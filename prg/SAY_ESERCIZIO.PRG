
_SCREEN.Caption   = "E.R.P. Aquarius  www.projectsrl.net    " + "[" + ALLTRIM(XXX_VERSIONE)+"]    " + "Data " + XXX_DATA + " Ora inizio " + XXX_TIME


_SCREEN.WindowState = 2
ZTF.COMMAND1.CAPTION="Anno: "+PUB_ANNO

*IF PUB_MENU_WIN8 			&& ESCLUSO MENU WIN8 E SUPERIORI : CONTROLLO GENERALE A LIVELLO AZIENDALE
IF PUB_MENU_WIN8_UTENTE 	&& ESCLUSO MENU WIN8 E SUPERIORI : CONTROLLO SUL SINGOLO OPERATORE
	
	*** ELIMINO EVENTUALI SCRITTE ED IMMAGINI SULLO SFONDO DELLO _SCREEN
*!*		IF TYPE("_SCREEN.oBackImage") == "O"
*!*			_SCREEN.RemoveObject("oBackImage")
*!*		ENDIF
	IF TYPE("_SCREEN.Image2")=="O"
		_SCREEN.RemoveObject("IMAGE2")
	ENDIF
	IF TYPE("_SCREEN.lblEsercizio1")=="O"
		_SCREEN.RemoveObject("lblEsercizio1")
	ENDIF
	IF TYPE("_SCREEN.lblEsercizio2")=="O"
		_SCREEN.RemoveObject("lblEsercizio2")
	ENDIF
	IF TYPE("_SCREEN.lblEsercizio3")=="O"
		_SCREEN.RemoveObject("lblEsercizio3")
	ENDIF

	RETURN
ENDIF

_SCREEN.BACKCOLOR = RGB(60,112,167)

_PATH_SFONDO_AQUARIUS = PUB_DINDIR+PUB_DESKTOP

**=> ERASMO - INIZIO 15/09/2020
V_SFONDO_PERSONALIZZATO = ALLTRIM(PUB_DIR)+"\"+SUBSTR(PUB_CODOPE,1,20)+ALLTRIM(PUB_IDSOCI)+".JPG"
IF FILE(V_SFONDO_PERSONALIZZATO)
	_PATH_SFONDO_AQUARIUS = V_SFONDO_PERSONALIZZATO
ENDIF
**=> ERASMO - FINE 15/09/2020

_resolution_bckgrnd = SetResolutionBackground(_PATH_SFONDO_AQUARIUS)
IF !EMPTY(_resolution_bckgrnd) AND FILE(_resolution_bckgrnd)
	_SCREEN.Picture = _resolution_bckgrnd
ELSE
	_SCREEN.Picture = ""
	IF !EMPTY(_PATH_SFONDO_AQUARIUS) .AND. FILE(_PATH_SFONDO_AQUARIUS)
		IF !TYPE("_SCREEN.oBackImage") == "O"
			_SCREEN.AddObject("oBackImage","IMAGE")
		ENDIF
		_SCREEN.oBackImage.Picture = _PATH_SFONDO_AQUARIUS
		_SCREEN.oBackImage.BackStyle = 1
		_SCREEN.oBackImage.Top = 0
		_SCREEN.oBackImage.Left = 0
		_SCREEN.oBackImage.Height = _SCREEN.Height
		_SCREEN.oBackImage.Width = _SCREEN.Width
		_SCREEN.oBackImage.Stretch = 2
		_SCREEN.oBackImage.Visible = .T.
	ENDIF
ENDIF

IF PUB_AQUAR
	IF TYPE("_SCREEN.Image2")=="U"
		_SCREEN.AddObject("IMAGE2","IMAGE")
	ENDIF 
	_SCREEN.Image2.Picture=PUB_DINDIR +'\AQ_SCRITTA.GIF'
	_SCREEN.Image2.BackStyle= 0
	_SCREEN.Image2.Top=SYSMETRIC(2)-_SCREEN.Image2.Height-100-20
	_SCREEN.Image2.LEFT=SYSMETRIC(1)-_SCREEN.Image2.WIDTH+1-40
	_SCREEN.Image2.Visible= .T.
ENDIF


_FILE_SFONDO_PERSONALIZZATO = SUBSTR(PUB_CODOPE,1,3)+ALLTRIM(PUB_IDSOCI)+'.JPG'

IF FILE(_FILE_SFONDO_PERSONALIZZATO)
	   _SCREEN.PICTURE=_FILE_SFONDO_PERSONALIZZATO 
ENDIF

_FILE_AMBIENTE_DI_TEST = 'AMBIENTE_TEST.BMP'

IF FILE(_FILE_AMBIENTE_DI_TEST)
	   _SCREEN.PICTURE=_FILE_AMBIENTE_DI_TEST 
ENDIF




IF PUB_SCRIT_B
	IF TYPE("_screen.lblEsercizio1") == 'O'
	   _screen.RemoveObject("lblEsercizio1")
	ENDIF
	_screen.AddObject("lblEsercizio1","label")
	WITH _screen.lblEsercizio1
	   .caption = ALLTRIM(PUB_DESSOC)
	   .autosize = .t.
	   .backstyle = 0
	   .fontname = "TIMES NEW ROMAN"
	   .fontsize = 34
	   .fontitalic = .t.
	   .move(10,400)
	   .visible = .t.
	   .backColor = RGB(255,255,255)
	   .DisabledBackColor = RGB(255,255,255)
	   .ForeColor = RGB(255,255,255)       
	ENDWITH

	IF TYPE("_screen.lblEsercizio2") == 'O'
	   _screen.RemoveObject("lblEsercizio2")
	ENDIF
	_screen.AddObject("lblEsercizio2","label")
	WITH _screen.lblEsercizio2
	   .caption = "Esercizio contabile: " + PUB_ANNO
	   .autosize = .t.
	   .backstyle = 0
	   .fontname = "TIMES NEW ROMAN"
	   .fontsize = 34
	   .fontitalic = .t.
	   .move(10,450)
	   .visible = .t.
	   .backColor = RGB(255,255,255)
	   .DisabledBackColor = RGB(255,255,255)
	   .ForeColor = RGB(255,255,255)       
	ENDWITH

	IF TYPE("_screen.lblEsercizio3") == 'O'
	   _screen.RemoveObject("lblEsercizio3")
	ENDIF
	_screen.AddObject("lblEsercizio3","label")
	WITH _screen.lblEsercizio3
	   .caption = "Aquarius by Project - " + PUB_NOMOPE
	   .autosize = .t.
	   .backstyle = 0
	   .fontname = "TIMES NEW ROMAN"
	   .fontsize = 16
	   .fontitalic = .t.
	   .move(10,500)
	   .visible = .t.
	   .backColor = RGB(255,255,255)
	   .DisabledBackColor = RGB(255,255,255)
	   .ForeColor = RGB(255,255,255)       
	ENDWITH
ENDIF

IF PUB_SCRIT_N
	IF TYPE("_screen.lblEsercizio1") == 'O'
	   _screen.RemoveObject("lblEsercizio1")
	ENDIF
	_screen.AddObject("lblEsercizio1","label")
	WITH _screen.lblEsercizio1
	   .caption = ALLTRIM(PUB_DESSOC)
	   .autosize = .t.
	   .backstyle = 0
	   .fontname = "TIMES NEW ROMAN"
	   .fontsize = 34
	   .fontitalic = .t.
	   .move(10,400)
	   .visible = .t.
	   .backColor = RGB(0,0,0)
	   .DisabledBackColor = RGB(0,0,0)
	   .ForeColor = RGB(0,0,0)       
	ENDWITH

	IF TYPE("_screen.lblEsercizio2") == 'O'
	   _screen.RemoveObject("lblEsercizio2")
	ENDIF
	_screen.AddObject("lblEsercizio2","label")
	WITH _screen.lblEsercizio2
	   .caption = "Esercizio contabile: " + PUB_ANNO
	   .autosize = .t.
	   .backstyle = 0
	   .fontname = "TIMES NEW ROMAN"
	   .fontsize = 34
	   .fontitalic = .t.
	   .move(10,450)
	   .visible = .t.
	   .backColor = RGB(0,0,0)
	   .DisabledBackColor = RGB(0,0,0)
	   .ForeColor = RGB(0,0,0)       
	ENDWITH

	IF TYPE("_screen.lblEsercizio3") == 'O'
	   _screen.RemoveObject("lblEsercizio3")
	ENDIF
	_screen.AddObject("lblEsercizio3","label")
	WITH _screen.lblEsercizio3
	   .caption = "Aquarius by Project - " + PUB_NOMOPE
	   .autosize = .t.
	   .backstyle = 0
	   .fontname = "TIMES NEW ROMAN"
	   .fontsize = 16
	   .fontitalic = .t.
	   .move(10,500)
	   .visible = .t.
	   .backColor = RGB(0,0,0)
	   .DisabledBackColor = RGB(0,0,0)
	   .ForeColor = RGB(0,0,0)       
	ENDWITH
ENDIF


IF PUB_SCRIT_R
	IF TYPE("_screen.lblEsercizio1") == 'O'
	   _screen.RemoveObject("lblEsercizio1")
	ENDIF
	_screen.AddObject("lblEsercizio1","label")
	WITH _screen.lblEsercizio1
	   .caption = ALLTRIM(PUB_DESSOC)
	   .autosize = .t.
	   .backstyle = 0
	   .fontname = "TIMES NEW ROMAN"
	   .fontsize = 34
	   .fontitalic = .t.
	   .move(10,400)
	   .visible = .t.
	   .backColor = RGB(255,0,0)
	   .DisabledBackColor = RGB(255,0,0)
	   .ForeColor = RGB(255,0,0)       
	ENDWITH

	IF TYPE("_screen.lblEsercizio2") == 'O'
	   _screen.RemoveObject("lblEsercizio2")
	ENDIF
	_screen.AddObject("lblEsercizio2","label")
	WITH _screen.lblEsercizio2
	   .caption = "Esercizio contabile: " + PUB_ANNO
	   .autosize = .t.
	   .backstyle = 0
	   .fontname = "TIMES NEW ROMAN"
	   .fontsize = 34
	   .fontitalic = .t.
	   .move(10,450)
	   .visible = .t.
	   .backColor = RGB(255,0,0)
	   .DisabledBackColor = RGB(255,0,0)
	   .ForeColor = RGB(255,0,0)       
	ENDWITH

	IF TYPE("_screen.lblEsercizio3") == 'O'
	   _screen.RemoveObject("lblEsercizio3")
	ENDIF
	_screen.AddObject("lblEsercizio3","label")
	WITH _screen.lblEsercizio3
	   .caption = "Aquarius by Project - " + PUB_NOMOPE
	   .autosize = .t.
	   .backstyle = 0
	   .fontname = "TIMES NEW ROMAN"
	   .fontsize = 16
	   .fontitalic = .t.
	   .move(10,500)
	   .visible = .t.
	   .backColor = RGB(255,0,0)
	   .DisabledBackColor = RGB(255,0,0)
	   .ForeColor = RGB(255,0,0)       
	ENDWITH
ENDIF


