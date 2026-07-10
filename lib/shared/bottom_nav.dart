import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/theme.dart';

/// Redesigned floating nav — active icon pops into a gradient pill with a
/// spring bounce; press states scale down with haptic feedback.
class AppBottomNav extends StatefulWidget {
  const AppBottomNav({
    super.key,
    this.color = Colors.white,
    this.onTap,
    this.activeIndex,
  });

  final Color color;
  final void Function(int index)? onTap;
  final int? activeIndex;

  static const icons = [
    Icons.rocket_launch_rounded,
    Icons.search_rounded,
    Icons.home_rounded,
    Icons.chat_bubble_rounded,
    Icons.person_rounded,
  ];

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  int? _pressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < AppBottomNav.icons.length; i++)
                _NavIcon(
                  icon: AppBottomNav.icons[i],
                  active: widget.activeIndex == i,
                  pressed: _pressed == i,
                  color: widget.color,
                  onTapDown: () => setState(() => _pressed = i),
                  onTapUp: () => setState(() => _pressed = null),
                  onTap: widget.onTap == null
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          widget.onTap!(i);
                        },
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 4,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: .8),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.active,
    required this.pressed,
    required this.color,
    required this.onTapDown,
    required this.onTapUp,
    this.onTap,
  });

  final IconData icon;
  final bool active;
  final bool pressed;
  final Color color;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onTapDown(),
      onTapCancel: onTapUp,
      onTapUp: (_) => onTapUp(),
      onTap: onTap,
      child: AnimatedScale(
        scale: pressed ? 0.82 : 1.0,
        duration: Motion.fast,
        curve: Motion.spring,
        child: AnimatedContainer(
          duration: Motion.base,
          curve: Motion.smooth,
          padding: EdgeInsets.symmetric(
            horizontal: active ? 18 : 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            gradient: active ? AppColors.heroGradient : null,
            borderRadius: BorderRadius.circular(20),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.brandGreen.withValues(alpha: .5),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: active ? Colors.white : color,
            size: active ? 24 : 26,
          ),
        ),
      ),
    );
  }
}
