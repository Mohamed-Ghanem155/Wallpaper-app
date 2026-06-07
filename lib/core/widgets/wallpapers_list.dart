import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallpaper/core/routing/routes.dart';
import 'package:wallpaper/features/home/data/models/wallpaper_model.dart';

class WallpapersList extends StatelessWidget {
  final List<WallpaperModel> wallpapers;

  const WallpapersList({super.key, required this.wallpapers});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DynamicHeightGridView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: wallpapers.length,
        crossAxisCount: 2,
        builder: (context, index) {
          final wallpaper = wallpapers[index];
          return GridTile(
            child: GestureDetector(
              onTap: () {
                final imageUrl = wallpaper.src?.portrait ?? "";
                if (imageUrl.isNotEmpty) {
                  context.push(Routes.wallpaperViewScreen, extra: imageUrl);
                }
              },
              child: Hero(
                tag: wallpaper.src?.portrait ?? wallpaper.photographerUrl ?? index.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    wallpaper.src?.portrait ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
