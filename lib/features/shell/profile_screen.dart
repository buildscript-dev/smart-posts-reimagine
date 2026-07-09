import 'dart:io';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../app/theme_controller.dart';
import '../../data/gallery_store.dart';
import '../../data/mock_posts.dart';
import '../../data/mock_shell.dart';
import 'shell.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<File> _shots = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final shots = await GalleryStore.list();
    if (mounted) setState(() => _shots = shots);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? Colors.white : AppColors.ink;
    // Gallery = camera shots (newest first) + the 3 post images as seed.
    final tiles = <ImageProvider>[
      for (final f in _shots) FileImage(f),
      for (final p in mockPosts) AssetImage(p.imageAsset),
    ];
    return ShellScaffold(
      index: tabProfile,
      onCameraReturn: _load,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(consultantName,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: ink)),
                    Text(consultantSince,
                        style: TextStyle(
                            fontSize: 13, color: AppColors.greyText)),
                    Text('Referral: $referralCode',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.brandGreen)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final s in dashStats)
                Column(
                  children: [
                    Text(s.value,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: ink)),
                    Text(s.label,
                        style: TextStyle(
                            fontSize: 12, color: AppColors.greyText)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Dark mode', style: TextStyle(color: ink)),
            secondary: Icon(dark ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.brandGreen),
            activeThumbColor: AppColors.brandGreen,
            value: dark,
            onChanged: (_) => toggleTheme(),
          ),
          const SizedBox(height: 6),
          Text('Gallery',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: ink)),
          const SizedBox(height: 4),
          Text('Camera shots land here automatically',
              style: TextStyle(fontSize: 12, color: AppColors.greyText)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: tiles.length,
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => _PhotoViewer(image: tiles[i]))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(image: tiles[i], fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoViewer extends StatelessWidget {
  const _PhotoViewer({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: InteractiveViewer(child: Image(image: image)),
        ),
      ),
    );
  }
}
