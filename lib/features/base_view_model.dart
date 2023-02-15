import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'base_view_model.g.dart';

class BaseViewModel = _BaseViewModel with _$BaseViewModel;

abstract class _BaseViewModel with Store {
  @observable
  var loading = false;

  @observable
  var firstLoading = true;

  @observable
  var initFailed = false;

  @computed
  bool get maxRetriesReached => initRetryCounter > 5;

  @observable
  var initRetryCounter = 0;

  @computed
  bool get allowInitRetry => !maxRetriesReached;

  @action
  @nonVirtual
  Future<void> runInit() async {
    try {
      initFailed = false;
      await init();
      initRetryCounter = 0;
    } catch (exception, stackTrace) {
      // TODO send error to error reporting tool
      debugPrint('Error initilializing viewModel: ${exception.toString()}:\n$stackTrace');

      initFailed = true;
      initRetryCounter++;
    } finally {
      firstLoading = false;
      loading = false;
    }
  }

  @action
  @protected
  Future<void> init() async {}

  void dispose() {}
}
