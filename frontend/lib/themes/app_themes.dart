import 'package:flutter/material.dart';

const Color primaryGreen = Color.fromARGB(255, 40, 78, 62);
const Color secondaryYellow = Color(0xFFFFF571);
const Color bgGrey = Color(0xFFF5F5F5);

class AppThemes {
  static final light = ThemeData(
    useMaterial3: true,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: bgGrey,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      primary: primaryGreen,
      secondary: secondaryYellow,
      brightness: Brightness.light,
      surface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),

    cardColor: Colors.white,

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.grey,
    ),

    iconTheme: const IconThemeData(color: Colors.black),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: const Color(0xFF121212),
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      primary: primaryGreen,
      brightness: Brightness.dark,
      surface: const Color(0xFF121212),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    cardColor: const Color(0xFF1E1E1E),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.grey,
    ),

    iconTheme: const IconThemeData(color: Colors.white),
  );
}
