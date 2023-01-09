import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/posts/view_model/post_view_model.dart';
import '../modules/posts/views/post_view.dart';
import '../repository/post_repository.dart';
import 'route_names.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  RouteNames.posts: (context) => PostView(
        postViewModel: PostViewModel(
          Provider.of<PostRepository>(context, listen: false),
        ),
      ),
};
