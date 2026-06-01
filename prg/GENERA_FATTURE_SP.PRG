
****************************************************************************************************************
*** PROCEDURA DI GENERAZIONE FATTURE PROFORMA O FATTURE CLIENTI (IN BASE AL PARAMETRO DI SISTEMA PUB_FATSTU) ***
*** IN FUNZIONE DEL CURSORE DI FATTURABILE PASSATO NEI PARAMETRI                                             ***
****************************************************************************************************************

PARAMETERS _NOME_CUR_FATTURABST,_MSG_ALERT

CONTA_FAP = 0

_PRIMA_FATTURA = .T.
_Z_NUMEDA = ""
_Z_NUMEAL = ""
_Z_ANNO   = SUBSTR(_V_DATFAT,7,4)

DO GEN_FAT_FAP_SP

WAIT CLEAR

_MSG = ""
IF CONTA_FAP > 0
   _MSG = _MSG + "Totale fatture create : " + ALLTRIM(STR(CONTA_FAP,10,0)) + CHR(13)
ENDIF

IF !EMPTY(ALLTRIM(_MSG))
	IF PUB_FATSTU
		MESSAGEBOX("Fatture generate correttamente " + CHR(13) + CHR(13) + _MSG,64,"Informazione")
	ELSE
		MESSAGEBOX("Fatture proforma generate correttamente " + CHR(13) + CHR(13) + _MSG,64,"Informazione")
	ENDIF

	_RISP = MESSAGEBOX("Aprire l'utilità di ristampa documenti per" + CHR(13) + ;
	                   "visualizzare e/o stampare le fatture create?",36,"Attenzione")
	IF _RISP = 6
	   *THISFORM.Hide
	   IF PUB_FATSTU
	      do form form\menu_ristampa_doc with "FAT",_Z_NUMEDA,_Z_NUMEAL,_Z_ANNO
	   ELSE
	      do form form\menu_ristampa_doc with "FAP",_Z_NUMEDA,_Z_NUMEAL,_Z_ANNO
	   ENDIF
	   *THISFORM.Show
	ENDIF
ELSE
	IF _MSG_ALERT
		MESSAGEBOX("Nessuna generazione fatture effettuata",48,"Informazione")
	ENDIF
ENDIF

RETURN


PROCEDURE GEN_FAT_FAP_SP

CREATE CURSOR WW_FATTURABILE (ID_UNIQUE C(36), TIPO C(10), NUMFAP C(06), DATFAP C(10))

IF !ExecCommand("select * from U_FAP_TT where 0=1","CUX_FAP_TT")
   return(.f.)
ENDIF
IF !ExecCommand("select * from U_FAP_DD where 0=1","CUX_FAP_DD")
   return(.f.)
ENDIF

_NUMERO_FATTURA_TROVATO = .F.
_V_NUMFAT = 0

IF PUB_FATSTU
	v_seek	= ACCESS_YEAR('NUMFAT'+PUB_CODSOC)
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	   _V_NUMFAT = VAL(ALLTRIM(SUBSTR(LIBERA,2,7)))
	   _NUMERO_FATTURA_TROVATO = .T.			&& SERGIO 2017/01/03 : LA PRIMA VOLTA è SICURAMENTE = 0	
	ELSE
	   _V_NUMFAT = 0
	ENDIF
ELSE
	v_seek	= ACCESS_YEAR('NUMFAP'+PUB_CODSOC)
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	   _V_NUMFAT = VAL(ALLTRIM(SUBSTR(LIBERA,2,7)))
	   _NUMERO_FATTURA_TROVATO = .T.			&& SERGIO 2017/01/03 : LA PRIMA VOLTA è SICURAMENTE = 0	   
	ELSE
	   _V_NUMFAT = 0
	ENDIF
ENDIF

IF !_NUMERO_FATTURA_TROVATO		&& SERGIO 2017/01/03 : LA PRIMA VOLTA è SICURAMENTE = 0	  
*!*	IF _V_NUMFAT = 0			&& SERGIO 2017/01/03 : LA PRIMA VOLTA è SICURAMENTE = 0	 
	IF PUB_FATSTU
		MESSAGEBOX("Numero progressivo Fattura non trovato" + CHR(13) + CHR(13) + "Impossibile continuare",16,"Attenzione")
	ELSE
		MESSAGEBOX("Numero progressivo Fattura proforma non trovato" + CHR(13) + CHR(13) + "Impossibile continuare",16,"Attenzione")
	ENDIF
	RETURN .F.
ENDIF

SELECT DISTINCT CODCLI,RAGSOC,REGFAT,RFAT_T,RFAT_Q,RFAT_C FROM &_NOME_CUR_FATTURABST INTO CURSOR ELENCO_CLIENTI READWRITE
SELECT ELENCO_CLIENTI
GO TOP
IF EOF()
	MESSAGEBOX("Nessun cliente nel Fatturabile selezionato",16,"Attenzione")
	RETURN .F.
ENDIF

IF _MSG_ALERT
	IF PUB_FATSTU
		_RISP = MESSAGEBOX("Generare le fatture effettive in base alle selezioni effettuate?",292,"Attenzione")
	ELSE
		_RISP = MESSAGEBOX("Generare le fatture proforma in base alle selezioni effettuate?",292,"Attenzione")
	ENDIF
	IF _RISP = 7
		MESSAGEBOX("Operazione abbandonata",62,"Attenzione")
		RETURN .F.
	ENDIF
ENDIF

WAIT WINDOWS "Elaborazione in corso... - Prego attendere" NOWAIT

DO GEN_FAT_FAP_SP_X_CLIENTE

IF CONTA_FAP > 0
ELSE
   RETURN .F.
ENDIF

IF PUB_FATSTU

	*** AGGIORNO I PARAMETRI CON L'ULTIMO NUMERO FATTURA REGISTRATO
	v_seek  = ACCESS_YEAR('NUMFAT'+PUB_CODSOC)
	v_chiave= "codice"
	cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
	IF !ExecRW(cSql,"PARA","R")
	   return(.f.)
	ENDIF
	SELECT PARA
	IF EOF()
	ELSE
	   V2 = _V_NUMFAT
	   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
	ENDIF
	IF !ExecRW(cSql,"PARA","W")
	   return(.f.)
	ENDIF

	IF !ExecRW('','u_FAT_tt','I','','CUX_FAP_TT')
	   return(.f.)
	ENDIF
	IF !ExecRW('','u_FAT_dd','I','','CUX_FAP_DD')
	   return(.f.)
	ENDIF
	
	*** AGGIORNO ALTRI DATI IN TESTATE FATTURE
	SELECT CUX_FAP_TT
	INDEX ON TAGGANCIO TAG I_AGGA
	SET ORDER TO I_AGGA
	GO TOP
	DO WHILE .T.
	   IF EOF()
	      EXIT
	   ENDIF
	   IF DELETED()
	      SKIP +1
	      LOOP
	   ENDIF
	   
	   SCATTER MEMVAR MEMO
	   
	   M.ORD_NPROT = SPACE(06)
	   v_seek  = 'NUMPRC'+PUB_CODSOC
	   v_chiave= "codice"
	   cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
	   IF !ExecRW(cSql,"PARA","R")
	      return(.f.)
	   ENDIF
	   SELECT PARA
	   IF RECCOUNT() <> 0
		  V2=VAL(SUBSTR(LIBERA,1,7)) + 1
		  REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
		  M.ORD_NPROT = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
	   ELSE
	      *RIT = MSGBOX('Parametro numero protocollo non trovato','ATTENZIONE',31)
	 	  *RETURN
	   ENDIF
	   IF !ExecRW(cSql,"PARA","W")
	      return(.f.)
	   ENDIF
	   
	   v_seek   = M.TAGGANCIO
	   v_chiave = "taggancio"
	   cSql     = "select * from u_FAT_tt where " + v_chiave + " = '" + v_seek + "'"
	   IF !ExecRW(cSql,"U_FAT_TT","R")
	      return(.f.)
	   ENDIF
	   SELECT U_FAT_TT
	   IF RECCOUNT() <> 0
	      *REPLACE ORD_VALORE WITH M.T_VALORE
	      *REPLACE ORD_DTSCAD WITH M.ORD_DTSCAD
	      REPLACE ORD_NPROT  WITH M.ORD_NPROT
	   ENDIF
	   IF !ExecRW(cSql,"U_FAT_TT","W")
	      return(.f.)
	   ENDIF
	   
	   SELECT CUX_FAP_TT
	   SKIP +1
	ENDDO
ELSE
	*** AGGIORNO I PARAMETRI CON L'ULTIMO NUMERO FATTURA REGISTRATO
	v_seek  = ACCESS_YEAR('NUMFAP'+PUB_CODSOC)
	v_chiave= "codice"
	cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
	IF !ExecRW(cSql,"PARA","R")
	   return(.f.)
	ENDIF
	SELECT PARA
	IF EOF()
	ELSE
	   V2 = _V_NUMFAT
	   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
	ENDIF
	IF !ExecRW(cSql,"PARA","W")
	   return(.f.)
	ENDIF

	IF !ExecRW('','u_FAP_tt','I','','CUX_FAP_TT')
	   return(.f.)
	ENDIF
	IF !ExecRW('','u_FAP_dd','I','','CUX_FAP_DD')
	   return(.f.)
	ENDIF

	*** AGGIORNO ALTRI DATI IN TESTATE FATTURE
	SELECT CUX_FAP_TT
	INDEX ON TAGGANCIO TAG I_AGGA
	SET ORDER TO I_AGGA
	GO TOP
	DO WHILE .T.
	   IF EOF()
	      EXIT
	   ENDIF
	   IF DELETED()
	      SKIP +1
	      LOOP
	   ENDIF
	   
	   SCATTER MEMVAR MEMO
	   

	   M.ORD_NPROT = SPACE(06)
	   v_seek  = 'NUMPRC'+PUB_CODSOC
	   v_chiave= "codice"
	   cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
	   IF !ExecRW(cSql,"PARA","R")
	      return(.f.)
	   ENDIF
	   SELECT PARA
	   IF RECCOUNT() <> 0
		  V2=VAL(SUBSTR(LIBERA,1,7)) + 1
		  REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
		  M.ORD_NPROT = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
	   ELSE
	      *RIT = MSGBOX('Parametro numero protocollo non trovato','ATTENZIONE',31)
	 	  *RETURN
	   ENDIF
	   IF !ExecRW(cSql,"PARA","W")
	      return(.f.)
	   ENDIF
	   
	   v_seek   = M.TAGGANCIO
	   v_chiave = "taggancio"
	   cSql     = "select * from u_FAP_tt where " + v_chiave + " = '" + v_seek + "'"
	   IF !ExecRW(cSql,"U_FAP_TT","R")
	      return(.f.)
	   ENDIF
	   SELECT U_FAP_TT
	   IF RECCOUNT() <> 0
	      *REPLACE ORD_VALORE WITH M.T_VALORE
	      *REPLACE ORD_DTSCAD WITH M.ORD_DTSCAD
	      REPLACE ORD_NPROT  WITH M.ORD_NPROT
	   ENDIF
	   IF !ExecRW(cSql,"U_FAP_TT","W")
	      return(.f.)
	   ENDIF
	   
	   SELECT CUX_FAP_TT
	   SKIP +1
	ENDDO
ENDIF

*** CONTRASSEGNO I RECORD DI FATTURABILE COME FATTURATI
SELECT WW_FATTURABILE
GO TOP
SCAN
   _XX_ID_UNIQUE = ID_UNIQUE
   _XX_NUMFAP = NUMFAP
   _XX_DATFAP = DATFAP
   x_unqe = "id_unique = '" + _XX_ID_UNIQUE + "'"
   x_cond = x_unqe 
   cSql   = "UPDATE FATTURABST SET FATTURATO = 1, NUMFAP = '" + _XX_NUMFAP + "', DATFAP = '" + _XX_DATFAP + "' WHERE " + x_cond
   IF !ExecCommand(cSql,"UPD_FATTURABST")
      return(.f.)
   ENDIF     
ENDSCAN


RETURN


PROCEDURE GEN_FAT_FAP_SP_X_CLIENTE


*** GENERA N FATTURE PER OGNI CLIENTE A SECONDA DELLE REGOLE DI FATTURAZIONE DEFINITE

SELECT ELENCO_CLIENTI 
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   _XXX_CODCLI = ALLTRIM(CODCLI)
   _XXX_REGFAT = REGFAT
   _XXX_RFAT_T = RFAT_T
   _XXX_RFAT_Q = RFAT_Q
   _XXX_RFAT_C = RFAT_C
   
   IF _XXX_REGFAT = 2
      
      DO GEN_FAT_FAP_SP_X_CLIENTE_TIPO_ELABORAZIONE
      
      IF CONTA_FAP > 0
      ELSE
         RETURN .F.
      ENDIF
      SELECT ELENCO_CLIENTI 
      SKIP +1
      LOOP
   ENDIF
   
   IF !ExecCommand("select * from u_FAP_tt where 0=1","cur_FAP_tt")
      return(.f.)
   ENDIF
   SELECT cur_FAP_tt
   SCATTER MEMVAR MEMO BLANK
   
   _V_NUMFAT = _V_NUMFAT + 1
   M.ORD_NUMORD = ALLTRIM(STR(_V_NUMFAT,6,0))
   M.ORD_NUMORD = TRC(6,ALLTRIM(M.ORD_NUMORD))
   M.ORD_CODSOC = PUB_CODSOC
   M.ORD_DATORD	= _V_DATFAT
   IF SUBSTR(M.ORD_DATORD,3,1) = '/'
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,7,4)
   ELSE
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,1,4)
   ENDIF
   
   IF PUB_FATSTU
      M.TAGGANCIO = STR(NEWPROG('NUMFAT'),10)
   ELSE
      M.TAGGANCIO = STR(NEWPROG('NUMFAP'),10)
   ENDIF
   
   M.ORD_CODSYS = SYS(2015)
   
   M.ORD_CDC    = ""
   M.ORD_NUMCOC = ""
   M.ORD_DATCOC = ""
   
   IF PUB_FATSTU
      WAIT WINDOW "Creazione fattura n° " + ALLTRIM(M.ORD_NUMORD) + " del " + ALLTRIM(M.ORD_DATORD) nowait
   ELSE
      WAIT WINDOW "Creazione fattura proforma n° " + ALLTRIM(M.ORD_NUMORD) + " del " + ALLTRIM(M.ORD_DATORD) nowait
   ENDIF

   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + _XXX_CODCLI + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      return(.f.)
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP
   IF EOF()
      MESSAGEBOX("Cliente " + _XXX_CODCLI + " non trovato in anagrafica clienti" + CHR(13) + CHR(13) + ;
                 "Impossibile proseguire",16,"Attenzione")
      RETURN .F.
   ENDIF
   M.ORD_CODCLI = CLI_CODCLI

   SELECT CUR_CLIENTI 

   M.TNUMERO    = M.ORD_NUMORD
   M.ORD_RAGSOC = CLI_RAGSOC
   M.ORD_INDIRI = CLI_INDIR
   M.ORD_CAP    = CLI_CAP
   M.ORD_LOCALI = CLI_LOCALI
   M.ORD_PROVIN = CLI_PROVIN
   M.ORD_PARIVA = CLI_PARIVA
   IVA_ESE      = CLI_ALRID
   IVA_CLI      = CLI_CODIVA               
   V_CLIES      = CLI_CLIES
   V_DTCLES	    = CLI_DTCLES
   V_NSES       = CLI_NSES
   V_DTNSES	    = CLI_DTNSES
   M.ORD_VALUTA = CLI_VALUTA
 
   IF EMPTY(M.ORD_VALUTA)  
      M.ORD_VALUTA = PUB_VALRIF
   ENDIF

   M.ORD_CPA   = CLI_CONPAG
   
   M.ORD_BANCA = CLI_BAE
   IF M.ORD_VALUTA = PUB_VALRIF
      M.ORD_CAMBIO = 1
   ENDIF

   SAV_BANCA    = CLI_BAE
   M.ORD_CODNAZ	= CLI_NAZION
   IF EMPTY(M.ORD_CODNAZ) 
      M.ORD_CODNAZ = "ITA"
   ENDIF
   M.ORD_AGE = CLI_AGE
   IF EMPTY(M.ORD_AGE)
      M.ORD_AGE = CLI_AGE
   ENDIF
   M.ORD_CAUS = PUB_FAPRO
   IF EMPTY(M.ORD_CAUS)
      M.ORD_CAUS = PUB_FAPRO  
   ENDIF  
   M.ORD_PRORIT = CLI_PROVVI
   M.ORD_SC1T   = CLI_SC1
   M.ORD_SC2T   = CLI_SC2
   M.ORD_SC3T   = CLI_SC3

   **==> Controllo di non esistenza doppione di numero fattura
   _spazio= SPACE(01)
   x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
   x_anno = "ord_anno = '" + SUBSTR(M.ORD_DATORD,7,4) + "'"
   x_nord = "ord_numord   = '" + M.ORD_NUMORD + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_nord

   IF PUB_FATSTU
	   cSql = "select * from u_FAT_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord,ord_age"
	   IF !ExecCommand(cSql,"CUR_TESTATA")
	      RETURN .F.
	   ENDIF
	   SELECT CUR_TESTATA
	   GO TOP
	   IF EOF()
	   ELSE
	      MESSAGEBOX("Risulta una fattura in archivio con lo stesso numero" + CHR(13) + CHR(13) + ;
	                 "Impossibile proseguire",16,"Attenzione")
	      RETURN .F.
	   ENDIF
   ELSE
	   cSql = "select * from u_FAP_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord,ord_age"
	   IF !ExecCommand(cSql,"CUR_TESTATA")
	      RETURN .F.
	   ENDIF
	   SELECT CUR_TESTATA
	   GO TOP
	   IF EOF()
	   ELSE
	      MESSAGEBOX("Risulta una fattura proforma in archivio con lo stesso numero" + CHR(13) + CHR(13) + ;
	                 "Impossibile proseguire",16,"Attenzione")
	      RETURN .F.
	   ENDIF
   ENDIF
   
   M.ORD_CONINC = ""
   M.ORD_INCASS = .F.
   M.FLGACCONT = .F.
   M.ACC_PRECED = 0
   M.ACC_DAFATT = 0
   M.ACC_ATTUAL = 0
   
   M.ORD_DATCON = M.ORD_DATORD
   X_NUMORD = M.ORD_NUMORD
   X_DATORD = M.ORD_DATORD
   X_CODCLI = M.ORD_CODCLI
   X_RAGSOC = M.ORD_RAGSOC
   
   IF _PRIMA_FATTURA
      _Z_NUMEDA = M.ORD_NUMORD
      _Z_ANNO = M.ORD_ANNO
      _PRIMA_FATTURA = .F.
   ENDIF
   _Z_NUMEAL = M.ORD_NUMORD

   _OKDET = .F.
   _WW_SEQUEN = 10
   _XX_COMMENTO = ""
   
   SELECT &_NOME_CUR_FATTURABST
   SET FILTER TO 
   SET FILTER TO ALLTRIM(CODCLI) == ALLTRIM(_XXX_CODCLI)
   GO TOP
   
   *** COMPONGO I DETTAGLI FATTURA PROFORMA IN BASE ALLE NOTE DI FATTURAZIONE
   DO CREA_CURSORE_ELENCO_NOTE_X_FAT_FAP_SP
   
   SELECT ELENCO_NOTE_X_FATT
   GO TOP
   SCAN
      SCATTER MEMVAR MEMO
      
      IF !ExecCommand("select * from u_FAP_dd where 0=1","cur_FAP_dd")
      	return(.f.)
      ENDIF
      SELECT cur_FAP_dd
      SCATTER MEMVAR MEMO BLANK   
      M.DAGGANCIO = M.TAGGANCIO
      SELECT CUX_FAP_DD
      
      DO INSERISCI_COMMENTO_X_FAT_FAP_SP WITH M.NOTE_X_FATT
      
      SELECT codcli,ragsoc,tipo,codattiv,desattiv,tipo_elab,tipo_fatt,umfat,przfat,SUM(qtafat) AS qtafat,SUM(valfat) AS valfat ;
      FROM &_NOME_CUR_FATTURABST ;
      WHERE ALLTRIM(CODCLI) == ALLTRIM(_XXX_CODCLI) .AND. SUBSTR(ALLTRIM(ANNOTAZIONI),1,1000) == SUBSTR(ALLTRIM(M.NOTE_X_FATT),1,1000) ;
      GROUP BY codcli,ragsoc,tipo,codattiv,desattiv,tipo_elab,tipo_fatt,umfat,przfat ;
      ORDER BY codcli,ragsoc,tipo,codattiv,desattiv,tipo_elab,tipo_fatt,umfat,przfat ;
      INTO CURSOR CU_FATTURABST_RAGGR
     
      SELECT CU_FATTURABST_RAGGR
      GO TOP
		DO WHILE .T.
		  
		   IF EOF()
		      EXIT
		   ENDIF
		  
		   IF DELETED()
		      SKIP +1
		      LOOP
		   ENDIF
		   
		   **** SOLO LE RIGHE DI FATTURABILE CON LE NOTE DI FATTURAZIONE IN LINEA
		   *IF ALLTRIM(C_ANNOTAZIONI) == SUBSTR(ALLTRIM(M.NOTE_X_FATT),1,1000)
		   *ELSE
		   *   SKIP +1
		   *   LOOP
		   *ENDIF
		   	   
		   SCATTER MEMVAR MEMO
		   
		   IF !ExecCommand("select * from u_FAP_dd where 0=1","cur_FAP_dd")
		      return(.f.)
		   ENDIF
		   SELECT cur_FAP_dd
		   SCATTER MEMVAR MEMO BLANK
		   
		   M.DAGGANCIO = M.TAGGANCIO
		   
		   _YY_CODART = "."
		  
		   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
		   x_codi = "art_codpri = '" + _YY_CODART + "'"
		   x_cond = x_soci + " and " + x_codi
		   cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
		   IF !ExecCommand(cSql,"CUR_ARTICOLO")
		      RETURN .F.
		   ENDIF
		   SELECT CUR_ARTICOLO
		   GO TOP
		   IF EOF()
		      MESSAGEBOX("Articolo non trovato in anagrafica" + CHR(13) + CHR(13) + ;
		                 "Impossibile proseguire",16,"Attenzione")
		      RETURN(.F.)
		   ENDIF
		   
	*!*		   _XX_COMMENTO = M.DesAttivita
	*!*		   IF ALLTRIM(_XX_OLD_ATTIVITA) == ALLTRIM(M.CodAttivita)
	*!*		   ELSE
	*!*		      _XX_OLD_ATTIVITA = M.CodAttivita
	*!*		      THISFORM.inserisci_commento(_XX_COMMENTO)
	*!*		   ENDIF
		   
		   SELECT CUR_ARTICOLO

		   M.ORD_DESART = ALLTRIM(M.DESATTIV)
		   IF ALLTRIM(M.TIPO) == "ATTIVEXCED"
		      M.ORD_DESART = ALLTRIM(M.ORD_DESART) + " (" + ALLTRIM(DESTIPO) + ")"
		   ENDIF
		   
		   IF !EMPTY(M.TIPO_ELAB) .AND. SUBSTR(M.TIPO_ELAB,1,1) <> "M"
		      M.ORD_DESART = ALLTRIM(M.ORD_DESART) + " (" + ALLTRIM(SUBSTR(M.TIPO_ELAB,4)) + ")"
		   ENDIF
		   
		   M.ORD_DES2   = ""
		   M.ORD_UM     = M.UMFAT
		   M.ORD_QTAORD = M.QTAFAT
		   M.ORD_PREZZO = M.PRZFAT
		   
		   M.ORD_MAGA   = PUB_TAGPFO  
		   M.ORS_MAGS   = M.ORD_MAGA
		   M.ORD_IVA    = ART_CODIVA
		   
		   IF PUB_IVANAG          && GESTIONE IVA PRELEVATA DALL'ANAGRAFICA CLENTI
		      IF !EMPTY(IVA_CLI)
		         M.ORD_IVA = IVA_CLI
		      ENDIF
		   ENDIF 
		   
		   M.ORD_CODART = ART_CODPRI
		   M.ORD_PUBBLI = ART_PUBBLI
		   XLINEA       = ART_LINEA
		   M.ORD_COORD  = ART_COORD 
		   M.ORD_QTXCON = ART_QTACON
		   M.ORD_SCORMI = ART_SCORMI
		   M.ORD_CODTAG = ART_CODTAG
		   M.ORD_DESTAG = ART_DESTAG
		   M.ORD_CODCOL = ART_CODCOL
		   M.ORD_DESCOL = ART_DESCOL
		   M.ORD_CODMAT = ART_CODMAT
		   M.ORD_DESMAT = ART_DESMAT
		   M.ORD_SPESSO = ART_SPESSO
		   M.ORD_ALTEZZ = ART_ALTEZZ
		   M.ORD_LUNGHE = ART_LUNGHE
		   M.ORD_CODIMB = ART_CODIMB
		   M.ORD_DESIMB = ART_DESIMB
		   M.ORD_LOTMIN = ART_LOTMIN

		   M.ORD_CDAPRD = M.ORD_CODART
		   M.ORD_DSAPRD = M.ORD_DESART
		   
		   M.ORD_SC1 = M.ORD_SC1T
		   M.ORD_SC2 = M.ORD_SC2T
		   M.ORD_SC3 = M.ORD_SC3T
		   
		   _SC1    = M.ORD_SC1
		   _SC2    = M.ORD_SC2
		   _SC3    = M.ORD_SC3
		   _PREZZO = M.ORD_PREZZO

		   M.ORD_FORNIT = SPACE(10)
		   M.ORD_PRZCON = 0
		   M.ORD_CODACQ = SPACE(03)
		   _GIACENZA    = 0

		   IF M.ORD_VALUTA = PUB_VALRIF        && SE VALUTA DIGITATA = VALUTA DI RIFERIMENTO
		      M.ORD_CAMBIO = 1
		   ENDIF
		   
		   VPRE         = M.ORD_PREZZO
		   VPRE         = VPRE-ROUND((VPRE*M.ORD_SC1/100),6)
		   VPRE         = VPRE-ROUND((VPRE*M.ORD_SC2/100),6)
		   VPRE         = VPRE-ROUND((VPRE*M.ORD_SC3/100),6)
		   M.ORD_PRZNET = VPRE
		   M.ORD_PRZNET = ROUND(M.ORD_PRZNET,6)
		   
		   M.ORD_VALORE = ROUND((M.ORD_PRZNET*M.ORD_QTAORD),2)
		   
		   IF !CHECKNUM(M.ORD_VALORE,17,3)
		      RETURN
		   ENDIF
		   
		   M.ORD_SEQUEN = _WW_SEQUEN
		   M.ORD_FLGMOD = ""
		   
		   M.ORD_NOTE   = "" 
		   M.ORS_NUMORD = X_NUMORD
		   M.ORS_DATORD = X_DATORD
		   M.ORS_CODCLI = X_CODCLI
		   M.ORS_RAGSOC = X_RAGSOC
		   M.ORS_VALUTA = M.ORD_VALUTA  
		   
		   M.ORS_CODEMI = PUB_CLISOC 
		   M.ORS_RAGEMI = PUB_RAGSOC  
		   M.ORS_TIPORD = 'BO '
		   M.ORD_NOTEBO = ALLTRIM(M.ORD_DSAPRD)
		   
		   M.ORD_CODSYS = SYS(2015)
		   
		   SELECT CUX_FAP_DD
		   APPEND BLANK
		   DO U_FAP_DD
		   
		   _WW_SEQUEN = _WW_SEQUEN + 10
		   
		   *** MEMORIZZO I RECORD DI FATTURABILE DA CONTRASSEGNARE COME FATTURATI
		   SELECT * ;
		   FROM &_NOME_CUR_FATTURABST ;
		   WHERE ALLTRIM(CODCLI) == ALLTRIM(M.CODCLI) .AND. ALLTRIM(TIPO) == ALLTRIM(M.TIPO) .AND. ;
		   ALLTRIM(CODATTIV) == ALLTRIM(M.CODATTIV) .AND. ALLTRIM(DESATTIV) == ALLTRIM(M.DESATTIV) .AND. ;
		   ALLTRIM(TIPO_ELAB) == ALLTRIM(M.TIPO_ELAB) .AND. ALLTRIM(TIPO_FATT) == ALLTRIM(M.TIPO_FATT) .AND. ;
		   ALLTRIM(UMFAT) == ALLTRIM(M.UMFAT) .AND. PRZFAT == M.PRZFAT .AND. ;
		   SUBSTR(ALLTRIM(ANNOTAZIONI),1,1000) == SUBSTR(ALLTRIM(M.NOTE_X_FATT),1,1000) ;
		   INTO CURSOR TMP_FATTURABST
		   
		   SELECT TMP_FATTURABST
		   GO TOP
		   SCAN
			   _XX_ID_UNIQUE = ID_UNIQUE
			   _XX_TIPO = TIPO
			   SELECT WW_FATTURABILE
			   APPEND BLANK
			   REPLACE ID_UNIQUE WITH _XX_ID_UNIQUE 
			   REPLACE TIPO WITH _XX_TIPO
			   REPLACE NUMFAP WITH X_NUMORD
			   =CAMBIADT(X_DATORD,"DATFAP")
		   ENDSCAN
		   
		   _OKDET = .T.
		   
		   SELECT CU_FATTURABST_RAGGR
		   SKIP +1

		ENDDO

   ENDSCAN
   
   IF _OKDET
      SELECT CUX_FAP_DD
      SCATTER MEMVAR
      IF PUB_FATSTU
   		 PUB_DAGGANCIO = M.TAGGANCIO	&& SERGIO : SERVE PER CANCELLARE IN AUTOMATICO I COMMENTI VECCHI PRIMA DEL NUOVO INSERIMENTO DELLO STESSO COMMENTO , ALTRIMENTI HO DEI COMMENTI DOPPI
         =CREA_NOTE("FAT","CUX_FAP_DD")
      ELSE
         PUB_DAGGANCIO = M.TAGGANCIO	&& SERGIO : SERVE PER CANCELLARE IN AUTOMATICO I COMMENTI VECCHI PRIMA DEL NUOVO INSERIMENTO DELLO STESSO COMMENTO , ALTRIMENTI HO DEI COMMENTI DOPPI
         =CREA_NOTE("FAP","CUX_FAP_DD")
      ENDIF
   ELSE
      SELECT ELENCO_CLIENTI 
      SKIP +1
      LOOP
   ENDIF
   
   *** RICALCOLO TOTALI FATTURA PROFORMA IN BASE ALLA ROUTINE AUTOMATIZZATA
   SELECT CUX_FAP_DD
   SET FILTER TO DAGGANCIO = M.TAGGANCIO
   =CALCdocgen("CUX_FAP_DD")
   SELECT CUX_FAP_DD
   SET FILTER TO
   
   SELECT CUX_FAP_TT
   APPEND BLANK
   DO U_FAP_TT
   
   CONTA_FAP = CONTA_FAP + 1   
      
   SELECT ELENCO_CLIENTI 
   SKIP +1
ENDDO   

RETURN


PROCEDURE GEN_FAT_FAP_SP_X_CLIENTE_TIPO_ELABORAZIONE


*** GENERA N FATTURE PER IL CLIENTE IN LINEA PER OGNI TIPO ELABORAZIONE PRESENTE NEI DETTAGLI DI FATTURABILE SELEZIONATO

SELECT DISTINCT TIPO_ELAB AS T_ELAB FROM &_NOME_CUR_FATTURABST WHERE ALLTRIM(CODCLI) == ALLTRIM(_XXX_CODCLI) INTO CURSOR CU_TIPI_ELAB

SELECT CU_TIPI_ELAB
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   SCATTER MEMVAR
   
   IF !ExecCommand("select * from u_FAP_tt where 0=1","cur_FAP_tt")
      return(.f.)
   ENDIF
   SELECT cur_FAP_tt
   SCATTER MEMVAR MEMO BLANK
   
   _V_NUMFAT = _V_NUMFAT + 1
   M.ORD_NUMORD = ALLTRIM(STR(_V_NUMFAT,6,0))
   M.ORD_NUMORD = TRC(6,ALLTRIM(M.ORD_NUMORD))
   M.ORD_CODSOC = PUB_CODSOC
   M.ORD_DATORD	= _V_DATFAT
   IF SUBSTR(M.ORD_DATORD,3,1) = '/'
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,7,4)
   ELSE
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,1,4)
   ENDIF
   M.TAGGANCIO  = STR(NEWPROG('NUMFAP'),10)
   *M.ORD_CODBUN = PUB_CODBUN
   M.ORD_CODSYS = SYS(2015)
   
   M.ORD_CDC    = ""
   M.ORD_NUMCOC = ""
   M.ORD_DATCOC = ""
   
   IF PUB_FATSTU
      WAIT WINDOW "Creazione fattura n° " + ALLTRIM(M.ORD_NUMORD) + " del " + ALLTRIM(M.ORD_DATORD) nowait
   ELSE
      WAIT WINDOW "Creazione fattura proforma n° " + ALLTRIM(M.ORD_NUMORD) + " del " + ALLTRIM(M.ORD_DATORD) nowait
   ENDIF

   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + _XXX_CODCLI + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      return(.f.)
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP
   IF EOF()
      MESSAGEBOX("Cliente " + _XXX_CODCLI + " non trovato in anagrafica clienti" + CHR(13) + CHR(13) + ;
                 "Impossibile proseguire",16,"Attenzione")
      RETURN .F.
   ENDIF
   M.ORD_CODCLI = CLI_CODCLI

   SELECT CUR_CLIENTI 

   M.TNUMERO    = M.ORD_NUMORD
   M.ORD_RAGSOC = CLI_RAGSOC
   M.ORD_INDIRI = CLI_INDIR
   M.ORD_CAP    = CLI_CAP
   M.ORD_LOCALI = CLI_LOCALI
   M.ORD_PROVIN = CLI_PROVIN
   M.ORD_PARIVA = CLI_PARIVA
   IVA_ESE      = CLI_ALRID
   IVA_CLI      = CLI_CODIVA               
   V_CLIES      = CLI_CLIES
   V_DTCLES	    = CLI_DTCLES
   V_NSES       = CLI_NSES
   V_DTNSES	    = CLI_DTNSES
   M.ORD_VALUTA = CLI_VALUTA
 
   IF EMPTY(M.ORD_VALUTA)  
      M.ORD_VALUTA = PUB_VALRIF
   ENDIF

   M.ORD_CPA   = CLI_CONPAG
   
   M.ORD_BANCA = CLI_BAE
   IF M.ORD_VALUTA = PUB_VALRIF
      M.ORD_CAMBIO = 1
   ENDIF

   SAV_BANCA    = CLI_BAE
   M.ORD_CODNAZ	= CLI_NAZION
   IF EMPTY(M.ORD_CODNAZ) 
      M.ORD_CODNAZ = "ITA"
   ENDIF
   M.ORD_AGE = CLI_AGE
   IF EMPTY(M.ORD_AGE)
      M.ORD_AGE = CLI_AGE
   ENDIF
   M.ORD_CAUS = PUB_FAPRO
   IF EMPTY(M.ORD_CAUS)
      M.ORD_CAUS = PUB_FAPRO  
   ENDIF  
   M.ORD_PRORIT = CLI_PROVVI
   M.ORD_SC1T   = CLI_SC1
   M.ORD_SC2T   = CLI_SC2
   M.ORD_SC3T   = CLI_SC3

   **==> Controllo di non esistenza doppione di numero fattura
   _spazio= SPACE(01)
   x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
   x_anno = "ord_anno = '" + SUBSTR(M.ORD_DATORD,7,4) + "'"
   x_nord = "ord_numord   = '" + M.ORD_NUMORD + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_nord

   IF PUB_FATSTU
	   cSql = "select * from u_FAT_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord,ord_age"
	   IF !ExecCommand(cSql,"CUR_TESTATA")
	      RETURN .F.
	   ENDIF
	   SELECT CUR_TESTATA
	   GO TOP
	   IF EOF()
	   ELSE
	      MESSAGEBOX("Risulta una fattura in archivio con lo stesso numero" + CHR(13) + CHR(13) + ;
	                 "Impossibile proseguire",16,"Attenzione")
	      RETURN .F.
	   ENDIF
   ELSE
	   cSql = "select * from u_FAP_tt where " + x_cond + " order by ord_codsoc,ord_anno,ord_numord,ord_age"
	   IF !ExecCommand(cSql,"CUR_TESTATA")
	      RETURN .F.
	   ENDIF
	   SELECT CUR_TESTATA
	   GO TOP
	   IF EOF()
	   ELSE
	      MESSAGEBOX("Risulta una fattura proforma in archivio con lo stesso numero" + CHR(13) + CHR(13) + ;
	                 "Impossibile proseguire",16,"Attenzione")
	      RETURN .F.
	   ENDIF
   ENDIF
   
   M.ORD_CONINC = ""
   M.ORD_INCASS = .F.
   M.FLGACCONT = .F.
   M.ACC_PRECED = 0
   M.ACC_DAFATT = 0
   M.ACC_ATTUAL = 0
   
   M.ORD_DATCON = M.ORD_DATORD
   X_NUMORD = M.ORD_NUMORD
   X_DATORD = M.ORD_DATORD
   X_CODCLI = M.ORD_CODCLI
   X_RAGSOC = M.ORD_RAGSOC
   
   IF _PRIMA_FATTURA
      _Z_NUMEDA = M.ORD_NUMORD
      _Z_ANNO = M.ORD_ANNO
      _PRIMA_FATTURA = .F.
   ENDIF
   _Z_NUMEAL = M.ORD_NUMORD

   _OKDET = .F.
   _WW_SEQUEN = 10
   _XX_COMMENTO = ""
   
   SELECT &_NOME_CUR_FATTURABST
   SET FILTER TO 
   SET FILTER TO ALLTRIM(CODCLI) == ALLTRIM(_XXX_CODCLI) .AND. ALLTRIM(TIPO_ELAB) == ALLTRIM(M.T_ELAB)
   GO TOP
   
   *** COMPONGO I DETTAGLI FATTURA PROFORMA IN BASE ALLE NOTE DI FATTURAZIONE
   DO CREA_CURSORE_ELENCO_NOTE_X_FAT_FAP_SP
   
   SELECT ELENCO_NOTE_X_FATT
   GO TOP
   SCAN
      SCATTER MEMVAR MEMO
      
      IF !ExecCommand("select * from u_FAP_dd where 0=1","cur_FAP_dd")
      	return(.f.)
      ENDIF
      SELECT cur_FAP_dd
      SCATTER MEMVAR MEMO BLANK   
      M.DAGGANCIO = M.TAGGANCIO
      SELECT CUX_FAP_DD
      
      DO INSERISCI_COMMENTO_X_FAT_FAP_SP WITH M.NOTE_X_FATT
      
      SELECT codcli,ragsoc,tipo,codattiv,desattiv,tipo_elab,tipo_fatt,umfat,przfat,SUM(qtafat) AS qtafat,SUM(valfat) AS valfat ;
      FROM &_NOME_CUR_FATTURABST ;
      WHERE ALLTRIM(CODCLI) == ALLTRIM(_XXX_CODCLI) .AND. ALLTRIM(TIPO_ELAB) == ALLTRIM(M.T_ELAB) .AND. SUBSTR(ALLTRIM(ANNOTAZIONI),1,1000) == SUBSTR(ALLTRIM(M.NOTE_X_FATT),1,1000) ;
      GROUP BY codcli,ragsoc,tipo,codattiv,desattiv,tipo_elab,tipo_fatt,umfat,przfat ;
      ORDER BY codcli,ragsoc,tipo,codattiv,desattiv,tipo_elab,tipo_fatt,umfat,przfat ;
      INTO CURSOR CU_FATTURABST_RAGGR
      
      SELECT CU_FATTURABST_RAGGR
      GO TOP

		DO WHILE .T.
		  
		   IF EOF()
		      EXIT
		   ENDIF
		  
		   IF DELETED()
		      SKIP +1
		      LOOP
		   ENDIF
		   
		   **** SOLO LE RIGHE DI FATTURABILE CON LE NOTE DI FATTURAZIONE IN LINEA
		   *IF ALLTRIM(ANNOTAZIONI) == ALLTRIM(M.NOTE_X_FATT)
		   *ELSE
		   *   SKIP +1
		   *   LOOP
		   *ENDIF
		   	   
		   SCATTER MEMVAR MEMO
		   
		   IF !ExecCommand("select * from u_FAP_dd where 0=1","cur_FAP_dd")
		      return(.f.)
		   ENDIF
		   SELECT cur_FAP_dd
		   SCATTER MEMVAR MEMO BLANK
		   
		   M.DAGGANCIO = M.TAGGANCIO
		   
		   _YY_CODART = "."
		  
		   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
		   x_codi = "art_codpri = '" + _YY_CODART + "'"
		   x_cond = x_soci + " and " + x_codi
		   cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
		   IF !ExecCommand(cSql,"CUR_ARTICOLO")
		      RETURN .F.
		   ENDIF
		   SELECT CUR_ARTICOLO
		   GO TOP
		   IF EOF()
		      MESSAGEBOX("Articolo non trovato in anagrafica" + CHR(13) + CHR(13) + ;
		                 "Impossibile proseguire",16,"Attenzione")
		      RETURN(.F.)
		   ENDIF
		   
		   SELECT CUR_ARTICOLO
		   
		   M.ORD_DESART = ALLTRIM(M.DESATTIV)
		   IF ALLTRIM(M.TIPO) == "ATTIVEXCED"
		      M.ORD_DESART = ALLTRIM(M.ORD_DESART) + " (" + ALLTRIM(DESTIPO) + ")"
		   ENDIF	   
		   M.ORD_DES2   = ""
		   M.ORD_UM     = M.UMFAT
		   M.ORD_QTAORD = M.QTAFAT
		   M.ORD_PREZZO = M.PRZFAT
		   
		   M.ORD_MAGA   = PUB_TAGPFO  
		   M.ORS_MAGS   = M.ORD_MAGA
		   M.ORD_IVA    = ART_CODIVA
		   
		   IF PUB_IVANAG          && GESTIONE IVA PRELEVATA DALL'ANAGRAFICA CLENTI
		      IF !EMPTY(IVA_CLI)
		         M.ORD_IVA = IVA_CLI
		      ENDIF
		   ENDIF 
		   
		   M.ORD_CODART = ART_CODPRI
		   M.ORD_PUBBLI = ART_PUBBLI
		   XLINEA       = ART_LINEA
		   M.ORD_COORD  = ART_COORD 
		   M.ORD_QTXCON = ART_QTACON
		   M.ORD_SCORMI = ART_SCORMI
		   M.ORD_CODTAG = ART_CODTAG
		   M.ORD_DESTAG = ART_DESTAG
		   M.ORD_CODCOL = ART_CODCOL
		   M.ORD_DESCOL = ART_DESCOL
		   M.ORD_CODMAT = ART_CODMAT
		   M.ORD_DESMAT = ART_DESMAT
		   M.ORD_SPESSO = ART_SPESSO
		   M.ORD_ALTEZZ = ART_ALTEZZ
		   M.ORD_LUNGHE = ART_LUNGHE
		   M.ORD_CODIMB = ART_CODIMB
		   M.ORD_DESIMB = ART_DESIMB
		   M.ORD_LOTMIN = ART_LOTMIN

		   M.ORD_CDAPRD = M.ORD_CODART
		   M.ORD_DSAPRD = M.ORD_DESART
		   
		   M.ORD_SC1 = M.ORD_SC1T
		   M.ORD_SC2 = M.ORD_SC2T
		   M.ORD_SC3 = M.ORD_SC3T
		   
		   _SC1    = M.ORD_SC1
		   _SC2    = M.ORD_SC2
		   _SC3    = M.ORD_SC3
		   _PREZZO = M.ORD_PREZZO

		   M.ORD_FORNIT = SPACE(10)
		   *M.ORD_RAGFOR = SPACE(50)
		   M.ORD_PRZCON = 0
		   M.ORD_CODACQ = SPACE(03)
		   _GIACENZA    = 0

		   IF M.ORD_VALUTA = PUB_VALRIF        && SE VALUTA DIGITATA = VALUTA DI RIFERIMENTO
		      M.ORD_CAMBIO = 1
		   ENDIF
		   
		   VPRE         = M.ORD_PREZZO
		   VPRE         = VPRE-ROUND((VPRE*M.ORD_SC1/100),6)
		   VPRE         = VPRE-ROUND((VPRE*M.ORD_SC2/100),6)
		   VPRE         = VPRE-ROUND((VPRE*M.ORD_SC3/100),6)
		   M.ORD_PRZNET = VPRE
		   M.ORD_PRZNET = ROUND(M.ORD_PRZNET,6)
		   
		   M.ORD_VALORE = ROUND((M.ORD_PRZNET*M.ORD_QTAORD),2)
		   
		   IF !CHECKNUM(M.ORD_VALORE,17,3)
		      RETURN
		   ENDIF
		   
		   M.ORD_SEQUEN = _WW_SEQUEN
		   M.ORD_FLGMOD = ""
		   
		   M.ORD_NOTE   = "" 
		   M.ORS_NUMORD = X_NUMORD
		   M.ORS_DATORD = X_DATORD
		   M.ORS_CODCLI = X_CODCLI
		   M.ORS_RAGSOC = X_RAGSOC
		   M.ORS_VALUTA = M.ORD_VALUTA  
		   
		   M.ORS_CODEMI = PUB_CLISOC 
		   M.ORS_RAGEMI = PUB_RAGSOC  
		   M.ORS_TIPORD = 'BO '
		   M.ORD_NOTEBO = ALLTRIM(M.ORD_DSAPRD)
		   
		   M.ORD_CODSYS = SYS(2015)
		   
		   SELECT CUX_FAP_DD
		   APPEND BLANK
		   DO U_FAP_DD
		   
		   _WW_SEQUEN = _WW_SEQUEN + 10
		   
		   *** MEMORIZZO I RECORD DI FATTURABILE DA CONTRASSEGNARE COME FATTURATI
		   SELECT * ;
		   FROM &_NOME_CUR_FATTURABST ;
		   WHERE ALLTRIM(CODCLI) == ALLTRIM(M.CODCLI) .AND. ALLTRIM(TIPO) == ALLTRIM(M.TIPO) .AND. ;
		   ALLTRIM(CODATTIV) == ALLTRIM(M.CODATTIV) .AND. ALLTRIM(DESATTIV) == ALLTRIM(M.DESATTIV) .AND. ;
		   ALLTRIM(TIPO_ELAB) == ALLTRIM(M.TIPO_ELAB) .AND. ALLTRIM(TIPO_FATT) == ALLTRIM(M.TIPO_FATT) .AND. ;
		   ALLTRIM(UMFAT) == ALLTRIM(M.UMFAT) .AND. PRZFAT == M.PRZFAT .AND. ;
		   SUBSTR(ALLTRIM(ANNOTAZIONI),1,1000) == SUBSTR(ALLTRIM(M.NOTE_X_FATT),1,1000) ;
		   INTO CURSOR TMP_FATTURABST
		   
		   SELECT TMP_FATTURABST
		   GO TOP
		   SCAN
			   _XX_ID_UNIQUE = ID_UNIQUE
			   _XX_TIPO = TIPO
			   SELECT WW_FATTURABILE
			   APPEND BLANK
			   REPLACE ID_UNIQUE WITH _XX_ID_UNIQUE 
			   REPLACE TIPO WITH _XX_TIPO
			   REPLACE NUMFAP WITH X_NUMORD
			   *REPLACE DATFAP WITH X_DATORD
			   =CAMBIADT(X_DATORD,"DATFAP")
		   ENDSCAN
		   
		   *IF ALLTRIM(M.ANNOTAZIONI) $ ALLTRIM(_XX_COMMENTO)
		   *ELSE
		   *	   _XX_COMMENTO = _XX_COMMENTO + CHR(13) + ALLTRIM(M.ANNOTAZIONI)
		   *ENDIF
		   
		   _OKDET = .T.
		   
		   SELECT CU_FATTURABST_RAGGR
		   SKIP +1

		ENDDO

   ENDSCAN

   IF _OKDET
      SELECT CUX_FAP_DD
      SCATTER MEMVAR
      IF PUB_FATSTU
         PUB_DAGGANCIO = M.TAGGANCIO	&& SERGIO : SERVE PER CANCELLARE IN AUTOMATICO I COMMENTI VECCHI PRIMA DEL NUOVO INSERIMENTO DELLO STESSO COMMENTO , ALTRIMENTI HO DEI COMMENTI DOPPI
         =CREA_NOTE("FAT","CUX_FAP_DD")
      ELSE
   		 PUB_DAGGANCIO = M.TAGGANCIO	&& SERGIO : SERVE PER CANCELLARE IN AUTOMATICO I COMMENTI VECCHI PRIMA DEL NUOVO INSERIMENTO DELLO STESSO COMMENTO , ALTRIMENTI HO DEI COMMENTI DOPPI
         =CREA_NOTE("FAP","CUX_FAP_DD")
      ENDIF
   ELSE
      SELECT CU_TIPI_ELAB 
      SKIP +1
      LOOP
   ENDIF
   
   *** RICALCOLO TOTALI FATTURA PROFORMA IN BASE ALLA ROUTINE AUTOMATIZZATA
   SELECT CUX_FAP_DD
   SET FILTER TO DAGGANCIO = M.TAGGANCIO
   =CALCdocgen("CUX_FAP_DD")
   SELECT CUX_FAP_DD
   SET FILTER TO
   
   SELECT CUX_FAP_TT
   APPEND BLANK
   DO U_FAP_TT
   
   CONTA_FAP = CONTA_FAP + 1   
      
   SELECT CU_TIPI_ELAB 
   SKIP +1
ENDDO
   
RETURN


PROCEDURE CREA_CURSORE_ELENCO_NOTE_X_FAT_FAP_SP


CREATE CURSOR ELENCO_NOTE_X_FATT (NOTE_X_FATT M, SEQUEN N(3,0))
INDEX ON SEQUEN TAG I_SEQUEN

_ANNOTAZIONI = ""

SELECT &_NOME_CUR_FATTURABST 
GO TOP
SCAN
	_ANNOTAZIONI = ALLTRIM(ANNOTAZIONI)
	_TIPO_ELABORAZ = ALLTRIM(SUBSTR(TIPO_ELAB,1,1))
	_FOUND = .F.
	SELECT ELENCO_NOTE_X_FATT 
	SCAN
		IF ALLTRIM(NOTE_X_FATT) == _ANNOTAZIONI
			_FOUND = .T.
		ENDIF
	ENDSCAN
	IF !_FOUND
		SELECT ELENCO_NOTE_X_FATT 
		APPEND BLANK
		REPLACE NOTE_X_FATT WITH _ANNOTAZIONI
		DO CASE
			CASE _TIPO_ELABORAZ = 'M'
				REPLACE SEQUEN WITH 1
			CASE _TIPO_ELABORAZ = 'T'
				REPLACE NOTE_X_FATT WITH SPACE(10) + NOTE_X_FATT
				REPLACE SEQUEN WITH 2
			CASE _TIPO_ELABORAZ = 'Q'
				REPLACE NOTE_X_FATT WITH SPACE(10) + NOTE_X_FATT
				REPLACE SEQUEN WITH 3
			CASE _TIPO_ELABORAZ = 'C'
				REPLACE NOTE_X_FATT WITH SPACE(10) + NOTE_X_FATT
				REPLACE SEQUEN WITH 4
			CASE _TIPO_ELABORAZ = 'B'
				REPLACE NOTE_X_FATT WITH SPACE(10) + NOTE_X_FATT
				REPLACE SEQUEN WITH 5
			CASE _TIPO_ELABORAZ = 'F'
				REPLACE NOTE_X_FATT WITH SPACE(10) + NOTE_X_FATT
				REPLACE SEQUEN WITH 6
			CASE _TIPO_ELABORAZ = 'A'
				REPLACE NOTE_X_FATT WITH SPACE(10) + NOTE_X_FATT
				REPLACE SEQUEN WITH 7
			OTHERWISE
				REPLACE SEQUEN WITH 999
		ENDCASE
	ENDIF
ENDSCAN

SELECT ELENCO_NOTE_X_FATT 
SET ORDER TO I_SEQUEN
GO TOP

SELECT &_NOME_CUR_FATTURABST 
GO TOP

RETURN


PROCEDURE INSERISCI_COMMENTO_X_FAT_FAP_SP

LPARAMETERS _YY_COMMENTO

M.ORD_DESART = "*** COMMENTO ***"
M.ORD_NOTE   = ""
IF EMPTY(ALLTRIM(_YY_COMMENTO))
ELSE
   M.ORD_NOTE = _YY_COMMENTO
ENDIF

M.ORD_CODART = SPACE(16)
M.ORD_DES2   = ""
M.ORD_CDAPRD = ""
M.ORD_DSAPRD = ""
M.ORD_PUBBLI = ""
M.ORD_FORNIT = ""
*M.ORD_RAGFOR = ""
M.ORS_NUMORD = X_NUMORD
M.ORS_DATORD = X_DATORD
M.ORS_CODCLI = X_CODCLI
M.ORS_RAGSOC = X_RAGSOC
M.ORS_VALUTA = M.ORD_VALUTA  
M.ORS_CODEMI = PUB_CLISOC 
M.ORS_RAGEMI = PUB_RAGSOC  
M.ORS_TIPORD = 'BO '
M.ORD_NOTEBO = ""
M.ORD_MAGA   = SPACE(06)
M.ORD_UM     = ""
M.ORD_IVA    = ""
M.ORD_QTAORD = 0
M.ORD_QTAEV  = 0
M.ORD_QTADEV = 0
M.ORD_PREZZO = 0
M.ORD_SC1    = 0
M.ORD_SC2    = 0
M.ORD_SC3    = 0
M.ORD_PRZNET = 0
M.ORD_VALORE = 0
M.ORD_PRORIG = 0
M.ORD_DATCON = ""
M.ORD_FLARTC = 0
M.ORD_QTAOLD = 0
M.ORD_QTAFAT = 0
M.ORD_VIEW   = .F.
M.ORD_CONSD  = .F.
M.ORD_CHIUSO = .F.
M.ORD_SINTE  = .F.
M.ORD_VALCO  = 0
M.ORS_MAGS   = ""
M.ORS_SALCON = ""
M.SELEZIONE  = ""
M.ORS_NUMORC = ""
M.ORS_DATORC = ""
M.ORD_QTCONF = 0
M.ORD_QTXCON = 0
M.ORD_COORD  = ""
M.ORD_SYSCOD = ""
M.ORD_FDITRA = ""
M.ORD_SCORMI = 0
M.ORD_PESOUM = 0
M.ORD_CODIMB = ""
M.ORD_CODTAG = ""
M.ORD_DESTAG = ""
M.ORD_CODCOL = ""
M.ORD_DESCOL = ""
M.ORD_TRASME = .F.
M.ORD_TRASMD = .F.
M.ORD_CODSYS = SYS(2015)
M.ORD_LEGSYS = SYS(2015)
M.ORD_FLGMOD = ""
M.ORD_PRZCON = 0
M.ORD_CODACQ = ""
M.ORD_CODMAT = ""
M.ORD_DESMAT = ""
M.ORD_SPESSO = 0
M.ORD_ALTEZZ = 0
M.ORD_LUNGHE = 0
M.ORD_NUMBOB = 0
M.ORD_QTAKG  = 0
M.ORD_QTAMQ  = 0
M.ORD_QTAML  = 0
M.ORD_QTAKG1 = 0
M.ORD_QTAMQ1 = 0
M.ORD_QTAML1 = 0
M.ORD_NUMPED = 0
M.ORD_DATPED = ""
M.ORD_SYSPED = ""
M.ORD_NOTEBO = ""
M.ORD_DESIMB = ""
M.ORD_LOTMIN = 0
M.ORD_QTAKGI = 0
M.ORD_QTAKGE = 0
M.ORD_SEQUEN = _WW_SEQUEN
M.ORD_TIPSOG = ""
M.ORD_CODSOG = ""
M.ORD_DESSOG = ""
   
SELECT CUX_FAP_DD
APPEND BLANK
DO U_FAP_DD

_WW_SEQUEN = _WW_SEQUEN + 10


RETURN
