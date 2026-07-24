import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants.dart';
import '../models/ayah.dart';

/// Al Quran Cloud REST API istemcisi.
///
/// Tek bir istekte birden fazla edition (Arapça + Latin + meal) çekmek için
/// `/surah/{n}/editions/{ed1},{ed2},...` uç noktasını kullanır.
class QuranApi {
  QuranApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Bir surenin ayetlerini istenen edition'larla birleştirilmiş döndürür.
  ///
  /// [arabicEdition] daima gelir; [translationEdition] / [transliterationEdition]
  /// null verilirse ilgili varyant boş kalır.
  Future<List<Ayah>> fetchSurah({
    required int surahNumber,
    String arabicEdition = ApiConstants.arabicEditionId,
    String? translationEdition = ApiConstants.defaultTranslationId,
    String? transliterationEdition = ApiConstants.transliterationEditionId,
  }) async {
    final editions = <String>[
      arabicEdition,
      if (transliterationEdition != null) transliterationEdition,
      if (translationEdition != null) translationEdition,
    ];

    final uri = Uri.parse(
      '${ApiConstants.apiBaseUrl}/surah/$surahNumber/editions/${editions.join(',')}',
    );

    final response = await _client.get(uri).timeout(
          const Duration(seconds: 20),
        );

    if (response.statusCode != 200) {
      throw QuranApiException(
        'Sure $surahNumber alınamadı (HTTP ${response.statusCode}).',
      );
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> data = body['data'] as List<dynamic>;

    return _mergeEditions(
      data: data,
      surahNumber: surahNumber,
      arabicEdition: arabicEdition,
      transliterationEdition: transliterationEdition,
      translationEdition: translationEdition,
    );
  }

  /// Edition dizisini `numberInSurah` üzerinden tek [Ayah] listesine katlar.
  List<Ayah> _mergeEditions({
    required List<dynamic> data,
    required int surahNumber,
    required String arabicEdition,
    String? transliterationEdition,
    String? translationEdition,
  }) {
    Map<String, dynamic>? editionByIdentifier(String id) {
      for (final e in data) {
        final map = e as Map<String, dynamic>;
        final ed = map['edition'] as Map<String, dynamic>?;
        if (ed != null && ed['identifier'] == id) return map;
      }
      return null;
    }

    final arabic = editionByIdentifier(arabicEdition) ?? data.first;
    final transliteration = transliterationEdition == null
        ? null
        : editionByIdentifier(transliterationEdition);
    final translation = translationEdition == null
        ? null
        : editionByIdentifier(translationEdition);

    List<dynamic> ayahsOf(Map<String, dynamic>? edition) =>
        (edition?['ayahs'] as List<dynamic>?) ?? const [];

    String? textAt(Map<String, dynamic>? edition, int index) {
      final list = ayahsOf(edition);
      if (index < 0 || index >= list.length) return null;
      final map = list[index] as Map<String, dynamic>;
      return (map['text'] as String?)?.trim();
    }

    final arabicAyahs = ayahsOf(arabic);
    final result = <Ayah>[];
    for (var i = 0; i < arabicAyahs.length; i++) {
      final base = Ayah.fromArabicJson(
        arabicAyahs[i] as Map<String, dynamic>,
        surahNumber,
      );
      result.add(
        base.copyWith(
          transliteration: textAt(transliteration, i),
          translation: textAt(translation, i),
        ),
      );
    }
    return result;
  }

  void close() => _client.close();
}

class QuranApiException implements Exception {
  QuranApiException(this.message);
  final String message;

  @override
  String toString() => 'QuranApiException: $message';
}
