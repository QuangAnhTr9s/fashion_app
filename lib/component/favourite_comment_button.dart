import 'package:fashion_app/models/comment/comment.dart';
import 'package:fashion_app/network/fire_base/fire_auth.dart';
import 'package:fashion_app/network/fire_base/firestore.dart';
import 'package:flutter/material.dart';

class FavouriteCommentButton extends StatefulWidget {
  const FavouriteCommentButton({
    super.key,
    required this.comment,
    required this.colorWhenNotSelected,
    this.size,
    this.handleLike2,
  });

  final Comment comment;
  final Color colorWhenNotSelected;
  final double? size;
  final void Function()? handleLike2;

  @override
  State<FavouriteCommentButton> createState() => _FavouriteCommentButtonState();
}

class _FavouriteCommentButtonState extends State<FavouriteCommentButton> {
  bool _isLiked = false;
  Set<String> _listID = {};
  String _productID = '';
  String _commentID = '';
  String _userID = '';

  @override
  void initState() {
    super.initState();
    _productID = widget.comment.productID;
    _commentID = widget.comment.commentID;
    _userID = Auth().currentUser?.uid ?? '';
  }

  Future<void> handleLike() async {
    _listID.contains(_userID) ? _listID.remove(_userID) : _listID.add(_userID);
    await FireStore().updateLikedBy(_productID, _commentID, _listID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<String>>(
        future: FireStore()
            .getSetLikedBy(productID: _productID, commentId: _commentID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Icon(
              Icons.favorite_border,
              color: widget.colorWhenNotSelected,
              size: widget.size,
            );
          } else {
            _listID = snapshot.data ?? {};
            _isLiked = _listID.contains(_userID);
            return GestureDetector(
              onTap: () async {
                await handleLike().then((value) {
                  if (widget.handleLike2 != null) {
                    widget.handleLike2!();
                  }
                  setState(() {
                    // _isLiked = !_isLiked;
                  });
                });
              },
              child: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : widget.colorWhenNotSelected,
                size: widget.size,
              ),
            );
          }
        });
  }
}
