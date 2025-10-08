import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/user.dart';

class UserHeaderWidget extends StatelessWidget {
  final User user;

  const UserHeaderWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Container(
      padding: EdgeInsets.all(isWeb ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // User Image
          CircleAvatar(
            radius: isWeb ? 28 : 24,
            backgroundColor: AppTheme.primaryColor,
            child: ClipOval(
              child: Image.network(
                user.imageUrl,
                width: (isWeb ? 28 : 24) * 2,
                height: (isWeb ? 28 : 24) * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to user initials if image fails to load
                  return Container(
                    color: AppTheme.primaryColor,
                    child: Center(
                      child: Text(
                        user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: isWeb ? 24 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: isWeb ? 16 : 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: isWeb
                      ? AppTextStyles.heading4Web
                      : AppTextStyles.heading4,
                ),
                SizedBox(height: isWeb ? 4 : 2),
                Text(
                  AppStrings.progressFormat(user.quizzesTaken, user.totalQuizzes),
                  style: isWeb
                      ? AppTextStyles.bodySmallWeb
                      : AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),

          // Progress Bar
          SizedBox(
            width: isWeb ? 120 : 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppStrings.percentageFormat((user.progress * 100).toInt()),
                  style: (isWeb
                          ? AppTextStyles.bodyMediumWeb
                          : AppTextStyles.bodyMedium)
                      .copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: user.progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
