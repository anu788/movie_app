import 'package:flutter/material.dart';

// Basic custom theme to predifine required text styles and colors.
class CustomTheme {
  static const Color _primarySeedColor = Colors.black;

  ThemeData get primary => ThemeData(
        primaryColor: _primarySeedColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primarySeedColor,
          primary: _primarySeedColor,
          background: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: _textTheme(_primarySeedColor),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      );

  TextTheme _textTheme(Color seedColor) => TextTheme(
        headlineLarge: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: seedColor,
        ),
        headlineSmall: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: seedColor,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      );
}
