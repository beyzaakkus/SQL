--USE ONLINE_SHOPPING;

--C.VER� SORGULAMA VE RAPORLAMA
--Temel Sorgular
-- En �ok sipari� veren 5 m��teri. 
SELECT TOP 5 M.id AS "M��teri ID", M.ad + ' ' + M.soyad AS "M��teri Ad Soyad", COUNT(*) AS "Sipari� Say�s�" FROM musteri M
JOIN siparis S On S.musteri_id = M.id
GROUP BY M.id, M.ad + ' ' + M.soyad ORDER BY "Sipari� Say�s�" DESC;

-- En �ok sat�lan �r�nler. 
SELECT U.ad AS "�r�n Ad�", COUNT(*) AS "Sat�� Adedi" FROM urun U
JOIN siparis_detay SD ON SD.urun_id = U.id
GROUP BY U.ad ORDER BY "Sat�� Adedi";

-- En y�ksek cirosu olan sat�c�lar.
SELECT ST.id AS "Sat�c� ID", ST.ad AS "Sat�c�", SUM(SD.adet * SD.fiyat) AS "Toplam Ciro" FROM satici ST
JOIN urun U ON U.satici_id = ST.id
JOIN siparis_detay SD ON SD.urun_id = U.id
GROUP BY ST.id, ST.ad ORDER BY "Toplam Ciro";

--AGGREGATE & GROUP BY
--�ehirlere g�re m��teri say�s�
SELECT sehir AS "�ehir", COUNT(*) AS "M��teri Say�s�" FROM musteri
GROUP BY sehir ORDER BY "M��teri Say�s�" DESC;

--Kategori bazl� toplam sat��lar
SELECT K.ad AS "Kategori", 
SUM(SD.adet * SD.fiyat) AS "Toplam Sat��" FROM kategori K
JOIN urun U ON U.kategori_id = K.id
JOIN siparis_detay SD ON SD.urun_id = U.id
GROUP BY K.ad ORDER BY "Toplam Sat��" DESC;

--Aylara g�re sipari� say�s�
SELECT MONTH(tarih) AS "Ay", COUNT(*) AS "Toplam Sipari� Say�s�" FROM siparis
GROUP BY MONTH(tarih);

--JOIN�ler: 
-- Sipari�lerde m��teri bilgisi + �r�n bilgisi + sat�c� bilgisi. 
SELECT S.id AS "Sipari� ID", M.ad +' '+ M.soyad AS "M��teri Ad Soyad", U.ad AS "�r�n Ad�", ST.ad AS "Sat�c� Ad�" FROM siparis S
JOIN musteri M ON S.musteri_id = M.id
JOIN siparis_detay SD ON SD.siparis_id = S.id
JOIN urun U ON SD.urun_id = U.id
JOIN satici ST ON U.satici_id = ST.id
ORDER BY S.id;

-- Hi� sat�lmam�� �r�nler. 
SELECT U.id AS "�r�n ID", U.ad AS "�r�n Ad�", COUNT(SD.urun_id) AS "Sipari� Say�s�" FROM urun U
LEFT JOIN siparis_detay SD ON SD.urun_id = U.id
GROUP BY U.id, U.ad
HAVING COUNT(SD.urun_id) = 0

SELECT U.id, U.ad
FROM urun U
LEFT JOIN siparis_detay SD ON SD.urun_id = U.id
WHERE SD.urun_id IS NULL;

-- Hi� sipari� vermemi� m��teriler.
SELECT M.id AS "M��teri ID", M.ad +' '+ M.soyad AS "M��teri Ad Soyad", COUNT(S.id) AS "Sipari� Adedi" FROM musteri M
LEFT JOIN siparis S ON S.musteri_id = M.id
GROUP BY M.id, M.ad +' '+ M.soyad
HAVING COUNT(S.id) = 0

SELECT M.id AS "M��teri ID", M.ad +' '+ M.soyad AS "M��teri Ad Soyad" FROM musteri M
LEFT JOIN siparis S ON S.musteri_id = M.id
WHERE S.id IS NULL

--D.�LER� SEV�YE G�REVLER
--En �ok kazan� sa�layan ilk 3 kategori.
SELECT TOP 3 K.ad AS "Kategori Ad�", SUM(SD.adet * SD.fiyat) AS "Toplam Kazan�" FROM kategori K
JOIN urun U ON U.kategori_id = K.id
JOIN siparis_detay SD ON SD.urun_id = U.id
GROUP BY K.ad ORDER BY SUM(SD.adet * SD.fiyat) DESC;

--Ortalama sipari� tutar�n� ge�en sipari�leri bul.
SELECT musteri_id, id, toplam_tutar, AVG(toplam_tutar) AS "Ortalama Sat��" FROM siparis
GROUP BY musteri_id, id, toplam_tutar
HAVING toplam_tutar > AVG(toplam_tutar)
ORDER BY "Ortalama Sat��" DESC; 

-- En az bir kez elektronik �r�n sat�n alan m��teriler.
SELECT DISTINCT M.id "M��teri ID", M.ad +' '+M.soyad AS "M��teri Ad Soyad" FROM musteri M
JOIN siparis S ON S.musteri_id = M.id
JOIN siparis_detay SD ON SD.siparis_id = S.id
JOIN urun U ON SD.urun_id = U.id
JOIN kategori K ON U.kategori_id = K.id
WHERE K.ad = 'Elektronik';

