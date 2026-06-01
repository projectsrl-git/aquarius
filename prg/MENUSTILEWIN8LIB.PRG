
DEFINE CLASS shape_termina AS shape

	PROCEDURE click	
		_RISP = MESSAGEBOX("Uscire dal sistema informativo Aquarius?",4+32,"Attenzione")
		IF _RISP = 6
		ELSE
		   RETURN
		ENDIF

		RELEASE THISFORM
		CLEAR EVENTS
	ENDPROC
	
	PROCEDURE mouseenter
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		this.BorderStyle= 1
		THIS.Parent.LAbel1.ForeColor = RGB(255,255,255)
	ENDPROC
	
	PROCEDURE mouseleave
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		this.BorderStyle= 0
		THIS.Parent.LAbel1.FORECOLOR = RGB(255,255,255)
	ENDPROC	
	
ENDDEFINE


DEFINE CLASS shape_bottone_aggiuntivo AS shape

	PROCEDURE click
		
		IF EMPTY(THIS.Parent.TAG)
			RETURN
		ENDIF
		
		DO NASCONDI_MENU_SU_SCREEN
		
		_par_command_string = ALLTRIM(THIS.Parent.TAG)
		&_par_command_string
		
		DO MOSTRA_MENU_SU_SCREEN
		
	ENDPROC
	
	PROCEDURE mouseenter
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		this.BorderStyle= 1
		THIS.Parent.LAbel1.ForeColor = RGB(255,255,255)
	ENDPROC
	
	PROCEDURE mouseleave
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		this.BorderStyle= 0
		THIS.Parent.LAbel1.FORECOLOR = RGB(255,255,255)
	ENDPROC	
	
ENDDEFINE


DEFINE CLASS shape_bottone_opzioni_menu AS shape

	PROCEDURE click
		
		_choice = 0
		DEFINE POPUP generatePop SHORTCUT RELATIVE FROM MROW(),MCOL()
		DEFINE BAR 1 OF generatePop PROMPT "\<Ripristina colore di sfondo voci di menu"
		DEFINE BAR 2 OF generatePop PROMPT "\<Mostra voci di menu nascoste"
		DEFINE BAR 3 OF generatePop PROMPT "\<Ripristina posizione originale voci di menu"
		ON SELECTION BAR 1 OF generatePop _choice = 1
		ON SELECTION BAR 2 OF generatePop _choice = 2
		ON SELECTION BAR 3 OF generatePop _choice = 3

		ACTIVATE POPUP generatePop

		DO CASE
					
			CASE _choice = 1
				
				_RISP = MESSAGEBOX("Ripristinare il colore di sfondo di tutte le voci di menu?",4+32,"Attenzione")
				IF _RISP = 6
				ELSE
					RETURN .F.
				ENDIF
				x_user = "CODOPE = '" + PUB_CODOPE + "'"
				x_cond = x_user
				cSql   = "UPDATE USER_MENU SET CMDBCKCOL = 0 WHERE " + x_cond
				IF !ExecCommand(cSql,"UPD_USER_MENU")
				  return(.f.)
				ENDIF
								
				FOR I=1 TO 24
					_cCommandExist = "TYPE('THIS.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+"') == 'O'"
					IF &_cCommandExist
						_cmdResetBckcol = "THIS.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+".Shape1.Tag"  && QUESTA VARIABILE CONTIENE IL COMANDO DELL'IMPOSTAZIONE DEL COLORE DI DEFAULT
						_cResetBckcol = &_cmdResetBckcol
						&_cResetBckcol
					ENDIF
				NEXT
				
				THIS.Parent.Parent.Refresh
				
			CASE _choice = 2
				
				_RISP = MESSAGEBOX("Mostrare tutte le voci di menu nascoste per il menu in linea?",4+32,"Attenzione")
				IF _RISP = 6
				ELSE
					RETURN .F.
				ENDIF
								
				FOR I=1 TO 24
				
					_cCommandExist = "TYPE('THIS.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+"') == 'O'"
					IF &_cCommandExist
						_cMenu = "__MENU = this.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+".menu"
						&_cMenu
						_cLabel = "__LABEL = this.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+".label"
						&_cLabel
						x_user = "CODOPE = '" + PUB_CODOPE + "'"
						x_menu = "MENU = '" + __MENU + "'"
						x_labl = "LABEL = '" + __LABEL + "'"
						x_cond = x_user + " and " + x_menu + " and " + x_labl 
						cSql   = "UPDATE USER_MENU SET HIDDEN = 0 WHERE " + x_cond
						IF !ExecCommand(cSql,"UPD_USER_MENU")
						  return(.f.)
						ENDIF
						
						_cCommandShow = "THIS.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+".Visible = .T."
						&_cCommandShow
					ENDIF
				NEXT
				
				THIS.Parent.Parent.Refresh
				
			CASE _choice = 3
				
				_RISP = MESSAGEBOX("Ripristinare la posizione di tutte le voci per il menu in linea?",4+32,"Attenzione")
				IF _RISP = 6
				ELSE
					RETURN .F.
				ENDIF
				
				FOR I=1 TO 24
				
					_cCommandExist = "TYPE('THIS.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+"') == 'O'"
					IF &_cCommandExist
						_cMenu = "__MENU = this.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+".menu"
						&_cMenu	
						_cLabel = "__LABEL = this.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+".label"
						&_cLabel
						x_user = "CODOPE = '" + PUB_CODOPE + "'"
						x_menu = "MENU = '" + __MENU + "'"
						x_labl = "LABEL = '" + __LABEL + "'"
						x_cond = x_user + " and " + x_menu + " and " + x_labl 
						cSql   = "UPDATE USER_MENU SET CMDLEFT=0, CMDTOP=0 WHERE " + x_cond
						IF !ExecCommand(cSql,"UPD_USER_MENU")
						  return(.f.)
						ENDIF
						
						_cmdResetLeft = "THIS.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+".Left = THIS.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+".Original_Left"
						&_cmdResetLeft

						_cmdResetTop = "THIS.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+".Top = THIS.Parent.Parent.CmdContainer"+ALLTRIM(STR(I))+".Original_Top"
						&_cmdResetTop
						
					ENDIF
										
				NEXT
				
				THIS.Parent.Parent.Refresh
				
			OTHERWISE
				
				RETURN .F.

		ENDCASE
		
		*** ELIMINO RIGHE DI PERSONALIZZAZIONE NON CONTENENTI DATI SIGNIFICATIVI PER SFOLTIRE LA TABELLA
		IF _choice = 1 OR _choice = 2 OR _choice = 3
			x_user = "CODOPE = '" + PUB_CODOPE + "'"
			x_empt = "CMDBCKCOL=0 AND HIDDEN=0 AND CMDLEFT=0 AND CMDTOP=0"
			x_cond = x_user + " and " + x_empt 
			cSql   = "DELETE FROM USER_MENU WHERE " + x_cond
			IF !ExecCommand(cSql,"DEL_USER_MENU")
			  return(.f.)
			ENDIF
		ENDIF
		
	ENDPROC
	
	PROCEDURE mouseenter
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		this.BorderStyle= 1
		*THIS.Parent.LAbel1.ForeColor = RGB(255,255,255)
	ENDPROC
	
	PROCEDURE mouseleave
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		this.BorderStyle= 0
		*THIS.Parent.LAbel1.FORECOLOR = RGB(255,255,255)
	ENDPROC	
	
ENDDEFINE


PROCEDURE COMPONI_MENU_SU_SCREEN


*!*			=IMPOSTA_BACKGROUND_MENU_WIN8_E_SUCCESSIVI()


*!*			THISFORM.WindowState = 2  && MAXIMIZED
*!*			THISFORM.Picture = PUB_DINDIR+PUB_DESKTOP

RELEASE PUB_DESBAR1,PUB_DESBAR1_PRECEDENTE,pub_desbar2,_MAIN_MENU_RETURN
PUBLIC PUB_DESBAR1,PUB_DESBAR1_PRECEDENTE,pub_desbar2,_MAIN_MENU_RETURN
PUB_DESBAR1 = "Menu principale"
PUB_DESBAR1_PRECEDENTE = ""
pub_desbar2 = "Esercizio contabile: " + PUB_ANNO + " - " + "Aquarius by Project - " + PUB_NOMOPE
_MAIN_MENU_RETURN = .F.
	
RELEASE _NUMERO_TASTI_CREATI
PUBLIC _NUMERO_TASTI_CREATI
_NUMERO_TASTI_CREATI = 0

PUB_LUMAX = 0
PUB_ARCH  = "CUR_TMENUL1"	&& CURSORE DEL PRIMO LIVELLO DEL MENU DOPO LA VERIFICA DELLE ABILITAZIONI PER L'OPERATORE CORRENTE


RELEASE PUB_SUBMENU_ATTIVO 
PUBLIC PUB_SUBMENU_ATTIVO 
PUB_SUBMENU_ATTIVO = .F.

_cWidthPulsantiMenuWin8  = "150"
_cHeightPulsantiMenuWin8 = "120"


SET CLASSLIB TO "cmdclass.vcx" additive				&& ATTIVA LA CLASSE PER LA DEFINIZIONE DEL CONTAINER

_ctrTastiCol   = 0
_nDistanzaLeft = 0
_nDistanzaTop  = 0


SELECT &PUB_ARCH	&& ELABORA IL CURSORE DEL PRIMO LIVELLO DEL MENU DOPO LA VERIFICA DELLE ABILITAZIONI PER L'OPERATORE CORRENTE
SET ORDER TO 
SET FILTER TO VISIBILE = 'S'
GO TOP 

_PROGRESSIVO_CONTAINER = 0

SCAN

    IF VISIBILE <> 'S'
    	SELECT &PUB_ARCH
    	LOOP
    ENDIF
 
	IF _PROGRESSIVO_CONTAINER > 24
		EXIT
	ENDIF


	_PROGRESSIVO_CONTAINER = _PROGRESSIVO_CONTAINER +1
    _NUMERO_TASTI_CREATI   = _PROGRESSIVO_CONTAINER 

	_oNewCmdContainerName = "CmdContainer"+ALLTRIM(STR(_PROGRESSIVO_CONTAINER))								&& NOME OGGETTO

	_SCREEN.NEWOBJECT(_oNewCmdContainerName,"cmdclass")													&& CREA OGGETTO

	IF _PROGRESSIVO_CONTAINER  > 1 AND MOD(_PROGRESSIVO_CONTAINER -1,6) = 0									&& GESTISCE 6 TASTI PER RIGA
		_nDistanzaLeft = 0																					&& GESTISCE 6 TASTI PER RIGA
		_nDistanzaTop = _nDistanzaTop + VAL(_cHeightPulsantiMenuWin8) + 10									&& GESTISCE 6 TASTI PER RIGA
	ENDIF																									&& GESTISCE 6 TASTI PER RIGA

	_cLeft 			= "_SCREEN."+_oNewCmdContainerName+".left = " + ALLTRIM(STR(120 + _nDistanzaLeft))		&& DISTANZA TRA I TASTI LATO SINISTRO
	_cTop 			= "_SCREEN."+_oNewCmdContainerName+".Top = " + ALLTRIM(STR(63 + _nDistanzaTop))			&& DISTANZA TRA I TASTI LATO ALTO
	_cOriginal_Left = "_SCREEN."+_oNewCmdContainerName+".Original_Left = " + ALLTRIM(STR(120 + _nDistanzaLeft))
	_cOriginal_Top 	= "_SCREEN."+_oNewCmdContainerName+".Original_Top = " + ALLTRIM(STR(63 + _nDistanzaTop))
	_cWidth			= "_SCREEN."+_oNewCmdContainerName+".Width = " + _cWidthPulsantiMenuWin8				&& LARGHEZZA TASTO
	_cHeight		= "_SCREEN."+_oNewCmdContainerName+".Height = " + _cHeightPulsantiMenuWin8				&& ALTEZZA TASTO
	_cImageVisib	= "_SCREEN."+_oNewCmdContainerName+".Image1.Visible = .F."								&& IMMAGINE SFONDO VISIBILE
	_cShapeBckCo	= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(255,128,0)"				&& COLORE TASTO
	_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '0,0,255'"				&& COLORE AZZURRO PER LABEL E BORDO TASTO STANDARD INIZIALMENTE ALL'INGRESSO DEL FORM
	_cColoreLabel	= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"			&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

	*** IMPOSTA_COLORE_TASTI

	** VERIFICA SE UTENTE DESIDERA PERSONALIZZARE IL MENU

	SxxS=STR(SELECT())
	x_cond = "CODICE = '" + ALLTRIM(PUB_CODOPE) + "'"
	Csql   = "select * from res_oper where " + x_cond + " order by CODICE"
	IF !ExecCommand(cSql,"Res_Oper_cu_")
	   return(.f.)
	ENDIF
	SELECT Res_Oper_cu_
	GO TOP
	IF !EOF()

	 	M.RES_MENU_WIN8 = RES_MENU_WIN8 	
	 	M.RES_FULL_SCRE	= RES_FULL_SCRE		
	    M.RES_COLO_STAN = RES_COLO_STAN 	
	    M.RES_SFODESK 	= RES_SFODESK 		
	    M.RES_SFOPASS 	= RES_SFOPASS		
	    M.RES_SFOSUBM   = RES_SFOSUBM		
	    M.RES_SCRDESK 	= RES_SCRDESK 		
	    M.RES_SCRPASS 	= RES_SCRPASS 		
	    M.RES_COLTAST 	= RES_COLTAST 		
	    M.RES_TRASPTAST	= RES_TRASPTAST

	ELSE

	 	M.RES_MENU_WIN8 = .F.	
	 	M.RES_FULL_SCRE	= .F.	
	    M.RES_COLO_STAN = .F. 	
	    M.RES_SFODESK 	= 0 		
	    M.RES_SFOPASS 	= 0		
	    M.RES_SFOSUBM   = 0		
	    M.RES_SCRDESK 	= 0		
	    M.RES_SCRPASS 	= 0 		
	    M.RES_COLTAST 	= 0 		
	    M.RES_TRASPTAST	= .F.
	    	
	ENDIF
	
	IF M.RES_SFODESK > 0	&& SFONDO PERSONALIZZATO PER OPERATORE

		lnColor 			= M.RES_SFODESK
		lnBlue 				= INT(lnColor / (256^2))
		lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
		lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
		_RgbColor	 		= "RGB("+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+")"			
		_cColoreDesktop		= "_SCREEN.backcolor = "+_RgbColor
		&_cColoreDesktop
		_SCREEN.Picture 	= ""
		
		IF TYPE("_SCREEN.oBackImage") == "O"
			_SCREEN.oBackImage.Visible = .F.
		ENDIF		
		
	ENDIF

	IF  !M.RES_COLO_STAN AND  M.RES_COLTAST > 0		&& COLORE TASTI PERSONALIZZATI DA UTENTE

		lnColor 			= M.RES_COLTAST
		lnBlue 				= INT(lnColor / (256^2))
		lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
		lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
		_RgbColor	 		= "RGB("+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+")"
		_cShapeBckCo		= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = "+_RgbColor					&& COLORE TASTO PERSONALIZZATO

		lnColor 			= M.RES_SCRDESK
		lnBlue 				= INT(lnColor / (256^2))
		lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
		lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
		_mouseleave	 		= "'"+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+"'"
		_cColoreLabelStd	= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave ="+_mouseleave			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
		_cColoreLabel		= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"			&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO
		&_cColoreLabelStd
		&_cColoreLabel
		
	ELSE

		_ctrTastiCol =  _ctrTastiCol + 1

		DO CASE 
			
			CASE _ctrTastiCol = 1
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(255,128,0)"						&& COLORE TASTO ARANCIONE
				_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
				_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

			CASE _ctrTastiCol = 2
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

			CASE _ctrTastiCol = 3
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

			CASE _ctrTastiCol = 4
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
				_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
				_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

			CASE _ctrTastiCol = 5
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

			CASE _ctrTastiCol = 6
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
				_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
				_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

			CASE _ctrTastiCol = 7
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

			CASE _ctrTastiCol = 8
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
				_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
				_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

			CASE _ctrTastiCol = 9
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

			CASE _ctrTastiCol = 10
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

			CASE _ctrTastiCol = 11
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

			CASE _ctrTastiCol = 12
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(253,234,198)"					&& COLORE TASTO OCRA CHIARO

			CASE _ctrTastiCol = 13
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(187,255,119)"					&& COLORE TASTO VERDE CHIARETTO

			CASE _ctrTastiCol = 14
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

			CASE _ctrTastiCol = 15
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

			CASE _ctrTastiCol = 16
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
				_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
				_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

			CASE _ctrTastiCol = 17
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

			CASE _ctrTastiCol = 18
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

			CASE _ctrTastiCol = 19
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(251,237,66)"					&& COLORE TASTO GIALLINO

			CASE _ctrTastiCol = 20
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(187,255,119)"					&& COLORE TASTO VERDE CHIARETTO

			CASE _ctrTastiCol = 21
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

			CASE _ctrTastiCol = 22
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(0,132,66)"						&& COLORE TASTO VERDE SCURO

			CASE _ctrTastiCol = 23
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(251,237,66)"					&& COLORE TASTO GIALLINO

			CASE _ctrTastiCol = 24
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(255,128,0)"						&& COLORE TASTO ARANCIONE

			OTHERWISE
				_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(255,128,0)"						&& COLORE TASTO ARANCIONE
			
		ENDCASE
		
	ENDIF
	
	IF !M.RES_COLO_STAN AND M.RES_TRASPTAST
		_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.BackStyle = 0"  && SFONDO TASTO TRASPARENTE
	ENDIF


	SELECT &SxxS
																			&& ESEGUE COMANDO
	__LABEL			= ALLTRIM(LABEL)																		&& ETICHETTA RIGA COMANDO DA ESEGUIRE
	__MENU			= ALLTRIM(MENU)
	__COMANDO		= STRTRAN(ALLTRIM(COMANDO),"\submenu","\AQMENU")										&& COMANDO DA ESEGUIRE : SOSTITUISCO SUBMENU CON AQMENU
	__COMANDO		= STRTRAN(ALLTRIM(__COMANDO),"\SUBMENU","\AQMENU")										&& COMANDO DA ESEGUIRE : SOSTITUISCO SUBMENU CON AQMENU
	__DESCRIZION	= ALLTRIM(DESCRIZION)																	&& DESCRIZIONE RIGA COMANDO
	_cLabel			= "_SCREEN."+_oNewCmdContainerName+".label = __LABEL"
	_cMenu			= "_SCREEN."+_oNewCmdContainerName+".menu = __MENU"
	_cLblCaption	= "_SCREEN."+_oNewCmdContainerName+".Label1.Caption = __LABEL"							&&
	_cTag			= "_SCREEN."+_oNewCmdContainerName+".Tag = __COMANDO"									&& ESECUZIONE COMANDO
	_cShapeToolT	= "_SCREEN."+_oNewCmdContainerName+".ShapeClick.ToolTipText = __DESCRIZION"				&& MOSTRA NEL TOOLTIPTEXT LA DESCRIZIONE DELLA RIGA DI COMANDO
	_cRidimens		= "_SCREEN."+_oNewCmdContainerName+".ridimensiona()"									&&
	_cVisible 		= "_SCREEN."+_oNewCmdContainerName+".VISIBLE = .T."										&&
	_cResetBckcol	= "_SCREEN."+_oNewCmdContainerName+".Shape1.Tag = '" + _cShapeBckCo + "'"
	*_cShapeDragMode	= "_SCREEN."+_oNewCmdContainerName+".ShapeClick.OLEDragMode = 1"
	*_cShapeDropMode	= "_SCREEN."+_oNewCmdContainerName+".ShapeClick.OLEDropMode = 1"
	
	x_user = "CODOPE = '" + PUB_CODOPE + "'"
	x_menu = "MENU = '" + __MENU + "'"
	x_labl = "LABEL = '" + STRTRAN(__LABEL,"'","''") + "'"
	x_bckc = "CMDBCKCOL > 0"
	x_cond = x_user + " and " + x_menu + " and " + x_labl + " and " + x_bckc 
	cSql   = "SELECT CMDBCKCOL FROM USER_MENU WHERE " + x_cond
	IF !ExecCommand(cSql,"TMP_USER_MENU")
	  return(.f.)
	ENDIF
	SELECT TMP_USER_MENU
	GO TOP
	IF !EOF()
		_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.Backcolor = " + ALLTRIM(STR(CMDBCKCOL,10,0))
	ENDIF
	
	x_user = "CODOPE = '" + PUB_CODOPE + "'"
	x_menu = "MENU = '" + __MENU + "'"
	x_labl = "LABEL = '" + STRTRAN(__LABEL,"'","''") + "'"
	x_hide = "HIDDEN = 1"
	x_cond = x_user + " and " + x_menu + " and " + x_labl + " and " + x_hide 
	cSql   = "SELECT HIDDEN FROM USER_MENU WHERE " + x_cond
	IF !ExecCommand(cSql,"TMP_USER_MENU")
	  return(.f.)
	ENDIF
	SELECT TMP_USER_MENU
	GO TOP
	IF !EOF()
		_cVisible = "_SCREEN."+_oNewCmdContainerName+".VISIBLE = .F."
	ENDIF
	
	x_user = "CODOPE = '" + PUB_CODOPE + "'"
	x_menu = "MENU = '" + __MENU + "'"
	x_labl = "LABEL = '" + STRTRAN(__LABEL,"'","''") + "'"
	x_posi = "CMDLEFT+CMDTOP > 0"
	x_cond = x_user + " and " + x_menu + " and " + x_labl + " and " + x_posi
	cSql   = "SELECT CMDLEFT, CMDTOP FROM USER_MENU WHERE " + x_cond
	IF !ExecCommand(cSql,"TMP_USER_MENU")
	  return(.f.)
	ENDIF
	SELECT TMP_USER_MENU
	GO TOP
	IF !EOF()
		_cLeft = "_SCREEN."+_oNewCmdContainerName+".LEFT = " + ALLTRIM(STR(CMDLEFT))
		_cTop  = "_SCREEN."+_oNewCmdContainerName+".TOP = " + ALLTRIM(STR(CMDTOP))
	ENDIF
	
	&_cLabel
	&_cMenu
	&_cLeft																									&& ESEGUE COMANDO
	&_cTop																									&& ESEGUE COMANDO
	&_cOriginal_Left
	&_cOriginal_Top
	&_cWidth																								&& ESEGUE COMANDO
	&_cHeight																								&& ESEGUE COMANDO
	&_cImageVisib																							&& ESEGUE COMANDO
	&_cShapeBckCo																							&& ESEGUE COMANDO
	&_cColoreLabelStd 
	&_cColoreLabel
	&_cLblCaption																							&& ESEGUE COMANDO
	&_cTag																									&& ESEGUE COMANDO
	&_cShapeToolT																							&& ESEGUE COMANDO
	&_cRidimens																								&& ESEGUE COMANDO
	&_cVisible
	&_cResetBckcol
	*&_cShapeDragMode
	*&_cShapeDropMode
	
	_nDistanzaLeft = _nDistanzaLeft + VAL(_cWidthPulsantiMenuWin8) + 10										&& IL PROSSIMO TASTO PARTE 10 PIXEL A DESTRA

*!*		IF !EMPTY(LABEL)
*!*			_lblcaption = "thisform.label"+ALLTRIM(STR(RECNO()))+".caption"
*!*			_lblvisible = "thisform.label"+ALLTRIM(STR(RECNO()))+".visible"
*!*			_imgvisible = "thisform.image"+ALLTRIM(STR(RECNO()))+".visible"
*!*			_lblenabled = "thisform.label"+ALLTRIM(STR(RECNO()))+".enabled"
*!*			_lblleft	= "thisform.label"+ALLTRIM(STR(RECNO()))+".left"
*!*			_lblwidth	= "thisform.label"+ALLTRIM(STR(RECNO()))+".width"

*!*			_imgleft	= "thisform.imgNew"+ALLTRIM(STR(RECNO()))+".left"
*!*			_imgvisible	= "thisform.imgNew"+ALLTRIM(STR(RECNO()))+".visible"
*!*
*!*			&_lblcaption = ALLTRIM(label)
*!*			&_lblvisible = .t.
*!*
*!*			IF AUTORIZZAZIONE
*!*
*!*				** CONTROLLO SE FORM O PRG è AGGIORNATO O MENO
*!*				stringa = ALLTRIM(COMANDO)
*!*				_STRDO = STR_EXTRACT(COMANDO, SPACE(1), 1)
*!*				IF ALLTRIM(_STRDO) <> ""
*!*					_STRFRM = STR_EXTRACT(COMANDO, SPACE(1), 2)
*!*					IF UPPER(ALLTRIM(_STRFRM)) = "FORM"
*!*						_STRFORM = STR_EXTRACT(COMANDO, SPACE(1), 3)

*!*						******** CONTROLLO SE è AGGIORNATO
*!*
*!*						IF DAYLASTMOD( PUB_DIR + "\" + ALLTRIM(_STRFORM) + ".SCT" ) < PUB_DAYNEW
*!*							&_imgleft =  &_lblleft + &_lblwidth + 10
*!*							** controllo se è nuovo
*!*							&_imgvisible = .T.
*!*						ENDIF
*!*
*!*					ELSE
*!*						** CHECK PRG

*!*						IF DAYLASTMOD( PUB_DIR + "\" + ALLTRIM(_STRFRM) + ".PRG" ) < PUB_DAYNEW
*!*							&_imgleft =  &_lblleft + &_lblwidth + 10
*!*							** controllo se è nuovo
*!*							&_imgvisible = .T.
*!*						ENDIF
*!*
*!*					ENDIF
*!*				ENDIF
*!*			ELSE
*!*				&_lblenabled = .F.
*!*			ENDIF
*!*		ENDIF


ENDSCAN


*!*	*######### INIZIO TEST CON COMMAND BUTTON IN CONTAINER ANZICHE' SHAPES ########################################################################################################################
*!*	SCAN

*!*	    IF VISIBILE <> 'S'
*!*	    	SELECT &PUB_ARCH
*!*	    	LOOP
*!*	    ENDIF
*!*	 
*!*		IF _PROGRESSIVO_CONTAINER > 24
*!*			EXIT
*!*		ENDIF


*!*		_PROGRESSIVO_CONTAINER = _PROGRESSIVO_CONTAINER +1
*!*	    _NUMERO_TASTI_CREATI   = _PROGRESSIVO_CONTAINER 

*!*		_oNewCmdContainerName = "CmdContainer"+ALLTRIM(STR(_PROGRESSIVO_CONTAINER))								&& NOME OGGETTO

*!*		_SCREEN.NEWOBJECT(_oNewCmdContainerName,"cmdmenuwin8class")												&& CREA OGGETTO

*!*		IF _PROGRESSIVO_CONTAINER  > 1 AND MOD(_PROGRESSIVO_CONTAINER -1,6) = 0									&& GESTISCE 6 TASTI PER RIGA
*!*			_nDistanzaLeft = 0																					&& GESTISCE 6 TASTI PER RIGA
*!*			_nDistanzaTop = _nDistanzaTop + VAL(_cHeightPulsantiMenuWin8) + 10									&& GESTISCE 6 TASTI PER RIGA
*!*		ENDIF																									&& GESTISCE 6 TASTI PER RIGA

*!*		_cLeft 			= "_SCREEN."+_oNewCmdContainerName+".left = " + ALLTRIM(STR(120 + _nDistanzaLeft))		&& DISTANZA TRA I TASTI LATO SINISTRO
*!*		_cTop 			= "_SCREEN."+_oNewCmdContainerName+".Top = " + ALLTRIM(STR(63 + _nDistanzaTop))			&& DISTANZA TRA I TASTI LATO ALTO
*!*		_cOriginal_Left = "_SCREEN."+_oNewCmdContainerName+".Original_Left = " + ALLTRIM(STR(120 + _nDistanzaLeft))
*!*		_cOriginal_Top 	= "_SCREEN."+_oNewCmdContainerName+".Original_Top = " + ALLTRIM(STR(63 + _nDistanzaTop))
*!*		_cWidth			= "_SCREEN."+_oNewCmdContainerName+".Width = " + _cWidthPulsantiMenuWin8				&& LARGHEZZA TASTO
*!*		_cHeight		= "_SCREEN."+_oNewCmdContainerName+".Height = " + _cHeightPulsantiMenuWin8				&& ALTEZZA TASTO
*!*		*_cImageVisib	= "_SCREEN."+_oNewCmdContainerName+".Image1.Visible = .F."								&& IMMAGINE SFONDO VISIBILE
*!*		_cShapeBckCo	= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(255,128,0)"				&& COLORE TASTO
*!*		_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '0,0,255'"				&& COLORE AZZURRO PER LABEL E BORDO TASTO STANDARD INIZIALMENTE ALL'INGRESSO DEL FORM
*!*		*_cColoreLabel	= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"			&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*		*** IMPOSTA_COLORE_TASTI

*!*		** VERIFICA SE UTENTE DESIDERA PERSONALIZZARE IL MENU

*!*		SxxS=STR(SELECT())
*!*		x_cond = "CODICE = '" + ALLTRIM(PUB_CODOPE) + "'"
*!*		Csql   = "select * from res_oper where " + x_cond + " order by CODICE"
*!*		IF !ExecCommand(cSql,"Res_Oper_cu_")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT Res_Oper_cu_
*!*		GO TOP
*!*		IF !EOF()

*!*		 	M.RES_MENU_WIN8 = RES_MENU_WIN8 	
*!*		 	M.RES_FULL_SCRE	= RES_FULL_SCRE		
*!*		    M.RES_COLO_STAN = RES_COLO_STAN 	
*!*		    M.RES_SFODESK 	= RES_SFODESK 		
*!*		    M.RES_SFOPASS 	= RES_SFOPASS		
*!*		    M.RES_SFOSUBM   = RES_SFOSUBM		
*!*		    M.RES_SCRDESK 	= RES_SCRDESK 		
*!*		    M.RES_SCRPASS 	= RES_SCRPASS 		
*!*		    M.RES_COLTAST 	= RES_COLTAST 		
*!*		    M.RES_TRASPTAST	= RES_TRASPTAST

*!*		ELSE

*!*		 	M.RES_MENU_WIN8 = .F.	
*!*		 	M.RES_FULL_SCRE	= .F.	
*!*		    M.RES_COLO_STAN = .F. 	
*!*		    M.RES_SFODESK 	= 0 		
*!*		    M.RES_SFOPASS 	= 0		
*!*		    M.RES_SFOSUBM   = 0		
*!*		    M.RES_SCRDESK 	= 0		
*!*		    M.RES_SCRPASS 	= 0 		
*!*		    M.RES_COLTAST 	= 0 		
*!*		    M.RES_TRASPTAST	= .F.
*!*		    	
*!*		ENDIF


*!*		IF M.RES_SFODESK > 0	&& SFONDO PERSONALIZZATO PER OPERATORE

*!*			lnColor 			= M.RES_SFODESK
*!*			lnBlue 				= INT(lnColor / (256^2))
*!*			lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
*!*			lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
*!*			_RgbColor	 		= "RGB("+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+")"			
*!*			_cColoreDesktop		= "_SCREEN.backcolor = "+_RgbColor
*!*			&_cColoreDesktop
*!*			_SCREEN.Picture 	= ""
*!*			
*!*			IF TYPE("_SCREEN.oBackImage") == "O"
*!*				_SCREEN.oBackImage.Visible = .F.
*!*			ENDIF		
*!*			
*!*		ENDIF

*!*		IF  !M.RES_COLO_STAN AND  M.RES_COLTAST > 0		&& COLORE TASTI PERSONALIZZATI DA UTENTE

*!*			lnColor 			= M.RES_COLTAST
*!*			lnBlue 				= INT(lnColor / (256^2))
*!*			lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
*!*			lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
*!*			_RgbColor	 		= "RGB("+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+")"
*!*			_cShapeBckCo		= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = "+_RgbColor					&& COLORE TASTO PERSONALIZZATO

*!*			lnColor 			= M.RES_SCRDESK
*!*			lnBlue 				= INT(lnColor / (256^2))
*!*			lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
*!*			lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
*!*			_mouseleave	 		= "'"+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+"'"
*!*			_cColoreLabelStd	= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave ="+_mouseleave			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*			*_cColoreLabel		= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"			&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO
*!*			&_cColoreLabelStd
*!*			*&_cColoreLabel
*!*			
*!*		ELSE

*!*			_ctrTastiCol =  _ctrTastiCol + 1

*!*			DO CASE 
*!*				
*!*				CASE _ctrTastiCol = 1
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(255,128,0)"						&& COLORE TASTO ARANCIONE
*!*					_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					*_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 2
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

*!*				CASE _ctrTastiCol = 3
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 4
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					*_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 5
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 6
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					*_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 7
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 8
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					*_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 9
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

*!*				CASE _ctrTastiCol = 10
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 11
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

*!*				CASE _ctrTastiCol = 12
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(253,234,198)"					&& COLORE TASTO OCRA CHIARO

*!*				CASE _ctrTastiCol = 13
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(187,255,119)"					&& COLORE TASTO VERDE CHIARETTO

*!*				CASE _ctrTastiCol = 14
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

*!*				CASE _ctrTastiCol = 15
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 16
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					*_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 17
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

*!*				CASE _ctrTastiCol = 18
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 19
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(251,237,66)"					&& COLORE TASTO GIALLINO

*!*				CASE _ctrTastiCol = 20
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(187,255,119)"					&& COLORE TASTO VERDE CHIARETTO

*!*				CASE _ctrTastiCol = 21
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

*!*				CASE _ctrTastiCol = 22
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(0,132,66)"						&& COLORE TASTO VERDE SCURO

*!*				CASE _ctrTastiCol = 23
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(251,237,66)"					&& COLORE TASTO GIALLINO

*!*				CASE _ctrTastiCol = 24
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(255,128,0)"						&& COLORE TASTO ARANCIONE

*!*				OTHERWISE
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = RGB(255,128,0)"						&& COLORE TASTO ARANCIONE
*!*				
*!*			ENDCASE
*!*			
*!*		ENDIF
*!*		
*!*	*!*		IF !M.RES_COLO_STAN AND M.RES_TRASPTAST
*!*	*!*			_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.BackStyle = 0"  && SFONDO TASTO TRASPARENTE
*!*	*!*		ENDIF


*!*		SELECT &SxxS
*!*																				&& ESEGUE COMANDO
*!*		__LABEL			= ALLTRIM(LABEL)																		&& ETICHETTA RIGA COMANDO DA ESEGUIRE
*!*		__MENU			= ALLTRIM(MENU)
*!*		__COMANDO		= STRTRAN(ALLTRIM(COMANDO),"\submenu","\AQMENU")										&& COMANDO DA ESEGUIRE : SOSTITUISCO SUBMENU CON AQMENU
*!*		__COMANDO		= STRTRAN(ALLTRIM(__COMANDO),"\SUBMENU","\AQMENU")										&& COMANDO DA ESEGUIRE : SOSTITUISCO SUBMENU CON AQMENU
*!*		__DESCRIZION	= ALLTRIM(DESCRIZION)																	&& DESCRIZIONE RIGA COMANDO
*!*		_cLabel			= "_SCREEN."+_oNewCmdContainerName+".label = __LABEL"
*!*		_cMenu			= "_SCREEN."+_oNewCmdContainerName+".menu = __MENU"
*!*		_cLblCaption	= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Caption = __LABEL"							&&
*!*		_cTag			= "_SCREEN."+_oNewCmdContainerName+".Tag = __COMANDO"									&& ESECUZIONE COMANDO
*!*		_cShapeToolT	= "_SCREEN."+_oNewCmdContainerName+".cmdClick.ToolTipText = __DESCRIZION"				&& MOSTRA NEL TOOLTIPTEXT LA DESCRIZIONE DELLA RIGA DI COMANDO
*!*		_cRidimens		= "_SCREEN."+_oNewCmdContainerName+".ridimensiona()"									&&
*!*		_cVisible 		= "_SCREEN."+_oNewCmdContainerName+".VISIBLE = .T."										&&
*!*		_cResetBckcol	= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Tag = '" + _cShapeBckCo + "'"
*!*		*_cShapeDragMode	= "_SCREEN."+_oNewCmdContainerName+".cmdClick.OLEDragMode = 1"
*!*		*_cShapeDropMode	= "_SCREEN."+_oNewCmdContainerName+".cmdClick.OLEDropMode = 1"
*!*		
*!*		x_user = "CODOPE = '" + PUB_CODOPE + "'"
*!*		x_menu = "MENU = '" + __MENU + "'"
*!*		x_labl = "LABEL = '" + STRTRAN(__LABEL,"'","''") + "'"
*!*		x_bckc = "CMDBCKCOL > 0"
*!*		x_cond = x_user + " and " + x_menu + " and " + x_labl + " and " + x_bckc 
*!*		cSql   = "SELECT CMDBCKCOL FROM USER_MENU WHERE " + x_cond
*!*		IF !ExecCommand(cSql,"TMP_USER_MENU")
*!*		  return(.f.)
*!*		ENDIF
*!*		SELECT TMP_USER_MENU
*!*		GO TOP
*!*		IF !EOF()
*!*			_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".cmdClick.Backcolor = " + ALLTRIM(STR(CMDBCKCOL,10,0))
*!*		ENDIF
*!*		
*!*		x_user = "CODOPE = '" + PUB_CODOPE + "'"
*!*		x_menu = "MENU = '" + __MENU + "'"
*!*		x_labl = "LABEL = '" + STRTRAN(__LABEL,"'","''") + "'"
*!*		x_hide = "HIDDEN = 1"
*!*		x_cond = x_user + " and " + x_menu + " and " + x_labl + " and " + x_hide 
*!*		cSql   = "SELECT HIDDEN FROM USER_MENU WHERE " + x_cond
*!*		IF !ExecCommand(cSql,"TMP_USER_MENU")
*!*		  return(.f.)
*!*		ENDIF
*!*		SELECT TMP_USER_MENU
*!*		GO TOP
*!*		IF !EOF()
*!*			_cVisible = "_SCREEN."+_oNewCmdContainerName+".VISIBLE = .F."
*!*		ENDIF
*!*		
*!*		x_user = "CODOPE = '" + PUB_CODOPE + "'"
*!*		x_menu = "MENU = '" + __MENU + "'"
*!*		x_labl = "LABEL = '" + STRTRAN(__LABEL,"'","''") + "'"
*!*		x_posi = "CMDLEFT+CMDTOP > 0"
*!*		x_cond = x_user + " and " + x_menu + " and " + x_labl + " and " + x_posi
*!*		cSql   = "SELECT CMDLEFT, CMDTOP FROM USER_MENU WHERE " + x_cond
*!*		IF !ExecCommand(cSql,"TMP_USER_MENU")
*!*		  return(.f.)
*!*		ENDIF
*!*		SELECT TMP_USER_MENU
*!*		GO TOP
*!*		IF !EOF()
*!*			_cLeft = "_SCREEN."+_oNewCmdContainerName+".LEFT = " + ALLTRIM(STR(CMDLEFT))
*!*			_cTop  = "_SCREEN."+_oNewCmdContainerName+".TOP = " + ALLTRIM(STR(CMDTOP))
*!*		ENDIF
*!*		
*!*		&_cLabel
*!*		&_cMenu
*!*		&_cLeft																									&& ESEGUE COMANDO
*!*		&_cTop																									&& ESEGUE COMANDO
*!*		&_cOriginal_Left
*!*		&_cOriginal_Top
*!*		&_cWidth																								&& ESEGUE COMANDO
*!*		&_cHeight																								&& ESEGUE COMANDO
*!*		*&_cImageVisib																							&& ESEGUE COMANDO
*!*		&_cShapeBckCo																							&& ESEGUE COMANDO
*!*		&_cColoreLabelStd 
*!*		*&_cColoreLabel
*!*		&_cLblCaption																							&& ESEGUE COMANDO
*!*		&_cTag																									&& ESEGUE COMANDO
*!*		&_cShapeToolT																							&& ESEGUE COMANDO
*!*		&_cRidimens																								&& ESEGUE COMANDO
*!*		&_cVisible
*!*		&_cResetBckcol
*!*		*&_cShapeDragMode
*!*		*&_cShapeDropMode
*!*		
*!*		_nDistanzaLeft = _nDistanzaLeft + VAL(_cWidthPulsantiMenuWin8) + 10										&& IL PROSSIMO TASTO PARTE 10 PIXEL A DESTRA

*!*	ENDSCAN
*!*	*######### FINE TEST CON COMMAND BUTTON IN CONTAINER ANZICHE' SHAPES ########################################################################################################################

*!*	*######### INIZIO TEST CON COMMAND BUTTON SENZA CONTAINER ANZICHE' SHAPES ########################################################################################################################
*!*	SCAN

*!*	    IF VISIBILE <> 'S'
*!*	    	SELECT &PUB_ARCH
*!*	    	LOOP
*!*	    ENDIF
*!*	 
*!*		IF _PROGRESSIVO_CONTAINER > 24
*!*			EXIT
*!*		ENDIF


*!*		_PROGRESSIVO_CONTAINER = _PROGRESSIVO_CONTAINER +1
*!*	    _NUMERO_TASTI_CREATI   = _PROGRESSIVO_CONTAINER 

*!*		_oNewCmdContainerName = "CmdContainer"+ALLTRIM(STR(_PROGRESSIVO_CONTAINER))								&& NOME OGGETTO

*!*		_SCREEN.NEWOBJECT(_oNewCmdContainerName,"cmdmenuwin8btn")												&& CREA OGGETTO

*!*		IF _PROGRESSIVO_CONTAINER  > 1 AND MOD(_PROGRESSIVO_CONTAINER -1,6) = 0									&& GESTISCE 6 TASTI PER RIGA
*!*			_nDistanzaLeft = 0																					&& GESTISCE 6 TASTI PER RIGA
*!*			_nDistanzaTop = _nDistanzaTop + VAL(_cHeightPulsantiMenuWin8) + 10									&& GESTISCE 6 TASTI PER RIGA
*!*		ENDIF																									&& GESTISCE 6 TASTI PER RIGA

*!*		_cLeft 			= "_SCREEN."+_oNewCmdContainerName+".left = " + ALLTRIM(STR(120 + _nDistanzaLeft))		&& DISTANZA TRA I TASTI LATO SINISTRO
*!*		_cTop 			= "_SCREEN."+_oNewCmdContainerName+".Top = " + ALLTRIM(STR(63 + _nDistanzaTop))			&& DISTANZA TRA I TASTI LATO ALTO
*!*		_cOriginal_Left = "_SCREEN."+_oNewCmdContainerName+".Original_Left = " + ALLTRIM(STR(120 + _nDistanzaLeft))
*!*		_cOriginal_Top 	= "_SCREEN."+_oNewCmdContainerName+".Original_Top = " + ALLTRIM(STR(63 + _nDistanzaTop))
*!*		_cWidth			= "_SCREEN."+_oNewCmdContainerName+".Width = " + _cWidthPulsantiMenuWin8				&& LARGHEZZA TASTO
*!*		_cHeight		= "_SCREEN."+_oNewCmdContainerName+".Height = " + _cHeightPulsantiMenuWin8				&& ALTEZZA TASTO
*!*		*_cImageVisib	= "_SCREEN."+_oNewCmdContainerName+".Image1.Visible = .F."								&& IMMAGINE SFONDO VISIBILE
*!*		_cShapeBckCo	= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(255,128,0)"				&& COLORE TASTO
*!*		_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '0,0,255'"				&& COLORE AZZURRO PER LABEL E BORDO TASTO STANDARD INIZIALMENTE ALL'INGRESSO DEL FORM
*!*		*_cColoreLabel	= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"			&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*		*** IMPOSTA_COLORE_TASTI

*!*		** VERIFICA SE UTENTE DESIDERA PERSONALIZZARE IL MENU

*!*		SxxS=STR(SELECT())
*!*		x_cond = "CODICE = '" + ALLTRIM(PUB_CODOPE) + "'"
*!*		Csql   = "select * from res_oper where " + x_cond + " order by CODICE"
*!*		IF !ExecCommand(cSql,"Res_Oper_cu_")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT Res_Oper_cu_
*!*		GO TOP
*!*		IF !EOF()

*!*		 	M.RES_MENU_WIN8 = RES_MENU_WIN8 	
*!*		 	M.RES_FULL_SCRE	= RES_FULL_SCRE		
*!*		    M.RES_COLO_STAN = RES_COLO_STAN 	
*!*		    M.RES_SFODESK 	= RES_SFODESK 		
*!*		    M.RES_SFOPASS 	= RES_SFOPASS		
*!*		    M.RES_SFOSUBM   = RES_SFOSUBM		
*!*		    M.RES_SCRDESK 	= RES_SCRDESK 		
*!*		    M.RES_SCRPASS 	= RES_SCRPASS 		
*!*		    M.RES_COLTAST 	= RES_COLTAST 		
*!*		    M.RES_TRASPTAST	= RES_TRASPTAST

*!*		ELSE

*!*		 	M.RES_MENU_WIN8 = .F.	
*!*		 	M.RES_FULL_SCRE	= .F.	
*!*		    M.RES_COLO_STAN = .F. 	
*!*		    M.RES_SFODESK 	= 0 		
*!*		    M.RES_SFOPASS 	= 0		
*!*		    M.RES_SFOSUBM   = 0		
*!*		    M.RES_SCRDESK 	= 0		
*!*		    M.RES_SCRPASS 	= 0 		
*!*		    M.RES_COLTAST 	= 0 		
*!*		    M.RES_TRASPTAST	= .F.
*!*		    	
*!*		ENDIF


*!*		IF M.RES_SFODESK > 0	&& SFONDO PERSONALIZZATO PER OPERATORE

*!*			lnColor 			= M.RES_SFODESK
*!*			lnBlue 				= INT(lnColor / (256^2))
*!*			lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
*!*			lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
*!*			_RgbColor	 		= "RGB("+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+")"			
*!*			_cColoreDesktop		= "_SCREEN.backcolor = "+_RgbColor
*!*			&_cColoreDesktop
*!*			_SCREEN.Picture 	= ""
*!*			
*!*			IF TYPE("_SCREEN.oBackImage") == "O"
*!*				_SCREEN.oBackImage.Visible = .F.
*!*			ENDIF		
*!*			
*!*		ENDIF

*!*		IF  !M.RES_COLO_STAN AND  M.RES_COLTAST > 0		&& COLORE TASTI PERSONALIZZATI DA UTENTE

*!*			lnColor 			= M.RES_COLTAST
*!*			lnBlue 				= INT(lnColor / (256^2))
*!*			lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
*!*			lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
*!*			_RgbColor	 		= "RGB("+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+")"
*!*			_cShapeBckCo		= "_SCREEN."+_oNewCmdContainerName+".Backcolor = "+_RgbColor					&& COLORE TASTO PERSONALIZZATO

*!*			lnColor 			= M.RES_SCRDESK
*!*			lnBlue 				= INT(lnColor / (256^2))
*!*			lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
*!*			lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
*!*			_mouseleave	 		= "'"+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+"'"
*!*			_cColoreLabelStd	= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave ="+_mouseleave			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*			*_cColoreLabel		= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"			&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO
*!*			&_cColoreLabelStd
*!*			*&_cColoreLabel
*!*			
*!*		ELSE

*!*			_ctrTastiCol =  _ctrTastiCol + 1

*!*			DO CASE 
*!*				
*!*				CASE _ctrTastiCol = 1
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(255,128,0)"						&& COLORE TASTO ARANCIONE
*!*					_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					*_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 2
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

*!*				CASE _ctrTastiCol = 3
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 4
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					*_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 5
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 6
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					*_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 7
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 8
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					*_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 9
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

*!*				CASE _ctrTastiCol = 10
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 11
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

*!*				CASE _ctrTastiCol = 12
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(253,234,198)"					&& COLORE TASTO OCRA CHIARO

*!*				CASE _ctrTastiCol = 13
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(187,255,119)"					&& COLORE TASTO VERDE CHIARETTO

*!*				CASE _ctrTastiCol = 14
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

*!*				CASE _ctrTastiCol = 15
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 16
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					*_cColoreLabel= "_SCREEN."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 17
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

*!*				CASE _ctrTastiCol = 18
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 19
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(251,237,66)"					&& COLORE TASTO GIALLINO

*!*				CASE _ctrTastiCol = 20
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(187,255,119)"					&& COLORE TASTO VERDE CHIARETTO

*!*				CASE _ctrTastiCol = 21
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

*!*				CASE _ctrTastiCol = 22
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(0,132,66)"						&& COLORE TASTO VERDE SCURO

*!*				CASE _ctrTastiCol = 23
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(251,237,66)"					&& COLORE TASTO GIALLINO

*!*				CASE _ctrTastiCol = 24
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(255,128,0)"						&& COLORE TASTO ARANCIONE

*!*				OTHERWISE
*!*					_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = RGB(255,128,0)"						&& COLORE TASTO ARANCIONE
*!*				
*!*			ENDCASE
*!*			
*!*		ENDIF
*!*		
*!*	*!*		IF !M.RES_COLO_STAN AND M.RES_TRASPTAST
*!*	*!*			_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Shape1.BackStyle = 0"  && SFONDO TASTO TRASPARENTE
*!*	*!*		ENDIF


*!*		SELECT &SxxS
*!*																				&& ESEGUE COMANDO
*!*		__LABEL			= ALLTRIM(LABEL)																		&& ETICHETTA RIGA COMANDO DA ESEGUIRE
*!*		__MENU			= ALLTRIM(MENU)
*!*		__COMANDO		= STRTRAN(ALLTRIM(COMANDO),"\submenu","\AQMENU")										&& COMANDO DA ESEGUIRE : SOSTITUISCO SUBMENU CON AQMENU
*!*		__COMANDO		= STRTRAN(ALLTRIM(__COMANDO),"\SUBMENU","\AQMENU")										&& COMANDO DA ESEGUIRE : SOSTITUISCO SUBMENU CON AQMENU
*!*		__DESCRIZION	= ALLTRIM(DESCRIZION)																	&& DESCRIZIONE RIGA COMANDO
*!*		_cLabel			= "_SCREEN."+_oNewCmdContainerName+".label = __LABEL"
*!*		_cMenu			= "_SCREEN."+_oNewCmdContainerName+".menu = __MENU"
*!*		_cLblCaption	= "_SCREEN."+_oNewCmdContainerName+".Caption = __LABEL"							&&
*!*		_cTag			= "_SCREEN."+_oNewCmdContainerName+".Tag = __COMANDO"									&& ESECUZIONE COMANDO
*!*		_cShapeToolT	= "_SCREEN."+_oNewCmdContainerName+".ToolTipText = __DESCRIZION"				&& MOSTRA NEL TOOLTIPTEXT LA DESCRIZIONE DELLA RIGA DI COMANDO
*!*		_cRidimens		= "_SCREEN."+_oNewCmdContainerName+".ridimensiona()"									&&
*!*		_cVisible 		= "_SCREEN."+_oNewCmdContainerName+".VISIBLE = .T."										&&
*!*		_cResetBckcol	= "_SCREEN."+_oNewCmdContainerName+".Tag = '" + _cShapeBckCo + "'"
*!*		*_cShapeDragMode	= "_SCREEN."+_oNewCmdContainerName+".cmdClick.OLEDragMode = 1"
*!*		*_cShapeDropMode	= "_SCREEN."+_oNewCmdContainerName+".cmdClick.OLEDropMode = 1"
*!*		
*!*		x_user = "CODOPE = '" + PUB_CODOPE + "'"
*!*		x_menu = "MENU = '" + __MENU + "'"
*!*		x_labl = "LABEL = '" + STRTRAN(__LABEL,"'","''") + "'"
*!*		x_bckc = "CMDBCKCOL > 0"
*!*		x_cond = x_user + " and " + x_menu + " and " + x_labl + " and " + x_bckc 
*!*		cSql   = "SELECT CMDBCKCOL FROM USER_MENU WHERE " + x_cond
*!*		IF !ExecCommand(cSql,"TMP_USER_MENU")
*!*		  return(.f.)
*!*		ENDIF
*!*		SELECT TMP_USER_MENU
*!*		GO TOP
*!*		IF !EOF()
*!*			_cShapeBckCo= "_SCREEN."+_oNewCmdContainerName+".Backcolor = " + ALLTRIM(STR(CMDBCKCOL,10,0))
*!*		ENDIF
*!*		
*!*		x_user = "CODOPE = '" + PUB_CODOPE + "'"
*!*		x_menu = "MENU = '" + __MENU + "'"
*!*		x_labl = "LABEL = '" + STRTRAN(__LABEL,"'","''") + "'"
*!*		x_hide = "HIDDEN = 1"
*!*		x_cond = x_user + " and " + x_menu + " and " + x_labl + " and " + x_hide 
*!*		cSql   = "SELECT HIDDEN FROM USER_MENU WHERE " + x_cond
*!*		IF !ExecCommand(cSql,"TMP_USER_MENU")
*!*		  return(.f.)
*!*		ENDIF
*!*		SELECT TMP_USER_MENU
*!*		GO TOP
*!*		IF !EOF()
*!*			_cVisible = "_SCREEN."+_oNewCmdContainerName+".VISIBLE = .F."
*!*		ENDIF
*!*		
*!*		x_user = "CODOPE = '" + PUB_CODOPE + "'"
*!*		x_menu = "MENU = '" + __MENU + "'"
*!*		x_labl = "LABEL = '" + STRTRAN(__LABEL,"'","''") + "'"
*!*		x_posi = "CMDLEFT+CMDTOP > 0"
*!*		x_cond = x_user + " and " + x_menu + " and " + x_labl + " and " + x_posi
*!*		cSql   = "SELECT CMDLEFT, CMDTOP FROM USER_MENU WHERE " + x_cond
*!*		IF !ExecCommand(cSql,"TMP_USER_MENU")
*!*		  return(.f.)
*!*		ENDIF
*!*		SELECT TMP_USER_MENU
*!*		GO TOP
*!*		IF !EOF()
*!*			_cLeft = "_SCREEN."+_oNewCmdContainerName+".LEFT = " + ALLTRIM(STR(CMDLEFT))
*!*			_cTop  = "_SCREEN."+_oNewCmdContainerName+".TOP = " + ALLTRIM(STR(CMDTOP))
*!*		ENDIF
*!*		
*!*		&_cLabel
*!*		&_cMenu
*!*		&_cLeft																									&& ESEGUE COMANDO
*!*		&_cTop																									&& ESEGUE COMANDO
*!*		&_cOriginal_Left
*!*		&_cOriginal_Top
*!*		&_cWidth																								&& ESEGUE COMANDO
*!*		&_cHeight																								&& ESEGUE COMANDO
*!*		*&_cImageVisib																							&& ESEGUE COMANDO
*!*		&_cShapeBckCo																							&& ESEGUE COMANDO
*!*		&_cColoreLabelStd 
*!*		*&_cColoreLabel
*!*		&_cLblCaption																							&& ESEGUE COMANDO
*!*		&_cTag																									&& ESEGUE COMANDO
*!*		&_cShapeToolT																							&& ESEGUE COMANDO
*!*		&_cRidimens																								&& ESEGUE COMANDO
*!*		&_cVisible
*!*		&_cResetBckcol
*!*		*&_cShapeDragMode
*!*		*&_cShapeDropMode
*!*		
*!*		_nDistanzaLeft = _nDistanzaLeft + VAL(_cWidthPulsantiMenuWin8) + 10										&& IL PROSSIMO TASTO PARTE 10 PIXEL A DESTRA

*!*	ENDSCAN
*!*	*######### FINE TEST CON COMMAND BUTTON SENZA CONTAINER ANZICHE' SHAPES ########################################################################################################################

_SCREEN.AddObject("text1","textbox")
_SCREEN.text1.FontBold = .T.
_SCREEN.text1.FontItalic = .F.
_SCREEN.text1.FontName = "Arial"
_SCREEN.text1.FontSize = 13
_SCREEN.text1.FontCondense = .T.
_SCREEN.text1.FontExtend = .F.
_SCREEN.text1.Alignment = 0
_SCREEN.text1.BackStyle = 0
_SCREEN.text1.BorderStyle = 0
_SCREEN.text1.Value = ""
_SCREEN.text1.ControlSource = "PUB_DESBAR1"
_SCREEN.text1.Enabled = .F.
_SCREEN.text1.Height = 19
_SCREEN.text1.Left = 118
_SCREEN.text1.Margin = 0
_SCREEN.text1.ReadOnly = .T.
_SCREEN.text1.SpecialEffect = 0
_SCREEN.text1.TabIndex = 71
_SCREEN.text1.TabStop = .F.
_SCREEN.text1.Top = 36
_SCREEN.text1.Width = 843
_SCREEN.text1.Style = 1
_SCREEN.text1.ColorSource = 4
_SCREEN.text1.ColorScheme = 10
_SCREEN.text1.ForeColor = RGB(255,255,255)
_SCREEN.text1.BackColor = RGB(128,128,255)
_SCREEN.text1.DisabledBackColor = RGB(255,255,255)
_SCREEN.text1.DisabledForeColor = RGB(255,255,255)
_SCREEN.text1.SelectedBackColor = RGB(128,128,255)
_SCREEN.text1.BorderColor = RGB(128,128,255)
_SCREEN.text1.Name = "Text1"

_SCREEN.AddObject("txtpub_dessoc","textbox")
_SCREEN.txtpub_dessoc.FontBold = .T.
_SCREEN.txtpub_dessoc.FontItalic = .F.
_SCREEN.txtpub_dessoc.FontName = "Arial"
_SCREEN.txtpub_dessoc.FontSize = 14
_SCREEN.txtpub_dessoc.FontCondense = .T.
_SCREEN.txtpub_dessoc.FontExtend = .F.
_SCREEN.txtpub_dessoc.Alignment = 1
_SCREEN.txtpub_dessoc.BackStyle = 0
_SCREEN.txtpub_dessoc.BorderStyle = 0
_SCREEN.txtpub_dessoc.Value = ""
_SCREEN.txtpub_dessoc.ControlSource = "PUB_DESSOC"
_SCREEN.txtpub_dessoc.Enabled = .F.
_SCREEN.txtpub_dessoc.Height = 27
_SCREEN.txtpub_dessoc.Left = 260
_SCREEN.txtpub_dessoc.Margin = 0
_SCREEN.txtpub_dessoc.ReadOnly = .T.
_SCREEN.txtpub_dessoc.SpecialEffect = 0
_SCREEN.txtpub_dessoc.TabIndex = 71
_SCREEN.txtpub_dessoc.TabStop = .F.
_SCREEN.txtpub_dessoc.Top = 404
_SCREEN.txtpub_dessoc.Width = 695
_SCREEN.txtpub_dessoc.Style = 0
_SCREEN.txtpub_dessoc.ColorSource = 4
_SCREEN.txtpub_dessoc.ColorScheme = 10
_SCREEN.txtpub_dessoc.ForeColor = RGB(255,255,255)
_SCREEN.txtpub_dessoc.BackColor = RGB(255,255,128)
_SCREEN.txtpub_dessoc.DisabledBackColor = RGB(255,128,128)
_SCREEN.txtpub_dessoc.DisabledForeColor = RGB(255,255,255)
_SCREEN.txtpub_dessoc.SelectedBackColor = RGB(128,128,255)
_SCREEN.txtpub_dessoc.BorderColor = RGB(128,128,255)
_SCREEN.txtpub_dessoc.Name = "txtPUB_DESSOC"

_SCREEN.AddObject("txtpub_desbar2","textbox")
_SCREEN.txtpub_desbar2.FontBold = .T.
_SCREEN.txtpub_desbar2.FontItalic = .F.
_SCREEN.txtpub_desbar2.FontName = "Arial"
_SCREEN.txtpub_desbar2.FontSize = 8
_SCREEN.txtpub_desbar2.FontCondense = .T.
_SCREEN.txtpub_desbar2.FontExtend = .F.
_SCREEN.txtpub_desbar2.Alignment = 1
_SCREEN.txtpub_desbar2.BackStyle = 0
_SCREEN.txtpub_desbar2.BorderStyle = 0
_SCREEN.txtpub_desbar2.Value = ""
_SCREEN.txtpub_desbar2.ControlSource = "pub_desbar2"
_SCREEN.txtpub_desbar2.Enabled = .F.
_SCREEN.txtpub_desbar2.Height = 27
_SCREEN.txtpub_desbar2.Left = 260
_SCREEN.txtpub_desbar2.Margin = 0
_SCREEN.txtpub_desbar2.ReadOnly = .T.
_SCREEN.txtpub_desbar2.SpecialEffect = 0
_SCREEN.txtpub_desbar2.TabIndex = 71
_SCREEN.txtpub_desbar2.TabStop = .F.
_SCREEN.txtpub_desbar2.Top = 435
_SCREEN.txtpub_desbar2.Width = 695
_SCREEN.txtpub_desbar2.Style = 0
_SCREEN.txtpub_desbar2.ColorSource = 4
_SCREEN.txtpub_desbar2.ColorScheme = 10
_SCREEN.txtpub_desbar2.ForeColor = RGB(255,255,255)
_SCREEN.txtpub_desbar2.BackColor = RGB(255,255,128)
_SCREEN.txtpub_desbar2.DisabledBackColor = RGB(255,128,128)
_SCREEN.txtpub_desbar2.DisabledForeColor = RGB(255,255,255)
_SCREEN.txtpub_desbar2.SelectedBackColor = RGB(128,128,255)
_SCREEN.txtpub_desbar2.BorderColor = RGB(128,128,255)
_SCREEN.txtpub_desbar2.Name = "txtpub_desbar2"

nRightDistance = 10
_SCREEN.txtPUB_DESSOC.Left = _SCREEN.Width - _SCREEN.txtPUB_DESSOC.Width - nRightDistance
_SCREEN.txtpub_desbar2.Left = _SCREEN.Width - _SCREEN.TXTpub_desbar2.Width - nRightDistance
nBottomDistance = 34
_SCREEN.txtpub_desbar2.Top = _SCREEN.Height - _SCREEN.TXTpub_desbar2.Height - nBottomDistance 
_SCREEN.txtPUB_DESSOC.Top = _SCREEN.TXTpub_desbar2.Top - _SCREEN.TXTpub_desbar2.Height

_SCREEN.text1.Visible = .T.
_SCREEN.txtPUB_DESSOC.Visible = .T.
_SCREEN.txtpub_desbar2.Visible = .T.


_SCREEN.AddObject("container1","container")
_SCREEN.container1.Top = 500
_SCREEN.container1.Left = 20
_SCREEN.container1.Width = 133
_SCREEN.container1.Height = 49
_SCREEN.container1.BackStyle = 0
_SCREEN.container1.BorderWidth = 0
_SCREEN.container1.TabIndex = 5
_SCREEN.container1.Name = "Container1"
_SCREEN.container1.Visible = .T.

_SCREEN.container1.AddObject("image1","image")
_SCREEN.container1.image1.Picture = "..\bmp\icone\termina.bmp"
_SCREEN.container1.image1.Stretch = 0
_SCREEN.container1.image1.BackStyle = 0
_SCREEN.container1.image1.Height = 25
_SCREEN.container1.image1.Left = 16
_SCREEN.container1.image1.Top = 9
_SCREEN.container1.image1.Width = 25
_SCREEN.container1.image1.Name = "Image1"
_SCREEN.container1.image1.Visible = .T.

_SCREEN.container1.AddObject("label1","label")
_SCREEN.container1.label1.AutoSize = .F.
_SCREEN.container1.label1.FontBold = .T.
_SCREEN.container1.label1.FontSize = 8
_SCREEN.container1.label1.Alignment = 0
_SCREEN.container1.label1.BackStyle = 0
_SCREEN.container1.label1.Caption = "       Termina"
_SCREEN.container1.label1.Height = 15
_SCREEN.container1.label1.Left = 44
_SCREEN.container1.label1.Top = 16
_SCREEN.container1.label1.Width = 87
_SCREEN.container1.label1.ForeColor = RGB(255,255,255)
_SCREEN.container1.label1.Name = "Label1"
_SCREEN.container1.label1.Visible = .T.

_SCREEN.container1.AddObject("shape1","shape_termina")
_SCREEN.container1.shape1.Top = 4
_SCREEN.container1.shape1.Left = 1
_SCREEN.container1.shape1.Height = 43
_SCREEN.container1.shape1.Width = 131
_SCREEN.container1.shape1.BackStyle = 0
_SCREEN.container1.shape1.BorderStyle = 0
_SCREEN.container1.shape1.MousePointer = 15
_SCREEN.container1.shape1.BorderColor = RGB(255,0,0)
_SCREEN.container1.shape1.Name = "Shape1"
_SCREEN.container1.shape1.Visible = .T.


*** INIZIO CREAZIONE PULSANTE OPZIONI MENU POSIZIONATO IN ALTO A SINISTRA
_nDistanzaTop = 20
_nDistanzaLeft = 20
_nLarghezzaTasto = 40
_nAltezzaTasto = 40
_SCREEN.NEWOBJECT("ContainerBottoneOpzioniMenu","container")
_RifCmd = "_oContainerBottoneOpzioni = _SCREEN.ContainerBottoneOpzioniMenu"
&_RifCmd
_oContainerBottoneOpzioni.Tag = ""
_oContainerBottoneOpzioni.Top = _nDistanzaTop
_oContainerBottoneOpzioni.Left = _nDistanzaLeft 
_oContainerBottoneOpzioni.Width = _nLarghezzaTasto
_oContainerBottoneOpzioni.Height = _nAltezzaTasto
_oContainerBottoneOpzioni.BackStyle = 0
_oContainerBottoneOpzioni.BorderWidth = 0
_oContainerBottoneOpzioni.Visible = .T.

_oContainerBottoneOpzioni.AddObject("shape_sfondo","shape")    && CREO L'OGGETTO SHAPE SEMPLICE PER IMPOSTARLO EVENTUALMENTE COME OMBRA DI SFONDO, INIZIALMENTE TRASPARENTE
_oContainerBottoneOpzioni.shape_sfondo.Top = 0
_oContainerBottoneOpzioni.shape_sfondo.Left = 0
_oContainerBottoneOpzioni.shape_sfondo.Height = _nAltezzaTasto
_oContainerBottoneOpzioni.shape_sfondo.Width = _nLarghezzaTasto
_oContainerBottoneOpzioni.shape_sfondo.BackStyle = 0
_oContainerBottoneOpzioni.shape_sfondo.BorderStyle = 0
_oContainerBottoneOpzioni.shape_sfondo.Visible = .T.

_oContainerBottoneOpzioni.AddObject("image1","image")
*_oContainerBottoneOpzioni.image1.Picture = "..\bmp\icone\opzioni_menu_24x24.bmp"
_oContainerBottoneOpzioni.image1.Picture = SYS(5)+SYS(2003)+"\bmp\icone\opzioni_menu_24x24.bmp"
_oContainerBottoneOpzioni.image1.Stretch = 0
_oContainerBottoneOpzioni.image1.BackStyle = 0
_oContainerBottoneOpzioni.image1.Height = 24
_oContainerBottoneOpzioni.image1.Width = 24
_oContainerBottoneOpzioni.image1.Left = (_oContainerBottoneOpzioni.Width - _oContainerBottoneOpzioni.image1.Width ) / 2
_oContainerBottoneOpzioni.image1.Top = (_oContainerBottoneOpzioni.Height - _oContainerBottoneOpzioni.image1.Height) / 2
*_oContainerBottoneOpzioni.image1.Left = 0
*_oContainerBottoneOpzioni.image1.Top = 0
_oContainerBottoneOpzioni.image1.Visible = .T.

_oContainerBottoneOpzioni.AddObject("shape1","shape_bottone_opzioni_menu")
_oContainerBottoneOpzioni.shape1.Top = 0
_oContainerBottoneOpzioni.shape1.Left = 0
_oContainerBottoneOpzioni.shape1.Height = _nAltezzaTasto
_oContainerBottoneOpzioni.shape1.Width = _nLarghezzaTasto
_oContainerBottoneOpzioni.shape1.BackStyle = 0
_oContainerBottoneOpzioni.shape1.BorderStyle = 0
_oContainerBottoneOpzioni.shape1.MousePointer = 15
_oContainerBottoneOpzioni.shape1.BorderColor = RGB(255,0,0)
_oContainerBottoneOpzioni.shape1.Visible = .T.

_oContainerBottoneOpzioni.shape1.ToolTipText = "Opzioni " + ALLTRIM(PUB_DESBAR1) + "..."   		&& SETTO IL TOOLTIPTEXT DELL'OGGETTO SHAPE1 DEL CONTAINER
_oContainerBottoneOpzioni.shape_sfondo.BackStyle = 0                            				&& OGGETTO shape_sfondo TRASPARENTE
*** FINE CREAZIONE PULSANTE OPZIONI MENU POSIZIONATO IN ALTO A SINISTRA


*** INIZIO CREAZIONE PULSANTI AGGIUNTIVI POSIZIONATI IN ALTO A DESTRA
RELEASE _N_BOTTONI_AGGIUNTIVI_MENU_WIN8
PUBLIC _N_BOTTONI_AGGIUNTIVI_MENU_WIN8
_N_BOTTONI_AGGIUNTIVI_MENU_WIN8 = 3		&& NUMERO DI BOTTONI AGGIUNTIVI DA CREARE
_nDistanzaTop_parte_fissa		= 65	&& DISTANZA DALLA PARTE ALTA DELLO SCREEN
_nDistanzaTop   				= 65	&& DISTANZA DALLA PARTE ALTA DELLO SCREEN

*!*	_nDistanzaTraTasti 				= 10	&& DISTANZA TRA UN PULSANTE E L'ALTRO		/ IMPOSTAZIONE ORRIZZONTALE
*!*	_nDistanzaRight 				= 5  	&& DISTANZA DAL LATO DESTRO DELLO SCREEN	/ IMPOSTAZIONE ORRIZZONTALE
*!*	_nLarghezzaTasti 				= 100	&& LARGHEZZA PULSANTE						/ IMPOSTAZIONE ORRIZZONTALE
*!*	_nAltezzaTasti 					= 50	&& ALTEZZA PULSANTE							/ IMPOSTAZIONE ORRIZZONTALE


*!*	_nDistanzaTraTasti 				= 2		&& DISTANZA TRA UN PULSANTE E L'ALTRO			/ IMPOSTAZIONE VERTICALE
*!*	_nDistanzaRight 				= 15  	&& DISTANZA DAL LATO DESTRO DELLO SCREEN		/ IMPOSTAZIONE VERTICALE
*!*	_nLarghezzaTasti 				= 20	&& LARGHEZZA PULSANTE							/ IMPOSTAZIONE VERTICALE
*!*	_nAltezzaTasti 					= 20	&& ALTEZZA PULSANTE								/ IMPOSTAZIONE VERTICALE
_nDistanzaTraTasti 				= 3		&& DISTANZA TRA UN PULSANTE E L'ALTRO			/ IMPOSTAZIONE VERTICALE
_nDistanzaRight 				= 20  	&& DISTANZA DAL LATO DESTRO DELLO SCREEN		/ IMPOSTAZIONE VERTICALE
_nLarghezzaTasti 				= 30	&& LARGHEZZA PULSANTE							/ IMPOSTAZIONE VERTICALE
_nAltezzaTasti 					= 30	&& ALTEZZA PULSANTE								/ IMPOSTAZIONE VERTICALE

  
FOR I=1 TO _N_BOTTONI_AGGIUNTIVI_MENU_WIN8
		
	_SCREEN.NEWOBJECT("ContainerBottoneAggiuntivo"+ALLTRIM(STR(I)),"container")		&& CREA IL CONTAINER AGGIUNTIVO
	_RifCmd = "_oContainerBottoneAggiuntivo = _SCREEN.ContainerBottoneAggiuntivo"+ALLTRIM(STR(I))
	&_RifCmd																		&& CREA IL RIFERIMENTO AL NUOVO CONTAINER CREATO NELLA VARIABILE _oContainerBottoneAggiuntivo
	_oContainerBottoneAggiuntivo.Tag = ""
	_oContainerBottoneAggiuntivo.Top = _nDistanzaTop
	*_oContainerBottoneAggiuntivo.Left = _SCREEN.Width - _nLarghezzaTasti - (_nDistanzaRight + (I - 1) * (_nLarghezzaTasti + _nDistanzaTraTasti)) && IMPOSTAZIONE ORRIZZONTALE
	_oContainerBottoneAggiuntivo.Left = _SCREEN.Width - _nLarghezzaTasti - _nDistanzaRight && IMPOSTAZIONE VERTICALE
	
				
	_oContainerBottoneAggiuntivo.Width = _nLarghezzaTasti
	_oContainerBottoneAggiuntivo.Height = _nAltezzaTasti
	_oContainerBottoneAggiuntivo.BackStyle = 0
	_oContainerBottoneAggiuntivo.BorderWidth = 0
	_oContainerBottoneAggiuntivo.Visible = .T.


     _oContainerBottoneAggiuntivo.AddObject("shape_sfondo","shape")    && CREO L'OGGETTO SHAPE SEMPLICE PER IMPOSTARLO EVENTUALMENTE COME OMBRA DI SFONDO, INIZIALMENTE TRASPARENTE
     _oContainerBottoneAggiuntivo.shape_sfondo.Top = 0
     _oContainerBottoneAggiuntivo.shape_sfondo.Left = 0
     _oContainerBottoneAggiuntivo.shape_sfondo.Height = _nAltezzaTasti
     _oContainerBottoneAggiuntivo.shape_sfondo.Width = _nLarghezzaTasti
     _oContainerBottoneAggiuntivo.shape_sfondo.BackStyle = 0
     _oContainerBottoneAggiuntivo.shape_sfondo.BorderStyle = 0
     _oContainerBottoneAggiuntivo.shape_sfondo.Visible = .T.


	_oContainerBottoneAggiuntivo.AddObject("image1","image")
	*_oContainerBottoneAggiuntivo.image1.Picture = "..\bmp\icone\termina.bmp"
	_oContainerBottoneAggiuntivo.image1.Picture = ""
	_oContainerBottoneAggiuntivo.image1.Stretch = 0
	_oContainerBottoneAggiuntivo.image1.BackStyle = 0
	_oContainerBottoneAggiuntivo.image1.Height = _nAltezzaTasti - 10
	_oContainerBottoneAggiuntivo.image1.Left = 5
	_oContainerBottoneAggiuntivo.image1.Top = 5
	_oContainerBottoneAggiuntivo.image1.Width = 20
	_oContainerBottoneAggiuntivo.image1.Visible = .T.

	_oContainerBottoneAggiuntivo.AddObject("label1","label")
	_oContainerBottoneAggiuntivo.label1.AutoSize = .F.
	_oContainerBottoneAggiuntivo.label1.FontBold = .T.
	_oContainerBottoneAggiuntivo.label1.FontSize = 8
	_oContainerBottoneAggiuntivo.label1.Alignment = 0
	_oContainerBottoneAggiuntivo.label1.BackStyle = 0
	_oContainerBottoneAggiuntivo.label1.Caption = ""
	_oContainerBottoneAggiuntivo.label1.Height = 15
	_oContainerBottoneAggiuntivo.label1.Left = 30
	_oContainerBottoneAggiuntivo.label1.Top = 16
	_oContainerBottoneAggiuntivo.label1.Width = 50
	_oContainerBottoneAggiuntivo.label1.ForeColor = RGB(255,255,255)
	_oContainerBottoneAggiuntivo.label1.Visible = .T.

	_oContainerBottoneAggiuntivo.AddObject("shape1","shape_bottone_aggiuntivo")
	_oContainerBottoneAggiuntivo.shape1.Top = 0
	_oContainerBottoneAggiuntivo.shape1.Left = 0
	_oContainerBottoneAggiuntivo.shape1.Height = _nAltezzaTasti
	_oContainerBottoneAggiuntivo.shape1.Width = _nLarghezzaTasti
	_oContainerBottoneAggiuntivo.shape1.BackStyle = 0
	_oContainerBottoneAggiuntivo.shape1.BorderStyle = 0
	_oContainerBottoneAggiuntivo.shape1.MousePointer = 15
	_oContainerBottoneAggiuntivo.shape1.BorderColor = RGB(255,0,0)
	_oContainerBottoneAggiuntivo.shape1.Visible = .T.
	

	DO CASE
		CASE I=1
			*** SCRIVO NELLA PROPRIETA' TAG DEL CONTAINER IL CODICE DA ESEGUIRE PER IL PULSANTE AGGIUNTIVO N°1
			_oContainerBottoneAggiuntivo.Tag = "DO FORM FORM\AQUA_DAY"
			*** INSERISCO LA SCRITTA DA VISUALIZZARE NELLA LABEL DEL PULSANTE AGGIUNTIVO N°1
			*_oContainerBottoneAggiuntivo.label1.Caption = "Data/ora"


			*** INSERISCO L'IMMAGINE DEL PULSANTE AGGIUNTIVO N°1 (BMP/PNG)
			_oContainerBottoneAggiuntivo.image1.Picture  = "..\bmp\ambiente\aqtoolbar\calendar-day.bmp"
			*_oContainerBottoneAggiuntivo.image1.Picture = "..\BMP\stile_windows8\clock.ico"

            _oContainerBottoneAggiuntivo.shape1.ToolTipText = "Mostra la data e l'ora attuali..."   		&& SETTO IL TOOLTIPTEXT DELL'OGGETTO SHAPE1 DEL CONTAINER
            *_oContainerBottoneAggiuntivo.shape_sfondo.BackStyle = 1                            				&& OGGETTO shape_sfondo NON TRASPARENTE, MA CON COLORE DI SFONDO VISIBILE
            _oContainerBottoneAggiuntivo.shape_sfondo.BackStyle = 0                            				&& OGGETTO shape_sfondo TRASPARENTE
            _oContainerBottoneAggiuntivo.shape_sfondo.BackColor = RGB(255,128,0)	              			&& COLORE OGGETTO SHAPE_SFONDO ARANCIONE
		    *_oContainerBottoneAggiuntivo.image1.visible = .F.												&& NON MOSTRA L'ICONA
  

		
		CASE I=2
			*** SCRIVO NELLA PROPRIETA' TAG DEL CONTAINER IL CODICE DA ESEGUIRE PER IL PULSANTE AGGIUNTIVO N°2
			_oContainerBottoneAggiuntivo.Tag = "DO FORM FORM\flusso LINKED"
			*** INSERISCO L'IMMAGINE DEL PULSANTE AGGIUNTIVO N°2 (BMP/PNG)
			_oContainerBottoneAggiuntivo.image1.Picture = "..\bmp\toolbar\sinottico.bmp"
			*** INSERISCO LA SCRITTA DA VISUALIZZARE NELLA LABEL DEL PULSANTE AGGIUNTIVO N°2
			*_oContainerBottoneAggiuntivo.label1.Caption = "Sinottico"
	
            _oContainerBottoneAggiuntivo.shape1.ToolTipText = "Sinottico"   								&& SETTO IL TOOLTIPTEXT DELL'OGGETTO SHAPE1 DEL CONTAINER
            *_oContainerBottoneAggiuntivo.shape_sfondo.BackStyle = 1                            			&& OGGETTO shape_sfondo NON TRASPARENTE, MA CON COLORE DI SFONDO VISIBILE
            _oContainerBottoneAggiuntivo.shape_sfondo.BackStyle = 0                            				&& OGGETTO shape_sfondo TRASPARENTE
            _oContainerBottoneAggiuntivo.shape_sfondo.BackColor = RGB(193,255,255)	              			&& COLORE OGGETTO SHAPE_SFONDO AZZURRINO
		    *_oContainerBottoneAggiuntivo.image1.visible = .F.												&& NON MOSTRA L'ICONA
	


		CASE I=3
			*** SCRIVO NELLA PROPRIETA' TAG DEL CONTAINER IL CODICE DA ESEGUIRE PER IL PULSANTE AGGIUNTIVO N°3
			_oContainerBottoneAggiuntivo.Tag = "DO FORM form\FLUSSI_ORGANIZZATIVI LINKED"
			*** INSERISCO L'IMMAGINE DEL PULSANTE AGGIUNTIVO N°3 (BMP/PNG)
			_oContainerBottoneAggiuntivo.image1.Picture = "..\bmp\ambiente\aqtoolbar\_flussi_organizzativi.bmp"
			*** INSERISCO LA SCRITTA DA VISUALIZZARE NELLA LABEL DEL PULSANTE AGGIUNTIVO N°3
			*_oContainerBottoneAggiuntivo.label1.Caption = "Flussi"


            _oContainerBottoneAggiuntivo.shape1.ToolTipText = "Flussi" 								  		&& SETTO IL TOOLTIPTEXT DELL'OGGETTO SHAPE1 DEL CONTAINER
            *_oContainerBottoneAggiuntivo.shape_sfondo.BackStyle = 1                           				&& OGGETTO shape_sfondo NON TRASPARENTE, MA CON COLORE DI SFONDO VISIBILE
            _oContainerBottoneAggiuntivo.shape_sfondo.BackStyle = 0                            				&& OGGETTO shape_sfondo TRASPARENTE
            _oContainerBottoneAggiuntivo.shape_sfondo.BackColor = RGB(209,253,181)	              			&& COLORE OGGETTO SHAPE_SFONDO VERDINO
		    *_oContainerBottoneAggiuntivo.image1.visible = .F.												&& NON MOSTRA L'ICONA


		CASE I=4
			*** SCRIVO NELLA PROPRIETA' TAG DEL CONTAINER IL CODICE DA ESEGUIRE PER IL PULSANTE AGGIUNTIVO N°4
			_oContainerBottoneAggiuntivo.Tag = ""
			*** INSERISCO L'IMMAGINE DEL PULSANTE AGGIUNTIVO N°4 (BMP/PNG)
			_oContainerBottoneAggiuntivo.image1.Picture = "..\bmp\ambiente\aqtoolbar\_flussi_organizzativi.bmp"
			*** INSERISCO LA SCRITTA DA VISUALIZZARE NELLA LABEL DEL PULSANTE AGGIUNTIVO N°4
			*_oContainerBottoneAggiuntivo.label1.Caption = "Flussi"


            _oContainerBottoneAggiuntivo.shape1.ToolTipText = "" 									  		&& SETTO IL TOOLTIPTEXT DELL'OGGETTO SHAPE1 DEL CONTAINER
            _oContainerBottoneAggiuntivo.shape_sfondo.BackStyle = 1                            				&& OGGETTO shape_sfondo NON TRASPARENTE, MA CON COLORE DI SFONDO VISIBILE
            _oContainerBottoneAggiuntivo.shape_sfondo.BackColor = RGB(209,253,181)	              			&& COLORE OGGETTO SHAPE_SFONDO VERDINO
		    _oContainerBottoneAggiuntivo.image1.visible = .F.												&& NON MOSTRA L'ICONA

		CASE I=5
			*** SCRIVO NELLA PROPRIETA' TAG DEL CONTAINER IL CODICE DA ESEGUIRE PER IL PULSANTE AGGIUNTIVO N°5
			_oContainerBottoneAggiuntivo.Tag = ""
			*** INSERISCO L'IMMAGINE DEL PULSANTE AGGIUNTIVO N°5 (BMP/PNG)
			_oContainerBottoneAggiuntivo.image1.Picture = "..\bmp\ambiente\aqtoolbar\_flussi_organizzativi.bmp"
			*** INSERISCO LA SCRITTA DA VISUALIZZARE NELLA LABEL DEL PULSANTE AGGIUNTIVO N°5
			*_oContainerBottoneAggiuntivo.label1.Caption = "Flussi"


            _oContainerBottoneAggiuntivo.shape1.ToolTipText = "" 									  		&& SETTO IL TOOLTIPTEXT DELL'OGGETTO SHAPE1 DEL CONTAINER
            _oContainerBottoneAggiuntivo.shape_sfondo.BackStyle = 1                            				&& OGGETTO shape_sfondo NON TRASPARENTE, MA CON COLORE DI SFONDO VISIBILE
            _oContainerBottoneAggiuntivo.shape_sfondo.BackColor = RGB(209,253,181)	              			&& COLORE OGGETTO SHAPE_SFONDO VERDINO
		    _oContainerBottoneAggiuntivo.image1.visible = .F.												&& NON MOSTRA L'ICONA

		CASE I=6
			*** SCRIVO NELLA PROPRIETA' TAG DEL CONTAINER IL CODICE DA ESEGUIRE PER IL PULSANTE AGGIUNTIVO N°6
			_oContainerBottoneAggiuntivo.Tag = ""
			*** INSERISCO L'IMMAGINE DEL PULSANTE AGGIUNTIVO N°6 (BMP/PNG)
			_oContainerBottoneAggiuntivo.image1.Picture = "..\bmp\ambiente\aqtoolbar\_flussi_organizzativi.bmp"
			*** INSERISCO LA SCRITTA DA VISUALIZZARE NELLA LABEL DEL PULSANTE AGGIUNTIVO N°5
			*_oContainerBottoneAggiuntivo.label1.Caption = "Flussi"


            _oContainerBottoneAggiuntivo.shape1.ToolTipText = "" 									  		&& SETTO IL TOOLTIPTEXT DELL'OGGETTO SHAPE1 DEL CONTAINER
            _oContainerBottoneAggiuntivo.shape_sfondo.BackStyle = 1                            				&& OGGETTO shape_sfondo NON TRASPARENTE, MA CON COLORE DI SFONDO VISIBILE
            _oContainerBottoneAggiuntivo.shape_sfondo.BackColor = RGB(209,253,181)	              			&& COLORE OGGETTO SHAPE_SFONDO VERDINO
		    _oContainerBottoneAggiuntivo.image1.visible = .F.												&& NON MOSTRA L'ICONA



	ENDCASE
 

	_nDistanzaTop = _nDistanzaTop_parte_fissa + (_nAltezzaTasti  + _nDistanzaTraTasti) * I 					&& IMPOSTAZIONE VERTICALE
	
NEXT
*** FINE CREAZIONE PULSANTI AGGIUNTIVI POSIZIONATI IN ALTO A DESTRA




ENDPROC


PROCEDURE ELIMINA_MENU_SU_SCREEN

IF TYPE("_SCREEN.container1") == 'O'
	_SCREEN.RemoveObject("container1")
ENDIF
IF TYPE("_SCREEN.text1") == 'O'
	_SCREEN.RemoveObject("text1")
ENDIF
IF TYPE("_SCREEN.txtPUB_DESSOC") == 'O'
	_SCREEN.RemoveObject("txtPUB_DESSOC")
ENDIF
IF TYPE("_SCREEN.txtpub_desbar2") == 'O'
	_SCREEN.RemoveObject("txtpub_desbar2")
ENDIF

FOR I=1 TO _NUMERO_TASTI_CREATI
	_cCommandRemove = "_SCREEN.RemoveObject('CmdContainer"+ALLTRIM(STR(I))+"')"
	_cCommandExist = "TYPE('_SCREEN.CmdContainer"+ALLTRIM(STR(I))+"') == 'O'"
	IF &_cCommandExist
		&_cCommandRemove
	ENDIF
NEXT

FOR I=1 TO _N_BOTTONI_AGGIUNTIVI_MENU_WIN8
	_cCommandRemove = "_SCREEN.RemoveObject('ContainerBottoneAggiuntivo"+ALLTRIM(STR(I))+"')"
	_cCommandExist = "TYPE('_SCREEN.ContainerBottoneAggiuntivo"+ALLTRIM(STR(I))+"') == 'O'"
	IF &_cCommandExist
		&_cCommandRemove
	ENDIF
NEXT

IF TYPE("_SCREEN.ContainerBottoneOpzioniMenu") == 'O'
	_SCREEN.RemoveObject("ContainerBottoneOpzioniMenu")
ENDIF

ENDPROC


PROCEDURE APRI_PROGRAMMA_DA_CMDCONTAINER_WIN8

LPARAMETERS _par_comando

_C_PRG=ALLTRIM(_par_comando)

LOCAL _oActiveFormRif
_oActiveFormRif = NULL

IF TYPE("_SCREEN.ActiveForm") == 'O'
	_oActiveFormRif = _SCREEN.ActiveForm
	_oActiveFormRif.Hide()
ELSE
	DO NASCONDI_MENU_SU_SCREEN
ENDIF

PUB_PROGRAMMA_ATTIVO = .T.

WAIT WINDOWS "Apertura programma/menu in corso..." NOWAIT

&_C_PRG

PUB_PROGRAMMA_ATTIVO = .F.

PUB_ARCH= "CUR_MENU"+ALLTRIM(STR(PUB_LUMAX))

IF TYPE("_oActiveFormRif") == 'O'
	_oActiveFormRif.show()
ELSE
	DO MOSTRA_MENU_SU_SCREEN
	_MAIN_MENU_RETURN = .F.
	_SCREEN.LockScreen = .F.
ENDIF

ENDPROC


PROCEDURE NASCONDI_MENU_SU_SCREEN

_SCREEN.container1.Visible = .F.
_SCREEN.text1.Visible = .F.
*_SCREEN.txtPUB_DESSOC.Visible = .F.
*_SCREEN.txtpub_desbar2.Visible = .F.

FOR I=1 TO _NUMERO_TASTI_CREATI
	_cCommandHide = "_SCREEN.CmdContainer"+ALLTRIM(STR(I))+".Visible = .F."
	&_cCommandHide
	_cCommandBorderColorShapeClick = "_SCREEN.CmdContainer"+ALLTRIM(STR(I))+".ShapeClick.MouseLeave"
	&_cCommandBorderColorShapeClick 
NEXT

FOR I=1 TO _N_BOTTONI_AGGIUNTIVI_MENU_WIN8
	_cCommandHide = "_SCREEN.ContainerBottoneAggiuntivo"+ALLTRIM(STR(I))+".Visible = .F."
	&_cCommandHide
	_cCommandBorderColorShape1 = "_SCREEN.ContainerBottoneAggiuntivo"+ALLTRIM(STR(I))+".Shape1.MouseLeave"
	&_cCommandBorderColorShape1
NEXT

_SCREEN.ContainerBottoneOpzioniMenu.Visible = .F.

_SCREEN.Refresh

ENDPROC

PROCEDURE MOSTRA_MENU_SU_SCREEN

_SCREEN.container1.Visible = .T.
_SCREEN.text1.Visible = .T.
_SCREEN.txtPUB_DESSOC.Visible = .T.
_SCREEN.txtpub_desbar2.Visible = .T.

FOR I=1 TO _NUMERO_TASTI_CREATI
	_cCommandShow = "_SCREEN.CmdContainer"+ALLTRIM(STR(I))+".Visible = .T."
	
	_cLabel = "__LABEL = _SCREEN.CmdContainer"+ALLTRIM(STR(I))+".label"
	_cMenu = "__MENU = _SCREEN.CmdContainer"+ALLTRIM(STR(I))+".menu"
	&_cLabel
	&_cMenu	
	x_user = "CODOPE = '" + PUB_CODOPE + "'"
	x_menu = "MENU = '" + __MENU + "'"
	x_labl = "LABEL = '" + STRTRAN(__LABEL,"'","''") + "'"
	x_hide = "HIDDEN = 1"
	x_cond = x_user + " and " + x_menu + " and " + x_labl + " and " + x_hide 
	cSql   = "SELECT HIDDEN FROM USER_MENU WHERE " + x_cond
	IF !ExecCommand(cSql,"TMP_USER_MENU")
	  return(.f.)
	ENDIF
	SELECT TMP_USER_MENU
	GO TOP
	IF !EOF()
		_cCommandShow = "_SCREEN.CmdContainer"+ALLTRIM(STR(I))+".Visible = .F."
	ENDIF
	
	&_cCommandShow
	_cCommandBorderColorShapeClick = "_SCREEN.CmdContainer"+ALLTRIM(STR(I))+".ShapeClick.MouseLeave"
	&_cCommandBorderColorShapeClick 
NEXT

FOR I=1 TO _N_BOTTONI_AGGIUNTIVI_MENU_WIN8
	_cCommandShow = "_SCREEN.ContainerBottoneAggiuntivo"+ALLTRIM(STR(I))+".Visible = .T."
	&_cCommandShow 
	_cCommandBorderColorShape1 = "_SCREEN.ContainerBottoneAggiuntivo"+ALLTRIM(STR(I))+".Shape1.MouseLeave"
	&_cCommandBorderColorShape1
NEXT

_SCREEN.ContainerBottoneOpzioniMenu.Visible = .T.

_SCREEN.Refresh

ENDPROC

