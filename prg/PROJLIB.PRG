
*!*	##############################################################################################################

					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE APPLICAZIONI RICERCHE STD                         ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################


*********************************************************************************************
* SEEK_ALL()	funzione per la gestione di tutte le tabella
*********************************************************************************************
* La funzione restituisce TRUE se trova, FALSE se non trova dati nella tabella
* selezionata con una certa chiave.
*
* Descrizione dei parametri:
* 		_nometabella	= è il nome della tabella su cui effettuare la ricerca
*		_chiavericerca	= è la chiave completa di ricerca (pub_codsoc+v_codcli)
*		_campinchiave	= è l'elenco dei campi che formano la chiave (cli_codsoc+cli_codcli)
*					   
* Esempio:
*		seek_all('u_cli_an','pub_codsoc+v_codcli','cli_codsoc+cli_codcli')
*********************************************************************************************
FUNCTION seek_all
PARAMETERS _nometabella,_chiavericerca,_campinchiave
IF PCOUNT() < 2
	=MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
	return(.f.)
ENDIF 

_cursore_ricerca="pj_cur_"+_nometabella

_pjlib_sele=SELECT()

_pj_seek = "select * from "+_nometabella+" where "+_campinchiave+" = '"+_chiavericerca+"'"

IF !ExecCommand(_pj_seek,_cursore_ricerca)
   return(.f.)
ENDIF
	
SELECT &_cursore_ricerca
IF reccount() = 0
   _ret_valore=.f.
ELSE
   _ret_valore=.t.
ENDIF 

SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_STD()	funzione per la gestione di tutte le tabella
*********************************************************************************************
* La funzione restituisce TRUE se trova, FALSE se non trova dati nella tabella
* selezionata con una certa chiave, inoltre restituisce il cursore con il/i record
* che hanno soffisfatto il filtro
*
* Descrizione dei parametri:
* 		_nometabella	= è il nome della tabella su cui effettuare la ricerca
*		_chiavericerca	= è la chiave completa di ricerca (pub_codsoc+v_codcli)
*		_campinchiave	= è l'elenco dei campi che formano la chiave (cli_codsoc+cli_codcli)
*					   
* Esempio:
*		seek_std('u_cli_an','pub_codsoc+v_codcli','cli_codsoc+cli_codcli','CUR_U_CLI_AN)
*********************************************************************************************
FUNCTION seek_std

LPARAMETERS _nometabella,_chiavericerca,_campinchiave,_nomecursore

IF PCOUNT() < 2
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return(.f.)
ENDIF 

IF EMPTY(_nomecursore)
   _cursore_ricerca="pj_cur_"+_nometabella
ELSE
   _cursore_ricerca=_nomecursore
ENDIF

_pjlib_sele=SELECT()

_pj_seek = "select * from "+_nometabella+" where "+_campinchiave+" = '"+_chiavericerca+"'"

IF !ExecCommand(_pj_seek,_cursore_ricerca)
   return(.f.)
ENDIF
	
SELECT &_cursore_ricerca
IF reccount() = 0
   _ret_valore=.f.
ELSE
   _ret_valore=.t.
ENDIF 
	
SELECT(_pjlib_sele)

return(_ret_valore)

*********************************************************************************************
* SEEK_PARA()	funzione per la gestione della tabella PARA
*********************************************************************************************
* La funzione restituisce dalla tabella PARA, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_para

*PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_FASCIACOMPETENZA,_contenuto_in_libera,_anche_parametri_disattivi,_data_rif_validita
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_FASCIACOMPETENZA,_contenuto_in_libera,_anche_parametri_disattivi,_data_rif_validita,_par_cond_aggiuntiva  && ERASMO - 23/02/2024

LOCAL _seek , _seek1 ,_seek_all,_pjlib_sele,_ret_valore

IF PCOUNT() < 5
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF

IF PCOUNT() <= 6
	_FASCIACOMPETENZA = "ALL"
ENDIF

IF PCOUNT() <= 7
	_contenuto_in_libera = ""
ENDIF

*!*	**=> ERASMO - INIZIO 30/10/2014
*!*	*** MODIFICA PER LA VISUALIZZAZIONE DEI SOLI PARAMETRI NON CONTRASSEGNATI COME "DISATTIVO"
*!*	LOCAL _solo_parametri_attivi
*!*	_solo_parametri_attivi = .T.
*!*	**=> ERASMO - FINE 30/10/2014

**=> ERASMO - INIZIO 08/07/2015
*** MODIFICA PER LA VISUALIZZAZIONE DEI SOLI PARAMETRI NON CONTRASSEGNATI COME "DISATTIVO", PARAMETRO PASSATO E GESTITO IN FORM "ELENCO"
IF PCOUNT() <= 8
	_anche_parametri_disattivi = .F.
ENDIF

*** MODIFICA PER LA VISUALIZZAZIONE DEI SOLI PARAMETRI CHE ABBIANO DELLE DATE DI VALIDITA' DAL/AL CHE COMPRENDA LA DATA DI RIFERIMENTO PASSATA
IF PCOUNT() <= 9
	_data_rif_validita = ""
ELSE
	IF SUBSTR(_data_rif_validita,3,1) = "/"
		_data_rif_validita = RIBALTA2(_data_rif_validita)
	ENDIF
ENDIF
**=> ERASMO - FINE 08/07/2015

**=> ERASMO - INIZIO 23/02/2024
IF PCOUNT() <= 10
	_par_cond_aggiuntiva = ""
ENDIF
**=> ERASMO - FINE 23/02/2024

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_para"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_tiporec+_chiave+"'"
_seek1= "'"+_tiporec+ALLTRIM(_chiave)+"%'"
_seek_all = "'"+_tiporec+"%'"


IF _FASCIACOMPETENZA = 'ALL' OR EMPTY(_FASCIACOMPETENZA)  && ERASMO - 17/04/2014
ELSE
   _seek = _SEEK + " AND '" + ALLTRIM(_FASCIACOMPETENZA) + "' LIKE ('%' + SUBSTRING(LIBERA,42,1) + '%')"
   _seek1 = _SEEK1 + " AND '" + ALLTRIM(_FASCIACOMPETENZA) + "' LIKE ('%' + SUBSTRING(LIBERA,42,1) + '%')"
   _seek_all = _seek_all + " AND '" + ALLTRIM(_FASCIACOMPETENZA) + "' LIKE ('%' + SUBSTRING(LIBERA,42,1) + '%')"
ENDIF 

IF EMPTY(_contenuto_in_libera)
ELSE
*!*		_seek = _SEEK + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
*!*		_seek1 = _SEEK1 + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
*!*		_seek_all = _seek_all + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
	**=> ERASMO - INIZIO 22/10/2015
	DO CASE
		CASE _tiporec = 'TPO'  && SE PARAMETRO 'TIPOLOGIA DOCUMENTO', IL CAMPO LIBERA VUOTO SIGNIFICA COMPATIBILE CON TUTTE LE CAUSALI
			_seek = _SEEK + " AND (LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%' OR LIBERA = '')"
			_seek1 = _SEEK1 + " AND (LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%' OR LIBERA = '')"
			_seek_all = _seek_all + " AND (LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%' OR LIBERA = '')"

		OTHERWISE
			_seek = _SEEK + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
			_seek1 = _SEEK1 + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
			_seek_all = _seek_all + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
	ENDCASE
	**=> ERASMO - FINE 22/10/2015
ENDIF

*!*	**=> ERASMO - INIZIO 30/10/2014
*!*	IF _solo_parametri_attivi
*!*	   _seek = _SEEK + " AND DISATTIVO = 0"
*!*	   _seek1 = _SEEK1 + " AND DISATTIVO = 0"
*!*	   _seek_all = _seek_all + " AND DISATTIVO = 0"
*!*	ENDIF
*!*	**=> ERASMO - FINE 30/10/2014

**=> ERASMO - INIZIO 08/07/2015
IF !EMPTY(_data_rif_validita)
	_date = "(PAR_VALIDDAL = '' OR '" + _data_rif_validita + "' >= PAR_VALIDDAL) AND (PAR_VALIDAL = '' OR '" + _data_rif_validita + "' <= PAR_VALIDAL)"
	_seek = _seek + " AND " + _date
	_seek1 = _seek1 + " AND " + _date
	_seek_all = _seek_all + " AND " + _date
ENDIF
**=> ERASMO - FINE 08/07/2015

**=> ERASMO - INIZIO 23/02/2024
IF !EMPTY(_par_cond_aggiuntiva)
	_seek = _seek + " AND " + _par_cond_aggiuntiva
	_seek1 = _seek1 + " AND " + _par_cond_aggiuntiva
	_seek_all = _seek_all + " AND " + _par_cond_aggiuntiva
ENDIF
**=> ERASMO - FINE 23/02/2024

cSql 	= "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4, ITALIANO, DESIVA FROM para where codice = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4, ITALIANO, DESIVA FROM para where codice like "+_seek1+" order by "+_ordinamento
cSql_all= "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4, ITALIANO, DESIVA FROM para where codice like "+_seek_all+" order by "+_ordinamento  && ERASMO - 24/01/2014

IF ALLTRIM(_chiave) == "?"
	cSql_1 = cSql_all
ENDIF

IF !ExecCommand(Csql_1,"xxx_para")
   return(.f.)
ENDIF
SELECT xxx_para
GO TOP

IF EOF()
   _seek1 = "codice like '" + _tiporec + "%'"
   *_seek2 = "descri like '" + ALLTRIM(_chiave) + "%'"
   _seek2 = "RTRIM(descri) like '" + ALLTRIM(_chiave) + "%'"  && ERASMO/SERGIO 15/09/2017
   **=> ERASMO - INIZIO 09/10/2015
   IF PUB_RICPARDES  && RICERCA PER STRINGA CONTENUTA COME DA PARAMETRO AZIENDALE
      *_seek2 = "descri like '%" + ALLTRIM(_chiave) + "%'"
      _seek2 = "RTRIM(descri) like '%" + ALLTRIM(_chiave) + "%'"  && ERASMO/SERGIO 15/09/2017
   ENDIF
   **=> ERASMO - FINE 09/10/2015
   IF _FASCIACOMPETENZA = 'ALL' OR EMPTY(_FASCIACOMPETENZA)   
      _seek4 = _seek1 + " and " + _seek2
   ELSE
      *_seek3 = "SUBSTRING(LIBERA,42,1) = '" + ALLTRIM(_FASCIACOMPETENZA) + "'"
      _seek3 = "'" + ALLTRIM(_FASCIACOMPETENZA) + "' LIKE ('%' + SUBSTRING(LIBERA,42,1) + '%')"  && ERASMO - 12/02/2024
      _seek4 = _seek1 + " and " + _seek2 + " and " + _seek3
   ENDIF
	IF EMPTY(_contenuto_in_libera)
	ELSE
	   *_seek4 = _seek4 + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
		**=> ERASMO - INIZIO 22/10/2015
		DO CASE
			CASE _tiporec = 'TPO'  && SE PARAMETRO 'TIPOLOGIA DOCUMENTO', IL CAMPO LIBERA VUOTO SIGNIFICA COMPATIBILE CON TUTTE LE CAUSALI
				_seek4 = _seek4 + " AND (LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%' OR LIBERA = '')"

			OTHERWISE
				_seek4 = _seek4 + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
		ENDCASE
		**=> ERASMO - FINE 22/10/2015
	ENDIF
*!*		**=> ERASMO - INIZIO 30/10/2014
*!*		IF _solo_parametri_attivi
*!*		   _seek4 = _seek4 + " AND DISATTIVO = 0"
*!*		ENDIF
*!*		**=> ERASMO - FINE 30/10/2014
	**=> ERASMO - INIZIO 08/07/2015
	IF !EMPTY(_data_rif_validita)
		_date = "(PAR_VALIDDAL = '' OR '" + _data_rif_validita + "' >= PAR_VALIDDAL) AND (PAR_VALIDAL = '' OR '" + _data_rif_validita + "' <= PAR_VALIDAL)"
		_seek4 = _seek4 + " AND " + _date
	ENDIF
	**=> ERASMO - FINE 08/07/2015
	**=> ERASMO - INIZIO 23/02/2024
	IF !EMPTY(_par_cond_aggiuntiva)
		_seek4 = _seek4 + " AND " + _par_cond_aggiuntiva
	ENDIF
	**=> ERASMO - FINE 23/02/2024
   cSql_1 = "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4, ITALIANO, DESIVA FROM para where " + _seek4 + " order by "+_ordinamento
ENDIF

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione;Libera"
PUB_VISTA  = "CODICE;DESCRI;LIBERA"
PUB_RIT    = _ritorno

*!*	IF SUBSTR(_nomecursore,1,5) = 'ECASH'
*!*	   DO Form FORM\elenco_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri ecash"
*!*	ELSE
*!*	   DO Form FORM\elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri"
*!*	ENDIF
**=> ERASMO - INIZIO 08/07/2015
*** PASSO PARAMETRO IN FORM "ELENCO" PER LA GESTIONE DELLA VISUALIZZAZIONE DEI PARAMETRI DISATTIVATI
IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\elenco_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri ecash","",_anche_parametri_disattivi
ELSE
   DO Form FORM\elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri","",_anche_parametri_disattivi
ENDIF
**=> ERASMO - FINE 08/07/2015

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)




*********************************************************************************************
* SEEK_PARA()	funzione per la gestione della tabella PARA
*********************************************************************************************
* La funzione restituisce dalla tabella PARA, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_para_descri

PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_fasciacompetenza,_contenuto_in_libera,_contenuto_in_descri,_anche_parametri_disattivi,_data_rif_validita

LOCAL _seek , _seek1 ,_seek_all,_pjlib_sele,_ret_valore


IF PCOUNT() < 5
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF

IF PCOUNT() <= 6
	_FASCIACOMPETENZA = "ALL"
ENDIF

IF PCOUNT() <= 7
	_contenuto_in_libera = ""
ENDIF

**SERGIO 2015/02/21 RICERCA PER CONTENUTO IN DESCIZIONE
IF PCOUNT() <= 8
	_contenuto_in_descri = ""
ENDIF
**SERGIO 2015/02/21 RICERCA PER CONTENUTO IN DESCIZIONE

*!*	**=> ERASMO - INIZIO 30/10/2014
*!*	*** MODIFICA PER LA VISUALIZZAZIONE DEI SOLI PARAMETRI NON CONTRASSEGNATI COME "DISATTIVO"
*!*	LOCAL _solo_parametri_attivi
*!*	_solo_parametri_attivi = .T.
*!*	**=> ERASMO - FINE 30/10/2014

**=> ERASMO - INIZIO 08/07/2015
*** MODIFICA PER LA VISUALIZZAZIONE DEI SOLI PARAMETRI NON CONTRASSEGNATI COME "DISATTIVO", PARAMETRO PASSATO E GESTITO IN FORM "ELENCO"
IF PCOUNT() <= 9
	_anche_parametri_disattivi = .F.
ENDIF

*** MODIFICA PER LA VISUALIZZAZIONE DEI SOLI PARAMETRI CHE ABBIANO DELLE DATE DI VALIDITA' DAL/AL CHE COMPRENDA LA DATA DI RIFERIMENTO PASSATA
IF PCOUNT() <= 10
	_data_rif_validita = ""
ELSE
	IF SUBSTR(_data_rif_validita,3,1) = "/"
		_data_rif_validita = RIBALTA2(_data_rif_validita)
	ENDIF
ENDIF
**=> ERASMO - FINE 08/07/2015

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_para"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_tiporec+_chiave+"'"
_seek1= "'"+_tiporec+ALLTRIM(_chiave)+"%'"
_seek_all = "'"+_tiporec+"%'"   


IF _FASCIACOMPETENZA = 'ALL' OR EMPTY(_FASCIACOMPETENZA)  && ERASMO - 17/04/2014
ELSE
   _seek = _SEEK + " AND '" + ALLTRIM(_FASCIACOMPETENZA) + "' LIKE ('%' + SUBSTRING(LIBERA,42,1) + '%')"
   _seek1 = _SEEK1 + " AND '" + ALLTRIM(_FASCIACOMPETENZA) + "' LIKE ('%' + SUBSTRING(LIBERA,42,1) + '%')"
   _seek_all = _seek_all + " AND '" + ALLTRIM(_FASCIACOMPETENZA) + "' LIKE ('%' + SUBSTRING(LIBERA,42,1) + '%')"
ENDIF 

IF EMPTY(_contenuto_in_libera)
ELSE
   _seek = _SEEK + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
   _seek1 = _SEEK1 + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
   _seek_all = _seek_all + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
ENDIF

**SERGIO 2015/02/21 RICERCA PER CONTENUTO IN DESCRIZIONE
IF EMPTY(_contenuto_in_descri)
ELSE
*!*	   _seek = _SEEK + " AND DESCRI LIKE '%" + ALLTRIM(_contenuto_in_descri) + "%'"
*!*	   _seek1 = _SEEK1 + " AND DESCRI LIKE '%" + ALLTRIM(_contenuto_in_descri) + "%'"
*!*	   _seek_all = _seek_all + " AND DESCRI LIKE '%" + ALLTRIM(_contenuto_in_descri) + "%'"
   **=> ERASMO/SERGIO - INIZIO 15/09/2017
   _seek = _SEEK + " AND RTRIM(DESCRI) LIKE '%" + ALLTRIM(_contenuto_in_descri) + "%'"
   _seek1 = _SEEK1 + " AND RTRIM(DESCRI) LIKE '%" + ALLTRIM(_contenuto_in_descri) + "%'"
   _seek_all = _seek_all + " AND RTRIM(DESCRI) LIKE '%" + ALLTRIM(_contenuto_in_descri) + "%'"
   **=> ERASMO/SERGIO - FINE 15/09/2017
ENDIF
**SERGIO 2015/02/21 RICERCA PER CONTENUTO IN DESCIZIONE

*!*	**=> ERASMO - INIZIO 30/10/2014
*!*	IF _solo_parametri_attivi
*!*	   _seek = _SEEK + " AND DISATTIVO = 0"
*!*	   _seek1 = _SEEK1 + " AND DISATTIVO = 0"
*!*	   _seek_all = _seek_all + " AND DISATTIVO = 0"
*!*	ENDIF
*!*	**=> ERASMO - FINE 30/10/2014

**=> ERASMO - INIZIO 08/07/2015
IF !EMPTY(_data_rif_validita)
	_date = "(PAR_VALIDDAL = '' OR '" + _data_rif_validita + "' >= PAR_VALIDDAL) AND (PAR_VALIDAL = '' OR '" + _data_rif_validita + "' <= PAR_VALIDAL)"
	_seek = _seek + " AND " + _date
	_seek1 = _seek1 + " AND " + _date
	_seek_all = _seek_all + " AND " + _date
ENDIF
**=> ERASMO - FINE 08/07/2015

cSql 	= "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4, ITALIANO, DESIVA FROM para where codice = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4, ITALIANO, DESIVA FROM para where codice like "+_seek1+" order by "+_ordinamento
cSql_all= "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4, ITALIANO, DESIVA FROM para where codice like "+_seek_all+" order by "+_ordinamento  && ERASMO - 24/01/2014

cSql_1 = cSql_all	&& 2015/02/21 SERGIO ACCESSO PER CODICE PARAMETRO PIU' CONTENUTO IN DESCRI

IF !ExecCommand(Csql_1,"xxx_para")
   return(.f.)
ENDIF
SELECT xxx_para
GO TOP

IF EOF()
   _seek1 = "codice like '" + _tiporec + "%'"
   *_seek2 = "descri like '" + ALLTRIM(_chiave) + "%'"
   _seek2 = "RTRIM(descri) like '" + ALLTRIM(_chiave) + "%'"  && ERASMO/SERGIO 15/09/2017
   IF _FASCIACOMPETENZA = 'ALL' OR EMPTY(_FASCIACOMPETENZA)   
      _seek4 = _seek1 + " and " + _seek2
   ELSE
      _seek3 = "SUBSTRING(LIBERA,42,1) = '" + ALLTRIM(_FASCIACOMPETENZA) + "'"
      _seek4 = _seek1 + " and " + _seek2 + " and " + _seek3
   ENDIF
	IF EMPTY(_contenuto_in_libera)
	ELSE
	   _seek4 = _seek4 + " AND LIBERA LIKE '%" + ALLTRIM(_contenuto_in_libera) + "%'"
	ENDIF
*!*		**=> ERASMO - INIZIO 30/10/2014
*!*		IF _solo_parametri_attivi
*!*		   _seek4 = _seek4 + " AND DISATTIVO = 0"
*!*		ENDIF
*!*		**=> ERASMO - FINE 30/10/2014
	**=> ERASMO - INIZIO 08/07/2015
	IF !EMPTY(_data_rif_validita)
		_date = "(PAR_VALIDDAL = '' OR '" + _data_rif_validita + "' >= PAR_VALIDDAL) AND (PAR_VALIDAL = '' OR '" + _data_rif_validita + "' <= PAR_VALIDAL)"
		_seek4 = _seek4 + " AND " + _date
	ENDIF
	**=> ERASMO - FINE 08/07/2015
   cSql_1 = "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4, ITALIANO, DESIVA FROM para where " + _seek4 + " order by "+_ordinamento
ENDIF

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione;Libera"
PUB_VISTA  = "CODICE;DESCRI;LIBERA"
PUB_RIT    = _ritorno

*!*	IF SUBSTR(_nomecursore,1,5) = 'ECASH'
*!*	   DO Form FORM\elenco_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri ecash"
*!*	ELSE
*!*	   DO Form FORM\elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri"
*!*	ENDIF

**=> ERASMO - INIZIO 08/07/2015
*** PASSO PARAMETRO IN FORM "ELENCO" PER LA GESTIONE DELLA VISUALIZZAZIONE DEI PARAMETRI DISATTIVATI
IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\elenco_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri ecash","",_anche_parametri_disattivi
ELSE
   DO Form FORM\elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri","",_anche_parametri_disattivi
ENDIF
**=> ERASMO - FINE 08/07/2015

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_PARA1()	funzione per la gestione della tabella PARA
*********************************************************************************************
* La funzione restituisce dalla tabella PARA, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec			= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave				= è il valore ricercato
* 		_ritorno			= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento		= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza			= è la posizione del valore ricercato all'interno del campo codice
*							  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					 		  posizione 4 per 3 caratteri)
*		_nomecursore   		= è il nome del cursore che si vuole utilizzare
*		_fasciacompetenza	= è il valore ricercato all'interno della stringa del campo libera
*							  nella posizione 42
*		_tipocausale 		= è il valore ricercato all'interno della stringa del campo libera
*							  nella posizione 1
*					   
*********************************************************************************************
FUNCTION seek_para1
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_fasciacompetenza,_tipocausale
IF PCOUNT() < 5
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF PCOUNT() <= 6 .OR. EMPTY(_FASCIACOMPETENZA)
	_FASCIACOMPETENZA = "ALL"
ENDIF

IF PCOUNT() <= 7 .OR. EMPTY(_TIPOCAUSALE)
	_TIPOCAUSALE = "ALL"
ENDIF

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_para"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_tiporec+_chiave+"'"
_seek1= "'"+_tiporec+ALLTRIM(_chiave)+"%'"

IF _FASCIACOMPETENZA = 'ALL'
ELSE
   _seek  = _SEEK  + " AND SUBSTRING(LIBERA,42,1) = '" + ALLTRIM(_FASCIACOMPETENZA) + "'"
   _seek1 = _SEEK1 + " AND SUBSTRING(LIBERA,42,1) = '" + ALLTRIM(_FASCIACOMPETENZA) + "'"
ENDIF

IF _TIPOCAUSALE = 'ALL'
ELSE
   _seek  = _SEEK  + " AND SUBSTRING(LIBERA,1,1) = '" + ALLTRIM(_TIPOCAUSALE) + "'"
   _seek1 = _SEEK1 + " AND SUBSTRING(LIBERA,1,1) = '" + ALLTRIM(_TIPOCAUSALE) + "'"
ENDIF

cSql 	= "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4 FROM para where codice = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4 FROM para where codice like "+_seek1+" order by "+_ordinamento

IF !ExecCommand(Csql_1,"xxx_para")
   return(.f.)
ENDIF
SELECT XXX_PARA
GO TOP


IF EOF()
   _seek1 = "codice like '" + _tiporec + "%'"
   *_seek2 = "descri like '" + ALLTRIM(_chiave) + "%'"
   _seek2 = "RTRIM(descri) like '" + ALLTRIM(_chiave) + "%'"  && ERASMO/SERGIO 15/09/2017
   IF _FASCIACOMPETENZA = 'ALL'
      _seek4 = _seek1 + " and " + _seek2
   ELSE
      _seek3 = "SUBSTRING(LIBERA,42,1) = '" + ALLTRIM(_FASCIACOMPETENZA) + "'"
      _seek4 = _seek1 + " and " + _seek2 + " and " + _seek3
   ENDIF
   IF _TIPOCAUSALE = 'ALL'
      _seek4 = _seek1 + " and " + _seek2
   ELSE
      _seek3 = "SUBSTRING(LIBERA,1,1) = '" + ALLTRIM(_TIPOCAUSALE) + "'"
      _seek4 = _seek1 + " and " + _seek2 + " and " + _seek3
   ENDIF      
   cSql_1 = "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4 FROM para where " + _seek4 + " order by "+_ordinamento
ENDIF

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione;Libera"
PUB_VISTA  = "CODICE;DESCRI;LIBERA"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\elenco_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri ecash"
ELSE
   DO Form FORM\elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri"
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_U_CLI_AN()	funzione per la gestione della tabella U_CLI_AN
*********************************************************************************************
* La funzione restituisce dalla tabella U_CLI_AN, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_cli_an
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_includi_obsoleti,_includi_for_clicee
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_cli_an"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

IF SUBSTR(_chiave,1,2)=PUB_CODSOC
	_chiave= SUBSTR(_chiave,3)
ENDIF

*!*	_seek = "'"+_chiave+"'" + " and CLI_OBSOL <> 'S'"
*!*	*_seek1= "'%"+_chiave+"%'" + " and CLI_OBSOL <> 'S'"
*!*	**=> ERASMO - INIZIO 11/02/2015
*!*	IF PUB_RICCLIDES  && RICERCA PER STRINGA CONTENUTA COME DA PARAMETRO AZIENDALE
*!*		_seek1= "'%"+_chiave+"%'" + " and CLI_OBSOL <> 'S'"
*!*	ELSE
*!*		_seek1= "'"+_chiave+"%'" + " and CLI_OBSOL <> 'S'"
*!*	ENDIF
*!*	**=> ERASMO - FINE 11/02/2015

**=> ERASMO - INIZIO 08/07/2015
IF PCOUNT() >= 7
ELSE
	_includi_obsoleti = .F.
ENDIF

_seek = "'"+_chiave+"'"
IF PUB_RICCLIDES  && RICERCA PER STRINGA CONTENUTA COME DA PARAMETRO AZIENDALE
	_seek1= "'%"+_chiave+"%'"
ELSE
	_seek1= "'"+_chiave+"%'"
ENDIF
IF !_includi_obsoleti
	_seek  = _seek  + " and CLI_OBSOL <> 'S'"
	_seek1 = _seek1 + " and CLI_OBSOL <> 'S'"
ENDIF
**=> ERASMO - FINE 08/07/2015

**=> ERASMO - INIZIO 09/10/2015
IF PCOUNT() >= 8
ELSE
	_includi_for_clicee = .F.
ENDIF
*IF !_includi_for_clicee  && ESCLUDE I CLIENTI PRESENTI IN U_FOR_AN.FOR_CLICEE
IF !_includi_for_clicee AND PUB_NOCLICEE  && ERASMO - 18/11/2015 - ESCLUDE I CLIENTI PRESENTI IN U_FOR_AN.FOR_CLICEE (SE PARAMETRO AZIENDALE ATTIVATO)
	_seek  = _seek  + " and CLI_CODCLI NOT IN (SELECT FOR_CLICEE FROM U_FOR_AN WHERE FOR_CLICEE<>'')"
	_seek1 = _seek1 + " and CLI_CODCLI NOT IN (SELECT FOR_CLICEE FROM U_FOR_AN WHERE FOR_CLICEE<>'')"
ENDIF
**=> ERASMO - FINE 09/10/2015

*!*	**=> ERASMO - INIZIO 08/12/2017
*!*	*** GESTIONE OPERATORE/AGENTE: PUO' VISUALIZZARE ESCLUSIVAMENTE I SUOI CLIENTI
*!*	IF !EMPTY(PUB_AGEOPE)
*!*		_seek  = _seek  + " and CLI_AGE = '" + PUB_AGEOPE + "'"
*!*		_seek1 = _seek1 + " and CLI_AGE = '" + PUB_AGEOPE + "'"
*!*	ENDIF
*!*	**=> ERASMO - FINE 08/12/2017
**=> ERASMO - INIZIO 20/10/2023
*** GESTIONE OPERATORE/AGENTE/CAPO-AREA: SE CONFIGURATO, PUO' VISUALIZZARE I CLIENTI CHE HANNO COME CODICE AGENTE IL SUO CAPO-AREA
IF !EMPTY(PUB_AGEOPE_PARENT)
	_seek  = _seek  + " and CLI_AGE LIKE '" + PUB_AGEOPE_PARENT + "%'"
	_seek1 = _seek1 + " and CLI_AGE LIKE '" + PUB_AGEOPE_PARENT + "%'"
ELSE
	*** GESTIONE OPERATORE/AGENTE: PUO' VISUALIZZARE ESCLUSIVAMENTE I SUOI CLIENTI
	IF !EMPTY(PUB_AGEOPE)
		_seek  = _seek  + " and CLI_AGE = '" + PUB_AGEOPE + "'"
		_seek1 = _seek1 + " and CLI_AGE = '" + PUB_AGEOPE + "'"
	ENDIF
ENDIF
**=> ERASMO - FINE 20/10/2023

cSql 	= "SELECT * FROM u_cli_an where cli_codcli = "+_seek+" order by "+_ordinamento 
*cSql_1 	= "SELECT * FROM u_cli_an where cli_ragsoc like "+_seek1+" or cli_pariva like "+_seek1+" order by "+_ordinamento
cSql_1 	= "SELECT * FROM u_cli_an where RTRIM(cli_ragsoc) like "+_seek1+" or cli_pariva like "+_seek1+" order by "+_ordinamento  && ERASMO/SERGIO - 15/09/2017
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Ragione sociale;Parita IVA"
PUB_VISTA  = "cli_codcli;cli_ragsoc;cli_pariva"
PUB_RIT    = _ritorno
___dimensioni= "120;510;120"

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\ELENCO_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco clienti ecash"
ELSE
   DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco clienti",___dimensioni
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_u_for_an()	funzione per la gestione della tabella u_for_an
*********************************************************************************************
* La funzione restituisce dalla tabella u_for_an, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_for_an
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_includi_obsoleti
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_for_an"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()


IF SUBSTR(_chiave,1,2)=PUB_CODSOC
	_chiave= SUBSTR(_chiave,3)
ENDIF

*!*	_seek = "'"+_chiave+"'" + " and FOR_OBSOL <> 'S'"
*!*	*_seek1= "'%"+_chiave+"%'" + " and FOR_OBSOL <> 'S'"
*!*	**=> ERASMO - INIZIO 11/02/2015
*!*	IF PUB_RICFORDES  && RICERCA PER STRINGA CONTENUTA COME DA PARAMETRO AZIENDALE
*!*		_seek1= "'%"+_chiave+"%'" + " and FOR_OBSOL <> 'S'"
*!*	ELSE
*!*		_seek1= "'"+_chiave+"%'" + " and FOR_OBSOL <> 'S'"
*!*	ENDIF
*!*	**=> ERASMO - FINE 11/02/2015

**=> ERASMO - INIZIO 08/07/2015
IF PCOUNT() >= 7
ELSE
	_includi_obsoleti = .F.
ENDIF

_seek = "'"+_chiave+"'"
IF PUB_RICFORDES  && RICERCA PER STRINGA CONTENUTA COME DA PARAMETRO AZIENDALE
	_seek1= "'%"+_chiave+"%'"
ELSE
	_seek1= "'"+_chiave+"%'"
ENDIF
IF !_includi_obsoleti
	_seek  = _seek  + " and FOR_OBSOL <> 'S'"
	_seek1 = _seek1 + " and FOR_OBSOL <> 'S'"
ENDIF
**=> ERASMO - FINE 08/07/2015

cSql 	= "SELECT * FROM u_for_an where for_codcli = "+_seek+" order by "+_ordinamento 
*cSql_1 	= "SELECT * FROM u_for_an where for_ragsoc like "+_seek1+" or for_pariva like "+_seek1+" order by "+_ordinamento
cSql_1 	= "SELECT * FROM u_for_an where RTRIM(for_ragsoc) like "+_seek1+" or for_pariva like "+_seek1+" order by "+_ordinamento  && ERASMO/SERGIO - 15/09/2017
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Ragione sociale;Parita IVA"
PUB_VISTA  = "for_codcli;for_ragsoc;for_pariva"
___dimensioni= "120;510;120"

PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco fornitori",___dimensioni

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_CONTI()	funzione per la gestione della tabella CONTI
*********************************************************************************************
* La funzione restituisce dalla tabella CONTI, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*		_nomecursore= nome del cursore creato per i dati della query
*  		_clifor		= se .T. cerca solo conti cliente/fornitore
*					   
*********************************************************************************************
FUNCTION seek_conti
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_clifor

LOCAL CSQL_JOIN,_seek,_seek1,_pjlib_sele,cSql,cSql_1,V_WHERE_CONDITION_CLIFOR

IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

V_WHERE_CONDITION_CLIFOR= ""

*!*	IF PCOUNT() = 7
*!*		IF _clifor
*!*			V_WHERE_CONDITION_CLIFOR= " AND CON_TIPOCO IN ('C','F') "
*!*		ENDIF
*!*	ENDIF 
**=> ERASMO - INIZIO 27/09/2022
IF PCOUNT() >= 7
	IF TYPE("_clifor") == 'L'
		V_WHERE_CONDITION_CLIFOR= " AND CON_TIPOCO IN ('C','F') "
	ELSE
		IF TYPE("_clifor") == 'C'
			V_WHERE_CONDITION_CLIFOR= " AND CON_TIPOCO = '" + ALLTRIM(_clifor) + "'"
		ENDIF
	ENDIF
ENDIF 
**=> ERASMO - FINE 27/09/2022

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_CONTI"
ENDIF

*_chiave = APITOSPA(_chiave)
_chiave = STRTRAN(_chiave,"'","")

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+ALLTRIM(SUBSTR(_chiave,7))+"'"
IF PUB_RICCONTDES
	_seek1= "'%"+ALLTRIM(SUBSTR(_chiave,7))+"%'"
ELSE
	_seek1= "'"+ALLTRIM(SUBSTR(_chiave,7))+"%'"
ENDIF

CSQL_JOIN="SELECT COALESCE(CLI.CLI_PARIVA,FFO.FOR_PARIVA,'') AS PARIVA,COALESCE(CLI.CLI_AGE,''),CON.* "+;
	" FROM CONTI AS CON "+;
	" LEFT OUTER JOIN (SELECT CLI_CODCLI,CLI_PARIVA,CLI_AGE FROM U_CLI_AN) AS CLI ON CON.CON_CONTO  LIKE '%'+RTRIM(CLI.CLI_CODCLI) AND CON.CON_TIPOCO='C' "+;
	" LEFT OUTER JOIN (SELECT FOR_CODCLI,FOR_PARIVA FROM U_FOR_AN) AS FFO ON CON.CON_CONTO LIKE '%'+RTRIM(FFO.FOR_CODCLI) AND CON.CON_TIPOCO='F' "

cSql     = CSQL_JOIN+;
			"where con_soc = '"+pub_codsoc+"' and con_anno = '"+pub_anno+"' "+V_WHERE_CONDITION_CLIFOR+" AND LEN(CON_CONTO)>"+ALLTRIM(STR(PUB_SOTTOG))+" and "+_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1   = CSQL_JOIN+;
			"where con_soc = '"+pub_codsoc+"' and con_anno = '"+pub_anno+"' "+V_WHERE_CONDITION_CLIFOR+" AND LEN(CON_CONTO)>"+ALLTRIM(STR(PUB_SOTTOG))+" and ( "+_ordinamento+" like "+_seek1+" ) order by "+_ordinamento
**=> ERASMO/SERGIO - INIZIO 09/02/2023
IF PUB_CONTOSIMILCEE
	cSql     = CSQL_JOIN+;
				"where con_soc = '"+pub_codsoc+"' and con_anno = '"+pub_anno+"' "+V_WHERE_CONDITION_CLIFOR+" AND CON_PADRE = 0 and "+_ordinamento+" = "+_seek+" order by "+_ordinamento 
	cSql_1   = CSQL_JOIN+;
				"where con_soc = '"+pub_codsoc+"' and con_anno = '"+pub_anno+"' "+V_WHERE_CONDITION_CLIFOR+" AND CON_PADRE = 0 and ( "+_ordinamento+" like "+_seek1+" ) order by "+_ordinamento
	**=> ERASMO - INIZIO 18/05/2026
	IF UPPER(_ordinamento) = "CON_CONTO"
		cSql = STRTRAN(cSql," order by "+_ordinamento," order by CAST(REPLACE('/' + REPLACE(RTRIM(CON_CONTO), '.', '/') + '/', '//', '/') AS HIERARCHYID)")
		cSql_1 = STRTRAN(cSql_1," order by "+_ordinamento," order by CAST(REPLACE('/' + REPLACE(RTRIM(CON_CONTO), '.', '/') + '/', '//', '/') AS HIERARCHYID)")
	ENDIF
	**=> ERASMO - FINE 18/05/2026
ENDIF
**=> ERASMO/SERGIO - FINE 09/02/2023

			
**2015/07/27 SERGIO INIZIO
IF PUB_RICCONTDES2
	_ordinamento = "CON_DESCR"
	cSql_1   = CSQL_JOIN+;
				"where con_soc = '"+pub_codsoc+"' and con_anno = '"+pub_anno+"' "+V_WHERE_CONDITION_CLIFOR+" AND LEN(CON_CONTO)>"+ALLTRIM(STR(PUB_SOTTOG))+" and ( "+_ordinamento+" like "+_seek1+" ) order by "+_ordinamento
ENDIF
**2015/07/27 SERGIO FINE

**=> ERASMO - INIZIO 08/12/2017
*** GESTIONE OPERATORE/AGENTE: PUO' VISUALIZZARE ESCLUSIVAMENTE I SUOI CLIENTI
IF !EMPTY(PUB_AGEOPE)
	cSql = STRTRAN(cSql,"order by "+_ordinamento," and CLI.CLI_AGE = '" + PUB_AGEOPE + "' AND CON_TIPOCO IN ('C')" + "order by " +_ordinamento)
	cSql_1 = STRTRAN(cSql_1,"order by "+_ordinamento," and CLI.CLI_AGE = '" + PUB_AGEOPE + "' AND CON_TIPOCO IN ('C')" + "order by " +_ordinamento)
ENDIF
**=> ERASMO - FINE 08/12/2017

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione conto contabile;P.IVA"
PUB_VISTA  = "con_conto;con_descr;PARIVA"
PUB_RIT    = _ritorno
___dimensioni= "120;510;120"

*DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco conti contabili",___dimensioni
**=> ERASMO - INIZIO 19/10/2021
*IF PUB_ALBEROCONTI
IF PUB_RICALBERO  && ERASMO - 12/11/2021
	noFilters = IIF(EMPTY(_seek) OR ALLTRIM(_seek) == "''",.T.,.F.)
	DO Form FORM\ELENCO_CONTI_TREEVIEW WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,noFilters
ELSE
	DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco conti contabili",___dimensioni
ENDIF
**=> ERASMO - FINE 19/10/2021

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)



*********************************************************************************************
* SEEK_u_art_pr()	funzione per la gestione della tabella u_art_pr
*********************************************************************************************
* La funzione restituisce dalla tabella u_art_pr, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la finestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_art_pr
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_primo_fornitore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF

**=> ERASMO - INIZIO 16/02/2016
IF PCOUNT() >= 7
ELSE
	_primo_fornitore = ""
ENDIF
**=> ERASMO - FINE 16/02/2016

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_art_pr"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   IF LEN(ALLTRIM(_chiave)) > 2
   ELSE
      cSql="SELECT * FROM U_ART_PR WHERE 1=0"
      IF !ExecCommand(cSql,_nomecursore)
         return(.f.)
      ENDIF
      V_TESTO = "Bisogna digitare almeno 3 caratteri per iniziare la ricerca"
      V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
      &V_FORM
      SELECT(_pjlib_sele)
      _ret_valore=""
      return(_ret_valore)
   ENDIF
ELSE
   IF LEN(ALLTRIM(_chiave)) > 0
   ELSE
      cSql="SELECT * FROM U_ART_PR WHERE 1=0"
      IF !ExecCommand(cSql,_nomecursore)
         return(.f.)
      ENDIF
      PUB_ERRORE=MESSAGEBOX('Bisogna digitare almeno 1 carattere per iniziare la ricerca',64,'*** ATTENZIONE ***')
      SELECT(_pjlib_sele)
      _ret_valore=""
      return(_ret_valore)
   ENDIF
ENDIF

*_seek = "'"+_chiave+"'"
*_seek1= "'"+_chiave+"%'"
*!*	**=> ERASMO - INIZIO 29/12/2010
*!*	_seek = "'"+_chiave+"'" + " and ART_OBSOL <> 'S'"
*!*	_seek1= "'"+_chiave+"%'" + " and ART_OBSOL <> 'S'"
*!*	**=> ERASMO - FINE 29/12/2010
*!*	**=> ERASMO - INIZIO 04/02/2015
*!*	_seek = "'"+_chiave+"'" + " and ART_OBSOL <> 'S'"
*!*	_seek1= "'%"+_chiave+"%'" + " and ART_OBSOL <> 'S'"
*!*	**=> ERASMO - FINE 04/02/2015
*!*	**=> ERASMO - INIZIO 11/02/2015
*!*	_seek = "'"+_chiave+"'" + " and ART_OBSOL <> 'S'"
*!*	IF PUB_RICARTDES  && RICERCA PER STRINGA CONTENUTA COME DA PARAMETRO AZIENDALE
*!*		_seek1= "'%"+_chiave+"%'" + " and ART_OBSOL <> 'S'"
*!*	ELSE
*!*		_seek1= "'"+_chiave+"%'" + " and ART_OBSOL <> 'S'"
*!*	ENDIF
*!*	**=> ERASMO - FINE 11/02/2015

**=> ERASMO - INIZIO 20/10/2023
*** SE HO DIGITATO IL PUNTO INTERROGATIVO, DEVE RICERCARE INDIPENDENTEMENTE DALLA CHIAVE
_seek = IIF(_chiave = "?",_ordinamento,"'"+_chiave+"'") + " and ART_OBSOL <> 'S'"
IF PUB_RICARTDES  && RICERCA PER STRINGA CONTENUTA COME DA PARAMETRO AZIENDALE
	_seek1= IIF(_chiave = "?",_ordinamento,"'%"+_chiave+"%'") + " and ART_OBSOL <> 'S'"
ELSE
	_seek1= IIF(_chiave = "?",_ordinamento,"'"+_chiave+"%'") + " and ART_OBSOL <> 'S'"
ENDIF
**=> ERASMO - FINE 20/10/2023

**=> ERASMO - INIZIO 16/02/2016
IF PCOUNT() >= 7
	_seek  = _seek + " and ART_CODF1 = '" + _primo_fornitore + "'"
	_seek1 = _seek1 + " and ART_CODF1 = '" + _primo_fornitore + "'"
ENDIF
**=> ERASMO - FINE 16/02/2016

**=> ERASMO/SERGIO - INIZIO 15/09/2017
IF _ordinamento = "ART_DESCR"
	_ordinamento = "RTRIM(ART_DESCR)"
ENDIF
**=> ERASMO/SERGIO - FINE 15/09/2017

**=> ERASMO - INIZIO 20/10/2023
*** GESTIONE OPERATORE/AGENTE: SE CONFIGURATO, PUO' VISUALIZZARE ESCLUSIVAMENTE I PRODOTTI APPARTENENTI AI MAGAZZINI DI COMPETENZA
IF !EMPTY(PUB_AGEOPE)
	*** RICERCA MAGAZZINI DI COMPETENZA ABILITATI
	_cMagazziniAbilitati = ""
	mSql = "SELECT * FROM PARA WHERE CODICE = 'AGE" + PUB_AGEOPE + "'"
   	IF !ExecCommand(mSql,"TMP_PARA_AGE")
		return(.f.)
	ENDIF
	SELECT TMP_PARA_AGE
	GO TOP
	IF !EOF()
		_cMagazziniAbilitati = ALLTRIM(TOKENIZER(ALLTRIM(ITALIANO),"MAGAZZINI_ABILITATI"))
	ENDIF
	IF !EMPTY(_cMagazziniAbilitati)
		_seek  = _seek + " and ART_MAGA IN (" + _cMagazziniAbilitati + ")"
		_seek1 = _seek1 + " and ART_MAGA IN (" + _cMagazziniAbilitati + ")"
	ENDIF
ENDIF
**=> ERASMO - FINE 20/10/2023

**=> ERASMO - INIZIO 19/02/2025
*** PRIMO PARAMETRO DI INGRESSO _tipore SFRUTTATO PER INSERIRE CONDIZIONE FILTRO AGGIUNTIVA
IF !EMPTY(_tiporec)
	_seek  = _seek + " and " + ALLTRIM(_tiporec)
	_seek1 = _seek1 + " and " + ALLTRIM(_tiporec)
ENDIF
**=> ERASMO - FINE 19/02/2025


* -->> query per procedura elenco standard (form elenco)
* ----------------------------------------------------------------
*cSql 	= "SELECT top 50 * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" = "+_seek+" order by "+_ordinamento 
*cSql_1 	= "SELECT top 50 * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" like "+_seek1+" order by "+_ordinamento
cSql 	= "SELECT * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" like "+_seek1+" order by "+_ordinamento

*!*	**=> ERASMO - INIZIO 28/02/2020
*!*	cSql_all 	= "SELECT * FROM u_art_pr where art_codsoc = " + pub_codsoc + " order by "+_ordinamento 
*!*	cSql_1_all 	= "SELECT * FROM u_art_pr where art_codsoc = " + pub_codsoc + " order by "+_ordinamento

*!*	IF _chiave = "?"
*!*		cSql   = cSql_all
*!*		cSql_1 = cSql_all
*!*	ENDIF
*!*	**=> ERASMO - FINE 28/02/2020

*!*	* -->> query per procedura elenco con paginazione (form elenco_pg)
*!*	* ----------------------------------------------------------------------

*!*	* -->> parametri per prima query
*!*	* ----------------------------------
*!*	j_ii_tabella_10 = "u_art_pr"
*!*	j_ii_cond_10	= "art_codsoc = '" + pub_codsoc + "'"
*!*	j_ii_cond_11	= " and " +_ordinamento+" = "+_seek
*!*	j_ii_cond_12	= " and 1=1"
*!*	j_ii_cond_13	= " and 1=1"
*!*	j_ii_ordine_10	= _ordinamento

*!*	* -->> parametri per seconda query
*!*	* ----------------------------------
*!*	j_ii_tabella_20	= "u_art_pr"
*!*	j_ii_cond_20	= "art_codsoc = '" + pub_codsoc + "'"
*!*	j_ii_cond_21	= " and " +_ordinamento+" like "+_seek1
*!*	j_ii_cond_22	= " and 1=1"
*!*	j_ii_cond_23	= " and 1=1"
*!*	j_ii_ordine_20	= _ordinamento


*!*	cSql_pg 	= j_ii_tabella_10+":"+j_ii_cond_10+":"+j_ii_cond_11+":"+j_ii_cond_12+":"+j_ii_cond_13+":"+j_ii_ordine_10
*!*	cSql_1_pg 	= j_ii_tabella_20+":"+j_ii_cond_20+":"+j_ii_cond_21+":"+j_ii_cond_22+":"+j_ii_cond_23+":"+j_ii_ordine_20


PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1

*!*	* -->> nuova variabile con le query x elenco con paginazione
*!*	* -----------------------------------------------------------------
*!*	PUB_SEEK_PG= cSql_pg+";"+cSql_1_pg
*!*	* -----------------------------------------------------------------

PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "art_codpri;art_descr"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\ELENCO_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli ecash"
ELSE
   *DO Form FORM\ELENCO_PG WITH pub_select,pub_seek_pg,pub_testa,pub_vista,pub_rit,"Elenco articoli"
   *DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli"
	**=> ERASMO - INIZIO 08/05/2024
	IF PUB_SHWEST
		PUB_TESTA  = "Codice;Descrizione;Descrizione estesa"
		PUB_VISTA  = "art_codpri;art_descr;art_desest"
		DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli","120;315;315"
	ELSE
		DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli"
	ENDIF
	**=> ERASMO - INIZIO 08/05/2024
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)



*********************************************************************************************
* SEEK_u_art_pr_light()	funzione per la gestione della tabella u_art_pr 
*********************************************************************************************
* 
*  funzione da utilizzare per anagrafiche articoli di grosse dimensioni
*  elebora solo i campi principali dell'anagrafica articoli :
*
*  		ART_CODPRI,ART_DESCR,ART_UNIMIS,ART_OBSOL,ART_PRZCOS,ART_PRZVEN,ART_CODIVA,ART_MAGA,ART_TIPART,ART_QTACON
*  		ART_CODF1,ART_PRZCO1,ART_CODF2,ART_PRZCO2,ART_CODF3,ART_PRZCO3,ART_CODF4,ART_PRZCO4,ART_CODF5,ART_PRZCO5
*  		ART_SERIE,ART_CODMAT,ART_DESMAT,ART_CODCOL,ART_DESCOL,ART_SPESSO,ART_ALTEZZ,ART_LUNGHE,ART_CODIMB,ART_DESIMB,ART_LOTMIN
*
*					   
*********************************************************************************************
FUNCTION seek_u_art_pr_light
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_primo_fornitore,_par_cond_aggiuntiva

IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF

IF PCOUNT() = 6
	_primo_fornitore = ""
ENDIF

IF PCOUNT() = 7
	_par_cond_aggiuntiva = ""
ENDIF

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_art_pr"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

IF LEN(ALLTRIM(_chiave)) > 0
ELSE
   cSql="SELECT * FROM U_ART_PR WHERE 1=0"
   IF !ExecCommand(cSql,_nomecursore)
         return(.f.)
   ENDIF
   PUB_ERRORE=MESSAGEBOX('Bisogna digitare almeno 1 carattere per iniziare la ricerca',64,'*** ATTENZIONE ***')
   SELECT(_pjlib_sele)
   _ret_valore=""
   return(_ret_valore)
ENDIF

**=> ERASMO/SERGIO - INIZIO 15/09/2017
IF _ordinamento = "ART_DESCR"
	_ordinamento = "RTRIM(ART_DESCR)"
ENDIF
**=> ERASMO/SERGIO - FINE 15/09/2017

*!*	####################################################### campi u_art_pr desiderati ####################################################

Campi 	= "u_art_pr.art_codsoc,u_art_pr.art_codpri,art_descr,art_desest,art_unimis,art_obsol,art_przcos,art_przven,art_codiva,art_maga,art_tipart,art_qtacon"
Campi_1 = ",art_codf1,art_przco1,art_nota1,art_codf2,art_przco2,art_nota2,art_codf3,art_przco3,art_nota3,art_codf4,art_przco4,art_nota4,art_codf5,art_przco5,art_nota5"
Campi_2 = ",art_serie,art_codmat,art_desmat,art_codcol,art_descol,art_spesso,art_altezz,art_lunghe,art_codimb,art_desimb,art_lotmin,art_codtag,art_destag,art_codctl"


*!*	####################################################### campi u_art_pr desiderati ####################################################

*!*	####################################################### campi u_art_an desiderati ####################################################
Campi_AN = ",art_codlis,art_scomagg,ART_LDTMST"
*!*	####################################################### campi u_art_an desiderati ####################################################


*!*	####################################################### ACCESSO DIRETTO U_ART_PR #####################################################

x_soci = "u_art_pr.art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "u_art_pr.art_codpri = '" + ALLTRIM(_chiave) + "'"
x_cond = x_soci + " and " + x_codi

Csql_a  = "select " 
Csql_a  = Csql_a + Campi + campi_1 + campi_2 + campi_AN
Csql_b  = " from u_art_pr left outer join u_art_an on u_art_pr.art_codsoc = u_art_an.art_codsoc and u_art_pr.art_codpri = u_art_an.art_codpri where " + x_cond + ;
		  " order by u_art_pr.art_codsoc,u_art_pr.art_codpri"
Csql    = Csql_a  +  Csql_b

IF !ExecCommand(cSql,_nomecursore)
   return(.f.)
ENDIF
SELECT &_nomecursore
GO TOP
IF EOF()
ELSE
   	_RET_VALORE= ART_CODPRI
	SELECT(_PJLIB_SELE)
	RETURN(_RET_VALORE)
ENDIF

*!*	####################################################### ACCESSO DIRETTO U_ART_PR #####################################################


*!*	####################################################### ACCESSO U_ART_PR CON ELENCO_PG ##################################################
_seek = "'"+_chiave+"'" + " and ART_OBSOL <> 'S'"
IF PUB_RICARTDES  && ricerca per stringa contenuta come da parametro aziendale
	_seek1= "'%"+_chiave+"%'" + " and ART_OBSOL <> 'S'"
ELSE
	_seek1= "'"+_chiave+"%'" + " and ART_OBSOL <> 'S'"
ENDIF

IF !EMPTY(_PRIMO_FORNITORE)		&& PCOUNT() >= 7
	_seek  = _seek + " and ART_CODF1 = '" + _primo_fornitore + "'"
	_seek1 = _seek1 + " and ART_CODF1 = '" + _primo_fornitore + "'"
ENDIF

* -->> query per procedura elenco con paginazione (form elenco_pg)
* ----------------------------------------------------------------------

* -->> parametri per prima query
* ----------------------------------
*!*	j_ii_tabella_10	= "(SELECT U_ART_PR.ID_UNIQUE, " + IIF(!EMPTY(_par_cond_aggiuntiva), SUBSTR(ALLTRIM(_par_cond_aggiuntiva),1,AT(' ',ALLTRIM(_par_cond_aggiuntiva))-1) + ", ","") + ;
*!*	                  "U_ART_PR.ART_CODSOC, U_ART_PR.ART_CODPRI, U_ART_PR.ART_DESCR, U_ART_PR.ART_OBSOL from u_art_pr left outer join u_art_an on u_art_pr.art_codsoc = u_art_an.art_codsoc and u_art_pr.art_codpri = u_art_an.art_codpri) AS U_ART_PR_AN"
j_ii_tabella_10	= "(SELECT U_ART_PR.ID_UNIQUE, " + IIF(!EMPTY(_par_cond_aggiuntiva), SUBSTR(ALLTRIM(_par_cond_aggiuntiva),1,AT(' ',ALLTRIM(_par_cond_aggiuntiva))-1) + ", ","") + ;
                  "U_ART_PR.ART_CODSOC, U_ART_PR.ART_CODPRI, U_ART_PR.ART_DESCR, U_ART_PR.ART_OBSOL, U_ART_PR.ART_DESEST from u_art_pr " + ;
                  "left outer join u_art_an on u_art_pr.art_codsoc = u_art_an.art_codsoc and u_art_pr.art_codpri = u_art_an.art_codpri) AS U_ART_PR_AN"  && ERASMO - 08/05/2024
j_ii_cond_10	= "art_codsoc = '" + pub_codsoc + "'"
j_ii_cond_11	= " and " +_ordinamento+" = "+_seek
j_ii_cond_12	= IIF(!EMPTY(_par_cond_aggiuntiva)," and " + SUBSTR(ALLTRIM(_par_cond_aggiuntiva),AT('.',ALLTRIM(_par_cond_aggiuntiva))+1), " and 1=1")
j_ii_cond_13	= " and 1=1"
j_ii_ordine_10	= _ordinamento

* -->> parametri per seconda query
* ----------------------------------
*!*	j_ii_tabella_20	= "(SELECT U_ART_PR.ID_UNIQUE, " + IIF(!EMPTY(_par_cond_aggiuntiva), SUBSTR(ALLTRIM(_par_cond_aggiuntiva),1,AT(' ',ALLTRIM(_par_cond_aggiuntiva))-1) + ", ","") + ;
*!*	                  "U_ART_PR.ART_CODSOC, U_ART_PR.ART_CODPRI, U_ART_PR.ART_DESCR, U_ART_PR.ART_OBSOL from u_art_pr left outer join u_art_an on u_art_pr.art_codsoc = u_art_an.art_codsoc and u_art_pr.art_codpri = u_art_an.art_codpri) AS U_ART_PR_AN"
j_ii_tabella_20	= "(SELECT U_ART_PR.ID_UNIQUE, " + IIF(!EMPTY(_par_cond_aggiuntiva), SUBSTR(ALLTRIM(_par_cond_aggiuntiva),1,AT(' ',ALLTRIM(_par_cond_aggiuntiva))-1) + ", ","") + ;
                  "U_ART_PR.ART_CODSOC, U_ART_PR.ART_CODPRI, U_ART_PR.ART_DESCR, U_ART_PR.ART_OBSOL, U_ART_PR.ART_DESEST from u_art_pr " + ;
                  "left outer join u_art_an on u_art_pr.art_codsoc = u_art_an.art_codsoc and u_art_pr.art_codpri = u_art_an.art_codpri) AS U_ART_PR_AN"  && ERASMO - 08/05/2024
j_ii_cond_20	= "art_codsoc = '" + pub_codsoc + "'"
j_ii_cond_21	= " and " +_ordinamento+" like "+_seek1
j_ii_cond_22	= IIF(!EMPTY(_par_cond_aggiuntiva)," and " + SUBSTR(ALLTRIM(_par_cond_aggiuntiva),AT('.',ALLTRIM(_par_cond_aggiuntiva))+1), " and 1=1")
j_ii_cond_23	= " and 1=1"
j_ii_ordine_20	= _ordinamento

cSql 	= "SELECT * FROM " + j_ii_tabella_10 + " where " + j_ii_cond_10 + j_ii_cond_11 + j_ii_cond_12 + j_ii_cond_13 + " order by " + j_ii_ordine_10
cSql_1 	= "SELECT * FROM " + j_ii_tabella_20 + " where " + j_ii_cond_20 + j_ii_cond_21 + j_ii_cond_22 + j_ii_cond_23 + " order by " + j_ii_ordine_20

cSql_pg 	= j_ii_tabella_10+":"+j_ii_cond_10+":"+j_ii_cond_11+":"+j_ii_cond_12+":"+j_ii_cond_13+":"+j_ii_ordine_10
cSql_1_pg 	= j_ii_tabella_20+":"+j_ii_cond_20+":"+j_ii_cond_21+":"+j_ii_cond_22+":"+j_ii_cond_23+":"+j_ii_ordine_20


PUB_SELECT = _nomecursore
PUB_SEEK   = cSql +";"+cSql_1

PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "art_codpri;art_descr"
PUB_RIT    = _ritorno

*DO Form FORM\ELENCO_PG WITH pub_select,pub_seek_pg,pub_testa,pub_vista,pub_rit,"Elenco articoli"
*DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli"
**=> ERASMO - INIZIO 08/05/2024
IF PUB_SHWEST
	PUB_TESTA  = "Codice;Descrizione;Descrizione estesa"
	PUB_VISTA  = "art_codpri;art_descr;art_desest"
	DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli","120;315;315"
ELSE
	DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli"
ENDIF
**=> ERASMO - INIZIO 08/05/2024

STORE PUB_RIT TO _ret_valore


x_soci = "u_art_pr.art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "u_art_pr.art_codpri = '" + ALLTRIM(_ret_valore) + "'"
x_cond = x_soci + " and " + x_codi
Csql_a  = "select " 
Csql_a  = Csql_a + Campi + campi_1 + campi_2 + campi_AN
Csql_b  = " from u_art_pr left outer join u_art_an on u_art_pr.art_codsoc = u_art_an.art_codsoc and u_art_pr.art_codpri = u_art_an.art_codpri where " + x_cond
Csql    = Csql_a  +  Csql_b
IF !ExecCommand(cSql,_nomecursore)
   return(.f.)
ENDIF
SELECT &_nomecursore
GO TOP
IF EOF()
ELSE
   	_RET_VALORE= ART_CODPRI
ENDIF
*!*	####################################################### ACCESSO U_ART_PR CON ELENCO_PG ##################################################



SELECT(_pjlib_sele)
return(_ret_valore)



*********************************************************************************************
* SEEK_u_art_pr_forni()	funzione per la gestione della tabella u_art_pr 
*********************************************************************************************
* 
*  funzione da utilizzare per anagrafiche articoli di grosse dimensioni
*  elebora solo i campi principali dell'anagrafica articoli : ACCESSO IN BASE AL PRIMO CODICE ARTICOLO DEL FORNITORE
*
*  		ART_CODPRI,ART_DESCR,ART_UNIMIS,ART_OBSOL,ART_PRZCOS,ART_PRZVEN,ART_CODIVA,ART_MAGA,ART_TIPART,ART_QTACON
*  		ART_CODF1,ART_PRZCO1,ART_CODF2,ART_PRZCO2,ART_CODF3,ART_PRZCO3,ART_CODF4,ART_PRZCO4,ART_CODF5,ART_PRZCO5
*  		ART_SERIE,ART_CODMAT,ART_DESMAT,ART_CODCOL,ART_DESCOL,ART_SPESSO,ART_ALTEZZ,ART_LUNGHE,ART_CODIMB,ART_DESIMB,ART_LOTMIN
*
*					   
*********************************************************************************************
FUNCTION SEEK_u_art_pr_forni
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_primo_articolo_fornitore,_par_cond_aggiuntiva

 
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF

IF PCOUNT() = 6
	_primo_articolo_fornitore = ""
ENDIF

IF PCOUNT() = 7
	_par_cond_aggiuntiva = ""
ENDIF

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_art_pr"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

IF LEN(ALLTRIM(_chiave)) > 0
ELSE
   cSql="SELECT * FROM U_ART_PR WHERE 1=0"
   IF !ExecCommand(cSql,_nomecursore)
         return(.f.)
   ENDIF
   PUB_ERRORE=MESSAGEBOX('Bisogna digitare almeno 1 carattere per iniziare la ricerca',64,'*** ATTENZIONE ***')
   SELECT(_pjlib_sele)
   _ret_valore=""
   return(_ret_valore)
ENDIF

**=> ERASMO/SERGIO - INIZIO 15/09/2017
IF _ordinamento = "ART_DESCR"
	_ordinamento = "RTRIM(ART_DESCR)"
ENDIF
**=> ERASMO/SERGIO - FINE 15/09/2017

*!*	####################################################### campi u_art_pr desiderati ####################################################

Campi 	= "u_art_pr.art_codsoc,u_art_pr.art_codpri,art_descr,art_desest,art_unimis,art_obsol,art_przcos,art_przven,art_codiva,art_maga,art_tipart,art_qtacon"
Campi_1 = ",art_codf1,art_przco1,art_nota1,art_codf2,art_przco2,art_nota2,art_codf3,art_przco3,art_nota3,art_codf4,art_przco4,art_nota4,art_codf5,art_przco5,art_nota5"
Campi_2 = ",art_serie,art_codmat,art_desmat,art_codcol,art_descol,art_spesso,art_altezz,art_lunghe,art_codimb,art_desimb,art_lotmin,art_codtag,art_destag,art_codctl"


*!*	####################################################### campi u_art_pr desiderati ####################################################

*!*	####################################################### campi u_art_an desiderati ####################################################
Campi_AN = ",art_codlis,art_scomagg,ART_LDTMST"
*!*	####################################################### campi u_art_an desiderati ####################################################


*!*	####################################################### ACCESSO U_ART_PR CON ELENCO_PG ##################################################
_seek = "'"+_chiave+"'" + " and ART_OBSOL <> 'S'"
IF PUB_RICARTDES  && ricerca per stringa contenuta come da parametro aziendale
	_seek1= "'%"+_chiave+"%'" + " and ART_OBSOL <> 'S'"
ELSE
	_seek1= "'"+_chiave+"%'" + " and ART_OBSOL <> 'S'"
ENDIF

*!*	IF !EMPTY(_primo_articolo_fornitore)		&& PCOUNT() >= 7
*!*		_seek  = _seek + " and ART_NOTA1 = '" + _primo_articolo_fornitore + "'"
*!*		_seek1 = _seek1 + " and ART_NOTA1 = '" + _primo_articolo_fornitore + "'"
*!*	ENDIF

* -->> query per procedura elenco con paginazione (form elenco_pg)
* ----------------------------------------------------------------------

* -->> parametri per prima query
* ----------------------------------
j_ii_tabella_10	= "(SELECT U_ART_PR.ID_UNIQUE, " + IIF(!EMPTY(_par_cond_aggiuntiva), SUBSTR(ALLTRIM(_par_cond_aggiuntiva),1,AT(' ',ALLTRIM(_par_cond_aggiuntiva))-1) + ", ","") + ;
                  "U_ART_PR.ART_CODSOC, U_ART_PR.ART_CODPRI, U_ART_PR.ART_DESCR, U_ART_PR.ART_NOTA1, U_ART_PR.ART_OBSOL from u_art_pr left outer join u_art_an on u_art_pr.art_codsoc = u_art_an.art_codsoc and u_art_pr.art_codpri = u_art_an.art_codpri) AS U_ART_PR_AN"
j_ii_cond_10	= "art_codsoc = '" + pub_codsoc + "'"
j_ii_cond_11	= " and " +_ordinamento+" = "+_seek
j_ii_cond_12	= IIF(!EMPTY(_par_cond_aggiuntiva)," and " + SUBSTR(ALLTRIM(_par_cond_aggiuntiva),AT('.',ALLTRIM(_par_cond_aggiuntiva))+1), " and 1=1")
j_ii_cond_13	= " and 1=1"
j_ii_ordine_10	= _ordinamento

* -->> parametri per seconda query
* ----------------------------------
j_ii_tabella_20	= "(SELECT U_ART_PR.ID_UNIQUE, " + IIF(!EMPTY(_par_cond_aggiuntiva), SUBSTR(ALLTRIM(_par_cond_aggiuntiva),1,AT(' ',ALLTRIM(_par_cond_aggiuntiva))-1) + ", ","") + ;
                  "U_ART_PR.ART_CODSOC, U_ART_PR.ART_CODPRI, U_ART_PR.ART_DESCR, U_ART_PR.ART_NOTA1, U_ART_PR.ART_OBSOL from u_art_pr left outer join u_art_an on u_art_pr.art_codsoc = u_art_an.art_codsoc and u_art_pr.art_codpri = u_art_an.art_codpri) AS U_ART_PR_AN"
j_ii_cond_20	= "art_codsoc = '" + pub_codsoc + "'"
j_ii_cond_21	= " and " +_ordinamento+" like "+_seek1
j_ii_cond_22	= IIF(!EMPTY(_par_cond_aggiuntiva)," and " + SUBSTR(ALLTRIM(_par_cond_aggiuntiva),AT('.',ALLTRIM(_par_cond_aggiuntiva))+1), " and 1=1")
j_ii_cond_23	= " and 1=1"
j_ii_ordine_20	= _ordinamento

cSql 	= "SELECT * FROM " + j_ii_tabella_10 + " where " + j_ii_cond_10 + j_ii_cond_11 + j_ii_cond_12 + j_ii_cond_13 + " order by " + j_ii_ordine_10
cSql_1 	= "SELECT * FROM " + j_ii_tabella_20 + " where " + j_ii_cond_20 + j_ii_cond_21 + j_ii_cond_22 + j_ii_cond_23 + " order by " + j_ii_ordine_20

cSql_pg 	= j_ii_tabella_10+":"+j_ii_cond_10+":"+j_ii_cond_11+":"+j_ii_cond_12+":"+j_ii_cond_13+":"+j_ii_ordine_10
cSql_1_pg 	= j_ii_tabella_20+":"+j_ii_cond_20+":"+j_ii_cond_21+":"+j_ii_cond_22+":"+j_ii_cond_23+":"+j_ii_ordine_20



PUB_SELECT = _nomecursore
PUB_SEEK   = cSql +";"+cSql_1

PUB_TESTA  = "Codice;Codice fornitore;Descrizione"
PUB_VISTA  = "art_codpri;art_nota1;art_descr"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli"

STORE PUB_RIT TO _ret_valore


x_soci = "u_art_pr.art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "u_art_pr.art_codpri = '" + ALLTRIM(_ret_valore) + "'"
x_cond = x_soci + " and " + x_codi
Csql_a  = "select " 
Csql_a  = Csql_a + Campi + campi_1 + campi_2 + campi_AN
Csql_b  = " from u_art_pr left outer join u_art_an on u_art_pr.art_codsoc = u_art_an.art_codsoc and u_art_pr.art_codpri = u_art_an.art_codpri where " + x_cond
Csql    = Csql_a  +  Csql_b
IF !ExecCommand(cSql,_nomecursore)
   return(.f.)
ENDIF
SELECT &_nomecursore
GO TOP
IF EOF()
ELSE
   	_RET_VALORE= ART_CODPRI
ENDIF
*!*	####################################################### ACCESSO U_ART_PR CON ELENCO_PG ##################################################



SELECT(_pjlib_sele)
return(_ret_valore)


*********************************************************************************************
* SEEK_u_art_pri()	funzione per la gestione della tabella u_art_pr per confezione M.I.
*********************************************************************************************
* La funzione restituisce dalla tabella u_art_pr, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_art_pri
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_art_pr"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   IF LEN(ALLTRIM(_chiave)) > 2
   ELSE
      cSql="SELECT * FROM U_ART_PR WHERE 1=0"
      IF !ExecCommand(cSql,_nomecursore)
         return(.f.)
      ENDIF
      V_TESTO = "Bisogna digitare almeno 3 caratteri per iniziare la ricerca"
      V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
      &V_FORM
      SELECT(_pjlib_sele)
      _ret_valore=""
      return(_ret_valore)
   ENDIF
ELSE
   IF LEN(ALLTRIM(_chiave)) > 2
   ELSE
      cSql="SELECT * FROM U_ART_PR WHERE 1=0"
      IF !ExecCommand(cSql,_nomecursore)
         return(.f.)
      ENDIF
      PUB_ERRORE=MESSAGEBOX('Bisogna digitare almeno 3 caratteri per iniziare la ricerca',64,'*** ATTENZIONE ***')
      SELECT(_pjlib_sele)
      _ret_valore=""
      return(_ret_valore)
   ENDIF
ENDIF

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT top 50 * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT top 50 * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Confezione;Descrizione;Componente;Descrizione"
PUB_VISTA  = "art_codpac;art_despac;art_codpri;art_descr"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\ELENCO_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli ecash"
ELSE
   DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli"
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)



*********************************************************************************************
* SEEK_ccosto()	funzione per la gestione della tabella ccosto
*********************************************************************************************
* La funzione restituisce dalla tabella ccosto, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_ccosto
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore

LOCAL _ret_valore,_pjlib_sele,_seek,_seek1,cSql,cSql_1,cSql_all  

IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return(SPACE(0))
ENDIF 

*** SE IL CAMPO DI RICERCA NON E' STATO VALORIZZATO ESCO CON BLANK
IF ALLTRIM(_chiave)=PUB_CODSOC+PUB_ANNO
	return(SPACE(0))
ENDIF

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_ccosto"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"

cSql 	= "SELECT * FROM ccosto where CON_ABILIT<>'N' AND con_soc+con_anno+con_conto = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM ccosto where CON_ABILIT<>'N' AND con_soc+con_anno+con_descr like "+_seek1+" order by "+_ordinamento
cSql_all= "SELECT  * FROM ccosto where CON_ABILIT<>'N' AND CON_ANNO='"+PUB_ANNO+"' order by "+_ordinamento

IF "?" $ ALLTRIM(_chiave)
	cSql_1 = cSql_all
ENDIF
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione centro di costo"
PUB_VISTA  = "con_conto;con_descr"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco centri di costo"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_u_pdv_an()	funzione per la gestione della tabella u_pdv_an
*********************************************************************************************
* La funzione restituisce dalla tabella u_pdv_an, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_pdv_an
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_pdv_an"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT * FROM u_pdv_an where "+_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM u_pdv_an where "+_ordinamento+" like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione centro di costo"
PUB_VISTA  = "pdv_codice;pdv_descri"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco buisness unit"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)



*********************************************************************************************
* SEEK_U_ART_PR_OR()	funzione per la lettura della tabella u_art_pr
*********************************************************************************************
* La funzione restituisce TRUE se trova, FALSE se non trova dati nella tabella
* selezionata con una certa chiave, inoltre restituisce il cursore con il/i record
* che hanno soffisfatto il filtro
* La caratteristica di questa lettura è che è condizionata da operatori .or.
*
* Descrizione dei parametri:
* 		_nometabella	= è il nome della tabella su cui effettuare la ricerca
* 		_nomecursore	= è il nome del cursore in output
*					   
* Esempio:
*		seek_all('u_art_pr','CUR_U_ART_PR)
*********************************************************************************************
FUNCTION seek_u_art_pr_or
PARAMETERS _nometabella,_nomecursore
IF PCOUNT() < 1
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return(.f.)
ENDIF 

IF EMPTY(_nomecursore)
   _cursore_ricerca="pj_cur_"+_nometabella
ELSE
   _cursore_ricerca=_nomecursore
ENDIF

_pjlib_sele=SELECT()

*_pj_seek = "select * from "+_nometabella+" where ART_CODF1 <> SPACE(10) OR ART_CODF2 <> SPACE(10) OR ART_CODF3 <> SPACE(10)
_pj_seek = "select * from "+_nometabella+" where ART_CODF1 <> SPACE(10) OR ART_CODF2 <> SPACE(10) OR ART_CODF3 <> SPACE(10) OR ART_CODF4 <> SPACE(10) OR ART_CODF5 <> SPACE(10)"  && ERASMO - 02/01/2017

IF !ExecCommand(_pj_seek,_cursore_ricerca)
   return(.f.)
ENDIF
	
SELECT &_cursore_ricerca
IF reccount() = 0
   _ret_valore=.f.
ELSE
   _ret_valore=.t.
ENDIF 
	
SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_U_ART_PR_DA/AL()	funzione per la lettura della tabella u_art_pr DA/AL
*********************************************************************************************
* La funzione restituisce TRUE se trova, FALSE se non trova dati nella tabella
* selezionata con una certa chiave, inoltre restituisce il cursore con il/i record
* che hanno soffisfatto il filtro
* La caratteristica di questa lettura è che è condizionata da un range dal/al
*
* Descrizione dei parametri:
* 		_nometabella	= è il nome della tabella su cui effettuare la ricerca
*		_chiavericercada= è la chiave completa di ricerca di partenza (dal)
*		_chiavericercaal= è la chiave completa di ricerca di arrivo (al)
*		_campinchiave	= è l'elenco dei campi che formano la chiave 
*					   
* Esempio:
*       seek_u_art_pr_da_al('u_art_pr',v_seekda,v_seekal,v_chiave,'CUR_ARTICOLI')
*********************************************************************************************
FUNCTION seek_u_art_pr_da_al
PARAMETERS _nometabella,_chiavericercada,_chiavericercaal,_campinchiave,_nomecursore
IF PCOUNT() < 4
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return(.f.)
ENDIF 

IF EMPTY(_nomecursore)
   _cursore_ricerca="pj_cur_"+_nometabella
ELSE
   _cursore_ricerca=_nomecursore
ENDIF

_pjlib_sele=SELECT()

_pj_seek = "select * from "+_nometabella+" where "+_campinchiave+" >= '"+_chiavericercada+"'"+" and "+_campinchiave+" <= '"+_chiavericercaal+"'"

IF !ExecCommand(_pj_seek,_cursore_ricerca)
   return(.f.)
ENDIF
	
SELECT &_cursore_ricerca
IF reccount() = 0
   _ret_valore=.f.
ELSE
   _ret_valore=.t.
ENDIF 
	
SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_STD_UG_DAL()	funzione per la lettura di tutte le tabelle a partire da un punto in avanti
*********************************************************************************************
* La funzione restituisce TRUE se trova, FALSE se non trova dati nella tabella
* selezionata con una certa chiave, inoltre restituisce il cursore con il/i record
* che hanno soddisfatto il filtro
* La caratteristica di questa lettura è che è condizionata da un range di uguaglianza di una parte
* della chiave e di una di maggioranza
*
* Descrizione dei parametri:
* 		_nometabella	= è il nome della tabella su cui effettuare la ricerca
*		_chiavericercaug= è la chiave completa di ricerca di uguaglianza
*		_chiavericercada= è la chiave completa di ricerca di partenza (dal)
*		_campinchiaveug	= è l'elenco dei campi che formano la chiave di uguaglianza
*		_campinchiaveda	= è l'elenco dei campi che formano la chiave di maggioranza 
*					   
* Esempio:
*       seek_u_art_pr_da_al('u_art_pr',v_seekug,v_seekda,v_chiaveug,v_chiaveda,'CUR_ARTICOLI')
*********************************************************************************************
FUNCTION seek_std_ug_dal
PARAMETERS _nometabella,_chiavericercaug,_chiavericercada,_campinchiaveug,_campinchiaveda,_nomecursore
IF PCOUNT() < 4
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return(.f.)
ENDIF 

IF EMPTY(_nomecursore)
   _cursore_ricerca="pj_cur_"+_nometabella
ELSE
   _cursore_ricerca=_nomecursore
ENDIF

_pjlib_sele=SELECT()

_pj_seek = "select * from "+_nometabella+" where "+_campinchiaveug+" = '"+_chiavericercaug+"'"+" and "+_campinchiaveda+" >= '"+_chiavericercada+"'"

IF !ExecCommand(_pj_seek,_cursore_ricerca)
   return(.f.)
ENDIF
	
SELECT &_cursore_ricerca
IF reccount() = 0
   _ret_valore=.f.
ELSE
   _ret_valore=.t.
ENDIF 
	
SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_STD_DAL()	funzione per la lettura di tutte le tabelle a partire da un punto in avanti
*********************************************************************************************
* La funzione restituisce TRUE se trova, FALSE se non trova dati nella tabella
* selezionata con una certa chiave, inoltre restituisce il cursore con il/i record
* che hanno soddisfatto il filtro
* La caratteristica di questa lettura è che è condizionata da un range dal fino alla fine
*
* Descrizione dei parametri:
* 		_nometabella	= è il nome della tabella su cui effettuare la ricerca
*		_chiavericercada= è la chiave completa di ricerca di partenza (dal)
*		_campinchiave	= è l'elenco dei campi che formano la chiave 
*					   
* Esempio:
*       seek_u_art_pr_da_al('u_art_pr',v_seekda,v_seekal,v_chiave,'CUR_ARTICOLI')
*********************************************************************************************
FUNCTION seek_std_dal
PARAMETERS _nometabella,_chiavericercada,_campinchiave,_nomecursore
IF PCOUNT() < 4
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return(.f.)
ENDIF 

IF EMPTY(_nomecursore)
   _cursore_ricerca="pj_cur_"+_nometabella
ELSE
   _cursore_ricerca=_nomecursore
ENDIF

_pjlib_sele=SELECT()

_pj_seek = "select * from "+_nometabella+" where "+_campinchiave+" >= '"+_chiavericercada+"'"

IF !ExecCommand(_pj_seek,_cursore_ricerca)
   return(.f.)
ENDIF
	
SELECT &_cursore_ricerca
IF reccount() = 0
   _ret_valore=.f.
ELSE
   _ret_valore=.t.
ENDIF 
	
SELECT(_pjlib_sele)

return(_ret_valore)



*********************************************************************************************
* SEEK_STD_DA/AL()	funzione per la lettura di tutte le tabelle DA/AL
*********************************************************************************************
* La funzione restituisce TRUE se trova, FALSE se non trova dati nella tabella
* selezionata con una certa chiave, inoltre restituisce il cursore con il/i record
* che hanno soffisfatto il filtro
* La caratteristica di questa lettura è che è condizionata da un range dal/al
*
* Descrizione dei parametri:
* 		_nometabella	= è il nome della tabella su cui effettuare la ricerca
*		_chiavericercada= è la chiave completa di ricerca di partenza (dal)
*		_chiavericercaal= è la chiave completa di ricerca di arrivo (al)
*		_campinchiave	= è l'elenco dei campi che formano la chiave 
*					   
* Esempio:
*       seek_u_art_pr_da_al('u_art_pr',v_seekda,v_seekal,v_chiave,'CUR_ARTICOLI')
*********************************************************************************************
FUNCTION seek_std_da_al
PARAMETERS _nometabella,_chiavericercada,_chiavericercaal,_campinchiave,_nomecursore
IF PCOUNT() < 4
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return(.f.)
ENDIF 

IF EMPTY(_nomecursore)
   _cursore_ricerca="pj_cur_"+_nometabella
ELSE
   _cursore_ricerca=_nomecursore
ENDIF

_pjlib_sele=SELECT()

_pj_seek = "select * from "+_nometabella+" where "+_campinchiave+" >= '"+_chiavericercada+"'"+" and "+_campinchiave+" <= '"+_chiavericercaal+"'"

IF !ExecCommand(_pj_seek,_cursore_ricerca)
   return(.f.)
ENDIF
	
SELECT &_cursore_ricerca
IF reccount() = 0
   _ret_valore=.f.
ELSE
   _ret_valore=.t.
ENDIF 
	
SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_U_AGE_AN()	funzione per la gestione della tabella U_AGE_AN
*********************************************************************************************
* La funzione restituisce dalla tabella U_AGE_AN, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_age_an
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_age_an"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT * FROM u_age_an where age_codsoc+age_codice = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM u_age_an where age_codsoc+age_ragsoc like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Ragione sociale"
PUB_VISTA  = "age_codice;age_ragsoc"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco agenti"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


* SERGIO 02/12/2004 INIZIO

*********************************************************************************************
* SEEK_U_BAN_AN()	funzione per la gestione della tabella U_BAN_AN
*********************************************************************************************
* La funzione restituisce dalla tabella U_BAN_AN, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec			= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave				= è il valore ricercato (prima chiave)
* 		_ritorno			= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento		= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza			= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*		_tipologiabanca		= " "   : Banche del cliente
*		_tipologiabanca		= "S"   : Banche di presentazione  
*					   
*********************************************************************************************
FUNCTION seek_u_ban_an
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_tipologiabanca



IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF PCOUNT() <= 6
	_tipologiabanca = "ALL"
ENDIF


IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_ban_an"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

*!*	_seek = "'"+_chiave+"'"
*!*	_seek1= "'"+_chiave+"%'"
**=> ERASMO - INIZIO 25/07/2008
_seek = _chiave
_seek1= _chiave
**=> ERASMO - FINE 25/07/2008

*!*	IF _tipologiabanca = 'ALL'
*!*	ELSE
*!*	   _seek = _SEEK + " AND BAN_PRESE = '" + ALLTRIM(_tipologiabanca) + "'"
*!*	   _seek1 = _SEEK1 + " AND BAN_PRESE = '" + ALLTRIM(_tipologiabanca) + "'"
*!*	ENDIF   

*!*	cSql 	= "SELECT * FROM u_ban_an where ban_codsoc+ban_codban = "+_seek+" order by "+_ordinamento 
*!*	cSql_1 	= "SELECT * FROM u_ban_an where ban_codsoc+ban_desban like "+_seek1+" order by "+_ordinamento

*!*	**=> ERASMO - INIZIO 25/07/2008
*!*	cSql 	= "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_codban = '" +SUBSTR(_seek,3)+ "' order by "+_ordinamento 
*!*	cSql_1 	= "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_desban like '" +SUBSTR(_seek,3)+ "%' order by "+_ordinamento 
*!*	**=> ERASMO - FINE 25/07/2008

**=> ERASMO - INIZIO 04/08/2008
IF _tipologiabanca = 'ALL'
   cSql 	= "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_codban = '" +SUBSTR(_seek,3)+ "' order by "+_ordinamento 
   *cSql_1 	= "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_desban like '" +SUBSTR(_seek,3)+ "%' order by "+_ordinamento
   **=> ERASMO - INIZIO 11/02/2015
   IF PUB_RICBANDES  && RICERCA PER STRINGA CONTENUTA COME DA PARAMETRO AZIENDALE
      *cSql_1 = "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_desban like '%" +SUBSTR(_seek,3)+ "%' order by "+_ordinamento
      cSql_1 = "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND RTRIM(ban_desban) like '%" +SUBSTR(_seek,3)+ "%' order by "+_ordinamento  && ERASMO/SERGIO - 15/09/2017
   ELSE
      *cSql_1 = "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_desban like '" +SUBSTR(_seek,3)+ "%' order by "+_ordinamento
      cSql_1 = "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND RTRIM(ban_desban) like '" +SUBSTR(_seek,3)+ "%' order by "+_ordinamento  && ERASMO/SERGIO - 15/09/2017
   ENDIF
**=> ERASMO - FINE 11/02/2015
ELSE
   cSql 	= "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_codban = '" +SUBSTR(_seek,3)+ "' AND BAN_PRESE = '" + ALLTRIM(_tipologiabanca) + "' order by "+_ordinamento 
   *cSql_1 	= "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_desban like '" +SUBSTR(_seek,3)+ "%' AND BAN_PRESE = '" + ALLTRIM(_tipologiabanca) + "' order by "+_ordinamento 
   **=> ERASMO - INIZIO 11/02/2015
   IF PUB_RICBANDES  && RICERCA PER STRINGA CONTENUTA COME DA PARAMETRO AZIENDALE
      *cSql_1 = "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_desban like '%" +SUBSTR(_seek,3)+ "%' AND BAN_PRESE = '" + ALLTRIM(_tipologiabanca) + "' order by "+_ordinamento 
      cSql_1 = "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND RTRIM(ban_desban) like '%" +SUBSTR(_seek,3)+ "%' AND BAN_PRESE = '" + ALLTRIM(_tipologiabanca) + "' order by "+_ordinamento  && ERASMO/SERGIO - 15/09/2017
   ELSE
      *cSql_1 = "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_desban like '" +SUBSTR(_seek,3)+ "%' AND BAN_PRESE = '" + ALLTRIM(_tipologiabanca) + "' order by "+_ordinamento 
      cSql_1 = "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND RTRIM(ban_desban) like '" +SUBSTR(_seek,3)+ "%' AND BAN_PRESE = '" + ALLTRIM(_tipologiabanca) + "' order by "+_ordinamento  && ERASMO/SERGIO - 15/09/2017
   ENDIF
**=> ERASMO - FINE 11/02/2015
ENDIF
**=> ERASMO - FINE 04/08/2008

	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "ban_codban;ban_desban"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco banche"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)





*********************************************************************************************
* SEEK_U_BAN_AN_RIC()	funzione per la gestione della tabella U_BAN_AN PER LE RIBA
*********************************************************************************************
* La funzione restituisce dalla tabella U_BAN_AN, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec			= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave				= è il valore ricercato (prima chiave)
* 		_ritorno			= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento		= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza			= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*		_tipologiabanca		= " "   : Banche del cliente
*		_tipologiabanca		= "S"   : Banche di presentazione  
*					   
*********************************************************************************************
FUNCTION seek_u_ban_an_RIC
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_tipologiabanca



IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF PCOUNT() <= 6
	_tipologiabanca = "ALL"
ENDIF


IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_ban_an"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
**=> ERASMO - INIZIO 25/07/2008
*!*	_seek = _chiave
*!*	_seek1= _chiave
**=> ERASMO - FINE 25/07/2008

IF _tipologiabanca = 'ALL'
ELSE
   _seek = _SEEK + " AND BAN_PRESE = '" + ALLTRIM(_tipologiabanca) + "'"
   _seek1 = _SEEK1 + " AND BAN_PRESE = '" + ALLTRIM(_tipologiabanca) + "'"
ENDIF   

cSql 	= "SELECT * FROM u_ban_an where ban_codsoc+ban_codban = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM u_ban_an where ban_codsoc+ban_desban like "+_seek1+" order by "+_ordinamento

**=> ERASMO - INIZIO 25/07/2008
*!*	cSql 	= "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_codban = '" +SUBSTR(_seek,3)+ "' order by "+_ordinamento 
*!*	cSql_1 	= "SELECT * FROM u_ban_an where ban_codsoc = '" +SUBSTR(_seek,1,2)+ "' AND ban_desban like '" +SUBSTR(_seek,3)+ "%' order by "+_ordinamento 
**=> ERASMO - FINE 25/07/2008

	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "ban_codban;ban_desban"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco banche"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)






*********************************************************************************************
* SEEK_U_MAG_MO()	funzione per la gestione della tabella U_MAG_MO
*********************************************************************************************
* La funzione restituisce dalla tabella U_BAN_AN, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_mag_mo
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_mag_mo"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT * FROM u_mag_mo where mov_codsoc+mov_numdoc = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM u_mag_mo where mov_codsoc+mov_numdoc like "+_seek1+" order by "+_ordinamento

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA = "Magaz;N.doc.;Cod.articolo;Qta.mov.;Data reg.;Data doc."
PUB_VISTA = "MOV_CODMAG;MOV_NUMDOC;MOV_CODART;MOV_QTAMOV;MOV_DTREGI;MOV_DTDOCU"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco movimenti"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)

*********************************************************************************************
* SEEK_NOTE_COM()	funzione per la gestione della tabella NOTE_COM
*********************************************************************************************
* La funzione restituisce dalla tabella NOTE_COM, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_note_com
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_note_com"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT *,SUBSTRING(NOT_TESTO,1,100) AS NOT_VEDI FROM note_com where not_codsoc+not_codice = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT *,SUBSTRING(NOT_TESTO,1,100) AS NOT_VEDI FROM note_com where not_codsoc+not_codice like "+_seek1+" order by "+_ordinamento

**=> ERASMO - INIZIO 18/09/2015
IF ALLTRIM(_chiave) == PUB_CODSOC+"?"
	cSql_all= "SELECT *,SUBSTRING(NOT_TESTO,1,100) AS NOT_VEDI FROM note_com order by "+_ordinamento
	cSql_1 = cSql_all
ENDIF
**=> ERASMO - FINE 18/09/2015

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA = "Codice;Testo"
PUB_VISTA = "NOT_CODICE;NOT_VEDI"
PUB_RIT    = _ritorno

DO FORM FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco commenti"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_u_tes_an()	funzione per la gestione della tabella u_tes_an
*********************************************************************************************
* La funzione restituisce dalla tabella u_tes_an, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_tes_an
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_tes_an"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT * FROM u_tes_an where tes_cogn+tes_nome = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM u_tes_an where tes_cogn+tes_nome like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Cognome;Nome"
PUB_VISTA  = "tes_cogn;tes_nome"
PUB_RIT    = _ritorno

DO Form FORM\elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco tesserati"


STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)

*********************************************************************************************
* SEEK_res_oper()	funzione per la gestione della tabella res_oper
*********************************************************************************************
* La funzione restituisce dalla tabella u_tes_an, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_res_oper
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_res_oper"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT * FROM res_oper where societa+descri = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM res_oper where societa+descri like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "codice;descri"
PUB_RIT    = _ritorno

DO Form elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco operatori"


STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)

*********************************************************************************************

FUNCTION seek_res_oper1
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_res_oper"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT * FROM res_oper where societa+codice = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM res_oper where societa+codice like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "codice;descri"
PUB_RIT    = _ritorno

DO Form elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco operatori"


STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)

*********************************************************************************************
* SEEK_u_cnt_tt()	funzione per la gestione della tabella u_cnt_tt
*********************************************************************************************
* La funzione restituisce dalla tabella u_tes_an, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_cnt_tt
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_cnt_tt"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT * FROM u_cnt_tt where cnt_ragsoc = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM u_cnt_tt where cnt_ragsoc like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Ragione sociale"
PUB_VISTA  = "cnt_codcli;cnt_ragsoc"
PUB_RIT    = _ritorno

DO Form FORM\elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco clienti potenziali"


STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


**FB***********************************************************************************************
* SEEK_u_art_prnoparcq()	funzione per la gestione della tabella u_art_pr
*********************************************************************************************
* La funzione restituisce dalla tabella u_art_pr, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_art_prnoparcq
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_art_pr"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT TOP 50 U_ART_PR.*,U_PAR_CQ.PAR_CODART AS ARTCQ FROM U_ART_PR LEFT OUTER JOIN U_PAR_CQ ON U_ART_PR.ART_CODPRI = U_PAR_CQ.PAR_CODART AND U_ART_PR.ART_CODSOC = U_PAR_CQ.PAR_CODSOC  where U_ART_PR.art_codmat = '004' AND "+_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT TOP 50 U_ART_PR.*,U_PAR_CQ.PAR_CODART AS ARTCQ FROM U_ART_PR LEFT OUTER JOIN U_PAR_CQ ON U_ART_PR.ART_CODPRI = U_PAR_CQ.PAR_CODART AND U_ART_PR.ART_CODSOC = U_PAR_CQ.PAR_CODSOC  where U_ART_PR.art_codmat = '004' AND "+_ordinamento+" like "+_seek1+" order by "+_ordinamento 

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "art_codpri;art_descr"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\elenco_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli ecash"
ELSE
   DO Form FORM\elenco_EXCL WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli", 'ISNULL(ARTCQ)'
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


**FB***********************************************************************************************
* SEEK_u_art_prANDparcq()	funzione per la gestione della tabella u_art_pr
*********************************************************************************************
* La funzione restituisce dalla tabella u_art_pr, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_art_prANDparcq
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_art_pr"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT TOP 50 U_ART_PR.*,U_PAR_CQ.PAR_CODART AS ARTCQ FROM U_ART_PR LEFT OUTER JOIN U_PAR_CQ ON U_ART_PR.ART_CODPRI = U_PAR_CQ.PAR_CODART AND U_ART_PR.ART_CODSOC = U_PAR_CQ.PAR_CODSOC where  "+_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT TOP 50 U_ART_PR.*,U_PAR_CQ.PAR_CODART AS ARTCQ FROM U_ART_PR LEFT OUTER JOIN U_PAR_CQ ON U_ART_PR.ART_CODPRI = U_PAR_CQ.PAR_CODART AND U_ART_PR.ART_CODSOC = U_PAR_CQ.PAR_CODSOC where "+_ordinamento+" like "+_seek1+" order by "+_ordinamento 

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "art_codpri;art_descr"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\elenco_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli ecash"
ELSE
   DO Form FORM\elenco_EXCL WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli", '!ISNULL(ARTCQ)'
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)



**FB***********************************************************************************************
* SEEK_u_art_prAD()	funzione per la gestione della tabella u_art_pr
*********************************************************************************************
* La funzione restituisce dalla tabella u_art_pr, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_art_prAD
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_art_pr"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT TOP 50 U_ART_PR.*, 'U_PAR_CQ.PAR_CODART' AS ARTCQ FROM U_ART_PR WHERE  U_ART_PR.art_codmat = '004' AND "+_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT TOP 50 U_ART_PR.*, 'U_PAR_CQ.PAR_CODART' AS ARTCQ FROM U_ART_PR WHERE  U_ART_PR.art_codmat = '004' AND "+_ordinamento+" like "+_seek1+" order by "+_ordinamento 

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "art_codpri;art_descr"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
 *  DO Form FORM\elenco_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli ecash"
ELSE
   DO Form FORM\elenco_EXCL WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli", '.T.'
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


** sergio  inizio 12/09/2004 


** #################################################################################
** AGGIORNA IL FLAG DI AUTORIZZAZIONE
** #################################################################################
FUNCTION aggiorna_tabella_menu_aquarius
PARAMETERS _NomeMenu,_autorizzazione


cSql="SELECT * FROM TBL_MENU WHERE MENU=?_NomeMenu ORDER BY ORDINE "
IF !ExecCommand(cSql,'CURS_MENU')
  return
ENDIF

SELECT CURS_MENU
GO TOP
*!*	IF !EOF()
*!*		REPLACE AUTORIZZAZIONE WITH _AUTORIZZAZIONE ALL
*!*		GO TOP
*!*		IF !ExecRW('','TBL_MENU','I','','CURS_MENU')
*!*		   return(.f.)
*!*		ENDIF
*!*	ENDIF

**=> ERASMO - INIZIO 04/02/2010
*** IL CODICE APPENA ASTERISCATO GENERAVA OCCASIONALMENTE RIGHE DI MENU DUPLICATE
DO WHILE .T.
	IF EOF()
		EXIT
	ENDIF
	IF DELETED()
		SKIP +1
		LOOP
	ENDIF
	
	__act_id_unique = ALLTRIM(ID_UNIQUE)
	
	IF EMPTY(__act_id_unique)
		SKIP +1
		LOOP
	ENDIF
	
	_bit_autorizzazione = '0'
	IF _AUTORIZZAZIONE
		_bit_autorizzazione = '1'
	ENDIF
	
	cSql = "UPDATE TBL_MENU SET AUTORIZZAZIONE = " + _bit_autorizzazione + " WHERE ID_UNIQUE = '" + __act_id_unique + "'"
	IF !ExecCommand(cSql,'UPD_TBL_MENU')
		return
	ENDIF
	
	SELECT CURS_MENU
	SKIP +1
ENDDO
SELECT CURS_MENU
USE
**=> ERASMO - FINE 04/02/2010

return(.t.)



** #################################################################################
** VERIFICA SE LA FUNZIONE HA LA LICENZA ATTIVA
** #################################################################################
FUNCTION verifica_licenza_modulo
PARAMETERS _NomeMenu

SMODS=STR(SELECT())

cSql 	= "SELECT * FROM U_LIC_AN WHERE AZI_CODSOC = " + PUB_CODSOC 

IF !ExecCommand(cSql,'CURS_U_LIC_AN')
  return
ENDIF

SELECT CURS_U_LIC_AN
GO TOP
IF !EOF()
	
	IF &_NomeMenu
		SELECT &SMODS
		RETURN(.T.)
	ELSE
	
	   DO PLAYWAV WITH "BLIP.WAV" 

 		   XDESCRI="Attenzione "
	   SET CLASSLIB TO "proj_lib.vcx" additive
	   oForm=CreateObject("MsgErr") 
	   oform.edit1.Value=""+XDESCRI+CHR(13)+;
				  ""+CHR(13)+;			  
				  "Licenza uso"+CHR(13)+"per questa funzione non attiva "+CHR(13)+"rivolgersi alla direzione"+CHR(13)+"Project"
	   oform.Show
	   RELEASE OFORM 
	   SELECT &SMODS
	   RETURN(.F.)	  
	   
	ENDIF
		  
		   	
ELSE
	SELECT &SMODS
	RETURN(.T.)
	
ENDIF



*********************************************************************************************
* SEEK_U_TOP_MO()	funzione per la gestione della tabella CAUSALI DI MOVIMENTI
*********************************************************************************************

FUNCTION seek_u_top_mo
PARAMETERS _chiave,_ritorno

_nomecursore="U_TOP_MO"
_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+ALLTRIM(_chiave)+"'"
_seek1= "'"+ALLTRIM(_chiave)+"%'"

cSql     = "SELECT * FROM U_TOP_MO WHERE TOP_MAGSCA = '" + _CHIAVE + "' ORDER BY TOP_MAGSCA,TOP_MAGCAR,TOP_CAUSCA"
cSql_1   = "SELECT * FROM U_TOP_MO WHERE TOP_MAGSCA LIKE '" + _CHIAVE + "%' ORDER BY TOP_MAGSCA,TOP_MAGCAR,TOP_CAUSCA"
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Mag.Scar.;Mag.Car.;Top.Scar.;Top.Car."
PUB_VISTA  = "top_magsca;top_magcar;top_causca;top_caucar"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco top di movimento magazzino"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_U_PRD_D1()	funzione per la gestione della tabella U_PRD_D1
*********************************************************************************************
* La funzione restituisce dalla tabella U_PRD_D1, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*		_nomecursore= è il nome che si vuole assegnare al cursore ottenuto dalla ricerca
*                     Se è BLANK ("") allora viene assegnato in automatico il nome U_PRD_D1.
*					   
*********************************************************************************************
FUNCTION SEEK_U_PRD_D1
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="U_PRD_D1"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

IF LEN(ALLTRIM(_chiave)) > 0
ELSE
  cSql="SELECT * FROM U_PRD_D1 WHERE 1=0"
  IF !ExecCommand(cSql,_nomecursore)
     return(.f.)
  ENDIF
  PUB_ERRORE=MESSAGEBOX('Bisogna digitare almeno 1 carattere per iniziare la ricerca',64,'*** ATTENZIONE ***')
  SELECT(_pjlib_sele)
  _ret_valore=""
  return(_ret_valore)
ENDIF

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"

* -->> query per procedura elenco standard (form elenco)
* ----------------------------------------------------------------
cSql 	= "SELECT top 50 * FROM U_PRD_D1 where " +_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT top 50 * FROM U_PRD_D1 where " +_ordinamento+" like "+_seek1+" order by "+_ordinamento
	

* -->> query per procedura elenco con paginazione (form elenco_pg)
* ----------------------------------------------------------------------

* -->> parametri per prima query
* ----------------------------------
j_ii_tabella_10 = "U_PRD_D1"
j_ii_cond_10	= " 1=1"
j_ii_cond_11	= " and " +_ordinamento+" = "+_seek
j_ii_cond_12	= " and 1=1"
j_ii_cond_13	= " and 1=1"
j_ii_ordine_10	= _ordinamento

* -->> parametri per seconda query
* ----------------------------------
j_ii_tabella_20	= "U_PRD_D1"
j_ii_cond_20	= " 1=1"
j_ii_cond_21	= " and " +_ordinamento+" like "+_seek1
j_ii_cond_22	= " and 1=1"
j_ii_cond_23	= " and 1=1"
j_ii_ordine_20	= _ordinamento


cSql_pg 	= j_ii_tabella_10+":"+j_ii_cond_10+":"+j_ii_cond_11+":"+j_ii_cond_12+":"+j_ii_cond_13+":"+j_ii_ordine_10
cSql_1_pg 	= j_ii_tabella_20+":"+j_ii_cond_20+":"+j_ii_cond_21+":"+j_ii_cond_22+":"+j_ii_cond_23+":"+j_ii_ordine_20


PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1

* -->> nuova variabile con le query x elenco con paginazione
* -----------------------------------------------------------------
PUB_SEEK_PG= cSql_pg+";"+cSql_1_pg
* -----------------------------------------------------------------

PUB_TESTA  = "D.piano;Num.piano;D.progr.;Num.programma"

***PR1_DATPIA:Data piano,W:10;PR1_NUMPIA:Num.piano,W:10;PR1_DATPRG:Data programma,W:10;PR1_NUMPRG:Num.programma;

PUB_VISTA  = "PR1_DATPIA;PR1_NUMPIA;PR1_DATPRG;PR1_NUMPRG"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO_PG WITH pub_select,pub_seek_pg,pub_testa,pub_vista,pub_rit,"Elenco PROGRAMMI DI PRODUZIONE"


STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)



*********************************************************************************************
* SEEK_BILNEW()	funzione per la gestione della tabella BILNEW
*********************************************************************************************
* La funzione restituisce dalla tabella BILNEW, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_bilnew
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_bilnew"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'%"+ALLTRIM(_chiave)+"%'"
cSql 	= "SELECT * FROM bilnew where bil_codrig = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM bilnew where descrizion like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "bil_codrig;descrizion"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\ELENCO_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco righe ecash"
ELSE
   DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco righe"
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)

*********************************************************************************************
* SEEK_BILANCIOR()	funzione per la gestione della tabella BILANCIOR
*********************************************************************************************
* La funzione restituisce dalla tabella BILANCIOR, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_bilancior
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_bilancior"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'%"+ALLTRIM(_chiave)+"%'"
cSql 	= "SELECT * FROM BILANCIOR where bil_codrig = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM BILANCIOR where descrizion like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "bil_codrig;descrizion"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\ELENCO_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco righe ecash"
ELSE
   DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco righe"
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)






*********************************************************************************************
* IS_CODINT()	funzione per la gestione del CODICE CLIENTE INTERNO
*********************************************************************************************
*
* La funzione restituisce il codice cliente impostato in anagrafica azienda
*
*********************************************************************************************
FUNCTION IS_CODINT

_sel_ = SELECT()

Csql   = "SELECT top 1 * FROM U_azi_an"

IF !ExecCommand(Csql,"AZIENDA")
	return(.f.)
ENDIF

SELECT AZIENDA
GO TOP
IF !EOF()
	_ret_codice = ALLTRIM(STR(VAL(AZIENDA.AZI_CODCLI)))
ELSE
	_ret_codice = "000000000"
ENDIF
	
SELECT(_sel_)

return(_ret_codice)


*********************************************************************************************
* SEEK_u_dis_tt()	funzione per la gestione della tabella u_dis_tt
*********************************************************************************************
FUNCTION seek_u_dis_tt
PARAMETERS _____GRUPPO 

_ret_valore=""

_pjlib_sele_dis=SELECT()
____GRUPPO2 = ''
____DESCRI2 = ''

IF PUB_SKART		&& ACCESSO PER DESCRIZIONE ARTICOLO 
	
	*!*	__________________________________________________________________ACCESSO PER CODICE DESCRIZIONE ARTICOLO  

	x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
	x_desc = "dit_descri = '" + ALLTRIM(_____GRUPPO) + "'"
	x_des1 = "dit_descri like '" + ALLTRIM(_____GRUPPO) + "%'"
	cSql   = "select * from u_dis_tt where " + x_soci + " and "  + x_desc + ;
	                                       " order by dit_codsoc,dit_descri"
	cSql_1 = "select * from u_dis_tt where " + x_soci + " and "  + x_des1 + ;
	                                       " order by dit_codsoc,dit_descri"
	PUB_SELECT = "u_dis_tt"
	PUB_SEEK   = cSql+";"+cSql_1
	PUB_TESTA  = "Gruppo;Descrizione"
	PUB_VISTA  = "DIT_GRUPPO;DIT_DESCRI"
	PUB_RIT    = "DIT_GRUPPO"

	DO FORM FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco gruppi"
	IF !EOF()
		STORE PUB_RIT TO _RET_VALORE
		____GRUPPO2 = DIT_GRUPPO
		____DESCRI2 = DIT_DESCRI		
		SELECT(_PJLIB_SELE_DIS)
		RETURN(_RET_VALORE)
	ENDIF

	*!*	__________________________________________________________________ACCESSO PER CODICE ARTICOLO  
	x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
	x_grup = "dit_gruppo = '" + ALLTRIM(_____GRUPPO) + "'"
	x_gru1 = "dit_gruppo like '" + ALLTRIM(_____GRUPPO) + "%'"
	cSql   = "select * from u_dis_tt where " + x_soci + " and "  + x_grup + ;
	                                       " order by dit_codsoc,dit_gruppo"
	cSql_1 = "select * from u_dis_tt where " + x_soci + " and "  + x_gru1 + ;
	                                       " order by dit_codsoc,dit_gruppo"
	PUB_SELECT = "u_dis_tt"
	PUB_SEEK   = cSql+";"+cSql_1
	PUB_TESTA  = "Gruppo;Descrizione"
	PUB_VISTA  = "DIT_GRUPPO;DIT_DESCRI"
	PUB_RIT    = "DIT_GRUPPO"

	DO FORM FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco gruppi"
	SELECT u_dis_tt
	GO TOP
	IF !EOF()
		STORE PUB_RIT TO _RET_VALORE
		____GRUPPO2 = DIT_GRUPPO
		____DESCRI2 = DIT_DESCRI		
		SELECT(_PJLIB_SELE_DIS)
		RETURN(_RET_VALORE)
	ENDIF

	
	 
ELSE		&& ACCESSO PER CODICE ARTICOLO 
	*!*	__________________________________________________________________ACCESSO PER CODICE ARTICOLO  
	x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
	x_grup = "dit_gruppo = '" + ALLTRIM(_____GRUPPO) + "'"
	x_gru1 = "dit_gruppo like '" + ALLTRIM(_____GRUPPO) + "%'"
	cSql   = "select * from u_dis_tt where " + x_soci + " and "  + x_grup + ;
	                                       " order by dit_codsoc,dit_gruppo"
	cSql_1 = "select * from u_dis_tt where " + x_soci + " and "  + x_gru1 + ;
	                                       " order by dit_codsoc,dit_gruppo"
	PUB_SELECT = "u_dis_tt"
	PUB_SEEK   = cSql+";"+cSql_1
	PUB_TESTA  = "Gruppo;Descrizione"
	PUB_VISTA  = "DIT_GRUPPO;DIT_DESCRI"
	PUB_RIT    = "DIT_GRUPPO"

	DO FORM FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco gruppi"
	SELECT u_dis_tt
	GO TOP
	IF !EOF()
		STORE PUB_RIT TO _RET_VALORE
		____GRUPPO2 = DIT_GRUPPO
		____DESCRI2 = DIT_DESCRI		
		SELECT(_PJLIB_SELE_DIS)
		RETURN(_RET_VALORE)
	ENDIF

	*!*	__________________________________________________________________ACCESSO PER CODICE DESCRIZIONE ARTICOLO  

	x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
	x_desc = "dit_descri = '" + ALLTRIM(_____GRUPPO) + "'"
	x_des1 = "dit_descri like '" + ALLTRIM(_____GRUPPO) + "%'"
	cSql   = "select * from u_dis_tt where " + x_soci + " and "  + x_desc + ;
	                                       " order by dit_codsoc,dit_descri"
	cSql_1 = "select * from u_dis_tt where " + x_soci + " and "  + x_des1 + ;
	                                       " order by dit_codsoc,dit_descri"
	PUB_SELECT = "u_dis_tt"
	PUB_SEEK   = cSql+";"+cSql_1
	PUB_TESTA  = "Gruppo;Descrizione"
	PUB_VISTA  = "DIT_GRUPPO;DIT_DESCRI"
	PUB_RIT    = "DIT_GRUPPO"

	DO FORM FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco gruppi"
	IF !EOF()
		STORE PUB_RIT TO _RET_VALORE
		____GRUPPO2 = DIT_GRUPPO
		____DESCRI2 = DIT_DESCRI		
		SELECT(_PJLIB_SELE_DIS)
		RETURN(_RET_VALORE)
	ENDIF



ENDIF


*!*	___________________ NON TROVATO NULLA
STORE PUB_RIT TO _RET_VALORE
____GRUPPO2 = ''
____DESCRI2 = ''	
SELECT(_PJLIB_SELE_DIS)
RETURN(_RET_VALORE)




*********************************************************************************************
* funzione per la gestione della licenza software Erp Aquarius
*********************************************************************************************
FUNCTION licenza_software

_pjlib_license=SELECT()

XDTODIERNA = SUBSTR(RIBALTA2(DTOC(DATE())),1,4)+;
			 SUBSTR(RIBALTA2(DTOC(DATE())),6,2)+;
			 SUBSTR(RIBALTA2(DTOC(DATE())),9,2)


*=> Gestione licenza software
xxSql   = "select * from u_lic_an"
IF !ExecCommand(xxSql,"CUR_LICENZA")
   return(.f.)
ENDIF
SELECT CUR_LICENZA

AUTORIZZATO_A_CONTINUARE = .T.

dataScadenza = ribalta2(CUR_LICENZA.AZI_DTSCAD)

XSCADENZA = SUBSTR(TRIM(CUR_LICENZA.AZI_DTSCAD),1,4)+;
			SUBSTR(TRIM(CUR_LICENZA.AZI_DTSCAD),6,2)+;
			SUBSTR(TRIM(CUR_LICENZA.AZI_DTSCAD),9,2)

**xScadenza = "20140615"

*!*	La licenza scade nei prossimi 30 gg
IF BETWEEN(VAL(XSCADENZA) - VAL(XDTODIERNA),1,100)
	DO FORM form\scadenza WITH 'smiley_32.GIF',165,604,'1',dataScadenza  
	AUTORIZZATO_A_CONTINUARE = .T.
ENDIF



	
SELECT(_pjlib_license)

RETURN (AUTORIZZATO_A_CONTINUARE)


*********************************************************************************************
* SEEK_SCHEDE_SDS()	funzione per la gestione della tabella SCHEDE_SDS
*********************************************************************************************
* La funzione restituisce dalla tabella U_AGE_AN, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_schede_sds
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PCOUNT() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_schede_sds"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT * FROM schede_sds where sds_codsoc+sds_codice = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM schede_sds where sds_codsoc+sds_descsds like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Versione;Descrizione scheda SDS"
PUB_VISTA  = "sds_codice;sds_version;sds_descsds"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco agenti"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)






***********************************
PROCEDURE SPLIT
***********************************

PARAMETERS paArr, pcLine, pcDiv
PRIVATE lnLen, lnWid, lnCnt, lnNum, lnStrt, lnPos, lcSub
  lnLen = aLen( paArr, 1 ) && Number of rows
  lnWid = aLen( paArr, 2 ) && Number of cols
  
  lnCnt = OCCURS( pcDiv, pcLine+pcDiv )
  if lnLen < lnCnt
    if lnWid > 0
      DIMENSION paArr[ lnCnt, lnWid ]
    else
      DIMENSION paArr[ lnCnt ]
    endif
  endif
  lnStrt = 1
  lnNum  = 0
  do While atc( pcDiv, pcLine+pcDiv, lnNum+1 ) > 0
    lnNum = lnNum + 1
    lnPos = atc( pcDiv, pcLine+pcDiv, lnNum )
    if lnStrt > len(pcLine) && 9/23/99 wgcs
      lcSub = ''
    else
      lcSub = Substr( pcLine, lnStrt, lnPos-lnStrt )
    endif
    lnStrt = lnPos + len(pcDiv)
    if lnWid > 0
      paArr[ lnNum, 1 ] = lcSub
    else
      paArr[ lnNum ] = lcSub
    endif
  enddo
    
RETURN lnCnt

*-----------------------------------------------------------------------
PROCEDURE IsInternetConnected
LPARAMETERS lcAddress, lcError

LOCAL llSuccess
LOCAL loExc as Exception

IF VARTYPE(gl_ws2_32) <> "L"
  TRY
    DECLARE INTEGER WSACleanup IN ws2_32
    DECLARE STRING inet_ntoa IN ws2_32 INTEGER in_addr
    DECLARE INTEGER gethostbyname IN ws2_32 STRING host
    DECLARE INTEGER WSAStartup IN ws2_32 INTEGER wVerRq, STRING lpWSAData
    DECLARE RtlMoveMemory IN kernel32 As CopyMemory;
	  STRING @Dest, INTEGER Src, INTEGER nLength
    PUBLIC gl_ws2_32
    gl_ws2_32 = .T.
    llSuccess = .T.
  CATCH TO loExc
    lcError = TRANSFORM(loExc.ErrorNo) + " " + loExc.Message
  ENDTRY
ELSE
  llSuccess = .T.
ENDIF

IF m.llSuccess AND WSAStartup(0x202, Repli(Chr(0),512)) = 0  && initiates use of WS2_32.DLL
  llSuccess = GetIP('microsoft.com') <> "0.0.0.0"
  = WSACleanup()
ENDIF

RETURN m.llSuccess


*-----------------------------------------------------------------------
FUNCTION GetIP(cServer)
* returns IP like 127.0.0.1 for a given host name like www.somewhere.com
#DEFINE HOSTENT_SIZE 16
	LOCAL nStruct, nSize, cBuffer, nAddr, cIP
	nStruct = gethostbyname(cServer)
	IF nStruct = 0
	* not found in a host database; or not connected etc.
		RETURN '0.0.0.0'
	ENDIF

	cBuffer = Repli(Chr(0), HOSTENT_SIZE)
	cIP = Repli(Chr(0), 4)

	= CopyMemory(@cBuffer, nStruct, HOSTENT_SIZE)
	= CopyMemory(@cIP, buf2dword(SUBS(cBuffer,13,4)),4)
	= CopyMemory(@cIP, buf2dword(cIP),4)
RETURN inet_ntoa(buf2dword(cIP))

FUNCTION buf2dword(lcBuffer)
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
	Bitlshift(Asc(SUBS(lcBuffer, 2,1)),8) +;
	Bitlshift(Asc(SUBS(lcBuffer, 3,1)),16) +;
	Bitlshift(Asc(SUBS(lcBuffer, 4,1)),24)
