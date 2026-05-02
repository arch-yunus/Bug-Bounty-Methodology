# Erişim Kontrol Hataları (Access Control Vulnerabilities)

Erişim kontrol hataları (Broken Access Control), web uygulamalarındaki en yaygın ve kritik zafiyetlerden biridir (OWASP Top 1). Kullanıcıların kendi yetki sınırlarının dışına çıkıp işlem yapabilmesine neden olur.

## 1. IDOR (Insecure Direct Object Reference)
Kullanıcıya sunulan referans değerlerinin (ID'ler, dosya isimleri, numaralar) doğrulanmadan arka planda işlenmesidir.

- **Nasıl Test Edilir?**
  1. `User A` ve `User B` adında iki hesap oluşturun.
  2. `User A` için bir kaynak oluşturun (Örn: Profil güncelleme, sipariş numarası `id=1001`).
  3. İsteği Burp Suite ile yakalayın ve `id=1001` değerini `id=1002` (User B'nin id'si) olarak değiştirin.
  4. Eğer işlem `User B`'nin verisi üzerinde başarıyla gerçekleşirse IDOR vardır.
- **Gizli Parametreler:** Bazen UI üzerinde ID görünmez, isteğe (POST body veya JSON) manuel olarak `{"user_id": 1234}` ekleyerek denemeler yapılmalıdır.

## 2. Yetki Yükseltme (Privilege Escalation)
Düşük yetkili bir kullanıcının, dikey (Vertical) veya yatay (Horizontal) olarak kendisinde olmaması gereken hakları elde etmesi.

- **Dikey Yetki Yükseltme:** Normal bir kullanıcının yönetici (Admin) yetkilerini alması.
  - Örnek: Rol parametresi manipülasyonu. JSON içinde `{"role": "user"}` değerini `{"role": "admin"}` yapmak.
- **Yatay Yetki Yükseltme:** Kullanıcının, kendi yetki seviyesindeki başka bir kullanıcının hesabına erişmesi (Genellikle IDOR ile iç içedir).

## 3. Zorunlu Tarama ve Yetkisiz Sayfa Erişimi (Forceful Browsing)
Sadece giriş yapmış kullanıcıların veya yöneticilerin erişebildiği dizin veya sayfalara doğrudan URL üzerinden erişmeye çalışmak.

- **Örnek:** `https://hedef.com/admin/dashboard`
- Sadece UI'daki butonu gizlemek bir güvenlik önlemi değildir. Sunucu tarafında erişim yetkisi mutlaka kontrol edilmelidir.

## 4. CORS (Cross-Origin Resource Sharing) Yanlış Yapılandırmaları
Sunucunun, hangi domainlerin kendisinden veri çekebileceğini belirleyen mekanizmadır.

- **Zafiyet:** Eğer hedef site `Access-Control-Allow-Origin: *` veya isteği gönderen hedefin (Origin) adını yansıtarak `Access-Control-Allow-Credentials: true` yanıtını veriyorsa, bir saldırgan kullanıcının tarayıcısı üzerinden hedef siteden hassas verileri (cookie, token, özel bilgiler) okuyabilir.
- **Test Aracı:** `CORScanner`, Burp Suite CORS modülleri.
- **Örnek Yük (Payload):** İstek başlığına `Origin: https://saldirgan.com` eklendiğinde cevap başlığında `Access-Control-Allow-Origin: https://saldirgan.com` dönüyorsa tehlikelidir.

## 5. Güvensiz CORS ve CSRF (Cross-Site Request Forgery) Farkı
CORS veri *okumaya* yöneliktir, CSRF ise kullanıcının haberi olmadan işlem *yaptırmaya* (veri yazmaya/değiştirmeye) yöneliktir. Her ikisi de kullanıcı oturumu üzerinden çalışır.
