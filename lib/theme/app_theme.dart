import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF9F9F9),
    cardColor: const Color(0xFFFFFFFF),
    iconTheme: const IconThemeData(color: Colors.black),
    colorScheme: const ColorScheme.light(
      surfaceVariant: Color(0xFFF2F3F5),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: const ColorScheme.dark(
      surfaceVariant: Color(0xFF2C2C2C),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
    ),
  );
}
