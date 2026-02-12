import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import 'expandable_image_badge.dart';

/// Rounded thumbnail for receipt/expense image with optional +N badge.
class ExpenseThumbnail extends StatelessWidget {
  const ExpenseThumbnail({
    super.key,
    required this.imagePath,
    this.extraCount = 0,
    this.borderRadius = AppSpacing.radiusXs,
    this.showBadge = true,
  });

  final String? imagePath;
  /// Number of additional items to show as "+N" badge (e.g. 2 for "+2").
  final int extraCount;
  final double borderRadius;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 28),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.overlayLight,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: hasImage
                ? Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                    // Thumbnails are typically small, use appropriate cache size
                    cacheWidth: 200,
                    cacheHeight: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.receipt_long,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  )
                : Center(
                    child: Icon(
                      Icons.receipt_long,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
        ),
        if (showBadge && extraCount > 0)
          Positioned(
            top: -2,
            right: -2,
            child: ExpandableImageBadge(count: extraCount),
          ),
      ],
    );
  }
}
