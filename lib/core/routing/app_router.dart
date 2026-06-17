import 'package:go_router/go_router.dart';
import 'package:wallpaper/core/routing/routes.dart';
import 'package:wallpaper/core/widgets/shell_screen.dart';
import 'package:wallpaper/features/search/ui/screens/search_screen.dart';
import 'package:wallpaper/features/home/ui/screens/wallpaper_view_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.homeScreen,
    routes: [
      // Shell handles Home + Categories with bottom nav
      GoRoute(
        path: Routes.homeScreen,
        builder: (context, state) => const ShellScreen(),
      ),
      GoRoute(
        path: Routes.searchScreen,
        builder: (context, state) {
          final query = state.extra as String? ?? '';
          return SearchScreen(searchQuery: query);
        },
      ),
      GoRoute(
        path: Routes.wallpaperViewScreen,
        builder: (context, state) {
          final imageUrl = state.extra as String? ?? '';
          return WallpaperViewScreen(imageUrl: imageUrl);
        },
      ),
    ],
  );
}
