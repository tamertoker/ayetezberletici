import '../../core/constants.dart';
import '../models/ayah.dart';
import '../models/surah.dart';
import '../sources/quran_api.dart';
import '../sources/quran_meta.dart';
import '../sources/surah_cache.dart';

/// Kur'an metin/meal verisine tek giriş noktası.
///
/// Sure listesi çevrimdışı meta'dan gelir; ayet metinleri önce önbellekten
/// okunur, yoksa API'den çekilip önbelleğe yazılır.
class QuranRepository {
  QuranRepository({
    required QuranApi api,
    required SurahCache cache,
  })  : _api = api,
        _cache = cache;

  final QuranApi _api;
  final SurahCache _cache;

  /// Tüm sureler (çevrimdışı, anlık).
  List<Surah> get surahs => QuranMeta.surahs;

  Surah surahByNumber(int number) => QuranMeta.byNumber(number);

  /// Bir surenin ayetlerini döndürür.
  ///
  /// [forceRefresh] true ise önbellek atlanır. Önbellek anahtarı meal
  /// edition'ına bağlıdır; meal değişince yeniden çekilir.
  Future<List<Ayah>> getSurahAyahs(
    int surahNumber, {
    String translationEdition = ApiConstants.defaultTranslationId,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _cache.read(surahNumber, translationEdition);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    final ayahs = await _api.fetchSurah(
      surahNumber: surahNumber,
      translationEdition: translationEdition,
    );
    await _cache.write(surahNumber, translationEdition, ayahs);
    return ayahs;
  }
}
