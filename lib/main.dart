import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kilit ekranı / medya bildirimi üzerinden arka planda çalma.
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ayetezberletici.audio',
    androidNotificationChannelName: 'Ayet Çalma',
    androidNotificationOngoing: true,
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const AyetEzberleticiApp(),
    ),
  );
}
