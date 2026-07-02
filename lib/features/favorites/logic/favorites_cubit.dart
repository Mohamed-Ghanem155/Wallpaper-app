import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper/features/favorites/data/favorites_local_data_source.dart';
import 'package:wallpaper/features/favorites/logic/favorites_state.dart';
import 'package:wallpaper/features/home/data/models/wallpaper_model.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesLocalDataSource _dataSource;

  FavoritesCubit(this._dataSource) : super(const FavoritesState.initial());

  void getFavorites() {
    emit(const FavoritesState.loading());
    try {
      final favorites = _dataSource.getFavorites();
      emit(FavoritesState.success(favorites));
    } catch (e) {
      emit(FavoritesState.error(e.toString()));
    }
  }

  Future<void> toggleFavorite(WallpaperModel wallpaper) async {
    try {
      if (_dataSource.isFavorite(wallpaper)) {
        await _dataSource.removeFavorite(wallpaper);
      } else {
        await _dataSource.addFavorite(wallpaper);
      }
      getFavorites(); // Refresh the list
    } catch (e) {
      emit(FavoritesState.error(e.toString()));
    }
  }

  bool isFavorite(WallpaperModel wallpaper) {
    return _dataSource.isFavorite(wallpaper);
  }
}
