import 'package:flutter/material.dart';

import 'app_palette.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppPalette.darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: AppPalette.primary,
    background: AppPalette.darkBackground,
    surface: AppPalette.darkSurface,
    surfaceVariant: AppPalette.darkCard,
    outline: AppPalette.darkBorder,
  ),
  cardColor: AppPalette.darkCard,
  dividerColor: AppPalette.darkBorder,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppPalette.darkBackground,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppPalette.darkTextPrimary),
    bodyMedium: TextStyle(color: AppPalette.darkTextSecondary),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppPalette.darkSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppPalette.darkBorder),
    ),
  ),
);
