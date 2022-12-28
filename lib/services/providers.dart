import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../flavors.dart';
import '../repository/implementation/post_repository.dart';
import 'api.dart';

final List<SingleChildWidget> providers = <Provider<dynamic>>[
  Provider<Dio>(
    lazy: false,
    create: (BuildContext ctx) => Api(F.env.baseUrl).init(),
  ),
  Provider<PostRepository>(
    create: (BuildContext ctx) => PostRepository(ctx.read<Dio>()),
  ),
];
