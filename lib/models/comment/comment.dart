import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String commentID;
  String productID;
  String userID;
  String? userName;
  String? photoURL;
  String content;
  Timestamp timestamp;
  Set<String>? likedBy;

  Comment({
    required this.commentID,
    required this.productID,
    required this.userID,
    required this.content,
    required this.timestamp,
    this.likedBy,
    this.userName,
    this.photoURL,
  });

  @override
  String toString() {
    return 'Comment{userId: $userID, content: $content, timestamp: $timestamp}';
  }
}
