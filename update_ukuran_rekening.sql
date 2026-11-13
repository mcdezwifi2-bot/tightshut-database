-- Jalankan SEKALI di tab SQL phpMyAdmin (database tightshut_db yang sudah ada)
ALTER TABLE merchandise  ADD COLUMN ukuran_tersedia VARCHAR(100) NULL AFTER stok;
ALTER TABLE merch_orders ADD COLUMN ukuran VARCHAR(10) NULL AFTER jumlah_beli;
ALTER TABLE site_settings ADD COLUMN info_pembayaran TEXT NULL;

-- Ukuran tersedia (pisahkan dengan koma). Sesuaikan dengan stok aslinya.
UPDATE merchandise SET ukuran_tersedia = 'S,M,L,XL' WHERE id_merch = 1;

-- ISI dengan rekening aslimu (contoh format, GANTI semuanya):
-- UPDATE site_settings SET info_pembayaran = 'Bank ...\nNo. Rek: ...\nA.n. ...';
