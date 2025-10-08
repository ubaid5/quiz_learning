import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/question.dart';
import '../repositories/quiz_repository.dart';

class GetQuestions implements UseCase<List<Question>, GetQuestionsParams> {
  final QuizRepository repository;

  GetQuestions(this.repository);

  @override
  Future<Either<Failure, List<Question>>> call(GetQuestionsParams params) {
    return repository.getQuestions(
      categoryId: params.categoryId,
      difficulty: params.difficulty,
      amount: params.amount,
    );
  }
}

class GetQuestionsParams {
  final int categoryId;
  final String difficulty;
  final int amount;

  const GetQuestionsParams({
    required this.categoryId,
    required this.difficulty,
    required this.amount,
  });
}
