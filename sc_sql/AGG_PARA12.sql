
/* 
**********************************************************************************
-- MODIFICA DESCRIZIONE PARAMETRI DI RICARICO AUTOMATICO MAGAZZINO
**********************************************************************************
*/

UPDATE PARA SET DESCRI = 'CARICO MAGAZZINO' WHERE CODICE = 'TOPM++'
UPDATE PARA SET DESCRI = 'SCARICO MAGAZZINO' WHERE CODICE = 'TOPM--'
