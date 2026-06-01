
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_UTENTI_PROFILI]'))
DROP VIEW [dbo].[V_UTENTI_PROFILI]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_menu]'))
DROP VIEW [dbo].[v_menu]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_menu_tree]'))
DROP VIEW [dbo].[v_menu_tree]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_AZIENDE_TREE]'))
DROP VIEW [dbo].[V_AZIENDE_TREE]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_DIPENDENTI]'))
DROP VIEW [dbo].[V_DIPENDENTI]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_UTENTI]'))
DROP VIEW [dbo].[V_UTENTI]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_LOGIN]'))
DROP VIEW [dbo].[V_LOGIN]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_MAPPA_PROFILI_PER_SITO]'))
DROP VIEW [dbo].[V_MAPPA_PROFILI_PER_SITO]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_EMAIL_LOG]'))
DROP VIEW [dbo].[V_EMAIL_LOG]
GO




-- view V_UTENTI_PROFILI
CREATE VIEW [dbo].[V_UTENTI_PROFILI]

AS
SELECT
	UPR.ID_UTENTE
	,PRF.CODICE
	,PRF.DESCRIZIONE
	,PRF.ID_PROFILO
FROM UTENTI_PROFILI AS UPR
LEFT OUTER JOIN PROFILI AS PRF
ON UPR.ID_PROFILO = PRF.ID_PROFILO
;


-- view V_MENU
CREATE VIEW V_MENU AS 
 SELECT me.id_menu,
    me.id_menu_sup,
	me.alias,
    me.ordine,
    ml.descrizione,
    LI.codice_iso,
    me.link,
	me.icon
   FROM menu me
   INNER JOIN menu_lingue AS ML 
   ON me.id_menu = ml.id_menu
   INNER JOIN LINGUE_ISO AS LI
   ON ML.ID_LINGUE_ISO=LI.ID_LINGUE_ISO
;




-- view v_menu_tree
CREATE VIEW v_menu_tree AS 
WITH v_menu_tree as (
	--select id_menu_sup
	--,descrizione_sup
	--,link_sup
	--,id_menu
	--,alias
	--,icon
	--,descrizione
	--,link
	--,path
	--,path_descri
	--,link_chain
	--,depth
	--,codice_iso) AS (
	SELECT 
		r.id_menu_sup
		,p1.descrizione AS descrizione_sup
		,p1.link AS link_sup
		,r.id_menu
		,R.ALIAS 
		,R.ICON
		,p2.descrizione
		,p2.link
		,FORMAT(r.ordine, '0000') as path
		,cast('Home / ' + r.descrizione as varchar(200)) AS path_descri
	    ,cast('astro?FUNCTIONID=Home;' + P2.LINK as varchar(200))  as LINK_CHAIN		
        ,1 as DEPTH
		,r.codice_iso
	FROM v_menu as r
		,v_menu as p1
		,v_menu as p2
	WHERE r.id_menu_sup = (SELECT id_menu FROM menu WHERE id_menu_sup IS NULL) 
		AND p1.id_menu = r.id_menu_sup AND p1.codice_iso = r.codice_iso 
		AND p2.id_menu = r.id_menu AND p2.codice_iso = r.codice_iso 
		AND p1.codice_iso = p2.codice_iso
	UNION ALL
	SELECT 
		r.id_menu_sup
		,p1.descrizione AS descrizione_sup
		,p1.link AS link_sup
		,r.id_menu
		,R.ALIAS
		,R.ICON
		,p2.descrizione
		,p2.link
		,nd.path + format(r.ordine, '0000') as path
		,cast(nd.path_descri+ ' / ' + r.descrizione as varchar(200)) AS path_descri
        ,cast(LINK_CHAIN + ';' + P2.LINK as varchar(200))  as LINK_CHAIN
		,nd.depth + 1
		,r.codice_iso
	FROM v_menu as r
		,v_menu as p1
		,v_menu as p2
		,v_menu_tree as nd
	WHERE 
		R.ID_MENU_SUP not in (SELECT ID_MENU FROM V_MENU WHERE ID_MENU_SUP IS  NULL) 
		and r.id_menu_sup = nd.id_menu AND r.codice_iso = nd.codice_iso 
		AND p1.id_menu = r.id_menu_sup AND p1.codice_iso = r.codice_iso 
		AND p2.id_menu = r.id_menu AND p2.codice_iso = r.codice_iso
)
SELECT DISTINCT * FROM v_menu_tree
UNION ALL
SELECT id_menu_sup
	,'' AS descrizione_sup
	,'' AS link_sup
	,id_menu
	,'Home' AS ALIAS
	,'fa fa-home' AS ICON
	,descrizione
	,link
	,'' AS path
	,'Home' AS path_descri
	,'astro?FUNCTIONID=Home' AS LINK_CHAIN
    	,0 AS depth
    	,codice_iso
FROM v_menu 
WHERE id_menu_sup IS NULL
;




-- view V_AZIENDE_TREE
CREATE VIEW V_AZIENDE_TREE AS 
WITH V_AZIENDE_TREE as (
	SELECT
		ID_AZIENDA_PARENT
		, cast('' as varchar(200))  AS RAGSOC_SUP
		, ID_AZIENDA
		, ALIAS_AZIENDA
		, RAGSOC
		, FORMAT(ID_AZIENDA, '00000') as PATH
		, 0 AS DEPTH
		, TIPO_AZIENDA
		, CODICE
		, FL_DISATTIVO
	FROM AZIENDE WHERE ID_AZIENDA_PARENT IS NULL
    UNION ALL
    SELECT
        R.ID_AZIENDA_PARENT, 
        cast(P1.RAGSOC as varchar(200)) AS RAGSOC_SUP,
        R.ID_AZIENDA, 
		R.ALIAS_AZIENDA ,
        P2.RAGSOC,
        PATH + '>' + FORMAT(R.ID_AZIENDA, '00000') as PATH, 
        ND.DEPTH + 1
        , R.TIPO_AZIENDA
		, R.CODICE
		, R.FL_DISATTIVO
    FROM AZIENDE AS R
		,AZIENDE AS P1
		,AZIENDE AS P2,
        V_AZIENDE_TREE AS ND
    WHERE R.ID_AZIENDA_PARENT IS NOT NULL
	AND R.ID_AZIENDA_PARENT = ND.ID_AZIENDA 
    AND P1.ID_AZIENDA = R.ID_AZIENDA_PARENT AND P2.ID_AZIENDA = R.ID_AZIENDA 
)
SELECT DISTINCT * FROM V_AZIENDE_TREE
;



-- view [V_UTENTI]
CREATE VIEW V_UTENTI AS
SELECT distinct USR.ID_UTENTE 
	,USR.USERNAME 
	,LI.CODICE_ISO 
	,USR.COGNOME AS COGNOME_UTENTE 
	,USR.NOME AS NOME_UTENTE 
	,USR.NOME + ' ' + USR.COGNOME AS NOME_COGNOME
	,USR.EMAIL 
	,USR.FL_DISATTIVO 
	,USR.TS_LOGIN
	,convert(varchar(10),ts_login,0) as DATA_ULTIMO_ACCESSO 
	,convert(varchar(10),ts_login,100) as ORA_ULTIMO_ACCESSO 	
	,PWD.PASSWORD 
	,PWD.DT_SCADENZA 
	,(SELECT CODICE FROM V_UTENTI_PROFILI AS EF WHERE ID_UTENTE=USR.ID_UTENTE ) AS PROFILO
	,(SELECT DESCRIZIONE FROM V_UTENTI_PROFILI AS EF WHERE ID_UTENTE=USR.ID_UTENTE ) AS DESCRIZIONE_PROFILO
	,(SELECT cast (UA.ID_AZIENDA as varchar(50)) FROM UTENTI_AZIENDE AS UA WHERE UA.ID_UTENTE=USR.ID_UTENTE) AS AZIENDE_UTENTE
	
	,(SELECT AZ.RAGSOC 
		FROM UTENTI_AZIENDE AS UA
		INNER JOIN AZIENDE AS AZ
		ON UA.ID_AZIENDA=AZ.ID_AZIENDA
		WHERE UA.ID_UTENTE=USR.ID_UTENTE 
		) AS RAGSOC_AZIENDE_UTENTE

	,'' AS LISTA_DIREZIONI


FROM UTENTI AS USR  
LEFT OUTER JOIN PASSWORD AS PWD  
ON USR.ID_UTENTE=PWD.ID_UTENTE AND PWD.FL_VALIDA=1 
INNER JOIN UTENTI_LINGUE AS UL 
ON USR.ID_UTENTE =UL.ID_UTENTE AND UL.FL_DEFAULT=1
INNER JOIN LINGUE_ISO AS LI 
ON UL.ID_LINGUE_ISO =LI.ID_LINGUE_ISO
;




-- view [V_LOGIN]
CREATE VIEW V_LOGIN
AS
SELECT 	USR.ID_UTENTE 
	,USR.USERNAME 
	,LI.CODICE_ISO 
	,USR.COGNOME AS COGNOME_UTENTE 
	,USR.NOME AS NOME_UTENTE 
	,PWD.PASSWORD 
	,PWD.DT_SCADENZA
	,usr.fl_disattivo

	,(SELECT CODICE 
		FROM V_UTENTI_PROFILI 
		WHERE ID_UTENTE=USR.ID_UTENTE 
		)  AS PROFILO  

	,(SELECT DESCRIZIONE
		FROM V_UTENTI_PROFILI 
		WHERE ID_UTENTE=USR.ID_UTENTE 
		)  AS DESCRIZIONE_PROFILO  


	,(SELECT cast(ID_AZIENDA as char(50))
		FROM UTENTI_AZIENDE 
		WHERE ID_UTENTE=USR.ID_UTENTE 
		)  AS AZIENDE_UTENTE  


	,( SELECT top(1) ALIAS_AZIENDA FROM V_AZIENDE_TREE WHERE ID_AZIENDA IN (
			SELECT ID_AZIENDA 
			FROM UTENTI_AZIENDE AS UA 
			LEFT OUTER JOIN UTENTI AS UT 
			ON UA.ID_UTENTE=UT.ID_UTENTE 
			WHERE LOWER(UT.USERNAME)=LOWER(USR.USERNAME)) ORDER BY PATH ) AS ALIAS_AZIENDA_UTENTE 
			
	,( SELECT top(1) AZ.CODICE 
			FROM V_AZIENDE_TREE AS AT 
			LEFT OUTER JOIN AZIENDE AS AZ 
			ON AZ.ID_AZIENDA = AT.ID_AZIENDA 
			WHERE AT.ID_AZIENDA IN (
			SELECT ID_AZIENDA 
			FROM UTENTI_AZIENDE AS UA 
			LEFT OUTER JOIN UTENTI AS UT 
			ON UA.ID_UTENTE=UT.ID_UTENTE 
			WHERE LOWER(UT.USERNAME)=LOWER(USR.USERNAME)) ORDER BY PATH ) AS CODICE_AZIENDA_UTENTE 

	,'' AS DIREZIONI_UTENTE
		
FROM UTENTI AS USR  
LEFT OUTER JOIN PASSWORD AS PWD  
ON USR.ID_UTENTE=PWD.ID_UTENTE AND PWD.FL_VALIDA=1 
INNER JOIN UTENTI_LINGUE AS UL 
ON USR.ID_UTENTE =UL.ID_UTENTE AND UL.FL_DEFAULT=1
INNER JOIN LINGUE_ISO AS LI 
ON LI.ID_LINGUE_ISO =UL.ID_LINGUE_ISO  
;


/*
-- view [V_PARAMETRI]
DROP VIEW IF exists V_PARAMETRI CASCADE;

CREATE VIEW V_PARAMETRI
AS
	select  DISTINCT
		PAR.*
		,DOM.DESCRIZIONE AS DESCR_DOMINIO
		,PAR.CODICE||' - '||PAR.DESCRIZIONE AS CODICE_DESCRIZIONE
	FROM PARAMETRI AS PAR 
	INNER JOIN PARAMETRI AS DOM
	ON PAR.DOMINIO=DOM.CODICE AND DOM.DOMINIO ='DOM'
;



-- view [V_PARAMETRI_LINGUE]
DROP VIEW IF exists V_PARAMETRI_LINGUE CASCADE;

CREATE VIEW V_PARAMETRI_LINGUE
AS
	SELECT
		PAR.DOMINIO
		,PAR.CODICE
		,PAR.ID_PARAMETRO
		,PAR.DESCRIZIONE
		,PAR.ORDINE
		,PAR.FL_DISATTIVO
		,DOM.DESCRIZIONE AS DESCR_DOMINIO
		,LIN.ID_LINGUE_ISO
		,LIN.CODICE_ISO
	FROM PARAMETRI AS PAR 
	INNER JOIN PARAMETRI AS DOM	ON PAR.DOMINIO=DOM.CODICE AND DOM.DOMINIO ='DOM'
	LEFT OUTER JOIN LINGUE_ISO AS LIN ON LIN.ID_LINGUE_ISO = (select id_lingue_iso from lingue_iso where codice_iso = 'it')
	
	union
	
	SELECT distinct
		PAR.DOMINIO
		,PAR.CODICE
		,PAR.ID_PARAMETRO
		,COALESCE(PAL.DESCRIZIONE,PAR.DESCRIZIONE) as DESCRIZIONE
		,PAR.ORDINE
		,PAR.FL_DISATTIVO
		,DOM.DESCRIZIONE AS DESCR_DOMINIO
		,LIN.ID_LINGUE_ISO
		,LIN.CODICE_ISO
	FROM PARAMETRI AS PAR 
	INNER JOIN PARAMETRI AS DOM	ON PAR.DOMINIO=DOM.CODICE AND DOM.DOMINIO ='DOM'
	LEFT OUTER JOIN PARAMETRI_LINGUE_ISO as PAL on PAL.ID_PARAMETRO = PAR.ID_PARAMETRO and PAL.ID_LINGUE_ISO = (select id_lingue_iso from lingue_iso where codice_iso = 'en')
	LEFT OUTER JOIN LINGUE_ISO AS LIN ON LIN.ID_LINGUE_ISO = (select id_lingue_iso from lingue_iso where codice_iso = 'en')
;
*/

-- view [V_EMAIL_LOG]
/*CREATE VIEW V_EMAIL_LOG AS
SELECT id_email_log,sender,recipients_to,
replace(recipients_to,';',chr(10)) AS destinatario,
replace(recipients_cc,';',chr(10)) AS destinatario_cc,
recipients_cc,recipients_bcc,subject,body,attachment_list,attempts,ts_send,email_data,fl_sent,username,ts_ins 
FROM EMAIL_LOG 
;*/

/*
-- view [V_MAPPA_PROFILI_PER_SITO_ABILITAZIONI]
drop view V_MAPPA_PROFILI_PER_SITO_ABILITAZIONI cascade;
CREATE VIEW V_MAPPA_PROFILI_PER_SITO_ABILITAZIONI AS
select distinct id_utente,id_azienda,ID_PROFILO,STRING_AGG (CODICE_MODULO, ', ') as codice_abilitazioni,STRING_AGG (descr_modulo, ', ') as abilitazioni from (
SELECT 
	udrm.id_utente,udrm.id_azienda
	,PR.ID_PROFILO as ID_PROFILO 
	,PR.DESCRIZIONE as DESCR_PROFILO 
	,AZ.RAGSOC as SITO 
	, udrm.CODICE_MODULO
	,EM.DESCRIZIONE || ' (' || UDRM.CODICE_MODULO || ')' as DESCR_MODULO 
FROM utenti_dettagli_ruoli_aziende_moduli as udrm 
LEFT OUTER JOIN PROFILI AS PR 
ON udrm.ID_RUOLO = PR.ID_PROFILO 
LEFT OUTER JOIN aziende AS az 
ON udrm.id_azienda = az.id_azienda 
LEFT OUTER JOIN ELENCO_MODULI AS EM 
ON udrm.CODICE_MODULO = EM.CODICE_MODULO 
ORDER BY PR.DESCRIZIONE
) as t1 group by id_utente,id_azienda,ID_PROFILO
order by id_utente,id_azienda,ID_PROFILO,abilitazioni;


-- view [V_MAPPA_PROFILI_PER_SITO]
CREATE VIEW V_MAPPA_PROFILI_PER_SITO AS
SELECT 	USR.ID_UTENTE 
	,USR.USERNAME 
	,USR.COGNOME AS COGNOME_UTENTE 
	,USR.NOME AS NOME_UTENTE 
	,USR.NOME || ' ' || USR.COGNOME AS NOME_COGNOME
	,USR.FL_DISATTIVO 
	,VUP.CODICE AS PROFILO
	,VUP.DESCRIZIONE AS DESCRIZIONE_PROFILO
	,VUP.ID_PROFILO AS ID_PROFILO
	,AZ.RAGSOC AS RAGSOC_AZIENDE_UTENTE
	,AZ.ID_AZIENDA AS ID_AZIENDA
	,vm.abilitazioni
	,vm.codice_abilitazioni
FROM UTENTI AS USR  
LEFT OUTER JOIN PASSWORD AS PWD  
ON USR.ID_UTENTE=PWD.ID_UTENTE AND PWD.FL_VALIDA=true 
INNER JOIN UTENTI_LINGUE AS UL 
ON USR.ID_UTENTE =UL.ID_UTENTE AND UL.FL_DEFAULT=true
INNER JOIN V_UTENTI_PROFILI AS VUP
ON USR.ID_UTENTE =VUP.ID_UTENTE
INNER JOIN UTENTI_AZIENDE AS UA
ON USR.ID_UTENTE=UA.ID_UTENTE
INNER JOIN AZIENDE AS AZ
ON UA.ID_AZIENDA=AZ.ID_AZIENDA
left outer join V_MAPPA_PROFILI_PER_SITO_ABILITAZIONI as vm
on vm.id_utente=usr.id_utente and vm.id_profilo=vup.id_profilo and vm.id_azienda= uA.id_azienda
;
*/