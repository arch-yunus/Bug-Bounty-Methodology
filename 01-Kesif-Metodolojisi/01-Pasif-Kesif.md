# Pasif Keşif (Passive Reconnaissance) Metodolojisi

Pasif keşif, hedefin haberi olmadan, sistemlerine herhangi bir paket göndermeden veya doğrudan temas kurmadan bilgi toplama sürecidir. Genellikle OSINT (Open-Source Intelligence) araçları ve halka açık veritabanları kullanılır.

## 1. WHOIS ve DNS Kayıtlarının İncelenmesi
Hedefin kayıt bilgilerini, kime ait olduğunu ve kullanımdaki DNS sunucularını belirlemek ilk adımdır.

- **Araçlar:** `whois`, `nslookup`, `dig`, `host`
- **Hedefler:**
  - Alan adının kayıt tarihi ve bitiş tarihi.
  - Şirkete veya kişiye ait e-posta adresleri (Reverse WHOIS ile benzer domainler bulunabilir).
  - İsim sunucuları (Nameservers).

## 2. Arama Motoru Dorkları (Google / Github Dorks)
Halka açık verilerde yanlışlıkla sızdırılmış hassas dosyaları veya sistemleri bulmak için kullanılır.

- **Google Dorks:**
  - `site:example.com ext:pdf | ext:doc | ext:xlsx` (Hassas dokümanlar)
  - `site:example.com inurl:admin | inurl:login` (Yönetim panelleri)
  - `site:example.com intitle:"index of"` (Açık dizinler - Directory Listing)
- **GitHub Dorks:**
  - `org:example "password" | "token" | "API_KEY"`
  - `org:example filename:.env`
  - `org:example extension:pem private`

## 3. Sertifika Şeffaflığı (Certificate Transparency - CT) Kayıtları
SSL/TLS sertifikaları üzerinden hedefin alt alan adlarını (subdomains) tespit etmek oldukça etkili bir pasif keşif yöntemidir.

- **Araçlar:** `crt.sh`, `Cert Spotter`, `Censys`
- **Taktik:** `https://crt.sh/?q=%.example.com` üzerinden yapılan sorgular, hedefin tüm bilinen alt alan adlarını ortaya çıkarabilir.

## 4. İnternet Arşivleri (Wayback Machine)
Hedefin geçmişteki sayfaları, şu an yayında olmayan ama hala erişilebilir durumda olabilecek eski API uç noktaları (endpoints) veya test sayfalarını bulmak için kullanılır.

- **Araçlar:** `waybackurls`, `gau` (Get All Urls)
- **Kullanım:** `echo "example.com" | waybackurls > urls.txt`

## 5. IP ve Altyapı Tespiti
Hedefin hangi hosting sağlayıcısını, WAF (Web Application Firewall) veya CDN (Content Delivery Network) kullandığını belirlemek.

- **Araçlar:** `BGPView`, `Hurricane Electric BGP Toolkit`, `Shodan`, `Censys`
- **Hedefler:** Hedefin ASN (Autonomous System Number) numarasını bulmak ve bu ASN'ye ait IP bloklarını tespit etmek.
