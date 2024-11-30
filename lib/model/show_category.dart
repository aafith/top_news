class ShowCategory {
  final String urlToImage;

  final String title;

  final String description;

  final String author;

  final String url;

  final String publishedAt;

  ShowCategory({
    required this.urlToImage,
    required this.title,
    required this.description,
    required this.author,
    required this.url,
    required this.publishedAt,
  });

  factory ShowCategory.fromJson(Map<String, dynamic> json) {
    return ShowCategory(
      urlToImage: json['urlToImage'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      url: json['url'],
      publishedAt: json['publishedAt'],
    );
  }
}
