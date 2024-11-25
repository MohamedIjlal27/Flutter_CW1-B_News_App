import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String username;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.userId,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  factory Comment.fromMap(Map<String, dynamic> data) {
    return Comment(
      userId: data['userId'],
      username: data['username'],
      text: data['text'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
