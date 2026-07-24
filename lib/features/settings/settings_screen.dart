import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/reciter.dart';
import 'settings_controller.dart';
import 'translation_editions.dart';

/// Ayarlar ekranı: okuyucu, meal, tema, gösterim ve tekrar sayısı.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          const _SectionHeader('Görünüm'),
          ListTile(
            title: const Text('Tema'),
            subtitle: Text(_themeLabel(settings.themeMode)),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto)),
                ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode)),
                ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode)),
              ],
              selected: {settings.themeMode},
              showSelectedIcon: false,
              onSelectionChanged: (set) => controller.setThemeMode(set.first),
            ),
          ),
          const Divider(),
          const _SectionHeader('Okuyucu (Kıraat)'),
          ...Reciter.curated.map(
            (r) => RadioListTile<String>(
              value: r.id,
              groupValue: settings.reciterId,
              title: Text(r.name),
              subtitle: Text(r.arabicName, textDirection: TextDirection.rtl),
              onChanged: (v) => controller.setReciter(v!),
            ),
          ),
          const Divider(),
          const _SectionHeader('Meal'),
          ...TranslationEdition.curated.map(
            (e) => RadioListTile<String>(
              value: e.id,
              groupValue: settings.translationId,
              title: Text(e.label),
              onChanged: (v) => controller.setTranslation(v!),
            ),
          ),
          const Divider(),
          const _SectionHeader('Ayet Gösterimi'),
          SwitchListTile(
            title: const Text('Arapça metin'),
            value: settings.showArabic,
            onChanged: controller.setShowArabic,
          ),
          SwitchListTile(
            title: const Text('Latin okunuş'),
            value: settings.showTransliteration,
            onChanged: controller.setShowTransliteration,
          ),
          SwitchListTile(
            title: const Text('Meal'),
            value: settings.showTranslation,
            onChanged: controller.setShowTranslation,
          ),
          const Divider(),
          const _SectionHeader('Çalma'),
          ListTile(
            title: const Text('Ayet tekrar sayısı'),
            subtitle: Text('Her ayet ${settings.repeatCount} kez çalınır'),
            trailing: SizedBox(
              width: 160,
              child: Slider(
                min: 1,
                max: 20,
                divisions: 19,
                label: '${settings.repeatCount}',
                value: settings.repeatCount.toDouble(),
                onChanged: (v) => controller.setRepeatCount(v.round()),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _AboutFooter(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Açık';
      case ThemeMode.dark:
        return 'Koyu';
      case ThemeMode.system:
        return 'Sistem';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _AboutFooter extends StatelessWidget {
  const _AboutFooter();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Metin ve ses verileri Al Quran Cloud (alquran.cloud) ve '
        'islamic.network üzerinden sunulmaktadır.',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
