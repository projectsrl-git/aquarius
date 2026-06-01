
*** UTILITY PER LO SCARICO DELLE GIACENZE EFFETTIVE IN CASO DI SCARICHI FITTIZI (SOLO PER ARTICOLI DI TIPO PANNELLO TRUCIOLARE GREZZO/NOBILITATO)

_V_DATADA = "24/08/2012"

_V_DATADA = PJ_INPUTBOX("Digitare la Data DDT DAL da prendere in considerazione","Selezione Data DAL",_V_DATADA)
IF EMPTY(_V_DATADA) .OR. _V_DATADA = "  /  /    "
	MESSAGEBOX("Data non valida",16,"Attenzione")
	RETURN .F.
ENDIF
IF VALID_DATA(_V_DATADA)
ELSE
	MESSAGEBOX("Data non valida",16,"Attenzione")
	RETURN .F.
ENDIF
_V_DATADA = OK_DATA(_V_DATADA)
_V_DATAAL = DTOC(DATE())


WAIT WINDOWS "Ricerca DDT in corso..." NOWAIT


_TOT_RIGHE_DDT_RETTIFICATE = 0
x_test = "DAGGANCIO IN (SELECT TAGGANCIO FROM U_BOL_TT)"
x_comm = "(ORD_CODART <> '' AND ORD_DESART <> '*** COMMENTO ***')"
x_dtda = IIF(EMPTY(_V_DATADA),"1=1","ORS_DATORD >= '" + RIBALTA2(_V_DATADA) + "'")
x_dtal = IIF(EMPTY(_V_DATAAL),"1=1","ORS_DATORD <= '" + RIBALTA2(_V_DATAAL) + "'")
x_cond = x_test + " and " + x_comm + " and " + x_dtda + " and " + x_dtal 
cSql   = "SELECT * from U_BOL_DD WHERE " + x_cond + " ORDER BY ORS_DATORD, ORS_NUMORD, ORD_SEQUEN"
IF !ExecCommand(cSql,"CX_BOL_DD")
  return(.f.)
ENDIF
SELECT CX_BOL_DD
GO TOP


DO WHILE !EOF()
	
	SCATTER MEMVAR
	
	WAIT WINDOWS "Elaborazione DDT N° " + M.ORS_NUMORD + " del " + RIBALTA2(M.ORS_DATORD) + " - Articolo  " + ALLTRIM(M.ORD_CODART) + "  in corso..." NOWAIT
	
*!*		IF ALLTRIM(M.ORD_CODART) = '118A1B300000001'
*!*		ELSE
*!*			SELECT CX_BOL_DD
*!*			SKIP +1
*!*			LOOP
*!*		ENDIF
	
	_X_TIPO = CERCATIPO(M.ORD_CODART)
	IF _X_TIPO = "6"  && TIPO ARTICOLO PANNELLO TRUCIOLARE
	ELSE
		SELECT CX_BOL_DD
		SKIP +1
		LOOP
	ENDIF
	
	AQM_NUMMOV_LOCALE  = AQM_RILEVA_NUMERO_INTERNO()

	_TOT_QTAMOV_NON_SCARICATA = 0
	x_codi = "MOV_TOP = '" + PUB_BOLLA + "'"
	x_lsys = "MOV_LEGSYS = '" + M.ORD_SYSMAG + "'"
	x_dcmd = "MOV_DOCMOD = 0"
	x_cond = x_codi + " and " + x_lsys + " and " + x_dcmd
	cSql   = "SELECT * from U_MAG_MO WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_MAG_MO")
	  return(.f.)
	ENDIF
	SELECT CX_MAG_MO
	GO TOP
	SCAN
		_ID_UNIQUE1 = ID_UNIQUE
		_ID_UNIQUE2 = ""
		_N_QTAMOV = MOV_QTAMOV
		_C_LEGAME = MOV_LEGAME
		x_codi = "MOV_TOP = '" + PUB_MPIU + "'"
		x_lega = "MOV_LEGAME = '" + _C_LEGAME + "'"
		x_dcmd = "MOV_DOCMOD = 0"
		x_qtam = "MOV_QTAMOV = " + STRTRAN(ALLTRIM(STR(_N_QTAMOV,19,4)),',','.')
		x_cond = x_codi + " and " + x_lega + " and " + x_dcmd  + " and " + x_qtam 
		cSql   = "SELECT * from U_MAG_MO WHERE " + x_cond
		IF !ExecCommand(cSql,"TMP_MAG_MO")
		  return(.f.)
		ENDIF
		SELECT TMP_MAG_MO
		GO TOP
		IF !EOF()
			_ID_UNIQUE2 = ID_UNIQUE
			
			cSql = "DELETE from U_MAG_MO WHERE ID_UNIQUE = '" + _ID_UNIQUE1 + "'"
			IF !ExecCommand(cSql,"DEL_MAG_MO1")
			  return(.f.)
			ENDIF
			
			cSql = "DELETE from U_MAG_MO WHERE ID_UNIQUE = '" + _ID_UNIQUE2 + "'"
			IF !ExecCommand(cSql,"DEL_MAG_MO2")
			  return(.f.)
			ENDIF
			
			_TOT_QTAMOV_NON_SCARICATA = _TOT_QTAMOV_NON_SCARICATA + _N_QTAMOV
		ENDIF
	ENDSCAN
	
	x_agga = "TAGGANCIO = '" + M.DAGGANCIO + "'"
	x_cond = x_agga 
	cSql   = "SELECT * from U_BOL_TT WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_BOL_TT")
	  return(.f.)
	ENDIF
	SELECT CX_BOL_TT
	GO TOP
	SCATTER MEMVAR MEMO
		
	SELECT CX_BOL_DD
	SCATTER MEMVAR MEMO
	
	IF _TOT_QTAMOV_NON_SCARICATA > 0
		
		M.ORD_FLGMOD = 'I'
		M.ORD_QTAORD = _TOT_QTAMOV_NON_SCARICATA 
		M.ORD_NUMBOB = TROVA_NR_DA_MQ_LEGNO(M.ORD_ALTEZZ,M.ORD_LUNGHE,M.ORD_QTAORD)
		
		M.ORD_QTAMQ1 = TROVA_MQ_DA_AL_LEGNO(M.ORD_ALTEZZ,M.ORD_LUNGHE,1) 
		M.ORD_QTAMQ  = TROVA_MQ_DA_AL_LEGNO(M.ORD_ALTEZZ,M.ORD_LUNGHE,M.ORD_NUMBOB) 

		M.ORD_QTAML1 = TROVA_ML_DA_LU(M.ORD_LUNGHE,1)
		M.ORD_QTAML  = TROVA_ML_DA_LU(M.ORD_LUNGHE,M.ORD_NUMBOB)

		M.ORD_QTAMC1 = TROVA_MC_DA_AL_LEGNO(M.ORD_ALTEZZ,M.ORD_LUNGHE,1,M.ORD_SPESSO) 
		M.ORD_QTAMC  = TROVA_MC_DA_AL_LEGNO(M.ORD_ALTEZZ,M.ORD_LUNGHE,M.ORD_NUMBOB,M.ORD_SPESSO) 
		
		IF M.ORD_SPESSO = 0
		   IF M.ORD_NUMBOB > 0
		   ELSE
		      M.ORD_NUMBOB = 1
		   ENDIF
		   M.ORD_QTAKG1 = M.ORD_QTAKG / M.ORD_NUMBOB
		ELSE
		   M.ORD_QTAKG1 = TROVA_KG_DA_MQ(M.ORD_CODART,M.ORD_SPESSO,M.ORD_QTAMQ1,1)
		   M.ORD_QTAKG  = TROVA_KG_DA_MQ(M.ORD_CODART,M.ORD_SPESSO,M.ORD_QTAMQ1,M.ORD_NUMBOB)
		ENDIF
			
	    =AQM_DEFINISCE_AQM_VARIABILI_MAGAZZINO()
	    =AQM_VALORIZZA_VARIABILI_MAGAZZINO("MENU_BOL000")
	    _YES_SCAR = AQM_SCARICA_MAGAZZINO_DDT()
	    IF _YES_SCAR
	    	_TOT_RIGHE_DDT_RETTIFICATE = _TOT_RIGHE_DDT_RETTIFICATE + 1
	    ELSE
			MESSAGEBOX("Si è verificato un errore generico durante l'aggiornamento delle giacenze" + CHR(13) + CHR(13) + ;
				"I dettagli DDT non verranno aggiornati completamente",16,"Attenzione")
	    ENDIF
	    
	ENDIF
	
	SELECT CX_BOL_DD
	SKIP +1
ENDDO

WAIT CLEAR

IF _TOT_RIGHE_DDT_RETTIFICATE > 0
	MESSAGEBOX("Totale righe DDT riscaricate: " + ALLTRIM(STR(_TOT_RIGHE_DDT_RETTIFICATE,10,0)),64,"Informazione")
ELSE
	MESSAGEBOX("Nessuna riga DDT riscaricata",64,"Informazione")
ENDIF

RETURN
