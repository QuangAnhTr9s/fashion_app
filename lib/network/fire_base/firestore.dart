import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/shared/fake_data/fake_product.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user/user.dart';

class FireStore {
  void addAllProductToFireStore() {
    final productsCollection =
        FirebaseFirestore.instance.collection('products');
    for (var product in FakeProduct.listProduct) {
      productsCollection.doc('product_${product.id}').set({
        'id': product.id,
        'favoriteCount': product.favoriteCount,
        'comments': product.comments ?? [],
      });
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
        final comments = List<String>.from(doc.get('comments') ?? '');
        // Cập nhật thuộc tính favoriteCount và comments cho sản phẩm
        FakeProduct.listProduct[productIndex].favoriteCount = favoriteCount;
        FakeProduct.listProduct[productIndex].comments = comments;
      }
    }
  }

  Future<void> incrementFavoriteCount(String iDProduct) async {
    try {
      final documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc('product_$iDProduct');
      await documentReference
          .update({'favoriteCount': FieldValue.increment(1)});
    } catch (e) {
      print('Error incrementing favorite count: $e');
    }
  }

  Future<void> addUserToFirestore(MyUser user) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.id);

    await userRef.set({
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'birthday': user.birthday,
      'phoneNumber': user.phoneNumber ?? '',
      'urlPhoto': user.photoURL ?? '',
      'email': user.email,
      'password': user.password,
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
      'urlPhoto': user.photoURL ?? '',
      'email': user.email,
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
          photoURL: data['urlPhoto'] ?? '',
          email: data['email'] ?? '',
          password: data['password'] ?? '',
        );
        return currentUser;
      }
    }
    return null;
  }

  Future<int> getMaxIDUser() async {
    // Lấy danh sách người dùng từ Firestore và sắp xếp theo ID giảm dần
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('id', descending: true)
        .get();

    int maxId = 0;
    if (usersSnapshot.docs.isNotEmpty) {
      maxId = usersSnapshot.docs.first.data()['id'] as int;
    }
    return maxId;
  }
}
