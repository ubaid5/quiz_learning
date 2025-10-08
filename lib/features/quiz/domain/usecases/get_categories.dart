import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quiz_category.dart';
import '../repositories/quiz_repository.dart';

class GetCategories implements UseCase<List<QuizCategory>, NoParams> {
  final QuizRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<QuizCategory>>> call(NoParams params) {
    return repository.getCategories();
  }
}
