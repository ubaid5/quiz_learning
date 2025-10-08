import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rank,
    required super.totalScore,
    required super.quizzesTaken,
    required super.totalQuizzes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      rank: json['rank'],
      totalScore: json['totalScore'],
      quizzesTaken: json['quizzesTaken'],
      totalQuizzes: json['totalQuizzes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'rank': rank,
      'totalScore': totalScore,
      'quizzesTaken': quizzesTaken,
      'totalQuizzes': totalQuizzes,
    };
  }

  // Default dummy user
  static UserModel get defaultUser => const UserModel(
        id: '1',
        name: 'Obaid Ullah',
        imageUrl: AppConstants.dummyUserImage,
        rank: 42,
        totalScore: 0,
        quizzesTaken: 0,
        totalQuizzes: 50,
      );
}
