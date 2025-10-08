import '../../domain/entities/quiz_category.dart';

class QuizCategoryModel extends QuizCategory {
  const QuizCategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.difficulty,
    required super.color,
    super.completedQuizzes,
    super.totalQuizzes,
  });

  factory QuizCategoryModel.fromJson(Map<String, dynamic> json) {
    return QuizCategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      difficulty: json['difficulty'],
      color: json['color'],
      completedQuizzes: json['completedQuizzes'] ?? 0,
      totalQuizzes: json['totalQuizzes'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'difficulty': difficulty,
      'color': color,
      'completedQuizzes': completedQuizzes,
      'totalQuizzes': totalQuizzes,
    };
  }

  // Static list of predefined categories
  static List<QuizCategoryModel> get defaultCategories => [
        const QuizCategoryModel(
          id: 9,
          name: 'General Knowledge',
          icon: '🧠',
          difficulty: 'easy',
          color: '0xFF6366F1',
          completedQuizzes: 0,
          totalQuizzes: 10,
        ),
        const QuizCategoryModel(
          id: 19,
          name: 'Mathematics',
          icon: '🔢',
          difficulty: 'medium',
          color: '0xFF8B5CF6',
          completedQuizzes: 0,
          totalQuizzes: 10,
        ),
        const QuizCategoryModel(
          id: 17,
          name: 'Science & Nature',
          icon: '🔬',
          difficulty: 'easy',
          color: '0xFF22C55E',
          completedQuizzes: 0,
          totalQuizzes: 10,
        ),
        const QuizCategoryModel(
          id: 23,
          name: 'History',
          icon: '📚',
          difficulty: 'medium',
          color: '0xFFEC4899',
          completedQuizzes: 0,
          totalQuizzes: 10,
        ),
        const QuizCategoryModel(
          id: 21,
          name: 'Sports',
          icon: '⚽',
          difficulty: 'easy',
          color: '0xFFF59E0B',
          completedQuizzes: 0,
          totalQuizzes: 10,
        ),
      ];
}
