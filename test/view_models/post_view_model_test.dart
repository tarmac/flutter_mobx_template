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

    test('should have initially empty post list', () async {
      mobx.ObservableList<Post> postsList() => mockPostRepository.postsList;
      when(postsList()).thenAnswer((_) => <Post>[].asObservable());

      expect(PostViewModel().postsList.isEmpty, true);

      verify(postsList());
      verifyNoMoreInteractions(mockPostRepository);
    });

    test('should load a list of posts', () async {
      final repoPosts = <Post>[Post(id: 1, text: 'text', creationDate: '')].asObservable();

      Future<void> loadAll() => mockPostRepository.loadAll();
      when(loadAll()).thenAnswer((_) async {});

      mobx.ObservableList<Post> postsList() => mockPostRepository.postsList;
      when(postsList()).thenAnswer((_) => repoPosts);

      final viewModel = PostViewModel();
      await viewModel.loadPosts();

      expect(viewModel.postsList.isNotEmpty, true);
      expect(viewModel.postsList.length, 1);
      expect(viewModel.postsList.first.id, repoPosts.first.id);

      verify(loadAll());
      verify(postsList()).called(3);
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
