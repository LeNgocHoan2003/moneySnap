import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import '../../../../../i18n/strings.g.dart';

/// Dialog shown when camera permission is denied or camera access fails.
class CameraPermissionDialog {
  /// Shows the permission dialog with options to open settings or cancel.
  static Future<void> show(BuildContext context) async {
    final t = context.t;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.cameraAccessNeeded),
        content: Text(t.cameraPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await AppSettings.openAppSettings();
            },
            child: Text(t.commonOpenSettings),
          ),
        ],
      ),
    );
  }
}
