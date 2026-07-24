import 'package:ayet_ezberletici/core/constants.dart';
import 'package:ayet_ezberletici/data/sources/quran_meta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuranMeta', () {
    test('114 sure vardır', () {
      expect(QuranMeta.surahs.length, QuranConstants.surahCount);
    });

    test('toplam ayet sayısı 6236', () {
      final total =
          QuranMeta.surahs.fold<int>(0, (sum, s) => sum + s.ayahCount);
      expect(total, QuranConstants.totalAyahCount);
    });

    test('sure numaraları 1..114 sırayla', () {
      for (var i = 0; i < QuranMeta.surahs.length; i++) {
        expect(QuranMeta.surahs[i].number, i + 1);
      }
    });

    test('globalOffsetBefore doğru hesaplanır', () {
      expect(QuranMeta.globalOffsetBefore(1), 0);
      expect(QuranMeta.globalOffsetBefore(2), 7); // Fâtiha 7 ayet
    });

    test('globalAyahNumber uçtan uca tutarlı', () {
      // İlk ayet
      expect(
        QuranMeta.globalAyahNumber(surahNumber: 1, ayahInSurah: 1),
        1,
      );
      // Bakara ilk ayeti (Fâtiha'dan sonra)
      expect(
        QuranMeta.globalAyahNumber(surahNumber: 2, ayahInSurah: 1),
        8,
      );
      // Son ayet: Nâs (114) 6. ayet -> 6236
      expect(
        QuranMeta.globalAyahNumber(surahNumber: 114, ayahInSurah: 6),
        QuranConstants.totalAyahCount,
      );
    });
  });
}
