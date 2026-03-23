import 'package:flutter/material.dart';
import 'package:food_tracker/core/storage/token_storage.dart';
import 'package:food_tracker/modules/auth/screens/login_screen.dart';
import 'package:food_tracker/modules/auth/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) async {
        final token = await TokenStorage.read();
        debugPrint(token);
        final isAuth = token != null;
        final isAuthRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        if (state.matchedLocation == '/'){
          return isAuth ? '/inventory' : '/login';
        }

        if (!isAuth && !isAuthRoute) return '/login';
        if (isAuth && isAuthRoute) return '/inventory';
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/inventory',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: '/scanner',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: '/recipes',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: '/shopping-list',
          builder: (context, state) => const Placeholder(),
        ),
      ],
    );
  }
}
