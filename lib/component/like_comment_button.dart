import 'package:flutter/material.dart';

import '../models/comment/comment.dart';

class LikeCommentButton extends StatefulWidget {
  final Future<bool> Function(Comment) setStateForButtonLikeComment;
  final Future<void> Function(Comment) handleLikeComment;
  final Comment comment;

  const LikeCommentButton({
    super.key,
    required this.setStateForButtonLikeComment,
    required this.handleLikeComment,
    required this.comment,
  });

  @override
  State<LikeCommentButton> createState() => _LikeCommentButtonState();
}

class _LikeCommentButtonState extends State<LikeCommentButton> {
  late Future<bool> _future;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _future = widget.setStateForButtonLikeComment(widget.comment);
    _future.then((value) {
      if (mounted) {
        setState(() {
          isLiked = value;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: widget.setStateForButtonLikeComment(widget.comment),
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
                  _future = widget.setStateForButtonLikeComment(widget.comment);
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
