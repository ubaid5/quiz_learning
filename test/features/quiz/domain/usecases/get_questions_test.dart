import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_learning/core/error/failures.dart';
import 'package:quiz_learning/features/quiz/domain/entities/question.dart';
import 'package:quiz_learning/features/quiz/domain/entities/quiz_category.dart';
import 'package:quiz_learning/features/quiz/domain/entities/quiz_result.dart';
import 'package:quiz_learning/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:quiz_learning/features/quiz/domain/usecases/get_questions.dart';

class MockQuizRepository implements QuizRepository {
  @override
  Future<Either<Failure, List<Question>>> getQuestions({
    required int categoryId,
    required String difficulty,
    required int amount,
  }) async {
    return Right([
      const Question(
        question: 'Test Question',
        type: QuestionType.multiple,
        options: ['A', 'B', 'C', 'D'],
        correctAnswer: 'A',
        difficulty: 'easy',
        category: 'General Knowledge',
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<QuizCategory>>> getCategories() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> saveQuizResult(QuizResult result) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateCategoryProgress({
    required int categoryId,
    required int completedQuizzes,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  late GetQuestions usecase;
  late MockQuizRepository mockRepository;

  setUp(() {
    mockRepository = MockQuizRepository();
    usecase = GetQuestions(mockRepository);
  });

  test('should get questions from the repository', () async {
    // Arrange
    const params = GetQuestionsParams(
      categoryId: 9,
      difficulty: 'easy',
      amount: 10,
    );

    // Act
    final result = await usecase(params);

    // Assert
    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Should not return failure'),
      (questions) {
        expect(questions.length, 1);
        expect(questions[0].question, 'Test Question');
      },
    );
  });
}

