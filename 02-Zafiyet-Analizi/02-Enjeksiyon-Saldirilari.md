# Enjeksiyon Saldırıları (Injection Vulnerabilities)

Enjeksiyon, kullanıcıdan alınan verilerin güvenilmeyen bir şekilde kod, komut veya sorgu olarak yorumlayıcıya (interpreter) gönderilmesiyle ortaya çıkar.

## 1. SQL Injection (SQLi)
Uygulamanın veritabanı sorgularına dışarıdan müdahale edilmesidir.

- **Temel Test Noktaları:** URL parametreleri (`?id=1`), arama kutuları, login formları, HTTP Header'lar (User-Agent vb.).
- **Tetikleyici Karakterler:** `'`, `"`, `#`, `--`, `;`
- **Türleri:**
  - *In-Band (Error-based / Union-based):* Hata mesajları veya sonuçlar doğrudan sayfada görünür.
  - *Blind (Boolean/Time-based):* Sonuç sayfaya yansımaz. Sayfanın farklı davranmasından (True/False durumu) veya gecikmeli yanıt vermesinden (`SLEEP(10)`) anlaşılır.
- **Araçlar:** `SQLMap`, `ghauri`

## 2. Command Injection (Komut Enjeksiyonu)
Kullanıcı girdisinin, sunucu işletim sisteminde terminal komutu olarak çalıştırılmasıdır.

- **Sık Rastlanan Senaryolar:** Ping araçları, dosya dönüştürücüler, imaj işleme işlemleri.
- **Tetikleyiciler:** `;`, `|`, `&&`, `$()`, `` ` `` (backtick)
- **Örnek Test:** `ip=127.0.0.1; cat /etc/passwd` veya `ip=127.0.0.1 && whoami`
- **Araçlar:** `Commix`

## 3. Server-Side Template Injection (SSTI)
Web uygulamalarında HTML şablon motorlarının (Jinja2, Twig, Freemarker) kullanıcı girdisini güvenilmeyen bir şekilde işlemesinden kaynaklanır. Uzaktan kod yürütmeye (RCE) kadar gidebilir.

- **Nasıl Tespit Edilir?**
  Kullanıcı girdisine matematiksel ifadeler ekleyerek şablon motorunun bunu hesaplayıp hesaplamadığını kontrol edin.
  - Payload: `${7*7}`, `{{7*7}}`, `<%= 7*7 %>`
  - Eğer sonuç ekranda `49` olarak yansıyorsa zafiyet vardır.
- **Araçlar:** `Tplmap`, Burp Suite SSTI modülleri.

## 4. XML External Entity (XXE) Enjeksiyonu
XML dosyalarının ayrıştırılması (parsing) sırasında, güvenilmeyen harici varlıkların (entities) işlenmesiyle oluşur. Sunucudan dosya okunmasına, SSRF'e veya DoS saldırılarına sebep olabilir.

- **Test Yöntemi:** XML girdisi alan yerlere harici bir entity tanımlayıp çağırmak.
- **Payload Örneği:**
  ```xml
  <?xml version="1.0" encoding="ISO-8859-1"?>
  <!DOCTYPE foo [
    <!ELEMENT foo ANY >
    <!ENTITY xxe SYSTEM "file:///etc/passwd" >]>
  <foo>&xxe;</foo>
  ```

## 5. Host Header Injection
HTTP `Host` başlığının manipüle edilmesidir. Genellikle parola sıfırlama maillerinde zararlı link gönderilmesine (Password Reset Poisoning) veya web önbelleğini zehirlemeye (Web Cache Poisoning) yol açar.
