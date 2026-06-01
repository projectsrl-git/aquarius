   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "MOTIVAZIONE DOCUMENTO SCADUTO" IN PARA
**********************************************************************************************
*/

DELETE PARA WHERE CODICE LIKE 'MSC%'

INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE) values ('MSCPAG','ATTESA PAGAMENTO','','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE) values ('MSCSPED','ATTESA SPEDIZIONIERE','','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE) values ('MSCADV','ATTESA SBLOCCO ADV','','')

SELECT * FROM PARA WHERE CODICE LIKE 'MSC%'
