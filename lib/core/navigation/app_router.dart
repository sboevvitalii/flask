import 'package:flask/features/presentation/pages/game_page.dart';
import 'package:flask/features/presentation/pages/menu_page.dart';
import 'package:flask/features/presentation/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'menu',
        builder: (context, state) => const MenuPage(),
      ),
      GoRoute(
        path: '/game',
        name: 'game',
        builder: (context, state) => const GamePage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      // GoRoute(path: '/settings', ...),
    ],
  );
}
