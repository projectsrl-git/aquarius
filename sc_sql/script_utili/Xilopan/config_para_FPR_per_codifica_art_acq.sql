/*********************************************************************************************************
 CONFIGURAZIONE PARAMETRO 'FAMIGLIA PRODOTTO' PER LEGAME CON UN DETERMINATO CODICE PARAMETRO DI DETTAGLIO
*********************************************************************************************************/

UPDATE PARA SET LIBERA = 'MPR' WHERE CODICE = 'FPR01'
UPDATE PARA SET LIBERA = 'TIP' WHERE CODICE = 'FPR02'

SELECT * FROM PARA WHERE CODICE = 'FPR01' OR CODICE = 'FPR02'
