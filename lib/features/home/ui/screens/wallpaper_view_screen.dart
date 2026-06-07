import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class WallpaperViewScreen extends StatefulWidget {
  final String imageUrl;

  const WallpaperViewScreen({super.key, required this.imageUrl});

  @override
  State<WallpaperViewScreen> createState() => _WallpaperViewScreenState();
}

class _WallpaperViewScreenState extends State<WallpaperViewScreen> {
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    if (!await _requestPermission()) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ تحتاج إلى إذن لحفظ الملفات!")),
      );
      return;
    }

    try {
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/downloaded_wallpaper.jpg';

      await Dio().download(imageUrl, filePath);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ تم تحميل الصورة بنجاح!")),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ فشل التحميل: $e")),
      );
    }
  }

  Future<void> _shareImage(BuildContext context, String imageUrl) async {
    if (!await _requestPermission()) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ تحتاج إلى إذن للوصول إلى الملفات!")),
      );
      return;
    }

    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/shared_wallpaper.jpg';

      await Dio().download(imageUrl, filePath);

      await Share.shareXFiles([XFile(filePath)], text: "📸 خلفية رائعة من Wallpaper Hub!");
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ فشل المشاركة: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("عرض الخلفية"), elevation: 0.0),
      body: Column(
        children: [
          Expanded(
            child: Hero(
              tag: widget.imageUrl,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _downloadImage(context, widget.imageUrl),
                  icon: const Icon(Icons.download),
                  label: const Text("تحميل"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _shareImage(context, widget.imageUrl),
                  icon: const Icon(Icons.share),
                  label: const Text("مشاركة"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
