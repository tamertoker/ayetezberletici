import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../data/models/ayah.dart';
import '../../data/sources/quran_meta.dart';
import '../player/audio_player_service.dart';
import '../player/player_providers.dart';
import '../player/widgets/mini_player.dart';
import '../settings/settings_controller.dart';
import 'reader_providers.dart';
import 'widgets/ayah_tile.dart';
import 'widgets/download_surah_button.dart';

/// Bir surenin okuma ekranı: ayetler, gösterim ayarları ve çalma.
class SurahDetailScreen extends ConsumerStatefulWidget {
  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    this.jumpToAyah,
  });

  final int surahNumber;

  /// Açılışta kaydırılacak ayet (sure içi numara), yoksa null.
  final int? jumpToAyah;

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  final ItemScrollController _scrollController = ItemScrollController();
  bool _didJump = false;

  Future<void> _playFrom(List<Ayah> ayahs, int index) async {
    final settings = ref.read(settingsControllerProvider);
    final service = ref.read(audioPlayerServiceProvider);
    await service.playAyahs(
      ayahs,
      reciterId: settings.reciterId,
      startIndex: index,
      repeatCount: settings.repeatCount,
    );
  }

  void _maybeJump(List<Ayah> ayahs) {
    if (_didJump || widget.jumpToAyah == null) return;
    final target = widget.jumpToAyah!;
    final index = ayahs.indexWhere((a) => a.numberInSurah == target);
    if (index < 0) return;
    _didJump = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.isAttached) {
        _scrollController.scrollTo(
          index: index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final surah = QuranMeta.byNumber(widget.surahNumber);
    final ayahsAsync = ref.watch(surahAyahsProvider(widget.surahNumber));
    final settings = ref.watch(settingsControllerProvider);

    // O an çalınan ayeti belirle (yalnızca bu sure çalıyorsa vurgula).
    final currentIndex = ref.watch(currentIndexProvider).valueOrNull;
    final service = ref.watch(audioPlayerServiceProvider);
    final QueueEntry? playingEntry = service.entryAt(currentIndex);
    final int? playingAyahInSurah =
        (playingEntry != null && playingEntry.ayah.surahNumber == surah.number)
            ? playingEntry.ayah.numberInSurah
            : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('${surah.turkishName} Sûresi'),
        actions: [
          DownloadSurahButton(surahNumber: widget.surahNumber),
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded),
            tooltip: 'Baştan çal',
            onPressed: () {
              final ayahs = ayahsAsync.valueOrNull;
              if (ayahs != null && ayahs.isNotEmpty) _playFrom(ayahs, 0);
            },
          ),
        ],
      ),
      bottomNavigationBar: const MiniPlayer(),
      body: ayahsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorView(
          onRetry: () => ref.invalidate(surahAyahsProvider(widget.surahNumber)),
        ),
        data: (ayahs) {
          _maybeJump(ayahs);
          return ScrollablePositionedList.separated(
            itemScrollController: _scrollController,
            itemCount: ayahs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final ayah = ayahs[index];
              return AyahTile(
                ayah: ayah,
                settings: settings,
                isPlaying: playingAyahInSurah == ayah.numberInSurah,
                onPlay: () => _playFrom(ayahs, index),
              );
            },
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Ayetler yüklenemedi. İnternet bağlantını kontrol edip tekrar dene.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Tekrar dene'),
            ),
          ],
        ),
      ),
    );
  }
}
