-- Obliczanie łącznej wartości zamówienia
CREATE OR REPLACE FUNCTION wartosc_zamowienia(p_id_zamowienie BIGINT)
RETURNS NUMERIC
LANGUAGE SQL
STABLE
AS $$
    SELECT COALESCE(SUM(cena_zakupu * ilosc_produktu), 0)
    FROM zamowiony_produkt
    WHERE id_zamowienie = p_id_zamowienie;
$$;

-- Obliczanie łącznej liczby sztuk produktów w zamówieniu
CREATE OR REPLACE FUNCTION liczba_produktow_zamowieniu(p_id_zamowienie BIGINT)
RETURNS BIGINT
LANGUAGE SQL
STABLE
AS $$
    SELECT COALESCE(SUM(ilosc_produktu), 0)
    FROM zamowiony_produkt
    WHERE id_zamowienie = p_id_zamowienie;
$$;

-- Sprawdzanie, czy zamówienie zostało w pełni opłacone
CREATE OR REPLACE FUNCTION czy_zamowienie_oplacone(p_id_zamowienie BIGINT)
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM zamowienie z
        WHERE z.id_zamowienie = p_id_zamowienie
          AND z.cena_zamowienia <= (
              SELECT COALESCE(SUM(p.kwota_platnosci), 0)
              FROM platnosci p
              WHERE p.id_zamowienie = z.id_zamowienie
                AND p.status_platnosci = 'Zrealizowana'
          )
    );
$$;

-- Sprawdzanie dostępności wymaganej ilości materiału
CREATE OR REPLACE FUNCTION czy_material_dostepny(
    p_id_material BIGINT,
    p_ilosc NUMERIC
)
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM material
        WHERE id_material = p_id_material
          AND p_ilosc > 0
          AND ilosc_magazynie >= p_ilosc
    );
$$;


-- Sprawdzanie możliwości wykonania określonej liczby produktów
-- na podstawie dostępności wszystkich wymaganych materiałów
CREATE OR REPLACE FUNCTION czy_produkt_mozna_wykonac(
    p_id_produkt BIGINT,
    p_ilosc INT
)
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM produkt
        WHERE id_produkt = p_id_produkt
          AND aktywny = TRUE
          AND p_ilosc > 0
    )
    AND EXISTS (
        SELECT 1
        FROM material_produktu
        WHERE id_produkt = p_id_produkt
    )
    AND NOT EXISTS (
        SELECT 1
        FROM material_produktu mp
        JOIN material m
            ON mp.id_material = m.id_material
        WHERE mp.id_produkt = p_id_produkt
          AND m.ilosc_magazynie < mp.ilosc * p_ilosc
    );
$$;
