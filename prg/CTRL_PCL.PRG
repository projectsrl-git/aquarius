RIT = MESSAGEBOX("Procedo con il controllo dei partitari"+CHR(13)+"ricostruendo il record 100/200 mancante ?",292,"ATTENZIONE")

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
V_NUMPRO = PAR_NUMPRO

*=> Flag che mi indicheranno quale progressivo mi manca nel partitario
V_100    = .F.
V_200    = .F.
V_300    = .F.
V_400    = .F.
V_500    = .F.
V_600    = .F.
V_700    = .F.
V_800    = .F.
V_900    = .F.

DO WHILE .T.

   IF EOF()
      DO CONTROLLA WITH _ARCH
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   *=> Verifico la rottura della partita
   IF PAR_NUMPRO = V_NUMPRO
   ELSE
      DO CONTROLLA WITH _ARCH
      *=> Riposizionamento per leggere la partita successiva
      SELECT C_PARTI
      ZAP
      SELECT &_ARCH
      IF _ARCH = 'PART_CLI'
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
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF PAR_NUMPRO = M.PAR_NUMPRO
         ELSE
            EXIT
         ENDIF
         SKIP +1
      ENDDO
      V_NUMPRO = PAR_NUMPRO
      V_100    = .F.
      V_200    = .F.
      V_300    = .F.
      V_400    = .F.
      V_500    = .F.
      V_600    = .F.
      V_700    = .F.
      V_800    = .F.
      V_900    = .F.
      LOOP
   ENDIF
      
   SCATTER MEMVAR MEMO

   *=> Attivazione flag di esistenza numero prograssivo
   IF PAR_NPROG = 100
      V_100 = .T.
   ENDIF
   IF PAR_NPROG = 200
      V_200 = .T.
   ENDIF
   IF PAR_NPROG = 300
      V_300 = .T.
   ENDIF
   IF PAR_NPROG = 400
      V_400 = .T.
   ENDIF
   IF PAR_NPROG = 500
      V_500 = .T.
   ENDIF
   IF PAR_NPROG = 600
      V_600 = .T.
   ENDIF
   IF PAR_NPROG = 700
      V_700 = .T.
   ENDIF
   IF PAR_NPROG = 800
      V_800 = .T.
   ENDIF
   IF PAR_NPROG = 900
      V_900 = .T.
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

PARAMETERS _ARCHI

*=> Se esiste sia il record 100 che il 200, si presuppone che la partita sia apposto
*IF V_100 AND V_200
*   RETURN
*ENDIF

*=> Azzeramento variabile per determinare il totale della partita
V_FATT100 = 0
V_FATT200 = 0
 
SELECT C_PARTI
SET ORDER TO SEQUEN
GO TOP
IF EOF()
   RETURN
ENDIF

SCATTER MEMVAR MEMO

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF PAR_NPROG = 100
      V_FATT100  = V_FATT100  + PAR_FATT
   ELSE
      V_FATT200  = V_FATT200  + PAR_FATT
   ENDIF
   
   SELECT C_PARTI
   SKIP +1
   
ENDDO

*=> Se il totale della partita record 100 è uguale alla sommatoria degli altri record
*=> significa che è tutto a posto
IF V_FATT100 = V_FATT200
   RETURN
ENDIF

*=> Generazione del record 100/200
IF !V_100
   SELECT &_ARCHI
   APPEND BLANK
   GATHER MEMVAR MEMO
   REPLACE PAR_NPROG  WITH 100
   REPLACE PAR_FATT   WITH V_FATT200
   REPLACE PAR_TIMPOS WITH PAR_IMPOS1 + PAR_IMPOS2 + PAR_IMPOS3 + PAR_IMPOS4 + PAR_IMPOS5
   REPLACE PAR_TOTIM  WITH PAR_FATT - PAR_TIMPOS
   REPLACE PAR_IMPVAL WITH PAR_FATT 
ELSE
   SELECT &_ARCHI
   APPEND BLANK
   GATHER MEMVAR MEMO
   IF !V_200
      REPLACE PAR_NPROG  WITH 200
   ELSE
      IF !V_300
         REPLACE PAR_NPROG  WITH 300
      ELSE
         IF !V_400
            REPLACE PAR_NPROG  WITH 400
         ELSE
            IF !V_500
               REPLACE PAR_NPROG  WITH 500
            ELSE
               IF !V_600
                  REPLACE PAR_NPROG  WITH 600
               ELSE
                  IF !V_700
                     REPLACE PAR_NPROG  WITH 700
                  ELSE
                     IF !V_800
                        REPLACE PAR_NPROG  WITH 800
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   REPLACE PAR_FATT   WITH V_FATT100 - V_FATT200
   REPLACE PAR_TIMPOS WITH 0
   REPLACE PAR_TOTIM  WITH 0
   REPLACE PAR_IMPVAL WITH PAR_FATT 
ENDIF

RETURN