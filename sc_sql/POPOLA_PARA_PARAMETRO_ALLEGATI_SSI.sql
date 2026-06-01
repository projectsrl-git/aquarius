   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "ALLEGATI SCHEDE DI SICUREZZA" IN PARA : 'FSDSSI'
**********************************************************************************************
*/

DELETE PARA WHERE CODICE = 'ALLSSI'
DELETE PARA WHERE CODICE = 'FSDSSI'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('FSDSSI','Percorso per allegati SCHEDE DI SICUREZZA','\DOC_AQUARIUS\SCHEDE-SICUREZZA')

SELECT * FROM PARA WHERE CODICE = 'FSDSSI'