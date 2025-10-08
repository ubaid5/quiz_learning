import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUser();

  Future<Either<Failure, void>> updateUser(User user);

  Future<Either<Failure, void>> updateUserProgress({
    required int quizzesTaken,
    required int scoreToAdd,
  });
}
