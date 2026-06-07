import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper/features/categories/data/repos/categories_repo.dart';
import 'package:wallpaper/features/categories/logic/categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepo _categoriesRepo;

  CategoriesCubit(this._categoriesRepo) : super(const CategoriesState.initial());

  void loadCategories() {
    final categories = _categoriesRepo.getCategories();
    emit(CategoriesState.loaded(categories));
  }
}
