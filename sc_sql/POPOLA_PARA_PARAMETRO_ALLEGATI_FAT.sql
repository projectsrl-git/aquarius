   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "DOCUMENTI DA ALLEGARE" IN PARA : 'ALLFAT'
**********************************************************************************************
*/

DELETE PARA WHERE CODICE = 'ALLFAT'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('ALLFAT','Percorso salvataggio documenti allegati FAT','\DOC_AQUARIUS\ALLEGATI_FATTURE')
