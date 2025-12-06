import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle _base(
    double size,
    FontWeight weight, {
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
    );
  }

  // Headings
  static final h1 = _base(32, FontWeight.w700, letterSpacing: -0.5);
  static final h2 = _base(24, FontWeight.w600, letterSpacing: -0.5);
  static final h3 = _base(18, FontWeight.w600);

  // Body
  static final bodyLarge = _base(16, FontWeight.w400);
  static final bodyMedium = _base(15, FontWeight.w400, letterSpacing: 0.2);
  static final bodySmall = _base(14, FontWeight.w400);

  // Buttons
  static final buttonLarge = _base(16, FontWeight.w600, letterSpacing: 0.5);
  static final buttonMedium = _base(15, FontWeight.w600);
  static final buttonSmall = _base(14, FontWeight.w500);

  // Labels
  static final labelMedium = _base(14, FontWeight.w500);

  // Helpers
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);

  static TextStyle withWeight(TextStyle style, FontWeight weight) =>
      style.copyWith(fontWeight: weight);
}