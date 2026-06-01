   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "TIPOLOGIA LISTINI" IN PARA
**********************************************************************************************
*/

DELETE PARA WHERE SUBSTRING(CODICE,1,3) = 'GLI'

INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE) values ('GLIVEN','LISTINO DI VENDITA','','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA,NOTE) values ('GLIRIC','LISTINO RICAMBI','','')
