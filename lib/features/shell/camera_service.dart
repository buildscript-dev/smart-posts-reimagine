import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/gallery_store.dart';

/// System camera → save shot into the profile gallery.
Future<void> captureToGallery(BuildContext context) async {
  final shot = await ImagePicker().pickImage(source: ImageSource.camera);
  if (shot == null) return; // user cancelled
  await GalleryStore.save(File(shot.path));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Saved to your gallery (Profile → Gallery)')),
  );
}
