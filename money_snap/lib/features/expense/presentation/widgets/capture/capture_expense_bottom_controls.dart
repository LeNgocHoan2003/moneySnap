import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../i18n/strings.g.dart';
import 'capture_button.dart';
import 'circle_button.dart';

/// Bottom controls for capture screen: camera mode (gallery, capture, switch) or preview mode (retry, save).
class CaptureExpenseBottomControls extends StatelessWidget {
  const CaptureExpenseBottomControls({
    super.key,
    required this.isPreviewMode,
    required this.saving,
    this.onRetry,
    this.onSave,
    this.onPickFromGallery,
    this.onTakePicture,
    this.onSwitchCamera,
    this.isCapturing = false,
    this.canSwitchCamera = true,
  });

  final bool isPreviewMode;
  final bool saving;
  final VoidCallback? onRetry;
  final VoidCallback? onSave;
  final VoidCallback? onPickFromGallery;
  final VoidCallback? onTakePicture;
  final VoidCallback? onSwitchCamera;
  final bool isCapturing;
  final bool canSwitchCamera;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom + AppSpacing.lg;

    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomPadding,
      child: isPreviewMode ? _buildPreviewControls(context) : _buildCameraControls(context),
    );
  }

  Widget _buildPreviewControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleButton(icon: Icons.refresh, onPressed: onRetry),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: FilledButton(
              onPressed: saving ? null : onSave,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7C7FEA),
                foregroundColor: AppColors.textLight,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                elevation: 0,
              ),
              child: saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textLight,
                      ),
                    )
                  : Text(
                      context.t.expenseSaveExpense,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleButton(icon: Icons.photo_library_outlined, onPressed: onPickFromGallery),
        CaptureButton(
          onPressed: isCapturing ? null : onTakePicture,
          isCapturing: isCapturing,
        ),
        CircleButton(
          icon: Icons.cameraswitch,
          onPressed: canSwitchCamera ? onSwitchCamera : null,
        ),
      ],
    );
  }
}
