/*Flutter Documentation (Google), (2024) Widget catalog. 
Available at: https://flutter.dev/docs/ui/widgets 
(Accessed: 20 November 2024).
*/
import 'package:flutter/material.dart';
import 'package:mobile_application_development_cw1b/service/api_service.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';

class CategorisedNewsScreen extends StatelessWidget {
  final String category;

  const CategorisedNewsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text('$category News'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<News>>(
        future: apiService.fetchNewsByKeyword(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news found.'));
          } else {
            final newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return NewsCard(news: news);
              },
            );
          }
        },
      ),
    );
  }
}
