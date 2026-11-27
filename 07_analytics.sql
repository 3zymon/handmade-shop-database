-- Analiza miesiecznej dynamiki sprzedazy (MoM Growth)
WITH sprzedaz_mom AS (
    SELECT
        miesiac,
        przychod,
        LAG(przychod) OVER (ORDER BY miesiac) AS przychod_poprzedni
    FROM widok_sprzedaz_miesieczna
)
SELECT
    miesiac,
    przychod,
    przychod_poprzedni,
    ROUND(
        100.0 * (przychod - przychod_poprzedni)
        / NULLIF(przychod_poprzedni, 0),
        2
    ) AS dynamika_mom_pct
FROM sprzedaz_mom
ORDER BY miesiac;


-- Analiza skumulowanej wartości sprzedaży (Cumulative Revenue)
SELECT
    miesiac,
    przychod,
    SUM(przychod) OVER (
        ORDER BY miesiac
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS przychod_skumulowany
FROM widok_sprzedaz_miesieczna
ORDER BY miesiac;


-- Ranking produktow wedlug przychodu w poszczegolnych kategoriach
SELECT
    kategoria,
    nazwa,
    liczba_sprzedanych_sztuk,
    przychod,
    DENSE_RANK() OVER (
        PARTITION BY kategoria
        ORDER BY przychod DESC
    ) AS ranking_w_kategorii
FROM widok_sprzedaz_produktow
ORDER BY kategoria, ranking_w_kategorii;


-- Segmentacja klientow wedlug wartosci zakupow (Customer Segmentation)
SELECT
    id_klient,
    imie,
    nazwisko,
    liczba_zamowien,
    wartosc_zakupow,
    CASE
        WHEN wartosc_zakupow >= 500 THEN 'Premium'
        WHEN wartosc_zakupow >= 200 THEN 'Standard'
        WHEN wartosc_zakupow > 0 THEN 'Basic'
        ELSE 'Brak zakupow'
    END AS segment_klienta
FROM widok_aktywnosc_klientow
ORDER BY wartosc_zakupow DESC;


-- Analiza wskaznika powracajacych klientow (Repeat Purchase Rate)
SELECT
    COUNT(*) AS liczba_klientow,
    COUNT(CASE WHEN liczba_zamowien > 1 THEN 1 END)
        AS klienci_powracajacy,
    ROUND(
        100.0 * COUNT(CASE WHEN liczba_zamowien > 1 THEN 1 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_purchase_rate_pct
FROM widok_aktywnosc_klientow
WHERE liczba_zamowien > 0;


-- Analiza sredniego czasu realizacji zamowien (Order Fulfillment Time)
SELECT
    COUNT(*) AS liczba_zamowien,
    ROUND(AVG(EXTRACT(EPOCH FROM
        (data_spakowania - data_zamowienia)) / 3600), 2)
        AS sredni_czas_pakowania_h,
    ROUND(AVG(EXTRACT(EPOCH FROM
        (data_wyslania - data_spakowania)) / 3600), 2)
        AS sredni_czas_do_wysylki_h,
    ROUND(AVG(EXTRACT(EPOCH FROM
        (data_wyslania - data_zamowienia)) / 3600), 2)
        AS sredni_czas_realizacji_h
FROM zamowienie
WHERE status_zamowienia IN ('Wysłane', 'Dostarczone')
    AND data_spakowania IS NOT NULL
    AND data_wyslania IS NOT NULL;


-- Analiza produktow najczesciej kupowanych razem (Market Basket Analysis)
SELECT
    p1.nazwa AS produkt_1,
    p2.nazwa AS produkt_2,
    COUNT(*) AS liczba_wspolnych_zamowien
FROM zamowiony_produkt zp1
JOIN zamowiony_produkt zp2
    ON zp1.id_zamowienie = zp2.id_zamowienie
    AND zp1.id_produkt < zp2.id_produkt
JOIN produkt p1
    ON zp1.id_produkt = p1.id_produkt
JOIN produkt p2
    ON zp2.id_produkt = p2.id_produkt
JOIN zamowienie z
    ON zp1.id_zamowienie = z.id_zamowienie
WHERE z.status_zamowienia <> 'Anulowane'
GROUP BY p1.id_produkt, p1.nazwa, p2.id_produkt, p2.nazwa
ORDER BY liczba_wspolnych_zamowien DESC;
