/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "TIPOLOGIA ORDINE"
**********************************************************************************************
*/

DELETE FROM PARA WHERE CODICE = 'TPOOFA'
DELETE FROM PARA WHERE CODICE = 'TPOOFN'
INSERT INTO PARA (CODICE,DESCRI,LIBERA,CODPGO) values ('TPOOFA','ORDINE ATTIVO','.OF.OE.','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,CODPGO) values ('TPOOFN','ORDINE ANNULLATO','.OF.OE.','ANNULLATO')
