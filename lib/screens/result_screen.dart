import 'package:flutter/material.dart';
import '../models/quiz_result_model.dart';
import '../core/theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  final QuizResultModel result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

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
                    color: result.percentage >= 70
                        ? AppTheme.correctColor.withOpacity(0.1)
                        : AppTheme.incorrectColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      result.percentage >= 70 ? '🎉' : '📚',
                      style: TextStyle(fontSize: isWeb ? 70 : 60),
                    ),
                  ),
                ),
                
                SizedBox(height: isWeb ? 32 : 24),
                
                // Result Title
                Text(
                  result.percentage >= 70 ? 'Great Job!' : 'Keep Learning!',
                  style: TextStyle(
                    fontSize: isWeb ? 36 : 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                
                SizedBox(height: isWeb ? 12 : 8),
                
                // Category Name
                Text(
                  result.categoryName,
                  style: TextStyle(
                    fontSize: isWeb ? 20 : 16,
                    color: AppTheme.textSecondary,
                  ),
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
                              color: result.percentage >= 70
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
                                  '${result.percentage.toInt()}%',
                                  style: TextStyle(
                                    fontSize: isWeb ? 40 : 32,
                                    fontWeight: FontWeight.w900,
                                    color: result.percentage >= 70
                                        ? AppTheme.correctColor
                                        : AppTheme.incorrectColor,
                                  ),
                                ),
                                Text(
                                  'Score',
                                  style: TextStyle(
                                    fontSize: isWeb ? 16 : 14,
                                    color: AppTheme.textSecondary,
                                  ),
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
                              '✅',
                              'Correct',
                              '${result.correctAnswers}',
                              AppTheme.correctColor,
                              isWeb,
                            ),
                            _buildDivider(isWeb),
                            _buildStatItem(
                              '❌',
                              'Incorrect',
                              '${result.incorrectAnswers}',
                              AppTheme.incorrectColor,
                              isWeb,
                            ),
                            _buildDivider(isWeb),
                            _buildStatItem(
                              '📊',
                              'Total',
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
                          '⭐',
                          style: TextStyle(fontSize: isWeb ? 32 : 28),
                        ),
                        SizedBox(width: isWeb ? 16 : 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Points Earned',
                              style: TextStyle(
                                fontSize: isWeb ? 16 : 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            Text(
                              '+${result.scoreEarned}',
                              style: TextStyle(
                                fontSize: isWeb ? 32 : 24,
                                fontWeight: FontWeight.w800,
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
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isWeb ? 20 : 16,
                      ),
                      textStyle: TextStyle(
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Back to Home'),
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
          style: TextStyle(
            fontSize: isWeb ? 28 : 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: isWeb ? 6 : 4),
        Text(
          label,
          style: TextStyle(
            fontSize: isWeb ? 14 : 12,
            color: AppTheme.textSecondary,
          ),
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

