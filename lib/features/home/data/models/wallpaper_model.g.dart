// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallpaperModel _$WallpaperModelFromJson(Map<String, dynamic> json) =>
    WallpaperModel(
      photographer: json['photographer'] as String?,
      photographerUrl: json['photographer_url'] as String?,
      photographerId: json['photographer_id'],
      src: json['src'] == null
          ? null
          : SrcModel.fromJson(json['src'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WallpaperModelToJson(WallpaperModel instance) =>
    <String, dynamic>{
      'photographer': instance.photographer,
      'photographer_url': instance.photographerUrl,
      'photographer_id': instance.photographerId,
      'src': instance.src,
    };

SrcModel _$SrcModelFromJson(Map<String, dynamic> json) => SrcModel(
  original: json['original'] as String?,
  small: json['small'] as String?,
  portrait: json['portrait'] as String?,
);

Map<String, dynamic> _$SrcModelToJson(SrcModel instance) => <String, dynamic>{
  'original': instance.original,
  'small': instance.small,
  'portrait': instance.portrait,
};
