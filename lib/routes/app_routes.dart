import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/shared/style.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import '../data/cubit/theme/theme_cubit.dart';
import '../ui/pages/main/create_story_page.dart';
import '../ui/pages/main/detail_map_page.dart';
import '../ui/pages/main/detail_story_page.dart';
import '../ui/pages/main/home_page.dart';
import '../ui/pages/login_page.dart';
import '../ui/pages/splash_page.dart';
import '../ui/widgets/set_location_story.dart';

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
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const CreateStoryPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.5, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            routes: [
              GoRoute(
                path: 'set-location',
                name: 'set-location',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    child: const SetLocationStory(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.5, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'detail',
            name: 'detail',
            builder: (context, state) => const DetailStoryPage(),
            routes: [
              GoRoute(
                path: 'detail-map',
                name: 'detail-map',
                pageBuilder: (context, state) => CustomTransitionPage(
                  child: const DetailMapPage(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) =>
                      TurnPageTransition(
                    animation: animation,
                    overleafColor: context.select((ThemeCubit cubit) =>
                            cubit.state.brightness == Brightness.dark)
                        ? whiteColor
                        : blackColor,
                    animationTransitionPoint: 0.5,
                    direction: TurnDirection.leftToRight,
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    debugLogDiagnostics: true,
    routerNeglect: true,
  );
}
