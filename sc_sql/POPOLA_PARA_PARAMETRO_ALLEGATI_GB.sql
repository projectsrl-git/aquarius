
DELETE PARA WHERE CODICE LIKE 'GB1%'
DELETE PARA WHERE CODICE LIKE 'GB2%'
DELETE PARA WHERE CODICE LIKE 'GB3%'
DELETE PARA WHERE CODICE LIKE 'GB4%'
DELETE PARA WHERE CODICE LIKE 'GB5%'
DELETE PARA WHERE CODICE LIKE 'GB6%'

/* 
**********************************************************************************************
INSERIMENTO PARAMETRO IN PARA : 'GB1'  (DESTINAZIONE D'USO)
**********************************************************************************************
*/
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB1I','INDUSTRIALE','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB1M','MEDICALE','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB1P','GAS PURI','')

/* 
**********************************************************************************************
INSERIMENTO PARAMETRO IN PARA : 'GB2'  (MOLECOLA GAS)
**********************************************************************************************
*/
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB21001','OSSIGENO LIQUIDO','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB21901','ACETILENE','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB20021','ALPHAGAZ 1 ARGON','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB20022','ALPHAGAZ 2 ARGON','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB27001','IDROGENO','')


/* 
**********************************************************************************************
INSERIMENTO PARAMETRO  IN PARA : 'GB3'  (CAPACITA' BOMBOLA)
**********************************************************************************************
*/
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB3L40','LARGE 40 LITRI','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB3M14','MEDIUM 14 LITRI','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB3S05','SMALL 5 LITRI','')

/* 
**********************************************************************************************
INSERIMENTO PARAMETRO  IN PARA : 'GB4'  (CAPPELLOTTO/VALVOLA)
**********************************************************************************************
*/
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB4R2','CAPPELLOTTO/VALVOLA REGULAR','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB4ST','CAPPELLOTTO/VALVOLA SMART TOP','')

/* 
**********************************************************************************************
INSERIMENTO PARAMETRO  IN PARA : 'GB5'
**********************************************************************************************
*/
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB5A','BOMBOLA DI PROPRIETA AIR LIQUIDE','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB5L','BOMBOLA DI PROPRIETA LIQUIGAS','')

/* 
**********************************************************************************************
INSERIMENTO PARAMETRO  IN PARA : 'GB6'
**********************************************************************************************
*/
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB6001','BOMBOLA PIENA','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('GB6000','BOMBOLA VUOTA','')


SELECT * FROM PARA WHERE SUBSTRING(CODICE,1,3) IN ('GB1','GB2','GB3','GB4','GB5','GB6') ORDER BY CODICE
