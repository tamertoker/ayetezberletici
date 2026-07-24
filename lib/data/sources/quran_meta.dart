import '../models/surah.dart';

/// 114 surenin çevrimdışı meta verisi.
///
/// Bu tablo sayesinde sure listesi ağ olmadan gösterilebilir ve sure+ayet
/// numarasından Kur'an geneli sıralı ayet numarası (ses URL'i için) hesaplanır.
/// Ayet sayıları standart Hafs sayımına göredir (toplam 6236).
///
/// İniş yeri (Mekkî/Medenî) yaygın sınıflandırmaya göre en iyi çabadır;
/// çevrimiçi API'nin `revelationType` değeri gerektiğinde bunu geçersiz kılar.
class QuranMeta {
  QuranMeta._();

  static const Set<int> _medinan = {
    2, 3, 4, 5, 8, 9, 13, 22, 24, 33, 47, 48, 49, 55, 57, 58, 59, 60, 61, 62, //
    63, 64, 65, 66, 76, 98, 99, 110,
  };

  /// (number, arabic, turkish, english, meaning, ayahCount)
  static const List<(int, String, String, String, String, int)> _raw = [
    (1, 'الفاتحة', 'Fâtiha', 'Al-Fatihah', 'Açılış', 7),
    (2, 'البقرة', 'Bakara', 'Al-Baqarah', 'İnek', 286),
    (3, 'آل عمران', 'Âl-i İmrân', 'Ali \'Imran', 'İmran Ailesi', 200),
    (4, 'النساء', 'Nisâ', 'An-Nisa', 'Kadınlar', 176),
    (5, 'المائدة', 'Mâide', 'Al-Ma\'idah', 'Sofra', 120),
    (6, 'الأنعام', 'En\'âm', 'Al-An\'am', 'Davarlar', 165),
    (7, 'الأعراف', 'A\'râf', 'Al-A\'raf', 'Yüksek Yerler', 206),
    (8, 'الأنفال', 'Enfâl', 'Al-Anfal', 'Ganimetler', 75),
    (9, 'التوبة', 'Tevbe', 'At-Tawbah', 'Tövbe', 129),
    (10, 'يونس', 'Yûnus', 'Yunus', 'Yunus', 109),
    (11, 'هود', 'Hûd', 'Hud', 'Hud', 123),
    (12, 'يوسف', 'Yûsuf', 'Yusuf', 'Yusuf', 111),
    (13, 'الرعد', 'Ra\'d', 'Ar-Ra\'d', 'Gök Gürültüsü', 43),
    (14, 'ابراهيم', 'İbrâhim', 'Ibrahim', 'İbrahim', 52),
    (15, 'الحجر', 'Hicr', 'Al-Hijr', 'Hicr', 99),
    (16, 'النحل', 'Nahl', 'An-Nahl', 'Arı', 128),
    (17, 'الإسراء', 'İsrâ', 'Al-Isra', 'Gece Yürüyüşü', 111),
    (18, 'الكهف', 'Kehf', 'Al-Kahf', 'Mağara', 110),
    (19, 'مريم', 'Meryem', 'Maryam', 'Meryem', 98),
    (20, 'طه', 'Tâhâ', 'Taha', 'Tâhâ', 135),
    (21, 'الأنبياء', 'Enbiyâ', 'Al-Anbya', 'Peygamberler', 112),
    (22, 'الحج', 'Hac', 'Al-Hajj', 'Hac', 78),
    (23, 'المؤمنون', 'Mü\'minûn', 'Al-Mu\'minun', 'İnananlar', 118),
    (24, 'النور', 'Nûr', 'An-Nur', 'Işık', 64),
    (25, 'الفرقان', 'Furkân', 'Al-Furqan', 'Ayırt Edici', 77),
    (26, 'الشعراء', 'Şuarâ', 'Ash-Shu\'ara', 'Şairler', 227),
    (27, 'النمل', 'Neml', 'An-Naml', 'Karınca', 93),
    (28, 'القصص', 'Kasas', 'Al-Qasas', 'Kıssalar', 88),
    (29, 'العنكبوت', 'Ankebût', 'Al-\'Ankabut', 'Örümcek', 69),
    (30, 'الروم', 'Rûm', 'Ar-Rum', 'Romalılar', 60),
    (31, 'لقمان', 'Lokmân', 'Luqman', 'Lokman', 34),
    (32, 'السجدة', 'Secde', 'As-Sajdah', 'Secde', 30),
    (33, 'الأحزاب', 'Ahzâb', 'Al-Ahzab', 'Müttefikler', 73),
    (34, 'سبإ', 'Sebe\'', 'Saba', 'Sebe', 54),
    (35, 'فاطر', 'Fâtır', 'Fatir', 'Yaratan', 45),
    (36, 'يس', 'Yâsîn', 'Ya-Sin', 'Yâsîn', 83),
    (37, 'الصافات', 'Sâffât', 'As-Saffat', 'Saf Tutanlar', 182),
    (38, 'ص', 'Sâd', 'Sad', 'Sâd', 88),
    (39, 'الزمر', 'Zümer', 'Az-Zumar', 'Gruplar', 75),
    (40, 'غافر', 'Mü\'min', 'Ghafir', 'Bağışlayan', 85),
    (41, 'فصلت', 'Fussilet', 'Fussilat', 'Ayrıntılı', 54),
    (42, 'الشورى', 'Şûrâ', 'Ash-Shuraa', 'Danışma', 53),
    (43, 'الزخرف', 'Zuhruf', 'Az-Zukhruf', 'Süs', 89),
    (44, 'الدخان', 'Duhân', 'Ad-Dukhan', 'Duman', 59),
    (45, 'الجاثية', 'Câsiye', 'Al-Jathiyah', 'Diz Çöken', 37),
    (46, 'الأحقاف', 'Ahkâf', 'Al-Ahqaf', 'Kum Tepeleri', 35),
    (47, 'محمد', 'Muhammed', 'Muhammad', 'Muhammed', 38),
    (48, 'الفتح', 'Fetih', 'Al-Fath', 'Fetih', 29),
    (49, 'الحجرات', 'Hucurât', 'Al-Hujurat', 'Odalar', 18),
    (50, 'ق', 'Kâf', 'Qaf', 'Kâf', 45),
    (51, 'الذاريات', 'Zâriyât', 'Adh-Dhariyat', 'Tozutup Savuranlar', 60),
    (52, 'الطور', 'Tûr', 'At-Tur', 'Tûr Dağı', 49),
    (53, 'النجم', 'Necm', 'An-Najm', 'Yıldız', 62),
    (54, 'القمر', 'Kamer', 'Al-Qamar', 'Ay', 55),
    (55, 'الرحمن', 'Rahmân', 'Ar-Rahman', 'Rahman', 78),
    (56, 'الواقعة', 'Vâkıa', 'Al-Waqi\'ah', 'Olay', 96),
    (57, 'الحديد', 'Hadîd', 'Al-Hadid', 'Demir', 29),
    (58, 'المجادلة', 'Mücâdele', 'Al-Mujadila', 'Tartışan Kadın', 22),
    (59, 'الحشر', 'Haşr', 'Al-Hashr', 'Sürgün', 24),
    (60, 'الممتحنة', 'Mümtehine', 'Al-Mumtahanah', 'İmtihan Edilen', 13),
    (61, 'الصف', 'Saff', 'As-Saff', 'Saf', 14),
    (62, 'الجمعة', 'Cum\'a', 'Al-Jumu\'ah', 'Cuma', 11),
    (63, 'المنافقون', 'Münâfikûn', 'Al-Munafiqun', 'Münafıklar', 11),
    (64, 'التغابن', 'Teğâbün', 'At-Taghabun', 'Aldanma', 18),
    (65, 'الطلاق', 'Talâk', 'At-Talaq', 'Boşanma', 12),
    (66, 'التحريم', 'Tahrîm', 'At-Tahrim', 'Yasaklama', 12),
    (67, 'الملك', 'Mülk', 'Al-Mulk', 'Egemenlik', 30),
    (68, 'القلم', 'Kalem', 'Al-Qalam', 'Kalem', 52),
    (69, 'الحاقة', 'Hâkka', 'Al-Haqqah', 'Gerçekleşecek Olan', 52),
    (70, 'المعارج', 'Meâric', 'Al-Ma\'arij', 'Yükselme Dereceleri', 44),
    (71, 'نوح', 'Nûh', 'Nuh', 'Nuh', 28),
    (72, 'الجن', 'Cin', 'Al-Jinn', 'Cin', 28),
    (73, 'المزمل', 'Müzzemmil', 'Al-Muzzammil', 'Örtünüp Bürünen', 20),
    (74, 'المدثر', 'Müddessir', 'Al-Muddaththir', 'Örtüsüne Bürünen', 56),
    (75, 'القيامة', 'Kıyâme', 'Al-Qiyamah', 'Kıyamet', 40),
    (76, 'الانسان', 'İnsân', 'Al-Insan', 'İnsan', 31),
    (77, 'المرسلات', 'Mürselât', 'Al-Mursalat', 'Gönderilenler', 50),
    (78, 'النبإ', 'Nebe\'', 'An-Naba', 'Haber', 40),
    (79, 'النازعات', 'Nâziât', 'An-Nazi\'at', 'Söküp Çıkaranlar', 46),
    (80, 'عبس', 'Abese', '\'Abasa', 'Yüzünü Ekşitti', 42),
    (81, 'التكوير', 'Tekvîr', 'At-Takwir', 'Dürülme', 29),
    (82, 'الإنفطار', 'İnfitâr', 'Al-Infitar', 'Yarılma', 19),
    (83, 'المطففين', 'Mutaffifîn', 'Al-Mutaffifin', 'Ölçüde Hile Yapanlar', 36),
    (84, 'الإنشقاق', 'İnşikâk', 'Al-Inshiqaq', 'Yarılma', 25),
    (85, 'البروج', 'Burûc', 'Al-Buruj', 'Burçlar', 22),
    (86, 'الطارق', 'Târık', 'At-Tariq', 'Gece Gelen', 17),
    (87, 'الأعلى', 'A\'lâ', 'Al-A\'la', 'En Yüce', 19),
    (88, 'الغاشية', 'Gâşiye', 'Al-Ghashiyah', 'Kaplayan Felaket', 26),
    (89, 'الفجر', 'Fecr', 'Al-Fajr', 'Şafak', 30),
    (90, 'البلد', 'Beled', 'Al-Balad', 'Şehir', 20),
    (91, 'الشمس', 'Şems', 'Ash-Shams', 'Güneş', 15),
    (92, 'الليل', 'Leyl', 'Al-Layl', 'Gece', 21),
    (93, 'الضحى', 'Duhâ', 'Ad-Duhaa', 'Kuşluk Vakti', 11),
    (94, 'الشرح', 'İnşirâh', 'Ash-Sharh', 'Ferahlatma', 8),
    (95, 'التين', 'Tîn', 'At-Tin', 'İncir', 8),
    (96, 'العلق', 'Alak', 'Al-\'Alaq', 'Kan Pıhtısı', 19),
    (97, 'القدر', 'Kadr', 'Al-Qadr', 'Kadir Gecesi', 5),
    (98, 'البينة', 'Beyyine', 'Al-Bayyinah', 'Apaçık Delil', 8),
    (99, 'الزلزلة', 'Zilzâl', 'Az-Zalzalah', 'Sarsıntı', 8),
    (100, 'العاديات', 'Âdiyât', 'Al-\'Adiyat', 'Koşan Atlar', 11),
    (101, 'القارعة', 'Kâria', 'Al-Qari\'ah', 'Çarpacak Felaket', 11),
    (102, 'التكاثر', 'Tekâsür', 'At-Takathur', 'Çokluk Yarışı', 8),
    (103, 'العصر', 'Asr', 'Al-\'Asr', 'İkindi Vakti', 3),
    (104, 'الهمزة', 'Hümeze', 'Al-Humazah', 'Arkadan Çekiştiren', 9),
    (105, 'الفيل', 'Fîl', 'Al-Fil', 'Fil', 5),
    (106, 'قريش', 'Kureyş', 'Quraysh', 'Kureyş', 4),
    (107, 'الماعون', 'Mâûn', 'Al-Ma\'un', 'Yardımlaşma', 7),
    (108, 'الكوثر', 'Kevser', 'Al-Kawthar', 'Bolluk', 3),
    (109, 'الكافرون', 'Kâfirûn', 'Al-Kafirun', 'İnkarcılar', 6),
    (110, 'النصر', 'Nasr', 'An-Nasr', 'Yardım', 3),
    (111, 'المسد', 'Tebbet', 'Al-Masad', 'Bükülmüş İp', 5),
    (112, 'الإخلاص', 'İhlâs', 'Al-Ikhlas', 'Samimiyet', 4),
    (113, 'الفلق', 'Felak', 'Al-Falaq', 'Şafak', 5),
    (114, 'الناس', 'Nâs', 'An-Nas', 'İnsanlar', 6),
  ];

  /// Tüm sureler (sırayla 1..114).
  static final List<Surah> surahs = _raw
      .map(
        (r) => Surah(
          number: r.$1,
          arabicName: r.$2,
          turkishName: r.$3,
          englishName: r.$4,
          meaning: r.$5,
          ayahCount: r.$6,
          revelationType: _medinan.contains(r.$1)
              ? RevelationType.medinan
              : RevelationType.meccan,
        ),
      )
      .toList(growable: false);

  static Surah byNumber(int number) => surahs[number - 1];

  /// Bir sureden önce gelen toplam ayet sayısı (0 tabanlı ofset).
  /// [surahNumber] için: 1. surede 0, 2. surede 7 (Fâtiha 7 ayet) ...
  static int globalOffsetBefore(int surahNumber) {
    var offset = 0;
    for (var i = 1; i < surahNumber; i++) {
      offset += surahs[i - 1].ayahCount;
    }
    return offset;
  }

  /// Sure numarası + sure içi ayet numarasından Kur'an geneli sıralı
  /// ayet numarasını (1..6236) döndürür. Ses URL'i için kullanılır.
  static int globalAyahNumber({
    required int surahNumber,
    required int ayahInSurah,
  }) {
    return globalOffsetBefore(surahNumber) + ayahInSurah;
  }
}
