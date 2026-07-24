import 'package:flutter/material.dart';

/// Uygulamanın renk paleti.
///
/// İlham: sakin, manevi bir his veren zümrüt-yeşil ve altın tonları.
class AppColors {
  AppColors._();

  // Ana marka rengi (zümrüt yeşili)
  static const Color primary = Color(0xFF1F6E5C);
  static const Color primaryDark = Color(0xFF14483C);
  static const Color primaryLight = Color(0xFF3E9E86);

  // Vurgu (altın)
  static const Color accent = Color(0xFFC9A34E);
  static const Color accentLight = Color(0xFFE3C782);

  // Açık tema yüzeyleri
  static const Color lightBackground = Color(0xFFF7F4EC);
  static const Color lightSurface = Color(0xFFFFFDF8);
  static const Color lightOnSurface = Color(0xFF1D2723);

  // Koyu tema yüzeyleri
  static const Color darkBackground = Color(0xFF0E1613);
  static const Color darkSurface = Color(0xFF16211D);
  static const Color darkOnSurface = Color(0xFFECEFEC);

  // Durum renkleri
  static const Color success = Color(0xFF2E9E5B);
  static const Color muted = Color(0xFF8A968F);
}
