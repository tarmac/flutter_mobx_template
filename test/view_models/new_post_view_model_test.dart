import 'package:flutter_mobx_template/features/new_posts/new_post_view_model.dart';
import 'package:flutter_mobx_template/features/posts/post_view_model.dart';
import 'package:flutter_mobx_template/models/post.dart';
import 'package:flutter_mobx_template/repository/post_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_view_model_test.mocks.dart';

@GenerateMocks([
  PostRepository,
])
void main() {
  group('PostViewModel', () {
    final mockPostRepository = MockPostRepository();
    final repositoryLocator = GetIt.instance;

    setUpAll(() async {
      repositoryLocator.registerSingleton<PostRepository>(mockPostRepository);
    });

    tearDown(() {
      reset(mockPostRepository);
    });

    tearDownAll(() async {
      await GetIt.instance.reset();
    });

    test('should add a new post', () async {
      final post = Post(id: 1, text: 'text', creationDate: '');

      Future<Post> addPost() => mockPostRepository.add(text: post.text, creationDate: post.creationDate);
      when(addPost()).thenAnswer((_) async => post);

      mobx.ObservableList<Post> postsList() => mockPostRepository.postsList;
      when(postsList()).thenAnswer((_) => <Post>[post].asObservable());

      final viewModel = NewPostViewModel();
      await viewModel.addNewPost(post.text, post.creationDate);

      verify(addPost());
      verifyNoMoreInteractions(mockPostRepository);
    });

    test('should return a Exception', () async {
      Future<void> loadAll() => mockPostRepository.loadAll();
      when(loadAll()).thenThrow(Exception('Fake error'));

      expect(PostViewModel().loadPosts, throwsException);
      verify(loadAll());
      verifyNoMoreInteractions(mockPostRepository);
    });
  });
}
