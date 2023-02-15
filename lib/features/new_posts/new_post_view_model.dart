import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../helpers/dependencies/repository_locator.dart';
import '../../models/post.dart';
import '../../repository/post_repository.dart';
import '../base_view_model.dart';

part 'new_post_view_model.g.dart';

class NewPostViewModel = _NewPostViewModel with _$NewPostViewModel;

abstract class _NewPostViewModel extends BaseViewModel with Store {
  final PostRepository _postRepository = repositoryLocator<PostRepository>();

  Future<Post> addNewPost(String text, String creationDate) {
    return _postRepository.add(text: text, creationDate: creationDate);
  }
}
