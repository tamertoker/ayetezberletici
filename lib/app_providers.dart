import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/quran_repository.dart';
import 'data/sources/quran_api.dart';
import 'data/sources/surah_cache.dart';

/// [SharedPreferences] örneği. `main()` içinde gerçek örnekle override edilir.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider override edilmeli'),
);

final quranApiProvider = Provider<QuranApi>((ref) {
  final api = QuranApi();
  ref.onDispose(api.close);
  return api;
});

final surahCacheProvider = Provider<SurahCache>((ref) {
  return SurahCache(ref.watch(sharedPreferencesProvider));
});

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepository(
    api: ref.watch(quranApiProvider),
    cache: ref.watch(surahCacheProvider),
  );
});
