   
/* 
********************************************************************************************************
INSERIMENTO PARAMETRO "NUMERAZIONE PROGRESSIVA FILE XML LIQUIDAZIONE IVA TRIMESTRALE  (LIPE): 'NUMLIP'
********************************************************************************************************
*/


DELETE PARA WHERE CODICE = 'NUMLIP'


INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('NUMLIP01','NUMERAZIONE PROGRESSIVA FILE XML (LIPE)','0')
