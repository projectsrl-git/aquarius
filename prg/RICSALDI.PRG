PARA _MESE_ARRIVO

IF EMPTY(_MESE_ARRIVO)
   _MESE_ARRIVO=12
ELSE
   _MESE_ARRIVO=_MESE_ARRIVO
ENDIF

RELEASE QU,F_CHIUSURA,F_CHIMAN,MESE,XMESE
PUBLIC  QU,F_CHIUSURA,F_CHIMAN,MESE,XMESE
QU         = 0
F_CHIUSURA = .F.
F_CHIMAN   = .F.
MESE       = 1
XMESE      = "01"

DO FORM FORM\ATTENDI LINKED

FOR H=1 TO _MESE_ARRIVO
    XMESE=ALLTRIM(STR(H))
    DO RICALCOLA_MESE
NEXT

DEACTIVATE WINDOW ATTENDI
RELEASE WINDOWS ATTENDI
RELEASE QU,F_CHIUSURA,F_CHIMAN,MESE,XMESE

RETURN


******************************************
PROCEDURE RICALCOLA_MESE
******************************************

*** AZZERAMENTO CONTI

WAIT WINDOW "STO AZZERANDO I SALDI"  NOWAIT

MESE = VAL(XMESE)

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"CONTI","R")
   return(.f.)
ENDIF
SELECT CONTI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF MESE = 1
	  REPLACE CON_DA01 WITH 0
	  REPLACE CON_AV01 WITH 0
   ENDIF
  
   IF MESE = 2
	  REPLACE CON_DA02 WITH 0
	  REPLACE CON_AV02 WITH 0
   ENDIF

   IF MESE = 3
	  REPLACE CON_DA03 WITH 0
	  REPLACE CON_AV03 WITH 0
   ENDIF
  
   IF MESE = 4
	  REPLACE CON_DA04 WITH 0
	  REPLACE CON_AV04 WITH 0 
   ENDIF
  
   IF MESE = 5
	  REPLACE CON_DA05 WITH 0
	  REPLACE CON_AV05 WITH 0
   ENDIF
  
   IF MESE = 6
	  REPLACE CON_DA06 WITH 0
	  REPLACE CON_AV06 WITH 0
   ENDIF
  
   IF MESE = 7
	  REPLACE CON_DA07 WITH 0
	  REPLACE CON_AV07 WITH 0
   ENDIF
  
   IF MESE = 8
	  REPLACE CON_DA08 WITH 0
	  REPLACE CON_AV08 WITH 0
   ENDIF
  
   IF MESE = 9
	  REPLACE CON_DA09 WITH 0
	  REPLACE CON_AV09 WITH 0
   ENDIF
  
   IF MESE = 10
  	  REPLACE CON_DA10 WITH 0
	  REPLACE CON_AV10 WITH 0
   ENDIF
  
   IF MESE = 11
  	  REPLACE CON_DA11 WITH 0
	  REPLACE CON_AV11 WITH 0
   ENDIF
  
   IF MESE = 12
	  REPLACE CON_DA12 WITH 0
	  REPLACE CON_AV12 WITH 0
   ENDIF
	
   SKIP +1

ENDDO  

IF !ExecRW(cSql,"CONTI","W")
   return(.f.)
ENDIF

WAIT WINDOW "STO AGGIORNANDO  I SALDI"  NOWAIT

**** ELABORO INDICE PER CACOLARE DARE / AVERE VALORIZZATI AL CAMBIO DELLA SINGOLA REGISTRAZIONE

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
cSql="SELECT * FROM INDICE WHERE " + x_cond + " order by mov_soc,mov_anno,mov_dtreg"
IF !ExecCommand(cSql,"INDICE")
   return(.f.)
ENDIF
SELECT INDICE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
 
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   IF VAL(SUBSTR(MOV_DTREG,6,2)) <> VAL(XMESE)    && TRATTA SOLO IL MESE DIGITATO
      SKIP +1
      LOOP
   ENDIF

   IF MOV_TOP = "CHI"
	  IF !F_CHIUSURA 		&& NON TRATTA I MOVIMENTI DI CHIUSURA
 	     SKIP +1
	     LOOP
	  ENDIF	
   ENDIF
     
   M.MOV_NUMPRO=MOV_NUMPRO

   _DARE = 0
   _AVERE= 0
   =VQUADRA(M.MOV_NUMPRO)

   WAIT WINDOWS "Registrazione con numero interno (NUMPRO) :"+ M.MOV_NUMPRO NOWAIT
  _DIFDA = _DARE-_AVERE

  =RICALCOLA(.F.,.F.,ABS(_DIFDA))
  
  SELECT INDICE
  SKIP +1
  
ENDDO

IF F_CHIMAN
   =ELABORA_CHI_MAN()  	
ENDIF

WAIT WINDOW "Stò ricalcolando il saldo totale "  TIMEOUT 2   

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"CONTI","R")
   return(.f.)
ENDIF
SELECT CONTI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   TDARE  =  CON_DA01 + CON_DA02 + CON_DA03 + CON_DA04 + CON_DA05 + CON_DA06 + CON_DA07 + CON_DA08 + CON_DA09 + CON_DA10 + CON_DA11 + CON_DA12
   TAVERE =  CON_AV01 + CON_AV02 + CON_AV03 + CON_AV04 + CON_AV05 + CON_AV06 + CON_AV07 + CON_AV08 + CON_AV09 + CON_AV10 +	CON_AV11 + CON_AV12
	
   REPLACE CON_IMP_D WITH TDARE
   REPLACE CON_IMP_A WITH TAVERE

   SKIP +1

ENDDO  

IF !ExecRW(cSql,"CONTI","W")
   return(.f.)
ENDIF

RETURN


**********************************
FUNCTION RICALCOLA
**********************************
PARA AGG_D,AGG_A,DIFLIRA

SELECT WW_TEMPO
GO TOP
QU = 0

DO WHILE !EOF()

   *** AGGIORNO IL DATABASES CONTI
   DA  = 0
   AV  = 0

   IF MOV_TMOV  = "D" .OR. MOV_TMOV  = "A"
   ELSE
	  WAIT WINDOW "Registrazione senza D/A"+STR(MOV_NREGIS,10,0)+"<<<<<<<<<<<<"
	  SELECT WW_TEMPO
	  SKIP +1
	  LOOP
   ENDIF

   IF MOV_TMOV  = "D"
      IF AGG_D
         * SOMMO AL DARE 1 LIRA FINO AD ESAURIRE LA DIFFERENZA
         DA =   CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)+IIF(DIFLIRA<>0,1,0)
         DIFLIRA=IIF(DIFLIRA<>0,DIFLIRA-1,DIFLIRA) && SCALA LA DIFFERENZA
      ELSE
         DA =   CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO,(MOV_SOC+MOV_ANNO+MOV_CONTO))
      ENDIF
   ENDIF
     
   IF MOV_TMOV  = "A"
      IF AGG_A
         * SOMMO AD AVERE 1 LIRA FINO AD ESAURIRE LA DIFFERENZA
         AV =   CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO)+IIF(DIFLIRA<>0,1,0)
         DIFLIRA=IIF(DIFLIRA<>0,DIFLIRA-1,DIFLIRA) && SCALA LA DIFFERENZA
      ELSE
         AV =   CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO,(MOV_SOC+MOV_ANNO+MOV_CONTO))
      ENDIF
   ENDIF

   XCONTO  = MOV_CONTO 
   DATAREG = MOV_DTREG    

   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + PUB_ANNO + "'"
   x_cont = "con_conto = '" + ALLTRIM(XCONTO) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      return(.f.)
   ENDIF
   SELECT CONTI
   GO TOP
   IF !EOF()
      MESE     = SUBSTR(DATAREG,6,2)
      D_ARE    = "CON_DA"+MESE
      A_VERE   = "CON_AV"+MESE
      P_IMPD	= CON_IMP_D
      P_IMPA	= CON_IMP_A
      IF DA <> 0
         REPLACE &D_ARE      WITH &D_ARE+DA   && SINGOLO MESE
	  ENDIF
      IF AV <> 0
         REPLACE &A_VERE     WITH &A_VERE+AV  && SINGOLO MESE
	  ENDIF	 
   ELSE
      WAIT WINDOW "Conto inesistente :"+XCONTO  
   ENDIF 
   IF !ExecRW(cSql,"CONTI","W")
      return(.f.)
   ENDIF

   QU=QU+1
  
   ***** WAIT WINDOW "MOVIMENTI ELABORATI "+STR(QU,10,0) NOWAIT
  
   SELECT WW_TEMPO
   SKIP +1
  
ENDDO

RETURN(.T.)


**********************************
FUNCTION ELABORA_CHI_MAN
**********************************
RETURN(.T.)


**********************************
FUNCTION VQUADRA
**********************************
PARA _NUMPRO

IF !ExecCommand("select * from mov_cont where 0=1","mov_cont")
   return(.f.)
ENDIF
SELECT MOV_CONT
AA=AFIELDS(ASD)
CREATE CURSOR WW_TEMPO FROM ARRAY ASD

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + PUB_ANNO + "'"
x_nume = "mov_numpro = '" + ALLTRIM(_NUMPRO) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_nume
cSql="SELECT * FROM MOV_CONT WHERE " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecCommand(cSql,"MOV_CONT")
   return(.f.)
ENDIF
SELECT MOV_CONT
GO TOP
IF !EOF()
   DO WHILE !EOF()
      IF DELETED()
         SKIP +1
         LOOP
      ENDIF
  	  _TMOV     = MOV_TMOV
	  _TOP      = MOV_TOP
	  _IMP      = MOV_IMP
	  _CAMBIO   = MOV_CAMBIO
	  _CODVAL   = MOV_VALUTA
	  _SOC	    = MOV_SOC
	  _ANNO	    = MOV_ANNO
	  _CONTO	= MOV_CONTO
  	  _VALORE   = CAMBIO(_CODVAL,_IMP,_CAMBIO,(_SOC+_ANNO+_CONTO))
	  IF SUBSTR(_TMOV,1,1)='A'
	     _AVERE = _AVERE + _VALORE
	  ENDIF
      IF SUBSTR(_TMOV,1,1)='D'
	     _DARE  = _DARE + _VALORE
	  ENDIF
      SELECT MOV_CONT
      SCATTER MEMVAR  && MEMO
      SELECT WW_TEMPO
      APPEND BLANK
      GATHER MEMVAR && MEMO
      SELECT MOV_CONT
      SKIP +1
   ENDDO
ELSE
   WAIT WINDOW "Non trovato il numero interno di legame INDICE - MOV_CONT "+_NUMPRO
ENDIF    

RETURN(.T.)


