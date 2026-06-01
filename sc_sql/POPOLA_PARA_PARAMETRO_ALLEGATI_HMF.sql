   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "ALLEGATI ARTICOLI PER ORDINI" IN PARA : 'HMF'
**********************************************************************************************
*/

DELETE PARA WHERE SUBSTRING(CODICE,1,3) = 'HMF'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('HMFHMF','SPESE HMF FISSE PER TRASPORTO','COSTO HMF  TRASPORTO FISSO:50')

