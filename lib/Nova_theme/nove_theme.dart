import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NovaColors {
  static const background = Color(0xFFF7F8F2);
  static const lime = Color(0xFFC8F560);
  static const navy = Color(0xFF0F1B3D);
  static const slate = Color(0xFF4A5A7A);
}

final ThemeData novaTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: NovaColors.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: NovaColors.lime,
    primary: NovaColors.lime,
    onPrimary: NovaColors.navy,
    surface: NovaColors.background,
    onSurface: NovaColors.navy,
  ),
  // Plus Jakarta Sans is the closest match to the design's font
  textTheme: TextTheme(
    displaySmall: GoogleFonts.plusJakartaSans(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      height: 1.08,
      letterSpacing: -1.2,
      color: NovaColors.navy,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.6,
      color: NovaColors.slate,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: NovaColors.lime,
      foregroundColor: NovaColors.navy,
      elevation: 0,
      minimumSize: const Size.fromHeight(52),
      shape: const StadiumBorder(),
      textStyle: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
    ),
  ),
);