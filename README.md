# TIGHTSHUT — Database (Project Based Learning: Web Programming 2026)

Basis data website band **TIGHTSHUT** (metallic hardcore, Pontianak): 13 tabel MySQL/MariaDB (`tightshut_db`).

## Isi folder `database/`
| File | Fungsi |
|---|---|
| `tightshut_db.sql` | Skema 13 tabel + data awal |
| `update_ukuran_rekening.sql` | Migrasi: kolom ukuran dan info pembayaran (untuk database lama) |
| `01_create_read.sql` | **WBS 2.2** — INSERT dan SELECT untuk semua tabel |
| `02_update_delete.sql` | **WBS 2.3** — UPDATE dan DELETE untuk semua tabel |

## Cara menjalankan (phpMyAdmin / XAMPP)
1. Import `tightshut_db.sql` (database kosong).
2. Jalankan `01_create_read.sql` di tab **SQL**.
3. Jalankan `02_update_delete.sql`.

Data uji ditandai `DEMO`, dan tahap 2 hanya mengubah/menghapus baris `DEMO` itu, sehingga data asli tidak tersentuh.
Data demo (termasuk email dan hash password) adalah contoh palsu, bukan data asli siapa pun.

## Urutan DELETE
Tabel anak dihapus lebih dulu, baru tabel induk, agar tidak melanggar foreign key:
`merch_orders` → `users`/`merchandise`; `songs` → `albums`; `member_socials`/`press_member_media` → `members`.
