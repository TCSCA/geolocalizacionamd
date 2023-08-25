import 'package:flutter/material.dart';

class AppThemes {
  static const String fontTitlesHighlight = 'TitlesHighlight';
  static const String fontTextsParagraphs = 'TextsParagraphs';
  static const double textSizeTitle = 20.0;
  static const double textSizeLarge = 16.0;
  static const double textSizeMedium = 15.0;
  static const double textSizeSmall = 14.0;

  ThemeData themedata = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        primary: const Color(0xff2B5178),
        onPrimary: Colors.white,
        secondary: const Color(0xffD84835),
        onSecondary: Colors.white,
      ),
      textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: textSizeTitle,
              fontFamily: fontTextsParagraphs,
              color: Colors.white),
          titleMedium: TextStyle(
              fontSize: textSizeMedium,
              fontFamily: fontTitlesHighlight,
              color: Colors.white),
          bodyLarge: TextStyle(
              fontSize: textSizeLarge, fontFamily: fontTextsParagraphs),
          labelLarge: TextStyle(
              fontSize: textSizeLarge,
              fontFamily: fontTextsParagraphs,
              color: Colors.white),
          labelMedium: TextStyle(
              fontSize: textSizeMedium,
              fontFamily: fontTextsParagraphs,
              color: Colors.white),
          labelSmall: TextStyle(
              fontSize: textSizeSmall,
              fontFamily: fontTextsParagraphs,
              color: Colors.white)));
}
