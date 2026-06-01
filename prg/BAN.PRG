
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
*		_fasciacompetenza	= blank : tutte le banche
*		_fasciacompetenza	= "S"   : Banche di presentazione  
*					   
*********************************************************************************************
FUNCTION seek_u_ban_an
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_FASCIACOMPETENZA
IF PARAMETERS() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF PARAMETERS() <= 7
	_FASCIACOMPETENZA = "ALL"
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

IF _FASCIACOMPETENZA = 'ALL'
ELSE
   _seek = _SEEK + " AND BAN_PRESE = '" + ALLTRIM(_FASCIACOMPETENZA) + "'"
   _seek1 = _SEEK1 + " AND BAN_PRESE = '" + ALLTRIM(_FASCIACOMPETENZA) + "'"
ENDIF   

cSql 	= "SELECT * FROM u_ban_an where ban_codsoc+ban_codban = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM u_ban_an where ban_codsoc+ban_desban like "+_seek1+" order by "+_ordinamento


	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "ban_codban;ban_desban"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco banche"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)

