--widok_aktywnosc_klientow prezentuje liczbe zamowien i wartosc zakupow klientow
CREATE VIEW widok_aktywnosc_klientow AS
SELECT
    k.id_klient,
    k.imie,
    k.nazwisko,
    COUNT(z.id_zamowienie) AS liczba_zamowien,
    COALESCE(SUM(z.cena_zamowienia), 0) AS wartosc_zakupow,
    COALESCE(ROUND(AVG(z.cena_zamowienia), 2), 0) AS srednia_wartosc_zamowienia,
    MAX(z.data_zamowienia) AS data_ostatniego_zamowienia
FROM klient k
LEFT JOIN zamowienie z
    ON k.id_klient = z.id_klient
    AND z.status_zamowienia <> 'Anulowane'
GROUP BY k.id_klient, k.imie, k.nazwisko;

--widok_status_zamowien pokazuje liczbe zamowien wedlug statusow
CREATE VIEW widok_status_zamowien AS
SELECT
    status_zamowienia,
    COUNT(*) AS liczba_zamowien,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS udzial_procentowy
FROM zamowienie
GROUP BY status_zamowienia;

--widok_sprzedaz_miesieczna to miesieczna wartosc sprzedazy
CREATE VIEW widok_sprzedaz_miesieczna AS
SELECT
    DATE_TRUNC('month', data_zamowienia)::DATE AS miesiac,
    COUNT(*) AS liczba_zamowien,
    SUM(cena_zamowienia) AS przychod,
    ROUND(AVG(cena_zamowienia), 2) AS srednia_wartosc_zamowienia
FROM zamowienie
WHERE status_zamowienia <> 'Anulowane'
GROUP BY DATE_TRUNC('month', data_zamowienia)::DATE;

--widok_sprzedaz_produktow pokazuje ile sztuk kazdego produktu sprzedano i jaki przychod wygenerowal
CREATE VIEW widok_sprzedaz_produktow AS
SELECT 
    p.id_produkt,
	p.nazwa,
	p.kategoria,
	SUM(zp.ilosc_produktu) AS liczba_sprzedanych_sztuk,
	SUM(zp.ilosc_produktu * zp.cena_zakupu) AS przychod
FROM produkt p
JOIN zamowiony_produkt zp
    ON p.id_produkt = zp.id_produkt
JOIN zamowienie z
    ON zp.id_zamowienie = z.id_zamowienie
WHERE z.status_zamowienia <> 'Anulowane'
GROUP BY
    p.id_produkt,
	p.nazwa,
	p.kategoria;

--widok_sprzedaz_kategorii prezentuje przychod i liczbe zamowien wedlug kategorii
CREATE VIEW widok_sprzedaz_kategorii AS
SELECT
    p.kategoria,
    COUNT(DISTINCT zp.id_zamowienie) AS liczba_zamowien,
	SUM(zp.ilosc_produktu) AS liczba_sprzedanych_sztuk,
    SUM(zp.ilosc_produktu * zp.cena_zakupu) AS przychod
FROM produkt p
JOIN zamowiony_produkt zp
    ON p.id_produkt = zp.id_produkt
JOIN zamowienie z
    ON zp.id_zamowienie = z.id_zamowienie
WHERE z.status_zamowienia <> 'Anulowane'
GROUP BY
    p.kategoria;

--widok_dostawcy umożliwia szybki podgląd dostawców materiałów:
CREATE VIEW widok_dostawcy AS 
SELECT dostawca, id_material, nazwa 
FROM material;

--widok_pracownik_podstawowy prezentuje podstawowe dane pracowników:
CREATE VIEW widok_pracownik_podstawowy AS 
SELECT imie, nazwisko, email 
FROM pracownik;

--widok_material_magazyn służy do monitorowania stanów magazynowych:
CREATE VIEW widok_material_magazyn AS 
SELECT id_material, nazwa, kategoria, ilosc_magazynie, jednostka_miary
FROM material;
