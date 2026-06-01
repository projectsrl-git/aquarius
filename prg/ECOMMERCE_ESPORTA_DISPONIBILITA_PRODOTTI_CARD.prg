
LPARAMETERS _par_scheduled_codsys,_par_articoli

_LOG_CODSYS = SYS(2015)
IF PCOUNT() = 0
	_LOG_CODSYS = SYS(2015)
ELSE
	IF !ISNULL(_par_scheduled_codsys) AND !EMPTY(_par_scheduled_codsys)
		_LOG_CODSYS = _par_scheduled_codsys
	ENDIF
ENDIF

IF PCOUNT() >= 2
ELSE
	_par_articoli = ""
ENDIF

IF EMPTY(PUB_ECURL) OR EMPTY(PUB_ECAUTK) OR EMPTY(PUB_ECMAGA)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'E-commerce REST API Authentication'",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() >= 1
ELSE
	_RISP = MESSAGEBOX("Esportare le disponibilità dei prodotti su e-commerce?",4+32,"Attenzione")
	IF _RISP = 7
		RETURN .F.
	ENDIF
ENDIF

_LOG_PROCEDURA = "ESPORTA_DISP"
_MESSAGGIO = "1 - Inizio procedura"
DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO

_endpoint_url = ALLTRIM(PUB_ECURL)
_auth_key = ALLTRIM(PUB_ECAUTK)

WAIT WINDOWS "Elaborazione disponibilità magazzino " + ALLTRIM(PUB_ECMAGA) + " in corso..." NOWAIT

_HTTP_request = _endpoint_url+"/update_qty"	
_cJson = ""
_cProductsQty = ""

*x_yesw = "AN.ART_ECOMM = 1"
x_yesw = "AN.ART_ECOMM = 1 AND PR.ART_NONMOV = 0"  && ERASMO - 27/05/2022
IF !EMPTY(_par_articoli)
	IF "'" $ _par_articoli
		x_arti = "PR.ART_CODPRI IN (" + ALLTRIM(_par_articoli) + ")"  && FILTRO SU ARTICOLI MULTIPLI
	ELSE
		x_arti = "PR.ART_CODPRI = '" + ALLTRIM(_par_articoli) + "'"  && FILTRO SU ARTICOLO SINGOLO
	ENDIF
ELSE
	x_arti = "1=1"
ENDIF
x_cond = x_yesw + " and " + x_arti 
cSql   = "select PR.ART_CODPRI,PR.ART_CODMAT from U_ART_PR AS PR LEFT OUTER JOIN U_ART_AN AS AN ON PR.ART_CODPRI = AN.ART_CODPRI where " + x_cond + " ORDER BY PR.ART_CODPRI"
IF !ExecCommand(cSql,"TMP_ART_AN")
	return(.f.)
ENDIF
SELECT TMP_ART_AN
GO TOP
SCAN
	
	_PRODOTTO = ALLTRIM(ART_CODPRI)
	_CODMAT = ALLTRIM(ART_CODMAT)
	
	WAIT WINDOWS "Elaborazione disponibilità magazzino " + ALLTRIM(PUB_ECMAGA) + " - Prodotto " + _PRODOTTO + " ..." NOWAIT
	
	IF UPPER(ALLTRIM(_CODMAT)) == "BUN" && ARTICOLO BUNDLE
	
*!*			_CODART_BUNDLE = _PRODOTTO
*!*			
*!*			*** VERIFICA ESISTENZA COMPOSIZIONE DI.BA.
*!*			x_grup = "DIS.DIS_GRUPPO = '" + _CODART_BUNDLE + "'"
*!*			x_disq = "DIS.DIS_QTA > 0"
*!*			x_nomo = "ANA.ART_NONMOV = 0"
*!*			x_cond = x_grup + " and " + x_disq + " and " + x_nomo 
*!*			cSql   = "SELECT DIS.DIS_CODART, ANA.ART_DESCR, DIS.DIS_QTA FROM U_DIS_DD AS DIS " + CHR(13) + ;
*!*			         "RIGHT OUTER JOIN U_ART_PR AS ANA ON ANA.ART_CODPRI = DIS.DIS_CODART " + CHR(13) + ;
*!*			         "RIGHT OUTER JOIN U_DIS_TT AS DIT ON DIT.TAGGANCIO = DIS.DAGGANCIO " + CHR(13) + ;
*!*			         "WHERE " + x_cond + " ORDER BY DIS.DIS_SEQUEN"
*!*			IF !ExecCommand(cSql,"BUN_DIS_DD")
*!*			  return(.f.)
*!*			ENDIF
*!*			SELECT BUN_DIS_DD
*!*			GO TOP
*!*			IF !EOF()
*!*				_CONSISTENZA = 9999999999
*!*				SELECT BUN_DIS_DD
*!*				GO TOP
*!*				SCAN
*!*					_PRODOTTO_COMPONENTE = ALLTRIM(DIS_CODART)
*!*					_CONSISTENZA = MIN(_CONSISTENZA,CERCA_CONSISTENZA_PER_ECOMMERCE_AD_OGGI(_PRODOTTO_COMPONENTE))
*!*				ENDSCAN
*!*				_cProductsQty = _cProductsQty + IIF(EMPTY(_cProductsQty),'',',') + '{"code":"' + _PRODOTTO + '", "qty":' + STRTRAN(ALLTRIM(STR(ROUND(_CONSISTENZA,2),16,2)),',','.') + '}'
*!*			ENDIF
	ELSE
		_CONSISTENZA = CERCA_CONSISTENZA_PER_ECOMMERCE_AD_OGGI(_PRODOTTO)	
		_cProductsQty = _cProductsQty + IIF(EMPTY(_cProductsQty),'',',') + '{"code":"' + _PRODOTTO + '", "qty":' + STRTRAN(ALLTRIM(STR(ROUND(_CONSISTENZA,2),16,2)),',','.') + '}'
	ENDIF
	
ENDSCAN

WAIT WINDOWS "Completamento Elaborazione disponibilità magazzino " + ALLTRIM(PUB_ECMAGA) + " in corso..." NOWAIT

IF !EMPTY(_cProductsQty)
	
	WAIT WINDOWS "Connessione a '"+_HTTP_request+"' per aggiornare disponibilità prodotti in corso..." NOWAIT
	
	_json_content = '{"products":[' + _cProductsQty + ']}'

	_cJson = ECOMMREST_POST(_HTTP_request,_auth_key,_json_content)
	IF EMPTY(_cJson)
		_MESSAGGIO = "Nessuna risposta da '"+_nomesito+_HTTP_request+"': verificare la URL e che sia disponibile una connessione internet"
		DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
		WAIT WINDOWS _MESSAGGIO TIMEOUT 3
		RETURN .F.
	ENDIF

	IF SUBSTR(_cJson,1,2) == "KO"
		_MESSAGGIO = "Errore " + ALLTRIM(SUBSTR(_cJson,5))
		DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
		WAIT WINDOWS _MESSAGGIO TIMEOUT 3
		RETURN .F.
	ENDIF
	
	_MESSAGGIO = "2 - Disponibilità prodotti aggiornate" + CHR(13) + CHR(10) + _json_content
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
	
ELSE
	
	_MESSAGGIO = "2 - Nessun prodotto codificato per l'aggiornamento delle disponibilità"
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
	
ENDIF

_MESSAGGIO = "3 - Procedura terminata"
DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
WAIT WINDOWS _MESSAGGIO TIMEOUT 3

RETURN .T.

*************************************************
FUNCTION CERCA_CONSISTENZA_PER_ECOMMERCE_AD_OGGI
*************************************************
LPARAMETERS _par_product_code

LOCAL _RIT
_RIT = 0

_GIACENZA = 0
_CONSISTENZA = 0

_ww_codsoc = PUB_CODSOC
_ww_anaart = _par_product_code
_ww_codmag = ALLTRIM(PUB_ECMAGA)
_ww_prenot = .T.  && SOLO GIACENZE NON PRENOTATE
_ww_codint = ""
_ww_altezz = 0
_ww_lunghe = 0
_ww_fila_x = ""
_ww_pian_x = ""
_ww_ubic_x = ""
_ww_umrit = ""
_ww_escl_mag_scarto = .T.
_ww_waitview = .F.
_ww_datfin = DTOC(DATE())
_ww_solpre = .T.  && ERASMO - 11/03/2022

_GIACENZA_CO = 0
_CONSISTENZA = AQM_RILEVA_CONSISTENZA(_ww_codsoc,_ww_anaart,_ww_codmag,_ww_prenot,_ww_codint,_ww_altezz,_ww_lunghe,_ww_fila_x,_ww_pian_x,_ww_ubic_x,_ww_umrit,_ww_escl_mag_scarto,_ww_waitview,_ww_datfin,_ww_solpre)
_GIACENZA = _GIACENZA_CO

_RIT = _CONSISTENZA

RETURN _RIT
