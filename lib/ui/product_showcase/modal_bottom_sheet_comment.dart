import 'dart:async';

import 'package:expandable_text/expandable_text.dart';
import 'package:fashion_app/models/product/product.dart';
import 'package:fashion_app/network/fire_base/fire_auth.dart';
import 'package:fashion_app/ui/product_showcase/product_showscase_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../models/comment/comment.dart';
import '../../models/user/user.dart';
import '../../network/fire_base/firestore.dart';
import '../../shared/const/images.dart';

class ModalBottomSheetComment extends StatefulWidget {
  const ModalBottomSheetComment({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ModalBottomSheetComment> createState() =>
      _ModalBottomSheetCommentState();
}

class _ModalBottomSheetCommentState extends State<ModalBottomSheetComment> {
  late Product product;
  final _productShowcasePageBloc = ProductShowcasePageBloc();
  bool _isKeyboardVisible = false;
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  double _keyboardHeight = 0.0;

  //get future and stream
  late Future<List<Comment>> _getCommentsStream;
  late Future<MyUser?> _getUserData;
  late Future<int> Function({required int commentID, required String productID})
      _getFavoriteCommentCount;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    _keyboardVisibilitySubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      _productShowcasePageBloc.handleKeyboardVisibility(visible);
    });

    //init future and stream
    _getUserData = FireStore().getUserData();
    _getFavoriteCommentCount = FireStore().getFavoriteCommentCount;
    _getCommentsStream = FireStore().getComments(product.id.toString());
  }

  @override
  void dispose() {
    _productShowcasePageBloc.dispose();
    _keyboardVisibilitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      // chọn bên ngoài để tắt bàn phím
      child: Container(
        constraints: const BoxConstraints(minHeight: 300, maxHeight: 550),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Comments',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildListComments(product),
            ),
            //hiển thị BottomAppBar ngay trên bàn phím khi nó được bật
            _buildBottomAppBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return StreamBuilder<bool>(
        stream: _productShowcasePageBloc.isKeyboardVisibleStream,
        builder: (context, snapshot) {
          _isKeyboardVisible = snapshot.data ?? false;
          _keyboardHeight =
              _isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0;
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                      // offset : Điều chỉnh vị trí shadow theo chiều dọc và ngang
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Row(children: [
                    _buildUserAvatar(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          cursorColor: Colors.grey,
                          controller: _productShowcasePageBloc
                              .commentTextEditingController,
                          onChanged: (value) {
                            _productShowcasePageBloc.showIconSend();
                          },
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fillColor: Colors.grey,
                            hintText: 'Input comment',
                            hintStyle: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    //icon send xuất hiện khi người dùng nhập comment
                    StreamBuilder<bool>(
                        stream: _productShowcasePageBloc.isInputCommentStream,
                        builder: (context, snapshot) {
                          return _productShowcasePageBloc
                                  .commentTextEditingController.text.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _productShowcasePageBloc
                                          .sendComment(product);
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus(); // chọn bên ngoài để tắt bàn phím
                                    },
                                    child: const Icon(Icons.send),
                                  ),
                                )
                              : const SizedBox();
                        }),
                  ]),
                ),
              ),
              SizedBox(
                height: _keyboardHeight,
              ),
            ],
          );
        });
  }

  FutureBuilder<MyUser?> _buildUserAvatar() {
    return FutureBuilder<MyUser?>(
      future: _getUserData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          );
        } else {
          MyUser? user = snapshot.data;
          return user == null
              ? const SizedBox()
              : Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: ClipOval(
                    child: (user.photoURL == null || user.photoURL!.isEmpty)
                        ? Image.asset(
                            MyImages.circleUserAvatar,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            user.photoURL ?? '',
                            fit: BoxFit.cover,
                          ),
                  ),
                );
        }
      },
    );
  }

  Widget _buildListComments(Product product) {
    return StreamBuilder<bool?>(
        stream: _productShowcasePageBloc.deleteCommentStream,
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            _getCommentsStream = FireStore().getComments(product.id.toString());
            _productShowcasePageBloc.addDeleteCommentSinkToNull();
          }
          return FutureBuilder<List<Comment>>(
            future: _getCommentsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              } else if (snapshot.hasData) {
                List<Comment> listCommentsFromFirestore = snapshot.data ?? [];
                return StreamBuilder<Comment?>(
                    stream: _productShowcasePageBloc.sendCommentStream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        Comment commentSnapshot = snapshot.data!;
                        listCommentsFromFirestore.insert(0, commentSnapshot);
                        _productShowcasePageBloc.addSendCommentSinkToNull();
                      }
                      return listCommentsFromFirestore.isEmpty
                          ? _buildTextNoComment()
                          : _buildListViewComment(
                              listCommentsFromFirestore.toSet());
                    });
              } else {
                return _buildTextNoComment();
              }
            },
          );
        });
  }

  Widget _buildListViewComment(Set<Comment> comments) {
    return ListView.builder(
      controller: _productShowcasePageBloc.controllerListViewComments,
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        var comment = comments.elementAt(index);
        return _buildRowComment(comment);
      },
    );
  }

  Widget _buildRowComment(Comment comment) {
    return InkWell(
      onLongPress: () => showDialog(
        context: context,
        builder: (context) => _buildDialog(comment),
      ),
      splashColor: Colors.transparent, // Tắt hiệu ứng khi onTap
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //user avatar
            SizedBox(
              height: 50,
              width: 50,
              child: ClipOval(
                child: (comment.photoURL == null || comment.photoURL!.isEmpty)
                    ? Image.asset(
                        MyImages.circleUserAvatar,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        comment.photoURL!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.userName ?? '',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ExpandableText(
                    comment.content,
                    maxLines: 5,
                    expandText: 'more',
                    collapseText: 'collapse',
                    linkColor: Colors.grey,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: _buildRowDateAndFavourite(comment),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextNoComment() {
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No comment',
            style: TextStyle(fontSize: 20, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildRowDateAndFavourite(Comment comment) {
    DateTime time = comment.timestamp.toDate();
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${time.month}/${time.day}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Flexible(
            child: StreamBuilder<Object>(
                stream: _productShowcasePageBloc.isLikedCommentStream,
                builder: (context, snapshot) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFavouriteCommentButton(comment),
                      const SizedBox(
                        width: 6,
                      ),
                      _buildTextShowTextShowingNumberOfLikes(
                          productID: comment.productID,
                          commentID: comment.commentID,
                          future: _getFavoriteCommentCount,
                          size: 14,
                          color: Colors.grey),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget _buildFavouriteCommentButton(Comment comment) {
    return FutureBuilder<bool>(
        future: _productShowcasePageBloc.initStateForButtonLikeComment(comment),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isLiked = snapshot.data!;
            return GestureDetector(
              onTap: () async {
                await _productShowcasePageBloc.handleLikeComment(comment);
              },
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
              ),
            );
          }
          return const Icon(
            Icons.favorite_border,
            color: Colors.grey,
          );
        });
  }

  Widget _buildTextShowTextShowingNumberOfLikes(
      {required Future<int> Function(
              {required String productID, required int commentID})
          future,
      required double? size,
      required Color? color,
      required String productID,
      required int commentID}) {
    return FutureBuilder<int>(
      future: future(productID: productID, commentID: commentID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final favoriteCount = snapshot.data!;
          return Text(
            favoriteCount.toString(),
            style: TextStyle(fontSize: size, color: color),
          );
        } else {
          return Text(
            '0',
            style: TextStyle(fontSize: size, color: color),
          );
        }
      },
    );
  }

  _buildDialog(Comment comment) {
    String? currentUserID = Auth().currentUser?.uid;
    String userID = comment.userID;
    String productId = comment.productID;
    int commentId = comment.commentID;
    return Dialog(
      shape: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentUserID == userID) _buildItemDialog('Edit', () => null),
            if (currentUserID == userID)
              _buildItemDialog(
                  'Delete',
                  () => showDialog(
                        context: context,
                        builder: (context) => _buildAlertDialogDeleteComment(
                            productId, commentId),
                      ).then((value) => Navigator.of(context).pop())),
            _buildItemDialog('Report', () => null),
          ],
        ),
      ),
    );
  }

  _buildAlertDialogDeleteComment(String productId, int commentId) {
    return AlertDialog(
      shape: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      title: const Text(
        'Do you want to delete this comment?',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      actions: [
        TextButton(
          onPressed: () async => await _productShowcasePageBloc
              .deleteComment(productId, commentId)
              .then((value) => Navigator.of(context).pop()),
          child: const Text(
            'Yes',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'No',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        )
      ],
    );
  }

  _buildItemDialog(String text, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
