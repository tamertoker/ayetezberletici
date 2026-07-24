import 'package:flutter/material.dart';

import '../../core/constants.dart';

/// Kullanıcı ayarlarının değişmez (immutable) durumu.
@immutable
class SettingsState {
  const SettingsState({
    this.reciterId = ApiConstants.defaultReciterId,
    this.translationId = ApiConstants.defaultTranslationId,
    this.themeMode = ThemeMode.system,
    this.showArabic = true,
    this.showTransliteration = true,
    this.showTranslation = true,
    this.repeatCount = 1,
  });

  final String reciterId;
  final String translationId;
  final ThemeMode themeMode;

  /// Okuma ekranında Arapça metnin gösterilmesi.
  final bool showArabic;

  /// Latin okunuşun gösterilmesi.
  final bool showTransliteration;

  /// Mealin gösterilmesi.
  final bool showTranslation;

  /// Bir ayetin arka arkaya kaç kez çalınacağı (1..20).
  final int repeatCount;

  SettingsState copyWith({
    String? reciterId,
    String? translationId,
    ThemeMode? themeMode,
    bool? showArabic,
    bool? showTransliteration,
    bool? showTranslation,
    int? repeatCount,
  }) {
    return SettingsState(
      reciterId: reciterId ?? this.reciterId,
      translationId: translationId ?? this.translationId,
      themeMode: themeMode ?? this.themeMode,
      showArabic: showArabic ?? this.showArabic,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showTranslation: showTranslation ?? this.showTranslation,
      repeatCount: repeatCount ?? this.repeatCount,
    );
  }

  static ThemeMode themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
