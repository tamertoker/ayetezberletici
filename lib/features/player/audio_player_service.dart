import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../data/models/ayah.dart';
import '../../data/sources/quran_meta.dart';
import 'download_manager.dart';

/// Çalınan sıradaki tek bir öğe: hangi ayet ve o ayetin kaçıncı tekrarı.
class QueueEntry {
  const QueueEntry({required this.ayah, required this.occurrence});

  final Ayah ayah;

  /// 1..repeatCount arası tekrar sırası.
  final int occurrence;
}

/// Ayet seslerini sıralı çalan, arka planda/kilit ekranında çalışan servis.
///
/// [just_audio_background] sayesinde çalma kilit ekranı ve medya bildirimi
/// üzerinden de kontrol edilebilir (Faz 2'deki ana ekran widget'ı da bu
/// altyapıyı kullanacak).
class AudioPlayerService {
  AudioPlayerService({required DownloadManager downloads})
      : _downloads = downloads;

  final DownloadManager _downloads;
  final AudioPlayer _player = AudioPlayer();

  /// Kaynak sırasındaki her indeks için karşılık gelen kuyruk öğesi.
  List<QueueEntry> _queue = const [];

  AudioPlayer get player => _player;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<int?> get currentIndexStream => _player.currentIndexStream;
  Stream<Duration> get positionStream => _player.positionStream;

  /// O an çalınan kaynak indeksine karşılık gelen ayet numarası (sure içi),
  /// yoksa null.
  int? currentAyahInSurah(int? index) {
    if (index == null || index < 0 || index >= _queue.length) return null;
    return _queue[index].ayah.numberInSurah;
  }

  QueueEntry? entryAt(int? index) {
    if (index == null || index < 0 || index >= _queue.length) return null;
    return _queue[index];
  }

  /// Verilen ayet listesini [startIndex]'ten başlayarak çalar. Her ayet
  /// [repeatCount] kez arka arkaya çalınır.
  Future<void> playAyahs(
    List<Ayah> ayahs, {
    required String reciterId,
    int startIndex = 0,
    int repeatCount = 1,
  }) async {
    if (ayahs.isEmpty) return;
    final safeRepeat = repeatCount < 1 ? 1 : repeatCount;

    final queue = <QueueEntry>[];
    final sources = <AudioSource>[];

    for (final ayah in ayahs) {
      final globalNumber = QuranMeta.globalAyahNumber(
        surahNumber: ayah.surahNumber,
        ayahInSurah: ayah.numberInSurah,
      );
      final uri = await _downloads.resolveSource(
        reciterId: reciterId,
        globalAyahNumber: globalNumber,
      );
      final surah = QuranMeta.byNumber(ayah.surahNumber);
      for (var occ = 1; occ <= safeRepeat; occ++) {
        queue.add(QueueEntry(ayah: ayah, occurrence: occ));
        sources.add(
          AudioSource.uri(
            uri,
            tag: MediaItem(
              id: '${ayah.surahNumber}:${ayah.numberInSurah}:$occ',
              album: '${surah.turkishName} Sûresi',
              title: '${surah.turkishName} ${ayah.numberInSurah}. Ayet',
              artist: reciterId,
            ),
          ),
        );
      }
    }

    _queue = queue;
    final firstSourceIndex = (startIndex * safeRepeat)
        .clamp(0, sources.isEmpty ? 0 : sources.length - 1)
        .toInt();

    await _player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
      initialIndex: firstSourceIndex,
    );
    await _player.play();
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> stop() => _player.stop();
  Future<void> next() => _player.seekToNext();
  Future<void> previous() => _player.seekToPrevious();

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> dispose() => _player.dispose();
}
