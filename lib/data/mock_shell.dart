import 'mock_posts.dart';

// Dummy data for the shell screens, derived from the app's own design world
// (Amanda the consultant, the three Smart Post products, the community).

const consultantName = 'Amanda';
const consultantSince = 'Consultant since 2024';

class DashStat {
  const DashStat(this.label, this.value);
  final String label;
  final String value;
}

const dashStats = [
  DashStat('Posts shared', '12'),
  DashStat('Link clicks', '148'),
  DashStat('Sales', '\$312'),
];

class ChatThread {
  ChatThread(this.name, this.lastMessage, this.time,
      {this.unread = false, List<(bool, String)>? messages})
      : messages = messages ?? [];
  final String name;
  final String lastMessage;
  final String time;
  final bool unread;

  /// (fromMe, text) — mutable so the input field can append locally.
  final List<(bool, String)> messages;
}

final chatThreads = [
  ChatThread('Oriflame Community', 'New Smart Posts are live! 🎉', '21:04',
      unread: true,
      messages: [
        (false, 'Welcome to the community, Amanda! 💚'),
        (false, 'New Smart Posts are live! 🎉'),
      ]),
  ChatThread('Priya S.', 'That lipstick post converted 🔥', '19:48',
      unread: true,
      messages: [
        (false, 'Hey! Which caption did you use?'),
        (true, 'The AI one, barely edited it 😄'),
        (false, 'That lipstick post converted 🔥'),
      ]),
  ChatThread('Maria K.', 'Can you share your referral setup?', 'Tue',
      messages: [
        (false, 'Can you share your referral setup?'),
      ]),
  ChatThread('Oriflame Support', 'Your July commission is confirmed.', 'Mon',
      messages: [
        (false, 'Your July commission is confirmed.'),
      ]),
];

class SearchItem {
  const SearchItem(this.title, this.subtitle, this.kind);
  final String title;
  final String subtitle;
  final String kind; // 'Product' | 'Post' | 'Member'
}

final searchCorpus = [
  const SearchItem('Girodani Gold Lipstick', '\$14.99 · 30% off', 'Product'),
  const SearchItem('Eclat Amour', 'Fragrance', 'Product'),
  const SearchItem('WonderLash Mascara', 'Length & volume', 'Product'),
  for (final p in mockPosts)
    SearchItem('${p.trackTitle} post', p.caption, 'Post'),
  const SearchItem('Priya S.', 'Community member', 'Member'),
  const SearchItem('Maria K.', 'Community member', 'Member'),
  const SearchItem('Oriflame Community', '2.4k members', 'Member'),
  const SearchItem('Oriflame Support', 'Official', 'Member'),
];

/// Tiny rule-based assistant — local only, per the no-backend brief.
String assistantReply(String input) {
  final q = input.toLowerCase();
  if (q.contains('caption')) {
    return 'Try this one from your Smart Posts:\n\n'
        '"${mockPosts[0].caption.split('!').first}!"\n\n'
        'Tap any post\'s caption to edit it before sharing.';
  }
  if (q.contains('sale') || q.contains('earn') || q.contains('commission')) {
    return 'You\'ve made \$312 this month from 148 link clicks. '
        'Your lipstick post converts best — share it again on WhatsApp?';
  }
  if (q.contains('share') || q.contains('post')) {
    return 'You have 3 Smart Posts ready. Swipe through them on the '
        'Smart Post tab and tap a platform icon to share with your '
        'referral link ($referralLink).';
  }
  if (q.contains('trend')) {
    return 'Trending now: Girodani Gold Lipstick (30% off) with '
        '"Bad Habits" by Ed Sheeran. High-converting in the community!';
  }
  return 'I can help with captions, sharing posts, sales stats, and '
      'what\'s trending. What do you want to do?';
}
