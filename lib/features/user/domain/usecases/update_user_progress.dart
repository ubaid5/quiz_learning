import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class UpdateUserProgress implements UseCase<void, UpdateUserProgressParams> {
  final UserRepository repository;

  UpdateUserProgress(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserProgressParams params) {
    return repository.updateUserProgress(
      quizzesTaken: params.quizzesTaken,
      scoreToAdd: params.scoreToAdd,
    );
  }
}

class UpdateUserProgressParams {
  final int quizzesTaken;
  final int scoreToAdd;

  const UpdateUserProgressParams({
    required this.quizzesTaken,
    required this.scoreToAdd,
  });
}
