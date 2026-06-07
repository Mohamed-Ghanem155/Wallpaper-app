import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallpaper/features/categories/data/models/category_model.dart';

part 'categories_state.freezed.dart';

@freezed
class CategoriesState with _$CategoriesState {
  const factory CategoriesState.initial() = _Initial;
  const factory CategoriesState.loaded(List<CategoryModel> categories) = _Loaded;
}
