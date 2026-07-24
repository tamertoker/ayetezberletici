import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_player_service.dart';
import 'download_manager.dart';

final downloadManagerProvider = Provider<DownloadManager>((ref) {
  final manager = DownloadManager();
  ref.onDispose(manager.close);
  return manager;
});

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService(
    downloads: ref.watch(downloadManagerProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

/// Çalma durumu (playing / buffering vb.).
final playerStateProvider = StreamProvider<PlayerState>((ref) {
  return ref.watch(audioPlayerServiceProvider).playerStateStream;
});

/// O an çalınan kaynak indeksi (tekrarlar dahil genişletilmiş sıra).
final currentIndexProvider = StreamProvider<int?>((ref) {
  return ref.watch(audioPlayerServiceProvider).currentIndexStream;
});
