import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system v3 — moved off pink/gold entirely. Deep emerald-teal
/// primary + warm copper accent, cool-neutral surfaces instead of the
/// blush wash. Same token *names* as before (zero-risk swap across every
/// screen); values changed.
abstract class AppColors {
  // Primary — deep emerald teal.
  static const brandGreen = Color(
    0xFF0E7C66,
  ); // primary — buttons, active states
  static const brandGreenLight = Color(0xFF3FAE91); // lighter accent, glows
  static const deepGreen = Color(
    0xFF07463A,
  ); // deepest shade — badges, text-on-light

  // "Ready to share" pill gradient — copper into teal.
  static const pillPink = Color(0xFFC1683B);
  static const pillPurple = Color(0xFF0E7C66);

  static const ink = Color(0xFF1B2422); // near-black w/ cool undertone
  static const greyText = Color(0xFF798581); // secondary text
  static const greyMuted = Color(0xFFD8DEDC); // disabled / track fill

  // Surfaces — cool neutral, not blush-tinted.
  static const surface = Color(0xFFF5F8F7); // scaffold background (light)
  static const surfaceCard = Color(0xFFFFFFFF); // elevated card fill
  static const trackGrey = Color(0xFFEBF1EF);
  static const cream = Color(0xFFF3EADC);
  static const darkBg = Color(0xFF0B1512); // near-black, teal-tinted
  static const darkSurface = Color(0xFF13201C);
  static const darkCard = Color(0xFF1C2E28); // card fill on dark surfaces

  static const scrim = Colors.black26;
  static const gold = Color(0xFFB97A45); // warm copper/bronze accent

  // Same green→gold pairing as the community/camera/search avatar washes,
  // at full strength — replaces the old dark green→deepGreen fill.
  static const heroGradient = LinearGradient(colors: [brandGreen, gold]);
  static const goldGradient = LinearGradient(colors: [gold, Color(0xFF8C5A30)]);

  static const cardShadow = Color(0x1F07463A); // tinted, not flat black

  // Soft neomorphic highlight — paired with cardShadow for a raised,
  // dual-tone card edge instead of a flat single drop shadow.
  static const cardHighlightLight = Color(0x99FFFFFF);
  static const cardHighlightDark = Color(0x0DFFFFFF);
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
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme),
  );
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
    textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
  );
}
