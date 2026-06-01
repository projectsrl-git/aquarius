   
/* 
********************************************************************************************************
INSERIMENTO PARAMETRO "PERCORSI INDUSTRY 4.0" IN PARA : 'FSDIND4**'
********************************************************************************************************
*/


DELETE PARA WHERE CODICE LIKE 'FSDI40%'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('FSDI40IN','Percorso file in input per implementazione programmi in macchinario Industry 4.0','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('FSDI40OU','Percorso file in output per implementazione programmi in macchinario Industry 4.0','')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('FSDI40LO','Percorso file di log da macchinario Industry 4.0','')

select * from para WHERE CODICE LIKE 'FSDI40%' ORDER BY CODICE