import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallpaper/core/networking/api_constants.dart';
import 'package:wallpaper/features/home/data/models/wallpaper_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("search")
  Future<WallpaperResponse> searchWallpapers(
    @Query("query") String query,
    @Query("per_page") int perPage,
  );
}

class WallpaperResponse {
  final List<WallpaperModel> photos;

  WallpaperResponse({required this.photos});

  factory WallpaperResponse.fromJson(Map<String, dynamic> json) {
    return WallpaperResponse(
      photos: (json['photos'] as List)
          .map((e) => WallpaperModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
