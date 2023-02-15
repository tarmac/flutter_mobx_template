import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';

import '../design_system/themes/custom_asset.dart';
import '../design_system/widgets/screen_init_error.dart';
import 'base_view_model.dart';

class BaseViewModelContainer extends StatefulWidget {
  final BaseViewModel viewModel;
  final Widget child;

  const BaseViewModelContainer({
    super.key,
    required this.viewModel,
    required this.child,
  });

  @override
  State<BaseViewModelContainer> createState() => _BaseViewModelContainerState();
}

class _BaseViewModelContainerState extends State<BaseViewModelContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.viewModel.runInit());
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  void closeKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

  Widget get loadingScreen => Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white30.withOpacity(0.7),
        ),
        alignment: Alignment.center,
        child: Center(
          child: Lottie.asset(CustomAsset.loadingAnimation.path),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return GestureDetector(
      onTap: () => closeKeyboard(context),
      child: Observer(
        builder: (context) {
          return Stack(
            children: [
              if (!viewModel.initFailed) widget.child,
              if (viewModel.initFailed)
                ScreenInitError(allowRetry: viewModel.allowInitRetry, onTryAgain: viewModel.runInit),
              if (viewModel.loading) loadingScreen,
            ],
          );
        },
      ),
    );
  }
}
