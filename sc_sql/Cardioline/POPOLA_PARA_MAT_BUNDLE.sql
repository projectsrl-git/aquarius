   
/* 
**********************************************************************************************
POPOLAMENTO PARAMETRO TIPO PRODOTTO "BUNDLE PER E-COMMERCE" IN PARA
**********************************************************************************************
*/

DELETE PARA WHERE CODICE = 'MATBUN'
INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE) values ('MATBUN','BUNDLE PER E-COMMERCE','0 UM_ACQUISTO:NR;UM_MAGAZZINO:NR;TIPO_ARTICOLO:A;','LIBERA = ''0''   ==>  GESTIONE NORMALE
LIBERA = ''1''   ==>  GESTIONE BOBINE/ROTOLI
LIBERA = ''2''   ==>  GESTIONE ADESIVI
LIBERA = ''6''   ==>  GESTIONE PANNELLI TRUCIOLARI
')

SELECT * FROM PARA WHERE CODICE LIKE 'MAT%' ORDER BY CODICE
