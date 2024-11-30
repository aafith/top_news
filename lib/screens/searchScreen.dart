import 'package:flutter/material.dart';
import 'package:top_news/model/article_model.dart';
import 'package:top_news/services/news_services.dart';
import 'package:top_news/screens/article_view_screen.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  final List<Article> _searchResults = [];
  List<Article> allArticles = [];
  List<String> searchHistory = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    try {
      News newsClass = News();
      await newsClass.getNews();

      if (newsClass.articles.isNotEmpty) {
        setState(() {
          allArticles = newsClass.articles;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          debugPrint('No News found.');
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      debugPrint('Error fetching news: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch news: $e')),
      );
    }
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        if (!searchHistory.contains(query)) {
          searchHistory.add(query);
        }

        _searchResults
          ..clear()
          ..addAll(
            allArticles.where((article) {
              final title = article.title.toLowerCase();
              return title.contains(query.toLowerCase());
            }),
          );
      });
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  void _clearSearchHistory() {
    setState(() {
      searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search News'),
        backgroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFE0000)),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      labelStyle: const TextStyle(color: Colors.black),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _performSearch(_searchController.text);
                        },
                      ),
                    ),
                    onSubmitted: _performSearch,
                  ),
                  const SizedBox(height: 16),
                  if (searchHistory.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Search History',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: _clearSearchHistory,
                              child: const Text(
                                'Clear All History',
                                style: TextStyle(color: Color(0xFFFE0000)),
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: searchHistory
                              .map((history) => Chip(
                                    label: Text(history),
                                    backgroundColor: Colors.white,
                                    onDeleted: () {
                                      setState(() {
                                        searchHistory.remove(history);
                                      });
                                    },
                                    deleteIcon: const Icon(Icons.close),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  Expanded(
                    child: _searchResults.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final article = _searchResults[index];
                              return ListTile(
                                leading: article.urlToImage.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          article.urlToImage,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Icons.image),
                                title: Text(
                                  article.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  article.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  final url = article.url;
                                  final title = article.title;
                                  final description = article.description;
                                  final imageUrl = article.urlToImage;
                                  final author = article.author;
                                  final publishedAt = article.publishedAt;

                                  if (url.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ArticleView(
                                            blogUrl: url,
                                            title: title,
                                            description: description,
                                            urlToImage: imageUrl,
                                            author: author,
                                            publishedAt: publishedAt),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'URL not available for this News.'),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      backgroundColor: Colors.white,
    );
  }
}
