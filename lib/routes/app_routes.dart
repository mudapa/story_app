import 'package:go_router/go_router.dart';

import '../ui/pages/main/create_story_page.dart';
import '../ui/pages/main/detail_story_page.dart';
import '../ui/pages/main/home_page.dart';
import '../ui/pages/login_page.dart';
import '../ui/pages/splash_page.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'create',
            builder: (context, state) => const CreateStoryPage(),
          ),
          GoRoute(
            path: 'detail',
            name: 'detail',
            builder: (context, state) => const DetailStoryPage(),
          ),
        ],
      ),
    ],
    debugLogDiagnostics: true,
    routerNeglect: true,
  );
}
