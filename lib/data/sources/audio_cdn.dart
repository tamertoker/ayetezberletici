import '../../core/constants.dart';

/// islamic.network ses CDN'i için ayet ses URL'lerini üretir.
///
/// Kalıp: `$audioCdnBase/$bitrate/$edition/$globalAyahNumber.mp3`
/// Örnek: https://cdn.islamic.network/quran/audio/128/ar.alafasy/262.mp3
///
/// Saf fonksiyon — ağ erişimi yoktur, birim testine uygundur.
class AudioCdn {
  const AudioCdn({
    this.bitrate = ApiConstants.defaultBitrate,
  });

  final int bitrate;

  /// Kur'an geneli sıralı ayet numarasından (1..6236) ses URL'i döndürür.
  String ayahUrl({
    required int globalAyahNumber,
    String reciterId = ApiConstants.defaultReciterId,
  }) {
    assert(
      globalAyahNumber >= 1 &&
          globalAyahNumber <= QuranConstants.totalAyahCount,
      'globalAyahNumber 1..${QuranConstants.totalAyahCount} aralığında olmalı',
    );
    return '${ApiConstants.audioCdnBase}/$bitrate/$reciterId/$globalAyahNumber.mp3';
  }

  /// İndirilen bir ayet ses dosyası için sabit, çakışmayan dosya adı.
  static String fileNameFor({
    required String reciterId,
    required int globalAyahNumber,
    int bitrate = ApiConstants.defaultBitrate,
  }) {
    return '${reciterId}_${bitrate}_$globalAyahNumber.mp3';
  }
}
