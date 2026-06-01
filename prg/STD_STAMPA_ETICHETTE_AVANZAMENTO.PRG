LPARAMETERS _PAR_QTA,_PAR_UM,_PAR_COND_ORDINI,_PAR_MAG_UNIQUE

LOCAL _MESSAGGIO,;
	_V_QTA,;
	_C_QTA_SINGOLA ,;
	_V_QTA_SINGOLA ,;
	_V_UM,;
	_V_QTA_ETICHETTE
	
RELEASE _PUB_ARTCLI,_PUB_ORDCLI,_V_QTA_PRODOTTA,_PUB_UM,_V_CODCLI,_V_CODSYS,_PUB_MAG_UNIQUE,_PUB_NUMORD
PUBLIC _PUB_ARTCLI,_PUB_ORDCLI,_V_QTA_PRODOTTA ,_PUB_UM,_V_CODCLI,_V_CODSYS,_PUB_MAG_UNIQUE,_PUB_NUMORD
	
_V_QTA_PRODOTTA = _PAR_QTA
_PUB_UM = _PAR_UM
_PUB_MAG_UNIQUE=_PAR_MAG_UNIQUE
_PUB_NUMORD = _PAR_COND_ORDINI

*!*	_MESSAGGIO = CHR(10)+;
*!*		"STAMPA ETICHETTE"+CHR(10)+CHR(10)+CHR(10)+;
*!*		"STAMPARE LE ETICHETTE DEGLI ARTICOLI PRODOTTI?"
*!*	IF MESSAGGIO_GROSSO_ROSSO_RISPOSTA_SI_NO(_MESSAGGIO,1) = "SI"
*!*	ELSE
*!*		RETURN
*!*	ENDIF

WAIT WINDOWS "Stampa etichette in corso..." NOWAIT
	
*** ARTICOLO CLIENTE
SELECT CU_PROD_CARICHI
_V_CODART=ALLTRIM(CODART)

**=> ERASMO - INIZIO 01/08/2018
_V_PROGRE = PROGRE
_FILTER = FILTER()
SET FILTER TO &_FILTER AND PROGRE = _V_PROGRE
**=> ERASMO - FINE 01/08/2018

TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
	SELECT ART_DES_I FROM U_ART_PR WHERE ART_CODPRI='<<_V_CODART>>'
ENDTEXT					&& FINE SCRITTURA QUERY

IF !ExecPreparedCommand(cSql,"C_ARTCLI")
	return(.F.)
ENDIF

SELECT C_ARTCLI
GO TOP

_PUB_ARTCLI=ART_DES_I 


*** NUMERO ORDINE CLIENTE

_PUB_ORDCLI=""
_V_RAGSOC=""
_V_CODCLI=""

*!*	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
*!*		SELECT TOP 1 ORD_RAGSOC , ORD_RIFERI FROM U_ORD_TT WHERE ORD_NUMORD ='<<_PAR_COND_ORDINI>>' 
*!*		ORDER BY ORD_DATORD DESC
*!*	ENDTEXT					&& FINE SCRITTURA QUERY

TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
	SELECT TOP 1 
		DD.ORD_CODSYS,
		TT.ORD_CODCLI,
		TT.ORD_RAGSOC , 
		TT.ORD_RIFERI 
	FROM U_ORD_TT AS TT
	LEFT OUTER JOIN U_ORD_DD AS DD
	ON TT.TAGGANCIO=DD.DAGGANCIO
	WHERE ORD_NUMORD ='<<_PAR_COND_ORDINI>>' AND DD.ORD_CODART='<<_V_CODART>>'
	ORDER BY ORD_DATORD DESC
ENDTEXT					&& FINE SCRITTURA QUERY

IF !ExecPreparedCommand(cSql,"C_ORDCLI")
	return(.F.)
ENDIF

SELECT C_ORDCLI
GO TOP

IF !EOF()
	_PUB_ORDCLI=ALLTRIM(ORD_RIFERI)
	_V_RAGSOC=ALLTRIM(ORD_RAGSOC)
	_V_CODCLI = ALLTRIM(ORD_CODCLI)
	_V_CODSYS = ALLTRIM(ORD_CODSYS)
ENDIF


_PUB_ORDCLI=_PUB_ORDCLI + CHR(13)+_V_RAGSOC

_V_PROGRESSIVO_QTA_ETICHETTE = 0

*!*	*** CREO UNA COPIA DEL CURSORE CU_PROD_CARICHI
*!*	*** CONTENENTE SOLO L'ULTIMO CARICO 
*!*	SELECT CU_PROD_CARICHI
*!*	AFIELDS(_A_TEMP)
*!*	CREATE CURSOR C_TEMP FROM ARRAY _A_TEMP

*!*	SELECT CU_PROD_CARICHI
*!*	*GO BOTT

*!*	SCATTER MEMVAR MEMO

*!*	SELECT C_TEMP 
*!*	APPEND BLANK
*!*	GATHER MEMVAR MEMO
*!*	GO TOP

*_Z_REPORT = "REPORT\etic_scatole_assemblaggio.lbx"

**=> ERASMO - INIZIO 26/09/2016
_choice = 0
DEFINE POPUP generatePop SHORTCUT RELATIVE FROM MROW(),MCOL()
DEFINE BAR 1 OF generatePop PROMPT "Stampante etichette sede \<PRINCIPALE"
DEFINE BAR 2 OF generatePop PROMPT "Stampante etichette sede PRINCIPALE Piano \<Terra"
DEFINE BAR 3 OF generatePop PROMPT "Stampante etichette sede \<DISTACCATA"
ON SELECTION BAR 1 OF generatePop _choice = 1
ON SELECTION BAR 2 OF generatePop _choice = 2
ON SELECTION BAR 3 OF generatePop _choice = 3
ACTIVATE POPUP generatePop
DO CASE
	CASE _choice = 1
		_Z_REPORT = "REPORT\etic_scatole_assemblaggio.lbx"
	CASE _choice = 2
		_Z_REPORT = "REPORT\etic_scatole_assemblaggio_pt.lbx"
	CASE _choice = 3
		_Z_REPORT = "REPORT\etic_scatole_assemblaggio_2.lbx"
ENDCASE
*LABEL FORM &_Z_REPORT NOCONSOLE PREVIEW
*LABEL FORM &_Z_REPORT NOCONSOLE TO PRINTER PROMPT
**=> ERASMO - FINE 26/09/2016

**=> ERASMO/ALESSANDRO - INIZIO 21/05/2019
_lSavePrinterName = ""  && ERASMO - 11/09/2019
IF _choice = 3
	_lSavePrinterName = ""
	IF TYPE('alltrim(set("PRINTER",3))') == 'C'
		_lSavePrinterName = alltrim(set("PRINTER",3))
	ENDIF
	_zebra = ""
	lFoundPrinter=.F.
	if aprinters(laPrinters) > 0
		for x = 1 to alen(laPrinters)
			*if UPPER("ZDesigner ZT230-200dpi ZPL") $ alltrim(upper(laPrinters[x]))
			if UPPER("Stampante-Etichette10x10-SedeDist") $ alltrim(upper(laPrinters[x]))  && ERASMO/ALESSANDRO - 21/03/2024
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
ENDIF
**=> ERASMO/ALESSANDRO - FINE 21/05/2019

**=> ERASMO/ALESSANDRO - INIZIO 21/09/2023
IF _choice = 1
	_lSavePrinterName = ""
	IF TYPE('alltrim(set("PRINTER",3))') == 'C'
		_lSavePrinterName = alltrim(set("PRINTER",3))
	ENDIF
	_zebra = ""
	lFoundPrinter=.F.
	if aprinters(laPrinters) > 0
		for x = 1 to alen(laPrinters)
			if UPPER("Stampante-Etichette10x10") $ alltrim(upper(laPrinters[x]))
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
ENDIF
**=> ERASMO/ALESSANDRO - FINE 21/09/2023

**=> ERASMO - INIZIO 26/04/2018
IF _choice > 0
	SELECT CU_PROD_CARICHI  && ERASMO - 01/08/2018
	LABEL FORM &_Z_REPORT NOCONSOLE TO PRINTER PROMPT
ELSE
	WAIT WINDOWS "Nessuna stampante selezionata" TIMEOUT 3
ENDIF
**=> ERASMO - FINE 26/04/2018

**=> ERASMO/ALESSANDRO - INIZIO 21/05/2019
IF !EMPTY(_lSavePrinterName)
	_set_default_printer_cmd = "SET PRINTER TO NAME '" + _lSavePrinterName+ "'"
	&_set_default_printer_cmd
ENDIF
**=> ERASMO/ALESSANDRO - FINE 21/05/2019

**=> ERASMO - INIZIO 01/08/2018
SELECT CU_PROD_CARICHI
SET FILTER TO &_FILTER
GO TOP
**=> ERASMO - FINE 01/08/2018

*DO PRG\MENUSTA WITH "C_TEMP",.T.,.F.,"XXX","etic_scatole_assemblaggio","etic_scatole_assemblaggio.lbx"
