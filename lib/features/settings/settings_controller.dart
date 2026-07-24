import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_providers.dart';
import '../../core/constants.dart';
import 'settings_state.dart';

/// Ayarları [SharedPreferences] ile kalıcı tutan denetleyici.
class SettingsController extends Notifier<SettingsState> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  SettingsState build() {
    final p = ref.read(sharedPreferencesProvider);
    return SettingsState(
      reciterId: p.getString(PrefKeys.reciterId) ?? ApiConstants.defaultReciterId,
      translationId:
          p.getString(PrefKeys.translationId) ?? ApiConstants.defaultTranslationId,
      themeMode: SettingsState.themeModeFromString(p.getString(PrefKeys.themeMode)),
      showArabic: p.getBool(PrefKeys.showArabic) ?? true,
      showTransliteration: p.getBool(PrefKeys.showTransliteration) ?? true,
      showTranslation: p.getBool(PrefKeys.showTranslation) ?? true,
      repeatCount: p.getInt(PrefKeys.repeatCount) ?? 1,
    );
  }

  Future<void> setReciter(String reciterId) async {
    state = state.copyWith(reciterId: reciterId);
    await _prefs.setString(PrefKeys.reciterId, reciterId);
  }

  Future<void> setTranslation(String translationId) async {
    state = state.copyWith(translationId: translationId);
    await _prefs.setString(PrefKeys.translationId, translationId);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs.setString(
      PrefKeys.themeMode,
      SettingsState.themeModeToString(mode),
    );
  }

  Future<void> setShowArabic(bool value) async {
    state = state.copyWith(showArabic: value);
    await _prefs.setBool(PrefKeys.showArabic, value);
  }

  Future<void> setShowTransliteration(bool value) async {
    state = state.copyWith(showTransliteration: value);
    await _prefs.setBool(PrefKeys.showTransliteration, value);
  }

  Future<void> setShowTranslation(bool value) async {
    state = state.copyWith(showTranslation: value);
    await _prefs.setBool(PrefKeys.showTranslation, value);
  }

  Future<void> setRepeatCount(int value) async {
    final clamped = value.clamp(1, 20);
    state = state.copyWith(repeatCount: clamped);
    await _prefs.setInt(PrefKeys.repeatCount, clamped);
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);
