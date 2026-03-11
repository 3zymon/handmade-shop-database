--DELETE pozwala na usuwanie pojedynczych płatności: 
DELETE FROM platnosci WHERE nr_platnosci = 5;

--UPDATE umożliwia aktualizowanie statusów istniejących zamówień:
UPDATE zamowienie SET status_zamowienia = 'Zwrocone' WHERE id_zamowienie = 9;

--INSERT INTO służy do dodania nowego pracownika:
INSERT INTO pracownik (imie, nazwisko, email, nr_telefonu, stanowisko) 
values ('Anna', 'Nowak', 'annaknowak3@gmail.com', '456765987', 'Asystentka prezesa');

--SELECT pobiera nazwy produktów wraz z ich cenami:
SELECT nazwa, cena FROM produkt;

--SELECT pobiera zamówienia o określonym statusie:
SELECT * FROM zamowienie WHERE status_zamowienia = 'Wyslane';
