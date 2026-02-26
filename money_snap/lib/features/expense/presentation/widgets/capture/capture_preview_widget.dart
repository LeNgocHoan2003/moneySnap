import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../i18n/strings.g.dart';
import 'capture_sign_button.dart';

/// Widget displayed after capturing an image, showing the image and amount input form.
class CapturePreviewWidget extends StatelessWidget {
  const CapturePreviewWidget({
    super.key,
    required this.imagePath,
    required this.squareSize,
    required this.amountController,
    required this.isPositive,
    required this.onSignChanged,
  });

  final String imagePath;
  final double squareSize;
  final TextEditingController amountController;
  final bool isPositive;
  final ValueChanged<bool> onSignChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Dark background
        Positioned.fill(
          child: Container(color: AppColors.overlayStrong),
        ),
        // Center square with captured image
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                width: squareSize,
                height: squareSize,
                // Preview is larger, but still limit resolution for performance
                cacheWidth: 1200,
                cacheHeight: 1200,
              ),
            ),
          ),
        ),
        // Amount input form
        Positioned(
          left: 0,
          right: 0,
          bottom: 100,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.t.expenseAmountSpent.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      // Sign selector buttons
                      Row(
                        children: [
                          CaptureSignButton(
                            label: '+',
                            isSelected: isPositive,
                            onTap: () => onSignChanged(true),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          CaptureSignButton(
                            label: '-',
                            isSelected: !isPositive,
                            onTap: () => onSignChanged(false),
                          ),
                        ],
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Amount input field
                      Expanded(
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isPositive ? AppColors.income : AppColors.expense,
                              ),
                          decoration: InputDecoration(
                            hintText: context.t.expenseAmountHint,
                            hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.lg,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              borderSide: BorderSide(
                                color: isPositive ? AppColors.income : AppColors.expense,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              borderSide: BorderSide(
                                color: isPositive ? AppColors.income : AppColors.expense,
                                width: 2,
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
