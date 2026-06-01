************************************************************
FUNCTION AQM_RILEVA_CONSISTENZA_E_DISPONIBILE_DA_PRODUZIONE
************************************************************

LPARAMETERS _par_codsoc,_par_anaart,_par_desart,_par_um,_par_codmag,_par_codint,_par_datada,_par_dataal,_par_dtcnda,_par_dtcnal,_par_dtprda,_par_dtpral,_par_altezz,_par_lunghe,_par_fila_x,_par_pian_x,_par_ubic_x,_par_escl_mag_scarto

LOCAL _AQM_SS_CONS,_RIT
_AQM_SS_CONS=SELECT()


** ##################################################################### CREAZIONE CURSORI ################################################################

*!*	CREATE CURSOR AQM_CONSISTENZA (CODART C(30), DESART C(200), UM C(3), QTARESORD N(19,PUB_DECQTA), QTAEVAORD N(19,PUB_DECQTA), QTAEVAORD_PREC N(19,PUB_DECQTA), GIACEN N(19,PUB_DECQTA), ;
*!*		QTARESORF N(19,PUB_DECQTA), QTARESPRD N(19,PUB_DECQTA), QTAPRLPRD N(19,PUB_DECQTA), QTADISP N(19,PUB_DECQTA), CONSIST N(19,PUB_DECQTA), QTAPROD N(19,PUB_DECQTA))

*!*	SELECT AQM_CONSISTENZA
*!*	INDEX ON CODART TAG I_CODART ADDITIVE

*!*	SELECT AQM_CONSISTENZA
*!*	SET ORDER TO I_CODART 

** ######################################### RICERCA ORDINI PERIODO ATTUALE (DA EVADERE) E PERIODO PRECEDENTE (EVASI)######################################



x_codi = "ORD_CODART = '" + ALLTRIM(_par_anaart) + "'"
x_test = "DAGGANCIO IN (SELECT TAGGANCIO FROM U_ORD_TT WHERE ORD_CODCLI <> '" + _par_codint + "')"  && ESCLUDO GLI ORDINI INTERNI
x_comm = "ORD_CODART <> '' AND ORD_DESART <> '*** COMMENTO ***'"
x_adot = "SUBSTRING(ORD_CODART,1,1) <> '.'"

x_evas_a = "ORD_CHIUSO = 0 AND ORD_QTAORD > ORD_QTAEV"
x_dtda_a = IIF(EMPTY(_par_datada),"1=1","ORS_DATORD >= '" + RIBALTA2(_par_datada) + "'")
x_dtal_a = IIF(EMPTY(_par_dataal),"1=1","ORS_DATORD <= '" + RIBALTA2(_par_dataal) + "'")
x_cond_a = x_codi + " and " +x_test + " and " + x_comm + " and " + x_adot + " and " + x_evas_a + " and " + x_dtda_a + " and " + x_dtal_a
x_cond_a = STRTRAN(x_cond_a," and 1=1","")

x_dcda_ea = IIF(EMPTY(_par_dtcnda),"1=1","ORD_DATCON >= '" + RIBALTA2(_par_dtcnda) + "'")
x_dcal_ea = IIF(EMPTY(_par_dtcnal),"1=1","ORD_DATCON <= '" + RIBALTA2(_par_dtcnal) + "'")
x_cond_ea = x_codi + " and " +x_test + " and " + x_comm + " and " + x_adot + " and " + x_dcda_ea + " and " + x_dcal_ea 
x_cond_ea = STRTRAN(x_cond_ea," and 1=1","")

x_evas_p = "ORD_QTAEV > 0"
x_dtda_p = IIF(EMPTY(_par_dtprda),"1=1","ORD_DATCON >= '" + RIBALTA2(_par_dtprda) + "'")
x_dtal_p = IIF(EMPTY(_par_dtpral),"1=1","ORD_DATCON <= '" + RIBALTA2(_par_dtpral) + "'")
x_cond_p = x_codi + " and " +x_test + " and " + x_comm + " and " + x_adot + " and " + x_evas_p + " and " + x_dtda_p + " and " + x_dtal_p
x_cond_p = STRTRAN(x_cond_p," and 1=1","")

cSql = ""
TEXT TO cSql NOSHOW
	SELECT
		COALESCE(ORDINI.ORD_CODART,'') AS ORD_CODART,
		COALESCE(ORDINI.ORD_QTARES,0) AS ORD_QTARES,
		COALESCE(ORDINI.ORD_QTAEV_ACT,0) AS ORD_QTAEV_ACT,
		COALESCE(ORDINI.ORD_QTAEV_PREC,0) AS ORD_QTAEV_PREC,
		COALESCE(ANA.ART_DESCR,'') AS ART_DESCR,
		COALESCE(ANA.ART_UMMAGA,'') AS ART_UMMAGA,
		COALESCE(ANA.ART_MAGA,'') AS ART_MAGA,
		COALESCE(ORDINI.ORD_MAGA,'') AS ORD_MAGA,
		COALESCE(ANA.ART_LINEA,'') AS ART_LINEA,
		COALESCE(AN2.ART_NONVAL,'') AS ART_NONVAL,
		COALESCE(DIT.DIT_GRUPPO,'') AS DIT_GRUPPO,
		COALESCE(DIS.DIS_CODART,'') AS DIS_CODART
	FROM (
		SELECT ORD_CODART, ORD_MAGA, SUM(ORD_QTAORD - ORD_QTAEV) AS ORD_QTARES, 0 AS ORD_QTAEV_ACT, 0 AS ORD_QTAEV_PREC
		FROM U_ORD_DD
		WHERE <<x_cond_a>>
		GROUP BY ORD_CODART, ORD_MAGA
		UNION
		SELECT ORD_CODART, ORD_MAGA, 0 AS ORD_QTARES, 0 AS ORD_QTAEV_ACT, SUM(ORD_QTAEV) AS ORD_QTAEV_PREC
		FROM U_ORD_DD
		WHERE <<x_cond_p>>
		GROUP BY ORD_CODART, ORD_MAGA
		UNION
		SELECT ORD_CODART, ORD_MAGA, 0 AS ORD_QTARES, SUM(ORD_QTAEV) AS ORD_QTAEV_ACT, 0 AS ORD_QTAEV_PREC
		FROM U_ORD_DD
		WHERE <<x_cond_ea>>
		GROUP BY ORD_CODART, ORD_MAGA
		) AS ORDINI
	LEFT OUTER JOIN U_DIS_TT AS DIT ON DIT.DIT_GRUPPO = ORDINI.ORD_CODART 
	LEFT OUTER JOIN U_ART_PR AS ANA ON ANA.ART_CODPRI = ORDINI.ORD_CODART 
	LEFT OUTER JOIN U_ART_AN AS AN2 ON AN2.ART_CODPRI = ANA.ART_CODPRI 
	OUTER APPLY (SELECT TOP 1 DIS_CODART FROM U_DIS_DD WHERE DIS_CODART = ORDINI.ORD_CODART) AS DIS
	ORDER BY ORD_CODART
ENDTEXT
IF !ExecPreparedCommand(cSql,"AQM_ORDINI")
	RETURN .F.
ENDIF

SELECT AQM_ORDINI
GO TOP


SELECT ART_MAGA,ORD_CODART,ART_DESCR,ART_UMMAGA,SUM(ORD_QTARES) AS ORD_QTARES,SUM(ORD_QTAEV_ACT) AS ORD_QTAEV_ACT,SUM(ORD_QTAEV_PREC) AS ORD_QTAEV_PREC;
 FROM AQM_ORDINI;
 GROUP BY ART_MAGA,ORD_CODART,ART_DESCR,ART_UMMAGA;
 INTO CURSOR AQM_ORDINATO 

SELECT AQM_ORDINATO
GO TOP
SCATTER MEMVAR MEMO
_AQM_QTARESORD 			= M.ORD_QTARES
_AQM_QTAEVAORD 			= M.ORD_QTAEV_ACT
_AQM_QTAEVAORD_PREC 	= M.ORD_QTAEV_PREC



** ######################################################################## GIACENZE ######################################################################

_AQM_GIACEN = 0
_ww_codsoc = pub_codsoc
_ww_anaart = _par_anaart
_ww_codmag = _par_codmag
_ww_prenot = .T.  && SOLO GIACENZE NON PRENOTATE
_ww_codint = ""
_ww_altezz = 0
_ww_lunghe = 0
_ww_fila_x = ""
_ww_pian_x = ""
_ww_ubic_x = ""
_AQM_GIACEN  = AQM_RILEVA_GIACENZE_DISPONIBILI(_ww_codsoc,_ww_anaart,_ww_codmag,_ww_prenot,_ww_codint,_ww_altezz,_ww_lunghe,_ww_fila_x,_ww_pian_x,_ww_ubic_x)



** ############################################################## ORDINI A FORNITORE IN ESSERE ############################################################

_AQM_QTARESORF = 0
x_comm = "ORD_DESART <> '*** COMMENTO ***'"
x_arti = "ORD_CODART = '" + _par_anaart + "'"
x_open = "(ORD_CHIUSO = 0 AND ORD_SALCON <> 'S')"
*x_maga = "ORD_MAGA = ORD_MAGA"
x_maga = "ORD_MAGA = '" + ALLTRIM(_par_codmag) + "'"
x_cond = x_comm + " and " + x_arti + " and " + x_open + " and " + x_maga
cSql = "SELECT DAGGANCIO, ORS_NUMORD, ORS_RAGSOC, ORD_DATCON, ORD_MAGA, ORS_CODCLI, ORD_CODART, ORD_CODCOL, ORD_ALTEZZ, ORD_LUNGHE, ORD_UM, " + ;
       "ORD_QTAORD, ORD_QTAEV, ORD_QTAMQ, ORD_QTAKG, ORD_QTAML, ORD_QTAMC, ORD_NUMBOB FROM U_ORF_DD " + ;
       "WHERE " + x_cond + " ORDER BY ORD_DATCON"
IF !ExecCommand(cSql,"CX_ORF_DD")
  return(.f.)
ENDIF
SELECT CX_ORF_DD
GO TOP
SCAN
	
	_Y_QTAORD = ORD_QTAORD
	_Y_QTAEV  = ORD_QTAEV
	_Y_QTARES = ORD_QTAORD - ORD_QTAEV
	IF _Y_QTARES < 0
		_Y_QTARES = 0
	ENDIF
	IF _Y_QTARES > 0
	ELSE
		SELECT CX_ORF_DD
		LOOP
	ENDIF
	
	_Y_UNIMIS = ALLTRIM(ORD_UM)
	_Y_QTAKG = ORD_QTAKG
	_Y_QTAMQ = ORD_QTAMQ
	_Y_QTAML = ORD_QTAML
	_Y_QTAMC = ORD_QTAMC
	_Y_QTANR = ORD_NUMBOB
	IF ALLTRIM(_Y_UNIMIS) == 'KG'
		_Y_QTAKG = ORD_QTAORD
	ENDIF
	IF ALLTRIM(_Y_UNIMIS) == 'MQ'
		_Y_QTAMQ = ORD_QTAORD
	ENDIF
	IF ALLTRIM(_Y_UNIMIS) == 'ML'
		_Y_QTAML = ORD_QTAORD
	ENDIF
	IF ALLTRIM(_Y_UNIMIS) == 'MC'
		_Y_QTAMC = ORD_QTAORD
	ENDIF
	IF ALLTRIM(_Y_UNIMIS) == 'NR'
		_Y_QTANR = ORD_QTAORD
	ENDIF
	
	_Y_QTATEO = 0
	
	_ummaga = AQM_TROVA_UMMAGA(_par_anaart)
	
	*** ESPRIMO LA QUANTITA' RESIDUA NELL'ORDINE A FORNITORE IN UNITA' DI MISURA DI MAGAZZINO
	DO CASE
		CASE _Y_UNIMIS == _ummaga
			_Y_QTATEO = _Y_QTARES
		
		CASE _ummaga = 'KG'
			_Y_QTATEO = ROUND(_Y_QTARES * _Y_QTAKG / _Y_QTAORD, PUB_DECQTA)
			
		CASE _ummaga = 'MQ'
			_Y_QTATEO = ROUND(_Y_QTARES * _Y_QTAMQ / _Y_QTAORD, PUB_DECQTA)
			
		CASE _ummaga = 'ML'
			_Y_QTATEO = ROUND(_Y_QTARES * _Y_QTAML / _Y_QTAORD, PUB_DECQTA)
			
		CASE _ummaga = 'MC'
			_Y_QTATEO = ROUND(_Y_QTARES * _Y_QTAMC / _Y_QTAORD, PUB_DECQTA)
			
		CASE _ummaga = 'NR'
			_Y_QTATEO = ROUND(_Y_QTARES * _Y_QTANR / _Y_QTAORD, 0)
	ENDCASE
	
	_AQM_QTARESORF = _AQM_QTARESORF + _Y_QTATEO

	SELECT CX_ORF_DD

ENDSCAN




** ########################################################## QUANTITA' IN PRODUZIONE E GIA' PRELEVATE ####################################################
 
_AQM_QTARESPRD = 0
_AQM_QTAPRLPRD = 0
x_comp = "PA.COMP = '" + _par_anaart + "'"
x_open = "PR.FLGCLOSED = 0"
x_cond = x_comp + " and " + x_open
cSql = "SELECT COALESCE(SUM(QTA - QTAPROD),0) AS QTADAPROD, COALESCE(SUM(QTAPREL),0) AS QTAPREL FROM ( " + CHR(13) + ;
       "	SELECT PA.QTA, PA.QTAPROD, PC.QTAPREL FROM PROD_AVANZA AS PA " + CHR(13) + ;
       "	INNER JOIN PRODUZIONE AS PR ON PR.IDPRG = PA.IDPRG AND PR.PARENT = '' " + CHR(13) + ;
       "	LEFT OUTER JOIN (SELECT IDPRG, FASELA, SEQUEN, COUNT(*) AS QTAPREL FROM PROD_CARICHI WHERE QTAPROD = 0 GROUP BY IDPRG, FASELA, SEQUEN) AS PC ON PA.IDPRG = PC.IDPRG AND PA.FASELA = PC.FASELA AND PA.SEQUEN = PC.SEQUEN " + CHR(13) + ;
       "	WHERE " + x_cond + ") AS MAIN"

IF !ExecCommand(cSql,"CX_PROD_QTANECT")
  return(.f.)
ENDIF
SELECT CX_PROD_QTANECT
GO TOP
IF !EOF()
	_AQM_QTARESPRD = QTADAPROD
	_AQM_QTAPRLPRD = QTAPREL
ENDIF



** ##################################################### QUANTITA' PRODOTTA NELL'ANNO DI RIFERIMENTO ATTUALE #############################################

_AQM_QTAPROD = 0
x_comp = "PA.COMP = '" + _par_anaart + "'"
x_open = "SUBSTRING(PR.DTINEF,1,4) = '" + IIF(EMPTY(_par_dataal),PUB_ANNO,SUBSTR(RIBALTA2(_par_dataal),1,4)) + "'"
x_cond = x_comp + " and " + x_open
cSql = "SELECT COALESCE(SUM(QTAPROD),0) AS QTAPROD FROM ( " + CHR(13) + ;
       "	SELECT QTAPROD FROM PROD_AVANZA AS PA " + CHR(13) + ;
       "	INNER JOIN PRODUZIONE AS PR ON PR.IDPRG = PA.IDPRG AND PR.PARENT = '' " + CHR(13) + ;
       "	WHERE " + x_cond + ") AS MAIN"
IF !ExecCommand(cSql,"CX_PROD_QTAPROD")
  return(.f.)
ENDIF
SELECT CX_PROD_QTAPROD
GO TOP
IF !EOF()
	_AQM_QTAPROD = QTAPROD
ENDIF



** ############################################################### CREA CURSORE CONSISTENZA ##############################################################

_AQM_QTADISP = _AQM_GIACEN - _AQM_QTARESORD
_AQM_CONSIST = _AQM_GIACEN - _AQM_QTARESORD + _AQM_QTARESORF + _AQM_QTARESPRD

*!*	SELECT AQM_CONSISTENZA
*!*	APPEND BLANK
*!*	REPLACE CODART         WITH _par_anaart
*!*	REPLACE DESART         WITH _par_desart
*!*	REPLACE UM             WITH _par_um
*!*	REPLACE QTARESORD      WITH _AQM_QTARESORD
*!*	REPLACE QTAEVAORD      WITH _AQM_QTAEVAORD
*!*	REPLACE QTAEVAORD_PREC WITH _AQM_QTAEVAORD_PREC
*!*	REPLACE GIACEN         WITH _AQM_GIACEN
*!*	REPLACE QTARESORF      WITH _AQM_QTARESORF
*!*	REPLACE QTARESPRD      WITH _AQM_QTARESPRD
*!*	REPLACE QTAPRLPRD      WITH _AQM_QTAPRLPRD
*!*	REPLACE QTADISP        WITH _AQM_QTADISP 
*!*	REPLACE CONSIST        WITH _AQM_CONSIST 
*!*	REPLACE QTAPROD        WITH _AQM_QTAPROD 



_RIT = _AQM_CONSIST 

SELECT(_AQM_SS_CONS)

RETURN _RIT

