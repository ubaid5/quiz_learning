import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/user_model.dart';
import '../models/quiz_category_model.dart';
import '../widgets/user_header_widget.dart';
import '../widgets/quiz_category_card.dart';
import '../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserModel.dummy;
    final categories = QuizCategoryModel.dummyCategories;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // User Header
            UserHeaderWidget(user: user),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isWeb ? 24 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Stats Card
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(isWeb ? 24 : 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                context,
                                '🏆',
                                'Rank',
                                '#${user.rank}',
                                isWeb,
                              ),
                              _buildDivider(isWeb),
                              _buildStatItem(
                                context,
                                '⭐',
                                'Score',
                                '${user.score}',
                                isWeb,
                              ),
                              _buildDivider(isWeb),
                              _buildStatItem(
                                context,
                                '📊',
                                'Completed',
                                '${user.quizzesTaken}',
                                isWeb,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: isWeb ? 32 : 24),

                      // Section Title
                      Text(
                        'Quiz Categories',
                        style: TextStyle(
                          fontSize: isWeb ? 24 : 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: isWeb ? 20 : 16),

                      // Categories List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return QuizCategoryCard(
                            category: categories[index],
                            onTap: () {
                              // Navigate to countdown screen
                              context.push('/countdown', extra: categories[index]);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String emoji,
    String label,
    String value,
    bool isWeb,
  ) {
    return Column(
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: isWeb ? 32 : 28),
        ),
        SizedBox(height: isWeb ? 12 : 8),
        Text(
          value,
          style: TextStyle(
            fontSize: isWeb ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryColor,
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
      height: isWeb ? 60 : 50,
      width: 1,
      color: Colors.grey[300],
    );
  }
}

