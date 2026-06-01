   
/* 
**********************************************************************************************
POPOLAMENTO PARAMETRO TIPO PRODOTTO "GRUPPO" IN PARA
**********************************************************************************************
*/

DELETE PARA WHERE CODICE = 'MATGRU'
INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE) values ('MATGRU','GRUPPO','0 UM_ACQUISTO:NR;UM_MAGAZZINO:NR;TIPO_ARTICOLO:A;','LIBERA = ''0''   ==>  GESTIONE NORMALE
LIBERA = ''1''   ==>  GESTIONE BOBINE/ROTOLI
LIBERA = ''2''   ==>  GESTIONE ADESIVI
LIBERA = ''6''   ==>  GESTIONE PANNELLI TRUCIOLARI
')

SELECT * FROM PARA WHERE CODICE LIKE 'MAT%' ORDER BY CODICE
