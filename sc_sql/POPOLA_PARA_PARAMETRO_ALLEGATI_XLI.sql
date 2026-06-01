   
/* 
********************************************************************************************************
INSERIMENTO PARAMETRO "ALLEGATI LIQUIDAZIONE IVA TRIMESTRALE IN FORMATO XML (LIPE): 'FSDXLI'
********************************************************************************************************
*/


DELETE PARA WHERE CODICE = 'FSDXLI'


INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('FSDXLI','PERCORSO SALVATAGGIO FILE XML (LIPE)','\IVA_TRIMESTRALE_XML_LIPE')
