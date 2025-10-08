import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class OptionCard extends StatelessWidget {
  final String option;
  final bool isSelected;
  final bool? isCorrect;
  final VoidCallback onTap;
  final bool showFeedback;

  const OptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    this.isCorrect,
    required this.onTap,
    this.showFeedback = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    Color getBorderColor() {
      if (showFeedback) {
        if (isCorrect == true) {
          return AppTheme.correctColor;
        } else if (isSelected && isCorrect == false) {
          return AppTheme.incorrectColor;
        }
      }
      return isSelected ? AppTheme.primaryColor : Colors.grey[300]!;
    }

    Color getBackgroundColor() {
      if (showFeedback) {
        if (isCorrect == true) {
          return AppTheme.correctColor.withOpacity(0.1);
        } else if (isSelected && isCorrect == false) {
          return AppTheme.incorrectColor.withOpacity(0.1);
        }
      }
      return isSelected 
          ? AppTheme.primaryColor.withOpacity(0.1) 
          : Colors.white;
    }

    return GestureDetector(
      onTap: showFeedback ? null : onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isWeb ? 16 : 12),
        padding: EdgeInsets.all(isWeb ? 20 : 16),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          border: Border.all(
            color: getBorderColor(),
            width: showFeedback && (isCorrect == true || (isSelected && isCorrect == false)) ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: isWeb ? 16 : 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            if (showFeedback && isCorrect == true)
              const Icon(
                Icons.check_circle,
                color: AppTheme.correctColor,
                size: 24,
              ),
            if (showFeedback && isSelected && isCorrect == false)
              const Icon(
                Icons.cancel,
                color: AppTheme.incorrectColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

