import 'package:top_news/model/article_model.dart';
import 'package:top_news/services/repository.dart';

class SaveArticle {
  final Repository _repository = Repository();

  //Save Article
  Future<void> saveArticle(Article article) async {
    return await _repository.insertData('articles', article.toMap());
  }

  // Read All Save Article
  Future<List<Article>> readAllSavedArticles() async {
    final List<Map<String, dynamic>> articles =
        await _repository.readData('articles');
    return articles.map((e) => Article.fromJson(e)).toList();
  }

  // Delete Saved Article
  Future<void> deleteArticle(String url) async {
    return await _repository.deleteData('articles', url);
  }

  // Check if article is saved
  Future<bool> isArticleSaved(String url) async {
    final List<Map<String, dynamic>> articles =
        await _repository.readData('articles');
    return articles
        .any((element) => element['url'] != null && element['url'] == url);
  }
}
