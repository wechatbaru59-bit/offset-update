#!/bin/bash

PURPLE='\033[0;35m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
WHITE='\033[0;97m'
NC='\033[0m' 

clear
echo -e "${PURPLE}══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}                      🔒 DEVICE AUTHENTICATION${NC}"
echo -e "${PURPLE}══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

DEVICE_FILE="$HOME/.my_tool_device_id"
if [ ! -f "$DEVICE_FILE" ]; then
    cat /proc/sys/kernel/random/uuid > "$DEVICE_FILE"
fi

DEVICE_ID=$(cat "$DEVICE_FILE" | tr -d '\n' | tr -d '\r')

echo -e "${CYAN}Device ID telefon anda:${NC} ${YELLOW}${DEVICE_ID}${NC}"
echo -e "${WHITE}Sila hantar ID ini kepada pihak Developer untuk mendapatkan LICENSE KEY.${NC}"
echo ""

read -p "$(echo -e "${GREEN}Masukkan License Key yang diberikan: ${NC}")" input_key < /dev/tty

EXPECTED_KEY=$(echo -n "${DEVICE_ID}" | sha256sum | cut -d' ' -f1)

if [ "$input_key" != "$EXPECTED_KEY" ]; then
    echo -e "${RED}❌ LICENSE KEY SALAH! Akses Ditolak.${NC}"
    sleep 2
    exit 1
fi

echo -e "${GREEN}✅ License Key Sah! Memuatkan Tool...${NC}"
sleep 1
clear

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

while true
do
    show_menu
    read -p "$(echo -e "${YELLOW}Select an option (0/1/2): ${NC}")" choice < /dev/tty

    case $choice in
        1)
            echo -e "${GREEN}▶ Menjalankan Auto Update Offset...${NC}"
            pkg install python -y > /dev/null 2>&1

            # ===== KOD PYTHON DALAM BENTUK TEKS BIASA (TIADA BASE64) =====
            cat > tool_rahasia.py << 'EOF'
import re
import os

def read_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        return f.readlines()

def write_file(file_path, lines):
    with open(file_path, 'w', encoding='utf-8') as f:
        f.writelines(lines)
    print(f"✅ File updated: {file_path}")

def extract_offset_method_pairs(lines):
    pairs = []
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        offset_match = re.search(r'0x[0-9a-fA-F]+', line)
        if offset_match:
            offset = offset_match.group()
            method = None
            if i+1 < len(lines):
                next_line = lines[i+1].strip()
                if next_line and not re.search(r'0x[0-9a-fA-F]+', next_line):
                    method = next_line
                else:
                    parts = re.split(r'\s+', line)
                    if len(parts) > 1:
                        method = parts[-1]
            if method:
                pairs.append((offset, method))
        i += 1
    return pairs

def find_new_offset(lines, method_name, occurrence):
    found_indices = [i for i, line in enumerate(lines) if method_name in line]
    if len(found_indices) >= occurrence:
        idx = found_indices[occurrence - 1]
        for check in (idx, idx-1):
            if check >= 0:
                m = re.search(r'0x[0-9a-fA-F]+', lines[check])
                if m:
                    return m.group()
    return None

def main():
    folder_path = "/storage/emulated/0/DumpDroid"
    
    if not os.path.exists(folder_path):
        print(f"❌ Folder '{folder_path}' tidak wujud!")
        return

    cs_files = [f for f in os.listdir(folder_path) if f.endswith('.cs')]
    
    if not cs_files:
        print("❌ Tiada fail .cs dijumpai dalam folder DumpDroid!")
        return

    print("📂 Senarai fail .cs yang dijumpai:")
    for i, file in enumerate(cs_files):
        print(f"   {i+1}. {file}")
    
    while True:
        try:
            pilihan1 = int(input("\n🔹 Pilih nombor untuk file222 (fail offset lama): "))
            if 1 <= pilihan1 <= len(cs_files):
                file222 = os.path.join(folder_path, cs_files[pilihan1 - 1])
                break
            else:
                print("❌ Nombor tidak sah, sila pilih semula.")
        except ValueError:
            print("❌ Sila masukkan nombor sahaja.")

    while True:
        try:
            pilihan2 = int(input("🔸 Pilih nombor untuk file333 (fail offset baru): "))
            if 1 <= pilihan2 <= len(cs_files):
                file333 = os.path.join(folder_path, cs_files[pilihan2 - 1])
                break
            else:
                print("❌ Nombor tidak sah, sila pilih semula.")
        except ValueError:
            print("❌ Sila masukkan nombor sahaja.")

    file111 = "/storage/emulated/0/DumpDroid/Main.cpp"

    lines111 = read_file(file111)
    lines222 = read_file(file222)
    lines333 = read_file(file333)

    pairs222 = extract_offset_method_pairs(lines222)
    method_counter = {}
    method_to_offset = {}
    for offset, method in pairs222:
        method_counter[method] = method_counter.get(method, 0) + 1
        occ = method_counter[method]
        method_to_offset[(method, occ)] = offset

    offsets111 = set()
    for line in lines111:
        m = re.search(r'0x[0-9a-fA-F]+', line)
        if m:
            offsets111.add(m.group())

    updated = False
    for old_offset in offsets111:
        found_method = None
        found_occ = None
        for (method, occ), off in method_to_offset.items():
            if off == old_offset:
                found_method = method
                found_occ = occ
                break

        if not found_method:
            print(f"❌ Offset {old_offset} tidak dijumpai dalam file222")
            continue

        print(f"🔍 Offset {old_offset} -> method '{found_method}' (urutan {found_occ})")
        new_offset = find_new_offset(lines333, found_method, found_occ)
        if new_offset:
            print(f"✅ Offset baru dijumpai: {new_offset}")
            new_lines = []
            for line in lines111:
                if old_offset in line:
                    line = line.replace(old_offset, new_offset)
                new_lines.append(line)
            lines111 = new_lines
            updated = True
        else:
            print(f"❌ Tiada offset baru untuk method '{found_method}' urutan {found_occ} dalam file333")

    if updated:
        write_file(file111, lines111)
    else:
        print("Tiada perubahan dibuat.")

if __name__ == "__main__":
    main()
EOF

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
