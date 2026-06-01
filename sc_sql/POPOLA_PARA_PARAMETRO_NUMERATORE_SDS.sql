   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "NUMERATORE SCHEDE DI SICUREZZA" IN PARA : 'NUMSDS'
**********************************************************************************************
*/


DELETE PARA WHERE CODICE = 'MDBI1001L'
DELETE PARA WHERE CODICE = 'MDBI1001S'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MDBI1001L','MDB BOMBOLE OSS. LARGE  ','     25 ')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('MDBI1001S','MDB BOMBOLE OSS. SMALL  ','     20 ')

SELECT * FROM PARA WHERE SUBSTRING(CODICE,1,3) = 'MDB'
