import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../../../user/presentation/widgets/user_header_widget.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import '../widgets/quiz_category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // User Header
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return UserHeaderWidget(user: state.user);
                }
                return const SizedBox.shrink();
              },
            ),

            // Main Content
            Expanded(
              child: BlocBuilder<QuizBloc, QuizState>(
                buildWhen: (previous, current) {
                  // Only rebuild for states relevant to home screen
                  return current is QuizInitial ||
                      current is QuizLoading ||
                      current is QuizError ||
                      current is CategoriesLoaded;
                },
                builder: (context, state) {
                  // Handle QuizInitial state - load categories
                  if (state is QuizInitial) {
                    // Trigger loading if not already triggered
                    Future.microtask(() {
                      if (mounted) {
                        context.read<QuizBloc>().add(LoadCategoriesEvent());
                      }
                    });
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is QuizLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is QuizError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<QuizBloc>().add(LoadCategoriesEvent());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is CategoriesLoaded) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(isWeb ? 24 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User Stats Card
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, userState) {
                                if (userState is UserLoaded) {
                                  return _buildUserStatsCard(
                                      context, userState.user, isWeb);
                                }
                                return const SizedBox.shrink();
                              },
                            ),

                            SizedBox(height: isWeb ? 32 : 24),

                            // Section Title
                            Text(
                              AppStrings.quizCategories,
                              style: isWeb
                                  ? AppTextStyles.heading3Web
                                  : AppTextStyles.heading3,
                            ),
                            SizedBox(height: isWeb ? 20 : 16),

                            // Categories List
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.categories.length,
                              itemBuilder: (context, index) {
                                final category = state.categories[index];
                                return QuizCategoryCard(
                                  category: category,
                                  onTap: () {
                                    context.push('/countdown', extra: category);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Default case - this should not happen with buildWhen condition
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStatsCard(BuildContext context, dynamic user, bool isWeb) {
    return Card(
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
              '${user.totalScore}',
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
