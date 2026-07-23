import re

def read_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        return f.readlines()

def write_file(file_path, lines):
    with open(file_path, 'w', encoding='utf-8') as f:
        f.writelines(lines)
    print(f"✅ File updated: {file_path}")

def extract_offset_method_pairs(lines):
    """
    Kembalikan list tuple (offset, method_name) untuk setiap pasangan.
    Offset diambil dari baris yang mengandungi pola 0x..., dan method diambil
    dari baris sama (jika ada) atau baris berikutnya yang bukan kosong.
    """
    pairs = []
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        offset_match = re.search(r'0x[0-9a-fA-F]+', line)
        if offset_match:
            offset = offset_match.group()
            # Cari method di baris ini atau baris seterusnya
            method = None
            # Jika baris ini ada method (cth. "0x1234 some_method")
            # kita boleh cuba ekstrak nama method (andaikan tiada ruang dalam nama)
            # Atau ambil baris seterusnya
            if i+1 < len(lines):
                next_line = lines[i+1].strip()
                # Jika next_line bukan kosong dan bukan offset sahaja, anggap ia method
                if next_line and not re.search(r'0x[0-9a-fA-F]+', next_line):
                    method = next_line
                else:
                    # Cuba cari method dalam baris semasa (selepas offset)
                    # Contoh: "0x1234 MethodName" -> ambil "MethodName"
                    parts = re.split(r'\s+', line)
                    if len(parts) > 1:
                        method = parts[-1]  # ambil perkataan terakhir
            if method:
                pairs.append((offset, method))
        i += 1
    return pairs

def find_new_offset(lines, method_name, occurrence):
    """
    Cari offset untuk method_name dengan urutan occurrence (1-based) dalam lines.
    Offset boleh berada di baris yang sama atau baris sebelumnya.
    """
    found_indices = [i for i, line in enumerate(lines) if method_name in line]
    if len(found_indices) >= occurrence:
        idx = found_indices[occurrence - 1]
        # Cari offset di baris idx atau idx-1
        for check in (idx, idx-1):
            if check >= 0:
                m = re.search(r'0x[0-9a-fA-F]+', lines[check])
                if m:
                    return m.group()
    return None

def main():
    file111 = "/storage/emulated/0/DumpDroid/Main.cpp"
    file222 = "/storage/emulated/0/DumpDroid/90000.cs"
    file333 = "/storage/emulated/0/DumpDroid/92100.cs"

    lines111 = read_file(file111)
    lines222 = read_file(file222)
    lines333 = read_file(file333)

    # Bina mapping offset -> method dan kira urutan
    pairs222 = extract_offset_method_pairs(lines222)
    # Buat dictionary: (method, occurrence) -> offset
    method_counter = {}
    method_to_offset = {}
    for offset, method in pairs222:
        method_counter[method] = method_counter.get(method, 0) + 1
        occ = method_counter[method]
        method_to_offset[(method, occ)] = offset

    # Kumpulkan semua offset dalam file111
    offsets111 = set()
    for line in lines111:
        m = re.search(r'0x[0-9a-fA-F]+', line)
        if m:
            offsets111.add(m.group())

    updated = False
    for old_offset in offsets111:
        # Cari pasangan dalam file222 berdasarkan old_offset
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
            # Gantikan dalam lines111
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