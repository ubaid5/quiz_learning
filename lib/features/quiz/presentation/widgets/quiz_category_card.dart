import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/quiz_category.dart';

class QuizCategoryCard extends StatelessWidget {
  final QuizCategory category;
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
    final color = Color(int.parse(category.color));

    return Card(
      margin: EdgeInsets.only(bottom: isWeb ? 16 : 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isWeb ? 20 : 16),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: isWeb ? 70 : 60,
                height: isWeb ? 70 : 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    category.icon,
                    style: TextStyle(fontSize: isWeb ? 36 : 32),
                  ),
                ),
              ),

              SizedBox(width: isWeb ? 20 : 16),

              // Category Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Name
                    Text(
                      category.name,
                      style: isWeb
                          ? AppTextStyles.heading4Web
                          : AppTextStyles.heading4,
                    ),
                    SizedBox(height: isWeb ? 8 : 6),

                    // Difficulty Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppStrings.difficultyFormat(category.difficulty),
                        style: (isWeb
                                ? AppTextStyles.badgeWeb
                                : AppTextStyles.badge)
                            .copyWith(color: color),
                      ),
                    ),

                    SizedBox(height: isWeb ? 12 : 10),

                    // Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.progress,
                              style: isWeb
                                  ? AppTextStyles.bodySmallWeb
                                  : AppTextStyles.bodySmall,
                            ),
                            Text(
                              AppStrings.progressFormat(
                                category.completedQuizzes,
                                category.totalQuizzes,
                              ),
                              style: (isWeb
                                      ? AppTextStyles.bodySmallWeb
                                      : AppTextStyles.bodySmall)
                                  .copyWith(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: category.progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: isWeb ? 16 : 12),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: isWeb ? 24 : 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
