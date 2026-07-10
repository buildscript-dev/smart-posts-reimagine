import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Camera shots live in `app-docs/gallery/`. Files on disk ARE the store.
class GalleryStore {
  static Future<Directory> _dir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/gallery');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  static Future<File> save(File photo) async {
    final dir = await _dir();
    final name = 'shot_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return photo.copy('${dir.path}/$name');
  }

  static Future<List<File>> list() async {
    final dir = await _dir();
    final files = await dir
        .list()
        .where((e) => e is File && e.path.endsWith('.jpg'))
        .cast<File>()
        .toList();
    files.sort((a, b) => b.path.compareTo(a.path)); // newest first
    return files;
  }

  static Future<void> delete(File photo) async {
    if (await photo.exists()) await photo.delete();
  }
}
