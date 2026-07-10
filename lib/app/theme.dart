import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system v2 — a deep, editorial berry replaces the candy-bright
/// rose, every screen sits on a soft warm surface instead of stark white,
/// and shadows/radii are unified into single tokens used everywhere.
abstract class AppColors {
  // Primary — deep berry, richer and more premium than a flat "brand pink".
  static const brandGreen = Color(0xFFA61856); // primary — buttons, active states
  static const brandGreenLight = Color(0xFFE0568C); // lighter accent, glows
  static const deepGreen = Color(0xFF6E0F3B); // deepest shade — badges, text-on-light

  static const pillPink = Color(0xFFA61856);
  static const pillPurple = Color(0xFF5B1140);

  static const ink = Color(0xFF241521); // near-black w/ warm undertone
  static const greyText = Color(0xFF8A7A85); // secondary text
  static const greyMuted = Color(0xFFDCD0D6); // disabled / track fill

  // Surfaces — the whole point: nothing sits on stark white anymore.
  static const surface = Color(0xFFFBF6F8); // scaffold background (light)
  static const surfaceCard = Color(0xFFFFFFFF); // elevated card fill
  static const trackGrey = Color(0xFFF1E9ED);
  static const cream = Color(0xFFFBEFE0);
  static const darkBg = Color(0xFF160C13);
  static const darkSurface = Color(0xFF221420);

  static const scrim = Colors.black26;
  static const gold = Color(0xFFCB9B4C); // muted antique gold, not neon

  static const heroGradient = LinearGradient(colors: [brandGreen, deepGreen]);
  static const goldGradient =
      LinearGradient(colors: [gold, Color(0xFFA9772E)]);

  static const cardShadow = Color(0x1F5B1140); // tinted, not flat black
}

/// Shared motion tokens so every animated widget feels like one system.
abstract class Motion {
  static const fast = Duration(milliseconds: 160);
  static const base = Duration(milliseconds: 280);
  static const slow = Duration(milliseconds: 420);
  static const spring = Cubic(0.34, 1.56, 0.64, 1.0); // slight overshoot
  static const smooth = Curves.easeOutCubic;
}

/// Shared shape tokens — one radius scale used by every card/sheet/button.
abstract class Corners {
  static const sm = 12.0;
  static const md = 18.0;
  static const lg = 26.0;
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.surface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandGreen,
      primary: AppColors.brandGreen,
      surface: AppColors.surface,
    ),
    splashFactory: InkSparkle.splashFactory,
    dividerColor: AppColors.trackGrey,
  );
  return base.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme));
}

ThemeData buildDarkTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandGreenLight,
      primary: AppColors.brandGreenLight,
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
    ),
  );
  return base.copyWith(
      textTheme:
          GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme));
}
