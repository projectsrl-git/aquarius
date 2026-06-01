DO SETLIB

SET STEP ON 


SET CENTURY ON
STORE {^2001-03-28} TO _DIARYDATE
=MESSAGEBOX(DTOC(_DIARYDATE),64)
ACTIVATE WINDOW calendar
=MESSAGEBOX("Change date to July 4, 1776",48))
STORE {^1776-07-04} TO _DIARYDATE
=MESSAGEBOX(DTOC(_DIARYDATE),64)
=MESSAGEBOX("Change date to today's date",48)
STORE DATE( ) TO _DIARYDATE
=MESSAGEBOX(DTOC(_DIARYDATE),64)
RELEASE WINDOW calendar


********################################################################

*!*	_STRINGA="C:\AQUARIUS\1_LISTINO_FORNITORI_1"
*!*	_STRINGA_DA_CERCARE = "2_LISTINO"
*!*	_LUNGHEZZA_DA_CERCARE = 9 


*!*	POS_STRINGA=CERCA_CHR(_STRINGA,_STRINGA_DA_CERCARE,_LUNGHEZZA_DA_CERCARE)


*!*	A=POS_STRINGA

*********###############################################################à

*!*	** CERCO LA PAROLA E RESTITUISCO : 
*!*	** POSIZIONE_PAROLA : è la posizione iniziale della stringa che si desidera cercar
*!*	** POSIZIONE_PAROLA_SUCCESSIVA : è la posizione iniziale della parola successiva

*!*	PUB_PAROLA_SUCCESSIVA               = ""
*!*	PUB_POSIZIONE_PAROLA				= 0
*!*	PUB_POSIZIONE_PAROLA_SUCCESSIVA		= 0 

*!*	_STRINGA_IN_CUI_RICERCARE     = "causale interna: OC 	48	OC	771,72	FATTURE 2860287 296"
*!*	_STRINGA_IN_CUI_RICERCARE	  = ALLTRIM(STRTRAN(_STRINGA_IN_CUI_RICERCARE," ",""))	&& TOGLIE IL CARATTERE SPECIALE 
*!*	_STRINGA_DA_RICERCARE   	  = "OC 	48	OC"				&& SUBITO DOPO QUESTA PAROLA INIZIA INIZIA L'IMPORTO	
*!*	_STRINGA_DA_RICERCARE   	  = ALLTRIM(STRTRAN(_STRINGA_DA_RICERCARE," ",""))	&& TOGLIE IL CARATTERE SPECIALE 


*!*	_LEN_STRINGA_DA_RICERCARE     = LEN(_STRINGA_DA_RICERCARE)

*!*	=FIND_WORDS(_STRINGA_IN_CUI_RICERCARE,_STRINGA_DA_RICERCARE)


*!*	? PUB_POSIZIONE_PAROLA, PUB_POSIZIONE_PAROLA_SUCCESSIVA

**--------------------------------------------------

*!*	_DATAAL  = DTOC(DATE())
*!*	_DATADAL = "01/01/2014"

*!*	__GGOGGI = TRASGG("GMA",_DATAAL)
*!*	__GGIERI = TRASGG("GMA",_DATADAL)
*!*	__GGESPO = __GGOGGI - __GGIERI   	

*!*	__NUMERO_ANNI = __GGESPO / 365		&& NUMERO ANNI
*!*	__NUMERO_MESI = __NUMERO_ANNI * 12	&& NUMERO MESI

*!*	? "numero giorni"+ STR(__GGESPO,9,0)
*!*	? "numero mesi"+ STR(__NUMERO_MESI,4,0)



**--------------------------------------------------
*!*	_ean = "E13"
*!*	_barC=EAN13(_ean)

*!*	a=_barC
*!*	? a
**--------------------------------------------------

*!*	_CAMPO = "AB CD EF"
*!*	a=STRTRAN(_CAMPO," ","")     
*!*	? a
**--------------------------------------------------
