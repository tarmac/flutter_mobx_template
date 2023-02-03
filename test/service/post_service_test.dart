import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_mobx_template/models/post.dart';
import 'package:flutter_mobx_template/services/api_client/api_client.dart';
import 'package:flutter_mobx_template/services/api_client/base_api_client.dart';
import 'package:flutter_mobx_template/services/post_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fixtures/fixtures.dart';
import 'post_service_test.mocks.dart';

@GenerateMocks([
  ApiClient,
])
void main() {
  group('PostService', () {
    final mockApiClient = MockApiClient();
    final serviceLocator = GetIt.instance;

    const postsPath = '/posts';

    setUpAll(() {
      serviceLocator.registerSingleton<BaseApiClient>(mockApiClient);
    });

    tearDown(() {
      reset(mockApiClient);
    });

    tearDownAll(() async {
      await GetIt.instance.reset();
    });

    test('shold return a list of posts', () async {
      final payload = fixtureList('post_items.json');

      Future<Response> getPosts() => mockApiClient.get(postsPath, queryParameters: {'_sort': 'id', '_order': 'desc'});
      when(getPosts()).thenAnswer(
        (_) async => Response(statusCode: 200, requestOptions: RequestOptions(path: postsPath), data: payload),
      );

      final result = await PostServiceImpl().getAll();

      expect(result, isA<List<Post>>());
      expect(result.length, payload.length);

      verify(getPosts());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('should return add new post and return post with id', () async {
      const id = 1;
      final text = Faker().randomGenerator.string(50, min: 10);
      final creationDate = Faker().date.dateTime().toString();

      final reqData = {'text': text, 'creation-date': creationDate};
      final respData = Map<String, dynamic>.from(reqData)..addAll({'id': id});

      Future<Response> postPost() => mockApiClient.post(postsPath, data: reqData);
      when(postPost()).thenAnswer(
        (_) async => Response(statusCode: 200, requestOptions: RequestOptions(path: postsPath), data: respData),
      );

      final result = await PostServiceImpl().add(text: text, creationDate: creationDate);

      expect(result, isA<Post>());
      expect(result.text, text);
      expect(result.creationDate, creationDate);
      expect(result.id, id);

      verify(postPost());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('should return updated post content', () async {
      final post = Post(
        id: 1,
        text: Faker().randomGenerator.string(50, min: 10),
        creationDate: Faker().date.dateTime().toString(),
      );

      final urlPath = '$postsPath/${post.id}';
      Future<Response> putPost() => mockApiClient.put(urlPath, data: post.toJson());
      when(putPost()).thenAnswer(
        (_) async => Response(statusCode: 200, requestOptions: RequestOptions(path: urlPath), data: post.toJson()),
      );

      final result = await PostServiceImpl().edit(post);

      expect(result, isA<Post>());
      expect(result.text, post.text);
      expect(result.creationDate, post.creationDate);
      expect(result.id, post.id);

      verify(putPost());
      verifyNoMoreInteractions(mockApiClient);
    });

    test('should return normally when delete one post', () async {
      const id = 1;

      const urlPath = '/posts/$id';
      Future<Response> deletePost() => mockApiClient.delete(urlPath);
      when(deletePost()).thenAnswer(
        (_) async => Response(statusCode: 200, requestOptions: RequestOptions(path: urlPath)),
      );

      expect(() => PostServiceImpl().delete(1), returnsNormally);
      verify(deletePost());
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
