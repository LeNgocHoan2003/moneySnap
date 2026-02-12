import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Widget that displays camera preview with gradient overlays and square frame.
class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({
    super.key,
    required this.controller,
    required this.squareSize,
    this.showFlashOverlay = false,
  });

  final CameraController controller;
  final double squareSize;
  final bool showFlashOverlay;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera preview
        Positioned.fill(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ),
        // Top gradient overlay
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: size.height * 0.25,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.overlayStrong, AppColors.transparent],
              ),
            ),
          ),
        ),
        // Bottom gradient overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: size.height * 0.35,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.overlayStrong, AppColors.transparent],
              ),
            ),
          ),
        ),
        // Center square frame
        Center(
          child: Container(
            width: squareSize,
            height: squareSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.textLightMuted, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.overlayDark,
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
        // Flash overlay (white flash effect when capturing)
        if (showFlashOverlay)
          Positioned.fill(
            child: Container(color: AppColors.textLight),
          ),
      ],
    );
  }
}
