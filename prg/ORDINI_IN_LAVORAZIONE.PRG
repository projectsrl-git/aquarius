

SELECT CU_ORD_DD

DAGGA = DAGGANCIO

PUBLIC V_NSRIF
*V_NSRIF   = _RIFER

*!*	SELECT U_ORD_TT

*!*	SET ORDER TO  ORDHOOKT
*!*	SEEK DAGGA

*!*	IF FOUND()

  V_OPE    = SUBSTR(M.ORD_CODOPE,1,1)
  V_NUMORD = M.ORD_NUMORD
  V_RAGSOC = M.ORD_RAGSOC
  V_RAGDUE = ""
  V_RAGTRE = ""
  V_RAGQUA = ""

  V_INDIRI = M.ORD_INDIRI
  V_CAP    = M.ORD_CAP
  V_LOCALI = M.ORD_LOCALI
  V_CODCLI = M.ORD_CODCLI
  V_PIVA   = M.ORD_PARIVA
*  V_VETTO  = M.ORD_VETTO
  V_VETTO  = "   "
  V_NSRIF  = ORD_RIFERI


*!*	ELSE

*!*	  V_NSRIF  = M.ORD_RIFERI
*!*	  V_NUMORD = M.ORD_NUMORD 
*!*	   
*!*	ENDIF

*CREATE CURSOR CU_LAVO (X_CODART C(16), X_QTAORD N(10,2), X_DATCON C(10), V_NSRIF C(30),V_NUMORD C(6)) 
*CREATE CURSOR CU_LAVO (X_CODART C(16), X_QTAORD N(10,2), X_DATCON C(10), V_NSRIF C(30),V_NUMORD C(6), X_CODSYS C(10))  && ERASMO - 06/08/2018
CREATE CURSOR CU_LAVO (X_CODART C(16), X_QTAORD N(10,2), X_DATCON C(10), V_NSRIF C(30),V_NUMORD C(6), X_CODSYS C(10), X_CODREV C(10))  && ERASMO - 29/06/2023
INDEX ON ORD_DATCON TAG DATCON

SELE CU_ORD_DD
GO TOP

DO WHILE !EOF()
	
	SELE CU_ORD_DD
	
	IF EMPTY (ORD_CODART) 
		SKIP + 1
		LOOP
	ENDIF	
	
	M.X_CODART= ORD_CODART
	M.X_QTAORD= ORD_QTAORD
	*X_DATCON= RIBALTA2(ORD_DATCON)
	M.X_DATCON= IIF(SUBSTR(ORD_DATCON,5,1)='/',ORD_DATCON,RIBALTA2(ORD_DATCON))  && ERASMO - 03/09/2018
	M.X_CODSYS= ORD_CODSYS  && ERASMO - 06/08/2018
	
	**=> ERASMO - INIZIO 29/06/2023
	M.X_CODREV= ORD_DES2
	_NOLISLCK = .F.
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + M.X_CODART + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select ART_NOLISLCK from u_art_an where " + x_cond
	IF !ExecCommand(cSql,"CHK_ART_AN")
	   return(.f.)
	ENDIF
	SELECT CHK_ART_AN
	GO TOP 
	IF !EOF()
		_NOLISLCK = ART_NOLISLCK
	ENDIF
	IF !_NOLISLCK
		M.X_CODREV = ""
	ENDIF
	**=> ERASMO - FINE 29/06/2023
				
	SELECT CU_LAVO
	APPEND BLANK
	GATHER MEMVAR
		
	SELE CU_ORD_DD
	SKIP+1
	LOOP
	
ENDDO	

*CREATE CURSOR CU_MESI (Y_CODART C(16), Y_QTAORD N(10,2), Y_DATCON C(10), V_NSRIF C(30),V_NUMORD C(6))
*CREATE CURSOR CU_MESI (Y_CODART C(16), Y_QTAORD N(10,2), Y_DATCON C(10), V_NSRIF C(30),V_NUMORD C(6), Y_CODSYS C(10))  && ERASMO - 06/08/2018
CREATE CURSOR CU_MESI (Y_CODART C(16), Y_QTAORD N(10,2), Y_DATCON C(10), V_NSRIF C(30),V_NUMORD C(6), Y_CODSYS C(10), Y_CODREV C(10))  && ERASMO - 29/06/2023
INDEX ON Y_DATCON TAG DATCON

SELE CU_LAVO
SET ORDER TO DATCON
GO TOP

X_RIF = ""

DO WHILE !EOF()
	
	MESI = SUBSTR(X_DATCON,6,2)
	
	IF SUBSTR(X_DATCON,6,2) <> MESI
		SKIP +1
		LOOP
	ENDIF
	
	M.Y_CODART= X_CODART
	M.Y_QTAORD= X_QTAORD
	M.Y_DATCON= X_DATCON
	M.Y_CODSYS= X_CODSYS  && ERASMO - 06/08/2018
	M.Y_CODREV= X_CODREV  && ERASMO - 29/06/2023
				
	SELECT CU_MESI
	APPEND BLANK
	GATHER MEMVAR

	X_RIF =  V_NSRIF

	SELE CU_LAVO
	SKIP+1
	LOOP
	
ENDDO	


SELE CU_MESI
SET ORDER TO DATCON
GO TOP


DO PRG\MENUSTA WITH "CU_MESI",.T.,.T.,"ORDINI_IN_LAVORAZIONE","ORDINI_IN_LAVORAZIONE","ORDINI_IN_LAVORAZIONE.frx",.T.

IF 6=MESSAGEBOX("Vuoi stampare i disegni?",35,"Ordine interno")
	DO STAMPA_DISEGNI_PDF
ENDIF


IF 6=MESSAGEBOX("Vuoi stampare le etichette dei disegni?",35,"Ordine interno")
	DO STAMPA_ETICHETTE_DISEGNI
ENDIF




*******************************************
PROCEDURE STAMPA_ETICHETTE_DISEGNI
*******************************************
	 
*** Y_CODART C(16), Y_QTAORD N(10,2), Y_DATCON C(10), V_NSRIF C(30),V_NUMORD C(6))
*!*	SELECT CU_MESI
*!*	GO TOP
*!*	BROWSE NORMAL	 

**=> ERASMO/ALESSANDRO - INIZIO 19/04/2018
_lSavePrinterName = ""
IF TYPE('alltrim(set("PRINTER",3))') == 'C'
	_lSavePrinterName = alltrim(set("PRINTER",3))
ENDIF
_zebra = ""
lFoundPrinter=.F.
if aprinters(laPrinters) > 0
	for x = 1 to alen(laPrinters)
		if UPPER("ZDesigner ZT230-200dpi ZPL") $ alltrim(upper(laPrinters[x]))
			_zebra = alltrim(laPrinters[x])
			lFoundPrinter = .t.
			EXIT
		endif
	endfor

	if lFoundPrinter
		*MESSAGEBOX("STAMPANTE ZEBRA: " + _zebra)
		_COMMAND = "SET PRINTER TO NAME '" + _zebra +"'"
		&_COMMAND
	ELSE
		*MESSAGEBOX("STAMPANTE ZDesigner ZT230-200dpi ZPL on srv-gl NON TROVATA")
	endif
ENDIF
**=> ERASMO/ALESSANDRO - FINE 19/04/2018
 
DO PRG\MENUSTA WITH "CU_MESI",.F.,.T.,"XXX","ETIC_DISEGNI","ETIC_DISEGNI.lbx"

**=> ERASMO/ALESSANDRO - INIZIO 19/04/2018
IF !EMPTY(_lSavePrinterName)
	_set_default_printer_cmd = "SET PRINTER TO NAME '" + _lSavePrinterName+ "'"
	&_set_default_printer_cmd
ENDIF
**=> ERASMO/ALESSANDRO - FINE 19/04/2018

RETURN
*** FINE STAMPA_ETICHETTE_DISEGNI


*******************************************
PROCEDURE STAMPA_DISEGNI_PDF
*******************************************

* -->> Ricerca ed eventuale creazione directory di default
* --------------------------------------------------------
_ATCH_tipo ='PRO'
x_codi = "codice = 'ALL" + _ATCH_tipo + "'"
x_cond = x_codi
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"TMP_PARA")
	return(.f.)
ENDIF
SELECT TMP_PARA
IF EOF()
	RELEASE  V_NSRIF  
	RETURN
ELSE
	_V_PARA_PATH = ALLTRIM(LIBERA)
ENDIF

_V_PATH_DESTIN = _V_PARA_PATH

**=> ERASMO - FINE 10/01/2013
DO CASE
	CASE SUBSTR(_V_PARA_PATH,1,2) = "\\"	&& PERCORSO SU SERVER DIVERSO
		_V_PATH_DESTIN = _V_PARA_PATH

	CASE !EMPTY(JUSTDRIVE(_V_PARA_PATH))	&& PERCORSO FISSO
		_V_PATH_DESTIN = _V_PARA_PATH
	
	OTHERWISE								&& PERCORSO RELATIVO RISPETTO ALLA DIRECTORY DI LAVORO DI AQUARIUS (CARTELLA SUPERIORE)
		_cWorkDir = SYS(5) + SYS(2003)
		_V_PATH_DESTIN = SUBSTR(_cWorkDir,1,RAT('\',_cWorkDir,1)-1) + _V_PARA_PATH
ENDCASE

_lExit = .F.
IF !DIRECTORY(_V_PATH_DESTIN)
	MESSAGEBOX('Impossibile raggiungere il percorso "' + ALLTRIM(_V_PATH_DESTIN) + '"' + CHR(13) + CHR(13) + ;
		'Verificare la correttezza del parametro "ALL' + _ATCH_tipo + '" e/o la disponibilità del volume, unità di rete o percorso condiviso',16,'Attenzione')
	RELEASE  V_NSRIF  
	RETURN
ENDIF



SELE CU_MESI
SET ORDER TO DATCON
GO TOP
_random=SYS(2015)
_file_dest=_V_PATH_DESTIN + "\"+_random+".pdf"
_W_FILE=""
_batch_filename="createpdf"+_random+".bat"

*STRTOFILE( 'gswin64.exe -dBATCH -dNOPAUSE -dCompatibilityLevel=1.4 -sDEVICE=pdfwrite -sOutputFile="'+_file_dest+'" ',_batch_filename,1)
*STRTOFILE( 'gswin64c.exe -dBATCH -dNOPAUSE -dCompatibilityLevel=1.4 -sDEVICE=pdfwrite -sOutputFile="'+_file_dest+'" ',_batch_filename,1)  && ERASMO - 15/01/2018 - CON 'gswin64c.exe' SI RISOLVE IL PROBLEMA DELLA LUNG. MAX DELLA STRINGA BATCH

**=> ERASMO - INIZIO 23/04/2018
cGSFolder = ""
if !directory("C:\gs")
	MESSAGEBOX("MANCA DIRECTORY 'C:\gs'",48,"ATTENZIONE")
	return .f.
endif
liGS = adir(laGSFolders, "C:\gs\*.*","D")
if liGS < 1
	MESSAGEBOX("ERRATA DIRECTORY 'C:\gs'",48,"ATTENZIONE")
	return .f.
endif
for x = 1 to alen(laGSFolders,1)
	lcTmp = alltrim(upper(laGSFolders[x,1]))
	if "GS" = left(lcTmp,2) and "D" $ laGSFolders[x,5]
		cGSFolder = lcTmp
	endif
endfor
if empty(cGSFolder)
	MESSAGEBOX("ERRATA DIRECTORY 'C:\gs'",48,"ATTENZIONE")
	return .f.
endif
cGSFolder = "c:\gs\"+alltrim(cGSFolder)+"\bin\"
c_GSWINXXC_name = cGSFolder+"gswin32c.exe"
IF !FILE(c_GSWINXXC_name)
	c_GSWINXXC_name = cGSFolder+"gswin64c.exe"
	IF !FILE(c_GSWINXXC_name)
		MESSAGEBOX("ESEGUIBILE GHOSTSCRIPT "+cGSFolder+"gswin64c.exe OPPURE "+cGSFolder+"gswin32c.exe MANCANTE",48,"ATTENZIONE")
		RETURN .F.
	ENDIF
ENDIF

STRTOFILE(c_GSWINXXC_name + ' -dBATCH -dNOPAUSE -dCompatibilityLevel=1.4 -sDEVICE=pdfwrite -sOutputFile="'+_file_dest+'" ',_batch_filename,1)
**=> ERASMO - FINE 23/04/2018

DO WHILE !EOF()

	*_W_FILE=_V_PATH_DESTIN + "\"+STRTRAN(ALLTRIM(Y_CODART),"/",".")+".PDF"
	_W_FILE=_V_PATH_DESTIN + "\"+STRTRAN(ALLTRIM(Y_CODART)+IIF(!EMPTY(ALLTRIM(Y_CODREV)),"_"+ALLTRIM(Y_CODREV),""),"/",".")+".PDF"  && ERASMO - 29/06/2023
		
	IF FILE(_W_FILE)

		STRTOFILE( ' "'+_W_FILE+'"',_batch_filename,1)
	ELSE
		MESSAGEBOX("MANCA DISEGNO "+_W_FILE,48,"ATTENZIONE")
	
	ENDIF
	
	SKIP

ENDDO

*RUN &_batch_filename
**=> ERASMO - INIZIO 15/01/2018
WAIT WINDOWS "Elaborazione disegni in corso..." NOWAIT
RUN &_batch_filename
WAIT CLEAR
**=> ERASMO - FINE 15/01/2018

**=> ERASMO - INIZIO 23/04/2018
_command = "ERASE '" + ALLTRIM(_batch_filename) + "'"
&_command
**=> ERASMO - FINE 23/04/2018

_W_FILE=_V_PATH_DESTIN + "\"+_random+".pdf"
DO Open_with_default_windows_program WITH _W_FILE

RELEASE  V_NSRIF  


RETURN
*** FINE STAMPA_DISEGNI_PDF
