
*!*	##############################################################################################################

					**********************************************************************************************
					***         	       PROJECT SRL - CALCOLO VALORI BILANCIO RICLASSIFICATO	               ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################

RELEASE _BIL_RICLASSIFICATO_INCLUDI_PREVISIONALI
PUBLIC _BIL_RICLASSIFICATO_INCLUDI_PREVISIONALI

_BIL_RICLASSIFICATO_INCLUDI_PREVISIONALI = .F.


**=> ERASMO - INIZIO 22/03/2019
_BIL_RICLASSIFICATO_INCLUDI_SALDI_PREC = .F.

IF PUB_PRDFILM
	*** VERIFICA SE ANNO CONTABILE PRECEDENTE CHIUSO (PRESENTI MOVIMENTI DI CHIUSURA)
	cSql = "SELECT TOP 1 * FROM MOV_CONT WHERE MOV_ANNO = '" + ALLTRIM(STR(VAL(PUB_ANNO) - 1,4,0)) + "' AND MOV_TOP = 'CHI' AND MOV_NDOC = '999999'"
	IF !ExecCommand(cSql,"CHK_MOV_CONT")
	   return(.f.)
	ENDIF
	SELECT CHK_MOV_CONT
	GO TOP
	IF EOF()  && ANNO PRECEDENTE APERTO
		_BIL_RICLASSIFICATO_INCLUDI_SALDI_PREC = .T.
	ENDIF
ENDIF

_X_CONTINUA = .F.
DO FORM FORM\BRICONT LINKED
IF !_X_CONTINUA
	RETURN .F.
ENDIF

**=> ERASMO - FINE 22/03/2019

x_soci = "bil_codsoc = '" + PUB_CODSOC + "'"
CSQL   = "UPDATE BILANCIOR SET CORRENTE = 0 WHERE " + x_soci
IF !ExecCommand(cSql,"BILANCIOR")
   return(.f.)
ENDIF

WAIT WINDOW 'OPERAZIONE ASSEGNAZIONE RIGHE...ATTENDERE PER FAVORE...' NOWAIT


**=> ERASMO - INIZIO 22/03/2019
x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from conti where " + x_cond + " order by con_conto"
IF !ExecCommand(cSql,"TMP_CONTI")
   return(.f.)
ENDIF
SELECT TMP_CONTI
INDEX ON ALLTRIM(CON_CONTO) TAG I_CC

IF _BIL_RICLASSIFICATO_INCLUDI_SALDI_PREC
	
	V_CONTI= ""
	V_ECODAL = ""
	V_ECOAL  = ""
	V_PATDAL = ""
	V_PATAL  = ""
	
	v_seek 	 = "DTE_CO"+PUB_CODSOC     && PARAMETRO - DATI TESTATA RIGA 3
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	   V_CONTI=ALLTRIM(LIBERA)
	ENDIF
	V_ECODAL = STR_EXTRACT(V_CONTI,",",1)
	V_ECOAL  = STR_EXTRACT(V_CONTI,",",2)
	V_PATDAL = STR_EXTRACT(V_CONTI,",",3)
	V_PATAL  = STR_EXTRACT(V_CONTI,",",4)
	
	OK_SALDI  = .T.

   **==> ELABORO IL SALDO ESERCIZIO PRECEDENTE DEI PATRIMONIALI (VD_TOTALE/VA_TOTALE) AL FINE DI RIPORTARLO 
   **==> SUGLI ECONOMICI A QUADRATURA DEL SALDO DEI PATRIMONIALI ANNO PRECEDENTE

    EPP_UTILE_PROVVISORIO_PRECEDENTE=""
	v_seek 	 = "EPP001"     && PARAMETRO UTILE ESERCIZIO PROVVISORIO PRECEDENTE
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	   EPP_UTILE_PROVVISORIO_PRECEDENTE=ALLTRIM(LIBERA)
	ENDIF

    EPP_PERDITA_PROVVISORIO_PRECEDENTE=""
	v_seek 	 = "EPP002"     && PARAMETRO PERDITA ESERCIZIO PROVVISORIO PRECEDENTE
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   SELECT CUR_PARA
	   EPP_PERDITA_PROVVISORIO_PRECEDENTE=ALLTRIM(LIBERA)
	ENDIF


   IF EMPTY(EPP_UTILE_PROVVISORIO_PRECEDENTE) AND EMPTY(EPP_PERDITA_PROVVISORIO_PRECEDENTE)
	   _seek = PUB_CODSOC
	   x_cod = "fin_codsoc = '" + _seek + "'"
	   cSql="SELECT * FROM chiusura WHERE " + x_cod
	   IF !ExecCommand(cSql,"chiusura")
		   return(.f.)
	   ENDIF
	   SELECT CHIUSURA
	   GO TOP
	   M.FIN_UTIESE = FIN_UTIESE
	   M.FIN_PERESE = FIN_PERESE
   ELSE
	   M.FIN_UTIESE = EPP_UTILE_PROVVISORIO_PRECEDENTE
	   M.FIN_PERESE = EPP_PERDITA_PROVVISORIO_PRECEDENTE
   ENDIF

   ***************************************************************   
   PUB_ANNO_SAVE = PUB_ANNO
   PUB_ANNO      = PUB_ANNOP
   _DB = "XCONTI"
   =SALDIATT(_DB)	&& AGGIUNGE I SALDI DELL'ANNO IN CORSO
   ***************************************************************   
   
   VA_TOTALE = 0
   VD_TOTALE = 0
   DO SBC400 WITH "P",V_ECODAL,V_ECOAL,1,12,PUB_ANNO,_DB,.F.,.F.,"",.F.,_BIL_RICLASSIFICATO_INCLUDI_PREVISIONALI
   PUB_ANNO = PUB_ANNO_SAVE


   VA_TOTALE_PREC = VA_TOTALE 
   VD_TOTALE_PREC = VD_TOTALE 
   VX_TOTALE_PREC = VD_TOTALE_PREC - VA_TOTALE_PREC && SALDO PER UTILE O PERDITA ESERCIZIO DA RIPORTARE SUGLI ECONOMICI A QUADRATURA DEL SALDO DEI PATRIMONIALI ANNO PRECEDENTE
   
   _COD_CONTO = ""
   _DES_CONTO = ""
   IF VX_TOTALE_PREC > 0
      _COD_CONTO = M.FIN_PERESE  && PERDITA D'ESERCIZIO
   ELSE
      _COD_CONTO = M.FIN_UTIESE  && UTILE D'ESERCIZIO
   ENDIF
   
   
   VA_TOTALE = 0
   VD_TOTALE = 0
   
   
   ***************************************************************   
   _DB = "XCONTI"
   =SALDIPRE(_DB)	&& AGGIUNGE I SALDI DELL'ANNO PRECEDENTE
   ***************************************************************   
   
   
	x_soci = "con_soc = '" + PUB_CODSOC + "'"
	x_anno = "con_anno = '" + PUB_ANNO + "'"
	x_cont = "con_conto = '" + ALLTRIM(_COD_CONTO) + "'"
	x_cond = x_soci + " and " + x_anno + " and " + x_cont
	Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
	IF !ExecCommand(cSql,"cur_conti")
	   return(.f.)
	ENDIF
	SELECT cur_conti
	GO TOP
	IF !EOF()
	   SCATTER MEMVAR
	   SELECT XCONTI
	   SET ORDER TO CONTO
	   SEEK M.CON_SOC+M.CON_ANNO+M.CON_CONTO
	   IF FOUND()
	   ELSE
		   APPEND BLANK
		   GATHER MEMVAR
       ENDIF
	   
	   IF VD_TOTALE_PREC <> 0
	       REPLACE CON_IMP_D WITH CON_IMP_D + VD_TOTALE_PREC 
	       REPLACE CON_DA01  WITH CON_DA01  + VD_TOTALE_PREC 
	   ENDIF
	   
	   IF VA_TOTALE_PREC <> 0
	 	   REPLACE CON_IMP_A WITH CON_IMP_A + VA_TOTALE_PREC 
		   REPLACE CON_AV01  WITH CON_AV01  + VA_TOTALE_PREC 
	   ENDIF	   
	ENDIF
	
	SELECT XCONTI
	GO TOP
	SCAN
		SCATTER MEMVAR
		
		SELECT TMP_CONTI
		SET ORDER TO I_CC
		GO TOP
		SEEK ALLTRIM(M.CON_CONTO)
		IF FOUND()
	 	   REPLACE CON_IMP_A WITH M.CON_IMP_A
	 	   REPLACE CON_IMP_D WITH M.CON_IMP_D
		ENDIF
	ENDSCAN
ENDIF
**=> ERASMO - FINE 22/03/2019

x_soci = "int_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci 
Csql   = "select * from U_BRI_TT where " + x_cond + " order by int_codsoc,int_conto"
IF !ExecCommand(cSql,"U_BRI_TT")
   return(.f.)
ENDIF
SELECT U_BRI_TT
GO TOP
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODRIG = INT_CODRIG
   V_CODRIA = INT_CODRIA
   V_CONTO  = INT_CONTO
   V_IMPATT = 0

   **=> ERASMO - INIZIO 22/03/2019		
   SELECT TMP_CONTI
   SET ORDER TO I_CC
   GO TOP
   SEEK ALLTRIM(V_CONTO)
   IF FOUND()
      V_IMPATT = CON_IMP_D - CON_IMP_A
     
      IF _BIL_RICLASSIFICATO_INCLUDI_PREVISIONALI 
         IF (PRE_IMP_D - PRE_IMP_A) <> 0
            WAIT WINDOW "Elaborati dati previsionali su conto "+ALLTRIM(CON_CONTO)+" - "+ALLTRIM(CON_DESCR) NOWAIT
            V_IMPATT = V_IMPATT + (PRE_IMP_D - PRE_IMP_A)
         ENDIF
      ENDIF
   ELSE
      =MESSAGEBOX('Il conto : '+V_CONTO+' non risulta presente in archivi',62,'ATTENZIONE')
   ENDIF
   **=> ERASMO - FINE 22/03/2019

   x_soci = "bil_codsoc = '" + PUB_CODSOC + "'"
   x_cond = x_soci
   X_RIG = PADL(ALLTRIM(V_CODRIG),10," ")
   VV=V_CODRIG


*!*		ATTRIBUISCE IL CODICE RIGA AVERE IN ALTERNATIVA SE DIGITATO

   IF V_IMPATT >= 0
      x_codi = "bil_codrig = '" + PADL(ALLTRIM(V_CODRIG),10," ") + "'"
      x_cond = x_cond + " and " + x_codi
   ELSE
      IF !EMPTY(V_CODRIA)            && BANCHE IN PASSIVO
         x_codi = "bil_codrig = '" + PADL(ALLTRIM(V_CODRIA),10," ") + "'"
         x_cond = x_cond + " and " + x_codi
         VV=V_CODRIA
      ELSE
         x_codi = "bil_codrig = '" + PADL(ALLTRIM(V_CODRIG),10," ") + "'"
         x_cond = x_cond + " and " + x_codi
	     VV=V_CODRIG
      ENDIF
   ENDIF

 
   Csql   = "select * from BILANCIOR where " + x_cond + " order by bil_codsoc,bil_codrig"
   IF !ExecRW(Csql,"BILANCIOR","R")
 	  return(.f.)
   ENDIF
   SELECT BILANCIOR
   GO TOP
   IF EOF()
		   
		***Codice riga non presente in archivio
		
		MESSAGEBOX("Verificare la confluenza di "+ALLTRIM(V_CONTO)+" in bilancio RICLASSIFICATO in quanto non assegnata la riga di destinazione",48,"Confluenza definita in modo incompleto")
	
		SELECT U_BRI_TT
		SKIP
		LOOP
   ELSE 
      REPLACE CORRENTE WITH CORRENTE + V_IMPATT
   ENDIF
   
   IF !ExecRW("","BILANCIOR","W")
      return(.f.)
   ENDIF
   
   SELECT U_BRI_TT
   SKIP +1

ENDDO

WAIT WINDOW 'Operazione calcolo economici, attendere per favore...' TIMEOUT(3)

V_TOTALE = 0

Csql   = "select * from BILANCIOR order by bil_codsoc,bil_codrig"
IF !ExecRW(Csql,"BILANCIOR","R")
   return(.f.)
ENDIF
SELECT BILANCIOR
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   * PER SOLO RIGHE CONTI ECONOMICI FA ABS

   XRIGA=BIL_CODRIG
   IF VAL(XRIGA) <  21600    && SALTA LE RIGHE DEI CONTI NON ECONOMICI
      SKIP +1
      LOOP
   ENDIF


   REPLACE CORRENTE WITH ABS(CORRENTE)  && RENDE IL VALORE IN ASSOLUTO

   SELECT BILANCIOR
   SKIP +1

ENDDO

IF !ExecRW("","BILANCIOR","W")
   return(.f.)
ENDIF

WAIT WINDOW 'Operazione calcolo totali, attendere per favore...' TIMEOUT(3)

 
V_TOTALE = 0

x_soci = "cor_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci 
Csql   = "select * from RIGHE_BIL_RIC where " + x_cond + " order by cor_codsoc,cor_riga"
IF !ExecCommand(cSql,"RIGHE_BIL_RIC")
   return(.f.)
ENDIF
SELECT RIGHE_BIL_RIC
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   CONFLU = COR_CONFLU
   SEGNO  = COR_SEGNO
   RIGA   = COR_RIGA

   x_soci = "bil_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "bil_codrig = '" + PADL(ALLTRIM(RIGA),10," ") + "'"
   x_cond = x_soci + " and " + x_codi

   Csql   = "select * from BILANCIOR where " + x_cond + " order by bil_codsoc,bil_codrig"
   IF !ExecRW(Csql,"BILANCIOR","R")
 	  return(.f.)
   ENDIF
   
   
   SELECT BILANCIOR
   GO TOP
   
   IF EOF()
   ELSE         && VADO SU BILANCIOR E PRENDO IL VALORE CORRENTE DI QUESTA RIGA
      IF SEGNO='+'
         V_TOTALE=V_TOTALE+CORRENTE
      ELSE
         V_TOTALE=V_TOTALE-CORRENTE
      ENDIF
   ENDIF

   x_soci = "bil_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "bil_codrig = '" + PADL(ALLTRIM(CONFLU),10," ") + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from BILANCIOR where " + x_cond + " order by bil_codsoc,bil_codrig"
   IF !ExecRW(Csql,"BILANCIOR","R")
 	  return(.f.)
   ENDIF
   SELECT BILANCIOR
   GO TOP
   IF EOF()
      =MESSAGEBOX("Non trovata la riga di confluenza, aggiornamento annullato"+CONFLU,62,"ATTENZIONE")
      RETURN
   ELSE 
      REPLACE CORRENTE WITH CORRENTE+V_TOTALE
      V_TOTALE=0
   ENDIF
   IF !ExecRW("","BILANCIOR","W")
      return(.f.)
   ENDIF

   SELECT RIGHE_BIL_RIC
   SKIP +1

ENDDO

MESSAGEBOX('Operazione conclusa, Buon lavoro...',64,"Calcolo bilancio RICLASSIFICATO")
