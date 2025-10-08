import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/question.dart';
import '../entities/quiz_category.dart';
import '../entities/quiz_result.dart';

abstract class QuizRepository {
  Future<Either<Failure, List<Question>>> getQuestions({
    required int categoryId,
    required String difficulty,
    required int amount,
  });

  Future<Either<Failure, List<QuizCategory>>> getCategories();

  Future<Either<Failure, void>> saveQuizResult(QuizResult result);

  Future<Either<Failure, void>> updateCategoryProgress({
    required int categoryId,
    required int completedQuizzes,
  });
}
