import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/ayah.dart';
import '../../settings/settings_state.dart';

/// Okuma ekranında tek bir ayet kartı.
class AyahTile extends StatelessWidget {
  const AyahTile({
    super.key,
    required this.ayah,
    required this.settings,
    required this.isPlaying,
    required this.onPlay,
  });

  final Ayah ayah;
  final SettingsState settings;
  final bool isPlaying;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isPlaying
            ? scheme.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: isPlaying ? scheme.primary : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AyahBadge(number: ayah.numberInSurah),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.volume_up_rounded : Icons.play_circle_outline,
                  color: scheme.primary,
                ),
                tooltip: 'Bu ayeti çal',
                onPressed: onPlay,
              ),
            ],
          ),
          if (settings.showArabic) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                ayah.arabicText,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: AppTheme.arabicTextStyle(color: scheme.onSurface),
              ),
            ),
          ],
          if (settings.showTransliteration && ayah.transliteration != null) ...[
            const SizedBox(height: 12),
            Text(
              ayah.transliteration!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: scheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ],
          if (settings.showTranslation && ayah.translation != null) ...[
            const SizedBox(height: 12),
            Text(
              ayah.translation!,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ],
      ),
    );
  }
}

class _AyahBadge extends StatelessWidget {
  const _AyahBadge({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Ayet $number',
        style: TextStyle(
          color: scheme.secondary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
