import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme.dart';

/// TikTok-style floating action rail — replaces the old full-width share
/// row sitting on the photo. Each icon is its own tiny interaction: heart
/// fills with a bounce, bookmark flips, share glows on press.
class ActionRail extends StatelessWidget {
  const ActionRail({
    super.key,
    required this.mood,
    required this.liked,
    required this.saved,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
  });

  final Color mood;
  final bool liked;
  final bool saved;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RailButton(
          icon: liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: liked ? mood : Colors.white,
          glow: liked,
          bounce: liked,
          onTap: onLike,
          haptic: HapticFeedback.mediumImpact,
        ),
        const SizedBox(height: 22),
        _RailButton(
          icon: Icons.auto_awesome_rounded,
          color: Colors.white,
          onTap: onComment,
          haptic: HapticFeedback.selectionClick,
        ),
        const SizedBox(height: 22),
        _RailButton(
          icon: Icons.send_rounded,
          color: Colors.white,
          onTap: onShare,
          haptic: HapticFeedback.mediumImpact,
        ),
        const SizedBox(height: 22),
        _RailButton(
          icon: saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          color: saved ? AppColors.gold : Colors.white,
          glow: saved,
          onTap: onSave,
          haptic: HapticFeedback.selectionClick,
        ),
      ],
    );
  }
}

class _RailButton extends StatefulWidget {
  const _RailButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.haptic,
    this.glow = false,
    this.bounce = false,
  });

  final IconData icon;
  final Color color;
  final bool glow;
  final bool bounce;
  final VoidCallback onTap;
  final void Function() haptic;

  @override
  State<_RailButton> createState() => _RailButtonState();
}

class _RailButtonState extends State<_RailButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: () {
        widget.haptic();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.78 : (widget.bounce ? 1.15 : 1.0),
        duration: widget.bounce ? Motion.base : Motion.fast,
        curve: Motion.spring,
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.22),
            boxShadow: widget.glow
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: .6),
                      blurRadius: 14,
                    ),
                  ]
                : null,
          ),
          child: Icon(widget.icon, color: widget.color, size: 25),
        ),
      ),
    );
  }
}
