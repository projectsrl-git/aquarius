**********************************************************************************************
* 			 CREAZIONE ARCHIVIO CESSIONI INTRACOMUNITARIE SUGLI ACQUISTI	   				 *
*																			 				 *
**********************************************************************************************

RELEASE _DESCRIZIONE_ANOMALIE,ESISTONO_ERRORI,___NUMPRO
PUBLIC  _DESCRIZIONE_ANOMALIE,ESISTONO_ERRORI,___NUMPRO
_DESCRIZIONE_ANOMALIE = "ACQUISTI"
ESISTONO_ERRORI = .F.
___NUMPRO = SPACE(10)

RELEASE PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,V_PESO,PERDAL,PERAL,OK_INS,CTRELAB
PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,V_PESO,PERDAL,PERAL,OK_INS,CTRELAB

XDESF    = "REGISTRAZIONE AUTOMATICA"
COMPENSO = 0
TIVA     = 0
CIVA     = 0
TOP_TOP  = SPACE(03)
V_PESO   = 0
V_CLDOG  = "68101939???     "
PERDAL   = RIBALTA2(DATADAL)
PERAL    = RIBALTA2(DATAAL)
OK_INS   = .F.
CTRELAB  = 0



PUBLIC M.TAGGANCIO
M.TAGGANCIO = ""

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

CREATE CURSOR W_ERR (W_CODFOR  C(13),    ;
					 W_DESERR  C(50))
SELECT W_ERR 
INDEX ON W_CODFOR  TAG DETTA



CREATE CURSOR W_FAT (W_IVACEE  C(20),    ;
					 W_CLDOG   C(16),    ;
					 W_RIGA    N(05),    ;
					 W_NATURA  C(01),    ;
					 W_PERI    C(07),    ;
                     W_IMPONI  N(17,3),  ;
                     W_IMPVAL  N(17,3),  ;
                     W_MANETT  N(17,0),  ;
                     W_QTA     N(17,0),  ;
                     W_VALSTA  N(17,0),  ;
                     W_PUBBLI  N(17,0),  ;
                     W_CONDCO  C(01),    ;
                     W_MODTRA  C(01),    ;
                     W_PAEDES  C(02),    ;
                     W_VALUTA  C(03),    ;
                     W_PAEORI  C(02),    ;
                     W_PAEPRO  C(02))

SELECT W_FAT
INDEX ON W_IVACEE + W_CLDOG + W_CONDCO + W_MODTRA + W_PAEDES + W_PAEORI + W_PAEPRO TAG DETTA
SET ORDER TO DETTA

*--> CANCELLA LA CESSIONE VECCHIA

DO CEIFDELE

*--> PRELEVA I DATI AZIENDALI

x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
IF !ExecCommand(cSql,"u_azi_an")
   return(.f.)
ENDIF
SELECT u_azi_an
GO TOP
IF !EOF()
    M.ORD_CODCLI	= AZI_CODCLI
    M.ORD_RAGSOC	= AZI_RAGSOC
	M.ORD_INDIRI	= AZI_INDIRI
	M.ORD_CAP		= AZI_CAP
	M.ORD_LOCALI	= AZI_LOCALI
	M.ORD_PARIVA	= AZI_PIVA
	V_CONDCO    	= AZI_CONDCO
	_MODTRA      	= AZI_MODTRA
	V_PAEORI    	= AZI_PAEORI
	V_NATURA    	= AZI_NATURA
	V_TELEFO        = AZI_TELEFO
ELSE
	M.ORD_CODCLI	= SPACE(10)
	M.ORD_RAGSOC	= SPACE(40)
	M.ORD_INDIRI	= SPACE(40)
	M.ORD_CAP		= SPACE(05)
	M.ORD_LOCALI	= SPACE(40)
	M.ORD_PARIVA	= SPACE(11)
	V_CONDCO    	= SPACE(01)
	_MODTRA     	= SPACE(01)
	V_PAEORI    	= SPACE(02)
	V_NATURA    	= SPACE(01)	
	V_TELEFO        = ""
    WAIT WINDOW "PER CORTESIA CODIFICA I DATI ANAGRAFICI PER BOLLATI CON APPOSITA PROCEDURA"
ENDIF


ANNODAL  = SUBSTR(DATADAL,7,4)
CT 	 	 = 0
CTRELAB	 = 0
V_TOTALE = 0
V_IVACEE = SPACE(20)

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + ANNODAL + "'"
x_data = "mov_dtreg >= '" + PERDAL + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_data
Csql   = "select * from mov_cont where " + x_cond + " order by mov_soc,mov_anno,mov_dtreg"
IF !ExecCommand(Csql,"MOV_CONT")
   return(.f.)
ENDIF
SELECT MOV_CONT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF MOV_DTREG > PERAL
      EXIT
   ENDIF




   XX_CONTO = MOV_CONTO
   XX_ANNO  = MOV_ANNO
   XX_NREGI = MOV_NREGIS
   
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + XX_ANNO + "'"
   x_cont = "con_conto = '" + XX_CONTO + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   Csql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecCommand(Csql,"CONTI")
      return(.f.)
   ENDIF
   SELECT CONTI
   GO TOP
   IF !EOF()
      IF con_tipoco = "I"
         SELECT MOV_CONT
         SKIP +1
         LOOP
      ENDIF 
   ELSE
	  =MESSAGEBOX("Registrazione non corretta "+XX_NREGI+CHR(13)+"manca il conto nel piano dei conti "+XX_CONTO,16,"*** ATTENZIONE ***")
      OK_INS = .F.
	  EXIT
   ENDIF

   SELECT MOV_CONT


 *  IF (MOV_IVA <> 'NO') .AND. (CAMBIO(MOV_VALUTA,MOV_IMPOST,MOV_CAMBIO) <> 0)  && SOLO IMPONIBILI FATTURE
   IF (MOV_IVA <> 'NO')  && SOLO IMPONIBILI FATTURE
   ELSE
      SELECT MOV_CONT
      SKIP +1
      LOOP
   ENDIF

   SELECT MOV_CONT
   _TOP=MOV_TOP

   v_seek	= 'TOP' + _TOP
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
	  _INTRA =SUBSTR(LIBERA,24,1)
   ELSE
	  _INTRA     =" "
   ENDIF

   IF _INTRA <> "S"
	  SELECT MOV_CONT
	  SKIP +1
	  LOOP
   ENDIF

   V_IVACEE = SPACE(20)
   SELECT MOV_CONT

   
   V_NPRO = MOV_NUMPRO
   V_CCON = MOV_CONTO


   * ACCEDE A INDICE PER PRELEVARE IL CODICE DEL FORNITORE E DI CONSEGUENZA IL CODICE IVA CEE
   x_soci = "mov_soc = '" + PUB_CODSOC + "'"
   x_anno = "mov_anno = '" + ANNODAL + "'"
   x_nump = "mov_numpro = '" + V_NPRO + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_nump
   Csql = "select * from indice where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
   IF !ExecCommand(Csql,"INDICE")
      return(.f.)
   ENDIF
   SELECT INDICE
   GO TOP
   IF !EOF()
      V_CCON   = MOV_CONTO			&& CARICA IL CODICE CONTO FORNITORE EFFETTIVO
      V_IVACEE = SPACE(20)
	  V_CODFOR = SUBSTR(V_CCON,PUB_SOTTOG,9)
      x_soci   = "for_codsoc = '" + PUB_CODSOC + "'"
      x_codi   = "for_codcli = '" + ALLTRIM(V_CODFOR) + "'"
      x_cond   = x_soci + " and " + x_codi
      Csql     = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
      IF !ExecCommand(cSql,"cur_fornitore")
         return(.f.)
      ENDIF
      SELECT cur_fornitore
      GO TOP
      IF !EOF()
 	     V_IVACEE  = FOR_IVACEE  && SI SALVA IVA CEE
         V_FLGINT  = FOR_FLGINT  && SI SALVA IL FLAG CHE INDICA SE DEVE GENERARE L'INTRASTAT X GLI ACQUISTI
      ELSE
 	     V_IVACEE  = ""
 	     V_FLGINT  = .F.
	  ENDIF
   ELSE
      WAIT WINDOWS "Attenzione INDICE non trovato su numpro "
      SELECT MOV_CONT
      SKIP +1
      LOOP
   ENDIF

   IF V_FLGINT
   ELSE
      SELECT MOV_CONT
      SKIP +1
      LOOP
   ENDIF

   SELECT INDICE
   ___NUMPRO = MOV_NUMPRO
   
   IF EMPTY(V_IVACEE)
      =CREACURSORERRORI(V_CCON,"Fornitore senza codice IVA CEE !!! ") 
   ENDIF

   SELECT MOV_CONT

   SCATTER MEMVAR MEMO	    && Salva i vecchi valori

   CTRELAB=CTRELAB+1
   =CONTATORE("Fatture Fornitori elaborate",CTRELAB)

   =CEI_VARI()
*!*	   =CEI_LEGA()

   OK_INS   = .T.

   SELECT MOV_CONT
   SKIP +1

ENDDO

IF OK_INS
   =CEI_CREAT()
   =CEI_CREAD()
ENDIF

RELEASE WINDOW DISPLAY

IF !ESISTONO_ERRORI
	IF OK_INS
		=MESSAGEBOX("Creazione archivio acquisti cee"+CHR(13)+"terminata correttamente",16,"*** ATTENZIONE ***")
	ELSE
		=MESSAGEBOX("Nessun movimento trattato "+CHR(13)+"relativo agli acquisti cee",16,"*** ATTENZIONE ***")
	ENDIF
ELSE
	=MESSAGEBOX("Creazione archivio acquisti cee"+CHR(13)+"NON terminata correttamente (ESISTONO ANOMALIE)",16,"*** ATTENZIONE ***")

	SELECT W_ERR
	GO TOP
	IF !EOF()   
	   DO PRG\MENUSTA WITH "W_ERR",.T.,.T.,"XXX","ERRINTRA","ERRINTRA.FRX"
	ENDIF
ENDIF

RELEASE WINDOW DISPLAY

RETURN


*************************
FUNCTION CEI_VARI			&& IMPOSTA VARIABILI
*************************

****DATI DI TESTATA DELLA SINGOLA FATTURA ****

V_PORTO  = M.MOV_PORTO
XDESF    = M.MOV_DESCR
XVALUTA  = M.MOV_VALUTA
XCAMBIO  = M.MOV_CAMBIO
VALFAT   = M.MOV_IMP
VALUTA   = M.MOV_VALUTA
VALORE   = CAMBIO(XVALUTA,VALFAT,XCAMBIO)
NUMF     = ALLTRIM(M.MOV_NDOC)
V_PESO   = OK_ARROT1(M.MOV_PESO,XVALUTA)
V_TISPE  = M.MOV_TISPE
TOP_TOP  = M.MOV_TOP                   && NOTE CREDITO

v_seek	 = 'TOP' + TOP_TOP
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   NOTAC  = SUBSTR(LIBERA,11,1)
   _INTRA = SUBSTR(LIBERA,24,1)
ELSE
   WAIT WINDOW "ERRORE MANCA PARAMETRO TOP :"+TOP_TOP
   TOP_TOP = "ACQ"
   NOTAC   = ' '
   _INTRA  = " "
ENDIF

v_seek	 = 'POR'+V_PORTO
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CONDCO = SUBSTR(LIBERA,1,1)
ELSE
   =CREACURSORERRORI(V_CCON,"Errore manca parametro porto: "+V_PORTO+"<<<<"+" Fattura n. :"+NUMF) 
   V_CONDCO = "E"
ENDIF

v_seek	 = 'TSI'+V_TISPE
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_MODTRA = SUBSTR(LIBERA,1,1)
ELSE
   =CREACURSORERRORI(V_CCON,"Errore manca parametro tipo spedizione: "+V_TISPE+"<<<<"+" Fattura n. :"+NUMF) 
   V_MODTRA = _MODTRA
ENDIF

SELECT MOV_CONT
IF NOTAC <> "S"            && FORZA TOP FATTURA DI ACQUISTO SE <> NOTA CREDITO
   **TOP_TOP = "ACQ"
ENDIF

IF V_PESO = 0
   =CREACURSORERRORI(V_CCON,"Correggere peso in fattura n. "+NUMF) 
ENDIF

CLDOG = MOV_CLDOG

IF EMPTY(CLDOG)
   =CREACURSORERRORI(V_CCON,"Correggere classe doganale in fattura n. "+NUMF) 
ENDIF	
	
V_TOTALE = V_TOTALE + VALORE

IF NOTAC  = "S"       && VERIFICA NOTA CREDITO
   VALORE = VALORE * -1
   VALFAT = VALFAT * -1
ENDIF

** CREA IL WORK FILE
	
SELECT W_FAT
SEEK V_IVACEE+CLDOG
IF FOUND()
   REPLACE W_IMPONI WITH W_IMPONI  + VALORE
   REPLACE W_IMPVAL WITH W_IMPVAL  + VALFAT
   REPLACE W_MANETT WITH W_MANETT  + V_PESO
ELSE
   APPEND BLANK
   REPLACE W_IVACEE WITH V_IVACEE
   REPLACE W_CLDOG  WITH CLDOG
   REPLACE W_PERI   WITH SUBSTR(XDATA,7,4)+"/"+SUBSTR(XDATA,4,2)
   REPLACE W_IMPONI WITH VALORE
   REPLACE W_IMPVAL WITH VALFAT
   REPLACE W_NATURA WITH V_NATURA
   REPLACE W_MANETT WITH V_PESO
   REPLACE W_VALUTA WITH VALUTA
   V_PESO = 0
   REPLACE W_VALSTA WITH 0
   REPLACE W_CONDCO WITH V_CONDCO
   REPLACE W_MODTRA WITH V_MODTRA
   REPLACE W_PAEDES WITH SUBSTR(V_IVACEE,1,2)
   REPLACE W_PAEORI WITH V_PAEORI
ENDIF

RETURN



*************************
FUNCTION CEI_LEGA			&& AGGANCIA GLI ARTICOLI DELLE DDT DI CARICO LEGATE ALLA FATTURA DI ACQUISTO
*************************

XVALUTA  = M.MOV_VALUTA
TOP_TOP  = M.MOV_TOP                   && NOTE CREDITO
V_CONDCO = "E"
V_MODTRA = "3"

v_seek	 = 'TOP' + TOP_TOP
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   NOTAC  = SUBSTR(LIBERA,11,1)
   _INTRA = SUBSTR(LIBERA,24,1)
ELSE
   WAIT WINDOW "ERRORE MANCA PARAMETRO TOP :"+TOP_TOP
   TOP_TOP = "ACQ"
   NOTAC   = ' '
   _INTRA  = " "
ENDIF

x_soci = "leg_codsoc = '" + PUB_CODSOC + "'"
x_npro = "leg_numpro = '" + ALLTRIM(___NUMPRO) + "'"
x_cond = x_soci + " and " + x_npro
cSql   = "SELECT * FROM U_BFO_LE WHERE " + x_cond + " order by leg_codsoc,leg_numpro,leg_sequen"
IF !ExecCommand(cSql,"cur_bfo_le")
   return(.f.)
ENDIF
         
SELECT CUR_BFO_LE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   x_cond = "daggancio = '" + LEG_AGGANC + "'"
   cSql   = "SELECT * FROM U_BFO_DD WHERE " + x_cond + " order by ord_codart"
   IF !ExecCommand(cSql,"cur_bfo_dd")
      return(.f.)
   ENDIF
        
   SELECT CUR_BFO_DD
   GO TOP

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF EMPTY(ORD_CODART)
         SKIP +1
         LOOP
      ENDIF

      IF NOTAC  = "S"       && VERIFICA NOTA CREDITO
         ___VALORE = ORD_VALORE * -1
         ___QTAORD = ORD_QTAORD * -1
      ELSE
         ___VALORE = ORD_VALORE
         ___QTAORD = ORD_QTAORD
      ENDIF
      
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + ALLTRIM(ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
      IF !ExecCommand(cSql,"cur_articoli")
         return(.f.)
      ENDIF
      SELECT cur_articoli
      GO TOP
      IF EOF()
         CLDOG    = SPACE(16)
         V_PAEPRO = SPACE(02)  
      ELSE
         CLDOG    = ART_CLDOG
         V_PAEPRO = ART_NAZMER
      ENDIF
      
      IF EMPTY(CLDOG)
         SELECT CUR_BFO_DD
         SKIP +1
         LOOP
      ENDIF

      IF EMPTY(V_PAEPRO)
         V_PAEPRO = SUBSTR(V_IVACEE,1,2)
      ENDIF
      
      SELECT W_FAT
      SEEK V_IVACEE + CLDOG + V_CONDCO + V_MODTRA + SUBSTR(V_IVACEE,1,2) + V_PAEORI + V_PAEPRO
      IF FOUND()
         REPLACE W_IMPONI WITH W_IMPONI  + ___VALORE
         REPLACE W_IMPVAL WITH W_IMPVAL  + ___VALORE
         REPLACE W_MANETT WITH W_MANETT  + ___QTAORD
      ELSE
         APPEND BLANK
         REPLACE W_IVACEE WITH V_IVACEE
         REPLACE W_CLDOG  WITH CLDOG
         REPLACE W_PERI   WITH SUBSTR(XDATA,7,4)+"/"+SUBSTR(XDATA,4,2)
         REPLACE W_IMPONI WITH ___VALORE
         REPLACE W_IMPVAL WITH ___VALORE
         REPLACE W_NATURA WITH '1'
         REPLACE W_MANETT WITH ___QTAORD
         REPLACE W_VALUTA WITH XVALUTA
         REPLACE W_VALSTA WITH 0
         REPLACE W_CONDCO WITH V_CONDCO
         REPLACE W_MODTRA WITH V_MODTRA
         REPLACE W_PAEDES WITH SUBSTR(V_IVACEE,1,2)
         REPLACE W_PAEORI WITH V_PAEORI
         REPLACE W_PAEPRO WITH V_PAEPRO
      ENDIF

      SELECT CUR_BFO_DD
      SKIP +1
      
   ENDDO
   
   SELECT CUR_BFO_LE
   SKIP +1
   
ENDDO

RETURN

*************************
FUNCTION CEI_CREAT			&& CREAZIONE ARCHIVIO TESTATE
*************************

*--> PRELEVA IL NUMERO DELLA CESSIONE

v_seek   = 'NUMCEA'+PUB_CODSOC
v_chiave = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
   V2=VAL(SUBSTR(LIBERA,1,7)) + 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   M.ORD_NUMORD = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
ELSE
   RIT = MSGBOX('Parametro numero CEA non trovato','ATTENZIONE',31)
   RETURN
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*==> Rino 26/03/2003
PUB_LNO      = 6
M.ORD_NUMORD = TRC(PUB_LNO,ALLTRIM(M.ORD_NUMORD))
M.ORD_ANNO   = PUB_ANNO
*==> Rino 26/03/2003

IF !ExecCommand("select * from u_cea_tt where 0=1","cu_cea_tt")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_cea_dd where 0=1","cu_cea_dd")
   return(.f.)
ENDIF

*--> CREA ARCHIVIO U_CEA_TT

M.TAGGANCIO		= STR(NEWPROG('NUMCEA'),10)
M.ORD_CODSOC 	= PUB_CODSOC
M.ORD_CAMBIO 	= 1
M.TNUMERO       = M.ORD_NUMORD
M.ORD_VALUTA	= PUB_VALRIF
M.ORD_DATORD	= RIBALTA2(XDATA)
M.ORD_VALORE	= V_TOTALE
M.ORD_CAUS		= "CEA"
M.ORD_TELEFO    = V_TELEFO
M.ID_UNIQUE     = ""

SELECT CU_CEA_TT
APPEND BLANK
GATHER MEMVAR MEMO

RETURN


*************************
FUNCTION CEI_CREAD			&& CREAZIONE ARCHIVIO DETTAGLI
*************************
* CREA ARCHIVIO U_CEA_DD

CTR_RIGA = 0
SELECT W_FAT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   CTR_RIGA = CTR_RIGA +1
   M.ORD_RIGA   = CTR_RIGA
   M.ORD_IVACEE = W_IVACEE
   M.ORD_VALORE = W_IMPONI
   M.ORD_IMPVAL = W_IMPVAL
   M.ORD_VALUTA = W_VALUTA
   M.ORD_NATURA = W_NATURA
   M.ORD_CLDOG  = W_CLDOG
   M.ORD_MANETT = W_MANETT
   M.ORD_QTA    = W_QTA
   M.ORD_VALSTA = W_VALSTA
   M.ORD_CONDCO = W_CONDCO
   M.ORD_MODTRA = W_MODTRA
   M.ORD_PAEDES = W_PAEDES
   M.ORD_PAEORI = W_PAEORI
   M.ORD_PAEPRO = W_PAEPRO
   SELECT CU_CEA_DD
   APPEND BLANK
   GATHER MEMVAR MEMO
   REPLACE DAGGANCIO	WITH   M.TAGGANCIO
   SELECT W_FAT
   SKIP +1
ENDDO

IF !ExecRW('','u_cea_tt','I','','CU_CEA_TT')
   return(.f.)
ENDIF
IF !ExecRW('','u_cea_dd','I','','CU_CEA_DD')
   return(.f.)
ENDIF

RETURN


*************
PROCEDURE CHK
*************
PUSH KEY CLEAR
IF SELEZIONE='=>'
   REPLACE SELEZIONE WITH ' '
ELSE
   REPLACE SELEZIONE WITH '=>'
ENDIF
POP KEY
KEYBOARD "{RIGHTARROW}+{LEFTARROW}"
RETURN


****************
FUNCTION VEDIART
****************
PARA FG

SELE=SELECT()

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(FG) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP
IF !EOF()
   IF EMPTY(ART_CLDOG)
      =CREACURSORERRORI(V_CCON,"Manca la classe doganale dell'articolo : "+FG+"forzo la classe : "+V_CLDOG)    
 	  RET=V_CLDOG
   ELSE
      RET=ART_CLDOG
   ENDIF
   IF ART_PESOUM = 0
      =CREACURSORERRORI(V_CCON,"Il peso dell'articolo "+FG+"è uguale a ZERO ")    
      V_PESO = 0
   ELSE
      V_PESO = ART_PESOUM
   ENDIF
ELSE
   RET=V_CLDOG
   =CREACURSORERRORI(V_CCON,"Manca la classe doganale dell'articolo : "+FG+"forzo la classe : "+V_CLDOG)    
ENDIF

SELECT U_FAT_DD

RETURN(RET)


*************************
FUNCTION CREACURSORERRORI			&& CREAZIONE CURSORE ERRORI RISCONTRATI
*************************
PARA _CODFOR,_MESSAGGIO

ESISTONO_ERRORI = .T.



SELECT W_ERR
APPEND BLANK
REPLACE W_CODFOR  WITH _CODFOR
REPLACE W_DESERR  WITH _MESSAGGIO



RETURN

