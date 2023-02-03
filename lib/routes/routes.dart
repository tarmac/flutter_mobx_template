import 'package:flutter/material.dart';

import '../features/posts/post_view.dart';
import 'route_names.dart';

// TODO(DavidGrunheidt): Use AutoRouter fou automatic route creations
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  RouteNames.posts: (context) => const PostView(),
};
