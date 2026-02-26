import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import 'circle_button.dart';

/// Top bar for capture screen: close button and optional flash toggle.
class CaptureExpenseTopBar extends StatelessWidget {
  const CaptureExpenseTopBar({
    super.key,
    required this.onClose,
    this.showFlash = false,
    this.isFlashOn = false,
    this.onToggleFlash,
  });

  final VoidCallback onClose;
  final bool showFlash;
  final bool isFlashOn;
  final VoidCallback? onToggleFlash;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleButton(icon: Icons.close, onPressed: onClose),
            if (showFlash)
              CircleButton(
                icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
                onPressed: onToggleFlash,
              )
            else
              const SizedBox(width: 48, height: 48),
          ],
        ),
      ),
    );
  }
}
