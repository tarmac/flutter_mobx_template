import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../design_system/widgets/refresh_list_adaptive.dart';
import '../../flavors.dart';
import 'post_view_model.dart';
import 'widgets/post_card_item.dart';

class PostView extends StatelessWidget {
  const PostView({
    Key? key,
    required this.postViewModel,
  }) : super(key: key);

  final PostViewModel postViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appFlavor!.appTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => postViewModel.openNewPostBottomSheet(context, postViewModel),
          )
        ],
      ),
      body: Observer(
        builder: (_) {
          return RefreshListAdaptive(
            onRefresh: () => postViewModel.loadPosts(context: context),
            itemBuilder: (context, i) {
              final post = postViewModel.posts[i];
              return PostCardItem(
                key: Key(post.id.toString()),
                id: post.id.toString(),
                text: post.text,
                createdAt: DateFormat.yMd().add_Hms().format(post.createdAtDatetime),
              );
            },
            itemCount: postViewModel.posts.length,
          );
        },
      ),
    );
  }
}
