// lib/app/theme/app_colors.dart

import 'package:flutter/material.dart';

/// A utility class that holds all the color constants for the app.
///
/// This class is designed with a private constructor to prevent it from
/// being instantiated. All colors should be accessed via static members.
/// Example: `AppColors.primaryDark`
class AppColors {
  // This class is not meant to be instantiated.
  const AppColors._();

  // --- PRIMARY COLORS ---
  /// The main background color for most screens.
  static const Color primaryDark = Color(0xFF395668);

  /// The background color for cards, modals, and other elevated surfaces.
  static const Color cardBackground = Color(0xFF2C3E50);

  // --- ACCENT COLORS ---
  /// Used for primary highlights, icons, and buttons.
  static const Color accentWhite = Colors.white;

  /// Used for prices, success indicators, and completed statuses.
  static const Color accentGreen = Color(0xFF4CAF50);

  /// Used for warnings and pending statuses.
  static const Color accentOrange = Colors.orange;

  static const Color accentBlue = Colors.blueAccent;

  /// Used for errors and canceled statuses.
  static const Color accentRed = Colors.redAccent;

  // --- TEXT COLORS ---
  /// The primary color for main text elements like titles.
  static const Color textWhite = Colors.white;

  /// The secondary color for subtitles, hints, and less important text.
  static const Color textWhite70 = Colors.white70;
}
