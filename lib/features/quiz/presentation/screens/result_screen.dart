import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_event.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../../domain/entities/quiz_result.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';

class ResultScreen extends StatelessWidget {
  final QuizResult result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    // Update user progress
    final userBloc = context.read<UserBloc>();
    if (userBloc.state is UserLoaded) {
      final currentUser = (userBloc.state as UserLoaded).user;
      userBloc.add(UpdateUserProgressEvent(
        quizzesTaken: currentUser.quizzesTaken + 1,
        scoreToAdd: result.pointsEarned,
      ));
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 32 : 24),
            child: Column(
              children: [
                SizedBox(height: isWeb ? 40 : 20),

                // Success Icon
                Container(
                  width: isWeb ? 140 : 120,
                  height: isWeb ? 140 : 120,
                  decoration: BoxDecoration(
                    color: result.scorePercentage >= 70
                        ? AppTheme.correctColor.withOpacity(0.1)
                        : AppTheme.incorrectColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      result.scorePercentage >= 70
                          ? AppStrings.emojiParty
                          : AppStrings.emojiBook,
                      style: TextStyle(fontSize: isWeb ? 70 : 60),
                    ),
                  ),
                ),

                SizedBox(height: isWeb ? 32 : 24),

                // Result Title
                Text(
                  result.scorePercentage >= 70
                      ? AppStrings.greatJob
                      : AppStrings.keepLearning,
                  style:
                      isWeb ? AppTextStyles.heading1Web : AppTextStyles.heading1,
                ),

                SizedBox(height: isWeb ? 12 : 8),

                // Category Name
                Text(
                  result.categoryName,
                  style:
                      isWeb ? AppTextStyles.heading4Web : AppTextStyles.heading4,
                ),

                SizedBox(height: isWeb ? 40 : 32),

                // Score Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(isWeb ? 32 : 24),
                    child: Column(
                      children: [
                        // Percentage Circle
                        Container(
                          width: isWeb ? 160 : 140,
                          height: isWeb ? 160 : 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: result.scorePercentage >= 70
                                  ? AppTheme.correctColor
                                  : AppTheme.incorrectColor,
                              width: 8,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.percentageFormat(
                                      result.scorePercentage.toInt()),
                                  style: (isWeb
                                          ? AppTextStyles.displayMediumWeb
                                          : AppTextStyles.displayMedium)
                                      .copyWith(
                                    color: result.scorePercentage >= 70
                                        ? AppTheme.correctColor
                                        : AppTheme.incorrectColor,
                                  ),
                                ),
                                Text(
                                  AppStrings.scoreLabel,
                                  style: isWeb
                                      ? AppTextStyles.bodyMediumWeb
                                      : AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: isWeb ? 32 : 24),

                        // Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                              AppStrings.emojiCheckMark,
                              AppStrings.correct,
                              '${result.correctAnswers}',
                              AppTheme.correctColor,
                              isWeb,
                            ),
                            _buildDivider(isWeb),
                            _buildStatItem(
                              AppStrings.emojiCross,
                              AppStrings.incorrect,
                              '${result.incorrectAnswers}',
                              AppTheme.incorrectColor,
                              isWeb,
                            ),
                            _buildDivider(isWeb),
                            _buildStatItem(
                              AppStrings.emojiChart,
                              AppStrings.total,
                              '${result.totalQuestions}',
                              AppTheme.primaryColor,
                              isWeb,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: isWeb ? 32 : 24),

                // Score Earned
                Card(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(isWeb ? 24 : 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.emojiStar,
                          style: TextStyle(fontSize: isWeb ? 32 : 28),
                        ),
                        SizedBox(width: isWeb ? 16 : 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.pointsEarned,
                              style: isWeb
                                  ? AppTextStyles.bodyMediumWeb
                                  : AppTextStyles.bodyMedium,
                            ),
                            Text(
                              AppStrings.pointsFormat(result.pointsEarned),
                              style: (isWeb
                                      ? AppTextStyles.displayMediumWeb
                                      : AppTextStyles.displayMedium)
                                  .copyWith(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: isWeb ? 40 : 32),

                // Back to Home Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Reset quiz state and reload categories
                      context.read<QuizBloc>().add(ResetQuizEvent());
                      context.read<QuizBloc>().add(LoadCategoriesEvent());
                      context.go('/');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isWeb ? 20 : 16,
                      ),
                    ),
                    child: Text(
                      AppStrings.backToHome,
                      style: isWeb
                          ? AppTextStyles.buttonTextWeb
                          : AppTextStyles.buttonText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String emoji,
    String label,
    String value,
    Color color,
    bool isWeb,
  ) {
    return Column(
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: isWeb ? 28 : 24),
        ),
        SizedBox(height: isWeb ? 12 : 8),
        Text(
          value,
          style: (isWeb
                  ? AppTextStyles.displaySmallWeb
                  : AppTextStyles.displaySmall)
              .copyWith(
            color: color,
          ),
        ),
        SizedBox(height: isWeb ? 6 : 4),
        Text(
          label,
          style:
              isWeb ? AppTextStyles.bodySmallWeb : AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDivider(bool isWeb) {
    return Container(
      height: isWeb ? 80 : 70,
      width: 1,
      color: Colors.grey[300],
    );
  }
}
