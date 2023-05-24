import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  int commentID;
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
    return 'Comment{commentID: $commentID, userName: $userName, content: $content}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          commentID == other.commentID &&
          productID == other.productID &&
          userID == other.userID;

  @override
  int get hashCode => commentID.hashCode ^ productID.hashCode ^ userID.hashCode;
}
