import '../../domain/entities/quiz_result.dart';

class QuizResultModel extends QuizResult {
  const QuizResultModel({
    required super.categoryId,
    required super.categoryName,
    required super.totalQuestions,
    required super.correctAnswers,
    required super.incorrectAnswers,
    required super.pointsEarned,
    required super.completedAt,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      incorrectAnswers: json['incorrectAnswers'],
      pointsEarned: json['pointsEarned'],
      completedAt: DateTime.parse(json['completedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'pointsEarned': pointsEarned,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}
