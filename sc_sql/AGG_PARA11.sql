
/* 
**********************************************************************************
VALORIZZAZIONE DI DEFAULT PER IL CAMPO PARA.SOLOIVA ERRONEAMENTE NON INIZIALIZZATE
A STRINGA VUOTA ('') NELLO SCRIPT DI CREAZIONE CAMPO 'AGG_PARA09.SQL'
**********************************************************************************
*/

UPDATE PARA SET SOLOIVA = '' WHERE ISNULL(SOLOIVA,'') = ''
