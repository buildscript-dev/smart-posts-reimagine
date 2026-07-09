import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/mock_shell.dart';
import 'shell.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.ink;
    return ShellScaffold(
      index: tabChat,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: Text('Chats',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w600, color: ink)),
          ),
          for (final t in chatThreads)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.brandGreenLight,
                child: Text(t.name[0],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              title: Text(t.name,
                  style: TextStyle(fontWeight: FontWeight.w600, color: ink)),
              subtitle: Text(t.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.greyText)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(t.time,
                      style: TextStyle(
                          fontSize: 12, color: AppColors.greyText)),
                  if (t.unread)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: AppColors.brandGreen,
                          shape: BoxShape.circle),
                    ),
                ],
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ChatThreadScreen(thread: t))),
            ),
        ],
      ),
    );
  }
}

class ChatThreadScreen extends StatefulWidget {
  const ChatThreadScreen({super.key, required this.thread});

  final ChatThread thread;

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final _input = TextEditingController();

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() {
      widget.thread.messages.add((true, text));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.thread.name),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final (fromMe, text) in widget.thread.messages)
                  Align(
                    alignment:
                        fromMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: fromMe
                            ? AppColors.brandGreen
                            : AppColors.trackGrey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(text,
                          style: TextStyle(
                              color:
                                  fromMe ? Colors.white : AppColors.ink)),
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
                    child: TextField(
                      controller: _input,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Message…',
                        filled: true,
                        fillColor: AppColors.trackGrey.withValues(alpha: .6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _send,
                    style: IconButton.styleFrom(
                        backgroundColor: AppColors.brandGreen),
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
