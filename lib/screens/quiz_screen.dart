import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../models/question_model.dart';
import '../models/quiz_category_model.dart';
import '../models/quiz_result_model.dart';
import '../widgets/option_card.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_strings.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategoryModel category;

  const QuizScreen({
    super.key,
    required this.category,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<QuestionModel> _questions = QuestionModel.dummyQuestions;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showFeedback = false;
  int _correctAnswers = 0;
  int _remainingSeconds = 60;
  Timer? _timer;

  QuestionModel get _currentQuestion => _questions[_currentQuestionIndex];
  int get _totalQuestions => _questions.length;
  double get _progress => _currentQuestionIndex / _totalQuestions; // Progress based on completed questions

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        // Auto-submit when time runs out
        if (!_showFeedback) {
          _submitAnswer();
        }
      }
    });
  }

  void _submitAnswer() {
    _timer?.cancel(); // Stop timer when answer is submitted
    setState(() {
      _showFeedback = true;
      if (_selectedAnswer == _currentQuestion.correctAnswer) {
        _correctAnswers++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showFeedback = false;
      });
      _startTimer(); // Start new timer for next question
    } else {
      // Quiz completed, navigate to result screen
      _timer?.cancel();
      final result = QuizResultModel(
        categoryName: widget.category.name,
        totalQuestions: _totalQuestions,
        correctAnswers: _correctAnswers,
        incorrectAnswers: _totalQuestions - _correctAnswers,
        scoreEarned: _correctAnswers * 10,
        completedAt: DateTime.now(),
      );
      context.pushReplacement('/result', extra: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog before leaving quiz
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppStrings.exitQuiz),
            content: Text(AppStrings.exitQuizMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(AppStrings.exit),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
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
                  title: Text(AppStrings.exitQuiz),
                  content: Text(AppStrings.exitQuizMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(AppStrings.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(AppStrings.exit),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.incorrectColor,
                      ),
                    ),
                  ],
                ),
              );
              if (shouldExit == true && context.mounted) {
                _timer?.cancel();
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
              _buildProgressSection(isWeb),
            
            // Question and Options Section
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isWeb ? 24 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Question Card
                      Card(
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
                                  _currentQuestion.type == QuestionType.multipleChoice
                                      ? AppStrings.multipleChoice
                                      : AppStrings.trueFalse,
                                  style: isWeb ? AppTextStyles.badgeWeb : AppTextStyles.badge,
                                ),
                              ),
                              
                              SizedBox(height: isWeb ? 24 : 20),
                              
                              // Question Text
                              Text(
                                _currentQuestion.question,
                                style: isWeb ? AppTextStyles.questionTextWeb : AppTextStyles.questionText,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: isWeb ? 24 : 20),
                      
                      // Feedback Label
                      if (_showFeedback)
                        Container(
                          margin: EdgeInsets.only(bottom: isWeb ? 16 : 12),
                          padding: EdgeInsets.all(isWeb ? 16 : 12),
                          decoration: BoxDecoration(
                            color: _selectedAnswer == _currentQuestion.correctAnswer
                                ? AppTheme.correctColor.withOpacity(0.1)
                                : AppTheme.incorrectColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedAnswer == _currentQuestion.correctAnswer
                                  ? AppTheme.correctColor
                                  : AppTheme.incorrectColor,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _selectedAnswer == _currentQuestion.correctAnswer
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: _selectedAnswer == _currentQuestion.correctAnswer
                                    ? AppTheme.correctColor
                                    : AppTheme.incorrectColor,
                                size: isWeb ? 28 : 24,
                              ),
                              SizedBox(width: isWeb ? 12 : 10),
                              Text(
                                _selectedAnswer == _currentQuestion.correctAnswer
                                    ? AppStrings.feedbackCorrect
                                    : AppStrings.feedbackIncorrect,
                                style: _selectedAnswer == _currentQuestion.correctAnswer
                                    ? (isWeb ? AppTextStyles.feedbackCorrectWeb : AppTextStyles.feedbackCorrect)
                                    : (isWeb ? AppTextStyles.feedbackIncorrectWeb : AppTextStyles.feedbackIncorrect),
                              ),
                            ],
                          ),
                        ),
                      
                      // Options
                      ...List.generate(
                        _currentQuestion.options.length,
                        (index) {
                          final option = _currentQuestion.options[index];
                          return OptionCard(
                            option: option,
                            isSelected: _selectedAnswer == option,
                            isCorrect: option == _currentQuestion.correctAnswer
                                ? true
                                : (_selectedAnswer == option ? false : null),
                            onTap: () {
                              setState(() {
                                _selectedAnswer = option;
                              });
                            },
                            showFeedback: _showFeedback,
                          );
                        },
                      ),
                      
                      SizedBox(height: isWeb ? 24 : 20),
                      
                      // Submit Button
                      if (!_showFeedback && _selectedAnswer != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitAnswer,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isWeb ? 20 : 16,
                              ),
                            ),
                            child: Text(
                              AppStrings.submitAnswer,
                              style: isWeb ? AppTextStyles.buttonTextWeb : AppTextStyles.buttonText,
                            ),
                          ),
                        ),
                      
                      // Next Button (after feedback)
                      if (_showFeedback)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _nextQuestion,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isWeb ? 20 : 16,
                              ),
                            ),
                            child: Text(
                              _currentQuestionIndex < _questions.length - 1
                                  ? AppStrings.nextQuestion
                                  : AppStrings.viewResults,
                              style: isWeb ? AppTextStyles.buttonTextWeb : AppTextStyles.buttonText,
                            ),
                          ),
                        ),
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

  Widget _buildProgressSection(bool isWeb) {
    final progressPercentage = (_progress * 100).toInt();
    
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
                AppStrings.questionFormat(_currentQuestionIndex + 1, _totalQuestions),
                style: isWeb ? AppTextStyles.heading4Web : AppTextStyles.heading4,
              ),
              Text(
                AppStrings.percentageFormat(progressPercentage),
                style: (isWeb ? AppTextStyles.heading4Web : AppTextStyles.heading4).copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
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
                    style: isWeb ? AppTextStyles.bodyMediumWeb : AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              Text(
                AppStrings.secondsFormat(_remainingSeconds),
                style: (isWeb ? AppTextStyles.timerLargeWeb : AppTextStyles.timerLarge).copyWith(
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
              value: _remainingSeconds / 60,
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

