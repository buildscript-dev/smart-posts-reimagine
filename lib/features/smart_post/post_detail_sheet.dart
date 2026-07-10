import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../data/models.dart';
import 'widgets/post_overlays.dart';

/// The full post — caption and music — lives here instead of permanently on
/// the photo. Drag up for more, drag down to dismiss; the photo stays fully
/// visible until the reader actually wants this.
Future<void> showPostDetailSheet(
  BuildContext context, {
  required SmartPost post,
  required int index,
  required VoidCallback onEditCaption,
}) {
  HapticFeedback.lightImpact();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.34,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        final ink = dark ? Colors.white : AppColors.ink;
        return Container(
          decoration: BoxDecoration(
            color: dark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.greyMuted,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) =>
                          post.moodGradient.createShader(rect),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Post details',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: ink,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: [
                    _GlassPanel(child: MusicRow(post: post)),
                    const SizedBox(height: 12),
                    _GlassPanel(
                      child: CaptionBlock(
                        post: post,
                        index: index,
                        onEdit: () {
                          Navigator.of(context).pop();
                          onEditCaption();
                        },
                        alwaysExpanded: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// Same soft brand gradient wash as the Communities earn cards — one shared
/// "glass" look across the app's info surfaces.
class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandGreen.withValues(alpha: dark ? .22 : .14),
            AppColors.gold.withValues(alpha: dark ? .16 : .10),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brandGreen.withValues(alpha: .14)),
      ),
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}
