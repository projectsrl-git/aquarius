



/****** Oggetto:  View [dbo].[V_INTERVENTO_SELEZIONATO]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_INTERVENTO_SELEZIONATO]'))
DROP VIEW [dbo].[V_INTERVENTO_SELEZIONATO]
GO

CREATE VIEW [dbo].[V_INTERVENTO_SELEZIONATO]
AS
	SELECT coalesce(cast(ROUND(ORD_VALORE , 2) as numeric(10,2) ),0) AS ORD_VALORE_MONEY, * FROM V_INTERVENTI
GO




/****** Oggetto:  View [dbo].[V_RICAMBI_TOP]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_RICAMBI_TOP]'))
DROP VIEW [dbo].[V_RICAMBI_TOP]
GO

CREATE VIEW [dbo].[V_RICAMBI_TOP]
AS
	select coalesce(cast(ROUND(ORD_VALORE_MONEY_TEMP+(ORD_VALORE_MONEY_TEMP*perc_iva/100) , 2) as numeric(10,2) ),0) as ORD_VALORE_MONEY,* from (
	SELECT coalesce(rtrim(substring(libera,1,3)),0) as perc_iva,
     --coalesce(cast(ROUND(ORD_VALORE , 2) as numeric(10,2) ),0) AS ORD_VALORE_MONEY, 
	 coalesce(cast(ROUND(ORD_VALORE , 2) as numeric(10,2) ),0) AS ORD_VALORE_MONEY_TEMP, 
	 VENDITE_DD.* FROM VENDITE_DD 
	left outer join para on 'IVA'+ord_iva = codice
	where ord_codart<>''
	) as t1
GO







/****** Oggetto:  View [dbo].[V_RICAMBI]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_RICAMBI]'))
DROP VIEW [dbo].[V_RICAMBI]
GO

CREATE VIEW [dbo].[V_RICAMBI]
AS
	SELECT coalesce(cast(ROUND(art_przven , 2) as numeric(10,2) ),0) AS ART_PRZVEN_MONEY, * FROM U_ART_pr
GO









/****** Oggetto:  View [dbo].[V_DETTAGLI_RICAMBI]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_DETTAGLI_RICAMBI]'))
DROP VIEW [dbo].[V_DETTAGLI_RICAMBI]
GO

CREATE VIEW [dbo].[V_DETTAGLI_RICAMBI]
AS
SELECT distinct '' AS COGNOME,'' AS NOME,dd.DAGGANCIO,COALESCE(pa2.descri,'') as descri_attivita, ORD_VALORE,'' AS NOME_TECNICO,
	coalesce(cast(ROUND(ORD_VALORE , 2) as numeric(10,2) ),0) AS ORD_VALORE_MONEY, 
	dd.ORD_DETT_INT,dd.ORD_DESART,dd.ORD_CODSYS,
	case when ORD_ORAINIINT='00:00:00' then '' else substring(ORD_ORAINIINT,1,5) end as ORD_ORAINIINT_REAL,
	case when ORD_ORAFININT='00:00:00' then '' else substring(ORD_ORAFININT,1,5) end as ORD_ORAFININT_REAL,
	substring(dt.ORD_ORAINIPRO,1,5) as ORD_ORAINIPRO_REAL,
	substring(dt.ORD_ORAFINPRO,1,5) as ORD_ORAFINPRO_REAL
	   FROM VENDITE_DD as dd
	left join vendite_dt as dt on dd.ORD_CODSYS=dt.ORD_CODSYS
	left outer join para on 'IVA'+ord_iva = codice
	left outer join para as pa2 on 'ATT'+ORD_ATTIVITA = pa2.codice 
	left outer join para as pa3 on 'TEI'+ORD_TECNICO  = ORD_TECNICO
	where ord_codart<>'' and ord_dett_int=0
union
SELECT distinct utenti.COGNOME,utenti.NOME,dT.DAGGANCIO,COALESCE(pa2.descri,'') as descri_attivita,ORD_VALORE,PA3.DESCRI AS NOME_TECNICO,
	coalesce(cast(ROUND(ORD_VALORE , 2) as numeric(10,2) ),0) AS ORD_VALORE_MONEY, 
	dd.ORD_DETT_INT,dd.ORD_DESART,dd.ORD_CODSYS,
	case when ORD_ORAINIINT='00:00:00' then '' else substring(ORD_ORAINIINT,1,5) end as ORD_ORAINIINT_REAL,
	case when ORD_ORAFININT='00:00:00' then '' else substring(ORD_ORAFININT,1,5) end as ORD_ORAFININT_REAL,
	substring(dt.ORD_ORAINIPRO,1,5) as ORD_ORAINIPRO_REAL,
	substring(dt.ORD_ORAFINPRO,1,5) as ORD_ORAFINPRO_REAL
	   FROM VENDITE_Dt AS DT
	   left join vendite_dD AS DD on dT.ORD_CODSYS=dD.ORD_CODSYS
	left outer join para on 'IVA'+ord_iva = codice
	left outer join para as pa2 on 'ATT'+ORD_ATTIVITA = pa2.codice 
	left outer join para as pa3 on 'TEI'+ORD_TECNICO  = PA3.codice
	left outer join utenti on codice_utente='TEI'+ORD_TECNICO
	where ord_codart<>'' and ord_dett_int=1
GO




/****** Oggetto:  View [dbo].[V_DETTAGLI_IMPIANTO]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_DETTAGLI_IMPIANTO]'))
DROP VIEW [dbo].[V_DETTAGLI_IMPIANTO]
GO

CREATE VIEW [dbo].[V_DETTAGLI_IMPIANTO]
AS


SELECT 
	ICO.ID_PMKEY,
	TAGGANCIO,
	UPPER(DESCRI) AS TIPO_COMPONENTE,
	ITT.CCODSCHE,
	cdittacal,
	cmodcal,
	cmatcal,
	cdittacal+' '+cmodcal+'<br/>Matricola: '+cmatcal as dati_componente,
	dt_install,
	dt_accensione,
	CDAFIGARNZ as scadenza_garanzia,
	DT_ULT_MAN,
	DT_ULT_MAN_ORD,
	DT_INIZ_BV,
	DT_SCAD_BV,
	case when CFLAGGARZ=1 then 'Si' else 'No' end as CFLAGGARZ_TESTO,
	--ite.USO_RISCALDAMENTO,
	--ite.USO_H2O_SANITARIA,
	--ite.USO_ALTRO,
	idd.Cnote1 as ubicazione
	FROM VENDITE_TT
	left outer join impianti_tt as itt on itt.CCODSCHE=VENDITE_TT.ORD_CCODSCHE
	left outer join impianti_dd as idd on idd.CCODSCHE=itt.CCODSCHE
	left outer join impianti_co as ico on ico.ccodsche=itt.ccodsche
	--left outer join impianti_te as ite on ite.ccodsche=itt.ccodsche
	left outer join para on 'TCI'+TIPO_COMPONENTE = CODICE

GO





---------------------- NEW
/****** Oggetto:  View [dbo].[V_CONTA_INTERVENTI]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_CONTA_INTERVENTI]'))
DROP VIEW [dbo].[V_CONTA_INTERVENTI]
GO

CREATE VIEW [dbo].[V_CONTA_INTERVENTI]
AS
SELECT SUM(NUMERO) AS NUMERO, STATO, REPLACE(STATO,'_',' ') AS ETICHETTA FROM ( 
SELECT COUNT(*) AS NUMERO, 
CASE 
WHEN ORD_DTPROGR=CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=0 THEN 'da_effettuare_oggi' 
WHEN ORD_DTPROGR=CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=1 THEN 'effettuati' 
WHEN ORD_DTPROGR<CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=0 THEN 'da_chiudere' 
--WHEN ORD_DTPROGR>CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=1 THEN 'pianificati_effettuati' 
WHEN ORD_DTPROGR>CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=0 THEN 'pianificati_futuri' END 
AS STATO FROM V_INTERVENTI 
GROUP BY ORD_INTCLOSE,ORD_DTPROGR ) as t1 WHERE STATO IS NOT NULL
GROUP BY STATO

GO




------------------------------------------------------------
---------------------- NEW ---------------------------------
------------------------------------------------------------



/****** Oggetto:  View [dbo].[V_INTERVENTO_DETTAGLIO_ATTIVITA]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_INTERVENTO_DETTAGLIO_ATTIVITA]'))
DROP VIEW [dbo].[V_INTERVENTO_DETTAGLIO_ATTIVITA]
GO

CREATE VIEW [dbo].[V_INTERVENTO_DETTAGLIO_ATTIVITA]
AS
	

SELECT VENDITE_DT.ORD_RAPPORT,VENDITE_TT.TAGGANCIO, VENDITE_TT.ORD_NUMORD,ORD_DTPROGR,ID_UTENTE,DAGGANCIO,VENDITE_DT.ORD_CODSYS,VENDITE_DT.ORD_CODSYS as codsys, LTRIM(RTRIM(DESCRI)) AS DESCRIZIONE_ATTIVITA,VENDITE_DT.ORD_TECNICO,
 utenti.COGNOME,utenti.NOME, utenti.COGNOME+' '+utenti.NOME AS NOMINATIVO_TECNICO,
 substring(VENDITE_DT.ORD_ORAINIINT,1,5) as ORD_ORAINIINT, substring(VENDITE_DT.ORD_ORAFININT,1,5) as ORAFININT,
case when VENDITE_DT.ORD_ORAINIINT='00:00:00' then '' else VENDITE_DT.ORD_ORAINIINT end as ORD_ORAINIINT_REAL,
	case when VENDITE_DT.ORD_ORAFININT='00:00:00' then '' else VENDITE_DT.ORD_ORAFININT end as ORD_ORAFININT_REAL,
	substring(VENDITE_DT.ORD_ORAINIPRO,1,5) as ORD_ORAINIPRO_REAL,
	substring(VENDITE_DT.ORD_ORAFINPRO,1,5) as ORD_ORAFINPRO_REAL,
	substring(VENDITE_DT.ORD_ORAINIPRO,1,5)+' - '+substring(VENDITE_DT.ORD_ORAFINPRO,1,5) as ORD_PRO_ATTIVITA
	,ord_oraparsede,ord_orelav,
	cast(format(ord_prezzo, 'N', 'de-DE') as varchar(20)) as ord_prezzo,
	cast(format(ord_prznet, 'N', 'de-DE') as varchar(20)) as ord_prznet,
	cast(format(ord_valatt, 'N', 'de-DE') as varchar(20)) as ord_valatt,
	cast(format(ord_dirizona, 'N', 'de-DE') as varchar(20)) as ord_dirizona,
	cast(format(ord_dirichiamata, 'N', 'de-DE') as varchar(20)) as ord_dirichiamata,
	cast(format(VENDITE_DT.ord_valpre, 'N', 'de-DE') as varchar(20)) as ord_valpre,
	ord_atticlose,ord_forfet,
	CAST(ord_prezzo AS DECIMAL(10, 2)) as ord_prezzo_note,
	CAST(ord_dirichiamata AS DECIMAL(10, 2)) as ord_dirichiamata_note,
	CAST(ord_dirizona AS DECIMAL(10, 2))  as ord_dirizona_note,
	case when ord_forfet=0 then 'No' else 'Si' end as TESTO_ORD_FORFET,
	case when ord_forfet=0 then 'N' else 'S' end as VALUE_ORD_FORFET
	 from VENDITE_DT 
	 left outer join VENDITE_TT on daggancio=taggancio
	LEFT OUTER JOIN PARA AS PA ON PA.CODICE='ATT'+ORD_ATTIVITA
	left outer join utenti on codice_utente='TEI'+VENDITE_DT.ORD_TECNICO
GO




/****** Oggetto:  View [dbo].[V_INTERVENTO_ATTIVITA]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_INTERVENTO_ATTIVITA]'))
DROP VIEW [dbo].[V_INTERVENTO_ATTIVITA]
GO

CREATE VIEW [dbo].[V_INTERVENTO_ATTIVITA]
AS
	
SELECT	LTRIM(RTRIM(DESCRI)) AS DESCRI,ORD_TECNICO,ORD_ORAINIINT,ORD_ORAFININT,DAGGANCIO,
case when VENDITE_DT.ORD_ORAINIINT='00:00:00' then '' else VENDITE_DT.ORD_ORAINIINT end as ORD_ORAINIINT_REAL,
	case when VENDITE_DT.ORD_ORAFININT='00:00:00' then '' else VENDITE_DT.ORD_ORAFININT end as ORD_ORAFININT_REAL,
	substring(VENDITE_DT.ORD_ORAINIPRO,1,5) as ORD_ORAINIPRO_REAL,
	substring(VENDITE_DT.ORD_ORAFINPRO,1,5) as ORD_ORAFINPRO_REAL,
	substring(VENDITE_DT.ORD_ORAINIPRO,1,5)+' - '+substring(VENDITE_DT.ORD_ORAFINPRO,1,5) as ORD_PRO_ATTIVITA
	 from VENDITE_DT 
	LEFT OUTER JOIN PARA AS PA ON PA.CODICE='ATT'+ORD_ATTIVITA
GO
	 





/****** Oggetto:  View [dbo].[V_INTERVENTI]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_INTERVENTI]'))
DROP VIEW [dbo].[V_INTERVENTI]
GO

CREATE VIEW [dbo].[V_INTERVENTI]
AS
	
SELECT distinct ORD_ORAINIPRO_REAL+' - '+ORD_ORAFINPRO_REAL as ORD_PRO_ATTIVITA, ORD_ORAINIINT_REAL+' - '+ORD_ORAFININT_REAL as ORD_INT_ATTIVITA,* FROM (
SELECT utenti.ID_UTENTE,utenti.USERNAME,utenti.COGNOME,utenti.NOME, utenti.COGNOME+' '+utenti.NOME AS NOMINATIVO_TECNICO,
	SUBSTRING(ORD_NOTET,0,33) AS ORD_NOTET_BREVE,
	case when ORD_PAGALTEC=1 then 'Si' else 'No' end as ORD_PAGALTEC_TESTO,
	case when ORD_INTCLOSE=1 then 'Effettuato' else 'Da effettuare' end as ORD_INTCLOSE_TESTO, 
	case when ORD_INTCLOSE=1 then 'Si' else 'No' end as INTERVENTO_TERMINATO, 
	case when ORD_INASSIST=1 then '- IN ASSISTENZA' else '' end as ORD_INASSIST_TESTO, 
	case when ORD_PAGALTEC=1 then '- PAGA AL TECNICO' else '' end as  ORD_PAGALTEC_NOTIFICA, 
	case when ORD_NOME='' and ORD_COGNOM='' then '' else ORD_NOME+' '+ORD_COGNOM END AS NOMINATIVO,
	case when FL_PAGATO=1 then 'Si' else 'No' end as FL_PAGATO_TESTO,
	case when ORD_FORFET=1 then 'Si' else 'No' end as ORD_FORFET_TESTO,	
	--case when VENDITE_DT.ORD_ORAINIINT='00:00:00' then '' else VENDITE_DT.ORD_ORAINIINT end as ORD_ORAINIINT_REAL,
	--case when VENDITE_DT.ORD_ORAFININT='00:00:00' then '' else VENDITE_DT.ORD_ORAFININT end as ORD_ORAFININT_REAL,
	--substring(VENDITE_DT.ORD_ORAINIPRO,1,5) as ORD_ORAINIPRO_REAL,
	--substring(VENDITE_DT.ORD_ORAFINPRO,1,5) as ORD_ORAFINPRO_REAL,
	--substring(VENDITE_DT.ORD_ORAINIPRO,1,5)+' - '+substring(VENDITE_DT.ORD_ORAFINPRO,1,5) as ORD_PRO_ATTIVITA,
	(select min(ORD_ORAINIPRO_REAL) from V_INTERVENTO_ATTIVITA as via WHERE via.DAGGANCIO=VENDITE_TT.TAGGANCIO and via.ORD_TECNICO=VENDITE_DT.ORD_TECNICO) as ORD_ORAINIPRO_REAL,
	(select max(ORD_ORAFINPRO_REAL) from V_INTERVENTO_ATTIVITA as via WHERE via.DAGGANCIO=VENDITE_TT.TAGGANCIO and via.ORD_TECNICO=VENDITE_DT.ORD_TECNICO) as ORD_ORAFINPRO_REAL,
	(select case when min(ORD_ORAINIINT)='00:00:00' then '' else min(ORD_ORAINIINT) end from V_INTERVENTO_ATTIVITA as via WHERE via.DAGGANCIO=VENDITE_TT.TAGGANCIO and via.ORD_TECNICO=VENDITE_DT.ORD_TECNICO) as ORD_ORAINIINT_REAL,
	(select case when min(ORD_ORAFININT)='00:00:00' then '' else min(ORD_ORAFININT) end from V_INTERVENTO_ATTIVITA as via WHERE via.DAGGANCIO=VENDITE_TT.TAGGANCIO and via.ORD_TECNICO=VENDITE_DT.ORD_TECNICO) as ORD_ORAFININT_REAL,
	DESCRI AS DESCRIZIONE_PAGAMENTO,
	REPLACE(STUFF ((SELECT ' + ' + DESCRI FROM V_INTERVENTO_ATTIVITA AS VIA WHERE VIA.dAGGANCIO=VENDITE_TT.TAGGANCIO and via.ORD_TECNICO=VENDITE_DT.ORD_TECNICO FOR XML PATH ('')) ,1,2,''),',,',',') AS DESCRIZIONE_ATTIVITA,
	'TEI'+VENDITE_DT.ORD_TECNICO as tecnico,
	--VENDITE_TT.* 
	TAGGANCIO,ORD_CODSOC,TNUMERO,ORD_CODCLI,ORD_RAGSOC,ORD_RAGDUE,ORD_INDIRI,ORD_CAP,ORD_LOCALI,ORD_PARIVA,ORD_CAMBIO,VENDITE_TT.ORD_NUMORD,VENDITE_TT.ORD_DATORD,ORD_CAUS,ORD_RIFERI,ORD_CPA,ORD_BANCA,
	cast(format(ORD_VALORE, 'N', 'de-DE') as varchar(20)) as ORD_VALORE,ORD_CHIUSO,VENDITE_TT.ORD_CODSYS,ORD_FLGSTA,ORD_ANNO,ORD_PROVIN,ORD_FLGTRA,ORD_TIPOLOGIA,cast(format(ORD_IMPONIB, 'N', 'de-DE') as varchar(20)) as ORD_IMPONIB,ORD_IMPOSTA,ORD_TELEFO,ORD_CELLU,CAST (ORD_NOTE_INTERVENTI AS CHAR(2000)) AS NOTE_INTERVENTI,ORD_INCASS,VENDITE_TT.ORD_TECNICO,
	VENDITE_TT.ORD_DTINIINT,ORD_DTFINTNT,ORD_INASSIST,ORD_PAGALTEC,VENDITE_TT.ORD_VALPRE,ORD_CCODSCHE,ORD_DAFATT,ORD_FATTURAT,ORD_DTPROGR,ORD_ZONA,ORD_INTCLOSE,ORD_SYSRINT,
	ORD_CCODLIS,LINKINTE,TIPO_MANU_PROGR,FL_PAGATO
	FROM VENDITE_TT
	LEFT OUTER JOIN VENDITE_DT ON VENDITE_TT.TAGGANCIO=VENDITE_DT.DAGGANCIO
	LEFT OUTER JOIN PARA ON CODICE='CPA'+ORD_CPA
	left outer join utenti on codice_utente='TEI'+VENDITE_DT.ORD_TECNICO
	where vendite_tt.ord_dtprogr>=convert(varchar, DATEADD(day, -(SELECT AZI_GINRINT FROM U_AZI_PC), GETDATE()), 111)
	) as t2
GO




/****** Oggetto:  View [dbo].[V_HOME_INTERVENTI]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_HOME_INTERVENTI]'))
DROP VIEW [dbo].[V_HOME_INTERVENTI]
GO

CREATE VIEW [dbo].[V_HOME_INTERVENTI]
AS

select *
--, count(*) over ( partition by stato ) as conteggio, REPLACE(STATO,'_',' ') AS ETICHETTA
from (
SELECT *, 
CASE 
WHEN ORD_DTPROGR=CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=0 THEN 'da_effettuare_oggi' 
--WHEN ORD_DTPROGR=CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=1 THEN 'effettuati' 
WHEN ORD_DTPROGR=CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=1 THEN 'effettuati' 
WHEN ORD_DTPROGR<CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=0 THEN 'da_chiudere' 
--WHEN ORD_DTPROGR>CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=1 THEN 'pianificati_effettuati' 
WHEN ORD_DTPROGR>CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=0 THEN 'pianificati_futuri' END 
AS STATO,
CASE 
WHEN ORD_DTPROGR=CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=0 and ORD_ORAINIINT_REAL!='' THEN 'card-active'
WHEN ORD_DTPROGR=CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=0 and ORD_ORAINIINT_REAL='' THEN '' 
WHEN ORD_DTPROGR=CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=1 THEN 'card-ended' 
WHEN ORD_DTPROGR<CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=0 THEN 'card-old' 
--WHEN ORD_DTPROGR>CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=1 THEN 'pianificati_effettuati' 
WHEN ORD_DTPROGR>CAST( GETDATE()  AS DATE ) AND ORD_INTCLOSE=0 THEN '' END 
AS CARD_COLOR
FROM V_INTERVENTI) as t1 where stato is not null 
GO







/****** Oggetto:  View [dbo].[V_U_ART_PR]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_U_ART_PR]'))
DROP VIEW [dbo].[V_U_ART_PR]
GO

CREATE VIEW [dbo].[V_U_ART_PR]
AS

select U_ART_PR.ID_UNIQUE,ART_CODSOC,ART_CODPRI,ART_DESCR,ART_DESEST,ART_UNIMIS,cast(format(ART_PRZVEN, 'N', 'de-DE') as varchar(20)) as ART_PRZVEN,ART_PRZVE2,ART_PRZVE3,ART_PRZVE4,
ART_PRZCOS,ART_CODIVA,ART_MAGA,'' as sconto,coalesce(rtrim(substring(libera,1,3)),0) as perc_iva,ART_BARCLI,ART_BARFOR
from U_ART_PR
left outer join para on 'IVA'+ART_CODIVA = codice
where ART_CODPRI<>''
GO





/****** Oggetto:  View [dbo].[V_RICAMBI_ELENCO]    Data script: 01/20/2011 08:42:57 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_RICAMBI_ELENCO]'))
DROP VIEW [dbo].[V_RICAMBI_ELENCO]
GO

CREATE VIEW [dbo].[V_RICAMBI_ELENCO]
AS

SELECT daggancio,ORD_CODSYS,ORD_CODART,ORD_DESART,cast(format(ORD_PRZNET, 'N', 'de-DE') as varchar(20)) as ORD_PRZNET,ORD_IVA,cast(format(ORD_SC1, 'N', 'de-DE') as varchar(6)) as ORD_SC1,cast(format(ORD_VALORE, 'N', 'de-DE') as varchar(20)) as ORD_VALORE,coalesce(rtrim(substring(libera,1,3)),0) as perc_iva FROM VENDITE_DD 
left outer join para on 'IVA'+ORD_IVA = codice
where ord_dett_int=0
GO