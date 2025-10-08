import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/quiz/data/datasources/quiz_local_data_source.dart';
import '../../features/quiz/data/datasources/quiz_remote_data_source.dart';
import '../../features/quiz/data/repositories/quiz_repository_impl.dart';
import '../../features/quiz/domain/repositories/quiz_repository.dart';
import '../../features/quiz/domain/usecases/get_categories.dart';
import '../../features/quiz/domain/usecases/get_questions.dart';
import '../../features/quiz/domain/usecases/save_quiz_result.dart';
import '../../features/quiz/domain/usecases/update_category_progress.dart';
import '../../features/quiz/presentation/bloc/quiz_bloc.dart';
import '../../features/user/data/datasources/user_local_data_source.dart';
import '../../features/user/data/repositories/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/user/domain/usecases/get_user.dart';
import '../../features/user/domain/usecases/update_user_progress.dart';
import '../../features/user/presentation/bloc/user_bloc.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Quiz
  // Bloc
  sl.registerFactory(
    () => QuizBloc(
      getCategories: sl(),
      getQuestions: sl(),
      saveQuizResult: sl(),
      updateCategoryProgress: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetQuestions(sl()));
  sl.registerLazySingleton(() => SaveQuizResult(sl()));
  sl.registerLazySingleton(() => UpdateCategoryProgress(sl()));

  // Repository
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<QuizLocalDataSource>(
    () => QuizLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Features - User
  // Bloc
  sl.registerFactory(
    () => UserBloc(
      getUser: sl(),
      updateUserProgress: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => UpdateUserProgress(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}

