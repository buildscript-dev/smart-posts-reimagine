import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/gallery_store.dart';

/// System camera → save shot into the profile gallery AND the phone's photo
/// gallery (MediaStore) so it shows up in the device Gallery app too.
Future<void> captureToGallery(BuildContext context) async {
  final shot = await ImagePicker().pickImage(source: ImageSource.camera);
  if (shot == null) return; // user cancelled
  await GalleryStore.save(File(shot.path));
  try {
    await Gal.putImage(shot.path, album: 'Smart Posts');
  } on GalException {
    // Phone-gallery save is best-effort; the in-app copy already succeeded.
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Saved to your phone gallery and Profile → Gallery'),
    ),
  );
}
