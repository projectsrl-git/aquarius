   
/* 
**********************************************************************************************
POPOLAMENTO PARAMETRO "FUNZIONI AZIENDALI" IN PARA DA SIGLA
**********************************************************************************************
*/

DELETE PARA WHERE CODICE LIKE 'FUN%'

INSERT INTO PARA (CODICE,DESCRI) SELECT 'FUN'+RTRIM(CODICE) AS CODICE, RTRIM(DESCRIZION) AS DESCRI FROM CARD_TABMANS

SELECT * FROM PARA WHERE CODICE LIKE 'FUN%'
