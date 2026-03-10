--obliczanie łącznej wartości zamówienia:
CREATE OR REPLACE FUNCTION 
wartosc_zamowienia(p_id_zamowienie BIGINT)
RETURNS NUMERIC 
AS '
SELECT COALESCE(SUM(p.cena * zp.ilosc_produktu), 0) 
FROM zamowiony_produkt zp
JOIN produkt p
ON zp.id_produkt = p.id_produkt
WHERE zp.id_zamowienie = p_id_zamowienie;
'
LANGUAGE SQL;
---
SELECT wartosc_zamowienia(5);

--zwracanie łączną ilość sztuk w zamówieniu:
CREATE OR REPLACE FUNCTION
liczba_produktow_zamowieniu(p_id_zamowienie BIGINT)
RETURNS INT
AS '
SELECT COALESCE(SUM(ilosc_produktu), 0) FROM zamowiony_produkt
WHERE id_zamowienie = p_id_zamowienie;
'
LANGUAGE sql;
---
SELECT liczba_produktow_zamowieniu(10);

--sprawdzanie czy zamówienie opłacono:
CREATE OR REPLACE FUNCTION
czy_zamowienie_oplacone(p_id_zamowienie BIGINT)
RETURNS BOOLEAN
AS $$
SELECT EXISTS (
SELECT 1
FROM platnosci
WHERE id_zamowienie = p_id_zamowienie
AND status_platnosci = 'Oplacona' );
$$
LANGUAGE sql;
---
SELECT czy_zamowienie_oplacone(14);

--obliczanie liczby zamówień klienta:
CREATE OR REPLACE FUNCTION
liczba_zamowien_klienta(p_id_klient BIGINT)
RETURNS INT
AS '
SELECT COUNT(*)
FROM zamowienie
WHERE id_klient = p_id_klient;
'
LANGUAGE sql;
---
SELECT liczba_zamowien_klienta(4);

--sprawdzanie dostępności materiału w magazynie:
CREATE OR REPLACE FUNCTION
czy_material_dostepny(p_id_material BIGINT)
RETURNS BOOLEAN
AS '
SELECT ilosc_magazynie > 0
FROM material
WHERE id_material = p_id_material;
'
LANGUAGE sql;
---
SELECT czy_material_dostepny(1);

--obliczanie średnią wartość zamówień klienta:
CREATE OR REPLACE FUNCTION
sr_wartosc_zamowien_klienta(p_id_klient BIGINT)
RETURNS NUMERIC
AS '
SELECT COALESCE(AVG(cena_zamowienia), 0)
FROM zamowienie
WHERE id_klient = p_id_klient;
'
LANGUAGE sql;
---
SELECT sr_wartosc_zamowien_klienta(10);