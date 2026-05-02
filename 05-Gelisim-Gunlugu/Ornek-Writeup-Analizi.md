# Örnek Write-Up Analizi Şablonu

**Write-Up Linki:** https://hackerone.com/reports/XXXXXX
**Bulunan Zafiyet:** (Örn: Account Takeover via Password Reset Poisoning)
**Ödenen Ödül (Bounty):** (Örn: $2,500)

## 1. Zafiyetin Özeti
*(Hacker bu hatayı nasıl bulmuş? Sistemdeki asıl kusur neymiş? Kısaca kendi kelimelerimle özetliyorum.)*

## 2. Ben Olsaydım Nasıl Bulurdum? (Metodoloji Çıkarımı)
*(Hangi adımları izlemeliyim ki bu tür bir açığı kendi hedeflerimde yakalayabileyim?)*
- Şifre sıfırlama kısımlarında mutlaka HTTP Host header'ını `Host: evil.com` olarak değiştirip denemeliyim.
- Farklı headerlar denemeliyim: `X-Forwarded-Host: evil.com`

## 3. Alınan Notlar / Payloadlar
*(Raporda kullanılan özel bir payload veya araç var mı?)*
- Hacker'ın kullandığı payload: ...
- Benzer durumlarda test etmek için not aldığım endpointler: `/api/reset`, `/forgot-password`
