import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends QuizEvent {}

class LoadQuestionsEvent extends QuizEvent {
  final int categoryId;
  final String categoryName;
  final String difficulty;
  final int amount;

  const LoadQuestionsEvent({
    required this.categoryId,
    required this.categoryName,
    required this.difficulty,
    this.amount = AppConstants.questionsPerQuiz,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, difficulty, amount];
}

class AnswerQuestionEvent extends QuizEvent {
  final int questionIndex;
  final String selectedAnswer;

  const AnswerQuestionEvent({
    required this.questionIndex,
    required this.selectedAnswer,
  });

  @override
  List<Object?> get props => [questionIndex, selectedAnswer];
}

class NextQuestionEvent extends QuizEvent {}

class FinishQuizEvent extends QuizEvent {}

class ResetQuizEvent extends QuizEvent {}

