/*Flutter Documentation (Google), (2024) provider. 
Available at: https://pub.dev/packages/provider
(Accessed: 28 November 2024).
*/

import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../service/api_service.dart';

class NewsProvider with ChangeNotifier {
  List<News> _topHeadlines = [];
  List<News> _latestNews = [];
  bool _isLoading = false;

  List<News> get topHeadlines => _topHeadlines;
  List<News> get latestNews => _latestNews;
  bool get isLoading => _isLoading;

  Future<void> fetchNews() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<News> allNews = await ApiService().fetchTopHeadlines();
      _topHeadlines = allNews.take(5).toList();
      _latestNews = allNews.skip(5).toList();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
