import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_mobx_template/models/post.dart';
import 'package:flutter_mobx_template/repository/post_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../fixtures/fixture.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late PostRepository repository;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    dio.httpClientAdapter = dioAdapter;
    repository = PostRepository(dio);
  });

  test('shold return a list of posts', () async {
    final payload = fixture('post_items.json') as List<dynamic>;
    dioAdapter.onGet(
      '/posts',
      (request) => request.reply(HttpStatus.ok, payload),
      queryParameters: <String, dynamic>{
        '_sort': 'id',
        '_order': 'desc',
      },
    );

    final result = await repository.getAll();
    expect(result, isA<List<Post>>());
    expect(result.length, payload.length);
  });

  test('should return add new post and return post with id', () async {
    const id = 1;
    final text = Faker().randomGenerator.string(50, min: 10);
    final creationDate = Faker().date.dateTime().toString();
    final data = <String, dynamic>{
      'id': id,
      'text': text,
      'creation-date': creationDate,
    };
    dioAdapter.onPost(
      '/posts',
      (request) => request.reply(HttpStatus.ok, data),
      data: data,
    );

    final result = await repository.add(text: text, creationDate: creationDate);
    expect(result, isA<Post>());
    expect(result.text, text);
    expect(result.creationDate, creationDate);
    expect(result.id, id);
  });

  test('should return updated post content', () async {
    const id = 1;
    final text = Faker().randomGenerator.string(50, min: 10);
    final creationDate = Faker().date.dateTime().toString();
    final data = <String, dynamic>{
      'id': id,
      'text': text,
      'creation-date': creationDate,
    };
    final post = Post.fromJson(data);
    post.text = Faker().randomGenerator.string(100, min: 51);

    dioAdapter.onPut(
      '/posts/$id',
      (request) => request.reply(HttpStatus.ok, post.toJson()),
      data: post.toJson(),
    );

    final result = await repository.edit(post);
    expect(result, isA<Post>());
    expect(result.text, post.text);
    expect(result.creationDate, post.creationDate);
    expect(result.id, post.id);
  });

  test('shouldn return true when delete one post', () async {
    const id = 1;
    dioAdapter.onDelete(
      '/posts/$id',
      (request) => request.reply(HttpStatus.ok, <String, dynamic>{}),
    );

    final result = await repository.delete(1);
    expect(result, true);
  });
}
