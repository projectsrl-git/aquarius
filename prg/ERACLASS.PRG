
*** 05/10/2005 - DEFINIZIONE CLASSI PERSONALIZZATE ****************

DEFINE CLASS txtdblclk AS textbox

   PROCEDURE DblClick
      RELEASE _XX_MAGA,_XX_FILA,_XX_PIAN,_XX_UBIC
      PUBLIC  _XX_MAGA,_XX_FILA,_XX_PIAN,_XX_UBIC
      SELECT CU_LOCAZIONI
      
      _NOMECOL = THIS.Parent.ControlSource
      IF &_NOMECOL = "NON ATTIVO" .OR. EMPTY(ALLTRIM(&_NOMECOL))
         MESSAGEBOX("Locazione non attiva o Inesistente",64,"Informazione")
         RETURN .F.
      ENDIF      
      
      _XX_MAGA = _VV_CODMAG
      _XX_FILA = _XX_FILNUM
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

      RETURN
      
ENDDEFINE


*** 27/11/2012 - DEFINIZIONE CLASSI PERSONALIZZATE ****************

DEFINE CLASS cmdLocazione AS CommandButton

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
		
		IF EMPTY(THIS.Tag)
			THIS.BackColor = RGB(128,255,128)
		ELSE
			THIS.BackColor = RGB(255,255,0)
		ENDIF
		
	ENDPROC

ENDDEFINE
