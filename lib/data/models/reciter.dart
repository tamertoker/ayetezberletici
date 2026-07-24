/// Bir Kur'an okuyucusu (kıraat). [id], islamic.network ses CDN'inde ve
/// Al Quran Cloud API'sinde kullanılan audio edition kimliğidir.
class Reciter {
  const Reciter({
    required this.id,
    required this.name,
    required this.arabicName,
  });

  final String id;
  final String name;
  final String arabicName;

  /// Uygulamada hazır sunulan popüler okuyucular. Varsayılan: Afasy.
  ///
  /// Kimlikler islamic.network ses CDN'inde mevcuttur; ileride
  /// `/edition?format=audio` ile dinamik olarak da genişletilebilir.
  static const List<Reciter> curated = [
    Reciter(
      id: 'ar.alafasy',
      name: 'Mishary Rashid Alafasy',
      arabicName: 'مشاري راشد العفاسي',
    ),
    Reciter(
      id: 'ar.abdulbasitmurattal',
      name: 'Abdul Basit (Murattal)',
      arabicName: 'عبد الباسط عبد الصمد',
    ),
    Reciter(
      id: 'ar.husary',
      name: 'Mahmoud Khalil Al-Husary',
      arabicName: 'محمود خليل الحصري',
    ),
    Reciter(
      id: 'ar.minshawi',
      name: 'Mohamed Siddiq El-Minshawi',
      arabicName: 'محمد صديق المنشاوي',
    ),
    Reciter(
      id: 'ar.muhammadayyoub',
      name: 'Muhammad Ayyoub',
      arabicName: 'محمد أيوب',
    ),
    Reciter(
      id: 'ar.shaatree',
      name: 'Abu Bakr Al-Shatri',
      arabicName: 'أبو بكر الشاطري',
    ),
  ];

  static Reciter byId(String id) => curated.firstWhere(
        (r) => r.id == id,
        orElse: () => curated.first,
      );
}
