import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../models/post.dart';
import '../../../repository/post_repository.dart';
import '../views/new_post_view.dart';
import 'new_post_view_model.dart';

part 'post_view_model.g.dart';

class PostViewModel = PostViewModelBase with _$PostViewModel;

abstract class PostViewModelBase with Store {
  PostViewModelBase(this._repository) {
    loadPosts();
  }

  final PostRepository _repository;

  @observable
  ObservableList<Post> posts = ObservableList<Post>.of(<Post>[]);

  @action
  Future<void> loadPosts({BuildContext? context}) async {
    try {
      posts = (await _repository.getAll()).asObservable();
    } catch (e, stackTrace) {
      log(e.toString(),
          name: 'PostViewModel.loadPosts', stackTrace: stackTrace);
      if (context != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> openNewPostBottomSheet(
    BuildContext context,
    PostViewModel postViewModel,
  ) async {
    try {
      final post = await showModalBottomSheet<Post>(
        context: context,
        builder: (context) {
          return NewPostPage(newPostViewModel: NewPostViewModel(_repository));
        },
        backgroundColor: Colors.black54,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
      );
      if (post != null) {
        await loadPosts();
      }
    } catch (e, stackTrace) {
      log(e.toString(), name: 'openNewPostBottomSheet', stackTrace: stackTrace);
    }
  }
}
