import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallpaper/features/home/data/models/wallpaper_model.dart';

part 'favorites_state.freezed.dart';

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState.initial() = _Initial;
  const factory FavoritesState.loading() = _Loading;
  const factory FavoritesState.success(List<WallpaperModel> favorites) = _Success;
  const factory FavoritesState.error(String message) = _Error;
}
