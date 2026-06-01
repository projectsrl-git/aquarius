   
/* 
******************************************************************************************************************
INSERIMENTO PARAMETRO SOTTODIRECTORY PER CREAZIONE DOCUMENTI DI RESO DA CLIENTI E DA RISTAMPA DOCUMENTI : 'FSDRDC'
******************************************************************************************************************
*/


DELETE PARA WHERE CODICE = 'FSDRDC'


INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('FSDRDC','SOTTODIRECTORY PER CREAZIONE DOCUMENTI DI RESO DA CLIENTI E DA RISTAMPA DOCUMENTI ','RESI_DA_CLIENTI')
