import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Configuration du router avec garde d'authentification.
///
/// [isAuthenticated] doit retourner true si un token d'accès valide est présent.
class AppRouter {
  static GoRouter createRouter({required bool Function() isAuthenticated}) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final loggingIn = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';
        if (!isAuthenticated() && !loggingIn) return '/login';
        if (isAuthenticated() && loggingIn) return '/courses';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const _PlaceholderScreen('Login'),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const _PlaceholderScreen('Register'),
        ),
        GoRoute(
          path: '/courses',
          builder: (context, state) => const _PlaceholderScreen('Courses'),
        ),
      ],
    );
  }
}

/// Écran de placeholder temporaire, à remplacer par les vrais écrans.
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — à implémenter')),
    );
  }
}
