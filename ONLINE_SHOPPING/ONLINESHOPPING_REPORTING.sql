--USE ONLINE_SHOPPING;

--C.VERÝ SORGULAMA VE RAPORLAMA
--Temel Sorgular
-- En çok sipariþ veren 5 müþteri. 
SELECT TOP 5 M.id AS "Müþteri ID", M.ad + ' ' + M.soyad AS "Müþteri Ad Soyad", COUNT(*) AS "Sipariþ Sayýsý" FROM musteri M
JOIN siparis S On S.musteri_id = M.id
GROUP BY M.id, M.ad + ' ' + M.soyad ORDER BY "Sipariþ Sayýsý" DESC;

-- En çok satýlan ürünler. 
SELECT U.ad AS "Ürün Adý", COUNT(*) AS "Satýþ Adedi" FROM urun U
JOIN siparis_detay SD ON SD.urun_id = U.id
GROUP BY U.ad ORDER BY "Satýþ Adedi";

-- En yüksek cirosu olan satýcýlar.
SELECT ST.id AS "Satýcý ID", ST.ad AS "Satýcý", SUM(SD.adet * SD.fiyat) AS "Toplam Ciro" FROM satici ST
JOIN urun U ON U.satici_id = ST.id
JOIN siparis_detay SD ON SD.urun_id = U.id
GROUP BY ST.id, ST.ad ORDER BY "Toplam Ciro";

--AGGREGATE & GROUP BY
--Þehirlere göre müþteri sayýsý
SELECT sehir AS "Þehir", COUNT(*) AS "Müþteri Sayýsý" FROM musteri
GROUP BY sehir ORDER BY "Müþteri Sayýsý" DESC;

--Kategori bazlý toplam satýþlar
SELECT K.ad AS "Kategori", 
SUM(SD.adet * SD.fiyat) AS "Toplam Satýþ" FROM kategori K
JOIN urun U ON U.kategori_id = K.id
JOIN siparis_detay SD ON SD.urun_id = U.id
GROUP BY K.ad ORDER BY "Toplam Satýþ" DESC;

--Aylara göre sipariþ sayýsý
SELECT MONTH(tarih) AS "Ay", COUNT(*) AS "Toplam Sipariþ Sayýsý" FROM siparis
GROUP BY MONTH(tarih);

--JOIN’ler: 
-- Sipariþlerde müþteri bilgisi + ürün bilgisi + satýcý bilgisi. 
SELECT S.id AS "Sipariþ ID", M.ad +' '+ M.soyad AS "Müþteri Ad Soyad", U.ad AS "Ürün Adý", ST.ad AS "Satýcý Adý" FROM siparis S
JOIN musteri M ON S.musteri_id = M.id
JOIN siparis_detay SD ON SD.siparis_id = S.id
JOIN urun U ON SD.urun_id = U.id
JOIN satici ST ON U.satici_id = ST.id
ORDER BY S.id;

-- Hiç satýlmamýþ ürünler. 
SELECT U.id AS "Ürün ID", U.ad AS "Ürün Adý", COUNT(SD.urun_id) AS "Sipariþ Sayýsý" FROM urun U
LEFT JOIN siparis_detay SD ON SD.urun_id = U.id
GROUP BY U.id, U.ad
HAVING COUNT(SD.urun_id) = 0

SELECT U.id, U.ad
FROM urun U
LEFT JOIN siparis_detay SD ON SD.urun_id = U.id
WHERE SD.urun_id IS NULL;

-- Hiç sipariþ vermemiþ müþteriler.
SELECT M.id AS "Müþteri ID", M.ad +' '+ M.soyad AS "Müþteri Ad Soyad", COUNT(S.id) AS "Sipariþ Adedi" FROM musteri M
LEFT JOIN siparis S ON S.musteri_id = M.id
GROUP BY M.id, M.ad +' '+ M.soyad
HAVING COUNT(S.id) = 0

SELECT M.id AS "Müþteri ID", M.ad +' '+ M.soyad AS "Müþteri Ad Soyad" FROM musteri M
LEFT JOIN siparis S ON S.musteri_id = M.id
WHERE S.id IS NULL

--D.ÝLERÝ SEVÝYE GÖREVLER
--En çok kazanç saðlayan ilk 3 kategori.
SELECT TOP 3 K.ad AS "Kategori Adý", SUM(SD.adet * SD.fiyat) AS "Toplam Kazanç" FROM kategori K
JOIN urun U ON U.kategori_id = K.id
JOIN siparis_detay SD ON SD.urun_id = U.id
GROUP BY K.ad ORDER BY SUM(SD.adet * SD.fiyat) DESC;

--Ortalama sipariþ tutarýný geçen sipariþleri bul.
SELECT musteri_id, id, toplam_tutar, AVG(toplam_tutar) AS "Ortalama Satýþ" FROM siparis
GROUP BY musteri_id, id, toplam_tutar
HAVING toplam_tutar > AVG(toplam_tutar)
ORDER BY "Ortalama Satýþ" DESC; 

-- En az bir kez elektronik ürün satýn alan müþteriler.
SELECT DISTINCT M.id "Müþteri ID", M.ad +' '+M.soyad AS "Müþteri Ad Soyad" FROM musteri M
JOIN siparis S ON S.musteri_id = M.id
JOIN siparis_detay SD ON SD.siparis_id = S.id
JOIN urun U ON SD.urun_id = U.id
JOIN kategori K ON U.kategori_id = K.id
WHERE K.ad = 'Elektronik';

