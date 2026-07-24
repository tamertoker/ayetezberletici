/// Uygulamada hazır sunulan meal edition'ları (Al Quran Cloud kimlikleri).
class TranslationEdition {
  const TranslationEdition({required this.id, required this.label});

  final String id;
  final String label;

  static const List<TranslationEdition> curated = [
    TranslationEdition(id: 'tr.diyanet', label: 'Türkçe — Diyanet İşleri'),
    TranslationEdition(id: 'tr.yazir', label: 'Türkçe — Elmalılı Hamdi Yazır'),
    TranslationEdition(id: 'tr.vakfi', label: 'Türkçe — Diyanet Vakfı'),
    TranslationEdition(id: 'tr.ates', label: 'Türkçe — Süleyman Ateş'),
    TranslationEdition(id: 'en.sahih', label: 'İngilizce — Saheeh International'),
  ];

  static String labelFor(String id) => curated
      .firstWhere(
        (e) => e.id == id,
        orElse: () => TranslationEdition(id: id, label: id),
      )
      .label;
}
