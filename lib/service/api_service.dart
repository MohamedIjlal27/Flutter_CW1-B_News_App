/*News API – search news and blog articles on the web (no date) News API â Search News and Blog Articles on the Web. Available at: https://newsapi.org/
(Accessed: 02 December 2024). 
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class ApiService {
  final String _baseUrl = 'https://newsapi.org/v2';
  final String _apiKey = '93fd452af5a04e9ca56482f4dd764c9d';

  Future<List<News>> fetchTopHeadlines() async {
    final url = Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List articles = json.decode(response.body)['articles'];
      return articles.map((article) => News.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<News>> fetchLatestNews() async {
    final url = Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List articles = json.decode(response.body)['articles'];
      return articles.map((article) => News.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<News>> fetchNewsByKeyword(String keyword,
      {String? apiKey, bool useHeader = false}) async {
    final url = Uri.parse('$_baseUrl/everything?q=$keyword');
    final response = await http.get(
      url,
      headers: useHeader
          ? {'93fd452af5a04e9ca56482f4dd764c9d': apiKey ?? _apiKey}
          : {'Authorization': apiKey ?? _apiKey},
    );

    if (response.statusCode == 200) {
      final List articles = json.decode(response.body)['articles'];
      return articles.map((article) => News.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
