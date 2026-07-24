import 'package:ayet_ezberletici/core/utils/ayah_reference.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AyahSearch', () {
    test('"Rahman 11" -> 55. sure, 11. ayet', () {
      final results = AyahSearch.query('Rahman 11');
      expect(results, isNotEmpty);
      expect(results.first.surah.number, 55);
      expect(results.first.ayahInSurah, 11);
    });

    test('"55:11" -> 55. sure, 11. ayet', () {
      final results = AyahSearch.query('55:11');
      expect(results.first.surah.number, 55);
      expect(results.first.ayahInSurah, 11);
    });

    test('"Bakara 255" -> 2. sure, 255. ayet', () {
      final results = AyahSearch.query('Bakara 255');
      expect(results.first.surah.number, 2);
      expect(results.first.ayahInSurah, 255);
    });

    test('diyakritikten bağımsız: "kehf" -> 18. sure', () {
      final results = AyahSearch.query('kehf');
      expect(results.first.surah.number, 18);
      expect(results.first.ayahInSurah, isNull);
    });

    test('sadece numara: "36" -> Yâsîn', () {
      final results = AyahSearch.query('36');
      expect(results.first.surah.number, 36);
    });

    test('aralık dışı ayet numarası kırpılır', () {
      final results = AyahSearch.query('Fatiha 99');
      expect(results.first.surah.number, 1);
      expect(results.first.ayahInSurah, 7); // Fâtiha 7 ayet
    });

    test('boş sorgu boş liste döner', () {
      expect(AyahSearch.query('   '), isEmpty);
    });
  });
}
