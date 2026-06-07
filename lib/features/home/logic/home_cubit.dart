import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper/features/home/data/repos/home_repo.dart';
import 'package:wallpaper/features/home/logic/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(const HomeState.initial());

  void getTrendingWallpapers() async {
    emit(const HomeState.loading());
    final result = await _homeRepo.getTrendingWallpapers();
    result.fold(
      (error) => emit(HomeState.error(error)),
      (wallpapers) => emit(HomeState.success(wallpapers)),
    );
  }
}
