import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Circular button widget used in camera controls (close, flash, gallery, switch camera).
class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.overlayMedium,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(child: Icon(icon, color: AppColors.textLight)),
        ),
      ),
    );
  }
}
