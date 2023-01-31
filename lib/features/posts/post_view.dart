import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../design_system/widgets/refresh_list_adaptive.dart';
import '../../flavors.dart';
import '../../models/post.dart';
import '../new_posts/new_post_view.dart';
import 'post_view_model.dart';
import 'widgets/post_card_item.dart';

class PostView extends StatefulWidget {
  const PostView({
    super.key,
  });

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final PostViewModel _viewModel = PostViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appFlavor.appTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openNewPostBottomSheet(context),
          )
        ],
      ),
      body: Observer(
        builder: (_) {
          return RefreshListAdaptive(
            onRefresh: _viewModel.loadPosts,
            itemBuilder: (context, i) {
              final post = _viewModel.postsList[i];
              return PostCardItem(
                key: Key(post.id.toString()),
                id: post.id.toString(),
                text: post.text,
                createdAt: DateFormat.yMd().add_Hms().format(post.createdAtDatetime),
              );
            },
            itemCount: _viewModel.postsList.length,
          );
        },
      ),
    );
  }

  Future<void> openNewPostBottomSheet(BuildContext context) async {
    try {
      final post = await showModalBottomSheet<Post>(
        context: context,
        builder: (context) => const NewPostPage(),
        backgroundColor: Colors.black54,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
      );
      if (post != null) await _viewModel.loadPosts();
    } catch (e, stackTrace) {
      log(e.toString(), name: 'openNewPostBottomSheet', stackTrace: stackTrace);
    }
  }
}
