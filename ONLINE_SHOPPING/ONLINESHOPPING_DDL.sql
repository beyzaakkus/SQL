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
VALUES('Elektronik'),('Aksesuar'), ('Kozmetik'), ('Ev & Ya�am');

INSERT INTO musteri(ad, soyad, email, sehir)
VALUES
('Beyza', 'Akku�', 'akkusbeyza52@gmail.com', '�stanbul'),
('Gamze', 'Demir', 'gamzedemir@exp.com', 'Ankara'),
('Hakan', 'Y�ld�z', 'hakanyildiz@exp.com', 'Eski�ehir'),
('G�l�ah', 'K�se', 'gulsahkose@exp.com', '�stanbul'),
('Enes', 'Do�ru', 'enesdogru@exp.com', '�zmir'),
('Mehmet','Y�lmaz','mehmetyilmaz@exp.com', '�stanbul'),
('Zeynep', '�elik', 'zeynepcelik@exp.com', 'Kastamonu'),
('Seda', 'U�ar', 'sedaucar@exp.com', 'Ayd�n'),
('Tugba', 'Mercan', 'mercantugba@exp.com', 'Konya'),
('H�lya', 'Ton', 'hulyaton@exp.com', 'Trabzon'),
('Ya�mur', 'Kurt', 'yagmurkurt@exp.com', '�stanbul'),
('Umut', 'Karaca', 'umutkaraca@exp.com', 'Nev�ehir'),
('Emincan', 'Tekin', 'emincantekin@exp.com', 'Antalya'),
('Deniz', 'Akyol', 'denizakyol@exp.com', 'Rize'),
('Tolga', 'Kaya', 'tolgakaya@exp.com', '�stanbul'),
('Demet', 'T�rk', 'demetturk@exp.com', 'Ordu'),
('Onur', 'Kutlu', 'onurkutlu@exp.com', 'Bayburt');

INSERT INTO satici(ad, adres)
VALUES
('ButikB','�stanbul'),
('Chic','Bursa'),
('SweetHome','Sakarya'),
('Ak�ar��','Eski�ehir'),
('Pure Bak�m','Isparta'),
('M�zikevi','Ankara'),
('TekTech','Kayseri'),
('Pearl Care','Antalya'),
('Tak�c�m','�zmir'),
('Tiktak Saat','�stanbul');

INSERT INTO urun(ad, fiyat, stok, kategori_id, satici_id)
VALUES
('Kot Pantolon','2290.00','500','1','1'),
('Deri Ceket','2490.00','100','1','2'),
('Kablosuz Kulak�st� Kulakl�k','1519.90','85','2','6'),
('�arjl� Dikey S�p�rge','9199.00','25','2','7'),
('G�ne� G�zl���','3499.90','120','3','9'),
('Kol Saati','2460.00','50','3','10'),
('Nemlendirici','1740.00','150','4','8'),
('G�ne� Kremi','769.90','100','4','5'),
('Abajur','549.85','25','5','3'),
('Kitapl�k','755.83','20','5','4'),
('�i�ek Desenli Vazo','350.00','41','5','4');

INSERT INTO siparis (musteri_id, toplam_tutar, odeme_turu)
VALUES (1, 0.00, 'Banka Kart�');

BEGIN TRAN;

-- Sipari�leri ekleme k�sm�
DECLARE @YeniSiparisler TABLE (siparis_id INT, musteri_id INT, odeme_turu NVARCHAR(50));

INSERT INTO siparis (musteri_id, toplam_tutar, odeme_turu)
OUTPUT INSERTED.id, INSERTED.musteri_id, INSERTED.odeme_turu INTO @YeniSiparisler
VALUES
(1,0.00,'Banka Kart�'),
(2,0.00,'Kredi Kart�'),
(3,0.00,'Dijital C�zdan'),
(4,0.00,'Kap�da �deme'),
(2,0.00,'Havale'),
(5,0.00,'Banka Kart�'),
(6,0.00,'Dijital C�zdan'),
(6,0.00,'Kap�da �deme'),
(8,0.00,'Havale'),
(9,0.00,'Banka Kart�');

--Sepet tablosu: Ayn� veya Farkl� Kategorilerden �r�nler
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

--Sipari� detaylar�n� do�ru siparislerin idleri ile e�leme
INSERT INTO siparis_detay (siparis_id, urun_id, adet, fiyat)
SELECT S.siparis_id, SP.urun_id, SP.adet, U.fiyat
FROM @Sepet SP
JOIN @YeniSiparisler S ON SP.musteri_id = S.musteri_id
JOIN urun U ON U.id = SP.urun_id;

--Stok g�ncelleme
UPDATE U
SET U.stok = U.stok - SD.adet
FROM urun U
JOIN siparis_detay SD ON U.id = SD.urun_id;

--Her sipari� i�in toplam tutar� g�ncelle
UPDATE S
SET S.toplam_tutar = ISNULL((
    SELECT SUM(SD.adet * SD.fiyat)
    FROM siparis_detay SD
    WHERE SD.siparis_id = S.id
),0)
FROM siparis S
JOIN @YeniSiparisler YS ON S.id = YS.siparis_id;

--Stok adedi g�ncelleme
--UPDATE urun SET stok = 20 WHERE stok <= 5;

COMMIT TRAN;

SELECT * FROM kategori ORDER BY id
SELECT * FROM musteri
SELECT * FROM satici
SELECT * FROM urun
SELECT * FROM siparis
UPDATE musteri SET email = 'gulsahkose10@exp.com' WHERE id = 4
UPDATE musteri SET sehir = '�zmir' WHERE id = 15
DELETE FROM siparis WHERE id <66
DELETE FROM siparis WHERE id<79
SELECT * FROM siparis_detay
TRUNCATE TABLE siparis_detay

SELECT id, ad, stok FROM urun WHERE stok < 50
