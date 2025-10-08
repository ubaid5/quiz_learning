import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quiz_result.dart';
import '../repositories/quiz_repository.dart';

class SaveQuizResult implements UseCase<void, SaveQuizResultParams> {
  final QuizRepository repository;

  SaveQuizResult(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveQuizResultParams params) {
    return repository.saveQuizResult(params.result);
  }
}

class SaveQuizResultParams {
  final QuizResult result;

  const SaveQuizResultParams({required this.result});
}
