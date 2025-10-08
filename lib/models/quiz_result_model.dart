class QuizResultModel {
  final String categoryName;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int scoreEarned;
  final DateTime completedAt;

  QuizResultModel({
    required this.categoryName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.scoreEarned,
    required this.completedAt,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;
  int get unanswered => totalQuestions - correctAnswers - incorrectAnswers;

  // Dummy result for static UI
  static QuizResultModel dummy = QuizResultModel(
    categoryName: 'General Knowledge',
    totalQuestions: 10,
    correctAnswers: 7,
    incorrectAnswers: 3,
    scoreEarned: 70,
    completedAt: DateTime.now(),
  );
}

