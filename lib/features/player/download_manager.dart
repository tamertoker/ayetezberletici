import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants.dart';
import '../../data/sources/audio_cdn.dart';

/// Ayet ses dosyalarının çevrimdışı indirme/çözümleme yöneticisi.
///
/// İndirilen dosyalar uygulama belgeler dizinindeki `audio/` klasörüne
/// sabit adlarla yazılır; çalma sırasında önce yerel dosya aranır, yoksa
/// CDN URL'i kullanılır.
class DownloadManager {
  DownloadManager({http.Client? client, AudioCdn cdn = const AudioCdn()})
      : _client = client ?? http.Client(),
        _cdn = cdn;

  final http.Client _client;
  final AudioCdn _cdn;
  Directory? _dir;

  Future<Directory> _audioDir() async {
    if (_dir != null) return _dir!;
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'audio'));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    _dir = dir;
    return dir;
  }

  Future<File> _fileFor(String reciterId, int globalAyahNumber) async {
    final dir = await _audioDir();
    final name = AudioCdn.fileNameFor(
      reciterId: reciterId,
      globalAyahNumber: globalAyahNumber,
    );
    return File(p.join(dir.path, name));
  }

  /// Ayet yerel olarak mevcut mu?
  Future<bool> isDownloaded({
    required String reciterId,
    required int globalAyahNumber,
  }) async {
    final file = await _fileFor(reciterId, globalAyahNumber);
    return file.existsSync();
  }

  /// Çalınacak kaynak URI'sini döndürür: yerel dosya varsa onun yolu,
  /// yoksa CDN URL'i.
  Future<Uri> resolveSource({
    required String reciterId,
    required int globalAyahNumber,
  }) async {
    final file = await _fileFor(reciterId, globalAyahNumber);
    if (file.existsSync()) return file.uri;
    return Uri.parse(
      _cdn.ayahUrl(globalAyahNumber: globalAyahNumber, reciterId: reciterId),
    );
  }

  /// Tek ayeti indirir (zaten varsa atlar). Yerel dosya yolunu döndürür.
  Future<File> downloadAyah({
    required String reciterId,
    required int globalAyahNumber,
  }) async {
    final file = await _fileFor(reciterId, globalAyahNumber);
    if (file.existsSync()) return file;

    final url =
        _cdn.ayahUrl(globalAyahNumber: globalAyahNumber, reciterId: reciterId);
    final response =
        await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw Exception('Ses indirilemedi (HTTP ${response.statusCode}).');
    }
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  /// Bir aralığı sırayla indirir; [onProgress] tamamlanan/indirilen sayısını
  /// bildirir.
  Future<void> downloadRange({
    required String reciterId,
    required int firstGlobalAyah,
    required int lastGlobalAyah,
    void Function(int done, int total)? onProgress,
  }) async {
    final total = lastGlobalAyah - firstGlobalAyah + 1;
    var done = 0;
    for (var n = firstGlobalAyah; n <= lastGlobalAyah; n++) {
      await downloadAyah(reciterId: reciterId, globalAyahNumber: n);
      done++;
      onProgress?.call(done, total);
    }
  }

  void close() => _client.close();
}
