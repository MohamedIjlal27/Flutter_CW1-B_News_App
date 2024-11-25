import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(
      String newsId, String text, String userId, String username) async {
    print('User ID: $userId');
    print('Username: $username');
    await _firestore.collection('comments').add({
      'newsId': newsId,
      'text': text,
      'userId': userId,
      'username': username,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Comment>> getComments(String newsId) async {
    final snapshot = await _firestore
        .collection('comments')
        .where('newsId', isEqualTo: newsId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList();
  }
}
