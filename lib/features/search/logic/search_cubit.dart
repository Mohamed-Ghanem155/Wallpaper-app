import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper/features/search/data/repos/search_repo.dart';
import 'package:wallpaper/features/search/logic/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo _searchRepo;

  SearchCubit(this._searchRepo) : super(const SearchState.initial());

  void searchWallpapers(String query) async {
    emit(const SearchState.loading());
    final result = await _searchRepo.searchWallpapers(query);
    result.fold(
      (error) => emit(SearchState.error(error)),
      (wallpapers) => emit(SearchState.success(wallpapers)),
    );
  }
}
