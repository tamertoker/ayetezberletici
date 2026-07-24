# Ayet Ezberletici

Günlük hayata Kur'an okumayı sığdırmayı kolaylaştıran, **ayet ezberletme** odaklı
bir mobil uygulama (Android + iOS, Flutter).

> **Durum:** Faz 1 (sağlam temel) tamamlandı — Kur'an okuma, Afasy (ve diğer
> okuyucular) ile ayet ayet ses çalma, sıralı çalma + tekrar, çevrimdışı indirme,
> arama ve ayarlar. Faz 2 (ana ekran widget'ı + günlük sayaç + hatırlatma
> bildirimleri) yol haritasındadır (aşağıya bakın).

## Ana Özellikler (Faz 1)

- **114 sure**, çevrimdışı sure listesi (meta veri gömülü).
- **Ayet ayet ses**: varsayılan okuyucu **Mishary Rashid Alafasy**; ayarlardan
  değiştirilebilir (Abdulbasit, Husary, Minshawi, Ayyoub, Shatri).
- **Okuma ekranı**: Arapça (Uthmani), Latin okunuş ve meal — her biri ayrı
  açılıp kapatılabilir.
- **Sıralı çalma + tekrar**: seçilen ayetten itibaren otomatik ilerleme; her
  ayet ayarlanan sayıda (1–20) arka arkaya çalınır (ezber için).
- **Arka planda / kilit ekranında çalma** (`just_audio_background`).
- **Çevrimdışı indirme**: bir sureyi indirip internetsiz dinleme.
- **Akıllı arama**: `Rahman 11`, `55:11`, `Bakara 255`, `Kehf`, `36` gibi
  sorgular (Türkçe diyakritikten bağımsız).
- **Ayarlar**: okuyucu, meal, tema (açık/koyu/sistem), gösterim, tekrar sayısı.

## Veri Kaynağı

Ücretsiz, kayıt/anahtar gerektirmeyen **Al Quran Cloud** ekosistemi:

- Metin/meal: `https://api.alquran.cloud/v1`
- Ayet sesi (CDN): `https://cdn.islamic.network/quran/audio/{bitrate}/{edition}/{globalAyah}.mp3`

Çekilen metinler cihazda önbelleğe alınır (sonraki açılışlar hızlı ve büyük
ölçüde çevrimdışı).

## Mimari

Katmanlı, feature-first yapı; state yönetimi **Riverpod**.

```
lib/
  main.dart / app.dart          # giriş, tema, ProviderScope
  app_providers.dart            # api, cache, repository sağlayıcıları
  core/
    constants.dart              # API/CDN sabitleri, pref anahtarları
    theme/                      # renkler + açık/koyu tema (Arapça: Amiri)
    utils/ayah_reference.dart   # "Rahman 11" -> sure/ayet ayrıştırma (saf Dart)
  data/
    models/                     # Surah, Ayah, Edition, Reciter
    sources/
      quran_api.dart            # alquran.cloud REST (çoklu edition tek istek)
      audio_cdn.dart            # ayet mp3 URL üretimi (saf Dart)
      quran_meta.dart           # 114 sure meta + global ayet no hesabı
      surah_cache.dart          # metin önbelleği (shared_preferences)
    repositories/quran_repository.dart
  features/
    reader/                     # sure listesi, okuma, arama
    player/                     # just_audio servis, indirme, mini player
    settings/                   # okuyucu/meal/tema/gösterim/tekrar
```

Saf mantık (URL üretimi, meta hesapları, arama ayrıştırma) Flutter'dan bağımsız
tutulmuştur ve `test/` altında birim testleriyle doğrulanır.

## Kurulum ve Çalıştırma

Ön koşul: [Flutter SDK](https://docs.flutter.dev/get-started/install) (≥ 3.22).

Bu depo `lib/`, `test/` ve `pubspec.yaml` içerir; platform klasörleri
(`android/`, `ios/`) sürüm kontrolüne dahil edilmemiştir. İlk kurulumda bunları
üretin:

```bash
# Proje kökünde — mevcut lib/ ve pubspec'i KORUYARAK android/ios üretir
flutter create .

flutter pub get
flutter run            # bağlı cihaz/emülatörde çalıştır
```

### Arka plan ses için gerekli native ayarlar

`flutter create .` sonrası, kilit ekranı/arka plan çalma için şu eklemeleri
yapın (`just_audio_background` gereksinimi):

**Android** — `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.WAKE_LOCK"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>

  <application ...>
    <!-- ... mevcut activity ... -->
    <service
        android:name="com.ryanheise.audioservice.AudioService"
        android:foregroundServiceType="mediaPlayback"
        android:exported="true">
      <intent-filter>
        <action android:name="android.media.browse.MediaBrowserService"/>
      </intent-filter>
    </service>
    <receiver
        android:name="com.ryanheise.audioservice.MediaButtonReceiver"
        android:exported="true">
      <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON"/>
      </intent-filter>
    </receiver>
  </application>
</manifest>
```

**iOS** — `ios/Runner/Info.plist` içine ekleyin:

```xml
<key>UIBackgroundModes</key>
<array>
  <string>audio</string>
</array>
```

Xcode'da: Runner hedefi → Signing & Capabilities → **Background Modes** →
*Audio, AirPlay, and Picture in Picture* açık olmalı.

## Testler

```bash
flutter test          # birim testleri
flutter analyze       # statik analiz / lint
```

Kapsanan saf-mantık testleri:
- `test/audio_cdn_test.dart` — ses URL kalıbı.
- `test/quran_meta_test.dart` — toplam 6236 ayet, global ayet numarası uçtan uca.
- `test/ayah_reference_test.dart` — arama ayrıştırma (`Rahman 11`, `55:11`, ...).

## Faz 2 — Yol Haritası (Widget + Bildirim + Ezber Takibi)

Asıl "can alıcı" özellik bu fazda gelir:

1. **Ezber modeli**: ana ekrana eklenen ayet(ler), günlük hedef okuma sayısı,
   bugünkü okunan sayı (gün değişince sıfırlanır), widget metin modu
   (Arapça/Latin/meal).
2. **Ana ekran widget'ı** (`home_widget`):
   - **Android**: `AppWidgetProvider` + `RemoteViews`; ayet metni + "bugün 1/5"
     sayacı + play butonu (mevcut ses altyapısını kullanır). Dinleme bitince
     sayaç +1, widget güncellenir.
   - **iOS 17+**: WidgetKit extension + App Intent'li buton (Background Audio;
     widget kodu app & extension hedeflerinde üye). iOS 16 ve altında widget'a
     dokununca uygulama açılır ve orada çalar (zarif düşüş).
3. **Sayaç mantığı**: tam dinleme → +1; hedefe ulaşınca "tamamlandı" durumu;
   yerel gün sınırında sıfırlama.
4. **Hatırlatma bildirimleri** (`flutter_local_notifications` + arka plan
   zamanlayıcı): "bugün X/Y okudun, biraz daha oku"; hedef dolunca kesilir.
5. **Widget yönetim ekranı**: ayet ekle/çıkar, hedef sayı, metin modu, bildirim
   sıklığı.

## Notlar

- Meal/metin ve ses telifsiz kaynaklardan alınır; üretim kullanımında
  alquran.cloud / islamic.network kullanım koşulları ve atıf gözetilmelidir.
- İniş yeri (Mekkî/Medenî) etiketi çevrimdışı meta'da en iyi çabadır; API değeri
  gerektiğinde esas alınır.
