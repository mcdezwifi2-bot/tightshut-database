-- ============================================================
-- TIGHTSHUT — skema + data awal
-- Mengikuti struktur tightshut_db di phpMyAdmin (13 tabel: 12 dari rancangan + news)
-- Import ke database KOSONG. Kalau tabel sudah ada, jalankan hanya bagian "DATA AWAL".
-- ============================================================
CREATE DATABASE IF NOT EXISTS tightshut_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tightshut_db;

-- ---------- SKEMA ----------
CREATE TABLE IF NOT EXISTS site_settings (
  id_pengaturan INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  judul_situs VARCHAR(150), url_logo VARCHAR(255), bg_hero VARCHAR(255),
  tag_hero VARCHAR(100), judul_hero VARCHAR(150), sub_hero TEXT,
  footer_band VARCHAR(100), footer_copy VARCHAR(150), footer_kota VARCHAR(100),
  info_pembayaran TEXT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS nav_menus (
  id_menu INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  label_menu VARCHAR(50) NOT NULL, url_menu VARCHAR(255) NOT NULL,
  posisi_menu VARCHAR(20) NOT NULL COMMENT 'navbar | hero_cta',
  kelas_tombol VARCHAR(50), urutan_tampil INT(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS members (
  id_member INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  slug_anchor VARCHAR(50) NOT NULL UNIQUE,
  nama_lengkap VARCHAR(100) NOT NULL,
  tempat_lahir VARCHAR(100) NULL,
  tanggal_lahir DATE NULL,
  golongan_darah VARCHAR(3) NULL,
  posisi_band VARCHAR(50) NOT NULL,
  biografi TEXT NULL,
  foto_profil VARCHAR(255) NULL,
  urutan_tampil INT(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS member_socials (
  id_sosmed INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_member INT(11) NOT NULL,
  nama_platform VARCHAR(50) NOT NULL, url_profil VARCHAR(255) NOT NULL,
  CONSTRAINT fk_ms_member FOREIGN KEY (id_member) REFERENCES members(id_member) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS albums (
  id_album INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  judul_album VARCHAR(150) NOT NULL, tanggal_rilis DATE NULL,
  jenis_album VARCHAR(50), gambar_sampul VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS songs (
  id_lagu INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_album INT(11) NOT NULL, judul_lagu VARCHAR(150) NOT NULL,
  durasi_lagu TIME NULL, file_audio VARCHAR(255) NULL,
  CONSTRAINT fk_song_album FOREIGN KEY (id_album) REFERENCES albums(id_album) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS users (
  id_pengguna INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nama_lengkap VARCHAR(100) NOT NULL, email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL, telepon VARCHAR(20), alamat_kirim TEXT,
  waktu_dibuat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS merchandise (
  id_merch INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nama_produk VARCHAR(150) NOT NULL, deskripsi TEXT,
  harga DECIMAL(10,2) NOT NULL DEFAULT 0, gambar_produk VARCHAR(255),
  stok INT(11) NOT NULL DEFAULT 0, ukuran_tersedia VARCHAR(100) NULL,
  produk_unggulan TINYINT(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS merch_orders (
  id_pesanan INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_pengguna INT(11) NOT NULL, id_merch INT(11) NOT NULL,
  jumlah_beli INT(11) NOT NULL, ukuran VARCHAR(10) NULL, total_harga DECIMAL(10,2) NOT NULL,
  status_pesanan VARCHAR(30) NOT NULL DEFAULT 'Pending' COMMENT 'Pending | Paid | Shipped',
  waktu_pesan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_mo_user  FOREIGN KEY (id_pengguna) REFERENCES users(id_pengguna),
  CONSTRAINT fk_mo_merch FOREIGN KEY (id_merch)    REFERENCES merchandise(id_merch)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS press_member_media (
  id_press INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_member INT(11) NULL COMMENT 'NULL = foto bersama',
  judul_press VARCHAR(150) NOT NULL, keterangan TEXT, url_foto VARCHAR(255) NOT NULL,
  konten_eksklusif TINYINT(1) NOT NULL DEFAULT 0, tanggal_publikasi DATE NULL,
  CONSTRAINT fk_press_member FOREIGN KEY (id_member) REFERENCES members(id_member) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS messages (
  id_pesan INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nama_pengirim VARCHAR(100) NOT NULL, email_pengirim VARCHAR(100) NOT NULL,
  subjek VARCHAR(150) NOT NULL, isi_pesan TEXT NOT NULL,
  sudah_dibaca TINYINT(1) NOT NULL DEFAULT 0,
  waktu_kirim DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS band_socials (
  id_sosmed_band INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nama_platform VARCHAR(50) NOT NULL, nama_akun VARCHAR(100),
  kelas_ikon VARCHAR(50), url_sosmed VARCHAR(255) NOT NULL,
  tampil_di_kontak TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS news (
  id_berita INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  judul_berita VARCHAR(150) NOT NULL, kategori_berita VARCHAR(100),
  isi_berita TEXT, tanggal_publikasi DATETIME, gambar_berita VARCHAR(255)
) ENGINE=InnoDB;

-- ---------- DATA AWAL (diambil dari isi website lama) ----------
INSERT INTO site_settings (judul_situs, url_logo, bg_hero, tag_hero, judul_hero, sub_hero, footer_band, footer_copy, footer_kota) VALUES
('TIGHTSHUT — Rot Beneath The Skin', 'assets/logo.png', 'assets/cover.jpg', '— New Release —',
 'Rot Beneath\nThe Skin',
 'Out now on all platforms. Stream, download, and support independent music.',
 'TIGHTSHUT', '© 2025 — All Rights Reserved', 'Pontianak, Indonesia');

INSERT INTO nav_menus (label_menu, url_menu, posisi_menu, kelas_tombol, urutan_tampil) VALUES
('Home',    'index.php',   'navbar', NULL, 1),
('Music',   'music.php',   'navbar', NULL, 2),
('Merch',   'merch.php',   'navbar', NULL, 3),
('About',   'about.php',   'navbar', NULL, 4),
('Press',   'press.php',   'navbar', NULL, 5),
('Contact', 'contact.php', 'navbar', NULL, 6),
('▶ Spotify',  'https://open.spotify.com/artist/7muskD8PszyL6LYE2JGjfu?si=Q0m8P2idSz26tV1fiEOyFQ', 'hero_cta', 'btn--primary', 1),
('▶ YouTube',  'https://youtu.be/afDWBzkJhhQ?si=rEXCEy9giHHdMTxX', 'hero_cta', 'btn--ghost', 2),
('▶ Bandcamp', 'https://districtsixrecs.bandcamp.com/album/tightshut-rot-beneath-the-skin', 'hero_cta', 'btn--ghost', 3),
('Booking / Contact', 'contact.php', 'hero_cta', 'btn--ghost', 4);

-- Hanya nama & posisi yang diketahui. Isi sendiri: tempat/tanggal lahir, gol. darah, biografi, foto.
INSERT INTO members (slug_anchor, nama_lengkap, posisi_band, urutan_tampil) VALUES
('profil-frans', 'Frans', 'Vocals', 1),
('profil-novan', 'Novan', 'Guitar', 2),
('profil-danu',  'Danu',  'Guitar', 3),
('profil-rizqi', 'Rizqi', 'Bass',   4),
('profil-felix', 'Felix', 'Drums',  5);

INSERT INTO albums (judul_album, jenis_album, gambar_sampul) VALUES
('Rot Beneath The Skin', 'Rilisan 2 track', 'assets/artwork-rot-beneath-the-skin-tape.jpg');
INSERT INTO songs (id_album, judul_lagu) VALUES (1, 'Curse of Illusions'), (1, 'Betrayed');

-- HARGA & STOK sengaja 0: isi sendiri lewat phpMyAdmin sebelum merch bisa dibeli.
INSERT INTO merchandise (nama_produk, deskripsi, harga, gambar_produk, stok, ukuran_tersedia, produk_unggulan) VALUES
('"Rot Beneath The Skin" Official Tee',
 'Bukan sekadar kaos. Ini adalah artefak dari rilisan ini — desain yang lahir dari visual yang sama dengan cover album. Gelap, industrial, dan terasa berat di tubuh.\nMaterial: Heavy Cotton / Gildan · Print: Screen Print / DTG · Warna: Black · Limited Run',
 0, 'assets/tshirt.jpg', 0, 'S,M,L,XL', 1);

INSERT INTO press_member_media (id_member, judul_press, keterangan, url_foto, konten_eksklusif, tanggal_publikasi) VALUES
(NULL, 'Live Performance',  NULL, 'assets/band-photo.jpg', 0, NULL),
(NULL, 'Album Artwork',     NULL, 'assets/cover.jpg', 0, NULL),
(NULL, 'Official Merch',    NULL, 'assets/tshirt.jpg', 0, NULL),
(NULL, 'Personil TIGHTSHUT', NULL, 'assets/personil.jpg', 0, NULL),
(NULL, 'Live / Flyer',      NULL, 'assets/whatsapp-image-2026-06-09-10-04-27.jpg', 0, NULL),
(NULL, 'Behind The Scene',  NULL, 'assets/whatsapp-image-2026-06-09-10-02-39.jpg', 0, NULL);

INSERT INTO band_socials (nama_platform, nama_akun, kelas_ikon, url_sosmed, tampil_di_kontak) VALUES
('Instagram', '@tightshuthc', 'icon-instagram', 'https://www.instagram.com/tightshuthc', 1),
('Bandcamp',  'districtsixrecs.bandcamp.com', 'icon-bandcamp', 'https://districtsixrecs.bandcamp.com/album/tightshut-rot-beneath-the-skin', 1),
('Spotify',   'TIGHTSHUT', 'icon-spotify', 'https://open.spotify.com/artist/7muskD8PszyL6LYE2JGjfu?si=Q0m8P2idSz26tV1fiEOyFQ', 1),
('YouTube',   'Rot Beneath The Skin', 'icon-youtube', 'https://youtu.be/afDWBzkJhhQ?si=rEXCEy9giHHdMTxX', 1);

-- Info rekening: isi sendiri, contoh:
-- UPDATE site_settings SET info_pembayaran = 'Bank ...\nNo. Rek: ...\nA.n. ...';
