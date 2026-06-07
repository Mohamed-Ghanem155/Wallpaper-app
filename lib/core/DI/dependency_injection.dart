import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:wallpaper/core/networking/api_constants.dart';
import 'package:wallpaper/core/networking/api_service.dart';
import 'package:wallpaper/features/home/data/repos/home_repo.dart';
import 'package:wallpaper/features/home/logic/home_cubit.dart';
import 'package:wallpaper/features/search/data/repos/search_repo.dart';
import 'package:wallpaper/features/search/logic/search_cubit.dart';
import 'package:wallpaper/features/categories/data/repos/categories_repo.dart';
import 'package:wallpaper/features/categories/logic/categories_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // Dio setup
  Dio dio = Dio();
  dio.options.headers["Authorization"] = ApiConstants.apiKey;
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  // Home Feature
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  // Search Feature
  getIt.registerLazySingleton<SearchRepo>(() => SearchRepo(getIt()));
  getIt.registerFactory<SearchCubit>(() => SearchCubit(getIt()));

  // Categories Feature
  getIt.registerLazySingleton<CategoriesRepo>(() => CategoriesRepo());
  getIt.registerFactory<CategoriesCubit>(() => CategoriesCubit(getIt()));
}
