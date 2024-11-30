import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:top_news/model/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class News {
  List<Article> articles = [];

  late DateTime now;
  late DateTime fromDate;
  late String fromDateString;

  News() {
    now = DateTime.now();
    fromDate = now.subtract(const Duration(hours: 24));
    fromDateString = DateFormat('yyyy-MM-dd').format(fromDate);
  }

  Future<void> getNews() async {
    try {
      final url = Uri.parse(
          'https://newsapi.org/v2/everything?q=apple&from=$fromDateString&to=$fromDateString&sortBy=popularity&apiKey=2cfe35a2df4e4dc985616a409546e0bf');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['articles'] != null) {
          // Clear existing articles to avoid duplication.
          articles.clear();

          for (var element in jsonData['articles']) {
            // Safeguard against missing data.
            if (element['urlToImage'] != null &&
                element['title'] != null &&
                element['description'] != null &&
                element['author'] != null &&
                element['url'] != null &&
                element['publishedAt'] != null) {
              articles.add(Article(
                urlToImage: element['urlToImage'],
                title: element['title'],
                description: element['description'],
                author: element['author'],
                url: element['url'], // Ensure you're capturing the article URL.
                publishedAt: element['publishedAt'],
              ));
            }
          }
        } else {
          debugPrint('No articles found in response.');
        }
      } else {
        debugPrint('Failed to fetch news: HTTP ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching news: $e');
    }
  }
}
