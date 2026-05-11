import 'package:flutter/material.dart';

import 'app_palette.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppPalette.lightBackground,
  colorScheme: const ColorScheme.light(
    primary: AppPalette.primary,
    background: AppPalette.lightBackground,
    surface: AppPalette.lightSurface,
    surfaceVariant: AppPalette.lightCard,
    outline: AppPalette.lightBorder,
  ),
  cardColor: AppPalette.lightCard,
  dividerColor: AppPalette.lightBorder,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppPalette.lightBackground,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppPalette.lightTextPrimary),
    bodyMedium: TextStyle(color: AppPalette.lightTextSecondary),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppPalette.lightSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppPalette.lightBorder),
    ),
  ),
);
