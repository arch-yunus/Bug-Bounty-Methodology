# İş Mantığı Hataları (Business Logic Vulnerabilities)

İş mantığı hataları, uygulamanın teknik altyapısındaki bir hatadan (örneğin SQLi veya XSS) ziyade, yazılımın **tasarımında veya çalışma akışında** yapılan mantıksal kurgu hatalarıdır. Otomatize araçlarla (tarayıcılar) bulunması neredeyse imkansızdır, uygulamanın nasıl çalıştığını iyi analiz etmeyi gerektirir.

## 1. Ödeme ve Sepet Manipülasyonları
E-ticaret sistemlerinde en çok aranan hatalardır.

- **Fiyat Manipülasyonu:** Sepete ürün eklerken isteği (request) yakalayıp fiyat (price) parametresini değiştirmek. Örneğin `price=100.00` değerini `price=0.01` yapmak.
- **Adet (Quantity) Manipülasyonu:** Adet kısmına negatif bir değer (`-1`) girmek. Eğer sistem bunu kontrol etmiyorsa, sepetteki diğer ürünlerin toplam tutarını düşürebilir ve faturayı eksiye düşürüp para iadesi bile sağlayabilir.
- **Para Birimi Değiştirme:** İşlem sırasında para birimi (currency) `USD` iken `TRY` olarak değiştirmek. Sistem tutarı güncellemeyip aynı sayıyı baz alabilir (Örn: 100 USD yerine 100 TRY ödemek).

## 2. Şifre Sıfırlama (Password Reset) Akışı Hataları
Hesap ele geçirmeye (Account Takeover - ATO) giden en yaygın yoldur.

- **Token Sızıntısı:** Şifre sıfırlama token'ının referer header'da veya dışarıya giden bir analitik isteğinde (Google Analytics vb.) ifşa olması.
- **Host Header Zehirlenmesi:** Şifre sıfırlama talebinde `Host: hedef.com` kısmını `Host: saldirgan.com` yaparak kurbana giden e-postadaki linki değiştirmek.
- **Farklı E-posta ile Talep:** Talebi yaparken HTTP isteğine `{"email":"kurban@mail.com", "email":"saldirgan@mail.com"}` (Parameter Pollution) eklemek.
- **Token Tahmin Edilebilirliği:** Eğer token sadece MD5(KullanıcıAdı + Tarih) ise, bu kolayca kırılarak saldırgan tarafından kendi bilgisayarında üretilebilir.

## 3. Davetiye ve Kayıt Sistemleri
- Sadece belirli kişilere açık olan veya şirket e-postası (örn: `@sirket.com`) gerektiren sistemlere, ikincil bir e-posta parametresi ekleyerek (Örn: `email=hacker@mail.com&email=admin@sirket.com`) veya boşluk (` `) manipülasyonuyla kayıt olmak.
- Premium özelliklere sahip hesapların davetiye linklerini tekrar tekrar (Replay Attack) kullanarak birden fazla hesaba premium özellik tanımlamak.

## 4. Promosyon ve Kupon Kodları (Race Condition / TOCTOU)
Bir sistemin iki işlemi neredeyse aynı anda işlemesi sonucu oluşan tutarsızlıklardır (Time of Check to Time of Use).

- **Senaryo:** Tek kullanımlık %50 indirim kuponunuz var. Eğer bu kuponu Burp Suite'in `Intruder` (Null Payloads) özelliği ile veya `Turbo Intruder` eklentisiyle sisteme aynı milisaniyede 20 kere gönderirseniz, sistem kuponun kullanılıp kullanılmadığını veritabanına yazana kadar, kupon birden fazla kez kabul edilebilir ve sepet tutarı sıfırlanabilir.

## 5. Doğrulama (OTP/2FA) Bypass
- Telefon numarasına veya maile gelen 4-6 haneli kodların (OTP) brute-force koruması olmaması. (Örn: 0000-9999 arasını Burp ile hızlıca denemek).
- İstek içinde durum parametrelerini değiştirmek. `{"success": false}` dönen bir OTP doğrulama yanıtını Burp'ün "Match and Replace" özelliği ile `{"success": true}` yaparak uygulamanın istemci (frontend) tarafını kandırmak.
