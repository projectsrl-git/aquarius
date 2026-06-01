
WAIT WINDOWS "Ricerca ordini aperti pannelli truciolari da ricodificare" NOWAIT

cSql = ""
TEXT TO cSql NOSHOW
	SELECT TT.ORD_NUMORD,TT.ORD_DATORD,DD.ORD_CODART,DD.ORD_CODMAT,DD.* FROM U_ORD_DD AS DD
	LEFT OUTER JOIN U_ORD_TT AS TT ON DD.DAGGANCIO = TT.TAGGANCIO
	WHERE
	DD.ORD_DESART <> '*** COMMENTO ***'
	AND DD.ORD_CHIUSO = 0
	AND TT.ORD_CHIUSO = 0
	AND DD.ORD_CODMAT = '008'
	AND DD.ORD_SPESSO > 0
	AND DD.ORD_ALTEZZ > 0
	AND DD.ORD_LUNGHE > 0
	--AND DD.ORD_LEGSYS NOT IN (SELECT ORD_LEGSYS FROM U_BOL_DD WHERE ORD_DESART <> '*** COMMENTO ***')
	AND LEN(DD.ORD_CODART) = 15
	ORDER BY DD.ORD_CODART
ENDTEXT
IF !ExecPreparedCommand(cSql,"CU_ORDINI")
	return(.F.)
ENDIF
SELECT CU_ORDINI
GO TOP
WAIT CLEAR
IF EOF()
	MESSAGEBOX("Nessun ordine con vecchia codifica da ricodificare",64,"Informazione")
	RETURN .F.
ENDIF

_risp = MESSAGEBOX("Procedere alla ricodifica di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " righe ordine?",4+32,"Attenzione")
IF _risp = 6
ELSE
	MESSAGEBOX("Operazione abbandonata",48,"Attenzione")
	RETURN .F.
ENDIF

_RIGHE_ORDINE_AGGIORNATE = 0

SELECT CU_ORDINI
GO TOP
SCAN
	
	WAIT WINDOWS "Elaborazione in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	SCATTER MEMVAR MEMO
	
	_VECCHIO_CODICE_ARTICOLO = ALLTRIM(M.ORD_CODART)
	_TIPO_GREZZO_NOBILITATO = SUBSTR(M.ORD_CODART,1,1)
	_NUOVO_TIPO_GREZZO_NOBILITATO = ""
	
	DO CASE
		CASE _TIPO_GREZZO_NOBILITATO = '#' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0#'
		CASE _TIPO_GREZZO_NOBILITATO = '0' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'BG'
		CASE _TIPO_GREZZO_NOBILITATO = '1' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'AA'
		CASE _TIPO_GREZZO_NOBILITATO = '2' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'BA'
		CASE _TIPO_GREZZO_NOBILITATO = '3' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'CA'
		CASE _TIPO_GREZZO_NOBILITATO = '4' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'DA'
		CASE _TIPO_GREZZO_NOBILITATO = '5' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'FA'
		CASE _TIPO_GREZZO_NOBILITATO = '6' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'BB'
		CASE _TIPO_GREZZO_NOBILITATO = '7' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'IB'
		CASE _TIPO_GREZZO_NOBILITATO = '8' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'AB'
		CASE _TIPO_GREZZO_NOBILITATO = '9' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'DB'
		CASE _TIPO_GREZZO_NOBILITATO = 'A' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'AC'
		CASE _TIPO_GREZZO_NOBILITATO = 'B' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'BC'
		CASE _TIPO_GREZZO_NOBILITATO = 'C' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'CC'
		CASE _TIPO_GREZZO_NOBILITATO = 'D' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'DC'
		CASE _TIPO_GREZZO_NOBILITATO = 'E' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'FC'
		CASE _TIPO_GREZZO_NOBILITATO = 'F' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0F'
		CASE _TIPO_GREZZO_NOBILITATO = 'G' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0G'
		CASE _TIPO_GREZZO_NOBILITATO = 'H' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'HA'
		CASE _TIPO_GREZZO_NOBILITATO = 'I' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'IA'
		CASE _TIPO_GREZZO_NOBILITATO = 'J' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0J'
		CASE _TIPO_GREZZO_NOBILITATO = 'K' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0K'
		CASE _TIPO_GREZZO_NOBILITATO = 'L' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0L'
		CASE _TIPO_GREZZO_NOBILITATO = 'M' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0M'
		CASE _TIPO_GREZZO_NOBILITATO = 'N' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0N'
		CASE _TIPO_GREZZO_NOBILITATO = 'O' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0O'
		CASE _TIPO_GREZZO_NOBILITATO = 'P' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0P'
		CASE _TIPO_GREZZO_NOBILITATO = 'Q' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0Q'
		CASE _TIPO_GREZZO_NOBILITATO = 'R' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0R'
		CASE _TIPO_GREZZO_NOBILITATO = 'S' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = '0S'
		CASE _TIPO_GREZZO_NOBILITATO = 'T' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'AG'
		CASE _TIPO_GREZZO_NOBILITATO = 'U' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'GA'
		CASE _TIPO_GREZZO_NOBILITATO = 'V' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'DE'
		CASE _TIPO_GREZZO_NOBILITATO = 'W' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'CE'
		CASE _TIPO_GREZZO_NOBILITATO = 'X' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'FE'
		CASE _TIPO_GREZZO_NOBILITATO = 'Y' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'FB'
		CASE _TIPO_GREZZO_NOBILITATO = 'Z' 
			_NUOVO_TIPO_GREZZO_NOBILITATO = 'AE'
		OTHERWISE
			SELECT CU_ORDINI
			LOOP
	ENDCASE
	
	_NUOVO_CODICE_ARTICOLO = _NUOVO_TIPO_GREZZO_NOBILITATO + ALLTRIM(SUBSTR(M.ORD_CODART,2))
	_DESCR_NUOVO_CODICE_ARTICOLO = ""
	
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + _NUOVO_CODICE_ARTICOLO + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select ART_CODPRI, ART_DESCR from U_ART_PR where " + x_cond
	IF !ExecCommand(cSql,"TMP_ART_PR")
	   RETURN .F.
	ENDIF
	SELECT TMP_ART_PR
	GO TOP
	IF EOF()
	
		IF !ExecCommand("select * from U_ART_PR where 0=1","U_ART_PR")		&& PUBLICIZZA E PULISCE LE VARIABILI DI U_ART_PR
		   return(.f.)
		ENDIF
		SELECT U_ART_PR 
		=DEFPUB(SELECT())
		SCATTER MEMVAR MEMO BLANK


		IF !ExecCommand("select * from U_ART_AN where 0=1","U_ART_AN")		&& PUBLICIZZA E PULISCE LE VARIABILI DI U_ART_AN
		   return(.f.)
		ENDIF
		SELECT U_ART_AN
		=DEFPUB(SELECT())
		SCATTER MEMVAR MEMO BLANK
		
		RELEASE _SE_MANCANO_DATI
		PUBLIC _SE_MANCANO_DATI 
		_SE_MANCANO_DATI = .F.

		RELEASE _ALTEZZ,_LUNGHE
		PUBLIC _ALTEZZ,_LUNGHE
		_ALTEZZ = ""
		_LUNGHE = ""
		
		RELEASE _CTRL_OPZIONALI
		PUBLIC _CTRL_OPZIONALI
		_CTRL_OPZIONALI = .T.

		RELEASE _descrizione_lunghezza_larghezza,_descrizione_altezza
		PUBLIC _descrizione_lunghezza_larghezza,_descrizione_altezza

		_descrizione_lunghezza_larghezza = ""
		_descrizione_altezza = ""

		RELEASE M.ART_TIPOG,M.ART_TIPON,M.ART_DESTIPOG,M.ART_DESTIPON,M.art_spesso,M.art_lunghe,M.art_altezz,m.art_codcol,m.art_codcolret,m.art_fini,m.art_scelta,m.art_desfini,m.art_descol,m.art_descolret,M.ART_GRUPRD
		public  M.ART_TIPOG,M.ART_TIPON,M.ART_DESTIPOG,M.ART_DESTIPON,M.art_spesso,M.art_lunghe,M.art_altezz,m.art_codcol,m.art_codcolret,m.art_fini,m.art_scelta,m.art_desfini,m.art_descol,m.art_descolret,M.ART_GRUPRD

		M.ART_TIPOG = ""
		M.ART_TIPON = ""
		M.ART_DESTIPOG = ""
		M.ART_DESTIPON = ""
		M.art_spesso = 0
		M.art_lunghe = 0
		M.art_altezz = 0
		m.art_codcol = ""
		m.art_codcolret = ""
		m.art_descol = ""
		m.art_descolret = ""
		m.art_fini = ""
		m.art_desfini = ""
		m.art_scelta = ""
		m.art_tiposcelta = ""
		m.art_destiposcelta = ""
		M.ART_GRUPRD = ""  && ERASMO - 08/07/2016
		
		****************************************************
		*** THISFORM.setta_variabili_anagrafica_articoli()
		****************************************************
		M.ART_CODSOC = PUB_CODSOC
		M.ART_CODPRI = _NUOVO_CODICE_ARTICOLO
		M.ART_UNIMIS = SPACE(02)
		M.ART_UMMAGA = SPACE(02)   
		M.ART_LINEA  = PUB_LINEA
		M.ART_PRZVEN = 0
		M.ART_PRZVE2 = 0
		M.ART_PRZVE3 = 0
		M.ART_PRZVE4 = 0
		M.ART_PRZVE5 = 0
		M.ART_PRZCOS = 0
		M.ART_CODIVA = PUB_IVA
		M.ART_MAGA   = PUB_CODM
		M.ART_PESOUM = 0
		M.ART_CGE    = SPACE(13)
		M.ART_CODF1  = SPACE(10)
		M.ART_CODF2  = SPACE(10)
		M.ART_CODF3  = SPACE(10)
		M.ART_NOTA1  = SPACE(20)
		M.ART_NOTA2  = SPACE(20)
		M.ART_NOTA3  = SPACE(20)
		M.ART_PRZCO1 = 0
		M.ART_PRZCO2 = 0
		M.ART_PRZCO3 = 0
		M.ART_DATINS = RIBALTA2(DTOC(DATE()))
		M.ART_CODVAL = PUB_VALU
		M.ART_ULDCAR = SPACE(10)
		M.ART_ULPCAR = 0
		M.ART_CATMER = SPACE(03)
		M.ART_DESMER = SPACE(50)
		M.ART_CODMAT = "001"
		M.ART_DESMAT = SPACE(50)
		M.ART_CODIMB = SPACE(03)
		M.ART_DESIMB = SPACE(50)
		M.ART_DATVAR = RIBALTA2(DTOC(DATE()))
		M.ART_DESMAT = SPACE(50)
		M.ART_TIPART = 'P'
		M.ART_DISBAS = ' '
		M.ART_RIPCOM = ' '
		M.ART_CODCOL = SPACE(03)
		M.ART_DESCOL = SPACE(50)
		M.ART_DESRID = SPACE(50)
		
		M.ART_SPESSO = 0
		M.ART_ALTEZZ = 0
		M.ART_LUNGHE = 0
		M.ART_LOTMIN = 0
		M.ART_CDDIBA = SPACE(16)
		M.ART_DSDIBA = SPACE(50)
		M.ART_UMMAGA = SPACE(02)
		M.ART_UMMAGA = "MC"
		M.ART_UNIMIS = "MC"

		M.ART_SCELTA 	= ""
		M.ART_FINI 		= ""
		M.ART_CODCOLRET 	= ""
		M.ART_TIPOG 		= "" 
		M.ART_TIPON 		= ""

		M.ART_GRUPRD 	= ""
		
			
		M.ART_SPESSO = M.ORD_SPESSO
		M.ART_ALTEZZ = M.ORD_ALTEZZ
		M.ART_LUNGHE = M.ORD_LUNGHE
		M.ART_CODCOL = SUBSTR(_VECCHIO_CODICE_ARTICOLO,8,3)
		M.ART_CODCOLRET = SUBSTR(_VECCHIO_CODICE_ARTICOLO,11,3)
		M.ART_FINI 	 = SUBSTR(_VECCHIO_CODICE_ARTICOLO,14,1)
		M.ART_SCELTA = SUBSTR(_VECCHIO_CODICE_ARTICOLO,15,1)
		
		IF SUBSTR(_VECCHIO_CODICE_ARTICOLO,8,7) = "0000000"
			M.ART_TIPOG = _NUOVO_TIPO_GREZZO_NOBILITATO
		ELSE
			M.ART_TIPON = _NUOVO_TIPO_GREZZO_NOBILITATO 
		ENDIF
		
		IF EMPTY(ALLTRIM(M.ART_TIPOG))
			M.ART_DESTIPOG = ''
		ELSE
			cSql = "SELECT * FROM PARA WHERE CODICE = 'TIG" + M.ART_TIPOG + "'"
			IF !ExecCommand(cSql,"CX_PARA")
			   return(.f.)
			ENDIF
			SELECT CX_PARA
			GO TOP
			IF !EOF()
				M.ART_DESTIPOG = ALLTRIM(DESCRI)
			ENDIF
		ENDIF
		
		IF EMPTY(ALLTRIM(M.ART_TIPON))
			M.ART_DESTIPON = ''
		ELSE
			cSql = "SELECT * FROM PARA WHERE CODICE = 'TNO" + M.ART_TIPON + "'"
			IF !ExecCommand(cSql,"CX_PARA")
			   return(.f.)
			ENDIF
			SELECT CX_PARA
			GO TOP
			IF !EOF()
				M.ART_DESTIPON = ALLTRIM(DESCRI)
			ENDIF
		ENDIF
		
		IF EMPTY(ALLTRIM(M.ART_CODCOL))
			M.ART_DESCOL = ''
		ELSE
			cSql = "SELECT * FROM PARA WHERE CODICE = 'COL" + M.ART_CODCOL + "'"
			IF !ExecCommand(cSql,"CX_PARA")
			   return(.f.)
			ENDIF
			SELECT CX_PARA
			GO TOP
			IF !EOF()
				M.ART_DESCOL = ALLTRIM(DESCRI)
			ENDIF
		ENDIF
		
		IF EMPTY(ALLTRIM(M.ART_CODCOLRET))
			M.ART_DESCOLRET = ''
		ELSE
			cSql = "SELECT * FROM PARA WHERE CODICE = 'COL" + M.ART_CODCOLRET + "'"
			IF !ExecCommand(cSql,"CX_PARA")
			   return(.f.)
			ENDIF
			SELECT CX_PARA
			GO TOP
			IF !EOF()
				M.ART_DESCOLRET = ALLTRIM(DESCRI)
			ENDIF
		ENDIF
		
		IF EMPTY(ALLTRIM(M.ART_FINI))
			M.ART_DESFINI = ''
		ELSE
			cSql = "SELECT * FROM PARA WHERE CODICE = 'FIN" + M.ART_FINI + "'"
			IF !ExecCommand(cSql,"CX_PARA")
			   return(.f.)
			ENDIF
			SELECT CX_PARA
			GO TOP
			IF !EOF()
				M.ART_DESFINI = ALLTRIM(DESCRI)
			ENDIF
		ENDIF
		
				
		***********************************************
		*** thisform.compone_codice_articolo_dinamico()
		***********************************************
		M.ART_SPESSO = M.ord_spesso

		X_ALTEZZ= ALLTRIM(STR(M.ORD_ALTEZZ,4,0))
		x_tipt  = "SUBSTRING(CODICE,1,3) = 'CLA'" 
		x_dime = "libera = '" + X_ALTEZZ + "'"  
		x_cond  = x_tipt + " and " + x_dime
		Csql    = "SELECT * FROM PARA WHERE " + x_cond
		IF !ExecCommand(cSql,"cu_para_cla")
		   return(.f.)
		ENDIF
		SELECT cu_para_cla
		GO TOP
		IF EOF()
		ELSE
			_ALTEZZ  = ALLTRIM(SUBSTR(CODICE,4,3))
		    _DESCRIZIONE_ALTEZZA = UPPER(DESCRI)
		ENDIF  

		X_LUNGHE= ALLTRIM(STR(M.ORD_LUNGHE,4,0))
		x_tipt  = "SUBSTRING(CODICE,1,3) = 'CLU'" 
		x_dime = "libera = '" + X_LUNGHE + "'"  
		x_cond  = x_tipt + " and " + x_dime
		Csql    = "SELECT * FROM PARA WHERE " + x_cond
		IF !ExecCommand(cSql,"cu_para_clu")
		   return(.f.)
		ENDIF
		SELECT cu_para_clu
		GO TOP
		IF EOF()
		ELSE
			_LUNGHE = ALLTRIM(SUBSTR(CODICE,4,3))
			_DESCRIZIONE_LUNGHEZZA_LARGHEZZA  = UPPER(ALLTRIM(DESCRI))
		ENDIF

		IF (EMPTY(ALLTRIM(m.art_codcol)) OR ALLTRIM(m.art_codcol) = '0')
			_art_codcol = '000'
		ELSE
			_art_codcol = ALLTRIM(m.art_codcol)
		ENDIF

		IF (EMPTY(ALLTRIM(m.art_codcolret)) OR ALLTRIM(m.art_codcolret) = '0')
			_art_codcolret = '000'
		ELSE
			_art_codcolret = ALLTRIM(m.art_codcolret)
		ENDIF

		IF (EMPTY(ALLTRIM(m.art_fini)) OR ALLTRIM(m.art_fini) = '0')
			_art_fini = '0'
		ELSE
			_art_fini = ALLTRIM(m.art_fini)
		ENDIF

		IF EMPTY(ALLTRIM(M.ART_TIPOG))
			M.ART_DESTIPOG = ''
		ENDIF
		IF EMPTY(ALLTRIM(M.ART_TIPON))
			M.ART_DESTIPON = ''
		ENDIF
		IF EMPTY(ALLTRIM(M.ART_CODCOL))
			M.ART_DESCOL = ''
		ENDIF
		IF EMPTY(ALLTRIM(M.ART_CODCOLRET))
			M.ART_DESCOLRET = ''
		ENDIF
		IF EMPTY(ALLTRIM(M.ART_FINI))
			M.ART_DESFINI = ''
		ENDIF


		* TOLGO ULTIMO 0 ALLO SPESSORE PER COMPORRE IL CODICE
		*!*	__ART_SPESSO = ALLTRIM(STR(M.ART_SPESSO/10))
		__ART_SPESSO = ALLTRIM(STR(M.ART_SPESSO))

		IF LEN(ALLTRIM(__ART_SPESSO )) = 1
			__ART_SPESSO = "0" + __ART_SPESSO 
		ENDIF

		__ART_ALTEZZ = ALLTRIM(_ALTEZZ)
		__ART_LUNGHE = ALLTRIM(_LUNGHE)
		__ART_SCELTA = ""


		IF !EMPTY(ALLTRIM(M.ART_SCELTA))
		    IF ALLTRIM(M.ART_SCELTA) = '4' OR ALLTRIM(M.ART_SCELTA) = '5'	&& BARRIERATO
				DO CASE 
					CASE ALLTRIM(M.ART_SCELTA) = '4'						&& BARRIERATO DI PRIMA SCELTA
						__ART_SCELTA = 'BARR. 1'+'^'		
					CASE ALLTRIM(M.ART_SCELTA) = '5'						&& BARRIERATO DI SECONDA SCELTA
						__ART_SCELTA = 'BARR. 2'+'^'		
				ENDCASE
		    ELSE
				__ART_SCELTA = ALLTRIM(M.ART_SCELTA)+'^'
			ENDIF
		ENDIF


		_SE_MANCANO_DATI = .F.
		IF VAL(__ART_SPESSO) = 0
			_SE_MANCANO_DATI = .T.
		ENDIF

		IF EMPTY(__ART_ALTEZZ)
			_SE_MANCANO_DATI = .T.
		ENDIF

		IF EMPTY(__ART_LUNGHE)
			_SE_MANCANO_DATI = .T.
		ENDIF



		M.ART_TIPO 		= ALLTRIM(M.ART_TIPOG) + ALLTRIM(M.ART_TIPON)
		M.ART_DESTIPO 	= ALLTRIM(M.ART_DESTIPOG) + ALLTRIM(M.ART_DESTIPON)
		M.ART_CODPRI 	= ALLTRIM(M.ART_TIPOG) + ALLTRIM(M.ART_TIPON) + ALLTRIM(__ART_SPESSO) + ALLTRIM(__ART_ALTEZZ) + ALLTRIM(__ART_LUNGHE) + ALLTRIM(_ART_CODCOL) + ALLTRIM(_ART_CODCOLRET) + ALLTRIM(_ART_FINI) + ALLTRIM(M.ART_SCELTA) 

		IF ALLTRIM(_ART_CODCOL) <> ALLTRIM(_ART_CODCOLRET)
			M.ART_DESCR 	= ALLTRIM(M.ART_DESTIPOG) + ALLTRIM(M.ART_DESTIPON) + ' ' +ALLTRIM(M.ART_DESCOL)+ ' ' +ALLTRIM(M.ART_DESCOLRET) +' '+ ALLTRIM(M.ART_DESFINI) +' '+ALLTRIM(__ART_SCELTA) 
		ELSE
			M.ART_DESCR 	= ALLTRIM(M.ART_DESTIPOG) + ALLTRIM(M.ART_DESTIPON) + ' ' +ALLTRIM(M.ART_DESCOL)+ ' ' +ALLTRIM(M.ART_DESFINI) +' '+ALLTRIM(__ART_SCELTA) 
		ENDIF 

		M.ORD_CODART    = M.ART_CODPRI
		M.ORD_DESART    = M.ART_DESCR 
		
		
		***************************************
		*** thisform.crea_anagrafica_articoli()
		***************************************		
		M.ART_CODMAT = "008" 		&& LEGNO TRUCCIOLARE
		*** AUTOMAZIONE PER INIZIALIZZAZIONE CAMPI DI DEFAULT DAL TIPO DI MATERIALE IDENTIFICO UNITA MISURA E TIPO PRODOTTO DI PRODUZIONE O NO
		_CODMAT = ALLTRIM(M.ART_CODMAT)
		x_codi = "codice = 'MAT" + _CODMAT + "'"
		Csql   = "select * from para where " + x_codi
		IF !ExecCommand(cSql,"CX_PARA")
		   return(.f.)
		ENDIF
		SELECT CX_PARA
		GO TOP
		IF EOF()
		   	_LIBERA = ""
			M.ART_DESMAT = ""   
		ELSE
		   	_LIBERA = LIBERA
			M.ART_DESMAT = UPPER(DESCRI) 
			M.ART_DESMAT = APITOSPA(M.ART_DESMAT)  
		ENDIF  
		M.ART_UNIMIS = TOKENIZER(_LIBERA,"UM_ACQUISTO")
		M.ART_UMMAGA = TOKENIZER(_LIBERA,"UM_MAGAZZINO")
		M.ART_TIPART = TOKENIZER(_LIBERA,"TIPO_ARTICOLO")

		IF !EMPTY(ALLTRIM(M.ART_TIPON))
			M.ART_UNIMIS = "MQ"						&& SE NOBILITATO GESTISCO SOLO MQ
			M.ART_UMMAGA = "MQ"						&& SE NOBILITATO GESTISCO SOLO MQ
		ENDIF

		** DETERMINO CATEGORIA MERCEOLOGICA

		_CODCOL = ALLTRIM(M.ART_CODCOL)
		x_codi = "codice = 'COL" + _CODCOL + "'"
		Csql   = "select * from para where " + x_codi
		IF !ExecCommand(cSql,"CX_PARA")
		   return(.f.)
		ENDIF
		SELECT CX_PARA
		GO TOP
		IF EOF()
		   	_LIBERA = ""
		ELSE
		   	_LIBERA = LIBERA
		ENDIF

		_GRUPPO_COLORE_ = SUBSTR(_LIBERA,1,1)

		IF EMPTY(ALLTRIM(_GRUPPO_COLORE_))

		    *MESSAGEBOX("Articolo con colore fronte " + M.ART_CODCOL + " SENZA GRUPPO COLORE : sei sicuro del codice articolo ?? ",16,"*** ATTENZIONE ***")  

			M.ART_CATMER = ""		&& ARTICOLO SENZA CATEGORIA MERCEOLOGICA 
		   	M.ART_DESMER = ""

		ELSE 

			IF !EMPTY(M.ART_TIPOG)
				M.ART_CATMER = "1"+SUBSTR(M.ART_TIPOG,1,1)+"X"
			ELSE
				M.ART_CATMER = "00"+_GRUPPO_COLORE_ 
			ENDIF

			_CODCME = ALLTRIM(M.ART_CATMER)
			x_codi = "codice = 'MER" + _CODCME + "'"
			Csql   = "select * from para where " + x_codi
			IF !ExecCommand(cSql,"CX_PARA")
			   return(.f.)
			ENDIF
			SELECT CX_PARA
			GO TOP
			IF EOF()
			   	M.ART_DESMER = ""
			ELSE
			   	M.ART_DESMER = UPPER(DESCRI)
			ENDIF  


			M.ART_DESMER = APITOSPA(M.ART_DESMER)


		ENDIF


		__TIPO_ 	= M.ART_CODMAT
		__SPESSO_ 	= M.ART_SPESSO
		__TIPON_  	= M.ART_TIPON
		M.ART_MAGA  = DETERMINA_MAGAZZINO(__TIPO_,__SPESSO_,__TIPON_)


		*!*	______

		M.ORD_CODART = M.ART_CODPRI
		M.ORD_DESART = M.ART_DESCR 
		_VERIFICA_ESISTENZA_ARTICOLO = .T.

		*!*	______


		x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "art_codpri = '" + M.ART_CODPRI + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "select * from U_ART_PR where " + x_cond + " order by art_codsoc,art_codpri"

		IF !ExecCommand(cSql,"U_ART_PR")
		   RETURN .F.
		ENDIF

		SELECT U_ART_PR 
		GO TOP
		IF EOF()
			APPEND BLANK
			GATHER MEMVAR memo
			REPLACE ID_UNIQUE WITH ""
			IF !ExecRW('','U_ART_PR','I','','U_ART_PR')
			  return(.f.)
			ENDIF	
		ENDIF

		x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "art_codpri = '" + M.ART_CODPRI + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "select * from U_ART_AN where " + x_cond + " order by art_codsoc,art_codpri"

		IF !ExecCommand(cSql,"U_ART_AN")
		   RETURN .F.
		ENDIF

		SELECT U_ART_AN
		GO TOP
		IF EOF()
			
			APPEND BLANK
			GATHER MEMVAR memo
			REPLACE ID_UNIQUE WITH ""
			IF !ExecRW('','U_ART_AN','I','','U_ART_AN')
			  return(.f.)
			ENDIF
			
			_NO_MESSAGE = .T.
			VERIFICA_E_CREA_DISTINTA_BASE(M.ART_CODPRI,_NO_MESSAGE)
		ENDIF
		
	ENDIF
	
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + _NUOVO_CODICE_ARTICOLO + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select ART_CODPRI, ART_DESCR from U_ART_PR where " + x_cond
	IF !ExecCommand(cSql,"TMP_ART_PR")
	   RETURN .F.
	ENDIF
	SELECT TMP_ART_PR
	GO TOP
	IF EOF()
		SELECT CU_ORDINI
		LOOP
	ELSE
		_DESCR_NUOVO_CODICE_ARTICOLO = ALLTRIM(ART_DESCR)
	ENDIF
	
	Csql = "UPDATE U_ORD_DD SET ORD_CODART = '" + _NUOVO_CODICE_ARTICOLO + "', ORD_DESART = '" + STRTRAN(_DESCR_NUOVO_CODICE_ARTICOLO,"'","''") + "' WHERE ORD_CODSYS = '" + ALLTRIM(M.ORD_CODSYS) + "'"
	IF !ExecCommand(cSql,"UPD_ORD_DD")
		SET STEP ON
	   return(.f.)
	ENDIF
	
	_RIGHE_ORDINE_AGGIORNATE = _RIGHE_ORDINE_AGGIORNATE + 1

ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione completata" + REPLICATE(CHR(13),2) + ;
	"Totale righe ordine aggiornate: " + ALLTRIM(STR(_RIGHE_ORDINE_AGGIORNATE,10,0)),64,"Informazione")

RETURN

