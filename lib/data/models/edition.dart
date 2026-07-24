/// Al Quran Cloud "edition" kaydı: bir metin/meal/ses sürümü.
class Edition {
  const Edition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
  });

  /// Benzersiz kimlik (ör. `ar.alafasy`, `tr.diyanet`).
  final String identifier;

  /// ISO dil kodu (ör. `ar`, `tr`, `en`).
  final String language;

  /// Yerel ad.
  final String name;

  /// İngilizce ad.
  final String englishName;

  /// `text` veya `audio`.
  final String format;

  /// `quran`, `translation`, `tafsir`, `versebyverse` vb.
  final String type;

  bool get isAudio => format == 'audio';

  factory Edition.fromJson(Map<String, dynamic> json) {
    return Edition(
      identifier: json['identifier'] as String,
      language: json['language'] as String? ?? '',
      name: json['name'] as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      format: json['format'] as String? ?? 'text',
      type: json['type'] as String? ?? '',
    );
  }
}
