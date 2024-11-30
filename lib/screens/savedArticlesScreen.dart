import 'package:flutter/material.dart';
import 'package:top_news/model/article_model.dart';
import 'package:top_news/screens/article_view_screen.dart';
import 'package:top_news/services/article.dart';

class SavedArticles extends StatefulWidget {
  const SavedArticles({super.key});

  @override
  State<SavedArticles> createState() => _SavedArticlesState();
}

class _SavedArticlesState extends State<SavedArticles> {
  final SaveArticle _saveArticle = SaveArticle();
  late Future<List<Article>> _savedArticlesFuture;

  @override
  void initState() {
    super.initState();
    _loadSavedArticles();
  }

  void _loadSavedArticles() {
    setState(() {
      _savedArticlesFuture = _saveArticle.readAllSavedArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks News"),
        backgroundColor: const Color(0xFFFFFFFF),
      ),
      body: FutureBuilder<List<Article>>(
        future: _savedArticlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Bookmarks found."));
          }

          final articles = snapshot.data!;

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];

              return Card(
                color: const Color(0xFFF6F6F6),
                margin: const EdgeInsets.all(10),
                elevation: 0,
                child: ListTile(
                  // ignore: unnecessary_null_comparison
                  leading: article.urlToImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            article.urlToImage,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(article.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFFFE0000)),
                    onPressed: () async {
                      // Show confirmation dialog before deleting
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete this bookmark?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Return false (cancel deletion)
                                },
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.black)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      true); // Return true (confirm deletion)
                                },
                                child: const Text('Delete',
                                    style: TextStyle(color: Color(0xFFFE0000))),
                              ),
                            ],
                          );
                        },
                      );

                      // If user confirmed, proceed with deleting the article
                      if (confirmDelete == true) {
                        await _saveArticle.deleteArticle(article.url);
                        _loadSavedArticles();
                      }
                    },
                  ),
                  onTap: () {
                    // Navigate to Article View
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleView(
                          blogUrl: article.url,
                          title: article.title,
                          description: article.description,
                          urlToImage: article.urlToImage,
                          author: article.author,
                          publishedAt: article.publishedAt,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      backgroundColor: const Color(0xFFFFFFFF),
    );
  }
}
