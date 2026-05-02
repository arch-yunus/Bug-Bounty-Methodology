# Aktif Keşif (Active Reconnaissance) Metodolojisi

Aktif keşif, hedef sistemlerle doğrudan etkileşime geçerek (paket gönderip yanıt alarak) bilgi toplama sürecidir. Hedef sistem loglarında iz bırakma ihtimali yüksektir.

## 1. Alt Alan Adı (Subdomain) Tespiti
Pasif olarak toplanan alt alan adlarını zenginleştirmek için aktif olarak brute-force ve DNS sorguları yapılır.

- **Araçlar:** `Amass`, `Subfinder`, `Puredns`, `Gobuster` (DNS modu)
- **Yöntem:**
  - Geniş bir kelime listesi (wordlist) kullanılarak DNS brute-forcing yapılır.
  - Bulunan subdomainlerin `A`, `CNAME` kayıtları çözümlenir (resolving).
  - Alt alan adı devralma (Subdomain Takeover) ihtimallerine karşı CNAME kayıtları dikkatle incelenir.

## 2. Port Tarama ve Servis Keşfi
Hedefin açık portlarını ve bu portlarda koşan servisleri/versiyonları tespit etmek.

- **Araçlar:** `Nmap`, `RustScan`, `Masscan`, `Naabu`
- **Taktik:**
  - Önce hızlı tarama için `RustScan` veya `Naabu` kullanılır.
  - Bulunan açık portlar üzerinde detaylı tarama için `nmap -sV -sC -p <portlar>` çalıştırılır.
  - *Sadece yaygın web portlarına (80, 443) değil, 8080, 8443, 3000, 5000 gibi alternatif portlara da bakılır.*

## 3. Dizin ve Dosya Tarama (Fuzzing / Directory Brute-Forcing)
Web sunucusunda gizlenmiş dosyaları, yönetim panellerini veya yedek dosyalarını (`.bak`, `.zip`) bulmak için yapılır.

- **Araçlar:** `ffuf`, `dirsearch`, `feroxbuster`, `gobuster`
- **Taktik:**
  - `ffuf -w wordlist.txt -u https://hedef.com/FUZZ`
  - Durum kodlarına (200, 301, 302, 403, 500) göre sonuçlar filtrelenir.
  - 403 (Forbidden) dönen sayfalar için Bypass teknikleri (örneğin X-Forwarded-For header ekleme veya path manipulation `/%2e/`) denenir.

## 4. Parametre Tespiti (Parameter Fuzzing)
Uygulamanın zafiyet barındırabilecek gizli GET/POST parametrelerini bulmak.

- **Araçlar:** `Arjun`, `x8`, `ParamSpider`
- **Taktik:** Endpointler üzerinde olası IDOR, XSS, SQLi veya LFI zafiyetleri için gizli parametreleri test etmek. `https://hedef.com/api/user?FUZZ=1`

## 5. Teknoloji Yığını (Tech Stack) Tespiti
Hedefin kullandığı dilleri, frameworkleri ve web sunucularını anlamak, saldırı vektörünü daraltır.

- **Araçlar:** `Wappalyzer`, `WhatWeb`, `httpx` (`-tech-detect` parametresi)
- **Taktik:** Bulunan teknolojinin sürümü tespit edilirse, `searchsploit` veya CVE veritabanlarında bilinen bir zafiyet aranır.
