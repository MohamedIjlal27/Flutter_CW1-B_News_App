import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String userId;
  final String username;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  factory Comment.fromMap(Map<String, dynamic> data, String id) {
    return Comment(
      id: id,
      userId: data['userId'],
      username: data['username'],
      text: data['text'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
