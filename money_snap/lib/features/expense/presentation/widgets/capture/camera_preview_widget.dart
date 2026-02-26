import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Widget that displays camera preview with gradient overlays and square frame.
class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({
    super.key,
    required this.controller,
    required this.squareSize,
  });

  final CameraController controller;
  final double squareSize;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final orientation = MediaQuery.orientationOf(context);
    // Use preview size for correct aspect ratio. On most devices previewSize is in
    // sensor (landscape) orientation; in portrait UI we need the inverse ratio
    // so the preview is not stretched.
    final previewSize = controller.value.previewSize;
    double aspectRatio;
    if (previewSize != null && previewSize.height > 0 && previewSize.width > 0) {
      final rawRatio = previewSize.width / previewSize.height;
      aspectRatio = orientation == Orientation.portrait
          ? previewSize.height / previewSize.width  // inverse for portrait
          : rawRatio;
    } else {
      final cr = controller.value.aspectRatio;
      aspectRatio = cr > 0 ? cr : 1.0;
      if (orientation == Orientation.portrait && aspectRatio > 1) {
        aspectRatio = 1 / aspectRatio;
      }
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera preview: fill area while keeping aspect ratio (no stretch)
        Positioned.fill(
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: aspectRatio,
                  height: 1,
                  child: CameraPreview(controller),
                ),
              ),
            ),
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
      ],
    );
  }
}
