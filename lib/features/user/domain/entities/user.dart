import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final int rank;
  final int totalScore;
  final int quizzesTaken;
  final int totalQuizzes;

  const User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rank,
    required this.totalScore,
    required this.quizzesTaken,
    required this.totalQuizzes,
  });

  double get progress =>
      totalQuizzes > 0 ? quizzesTaken / totalQuizzes : 0.0;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        rank,
        totalScore,
        quizzesTaken,
        totalQuizzes,
      ];

  User copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? rank,
    int? totalScore,
    int? quizzesTaken,
    int? totalQuizzes,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      rank: rank ?? this.rank,
      totalScore: totalScore ?? this.totalScore,
      quizzesTaken: quizzesTaken ?? this.quizzesTaken,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
    );
  }
}
