import 'package:flutter/material.dart';
import 'package:top_news/model/article_model.dart';
import 'package:top_news/services/article.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  final String blogUrl;
  final String title;
  final String description;
  final String urlToImage;
  final String author;
  final String publishedAt;

  const ArticleView({
    super.key,
    required this.blogUrl,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.author,
    required this.publishedAt,
  });

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late final WebViewController _controller;
  bool isFavorite = false;

  var saveArticles = SaveArticle();

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _checkIfArticleSaved();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.blogUrl));
  }

  Future<void> _checkIfArticleSaved() async {
    final isSaved = await saveArticles.isArticleSaved(
        widget.blogUrl); // Check if the article is in the database
    setState(() {
      isFavorite = isSaved;
    });
  }

  Future<void> saveArticle() async {
    try {
      final article = Article(
        url: widget.blogUrl,
        title: widget.title,
        description: widget.description,
        urlToImage: widget.urlToImage,
        author: widget.author,
        publishedAt: widget.publishedAt,
      );
      await saveArticles.saveArticle(article);
      setState(() {
        isFavorite = true;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to Bookmark')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to bookmark: $e')),
      );
    }
  }

  Future<void> deleteArticle() async {
    try {
      await saveArticles
          .deleteArticle(widget.blogUrl); // Remove article from database
      if (!mounted) return;
      setState(() {
        isFavorite = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleted to Bookmark')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Delete Bookmark: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Text(
                  'Top',
                  style: TextStyle(
                    color: Color(0xFFFE0000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 3),
                Text('News'),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.bookmark,
                    color: isFavorite ? const Color(0xFFFE0000) : Colors.grey,
                  ),
                  onPressed: () async {
                    if (isFavorite) {
                      await deleteArticle();
                    } else {
                      await saveArticle();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: WebViewWidget(controller: _controller),
      backgroundColor: Colors.white,
    );
  }
}
