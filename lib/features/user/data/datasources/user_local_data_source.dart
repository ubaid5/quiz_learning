import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  /// Gets cached user from SharedPreferences
  /// Throws [CacheException] if no cached data is found
  Future<UserModel> getCachedUser();

  /// Caches user to SharedPreferences
  Future<void> cacheUser(UserModel user);

  /// Updates user progress
  Future<void> updateUserProgress({
    required int quizzesTaken,
    required int scoreToAdd,
  });
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String userKey = 'CACHED_USER';

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getCachedUser() async {
    final jsonString = sharedPreferences.getString(userKey);
    
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    } else {
      // Return default user if no cache exists
      final defaultUser = UserModel.defaultUser;
      await cacheUser(defaultUser);
      return defaultUser;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(userKey, json.encode(user.toJson()));
  }

  @override
  Future<void> updateUserProgress({
    required int quizzesTaken,
    required int scoreToAdd,
  }) async {
    final user = await getCachedUser();
    final updatedUser = UserModel(
      id: user.id,
      name: user.name,
      imageUrl: user.imageUrl,
      rank: user.rank,
      totalScore: user.totalScore + scoreToAdd,
      quizzesTaken: quizzesTaken,
      totalQuizzes: user.totalQuizzes,
    );
    
    await cacheUser(updatedUser);
  }
}
