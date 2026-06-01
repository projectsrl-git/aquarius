
***************************************************************************
PROCEDURE MAGLOG_DEFA_CAR
***************************************************************************
** CREA UN FORM DINAMICO DI SELEZIONE DELLA LOCAZIONE GIA' PRECEDENTEMENTE
** UTILIZZATA PER IL CARICO DEL CODICE ARTICOLO PASSATO NEI PARAMETRI
***************************************************************************
LPARAMETERS _par_codart
	
IF PCOUNT() < 1
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(_par_codart)
	RETURN .F.
ENDIF

IF !PUB_MAGLOG
	RETURN .F.
ENDIF

frmlocazcar1 = CREATEOBJECT("frmlocazcar",_par_codart)
frmlocazcar1.SHOW

RELEASE frmlocazcar1

ENDPROC


**************************************************
*-- FORM DI SELEZIONE LOCAZIONE DI CARICO PER ARTICOLO SU MAGAZZINO LOGISTICO
*-- Form:         frmlocazcar
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   04/12/2012 09:43:02
*
DEFINE CLASS frmlocazcar AS form
	
	BorderStyle = 1  && Fixed Single
	Height = 100
	Width = 130
	ScrollBars = 2
	DoCreate = .T.
	AutoCenter = .T.
	Caption = "Locazioni predefinite magazzino logistico"
	FontBold = .T.
	FontSize = 10
	HalfHeightCaption = .F.
	MaxButton = .F.
	MinButton = .F.
	*Visible = .T.
	Icon = "..\ico\2_aquarius.ico"
	TitleBar = 1
	WindowType = 1
	WindowState = 0
	LockScreen = .F.
	ColorSource = 5
	ForeColor = RGB(192,192,192)
	BackColor = RGB(192,192,192)
	Themes = .F.
	Name = "FrmLocazCar"
	*Desktop = .T.
	TitleBar = 0  &&  Off
	ShowTips = .T.


	PROCEDURE Activate
		
		IF USED("CUR_MOV_LOC")
			SELECT CUR_MOV_LOC
			GO TOP
			IF EOF()
				USE
				RELEASE THISFORM
			ENDIF
		ELSE
			RELEASE THISFORM
		ENDIF
		
	ENDPROC


	PROCEDURE Init

		LPARAMETERS _par_codart
		
		IF PCOUNT() < 1
			MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
			RETURN .F.
		ENDIF

		WAIT WINDOW "Ricerca locazioni predefinite magazzino logistico in corso..." NOWAIT

		_W_CODART = ALLTRIM(_par_codart)

		_XX_MAXCOLS = 6
		
		IF USED("CUR_MOV_LOC")
			SELECT CUR_MOV_LOC
			USE
		ENDIF
		x_arti = "MOV_ANAART = '" + _W_CODART + "'"
		x_maga = "MOV_CODMAG <> ''"
		x_filn = "MOV_FILA_N > 0"
		x_pian = "MOV_PIAN_N > 0"
		x_ubin = "MOV_UBIC_N > 0"
		x_cond1 = x_arti + " and " + x_maga + " and " + x_filn + " and " + x_pian + " and " + x_ubin 
		x_maga = "LOC_CODMAG = (SELECT ART_MAGA FROM U_ART_PR WHERE ART_CODPRI = '" + _W_CODART + "')"
		x_fsel = "LOC_FILSEL = 1"
		x_cond2 = x_maga + " and " + x_fsel
		cSql = "SELECT '1' AS FLG_USED, MOV_CODMAG, DESCRI AS MOV_DESMAG, " + CHR(13) + ;
		       "	LOC_FILALF, LOC_FILNUM, LOC_FDESCR, LOC_PIAALF, LOC_PIANUM, LOC_UBIALF, LOC_UBINUM, COALESCE(GG.MAG_GIACEN,0) AS MAG_GIACEN " + CHR(13) + ;
		       "FROM U_MAG_MO AS MO " + CHR(13) + ;
		       "INNER JOIN U_LOC_GE AS LOC ON LOC.LOC_CODMAG = MO.MOV_CODMAG AND LOC.LOC_FILNUM = MO.MOV_FILA_N AND " + CHR(13) + ;
		       "	LOC.LOC_PIANUM = MO.MOV_PIAN_N AND LOC.LOC_UBINUM = MO.MOV_UBIC_N AND LOC_FILSEL = 1 " + CHR(13) + ;
		       "LEFT OUTER JOIN (SELECT CODICE, DESCRI FROM PARA) AS PARA ON PARA.CODICE = 'MAG'+MO.MOV_CODMAG " + CHR(13) + ;
		       "LEFT OUTER JOIN (SELECT MAG_ANAART, MAG_CODMAG, MAG_FILA_N, MAG_PIAN_N, MAG_UBIC_N, SUM(MAG_GIACEN) AS MAG_GIACEN " + CHR(13) + ;
		       "	FROM U_MAG_GG WHERE MAG_ANAART = '" + _W_CODART + "' AND MAG_DATAGG <> '' AND MAG_GIACEN > 0 " + CHR(13) + ;
		       "	GROUP BY MAG_ANAART, MAG_CODMAG, MAG_FILA_N, MAG_PIAN_N, MAG_UBIC_N) AS GG " + CHR(13) + ;
		       "	ON GG.MAG_CODMAG = LOC.LOC_CODMAG AND GG.MAG_FILA_N = LOC.LOC_FILNUM AND GG.MAG_PIAN_N = LOC.LOC_PIANUM AND GG.MAG_UBIC_N = LOC.LOC_UBINUM " + CHR(13) + ;
		       "WHERE " + x_cond1 + " " + CHR(13) + ;
		       "GROUP BY MOV_CODMAG, DESCRI, LOC_FILALF, LOC_FILNUM, LOC_FDESCR, LOC_PIAALF, LOC_PIANUM, LOC_UBIALF, LOC_UBINUM, MAG_GIACEN " + CHR(13) + ;
		       "UNION " + CHR(13) + ;
		       "SELECT '2' AS FLG_USED, LOC_CODMAG AS MOV_CODMAG, DESCRI AS MOV_DESMAG, " + CHR(13) + ;
		       "	LOC_FILALF, LOC_FILNUM, LOC_FDESCR, LOC_PIAALF, LOC_PIANUM, LOC_UBIALF, LOC_UBINUM, COALESCE(GG.MAG_GIACEN,0) AS MAG_GIACEN " + CHR(13) + ;
		       "FROM U_LOC_GE AS LOC " + CHR(13) + ;
		       "LEFT OUTER JOIN (SELECT CODICE, DESCRI FROM PARA) AS PARA ON PARA.CODICE = 'MAG'+LOC.LOC_CODMAG " + CHR(13) + ;
		       "LEFT OUTER JOIN (SELECT MAG_ANAART, MAG_CODMAG, MAG_FILA_N, MAG_PIAN_N, MAG_UBIC_N, SUM(MAG_GIACEN) AS MAG_GIACEN " + CHR(13) + ;
		       "	FROM U_MAG_GG WHERE MAG_ANAART = '" + _W_CODART + "' AND MAG_DATAGG <> '' AND MAG_GIACEN > 0 " + CHR(13) + ;
		       "	GROUP BY MAG_ANAART, MAG_CODMAG, MAG_FILA_N, MAG_PIAN_N, MAG_UBIC_N) AS GG " + CHR(13) + ;
		       "	ON GG.MAG_CODMAG = LOC.LOC_CODMAG AND GG.MAG_FILA_N = LOC.LOC_FILNUM AND GG.MAG_PIAN_N = LOC.LOC_PIANUM AND GG.MAG_UBIC_N = LOC.LOC_UBINUM " + CHR(13) + ;
		       "WHERE " + x_cond2 + " " + CHR(13) + ;
		       "ORDER BY FLG_USED, MOV_CODMAG, DESCRI, LOC_FILALF, LOC_FILNUM, LOC_FDESCR, LOC_PIAALF, LOC_PIANUM, LOC_UBIALF, LOC_UBINUM"
		IF !ExecCommand(cSql,"TMP_MOV_LOC")
			RETURN .F.
		ENDIF
		SELECT TMP_MOV_LOC
		GO TOP
		IF EOF()
			WAIT CLEAR
			RETURN
		ENDIF
		
		*** ELIMINO LOCAZIONI DOPPIE (QUELLE MAI USATE)
		SELECT * FROM TMP_MOV_LOC WHERE FLG_USED = '1' INTO CURSOR TMP_MOV_LOC_USED
		SELECT TMP_MOV_LOC_USED
		GO TOP
		SCAN
			_MOV_CODMAG = MOV_CODMAG
			_LOC_FILNUM = LOC_FILNUM
			_LOC_PIANUM = LOC_PIANUM
			_LOC_UBINUM = LOC_UBINUM
			SELECT TMP_MOV_LOC
			DELETE FOR FLG_USED = '2' AND ALLTRIM(MOV_CODMAG) == ALLTRIM(_MOV_CODMAG) AND LOC_FILNUM = _LOC_FILNUM AND LOC_PIANUM = _LOC_PIANUM AND LOC_UBINUM = _LOC_UBINUM
		    SELECT TMP_MOV_LOC_USED
		ENDSCAN

		*** SERGIO 2014-09-13 ELIMINO LOCAZIONI UTILIZZATE SE NON DESIDERATE DALL'UTENTE IN BASE AI PARAMETRI DI SISTEMA
		IF PUB_NOLOCCM
			SELECT * FROM TMP_MOV_LOC  INTO CURSOR TMP_MOV_LOC_CARICATE
			SELECT TMP_MOV_LOC_CARICATE
			GO TOP
			SCAN
				_MOV_CODMAG = MOV_CODMAG
				_LOC_FILNUM = LOC_FILNUM
				_LOC_PIANUM = LOC_PIANUM
				_LOC_UBINUM = LOC_UBINUM
				SELECT TMP_MOV_LOC
				DELETE FOR MAG_GIACEN > 0 AND ALLTRIM(MOV_CODMAG) == ALLTRIM(_MOV_CODMAG) AND LOC_FILNUM = _LOC_FILNUM AND LOC_PIANUM = _LOC_PIANUM AND LOC_UBINUM = _LOC_UBINUM
			    SELECT TMP_MOV_LOC_CARICATE
			ENDSCAN
		ENDIF
		*** SERGIO 2014-09-13 ELIMINO LOCAZIONI UTILIZZATE SE NON DESIDERATE DALL'UTENTE IN BASE AI PARAMETRI DI SISTEMA
		
		
		SELECT * FROM TMP_MOV_LOC INTO CURSOR CUR_MOV_LOC READWRITE
		SELECT CUR_MOV_LOC
		INDEX ON FLG_USED+MOV_CODMAG+STR(LOC_FILNUM)+STR(LOC_PIANUM)+STR(LOC_UBINUM) TAG I_ORDINE
		SET ORDER TO I_ORDINE
		GO TOP
		
		_XX_MAXROWS = CEILING(RECCOUNT() / _XX_MAXCOLS)
		_XX_CMDW = 130
		_XX_CMDH = 80

		THISFORM.Width = _XX_CMDW * _XX_MAXCOLS
		THISFORM.Height = 480

		IF _XX_MAXROWS * _XX_CMDH > 480
			*THISFORM.Height = 480
		ELSE
			THISFORM.ScrollBars = 0
			*THISFORM.Height = _XX_MAXROWS * _XX_CMDH
		ENDIF

		IF RECCOUNT() > _XX_MAXCOLS
			*THISFORM.Width = _XX_MAXCOLS * _XX_CMDW
		ELSE
			*THISFORM.Width = RECCOUNT() * _XX_CMDW
		ENDIF
		
		_nScrollBarsWidth = 0
		IF THISFORM.ScrollBars > 0
			_nScrollBarsWidth = 16
			THISFORM.Width = THISFORM.Width + _nScrollBarsWidth
		ENDIF
		
		THISFORM.Height = THISFORM.Height + 32
		
		THISFORM.NewObject("imgInfo","Image")
		_cNewObjRefCommand = "_NewObj = THISFORM.imgInfo"
		&_cNewObjRefCommand
		_NewObj.Width = 19
		_NewObj.Height = 19
		_NewObj.Left = 4
		_NewObj.Top = 8
		_NewObj.BackStyle = 0  && Transparent
		_NewObj.Stretch = 1  && Isometric
		_NewObj.Picture = "..\AQUARIUS\INFO.BMP"
		_NewObj.MousePointer = 15  && Hand
		_NewObj.ToolTipText = "Cliccare sulla locazione nella quale effettuare il carico." + CHR(13) + "Fare click col tasto destro per visualizzare l'elenco delle attuali giacenze"
		_NewObj.Visible = .T.
				
		THISFORM.AddObject("lbl_colore_NOTA","Label")
		_cNewObjRefCommand = "_NewObj = THISFORM.lbl_colore_NOTA"
		&_cNewObjRefCommand
		_NewObj.Width = 30
		_NewObj.Height = 20
		_NewObj.Left = THISFORM.imgInfo.Left + THISFORM.imgInfo.Width + 10
		_NewObj.Top = 8
		_NewObj.FontName = "Arial Narrow"
		_NewObj.FontBold = .T.
		_NewObj.FontSize = 9
		_NewObj.BackStyle = 1  && Opaque
		_NewObj.BorderStyle = 1  && Fixed Single
		_NewObj.BackColor = RGB(255,255,0)
		_NewObj.ForeColor = RGB(128,128,128)
		_NewObj.Caption = ""
		_NewObj.Visible = .T.
		
		THISFORM.AddObject("lbl_testo_NOTA","Label")
		_cNewObjRefCommand = "_NewObj = THISFORM.lbl_testo_NOTA"
		&_cNewObjRefCommand
		_NewObj.Width = 300
		_NewObj.Height = 20
		_NewObj.Left = THISFORM.lbl_colore_NOTA.Left + THISFORM.lbl_colore_NOTA.Width + 2
		_NewObj.Top = 9
		_NewObj.FontName = "Arial Narrow"
		_NewObj.FontBold = .F.
		_NewObj.FontSize = 8
		_NewObj.BackStyle = 0  && Transparent
		_NewObj.ForeColor = RGB(255,0,0)
		_NewObj.Caption = "= Locazioni utilizzate in precedenza"
		_NewObj.Visible = .T.
		
		THISFORM.AddObject("lbl_TITOLO","Label")
		_cNewObjRefCommand = "_NewObj = THISFORM.lbl_TITOLO"
		&_cNewObjRefCommand
		_NewObj.Width = 300
		_NewObj.Height = 20
		_NewObj.Left = (THISFORM.Width - _NewObj.Width) / 2
		_NewObj.Top = 8
		_NewObj.FontName = "Arial"
		_NewObj.FontBold = .T.
		_NewObj.FontSize = 10
		_NewObj.BackStyle = 0  && Transparent
		_NewObj.ForeColor = RGB(0,0,255)
		_NewObj.Caption = "CARICO MAGAZZINO PER " + _W_CODART
		_NewObj.Alignment = 2  && Center
		_NewObj.AutoSize = .T.
		_NewObj.FontUnderline = .T.
		_NewObj.Visible = .T.
		
		THISFORM.NewObject("cmdAnnulla","cmdAnnullaSelLocazione")
		_cNewObjRefCommand = "_NewObj = THISFORM.cmdAnnulla"
		&_cNewObjRefCommand
		_NewObj.Width = 30
		_NewObj.Height = 24
		_NewObj.Caption = ""
		_NewObj.Left = THISFORM.Width - _NewObj.Width - 4 - _nScrollBarsWidth
		_NewObj.Top = 4
		_NewObj.FontName = "Arial"
		_NewObj.FontBold = .T.
		_NewObj.WordWrap = .T.
		_NewObj.BackColor = RGB(212,208,200)
		_NewObj.ForeColor = RGB(0,0,255)
		_NewObj.TabStop = .F.
		*_NewObj.PicturePosition = 1  && Middle Left
		_NewObj.Visible = .T.
		_NewObj.Picture = "..\AQUARIUS\BMP\ICONE\CHIUDI_16x16.BMP"
		*_NewObj.SpecialEffect = 2  && Hot Tracking
		*_NewObj.SpecialEffect = 1  && Plain
		_NewObj.SpecialEffect = 0  && 3D
		_NewObj.MousePointer = 15  && Hand
		
		_nContaPulsantiVeri = 0
		_nLeft = 0
		_nTop = 32
		_nPROGRE = 0
		SELECT CUR_MOV_LOC
		SET ORDER TO I_ORDINE
		GO TOP
		SCAN
			_nPROGRE = _nPROGRE + 1
			_cPROGRE = ALLTRIM(STR(_nPROGRE))
			THISFORM.NewObject("cmdSelLocazione"+_cPROGRE,"cmdSelLocazione")
			_cNewObjRefCommand = "_NewObj = THISFORM.cmdSelLocazione"+_cPROGRE
			&_cNewObjRefCommand
			_NewObj.Width = _XX_CMDW
			_NewObj.Height = _XX_CMDH
			_NewObj.Caption = "Mag. " + ALLTRIM(MOV_CODMAG) + CHR(13) + ;
					"Fila " + ALLTRIM(LOC_FILALF) + IIF(!EMPTY(LOC_FDESCR)," ("+ALLTRIM(LOC_FDESCR)+")","") + CHR(13) + ;
					ALLTRIM(LOC_PIAALF) + " - " + ALLTRIM(LOC_UBIALF) + CHR(13) + ;
					"GIACENZA: " + ALLTRIM(STR(MAG_GIACEN,19,PUB_DECQTA))
			_NewObj.Left = _nLeft
			_NewObj.Top = _nTop
			_NewObj.FontName = "Arial Narrow"
			_NewObj.FontBold = .T.
			_NewObj.WordWrap = .T.
			_NewObj.BackColor = RGB(212,208,200)
			_NewObj.ForeColor = RGB(0,0,255)
			_NewObj.TabStop = .F.
			_NewObj.Visible = .T.
			_NewObj.AddProperty("CODMAG",ALLTRIM(MOV_CODMAG))
			_NewObj.AddProperty("DESMAG",ALLTRIM(MOV_DESMAG))
			_NewObj.AddProperty("FILALF",ALLTRIM(LOC_FILALF))
			_NewObj.AddProperty("PIAALF",ALLTRIM(LOC_PIAALF))
			_NewObj.AddProperty("UBIALF",ALLTRIM(LOC_UBIALF))
			_NewObj.AddProperty("FILNUM",LOC_FILNUM)
			_NewObj.AddProperty("PIANUM",LOC_PIANUM)
			_NewObj.AddProperty("UBINUM",LOC_UBINUM)
			_NewObj.AddProperty("GIACEN",MAG_GIACEN)
			_NewObj.AddProperty("USED",FLG_USED)
			*_NewObj.SpecialEffect = 2  && Hot Tracking
			*_NewObj.SpecialEffect = 1  && Plain
			_NewObj.SpecialEffect = 0  && 3D
			_NewObj.MousePointer = 15  && Hand
			_NewObj.Tag = "."
			
			_nContaPulsantiVeri = _nContaPulsantiVeri + 1

			_nLeft = _nLeft + _NewObj.Width
			IF _nLeft > (THISFORM.Width - _XX_CMDW)
				_nLeft = 0
				_nTop = _nTop + _NewObj.Height
			ENDIF
		ENDSCAN
		
		FOR _ii = _nContaPulsantiVeri + 1 TO MAX(_XX_MAXROWS * _XX_MAXCOLS,36)
						
			_nPROGRE = _ii
			_cPROGRE = ALLTRIM(STR(_nPROGRE))
			THISFORM.NewObject("cmdSelLocazione"+_cPROGRE,"cmdSelLocazione")
			_cNewObjRefCommand = "_NewObj = THISFORM.cmdSelLocazione"+_cPROGRE
			&_cNewObjRefCommand
			_NewObj.Width = _XX_CMDW
			_NewObj.Height = _XX_CMDH
			_NewObj.Caption = ""
			_NewObj.Left = _nLeft
			_NewObj.Top = _nTop
			_NewObj.FontName = "Arial Narrow"
			_NewObj.FontBold = .T.
			_NewObj.WordWrap = .T.
			_NewObj.BackColor = RGB(212,208,200)
			_NewObj.ForeColor = RGB(0,0,255)
			_NewObj.TabStop = .F.
			_NewObj.Visible = .T.
			_NewObj.AddProperty("CODMAG","")
			_NewObj.AddProperty("DESMAG","")
			_NewObj.AddProperty("FILALF","")
			_NewObj.AddProperty("PIAALF","")
			_NewObj.AddProperty("UBIALF","")
			_NewObj.AddProperty("FILNUM",0)
			_NewObj.AddProperty("PIANUM",0)
			_NewObj.AddProperty("UBINUM",0)
			_NewObj.AddProperty("GIACEN",0)
			_NewObj.AddProperty("USED","")
			*_NewObj.SpecialEffect = 2  && Hot Tracking
			*_NewObj.SpecialEffect = 1  && Plain
			_NewObj.SpecialEffect = 0  && 3D
			_NewObj.MousePointer = 15  && Hand
			_NewObj.Tag = ""
			
			_nLeft = _nLeft + _NewObj.Width
			IF _nLeft > (THISFORM.Width - _XX_CMDW)
				_nLeft = 0
				_nTop = _nTop + _NewObj.Height
			ENDIF
			
		NEXT

		WAIT CLEAR

		*THISFORM.Caption = "Locazioni predefinite Articolo '" + ALLTRIM(_par_codart) + "' per magazzino logistico"

		THISFORM.AutoCenter = .T.
		
*!*			*##########################################################################################
*!*			*** IMPOSTAZIONE TRASPARENZA FORM (solo form con proprietà Desktop = .T.)
*!*			#DEFINE BADOS_LOC	"This sample only runs on Windows 2000 or higher."
*!*			IF VAL(OS(3))<5
*!*				MESSAGEBOX(BADOS_LOC)
*!*				RETURN .F.
*!*			ENDIF
*!*			DECLARE SetWindowLong In Win32Api AS _Sol_SetWindowLong Integer, Integer, Integer
*!*			DECLARE SetLayeredWindowAttributes In Win32Api AS _Sol_SetLayeredWindowAttributes Integer, String, Integer, Integer
*!*			_Sol_SetWindowLong(THISFORM.hWnd, -20, 0x00080000)
*!*			_nTransparencyLevel = 220  && (accept values from 0 to 255)
*!*			_Sol_SetLayeredWindowAttributes(THISFORM.hWnd, 0, _nTransparencyLevel, 2)
*!*			*##########################################################################################

		THISFORM.Refresh
	ENDPROC


	PROCEDURE Load
		
		RELEASE _SEL_CODMAG,_SEL_DESMAG,_SEL_FILALF,_SEL_PIAALF,_SEL_UBIALF,_SEL_FILNUM,_SEL_PIANUM,_SEL_UBINUM
		PUBLIC _SEL_CODMAG,_SEL_DESMAG,_SEL_FILALF,_SEL_PIAALF,_SEL_UBIALF,_SEL_FILNUM,_SEL_PIANUM,_SEL_UBINUM
		_SEL_CODMAG = ""
		_SEL_DESMAG = ""
		_SEL_FILALF = ""
		_SEL_PIAALF = ""
		_SEL_UBIALF = ""
		_SEL_FILNUM = 0
		_SEL_PIANUM = 0
		_SEL_UBINUM = 0

		RELEASE _W_CODART
		PUBLIC _W_CODART
		_W_CODART = ""
	ENDPROC


ENDDEFINE
*
*-- EndDefine: frmlocazcar
**************************************************


DEFINE CLASS cmdLocazione AS CommandButton

	Caption = ""
	
	PROCEDURE Click
	
		RELEASE _XX_MAGA,_XX_FILA,_XX_PIAN,_XX_UBIC
		PUBLIC  _XX_MAGA,_XX_FILA,_XX_PIAN,_XX_UBIC
		SELECT CU_LOCAZIONI
		
		_NOMECOL = THIS.Parent.ControlSource
		IF &_NOMECOL = "NON ATTIVO" .OR. EMPTY(ALLTRIM(&_NOMECOL))
			MESSAGEBOX("Locazione non attiva o Inesistente",64,"Informazione")
			RETURN .F.
		ENDIF
		
		SELECT CU_FILE
		_XX_MAGA = _VV_CODMAG
		_XX_FILA = LOC_FILNUM
		SELECT CU_LOCAZIONI
		_XX_PIAN = U_PIANUM
		_XX_UBIC = VAL(ALLTRIM(SUBSTR(THIS.Parent.Name,7)))
		THISFORM.articoli_in_giacenza(_XX_MAGA,_XX_FILA,_XX_PIAN,_XX_UBIC)
		SELECT CU_MAG_GI
		GO TOP
		IF EOF()
			MESSAGEBOX("Nessuna Giacenza In Questa Locazione",64,"Informazione")
			RETURN .F.
		ELSE
			DO FORM FORM\MAGLOG_GUI_DET2 LINKED
		ENDIF
		
		IF TYPE(_X_NOMEVAR_CODART_RIT) == 'C'
			IF !EMPTY(_X_NOMEVAR_CODART_RIT) AND !EMPTY(&_X_NOMEVAR_CODART_RIT)
				RELEASE THISFORM
			ENDIF
		ENDIF
		
		IF _V_SPOSTATO
			THISFORM.aggiorna_locazione(_NOMECOL,_XX_MAGA,_XX_FILA,_XX_PIAN,_XX_UBIC)
			IF _V_CMASCA = _V_CMACAR .AND. _XX_FILA = _VV_MAG_FILDES_N	
				_V_IND_X  = STR(_VV_MAG_UBIDES_N,6,0)
				_V_IND_X  = TRC(6,ALLTRIM(_V_IND_X))  
				_NOMECOL  = "U_" + _V_IND_X
				_XX_MAGA = _VV_MAG_CDMDES
				_XX_FILA = _VV_MAG_FILDES_N
				_XX_PIAN = _VV_MAG_PIADES_N
				_XX_UBIC = _VV_MAG_UBIDES_N
				THISFORM.aggiorna_locazione(_NOMECOL,_XX_MAGA,_XX_FILA,_XX_PIAN,_XX_UBIC)
			ENDIF
		ENDIF

	ENDPROC
	
	
	PROCEDURE Refresh
		
		SELECT CU_LOCAZIONI
		_cCONTROLSOURCE = THIS.Parent.CONTROLSOURCE
		THIS.Caption = ALLTRIM(&_cCONTROLSOURCE)
		
	ENDPROC

ENDDEFINE


DEFINE CLASS cmdSelLocazione AS CommandButton

	PROCEDURE Click
		
		IF EMPTY(THIS.Tag)
			RETURN
		ENDIF
		
		_SEL_CODMAG = ALLTRIM(THIS.CODMAG)
		_SEL_DESMAG = ALLTRIM(THIS.DESMAG)
		_SEL_FILALF = ALLTRIM(THIS.FILALF)
		_SEL_PIAALF = ALLTRIM(THIS.PIAALF)
		_SEL_UBIALF = ALLTRIM(THIS.UBIALF)
		_SEL_FILNUM = THIS.FILNUM
		_SEL_PIANUM = THIS.PIANUM
		_SEL_UBINUM = THIS.UBINUM
		
		RELEASE THISFORM

	ENDPROC
	
	PROCEDURE Refresh
		
		IF !EMPTY(THIS.Tag)
			IF THIS.USED = "1"
				THIS.BackColor = RGB(255,255,0)
			ELSE
				THIS.BackColor = RGB(128,255,128)
			ENDIF
		ENDIF
		
	ENDPROC
	
	PROCEDURE RightClick
		
		IF EMPTY(THIS.Tag) OR THIS.GIACEN = 0
			RETURN
		ENDIF
		
		_choice = 0
		DEFINE POPUP generatePop SHORTCUT RELATIVE FROM MROW(),MCOL()
		DEFINE BAR 1 OF generatePop PROMPT "Visualizza le giacenze..." 
		ON SELECTION BAR 1 OF generatePop _choice = 1
		ACTIVATE POPUP generatePop

		DO CASE
			CASE _choice = 1
								
				x_arti = "MAG_ANAART = '" + _W_CODART + "'"
				x_maga = "MAG_CODMAG = '" + THIS.CODMAG + "'"
				x_filn = "MAG_FILA_N = " + STR(THIS.FILNUM)
				x_pian = "MAG_PIAN_N = " + STR(THIS.PIANUM)
				x_ubin = "MAG_UBIC_N = " + STR(THIS.UBINUM)
				x_cond = x_arti + " and " + x_maga + " and " + x_filn + " and " + x_pian + " and " + x_ubin
				cSql = "SELECT MAG_DATAGG,MAG_ORACAR,MAG_ANAART,MAG_DESART,MAG_NRLINT,ART_UMMAGA,MAG_GIACEN,MAG_QTAIMP FROM U_MAG_GG " + ;
				       "LEFT OUTER JOIN U_ART_PR ON U_ART_PR.ART_CODPRI = U_MAG_GG.MAG_ANAART " + ;
				       "WHERE " + x_cond + " ORDER BY MAG_DATAGG, MAG_ORACAR, MAG_NRLINT"
				IF !ExecCommand(cSql,"VIEW_MAG_GG")
					RETURN .F.
				ENDIF
				
				DO prg\browseview WITH "VIEW_MAG_GG","Giacenze " + _W_CODART + " in Mag. " + THIS.CODMAG + "  Locazione " + THIS.FILALF + " - " + THIS.PIAALF + " - " + THIS.UBIALF , ;
					"MAG_DATAGG:Data car.,W:10;MAG_ORACAR:Ora Car.,W:9;MAG_ANAART:Articolo,W:15;MAG_DESART:Descrizione,W:34;MAG_NRLINT:Nr.lotto int.,W:10;" + ;
					"ART_UMMAGA:UM,W:5;MAG_GIACEN:Giacenza,W:10;MAG_QTAIMP:Qtà imp.,W:10;",500,800
				
		ENDCASE

	ENDPROC

ENDDEFINE


DEFINE CLASS cmdAnnullaSelLocazione AS CommandButton

	PROCEDURE Click
		
		_SEL_CODMAG = ""
		_SEL_DESMAG = ""
		_SEL_FILALF = ""
		_SEL_PIAALF = ""
		_SEL_UBIALF = ""
		_SEL_FILNUM = 0
		_SEL_PIANUM = 0
		_SEL_UBINUM = 0
		
		MESSAGEBOX("Nessuna locazione selezionata",64,"Informazione")
		
		RELEASE THISFORM

	ENDPROC

ENDDEFINE


***************************************************************************
PROCEDURE MAGLOG_DEFA_SCA
***************************************************************************
** CREA UN FORM DINAMICO DI SELEZIONE DELLE GIACENZE ESISTENTI
** DA UTILIZZARE PER LO SCARICO DEL CODICE ARTICOLO PASSATO NEI PARAMETRI
***************************************************************************
LPARAMETERS _par_codart
	
IF PCOUNT() < 1
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(_par_codart)
	RETURN .F.
ENDIF

frmlocazsca1 = CREATEOBJECT("frmlocazsca",_par_codart)
frmlocazsca1.SHOW

RELEASE frmlocazsca1

ENDPROC


**************************************************
*-- FORM DI SELEZIONE GIACENZE CON LOCAZIONI DI SCARICO PER ARTICOLO SU MAGAZZINO LOGISTICO
*-- Form:         frmlocazsca
*-- ParentClass:  form
*-- BaseClass:    form
*-- Time Stamp:   04/12/2012 11:29:00
*
DEFINE CLASS frmlocazsca AS form
	
	BorderStyle = 1  && Fixed Single
	Height = 100
	Width = 130
	ScrollBars = 2
	DoCreate = .T.
	AutoCenter = .T.
	Caption = "Selezione Giacenze in Locazioni magazzino logistico"
	FontBold = .T.
	FontSize = 10
	HalfHeightCaption = .F.
	MaxButton = .F.
	MinButton = .F.
	*Visible = .T.
	Icon = "..\ico\2_aquarius.ico"
	TitleBar = 1
	WindowType = 1
	WindowState = 0
	LockScreen = .F.
	ColorSource = 5
	ForeColor = RGB(192,192,192)
	BackColor = RGB(192,192,192)
	Themes = .F.
	Name = "FrmLocazSca"
	*Desktop = .T.
	TitleBar = 0  &&  Off
	ShowTips = .T.
	

	PROCEDURE Activate
		
		IF USED("CUR_GIA_LOC")
			SELECT CUR_GIA_LOC
			GO TOP
			IF EOF()
				USE
				RELEASE THISFORM
			ENDIF
		ELSE
			RELEASE THISFORM
		ENDIF
		
	ENDPROC


	PROCEDURE Init

		LPARAMETERS _par_codart

		IF PCOUNT() < 1
			MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
			RETURN .F.
		ENDIF

		WAIT WINDOW "Ricerca giacenze in locazioni magazzino logistico in corso..." NOWAIT

		_W_CODART = ALLTRIM(_par_codart)

		_XX_MAXCOLS = 6

		IF USED("CUR_GIA_LOC")
			SELECT CUR_GIA_LOC
			USE
		ENDIF
		x_arti = "MAG_ANAART = '" + _W_CODART + "'"
		x_data = "MAG_DATAGG <> ''"
		x_maga = "MAG_CODMAG <> ''"
		x_filn = "MAG_FILA_N > 0"
		x_pian = "MAG_PIAN_N > 0"
		x_ubin = "MAG_UBIC_N > 0"
		x_giac = "MAG_GIACEN > 0"  && ERASMO - 09/11/2017
		*x_cond = x_arti + " and " + x_data + " and " + x_maga + " and " + x_filn + " and " + x_pian + " and " + x_ubin 		       
		x_cond = x_arti + " and " + x_data + " and " + x_maga + " and " + x_filn + " and " + x_pian + " and " + x_ubin + " and " + x_giac  && ERASMO - 09/11/2017
		cSql = "SELECT CAST(0 AS BIT) AS SELEZI, 'NO' AS LAST, MAG_DATAGG, MAG_CODMAG, DESCRI AS MAG_DESMAG, MAG_GIACEN, MAG_UNIQUE, " + CHR(13) + ;
		       "	LOC_FILALF, LOC_FILNUM, LOC_FDESCR, LOC_PIAALF, LOC_PIANUM, LOC_UBIALF, LOC_UBINUM " + CHR(13) + ;
		       "FROM U_MAG_GG AS GG " + CHR(13) + ;
		       "INNER JOIN U_LOC_GE AS LOC ON LOC.LOC_CODMAG = GG.MAG_CODMAG AND LOC.LOC_FILNUM = GG.MAG_FILA_N AND " + CHR(13) + ;
		       "	LOC.LOC_PIANUM = GG.MAG_PIAN_N AND LOC.LOC_UBINUM = GG.MAG_UBIC_N AND LOC_FILSEL = 1 " + CHR(13) + ;
		       "LEFT OUTER JOIN (SELECT CODICE, DESCRI FROM PARA) AS PARA ON PARA.CODICE = 'MAG'+GG.MAG_CODMAG " + CHR(13) + ;
		       "WHERE " + x_cond + " " + CHR(13) + ;
		       "ORDER BY MAG_DATAGG, MAG_CODMAG, DESCRI, LOC_FILALF, LOC_FILNUM, LOC_FDESCR, LOC_PIAALF, LOC_PIANUM, LOC_UBIALF, LOC_UBINUM"
		IF !ExecCommand(cSql,"CUR_GIA_LOC")
			RETURN .F.
		ENDIF
		SELECT CUR_GIA_LOC
		GO TOP
		IF EOF()
			WAIT CLEAR
			RETURN
		ENDIF
		
		_XX_MAXROWS = CEILING(RECCOUNT() / _XX_MAXCOLS)
		_XX_CMDW = 130
		_XX_CMDH = 80

		THISFORM.Width = _XX_CMDW * _XX_MAXCOLS
		THISFORM.Height = 480

		IF _XX_MAXROWS * _XX_CMDH > 480
			*THISFORM.Height = 480
		ELSE
			THISFORM.ScrollBars = 0
			*THISFORM.Height = _XX_MAXROWS * _XX_CMDH
		ENDIF

		IF RECCOUNT() > _XX_MAXCOLS
			*THISFORM.Width = _XX_MAXCOLS * _XX_CMDW
		ELSE
			*THISFORM.Width = RECCOUNT() * _XX_CMDW
		ENDIF
		
		_nScrollBarsWidth = 0
		IF THISFORM.ScrollBars > 0
			_nScrollBarsWidth = 16
			THISFORM.Width = THISFORM.Width + _nScrollBarsWidth
		ENDIF
		
		THISFORM.Height = THISFORM.Height + 32
		
		THISFORM.NewObject("imgInfo","Image")
		_cNewObjRefCommand = "_NewObj = THISFORM.imgInfo"
		&_cNewObjRefCommand
		_NewObj.Width = 19
		_NewObj.Height = 19
		_NewObj.Left = 4
		_NewObj.Top = 8
		_NewObj.BackStyle = 0  && Transparent
		_NewObj.Stretch = 1  && Isometric
		_NewObj.Picture = "..\AQUARIUS\INFO.BMP"
		_NewObj.MousePointer = 15  && Hand
		_NewObj.ToolTipText = "Cliccare sulle locazioni delle giacenze da selezionare ed eventualmente rettificare la quantità da scaricare" + CHR(13) + "Successivamente fare click sul tasto 'Conferma...'"
		_NewObj.Visible = .T.
		
		THISFORM.AddObject("lbl_SEL_GIACEN","Label")
		_cNewObjRefCommand = "_NewObj = THISFORM.lbl_SEL_GIACEN"
		&_cNewObjRefCommand
		_NewObj.Width = 100
		_NewObj.Height = 22
		_NewObj.Left = THISFORM.imgInfo.Left + THISFORM.imgInfo.Width + 4
		_NewObj.Top = 8
		_NewObj.FontName = "Arial Narrow"
		_NewObj.FontBold = .T.
		_NewObj.FontSize = 9
		_NewObj.BackStyle = 0  && Transparent
		_NewObj.ForeColor = RGB(255,0,0)
		_NewObj.Caption = "Giacenza selezionata"
		_NewObj.Visible = .T.
		
		THISFORM.AddObject("txt_SEL_GIACEN","txtSelGiacLocaz")
		_cNewObjRefCommand = "_NewObj = THISFORM.txt_SEL_GIACEN"
		&_cNewObjRefCommand
		_NewObj.Width = 80
		_NewObj.Height = 24
		_NewObj.Left = THISFORM.lbl_SEL_GIACEN.Left + THISFORM.lbl_SEL_GIACEN.Width + 4
		_NewObj.Top = 4
		_NewObj.FontName = "Arial"
		_NewObj.FontBold = .T.
		_NewObj.FontSize = 10
		_NewObj.BackColor = RGB(255,255,0)
		_NewObj.ForeColor = RGB(0,0,255)
		_NewObj.Inputmask = CAMPOMASK(PUB_DECQTA,"99,999,999,999,999")
		_NewObj.TabStop = .F.
		_NewObj.Alignment = 1  && Right
		_NewObj.ControlSource = "_SEL_GIACEN"
		_NewObj.SelectOnEntry = .T.
		_NewObj.Visible = .T.
			
		THISFORM.NewObject("cmdAnnulla","cmdAnnullaSelGiacLocaz")
		_cNewObjRefCommand = "_NewObj = THISFORM.cmdAnnulla"
		&_cNewObjRefCommand
		_NewObj.Width = 30
		_NewObj.Height = 24
		_NewObj.Caption = ""
		_NewObj.Left = THISFORM.Width - _NewObj.Width - 4 - _nScrollBarsWidth
		_NewObj.Top = 4
		_NewObj.FontName = "Arial"
		_NewObj.FontBold = .T.
		_NewObj.WordWrap = .T.
		_NewObj.BackColor = RGB(212,208,200)
		_NewObj.ForeColor = RGB(0,0,255)
		_NewObj.TabStop = .F.
		_NewObj.PicturePosition = 1  && Middle Left
		_NewObj.Visible = .T.
		_NewObj.Picture = "..\AQUARIUS\BMP\ICONE\CHIUDI_16x16.BMP"
		*_NewObj.SpecialEffect = 2  && Hot Tracking
		*_NewObj.SpecialEffect = 1  && Plain
		_NewObj.SpecialEffect = 0  && 3D
		_NewObj.MousePointer = 15  && Hand
		
		THISFORM.NewObject("cmdConferma","cmdConfermaSelGiacLocaz")
		_cNewObjRefCommand = "_NewObj = THISFORM.cmdConferma"
		&_cNewObjRefCommand
		_NewObj.Width = 100
		_NewObj.Height = 24
		_NewObj.Caption = "Conferma..."
		_NewObj.Left = THISFORM.cmdAnnulla.Left - _NewObj.Width - 4
		_NewObj.Top = 4
		_NewObj.FontName = "Arial"
		_NewObj.FontBold = .T.
		_NewObj.WordWrap = .T.
		_NewObj.BackColor = RGB(212,208,200)
		_NewObj.ForeColor = RGB(0,0,255)
		_NewObj.TabStop = .F.
		_NewObj.PicturePosition = 1  && Middle Left
		_NewObj.Picture = "..\AQUARIUS\BMP\ICONE\OK_SPUNTA.BMP"
		*_NewObj.SpecialEffect = 2  && Hot Tracking
		*_NewObj.SpecialEffect = 1  && Plain
		_NewObj.SpecialEffect = 0  && 3D
		_NewObj.MousePointer = 15  && Hand
		_NewObj.Visible = .T.
		
		THISFORM.AddObject("lbl_TITOLO","Label")
		_cNewObjRefCommand = "_NewObj = THISFORM.lbl_TITOLO"
		&_cNewObjRefCommand
		_NewObj.Width = 300
		_NewObj.Height = 20
		_NewObj.Left = (THISFORM.Width - _NewObj.Width) / 2
		_NewObj.Top = 8
		_NewObj.FontName = "Arial"
		_NewObj.FontBold = .T.
		_NewObj.FontSize = 10
		_NewObj.BackStyle = 0  && Transparent
		_NewObj.ForeColor = RGB(255,0,0)
		_NewObj.Caption = "SCARICO MAGAZZINO PER " + _W_CODART
		_NewObj.Alignment = 2  && Center
		_NewObj.AutoSize = .T.
		_NewObj.FontUnderline = .T.
		_NewObj.Visible = .T.
		
		_nContaPulsantiVeri = 0
		_nLeft = 0
		_nTop = 32
		SELECT CUR_GIA_LOC
		GO TOP
		SCAN

			_nPROGRE = RECNO()
			_cPROGRE = ALLTRIM(STR(_nPROGRE))
			THISFORM.NewObject("chkSelGiacLocaz"+_cPROGRE,"chkSelGiacLocaz")
			_cNewObjRefCommand = "_NewObj = THISFORM.chkSelGiacLocaz"+_cPROGRE
			&_cNewObjRefCommand
			_NewObj.Width = _XX_CMDW
			_NewObj.Height = _XX_CMDH
			_NewObj.Caption = "Mag. " + ALLTRIM(MAG_CODMAG) + CHR(13) + ;
					"Fila " + ALLTRIM(LOC_FILALF) + IIF(!EMPTY(LOC_FDESCR)," ("+ALLTRIM(LOC_FDESCR)+")","") + CHR(13) + ;
					ALLTRIM(LOC_PIAALF) + " - " + ALLTRIM(LOC_UBIALF) + CHR(13) + ;
					"GIACENZA: " + ALLTRIM(STR(MAG_GIACEN,19,PUB_DECQTA))
			_NewObj.Left = _nLeft
			_NewObj.Top = _nTop
			_NewObj.FontName = "Arial Narrow"
			_NewObj.FontBold = .T.
			_NewObj.WordWrap = .T.
			_NewObj.BackColor = RGB(212,208,200)
			_NewObj.ForeColor = RGB(0,0,255)
			_NewObj.TabStop = .F.
			_NewObj.Style = 1  && Graphical
			_NewObj.Alignment = 2  && Middle Right
			*_NewObj.PicturePosition = 2  && Middle Right
			*_NewObj.SpecialEffect = 2  && Hot Tracking
			*_NewObj.SpecialEffect = 1  && Plain
			_NewObj.SpecialEffect = 0  && 3D
			_NewObj.MousePointer = 15  && Hand
			_NewObj.Visible = .T.
			_NewObj.AddProperty("CODMAG",ALLTRIM(MAG_CODMAG))
			_NewObj.AddProperty("DESMAG",ALLTRIM(MAG_DESMAG))
			_NewObj.AddProperty("FILALF",ALLTRIM(LOC_FILALF))
			_NewObj.AddProperty("PIAALF",ALLTRIM(LOC_PIAALF))
			_NewObj.AddProperty("UBIALF",ALLTRIM(LOC_UBIALF))
			_NewObj.AddProperty("FILNUM",LOC_FILNUM)
			_NewObj.AddProperty("PIANUM",LOC_PIANUM)
			_NewObj.AddProperty("UBINUM",LOC_UBINUM)
			_NewObj.AddProperty("UNIQUE",MAG_UNIQUE)
			_NewObj.AddProperty("GIACEN",MAG_GIACEN)
			
			_nContaPulsantiVeri = _nContaPulsantiVeri + 1

			_nLeft = _nLeft + _NewObj.Width
			IF _nLeft > (THISFORM.Width - _XX_CMDW)
				_nLeft = 0
				_nTop = _nTop + _NewObj.Height
			ENDIF
		ENDSCAN
		
		FOR _ii = _nContaPulsantiVeri + 1 TO MAX(_XX_MAXROWS * _XX_MAXCOLS,36)
						
			_nPROGRE = _ii
			_cPROGRE = ALLTRIM(STR(_nPROGRE))
			THISFORM.NewObject("chkSelGiacLocaz"+_cPROGRE,"chkSelGiacLocaz")
			_cNewObjRefCommand = "_NewObj = THISFORM.chkSelGiacLocaz"+_cPROGRE
			&_cNewObjRefCommand
			_NewObj.Width = _XX_CMDW
			_NewObj.Height = _XX_CMDH
			_NewObj.Caption = ""
			_NewObj.Left = _nLeft
			_NewObj.Top = _nTop
			_NewObj.FontName = "Arial Narrow"
			_NewObj.FontBold = .T.
			_NewObj.WordWrap = .T.
			_NewObj.BackColor = RGB(212,208,200)
			_NewObj.ForeColor = RGB(0,0,255)
			_NewObj.TabStop = .F.
			_NewObj.Style = 1  && Graphical
			_NewObj.Alignment = 2  && Middle Right
			*_NewObj.PicturePosition = 2  && Middle Right
			*_NewObj.SpecialEffect = 2  && Hot Tracking
			*_NewObj.SpecialEffect = 1  && Plain
			_NewObj.SpecialEffect = 0  && 3D
			_NewObj.MousePointer = 15  && Hand
			_NewObj.Visible = .T.
			_NewObj.AddProperty("CODMAG","")
			_NewObj.AddProperty("DESMAG","")
			_NewObj.AddProperty("FILALF","")
			_NewObj.AddProperty("PIAALF","")
			_NewObj.AddProperty("UBIALF","")
			_NewObj.AddProperty("FILNUM",0)
			_NewObj.AddProperty("PIANUM",0)
			_NewObj.AddProperty("UBINUM",0)
			_NewObj.AddProperty("UNIQUE","")
			_NewObj.AddProperty("GIACEN",0)
			
			_nLeft = _nLeft + _NewObj.Width
			IF _nLeft > (THISFORM.Width - _XX_CMDW)
				_nLeft = 0
				_nTop = _nTop + _NewObj.Height
			ENDIF
			
		NEXT

		WAIT CLEAR

		*THISFORM.Caption = "Giacenze Articolo '" + ALLTRIM(_par_codart) + "' in locazioni magazzino logistico"
		
		THISFORM.AutoCenter = .T.
		
*!*			*##########################################################################################
*!*			*** IMPOSTAZIONE TRASPARENZA FORM (solo form con proprietà Desktop = .T.)
*!*			#DEFINE BADOS_LOC	"This sample only runs on Windows 2000 or higher."
*!*			IF VAL(OS(3))<5
*!*				MESSAGEBOX(BADOS_LOC)
*!*				RETURN .F.
*!*			ENDIF
*!*			DECLARE SetWindowLong In Win32Api AS _Sol_SetWindowLong Integer, Integer, Integer
*!*			DECLARE SetLayeredWindowAttributes In Win32Api AS _Sol_SetLayeredWindowAttributes Integer, String, Integer, Integer
*!*			_Sol_SetWindowLong(THISFORM.hWnd, -20, 0x00080000)
*!*			_nTransparencyLevel = 220  && (accept values from 0 to 255)
*!*			_Sol_SetLayeredWindowAttributes(THISFORM.hWnd, 0, _nTransparencyLevel, 2)
*!*			*##########################################################################################

		THISFORM.Refresh
	ENDPROC


	PROCEDURE Load

		RELEASE _SEL_GIACEN,_OK_SEL_GIACEN_LOCAZ
		PUBLIC _SEL_GIACEN,_OK_SEL_GIACEN_LOCAZ
		_SEL_GIACEN = 0
		_OK_SEL_GIACEN_LOCAZ = NULL

		RELEASE _W_CODART
		PUBLIC _W_CODART
		_W_CODART = ""
		
	ENDPROC
	
	PROCEDURE selezione_giacenze
		
		LPARAMETERS _par_unique,_par_segno
		
		_SEL_GIACEN = 0
		
		SELECT CUR_GIA_LOC
		GO TOP
		SCAN
			IF _par_segno == "+"
				REPLACE LAST WITH 'NO'
			ENDIF
			
			IF ALLTRIM(MAG_UNIQUE) == ALLTRIM(_par_unique)
				IF _par_segno == "+"
					REPLACE LAST WITH 'SI'
					REPLACE SELEZI WITH .T.
				ELSE
					REPLACE SELEZI WITH .F.
				ENDIF
			ENDIF
			
			IF SELEZI
				_SEL_GIACEN = _SEL_GIACEN + MAG_GIACEN
			ENDIF			
		ENDSCAN
		
	ENDPROC


ENDDEFINE
*
*-- EndDefine: frmlocazsca
**************************************************


DEFINE CLASS chkSelGiacLocaz AS CheckBox

	PROCEDURE Valid
	
		IF EMPTY(THIS.UNIQUE)
			THIS.Value = 0
			THISFORM.REFRESH
			RETURN .F.
		ENDIF
		
		IF THIS.Value = 1
			THISFORM.selezione_giacenze(THIS.UNIQUE,"+")
		ELSE
			THISFORM.selezione_giacenze(THIS.UNIQUE,"-")
		ENDIF
		
		THISFORM.REFRESH

	ENDPROC
	
	PROCEDURE Refresh
	
		IF THIS.Value = 1
			*THIS.BackColor = RGB(255,255,0)
			THIS.BackColor = RGB(255,0,0)
			*THIS.ForeColor = RGB(255,255,255)
		ELSE
			THIS.BackColor = RGB(212,208,200)
			*THIS.ForeColor = RGB(0,0,255)
		ENDIF
				
	ENDPROC

ENDDEFINE


DEFINE CLASS txtSelGiacLocaz AS TextBox

	PROCEDURE GotFocus
		
		*** FACCIO IN MODO CHE SI SELEZIONI TUTTA LA CASELLA DI TESTO
		WITH This
			IF .SelectOnEntry
				*Textbox::GotFocus()	&& ALTERNATIVO AL 'DODEFAULT()'
				DODEFAULT()
				.SelStart = 0
				.SelLength = LEN( .Text )
				NODEFAULT
			ENDIF
		ENDWITH

	ENDPROC

ENDDEFINE


DEFINE CLASS cmdConfermaSelGiacLocaz AS CommandButton

	PROCEDURE Click
		
		IF _SEL_GIACEN > 0
		ELSE
			MESSAGEBOX("Selezionare correttamente la giacenza da scaricare",16,"Attenzione")
			RETURN .F.
		ENDIF
		
		_TOT_GIACEN = 0
		SELECT CUR_GIA_LOC
		DELETE FOR !SELEZI
		INDEX ON LAST+MAG_DATAGG TAG I_DATSEL
		SET ORDER TO I_DATSEL
		GO TOP
		SCAN
			_TOT_GIACEN = _TOT_GIACEN + MAG_GIACEN
			
			IF _TOT_GIACEN > _SEL_GIACEN
				REPLACE MAG_GIACEN WITH MAG_GIACEN - (_TOT_GIACEN - _SEL_GIACEN)
				_TOT_GIACEN = _SEL_GIACEN
			ENDIF
		ENDSCAN
		
		IF _SEL_GIACEN > _TOT_GIACEN
			_SEL_GIACEN = _TOT_GIACEN
			MESSAGEBOX("Giacenza massima selezionabile: " + ALLTRIM(STR(_TOT_GIACEN,19,PUB_DECQTA)),48,"Attenzione")
		ENDIF
				
		_OK_SEL_GIACEN_LOCAZ = .T.
		
		RELEASE THISFORM

	ENDPROC

ENDDEFINE


DEFINE CLASS cmdAnnullaSelGiacLocaz AS CommandButton

	PROCEDURE Click
		
		_SEL_GIACEN = 0
		
		SELECT CUR_GIA_LOC
		ZAP
		
		_OK_SEL_GIACEN_LOCAZ = .F.
		
		MESSAGEBOX("Nessuna giacenza selezionata",64,"Informazione")
		
		RELEASE THISFORM

	ENDPROC

ENDDEFINE
