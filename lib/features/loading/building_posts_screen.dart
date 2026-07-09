import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../app/theme_controller.dart';
import '../../shared/bottom_nav.dart';
import '../../shared/oriflame_header.dart';
import '../../shared/tab_row.dart';
import '../smart_post/smart_post_screen.dart';

const _steps = [
  'Preparing popular\ncontent for you',
  'Crafting a caption to\nboost engagement',
  'Adding your personal\nreferral link and code',
  'Finding trending songs on\nother social media',
];

/// Redesign — each completed step gives a light haptic tick, the row slides
/// in with a stagger, and the final "All set!" arrives with a bounce.
class BuildingPostsScreen extends StatefulWidget {
  const BuildingPostsScreen({super.key});

  @override
  State<BuildingPostsScreen> createState() => _BuildingPostsScreenState();
}

class _BuildingPostsScreenState extends State<BuildingPostsScreen> {
  int _done = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1100), (t) {
      HapticFeedback.lightImpact();
      setState(() => _done++);
      if (_done > _steps.length) {
        t.cancel();
        HapticFeedback.mediumImpact();
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, _, _) => const SmartPostScreen(),
            transitionsBuilder: (_, anim, _, child) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(
                    scale: Tween(begin: 0.97, end: 1.0).animate(
                        CurvedAnimation(parent: anim, curve: Motion.smooth)),
                    child: child)),
            transitionDuration: Motion.slow,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? Colors.white : AppColors.ink;
    final allDone = _done >= _steps.length;
    return Scaffold(
      body: GestureDetector(
        onLongPress: () {
          HapticFeedback.heavyImpact();
          toggleTheme();
        },
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            children: [
              if (!dark) ...[
                const OriflameHeader(showAssistant: false),
                const SmartTabRow(),
              ],
              const Spacer(flex: 2),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Motion.slow,
                curve: Motion.smooth,
                builder: (context, v, child) => Opacity(
                    opacity: v,
                    child: Transform.translate(
                        offset: Offset(0, (1 - v) * 16), child: child)),
                child: ShaderMask(
                  shaderCallback: (rect) =>
                      AppColors.heroGradient.createShader(rect),
                  child: Text(
                    'Building personalised\nSmart Posts for you!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        color: dark ? Colors.white : ink),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              for (var i = 0; i < _steps.length; i++) ...[
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Motion.slow,
                  curve: Motion.smooth,
                  builder: (context, v, child) => Opacity(
                      opacity: v,
                      child: Transform.translate(
                          offset: Offset((1 - v) * 24, 0), child: child)),
                  child: _StepRow(
                    label: _steps[i],
                    state: i < _done
                        ? _StepState.done
                        : i == _done
                            ? _StepState.active
                            : _StepState.pending,
                    dark: dark,
                  ),
                ),
                const SizedBox(height: 22),
              ],
              AnimatedScale(
                scale: allDone ? 1 : 0.85,
                duration: Motion.base,
                curve: Motion.spring,
                child: AnimatedOpacity(
                  opacity: allDone ? 1 : 0,
                  duration: Motion.base,
                  child: ShaderMask(
                    shaderCallback: (rect) =>
                        AppColors.goldGradient.createShader(rect),
                    child: const Text('All set! Get ready to share...',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ),
                ),
              ),
              const Spacer(flex: 3),
              AppBottomNav(color: dark ? Colors.white : AppColors.ink),
            ],
          ),
        ),
      ),
    );
  }
}

enum _StepState { pending, active, done }

class _StepRow extends StatelessWidget {
  const _StepRow(
      {required this.label, required this.state, required this.dark});

  final String label;
  final _StepState state;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final active = state == _StepState.active;
    final done = state == _StepState.done;
    final textColor =
        done || active ? (dark ? Colors.white : AppColors.ink) : AppColors.greyMuted;

    Widget indicator;
    switch (state) {
      case _StepState.done:
        indicator = TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Motion.base,
          curve: Motion.spring,
          builder: (context, v, _) => Transform.scale(
            scale: v,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.brandGreen.withValues(alpha: .5),
                      blurRadius: 10),
                ],
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.brandGreen, size: 26),
            ),
          ),
        );
      case _StepState.active:
        indicator = const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
              strokeWidth: 3, color: AppColors.brandGreen),
        );
      case _StepState.pending:
        indicator = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.greyMuted, width: 2.5),
          ),
        );
    }

    return SizedBox(
      width: 320,
      child: Row(
        children: [
          SizedBox(width: 40, child: Center(child: indicator)),
          const SizedBox(width: 14),
          Text(
            label,
            style: TextStyle(
              fontSize: 17,
              height: 1.25,
              color: textColor,
              fontWeight: active || done ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
