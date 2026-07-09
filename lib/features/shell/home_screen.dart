import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/mock_posts.dart';
import '../../data/mock_shell.dart';
import 'shell.dart';

/// Consultant dashboard: greeting, stats, trending products, recent posts.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.ink;
    return ShellScaffold(
      index: tabHome,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Hi $consultantName 👋',
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w600, color: ink)),
          Text('Here\'s how your sharing is going',
              style: TextStyle(fontSize: 14, color: AppColors.greyText)),
          const SizedBox(height: 18),
          Row(
            children: [
              for (final s in dashStats) ...[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.brandGreenLight.withValues(alpha: .18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(s.value,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepGreen)),
                        const SizedBox(height: 2),
                        Text(s.label,
                            style: TextStyle(
                                fontSize: 12, color: AppColors.greyText)),
                      ],
                    ),
                  ),
                ),
                if (s != dashStats.last) const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 26),
          Text('Trending products',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: ink)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final item in searchCorpus.where(
                    (s) => s.kind == 'Product'))
                  Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cream.withValues(alpha: .55),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.trending_up,
                            color: AppColors.deepGreen),
                        const Spacer(),
                        Text(item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink)),
                        Text(item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, color: AppColors.greyText)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text('Your recent Smart Posts',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: ink)),
          const SizedBox(height: 12),
          for (final p in mockPosts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(p.imageAsset,
                    width: 52, height: 52, fit: BoxFit.cover),
              ),
              title: Text(p.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: ink)),
              subtitle: Text('♫ ${p.trackTitle} · ${p.trackArtist}',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.greyText)),
              trailing: const Icon(Icons.chevron_right,
                  color: AppColors.greyMuted),
              onTap: () =>
                  Navigator.of(context).popUntil((r) => r.isFirst),
            ),
        ],
      ),
    );
  }
}
