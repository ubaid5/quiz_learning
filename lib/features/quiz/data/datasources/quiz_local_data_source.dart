import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/quiz_category_model.dart';
import '../models/quiz_result_model.dart';

abstract class QuizLocalDataSource {
  /// Gets cached categories from SharedPreferences
  /// Throws [CacheException] if no cached data is found
  Future<List<QuizCategoryModel>> getCachedCategories();

  /// Caches categories to SharedPreferences
  Future<void> cacheCategories(List<QuizCategoryModel> categories);

  /// Saves quiz result to local storage
  Future<void> saveQuizResult(QuizResultModel result);

  /// Updates category progress
  Future<void> updateCategoryProgress({
    required int categoryId,
    required int completedQuizzes,
  });
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String categoriesKey = 'CACHED_CATEGORIES';
  static const String quizResultsKey = 'QUIZ_RESULTS';

  QuizLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<QuizCategoryModel>> getCachedCategories() async {
    final jsonString = sharedPreferences.getString(categoriesKey);
    
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => QuizCategoryModel.fromJson(json))
          .toList();
    } else {
      // Return default categories if no cache exists
      final defaultCategories = QuizCategoryModel.defaultCategories;
      await cacheCategories(defaultCategories);
      return defaultCategories;
    }
  }

  @override
  Future<void> cacheCategories(List<QuizCategoryModel> categories) async {
    final jsonList = categories.map((category) => category.toJson()).toList();
    await sharedPreferences.setString(categoriesKey, json.encode(jsonList));
  }

  @override
  Future<void> saveQuizResult(QuizResultModel result) async {
    final resultsJson = sharedPreferences.getString(quizResultsKey);
    List<dynamic> results = [];
    
    if (resultsJson != null) {
      results = json.decode(resultsJson);
    }
    
    results.add(result.toJson());
    await sharedPreferences.setString(quizResultsKey, json.encode(results));
  }

  @override
  Future<void> updateCategoryProgress({
    required int categoryId,
    required int completedQuizzes,
  }) async {
    final categories = await getCachedCategories();
    final updatedCategories = categories.map((category) {
      if (category.id == categoryId) {
        return QuizCategoryModel(
          id: category.id,
          name: category.name,
          icon: category.icon,
          difficulty: category.difficulty,
          color: category.color,
          completedQuizzes: completedQuizzes,
          totalQuizzes: category.totalQuizzes,
        );
      }
      return category;
    }).toList();
    
    await cacheCategories(updatedCategories);
  }
}
