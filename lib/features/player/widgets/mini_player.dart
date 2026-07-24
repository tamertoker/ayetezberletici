import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../data/sources/quran_meta.dart';
import '../audio_player_service.dart';
import '../player_providers.dart';

/// Ekranın altında görünen kompakt çalar. Bir şey çalmıyorsa gizlenir.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(audioPlayerServiceProvider);
    final currentIndex = ref.watch(currentIndexProvider).valueOrNull;
    final playerState = ref.watch(playerStateProvider).valueOrNull;
    final QueueEntry? entry = service.entryAt(currentIndex);

    if (entry == null) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final surah = QuranMeta.byNumber(entry.ayah.surahNumber);
    final isPlaying = playerState?.playing ?? false;
    final processing = playerState?.processingState;
    final isBuffering = processing == ProcessingState.loading ||
        processing == ProcessingState.buffering;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.menu_book_rounded, color: scheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${surah.turkishName} ${entry.ayah.numberInSurah}. Ayet',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Tekrar ${entry.occurrence}',
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded),
              onPressed: service.previous,
            ),
            IconButton(
              iconSize: 34,
              icon: isBuffering
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                    ),
              color: scheme.primary,
              onPressed: service.togglePlayPause,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              onPressed: service.next,
            ),
          ],
        ),
      ),
    );
  }
}
