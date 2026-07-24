import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_providers.dart';
import '../../core/utils/ayah_reference.dart';
import '../../data/models/ayah.dart';
import '../../data/models/surah.dart';
import '../settings/settings_controller.dart';

/// Tüm sureler (çevrimdışı meta).
final surahListProvider = Provider<List<Surah>>((ref) {
  return ref.watch(quranRepositoryProvider).surahs;
});

/// Arama metnine göre filtrelenmiş sure/ayet referansları.
final surahSearchProvider =
    Provider.family<List<AyahReference>, String>((ref, query) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) {
    return ref
        .watch(surahListProvider)
        .map((s) => AyahReference(surah: s))
        .toList();
  }
  return AyahSearch.query(trimmed);
});

/// Bir surenin ayetleri. Aktif meal edition'ına bağlıdır; meal değişince
/// otomatik yeniden çekilir.
final surahAyahsProvider =
    FutureProvider.family<List<Ayah>, int>((ref, surahNumber) async {
  final translationId =
      ref.watch(settingsControllerProvider.select((s) => s.translationId));
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getSurahAyahs(surahNumber, translationEdition: translationId);
});
