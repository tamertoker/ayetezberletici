import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ayah_reference.dart';
import '../settings/settings_screen.dart';
import 'reader_providers.dart';
import 'surah_detail_screen.dart';

/// Ana ekran: aranabilir sure listesi.
class SurahListScreen extends ConsumerStatefulWidget {
  const SurahListScreen({super.key});

  @override
  ConsumerState<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends ConsumerState<SurahListScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _open(AyahReference target) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SurahDetailScreen(
          surahNumber: target.surah.number,
          jumpToAyah: target.ayahInSurah,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(surahSearchProvider(_query));
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kur\'an-ı Kerim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Ayarlar',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SettingsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _controller,
              onChanged: (value) => setState(() => _query = value),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Sure ara veya "Rahman 11" yaz',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const _EmptyResults()
                : ListView.separated(
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final reference = results[index];
                      final surah = reference.surah;
                      return ListTile(
                        leading: _SurahNumberBadge(number: surah.number),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${surah.turkishName} Sûresi',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              surah.arabicName,
                              style: AppTheme.arabicTextStyle(
                                color: scheme.primary,
                                fontSize: 20,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          reference.ayahInSurah != null
                              ? '${surah.revelationType.turkishLabel} • ${reference.ayahInSurah}. ayete git'
                              : '${surah.revelationType.turkishLabel} • ${surah.ayahCount} ayet • ${surah.meaning}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _open(reference),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SurahNumberBadge extends StatelessWidget {
  const _SurahNumberBadge({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Sonuç bulunamadı.\nSure adı ya da "Sure Ayet" (ör. Bakara 255) deneyin.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
