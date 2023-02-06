import 'package:flutter/material.dart';

import '../../helpers/app_constants.dart';

class ScreenInitError extends StatelessWidget {
  final VoidCallback onTryAgain;
  final bool allowRetry;

  const ScreenInitError({
    super.key,
    required this.allowRetry,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(DavidGrunheidt): Use CustomXXX theme and widget classes
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              genericExceptionMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            if (allowRetry)
              InkWell(
                onTap: onTryAgain,
                child: const Text('Try again'),
              )
            else
              Text(
                'Try again later',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              )
          ],
        ),
      ),
    );
  }
}
