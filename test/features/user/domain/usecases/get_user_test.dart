import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_learning/core/error/failures.dart';
import 'package:quiz_learning/core/usecases/usecase.dart';
import 'package:quiz_learning/features/user/domain/entities/user.dart';
import 'package:quiz_learning/features/user/domain/repositories/user_repository.dart';
import 'package:quiz_learning/features/user/domain/usecases/get_user.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<Either<Failure, User>> getUser() async {
    return const Right(User(
      id: '1',
      name: 'Test User',
      imageUrl: 'https://test.com/image.jpg',
      rank: 42,
      totalScore: 100,
      quizzesTaken: 5,
      totalQuizzes: 50,
    ));
  }

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateUserProgress({
    required int quizzesTaken,
    required int scoreToAdd,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  late GetUser usecase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = GetUser(mockRepository);
  });

  test('should get user from the repository', () async {
    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Should not return failure'),
      (user) {
        expect(user.name, 'Test User');
        expect(user.rank, 42);
        expect(user.totalScore, 100);
      },
    );
  });
}

