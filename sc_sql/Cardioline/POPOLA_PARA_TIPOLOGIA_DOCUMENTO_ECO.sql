/* 
**********************************************************************************************
INSERIMENTO PARAMETRO "TIPOLOGIA ORDINE"
**********************************************************************************************
*/

DELETE FROM PARA WHERE CODICE = 'TPOECC'
DELETE FROM PARA WHERE CODICE = 'TPOECN'
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('TPOECC','ORDINE E-COMMERCE CLIENTE CONVENZ.','.OC.VEN.FVC.FVE.FVI.FVS.NCC.NCE.NCI.NCS.')
INSERT INTO PARA (CODICE,DESCRI,LIBERA) values ('TPOECN','ORDINE E-COMMERCE CLIENTE NON CONVENZ.','.OC.VEN.FVC.FVE.FVI.FVS.NCC.NCE.NCI.NCS.')
