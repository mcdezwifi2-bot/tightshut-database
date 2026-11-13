-- ============================================================
-- TIGHTSHUT — WBS 2.2: Operasi CREATE (INSERT) dan READ (SELECT)
-- Mencakup 13 tabel di database tightshut_db.
-- Semua data di sini adalah DATA DEMO (ditandai "DEMO"/"demo"), bukan data asli.
-- Jalankan SETELAH tightshut_db.sql ter-import.
-- ============================================================
USE tightshut_db;

-- ------------------------------------------------------------
-- A. CREATE (INSERT) — urutan mengikuti relasi: induk dulu, baru anak
-- ------------------------------------------------------------

-- 1. site_settings (standalone)
INSERT INTO site_settings (judul_situs, url_logo, bg_hero, tag_hero, judul_hero, sub_hero, footer_band, footer_copy, footer_kota, info_pembayaran)
VALUES ('DEMO — Site Settings', 'assets/logo.png', 'assets/cover.jpg', '— Demo —', 'Demo Hero', 'Baris demo untuk uji CRUD.',
        'TIGHTSHUT', '© DEMO', 'Pontianak, Indonesia', 'Bank DEMO\nNo. Rek: 0000000000\nA.n. DEMO');

-- 2. nav_menus (standalone). posisi_menu = 'demo' agar tidak muncul di navbar/hero.
INSERT INTO nav_menus (label_menu, url_menu, posisi_menu, kelas_tombol, urutan_tampil)
VALUES ('DEMO Menu', 'demo.php', 'demo', 'btn--ghost', 99);

-- 3. members (induk dari member_socials & press_member_media)
INSERT INTO members (slug_anchor, nama_lengkap, tempat_lahir, tanggal_lahir, golongan_darah, posisi_band, biografi, foto_profil, urutan_tampil)
VALUES ('profil-demo', 'DEMO Member', 'Pontianak', '2000-01-01', 'A', 'Guitar', 'Biodata demo.', NULL, 99);

-- 4. member_socials (anak members) — id_member diambil lewat slug, bukan angka tetap
INSERT INTO member_socials (id_member, nama_platform, url_profil)
SELECT id_member, 'Instagram', 'https://instagram.com/contoh_demo' FROM members WHERE slug_anchor = 'profil-demo';

-- 5. albums (induk dari songs)
INSERT INTO albums (judul_album, tanggal_rilis, jenis_album, gambar_sampul)
VALUES ('DEMO Album', '2026-01-01', 'EP', 'assets/cover.jpg');

-- 6. songs (anak albums)
INSERT INTO songs (id_album, judul_lagu, durasi_lagu, file_audio)
SELECT id_album, 'DEMO Lagu 1', '00:03:30', NULL FROM albums WHERE judul_album = 'DEMO Album';
INSERT INTO songs (id_album, judul_lagu, durasi_lagu, file_audio)
SELECT id_album, 'DEMO Lagu 2', '00:02:45', NULL FROM albums WHERE judul_album = 'DEMO Album';

-- 7. users (induk dari merch_orders). Hash di bawah SENGAJA palsu (bukan password siapa pun).
INSERT INTO users (nama_lengkap, email, password, telepon, alamat_kirim, waktu_dibuat)
VALUES ('DEMO User', 'demo.user@example.com', '$2y$10$DEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEMOHASHDEM', '081200000000', 'Jl. Demo No. 1, Pontianak', NOW());

-- 8. merchandise (induk dari merch_orders)
INSERT INTO merchandise (nama_produk, deskripsi, harga, gambar_produk, stok, ukuran_tersedia, produk_unggulan)
VALUES ('DEMO Tee', 'Produk demo untuk uji CRUD.', 100000.00, 'assets/tshirt.jpg', 10, 'S,M,L', 0);

-- 9. merch_orders (anak users & merchandise); total_harga dihitung dari harga × jumlah
INSERT INTO merch_orders (id_pengguna, id_merch, jumlah_beli, ukuran, total_harga, status_pesanan, waktu_pesan)
SELECT u.id_pengguna, m.id_merch, 2, 'M', m.harga * 2, 'Pending', NOW()
FROM users u JOIN merchandise m ON m.nama_produk = 'DEMO Tee'
WHERE u.email = 'demo.user@example.com';

-- 10. press_member_media (anak members; id_member boleh NULL untuk foto bersama)
INSERT INTO press_member_media (id_member, judul_press, keterangan, url_foto, konten_eksklusif, tanggal_publikasi)
SELECT id_member, 'DEMO Press (member)', 'Dokumentasi demo.', 'assets/band-photo.jpg', 0, '2026-01-01' FROM members WHERE slug_anchor = 'profil-demo';
INSERT INTO press_member_media (id_member, judul_press, keterangan, url_foto, konten_eksklusif, tanggal_publikasi)
VALUES (NULL, 'DEMO Press (bersama)', 'Foto bersama demo.', 'assets/personil.jpg', 1, '2026-01-02');

-- 11. messages (standalone)
INSERT INTO messages (nama_pengirim, email_pengirim, subjek, isi_pesan, sudah_dibaca, waktu_kirim)
VALUES ('DEMO Pengirim', 'demo.pengirim@example.com', 'DEMO Subjek', 'Isi pesan demo.', 0, NOW());

-- 12. band_socials (standalone)
INSERT INTO band_socials (nama_platform, nama_akun, kelas_ikon, url_sosmed, tampil_di_kontak)
VALUES ('DEMO Platform', '@demo', 'icon-demo', 'https://example.com/demo', 0);

-- 13. news (standalone)
INSERT INTO news (judul_berita, kategori_berita, isi_berita, tanggal_publikasi, gambar_berita)
VALUES ('DEMO Berita', 'Demo', 'Isi berita demo.', NOW(), NULL);

-- ------------------------------------------------------------
-- B. READ (SELECT)
-- ------------------------------------------------------------

-- B1. Baca seluruh isi tiap tabel
SELECT * FROM site_settings;
SELECT * FROM nav_menus ORDER BY posisi_menu, urutan_tampil;
SELECT * FROM members ORDER BY urutan_tampil;
SELECT * FROM member_socials;
SELECT * FROM albums;
SELECT * FROM songs;
SELECT * FROM users;
SELECT * FROM merchandise;
SELECT * FROM merch_orders;
SELECT * FROM press_member_media;
SELECT * FROM messages;
SELECT * FROM band_socials;
SELECT * FROM news;

-- B2. SELECT dengan kondisi (WHERE) dan pengurutan (ORDER BY)
SELECT label_menu, url_menu FROM nav_menus WHERE posisi_menu = 'navbar' ORDER BY urutan_tampil;
SELECT nama_lengkap, posisi_band FROM members WHERE posisi_band = 'Guitar';
SELECT judul_press, tanggal_publikasi FROM press_member_media WHERE konten_eksklusif = 1;
SELECT nama_produk, harga, stok FROM merchandise WHERE stok > 0 ORDER BY harga DESC;
SELECT nama_platform, url_sosmed FROM band_socials WHERE tampil_di_kontak = 1;

-- B3. SELECT dengan JOIN (membaca data lintas tabel yang berelasi)
-- members -> member_socials
SELECT m.nama_lengkap, s.nama_platform, s.url_profil
FROM members m JOIN member_socials s ON s.id_member = m.id_member;

-- albums -> songs
SELECT a.judul_album, s.judul_lagu, s.durasi_lagu
FROM albums a JOIN songs s ON s.id_album = a.id_album
ORDER BY a.id_album, s.id_lagu;

-- users -> merch_orders <- merchandise
SELECT o.id_pesanan, u.nama_lengkap AS pembeli, p.nama_produk, o.ukuran, o.jumlah_beli, o.total_harga, o.status_pesanan
FROM merch_orders o
JOIN users u       ON u.id_pengguna = o.id_pengguna
JOIN merchandise p ON p.id_merch    = o.id_merch;

-- members -> press_member_media (LEFT JOIN: foto bersama dengan id_member NULL tetap tampil)
SELECT p.judul_press, COALESCE(m.nama_lengkap, '(foto bersama)') AS member
FROM press_member_media p LEFT JOIN members m ON m.id_member = p.id_member;

-- B4. SELECT agregat
SELECT COUNT(*) AS jumlah_lagu FROM songs;
SELECT status_pesanan, COUNT(*) AS jumlah_pesanan, SUM(total_harga) AS total FROM merch_orders GROUP BY status_pesanan;
