****************************************************************************************************
FUNCTION CERCA_IN_TABELLE
****************************************************************************************************
*** RICERCA NELLE TABELLE RICHIESTE LA DESCRIZIONE DELLA STRINGA DESIDERATA
*** LA RICERCA AVVIENE SIA SUL CODICE ARTICOLO CHE SULLA DESCRIZIONE DELL'ARTICOLO
*** 
*** PARAMETRI:
***
*** 	- _par_cStringa       = Stringa da ricercare
*** 	- [_par_nSelezione]   = Numero (0/1/2) indicante il tipo di selezione da poter effettuare
*** 	                        (0 = nessuna selezione / 1 = selezione singola / 2 = selezione multipla)
*** 	- _par_cTabSource1    = Stringa contenente il nome della tabella da usare nella ricerca
*** 	- _par_cNome_campo1a  = Nome campo in cui ricercare la stringa
*** 	- _par_cNome_campo1b  = Nome campo in cui ricercare la stringa
***
*** 	- _par_cTabSource2    = Stringa contenente il nome della tabella da usare nella ricerca
*** 	- _par_cNome_campo2a  = Nome campo in cui ricercare la stringa
*** 	- _par_cNome_campo2b  = Nome campo in cui ricercare la stringa
***
*** 	- _par_cTabSource3    = Stringa contenente il nome della tabella da usare nella ricerca
*** 	- _par_cNome_campo3a  = Nome campo in cui ricercare la stringa
*** 	- _par_cNome_campo3b  = Nome campo in cui ricercare la stringa
***
***
***  
*** ESEMPIO:
*** 	DO PRG\CERCA_IN_DOCUMENTI WITH _cTestoDaRicercare,2,"U_ART_PR","ART_CODPRI",ART_DESCR"
*** 	DO PRG\CERCA_IN_DOCUMENTI WITH _cTestoDaRicercare,2,"U_ART_PR","ART_CODPRI",ART_DESCR","U_LIF_TT","LIS_CODART",LIS_DESART"
***
***
*** VARIABILI DI RITORNO
*** 	1) Cursore "CUR_DOCS" popolante la griglia di visualizzazione dei risultati di ricerca
*** 	2) Variabile di ritorno di tipo stringa _VAR_RIT contenente l'aggancio al primo documento 
*** 	   selezionato (solo se _par_nSelezione >= 1)
***
***
****************************************************************************************************
LPARAMETERS _par_cStringa,_par_nSelezione,_par_cTabSource1,_par_cNome_campo1a,_par_cNome_campo1b,_par_cTabSource2,_par_cNome_campo2a,_par_cNome_campo2b,_par_cTabSource3,_par_cNome_campo3a,_par_cNome_campo3b


RELEASE _VAR_RIT
PUBLIC _VAR_RIT
_VAR_RIT = ""

IF PCOUNT() >= 5
ELSE
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN _VAR_RIT
ENDIF

IF TYPE("_par_cStringa") <> 'C'
	MESSAGEBOX("Parametro stringa da cercare non di tipo STRINGA",16,"Attenzione")
	RETURN _VAR_RIT
ENDIF

_par_cStringa = ALLTRIM(_par_cStringa)


CREATE CURSOR CUR_TABLE (SELEZIONE L, FLGCHNG L, TIPDOC C(10), AGGANCIO C(10), NUMDOC C(10), DATDOC C(10), CLIFOR C(10), RAGSOC C(100), CODRIC C(10), ;
						DESRIC C(100), CODART C(16), DESART C(100), UM C(3), QUANTI N(17,2), PREZZO N(17,6), SCONTO1 N(9,3), SCONTO2 N(9,3), ;
						SCONTO3 N(9,3), VALORE N(19,3), COMMENTO M)

SELECT CUR_TABLE
INDEX ON TIPDOC + DATDOC + NUMDOC TAG I_DATNUM DESCENDING ADDITIVE
_TotFields_CUR_TABLE = AFIELDS(_Fields_CUR_TABLE)

	
	SELECT &_par_cTabSource
	IF UPPER(ALLTRIM(&_NomeCampoTipologia)) == "RDA"

		x_cart = "CODART LIKE '%" + _par_cStringa + "%'"
		x_dart = "DESART LIKE '%" + _par_cStringa + "%'"
		x_cond = x_cart + " or " + x_dart 
		

		
		Csql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
		
		IF !ExecCommand(cSql,"CX_ART_PR")
		  return(.f.)
		ENDIF
		SELECT CX_DETT_RDA
		GO TOP
		BROWSE NORMAL
		
*!*			SCAN
*!*				SELECT CX_ART_PR
*!*				APPEND BLANK
*!*				FOR I=1 TO _TotFields_CUR_DOCS
*!*					SELECT CX_DETT_RDA
*!*					_NomeCampo = _Fields_CUR_DOCS[I,1]
*!*					_NomeVar = "_X_" + ALLTRIM(_NomeCampo)
*!*					*&_NomeVar = &_NomeCampo
*!*					&_NomeVar = IIF(!ISNULL(&_NomeCampo),&_NomeCampo,IIF(TYPE(_NomeCampo)=='N',0,IIF(TYPE(_NomeCampo)=='L',.F.,"")))  && ERASMO - 26/04/2012
*!*					SELECT CUR_DOCS
*!*					REPLACE &_NomeCampo WITH &_NomeVar
*!*				NEXT
*!*			ENDSCAN
	ENDIF



	*ENDIF
	
	


*!*	_VAR_RIT = ""

*!*	SELECT CUR_TABLE
*!*	SET ORDER TO I_DATNUM 
*!*	GO TOP
*!*	IF EOF()
*!*	ELSE

*!*		*** MARCATURA CUR_TABLE.FLGCHNG PER VISUALIZZAZIONE BIANCO/GRIGETTO A ROTTURA DOCUMENTO
*!*		_OLD_AGGANCIO = ""
*!*		_OLD_FLGCHNG = .T.
*!*		SCAN
*!*			IF _OLD_AGGANCIO = AGGANCIO
*!*				REPLACE FLGCHNG WITH _OLD_FLGCHNG
*!*			ELSE
*!*				_OLD_FLGCHNG = !_OLD_FLGCHNG
*!*				_OLD_AGGANCIO = AGGANCIO
*!*				REPLACE FLGCHNG WITH _OLD_FLGCHNG
*!*			ENDIF
*!*		ENDSCAN
*!*		GO TOP
*!*		
*!*		_V_MOSTRA_PREZZI = UTENTE_MOSTRA_PREZZI(PUB_CODOPE)
*!*		
*!*		DO FORM FORM\CERCA_IN_DOCUMENTI WITH _par_nSelezione LINKED
*!*		
*!*		*** RITORNO L'AGGANCIO DEL PRIMO DOCUMENTO SELEZIONATO
*!*		NumeroRecordSelezionati = 0
*!*		SELECT CUR_TABLE
*!*		GO TOP
*!*		SCAN
*!*			IF SELEZIONE
*!*				NumeroRecordSelezionati = NumeroRecordSelezionati + 1
*!*			ENDIF
*!*		ENDSCAN
*!*		
*!*		GO TOP
*!*		IF NumeroRecordSelezionati > 0
*!*			SCAN
*!*				IF SELEZIONE
*!*					_VAR_RIT = AGGANCIO
*!*					EXIT
*!*				ENDIF
*!*			ENDSCAN
*!*		ENDIF
*!*	ENDIF

*!*	RETURN _VAR_RIT

ENDFUNC

