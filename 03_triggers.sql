-- Automatyczna aktualizacja wartości zamówienia
-- po dodaniu, zmianie lub usunięciu jego pozycji
CREATE OR REPLACE FUNCTION aktualizuj_wartosc_zamowienia()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        UPDATE zamowienie
        SET cena_zamowienia = wartosc_zamowienia(OLD.id_zamowienie)
        WHERE id_zamowienie = OLD.id_zamowienie;
        RETURN OLD;
    END IF;

    UPDATE zamowienie
    SET cena_zamowienia = wartosc_zamowienia(NEW.id_zamowienie)
    WHERE id_zamowienie = NEW.id_zamowienie;

    IF TG_OP = 'UPDATE' THEN
        IF OLD.id_zamowienie <> NEW.id_zamowienie THEN
            UPDATE zamowienie
            SET cena_zamowienia = wartosc_zamowienia(OLD.id_zamowienie)
            WHERE id_zamowienie = OLD.id_zamowienie;
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_aktualizuj_wartosc_zamowienia
AFTER INSERT OR UPDATE OR DELETE ON zamowiony_produkt
FOR EACH ROW
EXECUTE FUNCTION aktualizuj_wartosc_zamowienia();


