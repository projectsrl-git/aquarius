
_RISP = MESSAGEBOX("Questo programma permette di spostare tutti i files di programma ESISTENTI, contenuti in una determinata lista, nella cartella 'SW_OBSOLETO' della ROOT di Aquarius." + CHR(13) + CHR(13) + ;
	"Selezionare il file di testo che contiene la lista dei files da spostare." + CHR(13) + CHR(13) + ;
	"N.B.: Ogni riga del file TXT può contenere un solo nome file, ed ogni file deve essere completo di estensione e del percorso a partire dalla ROOT di Aquarius (esclusa), ad esempio:" + CHR(13) + ;
	"      FORM\CREBOLPOR1.SCT" + CHR(13) + ;
	"      FORM\CREBOLPOR1.SCX" + CHR(13) + ;
	"      PRG\MAGAZZINOLIB.PRG" + CHR(13) + ;
	"      PRG\MAGAZZINOLIB.FXP" + CHR(13) + ;
	"      ..." + CHR(13) + CHR(13) + "Continuare con la selezione della lista?",32+4+256,"Attenzione")
IF _RISP = 6
ELSE
	RETURN
ENDIF

_cLista = ""
_cFile = ""
_V_FILE = GETFILE("Tutti i files di testo:TXT","File:","Apri",0,"Selezionare il file contenente la lista dei files di programma da spostare")
_V_FILE = ALLTRIM(_V_FILE)

IF EMPTY(_V_FILE) .OR. !FILE(_V_FILE)
	MESSAGEBOX("Nessun file selezionato",48,"Attenzione")
	RETURN
ENDIF

IF SPACE(1) $ _V_FILE
	MESSAGEBOX("Il nome file non può contenere spazi" + CHR(13) + CHR(13) + ;
		"Rinominare il file sorgente e ripetere l'operazione",48,"Attenzione")
	RETURN
ENDIF

_cFile = _V_FILE

CREATE CURSOR LISTA_FILES (NAME C(254))
_cCommand = "APPEND FROM " + _cFile + " TYPE SDF"
&_cCommand

_cOldDir = SYS(5)+SYS(2003)
_cNewDir = SYS(5)+SYS(2003)+"\sw_obsoleto"

_nCount = 0
SELECT LISTA_FILES
GO TOP
SCAN
	IF !EMPTY(NAME)
		_cFileSrc = _cOldDir + "\" + ALLTRIM(NAME)
		_cDirSrc = STRTRAN(ALLTRIM(NAME),JUSTFNAME(ALLTRIM(NAME)),"")
		_cDestDir = _cNewDir + "\" + _cDirSrc
		IF FILE(_cFileSrc)
			WAIT WINDOWS "Spostamento file '" + _cFileSrc + "' ..." NOWAIT
			_cDosCommandCopy = '! XCOPY "' + _cFileSrc + '" "' + _cDestDir + '" /Y'
			&_cDosCommandCopy
			_cDosCommandDelete = '! DEL "' + _cFileSrc + '"'
			&_cDosCommandDelete
			_nCount = _nCount + 1
		ENDIF
	ENDIF
ENDSCAN
USE

WAIT CLEAR

IF _nCount > 0
	MESSAGEBOX("Totale files spostati: " + ALLTRIM(STR(_nCount)),64,"Informazione")
	_RISP = MESSAGEBOX("Aprire la cartella '" + _cNewDir + "'",32+4,"Informazione")
	IF _RISP = 6
		WAIT WINDOWS "Apertura cartella in corso..." NOWAIT
		_V_RUN = "/N Explorer /e," + ALLTRIM(_cNewDir)
		RUN &_V_RUN
	ENDIF
ELSE
	MESSAGEBOX("Nessun file spostato",48,"Attenzione")
ENDIF

RETURN

