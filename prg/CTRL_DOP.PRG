RIT = MESSAGEBOX("Procedo con il controllo dei partitari"+CHR(13)+;
                 "stampando le partite con più di un cliente/fornitore ?",292,"ATTENZIONE")

IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

***======> Creazione cursore per stampa doppioni
IF !ExecCommand("select * from part_for where 0=1","part_for")
   return(.f.)
ENDIF
SELECT PART_FOR
HH=AFIELDS(TRANSITO)
CREATE CURSOR C_STAMPA FROM ARRAY TRANSITO
INDEX ON PAR_CODSOC + PAR_ANNO + STR(PAR_NPART,10,0) TAG I_STAMPA ADDITIVE 

***======> Controllo sul partitario dei clienti
IF !ExecCommand("select * from part_cli where 0=1","part_cli")
   return(.f.)
ENDIF
SELECT PART_CLI
HH=AFIELDS(TRANSITO)
CREATE CURSOR C_PARTI FROM ARRAY TRANSITO
INDEX ON PAR_CODSOC + PAR_ANNO + STR(PAR_NPART,10,0) + PAR_CODCLI TAG SEQUEN ADDITIVE 
CREATE CURSOR C_STAMPA FROM ARRAY TRANSITO
INDEX ON PAR_CODSOC + PAR_ANNO + STR(PAR_NPART,10,0) TAG I_STAMPA ADDITIVE 
DO LOOP_PART WITH "PART_CLI","CL"

***======> Controllo sul partitario dei fornitori
IF !ExecCommand("select * from part_for where 0=1","part_for")
   return(.f.)
ENDIF
SELECT PART_FOR
HH=AFIELDS(TRANSITO)
CREATE CURSOR C_PARTI FROM ARRAY TRANSITO
INDEX ON PAR_CODSOC + PAR_ANNO + STR(PAR_NPART,10,0) + PAR_CODCLI TAG SEQUEN ADDITIVE 
DO LOOP_PART WITH "PART_FOR","FO"

***======> Stampa dei doppioni

SELECT C_STAMPA
SET ORDER TO I_STAMPA
GO TOP
IF EOF()
   =MESSAGEB("Nessuna partita con doppio codice cliente/fornitore",64,"*** ATTENZIONE ***")
ELSE
   DO PRG\MENUSTA WITH "C_STAMPA",.T.,.T.,"XXX","CTRL_DOP","CTRL_DOP.FRX"
ENDIF

RETURN


*******************
PROCEDURE LOOP_PART
*******************

PARAMETERS _ARCH,_TIPO

IF _ARCH = 'PART_CLI'
   cSql = "select * from part_cli order by par_codsoc,par_anno,STR(par_npart,10,0),STR(par_nprog,5,0)"
   IF !ExecCommand(cSql,"PART_CLI")
      RETURN .F.
   ENDIF
ELSE
   cSql = "select * from part_for order by par_codsoc,par_anno,STR(par_npart,10,0),STR(par_nprog,5,0)"
   IF !ExecCommand(cSql,"PART_FOR")
      RETURN .F.
   ENDIF
ENDIF

SELECT &_ARCH
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

   SELECT C_PARTI
   SET ORDER TO SEQUEN
   SEEK _TIPO + M.PAR_ANNO + STR(M.PAR_NPART,10,0) + M.PAR_CODCLI 
   
   IF FOUND()
   ELSE
      APPEND BLANK
      GATHER MEMVAR MEMO
      REPLACE PAR_CODSOC WITH _TIPO
   ENDIF
   
   SELECT &_ARCH
   SKIP +1
   
ENDDO

SELECT C_PARTI
SET ORDER TO SEQUEN
GO TOP

SCATTER MEMVAR MEMO

V_NPART = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF PAR_NPART = V_NPART
   ELSE
      V_NPART = PAR_NPART
      SCATTER MEMVAR MEMO
      SKIP +1
      LOOP
   ENDIF
   
   SELECT C_STAMPA
   APPEND BLANK
   GATHER MEMVAR MEMO
   
   SELECT C_PARTI
   SCATTER MEMVAR MEMO

   SELECT C_STAMPA
   APPEND BLANK
   GATHER MEMVAR MEMO

   SELECT C_PARTI
   SKIP +1      

ENDDO

RETURN