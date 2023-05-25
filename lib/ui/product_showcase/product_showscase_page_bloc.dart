import 'dart:async';

import 'package:fashion_app/network/fire_base/fire_auth.dart';
import 'package:fashion_app/shared/fake_data/fake_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../base/bloc/bloc.dart';
import '../../models/comment/comment.dart';
import '../../models/product/product.dart';
import '../../network/fire_base/firestore.dart';

class ProductShowcasePageBloc extends Bloc {
  bool _isLikedComment = false;
  bool _isLikedProduct = false;
  final commentTextEditingController = TextEditingController();
  final ScrollController controllerListViewComments = ScrollController();

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
  final _sendCommentStreamController = StreamController<Comment?>.broadcast();
  final _deleteCommentStreamController = StreamController<bool?>.broadcast();

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

  Stream<Comment?> get sendCommentStream => _sendCommentStreamController.stream;

  Stream<bool?> get deleteCommentStream => _deleteCommentStreamController.stream;

  StreamSink get _isLikedProductSink => _isLikedProductStreamController.sink;

  StreamSink get _isTapCommentsProductSink =>
      _isTapCommentsProductStreamController.sink;

  StreamSink get _isLikedCommentSink => _isLikedCommentStreamController.sink;

  StreamSink get _isKeyboardVisibleSink =>
      _isKeyboardVisibleStreamController.sink;

  StreamSink get _isInputCommentSink => _isInputCommentStreamController.sink;

  StreamSink get _sendCommentSink => _sendCommentStreamController.sink;

  StreamSink get _deleteCommentSink => _deleteCommentStreamController.sink;

  void handleLikeProduct() {
    //update data number of likes
    _isLikedProduct = !_isLikedProduct;
    _isLikedProductSink.add(_isLikedProduct);
  }

  getNumberOfComments() {
    _isTapCommentsProductSink.add(true);
  }

  Future<void> sendComment(Product product) async {
    if (commentTextEditingController.text.isNotEmpty) {
      await FireStore().sendComment(
              product.id.toString(),
              commentTextEditingController
                  .text) /*.then((value) {
        _sendCommentSink.add(true);
        commentTextEditingController.clear();
        if (controllerListViewComments.positions.isNotEmpty) {
          controllerListViewComments.jumpTo(0);
        }
          },)*/
          ;
      await FireStore()
          .createAndGetComment(
              product.id.toString(), commentTextEditingController.text)
          .then((value) {
        _sendCommentSink.add(value);
        commentTextEditingController.clear();
        if (controllerListViewComments.positions.isNotEmpty) {
          controllerListViewComments.jumpTo(0);
        }
      });
    }
  }

  void handleKeyboardVisibility(bool isVisible) {
    _isKeyboardVisibleSink.add(isVisible);
  }

  void showIconSend() {
    _isInputCommentSink.add(true);
  }

  Future<bool> setStateForButtonLikeComment(Comment comment) async {
    String userID = Auth().currentUser?.uid ?? '';
    Set<String> setIDLikedComment = await FireStore().getSetLikedBy(
        productID: comment.productID, commentID: comment.commentID);
    return setIDLikedComment.contains(userID);
  }

  Future<void> handleLikeComment(Comment comment) async {
    String userID = Auth().currentUser?.uid ?? '';
    Set<String> setIDLikedComment = await FireStore().getSetLikedBy(
        productID: comment.productID, commentID: comment.commentID);
    setIDLikedComment.contains(userID)
        ? setIDLikedComment.remove(userID)
        : setIDLikedComment.add(userID);
    await FireStore()
        .updateLikedBy(comment.productID, comment.commentID, setIDLikedComment)
        .then(
      (value) {
        //update data number of comment
        _isLikedComment = !_isLikedComment;
        _isLikedCommentSink.add(_isLikedComment);
      },
    );
  }

  Future<void> deleteComment(String productId, int commentId) async {
    await FireStore().deleteComment(productId, commentId).then(
      (value) {
        _deleteCommentSink.add(true);
      },
    );
  }

  void addSendCommentSinkToNull() {
    _sendCommentSink.add(null);
  }

  void addDeleteCommentSinkToNull() {
    _deleteCommentSink.add(null);
  }

  @override
  void dispose() {
    commentTextEditingController.dispose();
    _isLikedProductStreamController.close();
    _isTapCommentsProductStreamController.close();
    _isKeyboardVisibleStreamController.close();
    _isLikedCommentStreamController.close();
    _isInputCommentStreamController.close();
    controllerListViewComments.dispose();
    super.dispose();
  }
}
