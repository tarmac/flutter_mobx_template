import '../helpers/dependencies/service_locator.dart';
import '../models/post.dart';
import 'api_client/base_api_client.dart';

abstract class PostService {
  Future<Post> add({required String text, required String creationDate});

  Future<void> delete(int id);

  Future<Post> edit(Post post);

  Future<List<Post>> getAll();
}

class PostServiceImpl implements PostService {
  static const accountPath = '/Account';

  final BaseApiClient _apiClient = serviceLocator<BaseApiClient>();

  @override
  Future<Post> add({required String text, required String creationDate}) async {
    final result = await _apiClient.post(
      '/posts',
      data: <String, dynamic>{'text': text, 'creation-date': creationDate},
    );

    return Post.fromJson(result.data ?? <String, dynamic>{});
  }

  @override
  Future<void> delete(int id) => _apiClient.delete('/posts/$id');

  @override
  Future<Post> edit(Post post) async {
    final result = await _apiClient.put('/posts/${post.id}', data: post.toJson());
    return Post.fromJson(result.data ?? <String, dynamic>{});
  }

  @override
  Future<List<Post>> getAll() async {
    final result = await _apiClient.get('/posts', queryParameters: <String, dynamic>{'_sort': 'id', '_order': 'desc'});
    final jsonList = result.data as List;
    return jsonList.map((el) => Post.fromJson(el as Map<String, dynamic>)).toList();
  }
}
