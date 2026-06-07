import 'package:json_annotation/json_annotation.dart';

part 'wallpaper_model.g.dart';

@JsonSerializable()
class WallpaperModel {
  @JsonKey(name: 'photographer')
  final String? photographer;
  
  @JsonKey(name: 'photographer_url')
  final String? photographerUrl;
  
  @JsonKey(name: 'photographer_id')
  final dynamic photographerId;
  
  @JsonKey(name: 'src')
  final SrcModel? src;

  WallpaperModel({
    this.photographer,
    this.photographerUrl,
    this.photographerId,
    this.src,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) => _$WallpaperModelFromJson(json);
  Map<String, dynamic> toJson() => _$WallpaperModelToJson(this);
}

@JsonSerializable()
class SrcModel {
  @JsonKey(name: 'original')
  final String? original;
  
  @JsonKey(name: 'small')
  final String? small;
  
  @JsonKey(name: 'portrait')
  final String? portrait;

  SrcModel({
    this.original,
    this.small,
    this.portrait,
  });

  factory SrcModel.fromJson(Map<String, dynamic> json) => _$SrcModelFromJson(json);
  Map<String, dynamic> toJson() => _$SrcModelToJson(this);
}
