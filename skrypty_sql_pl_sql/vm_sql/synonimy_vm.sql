--Synonimy dla tabel na vm

--synonim dla migawki mv_ubezpieczenia
CREATE OR REPLACE PUBLIC SYNONYM ubezpieczenia FOR mv_ubezpieczenia;

--synonim dla klientów z Wroclawia (host)
CREATE OR REPLACE PUBLIC SYNONYM klienci_wroclaw FOR klienci@TO_HOST;

--synonim dla sprzedaży z Wroclawia (host)
CREATE OR REPLACE PUBLIC SYNONYM sprzedaz_wroclaw FOR sprzedaz@TO_HOST;

--synonim dla zdarzeń z Wroclawia (host)
CREATE OR REPLACE PUBLIC SYNONYM zdarzenia_wroclaw FOR zdarzenia@TO_HOST;