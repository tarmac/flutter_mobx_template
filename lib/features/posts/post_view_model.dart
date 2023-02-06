import 'package:mobx/mobx.dart';

import '../../helpers/dependencies/repository_locator.dart';
import '../../models/post.dart';
import '../../repository/post_repository.dart';
import '../base_view_model.dart';

part 'post_view_model.g.dart';

class PostViewModel = _PostsViewModel with _$PostViewModel;

abstract class _PostsViewModel extends BaseViewModel with Store {
  final PostRepository _postRepository = repositoryLocator<PostRepository>();

  @computed
  List<Post> get postsList => _postRepository.postsList;

  @action
  @override
  Future<void> init() async {
    await loadPosts();
    return super.init();
  }

  @action
  Future<void> loadPosts() => _postRepository.loadAll();
}
