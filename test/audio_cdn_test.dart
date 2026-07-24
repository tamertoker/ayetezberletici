import 'package:ayet_ezberletici/data/sources/audio_cdn.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AudioCdn', () {
    const cdn = AudioCdn();

    test('ayet URL kalıbı doğru üretilir', () {
      final url = cdn.ayahUrl(globalAyahNumber: 262, reciterId: 'ar.alafasy');
      expect(
        url,
        'https://cdn.islamic.network/quran/audio/128/ar.alafasy/262.mp3',
      );
    });

    test('bit hızı özelleştirilebilir', () {
      const cdn64 = AudioCdn(bitrate: 64);
      final url = cdn64.ayahUrl(globalAyahNumber: 1);
      expect(url, contains('/64/ar.alafasy/1.mp3'));
    });

    test('indirilen dosya adı çakışmayacak biçimde üretilir', () {
      final name = AudioCdn.fileNameFor(
        reciterId: 'ar.husary',
        globalAyahNumber: 300,
      );
      expect(name, 'ar.husary_128_300.mp3');
    });
  });
}
