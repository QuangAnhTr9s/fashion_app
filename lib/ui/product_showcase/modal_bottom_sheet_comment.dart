import 'dart:async';

import 'package:expandable_text/expandable_text.dart';
import 'package:fashion_app/models/product/product.dart';
import 'package:fashion_app/ui/product_showcase/product_showscase_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../component/favourite_comment_button.dart';
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

class _ModalBottomSheetCommentState extends State<ModalBottomSheetComment>
    with AutomaticKeepAliveClientMixin {
  late Product product;
  final _productShowcasePageBloc = ProductShowcasePageBloc();
  bool _isKeyboardVisible = false;
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  double _keyboardHeight = 0.0;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    _keyboardVisibilitySubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      _productShowcasePageBloc.handleKeyboardVisibility(visible);
    });
  }

  @override
  void dispose() {
    _productShowcasePageBloc.dispose();
    _keyboardVisibilitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('build bottom sheet');
    return Container(
      // constraints: const BoxConstraints(minHeight: 300, maxHeight: 550),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: _buildListComments(product),
            ),
          ),
          //hiển thị BottomAppBar ngay trên bàn phím khi nó được bật
          _buildBottomAppBar(),
        ],
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
                      offset: const Offset(0,
                          3), // Điều chỉnh vị trí shadow theo chiều dọc và ngang
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Row(children: [
                    _buildUserAvatar(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                vertical: 10, horizontal: 6),
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
                                    onTap: () => _productShowcasePageBloc
                                        .sendComment(product),
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
      future: FireStore().getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(
                  'Error in getUserData from Firestore: ${snapshot.error}'));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
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
                    child: user.photoURL?.isNotEmpty == true
                        ? Image.network(
                            user.photoURL ?? '',
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            MyImages.circleUserAvatar,
                            fit: BoxFit.cover,
                          ),
                  ),
                );
        }
      },
    );
  }

  Widget _buildListComments(Product product) {
    print('_buildListComments');
    return StreamBuilder<List<Comment>>(
      stream: FireStore().getCommentsStream(product.id.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error in getCommentsStream: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        } else if (snapshot.hasData) {
          List<Comment> comments = snapshot.data ?? [];
          if (comments.isEmpty) {
            return _buildTextNoComment();
          } else {
            print('có');
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                var comment = comments[index];
                String? userName = comment.userName;
                String? photoURL = comment.photoURL;
                String? content = comment.content;
                DateTime time = comment.timestamp.toDate();
                return _buildRowComment(
                    photoURL, userName, content, time, comment);
              },
            );
          }
        } else {
          return _buildTextNoComment();
        }
      },
    );
  }

  Row _buildRowComment(String? photoURL, String? userName, String content,
      DateTime time, Comment comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //user avatar
        SizedBox(
          height: 50,
          width: 50,
          child: ClipOval(
            child: photoURL == null
                ? Image.asset(
                    MyImages.circleUserAvatar,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    photoURL,
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
                userName ?? '',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              ExpandableText(
                content,
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
                child: _buildRowDateAndFavourite(time, comment),
              )
            ],
          ),
        )
      ],
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

  Widget _buildRowDateAndFavourite(DateTime time, Comment comment) {
    return SizedBox(
      height: 40,
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FavouriteCommentButton(
                    handleLike2: () {
                      _productShowcasePageBloc.handleLikeComment();
                    },
                    comment: comment,
                    colorWhenNotSelected: Colors.grey),
                const SizedBox(
                  width: 6,
                ),
                _buildTextShowTextShowingNumberOfLikes(
                    stream: _productShowcasePageBloc.isLikedCommentStream,
                    productID: comment.productID,
                    commentId: comment.commentID,
                    future: FireStore().getFavoriteCommentCount,
                    size: 14,
                    color: Colors.grey),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextShowTextShowingNumberOfLikes(
      {required Future<int> Function(
              {required String productID, required String commentId})
          future,
      required Stream<bool> stream,
      required double? size,
      required Color? color,
      required String productID,
      required String commentId}) {
    return StreamBuilder<bool>(
        stream: stream,
        builder: (context, snapshot) {
          return FutureBuilder<int>(
            future: future(productID: productID, commentId: commentId),
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
        });
  }

  @override
  bool get wantKeepAlive => true;
}
