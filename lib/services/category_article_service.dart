import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:ureport_ecaro/models/category.dart';
import 'package:ureport_ecaro/models/response_opinions.dart' as opinionsarray;
import '../models/story.dart' as storyFull;

class CategoryArticleService {
  Future<List<Result>?> getCategories(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final category =
            Category.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

        inspect(category.results);

        return category.results ?? [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<storyFull.StoryItem>> getRecentStories(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final stories = storyFull.Story.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        return stories.results ?? [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<opinionsarray.Question>> getRecentOpinions(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final opinions = opinionsarray.ResponseOpinions.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (opinions.results.length > 0)
        return opinions.results[0].questions;
      else
        return [];
    } else {
      return [];
    }
  }
}
