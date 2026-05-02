# Altyapı Zafiyetleri (Infrastructure Vulnerabilities)

Altyapı zafiyetleri, yazılımın kodundan ziyade, üzerinde çalıştığı sistemin (bulut, sunucu, DNS) yapılandırma hatalarından kaynaklanır.

## 1. Alt Alan Adı Devralma (Subdomain Takeover)
Bir alt alan adının (örn: `blog.hedef.com`) bir dış servise (Github Pages, AWS S3, Heroku) CNAME veya A kaydı ile yönlendirilmiş olması, ancak dış servisteki asıl projenin silinmiş veya süresinin dolmuş olması durumudur.

- **Tehlike:** Saldırgan, ilgili dış servise gidip aynı isimle bir proje oluşturarak alt alan adını tamamen kendi kontrolüne alabilir. Bu da oltalama (phishing) veya Cookie çalmak (Session Hijacking) için kullanılır.
- **Araçlar:** `subzy`, `nuclei`, `takeover`
- **Nasıl Anlaşılır?** Tarayıcıda açtığınızda `404 Not Found`, `NoSuchBucket`, `There isn't a Github Pages site here` gibi hata mesajları görünüyorsa yüksek ihtimalle takeover mevcuttur.

## 2. Hassas Dosya İfşası (Sensitive Information Disclosure)
Geliştiricilerin web kök dizininde (root) unutmaması gereken dosyaları unutmasıdır.

- **.git Klasörü İfşası:** Sitenin kaynak kodlarının (ve içindeki tüm şifrelerin) indirilmesine olanak tanır.
  - Araç: `GitTools`, `git-dumper`
- **.env Dosyası:** Ortam değişkenlerini tutar. Veritabanı şifreleri, AWS anahtarları (AWS Key) barındırır. (`https://hedef.com/.env`)
- **Yedek Dosyalar:** `backup.zip`, `database.sql`, `config.php.bak` gibi dosyalar kritik veri sızıntılarına neden olur.

## 3. Bulut Depolama (S3 / Azure) Yapılandırma Hataları
Özellikle Amazon AWS S3 Bucket'larının dışarıdan okuma veya yazmaya açık (Public) unutulmasıdır.

- **Tehlike:** Eğer sadece okumaya açıksa veriler çalınır. Eğer *yazmaya* açıksa, saldırgan hedefin sitesindeki görselleri veya javascript dosyalarını zararlı dosyalarla değiştirebilir.
- **Test:** AWS CLI kullanarak. `aws s3 ls s3://bucket-ismi --no-sign-request`
- **Araçlar:** `S3Scanner`, `cloud_enum`

## 4. SSRF (Server-Side Request Forgery)
Saldırganın, hedef sunucuyu kullanarak sunucunun erişebildiği iç ağa (Intranet) veya dış sistemlere istek yapmaya zorlamasıdır.

- **Kritiklik:** Özellikle bulut (AWS/GCP/Azure) ortamlarında çalışıyorsa, metadata servislerine (örn: `http://169.254.169.254/latest/meta-data/`) erişip sunucunun root yetkisindeki kimlik bilgilerini (IAM Roles) çekebilir.
- **Nerelerde Aranır?** URL, IP veya dosya linki alan parametreler (Profil fotoğrafı yükleme, PDF oluşturma, Webhook entegrasyonları).
- **Test:** Burp Collaborator veya pingb.in gibi servislerden bir link verilerek hedef sunucunun dışarıya istek yapıp yapmadığı kontrol edilir.

## 5. Web Cache Deception (Web Önbellek Yanıltmacası)
CDN'lerin (Cloudflare, Akamai vb.) statik dosyaları (.jpg, .css) önbellekleme (cache) mantığının suistimal edilmesidir.

- **Yöntem:** Kullanıcı kendi profil (gizli) sayfasına bir statik uzantı ekleyerek (Örn: `https://hedef.com/profile.php/nonexistent.css`) istek yapar. Sunucu gizli profil sayfasını oluşturur, ancak aradaki CDN, url'nin sonunun `.css` olduğunu görüp bu hassas veriyi *herkese açık* olan önbelleğine kaydeder.
- Saldırgan daha sonra aynı URL'ye giderek o kullanıcının gizli bilgilerini CDN'den okuyabilir.
