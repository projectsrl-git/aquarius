

*!*	_SCREEN.AddObject("text1","textbox")
*!*			FontBold = .T., ;
*!*			FontItalic = .F., ;
*!*			FontName = "Arial", ;
*!*			FontSize = 13, ;
*!*			FontCondense = .T., ;
*!*			FontExtend = .F., ;
*!*			Alignment = 0, ;
*!*			BackStyle = 0, ;
*!*			BorderStyle = 0, ;
*!*			Value = "", ;
*!*			ControlSource = "PUB_DESBAR1", ;
*!*			Enabled = .F., ;
*!*			Height = 19, ;
*!*			Left = 118, ;
*!*			Margin = 0, ;
*!*			ReadOnly = .T., ;
*!*			SpecialEffect = 0, ;
*!*			TabIndex = 71, ;
*!*			TabStop = .F., ;
*!*			Top = 36, ;
*!*			Width = 843, ;
*!*			ReleaseErase = .F., ;
*!*			Style = 1, ;
*!*			ColorSource = 4, ;
*!*			ColorScheme = 10, ;
*!*			ForeColor = RGB(255,255,255), ;
*!*			BackColor = RGB(128,128,255), ;
*!*			DisabledBackColor = RGB(255,255,255), ;
*!*			DisabledForeColor = RGB(255,255,255), ;
*!*			SelectedBackColor = RGB(128,128,255), ;
*!*			BorderColor = RGB(128,128,255), ;
*!*			Name = "Text1"
	

_SCREEN.AddObject("container1","container")
_SCREEN.container1.Top = 577
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

DEFINE CLASS shape_termina AS shape

	PROCEDURE click
			
		RELEASE THISFORM

		CLEAR EVENTS
		
	ENDPROC
	
ENDDEFINE

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




*!*		ADD OBJECT txtpub_dessoc AS textbox WITH ;
*!*			FontBold = .T., ;
*!*			FontItalic = .F., ;
*!*			FontName = "Arial", ;
*!*			FontSize = 14, ;
*!*			FontCondense = .T., ;
*!*			FontExtend = .F., ;
*!*			Alignment = 1, ;
*!*			BackStyle = 0, ;
*!*			BorderStyle = 0, ;
*!*			Value = "", ;
*!*			ControlSource = "PUB_DESSOC", ;
*!*			Enabled = .F., ;
*!*			Height = 27, ;
*!*			Left = 260, ;
*!*			Margin = 0, ;
*!*			ReadOnly = .T., ;
*!*			SpecialEffect = 0, ;
*!*			TabIndex = 71, ;
*!*			TabStop = .F., ;
*!*			Top = 404, ;
*!*			Width = 695, ;
*!*			ReleaseErase = .F., ;
*!*			Style = 0, ;
*!*			ColorSource = 4, ;
*!*			ColorScheme = 10, ;
*!*			ForeColor = RGB(255,255,255), ;
*!*			BackColor = RGB(255,255,128), ;
*!*			DisabledBackColor = RGB(255,128,128), ;
*!*			DisabledForeColor = RGB(255,255,255), ;
*!*			SelectedBackColor = RGB(128,128,255), ;
*!*			BorderColor = RGB(128,128,255), ;
*!*			Name = "txtPUB_DESSOC"


*!*		ADD OBJECT txtpub_desbar2 AS textbox WITH ;
*!*			FontBold = .T., ;
*!*			FontItalic = .F., ;
*!*			FontName = "Arial", ;
*!*			FontSize = 8, ;
*!*			FontCondense = .T., ;
*!*			FontExtend = .F., ;
*!*			Alignment = 1, ;
*!*			BackStyle = 0, ;
*!*			BorderStyle = 0, ;
*!*			Value = "", ;
*!*			ControlSource = "pub_desbar2", ;
*!*			Enabled = .F., ;
*!*			Height = 27, ;
*!*			Left = 260, ;
*!*			Margin = 0, ;
*!*			ReadOnly = .T., ;
*!*			SpecialEffect = 0, ;
*!*			TabIndex = 71, ;
*!*			TabStop = .F., ;
*!*			Top = 435, ;
*!*			Width = 695, ;
*!*			ReleaseErase = .F., ;
*!*			Style = 0, ;
*!*			ColorSource = 4, ;
*!*			ColorScheme = 10, ;
*!*			ForeColor = RGB(255,255,255), ;
*!*			BackColor = RGB(255,255,128), ;
*!*			DisabledBackColor = RGB(255,128,128), ;
*!*			DisabledForeColor = RGB(255,255,255), ;
*!*			SelectedBackColor = RGB(128,128,255), ;
*!*			BorderColor = RGB(128,128,255), ;
*!*			Name = "txtpub_desbar2"


*!*		ADD OBJECT cntsetcolori AS container WITH ;
*!*			Top = 7, ;
*!*			Left = 7, ;
*!*			Width = 26, ;
*!*			Height = 26, ;
*!*			BackStyle = 0, ;
*!*			BorderWidth = 0, ;
*!*			TabIndex = 95, ;
*!*			ToolTipText = "Cambia colori menu...", ;
*!*			Name = "cntSetColori"


*!*		ADD OBJECT aq_00.cntsetcolori.image1 AS image WITH ;
*!*			Picture = "..\bmp\stile_windows8\exit full screen.ico", ;
*!*			Stretch = 1, ;
*!*			BackStyle = 0, ;
*!*			Height = 21, ;
*!*			Left = 0, ;
*!*			Top = 2, ;
*!*			Width = 26, ;
*!*			Name = "Image1"


*!*		ADD OBJECT aq_00.cntsetcolori.label1 AS label WITH ;
*!*			AutoSize = .F., ;
*!*			FontBold = .T., ;
*!*			FontSize = 6, ;
*!*			Alignment = 2, ;
*!*			BackStyle = 0, ;
*!*			Caption = "", ;
*!*			Height = 12, ;
*!*			Left = 0, ;
*!*			Top = 32, ;
*!*			Width = 75, ;
*!*			ForeColor = RGB(0,0,128), ;
*!*			Name = "Label1"


*!*		ADD OBJECT aq_00.cntsetcolori.shape1 AS shape WITH ;
*!*			Top = 0, ;
*!*			Left = 0, ;
*!*			Height = 26, ;
*!*			Width = 26, ;
*!*			BackStyle = 0, ;
*!*			BorderStyle = 0, ;
*!*			MousePointer = 15, ;
*!*			ToolTipText = "Cambia colori menu...", ;
*!*			BorderColor = RGB(255,0,0), ;
*!*			Name = "Shape1"


*!*		PROCEDURE apri_programma

*!*			LPARAMETERS _par_TabIndex

*!*			SELECT &pub_arch
*!*			GO _par_TabIndex
*!*			_C_PRG=ALLTRIM(comando)

*!*			thisform.Hide()

*!*			PUB_PROGRAMMA_ATTIVO = .T.

*!*			&_C_PRG


*!*			PUB_PROGRAMMA_ATTIVO = .F.


*!*			PUB_ARCH= "CUR_MENU"+ALLTRIM(STR(PUB_LUMAX))
*!*			thisform.show()
*!*		ENDPROC


*!*		PROCEDURE apri_programma_da_cmdcontainer

*!*			LPARAMETERS _par_comando

*!*			_C_PRG=ALLTRIM(_par_comando)

*!*			thisform.Hide()

*!*			PUB_PROGRAMMA_ATTIVO = .T.

*!*			&_C_PRG

*!*			PUB_PROGRAMMA_ATTIVO = .F.

*!*			PUB_ARCH= "CUR_MENU"+ALLTRIM(STR(PUB_LUMAX))

*!*			thisform.show()
*!*		ENDPROC


*!*		PROCEDURE imposta_colore_tasti

*!*			** VERIFICA SE UTENTE DESIDERA PERSONALIZZARE IL MENU

*!*			SxxS=STR(SELECT())
*!*			x_cond = "CODICE = '" + ALLTRIM(PUB_CODOPE) + "'"
*!*			Csql   = "select * from res_oper where " + x_cond + " order by CODICE"
*!*			IF !ExecCommand(cSql,"Res_Oper_cu_")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT Res_Oper_cu_
*!*			GO TOP
*!*			IF !EOF()

*!*			 	M.RES_MENU_WIN8 = RES_MENU_WIN8 
*!*			 	M.RES_FULL_SCRE	= RES_FULL_SCRE
*!*			    M.RES_COLO_STAN = RES_COLO_STAN 
*!*			    M.RES_SFODESK 	= RES_SFODESK 
*!*			    M.RES_SFOPASS 	= RES_SFOPASS
*!*			    M.RES_SFOSUBM   = RES_SFOSUBM
*!*			    M.RES_SCRDESK 	= RES_SCRDESK 
*!*			    M.RES_SCRPASS 	= RES_SCRPASS 
*!*			    M.RES_COLTAST 	= RES_COLTAST 


*!*			ELSE

*!*			 	M.RES_MENU_WIN8 = .F.
*!*			 	M.RES_FULL_SCRE	= .F.
*!*			    M.RES_COLO_STAN = .F. 
*!*			    M.RES_SFODESK 	= 0 
*!*			    M.RES_SFOPASS 	= 0
*!*			    M.RES_SFOSUBM   = 0
*!*			    M.RES_SCRDESK 	= 0
*!*			    M.RES_SCRPASS 	= 0 
*!*			    M.RES_COLTAST 	= 0 
*!*			    
*!*			ENDIF


*!*			IF M.RES_SFODESK > 0	&& SFONDO PERSONALIZZATO PER OPERATORE

*!*				lnColor 			= M.RES_SFODESK
*!*				lnBlue 				= INT(lnColor / (256^2))
*!*				lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
*!*				lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
*!*				_RgbColor	 		= "RGB("+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+")"
*!*				_cColoreDesktop		= "THISFORM.backcolor = "+_RgbColor
*!*				&_cColoreDesktop
*!*				THISFORM.Picture 	= ""

*!*				_cColoreDesktop		= "_SCREEN.backcolor = "+_RgbColor
*!*				&_cColoreDesktop
*!*				_SCREEN.Picture 	= ""

*!*				IF TYPE("_SCREEN.oBackImage") == "O"
*!*					_SCREEN.oBackImage.Visible = .F.
*!*				ENDIF

*!*			ENDIF

*!*			IF  !M.RES_COLO_STAN AND  M.RES_COLTAST > 0		&& COLORE TASTI PERSONALIZZATI DA UTENTE

*!*				lnColor 			= M.RES_COLTAST
*!*				lnBlue 				= INT(lnColor / (256^2))
*!*				lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
*!*				lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
*!*				_RgbColor	 		= "RGB("+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+")"
*!*				_cShapeBckCo		= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = "+_RgbColor					&& COLORE TASTO PERSONALIZZATO

*!*				lnColor 			= M.RES_SCRDESK
*!*				lnBlue 				= INT(lnColor / (256^2))
*!*				lnGreen 			= INT((lnColor - lnBlue*256^2) / 256)
*!*				lnRed 				= INT(lnColor - (lnBlue*256^2 + lnGreen * 256))
*!*				_mouseleave	 		= "'"+ALLTRIM(STR(lnRed,3,0)) + ',' + ALLTRIM(STR(lnGreen,3,0)) + ',' + ALLTRIM(STR(lnBlue,3,0))+"'"
*!*				_cColoreLabelStd	= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseleave ="+_mouseleave			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*				_cColoreLabel		= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"			&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO
*!*				&_cColoreLabelStd
*!*				&_cColoreLabel
*!*				SELECT &SxxS
*!*				RETURN

*!*			ENDIF


*!*			SELECT &SxxS

*!*			_ctrTastiCol =  _ctrTastiCol + 1

*!*			DO CASE 

*!*				CASE _ctrTastiCol = 1
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(255,128,0)"					&& COLORE TASTO ARANCIONE
*!*					_cColoreLabelStd= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					_cColoreLabel= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 2
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

*!*				CASE _ctrTastiCol = 3
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 4
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					_cColoreLabel= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 5
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 6
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					_cColoreLabel= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 7
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 8
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					_cColoreLabel= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 9
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

*!*				CASE _ctrTastiCol = 10
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 11
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

*!*				CASE _ctrTastiCol = 12
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(253,234,198)"					&& COLORE TASTO OCRA CHIARO

*!*				CASE _ctrTastiCol = 13
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(187,255,119)"					&& COLORE TASTO VERDE CHIARETTO

*!*				CASE _ctrTastiCol = 14
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

*!*				CASE _ctrTastiCol = 15
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 16
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(192,192,192)"					&& COLORE TASTO GRIGETTO
*!*					_cColoreLabelStd= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseleave = '255,255,255'"			&& COLORE BIANCO PER LABEL E BORDO TASTO STANDARD
*!*					_cColoreLabel= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"				&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO

*!*				CASE _ctrTastiCol = 17
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(193,255,255)"					&& COLORE TASTO AZZURRINO

*!*				CASE _ctrTastiCol = 18
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(209,253,181)"					&& COLORE TASTO VERDINO

*!*				CASE _ctrTastiCol = 19
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(251,237,66)"					&& COLORE TASTO GIALLINO

*!*				CASE _ctrTastiCol = 20
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(187,255,119)"					&& COLORE TASTO VERDE CHIARETTO

*!*				CASE _ctrTastiCol = 21
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(102,179,255)"					&& COLORE TASTO AZZURRETTO

*!*				CASE _ctrTastiCol = 22
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(0,132,66)"						&& COLORE TASTO VERDE SCURO

*!*				CASE _ctrTastiCol = 23
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(251,237,66)"					&& COLORE TASTO GIALLINO

*!*				CASE _ctrTastiCol = 24
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(255,128,0)"					&& COLORE TASTO ARANCIONE

*!*				OTHERWISE
*!*					_cShapeBckCo= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(255,128,0)"					&& COLORE TASTO ARANCIONE


*!*			ENDCASE
*!*		ENDPROC


*!*		PROCEDURE setcolori


*!*			THISFORM.WindowState = 2  && MAXIMIZED
*!*			THISFORM.Picture = PUB_DINDIR+PUB_DESKTOP

*!*			_ctrTastiCol = 0

*!*			FOR _PROGRESSIVO_CONTAINER = 1 TO _NUMERO_TASTI_CREATI      

*!*				_oNewCmdContainerName = "CmdContainer"+ALLTRIM(STR(_PROGRESSIVO_CONTAINER))								&& NOME OGGETTO

*!*			*!*		IF TYPE("THISFORM."+_oNewCmdContainerName) = 'O'
*!*			*!*		ELSE
*!*			*!*			LOOP
*!*			*!*		ENDIF

*!*				_cShapeBckCo	= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(255,128,0)"				&& COLORE TASTO
*!*				_cColoreLabelStd= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseleave = '0,0,255'"				&& COLORE AZZURRO PER LABEL E BORDO TASTO STANDARD INIZIALMENTE ALL'INGRESSO DEL FORM
*!*				_cColoreLabel	= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"			&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO
*!*				thisform.imposta_colore_tasti()																			&& IMPOSTA COLORI TASTI																						&& ESEGUE COMANDO
*!*				&_cShapeBckCo																							&& ESEGUE COMANDO
*!*				&_cColoreLabelStd 
*!*				&_cColoreLabel

*!*			NEXT 

*!*			THISFORM.Refresh
*!*		ENDPROC


*!*		PROCEDURE Deactivate

*!*			LOCAL SWSX
*!*			SWSX=SELECT()

*!*			DO SET_SCREEN_CAPTION

*!*			SELECT(SWSX)

*!*			RETURN
*!*		ENDPROC


*!*		PROCEDURE Init
*!*			PARAMETERS __LIVELLO_MENU


*!*			=IMPOSTA_BACKGROUND_MENU_WIN8_E_SUCCESSIVI()


*!*			THISFORM.WindowState = 2  && MAXIMIZED
*!*			THISFORM.Picture = PUB_DINDIR+PUB_DESKTOP

*!*			RELEASE PUB_DESBAR1,PUB_DESBAR1_PRECEDENTE 
*!*			PUBLIC PUB_DESBAR1,PUB_DESBAR1_PRECEDENTE 
*!*			PUB_DESBAR1 = ""
*!*			PUB_DESBAR1_PRECEDENTE = ""

*!*			RELEASE _NUMERO_TASTI_CREATI
*!*			PUBLIC _NUMERO_TASTI_CREATI
*!*			_NUMERO_TASTI_CREATI = 0


*!*			RELEASE PUB_LIVELLO_MENU
*!*			PUBLIC PUB_LIVELLO_MENU
*!*			PUB_LIVELLO_MENU = __LIVELLO_MENU

*!*			PUB_LUMAX = 0
*!*			PUB_ARCH  = "CUR_TMENUL1"	&& CURSORE DEL PRIMO LIVELLO DEL MENU DOPO LA VERIFICA DELLE ABILITAZIONI PER L'OPERATORE CORRENTE


*!*			RELEASE PUB_SUBMENU_ATTIVO 
*!*			PUBLIC PUB_SUBMENU_ATTIVO 
*!*			PUB_SUBMENU_ATTIVO = .F.

*!*			_cWidthPulsantiMenuWin8  = "150"
*!*			_cHeightPulsantiMenuWin8 = "120"


*!*			SET CLASSLIB TO "cmdclass.vcx" additive				&& ATTIVA LA CLASSE PER LA DEFINIZIONE DEL CONTAINER

*!*			_ctrTastiCol   = 0
*!*			_nDistanzaLeft = 0
*!*			_nDistanzaTop  = 0


*!*			SELECT &PUB_ARCH	&& ELABORA IL CURSORE DEL PRIMO LIVELLO DEL MENU DOPO LA VERIFICA DELLE ABILITAZIONI PER L'OPERATORE CORRENTE
*!*			SET ORDER TO 
*!*			SET FILTER TO VISIBILE = 'S'
*!*			GO TOP 

*!*			_PROGRESSIVO_CONTAINER = 0

*!*			SCAN

*!*			    IF VISIBILE <> 'S'
*!*			    	SELECT &PUB_ARCH
*!*			    	LOOP
*!*			    ENDIF
*!*			 
*!*				IF _PROGRESSIVO_CONTAINER  > 24
*!*					EXIT
*!*				ENDIF


*!*				_PROGRESSIVO_CONTAINER = _PROGRESSIVO_CONTAINER +1
*!*			    _NUMERO_TASTI_CREATI   = _PROGRESSIVO_CONTAINER 

*!*				_oNewCmdContainerName = "CmdContainer"+ALLTRIM(STR(_PROGRESSIVO_CONTAINER))								&& NOME OGGETTO

*!*				THISFORM.NEWOBJECT(_oNewCmdContainerName,"cmdclass")													&& CREA OGGETTO

*!*				IF _PROGRESSIVO_CONTAINER  > 1 AND MOD(_PROGRESSIVO_CONTAINER -1,6) = 0									&& GESTISCE 6 TASTI PER RIGA
*!*					_nDistanzaLeft = 0																					&& GESTISCE 6 TASTI PER RIGA
*!*					_nDistanzaTop = _nDistanzaTop + VAL(_cHeightPulsantiMenuWin8) + 10									&& GESTISCE 6 TASTI PER RIGA
*!*				ENDIF																									&& GESTISCE 6 TASTI PER RIGA

*!*				_cLeft 			= "THISFORM."+_oNewCmdContainerName+".left = " + ALLTRIM(STR(120 + _nDistanzaLeft))		&& DISTANZA TRA I TASTI LATO SINISTRO
*!*				_cTop 			= "THISFORM."+_oNewCmdContainerName+".TOP = " + ALLTRIM(STR(63 + _nDistanzaTop))		&& DISTANZA TRA I TASTI LATO ALTO
*!*				_cWidth			= "THISFORM."+_oNewCmdContainerName+".Width = " + _cWidthPulsantiMenuWin8				&& LARGHEZZA TASTO
*!*				_cHeight		= "THISFORM."+_oNewCmdContainerName+".Height = " + _cHeightPulsantiMenuWin8				&& ALTEZZA TASTO
*!*				_cImageVisib	= "THISFORM."+_oNewCmdContainerName+".Image1.Visible = .F."								&& IMMAGINE SFONDO VISIBILE
*!*				_cShapeBckCo	= "THISFORM."+_oNewCmdContainerName+".Shape1.Backcolor = RGB(255,128,0)"				&& COLORE TASTO
*!*				_cColoreLabelStd= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseleave = '0,0,255'"				&& COLORE AZZURRO PER LABEL E BORDO TASTO STANDARD INIZIALMENTE ALL'INGRESSO DEL FORM
*!*				_cColoreLabel	= "THISFORM."+_oNewCmdContainerName+".colore_label_mouseenter = '72,72,255'"			&& COLORE AZZURRO CHIARO PER LABEL E BORDO TASTO SU MOUSEENTER	QUANDO VADO SOPRA IL TASTO
*!*				thisform.imposta_colore_tasti()																			&& IMPOSTA COLORI TASTI																						&& ESEGUE COMANDO
*!*				__LABEL			= ALLTRIM(LABEL)																		&& ETICHETTA RIGA COMANDO DA ESEGUIRE
*!*				__COMANDO		= STRTRAN(ALLTRIM(COMANDO),"\submenu","\AQMENU")										&& COMANDO DA ESEGUIRE : SOSTITUISCO SUBMENU CON AQMENU
*!*				__COMANDO		= STRTRAN(ALLTRIM(__COMANDO),"\SUBMENU","\AQMENU")										&& COMANDO DA ESEGUIRE : SOSTITUISCO SUBMENU CON AQMENU
*!*				__DESCRIZION	= ALLTRIM(DESCRIZION)																	&& DESCRIZIONE RIGA COMANDO
*!*				_cLblCaption	= "THISFORM."+_oNewCmdContainerName+".Label1.Caption = __LABEL"							&&
*!*				_cTag			= "THISFORM."+_oNewCmdContainerName+".Tag = __COMANDO"									&& ESECUZIONE COMANDO
*!*				_cShapeToolT	= "THISFORM."+_oNewCmdContainerName+".ShapeClick.ToolTipText = __DESCRIZION"			&& MOSTRA NEL TOOLTIPTEXT LA DESCRIZIONE DELLA RIGA DI COMANDO
*!*				_cRidimens		= "THISFORM."+_oNewCmdContainerName+".ridimensiona()"									&&
*!*				_cVisible 		= "THISFORM."+_oNewCmdContainerName+".VISIBLE = .T."									&&

*!*				&_cLeft																									&& ESEGUE COMANDO
*!*				&_cTop																									&& ESEGUE COMANDO
*!*				&_cWidth																								&& ESEGUE COMANDO
*!*				&_cHeight																								&& ESEGUE COMANDO
*!*				&_cImageVisib																							&& ESEGUE COMANDO
*!*				&_cShapeBckCo																							&& ESEGUE COMANDO
*!*				&_cColoreLabelStd 
*!*				&_cColoreLabel
*!*				&_cLblCaption																							&& ESEGUE COMANDO
*!*				&_cTag																									&& ESEGUE COMANDO
*!*				&_cShapeToolT																							&& ESEGUE COMANDO
*!*				&_cRidimens																								&& ESEGUE COMANDO
*!*				&_cVisible


*!*				_nDistanzaLeft = _nDistanzaLeft + VAL(_cWidthPulsantiMenuWin8) + 10										&& IL PROSSIMO TASTO PARTE 10 PIXEL A DESTRA

*!*			*!*		IF !EMPTY(LABEL)
*!*			*!*			_lblcaption = "thisform.label"+ALLTRIM(STR(RECNO()))+".caption"
*!*			*!*			_lblvisible = "thisform.label"+ALLTRIM(STR(RECNO()))+".visible"
*!*			*!*			_imgvisible = "thisform.image"+ALLTRIM(STR(RECNO()))+".visible"
*!*			*!*			_lblenabled = "thisform.label"+ALLTRIM(STR(RECNO()))+".enabled"
*!*			*!*			_lblleft	= "thisform.label"+ALLTRIM(STR(RECNO()))+".left"
*!*			*!*			_lblwidth	= "thisform.label"+ALLTRIM(STR(RECNO()))+".width"

*!*			*!*			_imgleft	= "thisform.imgNew"+ALLTRIM(STR(RECNO()))+".left"
*!*			*!*			_imgvisible	= "thisform.imgNew"+ALLTRIM(STR(RECNO()))+".visible"
*!*			*!*
*!*			*!*			&_lblcaption = ALLTRIM(label)
*!*			*!*			&_lblvisible = .t.
*!*			*!*
*!*			*!*			IF AUTORIZZAZIONE
*!*			*!*
*!*			*!*				** CONTROLLO SE FORM O PRG è AGGIORNATO O MENO
*!*			*!*				stringa = ALLTRIM(COMANDO)
*!*			*!*				_STRDO = STR_EXTRACT(COMANDO, SPACE(1), 1)
*!*			*!*				IF ALLTRIM(_STRDO) <> ""
*!*			*!*					_STRFRM = STR_EXTRACT(COMANDO, SPACE(1), 2)
*!*			*!*					IF UPPER(ALLTRIM(_STRFRM)) = "FORM"
*!*			*!*						_STRFORM = STR_EXTRACT(COMANDO, SPACE(1), 3)

*!*			*!*						******** CONTROLLO SE è AGGIORNATO
*!*			*!*
*!*			*!*						IF DAYLASTMOD( PUB_DIR + "\" + ALLTRIM(_STRFORM) + ".SCT" ) < PUB_DAYNEW
*!*			*!*							&_imgleft =  &_lblleft + &_lblwidth + 10
*!*			*!*							** controllo se è nuovo
*!*			*!*							&_imgvisible = .T.
*!*			*!*						ENDIF
*!*			*!*
*!*			*!*					ELSE
*!*			*!*						** CHECK PRG

*!*			*!*						IF DAYLASTMOD( PUB_DIR + "\" + ALLTRIM(_STRFRM) + ".PRG" ) < PUB_DAYNEW
*!*			*!*							&_imgleft =  &_lblleft + &_lblwidth + 10
*!*			*!*							** controllo se è nuovo
*!*			*!*							&_imgvisible = .T.
*!*			*!*						ENDIF
*!*			*!*
*!*			*!*					ENDIF
*!*			*!*				ENDIF
*!*			*!*			ELSE
*!*			*!*				&_lblenabled = .F.
*!*			*!*			ENDIF
*!*			*!*		ENDIF


*!*			ENDSCAN 
*!*		ENDPROC


*!*		PROCEDURE Destroy

*!*			*PUB_LUMAX=PUB_LUMAX-1
*!*			PUB_SUBMENU_ATTIVO = .F.
*!*		ENDPROC


*!*		PROCEDURE Activate

*!*			nRightDistance = 10
*!*			THISFORM.txtPUB_DESSOC.Left = THISFORM.Width - THISFORM.txtPUB_DESSOC.Width - nRightDistance
*!*			THISFORM.txtpub_desbar2.Left = THISFORM.Width - THISFORM.TXTpub_desbar2.Width - nRightDistance
*!*			nBottomDistance = 34
*!*			THISFORM.txtpub_desbar2.Top = THISFORM.Height - THISFORM.TXTpub_desbar2.Height - nBottomDistance 
*!*			THISFORM.txtPUB_DESSOC.Top = THISFORM.TXTpub_desbar2.Top - THISFORM.TXTpub_desbar2.Height
*!*		ENDPROC


*!*		PROCEDURE image1.Click
*!*		ENDPROC


*!*		PROCEDURE shape1.MouseLeave
*!*			LPARAMETERS nButton, nShift, nXCoord, nYCoord

*!*			this.BorderStyle= 0

*!*			THIS.Parent.LAbel1.FORECOLOR = RGB(255,255,255)
*!*		ENDPROC


*!*		PROCEDURE shape1.MouseEnter
*!*			LPARAMETERS nButton, nShift, nXCoord, nYCoord

*!*			this.BorderStyle= 1

*!*			THIS.Parent.LAbel1.ForeColor = RGB(255,255,255)
*!*		ENDPROC


*!*		PROCEDURE shape1.Click

*!*			RELEASE THISFORM

*!*			CLEAR EVENTS
*!*		ENDPROC


*!*		PROCEDURE shape1.Click

*!*			thisform.Hide()

*!*			DO FORM form\menu_set_menu LINKED
*!*			thisform.SETCOLORI()

*!*			thisform.show()
*!*		ENDPROC


*!*		PROCEDURE shape1.MouseEnter
*!*			LPARAMETERS nButton, nShift, nXCoord, nYCoord

*!*			this.BorderStyle= 1

*!*			THIS.Parent.LAbel1.ForeColor = RGB(255,0,0)
*!*		ENDPROC


*!*		PROCEDURE shape1.MouseLeave
*!*			LPARAMETERS nButton, nShift, nXCoord, nYCoord

*!*			this.BorderStyle= 0

*!*			THIS.Parent.LAbel1.ForeColor = RGB(0,0,255)
*!*		ENDPROC

