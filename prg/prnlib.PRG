*****************************************************************************
*
* -->> Libreria delle procedure di stampa richiamate dalla toolbar nei vari
* -->> form.
*
* -->> Libreria delle procedure di stampa ETICHETTE richiamate dalla toolbar 
* -->> nei vari form.
*
* -->> per le etichette, cercare << SEZIONE ETICHETTE >>
*
*
*****************************************************************************



*****************************************************************************
PROCEDURE clista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg,.T. LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(17)
		*_V_SELECT = "U_CLI_AN"
		_V_SELECT = "V_CLI_AN"  && ERASMO - 17/03/2023
		_V_REPORT = "CLI000.FRX"
		A_LISTA[1]="RAG.SOCIALE;CLI_RAGSOC;C;40"
		A_LISTA[2]="COD.CLIENTE;CLI_CODCLI;C;10"
		A_LISTA[3]="INDIRIZZO;CLI_INDIR;C;30"
		A_LISTA[4]="C.A.P.;CLI_CAP;C;5"
		A_LISTA[5]="PART.IVA;CLI_PARIVA;C;11"
		A_LISTA[6]="TELEFONO;CLI_TELEFO;C;20"
		A_LISTA[7]="COD.AGENTE;CLI_AGE;C;3"
		A_LISTA[8]="RICERCA ALTERNATIVA;CLI_RICERC;C;10"
		A_LISTA[9]="CODICE NAZIONE;CLI_NAZION;C;3"
		A_LISTA[10]="LOCALITÀ;CLI_LOCALI;C;20"
		A_LISTA[11]="BANCA FORN.;CLI_BAEFOR;C;5"
		A_LISTA[12]="BANCA CLIENTE;CLI_BAE;C;5"
		A_LISTA[13]="DT.BLOCCO FORN.(AAAA/MM/GG);CLI_DTAMGK;C;10"
		A_LISTA[14]="COD.CONDIZ.DI PAGAMENTO;CLI_CONPAG;C;3"
		A_LISTA[15]="COD.ZONA;CLI_ZONA;C;3"
		A_LISTA[16]="LISTINO;CLI_LISCLI;C;10"
		A_LISTA[17]="COD.GRUPPO;CLI_APPPRO;C;3"  && ERASMO - 17/03/2023
		
		PUBLIC A_LISTA2(5)
		A_LISTA2[1]="Nessuna opzione"
		A_LISTA2[2]="Solo clienti non obsoleti"
		A_LISTA2[3]="Solo clienti obsoleti"	
		A_LISTA2[4]="Solo clienti italiani"	
		A_LISTA2[5]="Solo clienti esteri"				

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF
ENDCASE

RETURN


*****************************************************************************
PROCEDURE agesta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_AGE_AN"
		_V_REPORT = "AGELIST.FRX"

		A_LISTA[1]="AGENTE;AGE_CODICE;C;3"
		A_LISTA[2]="RAGIONE SOCIALE;AGE_RAGSOC;C;30"	

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE ammsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_AMM_TT"
		_V_REPORT = "AMMLIST.FRX"

		A_LISTA[1]="NUMERO FATTURA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA FATTURA;ORD_DATORD;C;10"
		A_LISTA[3]="LOCALITA;ORD_LOCALI;C;30"
		A_LISTA[4]="RAGIONE SOCIALE;ORD_RAGSOC;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

		
ENDCASE

RETURN




*****************************************************************************
PROCEDURE apesta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "APERTE"
		_V_REPORT = "APE000.FRX"

		A_LISTA[1]="COD.CONTO;PAR_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;PAR_RAGSOC;C;35"
		A_LISTA[3]="NUMERO FATTURA;PAR_FATT;C;7"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

		
ENDCASE

RETURN



*****************************************************************************
PROCEDURE apesta1
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "APEWORK"
		_V_REPORT = "APE000.FRX"

		A_LISTA[1]="Cod.Conto;par_codcli;C;10"
		A_LISTA[2]="Ragione Sociale;Par_ragsoc;C;35"
		A_LISTA[3]="Numero Fattura;par_fatt;C;7"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN




*****************************************************************************
PROCEDURE artsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg,.T. LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(9)
		_V_SELECT = "U_ART_PR"
		_V_REPORT = "ART000.FRX"
		_V_LISTIN = SPACE(01)

		A_LISTA[1]="COD.ARTICOLO;ART_CODPRI;C;16"
		A_LISTA[2]="DESCRIZIONE;ART_DESCR;C;40"
		A_LISTA[3]="UNITA' DI MISURA;ART_UNIMIS;C;2"
		A_LISTA[4]="LINEA PRODOTTO;ART_LINEA;C;2"
		A_LISTA[5]="COORDINATE;ART_COORD;C;10"
		A_LISTA[6]="GRUPPO PRODUTTIVO;ART_GRUPRD;C;16"
		A_LISTA[7]="CATEG. MERCEOLOGICA;ART_CATMER;C;3" 
		A_LISTA[8]="CENTRO DI COSTO;ART_CCO;C;13"  
		A_LISTA[9]="CLASSE DOGANALE;ART_CLDOG;C;13"  


		PUBLIC A_LISTA2(6)
		A_LISTA2[1]="Nessuna opzione"
		A_LISTA2[2]="Solo articoli non obsoleti"
		A_LISTA2[3]="Solo articoli obsoleti"
		A_LISTA2[4]="Solo articoli prodotti"
		A_LISTA2[5]="Solo articoli acquistati"
		A_LISTA2[6]="Solo articoli in conto lavoro"

		
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN




*****************************************************************************
PROCEDURE aststa
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_AST_AN"
		_V_REPORT = "AST000.FRX"

		A_LISTA[1]="NUMERO SCATOLA;AST_NUMSCA;C;6"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE azista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_AZI_AN"
		_V_REPORT = "AZI000.FRX"

		A_LISTA[1]="COD.SOC.;AZI_CODSOC;C;2"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


** SERGIO INIZIO 02/12/2004

*****************************************************************************
PROCEDURE bansta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(9)
		_V_SELECT = "U_BAN_AN"
		_V_REPORT = "BAN000.FRX"

		A_LISTA[1]="CODICE BANCA;BAN_CODBAN;C;6"
		A_LISTA[2]="T.B.;BAN_PRESE;C;4"
		A_LISTA[3]="DESCRIZIONE BANCA;BAN_DESBAN;C;40"
		A_LISTA[4]="INDIRIZZO;BAN_INDIR;C;50"
		A_LISTA[5]="CAP;BAN_CAP;C;5"
		A_LISTA[6]="LOCALITA;BAN_LOCA;C;30"
		A_LISTA[7]="ABI;BAN_CODABI;C;5"
		A_LISTA[8]="CAB;BAN_CODCAB;C;5"
		A_LISTA[9]="DATA INSERIMENTO;BAN_DATINS;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN
** SERGIO FINE 02/12/2004



*****************************************************************************
PROCEDURE bofsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_BOF_TT"
		_V_REPORT = "BOFLIST.FRX"

		A_LISTA[1]="NUMERO BOLLA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA BOLLA;ORD_DATORD;C;10"
		A_LISTA[3]="LOCALITA;ORD_LOCALI;C;30"
		A_LISTA[4]="MAGAZZINO;ORD_MAGS;C;6"


		RELEASE DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		PUBLIC DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		DDT_ITA = .F.
		DDT_EXP = .F.
		DDT_ALL = .F.

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'


ENDCASE

RETURN


*****************************************************************************
PROCEDURE bolsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(7)
		_V_SELECT = "U_BOL_TT"
		_V_REPORT = "BOLLIST.FRX"

		A_LISTA[1]="NUMERO BOLLA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA BOLLA;ORD_DATORD;C;10"
		A_LISTA[3]="LOCALITÀ;ORD_LOCALI;C;30"
		A_LISTA[4]="MAGAZZINO;ORD_MAGS;C;6"
		A_LISTA[5]="CLIENTE EMITTENTE;ORD_RAGEMI;C;30"
		A_LISTA[6]="CLIENTE IN FATTURAZIONE;ORD_RAGSOC;C;30"
		A_LISTA[7]="LOCALITÀ DI DESTINAZIONE;ORD_LOCC;C;70"


		RELEASE DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		PUBLIC DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		DDT_ITA = .F.
		DDT_EXP = .F.
		DDT_ALL = .F.

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE bolressta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "U_BOL_TT"
		_V_REPORT = "BOLLIST.FRX"

		A_LISTA[1]="NUMERO BOLLA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA BOLLA;ORD_DATORD;C;10"
		A_LISTA[3]="LOCALITA;ORD_LOCALI;C;30"
		A_LISTA[4]="MAGAZZINO;ORD_MAGS;C;6"
		A_LISTA[5]="CLIENTE EMITTENTE;ORD_RAGEMI;C;30"
		A_LISTA[6]="CLIENTE IN FATTURAZIONE;ORD_RAGSOC;C;30"


		RELEASE DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		PUBLIC DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		DDT_ITA = .F.
		DDT_EXP = .F.
		DDT_ALL = .F.

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE bolfsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "U_BOL_TT"
		_V_REPORT = "BOLLIST.FRX"

		A_LISTA[1]="NUMERO BOLLA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA BOLLA;ORD_DATORD;C;10"
		A_LISTA[3]="LOCALITA;ORD_LOCALI;C;30"
		A_LISTA[4]="MAGAZZINO;ORD_MAGS;C;6"
		A_LISTA[5]="CLIENTE EMITTENTE;ORD_RAGEMI;C;30"
		A_LISTA[6]="CLIENTE IN FATTURAZIONE;ORD_RAGSOC;C;30"

		RELEASE DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		PUBLIC DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		DDT_ITA = .F.
		DDT_EXP = .F.
		DDT_ALL = .F.

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE budsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_BUD_AN"
		_V_REPORT = "BUDLIST.FRX"

		A_LISTA[1]="GRUPPO;BUD_CODGRU;C;10"
		A_LISTA[2]="MASTRO;BUD_MASTRO;C;13"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE ceasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_CEA_TT"
		_V_REPORT = "CEALIST.FRX"

		A_LISTA[1]="NUMERO ACQUISTO;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA ACQUISTO;ORD_DATORD;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE ceista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_CEI_TT"
		_V_REPORT = "CEILIST.FRX"

		A_LISTA[1]="NUMERO CESSIONE;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA CESSIONE;ORD_DATORD;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*!*	*****************************************************************************
*!*	PROCEDURE cersta
*!*	*****************************************************************************
*!*	PARAMETERS _p_nomeprg,_p_routine

*!*	IF EMPTY(_p_routine)
*!*	  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
*!*	  return
*!*	endif

*!*	* -->> nome del form da eseguire
*!*	* --------------------------------------
*!*	_p_nomesta='Stampa'

*!*	DO CASE 
*!*		CASE  _p_routine='START'
*!*			DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
*!*		CASE  _p_routine='LOAD'
*!*			PUBLIC A_LISTA(2)
*!*			_V_SELECT = "U_CER_AN"
*!*			_V_REPORT = "CER000.FRX"

*!*			A_LISTA[1]="CODICE;CER_CODICE;C;10"
*!*			A_LISTA[2]="FORNITORE;CER_CODICE;C;10"

*!*		CASE  _p_routine='VALID-DAL'

*!*		CASE  _p_routine='VALID-AL'

*!*	ENDCASE

*!*	RETURN


*****************************************************************************
PROCEDURE cersta1
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "_STAMPA1"
		_V_REPORT = "CER100.FRX"

		A_LISTA[1]="CODICE;CER_CODICE;C;10"
		A_LISTA[2]="FORNITORE;CER_CODFOR;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE cmcstage
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_CMC_AN"
		_V_REPORT = "CMCSTAGE.FRX"

		A_LISTA[1]="AGENTE,CLIENTE,NUMERO;STR(VAL(CMD_CODAGE),3,0);C;3"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE cmdsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_CMD_AN"
		_V_REPORT = "CMD000.FRX"

		A_LISTA[1]="Data;CMD_DATA;C;10"
		A_LISTA[2]="Descrizione;cmd_descr1;C;40"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'


ENDCASE

RETURN



*****************************************************************************
PROCEDURE cmdstage
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_CMD_AN"
		_V_REPORT = "CMDSTAGE.FRX"

		A_LISTA[1]="AGENTE,CLIENTE,NUMERO;STR(VAL(CMD_CODAGE),3,0);C;3"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE cmssta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_COM_TT"
		_V_REPORT = "CMSLIST.FRX"

		A_LISTA[1]="NUMERO COMMESSA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA COMMESSA;ORD_DATORD;C;10"
		A_LISTA[3]="AGENTE;ORD_AGE;C;3"
		A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE comdsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_CMD_AN"
		_V_REPORT = "CMD000.FRX"

		A_LISTA[1]="COD.CLIENTE;CMD_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;CMD_RAGSOC;C;40"
		A_LISTA[3]="DATA COMODATO;CMD_DATA;C;10"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN


*****************************************************************************
PROCEDURE comsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_COM_AN"
		_V_REPORT = "COM000.FRX"

		A_LISTA[1]="CLIENTE;COM_CLI;C;20"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'


ENDCASE

RETURN



*****************************************************************************
PROCEDURE confsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_INT_TT"
		_V_REPORT = "CONFLIST.FRX"

		A_LISTA[1]="N.CONTO;INT_CONTO;C;13"
		*A_LISTA[2]="C.R. DARE;INT_CODRIG;C;10"
		*A_LISTA[3]="C.R. AVERE;INT_CODRIA;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE confbrista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_BRI_TT"
		_V_REPORT = "CONFLIST.FRX"

		A_LISTA[1]="N.CONTO;INT_CONTO;C;13"
		*A_LISTA[2]="C.R. DARE;INT_CODRIG;C;10"
		*A_LISTA[3]="C.R. AVERE;INT_CODRIA;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE consta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_CON_AN"
		_V_REPORT = "CON000.FRX"

		A_LISTA[1]="COD.CLIENTE;SCA_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;SCA_RAGSOC;C;40"
		A_LISTA[3]="NUMERO CONTRATTO;SCA_NUMID;C;8"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF


ENDCASE

RETURN


*****************************************************************************
PROCEDURE disesta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(10)
		_V_SELECT = "U_DIS_AN"
		_V_REPORT = "DISE000.FRX"

		A_LISTA[1]="CODICE DISEGNO;DIS_CODICE;C;15"
		A_LISTA[2]="DESCRIZIONE DISEGNO;DIS_DESCRI;C;50"
		A_LISTA[3]="INDIRIZZO;CLI_INDIR;C;30"
		A_LISTA[4]="C.A.P.;CLI_CAP;C;5"
		A_LISTA[5]="PART.IVA;CLI_PARIVA;C;11"
		A_LISTA[6]="TELEFONO;CLI_TELEFO;C;20"
		A_LISTA[7]="COD.AGENTE;CLI_AGE;C;3"
		A_LISTA[8]="RICERCA ALTERNATIVA;CLI_RICERC;C;10"
		A_LISTA[9]="CODICE NAZIONE;CLI_NAZION;C;3"
		A_LISTA[10]="LOCALITÀ;CLI_LOCALI;C;20"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE dissta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_DIS_TT"
		_V_REPORT = "DISLIST.FRX"

		A_LISTA[1]="CODICE GRUPPO;DIT_GRUPPO;C;16"
		
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE fagsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_FAG_TT"
		_V_REPORT = "FAGLIST.FRX"

		A_LISTA[1]="AGENTE;AGE_CODICE;C;3"
		A_LISTA[2]="RAGIONE SOCIALE;AGE_RAGSOC;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE famsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_FAM_TT"
		_V_REPORT = "FAMLIST.FRX"

		A_LISTA[1]="NUMERO FATTURA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA FATTURA;ORD_DATORD;C;10"
		A_LISTA[3]="LOCALITA;ORD_LOCALI;C;30"
		A_LISTA[4]="RAGIONE SOCIALE;ORD_RAGSOC;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE fansta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "CHIUSURA"
		_V_REPORT = "FANN000.FRX"

		A_LISTA[1]="CODICE SOCIETA';FIN_CODSOC;C;2"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE fapsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_FAP_TT"
		_V_REPORT = "FAPLIST.FRX"

		A_LISTA[1]="NUMERO FATTURA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA FATTURA;ORD_DATORD;C;10"
		A_LISTA[3]="AGENTE;ORD_AGE;C;3"
		A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE fapstage
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_FAP_TT"
		_V_REPORT = "FAPSTAGE.FRX"

		A_LISTA[1]="AGENTE;ORD_AGE;C;5"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE fatsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_FAT_TT"
		_V_REPORT = "FATLIST.FRX"

		A_LISTA[1]="NUMERO FATTURA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA FATTURA;ORD_DATORD;C;10"
		A_LISTA[3]="AGENTE;ORD_AGE;C;3"
		A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE fatsta00
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_FAT_TT"
		_V_REPORT = "FATSTA00.FRX"

		A_LISTA[1]="NUM.FATTURA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA FATTURA;ORD_DATORD;C;10"
		A_LISTA[3]="CODICE CLIENTE;ORD_CODCLI;C;10"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 3
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 3
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF


ENDCASE

RETURN


*****************************************************************************
PROCEDURE fatstage
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_FAT_TT"
		_V_REPORT = "FATSTAGE.FRX"

		A_LISTA[1]="AGENTE;ORD_AGE;C;5"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'


ENDCASE

RETURN


*****************************************************************************
PROCEDURE fatstagx
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_FAT_TT"
		_V_REPORT = "FATSTAGE.FRX"

		A_LISTA[1]="AGENTE;ORD_AGE;C;5"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'


ENDCASE

RETURN


*****************************************************************************
PROCEDURE fidsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_FID_TT"
		_V_REPORT = "FID000.FRX"

		A_LISTA[1]="CODICE CLIENTE;FID_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;FID_RAGSOC;C;40"
		A_LISTA[3]="NUMERO FIDEUSSIONE;FID_NUMFID;C;8"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF


ENDCASE

RETURN



*****************************************************************************
PROCEDURE fidstage
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_FID_TT"
		_V_REPORT = "FIDSTAGE.FRX"

		A_LISTA[1]="BANCA,AGENTE,CLIENTE,NUMERO;STR(VAL(FID_CODBAN),5,0);C;5"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'


ENDCASE

RETURN



*****************************************************************************
PROCEDURE forsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg,.T. LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(13)
		_V_SELECT = "U_FOR_AN"
		_V_REPORT = "FOR000.FRX"

		A_LISTA[1]="RAG.SOCIALE;FOR_RAGSOC;C;40"
		A_LISTA[2]="COD.FORNITORE;FOR_CODCLI;C;10"
		A_LISTA[3]="INDIRIZZO;FOR_INDIR;C;30"
		A_LISTA[4]="COSA TRATTA;FOR_COSATRATTA;C;5"
		A_LISTA[5]="C.A.P.;FOR_CAP;C;5"
		A_LISTA[6]="PART.IVA;FOR_PARIVA;C;11"
		A_LISTA[7]="TELEFONO;FOR_TELEFO;C;20"
		A_LISTA[8]="RICERCA ALTERNATIVA;FOR_RICERC;C;10"
		A_LISTA[9]="LOCALITÀ;FOR_LOCALI;C;20"
		A_LISTA[10]="BANCA;FOR_BAE;C;5"
		A_LISTA[11]="TIPOLOGIA PAGAMENTO';FOR_FORMAPAGAMENTO;C;5"
		A_LISTA[12]="LISTINO;FOR_LISFOR;C;10"	
		A_LISTA[13]="NAZIONE;FOR_NAZION;C;3"	

		
		PUBLIC A_LISTA2(5)
		A_LISTA2[1]="Nessuna opzione"
		A_LISTA2[2]="Solo fornitori non obsoleti"
		A_LISTA2[3]="Solo fornitori obsoleti"	
		A_LISTA2[4]="Solo fornitori italiani"	
		A_LISTA2[5]="Solo fornitori esteri"				


	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

		
ENDCASE

RETURN



*****************************************************************************
PROCEDURE forasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(10)
		_V_SELECT = "U_FOR_PR"
		_V_REPORT = "FPR000.FRX"

		A_LISTA[1]="COD.FORNITORE;FPR_CODFOR;C;10"
		A_LISTA[2]="RAG.SOCIALE;FPR_RAGFOR;C;50"
		A_LISTA[3]="INDIRIZZO;FPR_INDIRI;C;100"
		A_LISTA[4]="LOCALITA';FPR_LOCALI;C;100"
		A_LISTA[5]="C.A.P.;FPR_CAP;C;5"
		A_LISTA[6]="PROVINCIA;FPR_PROVIN;C;2"
		A_LISTA[7]="TELEFONO;FPR_TELEFO;C;20"
		A_LISTA[8]="DATA ULTIMO CARICO;FPR_DATUCA;C;10"		
		A_LISTA[9]="PREZZO DA CONTRATTO;FPR_PRZCON;C;17"
		A_LISTA[10]="PRIORITA';FPR_SEQPRI;C;3"
		
	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

		
ENDCASE

RETURN



*****************************************************************************
PROCEDURE ftpsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(8)
		_V_SELECT = "U_FTP_AN"
		_V_REPORT = "FTP000.FRX"

		A_LISTA[1]="CODICE PDV;FTP_CODPDV;C;10"
		A_LISTA[2]="DESCRIZIONE PDV;FTP_DESPDV;C;50"
		A_LISTA[3]="CODICE CASSA;FTP_CODCAS;C;3"		
		A_LISTA[4]="DESCRIZIONE CASSA;FTP_DESCAS;C;50"
		A_LISTA[5]="TIPO;FTP_TIPO;C;1"
		A_LISTA[6]="HOST;FTP_HOST;C;100"
        A_LISTA[7]="USERS;FTP_USER;C;100"
		A_LISTA[8]="NOME FILE;FTP_NOMEFI;C;100"
		
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN



*****************************************************************************
PROCEDURE gcosta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "CONTATTI"
		_V_REPORT = "GCO000.FRX"

		A_LISTA[1]="CONTATTO;MAI_CONTA;C;40"
		A_LISTA[2]="C.A.P.;MAI_CAP;C;5"
		A_LISTA[3]="PROV.;MAI_PR;C;2"
		A_LISTA[4]="GROSSISTA;MAI_GROSSI;C;40"
		A_LISTA[5]="CODICE;MAI_CODICE;C;3"
		A_LISTA[6]="SOTTOCODICE;MAI_SUBCO;C;2"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'


ENDCASE

RETURN


*****************************************************************************
PROCEDURE imbsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_IMB_TB"
		_V_REPORT = "IMB000.FRX"

		A_LISTA[1]="CODICE;IMB_CODICE;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'


ENDCASE

RETURN


*****************************************************************************
PROCEDURE insesta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_INS_AN"
		_V_REPORT = "INSE000.FRX"

		A_LISTA[1]="CODICE CLIENTE;INS_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;INS_RAGSOC;C;40"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF


ENDCASE

RETURN



*****************************************************************************
PROCEDURE intsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_INT_AN"
		_V_REPORT = "INT000.FRX"

		A_LISTA[1]="DATA;INT_DATA;C;10"
		A_LISTA[2]="AGENTE;INT_AGE;C;30"


	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE lavista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_BLI_TT"
		_V_REPORT = "LAVILIST.FRX"

		A_LISTA[1]="AGENTE;ORD_AGE;C;3"
		A_LISTA[2]="NUMERO ORDINE;ORD_NUMORD;C;6"
		A_LISTA[3]="DATA ORDINE;ORD_DATORD;C;10"
		A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"


	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'


ENDCASE

RETURN



*****************************************************************************
PROCEDURE lavosta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "U_CTL_TT"
		_V_REPORT = "LAVOLIST.FRX"

		A_LISTA[1]="NUMERO ORDINE;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA ORDINE;ORD_DATORD;C;10"
		A_LISTA[3]="NUMERO BOLLA;ORD_NUMBOL;C;6"
		A_LISTA[4]="DATA BOLLA;ORD_DATBOL;C;10"
		A_LISTA[5]="RAGIONE SOCIALE;ORD_RAGSOC;C;35"
		A_LISTA[6]="LOCALITA;ORD_LOCALI;C;30"


	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN




*****************************************************************************
PROCEDURE lavusta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_BLU_TT"
		_V_REPORT = "LAVULIST.FRX"

		A_LISTA[1]="AGENTE;ORD_AGE;C;3"
		A_LISTA[2]="NUMERO BOLLA;ORD_NUMORD;C;6"
		A_LISTA[3]="DATA BOLLA;ORD_DATORD;C;10"
		A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE legdsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_LEG_DO"
		_V_REPORT = "LEGD000.FRX"

		A_LISTA[1]="Documento di partenza;LEG_TIPDOC;C;4"
		A_LISTA[2]="Cod.cliente;LEG_CODCLI;C;10"
		A_LISTA[3]="Ragione sociale cliente;LEG_RAGSOC;C;40"
*		A_LISTA[4]="Tipo doc./ anno / Cod.cli./ Rag.soc./Num.doc. / Data doc./ Num.doc.creato;LEG_TIPDOC;C;4,LEG_ANNO;C;4,LEG_CODCLI;C;10,LEG_RAGSOC;C;40,LEG_NUMDOC;C;6,LEG_DATDOC;C;10,LEG_TIPCRE

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF


ENDCASE

RETURN




*****************************************************************************
PROCEDURE ligsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "U_LIS_LG"
		_V_REPORT = "LIG000.FRX"

		A_LISTA[1]="TIPO;LIS_TIPO;C;10"
		A_LISTA[2]="AGENTE;LIS_AGE;C;3"
		A_LISTA[3]="ZONA;LIS_ZONA;C;3"
		A_LISTA[4]="LINEA;LIS_LINEA;C;3"
		A_LISTA[5]="CLIENTE;LIS_CODCLI;C;10"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 5
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 5
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF


ENDCASE

RETURN




*****************************************************************************
PROCEDURE lislsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_LIS_LI"
		_V_REPORT = "LISLIN.FRX"

		A_LISTA[1]="CODICE CLIENTE;LIS_CODCLI;C;10"
		A_LISTA[2]="LINEA;LIS_LINART;C;2"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN





*****************************************************************************
PROCEDURE lissta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_LIS_TT"
		_V_REPORT = "LISSTA.FRX"

		A_LISTA[1]="Cod.Articolo;art_codpri;C;16"
		A_LISTA[2]="Descrizione;art_descr;C;40"
		A_LISTA[3]="Unita' di Misura;art_unimis;C;2"
		A_LISTA[3]="Agente;art_unimis;C;2"


	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN




*****************************************************************************
PROCEDURE listast2
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_LIS_PA"
		_V_REPORT = "LISTAGE2.FRX"

		A_LISTA[1]="AGENTE;LIS_AGE;C;3"
		A_LISTA[2]="CODICE LINEA;LIS_LINEA;C;3"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE listasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_LIS_AG"
		_V_REPORT = "LISTAGE1.FRX"

		A_LISTA[1]="AGENTE;LIS_AGE;C;3"
		A_LISTA[2]="CODICE ARTICOLO;LIS_CODART;C;16"
		
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE logrsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "LOG_RETE"
		_V_REPORT = "LOGR000.FRX"

		A_LISTA[1]="POSTAZIONE;LOG_POSOPE;C;50"
		A_LISTA[2]="NOME UTENTE;LOG_NOMOPE;C;30"
		A_LISTA[3]="CODICE UTENTE;LOG_CODOPE;C;03"
		A_LISTA[4]="CONTO CONTABILE;LOG_CODCON;C;13"
		A_LISTA[5]="DATA OPERAZIONE;LOG_DATOPE;C;10"
		A_LISTA[6]="RISULTATO;LOG_RISULT;C;2"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN




*****************************************************************************
PROCEDURE logsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "LOG_CONT"
		_V_REPORT = "LOG000.FRX"

		A_LISTA[1]="POSTAZIONE;LOG_POSOPE;C;50"
		A_LISTA[2]="NOME UTENTE;LOG_NOMOPE;C;30"
		A_LISTA[3]="CODICE UTENTE;LOG_CODOPE;C;03"
		A_LISTA[4]="CONTO CONTABILE;LOG_CODCON;C;13"
		A_LISTA[5]="DATA OPERAZIONE;LOG_DATOPE;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE mandsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_PFO_TT"
		_V_REPORT = "PFOR000.FRX"

		A_LISTA[1]="Cod.Fornit.;RIC_CODCLI;C;10"
		A_LISTA[2]="Ragione Sociale;RIC_RAGSOC;C;40"
		A_LISTA[3]="Numero Assegno;ric_nfatt;C;6"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF


ENDCASE

RETURN



*****************************************************************************
PROCEDURE marsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_MAR_AN"
		_V_REPORT = "MARLIST.FRX"

		A_LISTA[1]="CODICE CLIENTE;MAR_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;MAR_RAGSOC;C;40"
		A_LISTA[3]="CODICE ARTICOLO;MAR_CODART;C;16"
		A_LISTA[4]="DESCRIZIONE ARTICOLO;MAR_DESART;C;40"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE movststa
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "MOVSTALL"
		_V_REPORT = "MOVSTSTA.FRX"

		A_LISTA[1]="CONTO;MOV_CONTO;C;13"
		A_LISTA[2]="DESCRIZIONE CONTO;MOV_DESCRI;C;40"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE mrista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_MRI_TT"
		_V_REPORT = "MRILIST.FRX"
		A_LISTA[1]= "AGENTE;ORD_AGE;C;3"
		A_LISTA[2]= "NUMERO ORDINE;ORD_NUMORD;C;6"
		A_LISTA[3]= "DATA ORDINE;ORD_DATORD;C;10"
		A_LISTA[4]= "LOCALITA;ORD_LOCALI;C;30"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


*****************************************************************************
PROCEDURE notesta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "NOTE_COM"
		_V_REPORT = "NOTE.FRX"

		A_LISTA[1]="CODICE;NOT_CODICE;C;16"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE inrsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "VENDITE_TT"
		_V_REPORT = "INRLIST.FRX"

		A_LISTA[1]="NR.INTERVENTO;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA INTERVENTO;ORD_DATORD;C;10"
		A_LISTA[3]="AGENTE;ORD_AGE;C;3"
		A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN

*****************************************************************************
PROCEDURE offsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_OFF_TT"
		_V_REPORT = "OFFLIST.FRX"

		A_LISTA[1]="NR.PREVENTIVO;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA PREVENTIVO;ORD_DATORD;C;10"
		A_LISTA[3]="AGENTE;ORD_AGE;C;3"
		A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE ordsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_ORD_TT"
		_V_REPORT = "ORDLIST.FRX"
		A_LISTA[1]= "AGENTE;ORD_AGE;C;3"
		A_LISTA[2]= "NUMERO ORDINE;ORD_NUMORD;C;6"
		A_LISTA[3]= "DATA ORDINE;ORD_DATORD;C;10"
		A_LISTA[4]= "LOCALITA;ORD_LOCALI;C;30"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN



*****************************************************************************
PROCEDURE orfsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		  DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED
	CASE  _p_routine='LOAD'
		  PUBLIC A_LISTA(4)
		  _V_SELECT = "U_ORF_TT"
		  IF XXX_TIPO
  		     _V_REPORT = "PROPLIST.FRX"
  		     A_LISTA[1]="CODICE PDV;ORD_CODBUN;C;10"
		     A_LISTA[2]="DESCRIZIONE PDV;ORD_DESBUN;C;50"
		     A_LISTA[3]="NUMERO ORDINE;ORD_NUMORD;C;6"
		     A_LISTA[4]="DATA PROPOSTA;ORD_DATORD;C;10"
		  ELSE
  		     _V_REPORT = "ORFLIST.FRX"
  		     A_LISTA[1]="AGENTE;ORD_AGE;C;3"
		     A_LISTA[2]="NUMERO ORDINE;ORD_NUMORD;C;6"
		     A_LISTA[3]="DATA ORDINE;ORD_DATORD;C;10"
		     A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"
		  ENDIF

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN

*****************************************************************************
PROCEDURE rdasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		  DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED
	CASE  _p_routine='LOAD'
		 PUBLIC A_LISTA(3)
		 _V_SELECT = "U_RDA_TT"
  		 _V_REPORT = "ORFLIST.FRX"
	     A_LISTA[1]="NUMERO RDA;ORD_NUMORD;C;6"
	     A_LISTA[2]="DATA 	RDA;ORD_DATORD;C;10"
	     A_LISTA[3]="LOCALITA;ORD_LOCALI;C;30"


	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE pagfsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_PFO_TT"
		_V_REPORT = "PFOR000.FRX"

		A_LISTA[1]="Cod.Fornit.;RIC_CODCLI;C;10"
		A_LISTA[2]="Ragione Sociale;RIC_RAGSOC;C;40"
		A_LISTA[3]="Numero Assegno;ric_nfatt;C;6"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE palsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_PAL_AN"
		_V_REPORT = "PAL000.FRX"

		A_LISTA[1]="CODICE PALLET;PAL_COD;C;10"
		A_LISTA[2]="DESCRIZIONE;PAL_DESCR;C;40"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE papsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_PAP_AN"
		_V_REPORT = "PAP000.FRX"

		A_LISTA[1]="COD.CLIENTE;PAP_CODCLI;C;7"
		A_LISTA[2]="RAGIONE SOCIALE;PAP_RAGSOC;C;35"
		A_LISTA[3]="NUMERO FATTURA;PAP_NFAT;C;7"


	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE parasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif


* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
	 	  DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		  PUBLIC A_LISTA(2)
		  _V_SELECT  = "PARA"
		  _V_REPORT  = "PARALIST.FRX"
  		  A_LISTA[1] = "Codice;CODICE;C;13"
		  A_LISTA[2] = "Descrizione;DESCRI;C;20"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE pefsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_POR_EF"
		_V_REPORT = "PEF000.FRX"

		A_LISTA[1]="COD.CLIENTE;RIC_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;RIC_RAGSOC;C;40"
		A_LISTA[3]="NUMERO FATTURA;RIC_NFATT;C;6"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN


*****************************************************************************
PROCEDURE pedsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_PER_PD"
		_V_REPORT = "PER001.FRX"

		A_LISTA[1]="CODICE PERSONA;PED_CODICE;C;10"		
		A_LISTA[2]="DESCRIZIONE PERSONA;PED_RAGSOC;C;50"
		
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE persta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "U_PER_AN"
		_V_REPORT = "PER000.FRX"

		A_LISTA[1]="CODICE PERSONA;PER_CODICE;C;10"		
		A_LISTA[2]="DESCRIZIONE PERSONA;PER_RAGSOC;C;50"
		A_LISTA[3]="TIPO CONTRATTO;PER_TIPCON;C;3"
		A_LISTA[4]="DESCRIZIONE CONTRATTO;PER_DESCON;C;50"
		A_LISTA[5]="DATA CONTRATTO;PER_DATCON;C;10"
        A_LISTA[6]="ORE LAVORATIVE;PER_ORELAV;C;5"
		
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE pforsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_PFO_TT"
		_V_REPORT = "PFOR000.FRX"

		A_LISTA[1]="COD.FORNIT.;RIC_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;RIC_RAGSOC;C;40"
		A_LISTA[3]="NUMERO ASSEGNO;RIC_NFATT;C;6"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE possta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_POS_AN"
		_V_REPORT = "POS000.FRX"

		A_LISTA[1]="COD.CLIENTE;LIS_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;LIS_RAGSOC;C;40"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE prbsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "U_PRB_TT"
		_V_REPORT = "PRBLIST.FRX"

		A_LISTA[1]="NUMERO PRE-BOLLA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA PRE-BOLLA;ORD_DATORD;C;10"
		A_LISTA[3]="LOCALITA;ORD_LOCALI;C;30"
		A_LISTA[4]="MAGAZZINO;ORD_MAGS;C;6"
		A_LISTA[5]="FORNITORE;ORD_RAGSOC;C;30"

		RELEASE DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		PUBLIC DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		DDT_ITA = .F.
		DDT_EXP = .F.
		DDT_ALL = .F.

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE prfsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_PRF_TT"
		_V_REPORT = "PRFLIST.FRX"

		A_LISTA[1]="NUMERO PRE-FATTURA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA PRE-FATTURA;ORD_DATORD;C;10"
		A_LISTA[3]="AGENTE;ORD_AGE;C;3"
		A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE procsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "RES_PROC"
		_V_REPORT = "PROCLIST.FRX"

		A_LISTA[1]="Utente;UTENTE;C;10"
		A_LISTA[2]="Procedura;PROCEDURA;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'


ENDCASE

RETURN


*****************************************************************************
PROCEDURE prosta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_PRO_AN"
		_V_REPORT = "PROLIST.FRX"

		A_LISTA[1]="Agente;PRO_CODAGE;C;3"
		A_LISTA[2]="Agente;PRO_RAGSOC;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE ribasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_RIC_TT"
		_V_REPORT = "RIBA000.FRX"

		A_LISTA[1]="COD.CLIENTE;RIC_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;RIC_RAGSOC;C;40"
		A_LISTA[3]="NUMERO FATTURA;RIC_NFATT;C;6"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN


*****************************************************************************
PROCEDURE ribmsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_RIM_TT"
		_V_REPORT = "RIBM000.FRX"

		A_LISTA[1]="COD.CLIENTE;RIC_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;RIC_RAGSOC;C;40"
		A_LISTA[3]="NUMERO FATTURA;RIC_NFATT;C;6"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE ricsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_RIC_AN"
		_V_REPORT = "RIC000.FRX"

		A_LISTA[1]="AGENTE;RIC_AGE;C;2"
		A_LISTA[2]="RAGIONE SOCIALE;RIC_RAGSOC;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN




*****************************************************************************
PROCEDURE ridsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_RID_AN"
		_V_REPORT = "RID000.FRX"

		A_LISTA[1]="BANCA;RID_BANCA;C;5"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE rintsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_RIN_TT"
		_V_REPORT = "RINTLIST.FRX"

		A_LISTA[1]="Agente;ORD_AGE;C;3"
		A_LISTA[2]="Numero Richiesta;ORD_NUMORD;C;6"
		A_LISTA[3]="Data Richiesta;ORD_DATORD;C;10"
		A_LISTA[4]="Localita;ORD_LOCALI;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN




*****************************************************************************
PROCEDURE scasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_SCA_AN"
		_V_REPORT = "SCA000.FRX"

		A_LISTA[1]="COD.CLIENTE;SCA_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;SCA_RAGSOC;C;40"
		A_LISTA[3]="NUMERO IDENTIFICATIVO;SCA_NUMID;C;8"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE spesta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_SPE_TT"
		_V_REPORT = "SPELIST.FRX"

		A_LISTA[1]="AGENTE;ORD_AGE;C;3"
		A_LISTA[2]="NUMERO DISTINTA;ORD_NUMORD;C;6"
		A_LISTA[3]="DATA DISTINTA;ORD_DATORD;C;10"
		A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE bfosta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(7)
		_V_SELECT = "U_BFO_TT"
		_V_REPORT = "BFOLIST.FRX"

        A_LISTA[1]="NUMERO DOCUMENTO;ORD_NUMORD;C;6"
        A_LISTA[2]="DATA DOCUMENTO;ORD_DATORD;C;10"
        A_LISTA[3]="RAG. SOCIALE FORNITORE;ORD_RAGSOC;C;30"
        A_LISTA[4]="CODICE FORNITORE;ORD_CODCLI;C;10"
        A_LISTA[5]="CODICE BUISNESS UNIT;ORD_CODBUN;C;10"
        A_LISTA[6]="CODICE CENTRO DI COSTO;ORD_CODCCO;C;13"
        A_LISTA[7]="NUMERO IDENTIFICATIVO;ORD_NUMIDE;C;6"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN

*****************************************************************************
PROCEDURE rdcsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(7)
		_V_SELECT = "U_BFO_TT"
		_V_REPORT = "RDCLIST.FRX"

        A_LISTA[1]="NUMERO DOCUMENTO;ORD_NUMORD;C;6"
        A_LISTA[2]="DATA DOCUMENTO;ORD_DATORD;C;10"
        A_LISTA[3]="RAG. SOCIALE CLIENTE;ORD_RAGSOC;C;30"
        A_LISTA[4]="CODICE CLIENTE;ORD_CODCLI;C;10"
        A_LISTA[5]="CODICE BUISNESS UNIT;ORD_CODBUN;C;10"
        A_LISTA[6]="CODICE CENTRO DI COSTO;ORD_CODCCO;C;13"
        A_LISTA[7]="NUMERO IDENTIFICATIVO;ORD_NUMIDE;C;6"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN

*****************************************************************************
PROCEDURE spista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_SPI_AN"
		_V_REPORT = "SPI000.FRX"

		A_LISTA[1]="CODICE CLIENTE;SPI_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;SPI_RAGSOC;C;40"
		A_LISTA[3]="DATA INTERVENTO;SPI_DATA;C;10"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE tvesta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_TVE_TT"
		_V_REPORT = "TVELIST.FRX"

		A_LISTA[1]="AGENTE;ORD_AGE;C;3"
		A_LISTA[2]="NUMERO BOLLA;ORD_NUMORD;C;6"
		A_LISTA[3]="DATA BOLLA;ORD_DATORD;C;10"
		A_LISTA[4]="LOCALITA;ORD_LOCALI;C;30"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



** SERGIO INIZIO 12/09/2004

*****************************************************************************
PROCEDURE valsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'


DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_VVA_CH"
		_V_REPORT = "VALLIST.FRX"
		A_LISTA[1]= "CODICE VALUTA;VVA_CODVAL;C;3"
		A_LISTA[2]= "DATA CAMBIO;VVA_DATA;C;10"
		A_LISTA[3]= "DESCRIZIONE VALUTA;VVA_NOMVAL;C;20"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		

ENDCASE

RETURN


** SERGIO FINE 12/09/2004

*****************************************************************************
PROCEDURE verssta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_VER_TT"
		_V_REPORT = "VERS000.FRX"

		A_LISTA[1]="NUMERO INCASSO;RIC_PROGR;C;6"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE vissta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_VIS_AN"
		_V_REPORT = "VIS000.FRX"

		A_LISTA[1]="DATA RELAZIONE;VIS_DTRELA;C;10"
		A_LISTA[2]="AGENTE;VIS_AGE;C;40"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE famstage
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
*		PUBLIC A_LISTA(2)
		_V_SELECT = "U_FAM_TT"
		_V_REPORT = "FAMSTAGE.FRX"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE logrstam
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "LOG_RETE"
		_V_REPORT = "LOGR000.FRX"

		A_LISTA[1]="POSTAZIONE;LOG_POSOPE;C;50"
		A_LISTA[2]="NOME UTENTE;LOG_NOMOPE;C;30"
		A_LISTA[3]="CODICE UTENTE;LOG_CODOPE;C;03"
		A_LISTA[4]="CONTO CONTABILE;LOG_CODCON;C;13"
		A_LISTA[5]="DATA OPERAZIONE;LOG_DATOPE;C;10"
		A_LISTA[6]="RISULTATO;LOG_RISULT;C;2"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE locsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(7)
		_V_SELECT = "U_LOC_AN"
		_V_REPORT = "LOC000.FRX"
		A_LISTA[1]="CODICE LOCALITA;LOC_CODLOC;C;3"
		A_LISTA[2]="CODICE CLIENTE/FORNITORE;LOC_CODCLI;C;10"
		A_LISTA[3]="DESCRIZIONE CLIENTE/FORNITORE;LOC_RAGSOC;C;40"
		A_LISTA[4]="LOCALITA;LOC_LOCALI;C;30"
		A_LISTA[5]="INDIRIZZO;LOC_INDIRI;C;30"
		A_LISTA[6]="CAP;LOC_CAP;C;5"
		A_LISTA[7]="TIPO;LOC_CF;C;1"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF
ENDCASE

RETURN


*****************************************************************************
PROCEDURE pdvsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_pdv_AN"
		_V_REPORT = "PDV000.FRX"
		A_LISTA[1]="CODICE;PDV_CODICE;C;10"
		A_LISTA[2]="DESCRIZIONE;PDV_DESCRI;C;50"
		A_LISTA[3]="C.COSTO;PDV_CODCCO;C;13"


	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE pdvtpsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_PDV_PA"
		_V_REPORT = "PDVTIPAG.FRX"
		A_LISTA[1]= "CODICE;PDV_CODICE;C;10"
		A_LISTA[2]= "DESCRIZIONE;PDV_DESCRI;C;50"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE pdvopsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_PDV_CC"
		_V_REPORT = "PDVTICAS.FRX"
		A_LISTA[1]= "CODICE;PDV_CODICE;C;10"
		A_LISTA[2]= "DESCRIZIONE;PDV_DESCRI;C;50"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE autsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_PDV_AU"
		_V_REPORT = "AUT000.FRX"
		A_LISTA[1]="DESCRIZIONE UTENTE;PDV_DESUTE;C;50"
		A_LISTA[2]="CODICE UTENTE;PDV_CODUTE;C;10"
		A_LISTA[3]="DESCRIZIONE PDV;PDV_DESBUN;C;50"
		A_LISTA[4]="CODICE PDV;PDV_CODBUN;C;10"		

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
*
* 				 		 << SEZIONE ETICHETTE >>
*
*****************************************************************************
*****************************************************************************
PROCEDURE eticli
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Eticli'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(8)
		_V_SELECT = "U_CLI_AN"
		_V_REPORT = "CLIETI.LBX"

		A_LISTA[1]="COD.CLIENTE;CLI_CODCLI;C;10"
		A_LISTA[2]="RAG.SOCIALE;CLI_RAGSOC;C;40"
		A_LISTA[3]="INDIRIZZO;CLI_INDIR;C;30"
		A_LISTA[4]="C.A.P.;CLI_CAP;C;5"
		A_LISTA[5]="PART.IVA;CLI_PARIVA;C;11"
		A_LISTA[6]="TELEFONO;CLI_TELEFO;C;20"
		A_LISTA[7]="AGENTE;CLI_AGE;C;3"
		A_LISTA[8]="RICERCA ALTERNATIVA;CLI_RICERC;C;10"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF
ENDCASE

RETURN


*****************************************************************************
PROCEDURE etifor
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Etifor'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(7)
		_V_SELECT = "U_FOR_AN"
		_V_REPORT = "FORETI.LBX"
		A_LISTA[1]="COD.FORNITORE;FOR_CODCLI;C;10"
		A_LISTA[2]="RAG.SOCIALE;FOR_RAGSOC;C;40"
		A_LISTA[3]="INDIRIZZO;FOR_INDIR;C;30"
		A_LISTA[4]="C.A.P.;FOR_CAP;C;5"
		A_LISTA[5]="PART.IVA;FOR_PARIVA;C;11"
		A_LISTA[6]="TELEFONO;FOR_TELEFO;C;20"
		A_LISTA[7]="RICERCA ALTERNATIVA;FOR_RICERC;C;10"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF
ENDCASE

RETURN


*****************************************************************************
PROCEDURE ccosta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "CCOSTO"
		_V_REPORT = "CCO000.FRX"
		A_LISTA[1]="CODICE;CON_CONTO;C;10"
		A_LISTA[2]="DESCRIZIONE;CON_DESCR;C;50"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE ceesta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "BILNEW"
		_V_REPORT = "STBILCE1.FRX"
		A_LISTA[1]="CODICE RIGA;bil_codrig;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN

*****************************************************************************
PROCEDURE brista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "BILANCIOR"
		_V_REPORT = "STBILRI1.FRX"
		A_LISTA[1]="CODICE RIGA;bil_codrig;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE ceerets
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_RET_CE"
		_V_REPORT = "CEERET.FRX"
        A_LISTA[1]="CODICE RIGA;RET_RIGA;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE brirets
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_RET_CE"
		_V_REPORT = "BRIRET.FRX"
        A_LISTA[1]="CODICE RIGA;RET_RIGA;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE lingues
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "LINGUE"
		_V_REPORT = "LINGUE.FRX"

        A_LISTA[1]="CODICE NAZIONE;COD_NAZ;C;3"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN

*****************************************************************************
PROCEDURE pdvcosta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_CON_PE"
		_V_REPORT = "PDVCONTR.FRX"
		A_LISTA[1]= "CODICE;CON_CODICE;C;10"
		A_LISTA[2]= "DESCRIZIONE;CON_DESCRI;C;50"
		A_LISTA[3]= "SIGLA;CON_SIGLA;C;2"
		A_LISTA[4]= "TIPO;CON_TIPCON;C;3"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE calsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_CAL_LA"
		_V_REPORT = "CAL000.FRX"
		A_LISTA[1]= "DATA;CAL_DATAMG;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN

*****************************************************************************
PROCEDURE tessta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_TES_AN"
		_V_REPORT = "TES000.FRX"
		A_LISTA[1]= "COGNOME;tes_cogn;C;40"
		A_LISTA[2]="NOME;tes_nome;C;40"
		A_LISTA[3]="CITTA';tes_loc;C;35"
		A_LISTA[4]="PROVINCIA;tes_prov;C;2"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE clifsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_CLI_FI"
		_V_REPORT = "CLIF000.FRX"
		A_LISTA[1]="RAG.SOCIALE;FID_RAGSOC;C;40"
		A_LISTA[2]="COD.CLIENTE;FID_CODCLI;C;10"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 2
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF
ENDCASE

RETURN


*****************************************************************************
PROCEDURE forprsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_FOR_PR"
		_V_REPORT = "FPR000.FRX"

		A_LISTA[1]="COD.FORNITORE;FPR_CODFOR;C;10"
		A_LISTA[2]="RAG.SOCIALE;FPR_RAGFOR;C;50"
		A_LISTA[3]="COD. ARTICOLO;FPR_CODART;C;16"
		A_LISTA[4]="DESCR. ARTICOLO;FPR_DESART;C;50"
		
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE msgsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_MSG_AU"
		_V_REPORT = "MSG000.FRX"

		A_LISTA[1]="MITTENTE;MSG_DESMIT;C;50"
		A_LISTA[2]="OPERATORE;MSG_DESOPE;C;50"
		A_LISTA[3]="DESTINATARIO;MSG_DESDES;C;50"

		
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN

*****************************************************************************
PROCEDURE agNsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa1'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_AGN_AN"
		_V_REPORT = "AGNLIST.FRX"
      
		A_LISTA[1]="NOME;AGN_NOME;C;40"
		A_LISTA[2]="COGNOME;AGN_COGNOME;C;40"	

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE cntsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_CNT_TT"
		_V_REPORT = "CNTLIST.FRX"
		A_LISTA[1]= "AGENTE;CNT_CODAGE;C;3"
		A_LISTA[2]= "RAGIONE SOCIALE;CNT_RAGSOC;C;50"
		A_LISTA[3]= "DATA INSERIMENTO;CNT_DATINS;C;10"
		A_LISTA[4]= "LOCALITA;CNT_LOCALI;C;50"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


*** EM INIZIO 27/04/04

*****************************************************************************
PROCEDURE leasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "U_LEA_TT"
		_V_REPORT = "LEA000.FRX"
		A_LISTA[1]= "NUMERO CONTRATTO;LEA_NUMCON;C;10"
		A_LISTA[2]= "DATA (aaaa/mm/gg);LEA_DATCON;C;10"
		A_LISTA[3]= "RAGIONE SOCIALE;LEA_RAGSOC;C;40"
		A_LISTA[4]= "PUNTO VENDITA;LEA_CODPDV;C;10"
		A_LISTA[5]= "COD.FORNITORE;LEA_CODCLI;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


*** EM FINE 27/04/04

*** EM INIZIO 28/04/04

*****************************************************************************
PROCEDURE finsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "U_FIN_TT"
		_V_REPORT = "FIN000.FRX"
		A_LISTA[1]= "NUMERO;fin_numcon;C;10"
		A_LISTA[2]= "DATA (aaaa/mm/gg);fin_datcon;C;10"
		A_LISTA[3]= "RAGIONE SOCIALE;fin_ragsoc;C;40"
		A_LISTA[4]= "PUNTO VENDITA;fin_codpdv;C;10"
		A_LISTA[5]= "COD.FORNITORE;fin_codcli;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN

*** EM FINE 28/04/04

*** EM INIZIO 29/04/04

*****************************************************************************
PROCEDURE asssta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "U_ASS_TT"
		_V_REPORT = "ASS000.FRX"
		A_LISTA[1]= "NUMERO ASSEGNO;ass_numass;C;10"
		A_LISTA[2]= "DATA (aaaa/mm/gg);ass_datass;C;10"
		A_LISTA[3]= "RAGIONE SOCIALE;ass_ragsoc;C;40"
		A_LISTA[4]= "PUNTO VENDITA;ass_codpdv;C;10"
		A_LISTA[5]= "COD.FORNITORE;ass_codcli;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN

*** EM FINE 29/04/04

*** EM INIZIO 30/04/04

*****************************************************************************
PROCEDURE consta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "U_CON_TT"
		_V_REPORT = "CON000.FRX"
		A_LISTA[1]= "NUMERO CONTRATTO;con_numcon;C;10"
		A_LISTA[2]= "DATA (aaaa/mm/gg);con_datcon;C;10"
		A_LISTA[3]= "RAGIONE SOCIALE;con_ragsoc;C;40"
		A_LISTA[4]= "PUNTO VENDITA;con_codpdv;C;10"
		A_LISTA[5]= "COD.FORNITORE;con_codcli;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN

*** EM FINE 30/04/04


*fb**************************************************************************
PROCEDURE PARCQsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_PAR_CQ"
		_V_REPORT = "parcqLIST.FRX"
      
		A_LISTA[1]="CODICE;PAR_CODART;C;16"
		A_LISTA[2]="DESCRIZIONE;PAR_DESART;C;50"	

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN

*****************************************************************************
PROCEDURE cq_mp
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "U_SLC_CQ"
		_V_REPORT = "cq_matprime.FRX"
		A_LISTA[1]= "CODICE PRODOTTO;SLC_CODART;C;16"
		A_LISTA[2]= "DESCRIZIONE PRODOTTO;SLC_DESART;C;50"
		A_LISTA[3]= "DATA ANALISI;SLC_DATANA;C;10"
		A_LISTA[4]= "CAMPIONE;SLC_CAMPIO;C;50"
		A_LISTA[5]= "RESPONSO;SLC_RESPON;C;1"
		A_LISTA[6]= "DATA RESPONSO;SLC_RESDAT;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


*****************************************************************************
PROCEDURE slcsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(7)
		_V_SELECT = "U_SLC_CQ"
		_V_REPORT = "SLCLIST.FRX"
		A_LISTA[1]= "CODICE PRODOTTO;SLC_CODART;C;16"
		A_LISTA[2]= "DESCRIZIONE PRODOTTO;SLC_DESART;C;50"
		A_LISTA[3]= "DATA ANALISI;SLC_DATANA;C;10"
		A_LISTA[4]= "RAGIONE SOCIALE CLIENTE;SLC_DESCLI;C;50"
		A_LISTA[5]= "CAMPIONE;SLC_CAMPIO;C;50"
		A_LISTA[6]= "RESPONSO;SLC_RESPON;C;1"
		A_LISTA[7]= "DATA RESPONSO;SLC_RESDAT;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


**EM*************************************************************************
PROCEDURE spcsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_PRO_MY"
		_V_REPORT = "SPC000.FRX"
		A_LISTA[1]= "CODICE SPESSORE;MIC_SPESSO;C;5"
		A_LISTA[2]= "TIPO MATERIALE;MIC_CODMAT;C;3"
		A_LISTA[3]= "DESCRIZIONE MATERIALE;MIC_DESMAT;C;30"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


**EM*************************************************************************
PROCEDURE cmpsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_PRO_CA"
		_V_REPORT = "CMP000.FRX"
		A_LISTA[1]= "CODICE TIPO LAVORAZIONE;CAP_CODLAV;C;3"
		A_LISTA[2]= "CODICE MACCHINA DI PRODUZIONE;CAP_CODMAC;C;3"
		A_LISTA[3]= "CODICE TIPO PRODOTTO;CAP_CODMAT;C;3"
		A_LISTA[4]= "CODICE FORMULA DI.BA.;CAP_CDDIBA;C;3"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN



**fb************************************************************************
PROCEDURE PARMYsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_PAR_MY"
		_V_REPORT = "PARMYLIST.FRX"
		A_LISTA[1]= "CODICE SPESSORE;PAR_CODSPE;N;5"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN

*prnlib.prg
**fb************************************************************************
PROCEDURE PARFIsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_PAR_FI"
		_V_REPORT = "PARFILIST.FRX"
		A_LISTA[1]= "CODICE ;PAR_CODICE;C;2"
		A_LISTA[2]= "DESCRIZIONE ;PAR_DESCRI;C;50"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


**FB************************************************************************
PROCEDURE MPAsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(12)
		_V_SELECT = "U_MPA_CQ"
		_V_REPORT = "MPALIST.FRX"
		A_LISTA[1]= "Codice componente ;MPA_CODART;C;16"
		A_LISTA[2]= "Descrizione componente ;MPA_DESART ;C;50"
		A_LISTA[3]= "Ragione sociale fornitore;MPA_DESFOR;C;50"
		A_LISTA[4]= "Num. ordine fornitore;MPA_NUMORF;C;6"
		A_LISTA[5]= "Data ordine fornitore;MPA_DATORF;C;10"
		A_LISTA[6]= "Data carico magazzino;MPA_DTCAMA;C;10"
		A_LISTA[7]= "Num. lotto interno;MPA_NUMLOT;C;6"
		A_LISTA[8]= "Data carico in CQ;MPA_DTCACQ;C;10"
		A_LISTA[9]= "Primo responso;MPA_RESPO1;C;1"
		A_LISTA[10]= "Data primo responso;MPA_RESDT1;C;10"
		A_LISTA[11]= "Secondo responso;MPA_RESPO2;C;1"
		A_LISTA[12]= "Data secondo responso;MPA_RESDT2;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN

**EM*************************************************************************
PROCEDURE lotsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "U_LOT_RI"
		_V_REPORT = "LOT000.FRX"
		A_LISTA[1]= "CODICE SOCIETA';LOT_CODSOC;C;2"
		A_LISTA[2]= "N°LOTTO INIZIALE;LOT_NLOINI;C;8"
		A_LISTA[3]= "DATA OPERAZIONE (aaaa/mm/gg);LOT_DATOPE;C;10"
		A_LISTA[4]= "CODICE CAUSALE;LOT_CODCAU;C;3"
		A_LISTA[5]= "N°LOTTO FINALE;LOT_NLOFIN;C;8"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


**FB************************************************************************
PROCEDURE MPfsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(12)
		_V_SELECT = "U_MPF_CQ"
		_V_REPORT = "MPFLIST.FRX"
		A_LISTA[1]= "Codice Film Nudo;MPF_CODART;C;16"
		A_LISTA[2]= "Descrizione Film Nudo;MPF_DESART ;C;50"
		A_LISTA[3]= "Ragione sociale fornitore;MPF_DESFOR;C;50"
		A_LISTA[4]= "Num. ordine fornitore;MPF_NUMORF;C;6"
		A_LISTA[5]= "Data ordine fornitore;MPF_DATORF;C;10"
		A_LISTA[6]= "Data carico magazzino;MPF_DTCAMA;C;10"
		A_LISTA[7]= "Num. lotto interno;MPF_NUMLOT;C;6"
		A_LISTA[8]= "Data carico in CQ;MPF_DTCACQ;C;10"
		A_LISTA[9]= "Primo responso;MPF_RESPO1;C;1"
		A_LISTA[10]= "Data primo responso;MPF_RESDT1;C;10"
		A_LISTA[11]= "Secondo responso;MPF_RESPO2;C;1"
		A_LISTA[12]= "Data secondo responso;MPF_RESDT2;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN

**FB************************************************************************
PROCEDURE SLFsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(11)
		_V_SELECT = "U_SLF_CQ"
		_V_REPORT = "SLFLIST.FRX"
		A_LISTA[1]= "Codice Film spalmato;SLF_CODART;C;16"
		A_LISTA[2]= "Descrizione Film spalmato;SLF_DESART ;C;50"
		A_LISTA[3]= "Num. lotto di produzione;SLF_NUMLOT;C;6"
		A_LISTA[4]= "Ragione sociale fornitore;SLF_DESFOR;C;50"
		A_LISTA[5]= "Num. lotto di carico;SLF_FNNULO;C;6"
		A_LISTA[6]= "Ragione sociale cliente;SLF_descli;C;50"
		A_LISTA[7]= "Data carico in CQ;SLF_DTCACQ;C;10"
		A_LISTA[8]= "Primo responso;SLF_RESPO1;C;1"
		A_LISTA[9]= "Data primo responso;SLF_RESDT1;C;10"
		A_LISTA[10]= "Secondo responso;SLF_RESPO2;C;1"
		A_LISTA[11]= "Data secondo responso;SLF_RESDT2;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


**EM*************************************************************************
PROCEDURE prista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(8)
		_V_SELECT = "U_PRO_IM"
		_V_REPORT = "PRO000.FRX"
		A_LISTA[1]= "CODICE LAVORAZIONE;IMP_CODLAV;C;3"
		A_LISTA[2]= "CODICE MACCHINA;IMP_CODMAC;C;3"
		A_LISTA[3]= "DATA IMPEGNATA (gg/mm/aaaa);INV_DATIMP;C;10"
		A_LISTA[4]= "SETTIMANA IMPEGNATA (nn/aaaa);INV_SETIMP;C;7"
		A_LISTA[5]= "N° PROGRAMMA 1;IMP_NRPRG1;C;6"
		A_LISTA[6]= "DATA PROGRAMMA 1 (gg/mm/aaaa);INV_DTPRG1;C;10"
		A_LISTA[7]= "N° PROGRAMMA 2;IMP_NRPRG2;C;6"
		A_LISTA[8]= "DATA PROGRAMMA 2 (gg/mm/aaaa);INV_DTPRG2;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


*****************************************************************************
*	PROCEDURA ELASTA SI TROVA NELLA LIBRERIA PRNLIB NELLA CARTELLA PRG
*****************************************************************************
PROCEDURE elasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 

	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_ELA_AN"
		_V_REPORT = "ELAAN00.FRX"
		A_LISTA[1]="DATA SOLARE;DATA_SOLAR;C;40"
		A_LISTA[2]="DATA ELABORAZIONE;DATAELA_01;C;10"
		A_LISTA[3]="PROCEDURA;PROC_01;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE 		

RETURN


**EM 21/07/2004**************************************************************
PROCEDURE alcsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_PRO_AL"
		_V_REPORT = "ALTCOMPA.FRX"
		A_LISTA[1]= "Alt.film nudo (mm);alt_finudo;N;5"
		A_LISTA[2]="Film sp.(mm) da;alt_fispda;N;5"
		A_LISTA[3]="Film sp.(mm) da;alt_fispal;N;5"
		A_LISTA[4]="Cil.gommato (mm);alt_cilgom;N;5"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE camsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_CAM_AN"
		_V_REPORT = "CAM000.FRX"
		A_LISTA[1]="CATEGORIA;CAM_CATEG;C;6"
		A_LISTA[2]="DESCRIZIONE;CAM_DESCR;C;40"
		A_LISTA[3]="CONTO CONTROPARTITA;CAM_CONTR;C;13"

	CASE  _p_routine='VALID-DAL'
	

	CASE  _p_routine='VALID-AL'
ENDCASE 		

RETURN

*****************************************************************************
PROCEDURE gpesta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "U_GPE_AN"
		_V_REPORT = "GPE000.FRX"
		A_LISTA[1]="MATRICOLA;GPE_MATRI;C;10"
		A_LISTA[2]="COGNOME;GPE_COGNOM;C;40"
		A_LISTA[3]="LOCALITA';GPE_LOCAL;C;40"
		A_LISTA[4]="BANCA;GPE_BANCA;C;5"
		A_LISTA[5]="DATA ASSUNZIONE (aaaa/mm/gg);GPE_DTASS;C;10"
		A_LISTA[6]="DATA CESSAZIONE (aaaa/mm/gg);GPE_DTCES;C;10"
		
	CASE  _p_routine='VALID-DAL'
	

	CASE  _p_routine='VALID-AL'
ENDCASE 		

RETURN


*****************************************************************************
PROCEDURE gppsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 

	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_GPP_MO"
		_V_REPORT = "GPP000.FRX"
		A_LISTA[1]="ANNO MESE MATRICOLA;GPP_ANNO+GPP_MESE+GPP_MATRI;C;16"  &&& 4
		A_LISTA[2]="MESE;GPP_MESE;C;2"
		A_LISTA[3]="MATRICOLA;GPP_MATRI;C;10"
		A_LISTA[4]="COGNOME;GPP_COGNOM;C;50"
	
	CASE  _p_routine='VALID-DAL'
		
		

	CASE  _p_routine='VALID-AL'
ENDCASE 
	
RETURN

*** SERGIO 07/08/2004 INIZIO
*****************************************************************************
PROCEDURE ascsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "U_ASC_TT"
		_V_REPORT = "ASS000.FRX"
		A_LISTA[1]= "NUMERO ASSEGNO;ass_numass;C;10"
		A_LISTA[2]= "DATA (aaaa/mm/gg);ass_datass;C;10"
		A_LISTA[3]= "RAGIONE SOCIALE;ass_ragsoc;C;40"
		A_LISTA[4]= "PUNTO VENDITA;ass_codpdv;C;10"
		A_LISTA[5]= "COD.CLIENTE;ass_codcli;C;10"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN

*** SERGIO 07/08/2004 FINE

*****************************************************************************
PROCEDURE comusta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "COMUNI"
		_V_REPORT = "COMUNI.FRX"

		A_LISTA[1]="CAP;CAP;C;5"
		A_LISTA[2]="Comune;COMUNE;C;40"
		A_LISTA[3]="Provincia;PROVINCIA;C;2"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE attsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_ATT_OP"
		_V_REPORT = "ATT000.FRX"

		A_LISTA[1]="Nome Procedura;ATT_PROCED;C;50"
		A_LISTA[2]="Descr.Procedura;ATT_DESPRO;C;100"
		A_LISTA[3]="Cod.Operatore;ATT_CODOPE;C;10"
		A_LISTA[4]="Descr.Operatore;ATT_NOMOPE;C;50"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE topsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_TOP_MO"
		_V_REPORT = "TOP000.FRX"

		A_LISTA[1]="Mag.Scarico;TOP_MAGSCA;C;06"
		A_LISTA[2]="Mag.Carico;TOP_MAGCAR;C;06"
		A_LISTA[3]="Causale Scar.;TOP_CAUSCA;C;04"
		A_LISTA[4]="Causale Car.;TOP_CAUCAR;C;04"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE provista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "PROVINCE"
		_V_REPORT = "PROVINCE.FRX"

		A_LISTA[1]="Sigla;SIGLA;C;03"
		A_LISTA[2]="Provincia;PROVINCIA;C;21"
		A_LISTA[3]="Cod.Regione;REGIONE;N;2"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN

*****************************************************************************
PROCEDURE pessta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_PES_VE"
		_V_REPORT = "TRASPPESI.FRX"

		A_LISTA[1]="Cod.Vettore;PES_CODVET;C;03"
		A_LISTA[2]="Descriz.Vettore;PES_DESVET;C;60"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE parsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "U_PAR_CT"
		_V_REPORT = "PAR000.FRX"

		A_LISTA[1]="Cod.Nazione;PAR_CODNAZ;C;03"
		A_LISTA[2]="Descriz.Nazione;PAR_DESNAZ;C;50"
		A_LISTA[3]="Tipo Trasp.;PAR_TIPTRA;C;01"
		A_LISTA[4]="Descr.Trasp.;PAR_DESTRA;C;50"
		
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE mansta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "U_MAN_CO"
		_V_REPORT = "MANDRCOMP.FRX"

		A_LISTA[1]="Altezza Da;MAN_ALTEDA;N;5"
		A_LISTA[2]="Lunghezza Da;MAN_LUNGDA;N;6"
		A_LISTA[3]="Spessore Da;MAN_SPESDA;N;5"
		A_LISTA[4]="Cod.Personal.;MAN_CODPER;C;02"
		A_LISTA[5]="Cod.Mandrino;MAN_CODMAN;C;16"
		A_LISTA[6]="Descr.Mandrino;MAN_DESMAN;C;50"
	
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE regiosta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "REGIONI"
		_V_REPORT = "REGIONI.FRX"

		A_LISTA[1]="Cod.Regione;CODICE;N;2"
		A_LISTA[2]="Descr.Regione;REGIONE;C;21"
	
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE cassta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "U_CAS_TT"
		_V_REPORT = "CASLIST.FRX"

		A_LISTA[1]="Codice cliente;CAS_CODCLI;C;10"
		A_LISTA[2]="Ragione sociale;CAS_RAGSOC;C;50"
		A_LISTA[3]="Numero scatola;CAS_NUMSCA;C;6"
		A_LISTA[4]="Data scatola (aaaa/mm/gg);CAS_DATSCA;C;10"
		A_LISTA[5]="Numero scheda;CAS_NUMSCH;C;6"
		A_LISTA[6]="Tipo documento;CAS_CODDOC;C;4"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE matsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_CAS_AN"
		_V_REPORT = "MAT000.FRX"

		A_LISTA[1]="COD.MATRICOLA;CAS_MATRIC;C;16"
		A_LISTA[2]="COGNOME;CAS_COGNOM;C;50"
		A_LISTA[3]="NOME;CAS_NOME;C;50"
				
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE prvagliscsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "U_PRV_AL"
		_V_REPORT = "prvaglisc.FRX"

		A_LISTA[1]="COD.AGENTE;PRV_CODAGE;C;3"
		A_LISTA[2]="COD.LINEA;PRV_CODLIN;C;3"
				
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE budstaam
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_BUD_AM"
		_V_REPORT = "bud_am000.FRX"

		A_LISTA[1]="COD.ARTICOLO;BUD_CODART;C;16"
		A_LISTA[2]="ANNO;BUD_ANNO;C;4"
		A_LISTA[3]="MESE;BUD_MESE;C;2"		
				
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE cersta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(8)
		_V_SELECT = "U_CER_CO"
		_V_REPORT = "CERT_CONF.FRX"

		A_LISTA[1]="Numero DDT;CER_NUMDDT;C;6"
		A_LISTA[2]="Data DDT (aaaa/mm/gg);CER_DATDDT;C;10"
		A_LISTA[3]="Rag.Sociale Cliente;CER_RAGSOC;C;80"
		A_LISTA[4]="Cod.Articolo;CER_CODART;C;16"
		A_LISTA[5]="Numero lotto;CER_NRLINT;N;8;0"	
		A_LISTA[6]="Tipo Programma;CER_TIPPRG;C;1"
		A_LISTA[7]="Numero Programma;CER_NUMPRG;C;6"
		A_LISTA[8]="Data Programma (aaaa/mm/gg);CER_AMGPRG;C;10"
		
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE ammcatsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "U_AMM_CA"
		_V_REPORT = "AMMCAT.FRX"

		A_LISTA[1]="Codice;AMM_CODAMM;C;10"
		A_LISTA[2]="Descrizione 1;AMM_DESCR1;C;50"
		A_LISTA[3]="Perc.ammortamento base;AMM_PERAMM;N;6;2"		
		A_LISTA[4]="Conto contabile;AMM_CONTAB;C;13"		
		A_LISTA[5]="Contropartita contabile;AMM_CONPAR;C;13"						
				
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN



*****************************************************************************
PROCEDURE ammcessta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(5)
		_V_SELECT = "U_AMM_AT"
		_V_REPORT = "AMMCES.FRX"

		A_LISTA[1]="Codice;AMM_CODCES;C;16"
		A_LISTA[2]="Descrizione;AMM_DESCRI;C;50"
		A_LISTA[3]="Categ.apparten.;AMM_CODCAT;C;10"		
		A_LISTA[4]="Tipo categ.;AMM_TIPCAT;C;2"
		A_LISTA[5]="Flag nuovo/usato;AMM_FLGNEW;C;1"						
				
	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE aggancsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
	 	  DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		  PUBLIC A_LISTA(2)
		  _V_SELECT  = "PARA"
		  _V_REPORT  = "AGGANC000.FRX"
  		  A_LISTA[1] = "Codice;CODICE;C;3"
		  A_LISTA[2] = "Descrizione;DESCRI;C;60"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE conantsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_ANF_TT"
		_V_REPORT = "CONANT000.FRX"

		A_LISTA[1]="COD.CLIENTE;RIC_CODCLI;C;10"
		A_LISTA[2]="RAGIONE SOCIALE;RIC_RAGSOC;C;40"
		A_LISTA[3]="NUMERO FATTURA;RIC_NFATT;C;6"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE anaazista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "ANAAZI"
		_V_REPORT = "ANAAZI000.FRX"

		A_LISTA[1]="Tipo Cli./For.(S/N);B_Client;C;1"
		A_LISTA[2]="Codice;Codice;C;16"
		A_LISTA[3]="Ragione Sociale;RagSoc;C;100"
		A_LISTA[4]="Acronimo;Acronimo;C;100"
		A_LISTA[5]="Comune;ComuneInd;C;250"
		A_LISTA[6]="Telefono;Telefono;C;50"

	CASE  _p_routine='VALID-DAL'
*!*			IF _V_SCELTA = 2
*!*				IF SUBSTR(_V_DAL,1,1)  <  "A"
*!*				  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
*!*				ENDIF
*!*			ENDIF

	CASE  _p_routine='VALID-AL'
*!*			IF _V_SCELTA = 2
*!*				IF SUBSTR(_V_AL,1,1)  <  "A"
*!*				  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
*!*				ENDIF
*!*			ENDIF

		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE risumanasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(6)
		_V_SELECT = "RISUMANA"
		_V_REPORT = "RISUMANA000.FRX"
		
		A_LISTA[1]="Codice;Codice;C;6"
		A_LISTA[2]="Cognome;Cognome;C;100"
		A_LISTA[3]="Nome;Nome;C;50"
		A_LISTA[4]="Sigla;Sigla;C;2"
		A_LISTA[5]="Sesso;Sesso;C;1"
		A_LISTA[6]="Cod.Fiscale;CodFiscale;C;16"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(5,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(5,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

		
ENDCASE

RETURN



*****************************************************************************
PROCEDURE commessasta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
*!*			PUBLIC A_LISTA(2)
*!*			_V_SELECT = "COMMESSA"
		**=> ERASMO - INIZIO 26/02/2008
		PUBLIC A_LISTA(7)
		_V_SELECT = "COMMESSA_TT"
		**=> ERASMO - FINE 26/02/2008
		_V_REPORT = "COMMESSA000.FRX"
		
		A_LISTA[1]="Codice;Codice;C;25"
		A_LISTA[2]="Data (aaaa/mm/gg);D_Data;C;10"
		**=> ERASMO - INIZIO 26/02/2008
		A_LISTA[3]="Tipo (Interna=1/Esterna=2);B_Interna;N;1"
		A_LISTA[4]="Centro competenza;CentrCom;C;5"
		A_LISTA[5]="Classificazione;ClassTC;C;2"
		A_LISTA[6]="Area di mercato;AreaMerc;C;3"
		A_LISTA[7]="Codice Resp.comm.le;RisUResp;C;5"
		**=> ERASMO - FINE 26/02/2008

	CASE  _p_routine='VALID-DAL'
*!*			IF _V_SCELTA = 2
*!*				IF SUBSTR(_V_DAL,1,1)  <  "A"
*!*				  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
*!*				ENDIF
*!*			ENDIF

	CASE  _p_routine='VALID-AL'
*!*			IF _V_SCELTA = 2
*!*				IF SUBSTR(_V_AL,1,1)  <  "A"
*!*				  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
*!*				ENDIF
*!*			ENDIF

		
ENDCASE

RETURN



*****************************************************************************
PROCEDURE timeshtsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "TIMESHT"
		_V_REPORT = "TIMESHT000.FRX"
		
		A_LISTA[1]="ID Time Sheet;IDTimeSht;C;32"
		A_LISTA[2]="ID Risorsa Umana;IDRisUmana;C;32"
		A_LISTA[3]="Data;D_Data;C;8"
		A_LISTA[4]="Fatturato (1/0);FlgFatt;N;1"

	CASE  _p_routine='VALID-DAL'
*!*			IF _V_SCELTA = 2
*!*				IF SUBSTR(_V_DAL,1,1)  <  "A"
*!*				  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
*!*				ENDIF
*!*			ENDIF

	CASE  _p_routine='VALID-AL'
*!*			IF _V_SCELTA = 2
*!*				IF SUBSTR(_V_AL,1,1)  <  "A"
*!*				  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
*!*				ENDIF
*!*			ENDIF

		
ENDCASE

RETURN



*****************************************************************************
PROCEDURE bdgsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg,.T. LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "U_BDG_AN"
		_V_REPORT = "BDG000.FRX"

		A_LISTA[1]="Codice cliente;BDG_CODCLI;C;10"
		A_LISTA[2]="Ragione sociale;BDG_RAGSOC;C;80"
		A_LISTA[3]="Nazione;BDG_CODNAZ;C;3"
		
		PUBLIC A_LISTA2(2)
		A_LISTA2[1]="Solo anno corrente"
		A_LISTA2[2]="Tutti gli anni"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE ricemacsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg,.F. LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "RICEMAC_TT"
		_V_REPORT = "RICEMAC_TT.FRX"

		A_LISTA[1]="Codice;CODICE;C;10"
		A_LISTA[2]="Prodotto;PRODOTTO;C;16"
		A_LISTA[3]="Fascia;FASCIA;C;4"
		A_LISTA[4]="Materiale;MATERIALE;C;80"

	CASE  _p_routine='VALID-DAL'
*!*			IF _V_SCELTA = 1
*!*				IF SUBSTR(_V_DAL,1,1)  <  "A"
*!*				  _V_DAL = TRC(PUB_LCL,ALLTRIM(_V_DAL))
*!*				ENDIF
*!*			ENDIF

	CASE  _p_routine='VALID-AL'
*!*			IF _V_SCELTA = 1
*!*				IF SUBSTR(_V_AL,1,1)  <  "A"
*!*				  _V_AL = TRC(PUB_LCL,ALLTRIM(_V_AL))
*!*				ENDIF
*!*			ENDIF

ENDCASE

RETURN


*****************************************************************************
PROCEDURE turnista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg,.F. LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "TURNI_TT"
		_V_REPORT = "TURNI_TT.FRX"

		A_LISTA[1]="Codice;TUR_CODICE;C;3"
		A_LISTA[2]="Data Inizio;TUR_DATINI;C;10"
		A_LISTA[3]="Data Fine;TUR_DATFIN;C;10"

	CASE  _p_routine='VALID-DAL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_DAL,1,1)  <  "A"
			  _V_DAL = TRC(3,ALLTRIM(_V_DAL))
			ENDIF
		ENDIF
		IF _V_SCELTA = 2 .OR. _V_SCELTA = 3  
			IF SUBSTR(_V_DAL,3,1) =  "/" .AND. SUBSTR(_V_DAL,6,1) =  "/"
				IF VALID_DATA(_V_DAL)
					_V_DAL=OK_DATA(_V_DAL)   
				ELSE
					MESSAGEBOX("Data non valida",16,"Attenzione")
					RETURN .F.
				ENDIF
				_V_DAL = RIBALTA2(_V_DAL)
			ENDIF
		ENDIF

	CASE  _p_routine='VALID-AL'
		IF _V_SCELTA = 1
			IF SUBSTR(_V_AL,1,1)  <  "A"
			  _V_AL = TRC(3,ALLTRIM(_V_AL))
			ENDIF
		ENDIF
		IF _V_SCELTA = 2 .OR. _V_SCELTA = 3
			IF SUBSTR(_V_AL,3,1) =  "/" .AND. SUBSTR(_V_AL,6,1) =  "/"
				IF VALID_DATA(_V_AL)
					_V_AL=OK_DATA(_V_AL)   
				ELSE
					MESSAGEBOX("Data non valida",16,"Attenzione")
					RETURN .F.
				ENDIF
				_V_AL = RIBALTA2(_V_AL)
			ENDIF
		ENDIF

ENDCASE

RETURN



*****************************************************************************
PROCEDURE attincsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "ATTIVITANC"
		_V_REPORT = "ATTIVITANC.FRX"

		A_LISTA[1]="CLIENTE;RAGSOC;C;50"
		A_LISTA[2]="ATTIVITA';DESATTIV;C;50"
*!*		A_LISTA[3]="ATTIVITA';DESATTIV;C;50"
			

	CASE  _p_routine='VALID-DAL'
		
	CASE  _p_routine='VALID-AL'
		
		
ENDCASE

RETURN



*****************************************************************************
PROCEDURE codiciclista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif



* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(1)
		_V_SELECT = "U_CLI_EX"
		_V_REPORT = "codicicli.FRX"

		A_LISTA[1]="COD.CLIENTE;CODCLI_AQUARIUS;C;10"
*!*			A_LISTA[2]="ATTIVITA';DESATTIV;C;50"

			
	CASE  _p_routine='VALID-DAL'
		
	CASE  _p_routine='VALID-AL'
		
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE budgetsintsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif



* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

SET STEP ON 

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "BUDGET_SINT_TT"
		_V_REPORT = "budgetsintlist.FRX"


		A_LISTA[1]="Cod.Budget;CODICE;C;25"
		A_LISTA[2]="Titolo;TITOLO;C;40"
*!*			A_LISTA[3]="ATTIVITA';DESATTIV;C;50"

			
	CASE  _p_routine='VALID-DAL'
		
	CASE  _p_routine='VALID-AL'
		
		
ENDCASE

RETURN


*****************************************************************************
PROCEDURE bclsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(7)
		_V_SELECT = "U_BOL_TT"
		_V_REPORT = "BOLLIST.FRX"

		A_LISTA[1]="NUMERO BOLLA;ORD_NUMORD;C;6"
		A_LISTA[2]="DATA BOLLA;ORD_DATORD;C;10"
		A_LISTA[3]="LOCALITÀ;ORD_LOCALI;C;30"
		A_LISTA[4]="MAGAZZINO;ORD_MAGS;C;6"
		A_LISTA[5]="CLIENTE EMITTENTE;ORD_RAGEMI;C;30"
		A_LISTA[6]="CLIENTE IN FATTURAZIONE;ORD_RAGSOC;C;30"
		A_LISTA[7]="LOCALITÀ DI DESTINAZIONE;ORD_LOCC;C;70"


		RELEASE DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		PUBLIC DDT_ITA,DDT_MAN,DDT_EXP,DDT_ALL
		DDT_ITA = .F.
		DDT_EXP = .F.
		DDT_ALL = .F.

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'

ENDCASE

RETURN


*****************************************************************************
PROCEDURE blosta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'


DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(2)
		_V_SELECT = "BLOCCAPN"
		_V_REPORT = "BLOLIST.FRX"
		A_LISTA[1]= "DATA BLOCCO DAL;BPN_DATADAL;C;10"
		A_LISTA[2]= "DATA BLOCCO AL;BPN_DATAAL;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		

ENDCASE

RETURN




*****************************************************************************
PROCEDURE mdbsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
   =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
   return
endif

* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
   CASE _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
   CASE _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "CONTRMDB"
		_V_REPORT = "MDBLIST.FRX"
		A_LISTA[1]= "AGENTE;ORD_AGE;C;3"
		A_LISTA[2]= "NUMERO ORDINE;ORD_NUMORD;C;6"
		A_LISTA[3]= "DATA ORDINE;ORD_DATORD;C;10"
		A_LISTA[4]= "LOCALITA;ORD_LOCALI;C;30"
   CASE _p_routine='VALID-DAL'
   CASE _p_routine='VALID-AL'
ENDCASE

RETURN


** SERGIO INIZIO 06/10/2022

*****************************************************************************
PROCEDURE richsta
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif


* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'
_TESTO = ""	&& 05/07/2023 SERGIO

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(4)
		_V_SELECT = "IMPIANTI_RI"
		_V_REPORT = "RICHINT.FRX"

		A_LISTA[1]="IMPIANTO ;ORD_CCODSCHE;C;20"
		A_LISTA[2]="DATA RICHIESTA;ORD_DATA;C;10"
		A_LISTA[3]="NOTE;ORD_NOTERIC;C;254"
		A_LISTA[4]="APE/CLO;ORD_APECLO;C;10"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN
** SERGIO FINE 06/10/2022







** SERGIO INIZIO 22/10/2022

*****************************************************************************
PROCEDURE lisista
*****************************************************************************
PARAMETERS _p_nomeprg,_p_routine

IF EMPTY(_p_routine)
  =MESSAGEBOX("Impossibile eseguire la stampa, manca parametro 'ROUTINE'","*** ATTENZIONE ***")
  return
endif


* -->> nome del form da eseguire
* --------------------------------------
_p_nomesta='Stampa'

DO CASE 
	CASE  _p_routine='START'
		DO FORM form\&_p_nomesta WITH _p_nomeprg LINKED 
	CASE  _p_routine='LOAD'
		PUBLIC A_LISTA(3)
		_V_SELECT = "IMPIANTI_LI"
		_V_REPORT = "LISTIMPIANTI.FRX"

		A_LISTA[1]="CODICE ;LIS_CODLIS;C;6"
		A_LISTA[2]="DATA LISTINO DAL ;LIS_DATLIS;C;10"
		A_LISTA[3]="NOTE;LIS_NOTELIS;C;254"

	CASE  _p_routine='VALID-DAL'

	CASE  _p_routine='VALID-AL'
		
ENDCASE

RETURN
** SERGIO FINE 22/10/2022
