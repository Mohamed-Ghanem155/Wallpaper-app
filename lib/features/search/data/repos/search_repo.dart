import 'package:dartz/dartz.dart';
import 'package:wallpaper/core/networking/api_service.dart';
import 'package:wallpaper/features/home/data/models/wallpaper_model.dart';

class SearchRepo {
  final ApiService _apiService;

  SearchRepo(this._apiService);

  Future<Either<String, List<WallpaperModel>>> searchWallpapers(String query) async {
    try {
      final response = await _apiService.searchWallpapers(query, 40);
      return Right(response.photos);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
