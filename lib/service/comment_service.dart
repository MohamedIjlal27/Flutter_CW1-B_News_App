/*
Get started with Cloud Firestore  |  Firebase (no date a) Google. Available at: https://firebase.google.com/docs/firestore/quickstart (Accessed: 02 December 2024).  
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(
      String newsId, String text, String userId, String username) async {
    await _firestore.collection('comments').add({
      'newsId': newsId,
      'text': text,
      'userId': userId,
      'username': username,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateComment(String commentId, String newText) async {
    await _firestore.collection('comments').doc(commentId).update({
      'text': newText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteComment(String commentId) async {
    await _firestore.collection('comments').doc(commentId).delete();
  }

  Future<List<Comment>> getComments(String newsId) async {
    final snapshot = await _firestore
        .collection('comments')
        .where('newsId', isEqualTo: newsId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Comment.fromMap(doc.data(), doc.id))
        .toList();
  }
}
