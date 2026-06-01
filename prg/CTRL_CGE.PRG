RIT = MESSAGEBOX("Procedo con il controllo del numero di partita significativo"+CHR(13)+"riassegnando lo stesso in caso di mancanza ?",292,"ATTENZIONE")

IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

***======> Controllo sul partitario dei clienti
IF !ExecCommand("select * from part_cli where 0=1","part_cli")
   return(.f.)
ENDIF
SELECT PART_CLI
HH=AFIELDS(TRANSITO)
CREATE CURSOR C_PARTI FROM ARRAY TRANSITO
INDEX ON PAR_NUMPRO + STR(PAR_NPROG,5,0) TAG SEQUEN ADDITIVE 
DO LOOP_PART WITH "PART_CLI"

***======> Controllo sul partitario dei fornitori
IF !ExecCommand("select * from part_for where 0=1","part_for")
   return(.f.)
ENDIF
SELECT PART_FOR
HH=AFIELDS(TRANSITO)
CREATE CURSOR C_PARTI FROM ARRAY TRANSITO
INDEX ON PAR_NUMPRO + STR(PAR_NPROG,5,0) TAG SEQUEN ADDITIVE 
DO LOOP_PART WITH "PART_FOR"

RETURN

*******************
PROCEDURE LOOP_PART
*******************

PARAMETERS _ARCH

IF _ARCH = 'PART_CLI'
   cSql = "select * from part_cli order by par_codsoc,par_anno,par_numpro"
   IF !ExecRW(cSql,"PART_CLI","R")
      RETURN .F.
   ENDIF
ELSE
   cSql = "select * from part_for order by par_codsoc,par_anno,par_numpro"
   IF !ExecRW(cSql,"PART_FOR","R")
      RETURN .F.
   ENDIF
ENDIF

SELECT &_ARCH
GO TOP

*=> Variabile che mi serve per verificare la rottura della partita in elaborazione
RELEASE V_NUMPRO,V_RIASS
PUBLIC  V_NUMPRO,V_RIASS
V_NUMPRO = PAR_NUMPRO
V_RIASS  = .F.

DO WHILE .T.

   IF EOF()
      DO CONTROLLA WITH _ARCH,V_RIASS
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   *=> Verifico la rottura della partita
   IF PAR_NUMPRO = V_NUMPRO
   ELSE
      DO CONTROLLA WITH _ARCH,V_RIASS
      SELECT C_PARTI
      ZAP
      SELECT &_ARCH
      V_NUMPRO = PAR_NUMPRO
      V_RIASS  = .F.
      LOOP
   ENDIF
      
   SCATTER MEMVAR MEMO
   
   *=> Attivazione flag di esistenza numero partita non significativa
   IF PAR_NPART = 0
      V_RIASS = .T.
   ENDIF
   
   SELECT C_PARTI
   APPEND BLANK
   GATHER MEMVAR MEMO
   
   SELECT &_ARCH
   SKIP +1   
   
ENDDO

IF _ARCH = 'PART_CLI'
   IF !ExecRW(cSql,"PART_CLI","W")
      RETURN .F.
   ENDIF
ELSE
   IF !ExecRW(cSql,"PART_FOR","W")
      RETURN .F.
   ENDIF
ENDIF

RETURN


*******************
PROCEDURE CONTROLLA
*******************

PARAMETERS _ARCHI,_RIASS

*=> Se tutti i movimenti del partitario, hanno un numero di partita significativo, 
*=> allora è a posto
IF _RIASS
ELSE
   RETURN
ENDIF

SELECT C_PARTI
SET ORDER TO SEQUEN
GO TOP
IF EOF()
   RETURN
ENDIF

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   XXX_NPART = 0

   *=> Se partitario fornitori, il numero di partita deve essere ricercato sul parametro NUMPRC
   *=> se partitario clienti, il numero di partita deve essere il numero di fattura o in mancanza,
   *=> ricercato sul parametro NUMPRC come per il fornitore. 

   V_CERCA = .T.

   IF _ARCHI = 'PART_CLI'
      IF PAR_NUMFAT = SPACE(06) .OR. EMPTY(PAR_NUMFAT)
      ELSE
         XXX_NPART = VAL(PAR_NUMFAT)
         V_CERCA = .F.
      ENDIF
   ENDIF

   IF V_CERCA 
      V_SEEK = 'NUMPRC' + PUB_CODSOC
      x_cond = "codice = '" + V_SEEK + "'"
      cSql = "select * from para where " + x_cond + " order by codice"
      IF !ExecRW(cSql,"PARA","R")
         RETURN .F.
      ENDIF
      SELECT PARA
      GO TOP
      IF EOF()
         V_LIB1	   = 1
         CS_LIB1   = STR(V_LIB1)
         XXX_NPART = VAL(CS_LIB1)
         APPEND BLANK
         REPLACE CODICE WITH 'NUMPRC'+PUB_CODSOC
         REPLACE DESCRI WITH "N.PARTITA FORNITORE"
         REPLACE LIBERA WITH ALLTRIM(CS_LIB1)
      ELSE
         C_LIB1	   = SUBSTR(LIBERA,1,10)
         V_LIB1    = VAL(C_LIB1)
         V_LIB1    = V_LIB1+1
         CS_LIB1   = STR(V_LIB1)
         XXX_NPART = VAL(CS_LIB1)
         REPLACE LIBERA  WITH ALLTRIM(CS_LIB1)
      ENDIF
      IF !ExecRW(cSql,"PARA","W")
         RETURN .F.
      ENDIF
   ENDIF
   
   EXIT

ENDDO

*=> Riposizionamento per aggiornamento numero partita trovata
SELECT &_ARCHI

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF _ARCHI = 'PART_CLI'
      IF PAR_CODSOC = M.PAR_CODSOC
      ELSE
         SKIP +1
         LOOP
      ENDIF
      IF PAR_ANNO = M.PAR_ANNO
         ELSE
         SKIP +1
         LOOP
      ENDIF
      IF PAR_NUMPRO = M.PAR_NUMPRO
      ELSE
         SKIP +1
         LOOP
      ENDIF
   ELSE
      IF PAR_NUMPRO = M.PAR_NUMPRO
      ELSE
         SKIP +1
         LOOP
      ENDIF
   ENDIF

   IF PAR_NUMPRO = M.PAR_NUMPRO
   ELSE
      EXIT
   ENDIF
 
   REPLACE PAR_NPART WITH XXX_NPART

   SKIP +1
 
ENDDO

x_soci = "mov_soc = '" + M.PAR_CODSOC + "'"
x_anno = "mov_anno = '" + M.PAR_ANNO + "'"
x_nume = "mov_numpro = '" + M.PAR_NUMPRO + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_nume
cSql = "select * from indice where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecRW(cSql,"INDICE","R")
   RETURN .F.
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
    
   REPLACE MOV_NPART WITH XXX_NPART

   SKIP +1
   
ENDDO

IF !ExecRW(cSql,"INDICE","W")
   RETURN .F.
ENDIF

x_soci = "mov_soc = '" + M.PAR_CODSOC + "'"
x_anno = "mov_anno = '" + M.PAR_ANNO + "'"
x_nume = "mov_numpro = '" + M.PAR_NUMPRO + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_nume
cSql = "select * from mov_cont where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecRW(cSql,"MOV_CONT","R")
   RETURN .F.
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
   
   REPLACE MOV_NPART WITH XXX_NPART

   SKIP +1
   
ENDDO

IF !ExecRW(cSql,"MOV_CONT","W")
   RETURN .F.
ENDIF

RETURN