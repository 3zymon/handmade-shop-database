-- Kontrola możliwości wykonania aktywnych produktów na podstawie dostępności materiałów w magazynie
DO $$
DECLARE
    prod RECORD;
    cursor_produkty CURSOR FOR
        SELECT id_produkt, nazwa
        FROM produkt
        WHERE aktywny = TRUE
        ORDER BY id_produkt;
BEGIN
    OPEN cursor_produkty;
    LOOP
        FETCH NEXT FROM cursor_produkty INTO prod;
        EXIT WHEN NOT FOUND;
        IF czy_produkt_mozna_wykonac(prod.id_produkt, 1) THEN
            RAISE NOTICE 'Produkt: % - produkcja możliwa', prod.nazwa;
        ELSE
            RAISE NOTICE 'Produkt: % - produkcja niemożliwa', prod.nazwa;
        END IF;
    END LOOP;
    CLOSE cursor_produkty;
END;
$$;
