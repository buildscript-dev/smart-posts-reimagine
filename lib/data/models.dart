import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.name,
    required this.price,
    required this.discount,
    required this.thumbAsset,
  });

  final String name;
  final String price;
  final String discount;
  final String thumbAsset;
}

class SmartPost {
  const SmartPost({
    required this.imageAsset,
    required this.trackTitle,
    required this.trackArtist,
    required this.caption,
    required this.moodA,
    required this.moodB,
    this.product,
  });

  final String imageAsset;
  final String trackTitle;
  final String trackArtist;
  final String caption;
  final Product? product;

  /// Mood palette pulled from this post's own photo — every post gets its
  /// own accent instead of one flat brand color reused everywhere.
  final Color moodA;
  final Color moodB;

  LinearGradient get moodGradient =>
      LinearGradient(colors: [moodA, moodB]);
}

class SharePlatform {
  const SharePlatform(this.name, this.iconAsset, this.webUrl,
      {this.textParam});

  final String name;
  final String iconAsset;
  final String webUrl;

  /// Query parameter that prefills the share text (wa.me / t.me support it).
  final String? textParam;

  String shareUrl(String? text) {
    if (text == null || textParam == null) return webUrl;
    final sep = webUrl.contains('?') ? '&' : '?';
    return '$webUrl$sep$textParam=${Uri.encodeComponent(text)}';
  }
}
