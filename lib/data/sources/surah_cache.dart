import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/ayah.dart';

/// Sure ayet metinlerinin (Arapça + Latin + meal) yerel önbelleği.
///
/// Bir kez çekilen sure, meal edition kimliğiyle birlikte saklanır; sonraki
/// açılışlarda ağ olmadan gösterilir. Basitlik için [SharedPreferences]
/// üzerinde JSON olarak tutulur.
class SurahCache {
  SurahCache(this._prefs);

  final SharedPreferences _prefs;

  static Future<SurahCache> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SurahCache(prefs);
  }

  String _key(int surahNumber, String translationId) =>
      'cache.surah.$surahNumber.$translationId';

  List<Ayah>? read(int surahNumber, String translationId) {
    final raw = _prefs.getString(_key(surahNumber, translationId));
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => Ayah.fromCacheJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> write(
    int surahNumber,
    String translationId,
    List<Ayah> ayahs,
  ) async {
    final raw = jsonEncode(ayahs.map((a) => a.toCacheJson()).toList());
    await _prefs.setString(_key(surahNumber, translationId), raw);
  }

  Future<void> clear() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith('cache.surah.'));
    for (final k in keys) {
      await _prefs.remove(k);
    }
  }
}
