import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:path_provider/path_provider.dart';

class WallpaperViewScreen extends StatefulWidget {
  final String imageUrl;

  const WallpaperViewScreen({super.key, required this.imageUrl});

  @override
  State<WallpaperViewScreen> createState() => _WallpaperViewScreenState();
}

class _WallpaperViewScreenState extends State<WallpaperViewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _panelCtrl;
  late Animation<Offset> _panelSlide;
  late Animation<double> _panelFade;
  bool _isDownloading = false;
  bool _isSharing = false;
  bool _isSettingWallpaper = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _panelCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _panelSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic));
    _panelFade = CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOut);
    _panelCtrl.forward();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _panelCtrl.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      // Request both storage and photos permissions to cover all Android versions (13+ needs photos)
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.photos,
      ].request();

      if (statuses[Permission.storage] == PermissionStatus.granted ||
          statuses[Permission.photos] == PermissionStatus.granted) {
        return true;
      }
      
      if (statuses[Permission.storage] == PermissionStatus.permanentlyDenied ||
          statuses[Permission.photos] == PermissionStatus.permanentlyDenied) {
        if (!mounted) return false;
        _showSnack('❌ يرجى تفعيل الصلاحيات من الإعدادات', isError: true);
        Future.delayed(const Duration(seconds: 2), () => openAppSettings());
      }
      return false;
    }
    return true;
  }

  Future<void> _downloadImage() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);
    if (!await _requestPermission()) {
      if (mounted) setState(() => _isDownloading = false);
      return;
    }
    try {
      var response = await Dio().get(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/wallpaperhub_${DateTime.now().millisecondsSinceEpoch}.jpg';
      File(filePath).writeAsBytesSync(response.data);
      
      await Gal.putImage(filePath);
      
      if (!mounted) return;
      _showSnack('✅ تم حفظ الصورة في المعرض!');
    } catch (e) {
      if (!mounted) return;
      _showSnack('❌ حدث خطأ أثناء التحميل', isError: true);
    }
    if (mounted) setState(() => _isDownloading = false);
  }

  Future<void> _shareImage() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    if (!await _requestPermission()) {
      if (mounted) setState(() => _isSharing = false);
      return;
    }
    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/shared_wallpaper.jpg';
      await Dio().download(widget.imageUrl, filePath);
      await Share.shareXFiles([XFile(filePath)],
          text: '📸 خلفية رائعة من WallpaperHub!');
    } catch (e) {
      if (!mounted) return;
      _showSnack('❌ فشل المشاركة', isError: true);
    }
    if (mounted) setState(() => _isSharing = false);
  }

  Future<void> _setWallpaper(int location) async {
    if (_isSettingWallpaper) return;
    setState(() => _isSettingWallpaper = true);
    try {
      var response = await Dio().get(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/temp_wallpaper.jpg';
      File(filePath).writeAsBytesSync(response.data);

      bool result = await WallpaperManager.setWallpaperFromFile(filePath, location);
      if (!mounted) return;
      if (result) {
        _showSnack('✅ تم تعيين الخلفية بنجاح!');
      } else {
        _showSnack('❌ فشل تعيين الخلفية', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnack('❌ حدث خطأ أثناء التعيين', isError: true);
    }
    if (mounted) setState(() => _isSettingWallpaper = false);
  }

  void _showSetWallpaperOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'تعيين كخلفية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.home_rounded, color: Colors.white70),
                title: const Text('الشاشة الرئيسية', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperManager.HOME_SCREEN);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_rounded, color: Colors.white70),
                title: const Text('شاشة القفل', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperManager.LOCK_SCREEN);
                },
              ),
              ListTile(
                leading: const Icon(Icons.screen_share_rounded, color: Colors.white70),
                title: const Text('كلتا الشاشتين', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(WallpaperManager.BOTH_SCREEN);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor:
            isError ? Colors.red.shade800 : const Color(0xFF7C5CFC),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen wallpaper with Hero
          Hero(
            tag: widget.imageUrl,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7C5CFC)),
                  ),
                );
              },
            ),
          ),

          // Back button - top left
          Positioned(
            top: 52,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15), width: 1),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom glass action panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _panelFade,
              child: SlideTransition(
                position: _panelSlide,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              label: 'Apply',
                              icon: Icons.wallpaper_rounded,
                              isLoading: _isSettingWallpaper,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE94057), Color(0xFFF27121)],
                              ),
                              onTap: _showSetWallpaperOptions,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ActionButton(
                              label: 'Save',
                              icon: Icons.download_rounded,
                              isLoading: _isDownloading,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7C5CFC), Color(0xFF5A3FC0)],
                              ),
                              onTap: _downloadImage,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ActionButton(
                              label: 'Share',
                              icon: Icons.share_rounded,
                              isLoading: _isSharing,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF5CE1E6), Color(0xFF3BAAB0)],
                              ),
                              onTap: _shareImage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLoading;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          gradient: isLoading ? null : gradient,
          color: isLoading ? Colors.white12 : null,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: gradient.colors.first.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
