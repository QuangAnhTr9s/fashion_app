import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/network/fire_base/fire_auth.dart';
import 'package:fashion_app/shared/fake_data/fake_product.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/comment/comment.dart';
import '../../models/product/product.dart';
import '../../models/user/user.dart';

class FireStore {
  void addAllProductToFireStore() {
    final productsCollection =
        FirebaseFirestore.instance.collection('products');
    for (var product in FakeProduct.listProduct) {
      Map<String, dynamic> productData = product.toJson();
      productsCollection.doc(product.id.toString()).set(productData);
    }
  }

  Future<void> deleteAllProductsFromFirestore() async {
    final productsCollection =
        FirebaseFirestore.instance.collection('products');
    final products = await productsCollection.get();
    for (var doc in products.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<Product>> getAllProducts() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
  }

  Future<void> getAllProductsFromFirestore() async {
    final productsCollection =
        FirebaseFirestore.instance.collection('products');
    final products = await productsCollection.get();
    // Lặp qua tất cả các sản phẩm trong collection 'products'
    for (var doc in products.docs) {
      final productId = doc.get('id');
      final productIndex = FakeProduct.listProduct.indexWhere(
          (p) => p.id == productId); // trả về -1 nếu như không tìm được
      // Nếu tìm thấy sản phẩm có id tương ứng trong FakeProduct().listProduct
      if (productIndex != -1) {
        final favoriteCount = doc.get('favoriteCount');
        /*    final commentsData = doc.get('comments');
        List<Comment> comments = [];
        // Kiểm tra nếu commentsData là một List<dynamic> hợp lệ
        if (commentsData is List<dynamic>) {
          comments = commentsData.map((commentData) {
            return Comment(
              userId: commentData['userId'],
              content: commentData['content'],
              timestamp: commentData['timestamp'],
            );
          }).toList();
        }*/
        // Cập nhật thuộc tính favoriteCount và comments cho sản phẩm
        FakeProduct.listProduct[productIndex].favoriteCount = favoriteCount;
        // FakeProduct.listProduct[productIndex].comments = comments;
      }
    }
  }

  Future<int> getFavoriteProductCount(int id) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc('$id')
        .get();
    final data = documentSnapshot.data();
    final favoriteCount = data?['favoriteCount'] ?? 0;
    return favoriteCount;
  }

  Future<void> incrementFavoriteCount(String iDProduct) async {
    try {
      final documentReference =
          FirebaseFirestore.instance.collection('products').doc(iDProduct);
      await documentReference
          .update({'favoriteCount': FieldValue.increment(1)});
    } catch (e) {
      print('Error incrementing favorite count: $e');
    }
  }

  Future<List<Product>> fetchProductsWithQueryBySearch(String query) async {
    final CollectionReference productsCollection =
        FirebaseFirestore.instance.collection('products');

    QuerySnapshot querySnapshot;
    if (query.isNotEmpty) {
      //tách ra rồi viết hoa chữ cái đầu tiên
      List<String> searchTerms = query.split(' ');
      List<String> capitalizedTerms = searchTerms
          .map((term) => '${term[0].toUpperCase()}${term.substring(1)}')
          .toList();
      String queryWithToUpperCase = capitalizedTerms.join(' ');
      print(queryWithToUpperCase);
      querySnapshot = await productsCollection
          .where("name", arrayContains: queryWithToUpperCase)
          // .where("name", isGreaterThanOrEqualTo: queryWithToUpperCase)
          // .orderBy("name", descending: false)
          .get();
      /* querySnapshot = await productsCollection
          .where('name',
              isGreaterThanOrEqualTo: query,
              isLessThan: query.substring(0, query.length - 1) +
                  String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
          .get();*/
      /*.where('name',
          arrayContains: query)
          .get();*/
      print('query ko rong');
    } else {
      querySnapshot = await productsCollection
          .orderBy('favoriteCount', descending: true)
          .get();
    }

    List<Product> products =
        querySnapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    return products;
  }

  //User
  Future<void> addUserToFirestore(MyUser user) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.id);

    await userRef.set({
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'birthday': user.birthday,
      'phoneNumber': user.phoneNumber ?? '',
      'photoURL': user.photoURL ?? '',
      'email': user.email,
      'password': user.password,
      'listFavoriteProductID': user.listFavoriteProductID ?? [],
    });
  }

  Future<void> saveGoogleUserDataToFirestore(User user) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      MyUser myUser = MyUser(
        id: user.uid,
        firstName: '',
        lastName: '',
        birthday: '',
        email: user.email ?? '',
        password: '',
        photoURL: user.photoURL ?? '',
        phoneNumber: '',
      );
      String fullName = user.displayName ?? '';
      List<String> nameParts = fullName.split(' ');
      if (nameParts.length > 1) {
        myUser.lastName = nameParts.last;
        nameParts.removeLast();
        myUser.firstName = nameParts.join(' ');
      } else {
        myUser.firstName = fullName;
      }
      await addUserToFirestore(myUser);
    }
  }

  //cập nhật thông tin người dùng
  Future<void> updateUserInFirestore(MyUser user) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.id);

    await userRef.update({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'birthday': user.birthday,
      'phoneNumber': user.phoneNumber ?? '',
      'photoURL': user.photoURL ?? '',
      'email': user.email,
      // 'listFavoriteProductID': user.listFavoriteProductID ?? [],
    });
  }

// Đăng nhập và lấy thông tin người dùng từ Firestore
  Future<MyUser?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        // Lấy dữ liệu từ snapshot
        Map<String, dynamic> data = snapshot.data()!;
        // Tạo một đối tượng MyUser từ dữ liệu
        MyUser currentUser = MyUser(
          id: data['id'] ?? '',
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          birthday: data['birthday'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          photoURL: data['photoURL'] ?? '',
          email: data['email'] ?? '',
          password: data['password'] ?? '',
          listFavoriteProductID:
              Set<String>.from(data['listFavoriteProductID'] ?? []),
        );
        return currentUser;
      }
    }
    return null;
  }

  //lấy danh sách yêu thích của user hiện tại
  Future<List<String>> getListFavoriteProductIDs() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        // Lấy dữ liệu từ snapshot
        Map<String, dynamic> data = snapshot.data()!;
        // Lấy danh sách favoriteProductIDs
        List<String>? favoriteProductIDs =
            List<String>.from(data['listFavoriteProductID'] ?? []);
        return favoriteProductIDs;
      }
    }
    return []; // Trả về danh sách rỗng nếu không có dữ liệu hoặc lỗi xảy ra
  }

  //cập nhật danh sách yêu thích của user hiện tại
  Future<void> updateFavoriteProductIDs(List<String> favoriteProductIDs) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference<Map<String, dynamic>> userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userRef.update({'listFavoriteProductID': favoriteProductIDs});
    }
  }

  Future<String?> getUserPhotoURLByID(String userID) async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    return usersSnapshot.data()!['photoURL'];
  }

  Future<String?> getUserNameByID(String userID) async {
    String firstName = '';
    String lastName = '';
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    firstName = usersSnapshot.data()!['firstName'];
    lastName = usersSnapshot.data()!['lastName'];
    return '$firstName $lastName';
  }

  //comment
  Future<Comment?> createAndGetComment(
      String productID, String commentContent) async {
    try {
      // Lấy tham chiếu đến tài liệu sản phẩm trong Firestore
      DocumentReference productRef =
          FirebaseFirestore.instance.collection('products').doc(productID);

      // Truy vấn để lấy giá trị lớn nhất của commentID trong collection "comments"
      QuerySnapshot commentsSnapshot = await productRef
          .collection('comments')
          .orderBy('commentID', descending: true)
          .get();

      int maxCommentID = 0;
      if (commentsSnapshot.docs.isNotEmpty) {
        maxCommentID = commentsSnapshot.docs.first['commentID'] as int;
      }
      //sau khi đã tạo comment này trên firestore rồi mới tạo ở đây nên để đồng nhất thì max sẽ không cộng thêm 1
      int commentID = maxCommentID;
      String userID = FirebaseAuth.instance.currentUser!.uid;
      String? userName = await getUserNameByID(userID);
      String? photoURL = await getUserPhotoURLByID(userID);
      // Tạo Comment
      Comment comment = Comment(
        commentID: commentID,
        productID: productID,
        userID: userID,
        userName: userName,
        content: commentContent,
        timestamp: Timestamp.fromDate(DateTime.now()),
        likedBy: {},
        photoURL: photoURL,
      );
      return comment;
    } catch (error) {
      print('Error in sending comment: $error');
    }
    return null;
  }

  Future<void> sendComment(String productId, String commentContent) async {
    try {
      // Lấy tham chiếu đến tài liệu sản phẩm trong Firestore
      DocumentReference productRef =
          FirebaseFirestore.instance.collection('products').doc(productId);

      // Truy vấn để lấy giá trị lớn nhất của commentID trong collection "comments"
      QuerySnapshot commentsSnapshot = await productRef
          .collection('comments')
          .orderBy('commentID', descending: true)
          .get();

      int maxCommentID = 0;
      if (commentsSnapshot.docs.isNotEmpty) {
        maxCommentID = commentsSnapshot.docs.first['commentID'] as int;
      }

      int commentID = maxCommentID + 1;
      String userID = FirebaseAuth.instance.currentUser!.uid;
      String? userName = await getUserNameByID(userID);
      String? photoURL = await getUserPhotoURLByID(userID);
      // Tạo một Map chứa thông tin bình luận
      Map<String, dynamic> commentData = {
        'commentID': commentID,
        'productId': productId,
        'userID': userID,
        'userName': userName,
        'content': commentContent,
        'timestamp': DateTime.now(),
        'likedBy': [],
        'photoURL': photoURL,
      };

      // Thêm bình luận vào collection "comments" của tài liệu sản phẩm
      CollectionReference commentsRef = productRef.collection('comments');
      await commentsRef.doc('$commentID').set(commentData);
    } catch (error) {
      print('Error in sending comment: $error');
    }
  }

  Future<List<Comment>> getComments(String productId) async {
    try {
      DocumentReference productRef =
          FirebaseFirestore.instance.collection('products').doc(productId);
      CollectionReference commentsRef = productRef.collection('comments');
      String currentUserID = Auth().currentUser?.uid ?? '';
      QuerySnapshot snapshot = await commentsRef.get();

      List<Comment> listUserComments = [];
      List<Comment> listOtherUsersComments = [];
      for (DocumentSnapshot commentDoc in snapshot.docs) {
        Map<String, dynamic>? commentData =
            commentDoc.data() as Map<String, dynamic>?;

        if (commentData != null) {
          String userID = commentData['userID'];
          String? userName = await getUserNameByID(userID);
          String? photoURL = await getUserPhotoURLByID(userID);

          Comment comment = Comment(
            commentID: commentData['commentID'],
            productID: productId,
            userID: userID,
            content: commentData['content'],
            timestamp: commentData['timestamp'],
            likedBy: Set<String>.from(commentData['likedBy'] ?? {}),
            userName: userName ?? '',
            photoURL: photoURL ?? '',
          );
          if (comment.userID == currentUserID) {
            listUserComments.add(comment);
          } else {
            listOtherUsersComments.add(comment);
          }
        }
      }
      listUserComments.sort(
          (a, b) => (b.likedBy?.length ?? 0).compareTo(a.likedBy?.length ?? 0));
      listOtherUsersComments.sort(
          (a, b) => (b.likedBy?.length ?? 0).compareTo(a.likedBy?.length ?? 0));
      //hiển thị comments của user trước
      return [...listUserComments, ...listOtherUsersComments];
    } catch (e) {
      print('Error getting comments: $e');
      return []; // Trả về một danh sách rỗng trong trường hợp xảy ra lỗi
    }
  }

  Future<int> getCommentProductCount(int productID) async {
    // Lấy tham chiếu đến tài liệu sản phẩm trong Firestore
    DocumentReference productRef = FirebaseFirestore.instance
        .collection('products')
        .doc(productID.toString());
    //lấy độ dài list comments trên firestore để làm id cho comment
    var commentsDoc = await productRef.collection('comments').get();
    int lenght = commentsDoc.docs.length;
    return lenght;
  }

  Future<Set<String>> getSetLikedBy(
      {required String productID, required int commentID}) async {
    CollectionReference commentsRef = FirebaseFirestore.instance
        .collection('products')
        .doc(productID)
        .collection('comments');
    DocumentSnapshot snapshot = await commentsRef.doc('$commentID').get();
    Set<String> setLikedBy = {};
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        setLikedBy = Set<String>.from(data['likedBy'] ?? {});
      }
    }
    return setLikedBy;
  }

  Future<void> updateLikedBy(
      String productID, int commentID, Set<String> newLikedBy) async {
    CollectionReference commentsRef = FirebaseFirestore.instance
        .collection('products')
        .doc(productID)
        .collection('comments');
    DocumentReference commentRef = commentsRef.doc('$commentID');
    await commentRef.update({
      'likedBy': newLikedBy,
    }).catchError((error) {
      print('Error updating likedBy: $error');
    });
  }

  Future<int> getFavoriteCommentCount(
      {required String productID, required int commentID}) async {
    Set<String> setLikeBy =
        await getSetLikedBy(productID: productID, commentID: commentID);
    return setLikeBy.length;
  }

  Future<void> deleteComment(String productID, int commentID) async {
    try {
      DocumentReference productRef =
          FirebaseFirestore.instance.collection('products').doc(productID);
      CollectionReference commentsRef = productRef.collection('comments');
      // Xóa bình luận dựa trên commentId
      await commentsRef.doc('$commentID').delete();
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }
}
