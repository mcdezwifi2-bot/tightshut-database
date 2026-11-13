-- ============================================================
-- TIGHTSHUT — WBS 2.3: Operasi UPDATE dan DELETE
-- Mencakup 13 tabel di database tightshut_db.
-- Hanya menyentuh DATA DEMO dari 01_create_read.sql (dipilih lewat WHERE),
-- jadi data asli band tidak ikut berubah/terhapus.
-- Jalankan SETELAH 01_create_read.sql.
-- ============================================================
USE tightshut_db;
SET SQL_SAFE_UPDATES = 0;  -- hanya perlu bila memakai MySQL Workbench (safe update mode)

-- ------------------------------------------------------------
-- A. UPDATE — satu baris demo per tabel, ditampilkan sebelum/sesudah lewat SELECT
-- ------------------------------------------------------------

-- 1. site_settings
UPDATE site_settings SET tag_hero = '— Demo (diubah) —', judul_hero = 'Demo Hero (diubah)'
WHERE judul_situs = 'DEMO — Site Settings';

-- 2. nav_menus
UPDATE nav_menus SET label_menu = 'DEMO Menu (diubah)', urutan_tampil = 100
WHERE label_menu = 'DEMO Menu' AND posisi_menu = 'demo';

-- 3. members
UPDATE members SET golongan_darah = 'O', biografi = 'Biodata demo (diubah).', urutan_tampil = 100
WHERE slug_anchor = 'profil-demo';

-- 4. member_socials
UPDATE member_socials SET url_profil = 'https://instagram.com/contoh_demo_baru'
WHERE id_member = (SELECT id_member FROM members WHERE slug_anchor = 'profil-demo');

-- 5. albums
UPDATE albums SET jenis_album = 'Single', tanggal_rilis = '2026-02-02' WHERE judul_album = 'DEMO Album';

-- 6. songs
UPDATE songs SET durasi_lagu = '00:04:00', judul_lagu = 'DEMO Lagu 1 (diubah)' WHERE judul_lagu = 'DEMO Lagu 1';

-- 7. users
UPDATE users SET telepon = '081211111111', alamat_kirim = 'Jl. Demo No. 2, Pontianak'
WHERE email = 'demo.user@example.com';

-- 8. merchandise
UPDATE merchandise SET harga = 120000.00, stok = 8 WHERE nama_produk = 'DEMO Tee';

-- 9. merch_orders: alur status Pending -> Paid -> Shipped
UPDATE merch_orders SET status_pesanan = 'Paid'
WHERE id_pengguna = (SELECT id_pengguna FROM users WHERE email = 'demo.user@example.com')
  AND status_pesanan = 'Pending';
UPDATE merch_orders SET status_pesanan = 'Shipped'
WHERE id_pengguna = (SELECT id_pengguna FROM users WHERE email = 'demo.user@example.com')
  AND status_pesanan = 'Paid';

-- 10. press_member_media
UPDATE press_member_media SET keterangan = 'Dokumentasi demo (diubah).', konten_eksklusif = 1
WHERE judul_press = 'DEMO Press (member)';

-- 11. messages: tandai sudah dibaca
UPDATE messages SET sudah_dibaca = 1 WHERE email_pengirim = 'demo.pengirim@example.com';

-- 12. band_socials
UPDATE band_socials SET nama_akun = '@demo_baru', tampil_di_kontak = 1 WHERE nama_platform = 'DEMO Platform';

-- 13. news
UPDATE news SET judul_berita = 'DEMO Berita (diubah)', kategori_berita = 'Pengumuman' WHERE judul_berita = 'DEMO Berita';

-- Bukti hasil UPDATE
SELECT * FROM site_settings WHERE judul_situs = 'DEMO — Site Settings';
SELECT * FROM nav_menus WHERE posisi_menu = 'demo';
SELECT * FROM members WHERE slug_anchor = 'profil-demo';
SELECT * FROM member_socials WHERE url_profil LIKE '%contoh_demo%';
SELECT * FROM albums WHERE judul_album = 'DEMO Album';
SELECT * FROM songs WHERE judul_lagu LIKE 'DEMO Lagu%';
SELECT * FROM users WHERE email = 'demo.user@example.com';
SELECT * FROM merchandise WHERE nama_produk = 'DEMO Tee';
SELECT o.* FROM merch_orders o JOIN users u ON u.id_pengguna = o.id_pengguna WHERE u.email = 'demo.user@example.com';
SELECT * FROM press_member_media WHERE judul_press LIKE 'DEMO Press%';
SELECT * FROM messages WHERE email_pengirim = 'demo.pengirim@example.com';
SELECT * FROM band_socials WHERE nama_platform = 'DEMO Platform';
SELECT * FROM news WHERE judul_berita LIKE 'DEMO Berita%';

-- ------------------------------------------------------------
-- B. DELETE — urutan: tabel ANAK dulu, baru tabel INDUK (agar tidak melanggar foreign key)
--    merch_orders -> (users, merchandise) | songs -> albums | member_socials, press_member_media -> members
-- ------------------------------------------------------------

-- Tabel anak
DELETE FROM merch_orders
WHERE id_pengguna = (SELECT id_pengguna FROM users WHERE email = 'demo.user@example.com');
DELETE FROM songs WHERE id_album = (SELECT id_album FROM albums WHERE judul_album = 'DEMO Album');
DELETE FROM member_socials WHERE id_member = (SELECT id_member FROM members WHERE slug_anchor = 'profil-demo');
DELETE FROM press_member_media WHERE judul_press LIKE 'DEMO Press%';

-- Tabel induk
DELETE FROM users       WHERE email = 'demo.user@example.com';
DELETE FROM merchandise WHERE nama_produk = 'DEMO Tee';
DELETE FROM albums      WHERE judul_album = 'DEMO Album';
DELETE FROM members     WHERE slug_anchor = 'profil-demo';

-- Tabel standalone
DELETE FROM site_settings WHERE judul_situs = 'DEMO — Site Settings';
DELETE FROM nav_menus     WHERE posisi_menu = 'demo';
DELETE FROM messages      WHERE email_pengirim = 'demo.pengirim@example.com';
DELETE FROM band_socials  WHERE nama_platform = 'DEMO Platform';
DELETE FROM news          WHERE judul_berita LIKE 'DEMO Berita%';

-- Bukti hasil DELETE: seharusnya semua bernilai 0
SELECT
  (SELECT COUNT(*) FROM site_settings       WHERE judul_situs = 'DEMO — Site Settings') AS site_settings,
  (SELECT COUNT(*) FROM nav_menus           WHERE posisi_menu = 'demo')                 AS nav_menus,
  (SELECT COUNT(*) FROM members             WHERE slug_anchor = 'profil-demo')          AS members,
  (SELECT COUNT(*) FROM member_socials      WHERE url_profil LIKE '%contoh_demo%')      AS member_socials,
  (SELECT COUNT(*) FROM albums              WHERE judul_album = 'DEMO Album')           AS albums,
  (SELECT COUNT(*) FROM songs               WHERE judul_lagu LIKE 'DEMO Lagu%')         AS songs,
  (SELECT COUNT(*) FROM users               WHERE email = 'demo.user@example.com')      AS users,
  (SELECT COUNT(*) FROM merchandise         WHERE nama_produk = 'DEMO Tee')             AS merchandise,
  (SELECT COUNT(*) FROM press_member_media  WHERE judul_press LIKE 'DEMO Press%')       AS press_member_media,
  (SELECT COUNT(*) FROM messages            WHERE email_pengirim = 'demo.pengirim@example.com') AS messages,
  (SELECT COUNT(*) FROM band_socials        WHERE nama_platform = 'DEMO Platform')      AS band_socials,
  (SELECT COUNT(*) FROM news                WHERE judul_berita LIKE 'DEMO Berita%')     AS news;

SET SQL_SAFE_UPDATES = 1;
