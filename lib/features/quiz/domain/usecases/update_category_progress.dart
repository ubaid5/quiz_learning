import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/quiz_repository.dart';

class UpdateCategoryProgress implements UseCase<void, UpdateCategoryProgressParams> {
  final QuizRepository repository;

  UpdateCategoryProgress(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateCategoryProgressParams params) {
    return repository.updateCategoryProgress(
      categoryId: params.categoryId,
      completedQuizzes: params.completedQuizzes,
    );
  }
}

class UpdateCategoryProgressParams {
  final int categoryId;
  final int completedQuizzes;

  const UpdateCategoryProgressParams({
    required this.categoryId,
    required this.completedQuizzes,
  });
}
