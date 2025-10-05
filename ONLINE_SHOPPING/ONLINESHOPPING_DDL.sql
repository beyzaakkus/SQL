--CREATE DATABASE ONLINE_SHOPPING;
--USE ONLINE_SHOPPING;

CREATE TABLE musteri(
id INT IDENTITY(1,1) PRIMARY KEY,
ad NVARCHAR(100) NOT NULL,
soyad NVARCHAR(100) NOT NULL,
email NVARCHAR(100) NOT NULL UNIQUE,
sehir NVARCHAR(100),
kayit_tarihi DATETIME DEFAULT GETDATE()
);

CREATE TABLE kategori(
id INT IDENTITY(1,1) PRIMARY KEY,
ad NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE satici(
id INT IDENTITY(1,1) PRIMARY KEY,
ad NVARCHAR(200) NOT NULL,
adres NVARCHAR(200)
);

CREATE TABLE urun(
id INT IDENTITY(1,1) PRIMARY KEY,
ad NVARCHAR(200) NOT NULL,
fiyat DECIMAL(10,2) NOT NULL,
stok INT NOT NULL DEFAULT 0,
kategori_id INT,
satici_id INT,
FOREIGN KEY (kategori_id) REFERENCES kategori(id),
FOREIGN KEY (satici_id) REFERENCES satici(id)
);

CREATE TABLE siparis(
id INT IDENTITY(1,1) PRIMARY KEY,
tarih DATETIME DEFAULT GETDATE(),
toplam_tutar DECIMAL(12,2) NOT NULL DEFAULT 0.00,
odeme_turu NVARCHAR(50),
musteri_id INT NOT NULL,
FOREIGN KEY (musteri_id) REFERENCES musteri(id)
);

CREATE TABLE siparis_detay(
id INT IDENTITY(1,1) PRIMARY KEY,
adet INT NOT NULL,
fiyat DECIMAL(10,2) NOT NULL,
siparis_id INT NOT NULL,
urun_id INT NOT NULL,
FOREIGN KEY (siparis_id) REFERENCES siparis(id),
FOREIGN KEY (urun_id) REFERENCES urun(id) ON DELETE CASCADE
);

INSERT INTO kategori(ad)
VALUES('Elektronik'),('Aksesuar'), ('Kozmetik'), ('Ev & Yaþam');

INSERT INTO musteri(ad, soyad, email, sehir)
VALUES
('Beyza', 'Akkuþ', 'akkusbeyza52@gmail.com', 'Ýstanbul'),
('Gamze', 'Demir', 'gamzedemir@exp.com', 'Ankara'),
('Hakan', 'Yýldýz', 'hakanyildiz@exp.com', 'Eskiþehir'),
('Gülþah', 'Köse', 'gulsahkose@exp.com', 'Ýstanbul'),
('Enes', 'Doðru', 'enesdogru@exp.com', 'Ýzmir'),
('Mehmet','Yýlmaz','mehmetyilmaz@exp.com', 'Ýstanbul'),
('Zeynep', 'Çelik', 'zeynepcelik@exp.com', 'Kastamonu'),
('Seda', 'Uçar', 'sedaucar@exp.com', 'Aydýn'),
('Tugba', 'Mercan', 'mercantugba@exp.com', 'Konya'),
('Hülya', 'Ton', 'hulyaton@exp.com', 'Trabzon'),
('Yaðmur', 'Kurt', 'yagmurkurt@exp.com', 'Ýstanbul'),
('Umut', 'Karaca', 'umutkaraca@exp.com', 'Nevþehir'),
('Emincan', 'Tekin', 'emincantekin@exp.com', 'Antalya'),
('Deniz', 'Akyol', 'denizakyol@exp.com', 'Rize'),
('Tolga', 'Kaya', 'tolgakaya@exp.com', 'Ýstanbul'),
('Demet', 'Türk', 'demetturk@exp.com', 'Ordu'),
('Onur', 'Kutlu', 'onurkutlu@exp.com', 'Bayburt');

INSERT INTO satici(ad, adres)
VALUES
('ButikB','Ýstanbul'),
('Chic','Bursa'),
('SweetHome','Sakarya'),
('Akçarþý','Eskiþehir'),
('Pure Bakým','Isparta'),
('Müzikevi','Ankara'),
('TekTech','Kayseri'),
('Pearl Care','Antalya'),
('Takýcým','Ýzmir'),
('Tiktak Saat','Ýstanbul');

INSERT INTO urun(ad, fiyat, stok, kategori_id, satici_id)
VALUES
('Kot Pantolon','2290.00','500','1','1'),
('Deri Ceket','2490.00','100','1','2'),
('Kablosuz Kulaküstü Kulaklýk','1519.90','85','2','6'),
('Þarjlý Dikey Süpürge','9199.00','25','2','7'),
('Güneþ Gözlüðü','3499.90','120','3','9'),
('Kol Saati','2460.00','50','3','10'),
('Nemlendirici','1740.00','150','4','8'),
('Güneþ Kremi','769.90','100','4','5'),
('Abajur','549.85','25','5','3'),
('Kitaplýk','755.83','20','5','4'),
('Çiçek Desenli Vazo','350.00','41','5','4');

INSERT INTO siparis (musteri_id, toplam_tutar, odeme_turu)
VALUES (1, 0.00, 'Banka Kartý');

BEGIN TRAN;

-- Sipariþleri ekleme kýsmý
DECLARE @YeniSiparisler TABLE (siparis_id INT, musteri_id INT, odeme_turu NVARCHAR(50));

INSERT INTO siparis (musteri_id, toplam_tutar, odeme_turu)
OUTPUT INSERTED.id, INSERTED.musteri_id, INSERTED.odeme_turu INTO @YeniSiparisler
VALUES
(1,0.00,'Banka Kartý'),
(2,0.00,'Kredi Kartý'),
(3,0.00,'Dijital Cüzdan'),
(4,0.00,'Kapýda Ödeme'),
(2,0.00,'Havale'),
(5,0.00,'Banka Kartý'),
(6,0.00,'Dijital Cüzdan'),
(6,0.00,'Kapýda Ödeme'),
(8,0.00,'Havale'),
(9,0.00,'Banka Kartý');

--Sepet tablosu: Ayný veya Farklý Kategorilerden Ürünler
DECLARE @Sepet TABLE (musteri_id INT, urun_id INT, adet INT);

INSERT INTO @Sepet (musteri_id, urun_id, adet)
VALUES
(1, 6, 2),  
(1, 7, 1),  
(1, 8, 3);  

INSERT INTO @Sepet (musteri_id, urun_id, adet)
VALUES
(2, 6, 1),
(2, 9, 2),
(2, 10, 1);

INSERT INTO @Sepet (musteri_id, urun_id, adet)
VALUES
(3, 7, 1),
(3, 8, 1),
(3, 7, 2);

INSERT INTO @Sepet (musteri_id, urun_id, adet)
VALUES
(6, 7, 1),
(8, 8, 1),
(9, 7, 2);

--Sipariþ detaylarýný doðru siparislerin idleri ile eþleme
INSERT INTO siparis_detay (siparis_id, urun_id, adet, fiyat)
SELECT S.siparis_id, SP.urun_id, SP.adet, U.fiyat
FROM @Sepet SP
JOIN @YeniSiparisler S ON SP.musteri_id = S.musteri_id
JOIN urun U ON U.id = SP.urun_id;

--Stok güncelleme
UPDATE U
SET U.stok = U.stok - SD.adet
FROM urun U
JOIN siparis_detay SD ON U.id = SD.urun_id;

--Her sipariþ için toplam tutarý güncelle
UPDATE S
SET S.toplam_tutar = ISNULL((
    SELECT SUM(SD.adet * SD.fiyat)
    FROM siparis_detay SD
    WHERE SD.siparis_id = S.id
),0)
FROM siparis S
JOIN @YeniSiparisler YS ON S.id = YS.siparis_id;

--Stok adedi güncelleme
--UPDATE urun SET stok = 20 WHERE stok <= 5;

COMMIT TRAN;

SELECT * FROM kategori ORDER BY id
SELECT * FROM musteri
SELECT * FROM satici
SELECT * FROM urun
SELECT * FROM siparis
UPDATE musteri SET email = 'gulsahkose10@exp.com' WHERE id = 4
UPDATE musteri SET sehir = 'Ýzmir' WHERE id = 15
DELETE FROM siparis WHERE id <66
DELETE FROM siparis WHERE id<79
SELECT * FROM siparis_detay
TRUNCATE TABLE siparis_detay

SELECT id, ad, stok FROM urun WHERE stok < 50
