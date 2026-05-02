#!/bin/bash

# Basit Recon (Keşif) Otomasyon Betiği
# Kullanım: ./recon_automation.sh hedefdomain.com

if [ -z "$1" ]; then
    echo "Kullanım: $0 <hedef-domain>"
    exit 1
fi

DOMAIN=$1
DATE=$(date +%Y-%m-%d)
OUTPUT_DIR="recon_results_${DOMAIN}_${DATE}"

mkdir -p $OUTPUT_DIR
cd $OUTPUT_DIR

echo "[+] Keşif başlatılıyor: $DOMAIN"

# 1. Pasif Subdomain Toplama
echo "[+] Subfinder çalıştırılıyor..."
subfinder -d $DOMAIN -all -silent > subdomains.txt

# (İsteğe bağlı: Amass, Assetfinder eklenebilir)

# 2. Canlı Alt Alan Adlarını Tespit Etme
echo "[+] Httpx ile canlı olanlar tespit ediliyor..."
cat subdomains.txt | httpx -silent -threads 100 > alive_subdomains.txt

# 3. Port Tarama (Naabu)
echo "[+] Naabu ile port taraması yapılıyor..."
naabu -l alive_subdomains.txt -p 80,443,8080,8443,3000,5000 -silent > open_ports.txt

# 4. Wayback Machine Verileri
echo "[+] Waybackurls ile URL'ler çekiliyor..."
cat alive_subdomains.txt | waybackurls > urls.txt

echo "[+] Keşif tamamlandı. Sonuçlar $OUTPUT_DIR klasöründe."
