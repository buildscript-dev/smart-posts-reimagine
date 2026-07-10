import 'package:flutter/material.dart';

/// App-wide light/dark switch. ponytail: a ValueNotifier is all this needs —
/// no provider package for one boolean.
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

void toggleTheme() {
  themeMode.value = themeMode.value == ThemeMode.light
      ? ThemeMode.dark
      : ThemeMode.light;
}
