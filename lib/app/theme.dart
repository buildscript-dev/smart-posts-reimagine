import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// REDESIGN — deep rose/plum identity replacing the flat mint-green original.
/// Same token *names* as before (zero-risk swap across every screen);
/// completely new values, plus a shared motion system.
abstract class AppColors {
  static const brandGreen = Color(0xFFE8578A); // rose — active states, dots
  static const brandGreenLight = Color(0xFFF0899F); // camera btn, spinners
  static const deepGreen = Color(0xFFB13366); // badges
  static const pillPink = Color(0xFFF0B860); // "Ready to share" gradient L
  static const pillPurple = Color(0xFFE8578A); // "Ready to share" gradient R
  static const ink = Color(0xFF1A1420); // headings (light mode)
  static const greyText = Color(0xFF8B7D91); // inactive tabs
  static const greyMuted = Color(0xFFD8CEDD); // pending checklist steps
  static const trackGrey = Color(0xFFF3EDF6); // progress track
  static const darkBg = Color(0xFF120A15); // dark screens
  static const cream = Color(0xFFFBEFE0); // product thumb bg
  static const scrim = Colors.black26; // frosted overlay panels

  static const gold = Color(0xFFF0B860);
  static const mint = Color(0xFF5FD6B0);
  static const heroGradient =
      LinearGradient(colors: [brandGreen, deepGreen]);
  static const goldGradient =
      LinearGradient(colors: [gold, Color(0xFFE8934A)]);
}

/// Shared motion tokens so every animated widget feels like one system.
abstract class Motion {
  static const fast = Duration(milliseconds: 160);
  static const base = Duration(milliseconds: 280);
  static const slow = Duration(milliseconds: 420);
  static const spring = Cubic(0.34, 1.56, 0.64, 1.0); // slight overshoot
  static const smooth = Curves.easeOutCubic;
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandGreen,
      primary: AppColors.brandGreen,
    ),
    splashFactory: InkSparkle.splashFactory,
  );
  return base.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme));
}

ThemeData buildDarkTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandGreen,
      primary: AppColors.brandGreen,
      brightness: Brightness.dark,
      surface: AppColors.darkBg,
    ),
  );
  return base.copyWith(
      textTheme:
          GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme));
}
