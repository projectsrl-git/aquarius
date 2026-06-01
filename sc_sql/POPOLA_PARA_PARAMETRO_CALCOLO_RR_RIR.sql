   
/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "PERIODI DI CALCOLO RITARDATA RESA RR" IN PARA : 'RIR'
**********************************************************************************************
*/

DELETE PARA WHERE SUBSTRING(CODICE,1,3) = 'RIR'

INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('RIR01','PERIODI (MM) PER CALCOLO RITARDATA RESA (RR)','P1: 2   P2: 4')
