import 'package:get_it/get_it.dart';

import '../../repository/post_repository.dart';

GetIt repositoryLocator = GetIt.instance;

void setupRepositoryLocator() {
  repositoryLocator.registerLazySingleton(PostRepository.new);
}
