import 'package:flutter/material.dart';
import '../models/quiz_category_model.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_strings.dart';

class QuizCategoryCard extends StatelessWidget {
  final QuizCategoryModel category;
  final VoidCallback onTap;

  const QuizCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Card(
      margin: EdgeInsets.only(bottom: isWeb ? 16 : 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(isWeb ? 20 : 16),
          child: Row(
            children: [
              // Icon
              Container(
                width: isWeb ? 70 : 60,
                height: isWeb ? 70 : 60,
                decoration: BoxDecoration(
                  color: Color(int.parse(category.color)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    category.icon,
                    style: TextStyle(fontSize: isWeb ? 32 : 28),
                  ),
                ),
              ),
              SizedBox(width: isWeb ? 20 : 16),
              
              // Category Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: isWeb ? AppTextStyles.heading4Web : AppTextStyles.heading4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.difficultyFormat(category.difficulty),
                      style: isWeb ? AppTextStyles.bodySmallWeb : AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    
                    // Progress
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.progress,
                              style: isWeb ? AppTextStyles.captionWeb : AppTextStyles.caption,
                            ),
                            Text(
                              AppStrings.progressFormat(category.completedQuizzes, category.totalQuizzes),
                              style: (isWeb ? AppTextStyles.captionWeb : AppTextStyles.caption).copyWith(
                                color: Color(int.parse(category.color)),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: category.progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(int.parse(category.color)),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textSecondary,
                size: isWeb ? 20 : 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

