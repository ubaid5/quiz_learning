import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/theme/app_theme.dart';

class UserHeaderWidget extends StatelessWidget {
  final UserModel user;

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
          // User Avatar
          Container(
            width: isWeb ? 60 : 50,
            height: isWeb ? 60 : 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor,
                width: 2,
              ),
              image: DecorationImage(
                image: NetworkImage(user.imageUrl),
                fit: BoxFit.cover,
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
                  style: TextStyle(
                    fontSize: isWeb ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: isWeb ? 13 : 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          '${user.quizzesTaken}/${user.totalQuizzes}',
                          style: TextStyle(
                            fontSize: isWeb ? 13 : 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: user.quizzesTaken / user.totalQuizzes,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

