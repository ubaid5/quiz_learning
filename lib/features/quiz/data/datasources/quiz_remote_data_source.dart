import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/question_model.dart';

abstract class QuizRemoteDataSource {
  /// Fetches questions from the Open Trivia DB API
  /// Throws [ServerException] for all error codes
  Future<List<QuestionModel>> getQuestions({
    required int categoryId,
    required String difficulty,
    required int amount,
  });
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final http.Client client;

  QuizRemoteDataSourceImpl({required this.client});

  @override
  Future<List<QuestionModel>> getQuestions({
    required int categoryId,
    required String difficulty,
    required int amount,
  }) async {
    final url = Uri.parse(
      '${AppConstants.apiBaseUrl}?amount=$amount&category=$categoryId&difficulty=$difficulty',
    );

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['response_code'] == 0) {
          final results = jsonResponse['results'] as List;
          return results
              .map((question) => QuestionModel.fromJson(question))
              .toList();
        } else {
          throw ServerException(
            message: 'Failed to fetch questions: ${jsonResponse['response_code']}',
          );
        }
      } else {
        throw ServerException(
          message: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Network error: ${e.toString()}');
    }
  }
}
