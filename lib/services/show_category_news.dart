import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:top_news/model/show_category.dart';

class ShowCategoryNews {
  List<ShowCategory> showCategory = [];

  Future<void> getCategoryNews(String category) async {
    try {
      final url = Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=2cfe35a2df4e4dc985616a409546e0bf');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['articles'] != null) {
          // Clear existing articles to avoid duplication.
          showCategory.clear();

          for (var element in jsonData['articles']) {
            // Safeguard against missing data.
            if (element['urlToImage'] != null &&
                element['title'] != null &&
                element['description'] != null &&
                element['author'] != null &&
                element['url'] != null &&
                element['publishedAt'] != null) {
              showCategory.add(ShowCategory(
                urlToImage: element['urlToImage'],
                title: element['title'],
                description: element['description'],
                author: element['author'],
                url: element['url'],
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
