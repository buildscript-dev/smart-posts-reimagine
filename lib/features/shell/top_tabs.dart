import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/mock_posts.dart';
import '../../data/mock_shell.dart';
import 'shell.dart';

/// Library: the consultant's saved posts and assets.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.ink;
    return ShellScaffold(
      index: -1,
      topTabIndex: 1,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Your Library',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w600, color: ink)),
          Text('Saved posts, ready to reshare anytime',
              style: TextStyle(fontSize: 13, color: AppColors.greyText)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemCount: mockPosts.length,
            itemBuilder: (context, i) {
              final p = mockPosts[i];
              return GestureDetector(
                onTap: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(p.imageAsset,
                            width: double.infinity, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(p.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: ink)),
                    Text('♫ ${p.trackTitle}',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.greyText)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Communities: joinable groups (local state only).
class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  final _communities = [
    ('Oriflame Community', '2.4k members', true),
    ('Lipstick Lovers', '860 members', false),
    ('Fragrance Fans', '1.1k members', false),
    ('Lash & Brow Club', '540 members', false),
    ('Nordic Beauty Tips', '310 members', false),
  ];

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.ink;
    return ShellScaffold(
      index: -1,
      topTabIndex: 2,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: Text('Communities',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w600, color: ink)),
          ),
          for (var i = 0; i < _communities.length; i++)
            ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    AppColors.brandGreenLight.withValues(alpha: .35),
                child: Text(_communities[i].$1[0],
                    style: const TextStyle(
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.w700)),
              ),
              title: Text(_communities[i].$1,
                  style: TextStyle(fontWeight: FontWeight.w600, color: ink)),
              subtitle: Text(_communities[i].$2,
                  style: TextStyle(color: AppColors.greyText)),
              trailing: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: _communities[i].$3
                      ? AppColors.trackGrey
                      : AppColors.brandGreen,
                  foregroundColor:
                      _communities[i].$3 ? AppColors.greyText : Colors.white,
                ),
                onPressed: () => setState(() => _communities[i] = (
                      _communities[i].$1,
                      _communities[i].$2,
                      !_communities[i].$3,
                    )),
                child: Text(_communities[i].$3 ? 'Joined' : 'Join'),
              ),
            ),
        ],
      ),
    );
  }
}

/// Share&Win: weekly sharing challenge with a leaderboard.
class ShareWinScreen extends StatelessWidget {
  const ShareWinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.ink;
    const shared = 3, goal = 5;
    final leaderboard = [
      ('Priya S.', 7),
      ('$consultantName (you)', shared),
      ('Maria K.', 2),
    ];
    return ShellScaffold(
      index: -1,
      topTabIndex: 3,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Share & Win 🏆',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w600, color: ink)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.brandGreenLight.withValues(alpha: .35),
                AppColors.pillPurple.withValues(alpha: .25),
              ]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly challenge',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.greyText)),
                const SizedBox(height: 4),
                Text('Share $goal Smart Posts, win a Giordani Gold set',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: ink)),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: shared / goal,
                    minHeight: 10,
                    backgroundColor: Colors.white,
                    color: AppColors.brandGreen,
                  ),
                ),
                const SizedBox(height: 6),
                Text('$shared of $goal shared — ${goal - shared} to go!',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.greyText)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Leaderboard',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: ink)),
          const SizedBox(height: 8),
          for (var i = 0; i < leaderboard.length; i++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: i == 0
                    ? const Color(0xFFF3D060)
                    : AppColors.trackGrey,
                child: Text('${i + 1}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink)),
              ),
              title: Text(leaderboard[i].$1,
                  style: TextStyle(
                      color: ink,
                      fontWeight: leaderboard[i].$1.contains('(you)')
                          ? FontWeight.w700
                          : FontWeight.w400)),
              trailing: Text('${leaderboard[i].$2} shares',
                  style: TextStyle(color: AppColors.greyText)),
            ),
        ],
      ),
    );
  }
}
