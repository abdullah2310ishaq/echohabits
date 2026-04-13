import 'package:flutter/material.dart';

/// Centralized design tokens for app colors.
///
/// Note: The rest of the app currently uses raw `Color(...)` in places.
/// New UI should prefer these tokens for consistency.
abstract final class AppColors {
  static const background = Color(0xFFF1F4F3);
  static const surface = Color(0xFFFFFFFF);

  static const primaryGreen = Color(0xFF2E7D32);
  static const deepGreen = Color(0xFF2D6A2E);
  static const lightGreenTint = Color(0xFFE8F5E9);

  static const accentBlue = Color(0xFF2F80ED);

  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textOnDark = Color(0xFFFFFFFF);

  static const shadow = Color(0x14000000); // 8% black
}
