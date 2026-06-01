*!*	##############################################################################################################
  
					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE PROCEDURE PER IL BLOCCO/SBLOCCO                   ***
					***                       AUTOMATICO DI AQUARIUS (AQ_ADMIN)                                ***
					**********************************************************************************************

*!*	##############################################################################################################
  



*******************************************************************************************************************
* DEFINIZIONE CLASSE PER TIMER DI CONTROLLO FLAG DI BLOCCO PER CHIUSURA AUTOMATICA AQUARIUS DA QUALSIASI POSTAZIONE

DEFINE CLASS AqBlockTimer AS Timer
	
	PROCEDURE Timer
				
*!*			**=> ERASMO/SERGIO - INIZIO 29/05/2015
*!*			IF PUB_ABILITA_AqVerificaAlert
*!*				*** PUB_ABILITA_AqVerificaAlert: VARIABILE PER ABILITARE/DISABILITARE TEMPORANEAMENTE LE ESECUZIONI RW VERSO DB SQL, QUESTO PER EVITARE
*!*				*** ACCAVALLAMENTI DI ESECUZIONI CHE RICHIEDONO Asynchronous MODE .T. (FORMTOLOG E FORMTOOPE RICHIEDONO LA NORMALE Asynchronous MODE .F.)
*!*				*** COME AD ESEMPIO LE ESECUZIONI CON POSSIBILITA' DI ANNULLARE LA QUERY SQL (FORM\SQLEXECUTION_CANSTOP)
*!*				LOCAL _FormFileName,_FormCaption
*!*				_FormFileName = ""
*!*				_FormCaption = ""
*!*				_FormCaption = IIF(TYPE("_SCREEN.ActiveForm") == 'O' AND TYPE("_SCREEN.ActiveForm.caption") == "C" AND ALLTRIM(_SCREEN.ActiveForm.Name) <> "WAITBAR", ALLTRIM(_SCREEN.ActiveForm.caption), "")
*!*				_FormFileName = IIF(TYPE("_SCREEN.ActiveForm") == 'O' AND TYPE("JUSTFNAME(SYS(1271, _SCREEN.ActiveForm))") == "C" AND ALLTRIM(_SCREEN.ActiveForm.Name) <> "WAITBAR", JUSTFNAME(SYS(1271, _SCREEN.ActiveForm)), "")		
*!*				IF !EMPTY(_FormFileName) AND !EMPTY(_FormCaption)
*!*					DO FORMTOLOG WITH _FormCaption + " [" + ALLTRIM(_FormFileName) + "]"
*!*					DO FORMTOOPE WITH _FormCaption + " [" + ALLTRIM(_FormFileName) + "]"
*!*				ENDIF
*!*			ENDIF
*!*			**=> ERASMO/SERGIO - FINE 29/05/2015
	
		DO VERIFICA_BLOCCO WITH .T.  && VERIFICO SE E' ATTIVO IL BLOCCO AQUARIUS, ASPETTANDO UN TEMPO PROGRAMMATO DI n SECONDI
		
	ENDPROC
	
ENDDEFINE

	
PROCEDURE VERIFICA_BLOCCO

LPARAMETERS _par_waitmsg

IF PCOUNT() > 0
ELSE
	_par_waitmsg = .T.
ENDIF

_ACT_SEL = SELECT()

IF UPPER(ALLTRIM(PUB_WORKDIR)) = UPPER(ALLTRIM(sys(5) + sys(2003)))
ELSE
	RETURN
ENDIF

IF !FILE("TBL_BLOCCO.DBF")
	CREATE TABLE TBL_BLOCCO (APP_NAME C(20), STIMEOUT N(3,0), LOCKED L)
	SELECT TBL_BLOCCO
	USE
ENDIF

IF !TYPE("PUB_BLOCCA_AQUARIUS") == 'L'
	RELEASE PUB_BLOCCA_AQUARIUS, PUB_BLOCCA_AQUARIUS_MOSTRA_MSG, PUB_BLOCCA_AQUARIUS_SEC_INI, PUB_BLOCCA_AQUARIUS_TIMEOUT
	PUBLIC PUB_BLOCCA_AQUARIUS, PUB_BLOCCA_AQUARIUS_MOSTRA_MSG, PUB_BLOCCA_AQUARIUS_SEC_INI, PUB_BLOCCA_AQUARIUS_TIMEOUT
	PUB_BLOCCA_AQUARIUS = .F.
	PUB_BLOCCA_AQUARIUS_MOSTRA_MSG = .T.
	PUB_BLOCCA_AQUARIUS_SEC_INI = 0
	PUB_BLOCCA_AQUARIUS_TIMEOUT = 0
ENDIF

IF !PUB_BLOCCA_AQUARIUS

	IF !USED("TBL_BLOCCO")
	   USE TBL_BLOCCO IN 0 AGAIN
	ENDIF
	
	SELECT TBL_BLOCCO
	SET FILTER TO UPPER(ALLTRIM(APP_NAME)) == 'AQUARIUS'
	GO TOP
	IF EOF()
		APPEND BLANK
		REPLACE APP_NAME WITH 'AQUARIUS'
		REPLACE STIMEOUT WITH 100
		REPLACE LOCKED WITH .F.
	ENDIF
	PUB_BLOCCA_AQUARIUS = LOCKED
	PUB_BLOCCA_AQUARIUS_TIMEOUT = STIMEOUT
		
	USE

ENDIF

IF PUB_BLOCCA_AQUARIUS

	IF PUB_BLOCCA_AQUARIUS_SEC_INI = 0
		PUB_BLOCCA_AQUARIUS_SEC_INI = SECONDS()
	ENDIF
	
	IF _par_waitmsg AND PUB_BLOCCA_AQUARIUS_MOSTRA_MSG
		*_cMsg = "ATTENZIONE" + CHR(13) + "Il sistema si chiuderà automaticamente per assistenza tecnica" + CHR(13) + ;
		*	"Ultimare le attività e uscire entro " + ALLTRIM(STR(ROUND(PUB_BLOCCA_AQUARIUS_TIMEOUT,0))) + " secondi"
		*_cDynMsg = '"ATTENZIONE" + CHR(13) + "Il sistema si chiuderà automaticamente per assistenza tecnica" + CHR(13) + ' + ;
		*	'"Ultimare le attività e uscire entro " + ALLTRIM(STR(ROUND(_NTimeOut - _NDeltaTime,0))) + " secondi"'
		*MESSAGGIO_GROSSO_ROSSO(_cMsg,PUB_BLOCCA_AQUARIUS_TIMEOUT,_cDynMsg)
		**=> ERASMO - INIZIO 05/09/2013
		_cDynMsg = '"ATTENZIONE" + CHR(13) + CHR(13) + "Il sistema E.R.P. Aquarius si chiuderà automaticamente" + CHR(13) + "per assistenza tecnica" + CHR(13) + CHR(13) + ' + ;
			'"Ultimare le attività e uscire entro " + ALLTRIM(STR(ROUND(_NTimeOut - _NDeltaTime,0))) + " secondi"'
		DO MESSAGGIO_STILE_WIN8 WITH "","255,0,0",PUB_BLOCCA_AQUARIUS_TIMEOUT,_cDynMsg
		**=> ERASMO - INIZIO 05/09/2013
		PUB_BLOCCA_AQUARIUS_MOSTRA_MSG = .F.
		IF TYPE("_SCREEN.oAqBlockTimer") == "O"
			_SCREEN.oAqBlockTimer.Interval = 1000
		ENDIF
	ENDIF
	
	IF ((SECONDS() - PUB_BLOCCA_AQUARIUS_SEC_INI) >= PUB_BLOCCA_AQUARIUS_TIMEOUT) OR !_par_waitmsg 
		_SCREEN.Visible = .F.
		IF TYPE("_SCREEN.oAqBlockTimer") == "O"
			_SCREEN.oAqBlockTimer.Interval = 0
		ENDIF
		WAIT WINDOWS "MANUTENZIONE PROGETTO AQUARIUS IN CORSO" TIMEOUT 1
		DECLARE Integer ExitProcess IN WIN32API 
		ExitProcess()
	ENDIF
	
ENDIF

SELECT(_ACT_SEL)
	
ENDPROC
