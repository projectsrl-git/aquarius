/********************************************************************
 PARAMETRO TEMPO MEDIO DI PERMANENZA DEL TRASPORTATORE
********************************************************************/

DELETE FROM PARA WHERE CODICE LIKE 'TMT%'


INSERT INTO PARA (CODICE,DESCRI,LIBERA) VALUES ('TMTBFO','TEMPO MEDIO PER SCARICO MATERIALE CON PESATA','15')

SELECT * FROM PARA WHERE CODICE LIKE 'TMT%'

