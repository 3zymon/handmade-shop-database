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
    ON z.status_zamowienia <> 'Anulowane'
GROUP BY
    p.id_produkt,
	p.nazwa,
	p.kategoria;

--widok_klient_podstawowy udostępnia podstawowe dane klientów bez informacji adresowych:
CREATE VIEW widok_klient_podstawowy AS 
SELECT imie, nazwisko, email 
FROM klient;

--widok_dostawcy umożliwia szybki podgląd dostawców materiałów:
CREATE VIEW widok_dostawcy AS 
SELECT dostawca, id_material, nazwa 
FROM material;

--widok_pracownik_podstawowy prezentuje podstawowe dane pracowników:
CREATE VIEW widok_pracownik_podstawowy AS 
SELECT imie, nazwisko, email 
FROM pracownik;

--widok_zamowienia_status pozwala na kontrolę statusów zamówień:
CREATE VIEW widok_zamowienia_status AS 
SELECT id_zamowienie, data_zamowienia, status_zamowienia 
FROM zamowienie; 

--widok_material_magazyn służy do monitorowania stanów magazynowych:
CREATE VIEW widok_material_magazyn AS 
SELECT id_material, nazwa, kategoria, ilosc_magazynie, jednostka_miary
FROM material;
