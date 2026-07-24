import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/sources/quran_meta.dart';
import '../../player/player_providers.dart';
import '../../settings/settings_controller.dart';

/// Bir sureyi seçili okuyucuyla çevrimdışı indiren buton.
class DownloadSurahButton extends ConsumerStatefulWidget {
  const DownloadSurahButton({super.key, required this.surahNumber});

  final int surahNumber;

  @override
  ConsumerState<DownloadSurahButton> createState() =>
      _DownloadSurahButtonState();
}

class _DownloadSurahButtonState extends ConsumerState<DownloadSurahButton> {
  bool _downloading = false;
  double _progress = 0;

  Future<void> _download() async {
    if (_downloading) return;
    final reciterId = ref.read(settingsControllerProvider).reciterId;
    final surah = QuranMeta.byNumber(widget.surahNumber);
    final first =
        QuranMeta.globalAyahNumber(surahNumber: surah.number, ayahInSurah: 1);
    final last = first + surah.ayahCount - 1;
    final manager = ref.read(downloadManagerProvider);

    setState(() {
      _downloading = true;
      _progress = 0;
    });
    try {
      await manager.downloadRange(
        reciterId: reciterId,
        firstGlobalAyah: first,
        lastGlobalAyah: last,
        onProgress: (done, total) {
          if (mounted) setState(() => _progress = done / total);
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${surah.turkishName} indirildi (çevrimdışı)')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İndirme başarısız oldu.')),
        );
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_downloading) {
      return Padding(
        padding: const EdgeInsets.all(14),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            value: _progress == 0 ? null : _progress,
          ),
        ),
      );
    }
    return IconButton(
      icon: const Icon(Icons.download_outlined),
      tooltip: 'Çevrimdışı indir',
      onPressed: _download,
    );
  }
}
