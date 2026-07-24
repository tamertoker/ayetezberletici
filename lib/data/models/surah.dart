/// Bir sureyi (Kur'an bölümü) temsil eder.
class Surah {
  const Surah({
    required this.number,
    required this.arabicName,
    required this.turkishName,
    required this.englishName,
    required this.meaning,
    required this.ayahCount,
    required this.revelationType,
  });

  /// 1..114 arası sure numarası.
  final int number;

  /// Arapça sure adı (ör. "الرحمن").
  final String arabicName;

  /// Türkçe/Latin okunuşlu ad (ör. "Rahmân").
  final String turkishName;

  /// İngilizce transliterasyonlu ad (ör. "Ar-Rahman").
  final String englishName;

  /// Anlamı (ör. "Çok Merhametli").
  final String meaning;

  /// Suredeki ayet sayısı.
  final int ayahCount;

  /// İniş yeri: Mekke veya Medine.
  final RevelationType revelationType;

  /// API'den (`/surah`) gelen JSON'dan üretir.
  factory Surah.fromApiJson(Map<String, dynamic> json) {
    final revelation =
        (json['revelationType'] as String?)?.toLowerCase() ?? 'meccan';
    return Surah(
      number: json['number'] as int,
      arabicName: json['name'] as String? ?? '',
      turkishName: json['englishName'] as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      meaning: json['englishNameTranslation'] as String? ?? '',
      ayahCount: json['numberOfAyahs'] as int? ?? 0,
      revelationType: revelation == 'medinan'
          ? RevelationType.medinan
          : RevelationType.meccan,
    );
  }
}

enum RevelationType {
  meccan,
  medinan;

  String get turkishLabel =>
      this == RevelationType.meccan ? 'Mekkî' : 'Medenî';
}
