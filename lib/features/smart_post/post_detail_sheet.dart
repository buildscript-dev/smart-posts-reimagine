import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../data/mock_posts.dart';
import '../../data/models.dart';
import 'widgets/post_overlays.dart';

/// The full post — caption, music, product, share — lives here instead of
/// permanently on the photo. Drag up for more, drag down to dismiss; the
/// photo stays fully visible until the reader actually wants this.
Future<void> showPostDetailSheet(
  BuildContext context, {
  required SmartPost post,
  required int index,
  required VoidCallback onEditCaption,
  required void Function(SharePlatform) onShare,
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
                    _DarkPanel(
                      mood: post.moodA,
                      child: MusicRow(post: post),
                    ),
                    const SizedBox(height: 12),
                    _DarkPanel(
                      mood: post.moodA,
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
                    if (post.product != null) ...[
                      const SizedBox(height: 12),
                      _DarkPanel(
                        mood: post.moodA,
                        child: ProductCard(
                          product: post.product!,
                          trending: true,
                          onTap: () {},
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    const Text(
                      'Quick share to',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.greyText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        for (final p in sharePlatforms)
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              Navigator.of(context).pop();
                              onShare(p);
                            },
                            child: Image.asset(
                              p.iconAsset,
                              width: 44,
                              height: 44,
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
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

/// Dark rounded panel so the light-mode overlay widgets (built for a photo
/// background) read correctly on the sheet's white surface, tinted with the
/// post's own mood color instead of flat black.
class _DarkPanel extends StatelessWidget {
  const _DarkPanel({required this.child, required this.mood});

  final Widget child;
  final Color mood;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.lerp(mood, Colors.black, 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }
}
