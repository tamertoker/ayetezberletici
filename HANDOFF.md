# Devir Belgesi (HANDOFF)

Bu belge, **Ayet Ezberletici** projesini devralan geliştirici/asistan içindir.
Amaç: hiçbir bağlamı tahmin etmek zorunda kalmadan projeye devam edebilmek.

- **Depo:** `tamertoker/ayetezberletici`
- **Aktif dal:** `claude/quran-memorization-app-yt4t4j`
- **Son commit:** `3067897` — "Faz 1: Kur'an okuma, ses çalar ve temel altyapı"
- **Durum:** Faz 1 kodu yazıldı ve push edildi. Faz 2 (asıl özellik) yazılmadı.

---

## 1. Proje nedir?

Günlük hayata Kur'an okumayı sığdırmayı kolaylaştıran bir **ayet ezberletme**
uygulaması (Android + iOS, Flutter).

**Asıl ayırt edici özellik (henüz yazılmadı — Faz 2):** Kullanıcı ezberlemek
istediği ayeti **ana ekrana widget** olarak ekler. Telefonda gezerken widget'taki
play butonuna basıp ayeti dinler. Widget'ta ayet metni (Arapça / Latin okunuş /
meal — kullanıcı seçer) ve **"bugün 1/5 okundu"** sayacı görünür. Uygulama
"bugün yeterince okumadın" diye hatırlatma bildirimi gönderir.

Faz 1 bu özelliğin üzerine oturacağı temeli kurar: Kur'an metni, ses çalar,
okuyucu seçimi, çevrimdışı destek.

---

## 2. ⚠️ ÖNCE OKU — Dürüst Uyarılar

Bunlar devralan tarafın ilk saatini kurtarır:

1. **Kod hiç derlenmedi, hiç çalıştırılmadı.** `flutter analyze` ve
   `flutter test` bir kez bile koşmadı — kodun yazıldığı ortamda Flutter SDK
   yoktu. Derleme hataları, tip uyuşmazlıkları veya lint ihlalleri **beklenmeli**.
   **İlk iş bunları çalıştırıp düzeltmek olmalı.**

2. **`android/` ve `ios/` klasörleri depoda yok.** Hiç üretilmediler.
   `flutter create .` ile üretilmeleri gerekiyor (bu komut mevcut `lib/` ve
   `pubspec.yaml`'ı bozmaz, sadece eksik platform klasörlerini ekler).

3. **Paket sürümleri elle yazıldı**, `pub get` ile çözülmedi. `pubspec.yaml`
   içindeki sürümlerde çakışma çıkabilir; gerekirse gevşetilmeli.

4. **Bazı meal edition kimlikleri doğrulanmadı.** `tr.yazir`, `tr.vakfi`,
   `tr.ates` API'de birebir bu adlarla var mı teyit edilmedi.
   `https://api.alquran.cloud/v1/edition` ile kontrol edilmeli.
   (`tr.diyanet` ve `ar.alafasy` yaygın kullanılan, güvenilir kimlikler.)

Doğrulanmış olan: sure meta tablosu (114 sure, toplam **6236** ayet) ve global
ayet numarası hesabı — birim testleriyle kontrol edildi (`test/quran_meta_test.dart`).

---

## 3. Teknoloji ve mimari kararları

| Karar | Gerekçe |
|---|---|
| **Flutter** | Tek kod tabanı ile Android+iOS. `home_widget` paketi her iki platformun ana ekran widget'ını tek Dart callback ile yönetebiliyor — Faz 2 için belirleyici oldu. |
| **Riverpod** | State management; provider override ile test edilebilirlik. |
| **Feature-first katmanlı yapı** | `core / data / features` ayrımı; ileride widget ve bildirim özellikleri ayrı feature klasörü olarak eklenecek. |
| **Saf mantığı Flutter'dan ayırma** | URL üretimi, ayet no hesabı, arama ayrıştırma saf Dart → birim testli, widget/isolate tarafından da kullanılabilir. |
| **Stream + offline indirme** | Tüm sesleri (~GB) pakete gömmek yerine CDN'den akış; ezberlenecek ayetler indirilip çevrimdışı çalınır. Uygulama küçük kalır, widget güvenilir çalışır. |

---

## 4. Dosya haritası

```
lib/
├── main.dart                       # Giriş: JustAudioBackground.init + SharedPreferences override
├── app.dart                        # MaterialApp, tema, tr locale, ana ekran
├── app_providers.dart              # ⚠️ sharedPreferencesProvider main'de override EDİLMELİ
│
├── core/
│   ├── constants.dart              # ⭐ API/CDN adresleri, varsayılan edition kimlikleri, pref anahtarları
│   ├── theme/app_colors.dart       # Zümrüt-yeşil + altın paleti
│   ├── theme/app_theme.dart        # Açık/koyu tema; arabicTextStyle() = Amiri fontu
│   └── utils/ayah_reference.dart   # ⭐ "Rahman 11" / "55:11" / "Kehf" ayrıştırma (saf, testli)
│
├── data/
│   ├── models/
│   │   ├── surah.dart              # Sure + RevelationType (Mekkî/Medenî)
│   │   ├── ayah.dart               # Ayet: arapça + latin + meal tek nesnede; cache JSON
│   │   ├── edition.dart            # API edition kaydı
│   │   └── reciter.dart            # 6 okuyucu (varsayılan ar.alafasy)
│   ├── sources/
│   │   ├── quran_api.dart          # alquran.cloud REST; çoklu edition TEK istekte, numberInSurah ile birleştirme
│   │   ├── audio_cdn.dart          # ⭐ mp3 URL kalıbı + indirilen dosya adı (saf, testli)
│   │   ├── quran_meta.dart         # ⭐⭐ 114 sure çevrimdışı tablo + globalAyahNumber() (1..6236)
│   │   └── surah_cache.dart        # Metin önbelleği (shared_preferences, JSON)
│   └── repositories/
│       └── quran_repository.dart   # Önbellek-önce okuma; meal değişince yeniden çeker
│
└── features/
    ├── reader/
    │   ├── reader_providers.dart       # surahListProvider, surahSearchProvider, surahAyahsProvider
    │   ├── surah_list_screen.dart      # Ana ekran: aranabilir sure listesi
    │   ├── surah_detail_screen.dart    # Okuma ekranı; ScrollablePositionedList ile ayete atlama
    │   └── widgets/ayah_tile.dart, download_surah_button.dart
    ├── player/
    │   ├── audio_player_service.dart   # ⭐ Kuyruk + tekrar mantığı (QueueEntry: ayet + kaçıncı tekrar)
    │   ├── download_manager.dart       # ⭐ İndirme + resolveSource() (yerel dosya varsa onu, yoksa CDN)
    │   ├── player_providers.dart
    │   └── widgets/mini_player.dart
    └── settings/
        ├── settings_state.dart         # Immutable ayar durumu
        ├── settings_controller.dart    # Riverpod Notifier + shared_preferences kalıcılık
        ├── settings_screen.dart
        └── translation_editions.dart   # Meal listesi

test/
├── audio_cdn_test.dart        # URL kalıbı
├── quran_meta_test.dart       # 6236 ayet, global ayet no uçtan uca
└── ayah_reference_test.dart   # Arama ayrıştırma
```

⭐ = Faz 2'de tekrar kullanılacak kritik dosyalar.
**`quran_meta.dart` → `globalAyahNumber()`** özellikle önemli: widget'tan ses
çalarken de ayet numarasını mp3 URL'ine çevirmek için bu kullanılacak.

---

## 5. Veri kaynağı sözleşmesi

Ücretsiz, kayıt/anahtar gerektirmez.

**Metin/meal** — Al Quran Cloud:
```
GET https://api.alquran.cloud/v1/surah/{surahNo}/editions/{ed1},{ed2},{ed3}
```
Tek istekte birden fazla edition döner; `quran_api.dart` bunları
`numberInSurah` üzerinden tek `Ayah` listesine katlar.

**Ses** — islamic.network CDN (doğrudan mp3):
```
https://cdn.islamic.network/quran/audio/{bitrate}/{edition}/{globalAyahNumber}.mp3
örnek: https://cdn.islamic.network/quran/audio/128/ar.alafasy/262.mp3
```
`globalAyahNumber` = Kur'an geneli sıralı ayet no (1..6236),
`QuranMeta.globalAyahNumber(surahNumber:, ayahInSurah:)` ile hesaplanır.

**Varsayılan edition kimlikleri** (`core/constants.dart`):
| Amaç | Kimlik |
|---|---|
| Okuyucu | `ar.alafasy` (Mishary Afasy) |
| Arapça metin | `quran-uthmani` |
| Latin okunuş | `en.transliteration` |
| Meal | `tr.diyanet` |

Çekilen metinler `shared_preferences`'ta önbelleklenir (anahtar meal
kimliğine bağlı → meal değişince yeniden çekilir).

---

## 6. Faz 1'de biten özellikler

- **114 sure**, çevrimdışı sure listesi (meta gömülü, ağ gerekmez)
- **Akıllı arama:** `Rahman 11`, `55:11`, `Bakara 255`, `Kehf`, `36` — Türkçe
  diyakritikten bağımsız (â/î/û/ç/ğ/ı/ö/ş/ü normalize edilir)
- **Okuma ekranı:** Arapça (Uthmani) + Latin okunuş + meal, her biri ayrı
  açılıp kapanabilir; aranan ayete otomatik kaydırma
- **Ses çalar:** 6 okuyucu, ayet ayet çalma, sıralı otomatik geçiş,
  **ayet başına 1–20 tekrar** (ezber için), arka plan/kilit ekranı, mini oynatıcı
- **Çevrimdışı indirme:** sure bazında indirme, ilerleme göstergesi;
  `resolveSource()` yerel dosya varsa onu kullanır
- **Ayarlar:** okuyucu, meal, tema (açık/koyu/sistem), gösterim, tekrar sayısı — kalıcı
- **Tema:** zümrüt-altın palet, Amiri Arapça fontu, Türkçe arayüz

---

## 7. Faz 2 — YAPILACAKLAR (asıl özellik)

### 7a. Ezber veri modeli
`MemorizationItem`:
```dart
int surahNumber;
int ayahNumber;
int dailyTarget;        // kullanıcı belirler, ör. 5
int todayCount;         // bugün kaç kez dinlendi
DateTime lastResetDate; // gün değişimi tespiti için
WidgetTextMode textMode; // arabic | transliteration | translation
```
Kalıcılık: mevcut `shared_preferences` deseni yeterli; liste büyürse `drift`.

### 7b. Ana ekran widget'ı — **platform kısıtları (kritik)**

Paket: [`home_widget`](https://pub.dev/packages/home_widget)

**Android** — sorunsuz:
- `AppWidgetProvider` + `RemoteViews` layout
- Play butonu → `PendingIntent` → foreground audio service
- Widget içeriği: ayet metni (seçili modda) + `bugün X/Y` + play butonu

**iOS** — dikkat edilecek noktalar:
- Widget'tan butonla ses başlatma **yalnızca iOS 17+** mümkün
  (WidgetKit + App Intents)
- **Bilinen tuzak:** Background Modes → *Audio, AirPlay and Picture in Picture*
  açık olmalı **VE** ilgili widget kodu hem ana app hem widget extension
  hedefine üye olmalı. Aksi halde ses sessizce başlamıyor.
- **iOS 16 ve altı:** widget'a dokununca uygulama açılır ve ayet orada çalar
  (zarif düşüş — bu davranış kabul edildi)

### 7c. Sayaç mantığı
- Ayet **tam** dinlendiğinde (sonuna kadar) `todayCount++`
- Hedefe ulaşınca widget "tamamlandı" görünümü
- Yerel gün sınırında sıfırlama: `lastResetDate` bugünden farklıysa
  `todayCount = 0`

### 7d. Hatırlatma bildirimleri
- `flutter_local_notifications` + arka plan zamanlayıcı
  (`workmanager` veya `android_alarm_manager_plus`)
- Mesaj: "bugün X/Y okudun, biraz daha oku"
- Hedef dolunca bildirim gönderilmez
- Sıklık kullanıcı ayarı

### 7e. Widget yönetim ekranı
Ayet ekle/çıkar, günlük hedef sayı, metin modu, bildirim sıklığı.

---

## 8. Kurulum (sıfır makinede)

```bash
git clone -b claude/quran-memorization-app-yt4t4j https://github.com/tamertoker/ayetezberletici.git
cd ayetezberletici

flutter create .          # android/ ios/ üretir — lib/ ve pubspec korunur
flutter pub get
flutter analyze           # ⚠️ ilk kez koşuyor, hata bekleniyor
flutter test              # ⚠️ ilk kez koşuyor
flutter run
```

**Arka plan ses için native ayarlar** (AndroidManifest izinleri + servis,
iOS `UIBackgroundModes`) → **`README.md`** içinde kopyala-yapıştır bloklar
olarak hazır, "Arka plan ses için gerekli native ayarlar" bölümü.

---

## 9. Bilinen açıklar ve riskler

| Konu | Durum |
|---|---|
| Derleme/test | **Hiç koşulmadı** — ilk iş bu |
| `android/`, `ios/` | Yok, `flutter create .` gerekli |
| Meal edition kimlikleri | `tr.yazir`/`tr.vakfi`/`tr.ates` doğrulanmalı (`/edition`) |
| `surah_cache.dart` | `shared_preferences` kullanıyor; tüm Kur'an önbelleklenirse boyut sorun olabilir → `drift`/sqflite düşünülmeli |
| Mekkî/Medenî etiketi | `quran_meta.dart`'ta "en iyi çaba"; API değeri esas alınabilir |
| Ayet sayıları | ✅ Doğrulandı (toplam 6236, testli) |
| Lisans/atıf | alquran.cloud & islamic.network kullanım koşulları üretimde gözetilmeli |

---

## 10. Codex'e verilecek başlangıç promptu

> Bu bir Flutter projesi: Kur'an ayeti ezberletme uygulaması (Android + iOS).
> Depo kökündeki `HANDOFF.md` ve `README.md` dosyalarını oku — proje durumu,
> mimari, veri kaynağı ve yol haritası orada.
>
> Önemli: Kod daha önce hiç derlenmedi ve `android/`/`ios/` klasörleri yok.
>
> İlk görevin:
> 1. `flutter create .` ile platform klasörlerini üret
> 2. `flutter pub get`, `flutter analyze`, `flutter test` çalıştır
> 3. Çıkan tüm derleme/lint/test hatalarını düzelt
> 4. Uygulamayı çalıştırıp Faz 1 özelliklerinin (sure listesi, arama, okuma
>    ekranı, ses çalma) çalıştığını doğrula
>
> Bunlar bittikten sonra `HANDOFF.md` bölüm 7'deki Faz 2'ye (ana ekran
> widget'ı + günlük sayaç + bildirimler) geçeceğiz. iOS widget kısıtlarına
> (bölüm 7b) dikkat et.
