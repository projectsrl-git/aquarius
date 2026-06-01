   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "ALLEGATI ARTICOLI PER ORDINI" IN PARA : 'FTR'
**********************************************************************************************
*/

DELETE PARA WHERE SUBSTRING(CODICE,1,3) = 'FTR'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('FTRBF','TRASPORTO BOMBOLE FREON','COSTO TRASPORTO FISSO:40')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('FTRBO','TRASPORTO BOMBOLE OSSIGENO','COSTO TRASPORTO FISSO:30')
