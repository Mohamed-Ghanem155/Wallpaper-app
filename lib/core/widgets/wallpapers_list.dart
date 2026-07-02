import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallpaper/core/routing/routes.dart';
import 'package:wallpaper/features/home/data/models/wallpaper_model.dart';

/// Masonry-style grid used in HomeScreen
class WallpapersGrid extends StatelessWidget {
  final List<WallpaperModel> wallpapers;

  const WallpapersGrid({super.key, required this.wallpapers});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final wallpaper = wallpapers[index];
          final isEven = index % 2 == 0;
          return _WallpaperCard(
            model: wallpaper,
            tall: isEven,
          );
        },
        childCount: wallpapers.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
    );
  }
}

class _WallpaperCard extends StatefulWidget {
  final WallpaperModel model;
  final bool tall;

  const _WallpaperCard({
    required this.model,
    required this.tall,
  });

  @override
  State<_WallpaperCard> createState() => _WallpaperCardState();
}

class _WallpaperCardState extends State<_WallpaperCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _scaleCtrl;
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.reverse(),
      onTapUp: (_) {
        _scaleCtrl.forward();
        if (widget.model.src?.portrait != null) {
          context.push(Routes.wallpaperViewScreen, extra: widget.model);
        }
      },
      onTapCancel: () => _scaleCtrl.forward(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.network(
                widget.model.src?.portrait ?? '',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: const Color(0xFF1E1E2E),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7C5CFC),
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stack) => Container(
                  color: const Color(0xFF1E1E2E),
                  child: const Icon(Icons.broken_image_outlined,
                      color: Colors.white24),
                ),
              ),
              // Gradient overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 70,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Text(
                    widget.model.photographer ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Legacy WallpapersList kept for backward compat
class WallpapersList extends StatelessWidget {
  final List<WallpaperModel> wallpapers;

  const WallpapersList({super.key, required this.wallpapers});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: wallpapers.length,
      itemBuilder: (context, index) {
        final wallpaper = wallpapers[index];
        return _WallpaperCard(
          model: wallpaper,
          tall: index % 2 == 0,
        );
      },
    );
  }
}
