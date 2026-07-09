import 'package:flutter/material.dart';

import 'app/theme.dart';
import 'app/theme_controller.dart';
import 'features/loading/building_posts_screen.dart';

void main() => runApp(const BrandieSmartPostsApp());

class BrandieSmartPostsApp extends StatelessWidget {
  const BrandieSmartPostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: 'Oriflame Smart Posts',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: mode,
        home: const BuildingPostsScreen(),
      ),
    );
  }
}
