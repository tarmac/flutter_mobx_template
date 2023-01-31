import 'package:mobx/mobx.dart';

import '../helpers/dependencies/service_locator.dart';
import '../models/post.dart';
import '../services/post_service.dart';

part 'post_repository.g.dart';

class PostRepository = _PostRepository with _$PostRepository;

abstract class _PostRepository with Store {
  final _postService = serviceLocator<PostService>();

  final postsList = <Post>[].asObservable();

  @action
  Future<Post> add({required String text, required String creationDate}) async {
    final newPost = await _postService.add(text: text, creationDate: creationDate);
    postsList.add(newPost);
    return newPost;
  }

  @action
  Future<void> delete(int id) async {
    await _postService.delete(id);
    postsList.removeWhere((el) => el.id == id);
  }

  @action
  Future<void> edit(Post post) async {
    final updatedPost = await _postService.edit(post);
    final postIndex = postsList.indexWhere((el) => el.id == updatedPost.id);
    postsList[postIndex] = updatedPost;
  }

  @action
  Future<void> loadAll() async {
    final posts = await _postService.getAll();
    postsList.clear();
    postsList.addAll(posts);
  }
}
