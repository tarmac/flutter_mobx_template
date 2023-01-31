import 'package:mobx/mobx.dart';

import '../../helpers/dependencies/repository_locator.dart';
import '../../models/post.dart';
import '../../repository/post_repository.dart';

part 'post_view_model.g.dart';

class PostViewModel = PostViewModelBase with _$PostViewModel;

// TODO(DavidGrunheidt): Add BaseViewModel extension with override to init method
abstract class PostViewModelBase with Store {
  final PostRepository _postRepository = repositoryLocator<PostRepository>();

  @computed
  List<Post> get postsList => _postRepository.postsList;

  @action
  Future<void> loadPosts() => _postRepository.loadAll();
}
