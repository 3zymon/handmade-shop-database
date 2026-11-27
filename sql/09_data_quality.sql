-- niezgodnosc wartosci zamowienia z suma jego pozycji
SELECT
    id_zamowienie,
    cena_zamowienia,
    wartosc_zamowienia(id_zamowienie) AS suma_pozycji
FROM zamowienie
WHERE cena_zamowienia <> wartosc_zamowienia(id_zamowienie);


-- zamowienia bez przypisanych produktow
SELECT id_zamowienie, status_zamowienia
FROM zamowienie z
WHERE NOT EXISTS (
    SELECT 1
    FROM zamowiony_produkt zp
    WHERE zp.id_zamowienie = z.id_zamowienie
);


-- nadplaty oraz nieoplacone wyslane i dostarczone zamowienia
SELECT
    z.id_zamowienie,
    z.status_zamowienia,
    z.cena_zamowienia,
    COALESCE(SUM(p.kwota_platnosci), 0) AS suma_platnosci
FROM zamowienie z
LEFT JOIN platnosci p
    ON z.id_zamowienie = p.id_zamowienie
    AND p.status_platnosci = 'Zrealizowana'
GROUP BY z.id_zamowienie, z.status_zamowienia, z.cena_zamowienia
HAVING COALESCE(SUM(p.kwota_platnosci), 0) > z.cena_zamowienia
    OR (
        z.status_zamowienia IN ('Wysłane', 'Dostarczone')
        AND COALESCE(SUM(p.kwota_platnosci), 0) < z.cena_zamowienia
    );


-- niezgodnosc statusow zamowien z datami realizacji
SELECT
    id_zamowienie,
    status_zamowienia,
    data_spakowania,
    data_wyslania
FROM zamowienie
WHERE
    (status_zamowienia IN ('Nowe', 'W realizacji')
        AND (data_spakowania IS NOT NULL OR data_wyslania IS NOT NULL))
    OR
    (status_zamowienia = 'Spakowane'
        AND (data_spakowania IS NULL OR data_wyslania IS NOT NULL))
    OR
    (status_zamowienia IN ('Wysłane', 'Dostarczone')
        AND (data_spakowania IS NULL OR data_wyslania IS NULL));


-- aktywne produkty bez przypisanych materialow
SELECT id_produkt, nazwa
FROM produkt p
WHERE aktywny = TRUE
    AND NOT EXISTS (
        SELECT 1
        FROM material_produktu mp
        WHERE mp.id_produkt = p.id_produkt
    );
