--Aşağıdaki 15 kaydı tabloya ekleyin (değerleri birebir kullanın):
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('1','Kayıp Zamanın İzinde', 'M. Proust', 'roman', '129.50', '25', '1913', '2025-08-20');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('2','Simyacı', 'P. Coelho', 'roman', '89.50', '40', '1988', '2025-08-21');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('3','Sapiens', 'Y. N. Harari', 'tarih', '159.00', '18', '2011', '2025-08-25');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('4','İnce Memed', 'Y. Kemal', 'roman', '99.90', '12', '1955', '2025-08-22');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('5','Körlük', 'J. Saramago', 'roman', '119.00', '7', '1995', '2025-08-28');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('6','Dune', 'F. Herbert', 'bilim', '149.00', '30', '1965', '2025-09-01');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('7','Hayvan Çiftliği', 'G. Orwell', 'roman', '79.90', '55', '1945', '2025-08-23');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('8','1984', 'G. Orwell', 'roman', '99.00', '35', '1949', '2025-08-24');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('9','Nutuk', 'M. K. Atatürk', 'tarih', '139.00', '20', '1927', '2025-08-27');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('10','Küçük Prens', 'A. de Saint-Exupéry', 'çocuk', '69.90', '80', '1943', '2025-08-26');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('11','Başlangıç', 'D. Brown', 'roman', '109.00', '22', '2017', '2025-09-02');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('12','Atomik Alışkanlıklar', 'J. Clear', 'kişslgelşm', '129.00', '28', '2018', '2025-09-03');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('13','Zamanın Kısa Tarihi', 'S. Hawking', 'bilim', '119.50', '16', '1988', '2025-08-29');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('14','Şeker Portakalı', 'J. M. de Vasconcelos', 'roman', '84.90', '45', '1968', '2025-08-30');
INSERT INTO Book (book_id, title, author, genre, price, stock_qty, published_year, added_at)
VALUES ('15','Bir İdam Mahkûmunun Son Günü', 'V. Hugo', 'roman', '74.90', '26', '1829', '2025-08-31');
SELECT * FROM Book
--1. Tüm kitapların title, author, price alanlarını fiyatı artan şekilde sıralayarak listeleyin.
SELECT title, author, price FROM Book ORDER BY price ASC
--2. Türü 'roman' olan kitapları A→Z title sırasıyla gösterin.
SELECT * FROM Book WHERE genre = 'roman' ORDER BY title ASC
--3. Fiyatı 80 ile 120 (dahil) arasındaki kitapları listeleyin (BETWEEN).
SELECT title, price FROM Book WHERE price BETWEEN  80 and 120 ORDER BY price ASC
--4. Stok adedi 20’den az olan kitapları bulun (title, stock_qty).
SELECT title, stock_qty FROM Book WHERE stock_qty < 20 ORDER BY stock_qty ASC
--5. title içinde 'zaman' geçen kitapları LIKE ile filtreleyin (büyük/küçük harf durumunu not edin).
SELECT title FROM Book WHERE title LIKE '%zaman%'
--6. genre değeri 'roman' veya 'bilim' olanları IN ile listeleyin.
SELECT title, genre FROM Book WHERE genre IN ('roman','bilim')
--7. published_year değeri 2000 ve sonrası olan kitapları, en yeni yıldan eskiye doğru sıralayın.
SELECT title, published_year FROM Book WHERE published_year >= 2000 ORDER BY published_year DESC
--8. Son 10 gün içinde eklenen kitapları bulun (added_at tarihine göre).
SELECT title, added_at FROM Book WHERE added_at >= DATEADD(DAY, -10, GETDATE())
--9. En pahalı 5 kitabı price azalan sırada listeleyin (LIMIT 5).
SELECT title, price FROM Book ORDER BY price DESC --sqlserver de LIMIT olmadığı için TOP kullandım
--10. Stok adedi 30 ile 60 arasında olan kitapları price artan şekilde sıralayın.
SELECT title, stock_qty, price FROM Book WHERE stock_qty BETWEEN 30 and 60 ORDER BY price ASC