/// Uygulama genelinde kullanılan sabitler.
///
/// Veri kaynağı: Al Quran Cloud (https://alquran.cloud/api) ve
/// islamic.network CDN. Ücretsiz, kayıt/anahtar gerektirmez.
class ApiConstants {
  ApiConstants._();

  /// Al Quran Cloud REST API taban adresi.
  static const String apiBaseUrl = 'https://api.alquran.cloud/v1';

  /// Ayet ses dosyalarının servis edildiği CDN taban adresi.
  /// Kalıp: `$audioCdnBase/$bitrate/$edition/$globalAyahNumber.mp3`
  static const String audioCdnBase =
      'https://cdn.islamic.network/quran/audio';

  /// Varsayılan ses bit hızı (kbps). 128 / 64 / 32 desteklenir.
  static const int defaultBitrate = 128;

  /// Varsayılan okuyucu (edition kimliği): Mishary Rashid Alafasy.
  static const String defaultReciterId = 'ar.alafasy';

  /// Arapça metin edition kimliği (Uthmani hattı).
  static const String arabicEditionId = 'quran-uthmani';

  /// Latin okunuş (transliterasyon) edition kimliği.
  static const String transliterationEditionId = 'en.transliteration';

  /// Varsayılan meal edition kimliği (Türkçe — Diyanet İşleri).
  static const String defaultTranslationId = 'tr.diyanet';
}

/// Kur'an geneline dair değişmez sayısal bilgiler.
class QuranConstants {
  QuranConstants._();

  /// Toplam sure sayısı.
  static const int surahCount = 114;

  /// Toplam ayet sayısı (besmeleler hariç, standart sayım).
  static const int totalAyahCount = 6236;
}

/// [shared_preferences] için ayar anahtarları.
class PrefKeys {
  PrefKeys._();

  static const String reciterId = 'settings.reciterId';
  static const String translationId = 'settings.translationId';
  static const String themeMode = 'settings.themeMode';
  static const String showArabic = 'settings.showArabic';
  static const String showTransliteration = 'settings.showTransliteration';
  static const String showTranslation = 'settings.showTranslation';
  static const String repeatCount = 'settings.repeatCount';
}
