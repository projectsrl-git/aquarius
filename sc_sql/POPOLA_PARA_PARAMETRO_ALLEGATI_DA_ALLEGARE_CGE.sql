   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "DOCUMENTI DA ALLEGARE" IN PARA : 'ALLCGE'
**********************************************************************************************
*/

DELETE PARA WHERE SUBSTRING(CODICE,1,6) = 'ALLCGE'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('ALLCGE','Percorso salvataggio documenti allegati CGE','\FILE_PDF_DA_SPEDIRE\DOCUMENTI_CONTABILI')
