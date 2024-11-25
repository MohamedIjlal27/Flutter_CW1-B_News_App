import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../models/comment_model.dart'; // Import the Comment model
import '../service/comment_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class NewsDetailScreen extends StatefulWidget {
  final News news;

  const NewsDetailScreen({Key? key, required this.news}) : super(key: key);

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _isCommenting = false;
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      List<Comment> comments =
          await _commentService.getComments(widget.news.id);
      print('Fetched comments: ${comments.length}');
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  void _toggleCommentField() {
    setState(() {
      _isCommenting = !_isCommenting;
    });
  }

  void _addComment(String text) async {
    if (text.isNotEmpty) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String userId = userProvider.uid ?? '';
      String username = userProvider.username ?? '';

      await _commentService.addComment(widget.news.id, text, userId, username);
      _commentController.clear();
      _toggleCommentField();
      _fetchComments(); // Refresh comments after adding a new one
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news.title),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.news.urlToImage.isNotEmpty
                ? Image.network(widget.news.urlToImage, fit: BoxFit.cover)
                : Container(height: 150, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              widget.news.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.news.description,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Published on ${widget.news.publishedAt}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _toggleCommentField,
              child: Text(
                _isCommenting ? 'Cancel' : 'Add a Comment',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            if (_isCommenting)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Add a comment',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: _addComment,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_comment),
                    onPressed: () {
                      _addComment(_commentController.text);
                    },
                  ),
                ],
              ),
            const SizedBox(height: 20),
            // Display comments
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(comment.username.isNotEmpty
                          ? comment.username[0].toUpperCase()
                          : '?'),
                    ),
                    title: Text(comment.username),
                    subtitle: Text(comment.text),
                    trailing: Text(
                      '${comment.timestamp.hour}:${comment.timestamp.minute}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
