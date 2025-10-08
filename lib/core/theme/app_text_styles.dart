import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppTextStyles {
  // Headings
  static TextStyle get heading1 => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppTheme.textPrimary,
        height: 1.2,
      );

  static TextStyle get heading1Web => const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppTheme.textPrimary,
        height: 1.2,
      );

  static TextStyle get heading2 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
        height: 1.3,
      );

  static TextStyle get heading2Web => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
        height: 1.3,
      );

  static TextStyle get heading3 => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
        height: 1.3,
      );

  static TextStyle get heading3Web => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
        height: 1.3,
      );

  static TextStyle get heading4 => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
        height: 1.4,
      );

  static TextStyle get heading4Web => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
        height: 1.4,
      );

  // Body Text
  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyLargeWeb => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMediumWeb => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppTheme.textSecondary,
        height: 1.4,
      );

  static TextStyle get bodySmallWeb => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppTheme.textSecondary,
        height: 1.4,
      );

  // Special Text Styles
  static TextStyle get caption => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppTheme.textSecondary,
        height: 1.3,
      );

  static TextStyle get captionWeb => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppTheme.textSecondary,
        height: 1.3,
      );

  static TextStyle get buttonText => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get buttonTextWeb => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  // Display Text (for large numbers, scores, etc.)
  static TextStyle get displayLarge => const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: AppTheme.textPrimary,
        height: 1.1,
      );

  static TextStyle get displayLargeWeb => const TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.w900,
        color: AppTheme.textPrimary,
        height: 1.1,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: AppTheme.textPrimary,
        height: 1.1,
      );

  static TextStyle get displayMediumWeb => const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: AppTheme.textPrimary,
        height: 1.1,
      );

  static TextStyle get displaySmall => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
        height: 1.2,
      );

  static TextStyle get displaySmallWeb => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
        height: 1.2,
      );

  // Stat Text (for numbers with labels)
  static TextStyle get statValue => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppTheme.primaryColor,
      );

  static TextStyle get statValueWeb => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppTheme.primaryColor,
      );

  static TextStyle get statLabel => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppTheme.textSecondary,
      );

  static TextStyle get statLabelWeb => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppTheme.textSecondary,
      );

  // Badge Text
  static TextStyle get badge => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.primaryColor,
      );

  static TextStyle get badgeWeb => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.primaryColor,
      );

  // Timer Text
  static TextStyle get timerLarge => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppTheme.primaryColor,
      );

  static TextStyle get timerLargeWeb => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppTheme.primaryColor,
      );

  // Question Text
  static TextStyle get questionText => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
        height: 1.4,
      );

  static TextStyle get questionTextWeb => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
        height: 1.4,
      );

  // Feedback Text
  static TextStyle get feedbackCorrect => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.correctColor,
      );

  static TextStyle get feedbackCorrectWeb => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.correctColor,
      );

  static TextStyle get feedbackIncorrect => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.incorrectColor,
      );

  static TextStyle get feedbackIncorrectWeb => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.incorrectColor,
      );

  // Helper method to get responsive text style
  static TextStyle getResponsive({
    required TextStyle mobile,
    required TextStyle web,
    required bool isWeb,
  }) {
    return isWeb ? web : mobile;
  }
}

