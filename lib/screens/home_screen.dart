import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/user_model.dart';
import '../models/quiz_category_model.dart';
import '../widgets/user_header_widget.dart';
import '../widgets/quiz_category_card.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_strings.dart';

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
                               AppStrings.emojiTrophy,
                               AppStrings.rank,
                               AppStrings.rankFormat(user.rank),
                               isWeb,
                             ),
                             _buildDivider(isWeb),
                             _buildStatItem(
                               context,
                               AppStrings.emojiStar,
                               AppStrings.score,
                               '${user.score}',
                               isWeb,
                             ),
                             _buildDivider(isWeb),
                             _buildStatItem(
                               context,
                               AppStrings.emojiChart,
                               AppStrings.completed,
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
                      AppStrings.quizCategories,
                      style: isWeb ? AppTextStyles.heading3Web : AppTextStyles.heading3,
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
          style: isWeb ? AppTextStyles.statValueWeb : AppTextStyles.statValue,
        ),
        SizedBox(height: isWeb ? 6 : 4),
        Text(
          label,
          style: isWeb ? AppTextStyles.statLabelWeb : AppTextStyles.statLabel,
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

