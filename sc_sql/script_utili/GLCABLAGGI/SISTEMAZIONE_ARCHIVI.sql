

select * from prod_carichi
delete from prod_carichi

select * from u_alt_da
delete from u_alt_da

select * from ccosto
delete from ccosto

select * from u_mag_ar
delete from u_mag_ar

select * from part_cli2
delete from part_cli2

select * from part_for2
delete from part_for2

select * from log_rete
delete from log_rete

select * from u_ven_cl
delete from u_ven_cl

select * from U_ORF_DL
delete from U_ORF_DL

select * from u_lot_ri
delete from u_lot_ri

delete from U_PRD_PK
delete from U_PRD_D4
delete from U_PRD_D5
delete from U_PRD_D3
delete from U_PRD_D2
delete from U_PRD_D1
delete from ABICAB
delete from LOG_CONT
delete from TIMESHT
delete from saldi_cli
delete from saldi_for
delete from PIANOP_P2
delete from PIANOP_MO
delete from PIANOP_P2


-- cancellazione contabilità precedente al 2012

delete from log_user

delete from part_for --where par_anno <> '2012'
delete from part_cli --where par_anno <> '2012'

delete from MOV_CONT
delete from INDICE

DELETE FROM U_IVA_CL
DELETE FROM U_IVF_CL
DELETE FROM U_IVA_TO


--- cancellazione ricevute bancarie manuali

select * from u_rim_tt
select * from u_rim_dd

delete from u_rim_tt
delete from u_rim_dd

select * from u_ric_tt
select * from u_ric_dd

delete from u_ric_tt
delete from u_ric_dd

--- CORREZIONE CC BANCA

--SELECT * FROM U_BAN_AN WHERE BAN_CODBAN='1071' 

--UPDATE U_BAN_AN SET BAN_CODNCC='000001997X88',BAN_IBAN='IT82V0569611300000001997X88' WHERE BAN_CODBAN='1071' 


--- PULIZIA BANCHE PRESENTAZIONE EFFETTI
--SELECT * FROM PARA WHERE CODICE LIKE 'NUMDIR%'

--DELETE FROM PARA WHERE CODICE LIKE 'NUMDIR%'



--- PULIZIA CONTI CORRENTI
--SELECT * FROM U_CCO_TT
--SELECT * FROM U_CCO_DD

--DELETE FROM U_CCO_TT
--DELETE FROM U_CCO_DD

--SELECT * FROM U_BAN_AN WHERE BAN_CODBAN='471' 



----0569611300

/*
sp_addlinkedserver [SRV-GL]
INSERT INTO U_CCO_TT SELECT * FROM [SRV-GL].GLCABLAGGI_TEST.DBO.U_CCO_TT
INSERT INTO U_CCO_DD SELECT * FROM [SRV-GL].GLCABLAGGI_TEST.DBO.U_CCO_DD
*/

DELETE FROM PRODUZIONE

DELETE FROM PROD_ORDINI

DELETE FROM PROD_AVANZA


DELETE FROM PARA WHERE CODICE LIKE 'MAG%' AND CODICE <>'MAGSEDE'

--DELETE FROM U_TOP_MO 

--SELECT ORS_CODCLI FROM U_ORD_DD


UPDATE U_ART_PR SET art_tipart = 'P' WHERE ART_CODPRI IN(SELECT DIT_GRUPPO FROM U_DIS_TT)

--DELETE FROM PARA WHERE CODICE LIKE 'PRD%' 


/******* CODICE ARTICOLO CLIENTE *******/
UPDATE U_ORD_DD
SET ORD_CDAPRD = COALESCE((SELECT SUBSTRING(ART_DES_I,1,16) FROM U_ART_PR WHERE ART_CODPRI=ORD_CODART),'') 


/*** SISTEMA NUMERI DOCUMENTO ***/
UPDATE PARA SET LIBERA='6000000000' WHERE  CODICE ='NUMORD'
UPDATE PARA SET LIBERA='6000000000' WHERE  CODICE ='NUMBOL'
UPDATE PARA SET LIBERA='6000000000' WHERE  CODICE ='NUMFAT'

/** CODICI MAGAZZINO ***/
UPDATE U_ART_PR SET ART_MAGA='SEDE'

UPDATE U_ORD_DD SET ORD_MAGA='SEDE'
UPDATE U_ORD_DD SET ORS_MAGS='SEDE'
UPDATE U_ORD_TT SET ORD_MAGS='SEDE'







-- Da lanciare selezionando il DB "glcablaggi"
backup log glcablaggi with truncate_only
dbcc shrinkfile (glcablaggi_Log,0)




/* ARTICOLI CON DESCRIZIONE INGLESE PER ARTICOLO CLIENTE*/

SELECT * FROM (
SELECT ORD.ID_UNIQUE,DAGGANCIO,ORS_NUMORD,ORS_DATORD,ORD_CODART,ORD_CDAPRD,ART_DES_I
FROM U_ORD_DD AS ORD 
LEFT OUTER JOIN U_ART_PR AS ART 
ON ORD_CODART=ART_CODPRI ) AS T1
WHERE ORD_CDAPRD<>ART_DES_I
ORDER BY DAGGANCIO DESC

UPDATE U_ORD_DD
SET ORD_CDAPRD = (SELECT SUBSTRING(ART_DES_I,1,16) FROM U_ART_PR WHERE ART_CODPRI=ORD_CODART)
WHERE ID_UNIQUE IN (
SELECT ID_UNIQUE FROM (
SELECT ORD.ID_UNIQUE,DAGGANCIO,ORS_NUMORD,ORS_DATORD,ORD_CODART,ORD_CDAPRD,ART_DES_I
FROM U_ORD_DD AS ORD 
LEFT OUTER JOIN U_ART_PR AS ART 
ON ORD_CODART=ART_CODPRI ) AS T1
WHERE ORD_CDAPRD<>ART_DES_I )









/** SIATEMAZIONE COSTI DISTINTE BASI*/


UPDATE U_DIS_DD
SET DIS_COSMAT=DIS_COSMAT+DIS_COSTO 
WHERE DIS_COSMAT=0

SELECT DIS_COSTO,DIS_COSMAT FROM U_DIS_DD WHERE DIS_COSMAT<>0


SELECT * FROM U_DIS_DD WHERE DIS_CODART='FFASC5000' AND DIS_GRUPPO='CSV135561'

/** CONTROLLO ORDINI DA SISTEMARE **/

SELECT DISTINCT ORS_NUMORD, ORS_DATORD,ORS_CODCLI,ORS_RAGSOC FROM U_ORD_DD WHERE ORD_LEGSYS IN (SELECT  ORD_LEGSYS FROM U_BOL_DD WHERE DAGGANCIO >'5000005125')
ORDER BY ORS_DATORD,ORS_NUMORD

