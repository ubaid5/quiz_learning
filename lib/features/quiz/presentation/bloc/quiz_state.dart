import 'package:equatable/equatable.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_category.dart';
import '../../domain/entities/quiz_result.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class CategoriesLoaded extends QuizState {
  final List<QuizCategory> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class QuestionsLoaded extends QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final String categoryName;
  final int categoryId;
  final Map<int, String> answers;
  final int? lastAnsweredIndex;
  final bool? lastAnswerCorrect;

  const QuestionsLoaded({
    required this.questions,
    required this.categoryName,
    required this.categoryId,
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.lastAnsweredIndex,
    this.lastAnswerCorrect,
  });

  bool get isLastQuestion => currentQuestionIndex >= questions.length - 1;

  int get correctAnswersCount {
    int count = 0;
    answers.forEach((index, answer) {
      if (questions[index].correctAnswer == answer) {
        count++;
      }
    });
    return count;
  }

  @override
  List<Object?> get props => [
        questions,
        currentQuestionIndex,
        categoryName,
        categoryId,
        answers,
        lastAnsweredIndex,
        lastAnswerCorrect,
      ];

  QuestionsLoaded copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    String? categoryName,
    int? categoryId,
    Map<int, String>? answers,
    int? lastAnsweredIndex,
    bool? lastAnswerCorrect,
  }) {
    return QuestionsLoaded(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      categoryName: categoryName ?? this.categoryName,
      categoryId: categoryId ?? this.categoryId,
      answers: answers ?? this.answers,
      lastAnsweredIndex: lastAnsweredIndex,
      lastAnswerCorrect: lastAnswerCorrect,
    );
  }
}

class QuizCompleted extends QuizState {
  final QuizResult result;

  const QuizCompleted({required this.result});

  @override
  List<Object?> get props => [result];
}

class QuizError extends QuizState {
  final String message;

  const QuizError({required this.message});

  @override
  List<Object?> get props => [message];
}

