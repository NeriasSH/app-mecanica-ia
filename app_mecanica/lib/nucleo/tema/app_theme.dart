import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get claro {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00E5FF), // Cyan neón
      brightness: Brightness.light,
      primary: const Color(0xFF6200EA), // Púrpura brillante
      secondary: const Color(0xFF00E5FF),
      surface: const Color(0xFFF3E5F5),
    );
    return _construirTema(colorScheme);
  }

  static ThemeData get oscuro {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00E5FF), // Cyan neón
      brightness: Brightness.dark,
      primary: const Color(0xFF7C4DFF),
      secondary: const Color(0xFF00B8D4),
      surface: Colors.transparent, // Transparente para dejar ver el GalaxyBackground
    );
    return _construirTema(colorScheme);
  }

  static ThemeData _construirTema(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent, // Transparente para el fondo galáctico
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent, // Que deje ver el gradiente
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white, // Texto en blanco brillante
          minimumSize: const Size.fromHeight(56), // Botones un poco más grandes
          elevation: 8,
          shadowColor: colorScheme.primary.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Más redondeado, estilo cápsula
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: colorScheme.secondary, width: 2),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.secondary.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.secondary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.secondary, width: 2),
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3), // Fondo semitransparente para inputs
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      cardTheme: CardThemeData(
        color: Colors.black.withOpacity(0.4), // Card translúcida
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.secondary.withOpacity(0.2), width: 1),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        labelLarge: TextStyle(color: Colors.white70),
        headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
      ),
    );
  }
}
