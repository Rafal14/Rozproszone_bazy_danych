--utworzenie sekwencji i wyzwalaczy dla autoinkrementacji kluczy podstawowych

--utworzenie sekwencji dla każdej z tabel

--utworzenie sekwencji dla inkrementacji klucza podstawowego
CREATE SEQUENCE klienci_seq MAXVALUE 999999;

--utworzenie sekwencji dla inkrementacji klucza podstawowego
CREATE SEQUENCE  pracownicy_seq MAXVALUE 999999;

--utworzenie sekwencji dla inkremenctaji klucz podstawowego
CREATE SEQUENCE sprzedaz_seq MAXVALUE 999999;

--utworzenie sekwencji dla inkrementacji klucza podstawowego
CREATE SEQUENCE zdarzenia_seq MAXVALUE 999999;
--utworzenie wyzwalaczy dla autoinkrementacji
--utworzenie triggera dla autoinkremencji klucza podstawowego
CREATE OR REPLACE TRIGGER klienci_trg 
BEFORE INSERT ON klienci
FOR EACH ROW
DECLARE
maks_host NUMBER;
maks_vm   NUMBER;
BEGIN
    IF :new.id_klient IS NULL THEN
      SELECT MAX(id_klient) INTO maks_vm from klienci@VM_LINK;
      SELECT MAX(id_klient) INTO maks_host from klienci;
  
      IF maks_vm IS NOT NULL THEN
        IF maks_host < maks_vm THEN
          :new.id_klient := maks_vm+1;
        END IF;
  
        IF maks_host > maks_vm THEN
          :new.id_klient := maks_host+1;
        END IF;
  
      END IF;
      
      IF maks_vm IS NULL THEN
        :new.id_klient := klienci_seq.NEXTVAL;
      END IF;
      
    END IF;
END;
/

--utworzenie triggera dla autoinkrementacji klucza podstawowego
CREATE OR REPLACE TRIGGER pracownicy_trg 
BEFORE INSERT ON pracownicy
FOR EACH ROW
DECLARE
maks_host NUMBER;
maks_vm   NUMBER;
zwieksz   NUMBER;
BEGIN
  IF :new.id_prac IS NULL THEN
    SELECT MAX(id_prac) INTO maks_vm   from pracownicy@VM_LINK;
    SELECT MAX(id_prac) INTO maks_host from pracownicy;
    
    IF maks_host IS NOT NULL THEN
      IF maks_host < maks_vm THEN
        :new.id_prac := maks_vm+1;
      END IF;
  
      IF maks_host > maks_vm THEN
        :new.id_prac := maks_host+1;
      END IF;
    END IF;
  
    IF maks_vm IS NULL THEN
      :new.id_prac := pracownicy_seq.NEXTVAL;
    END IF;
  
  END IF;
END;
/

--utworzenie triggera dla autoinkremencji klucza podstawowego
CREATE OR REPLACE TRIGGER sprzedaz_trg 
BEFORE INSERT ON sprzedaz
FOR EACH ROW
DECLARE
maks_host NUMBER;
maks_vm   NUMBER;
BEGIN
    IF :new.id_sprzedaz IS NULL THEN
      SELECT MAX(id_sprzedaz) INTO maks_vm from sprzedaz@VM_LINK;
      SELECT MAX(id_sprzedaz) INTO maks_host from sprzedaz;
  
      IF maks_vm IS NOT NULL THEN
        IF maks_host < maks_vm THEN
          :new.id_sprzedaz := maks_vm+1;
        END IF;
  
        IF maks_host > maks_vm THEN
          :new.id_sprzedaz := maks_host+1;
        END IF;
  
      END IF;
      
      IF maks_vm IS NULL THEN
        :new.id_sprzedaz := sprzedaz_seq.NEXTVAL;
      END IF;
      
    END IF;
END;
/

--utworzenie triggera dla autoinkrementacji klucza podstawowego
CREATE OR REPLACE TRIGGER zdarzenia_trg 
BEFORE INSERT ON zdarzenia
FOR EACH ROW
DECLARE
maks_host NUMBER;
maks_vm   NUMBER;
BEGIN
    IF :new.id_zdarzenia IS NULL THEN
      SELECT MAX(id_zdarzenia) INTO maks_vm from zdarzenia@VM_LINK;
      SELECT MAX(id_zdarzenia) INTO maks_host from zdarzenia;
  
      IF maks_vm IS NOT NULL THEN
        IF maks_host < maks_vm THEN
          :new.id_zdarzenia := maks_vm+1;
        END IF;
  
        IF maks_host > maks_vm THEN
          :new.id_zdarzenia := maks_host+1;
        END IF;
  
      END IF;
      
      IF maks_vm IS NULL THEN
        :new.id_zdarzenia := zdarzenia_seq.NEXTVAL;
      END IF;
      
    END IF;
END;
/