import 'package:go_router/go_router.dart';
import 'package:wallpaper/core/routing/routes.dart';
import 'package:wallpaper/features/home/ui/screens/home_screen.dart';
import 'package:wallpaper/features/categories/ui/screens/categories_screen.dart';
import 'package:wallpaper/features/search/ui/screens/search_screen.dart';
import 'package:wallpaper/features/home/ui/screens/wallpaper_view_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.homeScreen,
    routes: [
      GoRoute(
        path: Routes.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.categoriesScreen,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: Routes.searchScreen,
        builder: (context, state) {
          final query = state.extra as String? ?? "";
          return SearchScreen(searchQuery: query);
        },
      ),
      GoRoute(
        path: Routes.wallpaperViewScreen,
        builder: (context, state) {
          final imageUrl = state.extra as String? ?? "";
          return WallpaperViewScreen(imageUrl: imageUrl);
        },
      ),
    ],
  );
}
