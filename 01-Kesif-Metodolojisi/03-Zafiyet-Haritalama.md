# Zafiyet Haritalama (Vulnerability Mapping)

Keşif aşamalarından elde edilen devasa veriyi anlamlandırma ve saldırı yüzeyini haritalandırma aşamasıdır. Rastgele saldırmak yerine stratejik test noktaları belirlenir.

## 1. Canlı Hedeflerin Belirlenmesi
Bulunan yüzlerce veya binlerce subdomain'den hangilerinin gerçekten web servisi çalıştırdığını filtrelemek.

- **Araçlar:** `httprobe`, `httpx`
- **Taktik:** `cat subdomains.txt | httpx -silent -status-code -title > alive.txt`

## 2. Görsel Haritalama (Screenshotting)
Canlı hedeflerin çokluğu durumunda, hepsini tek tek tarayıcıda açmak yerine ekran görüntülerini alıp görsel olarak incelemek büyük vakit kazandırır.

- **Araçlar:** `Aquatone`, `Gowitness`, `EyeWitness`
- **Odak Noktası:** Alışılmadık login ekranları, varsayılan kurulum sayfaları (Apache/Nginx default pages), hata mesajı gösteren sayfalar.

## 3. API Uç Noktalarının Çıkarımı
Modern web uygulamaları genellikle API tabanlıdır (REST, GraphQL). JavaScript dosyaları içerisinden API route'larını toplamak kritik önem taşır.

- **Araçlar:** `LinkFinder`, `SecretFinder`, `Katana`
- **Yöntem:**
  1. Hedeften JS dosyalarını çek.
  2. JS dosyaları içindeki `/api/v1/xyz` benzeri endpointleri ayrıştır.
  3. API anahtarları (API Keys) veya hardcoded (koda gömülü) şifreleri ara.

## 4. Uygulama Mantığını Anlamak (Business Logic)
Hedefi bir zafiyet tarayıcısına vermeden önce manuel olarak uygulamanın nasıl çalıştığını anlamak.

- **Adımlar:**
  1. Uygulamaya kullanıcı (User) ve yetkili (Admin/Pro) olarak iki farklı hesap aç.
  2. Burp Suite'i arkada açık tutarak tüm siteyi manuel olarak dolaş (Spidering).
  3. Ödeme, şifre sıfırlama, profil güncelleme gibi kritik fonksiyonların request/response yapılarını incele.
  4. Yetki sınırlarını test etmek için IDOR (Insecure Direct Object Reference) noktalarını not al.

## 5. Zafiyet Taraması (Otomatize)
Haritalama bittikten sonra belirli, dar hedefler üzerinde zafiyet tarayıcılar çalıştırılabilir.

- **Araçlar:** `Nuclei`, `Burp Suite Professional Scanner`, `Acunetix` (varsa)
- **Uyarı:** Sadece bilinçli hedeflerde çalıştırılmalı ve yanlış pozitiflere (False Positive) dikkat edilmelidir. Özellikle `Nuclei` ile hedefe uygun spesifik şablonlar (templates) çalıştırılması daha etkilidir.
