import 'package:flutter/material.dart';
import 'package:top_news/model/article_model.dart';
import 'package:top_news/screens/SearchScreen.dart';
import 'package:top_news/screens/savedArticlesScreen.dart';
import 'package:top_news/screens/article_view_screen.dart';
import 'package:top_news/services/news_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> articles = [];
  bool _loading = true;
  bool isSortedByLatest = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getNews(); // Fetch news when the widget initializes
  }

  Future<void> getNews() async {
    try {
      News newsClass = News();
      await newsClass.getNews();

      if (newsClass.articles.isNotEmpty) {
        setState(() {
          articles = newsClass.articles;
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
      debugPrint('Error fetching news: $e'); // Log the error for debugging
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch news: $e')),
        );
      }
    }
  }

  void _sortNews() {
    setState(() {
      isSortedByLatest = !isSortedByLatest;
      articles = List.from(articles.reversed);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 40,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Top',
                  style: TextStyle(
                    color: Color(0xFFFE0000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 3),
                const Text('News'),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Search()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedArticles(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFE0000)),
              ),
            )
          : articles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 50, color: Color(0xFFFE0000)),
                      const SizedBox(height: 10),
                      const Text(
                        'No News available.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: getNews,
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Color(0xFFFE0000)),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Explore News!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.filter_list),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading:
                                              const Icon(Icons.arrow_upward),
                                          title: const Text('Sort by newest'),
                                          onTap: () {
                                            if (!isSortedByLatest) {
                                              _sortNews();
                                            }
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading:
                                              const Icon(Icons.arrow_downward),
                                          title: const Text('Sort by oldest'),
                                          onTap: () {
                                            if (isSortedByLatest) {
                                              _sortNews();
                                            }
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return NewsTile(
                            url: article.url,
                            imageUrl: article.urlToImage,
                            title: article.title,
                            description: article.description,
                            author: article.author,
                            publishedAt: article.publishedAt,
                          );
                        },
                      ),
                    ],
                  ),
                ),
      backgroundColor: Colors.white,
    );
  }
}

class NewsTile extends StatelessWidget {
  final String imageUrl, title, description, author, url, publishedAt;

  const NewsTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.author,
    required this.url,
    required this.publishedAt,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
              content: Text('URL not available for this News.'),
            ),
          );
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 130,
                        width: 130,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 130,
                            width: 130,
                            color: Colors.grey,
                            child: const Icon(Icons.broken_image,
                                color: Colors.white),
                          );
                        },
                      )
                    : Container(
                        height: 130,
                        width: 130,
                        color: Colors.grey,
                        child: const Icon(Icons.image, color: Colors.white),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isNotEmpty ? title : "No Title Available",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description.isNotEmpty
                          ? description
                          : "No Description Available",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      author.isNotEmpty ? "By $author" : "Unknown Author",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFE0000),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
