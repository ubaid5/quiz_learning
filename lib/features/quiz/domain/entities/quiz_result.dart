import 'package:equatable/equatable.dart';

class QuizResult extends Equatable {
  final int categoryId;
  final String categoryName;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int pointsEarned;
  final DateTime completedAt;

  const QuizResult({
    required this.categoryId,
    required this.categoryName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.pointsEarned,
    required this.completedAt,
  });

  double get scorePercentage => (correctAnswers / totalQuestions) * 100;

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        totalQuestions,
        correctAnswers,
        incorrectAnswers,
        pointsEarned,
        completedAt,
      ];
}

