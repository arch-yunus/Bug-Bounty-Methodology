# Genel Zafiyet Rapor Taslağı (Vulnerability Report Template)

HackerOne, Bugcrowd veya bağımsız VDP (Vulnerability Disclosure Program) programlarına rapor gönderirken aşağıdaki formatı kullanın. Açık, net ve tekrarlanabilir bir rapor, "Triage" ekibinin işini kolaylaştırır ve ödül (Bounty) miktarını olumlu etkiler.

---

## 📌 Zafiyet Başlığı (Title)
*[Kısa, öz ve zafiyetin türünü + nerede olduğunu belirten bir başlık.]*
**Örnek:** `[example.com] - IDOR in /api/v1/user_profile allows account takeover`

## 🔴 Kritiklik Seviyesi (Severity / CVSS)
*[CVSS 3.1 hesaplayıcısı kullanılarak belirlenen skor. Örn: High 8.5]*

## 📝 Özet (Description)
*[Zafiyetin ne olduğu, hangi parametreden veya bileşenden kaynaklandığı hakkında kısa bir paragraf. Fazla uzatmadan sadede gelin.]*

**Örnek:**
Sayın yetkili,
`https://example.com/api/v1/update` uç noktasında bulunan `user_id` parametresinde IDOR (Insecure Direct Object Reference) zafiyeti tespit ettim. Bu zafiyet, herhangi bir kullanıcının diğer kullanıcıların özel bilgilerini (telefon, adres) değiştirmesine olanak tanımaktadır.

## 🛠️ Yeniden Üretme Adımları (Steps to Reproduce)
*[Triage ekibinin hatayı kendi bilgisayarında aynen tetikleyebilmesi için adım adım liste. Gerekirse ekran görüntüsü veya video linki ekleyin.]*

1.  Uygulamada Saldırgan (Attacker) olarak bir hesap oluşturun ve giriş yapın.
2.  Profil güncelleme sayfasına gidin ve bilgilerinizi değiştirerek "Kaydet" butonuna basın.
3.  Giden HTTP POST isteğini Burp Suite ile yakalayın.
4.  İstek gövdesindeki (body) `{"user_id": 1001}` değerini `{"user_id": 1002}` (Kurbanın ID'si) olarak değiştirin.
5.  İsteği sunucuya gönderin. Sunucudan `200 OK` yanıtı döndüğünü göreceksiniz.
6.  Kurbanın profiline gidildiğinde bilgilerin saldırgan tarafından değiştirilmiş olduğu doğrulanabilir.

## 💥 Etki (Impact)
*[Bu zafiyetin iş birimi ve kullanıcılar üzerindeki gerçek dünya etkisi nedir? Neden önemli?]*

**Örnek:**
Saldırganlar, bu zafiyeti kullanarak platformdaki tüm kullanıcıların kişisel verilerini manipüle edebilir. Bu durum veri bütünlüğünü bozar ve hesap ele geçirme (Account Takeover) senaryolarına yol açabilir.

## 🛡️ Çözüm Önerisi (Remediation / Mitigation)
*[Geliştirici ekibe bu hatayı nasıl düzelteceklerine dair kısa bir öneri.]*

**Örnek:**
Kullanıcıların kendi verilerine erişimini sadece ID parametresi üzerinden değil, sunucu tarafındaki oturum (Session) bilgisi ile doğrulanması gerekmektedir. Kullanıcının değiştirmek istediği `user_id` ile sistemde oturum açmış kullanıcının (Session) `user_id`'si eşleşmediği durumlarda işlem `403 Forbidden` ile reddedilmelidir.

---

### Ekler (Attachments)
*   Burp Suite HTTP İstek ve Yanıt Logu (Raw HTTP Request/Response)
*   Ekran görüntüleri (PoC.png)
