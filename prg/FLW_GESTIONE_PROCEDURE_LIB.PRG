**********************************************************
PROCEDURE LOAD_FLOW_BLOCCHI
**********************************************************

	LPARAMETERS _PARA_ID_PROCEDURA,_ALIAS

	LOCAL _CONDIZIONI_DI_RICERCA_SU_UTENTE,_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE,_CONDIZIONI_DI_RICERCA_SU_DATA_INIZIO,_CONDIZIONI_DI_RICERCA_SU_DATA_FINE
	
	_CONDIZIONI_DI_RICERCA_SU_UTENTE=""
	IF !EMPTY(_RIC_USER)		
		_CONDIZIONI_DI_RICERCA_SU_UTENTE= _CONDIZIONI_DI_RICERCA_SU_UTENTE + " AND STE.USERID LIKE '%"+ALLTRIM(_RIC_USER)+"%' "
	ENDIF
	
	_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE=""
	IF _V_OPZ_RIC_FATTE=1
		_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE=_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE+" (STE.DATA_FINE IS NOT NULL OR STE.DATA_FINE !='')"
	ENDIF
	
	IF _V_OPZ_RIC_DA_FARE=1
		IF !EMPTY(_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE)
			_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE=_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE+" OR "
		ENDIF
		_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE=_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE+" STE.DATA_INIZIO IS NULL "
	ENDIF

	IF _V_OPZ_RIC_ESECUZIONE=1
		IF !EMPTY(_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE)
			_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE=_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE+" OR "
		ENDIF
		_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE=_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE+" (STE.DATA_INIZIO IS NOT NULL AND STE.DATA_FINE ='') "
	ENDIF
		
	IF !EMPTY(_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE)
		_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE=" AND (1=0 OR "+_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE+")"
	ELSE
		_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE=" AND 1=0"
	ENDIF	
	
	_CONDIZIONI_DI_RICERCA_SU_DATA_INIZIO=""
	
	IF _V_OPZ_RIC_DA_FARE=0
		IF !EMPTY(_RIC_DATA_DAL)
			_CONDIZIONI_DI_RICERCA_SU_DATA_INIZIO=_CONDIZIONI_DI_RICERCA_SU_DATA_INIZIO+" AND STE.DATA_INIZIO >= '"+RIBALTA2(_RIC_DATA_DAL)+"' "
		ENDIF
		
		IF !EMPTY(_RIC_DATA_AL)
			_CONDIZIONI_DI_RICERCA_SU_DATA_INIZIO=_CONDIZIONI_DI_RICERCA_SU_DATA_INIZIO+" AND STE.DATA_INIZIO <= '"+RIBALTA2(_RIC_DATA_AL)+"' "
		ENDIF
		
		_CONDIZIONI_DI_RICERCA_SU_DATA_FINE=""
		IF !EMPTY(_RIC_DATA_FINE_DAL)
			_CONDIZIONI_DI_RICERCA_SU_DATA_FINE=_CONDIZIONI_DI_RICERCA_SU_DATA_FINE+" AND STE.DATA_FINE >= '"+RIBALTA2(_RIC_DATA_FINE_DAL)+"' "
		ENDIF
		
		IF !EMPTY(_RIC_DATA_FINE_AL)
			_CONDIZIONI_DI_RICERCA_SU_DATA_FINE=_CONDIZIONI_DI_RICERCA_SU_DATA_FINE+" AND STE.DATA_FINE <= '"+RIBALTA2(_RIC_DATA_FINE_AL)+"' "
		ENDIF
	ENDIF
		
	
	IF PCOUNT()=1
		_ALIAS="GEST_FLOW_BLOCCHI"
	ENDIF
			
	*** SELEZIONO I BLOCCHI E GLI STEPS IN UN UNICO CURSOR
	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
		SELECT	BLO.ID_PROCEDURA AS ID_PROCEDURA,
			PRO.DESCRIZIONE AS DESCRIZIONE,
			PRO.CODATTIV AS CODATTIV,
			COALESCE(PAR.DESCRI,'') AS DESATTIV,
			PRO.CODCLI AS CODCLI,
			COALESCE(CLI.CLI_RAGSOC,'') AS RAGSOC,
			BLO.NR_BLOCCO AS NR_BLOCCO,
			BLO.NOME AS ID_BLOCCO,
			SUBSTRING(BLO.TESTO,1,100) AS TESTO,
			COALESCE(STE.DATA_INIZIO,'') AS DATA_INIZIO,
			COALESCE(STE.ORA_INIZIO,'') AS ORA_INIZIO,
			COALESCE(STE.DATA_FINE,'') AS DATA_FINE,
			COALESCE(STE.ORA_FINE,'') AS ORA_FINE,
			COALESCE(STE.USERID,'') AS USERID 
		FROM FLOW_BLOCCHI AS BLO 
		LEFT OUTER JOIN FLOW_STEPS AS STE 
		ON BLO.NOME= STE.ID_BLOCCO AND BLO.ID_PROCEDURA= STE.ID_PROCEDURA
		LEFT OUTER JOIN FLOW_PROCEDURE AS PRO 
		ON BLO.ID_PROCEDURA= PRO.ID_PROCEDURA 
		LEFT OUTER JOIN U_CLI_AN AS CLI  
		ON PRO.CODCLI= CLI.CLI_CODCLI
		LEFT OUTER JOIN PARA AS PAR  
		ON PAR.CODICE= 'AST'+PRO.CODATTIV 
		WHERE BLO.ID_PROCEDURA='<<_PARA_ID_PROCEDURA>>' <<_CONDIZIONI_DI_RICERCA_SU_UTENTE>> <<_CONDIZIONI_DI_RICERCA_SU_ESECUZIONE>> <<_CONDIZIONI_DI_RICERCA_SU_DATA_INIZIO>>
		ORDER BY BLO.NR_BLOCCO,STE.DATA_INIZIO,STE.ORA_INIZIO 
	ENDTEXT					&& FINE SCRITTURA QUERY
	
	IF !ExecPreparedCommand(cSql,_ALIAS)
		return(.f.)
	ENDIF	


* PROCEDURE LOAD_FLOW_BLOCCHI
**********************************************************	

**********************************************************
PROCEDURE COPIA_CURSORE_IN_ALTRO_CURSORE
**********************************************************
* SINTASSI:
*
* COPIA_CURSORE_IN_ALTRO_CURSORE(<<_CURSORE_PARTENZA>>,<<_CURSORE_ARRIVO>>)
*
* COPIA TUTTE LE RIGHE DI _CURSORE_PARTENZA IN _CURSORE_ARRIVO
* PRIMA CANCELLA I DATI IN _CURSORE_ARRIVO
**********************************************************

	LPARAMETERS _CURSORE_PARTENZA,_CURSORE_ARRIVO

	LOCAL _SWWS

	_SWWS=SELECT()


	SELECT &_CURSORE_ARRIVO
	DELETE ALL
	
	SELECT &_CURSORE_PARTENZA
	GO TOP
	
	DO WHILE !EOF()
		
		SCATTER MEMVAR
		
		IF _CURSORE_PARTENZA="GEST_FLOW_BLOCCHI"
			M.DATA_INIZIO=RIBALTA2(M.DATA_INIZIO)
			M.DATA_FINE=RIBALTA2(M.DATA_FINE)
		ENDIF
		
		SELECT &_CURSORE_ARRIVO
		APPEND BLANK
		GATHER MEMVAR
	
		SELECT  &_CURSORE_PARTENZA
		SKIP
	ENDDO
	
	SELECT &_CURSORE_ARRIVO
	GO TOP

	SELECT(_SWWS)
	RETURN
	
* PROCEDURE COPIA_CURSORE_IN_ALTRO_CURSORE
**********************************************************

**********************************************************
PROCEDURE REFRESH_CURSORE_GRIGLIA
**********************************************************
	LPARAMETERS _ALIAS

	
	COPIA_CURSORE_IN_ALTRO_CURSORE(_ALIAS,"CUR_"+_ALIAS)

* PROCEDURE REFRESH_CURSORE_GRIGLIA
**********************************************************

**********************************************************
PROCEDURE FLW_CREA_CURSORI_GRIGLIE
**********************************************************
CREATE CURSOR CUR_GEST_FLOW_PROCEDURE (;
	ID_PROCEDURA C(20) ,;
	ID_PROCEDURA_PADRE C(20) ,;
	DESCRIZIONE C(100),;
	CODCLI C(16) ,;
	RAGSOC C(50) ,;
	CODATTIV C(5) ,;
	DESATTIV C(30) ,;
	DATA_ULTAGG C(10),;
	ORA_ULTAGG C(8),;
	SELEZIONE C(1) )
	

CREATE CURSOR CUR_GEST_FLOW_BLOCCHI (;
	ID_PROCEDURA C(20) ,;
	ID_BLOCCO C(20) ,;
	NR_BLOCCO N(5,0),;
	ID_STEP C(20) ,;
	USERID C(30),;
	FLG_ESEGUITO L,;
	DATA_INIZIO C(10),;
	ORA_INIZIO C(8),;
	DATA_FINE C(10),;
	ORA_FINE C(8),;
	TESTO C(100))
	
	
* FLW_CREA_CURSORI
**********************************************************


**********************************************************
* Classe CheckBoxPerGrigliaProcedure
**********************************************************
DEFINE CLASS CheckBoxPerGrigliaProcedure AS CheckBox
	
    WIDTH = 18
    AUTOSIZE = .T.
    CAPTION = ""
    NAME = "CheckBoxPerGrigliaProcedure"

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
	
		LOCAL _POSIZIONE_ATTUALE

		SELECT (this.Parent.Parent.RECORDSOURCE)
		IF RECCOUNT()=0
			RETURN
		ENDIF
	
		SELECT (THIS.Parent.Parent.RecordSource) 
		IF EMPTY(SELEZIONE)
		
			_POSIZIONE_ATTUALE= RECNO()
			
			REPLACE SELEZIONE WITH SPACE(0) ALL
			
			GO _POSIZIONE_ATTUALE
			REPLACE SELEZIONE WITH THIS.Parent.Parent.SimboloSelezione
		ELSE
			REPLACE SELEZIONE WITH SPACE(0)
		ENDIF


		WITH this
			_ALIAS=.Parent.Parent.RecordSourceAlias
			SELECT &_ALIAS
			_RECNO=ALLTRIM(STR(RECNO()))
			* seleziona la casella corrente con un colore diverso
			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()="+_RECNO+",COLORE('ROSSO'),COLORE('BIANCO'))", "Column")
			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()="+_RECNO+", COLORE('GIALLO'),COLORE('NERO'))", "Column")
			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()="+_RECNO+",.T.,.F.)","Column") 
			
			.Parent.Parent.Refresh()
			
			SELECT &_ALIAS		
			_ID_PROCEDURA_SELEZIONATA=ALLTRIM(ID_PROCEDURA)
			LOAD_FLOW_BLOCCHI(_ID_PROCEDURA_SELEZIONATA)
			
			REFRESH_CURSORE_GRIGLIA("GEST_FLOW_BLOCCHI")
			
			.Parent.Parent.Parent.Refresh()
			SELECT &_ALIAS				
		ENDWITH
		
		
	ENDPROC
	*- FINE Metodo: Click
    ***************************

ENDDEFINE
*- FINE CLASSE CheckBoxPerGrigliaProcedure
**********************************************************


**********************************************************
* Classe CasellaDiTestoBlocchi
**********************************************************
DEFINE CLASS CasellaDiTestoBlocchi AS TestoPerGriglia
  		  
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
*- FINE CLASSE CasellaDiTestoBlocchi
**********************************************************



**********************************************************
* Classe CasellaData
**********************************************************
DEFINE CLASS CasellaData AS TestoPerGriglia
  		  
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
			.Format="DXXXXXXXXXX"
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
	
	***************************
	* Metodo 
	* Procedure Valid
	***************************
	PROCEDURE Valid
	
		IF THIS.ReadOnly=.T.
			RETURN(.T.)
		ENDIF
		
		IF EMPTY(USERID)
			RETURN(.T.)
		ENDIF
		
		IF ALLTRIM(USERID)!=ALLTRIM(PUB_CODOPE) AND !PUB_OK_LAB_PROCEDURE
			RETURN(.T.)
		ENDIF
		
		IF VALID_DATA(THIS.Value)
		   THIS.Value= OK_DATA(THIS.Value)
		   IF RIBALTA2(DATA_INIZIO)>RIBALTA2(DATA_FINE)
	 		   =MESSAGEBOX("Data inizio attività successiva alla data fine attività",48,"Attenzione")
	 		   RETURN(.F.)
	 	   ENDIF

		   RETURN(.T.)
		ELSE
		   WAIT WINDOW " Data non valida "
		   RETURN(.F.)
		ENDIF

		
	    RETURN(.T.)
	
	RETURN
	*- FINE Metodo: Valid
    ***************************

	***************************
	* Metodo 
	* Procedure GotFocus
	***************************
	PROCEDURE GotFocus
	
		IF THIS.ReadOnly=.T.
			RETURN
		ENDIF

		SELECT CUR_GEST_FLOW_BLOCCHI
		
		IF EMPTY(USERID)
			=MESSAGEBOX("Impossibile modificare i dati un'attivita' non ancora eseguita",48,"Attenzione")
			RETURN
		ENDIF
		
		IF ALLTRIM(USERID)!=ALLTRIM(PUB_CODOPE) AND !PUB_OK_LAB_PROCEDURE
			=MESSAGEBOX("Impossibile modificare i dati di un'altro utente",48,"Attenzione")
			RETURN
		ENDIF

	RETURN
	*- FINE Metodo: GotFocus
    ***************************
    			

    
ENDDEFINE
*- FINE CLASSE CasellaData
**********************************************************



**********************************************************
* Classe CasellaOra
**********************************************************
DEFINE CLASS CasellaOra AS TestoPerGriglia
  		  
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
			.InputMask="99:99:99"
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
	
	***************************
	* Metodo 
	* Procedure Valid
	***************************
	PROCEDURE Valid
	
		IF THIS.ReadOnly=.T.
			RETURN(.T.)
		ENDIF
		
		IF EMPTY(USERID)
			RETURN(.T.)
		ENDIF
		
		IF ALLTRIM(USERID)!=ALLTRIM(PUB_CODOPE) AND !PUB_OK_LAB_PROCEDURE
			RETURN(.T.)
		ENDIF
		
  	    RETURN(.T.)
	
	RETURN
	*- FINE Metodo: Valid
    ***************************

	***************************
	* Metodo 
	* Procedure GotFocus
	***************************
	PROCEDURE GotFocus
	
		IF THIS.ReadOnly=.T.
			RETURN
		ENDIF

		SELECT CUR_GEST_FLOW_BLOCCHI
		
		IF EMPTY(USERID)
			=MESSAGEBOX("Impossibile modificare i dati un'attivita' non ancora eseguita",48,"Attenzione")
			RETURN
		ENDIF
		
		IF ALLTRIM(USERID)!=ALLTRIM(PUB_CODOPE) AND !PUB_OK_LAB_PROCEDURE
			=MESSAGEBOX("Impossibile modificare i dati di un'altro utente",48,"Attenzione")
			RETURN
		ENDIF

	RETURN
	*- FINE Metodo: GotFocus
    ***************************
    			

    
ENDDEFINE
*- FINE CLASSE CasellaOra
**********************************************************


**********************************************************
* Classe CasellaProcedure
**********************************************************
DEFINE CLASS CasellaProcedure AS TestoPerGriglia
  		  
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
			_POSIZIONE_ATTUALE=RECNO()
			
			REPLACE SELEZIONE WITH SPACE(0) ALL
				
			GO _POSIZIONE_ATTUALE
			REPLACE SELEZIONE WITH THIS.Parent.Parent.SimboloSelezione
			
			_RECNO=ALLTRIM(STR(_POSIZIONE_ATTUALE))
			* seleziona la casella corrente con un colore diverso
			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()="+_RECNO+",COLORE('ROSSO'),COLORE('BIANCO'))", "Column")
			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()="+_RECNO+", COLORE('GIALLO'),COLORE('NERO'))", "Column")
			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()="+_RECNO+",.T.,.F.)","Column") 
			.Parent.Parent.Refresh()
					
			SELECT &_ALIAS		
			_ID_PROCEDURA_SELEZIONATA=ALLTRIM(ID_PROCEDURA)
			LOAD_FLOW_BLOCCHI(_ID_PROCEDURA_SELEZIONATA)
			
			REFRESH_CURSORE_GRIGLIA("GEST_FLOW_BLOCCHI")
			
			.Parent.Parent.Parent.Refresh()
			SELECT &_ALIAS	
			
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
*- FINE CLASSE CasellaDiTestoPerProcedure
**********************************************************