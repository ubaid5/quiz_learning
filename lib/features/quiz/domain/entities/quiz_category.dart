import 'package:equatable/equatable.dart';

class QuizCategory extends Equatable {
  final int id;
  final String name;
  final String icon;
  final String difficulty;
  final String color;
  final int completedQuizzes;
  final int totalQuizzes;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.difficulty,
    required this.color,
    this.completedQuizzes = 0,
    this.totalQuizzes = 10,
  });

  double get progress =>
      totalQuizzes > 0 ? completedQuizzes / totalQuizzes : 0.0;

  @override
  List<Object?> get props => [
        id,
        name,
        icon,
        difficulty,
        color,
        completedQuizzes,
        totalQuizzes,
      ];

  QuizCategory copyWith({
    int? id,
    String? name,
    String? icon,
    String? difficulty,
    String? color,
    int? completedQuizzes,
    int? totalQuizzes,
  }) {
    return QuizCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      difficulty: difficulty ?? this.difficulty,
      color: color ?? this.color,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
    );
  }
}

