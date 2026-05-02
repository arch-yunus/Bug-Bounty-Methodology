# Cross-Site Scripting (XSS) Zafiyetleri

XSS, saldırganın hedef web sitesine, genellikle JavaScript olmak üzere, zararlı betikler (script) enjekte etmesine olanak tanıyan bir zafiyettir. Bu betikler diğer kullanıcıların tarayıcısında çalışarak çerezlerin (cookies), oturum tokenlarının veya hassas bilgilerin çalınmasına yol açar.

## 1. Reflected XSS (Yansıyan XSS)
Kullanıcı girdisinin, sunucu tarafından anında işlenip web sayfasına doğrulanmadan (sanitize edilmeden) yansıtılmasıdır.

- **Karakteristik:** Kalıcı değildir, saldırı genellikle bir oltalama (phishing) e-postası veya zararlı bir link aracılığıyla yapılır.
- **Nerelerde Aranmalı:** Arama kutuları, hata mesajları, filtrelenen sonuçlar.
- **Basit Test Payload'ı:** `<script>alert(1)</script>`
- **Eğer `script` tagi filtreleniyorsa:** `<img src=x onerror=alert(1)>` veya `<svg onload=alert(1)>`

## 2. Stored XSS (Kalıcı XSS)
Zararlı betiğin doğrudan sunucunun veritabanına kaydedilmesi ve o sayfayı görüntüleyen her kullanıcıda otomatik olarak çalışmasıdır. En tehlikeli XSS türüdür.

- **Karakteristik:** Hedef sayfayı ziyaret eden herkes etkilenir.
- **Nerelerde Aranmalı:** Yorum alanları, profil güncellemeleri (isim, biyografi), mesajlaşma sistemleri, forum gönderileri.
- **Etki:** Bir yönetici (Admin) zafiyetli sayfayı ziyaret ettiğinde, zararlı script yönetici yetkileriyle işlem yapabilir (Örn: yeni admin ekleme).

## 3. DOM-Based XSS (DOM Tabanlı XSS)
Zafiyetin sunucu tarafında değil, tamamen istemci tarafında (tarayıcıda), JavaScript kodunun (DOM - Document Object Model) veriyi güvensiz işlemesiyle oluşmasıdır.

- **Karakteristik:** İstek sunucuya gitse bile, zararlı payload sunucu yanıtında (response body) görünmez. `Location`, `document.write`, `eval()`, `innerHTML` gibi tehlikeli (sink) fonksiyonlardan kaynaklanır.
- **Nerelerde Aranmalı:** URL fragment'ları (`#` sonrası), `window.location` kullanan yönlendirmeler.
- **Test:** `https://hedef.com/page#<script>alert(1)</script>`

## 4. XSS Bypass Teknikleri (Filtreleri Aşma)
Web Uygulama Güvenlik Duvarları (WAF) veya basit filtreler XSS'i engellemeye çalışır.

- **Encoding:** `<` veya `>` karakterlerini URL (%3C, %3E), HTML Entities (`&lt;`, `&gt;`) veya Hex şeklinde kodlayarak yollamak.
- **Büyük/Küçük Harf:** `<ScRiPt>alert(1)</sCrIpT>`
- **İç İçe Tagler:** `<scr<script>ipt>alert(1)</script>` (Filtre sadece `<script>` i siliyorsa, geriye bir script tagi daha kalır).
- **JavaScript Pseudoprotocol:** `javascript:alert(1)` (Özellikle `<a href="...">` içine veri giriliyorsa).

## 5. XSS to RCE (Remote Code Execution)
Özellikle ElectronJS tabanlı masaüstü uygulamalarında (Discord, Slack, Notion) veya Headless Chrome kullanan PDF dönüştürücülerde, basit bir XSS zafiyeti NodeJS yetenekleriyle birleşip işletim sisteminde komut çalıştırmaya (RCE) dönüşebilir.
