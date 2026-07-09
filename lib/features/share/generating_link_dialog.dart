import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';

/// Figma "Loading animation" sequence — one card, four stages:
/// sales link → clipboard → profile → social media prep.
const _stages = [
  'Generating your sales link..',
  'Copying the caption to clipboard',
  'Saving the content to your profile',
  'Preparing the content for social media',
];

Future<void> showGeneratingLinkDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black26,
    pageBuilder: (_, _, _) => const Material(
        type: MaterialType.transparency, child: _GeneratingLinkDialog()),
  );
}

class _GeneratingLinkDialog extends StatefulWidget {
  const _GeneratingLinkDialog();

  @override
  State<_GeneratingLinkDialog> createState() => _GeneratingLinkDialogState();
}

class _GeneratingLinkDialogState extends State<_GeneratingLinkDialog>
    with SingleTickerProviderStateMixin {
  static const _stageMs = 1100;
  int _stage = 0;
  Timer? _timer;
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: _stageMs),
  )..forward();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: _stageMs), (t) {
      if (_stage >= _stages.length - 1) {
        t.cancel();
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop();
        return;
      }
      HapticFeedback.selectionClick();
      setState(() => _stage++);
      _progress.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: AppColors.brandGreen.withValues(alpha: .25),
                  blurRadius: 30,
                  offset: const Offset(0, 12)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                curve: Curves.linear,
                builder: (context, v, child) =>
                    Transform.rotate(angle: v * 6.28, child: child),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    gradient: AppColors.heroGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome_rounded,
                        color: Colors.white, size: 28),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              AnimatedSwitcher(
                duration: Motion.base,
                transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                        position: Tween(
                                begin: const Offset(0, .3),
                                end: Offset.zero)
                            .animate(anim),
                        child: child)),
                child: Text(_stages[_stage],
                    key: ValueKey(_stage),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink)),
              ),
              const SizedBox(height: 18),
              AnimatedBuilder(
                animation: _progress,
                builder: (_, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _progress.value,
                    minHeight: 9,
                    backgroundColor: AppColors.trackGrey,
                    valueColor: const AlwaysStoppedAnimation(
                        AppColors.brandGreen),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _stages.length; i++)
                    AnimatedContainer(
                      duration: Motion.base,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _stage ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: i <= _stage
                            ? AppColors.brandGreen
                            : AppColors.greyMuted,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
