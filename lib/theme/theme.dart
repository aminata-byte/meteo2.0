import 'package:flutter/material.dart';

//theme clair
class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFEAF2F8),
    primaryColor: Colors.blue,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        //fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );

  //theme sombre
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1B2A),
    primaryColor: Colors.blue,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        //fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}