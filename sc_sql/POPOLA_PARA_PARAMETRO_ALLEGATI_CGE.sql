   
/* 
********************************************************************************************************
INSERIMENTO PARAMETRO "ALLEGATI ALLA CONTABILITA' GENERALE: FATTURAZIONE ELETTRONICA" IN PARA : 'ALLCGE'
********************************************************************************************************
*/


DELETE PARA WHERE CODICE = 'FSDFEF'
DELETE PARA WHERE CODICE = 'ALLCGE'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('ALLCGE','Percorso salvataggio documenti allegati CGE','\DOC_AQUARIUS\FATTURE_ELETTRONICHE_FORNITORI')
