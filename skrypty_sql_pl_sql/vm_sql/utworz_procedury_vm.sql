--utworzenie wyzwalaczy i procedur dla wstawiania danych do tabeli
-- i rozpraszania danych

--utworzenie triggera dla wstawiania danych do tabeli klienci
CREATE OR REPLACE TRIGGER dane_klienta_trg
AFTER INSERT ON klienci
FOR EACH ROW
DECLARE
wyjatek_biz      EXCEPTION;
wyjatek_imie     EXCEPTION;
wyjatek_nazwisko EXCEPTION;
wyjatek_nazwa    EXCEPTION;
 
BEGIN    
    IF :new.kod_pocz < 60000 THEN
    
    IF  :new.czy_biznesowy>1
    THEN raise wyjatek_biz;
    END IF;
    
    --obsluga kopiowania danych klientów indywidualnych
    IF :new.czy_biznesowy=0 THEN
    
    IF  :new.imie_kl IS NULL
    THEN raise wyjatek_imie;
    END IF;
    
    IF  :new.nazwisko_kl IS NULL
    THEN raise wyjatek_nazwisko;
    END IF;
    
    --wstawianie danych do tabeli klienci na hoście
    INSERT INTO klienci@TO_HOST(id_klient, czy_biznesowy, imie_kl, nazwisko_kl,
    pesel, email, tel_kom, ulica, miasto, kod_pocz) values (:new.id_klient, 
    :new.czy_biznesowy, :new.imie_kl, :new.nazwisko_kl, :new.pesel, :new.email,
    :new.tel_kom, :new.ulica, :new.miasto, :new.kod_pocz);

    END IF;
    
    IF :new.czy_biznesowy=1 THEN
    
    IF  :new.nazwa IS NULL
    THEN raise wyjatek_nazwa;
    END IF;
    
    INSERT INTO klienci@TO_HOST(id_klient, czy_biznesowy, nazwa, nip, email, 
    tel_kom, ulica, miasto, kod_pocz) values (:new.id_klient, 
    :new.czy_biznesowy, :new.nazwa, :new.nip, :new.email, :new.tel_kom, 
    :new.ulica, :new.miasto, :new.kod_pocz);
    
    END IF;

    DBMS_OUTPUT.PUT_LINE('Przeniesiono rekord');
    
    END IF;
    
    --obsluga wyjatku zwiazanego z nieprawidlowy, polem czy_biznesowy
    EXCEPTION
    WHEN wyjatek_biz THEN
    DBMS_OUTPUT.PUT_LINE('Blad. Nieprawidlowa wartosc pola czy_biznesowy');
    
    WHEN wyjatek_imie THEN
    DBMS_OUTPUT.PUT_LINE('Blad. Wartosc pola imie_kl nie moze byc pusta');
    
    WHEN wyjatek_nazwisko THEN
    DBMS_OUTPUT.PUT_LINE('Blad. Wartosc pola nazwisko_kl nie moze byc pusta');
    
    WHEN wyjatek_nazwa THEN
    DBMS_OUTPUT.PUT_LINE('Blad. Wartosc pola nazwa nie moze byc pusta');
    
END;
/

--utworzenie triggera dla wstawiania danych do tabeli sprzedaz
CREATE OR REPLACE TRIGGER dane_sprzedaz_trg
AFTER INSERT ON sprzedaz
FOR EACH ROW
DECLARE
BEGIN    
    IF :new.miasto = 'Wro' THEN
    INSERT INTO sprzedaz@TO_HOST(id_sprzedaz,id_produkt,id_klient,id_prac,
    data_sprzed, miasto, data_rozp, data_zakoncz, wart_skladki, uwagi)
    VALUES (:new.id_sprzedaz,:new.id_produkt,:new.id_klient,:new.id_prac,
    :new.data_sprzed, :new.miasto, :new.data_rozp, :new.data_zakoncz, 
    :new.wart_skladki, :new.uwagi);
    DBMS_OUTPUT.PUT_LINE('Przeniesiono rekord');
    END IF;
END;
/

--utworzenie triggera dla wstawiania danych do tabeli zdarzenia
CREATE OR REPLACE TRIGGER dane_zdarzenia_trg
AFTER INSERT ON zdarzenia
FOR EACH ROW
DECLARE

kod_pocztowy NUMBER(5);

BEGIN    
    SELECT kod_pocz INTO kod_pocztowy FROM klienci 
    WHERE id_klient = :new.id_klient;

    IF kod_pocztowy < 60000 THEN
    
    INSERT INTO zdarzenia@TO_HOST(id_zdarzenia, id_klient, typ_sprawcy, uwagi) 
    VALUES (:new.id_zdarzenia, :new.id_klient, :new.typ_sprawcy, :new.uwagi);
    
    DBMS_OUTPUT.PUT_LINE('Przeniesiono rekord');

    END IF;
END;
/


--procedury

/**
Procedura dodaje dane klienta do tabeli klienci.
W procedurze występuje obsluga przenoszenia danych klientów miedzy węzami.
**/
CREATE OR REPLACE PROCEDURE wstaw_dane_klienta
(czy_b IN NUMBER, imie IN VARCHAR2, nazwisko IN VARCHAR2, 
 nazwa IN VARCHAR2, nr_pesel IN NUMBER, nr_nip IN NUMBER, ad_email IN VARCHAR2, 
 telefon IN NUMBER, ulica IN VARCHAR2, miasto IN VARCHAR2, kod_poczt IN NUMBER)
 AS
 nr_klienta   NUMBER(6);
 kod_pocztowy NUMBER(5);
 CURSOR znajdz IS SELECT id_klient, kod_pocz FROM klienci where kod_pocz<60000;
 BEGIN
--wstaw dane klienta do tabeli klineci
INSERT INTO klienci(czy_biznesowy, imie_kl, nazwisko_kl, nazwa, pesel, nip, 
email, tel_kom, ulica, miasto, kod_pocz) VALUES (czy_b, imie, nazwisko, nazwa, 
nr_pesel, nr_nip, ad_email, telefon, ulica, miasto, kod_poczt);


--otworz kursor i znajdz nadmiarowe dane
OPEN znajdz;
FETCH znajdz INTO nr_klienta, kod_pocztowy;
WHILE znajdz%FOUND
LOOP
--usun zduplikowane dane
DELETE FROM klienci WHERE kod_pocz = kod_pocztowy;
DBMS_OUTPUT.PUT_LINE('Usunieto rekord dla klienta o nr' || nr_klienta);
FETCH znajdz INTO nr_klienta, kod_pocztowy;
END LOOP;
COMMIT;
END;
/

/**
Procedura dodaje dane o sprzedazy do tabeli klienci.

(2 ,1 ,1 ,to_date('2018-07-03', 'RRRR-MM-DD'),'Wro',to_date('2018-07-10', 'RRRR-MM-DD'),to_date('2019-07-09', 'RRRR-MM-DD'),500 ,'brak');

W procedurze występuje obsluga przenoszenia danych sprzedazy miedzy węzami.
**/
CREATE OR REPLACE PROCEDURE wstaw_dane_sprzedazy
(id_prod IN NUMBER, id_kli IN NUMBER, id_pr IN NUMBER,
 data_sp IN DATE, miasto IN VARCHAR2, data_rozp IN DATE,
 data_zakoncz IN DATE, wart_skladki IN NUMBER, uwagi IN VARCHAR2)
 AS
 nr_sprzedazy   NUMBER(6);
 miasto_sp      VARCHAR2(10);
 CURSOR znajdz IS SELECT id_sprzedaz, miasto FROM sprzedaz 
 WHERE miasto = 'Wro';
 BEGIN
--wstaw dane o sprzedazy
INSERT INTO sprzedaz(id_produkt, id_klient, id_prac, data_sprzed, miasto, 
data_rozp, data_zakoncz, wart_skladki, uwagi) VALUES (id_prod, id_kli, 
id_pr, data_sp, miasto, data_rozp, data_zakoncz, wart_skladki, uwagi);


--otworz kursor i znajdz nadmiarowe dane
OPEN znajdz;
FETCH znajdz INTO nr_sprzedazy, miasto_sp;
WHILE znajdz%FOUND
LOOP
--usun zduplikowane dane
DELETE FROM sprzedaz WHERE miasto = miasto_sp;
DBMS_OUTPUT.PUT_LINE('Usunieto rekord dla klienta o nr' ||  nr_sprzedazy);
FETCH znajdz INTO nr_sprzedazy, miasto_sp;
END LOOP;
COMMIT;
END;
/

/**
Procedura dodaje dane o zdarzeniu do tabeli zdarzenia.
W procedurze występuje obsluga przenoszenia danych o zdarzeniach miedzy węzami.
**/
CREATE OR REPLACE PROCEDURE wstaw_dane_zdarzenia
(id_zd IN NUMBER, id_kli IN NUMBER, typ IN NUMBER, uwagi IN VARCHAR2)
 AS

 kod_pocztowy   NUMBER(6);

 BEGIN
 
 SELECT kod_pocz INTO kod_pocztowy FROM klienci 
 WHERE id_klient = id_kli;

 --wstaw dane o zdarzeniu
 INSERT INTO zdarzenia(id_zdarzenia, id_klient, typ_sprawcy, uwagi) 
 VALUES (id_zd, id_kli, typ, uwagi);
 
 IF kod_pocztowy < 60000 THEN

  --usun zduplikowane dane
  DELETE FROM zdarzenia WHERE id_klient = id_kli;
  DBMS_OUTPUT.PUT_LINE('Usunieto rekord');
  
  END IF;
  
  COMMIT;
END;
/