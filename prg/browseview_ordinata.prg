************************************************************************
* BROWSEVIEW_ORDINATA
************************************************************************
* Sintassi
* 
* DO prg\BROWSEVIEW_ORDINATA WITH <cursore o tabella>,<titolo>,[<mappatura campi>,<altezza griglia>,<larghezza griglia>,<selezione rapida attivata>]
*
* 1) <cursore o tabella>           : é la tabella/cursore che si vuole visualizzare. DEVE CONTENERE UN CAMPO SELEZIONE C(3)
* 2) <titolo>                      : titolo della griglia
* 3) <mappatura campi>             : indica il titolo che si vuole dare alle colonne della griglia nel seguente formato
*                                    "<NOME COLONNA1>:<DESCRIZIONE COLONNA1>;<NOME COLONNA2>:<DESCRIZIONE COLONNA2>;....". 
*                                    Se si specifica questo parametro verranno riportate in griglia solo le colonne mappate 
*                                    e la colonna SELEZIONE (sempre presente)
* 4) <altezza griglia>             : specifica l'altezza in pixel della griglia (default 500)
* 5) <larghezza griglia>           : specifica la larghezza in pixel della griglia (default 700)
* 6) <selezione rapida attivata>   : è un flag di tipo boolean che indica se la selezione rapida (tasti seleziona da/a, 
*                                    seleziona tutto...) deve essere attivata. Se il flag non viene impostato la 
*                                    BROWSEVIEW assume come valore di default .T. e attiva i tasti di selezione rapida
*                                 
* 7) <selezione univoca attivata>   : DA COMMENTARE
*
* 8) <abilita ordinameto campi>     : DA COMMENTARE
*
* 9) <commento>                     : DA COMMENTARE
*
*
* Esempio 1: visualizzo tutti i campi con descrizione uguale ai loro nomi
*
* DO prg\browseview WITH "CU_PCK_TT","Seleziona packing list da evadere"
*
* Esempio 2: visualizzo solo due campi TNUMERO e ORD_RAGSOC e li chiamo NUMERO ORDINE e RAGIONE SOCIALE (largo 10 pixel)
*
* DO prg\browseview WITH "CU_PCK_TT","Seleziona packing list da evadere","TNUMERO:numero ordine;ORD_RAGSOC:RAGIONE SOCIALE,W:10;",300,500
*
*
* Esempio 3: visualizzo la stessa query dell'esempio 2 disabilitando i tasti di selezione rapida
*
* DO prg\browseview WITH "CU_PCK_TT","Seleziona packing list da evadere","TNUMERO:numero ordine;ORD_RAGSOC:RAGIONE SOCIALE,W:10;",300,500,.F.
* 
* AUTOMATISMI:
*
* 1) Stabilisce autonomamente la largehzza della colonna in modo da contenere il più grande tra TITOLO DELLA COLONNA
*    e LARGHEZZA DELLA COLONNA
*
* 2) Riconosce i campi data ribalatati (es. 2004/10/10) e ne fa automaticamente il RIBALTA2
*
* 3) Cliccando sulla descrizione di una qualunque delle colonne la griglia viene ordinata per ordine crescente rispetto 
*    a quella colonna. Cliccando una seconda volta sulla colonna l'ordinamento divente decrescente (e così via...)
*
*
* VARIABILI PUBBLICHE RESTITUITE
* 
* NumeroRecordLetti             : indica il numero di record selezionati all'uscita dalla BROWSEVIEW
*
********************************************************************************************************************

PARAMETERS _cursore_out,_descrizioneattivita,_mappa_campi,_altezza,_larghezza,_abilita_selezione_rapida,_selezione_unica,_abilita_ordinamento_campi,_commento


RELEASE _PUB_CURSORE_IN,;
        _PUB_CURSORE_OUT,;
        _PUB_DESCRIZIONE_ATTIVITA,;
        _PUB_MAPPA_CAMPI,;
        _PUB_FORMHEIGHT,;
        _PUB_FORMWIDTH,;
        _PUB_SELEZIONE,;
        _PUB_ABILITA_SELEZIONE_RAPIDA,;
        _PUB_FLAG_SELEZIONE_UNICA,;
        _PUB_DIMENSIONE_CARATTERE_TITOLO,;
        _PUB_ABILITA_ORDINAMENTO_CAMPI,;
        _PUB_ORDINAMENTO,;
        _PUB_COMMENTO,;
        _PUB_COMMENTO_DINAMICO,;
        NumeroRecordLetti
        
PUBLIC  _PUB_CURSORE_IN,;
        _PUB_CURSORE_OUT,;
        _PUB_DESCRIZIONE_ATTIVITA,;
        _PUB_MAPPA_CAMPI,;
        _PUB_FORMHEIGHT,;
        _PUB_FORMWIDTH,;
        _PUB_SELEZIONE,;
        _PUB_ABILITA_SELEZIONE_RAPIDA,;
        _PUB_FLAG_SELEZIONE_UNICA,;
        _PUB_DIMENSIONE_CARATTERE_TITOLO,;
        _PUB_ABILITA_ORDINAMENTO_CAMPI,;
        _PUB_ORDINAMENTO,;
        _PUB_COMMENTO,;
        _PUB_COMMENTO_DINAMICO,;
        NumeroRecordLetti

*** indicatore numero di record selezionati
*** lo rendo publico ma non lo rilascio alla fine perchè deve essere
*** utilizzabile all'esterno della BROWSEVIEW dalla procedura che 
*** ha richiamato la stessa
NumeroRecordLetti  = 0

SET CLASSLIB  TO TESORERIA_CLASSLIB 				ADDITIVE
SET PROCEDURE TO PRG\TESORERIA_LIB.PRG 				ADDITIVE
SET PROCEDURE TO PRG\BROWSEVIEW_ORDINATA_LIB.PRG 	ADDITIVE

n_para = PARAMETERS() 

IF n_para = 0
	MESSAGEBOX("Parametri insufficienti per eseguire BrowseView",16,"*** ERRORE PROGRAMMA ***")
	return
ENDIF 

_PUB_CURSORE_OUT					=	_cursore_out
_PUB_DESCRIZIONE_ATTIVITA			=	_descrizioneattivita
_PUB_SELEZIONE						=	.F.
_PUB_DIMENSIONE_CARATTERE_TITOLO	=	16	&& DIMENSIONE DI DEFAULT DEL CARATTERE DEL TITOLO

_PUB_ORDINAMENTO					= ""

***CONTROLLO SE E' IMPOSTATA LA DIMENSIONE DEL CARATTERE DEL TITOLO
nPosizioneDimensioneCarattereTitolo= AT(":",_PUB_DESCRIZIONE_ATTIVITA)
IF nPosizioneDimensioneCarattereTitolo>0
	_PUB_DESCRIZIONE_ATTIVITA=SUBSTR(_PUB_DESCRIZIONE_ATTIVITA,1,nPosizioneDimensioneCarattereTitolo-1)
	_PUB_DIMENSIONE_CARATTERE_TITOLO=VAL(ALLTRIM(SUBSTR(_PUB_DESCRIZIONE_ATTIVITA,nPosizioneDimensioneCarattereTitolo+1)))
ENDIF

IF n_para >= 3
	_PUB_MAPPA_CAMPI=_mappa_campi
ELSE
	_PUB_MAPPA_CAMPI=""
ENDIF 

IF n_para >= 4
    _PUB_FORMHEIGHT=_altezza
ELSE
    _PUB_FORMHEIGHT=500
ENDIF 

IF n_para >= 5
    _PUB_FORMWIDTH =_larghezza
ELSE
    _PUB_FORMWIDTH =700
ENDIF 

IF n_para >= 6
    _PUB_ABILITA_SELEZIONE_RAPIDA=_abilita_selezione_rapida
ELSE
    _PUB_ABILITA_SELEZIONE_RAPIDA=.T.
ENDIF 

IF n_para >= 7
    _PUB_FLAG_SELEZIONE_UNICA=_selezione_unica
ELSE
    _PUB_FLAG_SELEZIONE_UNICA=.F.
ENDIF 

IF n_para >= 8
    _PUB_ABILITA_ORDINAMENTO_CAMPI=_abilita_ordinamento_campi
ELSE
    _PUB_ABILITA_ORDINAMENTO_CAMPI=.F.
ENDIF 

IF n_para >= 9
    _PUB_COMMENTO=_commento
ELSE
    _PUB_COMMENTO=""
ENDIF 


CREATE CURSOR BRWVORD (CAMPO C(20), HEADER C(120), CAPTORIG C(120), BACKORIG N(10), FOREORIG N(10))

DO FORM form\BROWSEVIEW_ORDINATA LINKED

NumeroRecordLetti=0

SELECT &_cursore_out 

IF TYPE('SELEZIONE')!='U'
	
    _CONTA_RECORD=0
    
	COUNT FOR !EMPTY(SELEZIONE) TO _CONTA_RECORD

	NumeroRecordLetti=_CONTA_RECORD
ENDIF

IF _PUB_FLAG_SELEZIONE_UNICA

	IF NumeroRecordLetti>1
		MESSAGEBOX("Attenzione! Sono state selezionate piu' righe della tabella. L'operazione non e' consentita."+CHR(13)+"Viene considerata valida SOLO LA PRIMA selezione.",48,"Selezione di un unica riga")
		SELECT &_cursore_out 
		REPLACE SELEZIONE WITH SPACE(0) ALL
	ENDIF	

	SELECT &_cursore_out 
	GO TOP
	
	IF NumeroRecordLetti=1
		
		DO WHILE !EOF()
			IF !EMPTY(SELEZIONE)
				EXIT
			ENDIF
			SKIP
		ENDDO
		
	ENDIF	
	
ENDIF


SELECT BRWVORD
USE

RELEASE _PUB_CURSORE_IN,;
        _PUB_CURSORE_OUT,;
        _PUB_DESCRIZIONE_ATTIVITA,;
        _PUB_MAPPA_CAMPI,;
        _PUB_FORMHEIGHT,;
        _PUB_FORMWIDTH,;
        _PUB_SELEZIONE,;
        _PUB_ABILITA_SELEZIONE_RAPIDA,;
        _PUB_FLAG_SELEZIONE_UNICA,;
        _PUB_DIMENSIONE_CARATTERE_TITOLO,;
        _PUB_ABILITA_ORDINAMENTO_CAMPI,;
        _PUB_ORDINAMENTO,;
        _PUB_COMMENTO,;
        _PUB_COMMENTO_DINAMICO,;
        NumeroRecordLetti

