import 'package:dio/dio.dart';
import '../models/post.dart';

class PostRepository {
  PostRepository(this._dio);

  final Dio _dio;

  Future<Post> add({
    required String text,
    required String creationDate,
  }) async {
    try {
      final result = await _dio.post(
        '/posts',
        data: <String, dynamic>{
          'text': text,
          'creation-date': creationDate,
        },
      );
      return Post.fromJson(result.data ?? <String, dynamic>{});
    } catch (e, stackTrace) {
      return Future<Post>.error(e, stackTrace);
    }
  }

  Future<bool> delete(int id) async {
    try {
      await _dio.delete<dynamic>('/posts/$id');
      return true;
    } catch (e, stackTrace) {
      return Future<bool>.error(e, stackTrace);
    }
  }

  Future<Post> edit(Post post) async {
    try {
      final result =
          await _dio.put('/posts/${post.id}', data: post.toJson());
      return Post.fromJson(result.data ?? <String, dynamic>{});
    } catch (e, stackTrace) {
      return Future<Post>.error(e, stackTrace);
    }
  }

  Future<List<Post>> getAll() async {
    try {
      final result = await _dio.get(
        '/posts',
        queryParameters: <String, dynamic>{
          '_sort': 'id',
          '_order': 'desc',
        },
      );
      return List<Map<String, dynamic>>.from(result.data ?? <dynamic>[])
          .map(Post.fromJson)
          .toList();
    } catch (e, stackTrace) {
      return Future<List<Post>>.error(e, stackTrace);
    }
  }
}
