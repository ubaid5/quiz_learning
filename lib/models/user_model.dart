class UserModel {
  final String id;
  final String name;
  final String imageUrl;
  final int rank;
  final int score;
  final int quizzesTaken;
  final int totalQuizzes;

  UserModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rank,
    required this.score,
    required this.quizzesTaken,
    required this.totalQuizzes,
  });

  // Dummy user for static UI
  static UserModel dummy = UserModel(
    id: '1',
    name: 'Obaid Ullah',
    imageUrl: 'https://i.pravatar.cc/150?img=68',
    rank: 5,
    score: 1250,
    quizzesTaken: 15,
    totalQuizzes: 25,
  );
}

