class Article {
  String urlToImage;

  String title;

  String description;

  String author;

  String url;

  String publishedAt;

  Article({
    required this.urlToImage,
    required this.title,
    required this.description,
    required this.author,
    required this.url,
    required this.publishedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'urlToImage': urlToImage,
      'title': title,
      'description': description,
      'author': author,
      'url': url,
      'publishedAt': publishedAt,
    };
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      urlToImage: json['urlToImage'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      url: json['url'],
      publishedAt: json['publishedAt'],
    );
  }
}
