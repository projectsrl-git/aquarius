
**********************************************************
* Classe IntestazionePerBrowseviewOrdinata
**********************************************************
DEFINE CLASS IntestazionePerBrowseviewOrdinata AS HEADER

	AlreadyOrdered=.F.
	OrderAscending=.F.
    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
	
		LOCAL 	_ALIAS,;
				_TAG_NAME,;
                _SWWS
                
		_SWWS=SELECT()
				
	    IF !_PUB_ABILITA_ORDINAMENTO_CAMPI
			RETURN
	    ENDIF
    
        WITH THIS
        
			IF .PARENT.CONTROLSOURCE='SELEZIONE'
				RETURN
			ENDIF
			
			_ALIAS=.PARENT.PARENT.RECORDSOURCE 	
			
        	IF !(ALLTRIM(.PARENT.CONTROLSOURCE) $ _PUB_ORDINAMENTO)
        		
        		_TYPE=TYPE(.PARENT.CONTROLSOURCE)
        	
        		IF _TYPE="C" OR _TYPE="N"
        		        	
					SELECT &_ALIAS
					IF !EMPTY(_PUB_ORDINAMENTO)
						DELETE TAG _TMPINDEX
					ENDIF
        		
        			IF _TYPE="C" 
						_PUB_ORDINAMENTO=_PUB_ORDINAMENTO+IIF(EMPTY(ALLTRIM(_PUB_ORDINAMENTO)),"","+")+"SUBSTR("+ALLTRIM(.PARENT.CONTROLSOURCE)+",1,20)"
						_NUMERO_CAMPI_INDICE=OCCURS("+",_PUB_ORDINAMENTO)+1
					ENDIF
					
					IF _TYPE="N"
						_LUNGHEZZA_CAMPO=20
						_PUB_ORDINAMENTO=_PUB_ORDINAMENTO+IIF(EMPTY(ALLTRIM(_PUB_ORDINAMENTO)),"","+")+"STR_FILL_ZERO("+ALLTRIM(.PARENT.CONTROLSOURCE)+","+ALLTRIM(STR(_LUNGHEZZA_CAMPO))+")"
						_NUMERO_CAMPI_INDICE=OCCURS("+",_PUB_ORDINAMENTO)+1
					ENDIF
						
					SELECT BRWVORD
					APPEND BLANK
					REPLACE CAMPO WITH ALLTRIM(.PARENT.CONTROLSOURCE)
					REPLACE HEADER WITH ALLTRIM(.PARENT.PARENT.NAME)+"."+ALLTRIM(.PARENT.NAME)+"."+ALLTRIM(.NAME)
					REPLACE CAPTORIG WITH .Caption
					REPLACE BACKORIG WITH .BackColor
					REPLACE FOREORIG WITH .ForeColor
					
					.BackColor=RGB(255,255,0)
					.ForeColor=RGB(0,0,0)
					.Caption="("+ALLTRIM(STR(_NUMERO_CAMPI_INDICE))+") "+ALLTRIM(.Caption)
					.Parent.Width=.Parent.Width+3
					
				ENDIF
        		
			ENDIF
			
			SELECT &_ALIAS
			
			IF .OrderAscending
				INDEX ON &_PUB_ORDINAMENTO TAG _TMPINDEX DESC
				.OrderAscending=.F.
			ELSE
				INDEX ON &_PUB_ORDINAMENTO TAG _TMPINDEX 
				.OrderAscending=.T.
			ENDIF
			
			SET ORDER TO _TMPINDEX
			.PARENT.PARENT.REFRESH()
			
		ENDWITH
		
		
	    SELECT(_SWWS)
		
	ENDPROC
    *- FINE Metodo: Click
    ***************************	

    
ENDDEFINE
*- FINE CLASSE Intestazione
**********************************************************


**********************************************************
* Classe CasellaDiTestoPerGrigliaOrdinata
**********************************************************
DEFINE CLASS CasellaDiTestoPerGrigliaOrdinata AS TestoPerGriglia
  		  
    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click

	
		WITH this
			.Parent.Parent.DefaultClick()
			IF !.alreadyClick
				.Parent.Parent.VerificaSelezioneMultipla()
				.alreadyClick=.T.
				.clickTime=SECONDS()
			ELSE
				.alreadyClick=.F.
				IF (SECONDS()-.clickTime)*100<40
					IF .Parent.Parent.StatoSelezioneMultipla>0
						***MESSAGEBOX("Prima di effettuare un'operazione di pagamento o trasferimento disattivare la selezione multipla",48,"Attenzione!")
					ELSE
						.DblClick()	
					ENDIF	
				ELSE
					.Parent.Parent.VerificaSelezioneMultipla()
				ENDIF
			ENDIF
		ENDWITH
		
	ENDPROC
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
		WITH this
		

			* seleziona tutte le caselle selezionate con un colore diverso
			* e....
			* seleziona la casella corrente con un colore diverso
			* anche se non ho selezionato nulla questa la devo selezionare comunque
			IF .Parent.Parent.AbilitaSelezione
				REPLACE SELEZIONE WITH .Parent.Parent.SimboloSelezione
				.Parent.Parent.SetAll("DynamicBackColor","IIF(!EMPTY(SELEZIONE) OR RECNO()=VAL(THIS.TAG), COLORE('ROSSO'),COLORE('GRIGIO_CHIARO'))", "Column")
				.Parent.Parent.SetAll("DynamicForeColor","IIF(!EMPTY(SELEZIONE) OR RECNO()=VAL(THIS.TAG), COLORE('GIALLO'),COLORE('GRIGIO'))", "Column")
				.Parent.Parent.SetAll("DynamicFontBold","IIF(!EMPTY(SELEZIONE) OR RECNO()=VAL(THIS.TAG),.T.,.F.)","Column") 
			ELSE			
	 			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()=VAL(THIS.TAG), COLORE('ROSSO'),COLORE('GRIGIO_CHIARO'))", "Column")
	 			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()=VAL(THIS.TAG), COLORE('GIALLO'),COLORE('GRIGIO'))", "Column")
	 			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()=VAL(THIS.TAG),.T.,.F.)","Column") 
			ENDIF			
		
			
				
			.Parent.Parent.StatoTransazioneCelle()
			.Parent.Parent.Refresh()
		ENDWITH
	ENDPROC
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaDiTestoPerGrigliaOrdinata
**********************************************************





**********************************************************
* Classe TestoPerGrigliaOrdinata
**********************************************************
DEFINE CLASS TestoPerGrigliaOrdinata AS TextBox
	alreadyClick=.F.
	clickTime=0
	
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
			.SelectedBackColor=RGB(255,0,0)
			.SelectedForeColor=RGB(255,255,255)
			.DisabledBackColor=RGB(255,0,0)
			.DisabledForeColor=RGB(255,255,255)
		ENDWITH	

	ENDPROC
	*- FINE Metodo: Init
    ***************************

    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
		THIS.Parent.Parent.DefaultClick()
		THIS.Parent.Parent.VerificaSelezioneMultipla()
		THIS.FontBold=.T.
		
	ENDPROC
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick

	ENDPROC
	*- FINE Metodo: DblClick
    ***************************

ENDDEFINE
*- FINE CLASSE TestoPerGrigliaOrdinata
**********************************************************