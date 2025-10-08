enum QuestionType {
  multipleChoice,
  trueFalse,
}

class QuestionModel {
  final String id;
  final String question;
  final QuestionType type;
  final List<String> options;
  final String correctAnswer;
  final String? selectedAnswer;
  final String difficulty;

  QuestionModel({
    required this.id,
    required this.question,
    required this.type,
    required this.options,
    required this.correctAnswer,
    this.selectedAnswer,
    required this.difficulty,
  });

  bool get isAnswered => selectedAnswer != null;
  bool get isCorrect => selectedAnswer == correctAnswer;

  QuestionModel copyWith({
    String? id,
    String? question,
    QuestionType? type,
    List<String>? options,
    String? correctAnswer,
    String? selectedAnswer,
    String? difficulty,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      question: question ?? this.question,
      type: type ?? this.type,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  // Dummy questions for static UI
  static List<QuestionModel> dummyQuestions = [
    QuestionModel(
      id: '1',
      question: 'What is the capital of France?',
      type: QuestionType.multipleChoice,
      options: ['London', 'Berlin', 'Paris', 'Madrid'],
      correctAnswer: 'Paris',
      difficulty: 'easy',
    ),
    QuestionModel(
      id: '2',
      question: 'The Great Wall of China is visible from space.',
      type: QuestionType.trueFalse,
      options: ['True', 'False'],
      correctAnswer: 'False',
      difficulty: 'medium',
    ),
    QuestionModel(
      id: '3',
      question: 'Which planet is known as the Red Planet?',
      type: QuestionType.multipleChoice,
      options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      correctAnswer: 'Mars',
      difficulty: 'easy',
    ),
    QuestionModel(
      id: '4',
      question: 'What is 2 + 2?',
      type: QuestionType.multipleChoice,
      options: ['3', '4', '5', '6'],
      correctAnswer: '4',
      difficulty: 'easy',
    ),
    QuestionModel(
      id: '5',
      question: 'Python is a programming language.',
      type: QuestionType.trueFalse,
      options: ['True', 'False'],
      correctAnswer: 'True',
      difficulty: 'easy',
    ),
  ];
}

