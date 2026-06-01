** ################################################################################# **
** 								CALCOLO PROVVIGIONALE								 **
** ################################################################################# **
** 1) DETERMINA IL VALORE DELLA PROVVIGIONE IN FUNZIONE DELLE REGOLE PREVISTE 
**    DICHIARANDOLA MATURATA
** 2) SE LA FATTURA VIENE INCASSATA TRAMITE RI.BA O COMUNQUE LA PARTITA E' CHIUSA 
**    IN QUANTO PAGATA LA RIGA DELLA FATTURA VIENE DICHIARATA INCASSATA
** 3) SE LA RIGA DELLA FATTURA E' MATURATA E NON INCASSATA VIENE PARCHEGGIATA NELLO 
**    STORICO DELLE FATTURE PROVVIGIONALI (PROVVI) AL FINE DI ESSERE OGNI MESE 
**    RIVERIFICATA PER VEDERE SE E' INCASSATA
**



CREATE CURSOR PRO_ERR(RIGA C (100))

CREATE CURSOR GIA_INCA(PARTITA N(10),CODCLI C(10), INCA L(01))
INDEX ON ALLTRIM(CODCLI)+ALLTRIM(STR(PARTITA)) TAG GIA_INCA ADDITIVE

_DATARIF = RIBALTA2(_DATARIF)
_DATARBM = RIBALTA2(_DATARBM)
_DATAEFF = RIBALTA2(_DATAEFF)
DATADAL  = RIBALTA2(DATADAL)
DATAAL   = RIBALTA2(DATAAL)
STORIDAL = RIBALTA2(STORIDAL)
STORIAL  = RIBALTA2(STORIAL)

RELEASE PREFIX
PUBLIC PREFIX

PREFIX   = "0109"


IF !CONTROL_FAT()   && CONTROLLA FATTURE ESISTENTI E PROTOCOLLATE NEL PERIODO
   RETURN
ENDIF
 
**--> CANCELLAVA LE PROVVIGIONI DEL PERIODO...

IF !PRO_CANC()       && CANCELLA LE PROVVIGIONI DEL PERIODO RICHIESTO
   RETURN
ENDIF

IF !ExecCommand("select * from provvi where 0=1","CUR_PROVVI")
   return(.f.)
ENDIF

=CARICA_STORICO()	&& CARICA I DATI DELLE FATTURE VECCHIE AL FINE DA RIVERIFICARE EVENTUALI INCASSI AVVENUTI NEL FRATTEMPO


CTRELAB=0

x_dt1   = DATADAL
x_dt2   = DATAAL
x_soci  = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno  = "ord_anno = '" + SUBSTR(DATADAL,1,4) + "'"
x_data  = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"


cSql    = "SELECT * FROM u_fat_tt WHERE " + x_data + " order by ord_codsoc,ord_anno,ord_datord"
IF !ExecCommand(cSql,"U_FAT_TT")
   return(.f.)
ENDIF
SELECT U_FAT_TT
GO TOP


IF EOF()
   =MESSAGEBOX("Non esistono fatture nel periodo specificato",62,"ATTENZIONE")
   RETURN
ENDIF

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   IF ORD_DATORD <= DATAAL
   ELSE
      EXIT
   ENDIF
  
   IF GETTOP(ORD_CAUS)    && VERIFICA SE DEVE SCARTARE LE FATTURE PER OMAGGI/SCONTI .............
      SKIP +1
      LOOP
   ENDIF

   SELECT U_FAT_TT
   SCATTER MEMVAR

   v_seek   = 'TOP'+ALLTRIM(M.ORD_CAUS)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      NOTAC= SUBSTR(LIBERA,11,1)         && NOTA CREDITO
   ELSE
	  NOTAC= " "
   ENDIF

   x_agga  = "daggancio = '" + M.TAGGANCIO + "'"
   cSql    = "SELECT * FROM u_fat_dd WHERE " + x_agga 
   IF !ExecCommand(cSql,"U_FAT_DD")
      return(.f.)
   ENDIF


   SELECT U_FAT_DD
   GO TOP

   IF EOF()
      =ERRORE("La fattura n. "+ALLTRIM(M.ORD_NUMORD)+" del cliente "+ALLTRIM(M.ORD_RAGSOC)+" dell'agente "+ALLTRIM(M.ORD_AGE)+" non contiene dettagli")
   ELSE
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF DELETED()
            SKIP +1
            LOOP
         ENDIF
         IF M.TAGGANCIO<>DAGGANCIO
            EXIT
         ENDIF
         IF "*** COMMENTO ***" $ ORD_DESART
            SKIP +1
            LOOP
         ENDIF
         IF ORD_PUBBLI="S"
            SKIP +1
            LOOP 
         ENDIF
         
         SELECT U_FAT_DD
         SCATTER MEMVAR
         
		 V_ER = SOTTOGEN(M.ORD_CODNAZ)
		 IF !V_ER
		   PREFIX = PUB_CC
		 ENDIF 
       
         
         SELECT CUR_PROVVI					&& STORICO PROVVIGIONI CONTENENTE LE FATTURE DA RIELABORARE SUCCESSIVAMENTE IN QUANTO LE RIBA NON ANCORA INCASSATE
         APPEND BLANK
         GATHER MEMVAR
         
         REPLACE ORD_DEPOSI WITH GETDEPO(M.ORD_AGE)
         REPLACE ORD_INCA   WITH .F.
         REPLACE ORD_TOP    WITH M.ORD_CAUS
         
         IF !GETDIFP(M.ORD_AGE)    && LA FUNZIONA RITORNA SE L'AGENTE HA IL CALCOLO IN BASE ALLE DIFF. DI PREZZO
            IF NOTAC <> "S"
               REPLACE ORD_PRZOK  WITH GETPREZZO(M.ORD_CODART,M.ORD_CODCLI,M.ORD_AGE)
               REPLACE ORD_VALOK  WITH ORD_PRZOK*ORD_QTAORD
               REPLACE ORD_PRORIG WITH GETPROVVI(M.ORD_AGE,M.ORD_CODART,M.ORD_CODCLI,M.ORD_DATORD)
               **--> GESTISCO LA PROVVIGIONE CON IL CALCOLO DEL NEGATIVO
               IF ORD_VALORE-ORD_VALOK>=0       && HO VENDUTO SOTTOCOSTO? NO
                  REPLACE ORD_NEGA   WITH 0
                  REPLACE ORD_PROVVI WITH ROUND((ORD_VALORE*ORD_PRORIG/100),0)
                  REPLACE ORD_PROTOT WITH ORD_PROVVI
                  IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)        && HO INCASSATO
                     REPLACE ORD_PRINCA WITH ORD_PROVVI
                     REPLACE ORD_PROTOT WITH 0
                  ENDIF
               ELSE                             && HO VENDUTO SOTTOCOSTO? SI
                  REPLACE ORD_NEGA   WITH ORD_VALORE-ORD_VALOK
                  REPLACE ORD_PROVVI WITH ROUND((ORD_VALORE*ORD_PRORIG/100),0)
                  REPLACE ORD_PROTOT WITH ORD_PROVVI+ORD_NEGA         && ORD_NEGA E' NEGATIVO E LO TOLGO
                  IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)
                     REPLACE ORD_INCANE WITH ORD_NEGA
                     REPLACE ORD_NEGA   WITH 0
                     REPLACE ORD_PRINCA WITH ORD_PROVVI
                     REPLACE ORD_PROTOT WITH 0
                     REPLACE ORD_PROVVI WITH 0
                  ENDIF
               ENDIF
            ELSE                                 && CASO NOTA DI CREDITO
               REPLACE ORD_PRZOK  WITH 0
               REPLACE ORD_VALOK  WITH 0
               REPLACE ORD_PRORIG WITH GETPROVVI(M.ORD_AGE,M.ORD_CODART,M.ORD_CODCLI,M.ORD_DATORD)
               REPLACE ORD_NEGA   WITH 0
               REPLACE ORD_PROVVI WITH ROUND((ORD_VALORE*ORD_PRORIG/100*-1),0)
               REPLACE ORD_PROTOT WITH ORD_PROVVI
               IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)
                  REPLACE ORD_PRINCA WITH ORD_PROVVI
                  REPLACE ORD_PROTOT WITH 0
               ENDIF
            ENDIF
         ELSE     && SE SONO QUI HO IL CALCOLO DELLE PROVV. IN BASE ALLE DIFF. DI PREZZO
            IF NOTAC <> "S"
               REPLACE ORD_PRZOK  WITH GETPREZZO(M.ORD_CODART,M.ORD_CODCLI,M.ORD_AGE)
               REPLACE ORD_VALOK  WITH ORD_PRZOK*ORD_QTAORD
               REPLACE ORD_PRORIG WITH 0
               **--> GESTISCO LA PROVVIGIONE CON IL CALCOLO DEL NEGATIVO
               IF ORD_VALORE-ORD_VALOK>=0       && HO VENDUTO SOTTOCOSTO? NO
                  REPLACE ORD_NEGA   WITH 0
                  REPLACE ORD_PROVVI WITH ORD_VALORE-ORD_VALOK
                  REPLACE ORD_PROTOT WITH ORD_PROVVI
                  IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)        && HO INCASSATO
                     REPLACE ORD_PRINCA WITH ORD_PROVVI
                     REPLACE ORD_PROTOT WITH 0
                  ENDIF
               ELSE                             && HO VENDUTO SOTTOCOSTO? SI
                  REPLACE ORD_NEGA   WITH ORD_VALORE-ORD_VALOK
                  REPLACE ORD_PROVVI WITH 0
                  REPLACE ORD_PROTOT WITH ORD_PROVVI+ORD_NEGA         && ORD_NEGA E' NEGATIVO E LO TOLGO
                  IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)
                     REPLACE ORD_INCANE WITH ORD_NEGA
                     REPLACE ORD_NEGA   WITH 0
                     REPLACE ORD_PRINCA WITH ORD_PROVVI
                     REPLACE ORD_PROTOT WITH 0
                     REPLACE ORD_PROVVI WITH 0
                  ENDIF
               ENDIF
            ELSE                                 && CASO NOTA DI CREDITO
               REPLACE ORD_PRZOK  WITH GETPREZZO(M.ORD_CODART,M.ORD_CODCLI,M.ORD_AGE)
               REPLACE ORD_VALOK  WITH ORD_PRZOK*ORD_QTAORD
               REPLACE ORD_PRORIG WITH 0
               REPLACE ORD_NEGA   WITH 0
               REPLACE ORD_PROVVI WITH (ABS(ORD_VALORE-ORD_VALOK))*-1
               REPLACE ORD_PROTOT WITH ORD_PROVVI
               IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)
                  REPLACE ORD_PRINCA WITH ORD_PROVVI
                  REPLACE ORD_PROTOT WITH 0
               ENDIF
            ENDIF
         ENDIF

         **--> RIPORTO DATI ORIGINALI .SER SU VARIABILI DI SUPPORTO PER RIELABORAZIONI SUCCESSIVE DA STORICO PROVVIGIONI
         SELECT CUR_PROVVI
	     REPLACE OLD_INCANE WITH ORD_INCANE
         REPLACE OLD_NEGA   WITH ORD_NEGA
         REPLACE OLD_PRINCA WITH ORD_PRINCA
         REPLACE OLD_PROTOT WITH ORD_PROTOT
         REPLACE OLD_PROVVI WITH ORD_PROVVI
         
         
         
         **--> CASO DI CLIENTE ASSOCIATO AD UN AGENTE MA GESTITO DA ALTRI
         SAVE_PROV=STR(SELECT())
         TROVO_CLI=.F.
         x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
         x_clie = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
         x_cond = x_soci + " and " + x_clie
         cSql="SELECT * FROM U_CLI_AG WHERE " + x_cond + " order by cli_codsoc,cli_codcli"
         IF !ExecCommand(cSql,"CUR_CLIAGE")
            return(.f.)
         ENDIF
         SELECT CUR_CLIAGE
         GO TOP
         IF !EOF()
            AGEASS=CLI_AGEASS
            PERCPR=CLI_PROVVI
            TROVO_CLI=.T.
         ENDIF
         SELECT CUR_PROVVI
         IF TROVO_CLI      && SE SONO QUI CASO AGENTE ASSOCIATO 
            SCATTER MEMVAR
            APPEND BLANK
            GATHER MEMVAR
            REPLACE ORD_AGE WITH AGEASS
            IF NOTAC <> "S"
               REPLACE ORD_PRORIG WITH PERCPR
               IF ORD_VALORE-ORD_VALOK>=0       && HO VENDUTO SOTTOCOSTO? NO
                  REPLACE ORD_NEGA   WITH 0
                  REPLACE ORD_PROVVI WITH ROUND((ORD_VALORE*ORD_PRORIG/100),0)
                  REPLACE ORD_PROTOT WITH ORD_PROVVI
                  IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)        && HO INCASSATO
                     REPLACE ORD_PRINCA WITH ORD_PROVVI
                     REPLACE ORD_PROTOT WITH 0
                  ENDIF
               ELSE                             && HO VENDUTO SOTTOCOSTO? SI
                  REPLACE ORD_NEGA   WITH ORD_VALORE-ORD_VALOK
                  REPLACE ORD_PROVVI WITH ROUND((ORD_VALORE*ORD_PRORIG/100),0)
                  REPLACE ORD_PROTOT WITH ORD_PROVVI+ORD_NEGA         && ORD_NEGA E' NEGATIVO E LO TOLGO
                  IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)
                     REPLACE ORD_INCANE WITH ORD_NEGA
                     REPLACE ORD_NEGA   WITH 0
                     REPLACE ORD_PRINCA WITH ORD_PROVVI
                     REPLACE ORD_PROTOT WITH 0
                     REPLACE ORD_PROVVI WITH 0
                  ENDIF
               ENDIF
            ELSE                                 && CASO NOTA DI CREDITO
               REPLACE ORD_PRZOK  WITH 0
               REPLACE ORD_VALOK  WITH 0
               REPLACE ORD_PRORIG WITH PERCPR
               REPLACE ORD_NEGA   WITH 0
               REPLACE ORD_PROVVI WITH ROUND((ORD_VALORE*ORD_PRORIG/100*-1),0)
               REPLACE ORD_PROTOT WITH ORD_PROVVI
               IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)
                  REPLACE ORD_PRINCA WITH ORD_PROVVI
                  REPLACE ORD_PROTOT WITH 0
               ENDIF
            ENDIF
            
            **--> RIPORTO DATI ORIGINALI .SER SU VARIABILI DI SUPPORTO PER RIELABORAZIONI SUCCESSIVE
            SELECT CUR_PROVVI
	        REPLACE OLD_INCANE WITH ORD_INCANE
            REPLACE OLD_NEGA   WITH ORD_NEGA
            REPLACE OLD_PRINCA WITH ORD_PRINCA
            REPLACE OLD_PROTOT WITH ORD_PROTOT
            REPLACE OLD_PROVVI WITH ORD_PROVVI

         ENDIF
         **--> AZZERO LE VARIABILI PER LE ELABORAZIONI SUCCESSIVE
         M.ORD_NEGA=0
         M.ORD_PROVVI=0
         M.ORD_PROTOT=0
         M.ORD_PRINCA=0
         M.ORD_PROTOT=0
         M.ORD_INCANE=0
         SELECT U_FAT_DD
         SKIP +1
      ENDDO
      CTRELAB=CTRELAB+1
      WAIT WINDOW "Fatture Elaborate :"+STR(CTRELAB,10,0) NOWAIT
   ENDIF
 
   SELECT U_FAT_TT
   SKIP +1

ENDDO

** ############################################################################################ **
**--> RIELABORA LE FATTURE DALL'ARCHIVIO STORICO AL VINE DI VERIFICARE SE ESISTONO INCASSATI
** ############################################################################################ **

CTRELAB=0


SELECT CUR_PROVVI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF


   IF ORD_DATORD<STORIDAL
     SELECT CUR_PROVVI
     SKIP +1
     LOOP
   ENDIF

   IF ORD_DATORD>STORIAL
     SELECT CUR_PROVVI
     SKIP +1
     LOOP
   ENDIF

   IF !OKAGE(ORD_AGE)
     SELECT CUR_PROVVI
     SKIP +1
     LOOP
   ENDIF



   SCATTER MEMVAR

   **--> RIPRISTINO DATI ORIGINALI

   REPLACE ORD_INCANE WITH M.OLD_INCANE
   REPLACE ORD_NEGA   WITH M.OLD_NEGA
   REPLACE ORD_PRINCA WITH M.OLD_PRINCA
   REPLACE ORD_PROTOT WITH M.OLD_PROTOT
   REPLACE ORD_PROVVI WITH M.OLD_PROVVI

   **--> TEST PER INCASSATO SOTTOCOSTO O NO

   IF ORD_NEGA=0                    && INCASSO NORMALE
      IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)
         REPLACE ORD_PRINCA WITH ORD_PROVVI
         REPLACE ORD_PROTOT WITH 0
      ENDIF
   ELSE
      IF GETINCA(M.ORD_NPROT,M.ORD_CODCLI,M.ORD_AGE)        && INCASSO SOTTOCOSTO
         REPLACE ORD_INCANE WITH ORD_NEGA
         REPLACE ORD_NEGA   WITH 0
         REPLACE ORD_PRINCA WITH ORD_PROVVI
         REPLACE ORD_PROTOT WITH 0
         REPLACE ORD_PROVVI WITH 0
      ELSE
         REPLACE ORD_PROTOT WITH ORD_NEGA+ORD_PROVVI
      ENDIF
   ENDIF

   CTRELAB=CTRELAB+1
   
   WAIT WINDOW "Movimenti Storici Elaborati :"+STR(CTRELAB,10,0) + " al " + STORIAL NOWAIT

   SELECT CUR_PROVVI
   SKIP +1

ENDDO

IF !ExecRW('','PROVVI','I','','CUR_PROVVI')
   return(.f.)
ENDIF

*** RELEASE WINDOW DISPLAY
DO VISU_ERR          && SE UTENTE VUOLE VISUALIZZA GLI EVENTUALI ERRORI

WAIT WINDOW "Operazione completata. Buon lavoro..."

RETURN


*********************
FUNCTION ERRORE
*********************
PARA V_STRINGA

S_S=STR(SELECT())

SELECT PRO_ERR
APPEND BLANK
REPLACE RIGA WITH V_STRINGA

SELECT &S_S
RETURN(.T.)


*********************
FUNCTION GETPREZZO
*********************
PARA V_CODART,V_CODCLI,V_CODAGE

SS=STR(SELECT())

VPREZZO=0
TROV=.F.

IF GETDIFP(V_CODAGE)
   x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
   x_agen = "lis_age = '" + ALLTRIM(V_CODAGE) + "'"
   x_arti = "lis_codart = '" + ALLTRIM(V_CODART) + "'"
   x_cond = x_soci + " and " + x_agen + " and " + x_arti
   cSql="SELECT * FROM U_LIS_AG WHERE " + x_cond + " order by lis_codsoc"
   IF !ExecCommand(cSql,"CUR_LISAGE")
      return(.f.)
   ENDIF
   SELECT CUR_LISAGE
   GO TOP
   IF !EOF()
      VPREZZO=LIS_PREZZO
   ELSE
      =ERRORE("Prezzo articolo non trovato nel listino AGE + ART : " + V_CODAGE + V_CODART)
   ENDIF
   SELECT &SS
   RETURN(VPREZZO)
ENDIF

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(V_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP
IF !EOF()
   TROV=.T.
   IF ART_PRZVEN<>0
      VPREZZO=ART_PRZVEN
   ENDIF
ENDIF

x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
x_agen = "age_codice = '" + ALLTRIM(V_CODAGE) + "'"
x_cond = x_soci + " and " + x_agen
Csql   = "select * from u_age_an where " + x_cond + " order by age_codsoc,age_codice"
IF !ExecCommand(cSql,"cur_agente")
   return(.f.)
ENDIF
SELECT cur_agente
GO TOP
IF !EOF()
   V_LISTIN=AGE_LISTIN
ELSE
   =ERRORE("Non trovato in anagrafica il codice agente "+V_CODAGE)
   V_LISTIN=SPACE(2)
ENDIF

IF V_LISTIN<>SPACE(2)
   x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
   x_tipo = "lis_tipo = '" + ALLTRIM(V_LISTIN) + "'"
   x_codi = "lis_codart = '" + ALLTRIM(V_CODART) + "'"
   x_cond = x_soci + " and " + x_tipo + " and " + x_codi
   cSql="SELECT * FROM U_LIS_VE WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_codart"
   IF !ExecCommand(cSql,"CUR_listino")
      return(.f.)
   ENDIF
   SELECT CUR_LISTINO
   GO TOP
   IF !EOF()
      TROV=.T.
      IF LIS_PREZZO<>0
         VPREZZO=LIS_PREZZO
      ENDIF
   ENDIF
ENDIF

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_clie = "lis_codcli = '" + ALLTRIM(V_CODCLI) + "'"
x_codi = "lis_codart = '" + ALLTRIM(V_CODART) + "'"
x_cond = x_soci + " and " + x_clie + " and " + x_codi
cSql="SELECT * FROM U_LIS_TT WHERE " + x_cond + " order by lis_codsoc,lis_codcli,lis_codart"
IF !ExecCommand(cSql,"CUR_listino")
   return(.f.)
ENDIF
SELECT CUR_LISTINO
GO TOP
IF !EOF()
   TROV=.T.
   IF LIS_PREZZO<>0
      VPREZZO=LIS_PREZZO
   ENDIF
ENDIF

SELECT &SS

IF !TROV
   =ERRORE("Non è inserito nessun listino per articolo " + V_CODART + " cliente " + V_CODCLI)
ENDIF

IF VPREZZO=0 .AND. TROV
   =ERRORE("Prezzo = 0 per articolo " + V_CODART + " cliente " + V_CODCLI)
ENDIF

RETURN(VPREZZO)


*********************
FUNCTION GETPROVVI
*********************
PARA V_CODAGE,V_CODART,V_CODCLI,V_DATA

SS=STR(SELECT())
VPROVVI=0
TROV=.F.

**--> ACCEDO ANAGRAFICA AGENTE

x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
x_agen = "age_codice = '" + ALLTRIM(V_CODAGE) + "'"
x_cond = x_soci + " and " + x_agen
Csql   = "select * from u_age_an where " + x_cond + " order by age_codsoc,age_codice"
IF !ExecCommand(cSql,"cur_agente")
   return(.f.)
ENDIF
SELECT cur_agente
GO TOP
IF !EOF()
   TROV=.T.
   V_LISTIN=AGE_LISTIN
   IF AGE_PROVVI<>0
      VPROVVI=AGE_PROVVI
   ENDIF
ELSE
   =ERRORE("Non trovato in anagrafica il codice agente " + V_CODAGE)
   V_LISTIN=SPACE(2)
ENDIF

**--> ACCEDO LISTINO VENDITE PER TIPO LISTINO + ARTICOLO

IF V_LISTIN<>SPACE(2)
   x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
   x_tipo = "lis_tipo = '" + ALLTRIM(V_LISTIN) + "'"
   x_codi = "lis_codart = '" + ALLTRIM(V_CODART) + "'"
   x_cond = x_soci + " and " + x_tipo + " and " + x_codi
   cSql="SELECT * FROM U_LIS_VE WHERE " + x_cond + " order by lis_codsoc,lis_tipo,lis_codart"
   IF !ExecCommand(cSql,"CUR_listino")
      return(.f.)
   ENDIF
   SELECT CUR_LISTINO
   GO TOP
   IF !EOF()
      TROV=.T.
      IF LIS_PROV1<>0
         VPROVVI=LIS_PROV1
      ENDIF
   ENDIF
ENDIF

**--> ACCEDO LISTINO SPECIALE CLIENTE + ARTICOLO + DATA VALIDITA'

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_clie = "lis_codcli = '" + ALLTRIM(V_CODCLI) + "'"
x_codi = "lis_codart = '" + ALLTRIM(V_CODART) + "'"
x_cond = x_soci + " and " + x_clie + " and " + x_codi
cSql="SELECT * FROM U_LIS_TT WHERE " + x_cond + " order by lis_codsoc,lis_codcli,lis_codart"
IF !ExecCommand(cSql,"CUR_listino")
   return(.f.)
ENDIF
SELECT CUR_LISTINO
GO TOP
IF !EOF()
   TROV=.T.
   IF LIS_PROVVI<>0 .AND. V_DATA>=RIBALTA2(LIS_DATLIS) .AND. V_DATA<=RIBALTA2(LIS_ALLIST)
      VPROVVI=LIS_PROVVI
   ENDIF
ENDIF

**--> ACCEDO ANAGRAFICA CLIENTE

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"cur_cliente")
   return(.f.)
ENDIF
SELECT cur_cliente
GO TOP
IF EOF()
   TROV=.T.
   IF CLI_PROVVI<>0
      VPROVVI=CLI_PROVVI
   ENDIF
   IF CLI_NOPROV       && SU QUESTO CLIENTE NON DEVO CALCOLARE PROVVIGIONI
      VPROVVI=0
   ENDIF
ENDIF

SELECT &SS

IF !TROV
   =ERRORE("Non trovata provvigione per articolo " + V_CODART + " cliente " + V_CODCLI + " agente " + V_CODAGE)
ENDIF

IF VPROVVI=0 .AND. TROV
   =ERRORE("Provvigione = 0 per articolo " + V_CODART + " cliente " + V_CODCLI + " agente " + V_CODAGE)
ENDIF

RETURN(VPROVVI)


*********************
FUNCTION GETDIFP
*********************
PARA V_CODAGE

S_S_S_S=STR(SELECT())

RITORNO=.F.

x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
x_agen = "age_codice = '" + ALLTRIM(V_CODAGE) + "'"
x_cond = x_soci + " and " + x_agen
Csql   = "select * from u_age_an where " + x_cond + " order by age_codsoc,age_codice"
IF !ExecCommand(cSql,"cur_agente")
   return(.f.)
ENDIF
SELECT cur_agente
GO TOP
IF !EOF()
   RITORNO=AGE_DIFPRZ
ELSE
   RITORNO=.F.
   =ERRORE("Non trovato in anagrafica il codice agente "+V_CODAGE)
ENDIF

SELECT &S_S_S_S

RETURN(RITORNO)


*********************
FUNCTION GETDEPO
*********************
PARA V_CODAGE

SS=STR(SELECT())

VDEPO=SPACE(3)

x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
x_agen = "age_codice = '" + ALLTRIM(V_CODAGE) + "'"
x_cond = x_soci + " and " + x_agen
Csql   = "select * from u_age_an where " + x_cond + " order by age_codsoc,age_codice"
IF !ExecCommand(cSql,"cur_agente")
   return(.f.)
ENDIF
SELECT cur_agente
GO TOP
IF !EOF()
   VDEPO=AGE_DEPCOL
ELSE
   =ERRORE("Non trovato in anagrafica il codice agente "+V_CODAGE)
ENDIF

SELECT &SS

RETURN(VDEPO)


*****************
FUNCTION ALLINEA
*****************
PARA STRINGA
RETURN(REPLICATE(" ",10-LEN(ALLTRIM(STRINGA)))+ALLTRIM(STRINGA))
RETURN


******************************************
FUNCTION CONTROL_FAT
******************************************

* CONTROLLA :
* 1) SE ESISTONO FATTURE
* 2) FATTURE SONO STATE TUTTE PROTOCOLLATE

CTRELAB = 0
FL_OK   = .T.

x_dt1   = DATADAL
x_dt2   = DATAAL
x_soci  = "ord_codsoc = '" + PUB_CODSOC + "'"
x_anno  = "ord_anno = '" + SUBSTR(DATADAL,1,4) + "'"
x_data  = "ord_datord >= '" + x_dt1 + "'"
cSql    = "SELECT * FROM u_fat_tt WHERE " + x_data + " order by ord_codsoc,ord_anno,ord_datord"
IF !ExecCommand(cSql,"CUR_FATTURE")
   return(.f.)
ENDIF
SELECT CUR_FATTURE
GO TOP
IF EOF()
   =MESSAGEBOX("Non esistono fatture nel periodo specificato",62,"ATTENZIONE")
   RETURN
ENDIF

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ORD_DATORD <= DATAAL
   ELSE
      EXIT
   ENDIF

   CTRELAB=CTRELAB+1

   WAIT WINDOW "Fatture Elaborate :"+STR(CTRELAB,10,0)  NOWAIT

   IF EMPTY(ORD_NPROT)                            && VERIFICA N.PROTOCOLLO
	  FL_OK = .F.
	  EXIT
   ENDIF

   SKIP +1
   LOOP

ENDDO


IF CTRELAB=0
   =MESSAGEBOX("Non esistono fatture nel periodo specificato",62,"ATTENZIONE")
   RETURN(.T.)
ELSE
	IF !FL_OK
  	   =MESSAGEBOX("Funzione non permessa devi protocollare le fatture",62,"ATTENZIONE")
	   RETURN(.F.)
	ENDIF
ENDIF

RETURN(.T.)


******************************************
FUNCTION PRO_CANC
******************************************

* SE ESISTONO PROVVIGIONI NEL PERIODO E SE UTENTE CONFERMA LE CANCELLA


TOT=0

x_dt1   = DATADAL
x_dt2   = DATAAL
x_data  = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
cSql    = "SELECT * FROM provvi WHERE " + x_data + " order by ord_datord"
IF !ExecCommand(cSql,"CUR_PROVVI")
   return(.f.)
ENDIF
SELECT CUR_PROVVI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   TOT=TOT+1
  
   EXIT

   SKIP +1

ENDDO

IF TOT=0     && TOT=0 SE PROVVIGIONI NON CI SONO PER IL PERIODO
   RETURN(.T.)
ENDIF

RIT=MESSAGEBOX("Esistono movimenti provvigionali nel periodo, li cancello ? ",292,"ATTENZIONE")
IF RIT=7
   RETURN(.F.)
ENDIF

x_dt1   = DATADAL
x_dt2   = DATAAL
x_data  = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
cSql    = "DELETE FROM PROVVI WHERE  " + x_data 
IF !ExecCommand(CSQL,"PROVVI")
   RETURN (.f.)
ENDIF 

RETURN(.T.)

******************************************
FUNCTION CARICA_STORICO
******************************************

* RICARICA LE FATTURE IN PRECEDENZA MEMORIZZATE NELLO STORICO PER VERIFICARE ULTERIORI INCASSI AVVENUTI NEL FRATTEMPO


x_dt1   = STORIDAL
x_dt2   = STORIAL
x_data  = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
cSql    = "SELECT * FROM provvi WHERE " + x_data + " order by ord_datord"
IF !ExecCommand(cSql,"CUR_PROVVI")
   return(.f.)
ENDIF
SELECT CUR_PROVVI
GO TOP


RETURN(.T.)


**********************************
PROCEDURE VISU_ERR
**********************************

SELECT PRO_ERR
GO TOP
IF EOF()
   RETURN
ENDIF

RIT=MESSAGEBOX("Desideri stampare un elenco di errori ?",292,"ATTENZIONE")
IF RIT=7
   RETURN
ENDIF

SELECT PRO_ERR
GO TOP
REPORT FORM report\PRO_ERR NOEJECT NOCONSOLE PREVIEW
REPORT FORM report\PRO_ERR NOEJECT NOCONSOLE TO PRINTER PROMPT

RETURN


********************
FUNCTION GETTOP
********************
PARA _TOP
OUT=.T.
SELE=STR(SELECT())
v_seek	 = "TPP"+_TOP
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   OUT=.T.
ELSE
   OUT=.F.
ENDIF
SELECT &SELE
RETURN(OUT)


*********************
FUNCTION GETINCA
*********************
PARA V_NPROT,V_CODCLI,V_AGE

SS_SS=STR(SELECT())

SELECT GIA_INCA
SET ORDER TO GIA_INCA
SEEK ALLTRIM(V_CODCLI)+ALLTRIM(V_NPROT)
IF FOUND()
   VINCA=INCA
   SELECT &SS_SS
   RETURN(VINCA)
ENDIF

VINCA       = .F.
TOT_PARTITA = 0
_OK_PARTITA_TROVATA = .F.

x_soci  = "par_codsoc = '" + PUB_CODSOC + "'"
x_clie  = "par_codcli = '" + PREFIX+ALLTRIM(V_CODCLI) + "'"
x_npro  = "par_npart = '" + ALLTRIM(V_NPROT) + "'"
cSql    = "SELECT * FROM part_cli WHERE " + x_soci + " and " + x_clie + " and " + x_npro + ;
                                        " order by par_codcli,par_npart"
IF !ExecCommand(cSql,"PART_CLI")
   return(.f.)
ENDIF
SELECT PART_CLI
GO TOP



DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   _OK_PARTITA_TROVATA = .T.

   IF PAR_NPROG=100  && .AND. PAR_TIPODO="FAT"
      SKIP +1
      LOOP
   ENDIF

*!*	   IF PAR_DTREG>DATAAL    && SCARTO I MOVIMENTI REGISTRATI NEL MESE SUCCESSIVO ????? QUESTO TEST E' D VERIFICARE 
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

   IF SCARTATOP(PAR_TIPFAT)  && ELABORO SOLO I TOP .....
      SKIP +1
      LOOP
   ENDIF

   IF !VALID_SCAD("RAU",PAR_TIPFAT,_DATARIF,PAR_DTSCAD,V_AGE)
	  SKIP +1
	  LOOP
   ENDIF
	
   IF !VALID_SCAD("RBM",PAR_TIPFAT,_DATARBM,PAR_DTSCAD,V_AGE)
	  SKIP +1
	  LOOP
   ENDIF

   IF !VALID_SCAD("EFF",PAR_TIPFAT,_DATAEFF,PAR_DTSCAD,V_AGE)
	  SKIP +1
	  LOOP
   ENDIF
	
   IF !VALID_PER(PAR_DTREG,V_AGE)    && CONSIDERA SOLO PER RBM IL TEST SULLE DATE REGISTRAZIONE
	  SKIP +1
	  LOOP
   ENDIF

   IF PAR_TMOV="D"
      TOT_PARTITA=TOT_PARTITA+PAR_FATT
   ELSE
      TOT_PARTITA=TOT_PARTITA-PAR_FATT
   ENDIF

   SKIP +1

ENDDO

IF _OK_PARTITA_TROVATA 
	IF TOT_PARTITA = 0
	   VINCA=.T.
	ENDIF
ELSE
   VINCA=.F.
ENDIF


SELECT GIA_INCA
APPEND BLANK
REPLACE CODCLI  WITH V_CODCLI
REPLACE PARTITA WITH VAL(V_NPROT)
REPLACE INCA    WITH VINCA

SELECT &SS_SS

RETURN(VINCA)


******************
FUNCTION SCARTATOP
******************
PARA VTOP
SS=STR(SELECT())

v_seek	 = "PRV"+VTOP
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   OUT=.T.
ELSE
   OUT=.F.
ENDIF
SELECT &SS
RETURN(OUT)


*******************
FUNCTION VALID_SCAD
*******************
PARA TIPO,VTOP,DATASC,CAMPO,XAGE

SS=STR(SELECT())

*--> RICERCO FLAG DI INCASSO SU ANAGRAFICA AGENTE SE SI NON TESTO LE DATE E RITORNO SEMPRE INCASSATO

x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
x_agen = "age_codice = '" + ALLTRIM(XAGE) + "'"
x_cond = x_soci + " and " + x_agen
Csql   = "select * from u_age_an where " + x_cond + " order by age_codsoc,age_codice"
IF !ExecCommand(cSql,"cur_agente")
   return(.f.)
ENDIF
SELECT cur_agente
GO TOP
IF !EOF()
   F_RBMINC=AGE_RBMINC
   F_RAUINC=AGE_RAUINC
   F_EFFINC=AGE_EFFINC
   F_RBMPER=AGE_RBMPER
ELSE
   F_RBMINC=.F.
   F_RAUINC=.F.
   F_EFFINC=.F.
   F_RBMPER=.F.
ENDIF

**--> QUESTO TEST SERVE PER GESTIRE LE RICEVUTE MANUALI INCASSATE NEL PERIODO DI FATT.
**--> IL TEST PER PERIODO VIENE FATTO NELLA FUNZIONE VALID_PER

IF TIPO="RBM" .AND. F_RBMPER
   SELECT &SS
   RETURN(.T.)
ENDIF

**   IF !VALID_SCAD("RAU",PAR_TIPFAT,_DATARIF,PAR_DTSCAD,V_AGE)
**                   TIPO,VTOP,       DATASC,   CAMPO,   XAGE
OUT=.F.
v_seek	 = TIPO+VTOP
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF !EMPTY(DATASC)
      IF CAMPO > DATASC     && DATA SCADENZA > DATA DI RIFERIMENTO DA RAU RBM EFF
                            && SCARTA IL MOVIMENTO CONSIDERANDOLO NON INCASSATO
         OUT=.F.
         **--> TUTTO QUELLO FATTO SOPRA VALE SE NON ESISTONO I FLAG DI SEMPRE PAGATO SU ANA AGE
         IF TIPO="RAU" .AND. F_RAUINC
            OUT=.T.
         ENDIF
         IF TIPO="RBM" .AND. F_RBMINC
            OUT=.T.
         ENDIF
         IF TIPO="EFF" .AND. F_EFFINC
            OUT=.T.
         ENDIF
      ELSE
         OUT=.T.
	  ENDIF
   ENDIF
ELSE
   OUT=.T.
ENDIF

SELECT &SS

RETURN(OUT)


*******************
FUNCTION VALID_PER
*******************
PARA DATAREG,XAGE

SS=STR(SELECT())

*--> RICERCO FLAG DI INCASSO SU ANAGRAFICA AGENTE SE SI NON TESTO LE DATE E DO SEMPRE INCASSATO
x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
x_agen = "age_codice = '" + ALLTRIM(XAGE) + "'"
x_cond = x_soci + " and " + x_agen
Csql   = "select * from u_age_an where " + x_cond + " order by age_codsoc,age_codice"
IF !ExecCommand(cSql,"cur_agente")
   return(.f.)
ENDIF
SELECT cur_agente
GO TOP
IF !EOF()
   F_RBMPER=AGE_RBMPER
ELSE
   F_RBMPER=.F.
ENDIF

SELECT &SS

OUT=.T.

IF ALLTRIM(PAR_TIPFAT)="RBM" .AND. F_RBMPER
   IF PAR_DTREG>=DATADAL .AND. PAR_DTREG<=DATAAL
      OUT=.T.
   ELSE
      OUT=.F.
   ENDIF
ELSE
   OUT=.T.
ENDIF

RETURN(OUT)



*********************************
FUNCTION OKAGE				&& SE NON ESISTE PIU' IL CODICE AGENTE IN ANAGRAFICA AGENTI : CESSATO E DI CONSEGUENZA NON SI ELABORANO PIU' I SUOI MOVIMENTI
*********************************
PARA _AGE
SS=STR(SELECT())


x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
x_agen = "age_codice = '" + ALLTRIM(_AGE) + "'"
x_cond = x_soci + " and " + x_agen
Csql   = "select * from u_age_an where " + x_cond + " order by age_codsoc,age_codice"
IF !ExecCommand(cSql,"cur_agente")
   return(.f.)
ENDIF
SELECT cur_agente
GO TOP
IF !EOF()
  OUT=.T.
ELSE
  OUT=.F.
ENDIF

SELECT &SS
RETURN(OUT)
