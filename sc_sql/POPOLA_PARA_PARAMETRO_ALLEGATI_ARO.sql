   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "ALLEGATI ARTICOLI PER ORDINI" IN PARA : 'ALLARO'
**********************************************************************************************
*/

DELETE PARA WHERE CODICE = 'ALLARO'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('ALLARO','Percorso allegati articoli per ordini clienti','\DOC_AQUARIUS\ALLEGATI-ARTICOLI-PER-ORD-CLI')
