import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../models/question_model.dart';
import '../models/quiz_category_model.dart';
import '../models/quiz_result_model.dart';
import '../widgets/option_card.dart';
import '../core/theme/app_theme.dart';

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
            title: const Text('Exit Quiz?'),
            content: const Text('Your progress will be lost. Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
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
                  title: const Text('Exit Quiz?'),
                  content: const Text('Your progress will be lost. Are you sure you want to exit?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Exit'),
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
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isWeb ? 20 : 18,
              fontWeight: FontWeight.w600,
            ),
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
                                      ? 'Multiple Choice'
                                      : 'True/False',
                                  style: TextStyle(
                                    fontSize: isWeb ? 13 : 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: isWeb ? 24 : 20),
                              
                              // Question Text
                              Text(
                                _currentQuestion.question,
                                style: TextStyle(
                                  fontSize: isWeb ? 22 : 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                  height: 1.4,
                                ),
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
                                    ? 'Correct! Well done! 🎉'
                                    : 'Incorrect. Try the next one! 💪',
                                style: TextStyle(
                                  fontSize: isWeb ? 16 : 14,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedAnswer == _currentQuestion.correctAnswer
                                      ? AppTheme.correctColor
                                      : AppTheme.incorrectColor,
                                ),
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
                              textStyle: TextStyle(
                                fontSize: isWeb ? 18 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('Submit Answer'),
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
                              textStyle: TextStyle(
                                fontSize: isWeb ? 18 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Text(
                              _currentQuestionIndex < _questions.length - 1
                                  ? 'Next Question'
                                  : 'View Results',
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
                'Question ${_currentQuestionIndex + 1}/$_totalQuestions',
                style: TextStyle(
                  fontSize: isWeb ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '$progressPercentage%',
                style: TextStyle(
                  fontSize: isWeb ? 18 : 16,
                  fontWeight: FontWeight.w600,
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
                    'Time Remaining',
                    style: TextStyle(
                      fontSize: isWeb ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                '${_remainingSeconds}s',
                style: TextStyle(
                  fontSize: isWeb ? 24 : 20,
                  fontWeight: FontWeight.w700,
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

