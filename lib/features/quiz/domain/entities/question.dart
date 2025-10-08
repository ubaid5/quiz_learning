import 'package:equatable/equatable.dart';

enum QuestionType {
  multiple,
  boolean,
}

class Question extends Equatable {
  final String question;
  final QuestionType type;
  final List<String> options;
  final String correctAnswer;
  final String difficulty;
  final String category;

  const Question({
    required this.question,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.category,
  });

  @override
  List<Object?> get props => [
        question,
        type,
        options,
        correctAnswer,
        difficulty,
        category,
      ];
}
