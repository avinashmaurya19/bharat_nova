import 'dart:convert';

import 'package:dio/dio.dart';

import 'post_model.dart';

class FeedRepository {
  FeedRepository() : _dio = Dio();

  static const _baseUrl = 'https://dummyjson.com/posts';
  final Dio _dio;

  Future<List<Posts>> fetchPosts({
    required int page,
    required int limit,
  }) async {
    final skip = page * limit;
    final uri = '$_baseUrl?skip=$skip&limit=$limit';

    final response = await _dio.get<String>(
      uri,
      options: Options(
        headers: const {
          'Accept': 'application/json',
          'User-Agent': 'BharatNova/1.0 Flutter',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch posts');
    }

    final responseBody = response.data ?? '';
    if (responseBody.trimLeft().startsWith('<!DOCTYPE html>')) {
      throw Exception('Received HTML instead of JSON from API');
    }

    final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
    final postModel = PostModel.fromJson(decoded);
    return postModel.posts ?? <Posts>[];
  }
}
