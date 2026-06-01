* FASE  CHIUSURA EFFETTIVA DELL'ANNO CONTABILE :
*
* 0) VERIFICA SE IN PRECEDENZA E' STATO APERTO IL NUOVO ANNO
*
* 1) CONTROLLA L'ANNO DA CHIUDERE SU PARAMETRI
*
* 2) VA SU CONTICA E CONTROLLA CONGRUENZA CON ANNO REGISTRATO
*
* 3) COPIA DA  MO_CONCA I MOVIMENTI DELL' ANNO REG. + 1 SU MOV_CONT
*    CONSIDERANDO IL NUOVO NUMERO DI REGISTRAZIONE
*
* 4) SE ANNO CONTABILE :
*
*    6.1 - GIA' APERTO ALL'INIZIO DELL'ANNO :
*          .. AZZERA   DB CONTICA
*          .. AGGIORNA DB CONTICA DA MO_CONCA CON MOVIMENTI DI NUOVO ANNO APERTO
*          .. AGGIORNA DB CONTI DA CONTICA :
*             - SOMMANDO SE ESISTE IL CONTO
*             - INSERENDO IL NUOVO CONTO SE NON ESISTE
*
* 5) CONTROAGGIORNA CONTI SU ESERCIZIO PRECEDENTE RIPORTANDO I SALDI CHIUSI PER UNA EVENTUALE RISTAMPA DEL BILANCIO
*
* 6) CHIUDE ANNO REGISTRATO SU D.B. PARAMETRI
*

*     
   
V_CONINS = 0
V_CONVAR = 0

PUB_ERRORE=MESSAGEBOX("Prima di proseguire hai fatto "+CHR(13)+"i salvataggi ??",292,"*** ATTENZIONE ***")
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
        RETURN
ENDCASE


* 0) VERIFICA SE IN PRECEDENZA E' STATO APERTO IL NUOVO ANNO
*===========================================================


IF USED('CONTICA')
  SELECT CONTICA
  USE 
ENDIF


V_ANNO   = PUB_ANNO
V_AAPIU1 = STR((VAL(V_ANNO)+1),4,0)
TROVATI  = 0
QUESTO   = 0



v_seek   = 'ANN'+ PUB_CODSOC
v_chiave = "codice"
cSql     = "select * from para where " + v_chiave + " LIKE '" + v_seek + "%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
   DO WHILE SUBSTR(CODICE,1,5)='ANN'+PUB_CODSOC
      IF SUBSTR(LIBERA,1,1)='A' .AND. SUBSTR(CODICE,6,4)=V_AAPIU1
         TROVATI= 1
         EXIT
      ENDIF
      SKIP +1
   ENDDO
ENDIF

IF TROVATI <> 1
   =MESSAGEBOX("Attenzione nuovo anno fiscale "+V_AAPIU1+CHR(13)+"non ancora aperto",62,"*** ATTENZIONE ***")
   RETURN
ENDIF

* 1) CONTROLLA L'ANNO DA CHIUDERE SU PARAMETRI
*=============================================

V_ANNO   = PUB_ANNO
V_AAPIU1 = STR((VAL(V_ANNO)+1),4,0)
TROVATI  = 0
QUESTO   = 0

v_seek   = 'ANN'+ PUB_CODSOC
v_chiave = "codice"
cSql     = "select * from para where " + v_chiave + " LIKE '" + v_seek + "%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
   DO WHILE SUBSTR(CODICE,1,5)='ANN'+PUB_CODSOC
      IF SUBSTR(LIBERA,1,1)='C' .AND. SUBSTR(CODICE,6,4)=V_ANNO
         =MESSAGEBOX("Attenzione anno fiscale "+V_ANNO+CHR(13)+"attualmente chiuso",62,"*** ATTENZIONE ***")
         RETURN
      ELSE
         IF SUBSTR(LIBERA,1,1)='A' .AND. SUBSTR(CODICE,6,4)=V_ANNO
            EXIT
         ENDIF
      ENDIF
      SKIP +1
   ENDDO
ENDIF

* 2) VA SU CONTICA E CONTROLLA CONGRUENZA CON ANNO REGISTRATO
* ===========================================================

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + V_ANNO  + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from contica where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(Csql,"contica")
   return(.f.)
ENDIF
SELECT contica
GO TOP
IF !EOF()
   IF CON_ANNO <> V_ANNO
      =MESSAGEBOX("Attenzione l'anno registrato "+V_ANNO+CHR(13)+"non è stato elaborato con fase di simulazione",62,"*** ATTENZIONE ***")
      RETURN
   ENDIF
ELSE
   =MESSAGEBOX("Attenzione l'anno registrato "+V_ANNO+CHR(13)+"non è stato elaborato con fase di simulazione",62,"*** ATTENZIONE ***")
   RETURN
ENDIF




* 3) PRELEVA IL MESE DI CHIUSURA 
* ==========================================================

V_MMCHI = "12"
x_soci = "fin_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci 
Csql   = "select * from chiusura where " + x_cond + " order by fin_codsoc"
IF !ExecCommand(cSql,"chiusura")
   return(.f.)
ENDIF
SELECT chiusura
GO TOP
IF !EOF()
   V_MMCHI=FIN_MMCHI          && MESE   PER CHIUSURA
ELSE
   =MESSAGEBOX("Conti di chiusura non trovati in archivio CHIUSURA",64,"*** ATTENZIONE ***")
   RETURN
ENDIF



* 3) AGGIORNA NUMERO DI REGISTRAZIONE ESERCIZIO IN CHIUSURA 
* ==========================================================

NREG       = ""
OLD_NUMPRO = "9999"

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + V_ANNO  + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from mo_conca where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecRW(Csql,"mo_conca","R")
   return(.f.)
ENDIF
SELECT mo_conca
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   ATT_NUMPRO=MOV_NUMPRO
   IF ALLTRIM(OLD_NUMPRO)<>ALLTRIM(ATT_NUMPRO)
      OLD_NUMPRO=ATT_NUMPRO
      DO REG_NUMREG              && AGGIORNA PARAMETRI NUM.REG.PRIMA N.  UTENTE
   ENDIF
   SELECT MO_CONCA
   REPLACE MOV_NREGIS WITH ALLTRIM(NREG)
   SKIP +1
ENDDO
IF !ExecRW(Csql,"mo_conca","W")
   return(.f.)
ENDIF

* 3) AGGIORNA NUMERO DI REGISTRAZIONE ESERCIZIO IN APERTURA
* =========================================================

NREG       = ""
OLD_NUMPRO = "9999"

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + V_AAPIU1  + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from mo_conca where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecRW(Csql,"mo_conca","R")
   return(.f.)
ENDIF
SELECT mo_conca
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   ATT_NUMPRO=MOV_NUMPRO
   IF ALLTRIM(OLD_NUMPRO)<>ALLTRIM(ATT_NUMPRO)
      OLD_NUMPRO=ATT_NUMPRO
      DO REG_NUMAAS              && AGGIORNA PARAMETRI NUM.REG.PRIMA N.  UTENTE
   ENDIF
   SELECT MO_CONCA
   REPLACE MOV_NREGIS WITH ALLTRIM(NREG)
   SKIP +1
ENDDO
IF !ExecRW(Csql,"mo_conca","W")
   return(.f.)
ENDIF

* 4) AGGIORNA DATA DOCUMENTO FORZANDOLA AL 31/12 SOLO PER MOVIMENTI DI CHIUSURA
* =============================================================================

DTDX=PUB_ANNO+"/12/31"

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + V_ANNO  + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from mo_conca where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecRW(Csql,"mo_conca","R")
   return(.f.)
ENDIF
SELECT mo_conca
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   IF PUB_ANNO = "2001"
	  IF MOV_TOP = "APE"    && SOLO APERTURE
     	 REPLACE MOV_IMP   WITH ROUND((MOV_IMP / 1936.27),2)  && SOLO PER I CLIENTI CHE HANNO 1L 2001 IN LIRE
	  ENDIF
   ENDIF	
   IF MOV_TOP <> "CHI"    && SOLO CHIUSURE
      SKIP +1
      LOOP
   ENDIF
   REPLACE MOV_DTDOC WITH DTDX
   SKIP +1
ENDDO
IF !ExecRW(Csql,"mo_conca","W")
   return(.f.)
ENDIF

* 3) COPIA DA  MO_CONCA I MOVIMENTI SU MOV_CONT / INDICE
* ======================================================

IF !ExecCommand("select * from mov_cont where 0=1","cu_movcont")
   return(.f.)
ENDIF

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_cond = x_soci 
Csql   = "select * from mo_conca where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecCommand(Csql,"mo_conca")
   return(.f.)
ENDIF
SELECT mo_conca
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
   SELECT CU_MOVCONT
   APPEND BLANK
   GATHER MEMVAR MEMO
   REPLACE MOV_CONTOP WITH SPACE(13)
   REPLACE MOV_IVA    WITH "NO"
   REPLACE MOV_CAMBIO WITH XCAMBIO
   REPLACE MOV_VALUTA WITH XVALUTA
   SELECT MO_CONCA
   SKIP +1
ENDDO
IF !ExecRW('','mov_cont','I','','CU_MOVCONT')
   return(.f.)
ENDIF

* --->> INDICE

IF !ExecCommand("select * from indice where 0=1","CU_INDICE")
   return(.f.)
ENDIF

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_cond = x_soci
Csql   = "select * from mo_conca where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecCommand(Csql,"mo_conca")
   return(.f.)
ENDIF
SELECT mo_conca
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   IF !EMPTY(MOV_CONTOP)
      SKIP +1
      LOOP
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_INDICE
   APPEND BLANK
   GATHER MEMVAR MEMO
   REPLACE MOV_IVA    WITH "NO"
   SELECT MO_CONCA
   SKIP +1
ENDDO
IF !ExecRW('','indice','I','','CU_INDICE')
   return(.f.)
ENDIF

* 6) SE ANNO CONTABILE :
*
*    6.1 - GIA' APERTO ALL'INIZIO DELL'ANNO :
*          .. AZZERA   DB CONTICA
*          .. AGGIORNA DB CONTICA DA MO_CONCA CON MOVIMENTI DI NUOVO ANNO APERTO
*          .. AGGIORNA DB CONTI DA CONTICA :
*             - SOMMANDO SE ESISTE IL CONTO
*             - INSERENDO IL NUOVO CONTO SE NON ESISTE SOLO SE SALDI DIVERSI DA ZERO
*

WAIT WINDOWS "Aggiornamento archivi in corso" NOWAIT
DO FANNIREP   && AGGIORNA ARCHIVI CONTABILI

WAIT WINDOWS "Ricalcolo saldi" NOWAIT
DO FANNICLX   && AZZERA SALDI E RICALCOLA SIA PER ANNO IN CORSO CHE NUOVO ESERCIZIO



* 7) AGGIORNA CONTI RIPORTANDO I SALDI CHIUSI PER UNA EVENTUALE RISTAMPA DEL BILANCIO ANCHE SE è CHIUSO
* =====================================================================================================

** RIPULISCE IL SALDO DI CHIUSURA SU CONTI

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + ALLTRIM(V_ANNO) + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"conti","R")
   return(.f.)
ENDIF
SELECT conti
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   REPLACE CHI_MMCHI  WITH ""
   REPLACE CHI_TMOV   WITH ""
   REPLACE CHI_SALDO  WITH 0

   SELECT CONTI
   SKIP +1
ENDDO

IF !ExecRW(cSql,"conti","W")
   return(.f.)
ENDIF

*!*	RIPORTA SU CONTI I DADI DI CHIUSURA DA MO_CONCA TOP "CHI"

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + V_ANNO  + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from mo_conca where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecCommand(Csql,"ela_conca")
   return(.f.)
ENDIF
SELECT ela_conca
GO TOP

DO WHILE .T.

    IF EOF()
      EXIT
    ENDIF
   
    IF DELETED()
      SKIP +1
      LOOP
    ENDIF
   
    IF MOV_TOP <> "CHI"
	   SELECT ela_conca
  	   SKIP +1   
  	   LOOP
    ENDIF
   
   
    IF ALLTRIM(MOV_NDOC) <> "999999"
	   SELECT ela_conca
  	   SKIP +1   
  	   LOOP
    ENDIF
   
    
    _CONTO_CLOSE = MOV_CONTO
    _TMOV_CLOSE  = MOV_TMOV
    _IMP_CLOSE   = MOV_IMP
 
	x_soci = "con_soc = '" + PUB_CODSOC + "'"
	x_anno = "con_anno = '" + V_ANNO  + "'"
	x_cont = "con_conto = '" + ALLTRIM(_CONTO_CLOSE) + "'"
	x_cond = x_soci + " and " + x_anno + " and " + x_cont
	Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"

	IF !ExecRW(cSql,"conti","R")
	   return(.f.)
	ENDIF
	SELECT conti
	GO TOP
	IF !EOF()

	   REPLACE CHI_MMCHI  WITH V_MMCHI 
	   REPLACE CHI_TMOV   WITH _TMOV_CLOSE  
	   REPLACE CHI_SALDO  WITH _IMP_CLOSE   
	
	ENDIF  
   
   
    IF !ExecRW(cSql,"CONTI","W")
       return(.f.)
    ENDIF

   
   
    SELECT ela_conca
    SKIP +1
    
ENDDO







* 7) SOSPENDE ANNO REGISTRATO SU D.B. PARAMETRI
* =============================================

v_seek	  = "ANN"+PUB_CODSOC+PUB_ANNO
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
ELSE
   XVAL = SUBSTR(LIBERA,25,10)
   V_LIBERA = 'CHIUSO   ' + PUB_ANNO
   REPLACE LIBERA    WITH V_LIBERA
   REPLACE LIBERA    WITH SUBSTR(LIBERA,1,24)+XVAL
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN
