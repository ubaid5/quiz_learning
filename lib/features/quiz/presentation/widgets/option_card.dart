import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

class OptionCard extends StatelessWidget {
  final String option;
  final bool isSelected;
  final bool? isCorrect;
  final VoidCallback? onTap;
  final bool showFeedback;

  const OptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    this.isCorrect,
    this.onTap,
    this.showFeedback = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    Color borderColor = Colors.grey[300]!;
    Color backgroundColor = Colors.white;

    if (showFeedback) {
      if (isCorrect == true) {
        borderColor = AppTheme.correctColor;
        backgroundColor = AppTheme.correctColor.withOpacity(0.1);
      } else if (isCorrect == false) {
        borderColor = AppTheme.incorrectColor;
        backgroundColor = AppTheme.incorrectColor.withOpacity(0.1);
      }
    } else if (isSelected) {
      borderColor = AppTheme.primaryColor;
      backgroundColor = AppTheme.primaryColor.withOpacity(0.1);
    }

    return Card(
      margin: EdgeInsets.only(bottom: isWeb ? 16 : 12),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: showFeedback && isCorrect != null ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isWeb ? 20 : 16),
          child: Row(
            children: [
              // Selection Indicator
              Container(
                width: isWeb ? 28 : 24,
                height: isWeb ? 28 : 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                  color: isSelected || (showFeedback && isCorrect != null)
                      ? borderColor
                      : Colors.transparent,
                ),
                child: showFeedback && isCorrect != null
                    ? Icon(
                        isCorrect! ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: isWeb ? 18 : 16,
                      )
                    : (isSelected
                        ? Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: isWeb ? 14 : 12,
                          )
                        : null),
              ),

              SizedBox(width: isWeb ? 16 : 12),

              // Option Text
              Expanded(
                child: Text(
                  option,
                  style: isWeb
                      ? AppTextStyles.optionTextWeb
                      : AppTextStyles.optionText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
