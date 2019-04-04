--skrypt do tworzenia tabeli na hoście




--tabela klienci
CREATE TABLE klienci (
    id_klient       NUMBER(6) NOT NULL,
    czy_biznesowy   NUMBER(1),
    imie_kl         VARCHAR2(20),
    nazwisko_kl     VARCHAR2(25),
    nazwa           VARCHAR2(35),
    pesel           NUMBER(11),
    nip             NUMBER(10),
    email           VARCHAR2(30),
    tel_kom         NUMBER(9),
    ulica           VARCHAR2(30) NOT NULL,
    miasto          VARCHAR2(20) NOT NULL,
    kod_pocz        NUMBER(5) NOT NULL,
    
    --dodanie klucza podstawowego do tabeli klieci
	  CONSTRAINT  klienci_pk PRIMARY KEY (id_klient)
);

--utworzenie tabeli pracownicy
CREATE TABLE pracownicy (
    id_prac         NUMBER(6) NOT NULL,
    imie_prac       VARCHAR2(20) NOT NULL,
    nazwisko_prac   VARCHAR2(30) NOT NULL,
    haslo           VARCHAR2(6) NOT NULL,
    --dodanie klucza podstawowego do tabeli pracownicy
    CONSTRAINT  pracownicy_pk PRIMARY KEY (id_prac)
);

--utworzenie tabeli sprzedaz
CREATE TABLE sprzedaz (
    id_sprzedaz    NUMBER(6) NOT NULL,
    id_produkt     NUMBER(6) NOT NULL,
    id_klient      NUMBER(6) NOT NULL,
    id_prac        NUMBER(6) NOT NULL,
    data_sprzed    DATE,
	  miasto         VARCHAR2(10),
    data_rozp      DATE,
    data_zakoncz   DATE,
    wart_skladki   NUMBER(8),
    uwagi          VARCHAR2(50),
    
    --dodanie klucza podstawowego do tabeli sprzedaz
    CONSTRAINT sprzedaz_pk PRIMARY KEY (id_sprzedaz),
	
    --dodanie klucza obcego względem tabeli klieci
    CONSTRAINT sprzedaz_klienci_fk FOREIGN KEY (id_klient) 
    REFERENCES klienci (id_klient),
	
    --dodanie klucza obcego względem tabeli pracownicy
    CONSTRAINT sprzedaz_pracownicy_fk FOREIGN KEY ( id_prac )
    REFERENCES pracownicy ( id_prac )
    
    --dodanie klucza obcego względem tabeli ubezpieczenia
    --CONSTRAINT sprzedaz_ubezpieczenia_fk FOREIGN KEY ( id_produkt )
    --REFERENCES ubezpieczenia ( id_produkt )
);

--utworzenie tabeli zdarzenia
CREATE TABLE zdarzenia (
    id_zdarzenia   NUMBER(6) NOT NULL,
    id_klient      NUMBER(6) NOT NULL,
    typ_sprawcy    NUMBER(1),
    uwagi          VARCHAR2(50),
    
    --dodanie klucza podstawowego do tabeli zdarzenia
    CONSTRAINT zdarzenia_pk PRIMARY KEY (id_zdarzenia),
	
    --dodanie klucza obcego względem tabeli klienci
    CONSTRAINT zdarzenia_klienci_fk FOREIGN KEY ( id_klient )
    REFERENCES klienci ( id_klient )
);