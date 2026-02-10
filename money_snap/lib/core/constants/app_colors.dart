import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const primary = Color(0xFF2D5BFF);
  static const secondary = Color(0xFF00A86B);

  // Background
  static const background = Color(0xFFF8F9FB);
  static const surface = Color(0xFFFFFFFF);
  /// Light grey for empty cells / placeholders (e.g. grey.shade100/200).
  static const surfaceVariant = Color(0xFFEEEEEE);

  // Text
  static const textPrimary = Color(0xFF1C1C1C);
  static const textSecondary = Color(0xFF6B6B6B);
  static const textLight = Color(0xFFFFFFFF);
  /// Muted text on dark background (e.g. white70).
  static const textLightMuted = Color(0xB3FFFFFF);
  /// Dimmed text on dark background (e.g. white54).
  static const textLightDimmed = Color(0x8AFFFFFF);

  // Expense
  static const expense = Color(0xFFE53935);
  static const income = Color(0xFF2E7D32);

  // Border / Divider
  static const border = Color(0xFFE0E0E0);

  // Overlay
  static const overlayDark = Color(0x66000000);
  /// Very light overlay (e.g. shadow 4% black).
  static const overlayLight = Color(0x0A000000);
  /// Medium overlay (~25% black) for gradients.
  static const overlayMedium = Color(0x40000000);
  /// Strong overlay (~35% black) for gradients.
  static const overlayStrong = Color(0x59000000);

  // Utility
  static const transparent = Color(0x00000000);

  /// Light primary tint for today/highlighted calendar cell.
  static const todayHighlight = Color(0x1F2D5BFF);
}
