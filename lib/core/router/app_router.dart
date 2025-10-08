import 'package:go_router/go_router.dart';
import '../../features/quiz/domain/entities/quiz_category.dart';
import '../../features/quiz/domain/entities/quiz_result.dart';
import '../../features/quiz/presentation/screens/home_screen.dart';
import '../../features/quiz/presentation/screens/countdown_screen.dart';
import '../../features/quiz/presentation/screens/quiz_screen.dart';
import '../../features/quiz/presentation/screens/result_screen.dart';

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
          final category = state.extra as QuizCategory;
          return CountdownScreen(category: category);
        },
      ),
      GoRoute(
        path: '/quiz',
        name: 'quiz',
        builder: (context, state) {
          final category = state.extra as QuizCategory;
          return QuizScreen(category: category);
        },
      ),
      GoRoute(
        path: '/result',
        name: 'result',
        builder: (context, state) {
          final result = state.extra as QuizResult;
          return ResultScreen(result: result);
        },
      ),
    ],
  );
}

