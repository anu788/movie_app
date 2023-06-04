import 'package:flutter/material.dart';
import 'package:yolo_movies_app/services/size_config.dart';

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
        headlineLarge: TextStyle(
          fontSize: 20.withTextFactor,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 16.withTextFactor,
          fontWeight: FontWeight.bold,
          color: seedColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 14.withTextFactor,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayLarge: TextStyle(
          fontSize: 12.withTextFactor,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 12.withTextFactor,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: 10.withTextFactor,
          fontWeight: FontWeight.w500,
          color: seedColor,
        ),
      );
}
