
**********************************************************
PROCEDURE REFRESH_CURSORE_GRIGLIA_SB
**********************************************************

	LPARAMETERS _ALIAS

	LOCAL _CUR_GRIGLIA

	_CUR_GRIGLIA="CUR_"+_ALIAS
	
	SELECT &_CUR_GRIGLIA
	DELETE ALL
	
	SELECT &_ALIAS
	GO TOP
	
	DO WHILE !EOF()
		
		SCATTER MEMVAR
		
		SELECT &_CUR_GRIGLIA
		APPEND BLANK
		GATHER MEMVAR
	
		SELECT  &_ALIAS
		SKIP
	ENDDO
	
	SELECT &_CUR_GRIGLIA
	GO TOP

* PROCEDURE REFRESH_CURSORE_GRIGLIA
**********************************************************




**********************************************************
* Classe CasellaDiTestoPerSbloccoPrenotato
**********************************************************
DEFINE CLASS CasellaDiTestoPerSbloccoPrenotato AS TestoPerGriglia
  		  
	*****************************
	* Metodo PROCEDURE Init
	*****************************
	PROCEDURE Init
		
		WITH this
			.height=20
			.FontName=this.Parent.Parent.FontName
			.FontSize=this.Parent.Parent.FontSize
			.FontBold=this.Parent.Parent.FontBold
			.SpecialEffect=1
			.BorderStyle=0 && 0-none 1-fixed single
			.BackColor=RGB(255,255,255)
			.ForeColor=RGB(0,0,0)
		ENDWITH	

	ENDPROC
	*- FINE Metodo: Init
    ***************************
    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
		WITH this
			_ALIAS=.Parent.Parent.RecordSourceAlias
			SELECT &_ALIAS
			_RECNO=ALLTRIM(STR(RECNO()))
			* seleziona la casella corrente con un colore diverso
			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()="+_RECNO+",COLORE('ROSSO'),COLORE('BIANCO'))", "Column")
			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()="+_RECNO+", COLORE('GIALLO'),COLORE('NERO'))", "Column")
			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()="+_RECNO+",.T.,.F.)","Column") 
			
			.Parent.Parent.Refresh()
		ENDWITH
	RETURN
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
	RETURN
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaDiTestoPerSbloccoPrenotato
**********************************************************


**********************************************************
* Classe CheckBoxPerGrigliaPerSbloccoPrenotato
**********************************************************
DEFINE CLASS CheckBoxPerGrigliaPerSbloccoPrenotato AS CheckBox
	
    WIDTH = 18
    AUTOSIZE = .T.
    CAPTION = ""
    NAME = "CheckBoxPerGrigliaPerSbloccoPrenotato"
    BACKSTYLE = 0

	***************************
	* Metodo 
	* Procedure Valid
	***************************
	PROCEDURE Valid

		SELECT (this.Parent.Parent.RECORDSOURCE)
		IF RECCOUNT()=0
			RETURN
		ENDIF
		
		IF !THIS.Parent.Parent.VerificaSelezioneMultipla()
			SELECT (THIS.Parent.Parent.RecordSource) 
			IF EMPTY(SELEZIONE)
				REPLACE SELEZIONE WITH THIS.Parent.Parent.SimboloSelezione
			ELSE
				REPLACE SELEZIONE WITH SPACE(0)
			ENDIF
		ENDIF
		
		DO CASE
			CASE THIS.Parent.Parent.Name = 'GRIGLIA_BOBINE'
				IF EMPTY(ALLTRIM(PR3_CODINT))
					WAIT WINDOWS "Codice Interno non valorizzato - Bobina non ancora pronta per produzione" NOWAIT
					REPLACE SELEZIONE WITH SPACE(0)
				ELSE
					THIS.Parent.Parent.Parent.aggiorna_selezione_griglie_dipendenti("BOB")
				ENDIF
			CASE THIS.Parent.Parent.Name = 'GRIGLIA_BARRE'
				IF EMPTY(ALLTRIM(PR4_CODINT))
					WAIT WINDOWS "Codice Interno non valorizzato - Barra non ancora avanzata in produzione" NOWAIT
					REPLACE SELEZIONE WITH SPACE(0)
				ELSE
					THIS.Parent.Parent.Parent.aggiorna_selezione_griglie_dipendenti("BAR")
				ENDIF
			CASE THIS.Parent.Parent.Name = 'GRIGLIA_ROTOLI'
				IF EMPTY(ALLTRIM(PR5_CODINT))
					WAIT WINDOWS "Codice Interno non valorizzato - Rotolo non ancora avanzato in produzione" NOWAIT
					REPLACE SELEZIONE WITH SPACE(0)
				ELSE
					THIS.Parent.Parent.Parent.aggiorna_selezione_griglie_dipendenti("ROT")
				ENDIF
			OTHERWISE
		ENDCASE
		
		WITH this
			_ALIAS=.Parent.Parent.RecordSourceAlias
			SELECT &_ALIAS
			_RECNO=ALLTRIM(STR(RECNO()))
			* seleziona la casella corrente con un colore diverso
			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()="+_RECNO+",COLORE('ROSSO'),COLORE('BIANCO'))", "Column")
			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()="+_RECNO+", COLORE('GIALLO'),COLORE('NERO'))", "Column")
			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()="+_RECNO+",.T.,.F.)","Column") 
			
			.Parent.Parent.Refresh()
		ENDWITH
		
		THIS.Parent.Parent.Refresh()
		
	ENDPROC
	*- FINE Metodo: Valid
    ***************************

ENDDEFINE
*- FINE CLASSE CheckBoxPerGrigliaPerSbloccoPrenotato
**********************************************************


**********************************************************
PROCEDURE LOAD_CURSORI_PIANO_SB
**********************************************************
	
	DO LOAD_U_PRD_D1_SB WITH "",0,"CUR_U_PRD_D1"

	*DO LOAD_U_PRD_D2_SB WITH "","CUR_U_PRD_D2"
	
	DO LOAD_U_PRD_D3_SB WITH "","CUR_U_PRD_D3"
	
	DO LOAD_U_PRD_D4_SB WITH "","CUR_U_PRD_D4"
	
	DO LOAD_U_PRD_D5_SB WITH "","CUR_U_PRD_D5"
	
	*DO LOAD_DATE WITH "","CUR_DATE"
	
	RETURN
	
**********************************************************
PROCEDURE RELOAD_CURSORE_PIANI_SB
**********************************************************
	
	LPARAMETERS _PJ_PRGPRD1
	
	IF PCOUNT() >= 1
	ELSE
	   _PJ_PRGPRD1 = ""
	ENDIF
	
	DO LOAD_U_PRD_D1_SB WITH _PJ_PRGPRD1,1
	
	RETURN
	
	
*****************************************
PROCEDURE LOAD_LIVELLI_PIANO_SPECIFICO_SB
*****************************************

	LPARAMETERS _PJ_PRGPRD1
	
	DO LOAD_U_PRD_D1_SB WITH _PJ_PRGPRD1
	
	*DO LOAD_U_PRD_D2 WITH _PJ_PRGPRD1
	
	DO LOAD_U_PRD_D3_SB WITH _PJ_PRGPRD1
	
	DO LOAD_U_PRD_D4_SB WITH _PJ_PRGPRD1
	
	DO LOAD_U_PRD_D5_SB WITH _PJ_PRGPRD1

	*DO LOAD_DATE WITH _PJ_PRGPRD1
	
	RETURN
	
	
	
**********************************************************
PROCEDURE LOAD_U_PRD_D1_SB
**********************************************************

	LPARAMETERS _PJ_PRGPRD1,_TIPO_RICERCA_PIANI,_ALIAS
	
	*** cancella i dati di U_PRD_D1 
	***
	IF USED("CUR_U_PRD_D1")
		TABLEREVERT(.T.,"CUR_U_PRD_D1")
	ENDIF
	
	IF PCOUNT() >= 2
	ELSE
	   _TIPO_RICERCA_PIANI = 1
	ENDIF
	
	IF EMPTY(ALLTRIM(_PJ_PRGPRD1))
		IF _TIPO_RICERCA_PIANI = 1
			x_cond = "1=1"
		ELSE
			x_cond = "1=0"
		ENDIF
	ELSE
	   x_cond = "PJ_PRGPRD1 = '" + ALLTRIM(_PJ_PRGPRD1) + "'"
	ENDIF
	
	IF PCOUNT() >= 3
	ELSE
		_ALIAS="U_PRD_D1"
	ENDIF
		
	cSql = "select * from U_PRD_D1 where " + x_cond + " ORDER BY PR1_NUMPIA,PR1_DATPIA"
	IF !ExecCommand(cSql,_ALIAS)
		return(.f.)
	ENDIF

	RETURN
	
	
**********************************************************
PROCEDURE LOAD_U_PRD_D3_SB
**********************************************************
	
	LPARAMETERS _PJ_PRGPRD1,_ALIAS
	
	IF PCOUNT()=1
		_ALIAS="U_PRD_D3"
	ENDIF
			
	cSql = "select SPACE(10) AS SELEZIONE, * from U_PRD_D3 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' ORDER BY PJ_PRGPRD2,PJ_PRGPRD3"
	IF !ExecCommand(cSql,_ALIAS)
		return(.f.)
	ENDIF

	RETURN

**********************************************************
PROCEDURE LOAD_U_PRD_D4_SB
**********************************************************
	LPARAMETERS _PJ_PRGPRD1,_ALIAS
	
	IF PCOUNT()=1
		_ALIAS="U_PRD_D4"
	ENDIF
		
	cSql = "select SPACE(10) AS SELEZIONE, * from U_PRD_D4 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' ORDER BY PJ_PRGPRD2,PJ_PRGPRD3,PJ_PRGPRD4"
	IF !ExecCommand(cSql,_ALIAS)
		return(.f.)
	ENDIF
	
	_ALIAS_RIBOBINATURA = _ALIAS + "_R"
	cSql = "select SPACE(10) AS SELEZIONE, * from U_PRD_DR where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' ORDER BY PJ_PRGPRD2,PJ_PRGPRD3,PJ_PRGPRD4"
	IF !ExecCommand(cSql,_ALIAS_RIBOBINATURA)
		return(.f.)
	ENDIF
	SELECT &_ALIAS_RIBOBINATURA
	GO TOP
	SCAN
	   SCATTER MEMVAR MEMO
	   SELECT &_ALIAS
	   APPEND BLANK
	   M.PJ_PRGPRD1 = M.PJ_PRGPRD1 
	   M.PJ_PRGPRD2 = M.PJ_PRGPRD2 
	   M.PJ_PRGPRD3 = M.PJ_PRGPRD3 
	   M.PJ_PRGPRD4 = M.PJ_PRGPRDR 
	   M.PR4_CODART = M.PRR_CODART 
	   M.PR4_DESART = M.PRR_DESART 
	   M.PR4_UNIMIS = M.PRR_UNIMIS 
	   M.PJ_PATTERN = M.PJ_PATTERN
	   M.PR4_PROGRE = M.PRR_PROGRE 
	   M.PR4_ALTEZZ = M.PRR_ALTEZZ 
	   M.PR4_LUNGHE = M.PRR_LUNGHE 
	   M.PR4_SPESSO = M.PRR_SPESSO 
	   M.PR4_CODINT = M.PRR_CODINT 
	   M.PR4_ALTCAR = M.PRR_ALTCAR 
	   M.PR4_LUNCAR = M.PRR_LUNCAR 
	   M.PR4_SPECAR = M.PRR_SPECAR 
	   M.PR4_DATAVA = M.PRR_DATAVA 
	   M.PR4_ORAAVA = M.PRR_ORAAVA 
	   M.PR4_CODEVE = M.PRR_CODEVE 
	   M.PR4_QUALIT = M.PRR_QUALIT 
	   M.PR4_GRAMMA = M.PRR_GRAMMA 
	   M.PR4_NRTTAG = M.PRR_NRTTAG 
	   M.PR4_FORTAG = M.PRR_FORTAG 
	   M.PR4_DARIBO = .T.
	   M.PR4_RIBOBI = M.PRR_RIBOBI 
	   M.PR4_DAMCRF = M.PRR_DAMCRF 
	   M.PR4_NONCON = M.PRR_NONCON 
	   M.PR4_NOTE = M.PRR_NOTE 
	   M.PR4_FLGVIEW = M.PRR_FLGVIEW 
	   M.PR4_FLGMULTI = M.PRR_FLGMULTI 
	   M.PR4_NUMSEZRAGG = M.PRR_NUMSEZRAGG 
	   M.PR4_INMAGA = M.PRR_INMAGA 
	   M.PR4_NPRGTG = M.PRR_NPRGTG 
	   M.PR4_DPRGTG = M.PRR_DPRGTG 
	   M.PR4_OPRGTG = M.PRR_OPRGTG 
	   M.PR4_DATVAR = M.PRR_DATVAR 
	   M.PR4_ORAVAR = M.PRR_ORAVAR 
	   M.PR4_CODOPV = M.PRR_CODOPV 
	   M.PR4_DESOPV = M.PRR_DESOPV 
	   M.PR4_SCARTO = M.PRR_SCARTO 
	   GATHER MEMVAR MEMO
	ENDSCAN

	RETURN
	
**********************************************************
PROCEDURE LOAD_U_PRD_D5_SB
**********************************************************
	
	LPARAMETERS _PJ_PRGPRD1,_ALIAS
	
	IF PCOUNT()=1
		_ALIAS="U_PRD_D5"
	ENDIF
		
	cSql = "select SPACE(10) AS SELEZIONE, * from U_PRD_D5 where PJ_PRGPRD1='"+ALLTRIM(_PJ_PRGPRD1)+"' ORDER BY PJ_PRGPRD2,PJ_PRGPRD3,PJ_PRGPRD4,PJ_PRGPRD5"
	IF !ExecCommand(cSql,_ALIAS)
		return(.f.)
	ENDIF

	RETURN
	
**********************************************************
PROCEDURE UNLOAD_U_PRD_D1345_SB
**********************************************************

IF USED("U_PRD_D1")
	SELECT U_PRD_D1
	USE
ENDIF
IF USED("U_PRD_D3")
	SELECT U_PRD_D3
	USE
ENDIF
IF USED("U_PRD_D4")
	SELECT U_PRD_D4
	USE
ENDIF
IF USED("U_PRD_D5")
	SELECT U_PRD_D5
	USE
ENDIF
IF USED("U_PRD_DR")
	SELECT U_PRD_DR
	USE
ENDIF

IF USED("CUR_U_PRD_D1")
	SELECT CUR_U_PRD_D1
	USE
ENDIF
IF USED("CUR_U_PRD_D3")
	SELECT CUR_U_PRD_D3
	USE
ENDIF
IF USED("CUR_U_PRD_D4")
	SELECT CUR_U_PRD_D4
	USE
ENDIF
IF USED("CUR_U_PRD_D5")
	SELECT CUR_U_PRD_D5
	USE
ENDIF
IF USED("CUR_U_PRD_D4_R")
	SELECT CUR_U_PRD_D4_R
	USE
ENDIF
	
RETURN