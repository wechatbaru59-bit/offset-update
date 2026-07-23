#!/bin/bash

# ================= SETUP WARNA =================
PURPLE='\033[0;35m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
WHITE='\033[0;97m'
NC='\033[0m' # No Color

# ================= SISTEM LOCK TO PHONE (DEVICE ID) =================
clear
echo -e "${PURPLE}══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}                      🔒 DEVICE AUTHENTICATION${NC}"
echo -e "${PURPLE}══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 1. Kenal pasti Device ID (Disimpan dalam fail supaya kekal)
DEVICE_FILE="$HOME/.my_tool_device_id"
if [ ! -f "$DEVICE_FILE" ]; then
    # Hasilkan ID rawak unik untuk telefon ini, simpan dalam fail
    cat /proc/sys/kernel/random/uuid > "$DEVICE_FILE"
fi
DEVICE_ID=$(cat "$DEVICE_FILE")

# 2. Tunjukkan Device ID kepada pengguna
echo -e "${CYAN}Device ID telefon anda:${NC} ${YELLOW}${DEVICE_ID}${NC}"
echo -e "${WHITE}Sila hantar ID ini kepada pihak Developer untuk mendapatkan LICENSE KEY.${NC}"
echo ""

# 3. Minta License Key
read -p "$(echo -e "${GREEN}Masukkan License Key yang diberikan: ${NC}")" input_key < /dev/tty

# 4. Rahsia Developer (SALT) - Disimpan dalam Base64 agar tak nampak di Raw
ENCODED_SALT="TXVyeG1vZHoyMDI0"  # echo -n "MurxzModz2024" | base64
SALT=$(echo "$ENCODED_SALT" | base64 -d)

# 5. Kira License Key yang sepatutnya
EXPECTED_KEY=$(echo -n "${DEVICE_ID}${SALT}" | sha256sum | cut -d' ' -f1)

# 6. Semak Key
if [ "$input_key" != "$EXPECTED_KEY" ]; then
    echo -e "${RED}❌ LICENSE KEY SALAH! Akses Ditolak.${NC}"
    sleep 2
    exit 1
fi

echo -e "${GREEN}✅ License Key Sah! Memuatkan Tool...${NC}"
sleep 1
clear

# ================= FUNGSI TAMPILAN MENU =================
show_menu() {
    clear
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║  ${YELLOW}WELCOME TO MY AUTO OFFSET TOOL                         ${PURPLE}║${NC}"
    echo -e "${PURPLE}║  ${CYAN}PROFESSIONAL TERMUX TOOL BY MurxzModz                    ${PURPLE}║${NC}"
    echo -e "${PURPLE}║  Current Language: ${GREEN}English/Melayu                          ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║  ${WHITE}Options${NC}  │  ${WHITE}Description${NC}                     │  ${WHITE}Status${NC}      ║${PURPLE}${NC}"
    echo -e "${PURPLE}╠═══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${PURPLE}║  ${GREEN}1${NC}       │  Jalankan Update Offset (File .cs)     │  ${GREEN}READY${NC}   ║${PURPLE}${NC}"
    echo -e "${PURPLE}║  ${GREEN}2${NC}       │  Fungsi Tambahan (Contoh)              │  ${GREEN}READY${NC}   ║${PURPLE}${NC}"
    echo -e "${PURPLE}║  ${RED}0${NC}       │  EXIT / Keluar Tool                      │  ${RED}EXIT${NC}    ║${PURPLE}${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ================= LOGIK PILIHAN MENU =================
while true
do
    show_menu
    read -p "$(echo -e "${YELLOW}Select an option (0/1/2): ${NC}")" choice < /dev/tty

    case $choice in
        1)
            echo -e "${GREEN}▶ Menjalankan Auto Update Offset...${NC}"
            
            # ===== DI SINI KOD PYTHON ANDA DIJALANKAN (BASE64) =====
            pkg install python -y > /dev/null 2>&1

            echo "aW1wb3J0IHJlCmltcG9ydCBvcwoKZGVmIHJlYWRfZmlsZShmaWxlX3BhdGgpOgogICAgd2l0aCBvcGVuKGZpbGVfcGF0aCwgJ3InLCBlbmNvZGluZz0ndXRmLTgnKSBhcyBmOgogICAgICAgIHJldHVybiBmLnJlYWRsaW5lcygpCgpkZWYgd3JpdGVfZmlsZShmaWxlX3BhdGgsIGxpbmVzKToKICAgIHdpdGggb3BlbihmaWxlX3BhdGgsICd3JywgZW5jb2Rpbmc9J3V0Zi04JykgYXMgZjoKICAgICAgICBmLndyaXRlbGluZXMobGluZXMpCiAgICBwcmludChmIuKWlSBGaWxlIHVwZGF0ZWQ6IHtmaWxlX3BhdGh9IikKCmRlZiBleHRyYWN0X29mZnNldF9tZXRob2RfcGFpcnMobGluZXM6CiAgICBwYWlycyA9IFtdCiAgICBpID0gMAogICAgd2hpbGUgaSA8IGxlbihsaW5lcyk6CiAgICAgICAgbGluZSA9IGxpbmVzW2ldLnN0cmlwKCkKICAgICAgICBvZmZzZXRfbWF0Y2ggPSByZS5zZWFyY2gocicweFswLTlhLWZBLUZdKycsIGxpbmUpCiAgICAgICAgaWYgb2Zmc2V0X21hdGNoOgogICAgICAgICAgICBvZmZzZXQgPSBvZmZzZXRfbWF0Y2guZ3JvdXAoKQogICAgICAgICAgICBtZXRob2QgPSBOb25lCiAgICAgICAgICAgIGlmIGkrMSA8IGxlbihsaW5lcyk6CiAgICAgICAgICAgICAgICBuZXh0X2xpbmUgPSBsaW5lc1tpKzFdLnN0cmlwKCkKICAgICAgICAgICAgICAgIGlmIG5leHRfbGluZSBhbmQgbm90IHJlLnNlYXJjaChyJzB4WzAtOWEtZkEtRl0rJywgbmV4dF9saW5lKToKICAgICAgICAgICAgICAgICAgICBtZXRob2QgPSBuZXh0X2xpbmUKICAgICAgICAgICAgICAgIGVsc2U6CiAgICAgICAgICAgICAgICAgICAgcGFydHMgPSByZS5zcGxpdChyJ1xzKycsIGxpbmUpCiAgICAgICAgICAgICAgICAgICAgaWYgbGVuKHBhcnRzKSA+IDE6CiAgICAgICAgICAgICAgICAgICAgICAgIG1ldGhvZCA9IHBhcnRzWy0xXQogICAgICAgICAgICBpZiBtZXRob2Q6CiAgICAgICAgICAgICAgICBwYWlycy5hcHBlbmQoKG9mZnNldCwgbWV0aG9kKSkKICAgICAgICBpICs9IDEKICAgIHJldHVybiBwYWlycwoKZGVmIGZpbmRfbmV3X29mZnNldChsaW5lcywgbWV0aG9kX25hbWUsIG9jY3VycmVuY2UpOgogICAgZm91bmRfaW5kaWNlcyA9IFtpIGZvciBpLCBsaW5lIGluIGVudW1lcmF0ZShsaW5lcykgaWYgbWV0aG9kX25hbWUgaW4gbGluZV0KICAgIGlmIGxlbihmb3VuZF9pbmRpY2VzKSA+PSBvY2N1cnJlbmNlOgogICAgICAgIGlkeCA9IGZvdW5kX2luZGljZXNbb2NjdXJyZW5jZSAtIDFdCiAgICAgICAgZm9yIGNoZWNrIGluIChpZHgsIGlkeC0xKToKICAgICAgICAgICAgaWYgY2hlY2sgPj0gMDoKICAgICAgICAgICAgICAgIG0gPSByZS5zZWFyY2gocicweFswLTlhLWZBLUZdKycsIGxpbmVzW2NoZWNrXSkKICAgICAgICAgICAgICAgIGlmIG06CiAgICAgICAgICAgICAgICAgICAgcmV0dXJuIG0uZ3JvdXAoKQogICAgcmV0dXJuIE5vbmUKCmRlZiBtYWluKCk6CiAgICBmb2xkZXJfcGF0aCA9ICIvc3RvcmFnZS9lbXVsYXRlZC8wL0R1bXBEcm9pZCIKICAgIAogICAgaWYgbm90IG9zLnBhdGguZXhpc3RzKGZvbGRlcl9wYXRoKToKICAgICAgICBwcmludChmIuKclCBGb2xkZXIgJ3tmb2xkZXJfcGF0aH0nIHRpZGFrIHd1anVkISIpCiAgICAgICAgcmV0dXJuCgogICAgY3NfZmlsZXMgPSBbZiBmb3IgZiBpbiBvcy5saXN0ZGlyKGZvbGRlcl9wYXRoKSBpZiBmLmVuZHN3aXRoKCcuY3MnKV0KICAgIAogICAgaWYgbm90IGNzX2ZpbGVzOgogICAgICAgIHByaW50KCLinJwgVGlhZGEgZmFpbCAuY3MgZGlqdW1wYWkgZGFsYW0gZm9sZGVyIER1bXBEcm9pZCEiKQogICAgICAgIHJldHVybgoKICAgIHByaW50KCLwnI2iIFNlbmFyYWkgZmFpbCAuY3MgeWFuZyBkaWp1bXBhaToiKQogICAgZm9yIGksIGZpbGUgaW4gZW51bWVyYXRlKGNzX2ZpbGVzKToKICAgICAgICBwcmludChmIiAgIHtJKzF9LiB7ZmlsZX0iKQogICAgCiAgICB3aGlsZSBUcnVlOgogICAgICAgIHRyeToKICAgICAgICAgICAgcGlsaWhhbjEgPSBpbnQoaW5wdXQoIlxu8J+RviBQaWxpaCBub21ib3IgdW50dWsgZmlsZTIyMiAoZmFpbCBvZmZzZXQgbGFtYSk6ICIpKQogICAgICAgICAgICBpZiAxIDw9IHBpbGlhaG4xIDw9IGxlbihjc19maWxlcyk6CiAgICAgICAgICAgICAgICBmaWxlMjIyID0gb3MucGF0aC5qb2luKGZvbGRlcl9wYXRoLCBjc19maWxlc1twaWxpaGFuMSAtIDFdKQogICAgICAgICAgICAgICAgYnJlYWsKICAgICAgICAgICAgZWxzZToKICAgICAgICAgICAgICAgIHByaW50KCLinJwgTm9tYm9yIHRpZGFrIHNhaCwgc2lsYSBwaWxpaCBzZW11bGEuIikKICAgICAgICBleGNlcHQgVmFsdWVFcnJvcjoKICAgICAgICAgICAgcHJpbnQoIuKclCBTaWxhIG1hc3Vra2FuIG5vbWJvciBzYWhhamEuIikKCiAgICB3aGlsZSBUcnVlOgogICAgICAgIHRyeToKICAgICAgICAgICAgcGlsaWhhbjIgPSBpbnQoaW5wdXQoIuKcuCBQaWxpaCBub21ib3IgdW50dWsgZmlsZTMzMyAoZmFpbCBvZmZzZXQgYmFydSk6ICIpKQogICAgICAgICAgICBpZiAxIDw9IHBpbGlhaG4yIDw9IGxlbihjc19maWxlcyk6CiAgICAgICAgICAgICAgICBmaWxlMzMzID0gb3MucGF0aC5qb2luKGZvbGRlcl9wYXRoLCBjc19maWxlc1twaWxpaGFuMiAtIDFdKQogICAgICAgICAgICAgICAgYnJlYWsKICAgICAgICAgICAgZWxzZToKICAgICAgICAgICAgICAgIHByaW50KCLinJwgTm9tYm9yIHRpZGFrIHNhaCwgc2lsYSBwaWxpaCBzZW11bGEuIikKICAgICAgICBleGNlcHQgVmFsdWVFcnJvcjoKICAgICAgICAgICAgcHJpbnQoIuKclCBTaWxhIG1hc3Vra2FuIG5vbWJvciBzYWhhamEuIikKCiAgICBmaWxlMTExID0gIi9zdG9yYWdlL2VtdWxhdGVkLzAvRHVtcERyb2lkL01haW4uY3BwIgoKICAgIGxpbmVzMTExID0gcmVhZF9maWxlKGZpbGUxMTEpCiAgICBsaW5lczIyMiA9IHJlYWRfZmlsZShmaWxlMjIyKQogICAgbGluZXMzMzMgPSByZWFkX2ZpbGUoZmlsZTMzMykKCiAgICBwYWlyczIyMiA9IGV4dHJhY3Rfb2Zmc2V0X21ldGhvZF9wYWlycyhsaW5lczIyMikKICAgIG1ldGhvZF9jb3VudGVyID0ge30KICAgIG1ldGhvZF90b19vZmZzZXQgPSB7fQogICAgZm9yIG9mZnNldCwgbWV0aG9kIGluIHBhaXJzMjIyOgogICAgICAgIG1ldGhvZF9jb3VudGVyW21ldGhvZF0gPSBtZXRob2RfY291bnRlci5nZXQobWV0aG9kLCAwKSArIDEKICAgICAgICBvY2MgPSBtZXRob2RfY291bnRlclttZXRob2RdCiAgICAgICAgbWV0aG9kX3RvX29mZnNldFsobWV0aG9kLCBvY2MpXSA9IG9mZnNldAoKICAgIG9mZnNldHMxMTEgPSBzZXQoKQogICAgZm9yIGxpbmUgaW4gbGluZXMxMTE6CiAgICAgICAgbSA9IHJlLnNlYXJjaChyJzB4WzAtOWEtZkEtRl0rJywgbGluZSkKICAgICAgICBpZiBtOgogICAgICAgICAgICBvZmZzZXRzMTExLmFkZChtLmdyb3VwKCkpCgogICAgdXBkYXRlZCA9IEZhbHNlCiAgICBmb3Igb2xkX29mZnNldCBpbiBvZmZzZXRzMTExOgogICAgICAgIGZvdW5kX21ldGhvZCA9IE5vbmUKICAgICAgICBmb3VuZF9vY2MgPSBOb25lCiAgICAgICAgZm9yIChtZXRob2QsIG9jYyksIG9mZiBpbiBtZXRob2RfdG9fb2Zmc2V0Lml0ZW1zKCk6CiAgICAgICAgICAgIGlmIG9mZiA9PSBvbGRfb2Zmc2V0OgogICAgICAgICAgICAgICAgZm91bmRfbWV0aG9kID0gbWV0aG9kCiAgICBmb3VuZF9vY2MgPSBvY2MKICAgICAgICAgICAgICAgIGJyZWFrCgogICAgICAgIGlmIG5vdCBmb3VuZF9tZXRob2Q6CiAgICAgICAgICAgIHByaW50KGYi4oydIE9mZnNldCB7b2xkX29mZnNldH0gdGlkYWsgZGlqdW1wYWkgZGFsYW0gZmlsZTIyMiIpCiAgICAgICAgICAgIGNvbnRpbnVlCgogICAgICAgIHByaW50KGYi8J+QjiBPZmZzZXQge29sZF9vZmZzZXR9IC0+IG1ldGhvZCAne2ZvdW5kX21ldGhvZH0nICh1cnV0YW4ge2ZvdW5kX29jY30pIikKICAgICAgICBuZXdfb2Zmc2V0ID0gZmluZF9uZXdfb2Zmc2V0KGxpbmVzMzMzLCBmb3VuZF9tZXRob2QsIGZvdW5kX29jYykKICAgICAgICBpZiBuZXdfb2Zmc2V0OgogICAgICAgICAgICBwcmludChmIuKWlCBPZmZzZXQgYmFydSBkaWp1bXBhaToge25ld19vZmZzZXR9IikKICAgICAgICAgICAgbmV3X2xpbmVzID0gW10KICAgICAgICAgICAgZm9yIGxpbmUgaW4gbGluZXMxMTE6CiAgICAgICAgICAgICAgICBpZiBvbGRfb2Zmc2V0IGluIGxpbmU6CiAgICAgICAgICAgICAgICAgICAgbGluZSA9IGxpbmUucmVwbGFjZShvbGRfb2Zmc2V0LCBuZXdfb2Zmc2V0KQogICAgICAgICAgICAgICAgbmV3X2xpbmVzLmFwcGVuZChsaW5lKQogICAgICAgICAgICBsaW5lczExMSA9IG5ld19saW5lcwogICAgICAgICAgICB1cGRhdGVkID0gVHJ1ZQogICAgICAgIGVsc2U6CiAgICAgICAgICAgIHByaW50KGYi4oydIFRpYWRhIG9mZnNldCBiYXJ1IHVudHVrIG1ldGhvZCAne2ZvdW5kX21ldGhvZH0nIHVydXRhbiB7Zm91bmRfb2NjfSBkYWxhbSBmaWxlMzMzIikKCiAgICBpZiB1cGRhdGVkOgogICAgICAgIHdyaXRlX2ZpbGUoZmlsZTExMSwgbGluZXMxMTEpCiAgICBlbHNlOgogICAgICAgIHByaW50KCJUaWFkYSBwZXJ1YmFoYW4gZGlidWF0LiIpCgppZiBfX25hbWVfXyA9PSAiX19tYWluX18iOgogICAgbWFpbigpCg==" | base64 -d > tool_rahasia.py

            python tool_rahasia.py < /dev/tty
            rm tool_rahasia.py

            echo -e "${GREEN}Selesai! Tekan ENTER untuk balik ke menu utama.${NC}"
            read < /dev/tty
            ;;
        2)
            echo -e "${CYAN}Anda pilih pilihan 2. (Boleh tambah fungsi lain di sini).${NC}"
            read < /dev/tty
            ;;
        0)
            echo -e "${RED}Terima kasih! Keluar dari tool...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Pilihan tidak sah! Sila pilih nombor yang betul.${NC}"
            sleep 1
            ;;
    esac
done
