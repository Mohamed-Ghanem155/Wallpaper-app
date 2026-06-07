import 'package:dartz/dartz.dart';
import 'package:wallpaper/core/networking/api_service.dart';
import 'package:wallpaper/features/home/data/models/wallpaper_model.dart';

class HomeRepo {
  final ApiService _apiService;

  HomeRepo(this._apiService);

  Future<Either<String, List<WallpaperModel>>> getTrendingWallpapers() async {
    try {
      final response = await _apiService.searchWallpapers("egypt tourism attractions", 40);
      return Right(response.photos);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
