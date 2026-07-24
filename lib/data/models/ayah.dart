/// Tek bir ayeti, farklı metin varyantlarıyla birlikte temsil eder.
///
/// Aynı ayet için Arapça metin, Latin okunuş ve meal ayrı edition'lardan
/// gelir; bu model hepsini tek nesnede birleştirir.
class Ayah {
  const Ayah({
    required this.number,
    required this.numberInSurah,
    required this.surahNumber,
    required this.arabicText,
    this.transliteration,
    this.translation,
    this.juz,
    this.page,
  });

  /// Kur'an geneli sıralı ayet numarası (1..6236). Ses URL'i bununla üretilir.
  final int number;

  /// Sure içindeki ayet numarası (1..n).
  final int numberInSurah;

  /// Ait olduğu sure numarası (1..114).
  final int surahNumber;

  /// Arapça metin (Uthmani).
  final String arabicText;

  /// Latin okunuş (transliterasyon). Yoksa null.
  final String? transliteration;

  /// Meal. Yoksa null.
  final String? translation;

  final int? juz;
  final int? page;

  Ayah copyWith({
    String? transliteration,
    String? translation,
  }) {
    return Ayah(
      number: number,
      numberInSurah: numberInSurah,
      surahNumber: surahNumber,
      arabicText: arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      juz: juz,
      page: page,
    );
  }

  /// Arapça edition'ın ayet JSON'undan üretir.
  factory Ayah.fromArabicJson(Map<String, dynamic> json, int surahNumber) {
    return Ayah(
      number: json['number'] as int,
      numberInSurah: json['numberInSurah'] as int,
      surahNumber: surahNumber,
      arabicText: (json['text'] as String? ?? '').trim(),
      juz: json['juz'] as int?,
      page: json['page'] as int?,
    );
  }

  Map<String, dynamic> toCacheJson() => {
        'number': number,
        'numberInSurah': numberInSurah,
        'surahNumber': surahNumber,
        'arabicText': arabicText,
        'transliteration': transliteration,
        'translation': translation,
        'juz': juz,
        'page': page,
      };

  factory Ayah.fromCacheJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'] as int,
      numberInSurah: json['numberInSurah'] as int,
      surahNumber: json['surahNumber'] as int,
      arabicText: json['arabicText'] as String,
      transliteration: json['transliteration'] as String?,
      translation: json['translation'] as String?,
      juz: json['juz'] as int?,
      page: json['page'] as int?,
    );
  }
}
