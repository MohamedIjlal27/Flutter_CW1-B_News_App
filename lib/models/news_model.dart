class News {
  final String id;
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}
