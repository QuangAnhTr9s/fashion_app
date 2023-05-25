import 'package:flutter/material.dart';

import '../models/comment/comment.dart';

class FavouriteCommentButton extends StatefulWidget {
  final Future<bool> Function(Comment) setStateForButtonLikeComment;
  final Future<void> Function(Comment) handleLikeComment;
  final Comment comment;

  const FavouriteCommentButton({
    super.key,
    required this.setStateForButtonLikeComment,
    required this.handleLikeComment,
    required this.comment,
  });

  @override
  State<FavouriteCommentButton> createState() => _FavouriteCommentButtonState();
}

class _FavouriteCommentButtonState extends State<FavouriteCommentButton> {
  late Future<bool> _future;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _future = widget.setStateForButtonLikeComment(widget.comment);
    _future.then((value) {
      setState(() {
        isLiked = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Icon(
            Icons.favorite_border,
            color: Colors.grey,
          );
        } else {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () async {
                await widget.handleLikeComment(widget.comment);
                setState(() {
                  isLiked = !isLiked;
                });
              },
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
              ),
            );
          }
          return const SizedBox();
        }
      },
    );
  }
}
