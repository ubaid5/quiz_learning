import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_questions.dart';
import '../../domain/usecases/save_quiz_result.dart';
import '../../domain/usecases/update_category_progress.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetCategories getCategories;
  final GetQuestions getQuestions;
  final SaveQuizResult saveQuizResult;
  final UpdateCategoryProgress updateCategoryProgress;

  QuizBloc({
    required this.getCategories,
    required this.getQuestions,
    required this.saveQuizResult,
    required this.updateCategoryProgress,
  }) : super(QuizInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadQuestionsEvent>(_onLoadQuestions);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionEvent>(_onNextQuestion);
    on<FinishQuizEvent>(_onFinishQuiz);
    on<ResetQuizEvent>(_onResetQuiz);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoading());
    
    final result = await getCategories(NoParams());
    
    if (!emit.isDone) {
      result.fold(
        (failure) => emit(QuizError(message: failure.message)),
        (categories) => emit(CategoriesLoaded(categories: categories)),
      );
    }
  }

  Future<void> _onLoadQuestions(
    LoadQuestionsEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoading());
    
    final result = await getQuestions(
      GetQuestionsParams(
        categoryId: event.categoryId,
        difficulty: event.difficulty,
        amount: event.amount,
      ),
    );
    
    if (!emit.isDone) {
      result.fold(
        (failure) => emit(QuizError(message: failure.message)),
        (questions) => emit(QuestionsLoaded(
          questions: questions,
          categoryName: event.categoryName,
          categoryId: event.categoryId,
        )),
      );
    }
  }

  void _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<QuizState> emit,
  ) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      final question = currentState.questions[event.questionIndex];
      final isCorrect = question.correctAnswer == event.selectedAnswer;
      
      final updatedAnswers = Map<int, String>.from(currentState.answers);
      updatedAnswers[event.questionIndex] = event.selectedAnswer;
      
      emit(currentState.copyWith(
        answers: updatedAnswers,
        lastAnsweredIndex: event.questionIndex,
        lastAnswerCorrect: isCorrect,
      ));
    }
  }

  void _onNextQuestion(
    NextQuestionEvent event,
    Emitter<QuizState> emit,
  ) {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      
      if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
        emit(currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
          lastAnsweredIndex: null,
          lastAnswerCorrect: null,
        ));
      }
    }
  }

  Future<void> _onFinishQuiz(
    FinishQuizEvent event,
    Emitter<QuizState> emit,
  ) async {
    if (state is QuestionsLoaded) {
      final currentState = state as QuestionsLoaded;
      
      final correctAnswers = currentState.correctAnswersCount;
      final totalQuestions = currentState.questions.length;
      final incorrectAnswers = totalQuestions - correctAnswers;
      final pointsEarned = correctAnswers * 10;
      
      final result = QuizResult(
        categoryId: currentState.categoryId,
        categoryName: currentState.categoryName,
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
        incorrectAnswers: incorrectAnswers,
        pointsEarned: pointsEarned,
        completedAt: DateTime.now(),
      );
      
      // Save quiz result
      await saveQuizResult(SaveQuizResultParams(result: result));
      
      // Update category progress
      // Get current category and increment completed quizzes
      await updateCategoryProgress(
        UpdateCategoryProgressParams(
          categoryId: currentState.categoryId,
          completedQuizzes: 1, // This should be fetched and incremented
        ),
      );
      
      // Check if emitter is still active before emitting
      if (!emit.isDone) {
        emit(QuizCompleted(result: result));
      }
    }
  }

  void _onResetQuiz(
    ResetQuizEvent event,
    Emitter<QuizState> emit,
  ) {
    emit(QuizInitial());
  }
}

