import 'package:flutter/material.dart';
import 'package:mobile_application_development_cw1b/models/news_model.dart';
import 'package:mobile_application_development_cw1b/screens/news_details_screen.dart';

class TopHeadlineCard extends StatelessWidget {
  final News news;

  const TopHeadlineCard({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailScreen(news: news),
            ),
          );
        },
        child: Container(
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  news.urlToImage,
                  fit: BoxFit.cover,
                  height: 100,
                  width: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(height: 100, color: Colors.grey);
                  },
                ),
              ),
              const SizedBox(height: 5),
              Text(
                news.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
