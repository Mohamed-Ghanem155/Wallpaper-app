import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallpaper/features/home/data/models/wallpaper_model.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.success(List<WallpaperModel> wallpapers) = _Success;
  const factory HomeState.error(String message) = _Error;
}
