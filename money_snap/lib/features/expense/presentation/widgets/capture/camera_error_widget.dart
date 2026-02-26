import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../i18n/strings.g.dart';

/// Widget displayed when camera initialization fails or permission is denied.
class CameraErrorWidget extends StatelessWidget {
  const CameraErrorWidget({
    super.key,
    required this.errorKey,
    this.errorCode,
    required this.onRetry,
  });

  final String errorKey;
  final String? errorCode;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final message = switch (errorKey) {
      'no_camera' => t.errorsNoCamera,
      'permission' => t.errorsCameraPermission,
      'camera_error' => t.cameraError(code: errorCode ?? ''),
      _ => errorKey,
    };

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: () async {
                  await AppSettings.openAppSettings();
                },
                icon: const Icon(Icons.settings),
                label: Text(t.commonOpenSettings),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: onRetry,
                child: Text(t.commonRetry),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(t.commonClose),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
