--ustawienie statusu 'Wyslane' dla wszystkich zamówień wysłanych dzisiaj:
DO $$
DECLARE
zam RECORD;
cursor_zamowienie CURSOR FOR
SELECT id_zamowienie FROM zamowienie
WHERE data_wyslania = CURRENT_DATE;
BEGIN
OPEN cursor_zamowienie;
LOOP
FETCH NEXT FROM cursor_zamowienie INTO zam;
EXIT WHEN NOT FOUND;
UPDATE zamowienie
SET status_zamowienia = 'Wyslane'
WHERE id_zamowienie = zam.id_zamowienie;
END LOOP;
CLOSE cursor_zamowienie;
END $$;