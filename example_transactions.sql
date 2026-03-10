BEGIN;
UPDATE zamowienie
SET status_zamowienia = 'Pakowanie' WHERE id_zamowienie = 10;
INSERT INTO platnosci (id_zamowienie, metoda_platnosci, status_platnosci, kwota_platnosci, data_platnosci)
VALUES (10, 'BLIK', 'OPLACONE', 250.00, CURRENT_DATE);
COMMIT ;

BEGIN;
INSERT INTO zamowienie (id_klient, id_pracownik, data_zamowienia,  status_zamowienia, cena_zamowienia) values (18,5,'2025-02-04 10:40', 'Oczekuje_platnosc',1750);
INSERT INTO zamowiony_produkt (id_zamowienie, id_produkt, ilosc_produktu) VALUES (20, 2, 9);
COMMIT;
