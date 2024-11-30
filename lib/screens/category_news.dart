import 'package:flutter/material.dart';
import 'package:top_news/model/show_category.dart';
import 'package:top_news/screens/article_view_screen.dart';
import 'package:top_news/services/show_category_news.dart';

class CategoryNews extends StatefulWidget {
  final String name;

  const CategoryNews({super.key, required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategory> categorys = [];
  bool _loading = true;
  final ScrollController _scrollController = ScrollController();

  getNews() async {
    try {
      ShowCategoryNews showCategoryNews = ShowCategoryNews();
      await showCategoryNews.getCategoryNews(widget.name.toLowerCase());
      setState(() {
        categorys = showCategoryNews.showCategory;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      debugPrint('Error fetching news: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getNews();
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
            Text(
              widget.name,
              style: const TextStyle(
                color: Color(0xFFFE0000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFE0000)),
              ),
            )
          : categorys.isEmpty
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categorys.length,
                        itemBuilder: (context, index) {
                          final category = categorys[index];
                          return ShowCategoryTile(
                            url: category.url,
                            imageUrl: category.urlToImage,
                            title: category.title,
                            description: category.description,
                            author: category.author,
                            publishedAt: category.publishedAt,
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

class ShowCategoryTile extends StatelessWidget {
  final String imageUrl, title, description, author, url, publishedAt;

  const ShowCategoryTile({
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: ClipRRect(
          child: GestureDetector(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(imageUrl),
                      )
                    : ClipRRect(
                        child: Container(
                          height: 200,
                          color: Colors.grey[200],
                        ),
                      ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'By $author',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFE0000),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
