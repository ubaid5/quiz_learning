class QuizCategoryModel {
  final String id;
  final String name;
  final String icon;
  final int categoryId; // Open Trivia DB category ID
  final String difficulty;
  final int completedQuizzes;
  final int totalQuizzes;
  final String color;

  QuizCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.categoryId,
    required this.difficulty,
    required this.completedQuizzes,
    required this.totalQuizzes,
    required this.color,
  });

  double get progress => totalQuizzes > 0 ? completedQuizzes / totalQuizzes : 0.0;

  String get apiUrl => 
      'https://opentdb.com/api.php?amount=10&category=$categoryId&difficulty=$difficulty&type=multiple';

  // Dummy categories for static UI
  static List<QuizCategoryModel> dummyCategories = [
    QuizCategoryModel(
      id: '1',
      name: 'General Knowledge',
      icon: '🧠',
      categoryId: 9,
      difficulty: 'easy',
      completedQuizzes: 5,
      totalQuizzes: 10,
      color: '0xFF6366F1',
    ),
    QuizCategoryModel(
      id: '2',
      name: 'Mathematics',
      icon: '🔢',
      categoryId: 19,
      difficulty: 'medium',
      completedQuizzes: 3,
      totalQuizzes: 10,
      color: '0xFF8B5CF6',
    ),
    QuizCategoryModel(
      id: '3',
      name: 'Science & Nature',
      icon: '🔬',
      categoryId: 17,
      difficulty: 'easy',
      completedQuizzes: 2,
      totalQuizzes: 10,
      color: '0xFF22C55E',
    ),
    QuizCategoryModel(
      id: '4',
      name: 'History',
      icon: '📚',
      categoryId: 23,
      difficulty: 'medium',
      completedQuizzes: 1,
      totalQuizzes: 10,
      color: '0xFFEC4899',
    ),
    QuizCategoryModel(
      id: '5',
      name: 'Sports',
      icon: '⚽',
      categoryId: 21,
      difficulty: 'easy',
      completedQuizzes: 4,
      totalQuizzes: 10,
      color: '0xFFF59E0B',
    ),
  ];
}

