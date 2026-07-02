import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/features/home/data/models/wallpaper_model.dart';

class FavoritesLocalDataSource {
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'FAVORITES_KEY';

  FavoritesLocalDataSource(this._prefs);

  List<WallpaperModel> getFavorites() {
    final List<String>? favoritesJson = _prefs.getStringList(_favoritesKey);
    if (favoritesJson == null) return [];

    return favoritesJson
        .map((jsonStr) => WallpaperModel.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  Future<void> saveFavorites(List<WallpaperModel> favorites) async {
    final List<String> favoritesJson = favorites
        .map((model) => jsonEncode(model.toJson()))
        .toList();
    await _prefs.setStringList(_favoritesKey, favoritesJson);
  }

  Future<void> addFavorite(WallpaperModel wallpaper) async {
    final favorites = getFavorites();
    // Avoid duplicates by checking the image URL (original or portrait)
    final exists = favorites.any((element) => element.src?.original == wallpaper.src?.original);
    if (!exists) {
      favorites.add(wallpaper);
      await saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(WallpaperModel wallpaper) async {
    final favorites = getFavorites();
    favorites.removeWhere((element) => element.src?.original == wallpaper.src?.original);
    await saveFavorites(favorites);
  }

  bool isFavorite(WallpaperModel wallpaper) {
    final favorites = getFavorites();
    return favorites.any((element) => element.src?.original == wallpaper.src?.original);
  }
}
