import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/shared/fake_data/fake_product.dart';
import 'package:intl/intl.dart';

import '../../base/bloc/bloc.dart';
import '../../models/product/product.dart';

class ProductShowcasePageBloc extends Bloc {
  bool isLiked = false;

  //get ListFavorite from
  Set<Product> getListProducts() {
    Set<Product> setResult = {};
    List<Product> listSorted = List.from(FakeProduct.listProduct);
    listSorted.sort(
      (a, b) => b.favoriteCount.compareTo(a.favoriteCount),
    );
    for (var product in FakeProduct.listProduct) {
      DateTime now = DateTime.now();
      DateTime dateElement = DateFormat('dd/MM/yyyy').parse(product.date);
      Duration difference = now.difference(dateElement);
      int days = difference.inDays;
      if (days <= 60) setResult.add(product);
    }
    for (int i = 0; i < 20; i++) {
      if (listSorted.length > i) setResult.add(listSorted[i]);
    }
    List<Product> listShuffle = setResult.toList();
    listShuffle.shuffle();
    setResult = listShuffle.toSet();
    return setResult;
  }

  final _isLikedStreamController = StreamController<bool>.broadcast();

  Stream<bool> get isLikedStream => _isLikedStreamController.stream;

  StreamSink get _isLikedSink => _isLikedStreamController.sink;

  handleLike() {
    //update data number of likes
    isLiked = !isLiked;
    _isLikedSink.add(isLiked);
  }

  showComments() {}

  @override
  void dispose() {
    _isLikedStreamController.close();
    super.dispose();
  }

  Future<int> getFavoriteCount(int id) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc('product_$id')
        .get();
    final data = documentSnapshot.data();
    final favoriteCount = data?['favoriteCount'] ?? 0;
    return favoriteCount;
  }

/*getFavoriteCount(int id) {
    return FirebaseFirestore.instance
        .collection('products')
        .doc('product_$id')
        .snapshots();
  }*/
}
