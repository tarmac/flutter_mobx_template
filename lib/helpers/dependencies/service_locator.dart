import 'package:get_it/get_it.dart';

import '../../services/api_client/api_client.dart';
import '../../services/api_client/base_api_client.dart';
import '../../services/post_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<BaseApiClient>(ApiClient.new);
  serviceLocator.registerLazySingleton<PostService>(PostServiceImpl.new);
}
