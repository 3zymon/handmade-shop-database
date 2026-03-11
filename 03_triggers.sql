CREATE OR REPLACE FUNCTION ustaw_date_zamowienia( )
RETURNS trigger AS $$
BEGIN
IF (TG_OP = 'INSERT') THEN
RAISE NOTICE 'Tabela % % % dnia %',
TG_TABLE_NAME, TG_WHEN, TG_OP, timeofday();
NEW.data_zamowienia := CURRENT_DATE;
RETURN NEW;
ELSIF (TG_OP = 'UPDATE') THEN
RAISE NOTICE 'Tabela % % % dnia %',
TG_TABLE_NAME, TG_WHEN, TG_OP, timeofday();
RETURN NEW;
ELSIF (TG_OP = 'DELETE') THEN
RAISE NOTICE 'Tabela % % % dnia %',
TG_TABLE_NAME, TG_WHEN, TG_OP, timeofday();
RETURN OLD;
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ustaw_date_zamowienia
BEFORE INSERT OR UPDATE OR DELETE ON zamowienie
FOR EACH ROW EXECUTE FUNCTION ustaw_date_zamowienia();

