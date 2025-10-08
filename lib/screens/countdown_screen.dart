import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/quiz_category_model.dart';
import '../core/theme/app_theme.dart';
import 'dart:async';

class CountdownScreen extends StatefulWidget {
  final QuizCategoryModel category;

  const CountdownScreen({
    super.key,
    required this.category,
  });

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _currentCount = 3;
  Timer? _timer;

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
        // Navigate to quiz screen after countdown
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            context.pushReplacement('/quiz', extra: widget.category);
          }
        });
      }
    });
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

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
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
                style: TextStyle(
                  fontSize: isWeb ? 32 : 24,
                  fontWeight: FontWeight.w700,
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
                      style: TextStyle(
                        fontSize: isWeb ? 80 : 64,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: isWeb ? 60 : 48),
              
              // Get Ready Text
              Text(
                'Get Ready!',
                style: TextStyle(
                  fontSize: isWeb ? 24 : 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

