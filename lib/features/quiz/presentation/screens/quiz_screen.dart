import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_category.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import '../widgets/option_card.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;

  const QuizScreen({
    super.key,
    required this.category,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _remainingSeconds = AppConstants.timePerQuestionSeconds;
  Timer? _timer;
  bool _timerStarted = false;

  @override
  void initState() {
    super.initState();
    // Don't start timer here - wait for questions to load
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = AppConstants.timePerQuestionSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resetTimer() {
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizCompleted) {
          context.pushReplacement('/result', extra: state.result);
        }
        
        if (state is QuestionsLoaded) {
          // Start timer only once when questions are first loaded
          if (!_timerStarted && state.currentQuestionIndex == 0 && state.lastAnsweredIndex == null) {
            _timerStarted = true;
            _startTimer();
          }
          
          // Handle answer submission and move to next question
          if (state.lastAnsweredIndex != null) {
            _timer?.cancel();
            // After feedback delay, move to next question
            Future.delayed(Duration(seconds: AppConstants.feedbackDelaySeconds), () {
              if (mounted) {
                if (state.isLastQuestion) {
                  context.read<QuizBloc>().add(FinishQuizEvent());
                } else {
                  context.read<QuizBloc>().add(NextQuestionEvent());
                  _resetTimer();
                }
              }
            });
          }
        }
      },
      builder: (context, state) {
        if (state is QuizLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is QuizError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is QuestionsLoaded) {
          return _buildQuizContent(context, state, isWeb);
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildQuizContent(
    BuildContext context,
    QuestionsLoaded state,
    bool isWeb,
  ) {
    // Start timer on first question if not already started
    if (!_timerStarted && state.currentQuestionIndex == 0 && state.lastAnsweredIndex == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_timerStarted) {
          setState(() {
            _timerStarted = true;
          });
          _startTimer();
        }
      });
    }

    final currentQuestion = state.questions[state.currentQuestionIndex];
    final selectedAnswer = state.answers[state.currentQuestionIndex];
    final showFeedback = state.lastAnsweredIndex == state.currentQuestionIndex;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(AppStrings.exitQuiz),
            content: const Text(AppStrings.exitQuizMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(AppStrings.exit),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.incorrectColor,
                ),
              ),
            ],
          ),
        );
        
        if (shouldExit == true && context.mounted) {
          _timer?.cancel();
          // Reset quiz state before going back
          context.read<QuizBloc>().add(ResetQuizEvent());
          context.go('/');
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () async {
              final shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(AppStrings.exitQuiz),
                  content: const Text(AppStrings.exitQuizMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(AppStrings.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(AppStrings.exit),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.incorrectColor,
                      ),
                    ),
                  ],
                ),
              );
              if (shouldExit == true && context.mounted) {
                _timer?.cancel();
                // Reset quiz state before going back
                context.read<QuizBloc>().add(ResetQuizEvent());
                context.go('/');
              }
            },
          ),
          title: Text(
            widget.category.name,
            style: isWeb ? AppTextStyles.heading4Web : AppTextStyles.heading4,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Top Progress Section
              _buildProgressSection(state, isWeb),

              // Question and Options Section
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(isWeb ? 24 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Question Card
                        _buildQuestionCard(currentQuestion, isWeb),

                        SizedBox(height: isWeb ? 24 : 20),

                        // Feedback Label
                        if (showFeedback)
                          _buildFeedbackLabel(
                            state.lastAnswerCorrect ?? false,
                            isWeb,
                          ),

                        // Options
                        ...currentQuestion.options.map((option) {
                          return OptionCard(
                            option: option,
                            isSelected: selectedAnswer == option,
                            isCorrect: option == currentQuestion.correctAnswer
                                ? true
                                : (selectedAnswer == option ? false : null),
                            onTap: showFeedback
                                ? null
                                : () {
                                    context.read<QuizBloc>().add(
                                          AnswerQuestionEvent(
                                            questionIndex:
                                                state.currentQuestionIndex,
                                            selectedAnswer: option,
                                          ),
                                        );
                                  },
                            showFeedback: showFeedback,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Timer Section
              _buildTimerSection(isWeb),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, bool isWeb) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 32 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Type Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                question.type == QuestionType.multiple
                    ? AppStrings.multipleChoice
                    : AppStrings.trueFalse,
                style: isWeb ? AppTextStyles.badgeWeb : AppTextStyles.badge,
              ),
            ),

            SizedBox(height: isWeb ? 24 : 20),

            // Question Text
            Text(
              question.question,
              style: isWeb
                  ? AppTextStyles.questionTextWeb
                  : AppTextStyles.questionText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackLabel(bool isCorrect, bool isWeb) {
    return Container(
      margin: EdgeInsets.only(bottom: isWeb ? 16 : 12),
      padding: EdgeInsets.all(isWeb ? 16 : 12),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppTheme.correctColor.withOpacity(0.1)
            : AppTheme.incorrectColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? AppTheme.correctColor : AppTheme.incorrectColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? AppTheme.correctColor : AppTheme.incorrectColor,
            size: isWeb ? 28 : 24,
          ),
          SizedBox(width: isWeb ? 12 : 10),
          Text(
            isCorrect
                ? AppStrings.feedbackCorrect
                : AppStrings.feedbackIncorrect,
            style: isCorrect
                ? (isWeb
                    ? AppTextStyles.feedbackCorrectWeb
                    : AppTextStyles.feedbackCorrect)
                : (isWeb
                    ? AppTextStyles.feedbackIncorrectWeb
                    : AppTextStyles.feedbackIncorrect),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(QuestionsLoaded state, bool isWeb) {
    final progress = state.currentQuestionIndex / state.questions.length;
    final progressPercentage = (progress * 100).toInt();

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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.questionFormat(
                  state.currentQuestionIndex + 1,
                  state.questions.length,
                ),
                style:
                    isWeb ? AppTextStyles.heading4Web : AppTextStyles.heading4,
              ),
              Text(
                AppStrings.percentageFormat(progressPercentage),
                style: (isWeb
                        ? AppTextStyles.heading4Web
                        : AppTextStyles.heading4)
                    .copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryColor,
              ),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection(bool isWeb) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: _remainingSeconds <= 10
                        ? AppTheme.incorrectColor
                        : AppTheme.primaryColor,
                    size: isWeb ? 28 : 24,
                  ),
                  SizedBox(width: isWeb ? 12 : 8),
                  Text(
                    AppStrings.timeRemaining,
                    style: isWeb
                        ? AppTextStyles.bodyMediumWeb
                        : AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              Text(
                AppStrings.secondsFormat(_remainingSeconds),
                style: (isWeb
                        ? AppTextStyles.timerLargeWeb
                        : AppTextStyles.timerLarge)
                    .copyWith(
                  color: _remainingSeconds <= 10
                      ? AppTheme.incorrectColor
                      : AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _remainingSeconds / AppConstants.timePerQuestionSeconds,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _remainingSeconds <= 10
                    ? AppTheme.incorrectColor
                    : AppTheme.primaryColor,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
