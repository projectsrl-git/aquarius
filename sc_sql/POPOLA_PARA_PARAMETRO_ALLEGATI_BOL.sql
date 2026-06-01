   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "DOCUMENTI DA ALLEGARE" IN PARA : 'ALLBOL'
**********************************************************************************************
*/

DELETE PARA WHERE CODICE = 'ALLBOL'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('ALLBOL','Percorso Allegati Documenti Di Trasporto','\DOCUMENTI\DOCUMENTI_DI_TRASPORTO')
