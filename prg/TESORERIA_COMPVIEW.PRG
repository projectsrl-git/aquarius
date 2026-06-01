************************************************************************
* BROWSEVIEWMODIFY
************************************************************************
* Sintassi
* 
* DO prg\browseviewmodify WITH <cursore o tabella>,<titolo>,[<mappatura campi>,<altezza griglia>,<larghezza griglia>,<selezione rapida attivata>]
*
* <cursore o tabella>           : é la tabella/cursore che si vuole visualizzare. DEVE CONTENERE UN CAMPO SELEZIONE C(3)
* <titolo>                      : titolo della griglia
* <mappatura campi>             : indica il titolo che si vuole dare alle colonne della griglia nel seguente formato
*                                 "<NOME COLONNA1>:<DESCRIZIONE COLONNA1>;<NOME COLONNA2>:<DESCRIZIONE COLONNA2>;....". 
*                                 Se si specifica questo parametro verranno riportate in griglia solo le colonne mappate 
*                                 e la colonna SELEZIONE (sempre presente)
* <altezza griglia>             : specifica l'altezza in pixel della griglia (default 500)
* <selezione rapida attivata>   : è un flag di tipo boolean che indica se la selezione rapida (tasti seleziona da/a, 
*                                 seleziona tutto...) deve essere attivata. Se il flag non viene impostato la 
*                                 BROWSEVIEW assume come valore di default .T. e attiva i tasti di selezione rapida
*                                 
*
*
* Esempio 1: visualizzo tutti i campi con descrizione uguale ai loro nomi
*
* DO prg\browseview WITH "CU_PCK_TT","Seleziona packing list da evadere"
*
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

PARAMETERS _cursore_out,_descrizioneattivita,_mappa_campi,_altezza,_larghezza,_abilita_selezione_rapida


RELEASE _PUB_CURSORE_IN,;
        _PUB_CURSORE_OUT,;
        _PUB_DESCRIZIONE_ATTIVITA,;
        _PUB_MAPPA_CAMPI,;
        _PUB_FORMHEIGHT,;
        _PUB_FORMWIDTH,;
        _PUB_SELEZIONE,;
        _PUB_ABILITA_SELEZIONE_RAPIDA,;
        NumeroRecordLetti
        
PUBLIC  _PUB_CURSORE_IN,;
        _PUB_CURSORE_OUT,;
        _PUB_DESCRIZIONE_ATTIVITA,;
        _PUB_MAPPA_CAMPI,;
        _PUB_FORMHEIGHT,;
        _PUB_FORMWIDTH,;
        _PUB_SELEZIONE,;
        _PUB_ABILITA_SELEZIONE_RAPIDA,;
        NumeroRecordLetti

*** indicatore numero di record selezionati
*** lo rendo publico ma non lo rilascio alla fine perchè deve essere
*** utilizzabile all'esterno della BROWSEVIEW dalla procedura che 
*** ha richiamato la stessa
NumeroRecordLetti  = 0

set classlib to tesoreria_classlib ADDITIVE
set procedure to prg\tesoreria_lib.prg ADDITIVE

n_para = PARAMETERS() 

IF n_para = 0
	MESSAGEBOX("Parametri insufficienti per eseguire BrowseView",16,"*** ERRORE PROGRAMMA ***")
	return
ENDIF 

_PUB_CURSORE_OUT=_cursore_out
_PUB_DESCRIZIONE_ATTIVITA=ALLTRIM(_descrizioneattivita)

_PUB_SELEZIONE=.F.

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

DO FORM form\TESORERIA_COMPVIEW LINKED




RELEASE _PUB_CURSORE_IN,;
        _PUB_CURSORE_OUT,;
        _PUB_DESCRIZIONE_ATTIVITA,;
        _PUB_MAPPA_CAMPI,;
        _PUB_FORMHEIGHT,;
        _PUB_FORMWIDTH,;
        _PUB_SELEZIONE,;
        _PUB_ABILITA_SELEZIONE_RAPIDA