import 'dart:async';

import 'package:fashion_app/shared/fake_data/fake_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../base/bloc/bloc.dart';
import '../../models/product/product.dart';
import '../../network/fire_base/firestore.dart';

class ProductShowcasePageBloc extends Bloc {
  bool _isLikedComment = false;
  bool _isLikedProduct = false;
  final commentTextEditingController = TextEditingController();

  //get ListFavorite from
  Set<Product> getListProducts() {
    Set<Product> setResult = {};
    List<Product> listSorted = List.from(FakeProduct.listProduct);
    listSorted.sort(
      (a, b) => b.favoriteCount.compareTo(a.favoriteCount),
    );
    //lấy danh sách những sản phẩm có ngày đăng < = 60
    for (var product in FakeProduct.listProduct) {
      DateTime now = DateTime.now();
      DateTime dateElement = DateFormat('dd/MM/yyyy').parse(product.date);
      Duration difference = now.difference(dateElement);
      int days = difference.inDays;
      if (days <= 60) setResult.add(product);
    }
    for (int i = 0; i < 20; i++) {
      //lấy 20 sản phẩm nhiều lượt thích nhất
      if (listSorted.length > i) setResult.add(listSorted[i]);
    }
    List<Product> listShuffle = setResult.toList();
    listShuffle.shuffle();
    setResult = listShuffle.toSet();
    return setResult;
  }

  final _isLikedProductStreamController = StreamController<bool>.broadcast();
  final _isTapCommentsProductStreamController =
      StreamController<bool>.broadcast();
  final _isLikedCommentStreamController = StreamController<bool>.broadcast();
  final _isKeyboardVisibleStreamController = StreamController<bool>.broadcast();
  final _isInputCommentStreamController = StreamController<bool>.broadcast();

  Stream<bool> get isLikedProductStream =>
      _isLikedProductStreamController.stream;

  Stream<bool> get isTapCommentsProductStream =>
      _isTapCommentsProductStreamController.stream;

  Stream<bool> get isLikedCommentStream =>
      _isLikedCommentStreamController.stream;

  Stream<bool> get isKeyboardVisibleStream =>
      _isKeyboardVisibleStreamController.stream;

  Stream<bool> get isInputCommentStream =>
      _isInputCommentStreamController.stream;

  StreamSink get _isLikedProductSink => _isLikedProductStreamController.sink;

  StreamSink get _isTapCommentsProductSink =>
      _isTapCommentsProductStreamController.sink;

  StreamSink get _isLikedCommentSink => _isLikedCommentStreamController.sink;

  StreamSink get _isKeyboardVisibleSink =>
      _isKeyboardVisibleStreamController.sink;

  StreamSink get _isInputCommentSink => _isInputCommentStreamController.sink;

  void handleLikeProduct() {
    //update data number of likes
    _isLikedProduct = !_isLikedProduct;
    _isLikedProductSink.add(_isLikedProduct);
  }

  void handleLikeComment() {
    //update data number of comment
    _isLikedComment = !_isLikedComment;
    _isLikedCommentSink.add(_isLikedComment);
  }

  getNumberOfComments() {
    _isTapCommentsProductSink.add(true);
  }

  Future<void> sendComment(Product product) async {
    if (commentTextEditingController.text.isNotEmpty) {
      await FireStore()
          .sendComments(
              product.id.toString(), commentTextEditingController.text)
          .then((value) => commentTextEditingController.clear());
    }
  }

  void handleKeyboardVisibility(bool isVisible) {
    _isKeyboardVisibleSink.add(isVisible);
  }

  void showIconSend() {
    _isInputCommentSink.add(true);
  }

  @override
  void dispose() {
    commentTextEditingController.dispose();
    _isLikedProductStreamController.close();
    _isTapCommentsProductStreamController.close();
    _isKeyboardVisibleStreamController.close();
    _isLikedCommentStreamController.close();
    _isInputCommentStreamController.close();
    super.dispose();
  }
}
