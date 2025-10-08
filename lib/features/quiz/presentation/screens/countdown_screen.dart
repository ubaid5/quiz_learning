import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/quiz_category.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';

class CountdownScreen extends StatefulWidget {
  final QuizCategory category;

  const CountdownScreen({
    super.key,
    required this.category,
  });

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _currentCount = AppConstants.countdownSeconds;
  Timer? _timer;
  bool _countdownComplete = false;
  bool _questionsLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
    _startCountdown();
    
    // Load questions
    context.read<QuizBloc>().add(LoadQuestionsEvent(
          categoryId: widget.category.id,
          categoryName: widget.category.name,
          difficulty: widget.category.difficulty,
        ));
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentCount > 1) {
        setState(() {
          _currentCount--;
        });
        // Reset animation for next number
        _controller.reset();
        _controller.forward();
      } else {
        timer.cancel();
        setState(() {
          _countdownComplete = true;
        });
        // Check if we can navigate now
        _checkAndNavigate();
      }
    });
  }

  void _checkAndNavigate() {
    // Only navigate when both countdown is complete AND questions are loaded
    if (_countdownComplete && _questionsLoaded && mounted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.pushReplacement('/quiz', extra: widget.category);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final color = Color(int.parse(widget.category.color));

    return BlocListener<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuestionsLoaded) {
          setState(() {
            _questionsLoaded = true;
          });
          // Check if we can navigate now
          _checkAndNavigate();
        } else if (state is QuizError) {
          // Handle error - go back to home
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: color,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Category Icon
              Container(
                width: isWeb ? 120 : 100,
                height: isWeb ? 120 : 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.category.icon,
                    style: TextStyle(fontSize: isWeb ? 60 : 50),
                  ),
                ),
              ),

              SizedBox(height: isWeb ? 40 : 32),

              // Category Name
              Text(
                widget.category.name,
                style: (isWeb
                        ? AppTextStyles.heading1Web
                        : AppTextStyles.heading1)
                    .copyWith(
                  color: Colors.white,
                ),
              ),

              SizedBox(height: isWeb ? 80 : 60),

              // Countdown Number
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: isWeb ? 160 : 140,
                  height: isWeb ? 160 : 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$_currentCount',
                      style: (isWeb
                              ? AppTextStyles.displayLargeWeb
                              : AppTextStyles.displayLarge)
                          .copyWith(
                        fontSize: isWeb ? 80 : 64,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: isWeb ? 60 : 48),

              // Get Ready Text
              Text(
                AppStrings.getReady,
                style: (isWeb
                        ? AppTextStyles.heading2Web
                        : AppTextStyles.heading2)
                    .copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
