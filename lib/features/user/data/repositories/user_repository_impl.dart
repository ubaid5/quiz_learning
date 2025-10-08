import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    try {
      // Convert User to UserModel and cache it
      // For now, we'll just return success since we handle updates via updateUserProgress
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProgress({
    required int quizzesTaken,
    required int scoreToAdd,
  }) async {
    try {
      await localDataSource.updateUserProgress(
        quizzesTaken: quizzesTaken,
        scoreToAdd: scoreToAdd,
      );
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
