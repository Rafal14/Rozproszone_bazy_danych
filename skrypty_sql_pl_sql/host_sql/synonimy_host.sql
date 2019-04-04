--Synonimy
--synonim dla migawki mv_ubezpieczenia
CREATE OR REPLACE PUBLIC SYNONYM ubezpieczenia FOR mv_ubezpieczenia;

--synonim dla klientów z Poznania (vm)
CREATE OR REPLACE PUBLIC SYNONYM klienci_poznan FOR klienci@VM_LINK;

--synonim dla sprzedaży z Poznania (vm)
CREATE OR REPLACE PUBLIC SYNONYM sprzedaz_poznan FOR sprzedaz@VM_LINK;

--synonim dla zdarzeń z Poznania
CREATE OR REPLACE PUBLIC SYNONYM zdarzenia_poznan FOR zdarzenia@VM_LINK;