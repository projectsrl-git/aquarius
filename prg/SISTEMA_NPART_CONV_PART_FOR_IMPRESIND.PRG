******************************************************
*** SISTEMAZIONE NUMERO PARTITA PART_FOR IMPRESIND ***
******************************************************

LOCAL _PAR_DATADAL
_PAR_DATADAL = "01/07/2017"

*** SCELTA DATA REGISTRAZIONE MOVIMENTI
_PAR_DATADAL = PJ_INPUTBOX("Inserire la Data Registrazione Partite Dal","Data Registrazione Partite Dal",_PAR_DATADAL)
IF EMPTY(ALLTRIM(_PAR_DATADAL))
	MESSAGEBOX("Data Registrazione Partite Dal obbligatoria",16,"Attenzione")
	RETURN .F.
ENDIF
IF EMPTY(ALLTRIM(_PAR_DATADAL)) .OR. _PAR_DATADAL = '  /  /    '
	MESSAGEBOX("Data Registrazione Partite Dal obbligatoria",16,"Attenzione")
	_PAR_DATADAL = ""
	RETURN .T.
ENDIF
IF VALID_DATA(_PAR_DATADAL)
ELSE
	MESSAGEBOX("Data Registrazione Partite Dal non valida",16,"Attenzione")
	RETURN .F.
ENDIF
_PAR_DATADAL = OK_DATA(_PAR_DATADAL)

** PAR_DESMO1 CONTIENE IL NR. PARTITA DI 'AD-HOC'
** PAR_NPORI = '***' IDENTIFICA TUTTE LE RIGHE DI PARTITARIO IMPORTATE

*** ASSEGNAZIONE N.PARTITA
_OLD_DESMO1 = ""
x_cond = "PAR_DTREG >= '" + RIBALTA2(_PAR_DATADAL) + "' AND PAR_NPORI = '***'"
cSql   = "SELECT PAR_NUMPRO,PAR_DESMO1,PAR_CODCLI FROM PART_FOR WHERE " + x_cond + " GROUP BY PAR_NUMPRO,PAR_DESMO1,PAR_CODCLI ORDER BY PAR_NUMPRO,PAR_DESMO1,PAR_CODCLI"
IF !ExecCommand(cSql,"ELAB_PART_FOR")
  return(.f.)
ENDIF
SELECT ELAB_PART_FOR
GO TOP
SCAN
	_NUMPRO = PAR_NUMPRO
	_DESMO1 = PAR_DESMO1
	_CODCLI = PAR_CODCLI
	_cNPART = ""
	
	WAIT WINDOWS "Assegnazione Nr. partita a riga partitario fornitori con PAR_NUMPRO = '" + _NUMPRO + "'" NOWAIT
	
	IF _DESMO1 = _OLD_DESMO1
	ELSE
		_OLD_DESMO1 = _DESMO1
		
		__PAR_NPART = ""
		v_seek  = 'NUMPRC'+PUB_CODSOC
		v_chiave= "codice"
		cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
		IF !ExecRW(cSql,"PARA","R")
		   return(.f.)
		ENDIF
		SELECT PARA
		IF RECCOUNT() <> 0
			V2=VAL(SUBSTR(LIBERA,1,7)) + 1
			REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
			__PAR_NPART = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
		ELSE
			RIT = MSGBOX('Parametro numero partita non trovato','ATTENZIONE',31)
		ENDIF
		IF !ExecRW(cSql,"PARA","W")
		   return(.f.)
		ENDIF
		
		_cNPART = __PAR_NPART
		
		x_cond = "PAR_NPORI = '***' AND PAR_DESMO1 = '" + _DESMO1 + "'"
		cSql   = "UPDATE PART_FOR SET PAR_NPART = " + __PAR_NPART + " WHERE " + x_cond
		IF !ExecCommand(cSql,"UPD_PART_FOR")
		  return(.f.)
		ENDIF
		
		*** INSERIMENTO RECORD 100
		_TOT_FATT = 0
		x_cond = "PAR_DTREG >= '" + RIBALTA2(_PAR_DATADAL) + "' AND PAR_TIPODO = 'FAT' AND PAR_NUMPRO = '" + _NUMPRO + "'"
		cSql   = "SELECT * FROM PART_FOR WHERE " + x_cond
		IF !ExecRW(cSql,"PART_FOR","R")
		  return(.f.)
		ENDIF
		SELECT PART_FOR
		GO TOP
		IF !EOF()
			SCAN
				_TOT_FATT = _TOT_FATT + PAR_FATT
			ENDSCAN
			GO TOP
			SCATTER MEMVAR MEMO
			M.PAR_NPROG = 100
			M.PAR_FATT = _TOT_FATT
			APPEND BLANK
			DO PART_FOR
			REPLACE PAR_CODACQ WITH M.PAR_CODACQ 
			REPLACE PAR_TIPOCONTRATTO WITH M.PAR_TIPOCONTRATTO 
			REPLACE PAR_FORMAPAGAMENTO WITH M.PAR_FORMAPAGAMENTO 
			REPLACE PAR_GRADOIMPORTANZA WITH M.PAR_GRADOIMPORTANZA 
			REPLACE PAR_COSATRATTA WITH M.PAR_COSATRATTA 
			REPLACE PAR_PRIPAGA WITH M.PAR_PRIPAGA 
			REPLACE PAR_NPORI WITH M.PAR_NPORI
		ENDIF
		IF !ExecRW(cSql,"PART_FOR","W")
		  return(.f.)
		ENDIF
	ENDIF
	
ENDSCAN


*** LEGAME CON MOV_CONT
_OLD_DESMO1 = ""
x_cond = "PAR_DTREG >= '" + RIBALTA2(_PAR_DATADAL) + "' AND PAR_NPORI = '***'"
cSql   = "SELECT * FROM PART_FOR WHERE " + x_cond + " ORDER BY PAR_NUMPRO,PAR_NPROG"
IF !ExecCommand(cSql,"ELAB_PART_FOR")
  return(.f.)
ENDIF
SELECT ELAB_PART_FOR
GO TOP
SCAN
	_NUMPRO = PAR_NUMPRO
	_CODCLI = PAR_CODCLI
	_cNPART = ALLTRIM(STR(PAR_NPART))
	
	WAIT WINDOWS "Legame con MOV_CONT riga partitario fornitori con PAR_NUMPRO = '" + _NUMPRO + "'" NOWAIT
	
	*** ASSEGNAZIONE N.PARTITA A MOVIMENTI CONTABILI LEGATI
	x_cond = "MOV_DTREG >= '" + RIBALTA2(_PAR_DATADAL) + "' AND MOV_CONTO = '" + _CODCLI + "' AND MOV_NUMPRO = '" + _NUMPRO + "'"
	cSql   = "UPDATE MOV_CONT SET MOV_NPART = " + _cNPART + " WHERE " + x_cond
	IF !ExecCommand(cSql,"UPD_MOV_CONT")
	  return(.f.)
	ENDIF
	
ENDSCAN

MESSAGEBOX("Operazione terminata",64,"Attenzione")

RETURN
