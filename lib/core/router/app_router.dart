import 'package:go_router/go_router.dart';
import '../../screens/home_screen.dart';
import '../../screens/countdown_screen.dart';
import '../../screens/quiz_screen.dart';
import '../../screens/result_screen.dart';
import '../../models/quiz_category_model.dart';
import '../../models/quiz_result_model.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/countdown',
        name: 'countdown',
        builder: (context, state) {
          final category = state.extra as QuizCategoryModel;
          return CountdownScreen(category: category);
        },
      ),
      GoRoute(
        path: '/quiz',
        name: 'quiz',
        builder: (context, state) {
          final category = state.extra as QuizCategoryModel;
          return QuizScreen(category: category);
        },
      ),
      GoRoute(
        path: '/result',
        name: 'result',
        builder: (context, state) {
          final result = state.extra as QuizResultModel;
          return ResultScreen(result: result);
        },
      ),
    ],
  );
}

