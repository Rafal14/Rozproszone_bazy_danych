--perspektywa dla wszystkich klientów
CREATE OR REPLACE VIEW wszyscy_klienci 
AS SELECT * FROM klienci 
UNION
SELECT * FROM klienci_wroclaw;

--perspektywa dla wszystkich klientów indywidualych
CREATE OR REPLACE VIEW wszyscy_klienci_ind
AS SELECT id_klient, imie_kl, nazwisko_kl, pesel, email, tel_kom, ulica,
miasto, kod_pocz FROM klienci WHERE czy_biznesowy = 0
UNION
SELECT id_klient, imie_kl, nazwisko_kl, pesel, email, tel_kom, ulica,
miasto, kod_pocz FROM klienci_wroclaw WHERE czy_biznesowy = 0;


--perspektywa dla wszystkich klientów biznesowych
CREATE OR REPLACE VIEW wszyscy_klienci_biz
AS SELECT id_klient, nazwa, nip, email, tel_kom, ulica, miasto, kod_pocz 
FROM klienci WHERE czy_biznesowy = 1
UNION
SELECT id_klient, nazwa, nip, email, tel_kom, ulica, miasto, kod_pocz 
FROM klienci_wroclaw WHERE czy_biznesowy = 1;

--cała sprzedaż
CREATE OR REPLACE VIEW cala_sprzedaz 
AS SELECT * FROM sprzedaz 
UNION
SELECT * FROM sprzedaz_wroclaw;


--perspektywa dla całej sprzedaży ofert dla klientów indywiualych
CREATE OR REPLACE VIEW cala_sprzedaz_ind
AS
SELECT sp.id_sprzedaz,
       ubezp.nazwa_ubezp,
       ubezp.czy_obowiazkowe,
       ubezp.rodzaj_ubezp,
       sp.data_sprzed,
       sp.miasto,
       sp.data_rozp,
       sp.data_zakoncz,
       sp.wart_skladki,
       kli.imie_kl, 
       kli.nazwisko_kl, 
       kli.pesel,
       kli.email,
       kli.tel_kom
FROM cala_sprzedaz sp 
INNER JOIN wszyscy_klienci kli 
ON sp.id_klient = kli.id_klient 
INNER JOIN ubezpieczenia ubezp 
ON sp.id_produkt = ubezp.id_produkt
WHERE kli.czy_biznesowy = 0;

--perspektywa dla całej sprzedaży ofert dla klientów biznesowych
CREATE OR REPLACE VIEW cala_sprzedaz_biz
AS
SELECT sp.id_sprzedaz,
       ubezp.nazwa_ubezp,
       ubezp.czy_obowiazkowe,
       ubezp.rodzaj_ubezp,
       sp.data_sprzed,
       sp.miasto,
       sp.data_rozp,
       sp.data_zakoncz,
       sp.wart_skladki,
       kli.nazwa, 
       kli.nip,
       kli.email,
       kli.tel_kom
FROM cala_sprzedaz sp 
INNER JOIN wszyscy_klienci kli 
ON sp.id_klient = kli.id_klient 
INNER JOIN ubezpieczenia ubezp 
ON sp.id_produkt = ubezp.id_produkt
WHERE kli.czy_biznesowy = 1;


--perspektywa dla klientów z Wrocławia (regionu)
CREATE OR REPLACE VIEW klienciWroclaw
AS SELECT * FROM klienci_wroclaw ORDER BY id_klient ASC;
