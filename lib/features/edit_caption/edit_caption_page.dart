import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';

/// Edit Caption page (02 Quick share frames): X · title · Save.
/// Designer notes honored: opens WITHOUT keyboard; tapping the caption
/// focuses it and opens the keyboard; Save enables only once text changes.
/// Save pops with the edited text; the feed stores it per post.
class EditCaptionPage extends StatefulWidget {
  const EditCaptionPage({super.key, required this.initialText});

  final String initialText;

  @override
  State<EditCaptionPage> createState() => _EditCaptionPageState();
}

class _EditCaptionPageState extends State<EditCaptionPage> {
  late final TextEditingController _controller;
  late final String _original;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _original = widget.initialText;
    _controller = TextEditingController(text: _original)
      ..addListener(() {
        final dirty = _controller.text != _original;
        if (dirty != _dirty) setState(() => _dirty = dirty);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.ink),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text('Edit Caption',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink)),
                  ),
                  AnimatedScale(
                    scale: _dirty ? 1.0 : 0.94,
                    duration: Motion.base,
                    curve: Motion.spring,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: _dirty ? AppColors.heroGradient : null,
                        boxShadow: _dirty
                            ? [
                                BoxShadow(
                                    color: AppColors.brandGreen
                                        .withValues(alpha: .4),
                                    blurRadius: 10)
                              ]
                            : null,
                      ),
                      child: FilledButton(
                        onPressed: _dirty
                            ? () {
                                HapticFeedback.mediumImpact();
                                Navigator.of(context).pop(_controller.text);
                              }
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          disabledBackgroundColor:
                              AppColors.greyMuted.withValues(alpha: .5),
                          disabledForegroundColor: AppColors.greyText,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                        ),
                        child: const Text('Save',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                // No autofocus: keyboard appears on caption tap (2nd click),
                // matching the annotated Figma flow.
                style: const TextStyle(
                    fontSize: 15, height: 1.45, color: AppColors.ink),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
