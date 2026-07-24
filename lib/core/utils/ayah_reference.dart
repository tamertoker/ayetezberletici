import '../../data/models/surah.dart';
import '../../data/sources/quran_meta.dart';

/// Bir arama sonucu: sure ve (varsa) hedef ayet numarası.
class AyahReference {
  const AyahReference({required this.surah, this.ayahInSurah});

  final Surah surah;

  /// Belirtildiyse gidilecek ayet numarası (1..ayahCount), yoksa null.
  final int? ayahInSurah;
}

/// Serbest metin aramasını sure/ayet referansına çevirir.
///
/// Desteklenen kalıplar:
///  - "55:11", "55 11", "Rahman 11", "Bakara 255"
///  - Sadece sure adı: "Kehf", "yasin"
///  - Sadece sure numarası: "36"
///
/// Türkçe/İngilizce/Arapça adlar diyakritikten bağımsız eşleştirilir.
class AyahSearch {
  const AyahSearch._();

  static List<AyahReference> query(String raw) {
    final input = raw.trim();
    if (input.isEmpty) return const [];

    // Sondaki ayet numarasını ("... 11" ya da "55:11") ayıkla.
    final refMatch =
        RegExp(r'^(.*?)[\s:]+(\d{1,3})$').firstMatch(input);
    String namePart = input;
    int? ayahNumber;
    if (refMatch != null) {
      namePart = refMatch.group(1)!.trim();
      ayahNumber = int.tryParse(refMatch.group(2)!);
    }

    // Tamamı sayıysa: sure numarası (ör. "36") ya da "55:11".
    final numeric = int.tryParse(namePart);
    if (numeric != null && numeric >= 1 && numeric <= QuranMeta.surahs.length) {
      final surah = QuranMeta.byNumber(numeric);
      return [
        AyahReference(
          surah: surah,
          ayahInSurah: _clampAyah(ayahNumber, surah),
        ),
      ];
    }

    // İsimle eşleştir.
    final matches = _matchByName(namePart.isEmpty ? input : namePart);
    return matches
        .map(
          (s) => AyahReference(
            surah: s,
            ayahInSurah: _clampAyah(ayahNumber, s),
          ),
        )
        .toList();
  }

  static int? _clampAyah(int? ayah, Surah surah) {
    if (ayah == null) return null;
    if (ayah < 1) return 1;
    if (ayah > surah.ayahCount) return surah.ayahCount;
    return ayah;
  }

  static List<Surah> _matchByName(String namePart) {
    final needle = _normalize(namePart);
    if (needle.isEmpty) return const [];

    final starts = <Surah>[];
    final contains = <Surah>[];
    for (final surah in QuranMeta.surahs) {
      final haystacks = [
        _normalize(surah.turkishName),
        _normalize(surah.englishName),
        _normalize(surah.meaning),
        surah.arabicName,
      ];
      if (haystacks.any((h) => h == needle || h.startsWith(needle))) {
        starts.add(surah);
      } else if (haystacks.any((h) => h.contains(needle))) {
        contains.add(surah);
      }
    }
    return [...starts, ...contains];
  }

  /// Küçük harfe indirger ve Türkçe diyakritiklerini sadeleştirir.
  static String _normalize(String value) {
    final lower = value.toLowerCase().trim();
    const map = {
      'â': 'a',
      'î': 'i',
      'û': 'u',
      'ô': 'o',
      'ê': 'e',
      'ç': 'c',
      'ğ': 'g',
      'ı': 'i',
      'ö': 'o',
      'ş': 's',
      'ü': 'u',
      '\'': '',
      '-': '',
      '`': '',
    };
    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      final ch = String.fromCharCode(rune);
      buffer.write(map[ch] ?? ch);
    }
    return buffer.toString().replaceAll(' ', '');
  }
}
