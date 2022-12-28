import '../models/post.dart';

abstract class IPostRepository {
  Future<List<Post>> getAll();

  Future<Post> add({
    required String text,
    required String creationDate,
  });

  Future<Post> edit(Post post);

  Future<bool> delete(int id);
}
