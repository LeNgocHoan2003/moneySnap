import 'package:flutter/material.dart';

/// Color palette for Money Snap.
/// Light mode: minimal, Material 3 inspired.
/// Dark mode: premium fintech dark theme.
class AppColors {
  AppColors._();

  // Brand & Primary
  static const primary = Color(0xFF4F6BED);
  static const primaryContainer = Color(0xFFE8ECFF);

  // Background (light)
  static const background = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF5F5F5);

  // Text (light)
  static const textPrimary = Color(0xFF1C1C1C);
  static const textSecondary = Color(0xFF6B6B6B);
  static const textLight = Color(0xFFFFFFFF);
  static const textLightMuted = Color(0xB3FFFFFF);
  static const textLightDimmed = Color(0x8AFFFFFF);

  // Finance (shared)
  static const expense = Color(0xFFE57373);
  static const income = Color(0xFF66BB6A);

  // Border / Divider (light)
  static const border = Color(0xFFEEEEEE);

  // Overlay & Shadows
  static const overlayDark = Color(0x66000000);
  static const overlayLight = Color(0x0A000000);
  static const overlayMedium = Color(0x40000000);
  static const overlayStrong = Color(0x59000000);
  static const overlayImage = Color(0x4D000000); // ~30% for image overlay

  // Utility
  static const transparent = Color(0x00000000);

  // Calendar (light)
  static const todayHighlight = Color(0x154F6BED);

  // ----- Dark theme (premium fintech) -----
  static const darkBackground = Color(0xFF0F1115);
  static const darkSurface = Color(0xFF1A1D23);
  static const darkSurfaceElevated = Color(0xFF20242C);
  static const darkPrimary = Color(0xFF5B7CFA);
  static const darkIncome = Color(0xFF4CAF50);
  static const darkExpense = Color(0xFFEF5350);
  static const darkTextPrimary = Color(0xFFE6EAF2);
  static const darkTextSecondary = Color(0xFFA0A6B1);
  static const darkDivider = Color(0xFF2A2E36);
  static const darkTodayGlow = Color(0x335B7CFA);
}
