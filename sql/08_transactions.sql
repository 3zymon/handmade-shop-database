-- Transakcja utworzenia nowego zamowienia
BEGIN;
WITH nowe_zamowienie AS (
    INSERT INTO zamowienie (
        id_klient,
        id_pracownik,
        status_zamowienia
    )
    VALUES (1, 2, 'Nowe')
    RETURNING id_zamowienie
)
INSERT INTO zamowiony_produkt (
    id_zamowienie,
    id_produkt,
    ilosc_produktu,
    cena_zakupu
)
SELECT
    nz.id_zamowienie,
    p.id_produkt,
    2,
    p.cena
FROM nowe_zamowienie nz
CROSS JOIN produkt p
WHERE p.id_produkt IN (1, 3);
COMMIT;


-- Rejestracja platnosci i przekazanie zamowienia do realizacji
BEGIN;
UPDATE platnosci p
SET
    status_platnosci = 'Zrealizowana',
    kwota_platnosci = z.cena_zamowienia,
    data_platnosci = CURRENT_TIMESTAMP
FROM zamowienie z
WHERE p.id_zamowienie = z.id_zamowienie
    AND z.id_zamowienie = 15
    AND z.status_zamowienia = 'Nowe'
    AND p.status_platnosci = 'Oczekujaca';
	
UPDATE zamowienie
SET status_zamowienia = 'W realizacji'
WHERE id_zamowienie = 15
    AND status_zamowienia = 'Nowe'
    AND czy_zamowienie_oplacone(id_zamowienie);
COMMIT;

SELECT
    z.id_zamowienie,
    z.status_zamowienia,
    p.status_platnosci,
    p.kwota_platnosci,
    czy_zamowienie_oplacone(z.id_zamowienie) AS oplacone
FROM zamowienie z
JOIN platnosci p
    ON z.id_zamowienie = p.id_zamowienie
WHERE z.id_zamowienie = 15;


-- Demonstracja wycofania zmian w transakcji
BEGIN;
UPDATE produkt
SET cena = cena * 1.10
WHERE id_produkt = 1;
-- Sprawdzenie ceny po zmianie
SELECT id_produkt, nazwa, cena
FROM produkt
WHERE id_produkt = 1;
ROLLBACK;
-- Sprawdzenie ceny po wycofaniu transakcji
SELECT id_produkt, nazwa, cena
FROM produkt
WHERE id_produkt = 1;
