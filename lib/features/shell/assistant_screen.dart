import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../data/mock_shell.dart';
import '../../shared/ui_kit.dart';

/// "Your Assistant" — local rule-based chat (no backend, per the brief).
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _input = TextEditingController();
  final _messages = <(bool, String)>[
    (false, 'Hi $consultantName! I\'m your Oriflame assistant. Ask me about '
        'captions, sharing, sales, or what\'s trending. ✨'),
  ];

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _messages.add((true, text));
      _messages.add((false, assistantReply(text)));
      _input.clear();
    });
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColors.darkBg : AppColors.surface;
    final ink = dark ? Colors.white : AppColors.ink;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('AI',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 8),
            Text('Your Assistant', style: TextStyle(color: ink)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final (fromMe, text) in _messages)
                  Align(
                    alignment:
                        fromMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 11),
                      constraints: const BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        gradient: fromMe ? AppColors.heroGradient : null,
                        color: fromMe
                            ? null
                            : (dark ? AppColors.darkCard : AppColors.surfaceCard),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 12,
                              offset: Offset(0, 3)),
                        ],
                      ),
                      child: Text(text,
                          style: TextStyle(
                              height: 1.35,
                              color: fromMe
                                  ? Colors.white
                                  : dark
                                      ? Colors.white
                                      : AppColors.ink)),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: SoftCard(
                      padding: EdgeInsets.zero,
                      radius: 24,
                      child: TextField(
                        controller: _input,
                        onSubmitted: (_) => _send(),
                        decoration: const InputDecoration(
                          hintText: 'Ask your assistant…',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _SendButton(onTap: _send),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatefulWidget {
  const _SendButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1.0,
        duration: Motion.fast,
        curve: Motion.spring,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: AppColors.brandGreen.withValues(alpha: .4),
                  blurRadius: 10),
            ],
          ),
          child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
