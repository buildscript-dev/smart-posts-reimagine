import 'dart:ui';

import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Reused translucent blur panel behind music row / caption / product card.
class FrostedPanel extends StatelessWidget {
  const FrostedPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = 10,
    this.color = AppColors.scrim,
    this.blur = 1.5, // subtle — the photo must stay recognizable behind it
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(padding: padding, color: color, child: child),
      ),
    );
  }
}
