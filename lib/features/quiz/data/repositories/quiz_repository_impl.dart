import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_category.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_local_data_source.dart';
import '../datasources/quiz_remote_data_source.dart';
import '../models/quiz_result_model.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;
  final QuizLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  QuizRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Question>>> getQuestions({
    required int categoryId,
    required String difficulty,
    required int amount,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final questions = await remoteDataSource.getQuestions(
          categoryId: categoryId,
          difficulty: difficulty,
          amount: amount,
        );
        return Right(questions);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<QuizCategory>>> getCategories() async {
    try {
      final categories = await localDataSource.getCachedCategories();
      return Right(categories);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveQuizResult(QuizResult result) async {
    try {
      final resultModel = QuizResultModel(
        categoryId: result.categoryId,
        categoryName: result.categoryName,
        totalQuestions: result.totalQuestions,
        correctAnswers: result.correctAnswers,
        incorrectAnswers: result.incorrectAnswers,
        pointsEarned: result.pointsEarned,
        completedAt: result.completedAt,
      );
      await localDataSource.saveQuizResult(resultModel);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateCategoryProgress({
    required int categoryId,
    required int completedQuizzes,
  }) async {
    try {
      await localDataSource.updateCategoryProgress(
        categoryId: categoryId,
        completedQuizzes: completedQuizzes,
      );
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
