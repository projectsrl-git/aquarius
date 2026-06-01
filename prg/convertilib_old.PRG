*#############################################################################################################

		**********************************************************************************************
		***         PROJECT SRL - LIBRERIA DELLE CONVERSIONI		                               ***
		***                                                                                        ***
		**********************************************************************************************

*##############################################################################################################


*************************************************************************************************
PROCEDURE CONV_U_AST_AN       && CONVERTE LA TABELLA U_AST_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE SCHEDE TECNICHE											*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_AST_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_AST_AN SQL
WAIT WINDOWS "Cancellazione vecchie Schede Tecniche...  -  Prego Attendere" NOWAIT
cSql = "delete from U_AST_AN where 1=1"
IF !ExecCommand(cSql,"U_AST_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_AST_AN where 1=0"
IF !ExecCommand(cSql,"CU_AST_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_AST_AN where 1=0"
IF !ExecCommand(cSql,"CUR_AST_AN")
   return(.f.)
ENDIF
SELECT CUR_AST_AN
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_AST_AN
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Scheda tecnica " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   IF EMPTY(M.AST_CODMAG)
      M.AST_CODMAG = SPACE(06)
      M.AST_DESMAG = SPACE(50)
      M.AST_FILA_X = SPACE(05)
      M.AST_PIAN_X = SPACE(05)
      M.AST_UBIC_X = SPACE(05)
      M.AST_FILA_N = 0
      M.AST_PIAN_N = 0
      M.AST_UBIC_N = 0
   ELSE
      M.AST_DESMAG = 'MAG. MANPOWER ARCHIVIAZ.INDUSTRIALE'
      IF ALLTRIM(M.AST_CORSIA) = 'A'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 1
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'B'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 2
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'C'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 3
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'D'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 4
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'E'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 5
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'F'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 6
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'G'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 7
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'H'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 8
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'I'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 9
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'L'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 10
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'M'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 11
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'N'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 12
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'O'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 13
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'P'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 14
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'Q'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 15
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'R'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 16
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'S'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 17
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'T'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 18
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'U'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 19
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'V'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 20
      ENDIF
      IF ALLTRIM(M.AST_CORSIA) = 'Z'
         M.AST_FILA_X = ALLTRIM(M.AST_CORSIA)
         M.AST_FILA_N = 21
      ENDIF
      M.AST_PIAN_X = ALLTRIM(STR(M.AST_PIANO,2,0))
      M.AST_UBIC_X = ALLTRIM(STR(M.AST_FILA,2,0))
      M.AST_PIAN_N = M.AST_PIANO
      M.AST_UBIC_N = M.AST_FILA
   ENDIF

   M.AST_CDMGPR = SPACE(06)
   M.AST_DSMGPR = SPACE(50)
   M.AST_FIPR_X = SPACE(05)
   M.AST_PIPR_X = SPACE(05)
   M.AST_UBPR_X = SPACE(05)
   M.AST_FIPR_N = 0
   M.AST_PIPR_N = 0
   M.AST_UBPR_N = 0
   M.AST_DATMOV = SPACE(10)
   M.AST_ORAMOV = SPACE(08)
   M.AST_OPEMOV = SPACE(03)
   M.AST_FLGMOV = SPACE(01)

   SELECT CU_AST_AN
   APPEND BLANK
   DO U_AST_AN

   _V_CONTA = _V_CONTA + 1

   SELECT CUR_AST_AN
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio delle Schede tecniche sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_ast_an','I','','CU_AST_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_CAS_TT_DD       && CONVERTE LE TABELLE U_CAS_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE CARTELLE SANITARIE       								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_CAS_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_CAS_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_CAS_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Cartelle sanitarie...  -  Prego Attendere" NOWAIT
cSql = "delete from U_CAS_TT where 1=1"
IF !ExecCommand(cSql,"U_CAS_TT")
   return(.f.)
ENDIF
cSql = "delete from U_CAS_DD where 1=1"
IF !ExecCommand(cSql,"U_CAS_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMCAS'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMCAS'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_CAS_TT where 1=0"
IF !ExecCommand(cSql,"CU_CAS_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_CAS_DD where 1=0"
IF !ExecCommand(cSql,"CU_CAS_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_CAS_TT where 1=0"
IF !ExecCommand(cSql,"CUR_CAS_TT")
   return(.f.)
ENDIF
SELECT CUR_CAS_TT
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_CAS_DD where 1=0"
IF !ExecCommand(cSql,"CUR_CAS_DD")
   return(.f.)
ENDIF
SELECT CUR_CAS_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_CAS_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Cartella sanitaria " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO  = STR(NEWPROG('NUMCAS'),10)

   IF EMPTY(M.CAS_CODMAG)
      M.CAS_CODMAG = SPACE(06)
      M.CAS_DESMAG = SPACE(50)
      M.CAS_FILA_X = SPACE(05)
      M.CAS_PIAN_X = SPACE(05)
      M.CAS_UBIC_X = SPACE(05)
      M.CAS_FILA_N = 0
      M.CAS_PIAN_N = 0
      M.CAS_UBIC_N = 0
   ELSE
      M.CAS_DESMAG = 'MAG. MANPOWER ARCHIVIAZ.INDUSTRIALE'
      IF ALLTRIM(M.CAS_CORSIA) = 'A'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 1
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'B'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 2
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'C'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 3
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'D'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 4
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'E'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 5
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'F'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 6
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'G'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 7
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'H'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 8
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'I'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 9
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'L'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 10
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'M'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 11
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'N'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 12
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'O'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 13
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'P'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 14
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'Q'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 15
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'R'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 16
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'S'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 17
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'T'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 18
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'U'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 19
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'V'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 20
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'Z'
         M.CAS_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAS_FILA_N = 21
      ENDIF
      M.CAS_PIAN_X = ALLTRIM(STR(M.CAS_PIANO,2,0))
      M.CAS_UBIC_X = ALLTRIM(STR(M.CAS_FILA,2,0))
      M.CAS_PIAN_N = M.CAS_PIANO
      M.CAS_UBIC_N = M.CAS_FILA
   ENDIF

   M.CAS_CDMGPR = SPACE(06)
   M.CAS_DSMGPR = SPACE(50)
   M.CAS_FIPR_X = SPACE(05)
   M.CAS_PIPR_X = SPACE(05)
   M.CAS_UBPR_X = SPACE(05)
   M.CAS_FIPR_N = 0
   M.CAS_PIPR_N = 0
   M.CAS_UBPR_N = 0
   M.CAS_DATMOV = SPACE(10)
   M.CAS_ORAMOV = SPACE(08)
   M.CAS_OPEMOV = SPACE(03)
   M.CAS_FLGMOV = SPACE(01)

   SELECT CU_CAS_TT
   APPEND BLANK
   DO U_CAS_TT

   SELECT CUR_CAS_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_CAS_TT
      SKIP +1
      LOOP
   ENDIF

   V_SEQUEN = 0

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      V_SEQUEN     = V_SEQUEN + 10
      M.CAS_SEQUEN = V_SEQUEN

      M.DAGGANCIO  = M.TAGGANCIO
      M.CAD_CODSOC = M.CAS_CODSOC
      M.CAD_NUMSCA = M.CAS_NUMSCA
      M.CAD_DATSCA = M.CAS_DATSCA
      M.CAD_CODCLI = M.CAS_CODCLI
      M.CAD_RAGSOC = M.CAS_RAGSOC
      M.CAD_INDIRI = M.CAS_INDIRI
      M.CAD_LOCALI = M.CAS_LOCALI
      M.CAD_CAP    = M.CAS_CAP
      M.CAD_CODCCO = M.CAS_CODCCO
      M.CAD_DESCCO = M.CAS_DESCCO

   IF EMPTY(M.CAS_CODMAG)
      M.CAD_CODMAG = SPACE(06)
      M.CAD_DESMAG = SPACE(50)
      M.CAD_FILA_X = SPACE(05)
      M.CAD_PIAN_X = SPACE(05)
      M.CAD_UBIC_X = SPACE(05)
      M.CAD_FILA_N = 0
      M.CAD_PIAN_N = 0
      M.CAD_UBIC_N = 0
   ELSE
      M.CAD_CODMAG = M.CAS_CODMAG
      M.CAD_DESMAG = 'MAG. MANPOWER ARCHIVIAZ.INDUSTRIALE'
      IF ALLTRIM(M.CAS_CORSIA) = 'A'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 1
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'B'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 2
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'C'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 3
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'D'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 4
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'E'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 5
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'F'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 6
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'G'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 7
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'H'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 8
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'I'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 9
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'L'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 10
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'M'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 11
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'N'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 12
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'O'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 13
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'P'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 14
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'Q'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 15
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'R'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 16
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'S'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 17
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'T'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 18
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'U'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 19
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'V'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 20
      ENDIF
      IF ALLTRIM(M.CAS_CORSIA) = 'Z'
         M.CAD_FILA_X = ALLTRIM(M.CAS_CORSIA)
         M.CAD_FILA_N = 21
      ENDIF
      M.CAD_PIAN_X = ALLTRIM(STR(M.CAS_PIANO,2,0))
      M.CAD_UBIC_X = ALLTRIM(STR(M.CAS_FILA,2,0))
      M.CAD_PIAN_N = M.CAS_PIANO
      M.CAD_UBIC_N = M.CAS_FILA
   ENDIF

      M.CAD_FLAG   = M.CAS_FLAG
      M.CAD_CODDOC = M.CAS_CODDOC
      M.CAD_DESDOC = M.CAS_DESDOC
      M.CAD_CODOPE = M.CAS_CODOPE
      M.CAD_CODLOC = M.CAS_CODLOC
      M.CAD_DESLOC = M.CAS_DESLOC
      M.CAD_NUMSCH = M.CAS_NUMSCH
      M.CAD_DATFIN = M.CAS_DATFIN

      SELECT CU_CAS_DD
      APPEND BLANK
      DO U_CAS_DD

      _V_CONTA2  = _V_CONTA2 + 1

      SELECT CUR_CAS_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_CAS_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle Cartelle sanitarie sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_cas_tt','I','','CU_CAS_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_cas_dd','I','','CU_CAS_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_CAS_AN       && CONVERTE LA TABELLA U_CAS_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA MATRICOLE									*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_CAS_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CAS_AN SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica matricole...  -  Prego Attendere" NOWAIT
cSql = "delete from U_CAS_AN where 1=1"
IF !ExecCommand(cSql,"U_CAS_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_CAS_AN where 1=0"
IF !ExecCommand(cSql,"CU_CAS_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_CAS_AN where 1=0"
IF !ExecCommand(cSql,"CUR_CAS_AN")
   return(.f.)
ENDIF
SELECT CUR_CAS_AN
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_CAS_AN
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione matricola " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_CAS_AN
   APPEND BLANK
   DO U_CAS_AN

   _V_CONTA = _V_CONTA + 1

   SELECT CUR_CAS_AN
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica matricole sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_cas_an','I','','CU_CAS_AN')
      return(.f.)
   ENDIF
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_PARA_CCA && CONVERTE I PARAMETRI CON CODICE LIKE 'CCA%' NELLA TABELLA PARA DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE CENTRI DI COSTO											*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "PARA"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL
WAIT WINDOWS "Cancellazione vecchi Centri di costo...  -  Prego Attendere" NOWAIT
x_codi = "codice like 'CCA%'"
x_cond = x_codi
cSql = "delete from PARA where " + x_cond
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PARA where 1=0"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from PARA where 1=0"
IF !ExecCommand(cSql,"CUR_PARA")
   return(.f.)
ENDIF
SELECT CUR_PARA
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_PARA
SET FILTER TO SUBSTR(CODICE,1,3) = "CCA"
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Centro di costo " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.GG_LAV   = 0
   M.PERANT   = 0
   M.PERSAL   = 0
   M.PAR_TRASME = SPACE(02)
   M.PAR_DATINS = RIBALTA2(DTOC(DATE()))
   M.TIPOMOV  = 0
   M.DTIPOMOV = SPACE(90)
   M.SCAFISS  = 0

   SELECT CU_PARA
   APPEND BLANK
   DO PARA

   _V_CONTA = _V_CONTA + 1

   SELECT CUR_PARA
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio Centri di costo sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','para','I','','CU_PARA')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_PARA_TDA && CONVERTE I PARAMETRI CON CODICE LIKE 'TDA%' NELLA TABELLA PARA DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE TIPI DOCUMENTI CARTACEI									*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "PARA"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL
WAIT WINDOWS "Cancellazione vecchi Tipi documento Schede tecniche...  -  Prego Attendere" NOWAIT
x_codi = "codice like 'TDA%'"
x_cond = x_codi
cSql = "delete from PARA where " + x_cond
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PARA where 1=0"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from PARA where 1=0"
IF !ExecCommand(cSql,"CUR_PARA")
   return(.f.)
ENDIF
SELECT CUR_PARA
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_PARA
SET FILTER TO SUBSTR(CODICE,1,3) = "TDA"
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Tipo documento Schede tecniche " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.GG_LAV   = 0
   M.PERANT   = 0
   M.PERSAL   = 0
   M.PAR_TRASME = SPACE(02)
   M.PAR_DATINS = RIBALTA2(DTOC(DATE()))
   M.TIPOMOV  = 0
   M.DTIPOMOV = SPACE(90)
   M.SCAFISS  = 0

   SELECT CU_PARA
   APPEND BLANK
   DO PARA

   _V_CONTA = _V_CONTA + 1

   SELECT CUR_PARA
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio Tipi documento Schede tecniche sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','para','I','','CU_PARA')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_PARA_TDC && CONVERTE I PARAMETRI CON CODICE LIKE 'TDS%' NELLA TABELLA PARA DA .DBF A SQL
                        && IL CODICE PARAMETRO VIENE CAMBIATO DA 'TDS' A 'TDC'
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE TIPI CARTELLE SANITARIE 								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "PARA"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL
WAIT WINDOWS "Cancellazione vecchi Tipi documento cartelle sanitarie...  -  Prego Attendere" NOWAIT
x_codi = "codice like 'TDC%'"
x_cond = x_codi
cSql = "delete from PARA where " + x_cond
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PARA where 1=0"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from PARA where 1=0"
IF !ExecCommand(cSql,"CUR_PARA")
   return(.f.)
ENDIF
SELECT CUR_PARA
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_PARA
SET FILTER TO SUBSTR(CODICE,1,3) = "TDS"
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Tipo documento cartelle sanitarie " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.CODICE   = "TDC" + SUBSTR(M.CODICE,4,4) && NELLA NUOVA VERSIONE ANZICHE' "TDS" LA CODIFICA AVERRA' CON PREFISSO "TDC"
   M.GG_LAV   = 0
   M.PERANT   = 0
   M.PERSAL   = 0
   M.PAR_TRASME = SPACE(02)
   M.PAR_DATINS = RIBALTA2(DTOC(DATE()))
   M.TIPOMOV  = 0
   M.DTIPOMOV = SPACE(90)
   M.SCAFISS  = 0

   SELECT CU_PARA
   APPEND BLANK
   DO PARA

   _V_CONTA = _V_CONTA + 1

   SELECT CUR_PARA
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio Tipi documento cartelle sanitarie sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','para','I','','CU_PARA')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_LOC_AN       && CONVERTE LA TABELLA U_LOC_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA LOCALITA'		    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_LOC_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_LOC_AN SQL
WAIT WINDOWS "Cancellazione vecchie località...  -  Prego Attendere" NOWAIT
cSql = "delete from U_LOC_AN where 1=1"
IF !ExecCommand(cSql,"U_LOC_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_LOC_AN where 1=0"
IF !ExecCommand(cSql,"CU_LOC_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_LOC_AN where 1=0"
IF !ExecCommand(cSql,"CUR_LOC_AN")
   return(.f.)
ENDIF
SELECT CUR_LOC_AN
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0
_V_DOPPIO = ""

*** LOOP DI SCRITTURA DATI
SELECT CUR_LOC_AN
INDEX ON LOC_CODSOC+LOC_CF+LOC_CODCLI+LOC_CODLOC TAG I_INDICE
SET ORDER TO I_INDICE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF LOC_CODSOC+LOC_CF+LOC_CODCLI+LOC_CODLOC = _V_DOPPIO
      SKIP +1
      LOOP
   ELSE
      _V_DOPPIO = LOC_CODSOC+LOC_CF+LOC_CODCLI+LOC_CODLOC
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Località " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.LOC_PROVIN = SPACE(02)
   M.LOC_TRASME = SPACE(02)
   M.LOC_DATINS = RIBALTA2(DTOC(DATE()))
   M.SELEZIONE  = SPACE(10)

   *** VALORI DI DEFAULT
   M.LOC_DATINS = "2005/12/31"

   SELECT CU_LOC_AN
   APPEND BLANK
   DO U_LOC_AN

   REPLACE LOC_PROVIN WITH M.LOC_PROVIN
   REPLACE LOC_TRASME WITH M.LOC_TRASME
   REPLACE LOC_DATINS WITH M.LOC_DATINS
   REPLACE SELEZIONE  WITH M.SELEZIONE

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_LOC_AN
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio delle Località sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_loc_an','I','','CU_LOC_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN


*************************************************************************************************
PROCEDURE CONV_U_CLI_AN       && CONVERTE LA TABELLA U_CLI_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CLIENTI			    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_CLI_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CLI_AN SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica clienti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_CLI_AN where 1=1"
IF !ExecCommand(cSql,"U_CLI_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_CLI_AN where 1=0"
IF !ExecCommand(cSql,"CU_CLI_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_CLI_AN where 1=0"
IF !ExecCommand(cSql,"CUR_CLI_AN")
   return(.f.)
ENDIF
SELECT CUR_CLI_AN
*APPEND FROM &V_PATH


**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_CLI_AN
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Cliente " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT


   M.CLI_PROVIN   = CLI_PROVIN

   M.CLI_DELDOC   = SPACE(50)
   M.CLI_UFFIVA   = SPACE(30)
   M.CLI_CODIMB   = SPACE(03)
   M.CLI_DATINS   = SPACE(10)
   M.CLI_DATNEW   = SPACE(10)
   M.CLI_FLGFID   = .F.
   M.CLI_CODCON   = SPACE(10)
   M.CLI_FLGTRA   = .F.
   M.CLI_CODCHE   = SPACE(02)
   M.CLI_CODCIN   = SPACE(02)
   M.CLI_CODABI   = SPACE(05)
   M.CLI_CODCAB   = SPACE(05)
   M.CLI_CDIBAN   = SPACE(29)
   M.CLI_VALIMP   = 0
   M.CLI_NUMINSOL = SPACE(03)
   M.CLI_LINGUA   = SPACE(03)
   M.CLI_SOTZONA  = SPACE(03)
   M.CLI_ABI2     = SPACE(04)
   M.CLI_CAB2     = SPACE(05)
   M.CLI_FLGABP   = .F.
   M.CLI_CLASSE   = SPACE(01)
   M.CLI_PERSMA   = SPACE(02)
   M.CLI_BAEFOR   = SPACE(05)
   M.CLI_NAZFOR   = SPACE(03)
   M.CLI_CHEFOR   = SPACE(02)
   M.CLI_CINFOR   = SPACE(02)
   M.CLI_ABIFOR   = SPACE(05)
   M.CLI_CABFOR   = SPACE(05)
   M.CLI_NCCFOR   = SPACE(12)
   M.CLI_IBAFOR   = SPACE(29)
   M.CLI_BSWFOR   = SPACE(100)
   M.CLI_FLGAGG   = .F.

*!*		** dati anagrafici sede legale cliente per legg2 248
*!*		M.CLI_RAGLEG  = M.CLI_RAGSOC
*!*		M.CLI_RGLEG2  = M.CLI_RAGDUE
*!*		M.CLI_INDLEG  = M.CLI_INDIR
*!*		M.CLI_LOCLEG  = M.CLI_LOCALI
*!*		M.CLI_PROLEG  = M.CLI_PROVIN
*!*		M.CLI_NAZLEG  = M.CLI_NAZION
*!*		M.CLI_CAPLEG  = M.CLI_CAP
*!*		M.CLI_CFISLG  = M.CLI_CODFIS
*!*		M.CLI_PIVALG  = M.CLI_PARIVA
*!*		M.CLI_IVCELG  = M.CLI_IVACEE



   *** VALORI DI DEFAULT
   M.CLI_CODCLI = UPPER(M.CLI_CODCLI)
   M.CLI_CODCLI = APITOSPA(M.CLI_CODCLI)
   M.CLI_DATINS = "2005/12/31"
   M.CLI_DATNEW = M.CLI_DATINS
   IF EMPTY(M.CLI_NAZION)
      M.CLI_NAZION = PUB_NAZI
   ENDIF	
   IF EMPTY(M.CLI_AGE)
      M.CLI_AGE    = PUB_AGE
   ENDIF
   IF EMPTY(M.CLI_CONPAG)
      M.CLI_CONPAG = PUB_CPA
   ENDIF
   IF EMPTY(M.CLI_CODIVA)
      M.CLI_CODIVA = PUB_IVA
   ENDIF
   IF EMPTY(M.CLI_VALUTA)
      M.CLI_VALUTA = PUB_VALU
   ENDIF
   IF M.CLI_SC1 = 0
      M.CLI_SC1 = PUB_SC1
   ENDIF	
   IF M.CLI_SC2 = 0
      M.CLI_SC2 = PUB_SC2
   ENDIF	
   IF M.CLI_SC3 = 0
      M.CLI_SC3 = PUB_SC3
   ENDIF	
   IF M.CLI_PROVVI = 0
      M.CLI_PROVVI = PUB_PROVVI
   ENDIF
   IF EMPTY(ALLTRIM(M.CLI_TIPFAT))
      M.CLI_TIPFAT = "FRM"
   ENDIF





   SELECT CU_CLI_AN
   APPEND BLANK
   DO U_CLI_AN

   REPLACE CLI_CODCON WITH M.CLI_CODCON
   REPLACE CLI_VALIMP WITH M.CLI_VALIMP
   REPLACE CLI_NUMINSOL WITH M.CLI_NUMINSOL
   REPLACE CLI_LINGUA WITH M.CLI_LINGUA
   REPLACE CLI_SOTZONA WITH M.CLI_SOTZONA
   REPLACE CLI_ABI2 WITH M.CLI_ABI2
   REPLACE CLI_CAB2 WITH M.CLI_CAB2

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_CLI_AN
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica clienti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_cli_an','I','','CU_CLI_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN


*************************************************************************************************
PROCEDURE CONV_U_CLI_AN_AGG_NAZIONE && AGGIORNA LA TABELLA U_CLI_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*									RIPORTO CODICE NAZIONE		   		 						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Gennaio 2013																				*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_CLI_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF


*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_CLI_AN where 1=0"
IF !ExecCommand(cSql,"CUR_CLI_AN")
   return(.f.)
ENDIF
SELECT CUR_CLI_AN


**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

SELECT CUR_CLI_AN
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

    SCATTER MEMVAR MEMO

    WAIT WINDOWS "Aggiorna Cliente " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT


    IF EMPTY(M.CLI_NAZION)
       M.CLI_NAZION = "ITA"
    ENDIF	


	x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
	cSql="SELECT * FROM U_CLI_AN WHERE "+ x_codi + " order by cli_codcli"
    IF !ExecRW(cSql,"u_cli_an","R")
 	   return(.f.)
    ENDIF

	SELECT u_cli_an
    REPLACE CLI_NAZION WITH M.CLI_NAZION
    IF EMPTY(CLI_NAZION) OR CLI_NAZION = ''
        REPLACE CLI_NAZION WITH "ITA"
    ENDIF


    IF !ExecRW("","u_cli_an","W")
	   return(.f.)
    ENDIF


   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_CLI_AN
   SKIP +1

ENDDO


IF _V_CONTA > 0
   _V_OKELAB = .T.
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_FOR_AN       && CONVERTE LA TABELLA U_FOR_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA FORNITORI		    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_FOR_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_FOR_AN SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica fornitori...  -  Prego Attendere" NOWAIT
cSql = "delete from U_FOR_AN where 1=1"
IF !ExecCommand(cSql,"U_FOR_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_FOR_AN where 1=0"
IF !ExecCommand(cSql,"CU_FOR_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_FOR_AN where 1=0"
IF !ExecCommand(cSql,"CUR_FOR_AN")
   return(.f.)
ENDIF
SELECT CUR_FOR_AN
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_FOR_AN
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Fornitore " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.FOR_PROVIN          = SPACE(02)
   M.FOR_TRASME          = SPACE(02)
   M.FOR_DATINS          = SPACE(10)
   M.FOR_DATNEW          = SPACE(10)
   M.FOR_CODCON          = SPACE(10)
   M.FOR_FLGTRA          = .F.
   M.FOR_GGFORN          = 0
   M.FOR_CODCHE          = SPACE(02)
   M.FOR_CODCIN          = SPACE(02)
   M.FOR_CODABI          = SPACE(05)
   M.FOR_CODCAB          = SPACE(05)
   M.FOR_CDIBAN          = SPACE(29)
   M.FOR_CODACQ          = SPACE(03)
   M.FOR_DESACQ          = SPACE(30)
   M.CLI_VALORD          = 0
   M.FOR_LINGUA          = SPACE(03)
   M.FOR_SOTZONA         = SPACE(03)
   M.FOR_ABI2            = SPACE(04)
   M.FOR_CAB2            = SPACE(05)
   M.FOR_PRVNASC         = SPACE(02)
   M.FOR_COSATRATTA      = SPACE(05)
   M.FOR_GRADOIMPORTANZA = SPACE(05)
   M.FOR_FORMAPAGAMENTO  = SPACE(05)
   M.FOR_TIPOCONTRATTO   = SPACE(05)
   M.FOR_PRIPAGA         = SPACE(04)
   M.FOR_BDAL            = SPACE(04)
   M.FOR_BAL             = SPACE(04)
   M.FOR_GG1             = SPACE(04)
   M.FOR_B2DAL           = SPACE(04)
   M.FOR_B2AL            = SPACE(04)
   M.FOR_GG2             = SPACE(04)
   M.FOR_BANPRA          = SPACE(10)
   M.FOR_CONACQ          = SPACE(10)
   M.FOR_CONSPE          = SPACE(10)
   M.FOR_MASSIM          = 0
   M.FOR_FATTOT          = 0
   M.FOR_PERENA          = 0
   M.FOR_CONENA          = SPACE(13)
   M.FOR_CONERA          = SPACE(13)
   M.FOR_CONPRV          = SPACE(13)
   M.FOR_FLGINT          = .F.

   *** VALORI DI DEFAULT
   M.FOR_DATINS = "2005/12/31"
   M.FOR_DATNEW = M.FOR_DATINS
   IF EMPTY(M.FOR_NAZION)
      M.FOR_NAZION = PUB_NAZI
   ENDIF
   IF EMPTY(M.FOR_VALUTA)
	  M.FOR_VALUTA = PUB_VALU
   ENDIF
   IF EMPTY(M.FOR_CONPAG)
	  M.FOR_CONPAG = PUB_CPA
   ENDIF
   IF EMPTY(M.FOR_CODIVA)
	  M.FOR_CODIVA = PUB_IVA
   ENDIF
   IF EMPTY(M.FOR_COSATRATTA)			
	  M.FOR_COSATRATTA = PUB_COSATRATTA
   ENDIF
   IF EMPTY(M.FOR_GRADOIMPORTANZA)		
	  M.FOR_GRADOIMPORTANZA = PUB_GRADOIMPORTANZA
   ENDIF
   IF EMPTY(M.FOR_FORMAPAGAMENTO)		
	  M.FOR_FORMAPAGAMENTO = PUB_FORMAPAGAMENTO
   ENDIF
   IF EMPTY(M.FOR_TIPOCONTRATTO)		
      M.FOR_TIPOCONTRATTO = PUB_TIPOCONTRATTO
   ENDIF
   IF EMPTY(M.FOR_CODACQ)	
	  M.FOR_CODACQ = ALLTRIM(PUB_CONAQUISTO)	
   ENDIF
   IF EMPTY(M.FOR_PRIPAGA)	
	  M.FOR_PRIPAGA = ALLTRIM(PUB_PRIORITAPAGAMENTO)	
   ENDIF
   v_SEEK = "COT"+M.FOR_COSATRATTA
   IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
      SELECT CPA_PARA
      M.FOR_DESCOSATRATTA = SUBSTR(DESCRI,1,30)
   ENDIF
   v_SEEK = "GRI"+M.FOR_GRADOIMPORTANZA
   IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
      SELECT CPA_PARA
      M.FOR_DESGRADOIMPORTANZA = SUBSTR(DESCRI,1,30)
   ENDIF
   v_SEEK = "FOP"+M.FOR_FORMAPAGAMENTO
   IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
      SELECT CPA_PARA
      M.FOR_DESFORMAPAGAMENTO = SUBSTR(DESCRI,1,30)
   ENDIF
   v_SEEK = "FLU"+M.FOR_TIPOCONTRATTO
   IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
      SELECT CPA_PARA
      M.FOR_DESTIPOCONTRATTO = SUBSTR(DESCRI,1,30)
   ENDIF
   v_SEEK = "TCA"+M.FOR_CODACQ
   IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
      SELECT CPA_PARA
      M.FOR_DESACQ = SUBSTR(DESCRI,1,30)
   ENDIF
   v_SEEK = "PPA"+M.FOR_PRIPAGA
   IF seek_std('PARA',v_seek,'CODICE','CPA_PARA')
      SELECT CPA_PARA
      M.FOR_DESPRI = SUBSTR(DESCRI,1,30)
   ENDIF
   v_seek	= 'APO' + PUB_CODSOC
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      M.FOR_BDAL ="0108"
      M.FOR_BAL  ="3108"
      M.FOR_gg1  ="1009"
      M.FOR_B2DAL="2012"
      M.FOR_B2AL ="3112"
      M.FOR_gg2  ="1001"
   ELSE
      M.FOR_BDAL ="1508"
      M.FOR_BAL  ="1508"
      M.FOR_gg1  ="1508"
      M.FOR_B2DAL="2512"
      M.FOR_B2AL ="2512"
      M.FOR_gg2  ="2512"
   ENDIF


   SELECT CU_FOR_AN
   APPEND BLANK
   DO U_FOR_AN

   REPLACE CLI_VALORD WITH M.CLI_VALORD
   REPLACE FOR_LINGUA WITH M.FOR_LINGUA
   REPLACE FOR_SOTZONA WITH M.FOR_SOTZONA
   REPLACE FOR_ABI2 WITH M.FOR_ABI2
   REPLACE FOR_CAB2 WITH M.FOR_CAB2
   REPLACE FOR_PRVNASC WITH M.FOR_PRVNASC

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_FOR_AN
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica fornitori sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_for_an','I','','CU_FOR_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_BAN_AN       && CONVERTE LA TABELLA U_BAN_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA BANCHE			    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_BAN_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_BAN_AN SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica banche...  -  Prego Attendere" NOWAIT
cSql = "delete from U_BAN_AN where 1=1"
IF !ExecCommand(cSql,"U_BAN_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_BAN_AN where 1=0"
IF !ExecCommand(cSql,"CU_BAN_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_BAN_AN where 1=0"
IF !ExecCommand(cSql,"CUR_BAN_AN")
   return(.f.)
ENDIF
SELECT CUR_BAN_AN
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_BAN_AN
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Banca " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.BAN_PROVIN = SPACE(02)
   M.BAN_TRASME = SPACE(02)
   M.BAN_DATINS = RIBALTA2(DTOC(DATE()))
   M.BAN_RIFMIT = SPACE(40)
   M.BAN_NOTE1  = SPACE(40)
   M.BAN_NOTE2  = SPACE(40)
   M.BAN_CONCON = SPACE(07)
   M.BAN_CONRIC = SPACE(10)
   M.BAN_PRESE  = SPACE(01)
   M.SELEZIONE  = SPACE(10)

   *** VALORI DI DEFAULT
   M.BAN_DATINS = "2005/12/31"

   SELECT CU_BAN_AN
   APPEND BLANK
   DO U_BAN_AN

   REPLACE BAN_RIFMIT WITH M.BAN_RIFMIT
   REPLACE BAN_NOTE1  WITH M.BAN_NOTE1
   REPLACE BAN_NOTE2  WITH M.BAN_NOTE2
   REPLACE SELEZIONE  WITH M.SELEZIONE

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_BAN_AN
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica banche sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_ban_an','I','','CU_BAN_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_AGE_AN       && CONVERTE LA TABELLA U_AGE_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA AGENTI			    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_AGE_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_AGE_AN SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica agenti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_AGE_AN where 1=1"
IF !ExecCommand(cSql,"U_AGE_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_AGE_AN where 1=0"
IF !ExecCommand(cSql,"CU_AGE_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_AGE_AN where 1=0"
IF !ExecCommand(cSql,"CUR_AGE_AN")
   return(.f.)
ENDIF
SELECT CUR_AGE_AN
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_AGE_AN
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Agente " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.AGE_PROVIN   = SPACE(02)
   M.AGE_TRASME   = SPACE(02)
   M.AGE_DATINS   = RIBALTA2(DTOC(DATE()))
   M.AGE_IMPPRO   = 0
   M.AGE_PROVMAT  = 0
   M.AGE_BADG1    = 0
   M.AGE_BADG2    = 0
   M.AGE_SCAPROV0 = 0
   M.AGE_SCAPROV1 = 0
   M.AGE_SCAPROV2 = 0
   M.AGE_SCAPROV3 = 0
   M.AGE_SCAPROV4 = 0
   M.AGE_SCAPROV5 = 0
   M.AGE_SCAPROV6 = 0
   M.AGE_SCAPROV7 = 0
   M.AGE_SCAPROV8 = 0
   M.AGE_SCAPROV9 = 0

   *** VALORI DI DEFAULT
   M.AGE_DATINS = "2005/12/31"


   SELECT CU_AGE_AN
   APPEND BLANK
   DO U_AGE_AN

   REPLACE AGE_IMPPRO   WITH M.AGE_IMPPRO
   REPLACE AGE_PROVMAT  WITH M.AGE_PROVMAT
   REPLACE AGE_BADG1    WITH M.AGE_BADG1
   REPLACE AGE_BADG2    WITH M.AGE_BADG2
   REPLACE AGE_SCAPROV0 WITH M.AGE_SCAPROV0
   REPLACE AGE_SCAPROV1 WITH M.AGE_SCAPROV1
   REPLACE AGE_SCAPROV2 WITH M.AGE_SCAPROV2
   REPLACE AGE_SCAPROV3 WITH M.AGE_SCAPROV3
   REPLACE AGE_SCAPROV4 WITH M.AGE_SCAPROV4
   REPLACE AGE_SCAPROV5 WITH M.AGE_SCAPROV5
   REPLACE AGE_SCAPROV6 WITH M.AGE_SCAPROV6
   REPLACE AGE_SCAPROV7 WITH M.AGE_SCAPROV7
   REPLACE AGE_SCAPROV8 WITH M.AGE_SCAPROV8
   REPLACE AGE_SCAPROV9 WITH M.AGE_SCAPROV9

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_AGE_AN
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica agenti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_age_an','I','','CU_AGE_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_ART_PR       && CONVERTE LA TABELLA U_ART_PR DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA ARTICOLI			    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_ART_PR"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_ART_PR SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica articoli...  -  Prego Attendere" NOWAIT
cSql = "delete from U_ART_PR where 1=1"
IF !ExecCommand(cSql,"U_ART_PR")
   return(.f.)
ENDIF
cSql = "delete from U_ART_AN where 1=1"
IF !ExecCommand(cSql,"U_ART_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_ART_AN where 1=0"
IF !ExecCommand(cSql,"CU_ART_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_ART_PR where 1=0"
IF !ExecCommand(cSql,"CU_ART_PR")
   return(.f.)
ENDIF


*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_ART_PR where 1=0"
IF !ExecCommand(cSql,"CUR_ART_PR")
   return(.f.)
ENDIF
SELECT CUR_ART_PR
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_ART_PR
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

*!*	   IF _V_CONTA >= 1000
*!*	      EXIT
*!*	   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Articolo " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.ART_BARFOR = SPACE(20)
   M.ART_BARCLI = SPACE(20)
   M.ART_CODIMB = SPACE(3)
   M.ART_CSTMAT = 0
   M.ART_CSTLAV = 0
   M.ART_TMPLAV = 0
   M.ART_MDCPER = 0
   M.ART_MDCQF  = 0
   M.ART_LOTTO  = 0
   M.ART_INTERA = 0
   M.ART_NUMDEN = 0
   M.ART_MODULO = 0
   M.ART_CODDIS = SPACE(15)
   M.ART_REVDIS = SPACE(2)
   M.ART_DATVAR = SPACE(10)
   M.ART_CODCLI = SPACE(10)
   M.ART_RAGSOC = SPACE(40)
   M.ART_MODELL = SPACE(25)
   M.ART_MATERI = SPACE(25)
   M.ART_MISURE = SPACE(25)
   M.ART_DESPES = SPACE(25)
   M.ART_NOTVAR = SPACE(50)
   M.ART_NUMCOM = SPACE(6)
   M.ART_DATCOM = SPACE(10)
   M.ART_DATCON = SPACE(10)
   M.ART_PEZZI  = 0
   M.ART_TPARTI = SPACE(2)
   M.ART_CODMAT = SPACE(3)
   M.ART_TIPART = SPACE(1)
   M.ART_DISBAS = SPACE(1)
   M.ART_RIPCOM = SPACE(1)
   M.ART_CODUPL = SPACE(16)
   M.ART_DSDUPL = SPACE(50)
   M.ART_DTDUPL = SPACE(10)
   M.ART_CICLO  = .F.
   M.ART_CSTMAN = 0
   M.ART_CSTMAC = 0
   M.ART_CODTAG = SPACE(3)
   M.ART_DESTAG = SPACE(30)
   M.ART_CODCOL = SPACE(3)
   M.ART_DESCOL = SPACE(30)
   M.ART_DESRID = SPACE(30)
   M.ART_PRZETI = 0
   M.ART_PRZCOP = 0
   M.ART_SC1    = 0
   M.ART_SC2    = 0
   M.ART_SC3    = 0
   M.ART_GRUEDI = SPACE(5)
   M.ART_EDITOR = SPACE(5)
   M.ART_COLLAN = SPACE(3)
   M.ART_CATAGO = SPACE(50)
   M.ART_AUTORE = SPACE(50)
   M.ART_ARGOME = SPACE(50)
   M.ART_PROSPE = .F.
   M.ART_QTASPE = 0
   M.ART_PRESPE = 0
   M.ART_CDISBN = SPACE(50)
   M.ART_FLGRES = .F.
   M.ART_NUMRES = 0
   M.ART_DATRES = SPACE(10)
   M.ART_NULTRE = SPACE(6)
   M.ART_NONMOV = .F.
   M.ART_CODCON = SPACE(16)
   M.ART_FLGTRA = .F.
   M.ART_DESGRE = SPACE(50)
   M.ART_DESEDI = SPACE(50)
   M.ART_DESCOA = SPACE(50)
   M.ART_DESLIN = SPACE(50)
   M.ART_PRZIVA = 0
   M.ART_CODPAC = SPACE(16)
   M.ART_DESPAC = SPACE(50)
   M.ART_TIPCOM = SPACE(3)
   M.ART_DESCOM = SPACE(30)
   M.ART_SERNUM = SPACE(50)
   M.ART_NOTCOM = SPACE(50)
   M.ART_FLGMOD = SPACE(1)
   M.ART_LEGSYS = SPACE(10)
   M.ART_FLGMIM = .F.
   M.ART_CODOPE = SPACE(10)
   M.ART_DESOPE = SPACE(50)
   M.ART_CODMAR = SPACE(3)
   M.ART_DESMAR = SPACE(50)
   M.ART_CODFOR = SPACE(10)
   M.ART_DESFOR = SPACE(50)
   M.ART_NUMDOC = SPACE(20)
   M.ART_DATDOC = SPACE(10)
   M.ART_UMMAGA = SPACE(3)
   M.ART_DESMAT = SPACE(30)
   M.ART_SPESSO = 0
   M.ART_ALTEZZ = 0
   M.ART_LUNGHE = 0
   M.ART_DESIMB = SPACE(30)
   M.ART_LOTMIN = 0
   M.ART_CDDIBA = SPACE(16)
   M.ART_DSDIBA = SPACE(50)
   M.ART_AMMORT = SPACE(1)
   M.ART_VALORE = 0
   M.ART_DTUTIL = SPACE(10)
   M.ART_DTCEBE = SPACE(10)
   M.ART_BARCOD = SPACE(20)
   M.ART_CODPOL = SPACE(2)
   M.ART_DESPOL = SPACE(30)
   M.ART_CODCAT = SPACE(2)
   M.ART_DESCAT = SPACE(50)

   *** VALORI DI DEFAULT
   M.ART_CODPRI   = UPPER(M.ART_CODPRI)
   M.ART_CODPRI   = APITOSPA(M.ART_CODPRI)
   M.ART_TIPO     = UPPER(SUBSTR(M.ART_CODPRI,1,4))
   M.ART_LUNG     = UPPER(SUBSTR(M.ART_CODPRI,5,4))
   M.ART_LARG     = UPPER(SUBSTR(M.ART_CODPRI,9,4))
   M.ART_COLORE   = UPPER(SUBSTR(M.ART_CODPRI,13,2))
   M.ART_LAVORA   = UPPER(SUBSTR(M.ART_CODPRI,15,2))
   M.ART_TIPO     = APITOSPA(M.ART_TIPO)
   M.ART_LUNG     = APITOSPA(M.ART_LUNG)
   M.ART_LARG     = APITOSPA(M.ART_LARG)
   M.ART_COLORE   = APITOSPA(M.ART_COLORE)
   M.ART_LAVORA   = APITOSPA(M.ART_LAVORA)
   IF EMPTY(M.ART_UNIMIS)
	  M.ART_UNIMIS = PUB_UM
   ENDIF
   IF EMPTY(ALLTRIM(M.ART_UMMAGA))
      M.ART_UMMAGA = M.ART_UNIMIS
   ENDIF


   IF ALLTRIM(M.ART_UNIMIS) = 'N'
	  M.ART_UNIMIS = 'NR'
   ENDIF
   IF ALLTRIM(M.ART_UMMAGA) = 'N'
	  M.ART_UMMAGA= 'NR'
   ENDIF




   IF EMPTY(M.ART_LINEA)
      M.ART_LINEA  = PUB_LINEA
   ENDIF
   IF EMPTY(M.ART_CODIVA)
	  M.ART_CODIVA = PUB_IVA
   ENDIF
   IF EMPTY(M.ART_MAGA)
	  M.ART_MAGA   = PUB_CODM
   ENDIF
   IF EMPTY(M.ART_DATINS)
      M.ART_DATINS = "2005/12/31"
   ENDIF
   M.ART_DATVAR = M.ART_DATINS

   IF EMPTY(M.ART_CODMAT) .OR. M.ART_CODMAT = SPACE(03)
      M.ART_CODMAT = '001'
      M.ART_DESMAT = 'GENERICO'
   ENDIF
   IF EMPTY(M.ART_TIPART) .OR. M.ART_TIPART = SPACE(01)
      M.ART_TIPART = 'A'
   ENDIF
   IF EMPTY(M.ART_DISBAS) .OR. M.ART_DISBAS = SPACE(01)
      M.ART_DISBAS = 'S'
   ENDIF
   IF EMPTY(M.ART_RIPCOM) .OR. M.ART_RIPCOM = SPACE(01)
      M.ART_RIPCOM = 'S'
   ENDIF

   SELECT CU_ART_PR
   APPEND BLANK
   DO U_ART_PR


   REPLACE ART_CODCON WITH M.ART_CODCON
   REPLACE ART_BARCOD WITH M.ART_BARCOD


	M.ART_SCELTA  	= ""
	M.ART_FINI  	= ""		
	M.ART_CODCOLRET = ""
	M.ART_TIPOG  	= ""
	M.ART_TIPON  	= ""
	M.ART_TOLGRM  	= 0

	M.ART_PREPES  	= .F.	
	M.ART_ARTSIMI	= ''	
	M.ART_DESARS  	= ''	
	M.ART_CODLIS	= ''	
	M.ART_DESLIS 	= ''	
	M.ART_SCHEDA	= ''	


   SELECT CU_ART_AN
   APPEND BLANK

	M.ART_DESCRWEB  =""
	M.ART_PRZVENWEB =0
	M.ART_XCOSLAI   =""
	M.ART_XCOSLAE	=""
	M.ART_XCOSATR	=""
	M.ART_NONWEB	= .F.	
	M.ART_FATIDR	= .F.
	M.ART_QTANRC  	= 0	




   DO U_ART_AN




   _V_CONTA  = _V_CONTA + 1



   SELECT CUR_ART_PR
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica articoli sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_art_pr','I','','CU_ART_PR')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_art_an','I','','CU_ART_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_CONTI       && CONVERTE LA TABELLA CONTI DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA PIANO DEI CONTI	    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "CONTI"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA CONTI SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica piano dei conti...  -  Prego Attendere" NOWAIT
cSql = "delete from CONTI where 1=1"
IF !ExecCommand(cSql,"CONTI")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from CONTI where 1=0"
IF !ExecCommand(cSql,"CU_CONTI")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from CONTI where 1=0"
IF !ExecCommand(cSql,"CUR_CONTI")
   return(.f.)
ENDIF
SELECT CUR_CONTI
SET FILTER TO
*!*	SET FILTER TO (ALLTRIM(CON_ANNO) == _V_ANNCONV OR ALLTRIM(CON_ANNO) == _V_ANNCONV_PRECEDENTE)
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_CONTI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Piano dei conti " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.CON_FLGCCO  = .F.
   M.CON_CONOLD  = SPACE(13)
   M.PRE_IMP_D   = 0
   M.PRE_IMP_A   = 0
   M.PRE_DA01    = 0
   M.PRE_AV01    = 0
   M.PRE_DA02    = 0
   M.PRE_AV02    = 0
   M.PRE_DA03    = 0
   M.PRE_AV03    = 0
   M.PRE_DA04    = 0
   M.PRE_AV04    = 0
   M.PRE_DA05    = 0
   M.PRE_AV05    = 0
   M.PRE_DA06    = 0
   M.PRE_AV06    = 0
   M.PRE_DA07    = 0
   M.PRE_AV07    = 0
   M.PRE_DA08    = 0
   M.PRE_AV08    = 0
   M.PRE_DA09    = 0
   M.PRE_AV09    = 0
   M.PRE_DA10    = 0
   M.PRE_AV10    = 0
   M.PRE_DA11    = 0
   M.PRE_AV11    = 0
   M.PRE_DA12    = 0
   M.PRE_AV12    = 0
   M.CON_CATEG   = SPACE(6)
   M.CON_FATTURA = 0
   M.CON_NOTAC   = 0
   M.PRE_FATTURA = 0
   M.PRE_NOTAC   = 0
   M.CON_CODRAG  = SPACE(8)
   M.CON_DESRAG  = SPACE(50)
   M.CON_CODCON  = SPACE(8)
   M.CON_DESCON  = SPACE(50)

   SELECT CU_CONTI
   APPEND BLANK
   DO CONTI

   REPLACE CON_CONOLD  WITH M.CON_CONOLD
   REPLACE PRE_IMP_D   WITH M.PRE_IMP_D
   REPLACE PRE_IMP_A   WITH M.PRE_IMP_A
   REPLACE PRE_DA01    WITH M.PRE_DA01
   REPLACE PRE_AV01    WITH M.PRE_AV01
   REPLACE PRE_DA02    WITH M.PRE_DA02
   REPLACE PRE_AV02    WITH M.PRE_AV02
   REPLACE PRE_DA03    WITH M.PRE_DA03
   REPLACE PRE_AV03    WITH M.PRE_AV03
   REPLACE PRE_DA04    WITH M.PRE_DA04
   REPLACE PRE_AV04    WITH M.PRE_AV04
   REPLACE PRE_DA05    WITH M.PRE_DA05
   REPLACE PRE_AV05    WITH M.PRE_AV05
   REPLACE PRE_DA06    WITH M.PRE_DA06
   REPLACE PRE_AV06    WITH M.PRE_AV06
   REPLACE PRE_DA07    WITH M.PRE_DA07
   REPLACE PRE_AV07    WITH M.PRE_AV07
   REPLACE PRE_DA08    WITH M.PRE_DA08
   REPLACE PRE_AV08    WITH M.PRE_AV08
   REPLACE PRE_DA09    WITH M.PRE_DA09
   REPLACE PRE_AV09    WITH M.PRE_AV09
   REPLACE PRE_DA10    WITH M.PRE_DA10
   REPLACE PRE_AV10    WITH M.PRE_AV10
   REPLACE PRE_DA11    WITH M.PRE_DA11
   REPLACE PRE_AV11    WITH M.PRE_AV11
   REPLACE PRE_DA12    WITH M.PRE_DA12
   REPLACE PRE_AV12    WITH M.PRE_AV12
   REPLACE CON_FATTURA WITH M.CON_FATTURA
   REPLACE CON_NOTAC   WITH M.CON_NOTAC
   REPLACE PRE_FATTURA WITH M.PRE_FATTURA
   REPLACE PRE_NOTAC   WITH M.PRE_NOTAC
   REPLACE CON_CODRAG  WITH M.CON_CODRAG
   REPLACE CON_DESRAG  WITH M.CON_DESRAG
   REPLACE CON_CODCON  WITH M.CON_CODCON
   REPLACE CON_DESCON  WITH M.CON_DESCON

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_CONTI
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica piano dei conti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','conti','I','','CU_CONTI')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_CCOSTO       && CONVERTE LA TABELLA CCOSTO DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CENTRI DI COSTO	    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "CCOSTO"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA CCOSTO SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica centri di costo...  -  Prego Attendere" NOWAIT
cSql = "delete from CCOSTO where 1=1"
IF !ExecCommand(cSql,"CCOSTO")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from CCOSTO where 1=0"
IF !ExecCommand(cSql,"CU_CCOSTO")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from CCOSTO where 1=0"
IF !ExecCommand(cSql,"CUR_CCOSTO")
   return(.f.)
ENDIF
SELECT CUR_CCOSTO
SET FILTER TO
*!*	SET FILTER TO ALLTRIM(CON_ANNO) == _V_ANNCONV
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_CCOSTO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Centri di costo " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.PRE_IMP_D = 0
   M.PRE_DA01  = 0
   M.PRE_DA02  = 0
   M.PRE_DA03  = 0
   M.PRE_DA04  = 0
   M.PRE_DA05  = 0
   M.PRE_DA06  = 0
   M.PRE_DA07  = 0
   M.PRE_DA08  = 0
   M.PRE_DA09  = 0
   M.PRE_DA10  = 0
   M.PRE_DA11  = 0
   M.PRE_DA12  = 0

   SELECT CU_CCOSTO
   APPEND BLANK
   DO CCOSTO

   REPLACE PRE_IMP_D WITH M.PRE_IMP_D
   REPLACE PRE_DA01  WITH M.PRE_DA01
   REPLACE PRE_DA02  WITH M.PRE_DA02
   REPLACE PRE_DA03  WITH M.PRE_DA03
   REPLACE PRE_DA04  WITH M.PRE_DA04
   REPLACE PRE_DA05  WITH M.PRE_DA05
   REPLACE PRE_DA06  WITH M.PRE_DA06
   REPLACE PRE_DA07  WITH M.PRE_DA07
   REPLACE PRE_DA08  WITH M.PRE_DA08
   REPLACE PRE_DA09  WITH M.PRE_DA09
   REPLACE PRE_DA10  WITH M.PRE_DA10
   REPLACE PRE_DA11  WITH M.PRE_DA11
   REPLACE PRE_DA12  WITH M.PRE_DA12

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_CCOSTO
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica centri di costo sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','ccosto','I','','CU_CCOSTO')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_PJTIPREP       && CONVERTE LA TABELLA PJTIPREP DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA REPORT			    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "PJTIPREP"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PJTIPREP SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica report...  -  Prego Attendere" NOWAIT
cSql = "delete from PJTIPREP where 1=1"
IF !ExecCommand(cSql,"PJTIPREP")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PJTIPREP where 1=0"
IF !ExecCommand(cSql,"CU_PJTIPREP")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from PJTIPREP where 1=0"
IF !ExecCommand(cSql,"CUR_PJTIPREP")
   return(.f.)
ENDIF
SELECT CUR_PJTIPREP
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_PJTIPREP
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica report " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_PJTIPREP
   APPEND BLANK
   DO PJTIPREP

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_PJTIPREP
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica report sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','pjtiprep','I','','CU_PJTIPREP')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_VVA_CH       && CONVERTE LA TABELLA U_VVA_CH DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA VALUTE			    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_VVA_CH"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_VVA_CH SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica valute...  -  Prego Attendere" NOWAIT
cSql = "delete from U_VVA_CH where 1=1"
IF !ExecCommand(cSql,"U_VVA_CH")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_VVA_CH where 1=0"
IF !ExecCommand(cSql,"CU_VVA_CH")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_VVA_CH where 1=0"
IF !ExecCommand(cSql,"CUR_VVA_CH")
   return(.f.)
ENDIF
SELECT CUR_VVA_CH
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_VVA_CH
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica valute " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_VVA_CH
   APPEND BLANK
   DO U_VVA_CH

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_VVA_CH
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica valute sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_vva_ch','I','','CU_VVA_CH')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_COMUNI       && CONVERTE LA TABELLA COMUNI DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA COMUNI			    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "COMUNI"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA COMUNI SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica comuni...  -  Prego Attendere" NOWAIT
cSql = "delete from COMUNI where 1=1"
IF !ExecCommand(cSql,"COMUNI")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from COMUNI where 1=0"
IF !ExecCommand(cSql,"CU_COMUNI")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from COMUNI where 1=0"
IF !ExecCommand(cSql,"CUR_COMUNI")
   return(.f.)
ENDIF
SELECT CUR_COMUNI
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_COMUNI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Comune " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.SELEZIONE = SPACE(10)

   SELECT CU_COMUNI
   APPEND BLANK
   DO COMUNI

   REPLACE SELEZIONE WITH M.SELEZIONE

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_COMUNI
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica comuni sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','comuni','I','','CU_COMUNI')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_PROVINCE       && CONVERTE LA TABELLA PROVINCE DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA PROVINCE			    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "PROVINCE"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PROVINCE SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica province...  -  Prego Attendere" NOWAIT
cSql = "delete from PROVINCE where 1=1"
IF !ExecCommand(cSql,"PROVINCE")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PROVINCE where 1=0"
IF !ExecCommand(cSql,"CU_PROVINCE")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from PROVINCE where 1=0"
IF !ExecCommand(cSql,"CUR_PROVINCE")
   return(.f.)
ENDIF
SELECT CUR_PROVINCE
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_PROVINCE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Provincia " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_PROVINCE
   APPEND BLANK
   DO PROVINCE

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_PROVINCE
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica province sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','province','I','','CU_PROVINCE')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_REGIONI       && CONVERTE LA TABELLA REGIONI DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA REGIONI			    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "REGIONI"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA REGIONI SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica regioni...  -  Prego Attendere" NOWAIT
cSql = "delete from REGIONI where 1=1"
IF !ExecCommand(cSql,"REGIONI")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from REGIONI where 1=0"
IF !ExecCommand(cSql,"CU_REGIONI")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from REGIONI where 1=0"
IF !ExecCommand(cSql,"CUR_REGIONI")
   return(.f.)
ENDIF
SELECT CUR_REGIONI
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_REGIONI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Regione " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_REGIONI
   APPEND BLANK
   DO REGIONI

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_REGIONI
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica regioni sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','regioni','I','','CU_REGIONI')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_NOTE_COM       && CONVERTE LA TABELLA NOTE_COM DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA NOTE				    						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "NOTE_COM"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA NOTE_COM SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica note...  -  Prego Attendere" NOWAIT
cSql = "delete from NOTE_COM where 1=1"
IF !ExecCommand(cSql,"NOTE_COM")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from NOTE_COM where 1=0"
IF !ExecCommand(cSql,"CU_NOTE_COM")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from NOTE_COM where 1=0"
IF !ExecCommand(cSql,"CUR_NOTE_COM")
   return(.f.)
ENDIF
SELECT CUR_NOTE_COM
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_NOTE_COM
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Nota " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.NOC_GEST6 = .F.
   M.NOC_PAGAN = .F.

   SELECT CU_NOTE_COM
   APPEND BLANK
   DO NOTE_COM

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_NOTE_COM
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica note sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','note_com','I','','CU_NOTE_COM')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_LIS_TT       && CONVERTE LA TABELLA U_LIS_TT DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA LISTINI (U_LIS_TT)   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_LIS_TT"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_LIS_TT SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica listini (tabella U_LIS_TT)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_LIS_TT where 1=1"
IF !ExecCommand(cSql,"U_LIS_TT")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_LIS_TT where 1=0"
IF !ExecCommand(cSql,"CU_LIS_TT")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_LIS_TT where 1=0"
IF !ExecCommand(cSql,"CUR_LIS_TT")
   return(.f.)
ENDIF
SELECT CUR_LIS_TT
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_LIS_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica listini (tabella U_LIS_TT) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.LIS_FLGTRA = .F.
   M.LIS_PRZSCO = 0
   M.LIS_QTA    = 0

   IF EMPTY(ALLTRIM(M.LIS_DATLIS)) .OR. M.LIS_DATLIS = "  /  /    " .OR. M.LIS_DATLIS = "    /  /  "
      M.LIS_DATLIS = "2005/01/01"
   ENDIF
   IF EMPTY(ALLTRIM(M.LIS_ALLIST)) .OR. M.LIS_ALLIST = "  /  /    " .OR. M.LIS_ALLIST = "    /  /  "
      M.LIS_ALLIST = PUB_DTAL
   ENDIF

   SELECT CU_LIS_TT
   APPEND BLANK
   DO U_LIS_TT

   REPLACE LIS_PRZSCO WITH M.LIS_PRZSCO
   	
   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_LIS_TT
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica listini (tabella U_LIS_TT) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_lis_tt','I','','CU_LIS_TT')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_LIF_TT       && CONVERTE LA TABELLA U_LIF_TT DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA LISTINI (U_LIF_TT)   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_LIF_TT"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_LIF_TT SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica listini (tabella U_LIF_TT)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_LIF_TT where 1=1"
IF !ExecCommand(cSql,"U_LIF_TT")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_LIF_TT where 1=0"
IF !ExecCommand(cSql,"CU_LIF_TT")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_LIF_TT where 1=0"
IF !ExecCommand(cSql,"CUR_LIF_TT")
   return(.f.)
ENDIF
SELECT CUR_LIF_TT
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_LIF_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica listini (tabella U_LIF_TT) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   IF EMPTY(ALLTRIM(M.LIS_DATLIS)) .OR. M.LIS_DATLIS = "  /  /    " .OR. M.LIS_DATLIS = "    /  /  "
      M.LIS_DATLIS = "01/01/1998"
   ENDIF
   IF EMPTY(ALLTRIM(M.LIS_ALLIST)) .OR. M.LIS_ALLIST = "  /  /    " .OR. M.LIS_ALLIST = "    /  /  "
      M.LIS_ALLIST = "31/12/2999"
   ENDIF

   SELECT CU_LIF_TT
   APPEND BLANK
   DO U_LIF_TT

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_LIF_TT
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica listini (tabella U_LIF_TT) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_lif_tt','I','','CU_LIF_TT')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_LIS_AG       && CONVERTE LA TABELLA U_LIS_AG DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA LISTINI (U_LIS_AG)   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_LIS_AG"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_LIS_AG SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica listini (tabella U_LIS_AG)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_LIS_AG where 1=1"
IF !ExecCommand(cSql,"U_LIS_AG")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_LIS_AG where 1=0"
IF !ExecCommand(cSql,"CU_LIS_AG")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_LIS_AG where 1=0"
IF !ExecCommand(cSql,"CUR_LIS_AG")
   return(.f.)
ENDIF
SELECT CUR_LIS_AG
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_LIS_AG
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica listini (tabella U_LIS_AG) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_LIS_AG
   APPEND BLANK
   DO U_LIS_AG

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_LIS_AG
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica listini (tabella U_LIS_AG) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_lis_ag','I','','CU_LIS_AG')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_LIS_LG       && CONVERTE LA TABELLA U_LIS_LG DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA LISTINI (U_LIS_LG)   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_LIS_LG"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_LIS_LG SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica listini (tabella U_LIS_LG)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_LIS_LG where 1=1"
IF !ExecCommand(cSql,"U_LIS_LG")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_LIS_LG where 1=0"
IF !ExecCommand(cSql,"CU_LIS_LG")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_LIS_LG where 1=0"
IF !ExecCommand(cSql,"CUR_LIS_LG")
   return(.f.)
ENDIF
SELECT CUR_LIS_LG
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_LIS_LG
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica listini (tabella U_LIS_LG) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.LIS_TIPO = UPPER(M.LIS_TIPO)
   IF ALLTRIM(M.LIS_TIPO) = "AGENTE"
      M.LIS_LINART = "XXX"
      M.LIS_ZONA   = "XXX"
      M.LIS_CODCLI = "XXXXXXXXXX"
   ENDIF
   IF ALLTRIM(M.LIS_TIPO) = "LINEA"
      M.LIS_AGE    = "XXX"
      M.LIS_ZONA   = "XXX"
      M.LIS_CODCLI = "XXXXXXXXXX"
   ENDIF
   IF ALLTRIM(M.LIS_TIPO) = "ZONA"
      M.LIS_AGE    = "XXX"
      M.LIS_LINART = "XXX"
      M.LIS_CODCLI = "XXX"
   ENDIF
   IF ALLTRIM(M.LIS_TIPO) = "CLIENTE"
      M.LIS_AGE    = "XXX"
      M.LIS_LINART = "XXX"
      M.LIS_ZONA   = "XXX"
   ENDIF
   M.LIS_FLGTRA = .F.

   SELECT CU_LIS_LG
   APPEND BLANK
   DO U_LIS_LG

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_LIS_LG
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica listini (tabella U_LIS_LG) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_lis_lg','I','','CU_LIS_LG')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_LIS_LI       && CONVERTE LA TABELLA U_LIS_LI DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA LISTINI (U_LIS_LI)   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_LIS_LI"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_LIS_LI SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica listini (tabella U_LIS_LI)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_LIS_LI where 1=1"
IF !ExecCommand(cSql,"U_LIS_LI")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_LIS_LI where 1=0"
IF !ExecCommand(cSql,"CU_LIS_LI")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_LIS_LI where 1=0"
IF !ExecCommand(cSql,"CUR_LIS_LI")
   return(.f.)
ENDIF
SELECT CUR_LIS_LI
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_LIS_LI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica listini (tabella U_LIS_LI) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_LIS_LI
   APPEND BLANK
   DO U_LIS_LI

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_LIS_LI
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica listini (tabella U_LIS_LI) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_lis_li','I','','CU_LIS_LI')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_LIS_PA       && CONVERTE LA TABELLA U_LIS_PA DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA LISTINI (U_LIS_PA)   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_LIS_PA"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_LIS_PA SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica listini (tabella U_LIS_PA)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_LIS_PA where 1=1"
IF !ExecCommand(cSql,"U_LIS_PA")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_LIS_PA where 1=0"
IF !ExecCommand(cSql,"CU_LIS_PA")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_LIS_PA where 1=0"
IF !ExecCommand(cSql,"CUR_LIS_PA")
   return(.f.)
ENDIF
SELECT CUR_LIS_PA
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_LIS_PA
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica listini (tabella U_LIS_PA) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_LIS_PA
   APPEND BLANK
   DO U_LIS_PA

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_LIS_PA
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica listini (tabella U_LIS_PA) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_lis_pa','I','','CU_LIS_PA')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_LIS_VE       && CONVERTE LA TABELLA U_LIS_VE DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA LISTINI (U_LIS_VE)   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_LIS_VE"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_LIS_VE SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica listini (tabella U_LIS_VE)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_LIS_VE where 1=1"
IF !ExecCommand(cSql,"U_LIS_VE")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_LIS_VE where 1=0"
IF !ExecCommand(cSql,"CU_LIS_VE")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_LIS_VE where 1=0"
IF !ExecCommand(cSql,"CUR_LIS_VE")
   return(.f.)
ENDIF
SELECT CUR_LIS_VE
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_LIS_VE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica listini (tabella U_LIS_VE) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   IF EMPTY(ALLTRIM(M.LIS_DATLIS)) .OR. M.LIS_DATLIS = "  /  /    " .OR. M.LIS_DATLIS = "    /  /  "
      M.LIS_DATLIS = "2005/01/01"
   ENDIF
   IF EMPTY(ALLTRIM(M.LIS_ALLIST)) .OR. M.LIS_ALLIST = "  /  /    " .OR. M.LIS_ALLIST = "    /  /  "
      M.LIS_ALLIST = PUB_DTAL
   ENDIF

   SELECT CU_LIS_VE
   APPEND BLANK
   DO U_LIS_VE

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_LIS_VE
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica listini (tabella U_LIS_VE) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_lis_ve','I','','CU_LIS_VE')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_PRV_AN       && CONVERTE LA TABELLA U_PRV_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA PROVVIGIONI			   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_PRV_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_PRV_AN SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica provvigioni...  -  Prego Attendere" NOWAIT
cSql = "delete from U_PRV_AN where 1=1"
IF !ExecCommand(cSql,"U_PRV_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_PRV_AN where 1=0"
IF !ExecCommand(cSql,"CU_PRV_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_PRV_AN where 1=0"
IF !ExecCommand(cSql,"CUR_PRV_AN")
   return(.f.)
ENDIF
SELECT CUR_PRV_AN
SET FILTER TO
**SET FILTER TO ALLTRIM(PRV_ANNO) == _V_ANNCONV
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_PRV_AN
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica provvigioni " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.PRV_NPART  = 0
   M.PRV_TIPFAT = SPACE(3)
   M.PRV_TMOV   = SPACE(1)
   M.PRV_CODPAG = SPACE(3)
   M.PRV_DESPAG = SPACE(30)
   M.PRV_DTSCAD = SPACE(10)
   M.PRV_LIQUID = SPACE(2)
   M.PRV_ANOMAX = SPACE(3)
   M.PRV_DTLIQU = SPACE(10)
   M.PRV_STORIC = SPACE(1)
   M.PRV_MESE   = SPACE(2)
   M.PRV_NONMAT = 0
   M.PRV_MATURA = 0
   M.PRV_TOTLIQ = 0
   M.PRV_PNONMA = 0
   M.PRV_PMATUR = 0
   M.PRV_PTOTLI = 0
   M.PRV_NONMOD = SPACE(1)
   M.PRV_DISLIQ = 0
   M.PRV_IMPRIC = 0
   M.PRV_SPEDIZ = 0

   SELECT CU_PRV_AN
   APPEND BLANK
   DO U_PRV_AN

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_PRV_AN
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica provvigioni sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_prv_an','I','','CU_PRV_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_PROV_STO       && CONVERTE LA TABELLA PROV_STO DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA PROVVIGIONI STORICHE	   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "PROV_STO"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PROV_STO SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica provvigioni storiche...  -  Prego Attendere" NOWAIT
cSql = "delete from PROV_STO where 1=1"
IF !ExecCommand(cSql,"PROV_STO")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PROV_STO where 1=0"
IF !ExecCommand(cSql,"CU_PROV_STO")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from PROV_STO where 1=0"
IF !ExecCommand(cSql,"CUR_PROV_STO")
   return(.f.)
ENDIF
SELECT CUR_PROV_STO
SET FILTER TO
**SET FILTER TO SUBSTR(ORD_DATORD,1,4) == _V_ANNCONV
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_PROV_STO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica provvigioni storiche " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_PROV_STO
   APPEND BLANK
   DO PROV_STO

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_PROV_STO
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica provvigioni storiche sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','prov_sto','I','','CU_PROV_STO')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_RIC_ARC       && CONVERTE LA TABELLA RIC_ARC DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA GENERALE				   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "RIC_ARC"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA RIC_ARC SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica generale...  -  Prego Attendere" NOWAIT
cSql = "delete from RIC_ARC where 1=1"
IF !ExecCommand(cSql,"RIC_ARC")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from RIC_ARC where 1=0"
IF !ExecCommand(cSql,"CU_RIC_ARC")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from RIC_ARC where 1=0"
IF !ExecCommand(cSql,"CUR_RIC_ARC")
   return(.f.)
ENDIF
SELECT CUR_RIC_ARC
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_RIC_ARC
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica generale " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_RIC_ARC
   APPEND BLANK
   DO RIC_ARC

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_RIC_ARC
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica generale sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','ric_arc','I','','CU_RIC_ARC')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_CONTATTI       && CONVERTE LA TABELLA CONTATTI DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CONTATTI				   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "CONTATTI"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA CONTATTI SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica contatti...  -  Prego Attendere" NOWAIT
cSql = "delete from CONTATTI where 1=1"
IF !ExecCommand(cSql,"CONTATTI")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from CONTATTI where 1=0"
IF !ExecCommand(cSql,"CU_CONTATTI")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from CONTATTI where 1=0"
IF !ExecCommand(cSql,"CUR_CONTATTI")
   return(.f.)
ENDIF
SELECT CUR_CONTATTI
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_CONTATTI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Contatto " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_CONTATTI
   APPEND BLANK
   DO CONTATTI

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_CONTATTI
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica contatti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','contatti','I','','CU_CONTATTI')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_MAILING       && CONVERTE LA TABELLA MAILING DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA MAILING				   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "MAILING"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA MAILING SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica mailing...  -  Prego Attendere" NOWAIT
cSql = "delete from MAILING where 1=1"
IF !ExecCommand(cSql,"MAILING")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from MAILING where 1=0"
IF !ExecCommand(cSql,"CU_MAILING")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from MAILING where 1=0"
IF !ExecCommand(cSql,"CUR_MAILING")
   return(.f.)
ENDIF
SELECT CUR_MAILING
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_MAILING
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Anagrafica mailing " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_MAILING
   APPEND BLANK
   DO MAILING

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_MAILING
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica mailing sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','mailing','I','','CU_MAILING')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_INDICE       && CONVERTE LA TABELLA INDICE DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE INDICE MOVIMENTI CONTABILI		   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "INDICE"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA INDICE SQL
WAIT WINDOWS "Cancellazione vecchio Indice movimenti contabili...  -  Prego Attendere" NOWAIT
cSql = "delete from INDICE where 1=1"
IF !ExecCommand(cSql,"INDICE")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from INDICE where 1=0"
IF !ExecCommand(cSql,"CU_INDICE")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from INDICE where 1=0"
IF !ExecCommand(cSql,"CUR_INDICE")
   return(.f.)
ENDIF
SELECT CUR_INDICE
SET FILTER TO
*!*	SET FILTER TO (ALLTRIM(MOV_ANNO) == _V_ANNCONV OR ALLTRIM(MOV_ANNO) == _V_ANNCONV_PRECEDENTE)
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_INDICE
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

*!*	   ** SERGIO 10/02/2005
*!*	   IF VAL(SUBSTR(MOV_DTREG,1,4)) > 2005
*!*			SELECT CUR_INDICE
*!*	        SKIP +1
*!*	        LOOP
*!*	   ENDIF
*!*	   ** SERGIO 10/02/2005


   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Indice movimenti contabili " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.MOV_ANOMAX                   = SPACE(3)
   M.MOV_CODCCO                   = SPACE(13)
   M.MOV_PRALEG                   = SPACE(1)
   M.MOV_EXTRA_NUMDOC             = SPACE(10)
   M.MOV_EXTRA_DATDOC             = SPACE(10)
   M.MOV_EXTRA_IMPDOC             = 0
   M.MOV_EXTRA_SYSDOC             = SPACE(10)
   M.MOV_NPARTO                   = 0
   M.MOV_DATSCAD                  = SPACE(10)
   M.MOV_CONTABILITA_PREVISIONALE = SPACE(1)
   M.MOV_BOLLATOIVA               = SPACE(1)
   M.MOV_CODACQ                   = SPACE(3)
   M.MOV_TIPOCONTRATTO            = SPACE(5)
   M.MOV_FORMAPAGAMENTO           = SPACE(5)
   M.MOV_GRADOIMPORTANZA          = SPACE(5)
   M.MOV_COSATRATTA               = SPACE(5)
   M.MOV_PRIPAGA                  = SPACE(4)
   M.MOV_CATEG                    = SPACE(6)
   M.MOV_CATOK                    = SPACE(6)
   M.MOV_DATES                    = SPACE(6)
   M.MOV_OKTES                    = SPACE(6)
   M.MOV_IVAOMA                   = .F.

   M.EXTRA_NUMDOC                 = M.MOV_EXTRA_NUMDOC
   M.EXTRA_DATDOC                 = M.MOV_EXTRA_DATDOC
   M.EXTRA_IMPDOC                 = M.MOV_EXTRA_IMPDOC
   M.EXTRA_SYSDOC                 = M.MOV_EXTRA_SYSDOC

   SELECT CU_INDICE
   APPEND BLANK
   DO INDICE

   REPLACE MOV_NPARTO                   WITH M.MOV_NPARTO
   REPLACE MOV_DATSCAD                  WITH M.MOV_DATSCAD
   REPLACE MOV_CONTABILITA_PREVISIONALE WITH M.MOV_CONTABILITA_PREVISIONALE
   REPLACE MOV_BOLLATOIVA               WITH M.MOV_BOLLATOIVA
   REPLACE MOV_CODACQ                   WITH M.MOV_CODACQ
   REPLACE MOV_TIPOCONTRATTO            WITH M.MOV_TIPOCONTRATTO
   REPLACE MOV_FORMAPAGAMENTO           WITH M.MOV_FORMAPAGAMENTO
   REPLACE MOV_GRADOIMPORTANZA          WITH M.MOV_GRADOIMPORTANZA
   REPLACE MOV_COSATRATTA               WITH M.MOV_COSATRATTA
   REPLACE MOV_PRIPAGA                  WITH M.MOV_PRIPAGA
   REPLACE MOV_CATEG                    WITH M.MOV_CATEG
   REPLACE MOV_CATOK                    WITH M.MOV_CATOK
   REPLACE MOV_DATES                    WITH M.MOV_DATES
   REPLACE MOV_OKTES                    WITH M.MOV_OKTES
   REPLACE MOV_IVAOMA                   WITH M.MOV_IVAOMA

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_INDICE
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Indice movimenti contabili sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','indice','I','','CU_INDICE')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_MOV_CONT       && CONVERTE LA TABELLA MOV_CONT DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE MOVIMENTI CONTABILI		   								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "MOV_CONT"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA MOV_CONT SQL
WAIT WINDOWS "Cancellazione vecchi Movimenti contabili...  -  Prego Attendere" NOWAIT
cSql = "delete from MOV_CONT where 1=1"
IF !ExecCommand(cSql,"MOV_CONT")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from MOV_CONT where 1=0"
IF !ExecCommand(cSql,"CU_MOV_CONT")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from MOV_CONT where 1=0"
IF !ExecCommand(cSql,"CUR_MOV_CONT")
   return(.f.)
ENDIF
SELECT CUR_MOV_CONT
SET FILTER TO
*!*	SET FILTER TO (ALLTRIM(MOV_ANNO) == _V_ANNCONV OR ALLTRIM(MOV_ANNO) == _V_ANNCONV_PRECEDENTE)
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

INDEX ON MOV_ANNO+MOV_NREGIS TAG I_NREGIS

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_MOV_CONT
SET ORDER TO I_NREGIS
GO TOP

V_ANNREG = ""
V_SEQUEN = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

*!*	   ** SERGIO 10/02/2005
*!*	   IF VAL(SUBSTR(MOV_DTREG,1,4)) > 2005
*!*			SELECT CUR_MOV_CONT
*!*	        SKIP +1
*!*	        LOOP
*!*	   ENDIF
*!*	   ** SERGIO 10/02/2005


   SCATTER MEMVAR MEMO

   IF V_ANNREG = M.MOV_ANNO + M.MOV_NREGIS
   ELSE
      V_SEQUEN = 0
   ENDIF

   WAIT WINDOWS "Conversione Movimento contabile " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   V_SEQUEN                       = V_SEQUEN + 10
   M.MOV_SEQUEN                   = V_SEQUEN

   M.MOV_ANNODO                   = SPACE(4)
   M.MOV_EXTRA_NUMDOC             = SPACE(10)
   M.MOV_EXTRA_DATDOC             = SPACE(10)
   M.MOV_EXTRA_IMPDOC             = 0
   M.MOV_EXTRA_SYSDOC             = SPACE(10)
   M.MOV_NPARTO                   = 0
   M.MOV_DATSCAD                  = SPACE(10)
   M.MOV_CONTABILITA_PREVISIONALE = SPACE(1)
   M.MOV_BOLLATOIVA               = SPACE(1)
   M.MOV_CODACQ                   = SPACE(3)
   M.MOV_TIPOCONTRATTO            = SPACE(5)
   M.MOV_FORMAPAGAMENTO           = SPACE(5)
   M.MOV_GRADOIMPORTANZA          = SPACE(5)
   M.MOV_COSATRATTA               = SPACE(5)
   M.MOV_PRIPAGA                  = SPACE(4)
   M.MOV_CATEG                    = SPACE(6)
   M.MOV_FATCE                    = SPACE(1)
   M.MOV_NOTCE                    = SPACE(1)
   M.MOV_FATRC                    = SPACE(1)
   M.MOV_NOTRC                    = SPACE(1)
   M.MOV_IVAOMA                   = .F.
   M.MOV_PUBBLI                   = 0
   M.MOV_NOIVA                    = SPACE(1)

   M.EXTRA_NUMDOC                 = M.MOV_EXTRA_NUMDOC
   M.EXTRA_DATDOC                 = M.MOV_EXTRA_DATDOC
   M.EXTRA_IMPDOC                 = M.MOV_EXTRA_IMPDOC
   M.EXTRA_SYSDOC                 = M.MOV_EXTRA_SYSDOC

   *** VALORI DI DEFAULT
   IF SUBSTR(M.MOV_DTDOC,3,1) = '/'
      M.MOV_ANNODO = SUBSTR(M.MOV_DTDOC,7,4)
   ELSE
      M.MOV_ANNODO = SUBSTR(M.MOV_DTDOC,1,4)
   ENDIF

   SELECT CU_MOV_CONT
   APPEND BLANK
   DO MOV_CONT

   REPLACE MOV_ANNODO                   WITH M.MOV_ANNODO
   REPLACE MOV_SEQUEN                   WITH M.MOV_SEQUEN
   REPLACE MOV_NPARTO                   WITH M.MOV_NPARTO
   REPLACE MOV_DATSCAD                  WITH M.MOV_DATSCAD
   REPLACE MOV_CONTABILITA_PREVISIONALE WITH M.MOV_CONTABILITA_PREVISIONALE
   REPLACE MOV_BOLLATOIVA               WITH M.MOV_BOLLATOIVA
   REPLACE MOV_CODACQ                   WITH M.MOV_CODACQ
   REPLACE MOV_TIPOCONTRATTO            WITH M.MOV_TIPOCONTRATTO
   REPLACE MOV_FORMAPAGAMENTO           WITH M.MOV_FORMAPAGAMENTO
   REPLACE MOV_GRADOIMPORTANZA          WITH M.MOV_GRADOIMPORTANZA
   REPLACE MOV_COSATRATTA               WITH M.MOV_COSATRATTA
   REPLACE MOV_PRIPAGA                  WITH M.MOV_PRIPAGA
   REPLACE MOV_CATEG                    WITH M.MOV_CATEG
   REPLACE MOV_FATCE                    WITH M.MOV_FATCE
   REPLACE MOV_NOTCE                    WITH M.MOV_NOTCE
   REPLACE MOV_FATRC                    WITH M.MOV_FATRC
   REPLACE MOV_NOTRC                    WITH M.MOV_NOTRC
   REPLACE MOV_IVAOMA                   WITH M.MOV_IVAOMA
   REPLACE MOV_PUBBLI                   WITH M.MOV_PUBBLI
   REPLACE MOV_NOIVA                    WITH M.MOV_NOIVA

   _V_CONTA = _V_CONTA + 1
   V_ANNREG = M.MOV_ANNO + M.MOV_NREGIS

   SELECT CUR_MOV_CONT
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dei Movimenti contabili sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','mov_cont','I','','CU_MOV_CONT')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_MOV_CCO       && CONVERTE LA TABELLA MOV_CCO DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE MOVIMENTI CENTRI DI COSTO		   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "MOV_CCO"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA MOV_CCO SQL
WAIT WINDOWS "Cancellazione vecchi Movimenti centri di costo...  -  Prego Attendere" NOWAIT
cSql = "delete from MOV_CCO where 1=1"
IF !ExecCommand(cSql,"MOV_CCO")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from MOV_CCO where 1=0"
IF !ExecCommand(cSql,"CU_MOV_CCO")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from MOV_CCO where 1=0"
IF !ExecCommand(cSql,"CUR_MOV_CCO")
   return(.f.)
ENDIF
SELECT CUR_MOV_CCO
SET FILTER TO
*!*	SET FILTER TO (ALLTRIM(MOV_ANNO) == _V_ANNCONV OR ALLTRIM(MOV_ANNO) == _V_ANNCONV_PRECEDENTE)
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_MOV_CCO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Movimento centri di costo " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.MOV_CODGRU                   = SPACE(10)
   M.MOV_PERCEN                   = 0
   M.MOV_CONTABILITA_PREVISIONALE = SPACE(1)
   M.MOV_BOLLATOIVA               = SPACE(1)
   M.MOV_CODACQ                   = SPACE(3)
   M.MOV_TIPOCONTRATTO            = SPACE(5)
   M.MOV_FORMAPAGAMENTO           = SPACE(5)
   M.MOV_GRADOIMPORTANZA          = SPACE(5)
   M.MOV_COSATRATTA               = SPACE(5)
   M.MOV_PRIPAGA                  = SPACE(4)
   M.MOV_PUBBLI                   = 0

   SELECT CU_MOV_CCO
   APPEND BLANK
   DO MOV_CCO

   REPLACE MOV_CONTABILITA_PREVISIONALE WITH M.MOV_CONTABILITA_PREVISIONALE
   REPLACE MOV_BOLLATOIVA               WITH M.MOV_BOLLATOIVA
   REPLACE MOV_CODACQ                   WITH M.MOV_CODACQ
   REPLACE MOV_TIPOCONTRATTO            WITH M.MOV_TIPOCONTRATTO
   REPLACE MOV_FORMAPAGAMENTO           WITH M.MOV_FORMAPAGAMENTO
   REPLACE MOV_GRADOIMPORTANZA          WITH M.MOV_GRADOIMPORTANZA
   REPLACE MOV_COSATRATTA               WITH M.MOV_COSATRATTA
   REPLACE MOV_PRIPAGA                  WITH M.MOV_PRIPAGA
   REPLACE MOV_PUBBLI                   WITH M.MOV_PUBBLI

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_MOV_CCO
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dei Movimenti centri di costo sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','mov_cco','I','','CU_MOV_CCO')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_PART_CLI       && CONVERTE LA TABELLA PART_CLI DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE PARTITARIO CLIENTI				   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "PART_CLI"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PART_CLI SQL
WAIT WINDOWS "Cancellazione vecchio Partitario clienti...  -  Prego Attendere" NOWAIT
cSql = "delete from PART_CLI where 1=1"
IF !ExecCommand(cSql,"PART_CLI")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PART_CLI where 1=0"
IF !ExecCommand(cSql,"CU_PART_CLI")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from PART_CLI where 1=0"
IF !ExecCommand(cSql,"CUR_PART_CLI")
   return(.f.)
ENDIF
SELECT CUR_PART_CLI
SET FILTER TO
*!*	SET FILTER TO ALLTRIM(PAR_ANNO) == _V_ANNCONV
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_PART_CLI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

*!*	   ** SERGIO 10/02/2005
*!*	   IF VAL(SUBSTR(PAR_DTREG,1,4)) > 2005
*!*			SELECT CUR_PART_CLI
*!*	        SKIP +1
*!*	        LOOP
*!*	   ENDIF
*!*	   ** SERGIO 10/02/2005



   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga del Partitario clienti " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.PAR_CONTABILITA_PREVISIONALE = SPACE(1)
   M.PAR_NPARTO                   = 0
   M.PAR_CODACQ                   = SPACE(3)
   M.PAR_TIPOCONTRATTO            = SPACE(5)
   M.PAR_FORMAPAGAMENTO           = SPACE(5)
   M.PAR_GRADOIMPORTANZA          = SPACE(5)
   M.PAR_COSATRATTA               = SPACE(5)
   M.PAR_PRIPAGA                  = SPACE(4)
   M.PAR_FATTD                    = 0
   M.PAR_FATTA                    = 0
   M.PAR_ANOMAX                   = SPACE(3)

   SELECT CU_PART_CLI
   APPEND BLANK
   DO PART_CLI

   REPLACE PAR_CONTABILITA_PREVISIONALE WITH M.PAR_CONTABILITA_PREVISIONALE
   REPLACE PAR_NPARTO                   WITH M.PAR_NPARTO
   REPLACE PAR_CODACQ                   WITH M.PAR_CODACQ
   REPLACE PAR_TIPOCONTRATTO            WITH M.PAR_TIPOCONTRATTO
   REPLACE PAR_FORMAPAGAMENTO           WITH M.PAR_FORMAPAGAMENTO
   REPLACE PAR_GRADOIMPORTANZA          WITH M.PAR_GRADOIMPORTANZA
   REPLACE PAR_COSATRATTA               WITH M.PAR_COSATRATTA
   REPLACE PAR_PRIPAGA                  WITH M.PAR_PRIPAGA
   REPLACE PAR_FATTD                    WITH M.PAR_FATTD
   REPLACE PAR_FATTA                    WITH M.PAR_FATTA
   REPLACE PAR_ANOMAX                   WITH M.PAR_ANOMAX

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_PART_CLI
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio del Partitario clienti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','part_cli','I','','CU_PART_CLI')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_PART_FOR       && CONVERTE LA TABELLA PART_FOR DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE PARTITARIO FORNITORI			   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "PART_FOR"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PART_FOR SQL
WAIT WINDOWS "Cancellazione vecchio Partitario fornitori...  -  Prego Attendere" NOWAIT
cSql = "delete from PART_FOR where 1=1"
IF !ExecCommand(cSql,"PART_FOR")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PART_FOR where 1=0"
IF !ExecCommand(cSql,"CU_PART_FOR")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from PART_FOR where 1=0"
IF !ExecCommand(cSql,"CUR_PART_FOR")
   return(.f.)
ENDIF
SELECT CUR_PART_FOR
SET FILTER TO
*!*	SET FILTER TO ALLTRIM(PAR_ANNO) == _V_ANNCONV
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_PART_FOR
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

*!*	   ** SERGIO 10/02/2005
*!*	   IF VAL(SUBSTR(PAR_DTREG,1,4)) > 2005
*!*			SELECT CUR_PART_FOR
*!*	        SKIP +1
*!*	        LOOP
*!*	   ENDIF
*!*	   ** SERGIO 10/02/2005


   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga del Partitario fornitori " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.PAR_NPARTO                   = 0
   M.PAR_CONTABILITA_PREVISIONALE = SPACE(1)
   M.PAR_CODACQ                   = SPACE(3)
   M.PAR_TIPOCONTRATTO            = SPACE(5)
   M.PAR_FORMAPAGAMENTO           = SPACE(5)
   M.PAR_GRADOIMPORTANZA          = SPACE(5)
   M.PAR_COSATRATTA               = SPACE(5)
   M.PAR_PRIPAGA                  = SPACE(4)
   M.PAR_FATTD                    = 0
   M.PAR_FATTA                    = 0
   M.PAR_ANOMAX                   = SPACE(3)

   SELECT CU_PART_FOR
   APPEND BLANK
   DO PART_FOR

   REPLACE PAR_NPARTO                   WITH M.PAR_NPARTO
   REPLACE PAR_CONTABILITA_PREVISIONALE WITH M.PAR_CONTABILITA_PREVISIONALE
   REPLACE PAR_CODACQ                   WITH M.PAR_CODACQ
   REPLACE PAR_TIPOCONTRATTO            WITH M.PAR_TIPOCONTRATTO
   REPLACE PAR_FORMAPAGAMENTO           WITH M.PAR_FORMAPAGAMENTO
   REPLACE PAR_GRADOIMPORTANZA          WITH M.PAR_GRADOIMPORTANZA
   REPLACE PAR_COSATRATTA               WITH M.PAR_COSATRATTA
   REPLACE PAR_PRIPAGA                  WITH M.PAR_PRIPAGA
   REPLACE PAR_FATTD                    WITH M.PAR_FATTD
   REPLACE PAR_FATTA                    WITH M.PAR_FATTA
   REPLACE PAR_ANOMAX                   WITH M.PAR_ANOMAX

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_PART_FOR
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio del Partitario fornitori sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','part_for','I','','CU_PART_FOR')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_SALDI_FOR       && CONVERTE LA TABELLA SALDI_FOR DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE SALDI FORNITORI					   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

DO FORM FORM\ATTENDI LINKED
CREA_SALDI_CF("F","TUTTO",'99999998',"XXXXXXXXXX","CREA","NO","ESTRAITUTTELEPARTITE")		&& ANNULLA E RICREA TUTTE LE PARTITE

RETURN



*************************************************************************************************
PROCEDURE CONV_SALDI_CLI       && CONVERTE LA TABELLA SALDI_CLI DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE SALDI FORNITORI					   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

DO FORM FORM\ATTENDI LINKED
CREA_SALDI_CF("C","TUTTO",'99999998',"XXXXXXXXXX","CREA","NO","ESTRAITUTTELEPARTITE")		&& ANNULLA E RICREA TUTTE LE PARTITE

*!*	PUB_ERRORE=MESSAGEBOX('Funzione terminata correttamente',64,'*** ATTENZIONE ***')

RETURN



*************************************************************************************************
PROCEDURE CONV_U_IVA_CL       && CONVERTE LA TABELLA U_IVA_CL DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE IVA CLIENTI						   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_IVA_CL"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_IVA_CL SQL
WAIT WINDOWS "Cancellazione vecchia Iva clienti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_IVA_CL where 1=1"
IF !ExecCommand(cSql,"U_IVA_CL")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_IVA_CL where 1=0"
IF !ExecCommand(cSql,"CU_IVA_CL")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_IVA_CL where 1=0"
IF !ExecCommand(cSql,"CUR_IVA_CL")
   return(.f.)
ENDIF
SELECT CUR_IVA_CL
SET FILTER TO
**SET FILTER TO (ALLTRIM(IVA_ANNO) == _V_ANNCONV OR ALLTRIM(IVA_ANNO) == _V_ANNCONV_PRECEDENTE)
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_IVA_CL
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Iva clienti " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.IVA_BOLLATOIVA = SPACE(1)
   M.IVA_TOP        = SPACE(10)
   M.IVA_NUMNEW     = 0

   SELECT CU_IVA_CL
   APPEND BLANK
   DO U_IVA_CL

   REPLACE IVA_BOLLATOIVA WITH M.IVA_BOLLATOIVA
   REPLACE IVA_TOP        WITH M.IVA_TOP
   REPLACE IVA_NUMNEW     WITH M.IVA_NUMNEW

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_IVA_CL
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Iva clienti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_iva_cl','I','','CU_IVA_CL')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN





*************************************************************************************************
PROCEDURE CONV_U_IVF_CL       && CONVERTE LA TABELLA U_IVF_CL DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE IVA FORNITORI					   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_IVF_CL"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_IVF_CL SQL
WAIT WINDOWS "Cancellazione vecchia Iva fornitori...  -  Prego Attendere" NOWAIT
cSql = "delete from U_IVF_CL where 1=1"
IF !ExecCommand(cSql,"U_IVF_CL")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_IVF_CL where 1=0"
IF !ExecCommand(cSql,"CU_IVF_CL")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_IVF_CL where 1=0"
IF !ExecCommand(cSql,"CUR_IVF_CL")
   return(.f.)
ENDIF
SELECT CUR_IVF_CL
SET FILTER TO
**SET FILTER TO (ALLTRIM(IVF_ANNO) == _V_ANNCONV OR ALLTRIM(IVF_ANNO) == _V_ANNCONV_PRECEDENTE)
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_IVF_CL
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dell'Iva fornitori " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.IVF_NUMNEW = 0

   SELECT CU_IVF_CL
   APPEND BLANK
   DO U_IVF_CL

   REPLACE IVF_NUMNEW WITH M.IVF_NUMNEW

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_IVF_CL
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Iva fornitori sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_ivf_cl','I','','CU_IVF_CL')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_IVA_TO       && CONVERTE LA TABELLA U_IVA_TO DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE IVA RIEPILOGHI IVA				   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_IVA_TO"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_IVA_TO SQL
WAIT WINDOWS "Cancellazione vecchi Riepiloghi iva...  -  Prego Attendere" NOWAIT
cSql = "delete from U_IVA_TO where 1=1"
IF !ExecCommand(cSql,"U_IVA_TO")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_IVA_TO where 1=0"
IF !ExecCommand(cSql,"CU_IVA_TO")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_IVA_TO where 1=0"
IF !ExecCommand(cSql,"CUR_IVA_TO")
   return(.f.)
ENDIF
SELECT CUR_IVA_TO
SET FILTER TO
**SET FILTER TO (ALLTRIM(ITO_ANNO) == _V_ANNCONV OR ALLTRIM(ITO_ANNO) == _V_ANNCONV_PRECEDENTE)
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_IVA_TO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga dei Riepiloghi iva " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_IVA_TO
   APPEND BLANK
   DO U_IVA_TO

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_IVA_TO
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dei Riepiloghi iva sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_iva_to','I','','CU_IVA_TO')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_CHIUSURA       && CONVERTE LA TABELLA CHIUSURA DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE CHIUSURA CONTABILE FINE ANNO	   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "CHIUSURA"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA CHIUSURA SQL
WAIT WINDOWS "Cancellazione vecchia Chiusura contabile fine anno...  -  Prego Attendere" NOWAIT
cSql = "delete from CHIUSURA where 1=1"
IF !ExecCommand(cSql,"CHIUSURA")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from CHIUSURA where 1=0"
IF !ExecCommand(cSql,"CU_CHIUSURA")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from CHIUSURA where 1=0"
IF !ExecCommand(cSql,"CUR_CHIUSURA")
   return(.f.)
ENDIF
SELECT CUR_CHIUSURA
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_CHIUSURA
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga della Chiusura contabile fine anno " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_CHIUSURA
   APPEND BLANK
   DO CHIUSURA

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_CHIUSURA
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio della Chiusura contabile fine anno sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','chiusura','I','','CU_CHIUSURA')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_OFF_TT_DD       && CONVERTE LE TABELLE U_OFF_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE OFFERTE CLIENTI			   								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_OFF_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_OFF_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_OFF_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Offerte clienti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_OFF_TT where 1=1"
IF !ExecCommand(cSql,"U_OFF_TT")
   return(.f.)
ENDIF
cSql = "delete from U_OFF_DD where 1=1"
IF !ExecCommand(cSql,"U_OFF_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMOFF'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMOFF'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_OFF_TT where 1=0"
IF !ExecCommand(cSql,"CU_OFF_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_OFF_DD where 1=0"
IF !ExecCommand(cSql,"CU_OFF_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_OFF_TT where 1=0"
IF !ExecCommand(cSql,"CUR_OFF_TT")
   return(.f.)
ENDIF
SELECT CUR_OFF_TT
SET FILTER TO
*SET FILTER TO SUBSTR(ORD_DATORD,7,4) == _V_ANNCONV
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_OFF_DD where 1=0"
IF !ExecCommand(cSql,"CUR_OFF_DD")
   return(.f.)
ENDIF
SELECT CUR_OFF_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_OFF_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga offerta clienti " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO  = STR(NEWPROG('NUMOFF'),10)
   M.ORD_FLGINC = .F.
   M.ORD_TRASME = .F.
   M.ORD_ANNO   = SPACE(4)
   M.ORD_PROVIN = SPACE(2)
   M.ORD_PROC   = SPACE(2)

   SELECT CU_OFF_TT
   APPEND BLANK
   DO U_OFF_TT

   SELECT CUR_OFF_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_OFF_TT
      SKIP +1
      LOOP
   ENDIF

   V_SEQUEN     = 0

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      V_SEQUEN     = V_SEQUEN + 10
      M.ORD_SEQUEN = V_SEQUEN

      M.DAGGANCIO  = M.TAGGANCIO
      M.ORD_CODTAG = SPACE(3)
      M.ORD_DESTAG = SPACE(30)
      M.ORD_CODCOL = SPACE(3)
      M.ORD_DESCOL = SPACE(30)
      M.ORD_TRASMD = .F.
      M.ORD_LEGSYS = SPACE(10)
      M.ORD_FLGMOD = SPACE(1)

	  IF ALLTRIM(M.ORD_UM) = "N"	&& 2012/10/11 FORZA COME UNITA' DI MISURA NR
	  	 M.ORD_UM = "NR"
	  ENDIF

      SELECT CU_OFF_DD
      APPEND BLANK
      DO U_OFF_DD

*!*	      REPLACE ORD_VETTO3 WITH M.ORD_VETTO3
*!*	      REPLACE ORD_LISTIN WITH M.ORD_LISTIN
*!*	      REPLACE ORD_ALTDES WITH M.ORD_ALTDES
*!*	      REPLACE ORD_CODLOC WITH M.ORD_CODLOC

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_OFF_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_OFF_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle Offerte clienti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_off_tt','I','','CU_OFF_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_off_dd','I','','CU_OFF_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_ORD_TT_DD_QUIMARI       && CONVERTE LE TABELLE U_ORD_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ORDINI CLIENTI			   								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_ORD_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_ORD_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_ORD_TT/DD SQL
*!*	WAIT WINDOWS "Cancellazione vecchi Ordini clienti...  -  Prego Attendere" NOWAIT
*!*	cSql = "delete from U_ORD_TT where 1=1"
*!*	IF !ExecCommand(cSql,"U_ORD_TT")
*!*	   return(.f.)
*!*	ENDIF
*!*	cSql = "delete from U_ORD_DD where 1=1"
*!*	IF !ExecCommand(cSql,"U_ORD_DD")
*!*	   return(.f.)
*!*	ENDIF
*!*	x_codi = "codice = 'NUMORD'"
*!*	x_cond = x_codi
*!*	cSql = "select * from PARA where " + x_cond
*!*	IF !ExecRW(cSql,"PARA","R")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT PARA
*!*	GO TOP
*!*	IF EOF()
*!*	   APPEND BLANK
*!*	   V1 = 'NUMORD'
*!*	   REPLACE CODICE WITH V1
*!*	   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
*!*	ENDIF
*!*	REPLACE LIBERA WITH "5000000000"
*!*	IF !ExecRW(cSql,"PARA","W")
*!*	   return(.f.)
*!*	ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_ORD_TT where 1=0"
IF !ExecCommand(cSql,"CU_ORD_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_ORD_DD where 1=0"
IF !ExecCommand(cSql,"CU_ORD_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_ORD_TT where 1=0"
IF !ExecCommand(cSql,"CUR_ORD_TT")
   return(.f.)
ENDIF
SELECT CUR_ORD_TT
INDEX ON ORD_ANNO TAG I_ANNO

SET FILTER TO
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
cSql = "Select * from U_ORD_DD where 1=0"
IF !ExecCommand(cSql,"CUR_ORD_DD")
   return(.f.)
ENDIF
SELECT CUR_ORD_DD
INDEX ON DAGGANCIO TAG I_INDICE
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND



_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_ORD_TT
SET ORDER TO I_ANNO
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Ordine cliente " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD  = M.TAGGANCIO
   _X_CHIUSOTT = M.ORD_CHIUSO

   M.TAGGANCIO  = STR(NEWPROG('NUMORD'),10)
   M.ORD_TOTIMB = 0
   M.ORD_PESEST = 0
   M.ORD_CODIMB = SPACE(3)
   M.ORD_CLIFAT = SPACE(10)
   M.ORD_RAGFAT = SPACE(40)
   M.ORD_FLFATT = .F.
   M.ORD_RATEO1 = 0
   M.ORD_DATRA1 = SPACE(10)
   M.ORD_RATEO2 = 0
   M.ORD_DATRA2 = SPACE(10)
   M.ORD_RATEO3 = 0
   M.ORD_DATRA3 = SPACE(10)
   M.ORD_RATEO4 = 0
   M.ORD_DATRA4 = SPACE(10)
   M.ORD_RATEO5 = 0
   M.ORD_DATRA5 = SPACE(10)
   M.ORD_RATEO6 = 0
   M.ORD_DATRA6 = SPACE(10)
   M.ORD_TOTRAT = 0
   M.ORD_FLGINC = .F.
   M.ORD_TRASME = .F.
   M.ORD_ANNO   = SPACE(4)
   M.ORD_CODSYS = SPACE(10)
   M.ORD_PROVIN = SPACE(2)
   M.ORD_PROC   = SPACE(2)
   M.ORD_ACCONT = 0
   M.ORD_DATACC = SPACE(10)
   M.ORD_NUMSCO = SPACE(10)
   M.ORD_FLGACC = .F.
   M.ORD_DATRIM = SPACE(10)
   M.ORD_FLGRIM = .F.
   M.ORD_FLGTRA = .F.
   M.ORD_CODBUN = SPACE(10)
   M.ORD_DESBUN = SPACE(50)
   M.ORD_ACCRES = 0
   M.ORD_TPORDI = SPACE(1)
   M.ORD_DSORDI = SPACE(30)
   M.ORD_FLGABP = .F.
   M.ORD_PKLOK  = SPACE(1)
   M.T_OMAGGIO  = 0
   M.I_OMAGGIO  = 0
   M.ORD_FLGCON = .F.
   M.ORD_CDIMBA = SPACE(3)

   *** VALORI DI DEFAULT
   M.ORD_NUMORD = TRC(6,ALLTRIM(M.ORD_NUMORD))
   M.TNUMERO    = M.ORD_NUMORD
   IF SUBSTR(M.ORD_DATORD,3,1) = '/'
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,7,4)
   ELSE
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,1,4)
   ENDIF
   M.ORD_CODSYS = SYS(2015)
   M.ORD_FLGCON = .T.
   X_NUMORD = M.ORD_NUMORD
   X_DATORD = M.ORD_DATORD
   X_MAGS   = M.ORD_MAGS
   X_MAGD   = M.ORD_MAGD
   X_CODCLI = M.ORD_CODCLI
   X_RAGSOC = M.ORD_RAGSOC
   X_CODEMI = M.ORD_CODEMI
   X_RAGEMI = M.ORD_RAGEMI
   X_TIPORD = M.ORD_TIPORD
   X_FLGABP = M.ORD_FLGABP
   IF M.ORD_LOCC = SPACE(70) .OR. EMPTY(M.ORD_LOCC)
      X_DESTIN = M.ORD_LOCALI
   ELSE
      X_DESTIN = M.ORD_LOCC
   ENDIF

*!*	   IF M.ORD_ANNO = PUB_ANNO .OR. M.ORD_ANNO = PUB_ANNOP				&& ELABORA SOLO GLI ORDINI DEGLI ULTIMI DUE ANNI
*!*	   ELSE
*!*	   	  SELECT CUR_ORD_TT
*!*	   	  SKIP +1
*!*	   	  LOOP
*!*	   ENDIF

   IF VAL(M.ORD_ANNO) < 2010				&& ELABORA SOLO GLI ORDINI DEGLI ULTIMI DUE ANNI
   	  SELECT CUR_ORD_TT
   	  SKIP +1
   	  LOOP
   ENDIF

   IF RIBALTA2(M.ORD_DATORD) > "2012/01/01"
   	  SELECT CUR_ORD_TT
   	  SKIP +1
   	  LOOP
   ENDIF




   SELECT CU_ORD_TT
   APPEND BLANK
   DO U_ORD_TT

   REPLACE ORD_PKLOK  WITH M.ORD_PKLOK
   REPLACE ORD_CDIMBA WITH M.ORD_CDIMBA

   SELECT CUR_ORD_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_ORD_TT
      SKIP +1
      LOOP
   ENDIF

   V_SEQUEN     = 0
   _X_ULTCODSYS = SPACE(10)

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      _X_CHIUSODD  = M.ORD_CHIUSO

      V_SEQUEN     = V_SEQUEN + 10
      M.ORD_SEQUEN = V_SEQUEN

      M.DAGGANCIO  = M.TAGGANCIO
      M.ORD_PESOUM = 0
      M.ORD_CODIMB = SPACE(3)
      M.ORD_IMBNET = 0
      M.ORD_IMBLOR = 0
      M.ORD_FLGCOM = .F.
      M.ORD_PADRE  = SPACE(16)
      M.ORS_VALUTA = SPACE(3)
      M.ORD_NUMBOL = SPACE(6)
      M.ORD_DATBOL = SPACE(10)
      M.ORD_QTABOL = 0
      M.ORD_QTADAC = 0
      M.ORD_FLFATD = .F.
      M.ORD_CODTAG = SPACE(3)
      M.ORD_DESTAG = SPACE(30)
      M.ORD_CODCOL = SPACE(3)
      M.ORD_DESCOL = SPACE(30)
      M.ORD_TRASMD = .F.
      M.ORD_QTAACC = 0
      M.ORD_LEGSYS = SPACE(10)
      M.ORD_FLGMOD = SPACE(1)
      M.ORD_CODMAT = SPACE(3)
      M.ORD_DESMAT = SPACE(30)
      M.ORD_SPESSO = 0
      M.ORD_ALTEZZ = 0
      M.ORD_LUNGHE = 0
      M.ORD_NUMBOB = 0
      M.ORD_NUMBOE = 0
      M.ORD_NUMBOD = 0
      M.ORD_QTAKG  = 0
      M.ORD_QTAMQ  = 0
      M.ORD_QTAML  = 0
      M.ORD_QTAKG1 = 0
      M.ORD_QTAMQ1 = 0
      M.ORD_QTAML1 = 0
      M.ORD_QTAKGE = 0
      M.ORD_QTAMQE = 0
      M.ORD_QTAMLE = 0
      M.ORD_QTAKGD = 0
      M.ORD_QTAMQD = 0
      M.ORD_QTAMLD = 0
      M.ORD_CONFER = SPACE(1)
      M.ORD_SALCON = SPACE(1)
      M.ORD_NOTEBO = ""
      M.ORD_DESIMB = SPACE(30)
      M.ORD_LOTMIN = 0
      M.ORD_DTINPR = SPACE(10)
      M.ORD_DTFIPR = SPACE(10)
      M.ORD_FLGPRG = 0
      M.ORD_FLGAVA = 0
      M.ORD_NUMPRG = SPACE(6)
      M.ORD_DATPRG = SPACE(10)
      M.ORD_SEIPRG = SPACE(7)
      M.ORD_SEFPRG = SPACE(7)
      M.ORD_DAIPRG = SPACE(10)
      M.ORD_DAFPRG = SPACE(10)
      M.ORD_NRBOBP = 0
      M.ORD_QUANTP = 0
      M.ORD_NRBOBF = 0
      M.ORD_QUANTF = 0
      M.ORD_NRBOBD = 0
      M.ORD_QUANTD = 0
      M.ORD_SETTPR = SPACE(7)
      M.ORD_SETTCC = SPACE(7)
      M.ORD_NRBOBX = 0
      M.ORD_QUANTX = 0
      M.ORD_SETTCX = SPACE(7)
      M.ORD_NRBOBO = 0
      M.ORD_QUANTO = 0
      M.ORD_NRBOBY = 0
      M.ORD_QUANTY = 0
      M.ORD_NRBSPD = 0
      M.ORD_QTASPD = 0
      M.ORD_NRBSPP = 0
      M.ORD_QTASPP = 0
      M.ORD_NRBRID = 0
      M.ORD_QTARID = 0
      M.ORD_NRBRIP = 0
      M.ORD_QTARIP = 0
      M.ORD_NRBTGO = 0
      M.ORD_QTATGO = 0
      M.ORD_NRBTGD = 0
      M.ORD_QTATGD = 0
      M.ORD_NRBTGP = 0
      M.ORD_QTATGP = 0
      M.ORD_CDAPRD = SPACE(16)
      M.ORD_DSAPRD = SPACE(50)
      M.ORS_FLGABP = .F.
      M.ORD_FLGCEL = .F.
      M.ORD_SERBOL = SPACE(3)
      M.ORD_AAPROD = 0
      M.ORD_SERNUM = SPACE(3)
      M.ORD_NUMEDA = 0
      M.ORD_NUMEAL = 0
      M.ORD_CBFISC = SPACE(50)
      M.ORD_PKLOK  = SPACE(1)
      M.ORD_QTAPCK = 0
      M.ORD_PUBBLI = SPACE(1)

      *** VALORI DI DEFAULT
      M.ORD_CODSYS = SYS(2015)
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + M.ORD_CODART + "'"
      x_cond = x_soci + " and " + x_codi
      cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
      IF !ExecCommand(cSql,"CUR_ARTICOLI")
         RETURN .F.
      ENDIF
      SELECT CUR_ARTICOLI
      GO TOP
      IF !EOF()
         M.ORD_CODMAT = ART_CODMAT
         M.ORD_DESMAT = ART_DESMAT
         M.ORD_CODCOL = ART_CODCOL
         M.ORD_DESCOL = ART_DESCOL
         M.ORD_SPESSO = ART_SPESSO
         M.ORD_ALTEZZ = ART_ALTEZZ
         M.ORD_LUNGHE = ART_LUNGHE
         M.ORD_CODIMB = ART_CODIMB
         M.ORD_DESIMB = ART_DESIMB
         M.ORD_LOTMIN = ART_LOTMIN
      ENDIF

      M.ORS_NUMORD = X_NUMORD
      M.ORS_DATORD = X_DATORD
      M.ORS_MAGS   = X_MAGS
      M.ORS_MAGD   = X_MAGD
      M.ORS_CODCLI = X_CODCLI
      M.ORS_RAGSOC = X_RAGSOC
      M.ORS_CODEMI = X_CODEMI
      M.ORS_RAGEMI = X_RAGEMI
      M.ORS_TIPORD = X_TIPORD
      M.ORS_DESTIN = X_DESTIN
      M.ORS_FLGABP = X_FLGABP
      M.ORD_CDAPRD = M.ORD_CODART
      M.ORD_DSAPRD = M.ORD_DESART

      IF _X_CHIUSOTT
         M.ORD_SALCON = 'S'
      ELSE
         IF _X_CHIUSODD
            M.ORD_SALCON = 'S'
         ELSE
            IF M.ORD_QTAEV >= M.ORD_QTAORD
               M.ORD_SALCON = 'S'
            ENDIF
         ENDIF
      ENDIF


	  IF ALLTRIM(M.ORD_UM) = "N"	&& 2012/10/11 FORZA COME UNITA' DI MISURA NR
	  	 M.ORD_UM = "NR"
	  ENDIF

      SELECT CU_ORD_DD
      APPEND BLANK
      DO U_ORD_DD

      REPLACE ORD_PKLOK  WITH M.ORD_PKLOK
      REPLACE ORD_QTAPCK WITH M.ORD_QTAPCK


      _X_ULTCODSYS = M.ORD_CODSYS

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_ORD_DD
      SKIP +1
   ENDDO

   SELECT CU_ORD_TT
   REPLACE ORD_CODSYS WITH _X_ULTCODSYS



   _V_CONTA1 = _V_CONTA1 + 1



   SELECT CUR_ORD_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi degli Ordini clienti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_ord_tt','I','','CU_ORD_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_ord_dd','I','','CU_ORD_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.

ENDIF

RETURN

*************************************************************************************************
PROCEDURE CONV_U_ORD_TT_DD       && CONVERTE LE TABELLE U_ORD_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ORDINI CLIENTI			   								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_ORD_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_ORD_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_ORD_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchi Ordini clienti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_ORD_TT where 1=1"
IF !ExecCommand(cSql,"U_ORD_TT")
   return(.f.)
ENDIF
cSql = "delete from U_ORD_DD where 1=1"
IF !ExecCommand(cSql,"U_ORD_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMORD'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMORD'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_ORD_TT where 1=0"
IF !ExecCommand(cSql,"CU_ORD_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_ORD_DD where 1=0"
IF !ExecCommand(cSql,"CU_ORD_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_ORD_TT where 1=0"
IF !ExecCommand(cSql,"CUR_ORD_TT")
   return(.f.)
ENDIF
SELECT CUR_ORD_TT
INDEX ON ORD_ANNO TAG I_ANNO

SET FILTER TO
*SET FILTER TO SUBSTR(ORD_DATORD,7,4) < _V_ANNCONV
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_ORD_DD where 1=0"
IF !ExecCommand(cSql,"CUR_ORD_DD")
   return(.f.)
ENDIF
SELECT CUR_ORD_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012


_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_ORD_TT
SET ORDER TO I_ANNO

GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Ordine cliente " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD  = M.TAGGANCIO
   _X_CHIUSOTT = M.ORD_CHIUSO

   M.TAGGANCIO  = STR(NEWPROG('NUMORD'),10)
   M.ORD_TOTIMB = 0
   M.ORD_PESEST = 0
   M.ORD_CODIMB = SPACE(3)
   M.ORD_CLIFAT = SPACE(10)
   M.ORD_RAGFAT = SPACE(40)
   M.ORD_FLFATT = .F.
   M.ORD_RATEO1 = 0
   M.ORD_DATRA1 = SPACE(10)
   M.ORD_RATEO2 = 0
   M.ORD_DATRA2 = SPACE(10)
   M.ORD_RATEO3 = 0
   M.ORD_DATRA3 = SPACE(10)
   M.ORD_RATEO4 = 0
   M.ORD_DATRA4 = SPACE(10)
   M.ORD_RATEO5 = 0
   M.ORD_DATRA5 = SPACE(10)
   M.ORD_RATEO6 = 0
   M.ORD_DATRA6 = SPACE(10)
   M.ORD_TOTRAT = 0
   M.ORD_FLGINC = .F.
   M.ORD_TRASME = .F.
   M.ORD_ANNO   = SPACE(4)
   M.ORD_CODSYS = SPACE(10)
   M.ORD_PROVIN = SPACE(2)
   M.ORD_PROC   = SPACE(2)
   M.ORD_ACCONT = 0
   M.ORD_DATACC = SPACE(10)
   M.ORD_NUMSCO = SPACE(10)
   M.ORD_FLGACC = .F.
   M.ORD_DATRIM = SPACE(10)
   M.ORD_FLGRIM = .F.
   M.ORD_FLGTRA = .F.
   M.ORD_CODBUN = SPACE(10)
   M.ORD_DESBUN = SPACE(50)
   M.ORD_ACCRES = 0
   M.ORD_TPORDI = SPACE(1)
   M.ORD_DSORDI = SPACE(30)
   M.ORD_FLGABP = .F.
   M.ORD_PKLOK  = SPACE(1)
   M.T_OMAGGIO  = 0
   M.I_OMAGGIO  = 0
   M.ORD_FLGCON = .F.
   M.ORD_CDIMBA = SPACE(3)

   *** VALORI DI DEFAULT
   M.ORD_NUMORD = TRC(6,ALLTRIM(M.ORD_NUMORD))
   M.TNUMERO    = M.ORD_NUMORD
   IF SUBSTR(M.ORD_DATORD,3,1) = '/'
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,7,4)
   ELSE
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,1,4)
   ENDIF
   M.ORD_CODSYS = SYS(2015)
   M.ORD_FLGCON = .T.
   X_NUMORD = M.ORD_NUMORD
   X_DATORD = M.ORD_DATORD
   X_MAGS   = M.ORD_MAGS
   X_MAGD   = M.ORD_MAGD
   X_CODCLI = M.ORD_CODCLI
   X_RAGSOC = M.ORD_RAGSOC
   X_CODEMI = M.ORD_CODEMI
   X_RAGEMI = M.ORD_RAGEMI
   X_TIPORD = M.ORD_TIPORD
   X_FLGABP = M.ORD_FLGABP
   IF M.ORD_LOCC = SPACE(70) .OR. EMPTY(M.ORD_LOCC)
      X_DESTIN = M.ORD_LOCALI
   ELSE
      X_DESTIN = M.ORD_LOCC
   ENDIF

   IF M.ORD_ANNO = PUB_ANNO .OR. M.ORD_ANNO = PUB_ANNOP				&& ELABORA SOLO GLI ORDINI DEGLI ULTIMI DUE ANNI
   ELSE
   	  SELECT CUR_ORD_TT
   	  SKIP +1
   	  LOOP
   ENDIF

   SELECT CU_ORD_TT
   APPEND BLANK
   DO U_ORD_TT

   REPLACE ORD_PKLOK  WITH M.ORD_PKLOK
   REPLACE ORD_CDIMBA WITH M.ORD_CDIMBA

   SELECT CUR_ORD_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_ORD_TT
      SKIP +1
      LOOP
   ENDIF

   V_SEQUEN     = 0
   _X_ULTCODSYS = SPACE(10)

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      _X_CHIUSODD  = M.ORD_CHIUSO

      V_SEQUEN     = V_SEQUEN + 10
      M.ORD_SEQUEN = V_SEQUEN

      M.DAGGANCIO  = M.TAGGANCIO
      M.ORD_PESOUM = 0
      M.ORD_CODIMB = SPACE(3)
      M.ORD_IMBNET = 0
      M.ORD_IMBLOR = 0
      M.ORD_FLGCOM = .F.
      M.ORD_PADRE  = SPACE(16)
      M.ORS_VALUTA = SPACE(3)
      M.ORD_NUMBOL = SPACE(6)
      M.ORD_DATBOL = SPACE(10)
      M.ORD_QTABOL = 0
      M.ORD_QTADAC = 0
      M.ORD_FLFATD = .F.
      M.ORD_CODTAG = SPACE(3)
      M.ORD_DESTAG = SPACE(30)
      M.ORD_CODCOL = SPACE(3)
      M.ORD_DESCOL = SPACE(30)
      M.ORD_TRASMD = .F.
      M.ORD_QTAACC = 0
      M.ORD_LEGSYS = SPACE(10)
      M.ORD_FLGMOD = SPACE(1)
      M.ORD_CODMAT = SPACE(3)
      M.ORD_DESMAT = SPACE(30)
      M.ORD_SPESSO = 0
      M.ORD_ALTEZZ = 0
      M.ORD_LUNGHE = 0
      M.ORD_NUMBOB = 0
      M.ORD_NUMBOE = 0
      M.ORD_NUMBOD = 0
      M.ORD_QTAKG  = 0
      M.ORD_QTAMQ  = 0
      M.ORD_QTAML  = 0
      M.ORD_QTAKG1 = 0
      M.ORD_QTAMQ1 = 0
      M.ORD_QTAML1 = 0
      M.ORD_QTAKGE = 0
      M.ORD_QTAMQE = 0
      M.ORD_QTAMLE = 0
      M.ORD_QTAKGD = 0
      M.ORD_QTAMQD = 0
      M.ORD_QTAMLD = 0
      M.ORD_CONFER = SPACE(1)
      M.ORD_SALCON = SPACE(1)
      M.ORD_NOTEBO = ""
      M.ORD_DESIMB = SPACE(30)
      M.ORD_LOTMIN = 0
      M.ORD_DTINPR = SPACE(10)
      M.ORD_DTFIPR = SPACE(10)
      M.ORD_FLGPRG = 0
      M.ORD_FLGAVA = 0
      M.ORD_NUMPRG = SPACE(6)
      M.ORD_DATPRG = SPACE(10)
      M.ORD_SEIPRG = SPACE(7)
      M.ORD_SEFPRG = SPACE(7)
      M.ORD_DAIPRG = SPACE(10)
      M.ORD_DAFPRG = SPACE(10)
      M.ORD_NRBOBP = 0
      M.ORD_QUANTP = 0
      M.ORD_NRBOBF = 0
      M.ORD_QUANTF = 0
      M.ORD_NRBOBD = 0
      M.ORD_QUANTD = 0
      M.ORD_SETTPR = SPACE(7)
      M.ORD_SETTCC = SPACE(7)
      M.ORD_NRBOBX = 0
      M.ORD_QUANTX = 0
      M.ORD_SETTCX = SPACE(7)
      M.ORD_NRBOBO = 0
      M.ORD_QUANTO = 0
      M.ORD_NRBOBY = 0
      M.ORD_QUANTY = 0
      M.ORD_NRBSPD = 0
      M.ORD_QTASPD = 0
      M.ORD_NRBSPP = 0
      M.ORD_QTASPP = 0
      M.ORD_NRBRID = 0
      M.ORD_QTARID = 0
      M.ORD_NRBRIP = 0
      M.ORD_QTARIP = 0
      M.ORD_NRBTGO = 0
      M.ORD_QTATGO = 0
      M.ORD_NRBTGD = 0
      M.ORD_QTATGD = 0
      M.ORD_NRBTGP = 0
      M.ORD_QTATGP = 0
      M.ORD_CDAPRD = SPACE(16)
      M.ORD_DSAPRD = SPACE(50)
      M.ORS_FLGABP = .F.
      M.ORD_FLGCEL = .F.
      M.ORD_SERBOL = SPACE(3)
      M.ORD_AAPROD = 0
      M.ORD_SERNUM = SPACE(3)
      M.ORD_NUMEDA = 0
      M.ORD_NUMEAL = 0
      M.ORD_CBFISC = SPACE(50)
      M.ORD_PKLOK  = SPACE(1)
      M.ORD_QTAPCK = 0
      M.ORD_PUBBLI = SPACE(1)

      *** VALORI DI DEFAULT
      M.ORD_CODSYS = SYS(2015)
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + M.ORD_CODART + "'"
      x_cond = x_soci + " and " + x_codi
      cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
      IF !ExecCommand(cSql,"CUR_ARTICOLI")
         RETURN .F.
      ENDIF
      SELECT CUR_ARTICOLI
      GO TOP
      IF !EOF()
         M.ORD_CODMAT = ART_CODMAT
         M.ORD_DESMAT = ART_DESMAT
         M.ORD_CODCOL = ART_CODCOL
         M.ORD_DESCOL = ART_DESCOL
         M.ORD_SPESSO = ART_SPESSO
         M.ORD_ALTEZZ = ART_ALTEZZ
         M.ORD_LUNGHE = ART_LUNGHE
         M.ORD_CODIMB = ART_CODIMB
         M.ORD_DESIMB = ART_DESIMB
         M.ORD_LOTMIN = ART_LOTMIN
      ENDIF

      M.ORS_NUMORD = X_NUMORD
      M.ORS_DATORD = X_DATORD
      M.ORS_MAGS   = X_MAGS
      M.ORS_MAGD   = X_MAGD
      M.ORS_CODCLI = X_CODCLI
      M.ORS_RAGSOC = X_RAGSOC
      M.ORS_CODEMI = X_CODEMI
      M.ORS_RAGEMI = X_RAGEMI
      M.ORS_TIPORD = X_TIPORD
      M.ORS_DESTIN = X_DESTIN
      M.ORS_FLGABP = X_FLGABP
      M.ORD_CDAPRD = M.ORD_CODART
      M.ORD_DSAPRD = M.ORD_DESART

      IF _X_CHIUSOTT
         M.ORD_SALCON = 'S'
      ELSE
         IF _X_CHIUSODD
            M.ORD_SALCON = 'S'
         ELSE
            IF M.ORD_QTAEV >= M.ORD_QTAORD
               M.ORD_SALCON = 'S'
            ENDIF
         ENDIF
      ENDIF


	  IF ALLTRIM(M.ORD_UM) = "N"	&& 2012/10/11 FORZA COME UNITA' DI MISURA NR
	  	 M.ORD_UM = "NR"
	  ENDIF

      SELECT CU_ORD_DD
      APPEND BLANK
      DO U_ORD_DD

      REPLACE ORD_PKLOK  WITH M.ORD_PKLOK
      REPLACE ORD_QTAPCK WITH M.ORD_QTAPCK


      _X_ULTCODSYS = M.ORD_CODSYS

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_ORD_DD
      SKIP +1
   ENDDO

   SELECT CU_ORD_TT
   REPLACE ORD_CODSYS WITH _X_ULTCODSYS



   _V_CONTA1 = _V_CONTA1 + 1



   SELECT CUR_ORD_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi degli Ordini clienti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_ord_tt','I','','CU_ORD_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_ord_dd','I','','CU_ORD_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.

*!*		x_codi = "codice = 'NUMORD'"
*!*		x_cond = x_codi
*!*		cSql = "select * from PARA where " + x_cond
*!*		IF !ExecRW(cSql,"PARA","R")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT PARA
*!*		GO TOP
*!*		IF EOF()
*!*		   APPEND BLANK
*!*		   V1 = 'NUMORD'
*!*		   REPLACE CODICE WITH V1
*!*		   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
*!*		ENDIF
*!*		REPLACE LIBERA WITH "5000000100"
*!*		IF !ExecRW(cSql,"PARA","W")
*!*		   return(.f.)
*!*		ENDIF





*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_BOL_TT_DD       && CONVERTE LE TABELLE U_BOL_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE DOCUMENTI DI TRASPORTO	   								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_BOL_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_BOL_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_BOL_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchi Documenti di trasporto...  -  Prego Attendere" NOWAIT
cSql = "delete from U_BOL_TT where 1=1"
IF !ExecCommand(cSql,"U_BOL_TT")
   return(.f.)
ENDIF
cSql = "delete from U_BOL_DD where 1=1"
IF !ExecCommand(cSql,"U_BOL_DD")
   return(.f.)
ENDIF


x_codi = "codice = 'NUMBOL'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMBOL'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_BOL_TT where 1=0"
IF !ExecCommand(cSql,"CU_BOL_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_BOL_DD where 1=0"
IF !ExecCommand(cSql,"CU_BOL_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_BOL_TT where 1=0"
IF !ExecCommand(cSql,"CUR_BOL_TT")
   return(.f.)
ENDIF
SELECT CUR_BOL_TT
INDEX ON ORD_ANNO TAG I_ANNO

SET FILTER TO
*SET FILTER TO SUBSTR(ORD_DATORD,7,4) < _V_ANNCONV
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_BOL_DD where 1=0"
IF !ExecCommand(cSql,"CUR_BOL_DD")
   return(.f.)
ENDIF
SELECT CUR_BOL_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_BOL_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Documento di trasporto " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO  = STR(NEWPROG('NUMBOL'),10)
   M.ORD_TOTIMB = 0
   M.ORD_PESEST = 0
   M.ORD_CODIMB = SPACE(3)
   M.ORD_CLIFAT = SPACE(10)
   M.ORD_RAGFAT = SPACE(40)
   M.ORD_ORATRA = SPACE(18)
   M.ORD_TRAPDV = .F.
   M.ORD_TRASME = .F.
   M.ORD_ANNO   = SPACE(4)
   M.ORD_PROVIN = SPACE(2)
   M.ORD_PROC   = SPACE(2)
   M.ORD_CODBUN = SPACE(10)
   M.ORD_DESBUN = SPACE(50)
   M.ORD_FLGTRA = .F.
   M.ORD_FLGCON = .F.
   M.ORD_NUMDDT = SPACE(6)
   M.ORD_DATDDT = SPACE(10)
   M.ORD_ANNDDT = SPACE(4)
   M.ORD_AGGDDT = SPACE(10)
   M.T_OMAGGIO  = 0
   M.I_OMAGGIO  = 0
   M.ORD_DATFAT = SPACE(10)

   *** VALORI DI DEFAULT
   M.ORD_NUMORD = TRC(6,ALLTRIM(M.ORD_NUMORD))
   M.ORD_NUMORC = TRC(6,ALLTRIM(M.ORD_NUMORC))
   M.TNUMERO    = M.ORD_NUMORD
   M.ORD_FLGCON = .T.
   IF SUBSTR(M.ORD_DATORD,3,1) = '/'
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,7,4)
   ELSE
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,1,4)
   ENDIF

   IF M.ORD_ANNO = PUB_ANNO .OR. M.ORD_ANNO = PUB_ANNOP				&& ELABORA SOLO LE BOLLE DEGLI ULTIMI DUE ANNI
   ELSE
   	  SELECT CUR_BOL_TT
   	  SKIP +1
   	  LOOP
   ENDIF


   X_NUMORD = M.ORD_NUMORD
   X_DATORD = M.ORD_DATORD
   X_MAGS   = M.ORD_MAGS
   X_MAGD   = M.ORD_MAGD
   X_CODCLI = M.ORD_CODCLI
   X_RAGSOC = M.ORD_RAGSOC
   X_CODEMI = M.ORD_CODEMI
   X_RAGEMI = M.ORD_RAGEMI
   X_TIPORD = M.ORD_TIPORD
   X_NUMORC = M.ORD_NUMORC
   X_DATORC = M.ORD_DATORC
   IF M.ORD_LOCC = SPACE(70) .OR. EMPTY(M.ORD_LOCC)
      X_DESTIN = M.ORD_LOCALI
      M.ORD_DESTIN = M.ORD_LOCALI
   ELSE
      X_DESTIN = M.ORD_LOCC
      M.ORD_DESTIN = M.ORD_LOCC
   ENDIF
   IF M.ORD_CODSYS = SPACE(10) .OR. EMPTY(M.ORD_CODSYS)
      _V_CODSYS = SYS(2015)
      M.ORD_CODSYS = _V_CODSYS
   ENDIF

   SELECT CU_BOL_TT
   APPEND BLANK
   DO U_BOL_TT

   REPLACE ORD_TRAPDV WITH M.ORD_TRAPDV
   REPLACE ORD_FLGTRA WITH M.ORD_FLGTRA

   SELECT CUR_BOL_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_BOL_TT
      SKIP +1
      LOOP
   ENDIF

   V_SEQUEN = 0

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      V_SEQUEN     = V_SEQUEN + 10
      M.ORD_SEQUEN = V_SEQUEN

      M.DAGGANCIO  = M.TAGGANCIO
      M.ORD_PESOUM = 0
      M.ORD_CODIMB = SPACE(3)
      M.ORD_FLGSCP = .F.
      M.ORS_VALUTA = SPACE(3)
      M.ORD_CODTAG = SPACE(3)
      M.ORD_DESTAG = SPACE(30)
      M.ORD_CODCOL = SPACE(3)
      M.ORD_DESCOL = SPACE(30)
      M.ORD_TRASMD = .F.
      M.ORD_LEGAME = SPACE(10)
      M.ORD_FORNIT = SPACE(10)
      M.ORD_PRZULC = 0
      M.ORD_RAGFOR = SPACE(50)
      M.ORD_LEGSYS = SPACE(10)
      M.ORD_FLGMOD = SPACE(1)
      M.ORD_PRZCON = 0
      M.ORD_CODACQ = SPACE(10)
      M.ORD_CODMAT = SPACE(3)
      M.ORD_DESMAT = SPACE(30)
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
      M.ORD_DATPED = SPACE(10)
      M.ORD_SYSPED = SPACE(10)
      M.ORD_DESIMB = SPACE(30)
      M.ORD_LOTMIN = 0
      M.ORD_NOTEBO = ""
      M.ORD_QTAKGI = 0
      M.ORD_QTAKGE = 0
      M.ORD_CDAPRD = SPACE(16)
      M.ORD_DSAPRD = SPACE(50)
      M.ORD_QTACON = 0
      M.ORD_TIPCON = SPACE(1)
      M.ORD_SERBOL = SPACE(3)
      M.ORD_ANNOPR = 0
      M.ORD_SERNUM = SPACE(3)
      M.ORD_NUMEDA = 0
      M.ORD_NUMEAL = 0
      M.ORD_AAPROD = 0
      M.ORD_FLGCEL = .F.
      M.ORD_SERIE  = SPACE(3)
      M.ORD_CBFISC = SPACE(50)
      M.ORS_NUMDDT = SPACE(6)
      M.ORS_DATDDT = SPACE(10)
      M.ORS_ANNDDT = SPACE(4)
      M.ORS_AGGDDT = SPACE(10)
      M.ORD_SYSDDT = SPACE(10)
      M.ORD_NRBRES = 0
      M.ORD_QTARES = 0
      M.ORD_NRERES = 0
      M.ORD_QTERES = 0
      M.ORD_FLGPKL = .F.
      M.RES_CODINT = SPACE(16)
      M.RES_NUMLOT = 0

      *** VALORI DI DEFAULT
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + M.ORD_CODART + "'"
      x_cond = x_soci + " and " + x_codi
      cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
      IF !ExecCommand(cSql,"CUR_ARTICOLI")
         RETURN .F.
      ENDIF
      SELECT CUR_ARTICOLI
      GO TOP
      IF !EOF()
         M.ORD_CODMAT = ART_CODMAT
         M.ORD_DESMAT = ART_DESMAT
         M.ORD_CODCOL = ART_CODCOL
         M.ORD_DESCOL = ART_DESCOL
         M.ORD_SPESSO = ART_SPESSO
         M.ORD_ALTEZZ = ART_ALTEZZ
         M.ORD_LUNGHE = ART_LUNGHE
         M.ORD_CODIMB = ART_CODIMB
         M.ORD_DESIMB = ART_DESIMB
         M.ORD_LOTMIN = ART_LOTMIN
      ENDIF
      M.ORS_NUMORD = X_NUMORD
      M.ORS_DATORD = X_DATORD
      M.ORS_MAGS   = X_MAGS
      M.ORS_MAGD   = X_MAGD
      M.ORS_CODCLI = X_CODCLI
      M.ORS_RAGSOC = X_RAGSOC
      M.ORS_CODEMI = X_CODEMI
      M.ORS_RAGEMI = X_RAGEMI
      M.ORS_TIPORD = X_TIPORD
      M.ORS_NUMORC = X_NUMORC
      M.ORS_DATORC = X_DATORC
      M.ORS_DESTIN = X_DESTIN
      M.ORD_CDAPRD = M.ORD_CODART
      M.ORD_DSAPRD = M.ORD_DESART

      IF M.ORD_CODSYS = SPACE(10) .OR. EMPTY(M.ORD_CODSYS)
         _V_CODSYS = SYS(2015)
         M.ORD_CODSYS = _V_CODSYS
      ENDIF

	  IF ALLTRIM(M.ORD_UM) = "N"	&& 2012/10/11 FORZA COME UNITA' DI MISURA NR
	  	 M.ORD_UM = "NR"
	  ENDIF

      SELECT CU_BOL_DD
      APPEND BLANK
      DO U_BOL_DD

      REPLACE ORD_NRERES WITH M.ORD_NRERES
      REPLACE ORD_QTERES WITH M.ORD_QTERES
      REPLACE ORD_FLGPKL WITH M.ORD_FLGPKL

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_BOL_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_BOL_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi dei Documenti di trasporto sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_bol_tt','I','','CU_BOL_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_bol_dd','I','','CU_BOL_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.


*!*		x_codi = "codice = 'NUMBOL'"
*!*		x_cond = x_codi
*!*		cSql = "select * from PARA where " + x_cond
*!*		IF !ExecRW(cSql,"PARA","R")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT PARA
*!*		GO TOP
*!*		IF EOF()
*!*		   APPEND BLANK
*!*		   V1 = 'NUMBOL'
*!*		   REPLACE CODICE WITH V1
*!*		   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
*!*		ENDIF
*!*		REPLACE LIBERA WITH "5000000100"
*!*		IF !ExecRW(cSql,"PARA","W")
*!*		   return(.f.)
*!*		ENDIF



*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_FAP_TT_DD       && CONVERTE LE TABELLE U_FAP_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE FATTURE PROFORMA		   								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_FAP_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_FAP_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_FAP_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Fatture proforma...  -  Prego Attendere" NOWAIT
cSql = "delete from U_FAP_TT where 1=1"
IF !ExecCommand(cSql,"U_FAP_TT")
   return(.f.)
ENDIF
cSql = "delete from U_FAP_DD where 1=1"
IF !ExecCommand(cSql,"U_FAP_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMFAP'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMFAP'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_FAP_TT where 1=0"
IF !ExecCommand(cSql,"CU_FAP_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_FAP_DD where 1=0"
IF !ExecCommand(cSql,"CU_FAP_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_FAP_TT where 1=0"
IF !ExecCommand(cSql,"CUR_FAP_TT")
   return(.f.)
ENDIF
SELECT CUR_FAP_TT
SET FILTER TO
*SET FILTER TO SUBSTR(ORD_DATORD,7,4) == _V_ANNCONV
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_FAP_DD where 1=0"
IF !ExecCommand(cSql,"CUR_FAP_DD")
   return(.f.)
ENDIF
SELECT CUR_FAP_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_FAP_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Fattura proforma " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO  = STR(NEWPROG('NUMFAP'),10)
   M.ORD_TISPE  = SPACE(3)
   M.ORD_CODEMI = SPACE(10)
   M.ORD_RAGEMI = SPACE(30)
   M.ORD_CCOSTO = SPACE(13)
   M.ORD_NUMTRX = SPACE(6)
   M.ORD_DATTRX = SPACE(10)
   M.ORD_ORATRX = SPACE(5)
   M.ORD_DATRCX = SPACE(10)
   M.ORD_ORARCX = SPACE(5)
   M.ORD_VALDAF = 0
   M.ORD_TIPORD = SPACE(3)
   M.ORD_TOTIMB = 0
   M.ORD_PESEST = 0
   M.ORD_CODIMB = SPACE(3)
   M.ORD_CLIFAT = SPACE(10)
   M.ORD_RAGFAT = SPACE(40)
   M.ORD_ANNO   = SPACE(4)
   M.ORD_PROVIN = SPACE(2)

   SELECT CU_FAP_TT
   APPEND BLANK
   DO U_FAP_TT

   SELECT CUR_FAP_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_FAP_TT
      SKIP +1
      LOOP
   ENDIF

   V_SEQUEN     = 0

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      V_SEQUEN     = V_SEQUEN + 10
      M.ORD_SEQUEN = V_SEQUEN

      M.DAGGANCIO  = M.TAGGANCIO
      M.ORS_MAGS   = SPACE(6)
      M.ORS_CODCLI = SPACE(10)
      M.ORS_RAGSOC = SPACE(70)
      M.ORS_NUMORD = SPACE(6)
      M.ORS_DATORD = SPACE(10)
      M.ORS_CODEMI = SPACE(10)
      M.ORS_RAGEMI = SPACE(40)
      M.ORS_TIPORD = SPACE(3)
      M.ORS_SALCON = SPACE(1)
      M.SELEZIONE  = SPACE(10)
      M.ORS_NUMORC = SPACE(6)
      M.ORS_DATORC = SPACE(10)
      M.ORS_DESTIN = SPACE(70)
      M.ORD_QTCONF = 0
      M.ORD_QTXCON = 0
      M.ORS_NUMDDT = SPACE(6)
      M.ORS_DATDDT = SPACE(10)
      M.ORS_VETTO1 = SPACE(40)
      M.ORS_VETTO2 = SPACE(40)
      M.ORS_VETTO3 = SPACE(40)
      M.ORD_SYSCOD = SPACE(10)
      M.ORD_FDITRA = SPACE(1)
      M.ORD_PESOUM = 0
      M.ORD_CODIMB = SPACE(3)
      M.ORS_VALUTA = SPACE(3)
      M.ORD_CODTAG = SPACE(3)
      M.ORD_DESTAG = SPACE(30)
      M.ORD_CODCOL = SPACE(3)
      M.ORD_DESCOL = SPACE(30)
      M.ORD_TRASME = .F.
      M.ORD_TRASMD = .F.
      M.ORD_CODSYS = SPACE(10)
      M.ORD_LEGSYS = SPACE(10)
      M.ORD_FLGMOD = SPACE(1)

	  IF ALLTRIM(M.ORD_UM) = "N"	&& 2012/10/11 FORZA COME UNITA' DI MISURA NR
	  	 M.ORD_UM = "NR"
	  ENDIF

      SELECT CU_FAP_DD
      APPEND BLANK
      DO U_FAP_DD

      REPLACE ORD_TRASME WITH M.ORD_TRASME

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_FAP_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_FAP_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle Fatture proforma sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_fap_tt','I','','CU_FAP_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_fap_dd','I','','CU_FAP_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_FAT_TT_DD       && CONVERTE LE TABELLE U_FAT_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE FATTURE CLIENTI			   								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_FAT_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_FAT_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_FAT_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Fatture clienti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_FAT_TT where 1=1"
IF !ExecCommand(cSql,"U_FAT_TT")
   return(.f.)
ENDIF
cSql = "delete from U_FAT_DD where 1=1"
IF !ExecCommand(cSql,"U_FAT_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMFAT'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMFAT'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_FAT_TT where 1=0"
IF !ExecCommand(cSql,"CU_FAT_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_FAT_DD where 1=0"
IF !ExecCommand(cSql,"CU_FAT_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_FAT_TT where 1=0"
IF !ExecCommand(cSql,"CUR_FAT_TT")
   return(.f.)
ENDIF
SELECT CUR_FAT_TT
SET FILTER TO
***SET FILTER TO SUBSTR(ORD_DATORD,7,4) == _V_ANNCONV
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_FAT_DD where 1=0"
IF !ExecCommand(cSql,"CUR_FAT_DD")
   return(.f.)
ENDIF
SELECT CUR_FAT_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_FAT_TT
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Fattura clienti " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO      = STR(NEWPROG('NUMFAT'),10)
   M.ORD_TOTIMB     = 0
   M.ORD_PESEST     = 0
   M.ORD_CODIMB     = SPACE(3)
   M.ORD_CLIFAT     = SPACE(10)
   M.ORD_RAGFAT     = SPACE(40)
   M.ORD_ANNO       = SPACE(4)
   M.ORD_PROVIN     = SPACE(2)
   M.ORD_CODBUN     = SPACE(10)
   M.ORD_DESBUN     = SPACE(50)
   M.ORD_NUMSCO     = SPACE(6)
   M.ORD_DATSCO     = SPACE(10)
   M.ORD_ORASCO     = SPACE(5)
   M.ORD_FLGTRA     = .F.
   M.ORD_BOLLATOIVA = SPACE(1)
   M.T_OMAGGIO      = 0
   M.I_OMAGGIO      = 0
   M.ORD_DATCGE     = SPACE(10)
   M.ORD_FLGABB     = .F.

   *** VALORI DI DEFAULT
   M.ORD_NUMORD = TRC(6,ALLTRIM(M.ORD_NUMORD))
   M.TNUMERO    = M.ORD_NUMORD
   IF SUBSTR(M.ORD_DATORD,3,1) = '/'
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,7,4)
   ELSE
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,1,4)
   ENDIF
   X_NUMORD     = M.ORD_NUMORD
   X_DATORD     = M.ORD_DATORD
   X_CODCLI     = M.ORD_CODCLI
   X_RAGSOC     = M.ORD_RAGSOC
   IF M.ORD_CODSYS = SPACE(10) .OR. EMPTY(M.ORD_CODSYS)
      _V_CODSYS = SYS(2015)
      M.ORD_CODSYS = _V_CODSYS
   ENDIF

   SELECT CU_FAT_TT
   APPEND BLANK
   DO U_FAT_TT

   REPLACE ORD_FLGTRA     WITH M.ORD_FLGTRA
   REPLACE ORD_BOLLATOIVA WITH M.ORD_BOLLATOIVA

   SELECT CUR_FAT_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_FAT_TT
      SKIP +1
      LOOP
   ENDIF

   V_SEQUEN     = 0

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      V_SEQUEN     = V_SEQUEN + 10
      M.ORD_SEQUEN = V_SEQUEN

      M.DAGGANCIO  = M.TAGGANCIO
      M.ORD_PESOUM = 0
      M.ORD_CODIMB = SPACE(3)
      M.ORS_VALUTA = SPACE(3)
      M.ORD_CODTAG = SPACE(3)
      M.ORD_DESTAG = SPACE(30)
      M.ORD_CODCOL = SPACE(3)
      M.ORD_DESCOL = SPACE(30)
      M.ORD_TRASME = .F.
      M.ORD_TRASMD = .F.
      M.ORD_CODSYS = SPACE(10)
      M.ORD_LEGSYS = SPACE(10)
      M.ORD_FLGMOD = SPACE(1)
      M.ORD_PRZCON = 0
      M.ORD_FORNIT = SPACE(10)
      M.ORD_CODACQ = SPACE(10)
      M.ORD_CODMAT = SPACE(3)
      M.ORD_DESMAT = SPACE(30)
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
      M.ORD_DATPED = SPACE(10)
      M.ORD_SYSPED = SPACE(10)
      M.ORD_NOTEBO = ""
      M.ORD_DESIMB = SPACE(30)
      M.ORD_LOTMIN = 0
      M.ORD_QTAKGI = 0
      M.ORD_QTAKGE = 0
      M.ORD_CDAPRD = SPACE(16)
      M.ORD_DSAPRD = SPACE(50)

      M.ORD_CODART = APITOSPA(M.ORD_CODART)
      M.ORD_DESART = APITOSPA(M.ORD_DESART)



      *** VALORI DI DEFAULT
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + M.ORD_CODART + "'"
      x_cond = x_soci + " and " + x_codi
      cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
      IF !ExecCommand(cSql,"CUR_ARTICOLI")
         RETURN .F.
      ENDIF
      SELECT CUR_ARTICOLI
      GO TOP
      IF !EOF()
         M.ORD_CODMAT = ART_CODMAT
         M.ORD_DESMAT = ART_DESMAT
         M.ORD_CODCOL = ART_CODCOL
         M.ORD_DESCOL = ART_DESCOL
         M.ORD_SPESSO = ART_SPESSO
         M.ORD_ALTEZZ = ART_ALTEZZ
         M.ORD_LUNGHE = ART_LUNGHE
         M.ORD_CODIMB = ART_CODIMB
         M.ORD_DESIMB = ART_DESIMB
         M.ORD_LOTMIN = ART_LOTMIN
      ENDIF
      M.ORS_NUMORD = X_NUMORD
      M.ORS_DATORD = X_DATORD
      M.ORS_CODCLI = X_CODCLI
      M.ORS_RAGSOC = X_RAGSOC
      M.ORD_CDAPRD = M.ORD_CODART
      M.ORD_DSAPRD = M.ORD_DESART
      M.ORS_NUMORC = TRC(6,ALLTRIM(M.ORS_NUMORC))
      M.ORS_VALUTA = M.ORD_VALUTA
      M.ORS_MAGS   = ORD_MAGA
      M.ORD_CODSYS = SYS(2015)

	  IF ALLTRIM(M.ORD_UM) = "N"	&& 2012/10/11 FORZA COME UNITA' DI MISURA NR
	  	 M.ORD_UM = "NR"
	  ENDIF
	
      SELECT CU_FAT_DD
      APPEND BLANK
      DO U_FAT_DD

      REPLACE ORD_TRASME WITH M.ORD_TRASME

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_FAT_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_FAT_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle Fatture clienti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_fat_tt','I','','CU_FAT_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_fat_dd','I','','CU_FAT_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_NCR_TT_DD       && CONVERTE LE TABELLE U_NCR_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE NOTE CREDITO CLIENTI									*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_NCR_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_NCR_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_NCR_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Note di credito clienti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_NCR_TT where 1=1"
IF !ExecCommand(cSql,"U_NCR_TT")
   return(.f.)
ENDIF
cSql = "delete from U_NCR_DD where 1=1"
IF !ExecCommand(cSql,"U_NCR_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMNCR'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMNCR'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_NCR_TT where 1=0"
IF !ExecCommand(cSql,"CU_NCR_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_NCR_DD where 1=0"
IF !ExecCommand(cSql,"CU_NCR_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_NCR_TT where 1=0"
IF !ExecCommand(cSql,"CUR_NCR_TT")
   return(.f.)
ENDIF
SELECT CUR_NCR_TT
SET FILTER TO
*SET FILTER TO SUBSTR(ORD_DATORD,7,4) == _V_ANNCONV
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_NCR_DD where 1=0"
IF !ExecCommand(cSql,"CUR_NCR_DD")
   return(.f.)
ENDIF
SELECT CUR_NCR_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_NCR_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga delle Note di credito clienti " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO = STR(NEWPROG('NUMNCR'),10)
   M.ORD_ANNO  = SPACE(4)

   SELECT CU_NCR_TT
   APPEND BLANK
   DO U_NCR_TT

   SELECT CUR_NCR_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_NCR_TT
      SKIP +1
      LOOP
   ENDIF

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      M.DAGGANCIO = M.TAGGANCIO

      SELECT CU_NCR_DD
      APPEND BLANK
      DO U_NCR_DD

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_NCR_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_NCR_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle Note di credito clienti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_ncr_tt','I','','CU_NCR_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_ncr_dd','I','','CU_NCR_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_RIC_TT_DD       && CONVERTE LE TABELLE U_RIC_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE RICEVUTE BANCARIE (U_RIC_TT-DD)							*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_RIC_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_RIC_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_RIC_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Ricevute bancarie (tabelle U_RIC_TT-DD)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_RIC_TT where 1=1"
IF !ExecCommand(cSql,"U_RIC_TT")
   return(.f.)
ENDIF
cSql = "delete from U_RIC_DD where 1=1"
IF !ExecCommand(cSql,"U_RIC_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMRIC'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMRIC'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_RIC_TT where 1=0"
IF !ExecCommand(cSql,"CU_RIC_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_RIC_DD where 1=0"
IF !ExecCommand(cSql,"CU_RIC_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_RIC_TT where 1=0"
IF !ExecCommand(cSql,"CUR_RIC_TT")
   return(.f.)
ENDIF
SELECT CUR_RIC_TT
SET FILTER TO
**SET FILTER TO SUBSTR(RIC_DTFATT,1,4) == _V_ANNCONV
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_RIC_DD where 1=0"
IF !ExecCommand(cSql,"CUR_RIC_DD")
   return(.f.)
ENDIF
SELECT CUR_RIC_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_RIC_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Ricevuta bancaria (tabelle U_RIC_TT-DD) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO  = STR(NEWPROG('NUMRIC'),10)
   M.ORD_ANNO   = SPACE(4)
   M.RIC_CONPAG = SPACE(3)

   *** VALORI DI DEFAULT
   M.RIC_NFATT = TRC(6,ALLTRIM(M.RIC_NFATT))
   IF SUBSTR(M.RIC_DTFATT,3,1) = '/'
      M.ORD_ANNO = SUBSTR(M.RIC_DTFATT,7,4)
   ELSE
      M.ORD_ANNO = SUBSTR(M.RIC_DTFATT,1,4)
   ENDIF

   SELECT CU_RIC_TT
   APPEND BLANK
   DO U_RIC_TT

   REPLACE RIC_CONPAG WITH M.RIC_CONPAG

   SELECT CUR_RIC_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_RIC_TT
      SKIP +1
      LOOP
   ENDIF

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      M.DAGGANCIO = M.TAGGANCIO

      *** VALORI DI DEFAULT
      M.RIC_FATAGE = TRC(6,ALLTRIM(M.RIC_FATAGE))

      SELECT CU_RIC_DD
      APPEND BLANK
      DO U_RIC_DD

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_RIC_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_RIC_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle Ricevute bancarie (tabelle U_RIC_TT-DD) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_ric_tt','I','','CU_RIC_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_ric_dd','I','','CU_RIC_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_RIC_AN       && CONVERTE LA TABELLA U_RIC_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE RICEVUTE BANCARIE (U_RIC_AN)   							*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_RIC_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_RIC_AN SQL
WAIT WINDOWS "Cancellazione vecchie Ricevute bancarie (tabella U_RIC_AN)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_RIC_AN where 1=1"
IF !ExecCommand(cSql,"U_RIC_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_RIC_AN where 1=0"
IF !ExecCommand(cSql,"CU_RIC_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_RIC_AN where 1=0"
IF !ExecCommand(cSql,"CUR_RIC_AN")
   return(.f.)
ENDIF
SELECT CUR_RIC_AN
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_RIC_AN
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga delle Ricevute bancarie (tabella U_RIC_AN) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_RIC_AN
   APPEND BLANK
   DO U_RIC_AN

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_RIC_AN
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio delle Ricevute bancarie (tabella U_RIC_AN) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_ric_an','I','','CU_RIC_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_RID_AN       && CONVERTE LA TABELLA U_RID_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE RICEVUTE BANCARIE (U_RID_AN)   							*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_RID_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_RID_AN SQL
WAIT WINDOWS "Cancellazione vecchie Ricevute bancarie (tabella U_RID_AN)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_RID_AN where 1=1"
IF !ExecCommand(cSql,"U_RID_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_RID_AN where 1=0"
IF !ExecCommand(cSql,"CU_RID_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from U_RID_AN where 1=0"
IF !ExecCommand(cSql,"CUR_RID_AN")
   return(.f.)
ENDIF
SELECT CUR_RID_AN
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_RID_AN
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga delle Ricevute bancarie (tabella U_RID_AN) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_RID_AN
   APPEND BLANK
   DO U_RID_AN

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_RID_AN
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio delle Ricevute bancarie (tabella U_RID_AN) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_rid_an','I','','CU_RID_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_ORF_TT_DD       && CONVERTE LE TABELLE U_ORF_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ORDINI A FORNITORE		   								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_ORF_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_ORF_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_ORF_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchi Ordini a fornitore...  -  Prego Attendere" NOWAIT
cSql = "delete from U_ORF_TT where 1=1"
IF !ExecCommand(cSql,"U_ORF_TT")
   return(.f.)
ENDIF
cSql = "delete from U_ORF_DD where 1=1"
IF !ExecCommand(cSql,"U_ORF_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMORF'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMORF'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_ORF_TT where 1=0"
IF !ExecCommand(cSql,"CU_ORF_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_ORF_DD where 1=0"
IF !ExecCommand(cSql,"CU_ORF_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_ORF_TT where 1=0"
IF !ExecCommand(cSql,"CUR_ORF_TT")
   return(.f.)
ENDIF
SELECT CUR_ORF_TT
SET FILTER TO
**SET FILTER TO SUBSTR(ORD_DATORD,7,4) == _V_ANNCONV
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_ORF_DD where 1=0"
IF !ExecCommand(cSql,"CUR_ORF_DD")
   return(.f.)
ENDIF
SELECT CUR_ORF_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_ORF_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Ordine a fornitore " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD   = M.TAGGANCIO
   _X_CHIUSOTT  = M.ORD_CHIUSO

   M.TAGGANCIO  = STR(NEWPROG('NUMORF'),10)
   M.ORD_TRASME = .F.
   M.ORD_ANNO   = SPACE(4)
   M.ORD_PROVIN = SPACE(2)
   M.ORD_PROC   = SPACE(2)
   M.ORD_CODBUN = SPACE(10)
   M.ORD_DESBUN = SPACE(50)
   M.ORD_FLGTRA = .F.
   M.ORD_FLGTIP = .F.
   M.ORD_FLGCON = .F.
   M.ORD_MAKEDA = SPACE(4)
   M.ORD_CODACQ = SPACE(3)
   M.ORD_DESACQ = SPACE(30)
   M.ORD_DESTIN = SPACE(4)

   *** VALORI DI DEFAULT
   M.ORD_NUMORD = TRC(6,ALLTRIM(M.ORD_NUMORD))
   M.TNUMERO    = M.ORD_NUMORD
   IF SUBSTR(M.ORD_DATORD,3,1) = '/'
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,7,4)
   ELSE
      M.ORD_ANNO = SUBSTR(M.ORD_DATORD,1,4)
   ENDIF
   M.ORD_FLGCON = .T.
   M.ORD_MAKEDA = "SEDE"
   M.ORD_DESTIN = "SEDE"
   X_NUMORD = M.ORD_NUMORD
   X_DATORD = M.ORD_DATORD
   X_CODCLI = M.ORD_CODCLI
   X_RAGSOC = M.ORD_RAGSOC
   IF M.ORD_LOCC = SPACE(70) .OR. EMPTY(M.ORD_LOCC)
      X_DESTIN = M.ORD_LOCALI
   ELSE
      X_DESTIN = M.ORD_LOCC
   ENDIF
   X_CODACQ = M.ORD_CODACQ
   X_DESACQ = M.ORD_DESACQ
   X_CODCPA = M.ORD_CPA

   SELECT CU_ORF_TT
   APPEND BLANK
   DO U_ORF_TT

   SELECT CUR_ORF_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_ORF_TT
      SKIP +1
      LOOP
   ENDIF

   V_SEQUEN = 0

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      _X_CHIUSODD  = M.ORD_CHIUSO

      V_SEQUEN     = V_SEQUEN + 10
      M.ORD_SEQUEN = V_SEQUEN

      M.DAGGANCIO  = M.TAGGANCIO
      M.ORD_CERTBV = SPACE(10)
      M.ORD_CERANN = SPACE(4)
      M.ORD_NUMACC = SPACE(15)
      M.ORD_COLATA = SPACE(15)
      M.ORD_QUALIT = SPACE(15)
      M.ORD_DIAMET = SPACE(20)
      M.ORD_DESCER = SPACE(40)
      M.ORD_CODTAG = SPACE(3)
      M.ORD_DESTAG = SPACE(30)
      M.ORD_CODCOL = SPACE(3)
      M.ORD_DESCOL = SPACE(30)
      M.ORD_TRASMD = .F.
      M.ORD_CODSYS = SPACE(10)
      M.ORD_UNIQUE = SPACE(10)
      M.ORD_LEGSYS = SPACE(10)
      M.ORD_FLGMOD = SPACE(1)
      M.ORS_CODACQ = SPACE(3)
      M.ORS_DESACQ = SPACE(30)
      M.ORS_CODCPA = SPACE(3)
      M.ORD_CODMAT = SPACE(3)
      M.ORD_DESMAT = SPACE(30)
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
      M.ORD_CONFER = SPACE(1)
      M.ORD_SALCON = SPACE(1)
      M.ORD_NOTEBO = ""
      M.ORD_CODIMB = SPACE(3)
      M.ORD_DESIMB = SPACE(30)
      M.ORD_LOTMIN = 0
      M.ORD_FLGCEL = .F.
      M.ORD_SERBOL = SPACE(3)
      M.ORD_AAPROD = 0
      M.ORD_SERNUM = SPACE(3)
      M.ORD_NUMEDA = 0
      M.ORD_NUMEAL = 0
      M.ORD_CBFISC = SPACE(50)
      M.ORD_NUMBOE = 0
      M.ORD_NUMBOD = 0

      *** VALORI DI DEFAULT
      M.ORD_CODSYS = SYS(2015)
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + M.ORD_CODART + "'"
      x_cond = x_soci + " and " + x_codi
      cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
      IF !ExecCommand(cSql,"CUR_ARTICOLI")
         RETURN .F.
      ENDIF
      SELECT CUR_ARTICOLI
      GO TOP
      IF !EOF()
         M.ORD_CODTAG = ART_CODTAG
         M.ORD_DESTAG = ART_DESTAG
         M.ORD_CODCOL = ART_CODCOL
         M.ORD_DESCOL = ART_DESCOL
         M.ORD_CODMAT = ART_CODMAT
         M.ORD_DESMAT = ART_DESMAT
         M.ORD_CODCOL = ART_CODCOL
         M.ORD_DESCOL = ART_DESCOL
         M.ORD_SPESSO = ART_SPESSO
         M.ORD_ALTEZZ = ART_ALTEZZ
         M.ORD_LUNGHE = ART_LUNGHE
         M.ORD_CODIMB = ART_CODIMB
         M.ORD_DESIMB = ART_DESIMB
         M.ORD_LOTMIN = ART_LOTMIN
      ENDIF
      M.ORS_NUMORD = X_NUMORD
      M.ORS_DATORD = X_DATORD
      M.ORS_CODCLI = X_CODCLI
      M.ORS_RAGSOC = X_RAGSOC
      M.ORS_DESTIN = X_DESTIN
      M.ORS_CODACQ = X_CODACQ
      M.ORS_DESACQ = X_DESACQ
      M.ORS_CODCPA = X_CODCPA

      IF _X_CHIUSOTT
         M.ORD_SALCON = 'S'
      ELSE
         IF _X_CHIUSODD
            M.ORD_SALCON = 'S'
         ELSE
            IF M.ORD_QTAEV >= M.ORD_QTAORD
               M.ORD_SALCON = 'S'
            ENDIF
         ENDIF
      ENDIF

	  IF ALLTRIM(M.ORD_UM) = "N"	&& 2012/10/11 FORZA COME UNITA' DI MISURA NR
	  	 M.ORD_UM = "NR"
	  ENDIF

      SELECT CU_ORF_DD
      APPEND BLANK
      DO U_ORF_DD

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_ORF_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_ORF_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi degli Ordini a fornitore sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_orf_tt','I','','CU_ORF_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_orf_dd','I','','CU_ORF_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_RIA_TT_DD       && CONVERTE LE TABELLE U_RIA_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE RITENUTE ACCONTO (U_RIA_TT-DD)							*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_RIA_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_RIA_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_RIA_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Ritenute d'acconto (tabelle U_RIA_TT-DD)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_RIA_TT where 1=1"
IF !ExecCommand(cSql,"U_RIA_TT")
   return(.f.)
ENDIF
cSql = "delete from U_RIA_DD where 1=1"
IF !ExecCommand(cSql,"U_RIA_DD")
   return(.f.)
ENDIF
*!*	x_codi = "codice = 'NUMORF'"
*!*	x_cond = x_codi
*!*	cSql = "delete from PARA where " + x_cond
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_RIA_TT where 1=0"
IF !ExecCommand(cSql,"CU_RIA_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_RIA_DD where 1=0"
IF !ExecCommand(cSql,"CU_RIA_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_RIA_TT where 1=0"
IF !ExecCommand(cSql,"CUR_RIA_TT")
   return(.f.)
ENDIF
SELECT CUR_RIA_TT
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_RIA_DD where 1=0"
IF !ExecCommand(cSql,"CUR_RIA_DD")
   return(.f.)
ENDIF
SELECT CUR_RIA_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_RIA_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Ritenuta d'acconto (tabelle U_RIA_TT-DD) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO    = STR(NEWPROG('NUMORF'),10)
   M.ORD_ANNO     = SPACE(4)
   M.ORD_PROVIN   = SPACE(2)
   M.ORD_NPART    = SPACE(10)
   M.ORD_IMPSPESE = 0
   M.ORD_IVASPESE = 0
   M.ORD_CODIVA   = SPACE(3)
   M.ORD_CIVSPE   = SPACE(3)
   M.ORD_PERENA   = 0
   M.ORD_IMPENA   = 0
   M.ORD_TOTENA   = 0

   SELECT CU_RIA_TT
   APPEND BLANK
   DO U_RIA_TT

   SELECT CUR_RIA_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_RIA_TT
      SKIP +1
      LOOP
   ENDIF

   V_SEQUEN = 0

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      V_SEQUEN     = V_SEQUEN + 10
      M.ORD_SEQUEN = V_SEQUEN

      M.DAGGANCIO  = M.TAGGANCIO
      M.ORD_SPESE  = SPACE(10)

      SELECT CU_RIA_DD
      APPEND BLANK
      DO U_RIA_DD

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_RIA_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_RIA_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle Ritenute d'acconto (tabelle U_RIA_TT-DD) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_ria_tt','I','','CU_RIA_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_ria_dd','I','','CU_RIA_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_RAA_TT_DD       && CONVERTE LE TABELLE U_RAA_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE RITENUTE ACCONTO (U_RAA_TT-DD)	 						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_RAA_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_RAA_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_RAA_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Ritenute d'acconto (tabelle U_RAA_TT-DD)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_RAA_TT where 1=1"
IF !ExecCommand(cSql,"U_RAA_TT")
   return(.f.)
ENDIF
cSql = "delete from U_RAA_DD where 1=1"
IF !ExecCommand(cSql,"U_RAA_DD")
   return(.f.)
ENDIF
*!*	x_codi = "codice = 'NUMORF'"
*!*	x_cond = x_codi
*!*	cSql = "delete from PARA where " + x_cond
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_RAA_TT where 1=0"
IF !ExecCommand(cSql,"CU_RAA_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_RAA_DD where 1=0"
IF !ExecCommand(cSql,"CU_RAA_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_RAA_TT where 1=0"
IF !ExecCommand(cSql,"CUR_RAA_TT")
   return(.f.)
ENDIF
SELECT CUR_RAA_TT
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_RAA_DD where 1=0"
IF !ExecCommand(cSql,"CUR_RAA_DD")
   return(.f.)
ENDIF
SELECT CUR_RAA_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_RAA_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Ritenuta d'acconto (tabelle U_RAA_TT-DD) " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO    = STR(NEWPROG('NUMORF'),10)
   M.ORD_ANNO     = SPACE(4)
   M.ORD_PROVIN   = SPACE(2)
   M.ORD_NPART    = SPACE(10)

   SELECT CU_RAA_TT
   APPEND BLANK
   DO U_RAA_TT

   SELECT CUR_RAA_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_RAA_TT
      SKIP +1
      LOOP
   ENDIF

   V_SEQUEN = 0

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      V_SEQUEN     = V_SEQUEN + 10
      M.ORD_SEQUEN = V_SEQUEN

      M.DAGGANCIO  = M.TAGGANCIO
      M.ORD_SEQUEN = 0

      SELECT CU_RAA_DD
      APPEND BLANK
      DO U_RAA_DD

      REPLACE ORD_SEQUEN WITH M.ORD_SEQUEN

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_RAA_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_RAA_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle Ritenute d'acconto (tabelle U_RAA_TT-DD) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_raa_tt','I','','CU_RAA_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_raa_dd','I','','CU_RAA_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_TVE_TT_DD       && CONVERTE LE TABELLE U_TVE_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE DDT TENTATA VENDITA				 						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_TVE_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_TVE_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_TVE_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie DDT tentata vendita...  -  Prego Attendere" NOWAIT
cSql = "delete from U_TVE_TT where 1=1"
IF !ExecCommand(cSql,"U_TVE_TT")
   return(.f.)
ENDIF
cSql = "delete from U_TVE_DD where 1=1"
IF !ExecCommand(cSql,"U_TVE_DD")
   return(.f.)
ENDIF
*!*	x_codi = "codice = 'NUMORF'"
*!*	x_cond = x_codi
*!*	cSql = "delete from PARA where " + x_cond
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_TVE_TT where 1=0"
IF !ExecCommand(cSql,"CU_TVE_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_TVE_DD where 1=0"
IF !ExecCommand(cSql,"CU_TVE_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_TVE_TT where 1=0"
IF !ExecCommand(cSql,"CUR_TVE_TT")
   return(.f.)
ENDIF
SELECT CUR_TVE_TT
SET FILTER TO
*SET FILTER TO SUBSTR(ORD_DATORD,7,4) == _V_ANNCONV
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_TVE_DD where 1=0"
IF !ExecCommand(cSql,"CUR_TVE_DD")
   return(.f.)
ENDIF
SELECT CUR_TVE_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_TVE_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione DDT tentata vendita " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO = STR(NEWPROG('NUMORF'),10)
   M.ORD_ANNO  = SPACE(4)

   SELECT CU_TVE_TT
   APPEND BLANK
   DO U_TVE_TT

   SELECT CUR_TVE_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_TVE_TT
      SKIP +1
      LOOP
   ENDIF

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      M.DAGGANCIO  = M.TAGGANCIO

      SELECT CU_TVE_DD
      APPEND BLANK
      DO U_TVE_DD

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_TVE_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_TVE_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle DDT tentata vendita sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_tve_tt','I','','CU_TVE_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_tve_dd','I','','CU_TVE_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_CEI_TT_DD       && CONVERTE LE TABELLE U_CEI_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE CESSIONI INTRACOMUNITARIE RELATIVE ALLE VENDITE			*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_CEI_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_CEI_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_CEI_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Cessioni intracomunitarie relative alle vendite...  -  Prego Attendere" NOWAIT
cSql = "delete from U_CEI_TT where 1=1"
IF !ExecCommand(cSql,"U_CEI_TT")
   return(.f.)
ENDIF
cSql = "delete from U_CEI_DD where 1=1"
IF !ExecCommand(cSql,"U_CEI_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMCEI'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMCEI'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_CEI_TT where 1=0"
IF !ExecCommand(cSql,"CU_CEI_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_CEI_DD where 1=0"
IF !ExecCommand(cSql,"CU_CEI_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_CEI_TT where 1=0"
IF !ExecCommand(cSql,"CUR_CEI_TT")
   return(.f.)
ENDIF
SELECT CUR_CEI_TT
SET FILTER TO
*SET FILTER TO SUBSTR(ORD_DATORD,7,4) == _V_ANNCONV
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_CEI_DD where 1=0"
IF !ExecCommand(cSql,"CUR_CEI_DD")
   return(.f.)
ENDIF
SELECT CUR_CEI_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_CEI_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga delle Cessioni intracomunitarie relative alle vendite " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO  = STR(NEWPROG('NUMCEI'),10)
   M.ORD_ANNO   = SPACE(4)
   M.ORD_PROVIN = SPACE(2)

   SELECT CU_CEI_TT
   APPEND BLANK
   DO U_CEI_TT

   SELECT CUR_CEI_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_CEI_TT
      SKIP +1
      LOOP
   ENDIF

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      M.DAGGANCIO  = M.TAGGANCIO

      SELECT CU_CEI_DD
      APPEND BLANK
      DO U_CEI_DD

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_CEI_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_CEI_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle Cessioni intracomunitarie relative alle vendite sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_cei_tt','I','','CU_CEI_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_cei_dd','I','','CU_CEI_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN




*************************************************************************************************
PROCEDURE CONV_U_CEA_TT_DD       && CONVERTE LE TABELLE U_CEA_TT-DD DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE CESSIONI INTRACOMUNITARIE RELATIVE AGLI ACQUISTI		*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_CEA_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_CEA_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_CEA_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Cessioni intracomunitarie relative agli acquisti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_CEA_TT where 1=1"
IF !ExecCommand(cSql,"U_CEA_TT")
   return(.f.)
ENDIF
cSql = "delete from U_CEA_DD where 1=1"
IF !ExecCommand(cSql,"U_CEA_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMCEA'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMCEA'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
REPLACE LIBERA WITH "5000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_CEA_TT where 1=0"
IF !ExecCommand(cSql,"CU_CEA_TT")
   return(.f.)
ENDIF
cSql = "Select * from U_CEA_DD where 1=0"
IF !ExecCommand(cSql,"CU_CEA_DD")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_CEA_TT where 1=0"
IF !ExecCommand(cSql,"CUR_CEA_TT")
   return(.f.)
ENDIF
SELECT CUR_CEA_TT
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_CEA_DD where 1=0"
IF !ExecCommand(cSql,"CUR_CEA_DD")
   return(.f.)
ENDIF
SELECT CUR_CEA_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA1  = 0
_V_CONTA2  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_CEA_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga delle Cessioni intracomunitarie relative agli acquisti " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _X_AGGAOLD = M.TAGGANCIO

   M.TAGGANCIO  = STR(NEWPROG('NUMCEA'),10)
   M.ORD_ANNO   = SPACE(4)
   M.ORD_PROVIN = SPACE(2)

   SELECT CU_CEA_TT
   APPEND BLANK
   DO U_CEA_TT

   SELECT CUR_CEA_DD
   SET ORDER TO I_INDICE
   SEEK _X_AGGAOLD
   IF FOUND()
   ELSE
      SELECT CUR_CEA_TT
      SKIP +1
      LOOP
   ENDIF

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF DAGGANCIO <> _X_AGGAOLD
         EXIT
      ENDIF

      SCATTER MEMVAR MEMO

      M.DAGGANCIO  = M.TAGGANCIO

      SELECT CU_CEA_DD
      APPEND BLANK
      DO U_CEA_DD

      _V_CONTA2 = _V_CONTA2 + 1

      SELECT CUR_CEA_DD
      SKIP +1
   ENDDO

   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_CEA_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi delle Cessioni intracomunitarie relative agli acquisti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_cea_tt','I','','CU_CEA_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_cea_dd','I','','CU_CEA_DD')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_PARA_FPS && CONVERTE I PARAMETRI DELLA TABELLA PARA DA .DBF A SQL
                        && N.B.: NON VERRANNO SOVRASCRITTI I PARAMETRI DEL VECCHIO SISTEMA
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE PARAMETRI												*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "PARA"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PARA where 1=0"
IF !ExecCommand(cSql,"CU_PARA")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
cSql = "Select * from PARA where 1=0"
IF !ExecCommand(cSql,"CUR_PARA")
   return(.f.)
ENDIF
SELECT CUR_PARA
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_PARA
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Parametro " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   M.GG_LAV     = 0
   M.PERANT     = 0
   M.PERSAL     = 0
   M.PAR_TRASME = SPACE(02)
   M.PAR_DATINS = "2005/12/31"
   M.TIPOMOV    = 0
   M.DTIPOMOV   = SPACE(90)
   M.SCAFISS    = 0


   *** SE CODICE PARAMETRO GIA' PRESENTE NELLA TABELLA PARA SQL VIENE AGGIORNATO
   x_codi = "codice = '" + M.CODICE + "'"
   x_cond = x_codi
   cSql = "select * from PARA where " + x_cond
   IF !ExecCommand(cSql,"PARA")
      return(.f.)
   ENDIF
   SELECT PARA
   GO TOP
   IF EOF()
   ELSE
      x_codi = "codice = '" + M.CODICE + "'"
      x_cond = x_codi
      cSql = "delete from PARA where " + x_cond
      IF !ExecCommand(cSql,"PARA")
         return(.f.)
      ENDIF
   ENDIF

   SELECT CU_PARA
   APPEND BLANK
   DO PARA

   _V_CONTA = _V_CONTA + 1

   SELECT CUR_PARA
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dei Parametri (tabella PARA) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','para','I','','CU_PARA')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_MAG_GG_MO    && CONVERTE LE TABELLE U_MAG_GG,U_MAG_MO DA U_MAG_AN.DBF
                              && A SQL GENERANDO UNA MOVIMENTAZIONE CON CAUSALE DI CARICO "RM+"
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA MAGAZZINO			   						*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Novembre 2005 - Modificato Giugno 2007														*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "U_MAG_AN"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLE TABELLE U_MAG_GG,U_MAG_MO,U_MAG_AN SQL
WAIT WINDOWS "Cancellazione vecchie Giacenze...  -  Prego Attendere" NOWAIT
cSql = "delete from U_MAG_GG where 1=1"
IF !ExecCommand(cSql,"U_MAG_GG")
   return(.f.)
ENDIF
WAIT WINDOWS "Cancellazione vecchie Movimentazioni...  -  Prego Attendere" NOWAIT
cSql = "delete from U_MAG_MO where 1=1"
IF !ExecCommand(cSql,"U_MAG_MO")
   return(.f.)
ENDIF
WAIT WINDOWS "Cancellazione vecchia Anagrafica magazzino...  -  Prego Attendere" NOWAIT
cSql = "delete from U_MAG_AN where 1=1"
IF !ExecCommand(cSql,"U_MAG_AN")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
CREATE CURSOR CUR_MAG_AN (MAG_CODSOC C(2),   MAG_CODMAG C(6),   MAG_ARTGRU N(3,0),  MAG_CODART C(30),  MAG_DESART C(50),  ;
                          MAG_GIACEN N(13,2),MAG_GIACIN N(13,2),MAG_CODFOR C(10),   MAG_COSTO N(19,6), MAG_UNIMIS C(3),   ;
                          MAG_DTCREA C(10),  MAG_IMPORD N(13,2),MAG_IMP1 N(13, 2),  MAG_SPEDIT N(13,2),MAG_FATTUR N(13,2),;
                          MAG_IMPFUT N(13,2),MAG_ORDATT N(13,2),MAG_ORDFUT N(13,2), MAG_TOTCAR N(14,2),MAG_TOTSCA N(14,2),;
                          MAG_MEDIOA N(14,2),MAG_MEDIOV N(14,2),MAG_IMPSIM N(13,0), MAG_VERSAT N(13,2),MAG_COORD C(23),   ;
                          MAG_VALUTA C(3),   MAG_SERIE C(3),    MAG_DSERIE C(30))
SELECT CUR_MAG_AN
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_MAG_AN
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF MAG_GIACEN > 0
   ELSE
      SKIP +1
      LOOP
   ENDIF

   V_DATAOGGI = RIBALTA2(DTOC(DATE()))
   _AN_CODSOC = MAG_CODSOC
   _AN_CODMAG = MAG_CODMAG
   _AN_ARTGRU = MAG_ARTGRU
   _AN_CODART = MAG_CODART
   _AN_DESART = MAG_DESART
   _AN_GIACEN = MAG_GIACEN
   _AN_GIACIN = MAG_GIACIN
   _AN_CODFOR = MAG_CODFOR
   _AN_COSTO  = MAG_COSTO
   _AN_UNIMIS = MAG_UNIMIS
   _AN_DTCREA = MAG_DTCREA
   _AN_IMPORD = MAG_IMPORD
   _AN_IMP1   = MAG_IMP1
   _AN_SPEDIT = MAG_SPEDIT
   _AN_FATTUR = MAG_FATTUR
   _AN_IMPFUT = MAG_IMPFUT
   _AN_ORDATT = MAG_ORDATT
   _AN_ORDFUT = MAG_ORDFUT
   _AN_TOTCAR = MAG_TOTCAR
   _AN_TOTSCA = MAG_TOTSCA
   _AN_MEDIOA = MAG_MEDIOA
   _AN_MEDIOV = MAG_MEDIOV
   _AN_IMPSIM = MAG_IMPSIM
   _AN_VERSAT = MAG_VERSAT
   _AN_COORD  = MAG_COORD
   _AN_VALUTA = MAG_VALUTA
   _AN_SERIE  = MAG_SERIE
   _AN_DSERIE = MAG_DSERIE

   WAIT WINDOWS "Conversione e scrittura Riga di Giacenza/movimentazione " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   * -->> Creazione cursore per effettuare i carichi di magazzino delle bobine di spalmato
   * -------------------------------------------------------------------------------------
   IF !ExecCommand("select * from u_bfo_dl where 0=1","u_bfo_dl")
      return(.f.)
   ENDIF
   SELECT U_BFO_DL
   =DEFPUB(SELECT())
   SCATTER MEMVAR MEMO BLANK
   HH=AFIELDS(TRANSITO)
   CREATE CURSOR CU_BFO_DL FROM ARRAY TRANSITO
   INDEX ON ORD_NUMBOB TAG I_ORDINE ADDITIVE

   IF !ExecCommand("select * from u_bfo_dd where 0=1","u_bfo_dd")
      return(.f.)
   ENDIF
   SELECT U_BFO_DD
   =DEFPUB(SELECT())
   SCATTER MEMVAR MEMO BLANK
   HH=AFIELDS(TRANSITO)
   CREATE CURSOR CU_BFO_DD FROM ARRAY TRANSITO
   INDEX ON ORD_SEQUEN TAG SEQUEN ADDITIVE    && 12/09/2002

   * -->> Creazione cursore vuoto
   * ----------------------------
   IF !ExecCommand("select * from u_ava_sp where 0=1","u_ava_sp")
      return(.f.)
   ENDIF
   SELECT U_AVA_SP
   =DEFPUB(SELECT())
   SCATTER MEMVAR MEMO BLANK
   HH=AFIELDS(TRANSITO)
   CREATE CURSOR STAMPAET FROM ARRAY TRANSITO

   * -->> Creazione cursore vuoto altri dati per funzione di magazzino
   * -----------------------------------------------------------------
   IF !ExecCommand("select * from u_alt_da where 0=1","u_alt_da")
      return(.f.)
   ENDIF
   SELECT U_ALT_DA
   =DEFPUB(SELECT())
   SCATTER MEMVAR MEMO BLANK

   RELEASE ZSA_NUMDOC,ZSA_DATDOC,ZSA_DATREG,ZSA_TOP,ZSA_DESTOP,ZSA_CODFOR,ZSA_RAGSOC,ZSA_VALUTA,ZSA_CODART,ZSA_DESART,ZSA_CODMAG,ZSA_DESMAG,ZSA_UM,             ;
           ZSA_PREACQ,ZSA_PREVEN,ZSA_CODMAT,ZSA_DESMAT,ZSA_CODCOL,ZSA_DESCOL,ZSA_SPESSO,ZSA_ALTEZZ,ZSA_LUNGHE,ZSA_CODIMB,ZSA_DESIMB,ZSA_LOTMIN,                 ;
           ZSA_SCONTO,ZSA_TIPO,ZSA_COORD,ZSA_QTXCON,ZSA_QTCONF,ZSA_CODACQ,ZSA_DESACQ,ZSA_CODBUN,ZSA_DESBUN,ZSA_NUMIDE,ZSA_ANNO,ZSA_NOTVAR,ZSA_NOTE,ZSA_GIACEN,  ;
           ZSA_TP,ZSA_CAMBIO,ZSA_VALACQ,ZSA_VALVEN,ZSA_TIPART,ZSA_CODIVA,ZSA_RIBO,ZSA_NAT,ZSA_LIB,ZSA_TMOV,ZSA_TOPCAR,ZSA_TIPOCF,ZSA_TIPOBOB,ZSA_IMBA,ZSA_SERIE, ;
           ZSA_FLGCEL,ZSA_QTACON,ZSA_CODINT,ZSA_NRLINT,X_QTXCON,X_QTCONF,ACCODA,XXX_PASSA,RRR_QTAINI,ZSA_ORAREG,ZSA_IMPEGN,ZSA_QTAMOV
   PUBLIC  ZSA_NUMDOC,ZSA_DATDOC,ZSA_DATREG,ZSA_TOP,ZSA_DESTOP,ZSA_CODFOR,ZSA_RAGSOC,ZSA_VALUTA,ZSA_CODART,ZSA_DESART,ZSA_CODMAG,ZSA_DESMAG,ZSA_UM,             ;
           ZSA_PREACQ,ZSA_PREVEN,ZSA_CODMAT,ZSA_DESMAT,ZSA_CODCOL,ZSA_DESCOL,ZSA_SPESSO,ZSA_ALTEZZ,ZSA_LUNGHE,ZSA_CODIMB,ZSA_DESIMB,ZSA_LOTMIN,                 ;
           ZSA_SCONTO,ZSA_TIPO,ZSA_COORD,ZSA_QTXCON,ZSA_QTCONF,ZSA_CODACQ,ZSA_DESACQ,ZSA_CODBUN,ZSA_DESBUN,ZSA_NUMIDE,ZSA_ANNO,ZSA_NOTVAR,ZSA_NOTE,ZSA_GIACEN,  ;
           ZSA_TP,ZSA_CAMBIO,ZSA_VALACQ,ZSA_VALVEN,ZSA_TIPART,ZSA_CODIVA,ZSA_RIBO,ZSA_NAT,ZSA_LIB,ZSA_TMOV,ZSA_TOPCAR,ZSA_TIPOCF,ZSA_TIPOBOB,ZSA_IMBA,ZSA_SERIE, ;
           ZSA_FLGCEL,ZSA_QTACON,ZSA_CODINT,ZSA_NRLINT,X_QTXCON,X_QTCONF,ACCODA,XXX_PASSA,RRR_QTAINI,ZSA_ORAREG,ZSA_IMPEGN,ZSA_QTAMOV

   ZSA_NUMDOC     = "000001"
   ZSA_DATDOC     = V_DATAOGGI
   ZSA_DATREG     = V_DATAOGGI
   *ZSA_TOP        = "INI"
   *ZSA_TOP        = "100"
   ZSA_TOP        = "RM+"
   ZSA_DESTOP     = SPACE(50)
   ZSA_QTAMOV     = _AN_GIACEN
   ZSA_VALUTA     = _AN_VALUTA
   ZSA_CODART     = _AN_CODART
   ZSA_DESART     = _AN_DESART
   ZSA_CODMAG     = _AN_CODMAG
   ZSA_CODFOR     = SPACE(10)

   x_cond = "codice = 'MAG" + ZSA_CODMAG + "'"
   cSql   = "select * from para where " + x_cond
   IF !ExecCommand(cSql,"PARA")
      RETURN .F.
   ENDIF
   SELECT PARA
   IF EOF()
      ZSA_CODMAG = "SEDE"
      ZSA_DESMAG = "MAGAZZINO CENTRALE"
   ELSE
      ZSA_DESMAG = DESCRI
   ENDIF

   ZSA_UM = _AN_UNIMIS
   **=> ERASMO - INIZIO 12/12/2012
   IF ALLTRIM(ZSA_UM) == 'N'
      ZSA_UM = "NR"
   ENDIF
   **=> ERASMO - FINE 12/12/2012

   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + ZSA_CODART + "'"
   x_cond = x_soci + " and " + x_codi
   cSql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"CUR_ARTICOLI")
      RETURN .F.
   ENDIF
   SELECT CUR_ARTICOLI
   GO TOP
   IF EOF()
      ZSA_QTXCON = 0
      ZSA_QTACON = 0
      ZSA_QTCONF = 0
      ZSA_PREACQ = 0
      ZSA_PREVEN = 0
      ZSA_CODMAT = SPACE(03)
      ZSA_DESMAT = SPACE(50)
      ZSA_CODCOL = SPACE(03)
      ZSA_DESCOL = SPACE(50)
      ZSA_SPESSO = 0
      ZSA_ALTEZZ = 0
      ZSA_LUNGHE = 0
      ZSA_CODIMB = SPACE(03)
      ZSA_DESIMB = SPACE(50)
      ZSA_LOTMIN = 0
      ZSA_TIPART = SPACE(01)
      ZSA_CODIVA = SPACE(03)
   ELSE
      ZSA_UM = ART_UMMAGA  && ERASMO - 12/12/2012
      ZSA_QTXCON = ART_QTACON
      ZSA_QTACON = ART_QTACON
*!*	      IF ALLTRIM(ART_UNIMIS) = ALLTRIM(ZSA_UM)
*!*	         ZSA_QTCONF = 0
*!*	      ELSE
*!*	         ZSA_QTCONF = ZSA_QTAMOV
*!*	         IF ART_QTACON > 0
*!*	            ZSA_QTAMOV = ZSA_QTAMOV * ART_QTACON
*!*	         ENDIF
*!*	         ZSA_UM = ART_UNIMIS
*!*	      ENDIF
      ZSA_PREACQ = ART_PRZCOS
      ZSA_PREVEN = ART_PRZVEN
      ZSA_CODMAT = ART_CODMAT
      ZSA_DESMAT = ART_DESMAT
      ZSA_CODCOL = ART_CODCOL
      ZSA_DESCOL = ART_DESCOL
      ZSA_SPESSO = ART_SPESSO
      ZSA_ALTEZZ = ART_ALTEZZ
      ZSA_LUNGHE = ART_LUNGHE
      ZSA_CODIMB = ART_CODIMB
      ZSA_DESIMB = ART_DESIMB
      ZSA_LOTMIN = ART_LOTMIN
      ZSA_TIPART = ART_TIPART
      ZSA_CODIVA = ART_CODIVA
      IF EMPTY(ALLTRIM(ZSA_CODFOR))
         ZSA_CODFOR = ART_CODF1
         IF ART_PRZCO1 > 0
            ZSA_PREACQ = ART_PRZCO1
         ENDIF
      ENDIF
      IF EMPTY(ALLTRIM(ZSA_CODFOR))
         ZSA_CODFOR = ART_CODF2
         IF ART_PRZCO2 > 0
            ZSA_PREACQ = ART_PRZCO2
         ENDIF
      ENDIF
      IF EMPTY(ALLTRIM(ZSA_CODFOR))
         ZSA_CODFOR = ART_CODF3
         IF ART_PRZCO3 > 0
            ZSA_PREACQ = ART_PRZCO3
         ENDIF
      ENDIF
      IF EMPTY(ALLTRIM(ZSA_CODFOR))
         ZSA_CODFOR = PUB_CFDEF
      ENDIF
   ENDIF

   x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "for_codcli = '" + ZSA_CODFOR + "'"
   x_cond = x_soci + " and " + x_codi
   cSql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
   IF !ExecCommand(cSql,"CUR_FORNITORI")
      RETURN .F.
   ENDIF
   SELECT CUR_FORNITORI
   GO TOP
   IF EOF()
      ZSA_CODFOR = SPACE(10)
      ZSA_RAGSOC = SPACE(40)
      ZSA_CODACQ = SPACE(03)
      ZSA_DESACQ = SPACE(50)
   ELSE
      ZSA_RAGSOC = CUR_FORNITORI.for_ragsoc
      ZSA_CODACQ = CUR_FORNITORI.for_codacq
      ZSA_DESACQ = CUR_FORNITORI.for_desacq
   ENDIF

   IF EMPTY(ALLTRIM(ZSA_VALUTA))
      ZSA_VALUTA = CUR_FORNITORI.for_valuta
   ENDIF

   ZSA_VALACQ     = ROUND((ZSA_PREACQ*ZSA_QTAMOV),2)
   ZSA_VALVEN     = ROUND((ZSA_PREVEN*ZSA_QTAMOV),2)
   ZSA_SCONTO     = 0
   ZSA_TIPO       = CERCATIPO(ZSA_CODART)
   ZSA_COORD      = SPACE(50)
   ZSA_CODBUN     = PUB_CODBUN
   ZSA_DESBUN     = SPACE(50)
   ZSA_NUMIDE     = SPACE(06)
   **=> ERASMO - INIZIO 12/12/2012
   *** VALORIZZO IN AUTOMATICO IL NUMERO IDENTIFICATIVO DEL CARICO SE NON DIGITATO MANUALMENTE
   IF EMPTY(ZSA_NUMIDE)
      x_codi = "codice = 'NUMIDC" + PUB_CODSOC + "'"
      x_cond = x_codi
      Csql   = "select * from para where " + x_cond
      IF !ExecRW(cSql,"PARA","R")
         return(.f.)
      ENDIF
      SELECT PARA
      IF EOF()
         APPEND BLANK
         REPLACE CODICE WITH 'NUMIDC' + PUB_CODSOC
         REPLACE DESCRI WITH 'PROGRESSISO IDENTIFICATIVO DI CARICO'
         REPLACE LIBERA WITH '0000000'
      ENDIF
      V2=VAL(SUBSTR(LIBERA,1,7)) + 1
      REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
      TMP_NUMIDX = VAL(ALLTRIM(SUBSTR(LIBERA,2,7)))
      TMP_NUMIDE = ALLTRIM(STR(TMP_NUMIDX,6,0))
      ZSA_NUMIDE = TRC(6,ALLTRIM(TMP_NUMIDE))
      IF !ExecRW(cSql,"PARA","W")
         return(.f.)
      ENDIF
   ENDIF
   **=> ERASMO - FINE 12/12/2012

   ZSA_ANNO       = SPACE(04)
   ZSA_NOTVAR     = SPACE(50)
   ZSA_NOTE       = SPACE(50)

   ZSA_GIACEN     = _AN_GIACEN
   ZSA_TIPOCF     = 'F'
   ZSA_SERIE      = _AN_SERIE
   ZSA_TP         = SPACE(01)
   IF ZSA_VALUTA = PUB_VALRIF
      ZSA_CAMBIO = 1
   ELSE
      *** PRELEVA IL CAMBIO DEL GIORNO
      ZSA_DATA = RIBALTA2(ZSA_DATDOC)
      x_soci = "vva_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "vva_codval = '" + ZSA_VALUTA + "'"
      x_data = "vva_data   = '" + ZSA_DATA + "'"
      x_cond = x_soci + " and " + x_codi + " and " + x_data
      cSql = "select * from u_vva_ch where " + x_cond + " order by vva_codsoc,vva_codval,vva_data"
      IF !ExecCommand(cSql,"CUR_CAMBIO")
         RETURN .F.
      ENDIF
      SELECT CUR_CAMBIO
      GO TOP
      IF EOF()
         ZSA_CAMBIO = 0
      ELSE
         ZSA_CAMBIO = VVA_CHANGE
      ENDIF
   ENDIF
   ZSA_RIBO       = 'NO'
   ZSA_NAT        = SPACE(01)
   ZSA_LIB        = SPACE(01)
   ZSA_TMOV       = SPACE(02)
   ZSA_TOPCAR     = SPACE(03)
   ZSA_TIPOBOB    = SPACE(03)
   ZSA_IMBA       = 'NO'
   ZSA_FLGCEL     = .F.
   ZSA_CODINT     = SPACE(16)
   ZSA_NRLINT     = 0
   X_QTXCON       = 0
   X_QTCONF       = 0
   ACCODA         = .F.
   XXX_PASSA      = .F.
   RRR_QTAINI     = 0
   ZSA_ORAREG     = SPACE(08)
   zsa_datreg     = V_DATAOGGI
   ZSA_IMPEGN     = 0

   RELEASE ZSA_FILA_X,ZSA_PIAN_X,ZSA_UBIC_X,ZSA_FILA_N,ZSA_PIAN_N,ZSA_UBIC_N
   PUBLIC  ZSA_FILA_X,ZSA_PIAN_X,ZSA_UBIC_X,ZSA_FILA_N,ZSA_PIAN_N,ZSA_UBIC_N
   ZSA_FILA_X = SPACE(05)
   ZSA_PIAN_X = SPACE(05)
   ZSA_UBIC_X = SPACE(05)
   ZSA_FILA_N = 0
   ZSA_PIAN_N = 0
   ZSA_UBIC_N = 0

   *ZSA_TOP    = "INI"
   ZSA_TOP    = "100"

   RELEASE M.ORD_CODMAT,M.ORD_DESMAT,M.ORD_CODCOL,M.ORD_DESCOL,M.ORD_SPESSO,M.ORD_ALTEZZ,M.ORD_LUNGHE,M.ORD_CODIMB,                 ;
           M.ORD_DESIMB,M.ORD_LOTMIN,M.ORD_NUMBOB,M.ORD_QTAKG,M.ORD_QTAMQ,M.ORD_QTAML,M.ORD_QTAKG1,M.ORD_QTAMQ1,M.ORD_QTAML1,       ;
           M.ORD_CODART,M.ORD_PREZZO,M.ORD_SC1,M.ORD_SC2,M.ORD_SC3,M.ORD_PRZNET,M.ORD_VALORE,M.ORD_QTAORD,M.ORD_CBFISC,             ;
           M.ORD_SERBOL,M.ORD_AAPROD,M.ORD_QTACON,M.ORD_SERNUM,M.ORD_NUMEDA,M.ORD_NUMEAL,M.ORD_NUMSCA,M.ORD_SALCON,M.ORS_NUMORC,    ;
           M.ORS_DATORC,M.ORD_SERIE,M.ORD_CODCLI,M.ORD_FLGCEL
   PUBLIC  M.ORD_CODMAT,M.ORD_DESMAT,M.ORD_CODCOL,M.ORD_DESCOL,M.ORD_SPESSO,M.ORD_ALTEZZ,M.ORD_LUNGHE,M.ORD_CODIMB,                 ;
           M.ORD_DESIMB,M.ORD_LOTMIN,M.ORD_NUMBOB,M.ORD_QTAKG,M.ORD_QTAMQ,M.ORD_QTAML,M.ORD_QTAKG1,M.ORD_QTAMQ1,M.ORD_QTAML1,       ;
           M.ORD_CODART,M.ORD_PREZZO,M.ORD_SC1,M.ORD_SC2,M.ORD_SC3,M.ORD_PRZNET,M.ORD_VALORE,M.ORD_QTAORD,M.ORD_CBFISC,             ;
           M.ORD_SERBOL,M.ORD_AAPROD,M.ORD_QTACON,M.ORD_SERNUM,M.ORD_NUMEDA,M.ORD_NUMEAL,M.ORD_NUMSCA,M.ORD_SALCON,M.ORS_NUMORC,    ;
           M.ORS_DATORC,M.ORD_SERIE,M.ORD_CODCLI,M.ORD_FLGCEL
   M.ORD_CODMAT = ZSA_CODMAT
   M.ORD_DESMAT = ZSA_DESMAT
   M.ORD_CODCOL = ZSA_CODCOL
   M.ORD_DESCOL = ZSA_DESCOL
   M.ORD_SPESSO = ZSA_SPESSO
   M.ORD_ALTEZZ = ZSA_ALTEZZ
   M.ORD_LUNGHE = ZSA_LUNGHE
   M.ORD_CODIMB = ZSA_CODIMB
   M.ORD_DESIMB = ZSA_DESIMB
   M.ORD_LOTMIN = ZSA_LOTMIN
   M.ORD_NUMBOB = 0
   M.ORD_QTAKG  = 0
   M.ORD_QTAMQ  = 0
   M.ORD_QTAML  = 0
   M.ORD_QTAKG1 = 0
   M.ORD_QTAMQ1 = 0
   M.ORD_QTAML1 = 0
   M.ORD_CODART = SPACE(16)
   M.ORD_PREZZO = 0
   M.ORD_SC1    = 0
   M.ORD_SC2    = 0
   M.ORD_SC3    = 0
   M.ORD_PRZNET = 0
   M.ORD_VALORE = 0
   M.ORD_QTAORD = 0
   M.ORD_CBFISC = SPACE(50)
   M.ORD_SERBOL = SPACE(03)
   M.ORD_AAPROD = 0
   M.ORD_QTACON = ZSA_QTACON
   M.ORD_SERNUM = SPACE(03)
   M.ORD_NUMEDA = 0
   M.ORD_NUMEAL = 0
   M.ORD_NUMSCA = 0
   M.ORD_SALCON = SPACE(01)
   M.ORS_NUMORC = SPACE(06)
   M.ORS_DATORC = SPACE(10)
   M.ORD_SERIE  = ZSA_SERIE
   M.ORD_CODCLI = SPACE(10)
   M.ORD_FLGCEL = .F.
   M.ORD_UM     = ZSA_UM

   **=> ERASMO - INIZIO 12/12/2012
   M.ORD_NUMIDE = ZSA_NUMIDE
   M.ORD_CODBUN = ZSA_CODBUN
   **=> ERASMO - FINE 12/12/2012



   *ZSA_TOP    = SEEK_PARA('TOP',ALLTRIM(ZSA_TOP),'CODICE','CODICE',"4,10")
   x_cond = "codice = 'TOP" + ALLTRIM(ZSA_TOP) + "'"
   cSql   = "select * from para where " + x_cond
   IF !ExecCommand(cSql,"_pj_para")
      RETURN .F.
   ENDIF
   SELECT _pj_para
   ZSA_DESTOP = "(" + SUBSTR(LIBERA,1,1) +  "/" + SUBSTR(LIBERA,24,1) + ") " +DESCRI
   ZSA_TP     = SUBSTR(LIBERA,1,1)
   ZSA_TIPORI = 1
   ZSA_NAT    = SUBSTR(LIBERA,1,1)   && (NATURA C=CARICO - S=SCARICO - D=DARE - A=AVERE)
   ZSA_LIB    = SUBSTR(LIBERA,12,1)  && (C=CLIENTE - F=FORNITORE - +/-=COMP.D.B. - A=ALTRO)
   ZSA_TMOV   = SUBSTR(LIBERA,33,2)				
   ZSA_TOPCAR = SUBSTR(LIBERA,35,3)  && CAUSALE CONTRARIA A QUELLA DIGITATA

   PUB_FILCAR_X   = SPACE(05)
   PUB_PIACAR_X   = SPACE(05)
   PUB_UBICAR_X   = SPACE(05)
   PUB_FILCAR_N   = 0
   PUB_PIACAR_N   = 0
   PUB_UBICAR_N   = 0

   ******* CONFERMA *****************
   IF EMPTY(ALLTRIM(ZSA_ANNO))
      IF SUBSTR(ZSA_DATDOC,5,1) = '/'
         ZSA_ANNO = SUBSTR(ZSA_DATDOC,1,4)
      ELSE
         ZSA_ANNO = SUBSTR(ZSA_DATDOC,7,4)
      ENDIF
   ENDIF

   PUB_TIPOBOB = ZSA_TIPOBOB

   RELEASE XXY_CODINT,XXY_NRLINT,XXY_BOBNUD,XXY_ADESIVI,XXY_CART,Y_TIPO
   PUBLIC  XXY_CODINT,XXY_NRLINT,XXY_BOBNUD,XXY_ADESIVI,XXY_CART,Y_TIPO
   XXY_CODINT  = SPACE(16)
   XXY_NRLINT  = 0
   XXY_BOBNUD  = ""
   XXY_ADESIVI = ""
   Y_TIPO      = ""

   M.ORD_CODART = ZSA_CODART
   XXY_CART     = ZSA_CODART

   PUB_FILCAR_X   = ZSA_FILA_X
   PUB_PIACAR_X   = ZSA_PIAN_X
   PUB_UBICAR_X   = ZSA_UBIC_X
   PUB_FILCAR_N   = ZSA_FILA_N
   PUB_PIACAR_N   = ZSA_PIAN_N
   PUB_UBICAR_N   = ZSA_UBIC_N

   PUB_SPOSTAMAGA = .T.

   **** GESTIONECELOPHANATO *********
   *=> Inizializzazione varialibi

   PUB_DATREG = RIBALTA2(ZSA_DATREG)

   _X_QTAML  = M.ORD_QTAML
   _X_QTAMQ  = M.ORD_QTAMQ
   _X_QTAKG  = M.ORD_QTAKG
   _X_QTAML1 = M.ORD_QTAML
   _X_QTAMQ1 = M.ORD_QTAMQ
   _X_QTAKG1 = M.ORD_QTAKG
   _X_ALTEZZ = M.ORD_ALTEZZ
   _X_LUNGHE = M.ORD_LUNGHE
   _X_DESART = ZSA_DESART
   _X_PRZVEN = ZSA_PREVEN
   _X_PRZACQ = ZSA_PREACQ
   _X_CODIVA = ZSA_CODIVA

   IF EMPTY(ALLTRIM(ZSA_CODFOR))
      _X_CODFOR = PUB_CFDEF
      _X_RAGSOC = SPACE(50)
      *=> Accesso alla anagrafica fornitori per prelevare la ragione sociale
      x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "for_codcli = '" + ALLTRIM(_X_CODFOR) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
      IF !ExecCommand(cSql,"cur_fornitore")
         return(.f.)
      ENDIF
      SELECT cur_fornitore
      GO TOP
      IF EOF()
      ELSE
         _X_RAGSOC = FOR_RAGSOC
      ENDIF
   ELSE
      _X_CODFOR = ZSA_CODFOR
      _X_RAGSOC = ZSA_RAGSOC
   ENDIF

   *=> Inizializzazione cursori di appoggio per richiamare la stessa routine utilizzata per il carico magazzino da
   *=> ordini a fornitori

   SELECT CU_BFO_DD
   ZAP

   SELECT CU_BFO_DL
   ZAP

   XXX_SEQUEN = 10
   XXX_NUMBOB = M.ORD_NUMBOB

   SELECT CU_BFO_DD
   APPEND BLANK
   GATHER MEMVAR MEMO
   REPLACE DAGGANCIO  WITH '1111111111'
   REPLACE ORD_CODART WITH ZSA_CODART
   *REPLACE ORD_UM     WITH 'KG'
   REPLACE ORD_IVA    WITH _X_CODIVA
   REPLACE ORD_DESART WITH _X_DESART
   REPLACE ORD_MAGA   WITH ZSA_CODMAG			
   REPLACE ORD_QTAORD WITH ZSA_QTAMOV
   REPLACE ORD_PREZZO WITH _X_PRZACQ
   REPLACE ORD_SC1    WITH 0
   REPLACE ORD_SC2    WITH 0
   REPLACE ORD_SC3    WITH 0
   REPLACE ORD_PRZNET WITH _X_PRZACQ
   REPLACE ORD_VALORE WITH ROUND((ORD_PRZNET*ORD_QTAORD),2)
   REPLACE ORD_DATCON WITH RIBALTA2(DTOC(DATE()))
   REPLACE ORD_CODSYS WITH SYS(2015)
   REPLACE ORS_CODCLI WITH _X_CODFOR
   REPLACE ORS_RAGSOC WITH _X_RAGSOC
   REPLACE ORS_NUMORD WITH ZSA_NUMDOC
   =CAMBIADT(ZSA_DATDOC,"ORS_DATORD")
   REPLACE ORS_VALUTA WITH ZSA_VALUTA
   REPLACE ORD_SEQUEN WITH XXX_SEQUEN
   REPLACE ORD_CODCOL WITH ZSA_CODCOL
   REPLACE ORD_DESCOL WITH ZSA_DESCOL
   REPLACE ORS_CODACQ WITH ZSA_CODACQ
   REPLACE ORD_LEGAME WITH '1111111111'
   REPLACE ORD_LEGSYS WITH SYS(2015)
   REPLACE ORD_FLGMOD WITH 'I'
   REPLACE ORS_NUMIDE WITH ZSA_NUMIDE
   REPLACE ORS_ANNO   WITH ZSA_ANNO
   REPLACE ORD_LEGASY WITH SYS(2015)
   REPLACE ORD_SALCON WITH 'S'
   REPLACE ORD_DTASCA WITH RIBALTA2(DTOC(DATE()))
   REPLACE ORD_QTAML  WITH _X_QTAML
   REPLACE ORD_QTAMQ  WITH _X_QTAMQ
   REPLACE ORD_QTAKG  WITH _X_QTAKG
   REPLACE ORD_QTAML1 WITH _X_QTAML1
   REPLACE ORD_QTAMQ1 WITH _X_QTAMQ1
   REPLACE ORD_QTAKG1 WITH _X_QTAKG1
   REPLACE ORD_ALTEZZ WITH _X_ALTEZZ
   REPLACE ORD_LUNGHE WITH _X_LUNGHE
   REPLACE ORD_FLGCEL WITH ZSA_FLGCEL
   SCATTER MEMVAR MEMO

   M.ORD_CAUS   = ZSA_TOP
   M.ORD_NUMORD = ZSA_NUMDOC
   M.ORD_DATORD = ZSA_DATDOC
   M.ORD_CODCLI = M.ORS_CODCLI
   M.ORD_RAGSOC = M.ORS_RAGSOC
   M.ORD_CODACQ = M.ORS_CODACQ
   M.ORD_VALUTA = M.ORS_VALUTA

   _X_QTAML  = M.ORD_QTAML1
   _X_QTAMQ  = M.ORD_QTAMQ1
   _X_QTAKG  = M.ORD_QTAKG1

   M.ORD_CODART = XXY_CART
   ZSA_CODART   = M.ORD_CODART

   SELECT CU_BFO_DD
   GO TOP

   U_AGGIORNA = .T.
   ZZZ_FLGTIP = 9

   *=> Variabili che alla fine conterranno il codice ed il numero di lotto interno

   XXY_CODINT  = SPACE(16)
   XXY_NRLINT  = 0
   XXY_BOBNUD  = ""
   XXY_ADESIVI = ""

   *=> Richiamo della procedura per il carico magazzino da ordini a fornitori

   *DO BFOCAMAGA
   =AQM_GESTIONE_CARICHI_BFO("MENU_MOVIMAGA")  && ERASMO - 12/12/2012

   U_AGGIORNA = .F.

   PUB_DATREG = SPACE(10)

   **********************************

   SELECT U_BFO_DD
   SCATTER MEMVAR MEMO BLANK

   PUB_SPOSTAMAGA = .F.

   ZSA_CODART = SPACE(16)
   ZSA_DESART = SPACE(40)
   ZSA_UM     = SPACE(02)
   ZSA_QTAMOV = 0
   ZSA_GIACEN = 0
   ZSA_IMPEGN = 0
   ZSA_COORD  = SPACE(01)

   PUB_FILCAR_X   = SPACE(05)
   PUB_PIACAR_X   = SPACE(05)
   PUB_UBICAR_X   = SPACE(05)
   PUB_FILCAR_N   = 0
   PUB_PIACAR_N   = 0
   PUB_UBICAR_N   = 0

   **********************************

   _V_CONTA  = _V_CONTA + 1

   SELECT CUR_MAG_AN
   SKIP +1

ENDDO

IF _V_CONTA > 0
   _V_OKELAB = .T.
ENDIF

RETURN



*************************************************************************************************
PROCEDURE CONV_U_VEN_CL && RIALLINEAMENTO ARCHIVIO RIEPILOGATO DELL'ORDINATO CLIENTI/FORNITORI,
                        && EVASO E FATTURATO
*************************************************************************************************
*************************************************************************************************
*							RIGENERAZIONE TABELLA U_VEN_CL   									*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Gennaio 2006				 																*
*************************************************************************************************


RELEASE _V_TABLE_TT,_V_TABLE_DD,_V_TIPOARC,_V_TIPORD,_V_TIPORF,_V_TIPBOL,_V_TIPFAT,_V_DATADA,_V_DATAAL,_V_DESCRIZ,V_CAUSALE
PUBLIC  _V_TABLE_TT,_V_TABLE_DD,_V_TIPOARC,_V_TIPORD,_V_TIPORF,_V_TIPBOL,_V_TIPFAT,_V_DATADA,_V_DATAAL,_V_DESCRIZ,V_CAUSALE

_V_TABLE_TT = SPACE(08)
_V_TABLE_DD = SPACE(08)
_V_TIPOARC  = SPACE(03)
_V_TIPORD   = .T.
_V_TIPORF   = .T.
_V_TIPBOL   = .f.
_V_TIPFAT   = .f.
_V_DATADA   = '01/01/2000'
_V_DATAAL   = '31/12/2999'
_V_DESCRIZ  = SPACE(50)
V_CAUSALE   = SPACE(04)

V_ELAALL = 0
V_ELAORD = 0
V_ELABOL = 0
V_ELAFAT = 0
V_ELAORF = 0

WAIT WINDOWS "Inizio Elaborazione per riallineamento archivio riepilogato dell'ordinato clienti/fornitori, " + ;
             "evaso e fatturato...  -- Prego attendere" NOWAIT

IF _V_TIPORD				&& ordinato clienti
   _V_DESCRIZ  = 'RIGENERAZIONE TABELLA U_VEN_CL - ORDINATO CLIENTI  -  Numero records letti : '
   _V_TABLE_TT = 'U_ORD_TT'
   _V_TABLE_DD = 'U_ORD_DD'
   _V_TIPOARC  = 'ORD'
   DO ELABORA_DATI
   V_ELAORD = V_ELAALL
ENDIF

V_ELAALL = 0

IF _V_TIPBOL				&& evaso
   _V_DESCRIZ  = 'RIGENERAZIONE TABELLA U_VEN_CL - BOLLE DI EVASIONE  -  Numero records letti : '
   _V_TABLE_TT = 'U_BOL_TT'
   _V_TABLE_DD = 'U_BOL_DD'
   _V_TIPOARC  = 'BOL'
   DO ELABORA_DATI
ENDIF

V_ELAALL = 0

IF _V_TIPFAT				&& fatturato
   _V_DESCRIZ  = 'RIGENERAZIONE TABELLA U_VEN_CL - FATTURE DI VENDITA  -  Numero records letti : '
   _V_TABLE_TT = 'U_FAT_TT'
   _V_TABLE_DD = 'U_FAT_DD'
   _V_TIPOARC  = 'FAT'
   DO ELABORA_DATI
ENDIF

V_ELAALL = 0

IF _V_TIPORF				&& ordinato fornitori
   _V_DESCRIZ  = 'RIGENERAZIONE TABELLA U_VEN_CL - ORDINATO FORNITORI  -  Numero records letti : '
   _V_TABLE_TT = 'U_ORF_TT'
   _V_TABLE_DD = 'U_ORF_DD'
   _V_TIPOARC  = 'ORF'
   DO ELABORA_DATI
ENDIF

RETURN

*********************************************************
PROCEDURE ELABORA_DATI && RIALLINEMENTO ARCHIVIO U_VEN_CL
*********************************************************
WAIT WINDOWS "Elaborazione per riallineamento archivio riepilogato U_VEN_CL in corso...  -- Prego attendere" NOWAIT

x_annoda = SUBSTR(_V_DATADA,7,4)
x_meseda = SUBSTR(_V_DATADA,4,2)
x_annoal = SUBSTR(_V_DATAAL,7,4)
x_meseal = SUBSTR(_V_DATAAL,4,2)

x_soci = "ven_codsoc = '" + PUB_CODSOC + "'"
x_anda = "ven_anno >= " + ALLTRIM(x_annoda)
x_anal = "ven_anno <= " + ALLTRIM(x_annoal)
x_meda = "ven_mese >= " + ALLTRIM(x_meseda)
x_meal = "ven_mese <= " + ALLTRIM(x_meseal)
x_tipo = "ven_tipdoc = '" + _V_TIPOARC + "'"
x_cond = x_soci + " and " + x_anda + " and " + x_anal + " and " + ;
         x_meda + " and " + x_meal + " and " + x_tipo
cSql   = "delete from u_ven_cl where " + x_cond
IF !ExecCommand(cSql,'U_VEN_CL')
    return(.f.)
ENDIF

_C_TABLE_TT = 'C' + _V_TABLE_TT
_C_TABLE_DD = 'C' + _V_TABLE_DD

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_data = "ord_datord >= '" + RIBALTA2(_V_DATADA) + "'"
x_cond = x_soci + " and " + x_data
cSql   = "select * from " + _V_TABLE_TT + " where " + x_cond + " order by ord_codsoc,ord_datord,ord_numord"
IF !ExecCommand(cSql,"&_C_TABLE_TT")
   return(.f.)
ENDIF
SELECT &_C_TABLE_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ORD_DATORD > RIBALTA2(_V_DATAAL)
      EXIT
   ENDIF

   V_ELAALL  = V_ELAALL + 1
   V_CAUSALE = ORD_CAUS

   WAIT WINDOWS _V_DESCRIZ + ALLTRIM(STR(V_ELAALL,10,0)) + "   -  Numero " + ord_numord + " del " + ribalta2(ord_datord) + "  Cliente/Fornitore : " + ALLTRIM(ord_ragsoc) + "  Top : " + ord_caus NOWAIT

   x_cond = "daggancio = '" + TAGGANCIO + "'"
   cSql   = "select * from " + _V_TABLE_DD + " where " + x_cond + " order by ord_sequen"
   IF !ExecCommand(cSql,"&_C_TABLE_DD")
      return(.f.)
   ENDIF
   SELECT &_C_TABLE_DD
   GO TOP

   DO GESTIONE_RIEPILOGO WITH 'INS',_V_TIPOARC,V_CAUSALE,SPACE(10)	

   SELECT &_C_TABLE_TT
   SKIP +1

ENDDO

RETURN



*************************************************************************************************
PROCEDURE CONV_U_CLI_AN_SOP      && CONVERTE LA TABELLA U_CLI_AN DA .DBF A SQL
*************************************************************************************************

*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CLIENTI			    						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.														 	*
*	Settembre 2007 - Modificato ----------														*
*************************************************************************************************



*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

MESSAGEBOX("ARCHIVIO IN INPUT DA ELABORARE :" + CHR(13) + ;
              "AQ_ANACLI",64,"Informazione")

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_ANACLI"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CLI_AN SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica clienti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_CLI_AN where 1=1"
IF !ExecCommand(cSql,"U_CLI_AN")
   return(.f.)
ENDIF



*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_CLI_AN where 1=0"
IF !ExecCommand(cSql,"CU_CLI_AN")
   return(.f.)
ENDIF
SELECT CU_CLI_AN
=DEFPUB(SELECT())

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA ############################## input
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH


=OPENDB("stati_esteri")
SELECT stati_esteri
SET ORDER TO mac_cod


=OPENDB("AQ_CAUSPAG")
SELECT AQ_CAUSPAG
SET ORDER TO PAGCOD


=OPENDB("AQ_ANACLI")
SELECT AQ_ANACLI

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT AQ_ANACLI
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
		SELECT AQ_ANACLI
	   	SKIP +1
		LOOP
   ENDIF


   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Cliente " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT



	M.CLI_CODSOC 	= PUB_CODSOC
	M.CLI_CODCLI	= TRC(PUB_LCL,ALLTRIM(M.CLICOD))
	M.CLI_RAGSOC	= CONV_CLEAR(APITOSPA(M.CLIRAG1))
	M.CLI_RAGDUE	= CONV_CLEAR(APITOSPA(M.CLIRAG2))


	M.CLI_INDIR		= CONV_CLEAR(APITOSPA(M.CLIIND))
	M.CLI_CAP		= CONV_CLEAR(APITOSPA(M.CLICAP))
	M.CLI_LOCALI	= CONV_CLEAR(APITOSPA(M.CLICITTA))
	M.CLI_PROVIN	= CONV_CLEAR(APITOSPA(M.CLIPROV))
	M.CLI_NAZION	= CONV_CERCA_NAZIONE(CONV_CLEAR(APITOSPA(M.CLINAZION)))
	
	IF ALLTRIM(M.CLI_NAZION)	= "IT"
		M.CLI_NAZION	= "ITA"
	ENDIF		

	
	M.CLI_PARIVA	= CONV_CLEAR(APITOSPA(M.CLIPIVA))
	M.CLI_CODFIS	= CONV_CLEAR(APITOSPA(M.CLICFIS))
	M.CLI_IVACEE	= ""
	
		
	M.CLI_PF		= ""

*!*	IF SUBSTR(M.CLI_RAGSOC,1,5) = "SOLME"
*!*	 SET STEP ON
*!*	ENDIF


	M.CLI_ZONA		= CONV_CLEAR(APITOSPA(M.ZONACOD))
	M.CLI_AGE		= ALLTRIM(CONV_CLEAR(APITOSPA(M.AGECODE)))
	
	IF EMPTY(ALLTRIM(M.CLI_AGE))
	   M.CLI_AGE = "01"
	ENDIF

	IF SUBSTR(M.CLI_AGE,1,1) = " "
	   M.CLI_AGE = "01"
	ENDIF
	
	
	M.CLI_TELEFO	= CONV_CLEAR(APITOSPA(M.CLITEL1))
	M.CLI_TELEX		= CONV_CLEAR(APITOSPA(M.CLITEL2))
	M.CLI_FAX		= CONV_CLEAR(APITOSPA(M.CLIFAX))
	
	M.CLI_NOTE		= ALLTRIM(CONV_CLEAR(APITOSPA(M.CLIFAX2))) + CHR(13)  + "Referente  : " + ALLTRIM(CONV_CLEAR(APITOSPA(M.REFPERS))) + CHR(13) + "Internet  : " + ALLTRIM(CONV_CLEAR(APITOSPA(M.INTERNET)))
	
	M.CLI_CONPAG	= CONV_CERCA_CPA(CONV_CLEAR(APITOSPA(M.PAGCOD)),"ANAGRAFICA_CLI_FOR")
	
	M.CLI_BAE		= CONV_CLEAR(APITOSPA(M.abicab))
	M.CLI_BPF		= ""
	M.CLI_INDEFF	= ""
	M.CLI_CODIVA	= PUB_IVA
	M.CLI_DTCLES    = CONV_CLEAR(RIBALTA2(DTOC(M.FINEESE)))
	M.CLI_ALRID 	= CONV_CLEAR(APITOSPA(ALLTRIM(M.ESENZIO)))
	
*!*		DO CASE
*!*			CASE M.CLI_ALRID = "NI4"
*!*			
*!*		ENDCASE
	
	M.CLI_SOSIMP	= ""
	M.CLI_ENASAR	= ""
	M.CLI_CLIES		= ""
	M.CLI_NSES		= ""
	M.CLI_DTNSES	= ""
	

	M.CLI_LOCDOC	= ""
	M.CLI_INDDOC	= ""
	
	DO CASE
		CASE ALLTRIM(CONV_CLEAR(APITOSPA(ALLTRIM(M.DESPOR)))) = "FRANCO"
	    	M.CLI_PORTO		= "05"
	    	
		CASE ALLTRIM(CONV_CLEAR(APITOSPA(ALLTRIM(M.DESPOR)))) = "ASSEGNATO"
	    	M.CLI_PORTO		= "06"

	
	    OTHERWISE
	    	M.CLI_PORTO		= ""
	
	ENDCASE
	
	
	DO CASE
		CASE ALLTRIM(CONV_CLEAR(APITOSPA(ALLTRIM(M.CODMEZ)))) = "V"
	    	M.CLI_MEZZO		= "03"
	    	
		CASE ALLTRIM(CONV_CLEAR(APITOSPA(ALLTRIM(M.CODMEZ)))) = "D"
	    	M.CLI_MEZZO		= "?D"

		CASE ALLTRIM(CONV_CLEAR(APITOSPA(ALLTRIM(M.CODMEZ)))) = "M"
	    	M.CLI_MEZZO		= "?M"

	
	    OTHERWISE
	    	M.CLI_MEZZO		= ""
	
	ENDCASE


	M.CLI_VETTO1	= CONV_CLEAR(APITOSPA(ALLTRIM(M.VETCOD1)))
	M.CLI_VETTO2	= CONV_CLEAR(APITOSPA(ALLTRIM(M.VETCOD2)))
	M.CLI_VETTO3	= ""
	M.CLI_BOLLI		= ""
	M.CLI_PRIVAC	= CONV_CLEAR(APITOSPA(ALLTRIM(M.PRIVACY)))


    M.CLI_BDAL   	= "0108"
    M.CLI_BAL    	= "3108"
    M.CLI_GG1    	= "1009"
    M.CLI_B2DAL  	= "2012"
    M.CLI_B2AL   	= "3112"
    M.CLI_GG2    	= "1001"


	M.CLI_DATNEW = RIBALTA2(DTOC(DATE()))
	M.CLI_DATINS = RIBALTA2(DTOC(DATE()))




	M.CLI_CLFIDO	= ""
	M.CLI_IMPFID	= 0
	M.CLI_TOTORD	= 0
	M.CLI_PERC		= 0
	M.CLI_SCON		= 0
	IF EMPTY(CONV_CLEAR(APITOSPA(ALLTRIM(M.DIVCOD))))
		M.CLI_VALUTA	= "EUR"
	ELSE
		M.CLI_VALUTA	= CONV_CLEAR(APITOSPA(ALLTRIM(M.DIVCOD)))
	ENDIF
	M.CLI_SPINCA	= 0

	M.CLI_LISTIN	= ""
	M.CLI_LISCLI    = CONV_CLEAR(APITOSPA(ALLTRIM(M.CLILIST)))
	M.CLI_CONTO1	= CONV_CLEAR(APITOSPA(ALLTRIM(M.CONTROP)))
	M.CLI_CONTO2	= ""
	M.CLI_CONTO3	= ""
	M.CLI_CONTO4	= ""
	M.CLI_CONTO5	= ""
	M.CLI_TRASME	= ""
	M.CLI_PROVVI	= 0
	M.CLI_DTCLOK	= ""
	M.SELEZIONE		= ""
	M.CLI_RICERC	= ""
*!*		M.CLI_NOPROV	= 0
	M.CLI_CATEGO	= ""
	M.CLI_SC1		= 0
	M.CLI_SC2		= 0
	M.CLI_SC3		= 0
	M.CLI_NUMCC		= ""
	M.CLI_CLISPE	= ""
	M.CLI_EMAIL		= CONV_CLEAR(APITOSPA(ALLTRIM(M.EMAIL)))
	M.CLI_CODTXT	= ""
	M.CLI_RCXDIR	= ""
	M.CLI_RCXNOM	= ""
	M.CLI_RCXPRG	= 0
	M.CLI_RCXPRO	= .F.
	M.CLI_TRXDIR	= ""
	M.CLI_TRXNOM	= ""
	M.CLI_TRXPRG	= 0
	M.CLI_TRXPRO	= .F.
	M.CLI_FLGDIR	= .F.
	M.CLI_CODDIR	= ""
	M.CLI_RAGDIR	= ""

	M.CLI_FLGFID	= ""
*!*		M.CLI_CODCHE	= ""
*!*		M.CLI_CODCIN	= ""
*!*		M.CLI_CODABI	= ""
*!*		M.CLI_CODCAB	= ""
*!*		M.CLI_CDIBAN	= ""
	M.CLI_FLGABP	= ""
	M.CLI_UFFIVA	= ""
	M.CLI_DELDOC	= ""
	M.CLI_CLASSE	= ""
	M.CLI_PERSMA	= ""
	M.CLI_CODIMB	= ""
	M.CLI_BAEFOR	= ""
	M.CLI_NAZFOR	= ""
	M.CLI_CHEFOR	= ""
	M.CLI_CINFOR	= ""
	M.CLI_ABIFOR	= ""
	M.CLI_CABFOR	= ""
	M.CLI_NCCFOR	= ""
	M.CLI_IBAFOR	= ""
	M.CLI_BSWFOR	= ""
	M.CLI_FLGAGG	= .F.
	M.CLI_EVATOT	= .F.
	M.CLI_ORDDDT	= .F.
	M.CLI_CDMAGD	= ""
	M.CLI_DSMAGD	= ""

	M.CLI_CCOST1	= ""
	M.CLI_CCOST2	= ""
	M.CLI_CCOST3	= ""
	M.CLI_CCOST4	= ""
	M.CLI_CCOST5	= ""

	M.CLI_PERCON1	= 0
	M.CLI_PERCON2	= 0
	M.CLI_PERCON3	= 0
	M.CLI_PERCON4	= 0
	M.CLI_PERCON5	= 0


	M.CLI_PERCON 	= 0
	M.CLI_PERCO2 	= 0
	M.CLI_PERCO3 	= 0
	M.CLI_PERCO4 	= 0
	M.CLI_PERCO5 	= 0


	M.CLI_FLGRCQ 	= .F.
	M.CLI_VENROT 	= .F.

	M.CLI_DTCLOK 	= ""
	M.CLI_OBSOL 	= ""

	M.IDAnaAzi 		= ""
	M.Codice 		= ""

	M.CLI_SPTRAS 	= 0
	M.CLI_INCASS 	= ""

	M.CLI_PERS01	= ""
	M.CLI_EMAIL1	= ""

	M.CLI_PERS02	= ""
	M.CLI_EMAIL2	= ""

	M.CLI_PERS03	= ""
	M.CLI_EMAIL3	= ""

	M.CLI_PERS04	= ""
	M.CLI_EMAIL4	= ""

	M.CLI_PERS05	= ""
	M.CLI_EMAIL5	= ""


   M.CLI_DELDOC   = SPACE(50)
   M.CLI_UFFIVA   = SPACE(30)
   M.CLI_CODIMB   = SPACE(03)
   M.CLI_FLGFID   = .F.
   M.CLI_CODCON   = SPACE(10)
   M.CLI_FLGTRA   = .F.
   M.CLI_CODCHE   = SPACE(02)
   M.CLI_CODCIN   = SPACE(02)
   M.CLI_CODABI   = SUBSTR(CONV_CLEAR(APITOSPA(M.ABICAB)),1,5)
   M.CLI_CODCAB   = SUBSTR(CONV_CLEAR(APITOSPA(M.ABICAB)),6,5)

   M.CLI_CDIBAN = SUBSTR(M.CLI_NAZION,1,2) + ALLTRIM(M.CLI_CODCHE) + M.CLI_CODCIN + M.CLI_CODABI + M.CLI_CODCAB + M.CLI_NUMCC

   M.CLI_VALIMP   = 0
   M.CLI_NUMINSOL = SPACE(03)
   M.CLI_LINGUA   = SPACE(03)
   M.CLI_SOTZONA  = SPACE(03)
   M.CLI_ABI2     = SPACE(04)
   M.CLI_CAB2     = SPACE(05)
   M.CLI_FLGABP   = .F.
   M.CLI_CLASSE   = SPACE(01)
   M.CLI_PERSMA   = SPACE(02)
   M.CLI_BAEFOR   = SPACE(05)
   M.CLI_NAZFOR   = SPACE(03)
   M.CLI_CHEFOR   = SPACE(02)
   M.CLI_CINFOR   = SPACE(02)
   M.CLI_ABIFOR   = SPACE(05)
   M.CLI_CABFOR   = SPACE(05)
   M.CLI_NCCFOR   = SPACE(12)
   M.CLI_IBAFOR   = SPACE(29)
   M.CLI_BSWFOR   = SPACE(100)
   M.CLI_FLGAGG   = .F.



   *** VALORI DI DEFAULT
   M.CLI_CODCLI = UPPER(M.CLI_CODCLI)
   M.CLI_CODCLI = CONV_CLEAR(APITOSPA(M.CLI_CODCLI))

   IF EMPTY(M.CLI_NAZION)
      M.CLI_NAZION = PUB_NAZI
   ENDIF	
*!*	   IF EMPTY(M.CLI_AGE)
*!*	      M.CLI_AGE    = PUB_AGE
*!*	   ENDIF
   IF EMPTY(M.CLI_CONPAG)
      M.CLI_CONPAG = PUB_CPA
   ENDIF
   IF EMPTY(M.CLI_VALUTA)
      M.CLI_VALUTA = PUB_VALU
   ENDIF
   IF M.CLI_SC1 = 0
      M.CLI_SC1 = PUB_SC1
   ENDIF	
   IF M.CLI_SC2 = 0
      M.CLI_SC2 = PUB_SC2
   ENDIF	
   IF M.CLI_SC3 = 0
      M.CLI_SC3 = PUB_SC3
   ENDIF	
   IF M.CLI_PROVVI = 0
      M.CLI_PROVVI = PUB_PROVVI
   ENDIF

   M.CLI_TIPFAT 	= "FDV"

   IF M.CLI_NAZION = "ITA"
   		M.CLI_conto1 = "401001"   		&& CLIENTE ITALIANO
   ELSE
   		M.CLI_conto1 = "401004"   		&& CLIENTE CEE  // 401003  EXTRACEE
   ENDIF


   SELECT CU_CLI_AN
   APPEND BLANK
   DO U_CLI_AN

   REPLACE CLI_CODCON 	WITH M.CLI_CODCON
   REPLACE CLI_VALIMP 	WITH M.CLI_VALIMP
   REPLACE CLI_NUMINSOL WITH M.CLI_NUMINSOL
   REPLACE CLI_LINGUA 	WITH M.CLI_LINGUA
   REPLACE CLI_SOTZONA 	WITH M.CLI_SOTZONA
   REPLACE CLI_ABI2 	WITH M.CLI_ABI2
   REPLACE CLI_CAB2 	WITH M.CLI_CAB2

   _V_CONTA  = _V_CONTA + 1

   SELECT AQ_ANACLI
   SKIP +1

ENDDO


* INSERISCE I CODICI CLIENTI INESISTENTI

SELECT CU_CLI_AN
SCATTER MEMVAR MEMO
APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CLI_CODCLI WITH "000000000"
REPLACE CLI_RAGSOC WITH "CLIENTE INESISTENTE *******"


APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CLI_CODCLI WITH "000000274"
REPLACE CLI_RAGSOC WITH "CLIENTE INESISTENTE *******"


APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CLI_CODCLI WITH "000000286"
REPLACE CLI_RAGSOC WITH "CLIENTE INESISTENTE *******"

APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CLI_CODCLI WITH "000000298"
REPLACE CLI_RAGSOC WITH "CLIENTE INESISTENTE *******"


APPEND BLANK
GATHER MEMVAR MEMO
REPLACE CLI_CODCLI WITH "000001305"
REPLACE CLI_RAGSOC WITH "CLIENTE INESISTENTE *******"


*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica clienti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_cli_an','I','','CU_CLI_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF


SET DEFA TO &PUB_DIR


RETURN




*************************************************************************************************
PROCEDURE CONV_U_FOR_AN_SOP       && CONVERTE LA TABELLA U_FOR_AN DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE ANAGRAFICA FORNITORI		    						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.														 	*
*	Ottobre 2007 - Modificato ----------														*
*************************************************************************************************



*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""


MESSAGEBOX("ARCHIVIO IN INPUT DA ELABORARE :" + CHR(13) + ;
              "AQ_ANAFOR",64,"Informazione")


V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_ANAFOR"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_FOR_AN SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica fornitori...  -  Prego Attendere" NOWAIT
cSql = "delete from U_FOR_AN where 1=1"
IF !ExecCommand(cSql,"U_FOR_AN")
   return(.f.)
ENDIF



*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_FOR_AN where 1=0"
IF !ExecCommand(cSql,"CU_FOR_AN")
   return(.f.)
ENDIF
SELECT CU_FOR_AN
=DEFPUB(SELECT())

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA ############################## input
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH


=OPENDB("stati_esteri")
SELECT stati_esteri
SET ORDER TO mac_cod


=OPENDB("AQ_CAUSPAG")
SELECT AQ_CAUSPAG
SET ORDER TO PAGCOD


=OPENDB("AQ_ANAFOR")
SELECT AQ_ANAFOR

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT AQ_ANAFOR
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
		SELECT AQ_ANAFOR
	   	SKIP +1
		LOOP
   ENDIF


   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Fornitore " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT



	M.FOR_CODSOC 	= PUB_CODSOC
	M.FOR_CODCLI	= TRC(PUB_LCL,ALLTRIM(M.FORCOD))
	M.FOR_IVACEE	= ""
	M.FOR_PARIVA	= CONV_CLEAR(APITOSPA(M.FORPIVA))
	M.FOR_CODFIS	= CONV_CLEAR(APITOSPA(M.FORCFIS))
		
	M.FOR_RAGSOC	= CONV_CLEAR(APITOSPA(M.FORRAG1))
	M.FOR_PF		= ""
	M.FOR_RAGDUE	= CONV_CLEAR(APITOSPA(M.FORRAG2))
	M.FOR_INDIR		= CONV_CLEAR(APITOSPA(M.FORIND))
	M.FOR_CAP		= CONV_CLEAR(APITOSPA(M.FORCAP))
	M.FOR_LOCALI	= CONV_CLEAR(APITOSPA(M.FORCITTA))
	

	IF EMPTY(CONV_CLEAR(APITOSPA(M.FORNAZ)))
		M.FORNAZ	= "IT"
	ENDIF		

	M.FOR_NAZION	= CONV_CERCA_NAZIONE(CONV_CLEAR(APITOSPA(M.FORNAZ)))

	M.FOR_PROVIN	= CONV_CLEAR(APITOSPA(M.FORPROV))
	

    IF EMPTY(M.FOR_NAZION)
        M.FOR_NAZION = PUB_NAZI
    ENDIF	

    IF SUBSTR(M.FOR_NAZION,1,1) = ' '
        M.FOR_NAZION = "ITA"
    ENDIF	
	


	M.FOR_ZONA		= CONV_CLEAR(APITOSPA(M.ZONACOD))
	M.FOR_TELEFO	= CONV_CLEAR(APITOSPA(M.FORTEL1))
	M.FOR_TELEX		= CONV_CLEAR(APITOSPA(M.FORTEL2))
	M.FOR_FAX		= CONV_CLEAR(APITOSPA(M.FORFAX))
	
	M.FOR_NOTE		= ALLTRIM(CONV_CLEAR(APITOSPA(M.FORFAX2))) + CHR(13)  + "Referente  : " + ALLTRIM(CONV_CLEAR(APITOSPA(M.REFPERS))) + CHR(13) + "Internet  : " + ALLTRIM(CONV_CLEAR(APITOSPA(M.INTERNET)))
	
	M.FOR_CONPAG	= CONV_CERCA_CPA(CONV_CLEAR(APITOSPA(M.PAGCOD)),"ANAGRAFICA_CLI_FOR")
					
	M.FOR_BAE		= CONV_CLEAR(APITOSPA(M.abicab))
	M.FOR_BPF		= ""
	M.FOR_INDEFF	= ""
	M.FOR_CODIVA	= PUB_IVA


	M.FOR_VETTO1	= CONV_CLEAR(APITOSPA(ALLTRIM(M.VETCOD1)))
	M.FOR_VETTO2	= CONV_CLEAR(APITOSPA(ALLTRIM(M.VETCOD2)))
	M.FOR_VETTO3	= ""
	M.FOR_BOLLI		= ""
*!*		M.FOR_PRIVAC	= CONV_CLEAR(APITOSPA(ALLTRIM(M.PRIVACY)))


    M.FOR_BDAL   	= "0108"
    M.FOR_BAL    	= "3108"
    M.FOR_GG1    	= "1009"
    M.FOR_B2DAL  	= "2012"
    M.FOR_B2AL   	= "3112"
    M.FOR_GG2    	= "1001"


	M.FOR_DATNEW = RIBALTA2(DTOC(DATE()))
	M.FOR_DATINS = RIBALTA2(DTOC(DATE()))


	IF EMPTY(CONV_CLEAR(APITOSPA(ALLTRIM(M.DIVCOD))))
		M.FOR_VALUTA	= "EUR"
	ELSE
		M.FOR_VALUTA	= CONV_CLEAR(APITOSPA(ALLTRIM(M.DIVCOD)))
	ENDIF
	M.FOR_SPINCA	= 0

	M.FOR_CONTO1	= CONV_CLEAR(APITOSPA(ALLTRIM(M.CONTROP)))
	M.FOR_CONTO2	= ""
	M.FOR_CONTO3	= ""
	M.FOR_CONTO4	= ""
	M.FOR_CONTO5	= ""
	M.SELEZIONE		= ""
	M.FOR_RICERC	= ""

	M.FOR_EMAIL		= CONV_CLEAR(APITOSPA(ALLTRIM(M.EMAIL)))
*!*		M.FOR_CODCHE	= ""
*!*		M.FOR_CODCIN	= ""
*!*		M.FOR_CODABI	= ""
*!*		M.FOR_CODCAB	= ""
*!*		M.FOR_CDIBAN	= ""

	M.FOR_CCOST1	= ""
	M.FOR_CCOST2	= ""
	M.FOR_CCOST3	= ""
	M.FOR_CCOST4	= ""
	M.FOR_CCOST5	= ""

	M.FOR_PERCON1	= 0
	M.FOR_PERCON2	= 0
	M.FOR_PERCON3	= 0
	M.FOR_PERCON4	= 0
	M.FOR_PERCON5	= 0


	M.FOR_PERCON 	= 0
	M.FOR_PERCO2 	= 0
	M.FOR_PERCO3 	= 0
	M.FOR_PERCO4 	= 0
	M.FOR_PERCO5 	= 0


	M.FOR_OBSOL 	= ""

	M.IDAnaAzi 		= ""
	M.Codice 		= ""

	M.FOR_SPTRAS 	= 0

	M.FOR_PERS01	= ""
	M.FOR_EMAIL1	= ""

	M.FOR_PERS02	= ""
	M.FOR_EMAIL2	= ""

	M.FOR_PERS03	= ""
	M.FOR_EMAIL3	= ""

	M.FOR_PERS04	= ""
	M.FOR_EMAIL4	= ""

	M.FOR_PERS05	= ""
	M.FOR_EMAIL5	= ""


   M.FOR_DELDOC   = SPACE(50)
   M.FOR_UFFIVA   = SPACE(30)
   M.FOR_CODIMB   = SPACE(03)
   M.FOR_FLGFID   = .F.
   M.FOR_CODCON   = SPACE(10)
   M.FOR_FLGTRA   = .F.
   M.FOR_CODCHE   = SPACE(02)
   M.FOR_CODCIN   = SPACE(02)
   M.FOR_CODABI   = SUBSTR(CONV_CLEAR(APITOSPA(M.ABICAB)),1,5)
   M.FOR_CODCAB   = SUBSTR(CONV_CLEAR(APITOSPA(M.ABICAB)),6,5)

   M.FOR_ABI2     = SPACE(04)
   M.FOR_CAB2     = SPACE(05)
   M.FOR_FLGABP   = .F.
   M.FOR_CLASSE   = SPACE(01)
   M.FOR_PERSMA   = SPACE(02)
   M.FOR_BAEFOR   = SPACE(05)
   M.FOR_NAZFOR   = SPACE(03)
   M.FOR_CHEFOR   = SPACE(02)
   M.FOR_CINFOR   = SPACE(02)
   M.FOR_ABIFOR   = SPACE(05)
   M.FOR_CABFOR   = SPACE(05)
   M.FOR_NCCFOR   = SPACE(12)
   M.FOR_IBAFOR   = SPACE(29)
   M.FOR_BSWFOR   = SPACE(100)
   M.FOR_FLGAGG   = .F.



   *** VALORI DI DEFAULT
   M.FOR_CODCLI = UPPER(M.FOR_CODCLI)
   M.FOR_CODCLI = CONV_CLEAR(APITOSPA(M.FOR_CODCLI))


   IF EMPTY(M.FOR_CONPAG)
      M.FOR_CONPAG = PUB_CPA
   ENDIF
   IF EMPTY(M.FOR_VALUTA)
      M.FOR_VALUTA = PUB_VALU
   ENDIF


   M.FOR_CLICEE	= ""		

   M.FOR_ABICAB	= ""		

   M.FOR_NUMCOC	= ""		

   M.FOR_CODRAC	= ""		

   M.FOR_RIFERI	= ""		

   M.FOR_CIRPEF	= ""		

   M.FOR_PERCCO	= 0		

   M.FOR_PERCPR = 0	

   M.FOR_TETMAX = 0		

   M.FOR_PERCPA = 0		

   M.FOR_LUNASC	= ""		

   M.FOR_DTNASC	= ""		

   M.FOR_CONTRO	= ""		

   M.FOR_TRASME	= ""		

   M.FOR_GGFORN	= 0		

   M.FOR_CODACQ	= ""		

   M.FOR_DESACQ	= ""		

   M.FOR_COSATRATTA 		= ""
   M.FOR_GRADOIMPORTANZA	= ""
   M.FOR_FORMAPAGAMENTO		= ""
   M.FOR_TIPOCONTRATTO		= ""
   M.FOR_PROPAGA			= ""

   M.FOR_BANPRA	= ""

   M.FOR_CONACQ	= ""

   M.FOR_CONSPE	= ""

   M.FOR_MASSIM	= 0

   M.FOR_FATTOT	= 0

   M.FOR_PERENA	= 0

   M.FOR_CONENA	= 0

   M.FOR_CONERA	= 0

   M.FOR_CONPRV	= 0

   M.FOR_BA2	= ""

   M.FOR_BA2NAZ	= ""

   M.FOR_BA2CHK	= ""

   M.FOR_BA2CIN	= ""

   M.FOR_BA2ABI	= ""

   M.FOR_BA2CAB	= ""

   M.FOR_BA2CC	= ""

   M.FOR_BA2IBA	= ""

   M.FOR_LOCDOC	= ""

   M.FOR_VALIMP	= 0

   M.FOR_NUMINSOL	= 0

   M.FOR_LINGUA		= ""

   M.FOR_SOTZONA	= ""

   M.FOR_NUMCC      = ""

   M.FOR_PRIPAGA    = ""

   M.FOR_CONENA		= ""

   M.FOR_CONERA		= ""

   M.FOR_CONPRV		= ""



   M.FOR_CDIBAN = SUBSTR(M.FOR_NAZION,1,2) + ALLTRIM(M.FOR_CODCHE) + M.FOR_CODCIN + M.FOR_CODABI + M.FOR_CODCAB + M.FOR_NUMCC


   SELECT CU_FOR_AN
   APPEND BLANK
   DO U_FOR_AN

   REPLACE FOR_CODCON 	WITH M.FOR_CODCON
   REPLACE FOR_LINGUA 	WITH M.FOR_LINGUA
   REPLACE FOR_SOTZONA 	WITH M.FOR_SOTZONA
   REPLACE FOR_ABI2 	WITH M.FOR_ABI2
   REPLACE FOR_CAB2 	WITH M.FOR_CAB2

   _V_CONTA  = _V_CONTA + 1

   SELECT AQ_ANAFOR
   SKIP +1

ENDDO





*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio dell'Anagrafica Fornitori sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','U_FOR_AN','I','','CU_FOR_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF


SET DEFA TO &PUB_DIR


RETURN

*************************************************************************************************
PROCEDURE CONV_MOV_CONT_SOP_ORIGINALE       && CONVERTE LA TABELLA MOV_CONT DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE MOVIMENTI CONTABILI		   								*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.			  											 	*
*	Settembre 2007 - Modificato  																*
*************************************************************************************************




*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_PDGIO"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

MESSAGEBOX("ARCHIVIO IN INPUT DA ELABORARE :" + CHR(13) + ;
              "AQ_PDTESTA+AQ_PDGIO+AQ_PDIVACL+AQ_PDIVAFR",64,"Informazione")


V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_PDTESTA"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF



*** CANCELLAZIONE DEI RECORD DELLA TABELLA INDICE SQL
WAIT WINDOWS "Cancellazione vecchio Indice movimenti contabili...  -  Prego Attendere" NOWAIT
cSql = "delete from INDICE where 1=1"
IF !ExecCommand(cSql,"INDICE")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from INDICE where 1=0"
IF !ExecCommand(cSql,"CU_INDICE")
   return(.f.)
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA MOV_CONT SQL
WAIT WINDOWS "Cancellazione vecchi Movimenti contabili...  -  Prego Attendere" NOWAIT
cSql = "delete from MOV_CONT where 1=1"
IF !ExecCommand(cSql,"MOV_CONT")
   return(.f.)
ENDIF

cSql = "delete from INDICE where 1=1"
IF !ExecCommand(cSql,"INDICE")
   return(.f.)
ENDIF

SET EXCLUSIVE OFF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from MOV_CONT where 1=0"
IF !ExecCommand(cSql,"CU_MOV_CONT")
   return(.f.)
ENDIF
SELECT CU_MOV_CONT
INDEX ON MOV_NUMPRO TAG XNUMPRO
=DEFPUB(SELECT())

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA ############################## input
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH

IF FILE("AQ_PDIVACL.CDX")
   ERASE AQ_PDIVACL.CDX
ENDIF

=OPENDB("AQ_PDIVACL")
SELECT AQ_PDIVACL
INDEX ON ribalta2(DTOC(pddtreg)) + ALLTRIM(pdnrreg)  TAG DnregCL ADDITIVE
SET ORDER TO DnregCL

IF FILE("AQ_PDIVAFR.CDX")
   ERASE AQ_PDIVAFR.CDX
ENDIF

=OPENDB("AQ_PDIVAFR")
SELECT AQ_PDIVAFR
INDEX ON ribalta2(DTOC(pddtreg)) + ALLTRIM(pdnrreg)  TAG DnregFR ADDITIVE
SET ORDER TO DnregFR


IF FILE("AQ_PDGIO.CDX")
   ERASE AQ_PDGIO.CDX
ENDIF

=OPENDB("AQ_PDGIO")
SELECT AQ_PDGIO
INDEX ON TAG1  TAG TAG1 ADDITIVE
SET ORDER TO TAG1


IF FILE("AQ_PDTESTA.CDX")
   ERASE AQ_PDTESTA.CDX
ENDIF

=OPENDB("AQ_PDTESTA")
SELECT AQ_PDTESTA
INDEX ON pdanno + pdnrreg  TAG Tnreg ADDITIVE
SET ORDER TO Tnreg


_V_CONTA  = 0


v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

CC=SUBSTR(LIBERA,1,4)
FF=SUBSTR(LIBERA,18,4)



*** LOOP DI SCRITTURA DATI
SELECT AQ_PDTESTA
GO TOP


V_ANNREG = ""
V_SEQUEN = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
   	  SELECT AQ_PDTESTA
   	  SKIP +1
      LOOP
   ENDIF

   *!* #########################################################	   DATI DI TESTATA       #########################################################


   M.MOV_ANNO	= CONV_CLEAR(pdanno)
   ___NREGIS	= CONV_CLEAR(pdnrreg)
   M.MOV_NREGIS	= SUBSTR(ALLTRIM(___NREGIS),2,6)

*!*	   ___TOTALE_REGISTRAZIONE = CONV_CLEAR(PDTOT)



   SCATTER MEMVAR MEMO

   IF V_ANNREG = M.MOV_ANNO + M.MOV_NREGIS
   ELSE
      V_SEQUEN = 0
   ENDIF

   WAIT WINDOWS "Conversione Movimento contabile " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT


*!*	IF M.MOV_ANNO <> "2007"
*!*	   	  SELECT AQ_PDTESTA
*!*	   	  SKIP +1
*!*	      LOOP
*!*	ENDIF
*!*	IF M.MOV_NREGIS = "000686"
*!*	SET STEP ON
*!*	ENDIF
*!*		
   *!* #########################################################	   DATI DI DETTAGLIO        #########################################################



	SELECT AQ_PDGIO
	SET ORDER TO TAG1
	_SEEK = M.TAG1
	SEEK _SEEK
	IF FOUND()

		M.MOV_NUMPRO = SYS(2015)
		SOLO_UNO     = .T.

		___TOTALE_REGISTRAZIONE = 0
		___TOTALE_FATTURA       = 0
		___TOTALE_RICALCOLATO	= 0
		
		DO WHILE .NOT. EOF()


		
			IF DELETED()
				SELECT AQ_PDGIO
				SKIP +1
				LOOP
			ENDIF
						
			IF ALLTRIM(CONV_CLEAR(M.TAG1)) <> ALLTRIM(CONV_CLEAR(TAG1))
				EXIT
			ENDIF
		
				
			M.MOV_DESMOV = ALLTRIM(CONV_CLEAR(PDDESCR))
   			M.MOV_CONTO  = ALLTRIM(CONV_CLEAR(PDCONTO))


			IF ALLTRIM(CONV_CLEAR(PDTPCON)) = "C"
  				M.MOV_CONTO  = TRC(PUB_LCL,ALLTRIM(M.MOV_CONTO))
  				M.MOV_CONTO  = CC + ALLTRIM(M.MOV_CONTO)	   			
			ENDIF


			IF ALLTRIM(CONV_CLEAR(PDTPCON)) = "F"
  				M.MOV_CONTO  = TRC(PUB_LCL,ALLTRIM(M.MOV_CONTO))
  				M.MOV_CONTO  = FF + ALLTRIM(M.MOV_CONTO)	   			
			ENDIF

    		
    		IF PDDARE <> 0
    			M.MOV_TMOV   = "D"
    			M.MOV_IMP	 = PDDARE
    		ELSE
    			M.MOV_TMOV   = "A"
    			M.MOV_IMP	 = PDAVERE     			
    		ENDIF
    		
  		
    		
    		** ACCESSO AI BOLLATI IVA CLIENTI/FORNITORI PER PRELEVARE IL CODICE IVA
    		M.MOV_IVA	 = ""
    		M.MOV_IMPOST = 0
    		

		    x_soci = "con_soc = '" + PUB_CODSOC + "'"
		    x_anno = "con_anno = '" + M.MOV_ANNO + "'"
		    x_cont = "con_conto = '" + M.MOV_CONTO + "'"
		    x_cond = x_soci + " and " + x_anno + " and " + x_cont
		    cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
		    IF !ExecRW(cSql,"CONTI","R")
		       RETURN .F.
		    ENDIF
		    SELECT CONTI
		    GO TOP
		    IF !EOF()
			   __CON_TIPOCO = CON_TIPOCO
			   __CON_DESCR  = CON_DESCR
			ELSE
			   __CON_TIPOCO = ""
			   __CON_DESCR  = ""
		    ENDIF

			SELECT AQ_PDGIO   	
			
			IF __CON_TIPOCO <> "I"   && NON CONSIDERA I CONTI IVA	
	    		IF ALLTRIM(CONV_CLEAR(PDTPCON)) = "C"  .OR. ALLTRIM(CONV_CLEAR(PDTPCON)) = "F"			&& NON CONSIDERA I CONTI CLIENTI / FORNITORI	
	    		ELSE
	    			IF ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FC"
	    				=CONV_CERCA_IVA_CLI(CONV_CLEAR(RIBALTA2(DTOC(PDDTREG))),CONV_CLEAR(PDNRREG),M.MOV_IMP)    			
	    			ENDIF
	    			
	    			IF ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FF"
	    				=CONV_CERCA_IVA_FOR(CONV_CLEAR(RIBALTA2(DTOC(PDDTREG))),CONV_CLEAR(PDNRREG),M.MOV_IMP)
	    			ENDIF
	     		ENDIF
    		ENDIF
    		

		

    		IF ALLTRIM(CONV_CLEAR(PDTPCON)) = "C" .OR.  ALLTRIM(CONV_CLEAR(PDTPCON)) = "F"

    		
			   DO CASE

			   		CASE ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FC"
			    		
			    		IF PDAVERE <> 0
			    		 	M.MOV_TOP	= "NCC"
			    		ENDIF
			  			M.MOV_IVA	= "NO"
			  			___TOTALE_FATTURA       = M.MOV_IMP
			  			
			  			
			   		CASE ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FF"
			    		
			    		IF PDDARE <> 0
			    		 	M.MOV_TOP	= "NCF"
			    		ENDIF
						M.MOV_IVA	= "NO"
						___TOTALE_FATTURA       = M.MOV_IMP
						
			   			
			   ENDCASE
    		
    		
    		
    		ENDIF
    		
   			

			   SELECT CU_MOV_CONT
			   APPEND BLANK
			
			
			   V_SEQUEN                       = V_SEQUEN + 10
			   M.MOV_SEQUEN                   = V_SEQUEN

			   M.MOV_ANNODO                   = SPACE(4)
			   M.MOV_EXTRA_NUMDOC             = SPACE(10)
			   M.MOV_EXTRA_DATDOC             = SPACE(10)
			   M.MOV_EXTRA_IMPDOC             = 0
			   M.MOV_EXTRA_SYSDOC             = SPACE(10)
			   M.MOV_NPARTO                   = 0
			   M.MOV_DATSCAD                  = SPACE(10)
			   M.MOV_CONTABILITA_PREVISIONALE = SPACE(1)
			   M.MOV_BOLLATOIVA               = SPACE(1)
			   M.MOV_CODACQ                   = SPACE(3)
			   M.MOV_TIPOCONTRATTO            = SPACE(5)
			   M.MOV_FORMAPAGAMENTO           = SPACE(5)
			   M.MOV_GRADOIMPORTANZA          = SPACE(5)
			   M.MOV_COSATRATTA               = SPACE(5)
			   M.MOV_PRIPAGA                  = SPACE(4)
			   M.MOV_CATEG                    = SPACE(6)
			   M.MOV_FATCE                    = SPACE(1)
			   M.MOV_NOTCE                    = SPACE(1)
			   M.MOV_FATRC                    = SPACE(1)
			   M.MOV_NOTRC                    = SPACE(1)
			   M.MOV_IVAOMA                   = .F.
			   M.MOV_PUBBLI                   = 0
			   M.MOV_NOIVA                    = SPACE(1)
			   M.EXTRA_NUMDOC                 = SPACE(1)
			   M.EXTRA_DATDOC                 = SPACE(1)
			   M.EXTRA_IMPDOC                 = SPACE(1)
			   M.EXTRA_SYSDOC                 = SPACE(1)


			   M.MOV_ANNODO					  = CONV_CLEAR(SUBSTR(DTOC(M.pddtreg),7,4))
			   M.MOV_COSATRATTA 			  = "GENER"
			   M.MOV_GRADOIMPORTANZA 		  = "PRIMA"
			   M.MOV_FORMAPAGAMENTO 		  = "RIMES"
			   M.MOV_TIPOCONTRATTO 			  = "SCADE"
			   M.MOV_CODACQ 				  = "001"
			   M.MOV_PRIPAGA 				  = "0500"
			
			   IF SUBSTR(CONV_CLEAR(DTOC(M.PDDTDOC)),3,1) = '/'
			      M.MOV_ANNODO = SUBSTR(CONV_CLEAR(DTOC(M.PDDTDOC)),7,4)
			   ELSE
			      M.MOV_ANNODO = SUBSTR(CONV_CLEAR(DTOC(M.PDDTDOC)),1,4)
			   ENDIF

			
			   REPLACE MOV_SOC    WITH PUB_CODSOC
			   REPLACE MOV_ANNO   WITH M.MOV_ANNO
				
			   =CAMBIADT(CONV_CLEAR(RIBALTA2(DTOC(M.PDDTDOC))),"MOV_DTDOC")
			   REPLACE MOV_NDOC   WITH CONV_CLEAR(M.PDNRDOC)
			   =CAMBIADT(CONV_CLEAR(RIBALTA2(DTOC(M.PDDTREG))),"MOV_DTREG")
			
			   IF EMPTY(ALLTRIM(MOV_DTDOC))
				   REPLACE MOV_DTDOC	WITH MOV_DTREG
			   ENDIF
			
			   ___NREGIS	= CONV_CLEAR(M.PDNRREG)
			   M.MOV_NREGIS	= SUBSTR(ALLTRIM(___NREGIS),2,6)
			   REPLACE MOV_NREGIS WITH M.MOV_NREGIS

			   =CAMBIADT(CONV_CLEAR(RIBALTA2(DTOC(M.PDDTDOC))),"MOV_DTVAL")


			   =CONV_DECODIFICA_CODICE_TOP(CONV_CLEAR(M.PDCCOD))


			   REPLACE MOV_TOP    					WITH M.MOV_TOP
			   REPLACE MOV_NPROT  					WITH CONV_CLEAR(M.PDNRPROT)
			
			   REPLACE MOV_VALUTA 					WITH "EUR"
			   REPLACE MOV_CODACQ                   WITH M.MOV_CODACQ
			   REPLACE MOV_TIPOCONTRATTO            WITH M.MOV_TIPOCONTRATTO
			   REPLACE MOV_FORMAPAGAMENTO           WITH M.MOV_FORMAPAGAMENTO
			   REPLACE MOV_GRADOIMPORTANZA          WITH M.MOV_GRADOIMPORTANZA
			   REPLACE MOV_COSATRATTA               WITH M.MOV_COSATRATTA
			   REPLACE MOV_PRIPAGA                  WITH M.MOV_PRIPAGA
			   REPLACE MOV_FATRI  					WITH .f.
			   REPLACE MOV_RECNO  					WITH 0
			   REPLACE MOV_INTOLD 					WITH ""
			   REPLACE MOV_NOTE   					WITH ""
			   REPLACE MOV_CODNOT 					WITH ""
			   REPLACE MOV_CCO    					WITH ""
			   REPLACE MOV_CCLI   					WITH ""
			   REPLACE MOV_CFOR   					WITH ""
			   REPLACE MOV_DESCR  					WITH ""
			   REPLACE MOV_OKCEE  					WITH .F.
			   REPLACE MOV_SYS    					WITH ""
			   REPLACE MOV_PESO   					WITH 0
			   REPLACE MOV_TISPE  					WITH ""
			   REPLACE MOV_PORTO  					WITH ""
			   REPLACE MOV_CLDOG  					WITH ""


			   REPLACE MOV_EXTRA_NUMDOC 			WITH ""
			   REPLACE MOV_EXTRA_DATDOC 			WITH ""
			   REPLACE MOV_EXTRA_IMPDOC 			WITH 0
			   REPLACE MOV_EXTRA_SYSDOC 			WITH ""
			   REPLACE MOV_ANNODO       			WITH M.MOV_ANNODO
			   REPLACE MOV_SEQUEN       			WITH M.MOV_SEQUEN
			   REPLACE MOV_CAMBIO 					WITH 1
			   REPLACE MOV_IMPVAL 					WITH 0
			   REPLACE MOV_BOLLAT 					WITH ""
			   REPLACE MOV_FLG    					WITH ""
			   REPLACE MOV_CEE    					WITH ""
			   REPLACE MOV_SALDO  					WITH ""
			   REPLACE MOV_CONTABILITA_PREVISIONALE WITH ""
			   REPLACE MOV_BOLLATOIVA               WITH ""
			   REPLACE MOV_DTPAG					WITH ""
			   REPLACE MOV_MODPAG   				WITH ""					&& ????????????
			   REPLACE MOV_PUBBLI   				WITH 0
			   REPLACE MOV_NOIVA    				WITH ""
			   REPLACE MOV_FATRC   					WITH ""
			   REPLACE MOV_NOTRC    				WITH ""
			   REPLACE MOV_CATEG    				WITH ""
			   REPLACE MOV_FATCE    				WITH ""
			   REPLACE MOV_NOTCE    				WITH ""
	

			   REPLACE MOV_NUMPRO   				WITH M.MOV_NUMPRO
			
			   REPLACE MOV_DESMO1 	                WITH ""
			   REPLACE MOV_IVAOMA   				WITH .F.
			   REPLACE MOV_BANCA  					WITH ""                && M.MOV_BANCA ???????

			*!*	   V_CONPAG  = M.MOV_MODPAG
			*!*	   V_TUTTO=TRANCHE("PARA",M.MOV_MODPAG,RIBALTA2(M.MOV_DTDOC),M.MOV_imp,VET_DAL,VET_AL,VET_DAY,m.mov_valuta)
			*!*	   DO SCADULT     && RICERCA ULTIMA DATA SCADENZA
			*!*	   M.ORD_DTSCAD = DATA_SCAD
			*!*	   REPLACE MOV_DATSCAD  WITH M.MOV_DATSCAD					&& ??????????????????????


			*!*	   REPLACE MOV_NPART  	WITH M.MOV_NPART					&&  ?????????????????????

  			  REPLACE MOV_TOP    				WITH M.MOV_TOP   			
   			  REPLACE MOV_DESMOV                WITH M.MOV_DESMOV
		      REPLACE MOV_CONTO    				WITH M.MOV_CONTO
			  REPLACE MOV_TMOV     				WITH M.MOV_TMOV
		      REPLACE MOV_IMP      				WITH M.MOV_IMP
   		
   		
			  IF EMPTY(ALLTRIM(M.MOV_IVA))	
			  	M.MOV_IVA	= "NO"
			  ENDIF		
   		
   		
   			  REPLACE MOV_IVA      				WITH M.MOV_IVA


			  IF SUBSTR(__CON_DESCR,1,6) <> "ERARIO"
				  IF __CON_TIPOCO = "A"   && NON CONSIDERA I CONTI IVA E I CONTI CLIENTI/FORNITORI	
					 =CONV_CALCOLO_IMPOSTA(M.MOV_IMP,M.MOV_IVA)
				  ENDIF
			  ENDIF

   			  REPLACE MOV_IMPOST   				WITH M.MOV_IMPOST
		      REPLACE MOV_IMPORT   				WITH 0
   			  REPLACE MOV_CONTOP   				WITH ""
   			  REPLACE MOV_PROGPA 				WITH 0
   			  REPLACE MOV_NPARTO   				WITH 0

			
*!*				  IF __CON_TIPOCO = "A"   && NON CONSIDERA I CONTI IVA E I CONTI CLIENTI/FORNITORI	
*!*	  			  	IF SUBSTR(__CON_DESCR,1,6) <> "ERARIO"
*!*		  			  IF M.MOV_TMOV = "A"   	
*!*					  	___TOTALE_RICALCOLATO	= ___TOTALE_RICALCOLATO + M.MOV_IMP
*!*					  ENDIF
*!*					ENDIF
*!*				  ENDIF

*!*				  IF M.MOV_IVA	<>  "NO"
*!*				  	___TOTALE_RICALCOLATO	= ___TOTALE_RICALCOLATO +  M.MOV_IMPOST
*!*				  ENDIF


  			  IF M.MOV_TMOV = "A"   	
			  	___TOTALE_RICALCOLATO	= ___TOTALE_RICALCOLATO + M.MOV_IMP
			  ENDIF



			  SCATTER MEMVAR MEMO			
			
*!*				  IF SOLO_UNO
*!*				      SOLO_UNO   = .F.
*!*				  ENDIF
			  			
		
			  SELECT AQ_PDGIO
			  SKIP +1
		
		ENDDO

*!*			IF ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FC" .OR. ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FF"
*!*				IF ___TOTALE_REGISTRAZIONE <> ___TOTALE_RICALCOLATO
*!*					=CONV_QUADRA_FATTURA(M.MOV_NUMPRO,___TOTALE_FATTURA,___TOTALE_RICALCOLATO)       		  			
*!*				ENDIF
*!*	    	ENDIF	



		SELECT CU_INDICE
		APPEND BLANK
		GATHER MEMVAR MEMO
	    REPLACE MOV_IMP      	WITH ___TOTALE_RICALCOLATO
	    ___TOTALE_REGISTRAZIONE = 0
		___TOTALE_FATTURA       = 0
		___TOTALE_RICALCOLATO	= 0

	ENDIF

   SELECT AQ_PDTESTA	

*!*	IF VAL(M.MOV_NREGIS) > 1
*!*	exit
*!*	ENDIF

   _V_CONTA = _V_CONTA + 1
   V_ANNREG = M.MOV_ANNO + M.MOV_NREGIS

   SELECT AQ_PDTESTA
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0

   WAIT WINDOWS "Scrittura archivio dell'Indice movimenti contabili sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','indice','I','','CU_INDICE')
      return(.f.)
   ENDIF

   WAIT WINDOWS "Scrittura archivio dei Movimenti contabili sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','mov_cont','I','','CU_MOV_CONT')
      return(.f.)
   ENDIF

   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF


SET DEFA TO &PUB_DIR

RETURN


*************************************************************************************************
PROCEDURE CONV_MOV_CONT_SOP      && CONVERTE LA TABELLA MOV_CONT DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE MOVIMENTI CONTABILI		   								*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.			  											 	*
*	Settembre 2007 - Modificato  																*
*************************************************************************************************




*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_PDGIO"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

MESSAGEBOX("ARCHIVIO IN INPUT DA ELABORARE :" + CHR(13) + ;
              "AQ_PDTESTA+AQ_PDGIO+AQ_PDIVACL+AQ_PDIVAFR",64,"Informazione")


V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_PDTESTA"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF



*** CANCELLAZIONE DEI RECORD DELLA TABELLA INDICE SQL
WAIT WINDOWS "Cancellazione vecchio Indice movimenti contabili...  -  Prego Attendere" NOWAIT
cSql = "delete from INDICE where 1=1"
IF !ExecCommand(cSql,"INDICE")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from INDICE where 1=0"
IF !ExecCommand(cSql,"CU_INDICE")
   return(.f.)
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA MOV_CONT SQL
WAIT WINDOWS "Cancellazione vecchi Movimenti contabili...  -  Prego Attendere" NOWAIT
cSql = "delete from MOV_CONT where 1=1"
IF !ExecCommand(cSql,"MOV_CONT")
   return(.f.)
ENDIF

cSql = "delete from INDICE where 1=1"
IF !ExecCommand(cSql,"INDICE")
   return(.f.)
ENDIF

SET EXCLUSIVE OFF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from MOV_CONT where 1=0"
IF !ExecCommand(cSql,"CU_MOV_CONT")
   return(.f.)
ENDIF
SELECT CU_MOV_CONT
INDEX ON MOV_NUMPRO TAG XNUMPRO
=DEFPUB(SELECT())

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA ############################## input
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH

IF FILE("AQ_PDIVACL.CDX")
   ERASE AQ_PDIVACL.CDX
ENDIF

=OPENDB("AQ_PDIVACL")
SELECT AQ_PDIVACL
INDEX ON ribalta2(DTOC(pddtreg)) + ALLTRIM(pdnrreg)  TAG DnregCL ADDITIVE
SET ORDER TO DnregCL

IF FILE("AQ_PDIVAFR.CDX")
   ERASE AQ_PDIVAFR.CDX
ENDIF

=OPENDB("AQ_PDIVAFR")
SELECT AQ_PDIVAFR
INDEX ON ribalta2(DTOC(pddtreg)) + ALLTRIM(pdnrreg)  TAG DnregFR ADDITIVE
SET ORDER TO DnregFR


IF FILE("AQ_PDGIO.CDX")
   ERASE AQ_PDGIO.CDX
ENDIF

=OPENDB("AQ_PDGIO")
SELECT AQ_PDGIO
INDEX ON TAG1  TAG TAG1 ADDITIVE
SET ORDER TO TAG1


IF FILE("AQ_PDTESTA.CDX")
   ERASE AQ_PDTESTA.CDX
ENDIF

=OPENDB("AQ_PDTESTA")
SELECT AQ_PDTESTA
INDEX ON pdanno + pdnrreg  TAG Tnreg ADDITIVE
SET ORDER TO Tnreg


_V_CONTA  = 0


v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

CCC=SUBSTR(LIBERA,1,4)
FFF=SUBSTR(LIBERA,18,4)



*** LOOP DI SCRITTURA DATI
SELECT AQ_PDTESTA
GO TOP


V_ANNREG = ""
V_SEQUEN = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
   	  SELECT AQ_PDTESTA
   	  SKIP +1
      LOOP
   ENDIF

   *!* #########################################################	   DATI DI TESTATA       #########################################################


   M.MOV_ANNO	= CONV_CLEAR(pdanno)
   ___NREGIS	= CONV_CLEAR(pdnrreg)
   M.MOV_NREGIS	= SUBSTR(ALLTRIM(___NREGIS),2,6)

*!*	   ___TOTALE_REGISTRAZIONE = CONV_CLEAR(PDTOT)



   SCATTER MEMVAR MEMO

   IF V_ANNREG = M.MOV_ANNO + M.MOV_NREGIS
   ELSE
      V_SEQUEN = 0
   ENDIF

   WAIT WINDOWS "Conversione Movimento contabile " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT


*!*	IF M.MOV_ANNO <> "2007"
*!*	   	  SELECT AQ_PDTESTA
*!*	   	  SKIP +1
*!*	      LOOP
*!*	ENDIF
*!*	IF M.MOV_NREGIS = "000686"
*!*	SET STEP ON
*!*	ENDIF
*!*		
   *!* #########################################################	   DATI DI DETTAGLIO        #########################################################



	SELECT AQ_PDGIO
	SET ORDER TO TAG1
	_SEEK = M.TAG1
	SEEK _SEEK
	IF FOUND()

		M.MOV_NUMPRO = SYS(2015)
		SOLO_UNO     = .T.

		___TOTALE_REGISTRAZIONE = 0
		___TOTALE_FATTURA       = 0
		___TOTALE_RICALCOLATO	= 0
		
		DO WHILE .NOT. EOF()


		
			IF DELETED()
				SELECT AQ_PDGIO
				SKIP +1
				LOOP
			ENDIF
						
			IF ALLTRIM(CONV_CLEAR(M.TAG1)) <> ALLTRIM(CONV_CLEAR(TAG1))
				EXIT
			ENDIF
		
				
			M.MOV_DESMOV = ALLTRIM(CONV_CLEAR(PDDESCR))
   			M.MOV_CONTO  = ALLTRIM(CONV_CLEAR(PDCONTO))


			IF ALLTRIM(CONV_CLEAR(PDTPCON)) = "C"

  				M.MOV_CONTO  = TRC(PUB_LCL,ALLTRIM(M.MOV_CONTO))
  							
				x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
				x_codi = "cli_codcli = '" + M.MOV_CONTO + "'"
				x_cond = x_soci + " and " + x_codi
				cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
				IF !ExecCommand(cSql,"CUR_CLIENTI")
				   RETURN .F.
				ENDIF
				SELECT CUR_CLIENTI
				GO TOP
				IF !EOF()
			       V_ER = SOTTOGEN(CLI_NAZION)
				   IF !V_ER
				      CC = PUB_CC
				   ELSE
				      CC = CCC
				   ENDIF
			    ELSE
				   CC = CCC
			    ENDIF

  				M.MOV_CONTO  = CC + ALLTRIM(M.MOV_CONTO)	   			

			ENDIF
	
	        SELECT AQ_PDGIO

			IF ALLTRIM(CONV_CLEAR(PDTPCON)) = "F"

  				M.MOV_CONTO  = TRC(PUB_LCL,ALLTRIM(M.MOV_CONTO))
  							
				x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
				x_codi = "for_codcli = '" + M.MOV_CONTO + "'"
				x_cond = x_soci + " and " + x_codi
				cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
				IF !ExecCommand(cSql,"CUR_FORNITO")
				   RETURN .F.
				ENDIF
				SELECT CUR_FORNITO
				GO TOP
				IF !EOF()
			       V_ER = SOTTOGEN(FOR_NAZION)
				   IF !V_ER
				      FF = PUB_FF
				   ELSE
				      FF = FFF
				   ENDIF
			    ELSE
				   FF = FFF
			    ENDIF

  				M.MOV_CONTO  = FF + ALLTRIM(M.MOV_CONTO)	   			
			ENDIF

	        SELECT AQ_PDGIO
    		
    		IF PDDARE <> 0
    			M.MOV_TMOV   = "D"
    			M.MOV_IMP	 = PDDARE
    		ELSE
    			M.MOV_TMOV   = "A"
    			M.MOV_IMP	 = PDAVERE     			
    		ENDIF
    		
  		
    		
    		** ACCESSO AI BOLLATI IVA CLIENTI/FORNITORI PER PRELEVARE IL CODICE IVA
    		M.MOV_IVA	 = ""
    		M.MOV_IMPOST = 0
    		

		    x_soci = "con_soc = '" + PUB_CODSOC + "'"
		    x_anno = "con_anno = '" + M.MOV_ANNO + "'"
		    x_cont = "con_conto = '" + M.MOV_CONTO + "'"
		    x_cond = x_soci + " and " + x_anno + " and " + x_cont
		    cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
		    IF !ExecRW(cSql,"CONTI","R")
		       RETURN .F.
		    ENDIF
		    SELECT CONTI
		    GO TOP
		    IF !EOF()
			   __CON_TIPOCO = CON_TIPOCO
			   __CON_DESCR  = CON_DESCR
			ELSE
			   __CON_TIPOCO = ""
			   __CON_DESCR  = ""
		    ENDIF

			SELECT AQ_PDGIO   	
			
			IF __CON_TIPOCO <> "I"   && NON CONSIDERA I CONTI IVA	
	    		IF ALLTRIM(CONV_CLEAR(PDTPCON)) = "C"  .OR. ALLTRIM(CONV_CLEAR(PDTPCON)) = "F"			&& NON CONSIDERA I CONTI CLIENTI / FORNITORI	
	    		ELSE
	    			IF ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FC"
	    				=CONV_CERCA_IVA_CLI(CONV_CLEAR(RIBALTA2(DTOC(PDDTREG))),CONV_CLEAR(PDNRREG),M.MOV_IMP)    			
	    			ENDIF
	    			
	    			IF ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FF"
	    				=CONV_CERCA_IVA_FOR(CONV_CLEAR(RIBALTA2(DTOC(PDDTREG))),CONV_CLEAR(PDNRREG),M.MOV_IMP)
	    			ENDIF
	     		ENDIF
    		ENDIF
    		

		

    		IF ALLTRIM(CONV_CLEAR(PDTPCON)) = "C" .OR.  ALLTRIM(CONV_CLEAR(PDTPCON)) = "F"

    		
			   DO CASE

			   		CASE ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FC"
			    		
			    		IF PDAVERE <> 0
			    		 	M.MOV_TOP	= "NCC"
			    		ENDIF
			  			M.MOV_IVA	= "NO"
			  			___TOTALE_FATTURA       = M.MOV_IMP
			  			
			  			
			   		CASE ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FF"
			    		
			    		IF PDDARE <> 0
			    		 	M.MOV_TOP	= "NCF"
			    		ENDIF
						M.MOV_IVA	= "NO"
						___TOTALE_FATTURA       = M.MOV_IMP
						
			   			
			   ENDCASE
    		
    		
    		
    		ENDIF
    		
   			

			   SELECT CU_MOV_CONT
			   APPEND BLANK
			
			
			   V_SEQUEN                       = V_SEQUEN + 10
			   M.MOV_SEQUEN                   = V_SEQUEN

			   M.MOV_ANNODO                   = SPACE(4)
			   M.MOV_EXTRA_NUMDOC             = SPACE(10)
			   M.MOV_EXTRA_DATDOC             = SPACE(10)
			   M.MOV_EXTRA_IMPDOC             = 0
			   M.MOV_EXTRA_SYSDOC             = SPACE(10)
			   M.MOV_NPARTO                   = 0
			   M.MOV_DATSCAD                  = SPACE(10)
			   M.MOV_CONTABILITA_PREVISIONALE = SPACE(1)
			   M.MOV_BOLLATOIVA               = SPACE(1)
			   M.MOV_CODACQ                   = SPACE(3)
			   M.MOV_TIPOCONTRATTO            = SPACE(5)
			   M.MOV_FORMAPAGAMENTO           = SPACE(5)
			   M.MOV_GRADOIMPORTANZA          = SPACE(5)
			   M.MOV_COSATRATTA               = SPACE(5)
			   M.MOV_PRIPAGA                  = SPACE(4)
			   M.MOV_CATEG                    = SPACE(6)
			   M.MOV_FATCE                    = SPACE(1)
			   M.MOV_NOTCE                    = SPACE(1)
			   M.MOV_FATRC                    = SPACE(1)
			   M.MOV_NOTRC                    = SPACE(1)
			   M.MOV_IVAOMA                   = .F.
			   M.MOV_PUBBLI                   = 0
			   M.MOV_NOIVA                    = SPACE(1)
			   M.EXTRA_NUMDOC                 = SPACE(1)
			   M.EXTRA_DATDOC                 = SPACE(1)
			   M.EXTRA_IMPDOC                 = SPACE(1)
			   M.EXTRA_SYSDOC                 = SPACE(1)


			   M.MOV_ANNODO					  = CONV_CLEAR(SUBSTR(DTOC(M.pddtreg),7,4))
			   M.MOV_COSATRATTA 			  = "GENER"
			   M.MOV_GRADOIMPORTANZA 		  = "PRIMA"
			   M.MOV_FORMAPAGAMENTO 		  = "RIMES"
			   M.MOV_TIPOCONTRATTO 			  = "SCADE"
			   M.MOV_CODACQ 				  = "001"
			   M.MOV_PRIPAGA 				  = "0500"
			
			   IF SUBSTR(CONV_CLEAR(DTOC(M.PDDTDOC)),3,1) = '/'
			      M.MOV_ANNODO = SUBSTR(CONV_CLEAR(DTOC(M.PDDTDOC)),7,4)
			   ELSE
			      M.MOV_ANNODO = SUBSTR(CONV_CLEAR(DTOC(M.PDDTDOC)),1,4)
			   ENDIF

			
			   REPLACE MOV_SOC    WITH PUB_CODSOC
			   REPLACE MOV_ANNO   WITH M.MOV_ANNO
				
			   =CAMBIADT(CONV_CLEAR(RIBALTA2(DTOC(M.PDDTDOC))),"MOV_DTDOC")
			   REPLACE MOV_NDOC   WITH CONV_CLEAR(M.PDNRDOC)
			   =CAMBIADT(CONV_CLEAR(RIBALTA2(DTOC(M.PDDTREG))),"MOV_DTREG")
			
			   IF EMPTY(ALLTRIM(MOV_DTDOC))
				   REPLACE MOV_DTDOC	WITH MOV_DTREG
			   ENDIF
			
			   ___NREGIS	= CONV_CLEAR(M.PDNRREG)
			   M.MOV_NREGIS	= SUBSTR(ALLTRIM(___NREGIS),2,6)
			   REPLACE MOV_NREGIS WITH M.MOV_NREGIS

			   =CAMBIADT(CONV_CLEAR(RIBALTA2(DTOC(M.PDDTDOC))),"MOV_DTVAL")


			   =CONV_DECODIFICA_CODICE_TOP(CONV_CLEAR(M.PDCCOD))


			   REPLACE MOV_TOP    					WITH M.MOV_TOP
			   REPLACE MOV_NPROT  					WITH CONV_CLEAR(M.PDNRPROT)
			
			   REPLACE MOV_VALUTA 					WITH "EUR"
			   REPLACE MOV_CODACQ                   WITH M.MOV_CODACQ
			   REPLACE MOV_TIPOCONTRATTO            WITH M.MOV_TIPOCONTRATTO
			   REPLACE MOV_FORMAPAGAMENTO           WITH M.MOV_FORMAPAGAMENTO
			   REPLACE MOV_GRADOIMPORTANZA          WITH M.MOV_GRADOIMPORTANZA
			   REPLACE MOV_COSATRATTA               WITH M.MOV_COSATRATTA
			   REPLACE MOV_PRIPAGA                  WITH M.MOV_PRIPAGA
			   REPLACE MOV_FATRI  					WITH .f.
			   REPLACE MOV_RECNO  					WITH 0
			   REPLACE MOV_INTOLD 					WITH ""
			   REPLACE MOV_NOTE   					WITH ""
			   REPLACE MOV_CODNOT 					WITH ""
			   REPLACE MOV_CCO    					WITH ""
			   REPLACE MOV_CCLI   					WITH ""
			   REPLACE MOV_CFOR   					WITH ""
			   REPLACE MOV_DESCR  					WITH ""
			   REPLACE MOV_OKCEE  					WITH .F.
			   REPLACE MOV_SYS    					WITH ""
			   REPLACE MOV_PESO   					WITH 0
			   REPLACE MOV_TISPE  					WITH ""
			   REPLACE MOV_PORTO  					WITH ""
			   REPLACE MOV_CLDOG  					WITH ""


			   REPLACE MOV_EXTRA_NUMDOC 			WITH ""
			   REPLACE MOV_EXTRA_DATDOC 			WITH ""
			   REPLACE MOV_EXTRA_IMPDOC 			WITH 0
			   REPLACE MOV_EXTRA_SYSDOC 			WITH ""
			   REPLACE MOV_ANNODO       			WITH M.MOV_ANNODO
			   REPLACE MOV_SEQUEN       			WITH M.MOV_SEQUEN
			   REPLACE MOV_CAMBIO 					WITH 1
			   REPLACE MOV_IMPVAL 					WITH 0
			   REPLACE MOV_BOLLAT 					WITH ""
			   REPLACE MOV_FLG    					WITH ""
			   REPLACE MOV_CEE    					WITH ""
			   REPLACE MOV_SALDO  					WITH ""
			   REPLACE MOV_CONTABILITA_PREVISIONALE WITH ""
			   REPLACE MOV_BOLLATOIVA               WITH ""
			   REPLACE MOV_DTPAG					WITH ""
			   REPLACE MOV_MODPAG   				WITH ""					&& ????????????
			   REPLACE MOV_PUBBLI   				WITH 0
			   REPLACE MOV_NOIVA    				WITH ""
			   REPLACE MOV_FATRC   					WITH ""
			   REPLACE MOV_NOTRC    				WITH ""
			   REPLACE MOV_CATEG    				WITH ""
			   REPLACE MOV_FATCE    				WITH ""
			   REPLACE MOV_NOTCE    				WITH ""
	

			   REPLACE MOV_NUMPRO   				WITH M.MOV_NUMPRO
			
			   REPLACE MOV_DESMO1 	                WITH ""
			   REPLACE MOV_IVAOMA   				WITH .F.
			   REPLACE MOV_BANCA  					WITH ""                && M.MOV_BANCA ???????

			*!*	   V_CONPAG  = M.MOV_MODPAG
			*!*	   V_TUTTO=TRANCHE("PARA",M.MOV_MODPAG,RIBALTA2(M.MOV_DTDOC),M.MOV_imp,VET_DAL,VET_AL,VET_DAY,m.mov_valuta)
			*!*	   DO SCADULT     && RICERCA ULTIMA DATA SCADENZA
			*!*	   M.ORD_DTSCAD = DATA_SCAD
			*!*	   REPLACE MOV_DATSCAD  WITH M.MOV_DATSCAD					&& ??????????????????????


			*!*	   REPLACE MOV_NPART  	WITH M.MOV_NPART					&&  ?????????????????????

  			  REPLACE MOV_TOP    				WITH M.MOV_TOP   			
   			  REPLACE MOV_DESMOV                WITH M.MOV_DESMOV
		      REPLACE MOV_CONTO    				WITH M.MOV_CONTO
			  REPLACE MOV_TMOV     				WITH M.MOV_TMOV
		      REPLACE MOV_IMP      				WITH M.MOV_IMP
   		
   		
			  IF EMPTY(ALLTRIM(M.MOV_IVA))	
			  	M.MOV_IVA	= "NO"
			  ENDIF		
   		
   		
   			  REPLACE MOV_IVA      				WITH M.MOV_IVA


			  IF SUBSTR(__CON_DESCR,1,6) <> "ERARIO"
				  IF __CON_TIPOCO = "A"   && NON CONSIDERA I CONTI IVA E I CONTI CLIENTI/FORNITORI	
					 =CONV_CALCOLO_IMPOSTA(M.MOV_IMP,M.MOV_IVA)
				  ENDIF
			  ENDIF

   			  REPLACE MOV_IMPOST   				WITH M.MOV_IMPOST
		      REPLACE MOV_IMPORT   				WITH 0
   			  REPLACE MOV_CONTOP   				WITH ""
   			  REPLACE MOV_PROGPA 				WITH 0
   			  REPLACE MOV_NPARTO   				WITH 0

			
*!*				  IF __CON_TIPOCO = "A"   && NON CONSIDERA I CONTI IVA E I CONTI CLIENTI/FORNITORI	
*!*	  			  	IF SUBSTR(__CON_DESCR,1,6) <> "ERARIO"
*!*		  			  IF M.MOV_TMOV = "A"   	
*!*					  	___TOTALE_RICALCOLATO	= ___TOTALE_RICALCOLATO + M.MOV_IMP
*!*					  ENDIF
*!*					ENDIF
*!*				  ENDIF

*!*				  IF M.MOV_IVA	<>  "NO"
*!*				  	___TOTALE_RICALCOLATO	= ___TOTALE_RICALCOLATO +  M.MOV_IMPOST
*!*				  ENDIF


  			  IF M.MOV_TMOV = "A"   	
			  	___TOTALE_RICALCOLATO	= ___TOTALE_RICALCOLATO + M.MOV_IMP
			  ENDIF



			  SCATTER MEMVAR MEMO			
			
*!*				  IF SOLO_UNO
*!*				      SOLO_UNO   = .F.
*!*				  ENDIF
			  			
		
			  SELECT AQ_PDGIO
			  SKIP +1
		
		ENDDO

*!*			IF ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FC" .OR. ALLTRIM(CONV_CLEAR(M.PDCCOD)) = "FF"
*!*				IF ___TOTALE_REGISTRAZIONE <> ___TOTALE_RICALCOLATO
*!*					=CONV_QUADRA_FATTURA(M.MOV_NUMPRO,___TOTALE_FATTURA,___TOTALE_RICALCOLATO)       		  			
*!*				ENDIF
*!*	    	ENDIF	



		SELECT CU_INDICE
		APPEND BLANK
		GATHER MEMVAR MEMO
	    REPLACE MOV_IMP      	WITH ___TOTALE_RICALCOLATO
	    ___TOTALE_REGISTRAZIONE = 0
		___TOTALE_FATTURA       = 0
		___TOTALE_RICALCOLATO	= 0

	ENDIF

   SELECT AQ_PDTESTA	

*!*	IF VAL(M.MOV_NREGIS) > 1
*!*	exit
*!*	ENDIF

   _V_CONTA = _V_CONTA + 1
   V_ANNREG = M.MOV_ANNO + M.MOV_NREGIS

   SELECT AQ_PDTESTA
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0

   WAIT WINDOWS "Scrittura archivio dell'Indice movimenti contabili sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','indice','I','','CU_INDICE')
      return(.f.)
   ENDIF

   WAIT WINDOWS "Scrittura archivio dei Movimenti contabili sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','mov_cont','I','','CU_MOV_CONT')
      return(.f.)
   ENDIF

   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF


SET DEFA TO &PUB_DIR

RETURN

*************************************************************************************************
PROCEDURE CONV_CONTI_SOP_SISTEMAZIONI	&& CONVERTE LA TABELLA CONTI DA .DBF A SQL
*************************************************************************************************

*
*
* PROVVISORIO
* VERSIONE PER RICOSTRUIRE IL PIANO DEI CONTI : DA NOON USARE SERGIO
*
*


*************************************************************************************************
*							CONVERSIONE PIANO DEI CONTI			   								*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.			  											 	*
*	Settembre 2007 - Modificato 																*
*************************************************************************************************
PARAMETERS _PUB_ANNO

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

MESSAGEBOX("SISTEMO PIANO CONTI CLIENTI / FORNITORI ESTERI!!!!" + CHR(13) + ;
              "",64,"Informazione")

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_PDCONTI"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF





*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA ############################## input
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH


SET EXCLUSIVE On

=OPENDB("TCONTI")
SELECT TCONTI
zap
=OPENDB("TCONTI")
SELECT TCONTI

_V_CONTA  = 0

SET EXCLUSIVE OFF

*!*	################################################# SISTEMA PIANO DEI CONTI #################################################


v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

CCC=SUBSTR(LIBERA,1,4)

x_soci = "CON_SOC = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from CONTI where " + x_cond + " order by CON_SOC,CON_ANNO"
IF !ExecRW(cSql,"CUR_CONTI","R")
   RETURN .F.
ENDIF
SELECT CUR_CONTI
GO TOP


CTRELAB = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SELECT CUR_CONTI
      SKIP +1
      LOOP
   ENDIF


   IF CON_TIPOCO <> 'C' && TRATTA SOLO I CLIENTI
      SELECT CUR_CONTI
      SKIP +1
      LOOP
   ENDIF


   SCATTER MEMVAR MEMO


	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" + SUBSTR(M.CON_CONTO,5,9) + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	IF !ExecCommand(cSql,"CUR_CLIENTI")
	   RETURN .F.
	ENDIF
	SELECT CUR_CLIENTI
	GO TOP
	IF !EOF()
       V_ER = SOTTOGEN(CLI_NAZION)
	   IF !V_ER
	      CC = PUB_CC
	   ELSE
	      CC = CCC
	   ENDIF

       XXX_CODCLI = CC + SUBSTR(CLI_CODCLI,1,9)

    ELSE
	   CC = CCC
       XXX_CODCLI = CC + SUBSTR(M.CON_CONTO,5,9)
    ENDIF

   IF EMPTY(ALLTRIM(XXX_CODCLI))
      XXX_CODCLI  = M.CON_CONTO
   ENDIF

   SELECT TCONTI
   APPEND BLANK
   REPLACE ANNO      WITH M.CON_ANNO
   REPLACE CONTO_OLD WITH M.CON_CONTO
   REPLACE CONTO_NEW WITH XXX_CODCLI


   SELECT CUR_CONTI
   REPLACE CON_CONTO  WITH XXX_CODCLI



   SELECT CUR_CONTI
   SKIP +1

ENDDO


SELECT CUR_CONTI
GO TOP

IF !ExecRW('','CONTI','I','','CUR_CONTI')
      return(.f.)
ENDIF




x_cond = "MOV_SOC = '" + PUB_CODSOC + "'"
cSql = "select * from INDICE where " + x_cond + " order by MOV_CONTO"
IF !ExecRW(cSql,"INDICE","R")
   RETURN .F.
ENDIF
SELECT INDICE
GO TOP


SELECT TCONTI
GO TOP

DO WHILE .NOT. EOF()


    SELECT TCONTI
    SCATTER MEMVAR MEMO

    WAIT WINDOWS "INDICE - CONTO VECCHIO IN ELABORAZIONE :" + CONTO_OLD NOWAIT
	SELECT INDICE
	GO TOP
	REPLACE MOV_CONTO WITH M.CONTO_NEW for ALLTRIM(MOV_CONTO) = ALLTRIM(M.CONTO_OLD)


    SELECT TCONTI
    SKIP +1

ENDDO


SELECT INDICE
GO TOP


IF !ExecRW('','INDICE','I','','INDICE')
      return(.f.)
ENDIF




x_cond = "MOV_SOC = '" + PUB_CODSOC + "'"
cSql = "select * from MOV_CONT where " + x_cond + " order by MOV_CONTO"
IF !ExecRW(cSql,"MOV_CONT","R")
   RETURN .F.
ENDIF
SELECT MOV_CONT
GO TOP


SELECT TCONTI
GO TOP

DO WHILE .NOT. EOF()


    SELECT TCONTI
    SCATTER MEMVAR MEMO

    WAIT WINDOWS "MOV_CONT - CONTO VECCHIO IN ELABORAZIONE :" + CONTO_OLD NOWAIT
	SELECT MOV_CONT
	GO TOP
	REPLACE MOV_CONTO WITH M.CONTO_NEW for ALLTRIM(MOV_CONTO) = ALLTRIM(M.CONTO_OLD)


    SELECT TCONTI
    SKIP +1

ENDDO


SELECT MOV_CONT
GO TOP


IF !ExecRW('','MOV_CONT','I','','MOV_CONT')
      return(.f.)
ENDIF



x_cond = "PAR_CODSOC  = '" + PUB_CODSOC + "'"
cSql = "select * from PART_CLI where " + x_cond + " order by PAR_CODCLI"
IF !ExecRW(cSql,"PART_CLI","R")
   RETURN .F.
ENDIF
SELECT PART_CLI
GO TOP


SELECT TCONTI
GO TOP

DO WHILE .NOT. EOF()


    SELECT TCONTI
    SCATTER MEMVAR MEMO

    WAIT WINDOWS "PART_CLI - CONTO VECCHIO IN ELABORAZIONE :" + CONTO_OLD NOWAIT
	SELECT PART_CLI
	GO TOP
	REPLACE PAR_CODCLI WITH M.CONTO_NEW for ALLTRIM(PAR_CODCLI) = ALLTRIM(M.CONTO_OLD)


    SELECT TCONTI
    SKIP +1

ENDDO


SELECT PART_CLI
GO TOP


IF !ExecRW('','PART_CLI','I','','PART_CLI')
      return(.f.)
ENDIF




***********______________________________________________________

*!*	v_seek	= 'GEN' + PUB_CODSOC
*!*	v_chiave = "codice"
*!*	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
*!*	   SELECT CUR_PARA
*!*	ELSE
*!*	   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
*!*	   RETURN .F.
*!*	ENDIF

*!*	CCC=SUBSTR(LIBERA,1,4)

*!*	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
*!*	x_cond = x_soci
*!*	cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
*!*	IF !ExecCommand(cSql,"CUR_CLIENTI")
*!*	   RETURN .F.
*!*	ENDIF
*!*	SELECT CUR_CLIENTI
*!*	GO TOP
*!*	
*!*	CTRELAB = 0
*!*	SET STEP ON
*!*	DO WHILE .T.
*!*	
*!*	   IF EOF()
*!*	      EXIT
*!*	   ENDIF

*!*	   IF DELETED()
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF


*!*	   SCATTER MEMVAR MEMO
*!*	
*!*	   CPA=CLI_CONPAG
*!*	   CLI=CLI_CODCLI +" " + SUBSTR(CLI_RAGSOC,1,30)

*!*	   V_ER = SOTTOGEN(CLI_NAZION)
*!*	   IF !V_ER
*!*	      CC = PUB_CC
*!*	   ELSE
*!*	      CC = CCC
*!*	   ENDIF


*!*	   SCATTER MEMVAR MEMO
*!*	
*!*	   XXX_CODCLI = CC + SUBSTR(M.CLI_CODCLI,1,9)
*!*	   x_soci = "con_soc = '" + PUB_CODSOC + "'"
*!*	   x_anno = "con_anno = '" + _PUB_ANNO + "'"
*!*	   x_cont = "con_conto = '" + XXX_CODCLI + "'"
*!*	   x_cond = x_soci + " and " + x_anno + " and " + x_cont
*!*	   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
*!*	   IF !ExecRW(cSql,"XXCONTI","R")
*!*	      RETURN .F.
*!*	   ENDIF
*!*	   SELECT XXCONTI
*!*	   GO TOP
*!*	   IF EOF()
*!*		  SELECT CU_CONTI
*!*		  APPEND BLANK
*!*		  REPLACE CON_SOC    WITH PUB_CODSOC
*!*		  REPLACE CON_ANNO   WITH _PUB_ANNO
*!*		  REPLACE CON_CONTO  WITH XXX_CODCLI
*!*		  REPLACE CON_DESCR  WITH M.CLI_RAGSOC
*!*		  REPLACE CON_TIPOCO WITH 'C'
*!*		  REPLACE CON_POSBIL WITH 'P'
*!*	
*!*	   ENDIF

*!*	
*!*	
*!*	
*!*	   SELECT CUR_CLIENTI
*!*	   SKIP +1

*!*	ENDDO


*!*	SELECT CU_CONTI
*!*	GO TOP
*!*	BROWSE NORMAL
*!*	GO TOP

*!*	   IF !ExecRW('','CONTI','I','','CU_CONTI')
*!*	      return(.f.)
*!*	   ENDIF


*!*	*!*	################################################# CREA PIANO DEI CONTI DA ANAGRAFICA FORNITORI #################################################

*!*	v_seek	= 'GEN' + PUB_CODSOC
*!*	v_chiave = "codice"
*!*	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
*!*	   SELECT CUR_PARA
*!*	ELSE
*!*	   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
*!*	   RETURN .F.
*!*	ENDIF

*!*	FF=SUBSTR(LIBERA,18,4)

*!*	x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
*!*	x_cond = x_soci
*!*	cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
*!*	IF !ExecCommand(cSql,"CUR_FORNITORI")
*!*	   RETURN .F.
*!*	ENDIF
*!*	SELECT CUR_FORNITORI
*!*	GO TOP
*!*	
*!*	CTRELAB = 0

*!*	DO WHILE .T.
*!*	
*!*	   IF EOF()
*!*	      EXIT
*!*	   ENDIF

*!*	   IF DELETED()
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   CPA=for_CONPAG
*!*	   for_=for_CODCLI +" " + SUBSTR(for_RAGSOC,1,30)

*!*	   SCATTER MEMVAR MEMO
*!*	
*!*	   XXX_CODfor = FF + SUBSTR(M.for_CODCLI,1,9)
*!*	   x_soci = "con_soc = '" + PUB_CODSOC + "'"
*!*	   x_anno = "con_anno = '" + _PUB_ANNO + "'"
*!*	   x_cont = "con_conto = '" + XXX_CODfor + "'"
*!*	   x_cond = x_soci + " and " + x_anno + " and " + x_cont
*!*	   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
*!*	   IF !ExecRW(cSql,"CONTI","R")
*!*	      RETURN .F.
*!*	   ENDIF
*!*	   SELECT CONTI
*!*	   GO TOP
*!*	   IF EOF()
*!*		  SELECT CU_CONTI
*!*		  APPEND BLANK
*!*		  REPLACE CON_SOC    WITH PUB_CODSOC
*!*		  REPLACE CON_ANNO   WITH _PUB_ANNO
*!*		  REPLACE CON_CONTO  WITH XXX_CODfor
*!*		  REPLACE CON_DESCR  WITH M.for_RAGSOC
*!*		  REPLACE CON_TIPOCO WITH 'F'
*!*		  REPLACE CON_POSBIL WITH 'P'
*!*	   ENDIF
*!*	
*!*	   SELECT CUR_FORNITORI
*!*	   SKIP +1

*!*	ENDDO



SET DEFA TO &PUB_DIR

RETURN



*************************************************************************************************
PROCEDURE CONV_CONTI_SOP	&& CONVERTE LA TABELLA CONTI DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE PIANO DEI CONTI			   								*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.			  											 	*
*	Settembre 2007 - Modificato 																*
*************************************************************************************************
PARAMETERS _PUB_ANNO

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

MESSAGEBOX("ARCHIVIO IN INPUT DA ELABORARE :" + CHR(13) + ;
              "AQ_PDCONTI",64,"Informazione")

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_PDCONTI"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA  CONTI  SQL
WAIT WINDOWS "Cancellazione vecchio Piani dei conti ...  -  Prego Attendere" NOWAIT
x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + _PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "delete from CONTI where " + x_cond
IF !ExecCommand(cSql,"CONTI")
   return(.f.)
ENDIF

SET EXCLUSIVE OFF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from CONTI where 1=0"
IF !ExecCommand(cSql,"CU_CONTI")
   return(.f.)
ENDIF

SELECT CU_CONTI
=DEFPUB(SELECT())

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA ############################## input
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH


IF FILE("AQ_PDCONTI.CDX")
   ERASE AQ_PDCONTI.CDX
ENDIF

=OPENDB("AQ_PDCONTI")
SELECT AQ_PDCONTI


_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT AQ_PDCONTI
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
   	  SELECT AQ_PDCONTI
   	  SKIP +1
      LOOP
   ENDIF

   *!* #########################################################	   DATI DI TESTATA       #########################################################



   SCATTER MEMVAR MEMO


   WAIT WINDOWS "Conversione Piano dei conti " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT



	
   *!* #########################################################	   DATI DI DETTAGLIO        #########################################################

    		
   			

   	SELECT CU_CONTI
   	APPEND BLANK
			
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	
	_CON_CONTO_ = CONV_CLEAR(M.pianocod)
	_CON_CONTO  = ALLTRIM(_CON_CONTO_)
	
	REPLACE CON_CONTO  WITH _CON_CONTO
	
	IF LEN(ALLTRIM(CON_CONTO)) = 1 OR LEN(ALLTRIM(CON_CONTO)) = 3
	    _CON_CONTO = ALLTRIM(CON_CONTO) +"0"
		REPLACE CON_CONTO  WITH _CON_CONTO
	ENDIF
	
	
	REPLACE CON_DESCR  WITH CONV_CLEAR(M.pianodes)
	
	IF SUBSTR(CON_DESCR,1,8) = "ATTIVITA"
		REPLACE CON_CONTO  WITH "10" 		
	ENDIF
	
	REPLACE CON_IMP_D  WITH 0
	REPLACE CON_IMP_A  WITH 0
	REPLACE CON_TIPOCO WITH "A"

	IF SUBSTR(CON_DESCR,1,3) = "IVA"
		REPLACE CON_TIPOCO WITH "I"
	ENDIF

	REPLACE CON_PARIVA WITH ""
	REPLACE CON_DA01   WITH 0
	REPLACE CON_AV01   WITH 0
	REPLACE CON_DA02   WITH 0
	REPLACE CON_AV02   WITH 0
	REPLACE CON_DA03   WITH 0
	REPLACE CON_AV03   WITH 0
	REPLACE CON_DA04   WITH 0
	REPLACE CON_AV04   WITH 0
	REPLACE CON_DA05   WITH 0
	REPLACE CON_AV05   WITH 0
	REPLACE CON_DA06   WITH 0
	REPLACE CON_AV06   WITH 0
	REPLACE CON_DA07   WITH 0
	REPLACE CON_AV07   WITH 0
	REPLACE CON_DA08   WITH 0
	REPLACE CON_AV08   WITH 0
	REPLACE CON_DA09   WITH 0
	REPLACE CON_AV09   WITH 0
	REPLACE CON_DA10   WITH 0
	REPLACE CON_AV10   WITH 0
	REPLACE CON_DA11   WITH 0
	REPLACE CON_AV11   WITH 0
	REPLACE CON_DA12   WITH 0
	REPLACE CON_AV12   WITH 0
	REPLACE CON_CLASS9 WITH ""
	
	
	IF VAL(SUBSTR(_CON_CONTO,1,1)) < 3
		REPLACE CON_POSBIL WITH "P"
	ELSE
		REPLACE CON_POSBIL WITH "E"
	ENDIF

	
	REPLACE CON_SALDOI WITH 0
	REPLACE CON_IVASN  WITH .F.
	REPLACE CON_NUMPAR WITH ""
	REPLACE SELEZIONE  WITH ""
	REPLACE CON_ABILIT WITH ""
	REPLACE CON_CCO    WITH ""
	REPLACE CON_CCO1   WITH ""
	REPLACE CON_CCO2   WITH ""
	REPLACE CON_CCO3   WITH ""
	REPLACE CON_CCO4   WITH ""
	REPLACE DA_SALDOI  WITH 0
	REPLACE CON_VALUTA WITH "EUR"

	REPLACE CON_FLGCCO WITH .F.
	REPLACE CON_CATEG  WITH ""
	REPLACE CON_PERCO1 WITH 0
	REPLACE CON_PERCO2 WITH 0
	REPLACE CON_PERCO3 WITH 0
	REPLACE CON_PERCO4 WITH 0
	REPLACE CON_PERCO5 WITH 0

	REPLACE CON_CODRAG WITH ""
	REPLACE CON_CODCON WITH ""
	REPLACE CON_DESRAG WITH ""
	REPLACE CON_DESCON WITH ""

	REPLACE CON_CODRA2 WITH ""
	REPLACE CON_CODCO2 WITH ""
	REPLACE CON_DESRA2 WITH ""
	REPLACE CON_DESCO2 WITH ""
	REPLACE CON_CODAMM WITH ""
	REPLACE CON_CODCES WITH ""
		
		


   	_V_CONTA = _V_CONTA + 1

   	SELECT AQ_PDCONTI
   	SKIP +1

ENDDO



*!*	################################################# AGGIUNGE I CONTI MASTRO MANCANTI #################################################

   	SELECT CU_CONTI
   	SCATTER MEMVAR

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "11"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "P"
	REPLACE CON_TIPOCO WITH "A"

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "1130"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "P"
	REPLACE CON_TIPOCO WITH "A"

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "12"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "P"
	REPLACE CON_TIPOCO WITH "A"

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "2020"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "P"
	REPLACE CON_TIPOCO WITH "A"

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "2040"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "P"
	REPLACE CON_TIPOCO WITH "A"

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "21"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "P"
	REPLACE CON_TIPOCO WITH "A"

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "2130"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "P"
	REPLACE CON_TIPOCO WITH "A"
	

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "2170"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "P"
	REPLACE CON_TIPOCO WITH "A"

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "31"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "E"
	REPLACE CON_TIPOCO WITH "A"

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "32"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "E"
	REPLACE CON_TIPOCO WITH "A"

   	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _PUB_ANNO
	REPLACE CON_CONTO  WITH "1030000000000"
	REPLACE CON_DESCR  WITH "DESCRIZIONE DA AGGIORNARE ****"
	REPLACE CON_POSBIL WITH "P"
	REPLACE CON_TIPOCO WITH "C"





*!*	################################################# CREA PIANO DEI CONTI DA ANAGRAFICA CLIENTI #################################################

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

CC=SUBSTR(LIBERA,1,4)

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP

CTRELAB = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   CPA=CLI_CONPAG
   CLI=CLI_CODCLI +" " + SUBSTR(CLI_RAGSOC,1,30)

   V_ER = SOTTOGEN(CLI_NAZION)
   IF !V_ER
      CC = PUB_CC
   ELSE
      CC = CCC
   ENDIF

   SELECT CUR_CLIENTI

   SCATTER MEMVAR MEMO

   XXX_CODCLI = CC + SUBSTR(M.CLI_CODCLI,1,9)
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + _PUB_ANNO + "'"
   x_cont = "con_conto = '" + XXX_CODCLI + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      RETURN .F.
   ENDIF
   SELECT CONTI
   GO TOP
   IF EOF()
	  SELECT CU_CONTI
	  APPEND BLANK
	  REPLACE CON_SOC    WITH PUB_CODSOC
	  REPLACE CON_ANNO   WITH _PUB_ANNO
	  REPLACE CON_CONTO  WITH XXX_CODCLI
	  REPLACE CON_DESCR  WITH M.CLI_RAGSOC
	  REPLACE CON_TIPOCO WITH 'C'
	  REPLACE CON_POSBIL WITH 'P'
   ENDIF

   SELECT CUR_CLIENTI
   SKIP +1

ENDDO

*!*	################################################# CREA PIANO DEI CONTI DA ANAGRAFICA FORNITORI #################################################

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

FFF=SUBSTR(LIBERA,18,4)

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"CUR_FORNITORI")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORI
GO TOP

CTRELAB = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   CPA=for_CONPAG
   for_=for_CODCLI +" " + SUBSTR(for_RAGSOC,1,30)

	V_ER = SOTTOGEN(FOR_nazion)
	IF !V_ER
	    FF = PUB_FF
	ELSE
	    FF = FFF
	ENDIF

   SELECT CUR_FORNITORI


   SCATTER MEMVAR MEMO

   XXX_CODfor = FF + SUBSTR(M.for_CODCLI,1,9)
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + _PUB_ANNO + "'"
   x_cont = "con_conto = '" + XXX_CODfor + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      RETURN .F.
   ENDIF
   SELECT CONTI
   GO TOP
   IF EOF()
	  SELECT CU_CONTI
	  APPEND BLANK
	  REPLACE CON_SOC    WITH PUB_CODSOC
	  REPLACE CON_ANNO   WITH _PUB_ANNO
	  REPLACE CON_CONTO  WITH XXX_CODfor
	  REPLACE CON_DESCR  WITH M.for_RAGSOC
	  REPLACE CON_TIPOCO WITH 'F'
	  REPLACE CON_POSBIL WITH 'P'
   ENDIF

   SELECT CUR_FORNITORI
   SKIP +1

ENDDO


*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0

   WAIT WINDOWS "Scrittura archivio deil Piano dei Conti sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','CONTI','I','','CU_CONTI')
      return(.f.)
   ENDIF

   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records scritti : " + ALLTRIM(STR(_V_CONTA,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF


SET DEFA TO &PUB_DIR

RETURN


*************************************************************************************************
PROCEDURE CONV_PART_CLI_SOP	&& CONVERTE LA TABELLA PARTITARI CLIENTI DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE PARTITARI CLIENTI		   								*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.			  											 	*
*	Ottobre 2007 - Modificato 																	*
*************************************************************************************************
PARAMETERS _PUB_ANNO,_NOME_FILE

RELEASE CLI_FOR
PUBLIC CLI_FOR
CLI_FOR = 'C'        && GESTIONE CLINTE SERGIO

SET EXCLUSIVE ON

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

MESSAGEBOX("ARCHIVIO IN INPUT DA ELABORARE :" + CHR(13) + ;
              _NOME_FILE,64,"Informazione")

V_PATH = ALLTRIM(_V_PERCORSO) + _NOME_FILE

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF



IF USED("AQ_PDTESTA")
   SELECT AQ_PDTESTA
   USE
ENDIF



IF FILE(_NOME_FILE+".CDX")
   ERASE _NOME_FILE+".CDX"
ENDIF

IF !USED(V_PATH)
   USE &V_PATH EXCLU
ENDIF
=MODTBL(ALIAS(SELECT()),"PAR_NPART","N(10,0)",.F.,.F.)
=MODTBL(ALIAS(SELECT()),"PAR_NUMPRO","C(13)",.F.,.F.)
=MODTBL(ALIAS(SELECT()),"PAR_CODPAG","C(8)",.F.,.F.)
=MODTBL(ALIAS(SELECT()),"PAR_DTSCAD","C(10)",.F.,.F.)
=MODTBL(ALIAS(SELECT()),"PAR_CODCLI","C(13)",.F.,.F.)
=MODTBL(ALIAS(SELECT()),"PAR_TIPFAT","C(03)",.F.,.F.)


INDEX ON SUBSTR(N1,7,2) + ALLTRIM(N9)	TAG __NPROT__ 	ADDITIVE
INDEX ON SUBSTR(N1,7,2) + ALLTRIM(N10)  TAG DTNU_REG 	ADDITIVE



*** CANCELLAZIONE DEI RECORD DELLA TABELLA  PART_CLI  SQL
WAIT WINDOWS "Cancellazione PARTITARIO CLIENTI ...  -  Prego Attendere" NOWAIT
x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
x_anno = "par_anno = '" + _PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "delete from PART_CLI where " + x_cond
IF !ExecCommand(cSql,"PART_CLI")
   return(.f.)
ENDIF



*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PART_CLI where 1=0"
IF !ExecCommand(cSql,"CU_PART_CLI")
   return(.f.)
ENDIF

SELECT CU_PART_CLI
=DEFPUB(SELECT())

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA ############################## input
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH



IF FILE("SALVA_PART.DBF")
   ERASE "SALVA_PART.DBF"
ENDIF


IF FILE("AQ_PDTESTA.CDX")
   ERASE AQ_PDTESTA.CDX
ENDIF

SET EXCLUSIVE OFF


=OPENDB("AQ_CAUSPAG")
SELECT AQ_CAUSPAG
SET ORDER TO PAGCOD


=OPENDB("AQ_PDTESTA")
SELECT AQ_PDTESTA
INDEX ON pdanno + pdnrreg  TAG Tnreg ADDITIVE
SET ORDER TO Tnreg



=OPENDB(_NOME_FILE)
SELECT &_NOME_FILE



_V_CONTA  = 0


***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE
v_seek	 = 'GEN'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro GEN 4 caratteri conti clienti"
   RETURN
ENDIF
CC = SUBSTR(LIBERA,1,4)
CCC = SUBSTR(LIBERA,1,4)





*!* #########################################################	   SISTEMA DATI       #########################################################
___PAR_CODCLI	= ""		

SELECT &_NOME_FILE
GO TOP


DO WHILE .T.

   	IF EOF()
      EXIT
   	ENDIF

   	IF DELETED()
   	  SELECT &_NOME_FILE
   	  SKIP +1
      LOOP
   	ENDIF



   	WAIT WINDOWS "Conversione Partitario clienti , RIPORTA RIFERIMENTI " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT


   	SCATTER MEMVAR MEMO

***SERGIO.
		
	IF SUBSTR(N1,1,5) 	= "Conto"
		___PAR_CODCLI = TRC(PUB_LCL,SUBSTR(STAMPA_MAS,1,7))
 							
		x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "cli_codcli = '" + ___PAR_CODCLI + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
		IF !ExecCommand(cSql,"CUR_CLIENTI")
		   RETURN .F.
		ENDIF
		SELECT CUR_CLIENTI
		GO TOP
		IF !EOF()
	       V_ER = SOTTOGEN(CLI_NAZION)
		   IF !V_ER
		      CC = PUB_CC
		   ELSE
		      CC = CCC
		   ENDIF
	    ELSE
		   CC = CCC
	    ENDIF
		
	ENDIF

   	SELECT &_NOME_FILE
 	
 	REPLACE PAR_CODCLI 	WITH CC+ALLTRIM(___PAR_CODCLI)


	DO CASE
		CASE UPPER(SUBSTR(STAMPA_MAS,1,4)) = "FATT"
			___PAR_TIPFAT = "VEN"
		CASE UPPER(SUBSTR(STAMPA_MAS,1,3)) = "INC"
			___PAR_TIPFAT = "BOC"
		CASE UPPER(SUBSTR(STAMPA_MAS,1,4)) = "RIBA"
			___PAR_TIPFAT = "ERB"
		CASE UPPER(SUBSTR(STAMPA_MAS,1,4)) = "N/CR"
			___PAR_TIPFAT = "699"
		CASE UPPER(SUBSTR(STAMPA_MAS,1,3)) = "INS"	
			___PAR_TIPFAT = "INC"
		CASE UPPER(SUBSTR(STAMPA_MAS,1,8)) = "PFC"
			___PAR_TIPFAT = "BOC"
		OTHERWISE
			___PAR_TIPFAT = "GEN"	
	ENDCASE

 	REPLACE PAR_TIPFAT 	WITH ___PAR_TIPFAT


	DO CASE
	
		CASE  SUBSTR(UPPER(M.STAMPA_MAS),1,4)	= "INC."
			
			
			IF EMPTY(M.N7)
				
				
				IF !EMPTY(SUBSTR(M.STAMPA_MAS,20,1))												&& Inc. Fatt: 1  del  12/01/2006    - 20
					___NUMERO_FATTURA = SUBSTR(M.STAMPA_MAS,12,3)									
					___DATA_FATTURA   = SUBSTR(M.STAMPA_MAS,20,6)+SUBSTR(M.STAMPA_MAS,28,2)	
			    	SELECT &_NOME_FILE
					REPLACE N7	WITH ALLTRIM(___DATA_FATTURA)
					REPLACE N8	WITH ALLTRIM(___NUMERO_FATTURA)
					REPLACE N9	WITH ALLTRIM(___NUMERO_FATTURA)
	   	  			SKIP +1
	      			LOOP
				ENDIF	
			
				IF !EMPTY(SUBSTR(M.STAMPA_MAS,21,1))												&& Inc. Fatt: 22  del  28/04/2006    - 21
					___NUMERO_FATTURA = SUBSTR(M.STAMPA_MAS,12,4)									
					___DATA_FATTURA   = SUBSTR(M.STAMPA_MAS,21,6)+SUBSTR(M.STAMPA_MAS,29,2)	
			    	SELECT &_NOME_FILE
					REPLACE N7	WITH ALLTRIM(___DATA_FATTURA)
					REPLACE N8	WITH ALLTRIM(___NUMERO_FATTURA)
					REPLACE N9	WITH ALLTRIM(___NUMERO_FATTURA)
	   	  			SKIP +1
	      			LOOP
				ENDIF	
			
			
				IF !EMPTY(SUBSTR(M.STAMPA_MAS,22,1))												&& Inc. Fatt: 355  del  28/04/2006    - 22
					___NUMERO_FATTURA = SUBSTR(M.STAMPA_MAS,12,5)									
					___DATA_FATTURA   = SUBSTR(M.STAMPA_MAS,22,6)+SUBSTR(M.STAMPA_MAS,30,2)	
			    	SELECT &_NOME_FILE
					REPLACE N7	WITH ALLTRIM(___DATA_FATTURA)
					REPLACE N8	WITH ALLTRIM(___NUMERO_FATTURA)
					REPLACE N9	WITH ALLTRIM(___NUMERO_FATTURA)
	   	  			SKIP +1
	      			LOOP
				ENDIF	
			
			
			ENDIF		
		
	
		CASE  SUBSTR(UPPER(M.STAMPA_MAS),1,4)	= "RIBA"

			
			IF EMPTY(M.N7)
			
			    SELECT &_NOME_FILE				
				SKIP -1
				IF !BOF()
					___NUMERO_FATTURA = ALLTRIM(N8)									
					___DATA_FATTURA   = ALLTRIM(N7)
			    	SELECT &_NOME_FILE
			    	SKIP +1
					REPLACE N7	WITH ALLTRIM(___DATA_FATTURA)
					REPLACE N8	WITH ALLTRIM(___NUMERO_FATTURA)
					REPLACE N9	WITH ALLTRIM(___NUMERO_FATTURA)
	   	  			SKIP +1
	      			LOOP
				ELSE
					SKIP +1
				ENDIF
	
			ENDIF


		CASE  SUBSTR(UPPER(M.STAMPA_MAS),1,10)	= "Ins. Fatt:"
			
			
			IF EMPTY(M.N7)
				
				
				IF !EMPTY(SUBSTR(M.STAMPA_MAS,20,1))												&& Ins. Fatt: 1  del  12/01/2006    - 20
					___NUMERO_FATTURA = SUBSTR(M.STAMPA_MAS,12,3)									
					___DATA_FATTURA   = SUBSTR(M.STAMPA_MAS,20,6)+SUBSTR(M.STAMPA_MAS,28,2)	
			    	SELECT &_NOME_FILE
					REPLACE N7	WITH ALLTRIM(___DATA_FATTURA)
					REPLACE N8	WITH ALLTRIM(___NUMERO_FATTURA)
					REPLACE N9	WITH ALLTRIM(___NUMERO_FATTURA)
	   	  			SKIP +1
	      			LOOP
				ENDIF	
			
				IF !EMPTY(SUBSTR(M.STAMPA_MAS,21,1))												&& Ins. Fatt: 22  del  28/04/2006    - 21
					___NUMERO_FATTURA = SUBSTR(M.STAMPA_MAS,12,4)									
					___DATA_FATTURA   = SUBSTR(M.STAMPA_MAS,21,6)+SUBSTR(M.STAMPA_MAS,29,2)	
			    	SELECT &_NOME_FILE
					REPLACE N7	WITH ALLTRIM(___DATA_FATTURA)
					REPLACE N8	WITH ALLTRIM(___NUMERO_FATTURA)
					REPLACE N9	WITH ALLTRIM(___NUMERO_FATTURA)
	   	  			SKIP +1
	      			LOOP
				ENDIF	
			
			
				IF !EMPTY(SUBSTR(M.STAMPA_MAS,22,1))												&& Ins. Fatt: 355  del  28/04/2006    - 22
					___NUMERO_FATTURA = SUBSTR(M.STAMPA_MAS,12,5)									
					___DATA_FATTURA   = SUBSTR(M.STAMPA_MAS,22,6)+SUBSTR(M.STAMPA_MAS,30,2)	
			    	SELECT &_NOME_FILE
					REPLACE N7	WITH ALLTRIM(___DATA_FATTURA)
					REPLACE N8	WITH ALLTRIM(___NUMERO_FATTURA)
					REPLACE N9	WITH ALLTRIM(___NUMERO_FATTURA)
	   	  			SKIP +1
	      			LOOP
				ENDIF	
			
			
			ENDIF		
		

	
	ENDCASE


  	SELECT &_NOME_FILE
 	SKIP +1


ENDDO


*!* #########################################################	   RIPORTO DATI DA ALTRI FILE      ###############################################

___CONTA_PART = 0
* N10 = NUMERO DI REGISTRAZIONE
* N1  = DATA DI REGISTRAZIONE GG/MM/AA
* N7  = DATA DI FATTURA GG/MM/AA
* N8  = NUMERO FATTURA
* N9  = NUMERO PROTOCOLLO

	
SELECT N10,N1,N7,N8,N9 FROM &_NOME_FILE NOCONSOLE GROUP BY N10,N1,N7,N8,N9


SELECT QUERY
GO TOP

DO WHILE .T.

   	IF EOF()
      EXIT
   	ENDIF

   	IF DELETED()
   	  SELECT QUERY
   	  SKIP +1
      LOOP
   	ENDIF

   	IF SUBSTR(N10,1,7) = "Rif.Pd."				&& NUMERO DI REGISTRAZIONE
   	  SELECT QUERY
   	  SKIP +1
      LOOP
   	ENDIF


   	IF SUBSTR(N10,1,1) = " "					&& NUMERO DI REGISTRAZIONE
   	  SELECT QUERY
   	  SKIP +1
      LOOP
   	ENDIF



	* N1  			= DATA DI REGISTRAZIONE GG/MM/AA
	* N7  			= DATA DI FATTURA GG/MM/AA
	* N8  			= NUMERO FATTURA
	* N9  			= NUMERO PROTOCOLLO
	* N10 			= NUMERO DI REGISTRAZIONE
	* STAMPA_MAS	= CONTIENE LA DESCRIZIONE DEL MOVIMENTO

	_N1			= ALLTRIM(N1)						&& data di registrazione
	_N10		= ALLTRIM(N10)						&& numero di registrazione

	_N7			= ALLTRIM(N7)						&& data di FATTURA
	_N8			= ALLTRIM(N8)						&& numero di FATTURE

	_N9			= ALLTRIM(N9)						&& numero di protocollo

	_NPRO 		= N9
	_ANNO 		= "20"+SUBSTR(N1,7,2)				&& ANNO REGISTRAZIONE
	_NREG 		= ALLTRIM(N10) 						&& NUMERO REGISTRAZIONE


    ___CONDIZIONE_PAGAMENTO = ""

	SELECT AQ_PDTESTA					&& RISALE A PDTESTA PER LE CONDIZIONI DI PAGAMENTO
	SET ORDER TO Tnreg
	
	_SEEK = _ANNO + _NREG
	SEEK _SEEK
	IF FOUND()

		DO WHILE .NOT.EOF()
		
		
			IF ALLTRIM(_ANNO) <> ALLTRIM(CONV_CLEAR(pdanno))
				EXIT
			ENDIF

			IF ALLTRIM(_NREG) <> ALLTRIM(CONV_CLEAR(pdnrreg))
				EXIT
			ENDIF

			IF !EMPTY(PAGCOD)
				___CONDIZIONE_PAGAMENTO =  CONV_CLEAR(PAGCOD)
				EXIT
			ENDIF

			SELECT AQ_PDTESTA
			SKIP +1
			
		ENDDO
		
	ENDIF
	
	
	
	*!*		AGGIORNA FILE DI INPUT CON LE CONDIZIONI DI PAGAMENTO E IL NUMERO DI PARTITA E IL NUMERO DI PRIMA NOTA

	___CONTA_PART = ___CONTA_PART +1
	___PAR_NUMPRO = SYS(2015)
	___PAR_NPART  = VAL(_NPRO)
	___PAR_CODPAG = CONV_CERCA_CPA(___CONDIZIONE_PAGAMENTO,"PARTITARI")
*!*		___PAR_CODPAG = ___CONDIZIONE_PAGAMENTO
	
	

	SELECT &_NOME_FILE
	SET ORDER TO __NPROT__
	_SEEK 	= SUBSTR(_N1,7,2) + ALLTRIM(_N9)				 	&& DATA + NUMERO DI PROTOCOLLO
	SET NEAR ON
	SEEK  _SEEK
	SET NEAR OFF
	IF FOUND()
	
		DO WHILE .NOT.EOF()
		
		    IF DELETED()
				SELECT &_NOME_FILE
				SKIP +1
				LOOP
		    ENDIF
	
		
			IF SUBSTR(N1,7,2) <> SUBSTR(_N1,7,2)		&& data di registrazione
				EXIT
			ENDIF

			IF ALLTRIM(N9) <> ALLTRIM(_N9)				&& numero di PROTOCOLLO
				EXIT
			ENDIF

			REPLACE	PAR_NUMPRO	WITH ___PAR_NUMPRO
			REPLACE PAR_NPART   WITH ___PAR_NPART
			IF !EMPTY(___PAR_CODPAG)
				REPLACE PAR_CODPAG	WITH ___PAR_CODPAG
			ENDIF

		    _DESMOV 	= ALLTRIM(STAMPA_MAS)												&& DESCRIZIONE DEL MOVIMENTO

    		IF SUBSTR(_DESMOV,1,9) 	= "RIBA SCAD"											&& GESTIONE RI.BA.
    			IF SUBSTR(_DESMOV,23,1) = "0"
    				___PAR_DTSCAD = SUBSTR(_DESMOV,15,10)									&& DATA IN FORMATO GG/MM/AAAA		
    			ELSE
    				___PAR_DTSCAD = SUBSTR(_DESMOV,15,6)+"20"+SUBSTR(_DESMOV,21,2)			&& DATA IN FORMATO GG/MM/AA
    			ENDIF	
				IF SUBSTR(___PAR_DTSCAD,3,1) = "/"
					REPLACE PAR_DTSCAD 	WITH RIBALTA2(___PAR_DTSCAD)
				ELSE
					REPLACE PAR_DTSCAD 	WITH ___PAR_DTSCAD
				ENDIF
			ENDIF


			SELECT &_NOME_FILE
			SKIP +1
			
		ENDDO
	
	
	ENDIF


	SELECT QUERY
   	SKIP +1

ENDDO




*!* #########################################################	   CREA PARTITARI       #########################################################
_V_CONTA = 0
RELEASE DATA_SCAD
PUBLIC DATA_SCAD
DATA_SCAD   = ""

SELECT &_NOME_FILE
GO TOP


DO WHILE .T.

   	IF EOF()
      EXIT
   	ENDIF

   	IF DELETED()
   	  SELECT &_NOME_FILE
   	  SKIP +1
      LOOP
   	ENDIF

   	IF EMPTY(N1)
   	  SELECT &_NOME_FILE
   	  SKIP +1
      LOOP
   	ENDIF


   	IF SUBSTR(N1,1,5) = "Conto"
   	  SELECT &_NOME_FILE
   	  SKIP +1
      LOOP
   	ENDIF

   	IF SUBSTR(N1,1,8) = "Data Reg"
   	  SELECT &_NOME_FILE
   	  SKIP +1
      LOOP
   	ENDIF

*!*	   	IF SUBSTR(STAMPA_MAS,1,14) = "CHIUSURA SALDI"
*!*	   	  SELECT &_NOME_FILE
*!*	   	  SKIP +1
*!*	      LOOP
*!*	   	ENDIF


*!*		IF _PUB_ANNO = "2006"										&& TRATTA I RECORD DI BILANCIO APERTURA SE 2006
*!*		ELSE
*!*		   	IF SUBSTR(STAMPA_MAS,1,20) = "BILANCIO DI APERTURA"
*!*		   	  SELECT &_NOME_FILE
*!*		   	  SKIP +1
*!*		      LOOP
*!*		   	ENDIF
*!*	   	ENDIF


   	WAIT WINDOWS "Conversione Partitario clienti " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT



	SCATTER MEMVAR MEMO

	TOP_TOP = M.PAR_TIPFAT

	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" + SUBSTR(M.PAR_CODCLI,PUB_SOTTOG,9) + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	IF !ExecCommand(cSql,"CUR_CLIENTI")
	   RETURN .F.
	ENDIF
	SELECT CUR_CLIENTI
	GO TOP
	IF !EOF()
	   V_TELEFO  = CLI_TELEFO
	   V_PARIVA  = CLI_PARIVA
	   V_RAGSOC  = CLI_RAGSOC
	   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
	   VET_DAL[1]= CLI_BDAL
	   VET_DAL[2]= CLI_B2DAL
	   VET_AL[1] = CLI_BAL
	   VET_AL[2] = CLI_B2AL
	   VET_DAY[1]= CLI_GG1
	   VET_DAY[2]= CLI_GG2
	   V_CONPAG  = CLI_CONPAG
	ELSE
	   V_TELEFO  = SPACE(15)
	   V_PARIVA  = SPACE(16)
	   V_RAGSOC  = "CLIENTE INESISTENTE"
	   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
	   VET_DAL[1]= "0000"
	   VET_DAL[2]= "0000"
	   VET_AL[1] = "0000"
	   VET_AL[2] = "0000"
	   VET_DAY[1]= "0000"
	   VET_DAY[2]= "0000"
	   V_CONPAG  = PUB_CPA
	ENDIF

   	SELECT &_NOME_FILE

	IF !EMPTY(M.PAR_CODPAG)
		V_CONPAG  = M.PAR_CODPAG
	ENDIF

	IF EMPTY(M.N7)
		DTD= SUBSTR(M.N1,1,6)+"20"+SUBSTR(M.N1,7,2)  && forza data registrazione
	ELSE
		DTD= SUBSTR(M.N7,1,6)+"20"+SUBSTR(M.N7,7,2)
	ENDIF
	
	IMP = 0
	IF VAL(M.N3) <> 0
		IMP = VAL(M.N3)
	ENDIF

	IF VAL(M.N4) <> 0
		IMP = VAL(M.N4)	
	ENDIF
	
	YVALUTA = "EUR"
	YCAMBIO = 1
	
    IF EMPTY(M.PAR_DTSCAD)
	    V_TUTTO=TRANCHE("PARA",V_CONPAG,RIBALTA2(DTD),IMP,VET_DAL,VET_AL,VET_DAY,YVALUTA)
	    DO SCADULT     && RICERCA ULTIMA DATA SCADENZA
	    M.PAR_DTSCAD = RIBALTA2(DATA_SCAD)
	ENDIF

   	v_seek	= 'TOP' + M.PAR_TIPFAT
   	v_chiave = "codice"
   	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      	SELECT CUR_PARA
      	NOTAC	     = SUBSTR(LIBERA,11,1)
      	FATTURA   	 = SUBSTR(LIBERA,2,1)
   	ELSE
      	WAIT WINDOW "Errore manca parametro TOP :"+TOP_TOP
      	NOTAC	     = " "
      	FATTURA   	 = " "
   	ENDIF


	IF !ExecCommand("select * from part_cli where 0=1","CUR_PARTCLI")
	   return(.f.)
	ENDIF

	_V_CONTA = _V_CONTA + 1


	SELECT CUR_PARTCLI
	APPEND BLANK
	REC_PART=RECNO()
	REPLACE PAR_CODSOC  WITH PUB_CODSOC
	REPLACE PAR_ANNO    WITH _PUB_ANNO


	IF VAL(M.N3) <> 0
		REPLACE PAR_TMOV    WITH "D"
	ENDIF

	IF VAL(M.N4) <> 0
		REPLACE PAR_TMOV    WITH "A"
	ENDIF

	REPLACE PAR_CODCLI  WITH M.PAR_CODCLI
	REPLACE PAR_RAGSOC  WITH V_RAGSOC
	
	DATREG = SUBSTR(M.N1,1,6)+"20"+SUBSTR(M.N1,7,2)
    REPLACE PAR_DTREG  WITH RIBALTA2(DATREG)

	REPLACE PAR_DTFAT  WITH RIBALTA2(DTD)
	
	REPLACE PAR_TIPFAT  WITH M.PAR_TIPFAT
	REPLACE PAR_NPROT   WITH M.N9
	
	REPLACE PAR_DESMOV	WITH ALLTRIM(M.STAMPA_MAS)
	
	REPLACE PAR_TOTIM   WITH IMP
	REPLACE PAR_TIMPOS  WITH 0           && TIVA ???????
	REPLACE PAR_FATT    WITH IMP
	
	REPLACE PAR_NUMFAT  WITH M.N8	
	_NDOC = M.N8
	
	IF EMPTY(ALLTRIM(PAR_NUMFAT))
		REPLACE PAR_NUMFAT  WITH SUBSTR(M.N10,2,6) 		&& FORZA NUMERO REGISTRAZIONE
		_NDOC = SUBSTR(M.N10,2,6) 						&& FORZA NUMERO REGISTRAZIONE
	ENDIF
	
	
	REPLACE PAR_NPROG   WITH 100
	
	IF FATTURA  <> "S"
		REPLACE PAR_NPROG   WITH 300					&& MOVIMENTI NON FATTURE
		REPLACE PAR_TIPODO  WITH "PAG"
	ELSE
		REPLACE PAR_TIPODO  WITH "FAT"
	ENDIF
	
	REPLACE PAR_NPART   WITH M.PAR_NPART
	REPLACE PAR_CODPAG  WITH V_CONPAG
	REPLACE PAR_TEL     WITH V_TELEFO
	REPLACE PAR_IVA     WITH V_PARIVA
	REPLACE PAR_NREG    WITH SUBSTR(M.N10,2,6)
	
	M.PAR_NUMPRO=CONV_CERCA_REGISTRAZIONE_CONTABILE(M.PAR_CODCLI,_PUB_ANNO,SUBSTR(M.N10,2,6),RIBALTA2(DATREG),M.PAR_NPART)
	REPLACE PAR_NUMPRO  WITH M.PAR_NUMPRO
	
	REPLACE PAR_CIVA1   WITH ""							&& CIVA ????????????
	REPLACE PAR_IMPO1   WITH IMP
	REPLACE PAR_IMPOS1  WITH 0							&& TIVA ??????????
	REPLACE PAR_TOT1    WITH IMP
	REPLACE PAR_CIVA2   WITH "   "
	REPLACE PAR_IMPO2   WITH 0
	REPLACE PAR_IMPOS2  WITH 0
	REPLACE PAR_TOT2    WITH 0
	REPLACE PAR_CIVA3   WITH "   "
	REPLACE PAR_IMPO3   WITH 0
	REPLACE PAR_IMPOS3  WITH 0
	REPLACE PAR_TOT3    WITH 0
	REPLACE PAR_CIVA4   WITH "   "
	REPLACE PAR_IMPO4   WITH 0
	REPLACE PAR_IMPOS4  WITH 0
	REPLACE PAR_TOT4    WITH 0
	REPLACE PAR_CIVA5   WITH "   "
	REPLACE PAR_IMPO5   WITH 0
	REPLACE PAR_IMPOS5  WITH 0
	REPLACE PAR_TOT5    WITH 0

	V_DTSCA = M.PAR_DTSCAD
	
    IF EMPTY(V_DTSCA)
    	V_DTSCA = RIBALTA2(DATREG)					&& FORZA DATA REGISTRAZIONE
    ENDIF	
	
	
	IF SUBSTR(V_DTSCA,3,1) = "/"
    	V_DTSCA = RIBALTA2(V_DTSCA) 				&& DT.SCAD DA FATTURA
    ENDIF

   	REPLACE PAR_DTSCAD  WITH V_DTSCA           		&& DT.SCAD DA FATTURA


	REPLACE PAR_VALUTA WITH YVALUTA
	REPLACE PAR_CAMBIO WITH YCAMBIO

	REPLACE PAR_DTVAL  WITH V_DTSCA
	REPLACE PAR_DATPAG WITH V_DTSCA

	REPLACE PAR_IMPVAL WITH IMP	         	 		&& VALORE IN VALUTA
	
	
	SCATTER MEMVAR MEMO

	
	IF FATTURA  = "S"
		DO CONV_REG_SCAD      			&& GESTIONE SCADENZIARIO CLIENTI
	ENDIF
	
	IF !ExecRW('','part_cli','I','','CUR_PARTCLI')
	   return(.f.)
	ENDIF


*!*		=CREA_SALDI_CF("C",M.PAR_CODCLI,_NDOC,"XXXXXXXXXX","CREA")


  	SELECT &_NOME_FILE
 	SKIP +1


ENDDO


*!* #########################################################	  CONTROVERIFICA       #########################################################


	

*!*	CREATE CURSOR CUR_ERR_PART (PAR_CODCLI C(13),AQ_DARE N(13,0),AQ_AVERE N(13,0),MAC_DARE N(13,0),MAC_AVERE N(13,0),PAR_RAGSOC C(35))



*!*	SELECT &_NOME_FILE
*!*	GO TOP

*!*	
*!*	DO WHILE .T.

*!*	   	IF EOF()
*!*	      EXIT
*!*	   	ENDIF
*!*	
*!*	   	IF DELETED()
*!*	   	  SELECT &_NOME_FILE
*!*	   	  SKIP +1
*!*	      LOOP
*!*	   	ENDIF

*!*	
*!*	   	WAIT WINDOWS "Controverifica " NOWAIT


*!*	   	SCATTER MEMVAR MEMO

*!*			
*!*		IF SUBSTR(STAMPA_MAS,1,15) 	<> "Totali generali"
*!*	   	  SELECT &_NOME_FILE
*!*	   	  SKIP +1
*!*	      LOOP
*!*		ENDIF

*!*	    SCATTER MEMVAR MEMO
*!*	
*!*	    __DARE_INPUT = VAL(M.N3)
*!*	    __AVERE_INPUT = VAL(M.N4)
*!*	
*!*		*!*	CREA IL PRIMO CURSORE PER I SALDI DARE
*!*		__clien  ="par_codcli = '" + ALLTRIM(M.par_codcli) + "'"
*!*		__campi__="par_codcli"
*!*		__somma__=", SUM(par_fatt) AS par_fattd"
*!*		__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'D' "  && TUTTE LE PARTITE
*!*		x_cond = __condi__ + " and " + __clien


*!*		cSql="SELECT "+__campi__+__somma__+" FROM PART_CLI WHERE " + x_cond +  ;
*!*		    					                          " group by "+__campi__+" order by PAR_CODCLI"
*!*		IF !ExecCommand(cSql,"cur_dare")
*!*		   return(.f.)
*!*		ENDIF

*!*		*!*	CREA IL SECONDO CURSORE PER I SALDI AVERE
*!*		__clien  ="par_codcli = '" + ALLTRIM(M.par_codcli) + "'"
*!*		__campi__="par_codcli"
*!*		__somma__=", SUM(par_fatt) AS par_fatta"
*!*		__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'A' "  && TUTTE LE PARTITE
*!*		x_cond = __condi__ + " and " + __clien


*!*		cSql="SELECT "+__campi__+__somma__+" FROM PART_CLI WHERE " + x_cond +  ;
*!*		    					                          " group by "+__campi__+" order by PAR_CODCLI"
*!*		IF !ExecCommand(cSql,"cur_avere")
*!*		   return(.f.)
*!*		ENDIF

*!*	    IF __DARE_INPUT <> cur_dare.par_fattd OR __AVERE_INPUT <> cur_avere.par_fatta
*!*	    	SELECT CUR_ERR_PART
*!*	    	APPEND BLANK
*!*	    	REPLACE PAR_CODCLI WITH M.PAR_CODCLI
*!*	    	REPLACE AQ_DARE	   WITH cur_dare.par_fattd
*!*	     	REPLACE MAC_DARE   WITH __DARE_INPUT
*!*	    	REPLACE AQ_AVERE   WITH cur_avere.par_fatta
*!*	     	REPLACE MAC_AVERE  WITH __AVERE_INPUT
*!*		ENDIF
*!*	   	

*!*	    SELECT &_NOME_FILE
*!*	    SKIP +1

*!*	ENDDO

*!*	SELECT CUR_ERR_PART
*!*	GO TOP
*!*	IF !EOF()
*!*		BROWSE
*!*	ENDIF


*!*	SET DEFA TO &PUB_DIR

*!*	RETURN


***************************************************************************
FUNCTION CONV_CERCA_NAZIONE
***************************************************************************
*
PARA _CODICE_NAZIONE

	___SS=STR(SELECT())
	_COD_NAZ = "???"
	SELECT stati_esteri
	SET ORDER TO mac_cod
	_SEEK = _CODICE_NAZIONE
	SEEK _SEEK
	IF FOUND()
		_COD_NAZ = AQU_COD
	ENDIF
	SELECT &___SS

RETURN(_COD_NAZ)


***************************************************************************
FUNCTION CONV_CERCA_IVA_CLI
***************************************************************************
*
PARA _DTREG,_NUMREG,_IMPORTO


___SS=STR(SELECT())

	SELECT AQ_PDIVACL
	SET ORDER  TO DnregCL
	_SEEK = _DTREG + ALLTRIM(_NUMREG)
	SEEK _SEEK
	IF FOUND()
	
		_PDIVACOD = ""
		
		DO WHILE .NOT. EOF()
			
			IF DELETED()
				SELECT AQ_PDIVACL
				SKIP +1
				LOOP
			ENDIF

						
			IF ALLTRIM(ribalta2(DTOC(pddtreg))) = ALLTRIM(_DTREG) AND ALLTRIM(pdnrreg) = ALLTRIM(_NUMREG)
			ELSE
				EXIT
			ENDIF
		
		
		    _IMPORTO_IMPONIBILE_IVA  	= PDIMPON
		    _PDIVACOD 					= PDIVACOD
		
		    IF _IMPORTO = _IMPORTO_IMPONIBILE_IVA
		    	EXIT
		    ENDIF
		
		
			SELECT AQ_PDIVACL
			SKIP +1
		
		ENDDO

		=CONV_DECODIFICA_CODICE_IVA(_PDIVACOD)			
	
	ENDIF
	
SELECT &___SS


RETURN


***************************************************************************
FUNCTION CONV_CERCA_IVA_FOR
***************************************************************************
*
PARA _DTREG,_NUMREG,_IMPORTO


___SS=STR(SELECT())

	SELECT AQ_PDIVAFR
	SET ORDER  TO DnregFR
	_SEEK = _DTREG + ALLTRIM(_NUMREG)
	SEEK _SEEK
	IF FOUND()
	
		_PDIVACOD = ""
		
		DO WHILE .NOT. EOF()
			
			IF DELETED()
				SELECT AQ_PDIVAFR
				SKIP +1
				LOOP
			ENDIF

						
			IF ALLTRIM(ribalta2(DTOC(pddtreg))) = ALLTRIM(_DTREG) AND ALLTRIM(pdnrreg) = ALLTRIM(_NUMREG)
			ELSE
				EXIT
			ENDIF
		
		
		    _IMPORTO_IMPONIBILE_IVA  	= PDIMPON
		    _PDIVACOD 					= PDIVACOD
		
		    IF _IMPORTO = _IMPORTO_IMPONIBILE_IVA
		    	EXIT
		    ENDIF
		
		
			SELECT AQ_PDIVAFR
			SKIP +1
		
		ENDDO

		=CONV_DECODIFICA_CODICE_IVA(_PDIVACOD)		
	
	ENDIF
	

SELECT &___SS

RETURN



***************************************************************************
FUNCTION CONV_DECODIFICA_CODICE_IVA
***************************************************************************
*
PARA _CODICE_IVA


	DO CASE
	
		CASE CONV_CLEAR(_CODICE_IVA) = "20"
			 M.MOV_IVA		= "20"

		CASE CONV_CLEAR(_CODICE_IVA) = "NI41"
			 M.MOV_IVA	= "41"
		
		CASE CONV_CLEAR(_CODICE_IVA) = "NI18A"
			 M.MOV_IVA	= "03"

		CASE CONV_CLEAR(_CODICE_IVA) = "NI8CAM"
			 M.MOV_IVA	= "03"
		
		OTHERWISE
			 M.MOV_IVA	= "NO"
			 		
	ENDCASE


RETURN


***************************************************************************
FUNCTION CONV_DECODIFICA_CODICE_TOP
***************************************************************************
*
PARA _CODICE_TOP

   DO CASE

   		CASE ALLTRIM(_CODICE_TOP) = "GE"
   			M.MOV_TOP	= "GIR"

   		CASE ALLTRIM(_CODICE_TOP) = "FC"
   			M.MOV_TOP	= "VEN"

   		CASE ALLTRIM(_CODICE_TOP) = "INCCL"
   			M.MOV_TOP	= "BOC"
   		
   		CASE ALLTRIM(_CODICE_TOP) = "FF"
   			M.MOV_TOP	= "FAC"

   		CASE ALLTRIM(_CODICE_TOP) = "PF"
   			M.MOV_TOP	= "BOF"

   		CASE ALLTRIM(_CODICE_TOP) = "EMEF"
   			M.MOV_TOP	= "ERB"

   		CASE ALLTRIM(_CODICE_TOP) = "EMEF"
   			M.MOV_TOP	= "ERB"

   			
		OTHERWISE
   			M.MOV_TOP	= "GIR"		   			
   			
   ENDCASE



RETURN

***************************************************************************
FUNCTION CONV_QUADRA_FATTURA
***************************************************************************
* RIPULISCE IL CAMPO DA CARATTERI SPORCHI
PARA _NUMPRO_,_TOTALE_FATTURA,_TOTALE_RICALCOLATO

AABBSSXX    = SELECT()


SELECT CU_MOV_CONT
SET ORDER TO XNUMPRO

_SEEK = _NUMPRO_
SEEK _SEEK
IF FOUND()
	
	DO WHILE .NOT.EOF()
		
		IF DELETED()
			SELECT CU_MOV_CONT
			SKIP +1
			LOOP
		ENDIF
		
		IF ALLTRIM(MOV_NUMPRO) <> ALLTRIM(_NUMPRO_)
			EXIT
		ENDIF
		
	    x_soci = "con_soc = '" + PUB_CODSOC + "'"
	    x_anno = "con_anno = '" + MOV_ANNO + "'"
	    x_cont = "con_conto = '" + MOV_CONTO + "'"
	    x_cond = x_soci + " and " + x_anno + " and " + x_cont
	    cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
	    IF !ExecRW(cSql,"CONTI___","R")
	       RETURN .F.
	    ENDIF
	    SELECT CONTI___
	    GO TOP
	    IF !EOF()
		   __CON_TIPOCON = CON_TIPOCO
		ELSE
		   __CON_TIPOCON = ""
	    ENDIF
		
		IF __CON_TIPOCON = "A"
			IF _TOTALE_FATTURA > _TOTALE_RICALCOLATO
				SELECT CU_MOV_CONT
				_DIFFERENZA = _TOTALE_FATTURA - _TOTALE_RICALCOLATO
				REPLACE MOV_IMPOST WITH MOV_IMPOST + _DIFFERENZA
			ELSE
				SELECT CU_MOV_CONT
				_DIFFERENZA = _TOTALE_RICALCOLATO - _TOTALE_FATTURA
				REPLACE MOV_IMPOST WITH MOV_IMPOST - _DIFFERENZA
			ENDIF
			EXIT
		ENDIF
		
		SELECT CU_MOV_CONT
		SKIP +1
	
	ENDDO

ENDIF

SELECT(AABBSSXX)

RETURN


***************************************************************************
FUNCTION CONV_CALCOLO_IMPOSTA
***************************************************************************
* RIPULISCE IL CAMPO DA CARATTERI SPORCHI
PARA _IMPONIBILE,_CODICE_IVA

	AABBSSXX    = SELECT()


	v_seek	 = 'IVA'+_CODICE_IVA
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	   	SELECT CUR_PARA
		LIB     		= VAL(SUBSTR(LIBERA,1,3))
		M.MOV_IMPOST    =ROUND(((_IMPONIBILE)*LIB/100)+.0000,2)	
	ELSE
	    M.MOV_IMPOST	= 0
	ENDIF


	SELECT(AABBSSXX)
	
	
RETURN

***************************************************************************
FUNCTION CONV_CLEAR
***************************************************************************
* RIPULISCE IL CAMPO DA CARATTERI SPORCHI
PARA __CAMPO_DA_RIPULIRE

*!*	    IF CHR(0) $ __CAMPO_DA_RIPULIRE
*!*			*!*	 STRTRAN(M.CLI_RAGDUE,CHR(0),SPACE(1))
*!*			__CAMPO_DA_RIPULIRE = ""
*!*	    ENDIF

IF ISNULL(__CAMPO_DA_RIPULIRE)
	__CAMPO_DA_RIPULIRE = ''
ENDIF

__CAMPO_DA_RIPULIRE = STRTRAN(__CAMPO_DA_RIPULIRE,CHR(0),"")      	&& NULL
__CAMPO_DA_RIPULIRE = STRTRAN(__CAMPO_DA_RIPULIRE,CHR(11),"")    	&& TAB
__CAMPO_DA_RIPULIRE = STRTRAN(__CAMPO_DA_RIPULIRE,"	","")    		&& CARATTERE STRANO TROVATO IN ARCHIVI CARDIOLINE


	
RETURN(__CAMPO_DA_RIPULIRE)

***************************************************************************
FUNCTION CONV_CERCA_CPA
***************************************************************************
*
PARA __CPA,_PROCEDURA


AABBSSXX    = SELECT()

__CPA_DA_RESTITUIRE = PUB_CPA

IF !EMPTY(__CPA)

	SELECT AQ_CAUSPAG
	SET ORDER TO PAGCOD

	_SEEK = __CPA

	SEEK _SEEK
	IF FOUND()
		__CPA_DA_RESTITUIRE	= AQCODI
	ELSE
		__CPA_DA_RESTITUIRE	= PUB_CPA
	ENDIF

*!*	ELSE

*!*		IF _PROCEDURA = "ANAGRAFICA_CLI_FOR"
*!*			__CPA_DA_RESTITUIRE	= PUB_CPA
*!*		ENDIF

ENDIF


SELECT(AABBSSXX)

RETURN(__CPA_DA_RESTITUIRE)


***************************************************************************
FUNCTION CONV_CERCA_REGISTRAZIONE_CONTABILE
***************************************************************************
*
PARA __CODICE_CF,_ANNO,_NUMREG,_DATREG,_NUMPARTITA


AABBSSXX    = SELECT()



__NUMPRO_DA_RESTITUIRE = M.PAR_NUMPRO


x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_datr = "mov_dtreg = '" + _DATREG + "'"
x_nreg = "mov_nregis = '" + _NUMREG + "'"

cSql   = "SELECT * FROM mov_cont WHERE " + x_soci + " and " + x_datr + " and " + x_nreg + ;
                                  " order by mov_soc,mov_anno,mov_numpro,mov_sequen"

IF !ExecRW(cSql,"CUR_MOV_CONT","R")
   return(.f.)
ENDIF


SELECT CUR_MOV_CONT
GO TOP
DO WHILE .not. EOF()

	IF DELETED()
		SELECT CUR_MOV_CONT
		SKIP +1
		LOOP
	ENDIF
	
	__NUMPRO_DA_RESTITUIRE = MOV_NUMPRO
	EXIT

*!*		REPLACE MOV_NPART WITH _NUMPARTITA		&& RIPORTA IL NUMERO DI PARTITA SUL MOVIMENTO CONTABILE

	SELECT CUR_MOV_CONT
	SKIP +1
	
ENDDO



*!*	IF !ExecRW('','mov_cont','I','','CUR_MOVCONT')
*!*	   return(.f.)
*!*	ENDIF



SELECT(AABBSSXX)

RETURN(__NUMPRO_DA_RESTITUIRE)



*************************************************************************
*    GESTIONE SCADENZIARIO CLIENTI                                      *
*************************************************************************
PROCEDURE CONV_REG_SCAD



*!*	24/07/2006 SERGIO INIZIO
IF FATTURA = 'S' .OR. FATTURA = 'C'  .OR. FATTURA = 'I' 	&& ESEGUE SOLO SE SI TRATTA DI FATTURA / CORRISPETTIVI / INSOLUTI
*!*	24/07/2006 SERGIO FINE
ELSE
   RETURN
ENDIF




HH=SELECT()
DATA_SCAD=SPACE(10)

IF CLI_FOR='C'
	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" + SUBSTR(M.PAR_CODCLI,PUB_SOTTOG,PUB_CONTO) + "'"
	x_cond = x_soci + " and " + x_codi
	Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	IF !ExecCommand(cSql,"cur_clienti")
	   return(.f.)
	ENDIF
	SELECT cur_clienti
	GO TOP


	IF EOF()
	ELSE
	   IF V_CONPAG  = "XXX"  .OR. EMPTY(V_CONPAG)
	      V_CONPAG  = CLI_CONPAG
	   ENDIF
	   V_TELEFO  = CLI_TELEFO
	   V_PARIVA  = CLI_PARIVA
	   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
	   VET_DAL[1]= CLI_BDAL
	   VET_DAL[2]= CLI_B2DAL
	   VET_AL[1] = CLI_BAL
	   VET_AL[2] = CLI_B2AL
	   VET_DAY[1]= CLI_GG1
	   VET_DAY[2]= CLI_GG2
	
	   V_TUTTO=TRANCHE("PARA",V_CONPAG,DTD,(IMP+KABBUO))
	   DO CONV_PERIODI     						&& CREA I PERIODI DI SCADENZA	
	ENDIF
ELSE

	x_soci = "FOR_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "FOR_codcli = '" + SUBSTR(M.PAR_CODCLI,PUB_SOTTOG,PUB_CONTO) + "'"
	x_cond = x_soci + " and " + x_codi
	Csql   = "select * from u_FOR_an where " + x_cond + " order by FOR_codsoc,FOR_codcli"
	IF !ExecCommand(cSql,"cur_clienti")
	   return(.f.)
	ENDIF
	SELECT cur_clienti
	GO TOP


	IF EOF()
	ELSE
	   IF V_CONPAG  = "XXX"  .OR. EMPTY(V_CONPAG)
	      V_CONPAG  = FOR_CONPAG
	   ENDIF
	   V_TELEFO  = FOR_TELEFO
	   V_PARIVA  = FOR_PARIVA
	   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
	   VET_DAL[1]= FOR_BDAL
	   VET_DAL[2]= FOR_B2DAL
	   VET_AL[1] = FOR_BAL
	   VET_AL[2] = FOR_B2AL
	   VET_DAY[1]= FOR_GG1
	   VET_DAY[2]= FOR_GG2
	
	   V_TUTTO=TRANCHE("PARA",V_CONPAG,DTD,(IMP+KABBUO))
	   DO CONV_PERIODI     						&& CREA I PERIODI DI SCADENZA	
	ENDIF

ENDIF


RETURN




*************************
PROCEDURE CONV_PERIODI
*************************

CONTA_TRA = 0
** RICERCA IMPORTO TRANCHE
IS=0
XPAROLA = ''

DO PAROLA

IMP_TRANK=VAL(XPAROLA)

DO WHILE .T.

   CONTA_TRA = CONTA_TRA + 1
   * CNT IDENTIFICA IL NUMERO DI TRANCHE DETERMINATO DA TRANCHE
   IF CONTA_TRA > CNT
      RETURN
   ENDIF

   IF CONTA_TRA = CNT
      IMP_TRANK = IMP_TRANK + COMPENSO
   ENDIF

   ** WAIT WINDOWS STR(IMP_TRANK,13,3)+"<<11<<" +STR(COMPENSO,13,3)+"<<<<"

   ** RICERCA DATA SCADENZA

   XPAROLA = ''
   DO PAROLA

   DATA_SCAD=XPAROLA

   DO CONV_CREA_PERI

ENDDO

RETURN


*************************
PROCEDURE CONV_CREA_PERI
*************************


** ===>>> CREA I PERIODI DI SCADENZA
IF CLI_FOR='C'
   SELECT CUR_PARTCLI
ELSE
   SELECT CUR_PARTFOR
ENDIF

APPEND BLANK

REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH _PUB_ANNO


IF VAL(M.N3) <> 0
	REPLACE PAR_TMOV    WITH "D"
ENDIF

IF VAL(M.N4) <> 0
	REPLACE PAR_TMOV    WITH "A"
ENDIF

REPLACE PAR_CODCLI  WITH M.PAR_CODCLI
REPLACE PAR_RAGSOC  WITH V_RAGSOC

DATREG = SUBSTR(M.N1,1,6)+"20"+SUBSTR(M.N1,7,2)
REPLACE PAR_DTREG  WITH RIBALTA2(DATREG)

REPLACE PAR_DTFAT  WITH RIBALTA2(DTD)

REPLACE PAR_TIPFAT  WITH M.PAR_TIPFAT
REPLACE PAR_NPROT   WITH M.N9

REPLACE PAR_DESMOV	WITH ALLTRIM(M.STAMPA_MAS)

*!*	REPLACE PAR_TOTIM   WITH IMP_TRANK

REPLACE PAR_TOTIM   WITH 0
REPLACE PAR_TIMPOS  WITH 0           && TIVA ???????
REPLACE PAR_FATT    WITH IMP_TRANK

REPLACE PAR_NUMFAT  WITH M.N8	
_NDOC = M.N8

IF EMPTY(ALLTRIM(PAR_NUMFAT))
	REPLACE PAR_NUMFAT  WITH SUBSTR(M.N10,2,6) 		&& FORZA NUMERO REGISTRAZIONE
	_NDOC = SUBSTR(M.N10,2,6) 						&& FORZA NUMERO REGISTRAZIONE
ENDIF



XPRG = CONTA_TRA * 100
REPLACE PAR_NPROG   WITH XPRG + 100


IF FATTURA  <> "S"
	REPLACE PAR_TIPODO  WITH "PAG"
ELSE
	REPLACE PAR_TIPODO  WITH "FAT"
ENDIF

REPLACE PAR_NPART   WITH M.PAR_NPART
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH SUBSTR(M.N10,2,6)

M.PAR_NUMPRO=CONV_CERCA_REGISTRAZIONE_CONTABILE(M.PAR_CODCLI,_PUB_ANNO,SUBSTR(M.N10,2,6),RIBALTA2(DATREG),M.PAR_NPART)
REPLACE PAR_NUMPRO  WITH M.PAR_NUMPRO

REPLACE PAR_CIVA1   WITH ""							&& CIVA ????????????
REPLACE PAR_IMPO1   WITH IMP_TRANK
REPLACE PAR_IMPOS1  WITH 0							&& TIVA ??????????
REPLACE PAR_TOT1    WITH IMP_TRANK
REPLACE PAR_CIVA2   WITH "   "
REPLACE PAR_IMPO2   WITH 0
REPLACE PAR_IMPOS2  WITH 0
REPLACE PAR_TOT2    WITH 0
REPLACE PAR_CIVA3   WITH "   "
REPLACE PAR_IMPO3   WITH 0
REPLACE PAR_IMPOS3  WITH 0
REPLACE PAR_TOT3    WITH 0
REPLACE PAR_CIVA4   WITH "   "
REPLACE PAR_IMPO4   WITH 0
REPLACE PAR_IMPOS4  WITH 0
REPLACE PAR_TOT4    WITH 0
REPLACE PAR_CIVA5   WITH "   "
REPLACE PAR_IMPO5   WITH 0
REPLACE PAR_IMPOS5  WITH 0
REPLACE PAR_TOT5    WITH 0

V_DTSCA = M.PAR_DTSCAD

IF EMPTY(V_DTSCA)
	V_DTSCA = RIBALTA2(DATREG)					&& FORZA DATA REGISTRAZIONE
ENDIF	


IF SUBSTR(V_DTSCA,3,1) = "/"
	V_DTSCA = RIBALTA2(V_DTSCA) 				&& DT.SCAD DA FATTURA
ENDIF

   	REPLACE PAR_DTSCAD  WITH V_DTSCA           		&& DT.SCAD DA FATTURA


REPLACE PAR_VALUTA WITH YVALUTA
REPLACE PAR_CAMBIO WITH YCAMBIO

REPLACE PAR_DTVAL  WITH V_DTSCA
REPLACE PAR_DATPAG WITH V_DTSCA

*!*	REPLACE PAR_IMPVAL WITH IMP_TRANK	      	&& VALORE IN VALUTA
REPLACE PAR_IMPVAL WITH 0	         	 		&& VALORE IN VALUTA


RETURN


**--> DAVR: CONVERSIONE ANAGRAFICA ARTICOLI (INIZIO)
*************************************************************************************************
PROCEDURE CONV_U_ART_PR_SOP
*************************************************************************************************
PARAMETERS _PUB_ANNO

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

MESSAGEBOX("ARCHIVIO IN INPUT DA ELABORARE:" + CHR(13) + "AQ_ANAMAG + AQ_ARTCONAI",64,"Informazione")

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_ANAMAG"

*** VERIFICA ESISTENZA FILE
IF !FILE(V_PATH + ".DBF")
	=MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   	RETURN
ENDIF

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_ARTCONAI"

*** VERIFICA ESISTENZA FILE
IF !FILE(V_PATH + ".DBF")
	=MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   	RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_ART_PR SQL
WAIT WINDOWS "Cancellazione archivio: Anagrafica Articoli...  -  Prego Attendere" NOWAIT
Csql   = "delete from U_ART_PR WHERE 1=1"
IF !ExecCommand(cSql,"U_ART_PR")
   return(.f.)
ENDIF

SET EXCLUSIVE OFF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_ART_PR where 1=0"
IF !ExecCommand(cSql,"CU_ART_PR")
   return(.f.)
ENDIF

SELECT CU_ART_PR
=DEFPUB(SELECT())

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH

IF FILE("AQ_ANAMAG.CDX")
   ERASE AQ_ANAMAG.CDX
ENDIF

IF FILE("AQ_ARTCONAI.CDX")
   ERASE AQ_ARTCONAI.CDX
ENDIF

=OPENDB("AQ_ARTCONAI")
SELECT AQ_ARTCONAI

=OPENDB("AQ_ANAMAG")
SELECT AQ_ANAMAG

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT AQ_ANAMAG
GO TOP
DO WHILE !EOF()

	IF DELETED()
		SELECT AQ_ANAMAG
   	  	SKIP +1
      	LOOP
   	ENDIF

   	WAIT WINDOWS "Conversione archivio: Anagrafica Articoli " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   	SCATTER MEMVAR MEMO

   	*--> PREPARO ALCUNE VARIABILI PER TRATTAMENTI SUCCESSIVI...	

	_MY_CODART = ALLTRIM(CONV_CLEAR(M.ARTCOD))
	_MY_TIPART = ""
	_MY_TIPOPR = ""
   	_MY_SPESSO = 1
   	_MY_ALTEZZ = 0
    _MY_UNIMIS = ALLTRIM(CONV_CLEAR(M.ARTUM))
	_MY_UMMAGA = ALLTRIM(CONV_CLEAR(M.ARTUM))
	_MY_CODCAT = ""
	_MY_DESCAT = ""
   	_MY_CODFOR = IIF(ASC(M.FORCOD)<>0 AND !EMPTY(M.FORCOD), REPLICATE('0',9-LEN(ALLTRIM(M.FORCOD)))+ALLTRIM(M.FORCOD), '')
   	_MY_DESFOR = IIF(!EMPTY(_MY_CODFOR), SEEK_U_FOR_AN("FOR", PUB_CODSOC+ALLTRIM(_MY_CODFOR), "FOR_RAGSOC", "FOR_CODCLI", "", ""), '')

    IF 	SUBSTR(_MY_CODART,1,1) =  "P"
		_MY_TIPART = "A"
		_MY_TIPOPR = " "
    ENDIF

    IF 	SUBSTR(_MY_CODART,1,2) =  "A " .OR. SUBSTR(_MY_CODART,1,2) =  "PR" .OR. SUBSTR(_MY_CODART,1,2) =  "AM" .OR. SUBSTR(_MY_CODART,1,2) =  "A0" .OR. SUBSTR(_MY_CODART,1,2) =  "S "
		_MY_TIPART = "P"
		_MY_TIPOPR = "I"
    ENDIF

   	DO  CASE
	 	CASE SUBSTR(ALLTRIM(CONV_CLEAR(M.ARTDES1)),1,4) = "FILM"
       		_MY_CODMAT = '005'
   	   		_MY_DESMAT = 'FILM HT'
	 	CASE SUBSTR(ALLTRIM(CONV_CLEAR(M.ARTDES1)),1,13) = "ADHESIVE FILM"
       		_MY_CODMAT = '005'
       		_MY_DESMAT = 'FILM HT'
	 	OTHERWISE
   	   		_MY_CODMAT = '001'
   	   		_MY_DESMAT = 'GENERICO'
	ENDCASE
   	
   	IF _MY_TIPART = "A"
   		IF VAL(SUBSTR(_MY_CODART,2,2)) <>0
   	  		_MY_SPESSO = VAL(SUBSTR(_MY_CODART,2,2))
   	  	ENDIF	
   		IF VAL(RIGHT(_MY_CODART,4)) <>0
   	  		_MY_ALTEZZ = VAL(RIGHT(_MY_CODART,4))
   	  	ENDIF	
	    _MY_UNIMIS = 'KG'
	    _MY_UMMAGA = 'ML'
		_MY_CODMAT = "005"
	    _MY_DESMAT = "FILM HT"
	    _MY_CODCAT = "BO"
	    _MY_DESCAT = "BOBINE"
   	ENDIF

   	*--> RECUPERO IL PESO DALLA TABELLA DEI CONAI. SE SONO PRESENTI PIU' RECORD PER LO STESSO CODICE FORZA A ZERO
   	SELECT ARTCOD, PESO;
     	FROM AQ_ARTCONAI;
     	WHERE ARTCOD = M.ARTCOD;
     	INTO CURSOR TMP1

   	IF _TALLY=1
     	M.PESOCONAI=PESO
   	ELSE
     	M.PESOCONAI=0
   	ENDIF

   	SELECT TMP1
   	USE

   	SELECT CU_ART_PR
   	APPEND BLANK
	
	REPLACE ART_CODSOC		WITH	PUB_CODSOC,;
			ART_TIPO		WITH	SUBSTR(_MY_CODART,1,4),;
			ART_LUNG		WITH	SUBSTR(_MY_CODART,5,4),;	
			ART_CODPRI		WITH	_MY_CODART,;
	        ART_DESCR		WITH	ALLTRIM(CONV_CLEAR(M.ARTDES1)),;
	        ART_DESEST		WITH    ALLTRIM(CONV_CLEAR(M.ARTDES2)),;
	        ART_UNIMIS		WITH	_MY_UNIMIS,;
	        ART_UMMAGA		WITH	_MY_UMMAGA,;
	        ART_PESOUM		WITH	M.PESOCONAI,;
	        ART_LINEA		WITH	'05',;	
			ART_CODIVA		WITH	ALLTRIM(CONV_CLEAR(M.ARTIVA)),;
			ART_MAGA		WITH	"SEDE",;
			ART_PRZVEN		WITH	M.ARTPZV,;
			ART_PRZCOS		WITH	M.ARTPZA,;
			ART_NOTE		WITH	ALLTRIM(CONV_CLEAR(M.ARTNOTE)),;
			ART_LOTTO		WITH	M.ARTLOTTO,;
			ART_DATINS		WITH	RIBALTA2(DTOC(DATE())),;
			ART_DATVAR		WITH	RIBALTA2(DTOC(DATE())),;
			ART_TIPART		WITH	'A',;
			ART_DISBAS		WITH	'S',;
			ART_RIPCOM		WITH	'S',;
			ART_ORELAV		WITH	'00000:00:00',;
			ART_OREATT		WITH	'00000:00:00',;
			ART_OREIMP		WITH	'00000:00:00',;
			ART_BARCOD		WITH	IIF(ASC(M.BARCODE)<>0 AND !EMPTY(M.BARCODE), M.BARCODE, 'O'),;
			ART_COORD		WITH	'     -     -     -     -     -     -     -        ',;
			ART_PESOSP		WITH	M.PESO,;
			ART_CODFOR		WITH	_MY_CODFOR,;
			ART_DESFOR		WITH	_MY_DESFOR,;
			ART_SCORMI		WITH	M.SCORTAM,;
			ART_SC1			WITH	M.SCOVEN,;
			ART_SC2			WITH	M.SCOVEN2,;
			ART_SPESSO	    WITH    _MY_SPESSO,;
			ART_ALTEZZ		WITH	_MY_ALTEZZ,;
			ART_CODMAT		WITH	_MY_CODMAT,;
	    	ART_DESMAT		WITH	_MY_DESMAT,;
	        ART_CODCAT		WITH	_MY_CODCAT,;
	        ART_DESCAT		WITH	_MY_DESCAT,;
	        ART_TIPART		WITH	_MY_TIPART,;
	        ART_TIPOPR		WITH	_MY_TIPOPR

   	_V_CONTA = _V_CONTA + 1

   	SELECT AQ_ANAMAG
   	SKIP +1

ENDDO

** CREA GLI ARTICOLI POLIECO E ARTICOLI FITTIZZI PER LA CONSULENZA

SELECT CU_ART_PR
SCATTER MEMVAR MEMO

_MY_CODART 	= "POLIECO ASS"
M.ARTDES1 	= "RIVALSA CONTRIBUTO POLIECO ASS"
M.ARTDES2 	= ""
M.ARTUM		= "KG"
M.ARTIVA	= "20"
M.PESOCONAI	= 0
M.ARTNOTE	= ""
M.BARCODE	= ""
M.PESO		= 0
_MY_CODFOR	= ""
_MY_DESFOR	= ""
M.SCORTAM	= 0
M.SCOVEN	= 0
M.SCOVEN2   = 0
M.ARTPZA	= 0
M.ARTPZV	= 0

APPEND BLANK
REPLACE 	ART_CODSOC		WITH	PUB_CODSOC,;
			ART_TIPO		WITH	SUBSTR(_MY_CODART,1,4),;
			ART_LUNG		WITH	SUBSTR(_MY_CODART,5,4),;	
			ART_CODPRI		WITH	_MY_CODART,;
	        ART_DESCR		WITH	ALLTRIM(CONV_CLEAR(M.ARTDES1)),;
	        ART_DESEST		WITH    ALLTRIM(CONV_CLEAR(M.ARTDES2)),;
	        ART_UNIMIS		WITH	ALLTRIM(CONV_CLEAR(M.ARTUM)),;
	        ART_UMMAGA		WITH	ALLTRIM(CONV_CLEAR(M.ARTUM)),;
	        ART_PESOUM		WITH	M.PESOCONAI,;
	        ART_LINEA		WITH	'05',;	
			ART_CODIVA		WITH	ALLTRIM(CONV_CLEAR(M.ARTIVA)),;
			ART_MAGA		WITH	"SEDE",;
			ART_PRZVEN		WITH	M.ARTPZV,;
			ART_PRZCOS		WITH	M.ARTPZA,;
			ART_NOTE		WITH	ALLTRIM(CONV_CLEAR(M.ARTNOTE)),;
			ART_LOTTO		WITH	M.ARTLOTTO,;
			ART_DATINS		WITH	RIBALTA2(DTOC(DATE())),;
			ART_DATVAR		WITH	RIBALTA2(DTOC(DATE())),;
			ART_TIPART		WITH	'A',;
			ART_DISBAS		WITH	'S',;
			ART_RIPCOM		WITH	'S',;
			ART_ORELAV		WITH	'00000:00:00',;
			ART_OREATT		WITH	'00000:00:00',;
			ART_OREIMP		WITH	'00000:00:00',;
			ART_BARCOD		WITH	IIF(ASC(M.BARCODE)<>0 AND !EMPTY(M.BARCODE), M.BARCODE, 'O'),;
			ART_COORD		WITH	'     -     -     -     -     -     -     -        ',;
			ART_PESOSP		WITH	M.PESO,;
			ART_CODFOR		WITH	_MY_CODFOR,;
			ART_DESFOR		WITH	_MY_DESFOR,;
			ART_SCORMI		WITH	M.SCORTAM,;
			ART_SC1			WITH	M.SCOVEN,;
			ART_SC2			WITH	M.SCOVEN2,;
            ART_CODMAT		WITH	'001',;
            ART_DESMAT		WITH	'GENERICO',;
            ART_SPESSO		WITH 	1

_MY_CODART 	= "POLIECO MPP"
M.ARTDES1 	= "CONTRIBUTO MPP POLIECO"
M.ARTUM		= "KG"
M.ARTIVA	= "20"
M.PESOCONAI	= 0
M.ARTNOTE	= ""
M.BARCODE	= ""
M.PESO		= 0
_MY_CODFOR	= ""
_MY_DESFOR	= ""
M.SCORTAM	= 0
M.SCOVEN	= 0
M.SCOVEN2   = 0
M.ARTPZA	= 0
M.ARTPZV	= 0.015000

APPEND BLANK
REPLACE 	ART_CODSOC		WITH	PUB_CODSOC,;
			ART_TIPO		WITH	SUBSTR(_MY_CODART,1,4),;
			ART_LUNG		WITH	SUBSTR(_MY_CODART,5,4),;	
			ART_CODPRI		WITH	_MY_CODART,;
	        ART_DESCR		WITH	ALLTRIM(CONV_CLEAR(M.ARTDES1)),;
	        ART_DESEST		WITH    ALLTRIM(CONV_CLEAR(M.ARTDES2)),;
	        ART_UNIMIS		WITH	ALLTRIM(CONV_CLEAR(M.ARTUM)),;
	        ART_UMMAGA		WITH	ALLTRIM(CONV_CLEAR(M.ARTUM)),;
	        ART_PESOUM		WITH	M.PESOCONAI,;
	        ART_LINEA		WITH	'05',;	
			ART_CODIVA		WITH	ALLTRIM(CONV_CLEAR(M.ARTIVA)),;
			ART_MAGA		WITH	"SEDE",;
			ART_PRZVEN		WITH	M.ARTPZV,;
			ART_PRZCOS		WITH	M.ARTPZA,;
			ART_NOTE		WITH	ALLTRIM(CONV_CLEAR(M.ARTNOTE)),;
			ART_LOTTO		WITH	M.ARTLOTTO,;
			ART_DATINS		WITH	RIBALTA2(DTOC(DATE())),;
			ART_DATVAR		WITH	RIBALTA2(DTOC(DATE())),;
			ART_TIPART		WITH	'A',;
			ART_DISBAS		WITH	'S',;
			ART_RIPCOM		WITH	'S',;
			ART_ORELAV		WITH	'00000:00:00',;
			ART_OREATT		WITH	'00000:00:00',;
			ART_OREIMP		WITH	'00000:00:00',;
			ART_BARCOD		WITH	IIF(ASC(M.BARCODE)<>0 AND !EMPTY(M.BARCODE), M.BARCODE, 'O'),;
			ART_COORD		WITH	'     -     -     -     -     -     -     -        ',;
			ART_PESOSP		WITH	M.PESO,;
			ART_CODFOR		WITH	_MY_CODFOR,;
			ART_DESFOR		WITH	_MY_DESFOR,;
			ART_SCORMI		WITH	M.SCORTAM,;
			ART_SC1			WITH	M.SCOVEN,;
			ART_SC2			WITH	M.SCOVEN2,;
			ART_CODMAT		WITH	'001',;
			ART_DESMAT		WITH	'GENERICO',;
			ART_SPESSO		WITH 	1

_MY_CODART 	= "POLIECO P"
M.ARTDES1 	= "CONTRIBUTO POLIECO PLASTICA"
M.ARTUM		= "KG"
M.ARTIVA	= "20"
M.PESOCONAI	= 0
M.ARTNOTE	= ""
M.BARCODE	= ""
M.PESO		= 0
_MY_CODFOR	= ""
_MY_DESFOR	= ""
M.SCORTAM	= 0
M.SCOVEN	= 0
M.SCOVEN2   = 0
M.ARTPZA	= 0
M.ARTPZV	= 0.015000

APPEND BLANK
REPLACE 	ART_CODSOC		WITH	PUB_CODSOC,;
			ART_TIPO		WITH	SUBSTR(_MY_CODART,1,4),;
			ART_LUNG		WITH	SUBSTR(_MY_CODART,5,4),;	
			ART_CODPRI		WITH	_MY_CODART,;
	        ART_DESCR		WITH	ALLTRIM(CONV_CLEAR(M.ARTDES1)),;
	        ART_DESEST		WITH    ALLTRIM(CONV_CLEAR(M.ARTDES2)),;
	        ART_UNIMIS		WITH	ALLTRIM(CONV_CLEAR(M.ARTUM)),;
	        ART_UMMAGA		WITH	ALLTRIM(CONV_CLEAR(M.ARTUM)),;
	        ART_PESOUM		WITH	M.PESOCONAI,;
	        ART_LINEA		WITH	'05',;	
			ART_CODIVA		WITH	ALLTRIM(CONV_CLEAR(M.ARTIVA)),;
			ART_MAGA		WITH	"SEDE",;
			ART_PRZVEN		WITH	M.ARTPZV,;
			ART_PRZCOS		WITH	M.ARTPZA,;
			ART_NOTE		WITH	ALLTRIM(CONV_CLEAR(M.ARTNOTE)),;
			ART_LOTTO		WITH	M.ARTLOTTO,;
			ART_DATINS		WITH	RIBALTA2(DTOC(DATE())),;
			ART_DATVAR		WITH	RIBALTA2(DTOC(DATE())),;
			ART_TIPART		WITH	'A',;
			ART_DISBAS		WITH	'S',;
			ART_RIPCOM		WITH	'S',;
			ART_ORELAV		WITH	'00000:00:00',;
			ART_OREATT		WITH	'00000:00:00',;
			ART_OREIMP		WITH	'00000:00:00',;
			ART_BARCOD		WITH	IIF(ASC(M.BARCODE)<>0 AND !EMPTY(M.BARCODE), M.BARCODE, 'O'),;
			ART_COORD		WITH	'     -     -     -     -     -     -     -        ',;
			ART_PESOSP		WITH	M.PESO,;
			ART_CODFOR		WITH	_MY_CODFOR,;
			ART_DESFOR		WITH	_MY_DESFOR,;
			ART_SCORMI		WITH	M.SCORTAM,;
			ART_SC1			WITH	M.SCOVEN,;
			ART_SC2			WITH	M.SCOVEN2,;
			ART_CODMAT		WITH	'001',;
			ART_DESMAT		WITH	'GENERICO',;
			ART_SPESSO		WITH 	1

_MY_CODART 	= "."
M.ARTDES1 	= ""
M.ARTUM		= "NR"
M.ARTIVA	= "20"
M.PESOCONAI	= 0
M.ARTNOTE	= ""
M.BARCODE	= ""
M.PESO		= 0
_MY_CODFOR	= ""
_MY_DESFOR	= ""
M.SCORTAM	= 0
M.SCOVEN	= 0
M.SCOVEN2   = 0
M.ARTPZA	= 0
M.ARTPZV	= 0

APPEND BLANK
REPLACE 	ART_CODSOC		WITH	PUB_CODSOC,;
			ART_TIPO		WITH	SUBSTR(_MY_CODART,1,4),;
			ART_LUNG		WITH	SUBSTR(_MY_CODART,5,4),;	
			ART_CODPRI		WITH	_MY_CODART,;
	        ART_DESCR		WITH	ALLTRIM(CONV_CLEAR(M.ARTDES1)),;
	        ART_DESEST		WITH    ALLTRIM(CONV_CLEAR(M.ARTDES2)),;
	        ART_UNIMIS		WITH	ALLTRIM(CONV_CLEAR(M.ARTUM)),;
	        ART_UMMAGA		WITH	ALLTRIM(CONV_CLEAR(M.ARTUM)),;
	        ART_PESOUM		WITH	M.PESOCONAI,;
	        ART_LINEA		WITH	'05',;	
			ART_CODIVA		WITH	ALLTRIM(CONV_CLEAR(M.ARTIVA)),;
			ART_MAGA		WITH	"SEDE",;
			ART_PRZVEN		WITH	M.ARTPZV,;
			ART_PRZCOS		WITH	M.ARTPZA,;
			ART_NOTE		WITH	ALLTRIM(CONV_CLEAR(M.ARTNOTE)),;
			ART_LOTTO		WITH	M.ARTLOTTO,;
			ART_DATINS		WITH	RIBALTA2(DTOC(DATE())),;
			ART_DATVAR		WITH	RIBALTA2(DTOC(DATE())),;
			ART_TIPART		WITH	'A',;
			ART_DISBAS		WITH	'S',;
			ART_RIPCOM		WITH	'S',;
			ART_ORELAV		WITH	'00000:00:00',;
			ART_OREATT		WITH	'00000:00:00',;
			ART_OREIMP		WITH	'00000:00:00',;
			ART_BARCOD		WITH	IIF(ASC(M.BARCODE)<>0 AND !EMPTY(M.BARCODE), M.BARCODE, 'O'),;
			ART_COORD		WITH	'     -     -     -     -     -     -     -        ',;
			ART_PESOSP		WITH	M.PESO,;
			ART_CODFOR		WITH	_MY_CODFOR,;
			ART_DESFOR		WITH	_MY_DESFOR,;
			ART_SCORMI		WITH	M.SCORTAM,;
			ART_SC1			WITH	M.SCOVEN,;
			ART_SC2			WITH	M.SCOVEN2,;
			ART_CODMAT		WITH	'001',;
			ART_DESMAT		WITH	'GENERICO',;
			ART_SPESSO		WITH 	1

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
  	WAIT WINDOWS "Scrittura archivio Anagrafica Articoli sul DataBase in corso... -- Prego Attendere --" nowait
   	IF !ExecRW('','U_ART_PR','I','','CU_ART_PR')
      	return(.f.)
   	ENDIF
   	_V_OKELAB = .T.
ENDIF

SET DEFA TO &PUB_DIR

RETURN
**--> DAVR: CONVERSIONE ANAGRAFICA ARTICOLI (FINE)

**--> DAVR: IMPORT ANAGRAFICA ARTICOLI DA FOGLIO EXCEL (INIZIO)
*************************************************************************************************
PROCEDURE CONV_ART_XLS
*************************************************************************************************
PARAMETERS _PUB_ANNO

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH

V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH

_MY_XLS_FILES = ADIR(VETTO, "*.XLS")

IF _MY_XLS_FILES=0
   =MESSAGEBOX("Nessun file XLS trovato nella cartella " + V_PATH, 62, "ATTENZIONE")
   SET DEFA TO &PUB_DIR
   RETURN
ENDIF

_MY_NOMEXLS = GETFILE("Foglio di lavoro Microsoft Excel:XLS","File:","Apri",0,"Selezionare il file Excel da importare")

IF _MY_NOMEXLS=""
   =MESSAGEBOX("Nessun file XLS selezionato. Non posso proseguire.", 62, "ATTENZIONE")
   SET DEFA TO &PUB_DIR
   RETURN
ENDIF

CREATE CURSOR C_APPOGGIO (;
A C(20),;
B C(40),;
C C(20),;
D C(20),;
E C(20),;
F C(20),;
G C(20),;
H C(20),;
I C(20),;
J C(20),;
K C(20),;
L C(20),;
M C(20),;
N C(20),;
O C(20),;
P C(20),;
Q C(20))

APPEND FROM &_MY_NOMEXLS TYPE XLS FOR !EMPTY(A) AND ALLTRIM(UPPER(A))<>"NS. COD"

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT C_APPOGGIO
GO TOP

DO WHILE !EOF()

  SCATTER MEMVAR

  _MY_SPESSO = VAL(ALLTRIM(CONV_CLEAR(M.O)))
  _MY_ALTEZZ = VAL(ALLTRIM(CONV_CLEAR(M.L)))
  _MY_PESO   = VAL(ALLTRIM(CONV_CLEAR(M.N)))

  WAIT WINDOWS "Import in corso... record " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
               " in corso...  -  Prego Attendere" NOWAIT

  x_cond = "ART_CODSOC = '" + PUB_CODSOC +"' AND UPPER(ART_CODPRI) = '" + UPPER(ALLTRIM(M.A)) + "'"
  cSql = "select * from U_ART_PR where " + x_cond
  IF !ExecRW(cSql,"U_ART_PR","R")
    return(.f.)
  ENDIF

  SELECT U_ART_PR
  GO TOP

  IF EOF()
   	APPEND BLANK

	REPLACE ART_CODSOC	WITH	PUB_CODSOC,;
	 	    ART_TIPO	WITH	UPPER(SUBSTR(CONV_CLEAR(ALLTRIM(M.A)),1,4)),;
			ART_LUNG	WITH	CONV_CLEAR(ALLTRIM(M.L)),;	
			ART_CODPRI	WITH	UPPER(ALLTRIM(CONV_CLEAR(ALLTRIM(M.A)))),;
	        ART_DESCR	WITH	UPPER(ALLTRIM(CONV_CLEAR(ALLTRIM(M.B)))),;
	        ART_UNIMIS	WITH	'KG',;
	        ART_UMMAGA	WITH	'ML',;
	        ART_PESOUM	WITH	_MY_PESO,;
	        ART_PESOSP	WITH	_MY_PESO,;
	        ART_LINEA	WITH	'05',;	
			ART_CODIVA	WITH	'20',;
			ART_MAGA	WITH	"SEDE",;
			ART_DATINS	WITH	RIBALTA2(DTOC(DATE())),;
			ART_DATVAR	WITH	RIBALTA2(DTOC(DATE())),;
			ART_TIPART	WITH	'A',;
			ART_DISBAS	WITH	'S',;
			ART_RIPCOM	WITH	'S',;
			ART_ORELAV	WITH	'00000:00:00',;
			ART_OREATT	WITH	'00000:00:00',;
			ART_OREIMP	WITH	'00000:00:00',;
			ART_BARCOD	WITH	'O',;
			ART_COORD	WITH	'     -     -     -     -     -     -     -        ',;
			ART_SPESSO	WITH    _MY_SPESSO,;
			ART_ALTEZZ	WITH	_MY_ALTEZZ,;
			ART_CODMAT	WITH	"005",;
	    	ART_DESMAT	WITH	"FILM HT",;
	    	ART_CODCAT	WITH	"BO",;
	    	ART_DESCAT	WITH	"BOBINE"
  ELSE

	REPLACE ART_TIPO	WITH	UPPER(SUBSTR(CONV_CLEAR(ALLTRIM(M.A)),1,4)),;
			ART_LUNG	WITH	CONV_CLEAR(ALLTRIM(M.L)),;	
	        ART_DESCR	WITH	UPPER(ALLTRIM(CONV_CLEAR(ALLTRIM(M.B)))),;
	        ART_UNIMIS	WITH	'KG',;
	        ART_UMMAGA	WITH	'ML',;
	        ART_PESOUM	WITH	_MY_PESO,;
	        ART_PESOSP	WITH	_MY_PESO,;
	        ART_LINEA	WITH	'05',;	
			ART_CODIVA	WITH	'20',;
			ART_MAGA	WITH	"SEDE",;
			ART_DATVAR	WITH	RIBALTA2(DTOC(DATE())),;
			ART_TIPART	WITH	'A',;
			ART_DISBAS	WITH	'S',;
			ART_RIPCOM	WITH	'S',;
			ART_ORELAV	WITH	'00000:00:00',;
			ART_OREATT	WITH	'00000:00:00',;
			ART_OREIMP	WITH	'00000:00:00',;
			ART_BARCOD	WITH	'O',;
			ART_COORD	WITH	'     -     -     -     -     -     -     -        ',;
			ART_SPESSO	WITH    _MY_SPESSO,;
			ART_ALTEZZ	WITH	_MY_ALTEZZ,;
			ART_CODMAT	WITH	"005",;
	    	ART_DESMAT	WITH	"FILM HT",;
	    	ART_CODCAT	WITH	"BO",;
	    	ART_DESCAT	WITH	"BOBINE"

  ENDIF

  IF !ExecRW(cSql,"U_ART_PR","W")
    return(.f.)
  ENDIF

  _V_CONTA = _V_CONTA + 1

  SELECT C_APPOGGIO
  SKIP +1

ENDDO

IF _V_CONTA > 0
  _V_OKELAB = .T.
ENDIF

SET DEFA TO &PUB_DIR

RETURN
**--> DAVR: IMPORT ANAGRAFICA ARTICOLI DA FOGLIO EXCEL (FINE)



**--> DAVR: CONVERSIONE ANAGRAFICA ARTICOLI (FINE)

**--> DAVR: CONVERSIONE LISTINO CLIENTE/PRODOTTO (INIZIO)
*************************************************************************************************
PROCEDURE CONV_U_LIS_TT_SOP
*************************************************************************************************
*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

*** VERIFICA ESISTENZA FILE TESTATE
V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_TCLLIST"
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** VERIFICA ESISTENZA FILE DETTAGLI
V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_DCLLIST"
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_LIS_TT SQL
WAIT WINDOWS "Cancellazione archivio Listini Clienti (tabella U_LIS_TT)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_LIS_TT where 1=1"
IF !ExecCommand(cSql,"U_LIS_TT")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_LIS_TT where 1=0"
IF !ExecCommand(cSql,"CU_LIS_TT")
   return(.f.)
ENDIF

*** CURSORE UTILIZZATO PER GESTIRE LA STORIA PREZZO CHE SULLA TABELLA DI PARTENZA E' SU UNICA RIGA
CREATE CURSOR c_valid(datadal c(10), prezzo n(17,6))

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH

IF FILE("AQ_TCLLIST.CDX")
   ERASE AQ_TCLLIST.CDX
ENDIF

IF FILE("AQ_DCLLIST.CDX")
   ERASE AQ_DCLLIST.CDX
ENDIF

=OPENDB("AQ_DCLLIST")
SELECT AQ_DCLLIST

=OPENDB("AQ_TCLLIST")
SELECT AQ_TCLLIST

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT AQ_TCLLIST
GO TOP




DO WHILE !EOF()

*!*	   WAIT WINDOWS "Conversione archivio Listini Clienti record " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
*!*	                " in corso...  -  Prego Attendere" NOWAIT

   SCATTER MEMVAR MEMO

   **--> M.NUMLIST E' LA CHIAVE CHE UNISCE LE TESTATE AI DETTAGLI MA ANCHE IL CODICE CLIENTE
   **--> LO UTILIZZERO' PER RECUPERARE ALCUNI DATI DALL'ANAGRAFICA

   _MY_CODCLI = REPLICATE('0',9-LEN(ALLTRIM(M.NUMLIST)))+ALLTRIM(M.NUMLIST)
*!*	   _MY_RAGSOC = SEEK_U_CLI_AN("CLI", PUB_CODSOC+ALLTRIM(_MY_CODCLI), "CLI_RAGSOC", "CLI_CODCLI", "", "")



   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(_MY_CODCLI) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"xx_cli_an")
      return(.f.)
   ENDIF
   SELECT xx_cli_an
   GO TOP
   IF EOF()

     WAIT WINDOW "Cliente NON TROVATOOOOOOOOOOOOOOO :"+ _MY_CODCLI nowait

     SELECT AQ_TCLLIST
     SKIP +1
     LOOP
   ELSE
   	_MY_RAGSOC = ALLTRIM(CLI_RAGSOC)
   ENDIF



   WAIT WINDOW "Cliente in elaborazione :"+ _MY_CODCLI nowait


*!*	   IF EMPTY(_MY_RAGSOC)
*!*	
*!*	     **WAIT WINDOW "Codice cliente: " + _MY_CODCLI + " non trovato in anagrafica. Listino NON caricato..."
*!*	
*!*	     SELECT AQ_TCLLIST
*!*	     SKIP +1
*!*	     LOOP
*!*	   ENDIF

   **--> AGGANCIO I DETTAGLI DEL LISTINO(CLIENTE) CHE STO TRATTANDO
   SELECT *;
     FROM AQ_DCLLIST;
     WHERE NUMLIST == M.NUMLIST;
     INTO CURSOR C_DCLLIST

   IF _TALLY=0

     **WAIT WINDOWS "Codice Listino: **" + M.NUMLIST + "** senza dettagli. Listino NON caricato"

     SELECT AQ_TCLLIST
     SKIP +1
     LOOP
   ENDIF

   SELECT C_DCLLIST
   GO TOP
   DO WHILE !EOF()

     **--> SE CODICE ARTICOLO E' VUOTO --> NON FUNZIONA EMPTY
     IF !(ASC(ARTCOD)<>0 AND !EMPTY(ARTCOD))
       SELECT C_DCLLIST
       SKIP +1
       LOOP
     ENDIF

     SCATTER MEMVAR

     **--> UTILIZZO M.ARTCOD APPENA VALORIZZATO PER RECUPERARE LA DESCRIZIONE DELL'ARTICOLO DA U_ART_PR

*!*	     _MY_DESART = SEEK_U_ART_PRI("ART", M.ARTCOD, "ART_DESCR", "ART_CODPRI", "", "")


		x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "art_codpri = '" + ALLTRIM(M.ARTCOD) + "'"
		x_cond = x_soci + " and " + x_codi
		Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
		IF !ExecCommand(cSql,"cur_articoli")
		   return(.f.)
		ENDIF
		SELECT cur_articoli
		GO TOP
		IF EOF()

		       WAIT WINDOW "Codice Articolo: " + M.ARTCOD + " non trovato in anagrafica. Riga Listino NON caricata..." NOWAIT
		
		       SELECT AQ_DCLLIST
		       SKIP +1
		       LOOP

        ELSE
               _MY_DESART = ALLTRIM(ART_DESCR)
		ENDIF





*!*	     IF EMPTY(_MY_DESART)
*!*	
*!*	       **WAIT WINDOW "Codice Articolo: " + M.ARTCOD + " non trovato in anagrafica. Riga Listino NON caricata..."
*!*	
*!*	       SELECT AQ_DCLLIST
*!*	       SKIP +1
*!*	       LOOP
*!*	     ENDIF
*!*	
     **--> GESTIONE STORIA PREZZI CHE SULLA TABELLA DI PARTENZA E' SU UNICO RECORD

     SELECT C_VALID
     ZAP

     APPEND BLANK
     REPLACE DATADAL WITH RIBALTA2(DTOC(M.DECORR)), PREZZO WITH M.PRZVEND
     APPEND BLANK
     REPLACE DATADAL WITH RIBALTA2(DTOC(M.DECOR2)), PREZZO WITH M.PRZVEN2
     APPEND BLANK
     REPLACE DATADAL WITH RIBALTA2(DTOC(M.DECOR3)), PREZZO WITH M.PRZVEN3
     APPEND BLANK
     REPLACE DATADAL WITH RIBALTA2(DTOC(M.DECOR4)), PREZZO WITH M.PRZVEN4
     APPEND BLANK
     REPLACE DATADAL WITH RIBALTA2(DTOC(M.DECOR5)), PREZZO WITH M.PRZVEN5
     APPEND BLANK
     REPLACE DATADAL WITH RIBALTA2(DTOC(M.DECOR6)), PREZZO WITH M.PRZVEN6

     SELECT DATADAL, MAX(PREZZO) AS PREZZO;
       FROM C_VALID;
       GROUP BY DATADAL;
       WHERE PREZZO<>0;
       INTO CURSOR C_VALID_2

     **--> GESTIONE STORIA PREZZI CHE SULLA TABELLA DI PARTENZA E' SU UNICO RECORD

     SELECT C_VALID_2
     GO TOP
     DO WHILE !EOF()

       _MY_STARTDATE = DATADAL
       _MY_PRICE = PREZZO

       SELECT CU_LIS_TT
       APPEND BLANK

       REPLACE LIS_CODSOC		WITH	PUB_CODSOC,;
	           LIS_CODCLI		WITH	_MY_CODCLI,;
	           LIS_RAGSOC		WITH	_MY_RAGSOC,;
			   LIS_CODART		WITH	M.ARTCOD,;
  			   LIS_DESART		WITH	_MY_DESART,;
			   LIS_DATLIS		WITH	_MY_STARTDATE;
		 	   LIS_ALLIST		WITH	RIBALTA2(PUB_DTAL),;
			   LIS_CLIART		WITH	"",;
			   LIS_ARTGRU		WITH	"",;
			   LIS_DEARCL		WITH	"",;
			   LIS_PREZZO		WITH	_MY_PRICE,;
			   LIS_DEARC1		WITH	"",;
			   LIS_TRASME		WITH	"",;
			   LIS_SCONTO		WITH	0,;
			   LIS_DTCONT		WITH	"",;
			   LIS_KILIMP		WITH	0,;
			   LIS_PROVVI		WITH	0,;
			   LIS_SC1			WITH	M.LISSCO,;
			   LIS_SC2			WITH	0,;
			   LIS_SC3			WITH	0,;
			   SELEZIONE		WITH	"",;
			   LIS_CODVAL		WITH	IIF(ASC(M.CODDIV)<>0 AND !EMPTY(M.CODDIV), M.CODDIV, 'EUR'),;
			   LIS_PUBBLI     	WITH	"",;
			   LIS_FLGTRA		WITH	.F.,;
			   LIS_PRZSCO		WITH	0,;
			   LIS_QTA			WITH	0

       SELECT C_VALID_2
       SKIP +1
     ENDDO

     SELECT C_DCLLIST
     SKIP +1
   ENDDO

   _V_CONTA  = _V_CONTA + 1

   SELECT AQ_TCLLIST
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio Listini Clienti (tabella U_LIS_TT) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_lis_tt','I','','CU_LIS_TT')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
ENDIF

SET DEFA TO &PUB_DIR

RETURN
**--> DAVR: CONVERSIONE LISTINO CLIENTE/PRODOTTO (FINE)

**--> DAVR: CONVERSIONE LISTINO FORNITORE/PRODOTTO (INIZIO)
*************************************************************************************************
PROCEDURE CONV_U_LIF_TT_SOP
*************************************************************************************************
*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

MESSAGEBOX("ARCHIVIO IN INPUT DA ELABORARE :" + CHR(13) + ;
              "AQ_TFRLIST + AQ_DFRLLIST",64,"Informazione")

*** VERIFICA ESISTENZA FILE TESTATE
V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_TFRLIST"
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** VERIFICA ESISTENZA FILE DETTAGLI
V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_DFRLIST"
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_LIF_TT SQL
WAIT WINDOWS "Cancellazione archivio Listini Fornitori (tabella U_LIF_TT)...  -  Prego Attendere" NOWAIT
cSql = "delete from U_LIF_TT where 1=1"
IF !ExecCommand(cSql,"U_LIF_TT")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_LIF_TT where 1=0"
IF !ExecCommand(cSql,"CU_LIF_TT")
   return(.f.)
ENDIF

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH

IF FILE("AQ_TFRLIST.CDX")
   ERASE AQ_TFRLIST.CDX
ENDIF

IF FILE("AQ_DFRLIST.CDX")
   ERASE AQ_DFRLIST.CDX
ENDIF

=OPENDB("AQ_DFRLIST")
SELECT AQ_DFRLIST

=OPENDB("AQ_TFRLIST")
SELECT AQ_TFRLIST

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT AQ_TFRLIST
GO TOP

DO WHILE !EOF()

*!*	   WAIT WINDOWS "Conversione archivio Listini Fornitori record " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
*!*	                " in corso...  -  Prego Attendere" NOWAIT

   SCATTER MEMVAR MEMO

   **--> M.NUMLIST E' LA CHIAVE CHE UNISCE LE TESTATE AI DETTAGLI MA ANCHE IL CODICE CLIENTE
   **--> LO UTILIZZERO' PER RECUPERARE ALCUNI DATI DALL'ANAGRAFICA

   _MY_CODFOR = REPLICATE('0',9-LEN(ALLTRIM(M.NUMLIST)))+ALLTRIM(M.NUMLIST)
*!*	   _MY_RAGSOC = SEEK_U_FOR_AN("FOR", PUB_CODSOC+ALLTRIM(_MY_CODFOR), "FOR_RAGSOC", "FOR_CODCLI", "", "")



   x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "for_codcli = '" + ALLTRIM(_MY_CODFOR) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
   IF !ExecCommand(cSql,"xx_for_an")
      return(.f.)
   ENDIF
   SELECT xx_for_an
   GO TOP
   IF EOF()

     WAIT WINDOW "Fornitore NON TROVATOOOOOOOOOOOOOOO :"+ _MY_CODFOR nowait

     SELECT AQ_TFRLIST
     SKIP +1
     LOOP
   ELSE
   	_MY_RAGSOC = ALLTRIM(FOR_RAGSOC)
   ENDIF



   WAIT WINDOW "Fornitore in elaborazione :"+ _MY_CODFOR nowait


*!*	   IF EMPTY(_MY_RAGSOC)
*!*	
*!*	     **WAIT WINDOW "Codice fornitore: " + _MY_CODFOR + " non trovato in anagrafica. Listino NON caricato..."
*!*	
*!*	     SELECT AQ_TFRLIST
*!*	     SKIP +1
*!*	     LOOP
*!*	   ENDIF

   **--> AGGANCIO I DETTAGLI DEL LISTINO(FORNITORI) CHE STO TRATTANDO
   SELECT *;
     FROM AQ_DFRLIST;
     WHERE NUMLIST == M.NUMLIST;
     INTO CURSOR C_DFRLIST

   IF _TALLY=0

     **WAIT WINDOWS "Codice Listino: **" + M.NUMLIST + "** senza dettagli. Listino NON caricato"

     SELECT AQ_TFRLIST
     SKIP +1
     LOOP
   ENDIF

   SELECT C_DFRLIST
   GO TOP
   DO WHILE !EOF()

     **--> SE CODICE ARTICOLO E' VUOTO --> NON FUNZIONA EMPTY
     IF !(ASC(ARTCOD)<>0 AND !EMPTY(ARTCOD))
       SELECT C_DFRLIST
       SKIP +1
       LOOP
     ENDIF

     SCATTER MEMVAR

     **--> UTILIZZO M.ARTCOD APPENA VALORIZZATO PER RECUPERARE LA DESCRIZIONE DELL'ARTICOLO DA U_ART_PR

*!*	     _MY_DESART = SEEK_U_ART_PRI("ART", M.ARTCOD, "ART_DESCR", "ART_CODPRI", "", "")


		x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "art_codpri = '" + ALLTRIM(M.ARTCOD) + "'"
		x_cond = x_soci + " and " + x_codi
		Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
		IF !ExecCommand(cSql,"cur_articoli")
		   return(.f.)
		ENDIF
		SELECT cur_articoli
		GO TOP
		IF EOF()

		       WAIT WINDOW "Codice Articolo: " + M.ARTCOD + " non trovato in anagrafica. Riga Listino NON caricata..." NOWAIT
		
		       SELECT AQ_DFRLIST
		       SKIP +1
		       LOOP

        ELSE
               _MY_DESART = ALLTRIM(ART_DESCR)
		ENDIF




*!*	     IF EMPTY(_MY_DESART)
*!*	
*!*	       **WAIT WINDOW "Codice Articolo: " + M.ARTCOD + " non trovato in anagrafica. Riga Listino NON caricata..."
*!*	
*!*	       SELECT AQ_DFRLIST
*!*	       SKIP +1
*!*	       LOOP
*!*	     ENDIF

     **--> GESTIONE DEI PREZZI STORICI SULLO STESSO RECORD
     **--> CONSIDERO SOLO IL PRIMO ED IL SECONDO PREZZO PERCHE' GLI ALTRI NON SONO MAI VALORIZZATI
     **--> NORMALMENTE IL PRIMO HA DATA DECORRENZA MAGGIORE DEL SECONDO MA CI SONO UN PAIO DI CASI
     **--> DOVE NON E' COSI...

     **--> RAGIONAMENTO PER IL PRIMO PREZZO... LA DATA DECORRENZA E' SEMPRE INDICATA
     _MY_STARTDATE = RIBALTA2(DTOC(M.DECORR))
     IF M.DECORR >= M.DECORR2
       _MY_ENDDATE = RIBALTA2(PUB_DTAL)
     ELSE
       _MY_ENDDATE = RIBALTA2(DTOC(M.DECORR2 - 1))
     ENDIF

     SELECT CU_LIF_TT
     APPEND BLANK

     REPLACE LIS_CODSOC		WITH	PUB_CODSOC,;
	         LIS_CODCLI		WITH	_MY_CODFOR,;
	         LIS_RAGSOC		WITH	_MY_RAGSOC,;
			 LIS_CODART		WITH	M.ARTCOD,;
			 LIS_DESART		WITH	_MY_DESART,;
			 LIS_DATLIS		WITH	_MY_STARTDATE,;
		 	 LIS_ALLIST		WITH	_MY_ENDDATE,;
			 LIS_CLIART		WITH	"",;
			 LIS_ARTGRU		WITH	"",;
			 LIS_DEARCL		WITH	"",;
			 LIS_PREZZO		WITH	M.PRZVEND,;
			 LIS_DEARC1		WITH	"",;
			 LIS_TRASME		WITH	"",;
			 LIS_SCONTO		WITH	0,;
			 LIS_DTCONT		WITH	"",;
			 LIS_KILIMP		WITH	0,;
			 LIS_PROVVI		WITH	0,;
			 LIS_SC1		WITH	M.LISSCO,;
			 LIS_SC2		WITH	0,;
			 LIS_SC3		WITH	0,;
			 SELEZIONE		WITH	"",;
			 LIS_VALUTA		WITH	IIF(ASC(M.CODDIV)<>0 AND !EMPTY(M.CODDIV), M.CODDIV, 'EUR'),;
			 LIF_VALUTA		WITH	IIF(ASC(M.CODDIV)<>0 AND !EMPTY(M.CODDIV), M.CODDIV, 'EUR')


     **--> RAGIONAMENTO PER IL SECONDO PREZZO... POTREBBE ESSERE 0 E SENZA DATA DECORRENZA
     IF RIBALTA2(DTOC(M.DECORR2)) <> "    /  /  "

       _MY_STARTDATE = RIBALTA2(DTOC(M.DECORR2))
       IF M.DECORR2 >= M.DECORR
         _MY_ENDDATE = RIBALTA2(PUB_DTAL)
       ELSE
         _MY_ENDDATE = RIBALTA2(DTOC(M.DECORR - 1))
       ENDIF

       SELECT CU_LIF_TT
       APPEND BLANK

       REPLACE LIS_CODSOC		WITH	PUB_CODSOC,;
	           LIS_CODCLI		WITH	_MY_CODFOR,;
	           LIS_RAGSOC		WITH	_MY_RAGSOC,;
			   LIS_CODART		WITH	M.ARTCOD,;
    		   LIS_DESART		WITH	_MY_DESART,;
			   LIS_DATLIS		WITH	_MY_STARTDATE,;
		 	   LIS_ALLIST		WITH	_MY_ENDDATE,;
			   LIS_CLIART		WITH	"",;
			   LIS_ARTGRU		WITH	"",;
			   LIS_DEARCL		WITH	"",;
			   LIS_PREZZO		WITH	M.PRZVEN2,;
			   LIS_DEARC1		WITH	"",;
			   LIS_TRASME		WITH	"",;
			   LIS_SCONTO		WITH	0,;
			   LIS_DTCONT		WITH	"",;
			   LIS_KILIMP		WITH	0,;
			   LIS_PROVVI		WITH	0,;
			   LIS_SC1			WITH	M.LISSCO2,;
			   LIS_SC2			WITH	0,;
			   LIS_SC3			WITH	0,;
			   SELEZIONE		WITH	"",;
			   LIS_VALUTA		WITH	IIF(ASC(M.CODDIV)<>0 AND !EMPTY(M.CODDIV), M.CODDIV, 'EUR'),;
			   LIF_VALUTA		WITH	IIF(ASC(M.CODDIV)<>0 AND !EMPTY(M.CODDIV), M.CODDIV, 'EUR')
	
     ENDIF		
			
     SELECT C_DFRLIST
     SKIP +1
   ENDDO

   _V_CONTA  = _V_CONTA + 1

   SELECT AQ_TFRLIST
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio Listini Fornitori (tabella U_LIF_TT) sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_lif_tt','I','','CU_LIF_TT')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
ENDIF

SET DEFA TO &PUB_DIR

RETURN
**--> DAVR: CONVERSIONE LISTINO FORNITORE/PRODOTTO (FINE)


**--> DAVR: CONVERSIONE ANAGRAFICA BANCHE (INIZIO)
*************************************************************************************************
PROCEDURE CONV_U_BAN_AN_SOP
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_BANCHE"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_BAN_AN SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica banche...  -  Prego Attendere" NOWAIT
cSql = "delete from U_BAN_AN where 1=1"
IF !ExecCommand(cSql,"U_BAN_AN")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from U_BAN_AN where 1=0"
IF !ExecCommand(cSql,"CU_BAN_AN")
   return(.f.)
ENDIF

V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH

IF FILE("AQ_BANCHE.CDX")
   ERASE AQ_BANCHE.CDX
ENDIF

=OPENDB("AQ_BANCHE")

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT AQ_BANCHE
GO TOP

DO WHILE !EOF()

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione archivio Anagrafica Banche record " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_BAN_AN
   APPEND BLANK
   REPLACE BAN_CODSOC	WITH	PUB_CODSOC,;
	       BAN_CODBAN	WITH	CONV_CLEAR(M.ABICOD),;
	       BAN_DESBAN   WITH    ALLTRIM(CONV_CLEAR(M.DESBANCA)) +" "+ ALLTRIM(CONV_CLEAR(M.DESBANCA2)),;
	       BAN_INDIR    WITH    CONV_CLEAR(M.BANCAIND),;
  	       BAN_CAP      WITH    CONV_CLEAR(M.BANCACAP),;
	       BAN_LOCA     WITH    CONV_CLEAR(M.BANCACIT),;
	       BAN_CODABI   WITH    SUBSTR(CONV_CLEAR(M.ABICOD),1,5),;
	       BAN_CODCAB   WITH    SUBSTR(CONV_CLEAR(M.ABICOD),6,5),;
   	       BAN_TOP		WITH	"",;
	       BAN_CIN		WITH	CONV_CLEAR(M.CODCIN),;
	       BAN_PROVIN	WITH	CONV_CLEAR(M.BANCAPROV),;
	       BAN_TRASME	WITH	"",;
	       BAN_DATINS	WITH	RIBALTA2(DTOC(DATE())),;
	       BAN_RIFMIT	WITH	"",;
	       BAN_NOTE1	WITH	"",;
	       BAN_NOTE2	WITH	"",;
	       BAN_CONCON	WITH	"",;
	       BAN_CONRIC	WITH	"",;
	       BAN_PRESE	WITH	"",;
	       SELEZIONE	WITH	""


   _V_CONTA  = _V_CONTA + 1

   SELECT AQ_BANCHE
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio Anagrafica Banche sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_ban_an','I','','CU_BAN_AN')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
ENDIF

SET DEFA TO &PUB_DIR

RETURN
**--> DAVR: CONVERSIONE ANAGRAFICA BANCHE (FINE)



*************************************************************************************************
PROCEDURE CONV_PART_FOR_SOP	&& CONVERTE LA TABELLA PARTITARI FORNITORI DA .DBF A SQL
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE PARTITARI FORNITORI		   								*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.			  											 	*
*	Novembre 2007 - Modificato 																	*
*************************************************************************************************
PARAMETERS _PUB_ANNO,_NOME_FILE



RELEASE CLI_FOR
PUBLIC CLI_FOR
CLI_FOR = 'F'        && GESTIONE CLINTE SERGIO




*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

MESSAGEBOX("ARCHIVIO IN INPUT DA ELABORARE :" + CHR(13) + ;
              _NOME_FILE,64,"Informazione")

V_PATH = ALLTRIM(_V_PERCORSO) + _NOME_FILE

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF



IF USED("AQ_PDTESTA")
   SELECT AQ_PDTESTA
   USE
ENDIF




IF FILE(_NOME_FILE+".CDX")
   ERASE _NOME_FILE+".CDX"
ENDIF

IF !USED(V_PATH)
   USE &V_PATH EXCLU
ENDIF
=MODTBL(ALIAS(SELECT()),"PAR_NPART","N(10,0)",.F.,.F.)
=MODTBL(ALIAS(SELECT()),"PAR_NUMPRO","C(13)",.F.,.F.)
=MODTBL(ALIAS(SELECT()),"PAR_CODPAG","C(8)",.F.,.F.)
=MODTBL(ALIAS(SELECT()),"PAR_DTSCAD","C(10)",.F.,.F.)
=MODTBL(ALIAS(SELECT()),"PAR_CODCLI","C(13)",.F.,.F.)
=MODTBL(ALIAS(SELECT()),"PAR_TIPFAT","C(03)",.F.,.F.)


INDEX ON SUBSTR(N1,7,2) + ALLTRIM(N9)	TAG __NPROT__ 	ADDITIVE
INDEX ON SUBSTR(N1,7,2) + ALLTRIM(N10)  TAG DTNU_REG 	ADDITIVE



*** CANCELLAZIONE DEI RECORD DELLA TABELLA  PART_FOR  SQL
WAIT WINDOWS "Cancellazione PARTITARIO FORNITORI ...  -  Prego Attendere" NOWAIT
x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
x_anno = "par_anno = '" + _PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "delete from PART_FOR where " + x_cond
IF !ExecCommand(cSql,"PART_FOR")
   return(.f.)
ENDIF

SET EXCLUSIVE OFF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PART_FOR where 1=0"
IF !ExecCommand(cSql,"CU_PART_FOR")
   return(.f.)
ENDIF

SELECT CU_PART_FOR
=DEFPUB(SELECT())

*** ACQUISIZIONE DEI DATI DALLA TABELLA DBF DI PARTENZA ############################## input
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH



IF FILE("SALVA_PART.DBF")
   ERASE "SALVA_PART.DBF"
ENDIF

IF FILE("AQ_PDTESTA.CDX")
   ERASE AQ_PDTESTA.CDX
ENDIF




=OPENDB("AQ_CAUSPAG")
SELECT AQ_CAUSPAG
SET ORDER TO PAGCOD


=OPENDB("AQ_PDTESTA")
SELECT AQ_PDTESTA
INDEX ON pdanno + pdnrreg  TAG Tnreg ADDITIVE
SET ORDER TO Tnreg


=OPENDB(_NOME_FILE)
SELECT &_NOME_FILE



_V_CONTA  = 0


***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE
v_seek	 = 'GEN'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro GEN 4 caratteri conti FORNITORI"
   RETURN
ENDIF
CC =SUBSTR(LIBERA,18,4)
CCC =SUBSTR(LIBERA,18,4)







*!* #########################################################	   SISTEMA DATI       #########################################################
___PAR_CODCLI	= ""		

SELECT &_NOME_FILE
GO TOP


DO WHILE .T.

   	IF EOF()
      EXIT
   	ENDIF

   	IF DELETED()
   	  SELECT &_NOME_FILE
   	  SKIP +1
      LOOP
   	ENDIF



   	WAIT WINDOWS "Conversione Partitario FORNITORI , RIPORTA RIFERIMENTI " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT


   	SCATTER MEMVAR MEMO

	
***SERGIO..
		
	IF SUBSTR(N1,1,5) 	= "Conto"
		___PAR_CODCLI = TRC(PUB_LCL,SUBSTR(STAMPA_MAS,1,7))
 							
		x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "for_codcli = '" + ___PAR_CODCLI + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
		IF !ExecCommand(cSql,"CUR_FORNI")
		   RETURN .F.
		ENDIF
		SELECT CUR_FORNI
		GO TOP
		IF !EOF()
	       V_ER = SOTTOGEN(FOR_NAZION)
		   IF !V_ER
		      CC = PUB_FF
		   ELSE
		      CC = CCC
		   ENDIF
	    ELSE
		   CC = CCC
	    ENDIF
	ENDIF

   	SELECT &_NOME_FILE


 	REPLACE PAR_CODCLI 	WITH CC+ALLTRIM(___PAR_CODCLI)


	DO CASE
		CASE UPPER(SUBSTR(STAMPA_MAS,1,4)) = "FATT"
			___PAR_TIPFAT = "FAC"
		CASE UPPER(SUBSTR(STAMPA_MAS,1,3)) = "Pag"
			___PAR_TIPFAT = "BOF"
		CASE UPPER(SUBSTR(STAMPA_MAS,1,9)) = "NOTA CRED"
			___PAR_TIPFAT = "NCF"
		CASE UPPER(SUBSTR(STAMPA_MAS,1,4)) = "N/CR"
			___PAR_TIPFAT = "NCF"
		OTHERWISE
			___PAR_TIPFAT = "GEN"	
	ENDCASE

 	REPLACE PAR_TIPFAT 	WITH ___PAR_TIPFAT


	DO CASE
	
		CASE  SUBSTR(UPPER(M.STAMPA_MAS),1,10)	= "Pag. Fatt:"
			
			*Pag. Fatt: 372084  del  28/08/2006
			*Pag. Fatt: 4  del  03/04/2006                        			


			
			IF EMPTY(M.N7)
				
				_STRINGA				= M.STAMPA_MAS
				_STRINGA_DA_CERCARE		= ":"
				_LUNGHEZZA_DA_CERCARE	= 1
				_PARTENZA_NUMERO_FATTURA=CERCA_CHR(_STRINGA,_STRINGA_DA_CERCARE,_LUNGHEZZA_DA_CERCARE) + 1

				_STRINGA_DA_CERCARE		= "del"
				_LUNGHEZZA_DA_CERCARE	= 3
				_PARTENZA_DATA_FATTURA  =CERCA_CHR(_STRINGA,_STRINGA_DA_CERCARE,_LUNGHEZZA_DA_CERCARE) + 5
				_PARTENZA_DEL		    =CERCA_CHR(_STRINGA,_STRINGA_DA_CERCARE,_LUNGHEZZA_DA_CERCARE)

				___NUMERO_FATTURA 		= ALLTRIM(SUBSTR(_PARTENZA_NUMERO_FATTURA,(_PARTENZA_DEL-1)))								
				___DATA_FATTURA   		= ALLTRIM(SUBSTR(M.STAMPA_MAS,_PARTENZA_DATA_FATTURA,8))	

		    	SELECT &_NOME_FILE
				REPLACE N7	WITH ALLTRIM(___DATA_FATTURA)
				REPLACE N8	WITH ALLTRIM(___NUMERO_FATTURA)
				REPLACE N9	WITH ALLTRIM(___NUMERO_FATTURA)
   	  			SKIP +1
      			LOOP

			
			ENDIF		
		
	
	ENDCASE


  	SELECT &_NOME_FILE
 	SKIP +1


ENDDO


*!* #########################################################	   RIPORTO DATI DA ALTRI FILE      ###############################################

___CONTA_PART = 0
* N10 = NUMERO DI REGISTRAZIONE
* N1  = DATA DI REGISTRAZIONE GG/MM/AA
* N7  = DATA DI FATTURA GG/MM/AA
* N8  = NUMERO FATTURA
* N9  = NUMERO PROTOCOLLO

	
SELECT N10,N1,N7,N8,N9 FROM &_NOME_FILE NOCONSOLE GROUP BY N10,N1,N7,N8,N9


SELECT QUERY
GO TOP

DO WHILE .T.

   	IF EOF()
      EXIT
   	ENDIF

   	IF DELETED()
   	  SELECT QUERY
   	  SKIP +1
      LOOP
   	ENDIF

   	IF SUBSTR(N10,1,7) = "Rif.Pd."				&& NUMERO DI REGISTRAZIONE
   	  SELECT QUERY
   	  SKIP +1
      LOOP
   	ENDIF


   	IF SUBSTR(N10,1,1) = " "					&& NUMERO DI REGISTRAZIONE
   	  SELECT QUERY
   	  SKIP +1
      LOOP
   	ENDIF



	* N1  			= DATA DI REGISTRAZIONE GG/MM/AA
	* N7  			= DATA DI FATTURA GG/MM/AA
	* N8  			= NUMERO FATTURA
	* N9  			= NUMERO PROTOCOLLO
	* N10 			= NUMERO DI REGISTRAZIONE
	* STAMPA_MAS	= CONTIENE LA DESCRIZIONE DEL MOVIMENTO

	_N1			= ALLTRIM(N1)						&& data di registrazione
	_N10		= ALLTRIM(N10)						&& numero di registrazione

	_N7			= ALLTRIM(N7)						&& data di FATTURA
	_N8			= ALLTRIM(N8)						&& numero di FATTURE

	_N9			= ALLTRIM(N9)						&& numero di protocollo

	_NPRO 		= N9
	_ANNO 		= "20"+SUBSTR(N1,7,2)				&& ANNO REGISTRAZIONE
	_NREG 		= ALLTRIM(N10) 						&& NUMERO REGISTRAZIONE


    ___CONDIZIONE_PAGAMENTO = ""

	SELECT AQ_PDTESTA					&& RISALE A PDTESTA PER LE CONDIZIONI DI PAGAMENTO
	SET ORDER TO Tnreg
	
	_SEEK = _ANNO + _NREG
	SEEK _SEEK
	IF FOUND()

		DO WHILE .NOT.EOF()
		
		
			IF ALLTRIM(_ANNO) <> ALLTRIM(CONV_CLEAR(pdanno))
				EXIT
			ENDIF

			IF ALLTRIM(_NREG) <> ALLTRIM(CONV_CLEAR(pdnrreg))
				EXIT
			ENDIF

			IF !EMPTY(PAGCOD)
				___CONDIZIONE_PAGAMENTO =  CONV_CLEAR(PAGCOD)
				EXIT
			ENDIF

			SELECT AQ_PDTESTA
			SKIP +1
			
		ENDDO
		
	ENDIF
	
	
	
	*!*		AGGIORNA FILE DI INPUT CON LE CONDIZIONI DI PAGAMENTO E IL NUMERO DI PARTITA E IL NUMERO DI PRIMA NOTA

	___CONTA_PART = ___CONTA_PART +1
	___PAR_NUMPRO = SYS(2015)
	___PAR_NPART  = VAL(_NPRO)
	___PAR_CODPAG = CONV_CERCA_CPA(___CONDIZIONE_PAGAMENTO,"PARTITARI")
	
	

	SELECT &_NOME_FILE
	SET ORDER TO __NPROT__
	_SEEK 	= SUBSTR(_N1,7,2) + ALLTRIM(_N9)				 	&& DATA + NUMERO DI PROTOCOLLO
	SET NEAR ON
	SEEK  _SEEK
	SET NEAR OFF
	IF FOUND()
	
		DO WHILE .NOT.EOF()
		
		    IF DELETED()
				SELECT &_NOME_FILE
				SKIP +1
				LOOP
		    ENDIF
	
		
			IF SUBSTR(N1,7,2) <> SUBSTR(_N1,7,2)		&& data di registrazione
				EXIT
			ENDIF

			IF ALLTRIM(N9) <> ALLTRIM(_N9)				&& numero di PROTOCOLLO
				EXIT
			ENDIF

			REPLACE	PAR_NUMPRO	WITH ___PAR_NUMPRO
			REPLACE PAR_NPART   WITH ___PAR_NPART
			IF !EMPTY(___PAR_CODPAG)
				REPLACE PAR_CODPAG	WITH ___PAR_CODPAG
			ENDIF

		    _DESMOV 	= ALLTRIM(STAMPA_MAS)												&& DESCRIZIONE DEL MOVIMENTO


			SELECT &_NOME_FILE
			SKIP +1
			
		ENDDO
	
	
	ENDIF


	SELECT QUERY
   	SKIP +1

ENDDO




*!* #########################################################	   CREA PARTITARI       #########################################################
_V_CONTA = 0
RELEASE DATA_SCAD
PUBLIC DATA_SCAD
DATA_SCAD   = ""

SELECT &_NOME_FILE
GO TOP


DO WHILE .T.

   	IF EOF()
      EXIT
   	ENDIF

   	IF DELETED()
   	  SELECT &_NOME_FILE
   	  SKIP +1
      LOOP
   	ENDIF

   	IF EMPTY(N1)
   	  SELECT &_NOME_FILE
   	  SKIP +1
      LOOP
   	ENDIF


   	IF SUBSTR(N1,1,5) = "Conto"
   	  SELECT &_NOME_FILE
   	  SKIP +1
      LOOP
   	ENDIF

   	IF SUBSTR(N1,1,8) = "Data Reg"
   	  SELECT &_NOME_FILE
   	  SKIP +1
      LOOP
   	ENDIF

*!*	   	IF SUBSTR(STAMPA_MAS,1,14) = "CHIUSURA SALDI"
*!*	   	  SELECT &_NOME_FILE
*!*	   	  SKIP +1
*!*	      LOOP
*!*	   	ENDIF


*!*		IF _PUB_ANNO = "2006"										&& TRATTA I RECORD DI BILANCIO APERTURA SE 2006
*!*		ELSE
*!*		   	IF SUBSTR(STAMPA_MAS,1,20) = "BILANCIO DI APERTURA"
*!*		   	  SELECT &_NOME_FILE
*!*		   	  SKIP +1
*!*		      LOOP
*!*		   	ENDIF
*!*	   	ENDIF


   	WAIT WINDOWS "Conversione Partitario FORNITORI " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT



	SCATTER MEMVAR MEMO

	TOP_TOP = M.PAR_TIPFAT

	x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "for_codcli = '" + SUBSTR(M.PAR_CODCLI,PUB_SOTTOG,9) + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
	IF !ExecCommand(cSql,"CUR_FORNITORI")
	   RETURN .F.
	ENDIF
	SELECT CUR_FORNITORI
	GO TOP
	IF !EOF()
	   V_TELEFO  = for_TELEFO
	   V_PARIVA  = for_PARIVA
	   V_RAGSOC  = for_RAGSOC
	   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
	   VET_DAL[1]= for_BDAL
	   VET_DAL[2]= for_B2DAL
	   VET_AL[1] = for_BAL
	   VET_AL[2] = for_B2AL
	   VET_DAY[1]= for_GG1
	   VET_DAY[2]= for_GG2
	   V_CONPAG  = for_CONPAG
	ELSE
	   V_TELEFO  = SPACE(15)
	   V_PARIVA  = SPACE(16)
	   V_RAGSOC  = "FORNTORE INESISTENTE"
	   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
	   VET_DAL[1]= "0000"
	   VET_DAL[2]= "0000"
	   VET_AL[1] = "0000"
	   VET_AL[2] = "0000"
	   VET_DAY[1]= "0000"
	   VET_DAY[2]= "0000"
	   V_CONPAG  = PUB_CPA
	ENDIF

   	SELECT &_NOME_FILE

	IF !EMPTY(M.PAR_CODPAG)
		V_CONPAG  = M.PAR_CODPAG
	ENDIF

	IF EMPTY(M.N7)
		DTD= SUBSTR(M.N1,1,6)+"20"+SUBSTR(M.N1,7,2)  && forza data registrazione
	ELSE
		DTD= SUBSTR(M.N7,1,6)+"20"+SUBSTR(M.N7,7,2)
	ENDIF
	
	IMP = 0
	IF VAL(M.N3) <> 0
		IMP = VAL(M.N3)
	ENDIF

	IF VAL(M.N4) <> 0
		IMP = VAL(M.N4)	
	ENDIF
	
	YVALUTA = "EUR"
	YCAMBIO = 1
	
    IF EMPTY(M.PAR_DTSCAD)
	    V_TUTTO=TRANCHE("PARA",V_CONPAG,RIBALTA2(DTD),IMP,VET_DAL,VET_AL,VET_DAY,YVALUTA)
	    DO SCADULT     && RICERCA ULTIMA DATA SCADENZA
	    M.PAR_DTSCAD = RIBALTA2(DATA_SCAD)
	ENDIF

   	v_seek	= 'TOP' + M.PAR_TIPFAT
   	v_chiave = "codice"
   	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      	SELECT CUR_PARA
      	NOTAC	     = SUBSTR(LIBERA,11,1)
      	FATTURA   	 = SUBSTR(LIBERA,2,1)
   	ELSE
      	WAIT WINDOW "Errore manca parametro TOP :"+TOP_TOP
      	NOTAC	     = " "
      	FATTURA   	 = " "
   	ENDIF


	IF !ExecCommand("select * from PART_FOR where 0=1","CUR_PARTFOR")
	   return(.f.)
	ENDIF

	_V_CONTA = _V_CONTA + 1


	SELECT CUR_PARTFOR
	APPEND BLANK
	REC_PART=RECNO()
	REPLACE PAR_CODSOC  WITH PUB_CODSOC
	REPLACE PAR_ANNO    WITH _PUB_ANNO


	IF VAL(M.N3) <> 0
		REPLACE PAR_TMOV    WITH "D"
	ENDIF

	IF VAL(M.N4) <> 0
		REPLACE PAR_TMOV    WITH "A"
	ENDIF

	REPLACE PAR_CODCLI  WITH M.PAR_CODCLI
	REPLACE PAR_RAGSOC  WITH V_RAGSOC
	
	DATREG = SUBSTR(M.N1,1,6)+"20"+SUBSTR(M.N1,7,2)
    REPLACE PAR_DTREG  WITH RIBALTA2(DATREG)

	REPLACE PAR_DTFAT  WITH RIBALTA2(DTD)
	
	REPLACE PAR_TIPFAT  WITH M.PAR_TIPFAT
	REPLACE PAR_NPROT   WITH M.N9
	
	REPLACE PAR_DESMOV	WITH ALLTRIM(M.STAMPA_MAS)
	
	REPLACE PAR_TOTIM   WITH IMP
	REPLACE PAR_TIMPOS  WITH 0           && TIVA ???????
	REPLACE PAR_FATT    WITH IMP
	
	REPLACE PAR_NUMFAT  WITH M.N8	
	_NDOC = M.N8
	
	IF EMPTY(ALLTRIM(PAR_NUMFAT))
		REPLACE PAR_NUMFAT  WITH SUBSTR(M.N10,2,6) 		&& FORZA NUMERO REGISTRAZIONE
		_NDOC = SUBSTR(M.N10,2,6) 						&& FORZA NUMERO REGISTRAZIONE
	ENDIF
	
	
	REPLACE PAR_NPROG   WITH 100
	
	IF FATTURA  <> "S"
		REPLACE PAR_NPROG   WITH 300					&& MOVIMENTI NON FATTURE
		REPLACE PAR_TIPODO  WITH "PAG"
	ELSE
		REPLACE PAR_TIPODO  WITH "FAT"
	ENDIF
	
	REPLACE PAR_NPART   WITH M.PAR_NPART
	REPLACE PAR_CODPAG  WITH V_CONPAG
	REPLACE PAR_TEL     WITH V_TELEFO
	REPLACE PAR_IVA     WITH V_PARIVA

*!*	    IF VAL(SUBSTR(M.N10,2,6)) = 6101
*!*	       SET STEP ON
*!*	
*!*	    ENDIF


	REPLACE PAR_NREG    WITH SUBSTR(M.N10,2,6)

	M.PAR_NUMPRO=CONV_CERCA_REGISTRAZIONE_CONTABILE(M.PAR_CODCLI,_PUB_ANNO,SUBSTR(M.N10,2,6),RIBALTA2(DATREG),M.PAR_NPART)
	REPLACE PAR_NUMPRO  WITH M.PAR_NUMPRO
	
	REPLACE PAR_CIVA1   WITH ""							&& CIVA ????????????
	REPLACE PAR_IMPO1   WITH IMP
	REPLACE PAR_IMPOS1  WITH 0							&& TIVA ??????????
	REPLACE PAR_TOT1    WITH IMP
	REPLACE PAR_CIVA2   WITH "   "
	REPLACE PAR_IMPO2   WITH 0
	REPLACE PAR_IMPOS2  WITH 0
	REPLACE PAR_TOT2    WITH 0
	REPLACE PAR_CIVA3   WITH "   "
	REPLACE PAR_IMPO3   WITH 0
	REPLACE PAR_IMPOS3  WITH 0
	REPLACE PAR_TOT3    WITH 0
	REPLACE PAR_CIVA4   WITH "   "
	REPLACE PAR_IMPO4   WITH 0
	REPLACE PAR_IMPOS4  WITH 0
	REPLACE PAR_TOT4    WITH 0
	REPLACE PAR_CIVA5   WITH "   "
	REPLACE PAR_IMPO5   WITH 0
	REPLACE PAR_IMPOS5  WITH 0
	REPLACE PAR_TOT5    WITH 0

	V_DTSCA = M.PAR_DTSCAD
	
    IF EMPTY(V_DTSCA)
    	V_DTSCA = RIBALTA2(DATREG)					&& FORZA DATA REGISTRAZIONE
    ENDIF	
	
	
	IF SUBSTR(V_DTSCA,3,1) = "/"
    	V_DTSCA = RIBALTA2(V_DTSCA) 				&& DT.SCAD DA FATTURA
    ENDIF

   	REPLACE PAR_DTSCAD  WITH V_DTSCA           		&& DT.SCAD DA FATTURA


	REPLACE PAR_VALUTA WITH YVALUTA
	REPLACE PAR_CAMBIO WITH YCAMBIO

	REPLACE PAR_DTVAL  WITH V_DTSCA
	REPLACE PAR_DATPAG WITH V_DTSCA

	REPLACE PAR_IMPVAL WITH IMP	         	 		&& VALORE IN VALUTA
	
	
	SCATTER MEMVAR MEMO

	
	IF FATTURA  = "S"
		DO CONV_REG_SCAD      			&& GESTIONE SCADENZIARIO FORNITORI
	ENDIF
	
	IF !ExecRW('','PART_FOR','I','','CUR_PARTFOR')
	   return(.f.)
	ENDIF


*!*		=CREA_SALDI_CF("C",M.PAR_CODCLI,_NDOC,"XXXXXXXXXX","CREA")


  	SELECT &_NOME_FILE
 	SKIP +1


ENDDO


*!* #########################################################	  CONTROVERIFICA       #########################################################


	

*!*	CREATE CURSOR CUR_ERR_PART (PAR_CODCLI C(13),AQ_DARE N(13,0),AQ_AVERE N(13,0),MAC_DARE N(13,0),MAC_AVERE N(13,0),PAR_RAGSOC C(35))



*!*	SELECT &_NOME_FILE
*!*	GO TOP

*!*	
*!*	DO WHILE .T.

*!*	   	IF EOF()
*!*	      EXIT
*!*	   	ENDIF
*!*	
*!*	   	IF DELETED()
*!*	   	  SELECT &_NOME_FILE
*!*	   	  SKIP +1
*!*	      LOOP
*!*	   	ENDIF

*!*	
*!*	   	WAIT WINDOWS "Controverifica " NOWAIT


*!*	   	SCATTER MEMVAR MEMO

*!*			
*!*		IF SUBSTR(STAMPA_MAS,1,15) 	<> "Totali generali"
*!*	   	  SELECT &_NOME_FILE
*!*	   	  SKIP +1
*!*	      LOOP
*!*		ENDIF

*!*	    SCATTER MEMVAR MEMO
*!*	
*!*	    __DARE_INPUT = VAL(M.N3)
*!*	    __AVERE_INPUT = VAL(M.N4)
*!*	
*!*		*!*	CREA IL PRIMO CURSORE PER I SALDI DARE
*!*		__clien  ="par_codcli = '" + ALLTRIM(M.par_codcli) + "'"
*!*		__campi__="par_codcli"
*!*		__somma__=", SUM(par_fatt) AS par_fattd"
*!*		__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'D' "  && TUTTE LE PARTITE
*!*		x_cond = __condi__ + " and " + __clien


*!*		cSql="SELECT "+__campi__+__somma__+" FROM PART_FOR WHERE " + x_cond +  ;
*!*		    					                          " group by "+__campi__+" order by PAR_CODCLI"
*!*		IF !ExecCommand(cSql,"cur_dare")
*!*		   return(.f.)
*!*		ENDIF

*!*		*!*	CREA IL SECONDO CURSORE PER I SALDI AVERE
*!*		__clien  ="par_codcli = '" + ALLTRIM(M.par_codcli) + "'"
*!*		__campi__="par_codcli"
*!*		__somma__=", SUM(par_fatt) AS par_fatta"
*!*		__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'A' "  && TUTTE LE PARTITE
*!*		x_cond = __condi__ + " and " + __clien


*!*		cSql="SELECT "+__campi__+__somma__+" FROM PART_FOR WHERE " + x_cond +  ;
*!*		    					                          " group by "+__campi__+" order by PAR_CODCLI"
*!*		IF !ExecCommand(cSql,"cur_avere")
*!*		   return(.f.)
*!*		ENDIF

*!*	    IF __DARE_INPUT <> cur_dare.par_fattd OR __AVERE_INPUT <> cur_avere.par_fatta
*!*	    	SELECT CUR_ERR_PART
*!*	    	APPEND BLANK
*!*	    	REPLACE PAR_CODCLI WITH M.PAR_CODCLI
*!*	    	REPLACE AQ_DARE	   WITH cur_dare.par_fattd
*!*	     	REPLACE MAC_DARE   WITH __DARE_INPUT
*!*	    	REPLACE AQ_AVERE   WITH cur_avere.par_fatta
*!*	     	REPLACE MAC_AVERE  WITH __AVERE_INPUT
*!*		ENDIF
*!*	   	

*!*	    SELECT &_NOME_FILE
*!*	    SKIP +1

*!*	ENDDO

*!*	SELECT CUR_ERR_PART
*!*	GO TOP
*!*	IF !EOF()
*!*		BROWSE
*!*	ENDIF


SET DEFA TO &PUB_DIR

RETURN



**--> DAVR: CONVERSIONE ANAGRAFICA VETTORI (INIZIO)
*************************************************************************************************
PROCEDURE CONV_PARA_VET_SOP
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_VETTORI"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica Vettori...  -  Prego Attendere" NOWAIT
cSql = "delete from PARA where codice like 'VET%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PARA where 1=0"
IF !ExecCommand(cSql,"CPARA")
   return(.f.)
ENDIF

V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH

IF FILE("AQ_VETTORI.CDX")
   ERASE AQ_VETTORI.CDX
ENDIF

=OPENDB("AQ_VETTORI")

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT AQ_VETTORI
GO TOP

DO WHILE !EOF()

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione archivio Anagrafica Vettori record " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   _MY_DESCRI = ALLTRIM(CONV_CLEAR(M.VETRAG))
   _MY_DESCRI = _MY_DESCRI + IIF(ALLTRIM(CONV_CLEAR(M.VETRAG2))<>"", " "+ALLTRIM(CONV_CLEAR(M.VETRAG2)), "" )
   _MY_DESCRI = _MY_DESCRI + IIF(ALLTRIM(CONV_CLEAR(M.VETIND))<>"", " - "+ALLTRIM(CONV_CLEAR(M.VETIND)), "" )
   _MY_DESCRI = _MY_DESCRI + IIF(ALLTRIM(CONV_CLEAR(M.VETCITTA))<>"", " - ", "")
   _MY_DESCRI = _MY_DESCRI + IIF(ALLTRIM(CONV_CLEAR(M.VETCAP))<>"", ALLTRIM(CONV_CLEAR(M.VETCAP))+ " ", "")
   _MY_DESCRI = _MY_DESCRI + IIF(ALLTRIM(CONV_CLEAR(M.VETCITTA))<>"", ALLTRIM(CONV_CLEAR(M.VETCITTA)), "" )
   _MY_DESCRI = _MY_DESCRI + IIF(ALLTRIM(CONV_CLEAR(M.VETPROV))<>"", " ("+ALLTRIM(CONV_CLEAR(M.VETPROV))+")", "" )

   SELECT CPARA
   APPEND BLANK
   REPLACE CODICE WITH "VET" + REPLICATE('0',3-LEN(ALLTRIM(CONV_CLEAR(M.VETCOD))))+ALLTRIM(CONV_CLEAR(M.VETCOD)),;
           DESCRI WITH _MY_DESCRI,;
           PAR_DATINS	WITH RIBALTA2(DTOC(DATE()))

   _V_CONTA  = _V_CONTA + 1

   SELECT AQ_VETTORI
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio Anagrafica Vettori sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','PARA','I','','CPARA')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
ENDIF

SET DEFA TO &PUB_DIR

RETURN
**--> DAVR: CONVERSIONE ANAGRAFICA VETTORI (FINE)

**--> DAVR: CONVERSIONE ANAGRAFICA TRASPORTO A MEZZO (INIZIO)
*************************************************************************************************
PROCEDURE  CONV_PARA_MEZ_SOP
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_TRAMEZ"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL
WAIT WINDOWS "Cancellazione vecchia Anagrafica Trasporto a Mezzo...  -  Prego Attendere" NOWAIT
cSql = "delete from PARA where codice like 'MEZ%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

*** DEFINIZIONE CURSORE DI APPOGGIO
cSql = "Select * from PARA where 1=0"
IF !ExecCommand(cSql,"CPARA")
   return(.f.)
ENDIF

V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH

IF FILE("AQ_TRAMEZ.CDX")
   ERASE AQ_TRAMEZ.CDX
ENDIF

=OPENDB("AQ_TRAMEZ")

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT AQ_TRAMEZ
GO TOP

DO WHILE !EOF()

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione archivio Anagrafica Trasporto a Mezzo record " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CPARA
   APPEND BLANK
   REPLACE CODICE 		WITH "MEZ" + CONV_CLEAR(M.CODMEZ),;
           DESCRI 		WITH CONV_CLEAR(M.DESMEZ),;
           PAR_DATINS	WITH RIBALTA2(DTOC(DATE()))

   _V_CONTA  = _V_CONTA + 1

   SELECT AQ_TRAMEZ
   SKIP +1

ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio Anagrafica Trasporto a Mezzo sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','PARA','I','','CPARA')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
ENDIF

SET DEFA TO &PUB_DIR

RETURN
**--> DAVR: CONVERSIONE ANAGRAFICA TRASPORTO A MEZZO (FINE)



*************************************************************************************************
PROCEDURE CONV_AQ_DBASES       && ACQUISISCE LE DISTINTE BASE U_DIS_TT/DD DA FILE AQ_DBASES.DBF
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE DISTINTE BASE E ANAGRAFICA ARTICOLI             		*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.													 	*
*	Gennaio 2008																				*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH
PUBLIC V_PATH
V_PATH = ""

V_PATH = ALLTRIM(_V_PERCORSO) + "AQ_DBASES"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL
WAIT WINDOWS "Cancellazione vecchi Centri di costo...  -  Prego Attendere" NOWAIT
x_codi = "codice like 'PRD%'"
x_cond = x_codi
cSql = "delete from PARA where " + x_cond
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF


*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_DIS_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Distinte base esistenti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_DIS_TT where 1=1"
IF !ExecCommand(cSql,"U_DIS_TT")
   return(.f.)
ENDIF
cSql = "delete from U_DIS_DD where 1=1"
IF !ExecCommand(cSql,"U_DIS_DD")
   return(.f.)
ENDIF
x_codi = "codice = 'NUMDIS'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = 'NUMDIS'
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO - " + V1
ENDIF
_YEAR = IIF(EMPTY(ALLTRIM(SUBSTR(PUB_ANNO,4,1))),"1",ALLTRIM(SUBSTR(PUB_ANNO,4,1)))
REPLACE LIBERA WITH _YEAR + "000000000"
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF


*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_DIS_TT where 1=0"
IF !ExecCommand(cSql,"CU_DIS_TT")
   return(.f.)
ENDIF
INDEX ON ALLTRIM(DIT_GRUPPO) TAG I_GRUPPO
cSql = "Select * from U_DIS_DD where 1=0"
IF !ExecCommand(cSql,"CU_DIS_DD")
   return(.f.)
ENDIF
INDEX ON ALLTRIM(DIS_GRUPPO)+ALLTRIM(DIS_CODART) TAG I_GRUART ADDITIVE
INDEX ON ALLTRIM(STR(DIS_SEQUEN,10,0)) TAG D_SEQUEN DESCENDING ADDITIVE


*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
IF !USED(V_PATH)
   USE &V_PATH IN 0 AGAIN
ENDIF
SELECT AQ_DBASES
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK
HH=AFIELDS(TRANSITO)
CREATE CURSOR CUR_AQ_DBASES FROM ARRAY TRANSITO
INDEX ON ARTBASE TAG ARTBASE ADDITIVE
SELECT CUR_AQ_DBASES
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

SELECT AQ_DBASES
USE

_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_AQ_DBASES
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione Riga delle Distinte base " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_DIS_TT
   SET ORDER TO I_GRUPPO
   GO TOP
   _SEEK = ALLTRIM(UPPER(M.ARTBASE))
   SEEK _SEEK
   IF FOUND()
      SCATTER MEMVAR MEMO
   ELSE
      _NEW_CODE = ALLTRIM(M.ARTBASE)
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_cond = "art_codpri = '" + ALLTRIM(_NEW_CODE) + "'"
      cSql   = "select * from u_art_pr where " + x_cond
      IF !ExecCommand(cSql,'CU_ART_PR')
         return(.f.)
      ENDIF
      SELECT CU_ART_PR
      SCATTER MEMVAR MEMO BLANK
      GO TOP
      IF EOF()
         *** AGGIORNAMENTO ANAGRAFICA ARTICOLI
         IF !ExecRW("select * from u_art_pr where 0=1","U_ART_PR","R")
            return(.f.)
         ENDIF
         SELECT U_ART_PR
         APPEND BLANK
         M.ART_CODSOC = PUB_CODSOC
         M.ART_CODPRI = ALLTRIM(_NEW_CODE)
         M.ART_CODPRI = UPPER(M.ART_CODPRI)
         M.ART_CODPRI = APITOSPA(M.ART_CODPRI)
         M.ART_TIPO   = UPPER(SUBSTR(M.ART_CODPRI,1,4))
         M.ART_LUNG   = UPPER(SUBSTR(M.ART_CODPRI,5,4))
         M.ART_LARG   = UPPER(SUBSTR(M.ART_CODPRI,9,4))
         M.ART_COLORE = UPPER(SUBSTR(M.ART_CODPRI,13,2))
         M.ART_LAVORA = UPPER(SUBSTR(M.ART_CODPRI,15,2))
         M.ART_TIPO   = APITOSPA(M.ART_TIPO)
         M.ART_LUNG   = APITOSPA(M.ART_LUNG)
         M.ART_LARG   = APITOSPA(M.ART_LARG)
         M.ART_COLORE = APITOSPA(M.ART_COLORE)
         M.ART_LAVORA = APITOSPA(M.ART_LAVORA)
         M.ART_DESCR  = "???????????????????????"
         M.ART_UNIMIS = "MQ"
         M.ART_CODIVA = PUB_IVA
         M.ART_MAGA   = PUB_CODM
         M.ART_LINEA  = PUB_LINEA
         M.ART_DATVAR = RIBALTA2(DTOC(DATE()))
         M.ART_DATINS = RIBALTA2(DTOC(DATE()))
         M.ART_COORD  = ""
         M.ART_CODMAT = '005'
         M.ART_DESMAT = 'FILM HT'
         M.ART_TIPART = 'P'
         M.ART_DISBAS = 'S'
         M.ART_RIPCOM = 'S'
         M.ART_TIPOPR = 'I'
         M.ART_GRUPPO = .T.
         *M.ART_PRZVEN = _W_PRZVEN
         *M.ART_PRZCOS = _W_PRZCOS
         M.ART_SINTE  = .F.
         M.ART_UMMAGA = "MQ"
         DO U_ART_PR
         IF !ExecRW("","U_ART_PR","W")
            return(.f.)
         ENDIF
      ELSE
         SCATTER MEMVAR MEMO
      ENDIF

      SELECT CU_DIS_TT
      SCATTER MEMVAR MEMO BLANK
      M.TAGGANCIO  = STR(NEWPROG('NUMDIS'),10)
      M.DIT_CODSOC = PUB_CODSOC
      M.DIT_GRUPPO = M.ART_CODPRI
      M.DIT_DESCRI = M.ART_DESCR
      M.DIT_UM     = M.ART_UNIMIS
      M.DIT_MAGA   = M.ART_MAGA
      M.DIT_LINEA  = M.ART_LINEA
      M.DIT_CODIVA = M.ART_CODIVA
      M.DIT_PREZZO = M.ART_PRZVEN
      M.DIT_COSTO  = M.ART_PRZCOS
      M.DIT_TIPOPR = M.ART_TIPOPR
      M.DIT_ORELAV = "00000:00:00"
      M.DIT_OREATT = "00000:00:00"
      M.DIT_OREIMP = "00000:00:00"
      M.DIT_SYSTT  = SYS(2015)
      SELECT CU_DIS_TT
      APPEND BLANK
      DO U_DIS_TT
      _V_CONTA = _V_CONTA + 1
   ENDIF

   SELECT CU_DIS_DD
   SET FILTER TO ALLTRIM(DIS_GRUPPO) = ALLTRIM(M.DIT_GRUPPO)
   SET ORDER TO D_SEQUEN
   GO TOP
   IF EOF()
      _SEQUEN = 10
   ELSE
      _SEQUEN = DIS_SEQUEN + 10
   ENDIF


*!*	IF ALLTRIM(M.DIT_GRUPPO) = "AM 58"
*!*		SET STEP ON
*!*	ENDIF


   SELECT CU_DIS_DD
   SET FILTER TO
   SET ORDER TO
   SET ORDER TO I_GRUART
   GO TOP
   _SEEK = ALLTRIM(M.DIT_GRUPPO)+ALLTRIM(M.ARTCOD)
   SEEK _SEEK
   IF FOUND()
   ELSE
      _NEW_CODE = ALLTRIM(M.ARTCOD)
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_cond = "art_codpri = '" + ALLTRIM(_NEW_CODE) + "'"
      cSql   = "select * from u_art_pr where " + x_cond
      IF !ExecCommand(cSql,'CU_ART_PR')
         return(.f.)
      ENDIF
      SELECT CU_ART_PR
      SCATTER MEMVAR MEMO BLANK
      GO TOP
      IF EOF()
         *** AGGIORNAMENTO ANAGRAFICA ARTICOLI
         IF !ExecRW("select * from u_art_pr where 0=1","U_ART_PR","R")
            return(.f.)
         ENDIF
         SELECT U_ART_PR
         APPEND BLANK
         M.ART_CODSOC = PUB_CODSOC
         M.ART_CODPRI = ALLTRIM(_NEW_CODE)
         M.ART_CODPRI = UPPER(M.ART_CODPRI)
         M.ART_CODPRI = APITOSPA(M.ART_CODPRI)
         M.ART_TIPO   = UPPER(SUBSTR(M.ART_CODPRI,1,4))
         M.ART_LUNG   = UPPER(SUBSTR(M.ART_CODPRI,5,4))
         M.ART_LARG   = UPPER(SUBSTR(M.ART_CODPRI,9,4))
         M.ART_COLORE = UPPER(SUBSTR(M.ART_CODPRI,13,2))
         M.ART_LAVORA = UPPER(SUBSTR(M.ART_CODPRI,15,2))
         M.ART_TIPO   = APITOSPA(M.ART_TIPO)
         M.ART_LUNG   = APITOSPA(M.ART_LUNG)
         M.ART_LARG   = APITOSPA(M.ART_LARG)
         M.ART_COLORE = APITOSPA(M.ART_COLORE)
         M.ART_LAVORA = APITOSPA(M.ART_LAVORA)
         M.ART_DESCR  = ALLTRIM(M.ARTDES1)
         M.ART_UNIMIS = ALLTRIM(M.ARTUM)  &&"KG"
         IF ALLTRIM(M.ARTUM) = "ML"
            M.ART_UNIMIS = "KG"  && UM ACQUISTO IN KG?
         ENDIF
         M.ART_CODIVA = PUB_IVA
         M.ART_MAGA   = PUB_CODM
         M.ART_LINEA  = PUB_LINEA
         M.ART_DATVAR = RIBALTA2(DTOC(DATE()))
         M.ART_DATINS = RIBALTA2(DTOC(DATE()))
         M.ART_COORD  = ""
         M.ART_CODMAT = '001'
         M.ART_DESMAT = 'GENERICO'
         IF ALLTRIM(M.ARTUM) = "ML"
            M.ART_CODMAT = '005'
            M.ART_DESMAT = 'FILM HT'
         ENDIF
         M.ART_TIPART = 'A'
         M.ART_DISBAS = 'S'
         M.ART_RIPCOM = 'S'
         M.ART_TIPOPR = ''
         M.ART_GRUPPO = .F.
         *M.ART_PRZVEN = _W_PRZVEN
         *M.ART_PRZCOS = _W_PRZCOS
         M.ART_SINTE  = .F.
         M.ART_UMMAGA = ALLTRIM(M.ARTUM)  &&"KG"
         DO U_ART_PR
         IF !ExecRW("","U_ART_PR","W")
            return(.f.)
         ENDIF
      ELSE
         SCATTER MEMVAR MEMO
      ENDIF

      SELECT CU_DIS_DD
      SCATTER MEMVAR MEMO BLANK
      M.DAGGANCIO = M.TAGGANCIO
      M.DIS_GRUPPO = M.DIT_GRUPPO
      M.DIS_TIPO   = "A"
      M.DIS_CODART = ALLTRIM(M.ARTCOD)
      M.DIS_DESCRI = ALLTRIM(M.ARTDES1)
      M.DIS_QTA    = M.ARTQTA
      M.DIS_MAGA   = M.DIT_MAGA
      M.DIS_UM     = M.ART_UNIMIS
      M.DIS_PERC   = 0
      M.DIS_DSNOCQ = M.DIS_DESCRI
      M.DIS_SYSDD  = SYS(2015)
      M.DIS_SEQUEN = _SEQUEN

      M.DIS_PREZZO = M.ART_PRZVEN
      M.DIS_COST   = M.ART_PRZCOS
      M.DIS_TIPOPR = M.ART_TIPOPR
      M.DIS_COSLAI = M.ART_COSLAI
      M.DIS_COSLAE = M.ART_COSLAE
      M.DIS_COSMAT = M.ART_COSMAT
      M.DIS_COSATR = M.ART_COSATR
      M.DIS_RICLAI = M.ART_RICLAI
      M.DIS_RICLAE = M.ART_RICLAE
      M.DIS_RICMAT = M.ART_RICMAT
      M.DIS_RICATR = M.ART_RICATR

      M.DIS_ORELAV = M.ART_ORELAV
      M.DIS_OREATT = M.ART_OREATT
      M.DIS_OREIMP = M.ART_OREIMP
      M.DIS_SECIMP = M.ART_SECIMP
      M.DIS_SECLAV = M.ART_SECLAV
      M.DIS_SECATT = M.ART_SECATT

      M.DIS_ORELAV	= "00000:00:00"
      M.DIS_OREATT	= "00000:00:00"
      M.DIS_OREIMP	= "00000:00:00"
      M.DIS_SECIMP	= 0
      M.DIS_SECLAV	= 0
      M.DIS_SECATT	= 0

      SELECT CU_DIS_DD
      APPEND BLANK
      DO U_DIS_DD
   ENDIF

   *** AGGIORNAMENTO GRUPPO PRODUTTIVO NEI PARAMETRI E IN ANAGRAFICA ARTICOLI
   IF ALLTRIM(M.ARTUM) = "ML"
      *_PARA = ALLTRIM(SUBSTR(M.DIS_CODART,1,4))

	  *!*	SERGIO - 11/01/2008 inizio
	  *!*	      _PARA = ALLTRIM(SUBSTR(M.DIS_CODART,1,10))  && ERASMO - 11/01/2008
      _LENGRP1 = LEN(ALLTRIM(M.DIS_CODART))
      IF  _LENGRP1 > 4
        _LENGRP2 = _LENGRP1 - 4
      	_PARA    = ALLTRIM(SUBSTR(M.DIS_CODART,1,_LENGRP2))	&& TOGLIE GLI ULTIMI 4 CHR
      ELSE
        _PARA    = ALLTRIM(SUBSTR(M.DIS_CODART,1,10))  && ERASMO - 11/01/2008
      ENDIF
	  *!*	SERGIO - 11/01/2008 FINE


      x_codi = "codice = 'PRD" + _PARA + "'"
      x_cond = x_codi
      cSql = "select * from PARA where " + x_cond
      IF !ExecRW(cSql,"PARA","R")
        return(.f.)
      ENDIF
      SELECT PARA
      GO TOP
      IF EOF()
         APPEND BLANK
         REPLACE CODICE WITH "PRD" + _PARA
         REPLACE DESCRI WITH "GRUPPO PRODUTTIVO " + _PARA
         REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
      ENDIF
      IF !ExecRW(cSql,"PARA","W")
        return(.f.)
      ENDIF

      _CODE = ALLTRIM(M.ARTBASE)
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_cond = "art_codpri = '" + ALLTRIM(_CODE) + "'"
      cSql   = "select * from u_art_pr where " + x_cond
      IF !ExecRW(cSql,"U_ART_PR","R")
         return(.f.)
      ENDIF
      SELECT U_ART_PR
      GO TOP
      IF EOF()
      ELSE
         REPLACE ART_GRUPRD WITH _PARA
         REPLACE ART_CDDIBA WITH _CODE
         REPLACE ART_GRUPPO WITH .T.
      ENDIF
      IF !ExecRW(cSql,"U_ART_PR","W")
         return(.f.)
      ENDIF

   ENDIF

   SELECT CUR_AQ_DBASES
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivi Distinte base sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_dis_tt','I','','CU_DIS_TT')
      return(.f.)
   ENDIF
   IF !ExecRW('','u_dis_dd','I','','CU_DIS_DD')
      return(.f.)
   ENDIF
   WAIT CLEAR
   _V_OKELAB = .T.
*!*	   MESSAGEBOX("Operazione eseguita correttamente" + CHR(13) + ;
*!*	              "Records di testata scritti   : " + ALLTRIM(STR(_V_CONTA1,10,0)) + CHR(13) + ;
*!*	              "Records di dettaglio scritti : " + ALLTRIM(STR(_V_CONTA2,10,0)),64,"Informazione")
*!*	ELSE
*!*	   MESSAGEBOX("File Vuoto",64,"Attenzione")
ENDIF



*** AGGIORNAMENTO ANAGRAFICA ARTICOLI : PER ARTICOLI BOBINE CON CODICE TIPO : P....... , RIPORTA IL GRUPPO PRODUTTIVO

*!*	SERGIO - 11/01/2008 inizio
WAIT WINDOWS "Aggiornamento articoli base di acquisto ......." nowait
x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
cSql   = "select * from u_art_pr where " + x_soci
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
GO TOP
DO WHILE !EOF()



	IF DELETED()
	   SELECT U_ART_PR
	   SKIP +1
	   LOOP
	ENDIF


    IF SUBSTR(ART_CODPRI,1,1) <> "P"
	   SELECT U_ART_PR
	   SKIP +1
	   LOOP
    ENDIF



    _LENGRP1 = LEN(ALLTRIM(ART_CODPRI))
    IF  _LENGRP1 > 4
        _LENGRP2 = _LENGRP1 - 4
    	_PARA    = ALLTRIM(SUBSTR(ART_CODPRI,1,_LENGRP2))	
    ELSE
        _PARA    = ALLTRIM(SUBSTR(ART_CODPRI,1,10))
    ENDIF


    REPLACE ART_GRUPRD WITH _PARA

    SELECT U_ART_PR
    SKIP +1


ENDDO WHILE !EOF()




IF !ExecRW("","U_ART_PR","W")
      return(.f.)
ENDIF




*!*	SERGIO - 11/01/2008 FINE










RETURN



*************************************************************************************************
PROCEDURE CONV_AQ_FASTDCL       && ACQUISISCE LE FATTURE CLIENTI DA FILE AQ_DBASES.DBF
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE STATISTICHE DI VENDITA             						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.													 	*
*	giugno 2008																				*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH,V_PATH1
PUBLIC V_PATH,V_PATH1
V_PATH = ""
V_PATH1= ""


V_PATH  = ALLTRIM(_V_PERCORSO) + "AQ_FASTDCL"
V_PATH1 = ALLTRIM(_V_PERCORSO) + "AQ_FASTTCL"


*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF



*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_STC_AN SQL
WAIT WINDOWS "Cancellazione vecchie statistiche esistenti...  -  Prego Attendere" NOWAIT
___data = "200712"
x_cond  = "stc_data < '" + ___data + "'"
Csql    = "delete from U_STC_AN where " + x_cond
IF !ExecCommand(cSql,"U_STC_AN")
   return(.f.)
ENDIF


*** DEFINIZIONE CURSORI DI APPOGGIO

cSql = "Select * from U_STC_AN where 1=0"
IF !ExecCommand(cSql,"CU_STC_AN")
   return(.f.)
ENDIF
INDEX ON ALLTRIM(STC_CODCLI)+ALLTRIM(STC_DATA)+ALLTRIM(STC_CODART) TAG I_CLIART ADDITIVE


*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
IF !USED(V_PATH)
   USE &V_PATH IN 0 AGAIN
ENDIF
SELECT AQ_FASTDCL
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK
HH=AFIELDS(TRANSITO)
CREATE CURSOR CUR_AQ_FASTDCL FROM ARRAY TRANSITO
SELECT CUR_AQ_FASTDCL
*APPEND FROM &V_PATH
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012

SELECT AQ_FASTDCL
USE

*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
IF !USED(V_PATH1)
   USE &V_PATH1 IN 0 AGAIN
ENDIF
SELECT AQ_FASTTCL
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK
HH=AFIELDS(TRANSITO)
CREATE CURSOR CUR_AQ_FASTTCL FROM ARRAY TRANSITO

SELECT CUR_AQ_FASTTCL
*APPEND FROM &V_PATH1
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH1) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012


*!*	SELECT CUR_AQ_FASTTCL
*!*	GO TOP
*!*	DO WHILE .NOT. EOF()

*!*	   TAGX=STRTRAN(TAG1," ","")   && SOSTITUISCE SPAZI CON nulla
*!*	   REPLACE TAG1 WITH TAGX

*!*	   SKIP +1
*!*	ENDDO

SELECT CUR_AQ_FASTTCL
INDEX ON ALLTRIM(CLICOD)+RIBALTA2(ALLTRIM(DTOC(BOLDATA)))+ALLTRIM(BOLNUM) TAG TAG1 ADDITIVE

SELECT AQ_FASTTCL
USE



_V_CONTA  = 0

*** LOOP DI SCRITTURA DATI
SELECT CUR_AQ_FASTDCL
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   IF EMPTY(ALLTRIM(CONV_CLEAR(M.ARTCOD)))
      SELECT CUR_AQ_FASTDCL
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(CONV_CLEAR(M.ARTCOD)) = "."
      SELECT CUR_AQ_FASTDCL
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(CONV_CLEAR(M.ARTCOD)) = "PL"
      SELECT CUR_AQ_FASTDCL
      SKIP +1
      LOOP
   ENDIF


   __CLICOD   = M.CLICOD
   M.CLICOD   = TRC(PUB_LCL,ALLTRIM(M.CLICOD))



   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(M.CLICOD) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"xx_cli_an")
      return(.f.)
   ENDIF
   SELECT xx_cli_an
   GO TOP
   IF EOF()

     WAIT WINDOW "Cliente NON TROVATOOOOOOOOOOOOOOO :"+ M.CLICOD nowait
     M.CLIDES   = "???????????????"
     M.STC_CAP  = "??????"
   ELSE
   	 M.CLIDES   = ALLTRIM(CLI_RAGSOC)
     M.STC_CAP  =  cli_cap  	
   ENDIF

   * VERIFICA SE NOTA CREDITO

   SELECT CUR_AQ_FASTTCL
   SET ORDER TO TAG1

   KEYT = ALLTRIM(__CLICOD)+RIBALTA2(ALLTRIM(DTOC(M.BOLDATA)))+ALLTRIM(M.BOLNUM)

   SEEK KEYT
   IF FOUND()
      IF ALLTRIM(CMOVCOD) = "NCR"
          M.BOLPRZ = M.BOLPRZ * -1
      ENDIF
   ENDIF



   SELECT CUR_AQ_FASTDCL



   M.BOLDATA  = DTOC(M.BOLDATA)

   M.ANNOMM = SUBSTR(M.BOLDATA,7,4)+SUBSTR(M.BOLDATA,4,2)

   WAIT WINDOWS "Conversione Riga FATTURA " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),8,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT


   SELECT CU_STC_AN
   SET FILTER TO
   SET ORDER TO
   SET ORDER TO I_CLIART
   GO TOP

   _SEEK = ALLTRIM(M.CLICOD)+ALLTRIM(M.ANNOMM)+ALLTRIM(M.ARTCOD)
   SEEK _SEEK

   IF FOUND()


		IF M.BOLPRZ < 0
		   REPLACE STC_QTAVEN WITH STC_QTAVEN - M.BOLQTA		&& TRATTASI DI NOTA CREDITO
		ELSE
		   REPLACE STC_QTAVEN WITH STC_QTAVEN + M.BOLQTA
		ENDIF
		
		
		VPRE         = M.BOLPRZ
		VPRE         = VPRE-ROUND((VPRE*M.BOLSCO/100),6)

		M.ORD_PRZNET = VPRE
		M.ORD_PRZNET = ROUND(M.ORD_PRZNET,6)
		M.ORD_VALORE = ROUND((M.ORD_PRZNET*M.BOLQTA),2)
	
		
		REPLACE STC_VALORE WITH STC_VALORE + M.ORD_VALORE
		REPLACE STC_VALVAL WITH STC_VALVAL + M.ORD_VALORE


		IF M.BOLPRZ < 0
		   REPLACE ORD_QTAMQ   WITH ORD_QTAMQ   - M.BOLQTA		&& TRATTASI DI NOTA CREDITO
		   REPLACE ORD_QTAMQ1  WITH ORD_QTAMQ1  - M.BOLQTA		&& TRATTASI DI NOTA CREDITO
		
		ELSE
		   REPLACE ORD_QTAMQ   WITH ORD_QTAMQ   + M.BOLQTA
		   REPLACE ORD_QTAMQ1  WITH ORD_QTAMQ1  + M.BOLQTA
		ENDIF



   ELSE



      	SELECT CU_STC_AN
      	APPEND BLANK

		REPLACE STC_CODSOC WITH PUB_CODSOC
		REPLACE STC_DATA   WITH M.ANNOMM
		REPLACE STC_DTDOC  WITH RIBALTA2(M.BOLDATA)
		REPLACE STC_CODAGE WITH "01"
		REPLACE STC_DESAGE WITH "AGENTE SEDE"
		REPLACE STC_CODCLI WITH M.CLICOD
		REPLACE STC_DESCLI WITH M.CLIDES
		REPLACE STC_CODART WITH ALLTRIM(M.ARTCOD)
		REPLACE STC_DESART WITH ALLTRIM(M.DESCRIZ)
		REPLACE STC_UNIMIS WITH M.ARTUM
		IF STC_UNIMIS = "MQ"
		   REPLACE STC_LINEA  WITH "05"
		ELSE
		   REPLACE STC_LINEA  WITH "05"
		ENDIF
		
	
		

		IF M.BOLPRZ < 0
		   REPLACE STC_QTAVEN WITH M.BOLQTA	* -1	&& TRATTASI DI NOTA CREDITO
		ELSE
		   REPLACE STC_QTAVEN WITH M.BOLQTA
		ENDIF
		
		
		VPRE         = M.BOLPRZ
		VPRE         = VPRE-ROUND((VPRE*M.BOLSCO/100),6)

		M.ORD_PRZNET = VPRE
		M.ORD_PRZNET = ROUND(M.ORD_PRZNET,6)
		M.ORD_VALORE = ROUND((M.ORD_PRZNET*M.BOLQTA),2)
	
		
		REPLACE STC_VALORE WITH M.ORD_VALORE
		REPLACE STC_TOP    WITH "VEN"

		
		REPLACE STC_CAP    WITH M.STC_CAP
		REPLACE STC_VALUTA WITH "EUR"
		REPLACE STC_CAMBIO WITH 1
		REPLACE STC_NUMORD WITH ALLTRIM(M.BOLNUM)
		REPLACE STC_PRZCOS WITH 0
		REPLACE STC_VALVAL WITH M.ORD_VALORE


	   	REPLACE ORD_QTAMQ  WITH M.BOLQTA
	   	REPLACE ORD_QTAMQ1 WITH M.BOLQTA

		IF M.BOLPRZ < 0
		   REPLACE ORD_QTAMQ   WITH M.BOLQTA * -1		&& TRATTASI DI NOTA CREDITO
		   REPLACE ORD_QTAMQ1  WITH M.BOLQTA * -1		&& TRATTASI DI NOTA CREDITO
		ELSE
		   REPLACE ORD_QTAMQ   WITH M.BOLQTA
		   REPLACE ORD_QTAMQ1  WITH M.BOLQTA
		ENDIF

	   	
*!*			  REPLACE ORD_QTAML  WITH V_QTAML
*!*			  REPLACE ORD_QTAML1 WITH V_QTAML1
*!*			  REPLACE ORD_QTAKG  WITH V_QTAKG
*!*			  REPLACE ORD_QTAKG1 WITH V_QTAKG1
*!*			  REPLACE ORD_QTAKGI WITH V_QTAKGI
*!*			  REPLACE ORD_QTAKGE WITH V_QTAKGE
*!*		





        _V_CONTA = _V_CONTA + 1



   ENDIF


   SELECT CUR_AQ_FASTDCL
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA > 0
   WAIT WINDOWS "Scrittura archivio statistiche sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','U_STC_AN','I','','CU_STC_AN')
      return(.f.)
   ENDIF
   WAIT CLEAR
   _V_OKELAB = .T.
ENDIF






RETURN




*************************************************************************************************
PROCEDURE CONV_U_DIS_TT_DD       && ACQUISISCE LE DISTINTE BASE U_DIS_TT/DD DA FILE .DBF
*************************************************************************************************
*************************************************************************************************
*							CONVERSIONE DISTINTE BASI DA ARCHIVI DBF			          		*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.														 	*
*	Settembre 2012																				*
*************************************************************************************************

*** ASSEGNAZIONE DELLA VARIABILE PATH
RELEASE V_PATH_TT,V_PATH_DD
PUBLIC V_PATH_TT,V_PATH_DD
V_PATH_TT = ""
V_PATH_DD = ""

V_PATH_TT = ALLTRIM(_V_PERCORSO) + "U_DIS_TT"
V_PATH_DD = ALLTRIM(_V_PERCORSO) + "U_DIS_DD"

*** VERIFICA ESISTENZA FILE
IF FILE(V_PATH_TT + ".DBF") .AND. FILE(V_PATH_DD + ".DBF")
ELSE
   =MESSAGEBOX("File " + V_PATH + " non trovato!",62,"ATTENZIONE")
   RETURN
ENDIF


*** CANCELLAZIONE DEI RECORDS DELLE TABELLE U_DIS_TT/DD SQL
WAIT WINDOWS "Cancellazione vecchie Distinte base esistenti...  -  Prego Attendere" NOWAIT
cSql = "delete from U_DIS_TT where 1=1"
IF !ExecCommand(cSql,"U_DIS_TT")
   return(.f.)
ENDIF
cSql = "delete from U_DIS_DD where 1=1"
IF !ExecCommand(cSql,"U_DIS_DD")
   return(.f.)
ENDIF


*** DEFINIZIONE CURSORI DI APPOGGIO
cSql = "Select * from U_DIS_TT where 1=0"
IF !ExecCommand(cSql,"CU_DIS_TT")
   return(.f.)
ENDIF
INDEX ON ALLTRIM(DIT_GRUPPO) TAG I_GRUPPO
cSql = "Select * from U_DIS_DD where 1=0"
IF !ExecCommand(cSql,"CU_DIS_DD")
   return(.f.)
ENDIF
INDEX ON ALLTRIM(DIS_GRUPPO)+ALLTRIM(DIS_CODART) TAG I_GRUART ADDITIVE
INDEX ON ALLTRIM(STR(DIS_SEQUEN,10,0)) TAG D_SEQUEN DESCENDING ADDITIVE



*** ACQUISIZIONE DEI DATI DALLE TABELLE DBF DI PARTENZA
cSql = "Select * from U_DIS_TT where 1=0"
IF !ExecCommand(cSql,"CUR_DIS_TT")
   return(.f.)
ENDIF
SELECT CUR_DIS_TT
SET FILTER TO
*APPEND FROM &V_PATH_TT
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_TT) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012
cSql = "Select * from U_DIS_DD where 1=0"
IF !ExecCommand(cSql,"CUR_DIS_DD")
   return(.f.)
ENDIF
SELECT CUR_DIS_DD
INDEX ON DAGGANCIO TAG I_INDICE
*APPEND FROM &V_PATH_DD
**=> ERASMO - INIZIO 12/12/2012
_COMMAND = "APPEND FROM '" + ALLTRIM(V_PATH_DD) + "'"
&_COMMAND
**=> ERASMO - FINE 12/12/2012



_V_CONTA1  = 0
_V_CONTA2  = 0


*** LOOP DI SCRITTURA DATI
SELECT CUR_DIS_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione TESTATA delle Distinte base " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT

   SELECT CU_DIS_TT
   APPEND BLANK
   DO U_DIS_TT
   _V_CONTA1 = _V_CONTA1 + 1

   SELECT CUR_DIS_TT
   SKIP +1
ENDDO

*** SCRITTURA DEI DATI SUL DB SQL
IF _V_CONTA1 > 0
   WAIT WINDOWS "Scrittura archivi Distinte base sul DataBase In Corso... -- Prego Attendere --" nowait
   IF !ExecRW('','u_dis_tt','I','','CU_DIS_TT')
      return(.f.)
   ENDIF
   _V_OKELAB = .T.
ENDIF



SELECT CUR_DIS_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   WAIT WINDOWS "Conversione DETTAGLI delle Distinte base " + ALLTRIM(STR(RECNO(),6,0)) + " di " + ALLTRIM(STR(RECCOUNT(),6,0)) + ;
                " in corso...  -  Prego Attendere" NOWAIT


   IF ALLTRIM(M.DIS_UM) = "N"	&& 2012/10/11 FORZA COME UNITA' DI MISURA NR
	   M.DIS_UM = "NR"
   ENDIF
	
   SELECT CU_DIS_DD
   APPEND BLANK
   DO U_DIS_DD
   _V_CONTA2 = _V_CONTA2 + 1

   SELECT CUR_DIS_DD
   SKIP +1

ENDDO


IF _V_CONTA2 > 0
   IF !ExecRW('','u_dis_dd','I','','CU_DIS_DD')
      return(.f.)
   ENDIF
   WAIT CLEAR
   _V_OKELAB = .T.
ENDIF




RETURN





**************************************************
FUNCTION CARDIOLINE_DECODIFICA_CODICE_IVA
**************************************************
** decodifica il codice iva riportandolo da 4 a 3 chr
PARA _codiva

_PARIVA = ALLTRIM(_codiva)


DO CASE

	CASE _PARIVA  	= "20BL"
		_PARIVA  	= "20L"

	CASE _PARIVA  	= "20BS"
		_PARIVA  	= "20S"

	CASE _PARIVA  	= "20IN"
		_PARIVA  	= "20N"		
		
	CASE _PARIVA  	= "20RC"
		_PARIVA  	= "20C"				
		
	CASE _PARIVA  	= "20SE"
		_PARIVA  	= "20E"				


	CASE _PARIVA  	= "21BL"
		_PARIVA  	= "21L"

	CASE _PARIVA  	= "21BS"
		_PARIVA  	= "21S"

	CASE _PARIVA  	= "21IN"
		_PARIVA  	= "21N"		
		
	CASE _PARIVA  	= "21RC"
		_PARIVA  	= "21C"				
		
	CASE _PARIVA  	= "21SE"
		_PARIVA  	= "21E"				

	CASE _PARIVA  	= "NI 1"
		_PARIVA  	= "NI1"				

	CASE _PARIVA  	= "NI 2"
		_PARIVA  	= "NI2"		

	CASE _PARIVA  	= "NI 3"
		_PARIVA  	= "NI3"		

	CASE _PARIVA  	= "2017"
		_PARIVA  	= "201"		

	CASE _PARIVA  	= "2180"
		_PARIVA  	= "218"
		
	CASE _PARIVA  	= "2280"
		_PARIVA  	= "228"
		
	CASE _PARIVA  	= "21AR"
		_PARIVA  	= "21R"
		
	CASE _PARIVA  	= "22AR"
		_PARIVA  	= "22R"

ENDCASE



IF LEN(_PARIVA) > 3
	_PARIVA = SUBSTR(_PARIVA,1,1) + SUBSTR(_PARIVA,3,2) 	&& TOGLIE IL SECONDO CARATTERE
ENDIF


RETURN(_PARIVA)



**************************************************
FUNCTION CARDIOLINE_DECODIFICA_CODICE_CPA
**************************************************
** decodifica il codice condizioni di pagamento riportandolo da 4 a 3 chr
PARA _codcpa

_PARCPA = ALLTRIM(_codcpa)



DO CASE

	CASE _PARCPA  	= "004"
		_PARCPA  	= "304"

	CASE _PARCPA  	= "97"
		_PARCPA  	= "397"

	CASE _PARCPA  	= "100"
		_PARCPA  	= "301"

	CASE _PARCPA  	= "175"
		_PARCPA  	= "375"

	CASE _PARCPA  	= "176"
		_PARCPA  	= "376"

	CASE _PARCPA  	= "204"
		_PARCPA  	= "324"

	CASE _PARCPA  	= "C101"
		_PARCPA  	= "C17"

	CASE _PARCPA  	= "C102"
		_PARCPA  	= "C18"

	CASE _PARCPA  	= "C103"
		_PARCPA  	= "C19"

	CASE _PARCPA  	= "C104"
		_PARCPA  	= "C20"

	CASE _PARCPA  	= "C105"
		_PARCPA  	= "C21"

	CASE _PARCPA  	= "V101"
		_PARCPA  	= "V23"

	CASE _PARCPA  	= "V102"
		_PARCPA  	= "V24"

	CASE _PARCPA  	= "V103"
		_PARCPA  	= "V25"

	CASE _PARCPA  	= "V104"
		_PARCPA  	= "V26"

	CASE _PARCPA  	= "V105"
		_PARCPA  	= "V27"

	CASE _PARCPA  	= "V201"
		_PARCPA  	= "V28"

	CASE _PARCPA  	= "V202"
		_PARCPA  	= "V29"

	CASE _PARCPA  	= "V203"
		_PARCPA  	= "V30"

	CASE _PARCPA  	= "V208"
		_PARCPA  	= "V31"

	CASE _PARCPA  	= "V211"
		_PARCPA  	= "V32"

	CASE _PARCPA  	= "V212"
		_PARCPA  	= "V33"

	CASE _PARCPA  	= "V213"
		_PARCPA  	= "V34"

	CASE _PARCPA  	= "V214"
		_PARCPA  	= "V35"

	CASE _PARCPA  	= "V306"
		_PARCPA  	= "V36"

	CASE _PARCPA  	= "V309"
		_PARCPA  	= "V37"

	CASE _PARCPA  	= "V310"
		_PARCPA  	= "V38"

ENDCASE

IF LEN(_PARCPA) > 3

	IF SUBSTR(_PARCPA,1,1) = '0'
		IF SUBSTR(_PARCPA,2,1) <> '0'
			_PARCPA = SUBSTR(_PARCPA,2,3) 							&& TOGLIE IL PRIMO CARATTERE	
		ELSE
			_PARCPA = SUBSTR(_PARCPA,1,1) + SUBSTR(_PARCPA,3,2) 	&& TOGLIE IL SECONDO CARATTERE
		ENDIF
	ELSE
		_PARCPA = SUBSTR(_PARCPA,1,1) + SUBSTR(_PARCPA,3,2) 		&& TOGLIE IL SECONDO CARATTERE
	ENDIF		
	
ENDIF


RETURN(_PARCPA)



**************************************************
FUNCTION CARDIOLINE_DECODIFICA_CODICE_VET
**************************************************
** decodifica il codice vettori riportandolo da 5 a 3 chr
PARA _codvet

_PARVET = ALLTRIM(_codvet)

DO CASE

	CASE _PARVET	= "168"
		_PARVET	= "00208"

	CASE _PARVET	= "187"
		_PARVET	= "00209"



ENDCASE



_PARVET = SUBSTR(_PARVET,3,3) 		&& CONSIIDERA I 3 CHR + SIGNIFICATIVI



RETURN(_PARVET)


**************************************************
FUNCTION CREA_U_VVA_CH_CARD
**************************************************
PARA _VALUTA,_DTVAL,_CAMBIO

AABBSScc    = SELECT()


v_seek	 = 'VVA'+_VALUTA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   _NOMVAL=SUBSTR(DESCRI,1,30)
ELSE
   _NOMVAL=""
ENDIF


M.VVA_CODSOC = PUB_CODSOC
M.VVA_CODVAL = _VALUTA
M.VVA_NOMVAL = _NOMVAL
M.VVA_DATA   = _DTVAL
M.VVA_CHANGE = _CAMBIO


x_codi = "VVA_CODVAL = '_VALUTA'"
x_dtva = "VVA_DATA = '_DTVAL'"
x_cond = x_codi + " and " + x_dtva
cSql = "select * from U_VVA_CH where " + x_cond
IF !ExecRW(cSql,"U_VVA_CH","R")
   return(.f.)
ENDIF
SELECT U_VVA_CH
GO TOP
IF EOF()
   APPEND BLANK
   DO U_VVA_CH
ENDIF
REPLACE VVA_CHANGE WITH _CAMBIO
IF !ExecRW(cSql,"U_VVA_CH","W")
   return(.f.)
ENDIF



SELECT(AABBSScc)

RETURN


**************************************************
FUNCTION CONVERTE_CODICI_CAUSALI_DOCUMENTI_ASSOLO
**************************************************



AABBSScc    = SELECT()

SELECT CU_INPUT
GO TOP 

DO WHILE !EOF()


    SCATTER MEMVAR MEMO
					
	M.CODICE 	= "TOP"+ALLTRIM(M.CodiceCauDocu)
   	M.DESCRI 	= ALLTRIM(M.Descrizione)
	
	_TIPO_DOC = "ALTRO DOC"
	IF "FATT" $ UPPER(ALLTRIM(M.Descrizione))
		_TIPO_DOC = "FATTURA"
	ENDIF
	IF "NOTA" $ UPPER(ALLTRIM(M.Descrizione))
		_TIPO_DOC = "NOTA CR"
	ENDIF

	*!*	NOTA CREDITO RUMI
	*!*	FATTURA ITALIA RUMI IMMEDIATA
    
    DO CASE 
    	CASE _TIPO_DOC = "FATTURA"
			M.FAT = "S"
			M.NOTA= "N"
			
    	CASE _TIPO_DOC = "NOTA CR"
			M.FAT = "S"
			M.NOTA= "S"
    	
		OTHERWISE    
			M.FAT = "N"
			M.NOTA= "N"  
    ENDCASE
    	
		
    _TIPO_		= ALLTRIM(M.CliFor)
    
    IF _TIPO_	= "C" 
    	M.NAT	= "D"	&& VENDITE
    ELSE
    	M.NAT	= "A"	&& ACQUISTI
    ENDIF

	IF "INCASS" $ UPPER(ALLTRIM(M.Descrizione))		&& INCASSO
    	M.FAT = "P"
    	M.NOTA= "N"
    	M.NAT = "A"
    ENDIF


	IF "INSOLUT" $ UPPER(ALLTRIM(M.Descrizione))	&& INSOLUTO
    	M.FAT = "I"
    	M.NOTA= "N"
    	M.NAT = "D"
    ENDIF

	IF "PAGAMEN" $ UPPER(ALLTRIM(M.Descrizione))	&& PAGAMENTO
    	M.FAT = "P"
    	M.NOTA= "N"
    	M.NAT = "D"
    ENDIF
    
    IF M.FAT = "S"		&& BOLLATO IVA
    	M.BOLL='S'
    ELSE
    	M.BOLL='N'
    ENDIF


	M.RIC='N'

	IF "RIBA" $ UPPER(ALLTRIM(M.Descrizione))	&& RICEVUTA BANCARIA
    	M.RIC='S'
    	M.NAT='A'    	
    ELSE
    	M.RIC='N'
    ENDIF
  
    

    
    M.LIB='A'							&& CLIENTE/FORNITORE/ALTRO
	M.CREAPART='N'						&& CREAZIONE PARTITARI

    IF _TIPO_= "C"
    	M.LIB		='C'				&& CLIENTE
		M.CREAPART	='S'
	ELSE
	   	M.LIB		='F'				&& FORNITORE
		M.CREAPART	='S'
	ENDIF


	DO CASE
		CASE  M.FAT = "P"	&& PAGAMENTO
			M.CREAPART	='S'
		CASE  M.FAT = "I"	&& INSOLUTO
			M.CREAPART	='S'
	ENDCASE


	DO CASE
		CASE M.RIC='S'			&& RICEVUTA
	    	M.LIB		='C'	&& CLIENTE
			M.CREAPART	='S'
	ENDCASE

    M.TOP_COL			=SPACE(03)
    
    M.NO_AUT			=' '
    M.PR_NO				=' '
    M.PR_SI				=' '
    M.PR_TOP			=' '
    M.PR_ANA			=' '
    M.PR_LIS			=' '
    M.PR_LAN			=' '
	M.AGGANCIAPARTITARI	=' '		&& AGGANCIA PARTITARI ANCHE PER LE PARTITE CHIUSE

    M.CEE=' '
    
    _CERCA_PAROLA_CEE = "CEE"
    _POSIZIONE_PAROLA_CEE = AT(_CERCA_PAROLA_CEE,M.Descrizione)   
    IF _POSIZIONE_PAROLA_CEE <> 0
    	M.CEE='E'
    ENDIF
    _CERCA_PAROLA_REVERSE = "REVERSE"
    _POSIZIONE_PAROLA_REVERSE = AT(_CERCA_PAROLA_REVERSE,M.Descrizione)   
    IF _POSIZIONE_PAROLA_REVERSE <> 0
    	M.CEE='R'
    ENDIF
 
   
    M.INTRA				=' '
    M.CSC				=' '
    M.IMPE				=' '
    M.RFOR				=' '
    M.RCLI				=' '
    M.CLAV				=' '
    M.CDEP				=' '
    M.IL_CCO			=' '
    M.IN_CCO			=' '
	M.TMOV   			= SPACE(02)
	M.CONCAU 			= SPACE(03)
	M.TPROC  			= SPACE(03)    

	M.FASCIACOMPETENZA	='C'							&& CONTABILE

	IF "FATT" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='F'						&& FATTURE VEN/ACQ
    ENDIF

	IF "NOTA" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='F'						&& NOTE CREDITO/DEBITO
    ENDIF

	IF "NOTE" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='F'						&& NOTE CREDITO/DEBITO
    ENDIF

	IF "TRASP" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='D'						&& DOCUMENTI DI TRASPORTO
    ENDIF

	IF "OFFE" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='P'						&& OFFERTE
    ENDIF


	IF "ORDI" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='O'						&& ORDINI
    ENDIF

	IF "INVEN" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='M'						&& MAGAZZINO
    ENDIF

	IF "CARIC" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='M'						&& MAGAZZINO
    ENDIF

	IF "SCARI" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='M'						&& MAGAZZINO
    ENDIF




	M.RPRO   			= SPACE(01)

	M.CANT				= SPACE(01)
	M.NOQUADRA 			= SPACE(01)
	M.CALCIMPOS			= SPACE(01)
	M.PINCAMULTI		= SPACE(01)
	M.CONTRCCO  		= SPACE(01)
	M.SITFIN    		= SPACE(01)
	M.SITCPA			= SPACE(01)
	M.NOCOMMESSA		= SPACE(01)
    M.VENACQ 			= SPACE(02)



    M.LIBERA=M.NAT+M.FAT+'      '+M.BOLL+M.RIC+M.NOTA+M.LIB+M.TOP_COL+M.NO_AUT+M.PR_NO+M.PR_SI+M.PR_TOP+M.PR_ANA+M.PR_LIS+M.PR_LAN+M.CEE+M.INTRA+M.CSC+M.IMPE+M.RFOR+M.RCLI+M.CLAV+M.CDEP+M.IL_CCO+M.IN_CCO+M.TMOV+M.CONCAU+M.TPROC+M.CREAPART+M.FASCIACOMPETENZA+M.RPRO+M.AGGANCIAPARTITARI+M.CANT+m.noquadra+M.calcimpos+m.pincamulti+m.contrcco+m.sitfin+M.VENACQ+m.sitcpa+m.nocommessa
   

 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT CU_INPUT
	SKIP

ENDDO


SELECT(AABBSScc)

RETURN(.T.)

**************************************************
FUNCTION CONVERTE_CODICI_CAUSALI_MAGAZZINO_ASSOLO
**************************************************

AABBSScc    = SELECT()

SELECT CU_INPUT_MAG
GO TOP 

DO WHILE !EOF()


*!*	CodiceCauMaga
*!*	Descrizione
*!*	CausaleCocat
*!*	Raggruppamento
*!*	Magazzino
*!*	Giacenza
*!*	Vendite
*!*	Acquisti
*!*	Produzione
*!*	Resi
*!*	Impegni
*!*	OrdiniFornitori
*!*	Costi
*!*	Ricavi
*!*	EsplodeDB
*!*	LivelloMinimo
*!*	EsplodeConf
*!*	MonoLivello



    SCATTER MEMVAR MEMO
					
	M.CODICE 	= "TOP"+ALLTRIM(M.CodiceCauMaga)
   	M.DESCRI 	= ALLTRIM(M.Descrizione)
	
	
	cSql = "select * from PARA where CODICE ='TOP"+ALLTRIM(M.CodiceCauMaga)+"'"
	IF !ExecCommand(cSql,"___temp_top")
	   RETURN .F.
	ENDIF
	SELECT ___temp_top
	GO TOP
	IF !EOF()
		SELECT CU_INPUT_MAG
		SKIP+1
		LOOP
    ENDIF       
	
	
	SELECT CU_INPUT_MAG
	
	
	
	_TIPO_DOC = "ALTRO DOC"
	IF "FATT" $ UPPER(ALLTRIM(M.Descrizione))
		_TIPO_DOC = "FATTURA"
	ENDIF
	IF "NOTA DI CR" $ UPPER(ALLTRIM(M.Descrizione))
		_TIPO_DOC = "NOTA DI CR"
	ENDIF
	IF "NOTA DI DE" $ UPPER(ALLTRIM(M.Descrizione))
		_TIPO_DOC = "NOTA DI DE"
	ENDIF
	IF "BOLLA" $ UPPER(ALLTRIM(M.Descrizione))
		_TIPO_DOC = "BOLLA" 
	ENDIF


	*!*	NOTA CREDITO RUMI
	*!*	FATTURA ITALIA RUMI IMMEDIATA
    
    DO CASE 
    	CASE _TIPO_DOC = "FATTURA"
			M.FAT = "S"
			M.NOTA= "N"
			
    	CASE _TIPO_DOC = "NOTA DI CR"
			M.FAT = "S"
			M.NOTA= "S"
    	
     	CASE _TIPO_DOC = "NOTA DI DE"
			M.FAT = "S"
			M.NOTA= "S"
   	
    	
		OTHERWISE    
			M.FAT = "N"
			M.NOTA= "N"  
    ENDCASE
    	
		
    M.NAT	= M.Giacenza	
   
    IF M.NAT	= "N" 
    	M.NAT	= "C"	
    ENDIF

    
    IF M.FAT = "S"		&& BOLLATO IVA
    	M.BOLL='S'
    ELSE
    	M.BOLL='N'
    ENDIF


	M.RIC='N'

     
    M.LIB='A'							&& CLIENTE/FORNITORE/ALTRO
	M.CREAPART='N'						&& CREAZIONE PARTITARI

    M.TOP_COL			=SPACE(03)
    
    M.NO_AUT			=' '
    M.PR_NO				=' '
    M.PR_SI				=' '
    M.PR_TOP			=' '
    M.PR_ANA			=' '
    M.PR_LIS			=' '
    M.PR_LAN			=' '
	M.AGGANCIAPARTITARI	=' '		&& AGGANCIA PARTITARI ANCHE PER LE PARTITE CHIUSE

    M.CEE=' '
    
  
    M.INTRA				=' '
    M.CSC				=' '
    M.IMPE				=' '
    M.RFOR				=' '
    M.RCLI				=' '
    M.CLAV				=' '
    M.CDEP				=' '
    M.IL_CCO			=' '
    M.IN_CCO			=' '
	M.TMOV   			= SPACE(02)
	M.CONCAU 			= SPACE(03)
	M.TPROC  			= SPACE(03)    

	M.FASCIACOMPETENZA	='M'							&& MAGAZZINO

	M.RPRO   			= SPACE(01)

	M.CANT				= SPACE(01)
	M.NOQUADRA 			= SPACE(01)
	M.CALCIMPOS			= SPACE(01)
	M.PINCAMULTI		= SPACE(01)
	M.CONTRCCO  		= SPACE(01)
	M.SITFIN    		= SPACE(01)
	M.SITCPA			= SPACE(01)
	M.NOCOMMESSA		= SPACE(01)
    M.VENACQ 			= SPACE(02)



    M.LIBERA=M.NAT+M.FAT+'      '+M.BOLL+M.RIC+M.NOTA+M.LIB+M.TOP_COL+M.NO_AUT+M.PR_NO+M.PR_SI+M.PR_TOP+M.PR_ANA+M.PR_LIS+M.PR_LAN+M.CEE+M.INTRA+M.CSC+M.IMPE+M.RFOR+M.RCLI+M.CLAV+M.CDEP+M.IL_CCO+M.IN_CCO+M.TMOV+M.CONCAU+M.TPROC+M.CREAPART+M.FASCIACOMPETENZA+M.RPRO+M.AGGANCIAPARTITARI+M.CANT+m.noquadra+M.calcimpos+m.pincamulti+m.contrcco+m.sitfin+M.VENACQ+m.sitcpa+m.nocommessa
   

 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT CU_INPUT_MAG
	SKIP

ENDDO


SELECT(AABBSScc)

RETURN(.T.)



**************************************************
FUNCTION CONVERTE_CODICI_CAUSALI_CONTABILI_ASSOLO
**************************************************

AABBSScc    = SELECT()



*!*	CAMPI DA CONVERTIRE

*!*	TABELLA CAUSALI_CONTABILI
*!*	Causale
*!*	Descrizione
*!*	TipoRegistroIVA
*!*	FlagAmmortamenti
*!*	FlagRAP
*!*	CodiceRAP
*!*	AliquotaRAP
*!*	SubCodiceRAP
*!*	PercImponibileRAP
*!*	FlagINPS
*!*	AliquotaINPS
*!*	PercImponibileINPS
*!*	QuotaCommittente
*!*	TipoScadenze
*!*	Sezione
*!*	FlagVisualizzaDA
*!*	VecchiaDescrizione
*!*	Impostazioni
*!*	IncassiPagamenti
*!*	TipoIncassoPagamento
*!*	Storno
*!*	TipoDocumentoAE




SELECT CU_INPUT_CONTAB
GO TOP 

DO WHILE !EOF()


    SCATTER MEMVAR MEMO
					
	M.CODICE 	= "TOP"+ALLTRIM(M.Causale)
   	M.DESCRI 	= ALLTRIM(M.Descrizione)
	
	_TIPO_DOC = "ALTRO DOC"
	IF "FATT" $ UPPER(ALLTRIM(M.Descrizione))
		_TIPO_DOC = "FATTURA"
	ENDIF
	IF "NOTA" $ UPPER(ALLTRIM(M.Descrizione))
		_TIPO_DOC = "NOTA CR"
	ENDIF

	IF "ACQUIST" $ UPPER(ALLTRIM(M.Descrizione))
		_TIPO_DOC = "AQUIST"
	ENDIF

	IF "FORNIT" $ UPPER(ALLTRIM(M.Descrizione))
		_TIPO_DOC = "FORNIT"
	ENDIF



    M.NAT = "D"	   
    DO CASE 
    	CASE _TIPO_DOC = "FATTURA"
			M.FAT = "S"
			M.NOTA= "N"
			
			
			
    	CASE _TIPO_DOC = "NOTA CR"
			M.FAT = "S"
			M.NOTA= "S"
 
     	CASE _TIPO_DOC = "AQUIST"
			M.FAT = "S"
			M.NOTA= "S"
   			M.NAT = "A"	
   			
     	CASE _TIPO_DOC = "FORNIT"
			M.FAT = "S"
			M.NOTA= "S"
   			M.NAT = "A"	
   	
		OTHERWISE    
			M.FAT = "N"
			M.NOTA= "N"  
    ENDCASE
    	

	IF "INCASS" $ UPPER(ALLTRIM(M.Descrizione))		&& INCASSO
    	M.FAT = "P"
    	M.NOTA= "N"
    	M.NAT = "A"
    ENDIF


	IF "INSOLUT" $ UPPER(ALLTRIM(M.Descrizione))	&& INSOLUTO
    	M.FAT = "I"
    	M.NOTA= "N"
    	M.NAT = "D"
    ENDIF

	IF "PAGAT" $ UPPER(ALLTRIM(M.Descrizione))		&& PAGAMENTO
    	M.FAT = "P"
    	M.NOTA= "N"
    	M.NAT = "D"
    ENDIF
    
    IF M.FAT = "S"									&& BOLLATO IVA
    	M.BOLL='S'
    ELSE
    	M.BOLL='N'
    ENDIF


	M.RIC='N'

	IF "RIBA" $ UPPER(ALLTRIM(M.Descrizione))		&& RICEVUTA BANCARIA
    	M.RIC='S'
    	M.NAT='A'    	
    ELSE
    	M.RIC='N'
    ENDIF
  
   

    
    M.LIB='A'							&& CLIENTE/FORNITORE/ALTRO
	M.CREAPART='N'						&& CREAZIONE PARTITARI

*!*	    IF _TIPO_= "C"
*!*	    	M.LIB		='C'				&& CLIENTE
*!*			M.CREAPART	='S'
*!*		ELSE
*!*		   	M.LIB		='F'				&& FORNITORE
*!*			M.CREAPART	='S'
*!*		ENDIF



	IF "FATT" $ UPPER(ALLTRIM(M.Descrizione))		&& FATTURE
    	M.FAT = "S"
    	M.NOTA= "N"
    	M.NAT = "D"
		M.CREAPART	='S'
    ENDIF


	IF "EMESSO" $ UPPER(ALLTRIM(M.Descrizione))		&& FATTURE EMESSE
    	M.FAT = "S"
    	M.NAT = "D"
		M.CREAPART	='S'
    ENDIF
    
	IF "RICEVUT" $ UPPER(ALLTRIM(M.Descrizione))	&& FATTURE RICEVUTE
    	M.FAT = "S"
    	M.NAT = "A"
		M.CREAPART	='S'
    ENDIF
        
	IF "SCHEDA" $ UPPER(ALLTRIM(M.Descrizione))		&& FATTURE SCHEDE CARBURANTI
    	M.FAT = "S"
    	M.NAT = "A"
		M.CREAPART	='S'
    ENDIF
        
	IF "NOTA" $ UPPER(ALLTRIM(M.Descrizione))		&& NOTE CREDITO
    	M.FAT = "S"
    	M.NOTA= "S"
    	M.NAT = "D"
		M.CREAPART	='S'
    ENDIF

	IF "PAGAT" $ UPPER(ALLTRIM(M.Descrizione))		&& PAGAMENTO
    	M.FAT = "P"
    	M.NOTA= "N"
    	M.NAT = "D"
		M.CREAPART	='S'
    ENDIF


	DO CASE
		CASE  M.FAT = "P"	&& PAGAMENTO
			M.CREAPART	='S'
		CASE  M.FAT = "I"	&& INSOLUTO
			M.CREAPART	='S'
	ENDCASE


	DO CASE
		CASE M.RIC='S'			&& RICEVUTA
	    	M.LIB		='C'	&& CLIENTE
			M.CREAPART	='S'
	ENDCASE

    M.TOP_COL			=SPACE(03)
    
    M.NO_AUT			=' '
    M.PR_NO				=' '
    M.PR_SI				=' '
    M.PR_TOP			=' '
    M.PR_ANA			=' '
    M.PR_LIS			=' '
    M.PR_LAN			=' '
	M.AGGANCIAPARTITARI	=' '		&& AGGANCIA PARTITARI ANCHE PER LE PARTITE CHIUSE

    M.CEE=' '
    
    _CERCA_PAROLA_CEE = "CEE"
    _POSIZIONE_PAROLA_CEE = AT(_CERCA_PAROLA_CEE,M.Descrizione)   
    IF _POSIZIONE_PAROLA_CEE <> 0
    	M.CEE='E'
    ENDIF
    _CERCA_PAROLA_REVERSE = "REVERSE"
    _POSIZIONE_PAROLA_REVERSE = AT(_CERCA_PAROLA_REVERSE,M.Descrizione)   
    IF _POSIZIONE_PAROLA_REVERSE <> 0
    	M.CEE='R'
    ENDIF
 
   
    M.INTRA				=' '
    M.CSC				=' '
    M.IMPE				=' '
    M.RFOR				=' '
    M.RCLI				=' '
    M.CLAV				=' '
    M.CDEP				=' '
    M.IL_CCO			=' '
    M.IN_CCO			=' '
	M.TMOV   			= SPACE(02)
	M.CONCAU 			= SPACE(03)
	M.TPROC  			= SPACE(03)    

	M.FASCIACOMPETENZA	='C'							&& CONTABILE

	IF "FATT" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='F'						&& FATTURE VEN/ACQ
    ENDIF

	IF "NOTA" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='F'						&& NOTE CREDITO/DEBITO
    ENDIF

	IF "NOTE" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='F'						&& NOTE CREDITO/DEBITO
    ENDIF

	IF "TRASP" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='D'						&& DOCUMENTI DI TRASPORTO
    ENDIF

	IF "OFFE" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='P'						&& OFFERTE
    ENDIF


	IF "ORDI" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='O'						&& ORDINI
    ENDIF

	IF "INVEN" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='M'						&& MAGAZZINO
    ENDIF

	IF "CARIC" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='M'						&& MAGAZZINO
    ENDIF

	IF "SCARI" $ UPPER(ALLTRIM(M.Descrizione))
		M.FASCIACOMPETENZA	='M'						&& MAGAZZINO
    ENDIF




	M.RPRO   			= SPACE(01)

	M.CANT				= SPACE(01)
	M.NOQUADRA 			= SPACE(01)
	M.CALCIMPOS			= SPACE(01)
	M.PINCAMULTI		= SPACE(01)
	M.CONTRCCO  		= SPACE(01)
	M.SITFIN    		= SPACE(01)
	M.SITCPA			= SPACE(01)
	M.NOCOMMESSA		= SPACE(01)
    M.VENACQ 			= SPACE(02)



    M.LIBERA=M.NAT+M.FAT+'      '+M.BOLL+M.RIC+M.NOTA+M.LIB+M.TOP_COL+M.NO_AUT+M.PR_NO+M.PR_SI+M.PR_TOP+M.PR_ANA+M.PR_LIS+M.PR_LAN+M.CEE+M.INTRA+M.CSC+M.IMPE+M.RFOR+M.RCLI+M.CLAV+M.CDEP+M.IL_CCO+M.IN_CCO+M.TMOV+M.CONCAU+M.TPROC+M.CREAPART+M.FASCIACOMPETENZA+M.RPRO+M.AGGANCIAPARTITARI+M.CANT+m.noquadra+M.calcimpos+m.pincamulti+m.contrcco+m.sitfin+M.VENACQ+m.sitcpa+m.nocommessa
   

 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT CU_INPUT_CONTAB
	SKIP

ENDDO


SELECT(AABBSScc)

RETURN(.T.)



*************************************************************
FUNCTION CONVERTE_DETTAGLIO_CODICI_CAUSALI_CONTABILI_EUROCONT
*************************************************************

AABBSScc    = SELECT()

*!*	TABELLA INPUT DETTAGLI CAUSALI CONTABILI
*!*	Causale
*!*	RigaCausale
*!*	CodicePC
*!*	CodiceANA
*!*	DareAvere
*!*	ImportoFormula
*!*	AliquotaIVA
*!*	TotaleDocumento
*!*	CodiceConto

*!*	TABELLA OUTPUT U_CCO_LE DETTAGLIO CAUSALI CONTABILI
*!*	id_unique
*!*	LEG_CODSOC
*!*	LEG_CODTOP
*!*	LEG_DESTOP
*!*	LEG_CODCON
*!*	LEG_DESCON
*!*	LEG_PERCEN
*!*	LEG_NATURA
*!*	LEG_IMPFIS
*!*	LEG_CODIVA
*!*	LEG_DESIVA
*!*	LEG_CODGRU
*!*	LEG_DESGRU
*!*	LEG_CODCCO
*!*	LEG_DESCCO
*!*	LEG_SEQUEN
*!*	LEG_VALORE
*!*	LEG_CODSYS
*!*	LEG_VALOLD


SELECT CU_INPUT_DETT_CONTAB
GO TOP 

DO WHILE !EOF()


    SCATTER MEMVAR MEMO
	M.LEG_CODTOP 	= ALLTRIM(M.Causale)
 
	v_seek	 = 'TOP'+M.LEG_CODTOP
	v_chiave ="codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARAXX')
	    
	    SELECT CUR_PARAXX
	    M.LEG_DESTOP = SUBSTR(DESCRI,1,30)								&& DESCRIZIONE CAUSALE

	 	M.IL_CCO	= "S"	&& GESTIONE TIPI OPERAZIONI CON CONTROPARTITE ILLIMITATE (POSIZIONE IN LIBERA: 31
	    _LIBERA = SUBSTR(LIBERA,1,30) + M.IL_CCO + SUBSTR(LIBERA,32,249)
    	REPLACE LIBERA WITH _LIBERA 		

	    IF !ExecRW('','PARA','I','','CUR_PARAXX')
	        return(.f.)
	    ENDIF		

	ELSE
	    M.LEG_DESTOP = "XXXXXXXXXXXXXXXXXXXXXXXXX"   
	ENDIF  



    x_soci = "con_soc = '" + PUB_CODSOC + "'"
    x_anno = "con_anno = '" + PUB_ANNO + "'"
    x_codi = "con_conto = '" + ALLTRIM(M.CodiceConto) + "'"				&& M.CODICECONTO 1,1,2,3 .....
    x_cond = x_soci + " and " + x_anno + " and " + x_codi
    cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
    IF !ExecCommand(cSql,"cu_conti")
	  return(.f.)
    ENDIF
    SELECT cu_conti	
    IF EOF()
	   M.LEG_DESCON = ""
    ELSE
	   M.LEG_DESCON = CON_DESCR											&& DESCRIZIONE CONTO CONTABILE
    ENDIF

	M.CODIVA1 		=CONV_CLEAR(M.AliquotaIVA)	
	M.CODIVA1   	=APITOSPA(ALLTRIM(M.CODIVA1)) 	
	M.LEG_CODIVA   	=CONVERTE_CODICE_IVA_ASSOLO(M.CODIVA1)


	v_seek	 = 'IVA'+M.LEG_CODIVA
	v_chiave ="codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARAXX')
	    SELECT CUR_PARAXX
	    M.LEG_DESIVA = SUBSTR(DESCRI,1,30)								&& DESCRIZIONE IVA
	ELSE
	    M.LEG_DESIVA = "XXXXXXXXXXXXXXXXXXXXXXXXX"   
	ENDIF  
	 
    M.LEG_SEQUEN= M.RigaCausale * 100

 	SELECT curs_U_CCO_LE												&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK

	REPLACE LEG_CODSOC WITH PUB_CODSOC
	REPLACE LEG_CODTOP WITH M.LEG_CODTOP 
	REPLACE LEG_DESTOP WITH M.LEG_DESTOP
	REPLACE LEG_CODCON WITH M.CodiceConto 								&& M.CODICECONTO 1,1,2,3 ..... CODICEPC 001001002003
	REPLACE LEG_DESCON WITH M.LEG_DESCON
	REPLACE LEG_PERCEN WITH 0
	REPLACE LEG_NATURA WITH M.DareAvere
	REPLACE LEG_IMPFIS WITH 0
	REPLACE LEG_CODIVA WITH M.LEG_CODIVA
	REPLACE LEG_DESIVA WITH M.LEG_DESIVA
	REPLACE LEG_CODGRU WITH ""
	REPLACE LEG_DESGRU WITH ""
	REPLACE LEG_CODCCO WITH ""
	REPLACE LEG_DESCCO WITH ""
	REPLACE LEG_SEQUEN WITH M.LEG_SEQUEN
	REPLACE LEG_VALORE WITH 0
	REPLACE LEG_CODSYS WITH SYS(2015)
	REPLACE LEG_VALOLD WITH 0
	


    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT



	SELECT CU_INPUT_DETT_CONTAB    
	SKIP

ENDDO





SELECT(AABBSScc)


RETURN(.T.)


*************************************************************
FUNCTION RIPORTA_PERCENTUALE_SULLE_RIGHE_TOP_EUROCONT
*************************************************************

AABBSScc    = SELECT()


** ELABORA I DETTAGLI DEI TIPI OPERAZIONE PER POTER RIPORTARE LA PERCENTUALE DI RIPARTIZIONE E/O ALTRE FORMULE
x_cond= "leg_codsoc = '" + PUB_CODSOC + "'"
cSql = "select leg_codtop from U_CCO_LE group by leg_codtop order by leg_codtop"
IF !ExecCommand(cSql,"CUR_TOP")
   RETURN .F.
ENDIF
SELECT CUR_TOP
GO TOP

DO WHILE .NOT.EOF()


   	IF DELETED()
   	    SELECT CUR_TOP
	  	SKIP +1
	  	LOOP
   	ENDIF

    _TIPO_OPERAZIONE = LEG_CODTOP
    
	x_soci   = "leg_codsoc = '" + PUB_CODSOC + "'"
	x_top    = "leg_codtop= '" + ALLTRIM(_TIPO_OPERAZIONE) + "'"
	x_cond = x_soci + " and " + x_top   

	cSql = "select * from U_CCO_LE where " + x_cond + " order by leg_codtop,leg_sequen"			&& RIGE DI DETTAGLIO DEL TIPO OPERAZIONE
	IF !ExecCommand(cSql,"CUR_RIGHE_TOP")
	   RETURN .F.
	ENDIF
	
	SELECT CUR_RIGHE_TOP
	GO TOP
	
	COUNT 						TO _TOT_RIGHE
	COUNT FOR LEG_NATURA = 'D' 	TO _TOT_RIGHE_DARE
	COUNT FOR LEG_NATURA = 'A' 	TO _TOT_RIGHE_AVERE
	
	SELECT CUR_RIGHE_TOP
	GO TOP
	
	** ELABORO LE RIGE DI DETTAGLIO DEL TIPO OPERAZIONE--------------------------------------------
	DO WHILE .NOT.EOF()


	   	IF DELETED()
	   	    SELECT CUR_TOP
		  	SKIP +1
		  	LOOP
	   	ENDIF

		DO CASE
		
			CASE _TOT_RIGHE_DARE 	= 1 		&& CASO DI 1 A MOLTI
		
				FOR nItem = 1 TO _TOT_RIGHE  
				   
				    IF LEG_NATURA = 'D' OR LEG_NATURA = 'A'
					   	IF LEG_NATURA = 'D'
					   		REPLACE LEG_PERCEN WITH  100 
					   	ELSE
					   		REPLACE LEG_PERCEN WITH  100 / _TOT_RIGHE_AVERE
					 	ENDIF	
					 ENDIF			   		

				ENDFOR	
				
		
			CASE _TOT_RIGHE_AVERE	= 1 		&& CASO DI 1 A MOLTI


				    IF LEG_NATURA = 'D' OR LEG_NATURA = 'A'
					   	IF LEG_NATURA = 'A'
					   		REPLACE LEG_PERCEN WITH  100 
					   	ELSE
					   		REPLACE LEG_PERCEN WITH  100 / _TOT_RIGHE_DARE
					 	ENDIF	
					 ENDIF			   		
			
			
			OTHERWISE 							&& CASO DI MOLTI/MOLTI A MOLTI
		
				    IF LEG_NATURA = 'D' OR LEG_NATURA = 'A'
					   	IF LEG_NATURA = 'A'
					   		REPLACE LEG_PERCEN WITH  100 / _TOT_RIGHE_AVERE
					   	ELSE
					   		REPLACE LEG_PERCEN WITH  100 / _TOT_RIGHE_DARE
					 	ENDIF	
					 ENDIF			   		
		
		
		ENDCASE


		
		SELECT CUR_RIGHE_TOP
		SKIP+1

	ENDDO 


	** EFFETTUA LA QUADRATURA DELLA PERCENTUALE SULLE RIGHE DARE/AVERE
	SELECT CUR_RIGHE_TOP
	GO TOP
	
	SUM LEG_PERCEN FOR LEG_NATURA = 'D' TO TOTALE_PERCENTUALE_DARE
 	SUM LEG_PERCEN FOR LEG_NATURA = 'A' TO TOTALE_PERCENTUALE_AVERE

	_DELTA_DARE  = 100 - TOTALE_PERCENTUALE_DARE 
	_DELTA_AVERE = 100 - TOTALE_PERCENTUALE_AVERE
	
	IF _DELTA_DARE > 0.01 OR _DELTA_DARE < 0.05
		IF _DELTA_DARE <> 0
			SELECT CUR_RIGHE_TOP
			SET FILTER TO LEG_NATURA = 'D'
			GO BOTTOM 
			REPLACE LEG_PERCEN WITH LEG_PERCEN + _DELTA_DARE 
			SET FILTER TO 
		ENDIF
	ENDIF
	
	IF _DELTA_AVERE > 0.01 OR _DELTA_AVERE  < 0.05
		IF _DELTA_AVERE <> 0
			SELECT CUR_RIGHE_TOP
			SET FILTER TO LEG_NATURA = 'A'
			GO BOTTOM 
			REPLACE LEG_PERCEN WITH LEG_PERCEN + _DELTA_AVERE 
			SET FILTER TO 
		ENDIF
	ENDIF
	
	


	SELECT CUR_RIGHE_TOP
	GO TOP

	****** AGGIORNA TABELLA U_CCO_LE SQL
	IF !ExecRW('','U_CCO_LE','I','','CUR_RIGHE_TOP')
	   return(.f.)
	ENDIF




	SELECT CUR_TOP
	SKIP+1

ENDDO 



SELECT(AABBSScc)


RETURN(.T.)



**********************************************
FUNCTION CONVERTE_CODICE_IVA_ASSOLO
**********************************************
PARA _codice_iva

_PARIVA = '022'

AABBSScc    = SELECT()

IF LEN(_codice_iva) > 3
	_PARIVA = SUBSTR(_codice_iva,1,1) + SUBSTR(_codice_iva,3,3)		&& CONSIDERA LE ULTIME 3 CIFRE DEL CODICE
ELSE
	_PARIVA = _codice_iva											&& CONSIDERA LE ULTIME 3 CIFRE DEL CODICE
ENDIF

SELECT(AABBSScc)

RETURN(_PARIVA)


***********************************************
FUNCTION CONVERTE_CODICE_CONTO_CONTABILE_ASSOLO
***********************************************
PARA _codice_conto

_CONTO_CONTABILE = 'XXXXXXXX'

AABBSScc    = SELECT()

_CONTO_CONTABILE  	=CONV_CLEAR(_codice_conto)	
_CONTO_CONTABILE    =APITOSPA(ALLTRIM(_CONTO_CONTABILE)) 	

*!*	TRASFORMA IL CODICE NUMERICO NEL FORMATO SIMILE AL PIANO DEI CONTI CEE 1.1.3 ......
_CONTO_CONTABILE=TRASFORMA_CODICE_CONTO_CONTABILE("CODICE_SIMILCEE",_CONTO_CONTABILE)


SELECT(AABBSScc)


RETURN(_CONTO_CONTABILE)


***********************************************
FUNCTION CREA_PARAMETRO_UM_ASSOLO
***********************************************
PARA _CODICE_UM

AABBSSccX    = SELECT()

x_codi = "codice = 'UMI"+_CODICE_UM+"'"
x_cond = x_codi
cSql = "select * from PARA where " + x_cond
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   V1 = "UMI"+_CODICE_UM
   REPLACE CODICE WITH V1
   REPLACE DESCRI WITH "UNITA' DI MISURA : "+ALLTRIM(_CODICE_UM)
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF



SELECT(AABBSSccX)


RETURN .T.




**********************************************
FUNCTION CONVERTE_CODICE_IVA_ZUCCHETTI
**********************************************
PARA _codice_iva

_PARIVA = '022'

AABBSScc    = SELECT()


DO CASE

	CASE SUBSTR(_codice_iva,1,2) = '  '
		_PARIVA = '022'
		

	CASE SUBSTR(_codice_iva,1,2) = '22'
		_PARIVA = '022'
		

	OTHERWISE
		_PARIVA = ALLTRIM(SUBSTR(_codice_iva,1,3))


ENDCASE



SELECT(AABBSScc)

RETURN(_PARIVA)


**********************************************
FUNCTION CONVERTE_CODICE_CPA_ZUCCHETTI
**********************************************
PARA _codice_cpa

_PARCPA = '001'

AABBSSccz    = SELECT()

DO CASE

	CASE EMPTY(ALLTRIM(_codice_cpa))
		_PARCPA = '001'
		
	OTHERWISE
		_PARCPA = ALLTRIM(SUBSTR(_codice_cpa,1,3))


ENDCASE





SELECT(AABBSSccz)

RETURN(_PARCPA)



**********************************************
FUNCTION DECODIFICA_TOP_ZUCCHETTI
**********************************************
LPARAMETERS _codice_TOP

_PARTOP = '001'

AABBSSccz = SELECT()

_codice_TOP = ALLTRIM(_codice_TOP)
_nLenTop = LEN(_codice_TOP)

DO CASE

	CASE _nLenTop = 3
		_PARTOP = _codice_TOP

	CASE _nLenTop = 4
		_PARTOP = SUBSTR(_codice_TOP,1,3)

	CASE _nLenTop = 5
		_PARTOP = SUBSTR(_codice_TOP,3,3)

	OTHERWISE
		_PARTOP = SUBSTR(_codice_TOP,1,3)

ENDCASE

SELECT(AABBSSccz)

RETURN(_PARTOP)



****************************************************************
FUNCTION INTERCETTA_DATI_CONTO
****************************************************************

	
	   M.CON_DESCR  = alltrim(m.descri)
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN


****************************************************************
FUNCTION INTERCETTA_DATI_SOTTOCONTO
****************************************************************


	
	   M.CON_DESCR  = alltrim(m.descri)
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN



****************************************************************
FUNCTION INTERCETTA_DATI_CONTO_ELEMENTARE
****************************************************************
	
	   M.CON_DESCR  = alltrim(m.descri)
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN

****************************************************************
FUNCTION COMPILA_ALTRI_DATI_PIANO_DEI_CONTI
****************************************************************

   m.id_unique = "" 				
   M.CON_SOC   = '01'
   M.CON_ANNO  = PUB_ANNO
   M.CON_TIPOCO = 'X'


   IF VAL(SUBSTR(M.CON_CONTO,1,(PUB_MASTRO -1)))  < 4		&& PATRIMONIALI
      PE_CORRENTE = 'P'
   ELSE
      PE_CORRENTE = 'E'
   ENDIF	
	


   M.CON_POSBIL = PE_CORRENTE


   IF SUBSTR(ALLTRIM(M.CON_CONTO),1,4) = "0105" 	&& MASTRO IVA
	    IF LEN(ALLTRIM(M.CON_CONTO)) > 4
       		M.CON_TIPOCO = 'I'						&& CONTO IVA
   		ENDIF
   ENDIF


*!*	#####################################################

   SELECT curs_CONTI					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   APPEND BLANK
   GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO

							
   _CTR = _CTR +1
   WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT





RETURN



***************************************************************************
FUNCTION CONV_TOGLIE_PUNTI
***************************************************************************
* RIPULISCE IL CAMPO DA CARATTERI SPORCHI
PARA __CAMPO_DA_RIPULIRE

IF ISNULL(__CAMPO_DA_RIPULIRE)
	__CAMPO_DA_RIPULIRE = ''
ENDIF

__CAMPO_DA_RIPULIRE = STRTRAN(__CAMPO_DA_RIPULIRE,".","")    		&& TOGLIE I PUNTI


	
RETURN(__CAMPO_DA_RIPULIRE)



***************************************************************************
FUNCTION CONV_ID_CLI_FOR
***************************************************************************
* VERIFICA SE PRESENTE NELL'ARCHIVIO DEI DOCUMENTI ASSOLO
PARA __CODICE_CLI_FOR,__TIPO_CLI_FOR,__ARCHIVIO_DOCUMENTI,__INDICE

AABBSSccz = SELECT()

LOCAL __TROVATO__
__TROVATO__ = .F.


   SELECT &__ARCHIVIO_DOCUMENTI
   SET ORDER TO &__INDICE
   GO TOP
   _SEEK = __CODICE_CLI_FOR+__TIPO_CLI_FOR
   SEEK _SEEK
   IF FOUND()
   		__TROVATO__ = .T.
   ENDIF


*!*		SELECT CU_INPUT_DOUMENTI
*!*		SET ORDER TO I_CODICE 
*!*	   	_SEEK = __CODICE_CLI_FOR+__TIPO_CLI_FOR
*!*	   	SEEK _SEEK
*!*	   	IF FOUND()
*!*	   		__TROVATO__ = .T.
*!*	   	ENDIF

SELECT(AABBSSccz)   
	
RETURN(__TROVATO__)


****************************************************************
FUNCTION INTERCETTA_DATI_CONTO 
****************************************************************
  
  
	   M.CON_DESCR  = alltrim(CONV_CLEAR(m.Titolo))
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN


****************************************************************
FUNCTION INTERCETTA_DATI_SOTTOCONTO 
****************************************************************

	   
	   M.CON_DESCR  = alltrim(CONV_CLEAR(m.Titolo))
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN



****************************************************************
FUNCTION INTERCETTA_DATI_CONTO_ELEMENTARE 
****************************************************************
	   
	   M.CON_DESCR  = ALLTRIM(CONV_CLEAR(M.TITOLO))
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   
   
       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN

****************************************************************
FUNCTION COMPILA_ALTRI_DATI_PIANO_DEI_CONTI
****************************************************************
*!*	CAMPI DA CONVERTIRE
*!*	CodicePC
*!*	TipoConto
*!*	Mastro
*!*	Titolo
*!*	RiclassificazioneCEE
*!*	RiclassificazioneAziendale
*!*	RiclassificazioneFiscale
*!*	RiclassificazioneCivile
*!*	Livello
*!*	MastroAnagrafico
*!*	CostiDaVentilare
*!*	ContoAmmortamenti
*!*	ContoSpese
*!*	ContoImponibileIVA
*!*	ContoIVA
*!*	ContoAnticipazioni
*!*	ContoPrevidenza
*!*	ContoBolli
*!*	ContoSoggettoRAP
*!*	ContoRAP
*!*	ContoSoggettoINPS
*!*	ContoINPS
*!*	ContoIRAP
*!*	GiroConto
*!*	MovimentaCdC
*!*	RiclassificazioneEsterna
*!*	TipoContoAllegatoIVA
*!*	CCDC


   m.id_unique = "" 				
   M.CON_SOC   = PUB_CODSOC
   M.CON_ANNO  = PUB_ANNO
   M.CON_TIPOCO = 'X'
   M.CON_TIPO_CONTO = STR(M.TipoConto,1,0)
 
   IF VAL(SUBSTR(M.CON_CONTO,1,1))  < 3			
      PE_CORRENTE = 'P'							&& PATRIMONIALI
   ELSE
      PE_CORRENTE = 'E'							&& ECONOMICI
   ENDIF	 
	     
   M.CON_POSBIL = PE_CORRENTE

  
*!*	   IF SUBSTR(ALLTRIM(M.CON_CONTO),1,4) = "1414" 	&& MASTRO IVA ####################################### DA GESTIRE
*!*		    IF LEN(ALLTRIM(M.CON_CONTO)) > 4 
*!*	       		M.CON_TIPOCO = 'I'						&& CONTO IVA
*!*	   		ENDIF
*!*	   ENDIF


*!*	#####################################################

   SELECT curs_CONTI					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   APPEND BLANK
   GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

							   
   _CTR = _CTR +1
   WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   




RETURN




****************************************************************
FUNCTION CREA_CONTI_CONTABILI_DA_CLIENTI_FORNITORI
****************************************************************


*!*	################################################# CREA PIANO DEI CONTI DA ANAGRAFICA CLIENTI #################################################

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

CCC=SUBSTR(LIBERA,1,4)

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP

CTRELAB = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

*!*		IF ALLTRIM(STR(VAL(CLI_CODCLI))) = '6055'
*!*			SET STEP ON
*!*		ENDIF

   CPA=CLI_CONPAG
   CLI=CLI_CODCLI +" " + SUBSTR(CLI_RAGSOC,1,30)

   V_ER = SOTTOGEN(CLI_NAZION)
   IF !V_ER
      CC = PUB_CC
   ELSE
      CCC= CCC
   ENDIF

   SELECT CUR_CLIENTI

   SCATTER MEMVAR MEMO

   XXX_CODCLI = CC + ALLTRIM(STR(VAL(M.CLI_CODCLI)))	&& TOGLIE GLI 0 NON SIGNIFICATIVI IN QUANTO IL CLIENTE NEL PIANO DEI CONTI E' MEMORIZZATO SENZA ZERI
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + PUB_ANNO + "'"
   x_cont = "con_conto = '" + XXX_CODCLI + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      RETURN .F.
   ENDIF
   SELECT CONTI
   GO TOP
   IF EOF()
	  SELECT curs_CONTI
	  APPEND BLANK
	  REPLACE CON_SOC    WITH PUB_CODSOC
	  REPLACE CON_ANNO   WITH PUB_ANNO
	  REPLACE CON_CONTO  WITH XXX_CODCLI
	  REPLACE CON_DESCR  WITH M.CLI_RAGSOC
	  REPLACE CON_TIPOCO WITH 'C'
	  REPLACE CON_POSBIL WITH 'P'
	  REPLACE CON_TIPO_CONTO WITH '1'
   ENDIF

   SELECT CUR_CLIENTI
   SKIP +1

ENDDO

*!*	################################################# CREA PIANO DEI CONTI DA ANAGRAFICA FORNITORI #################################################

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

FFF=SUBSTR(LIBERA,18,4)

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"CUR_FORNITORI")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORI
GO TOP

CTRELAB = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
*!*		IF ALLTRIM(STR(VAL(FOR_CODCLI))) = '6055'
*!*			SET STEP ON
*!*		ENDIF

   CPA=FOR_CONPAG

	V_ER = SOTTOGEN(FOR_NAZION)
	IF !V_ER
	    FF = PUB_FF
	ELSE
	    FFF= FFF
	ENDIF

   SELECT CUR_FORNITORI


   SCATTER MEMVAR MEMO

   XXX_CODFOR = FF + ALLTRIM(STR(VAL(M.FOR_CODCLI)))	&& TOGLIE GLI 0 NON SIGNIFICATIVI IN QUANTO IL FORNITORE NEL PIANO DEI CONTI E' MEMORIZZATO SENZA ZERI
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + PUB_ANNO + "'"
   x_cont = "con_conto = '" + XXX_CODfor + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      RETURN .F.
   ENDIF
   SELECT CONTI
   GO TOP
   IF EOF()
	  SELECT curs_CONTI
	  APPEND BLANK
	  REPLACE CON_SOC    WITH PUB_CODSOC
	  REPLACE CON_ANNO   WITH PUB_ANNO
	  REPLACE CON_CONTO  WITH XXX_CODFOR
	  REPLACE CON_DESCR  WITH M.FOR_RAGSOC
	  REPLACE CON_TIPOCO WITH 'F'
	  REPLACE CON_POSBIL WITH 'P'
	  REPLACE CON_TIPO_CONTO WITH '2'	  
   ENDIF

   SELECT CUR_FORNITORI
   SKIP +1

ENDDO



RETURN



****************************************************************
FUNCTION CONVERSIONE_FATTURE_AUTOMATICHE_DA_DDT_ASSOLO
****************************************************************

**SERGIO????????
*!*	DATI TESTATA DOCUMENTI DA CONVERTIRE
*!*	NumeroTestata
*!*	NumeroDoc
*!*	TipoDocumento
*!*	CliFor
*!*	Causale
*!*	Intestatario
*!*	DataDocumento
*!*	DataRegistra
*!*	TipoDocColl
*!*	NumDocColl
*!*	Destinatario
*!*	CodiceIndirizzo
*!*	DestDesc1
*!*	DestDesc2
*!*	DestDesc3
*!*	Magazzino1
*!*	Magazzino2
*!*	CodiceListino
*!*	CodicePag
*!*	Banca
*!*	XFatture
*!*	GiaFatturata
*!*	XCntbl
*!*	GiaCntbl
*!*	XMovimenti
*!*	GiaMovimenti
*!*	XEffetti
*!*	GiaEffetti
*!*	Valuta
*!*	Cambio
*!*	DataCambio
*!*	CodiceEseIva
*!*	Bolli
*!*	ImportoBolli
*!*	IvaBolli
*!*	Trasporto
*!*	SpeTrasporto
*!*	Porto
*!*	Imballo
*!*	SpeImballo
*!*	CodiceSpeAgg
*!*	SpeAgg
*!*	CausaleTrasp
*!*	Colli
*!*	Peso
*!*	AspettoBeni
*!*	CodiceVett1
*!*	DescVett1
*!*	CodiceVett2
*!*	DescVett2
*!*	DataPart
*!*	OraPart
*!*	DataCons
*!*	OraCons
*!*	NsRif
*!*	VsRif
*!*	Agente
*!*	Zona
*!*	Commessa
*!*	Descrizione
*!*	AbiCab
*!*	Sconto
*!*	DataCompetenza
*!*	DataModifica
*!*	GiaStampato
*!*	Cin
*!*	Conto
*!*	SwiftCode
*!*	Iban
*!*	DcreTD
*!*	DmodTD
*!*	IdregSc
*!*	Totprov
*!*	Piu3000
*!*	Piu3000St
*!*	IdDoc
*!*	Email
*!*	ScontoValore
*!*	GiaXml
*!*	ConPag



SELECT CU_INPUT
GO TOP
SCAN



	
	WAIT WINDOWS "Conversione Fattura " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
	
	
	SCATTER MEMVAR MEMO
	
	__TAGGANCIO 	= SYS(2015)
	__ORD_CODSOC 	= PUB_CODSOC
	__TNUMERO 		= ALLTRIM(CONV_CLEAR(M.NumDocColl))	&& Numero testata documento
	__ORD_CODCLI 	= ALLTRIM(CONV_CLEAR(M.Intestatario))
	__ORD_CODCLI    = TRC(PUB_LCL,ALLTRIM(__ORD_CODCLI))
	
	x_soci = "CLI_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "CLI_CODCLI = '" + __ORD_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT * FROM U_CLI_AN WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_CLI_AN")
		RETURN .F.
	ENDIF
	SELECT CX_CLI_AN
	GO TOP
	IF !EOF()
		__ORD_RAGSOC = CLI_RAGSOC
		__ORD_INDIRI = CLI_INDIR
		__ORD_CAP	 = CLI_CAP
		__ORD_LOCALI = CLI_LOCALI
		__ORD_PROVIN = CLI_PROVIN
		__ORD_PARIVA = CLI_PARIVA
		*__ORD_FAX    = CLI_FAX
		*__ORD_CDIMBA = CLI_CODIMB
		__ORD_CPA	 = CLI_CONPAG
		__ORD_BANCA	 = CLI_BAE
		__ORD_CODNAZ = CLI_NAZION
		__ORD_VALUTA = CLI_VALUTA
		__ORD_AGE    = CLI_AGE
	ELSE
		__ORD_RAGSOC = ""
		__ORD_INDIRI = ""
		__ORD_CAP	 = ""
		__ORD_LOCALI = ""
		__ORD_PROVIN = ""
		__ORD_PARIVA = ""
		*__ORD_FAX    = ""
		*__ORD_CDIMBA = ""
		__ORD_CPA	 = ""
		__ORD_BANCA	 = ""
		__ORD_CODNAZ = ""
		__ORD_VALUTA = ""
		__ORD_AGE    = "000"
	ENDIF
	
	__ORD_VALUTA = PUB_VALRIF
	__ORD_CAMBIO = 1
	
	
	__datdoc 		= TTOC(M.DataDocumento)
	__AA	 		= SUBSTR(__datdoc,7,4)
	__MM	 		= SUBSTR(__datdoc,4,2)
	__GG	 		= SUBSTR(__datdoc,1,2)
	__ORD_DATORD 	= RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))    

	
	__ORD_ANNO 		= __AA
	__ORD_NUMORD 	= ALLTRIM(STR(M.Numerodoc,1,10))
	__ORD_CAUS 		= PUB_FATTU
	__ORD_NSRIFE	= "NS.RIF: " + ALLTRIM(CONV_CLEAR(M.NsRif))
	__ORD_VSRIFE	= "VS.RIF: " + ALLTRIM(CONV_CLEAR(M.VsRif))
	__ORD_RIFERI 	= __ORD_NSRIFE + " " + __ORD_VSRIFE


     
	M.CODICE1   =ALLTRIM(CONV_CLEAR(ALLTRIM(M.Agente))) 
	
	_LEN_AGE    =LEN(M.CODICE1)
	IF _LEN_AGE = 4
		M.CODICE1 = SUBSTR(M.CODICE1,2,3)
	ENDIF
	IF _LEN_AGE = 5
		M.CODICE1 = SUBSTR(M.CODICE1,3,3)
	ENDIF
	IF _LEN_AGE = 6
		M.CODICE1 = SUBSTR(M.CODICE1,4,3)
	ENDIF
	IF _LEN_AGE = 7
		M.CODICE1 = SUBSTR(M.CODICE1,5,3)
	ENDIF
	IF _LEN_AGE = 8
		M.CODICE1 = SUBSTR(M.CODICE1,6,3)
	ENDIF
		

	IF EMPTY(M.CODICE1)
		__ORD_AGE = '000'
	ELSE
		__ORD_AGE = M.CODICE1 
	ENDIF
	


	__DataCons		= TTOC(M.DataCons)
	__AA	 		= SUBSTR(__DataCons,7,4)
	__MM	 		= SUBSTR(__DataCons,4,2)
	__GG	 		= SUBSTR(__DataCons,1,2)
	__ORD_DTCONS 	= RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))    


	__ORD_CODEMI 	= ""
	__ORD_RAGEMI 	= ""
	
	__REG_CODOPE 	= PUB_CODOPE
	__REG_NOMOPE 	= PUB_NOMOPE


	__DataRegistra	= TTOC(M.DataRegistra)
	__AA	 		= SUBSTR(__DataRegistra,7,4)
	__MM	 		= SUBSTR(__DataRegistra,4,2)
	__GG	 		= SUBSTR(__DataRegistra,1,2)
	__REG_DATREG 	= RIBALTA2(OK_DATA(__GG+"/"+__MM+"/"+__AA+"/"))    
	__REG_ORAREG 	= "00:00:00"
	
	__ORD_CHIUSO_TT = .T.
	
	__ORD_PESO 		= 0
	__ORD_VARIE 	= ""
	__ORD_RAGC 		= ""
	__ORD_INDC 		= ""
	__ORD_LOCC 		= ""
	__ORD_PROC 		= ""
	__ORD_CAPC 		= ""
	__ORD_CODLOC 	= ""
	__ORD_ALTDES 	= 0

**SERGIO????????????
	
	__ORD_CUP 		= ""
	__ORD_CIG 		= ""
	__ORD_SPTRAS 	= 0 	&& M.SpeTrasporto
	
	__ORD_COLLI 	= ""
	__ORD_PESNET 	= ""
	__ORD_VETTO1 	= ""
	__ORD_PORTO 	= ""
	__ORD_ASPETT 	= ""
	__ORD_ACURA 	= ""
	
*!*		x_tipo = "TIPODOCUM IN ('F','R','A','N')"	&& FATTURE
*!*		x_nume = "NUMERO = '" + M.NUMERO + "'"		&& CODICE UNIVOCO
*!*		x_cond = x_tipo + " and " + x_nume 
*!*		cSql = "SELECT * FROM CARD_TESDOCUM WHERE " + x_cond
*!*		IF !ExecCommand(cSql,"CU_INPUT")
*!*			RETURN .F.
*!*		ENDIF
*!*		SELECT CU_INPUT
*!*		GO TOP
*!*		IF !EOF()

		__ORD_VALUTA    =SUBSTR(ALLTRIM(CONV_CLEAR(M.CodiceValuta)),1,3)

		
		IF __ORD_VALUTA = PUB_VALRIF
			__ORD_CAMBIO = 1
		ELSE
			IF !ISNULL(M.ECAMBIO)
				__ORD_CAMBIO = 1 / M.ECAMBIO  && CONVERSIONE CAMBIO EURO/VALUTA
			ENDIF
		ENDIF
		IF !ISNULL(M.PAGAMENTO)
			__ORD_CPA = CARDIOLINE_DECODIFICA_CODICE_CPA(M.PAGAMENTO)
		ENDIF
		__ORD_PESO = M.PESOKG
		IF !ISNULL(M.ANNOTAZION)
			__ORD_VARIE = ALLTRIM(M.ANNOTAZION)
		ENDIF
		IF !ISNULL(M.RGSOC_DEST)
			__ORD_RAGC = ALLTRIM(M.RGSOC_DEST)
		ENDIF
		IF !ISNULL(M.INDIR_DEST)
			__ORD_INDC = ALLTRIM(M.INDIR_DEST)
		ENDIF
		IF !ISNULL(M.LOCAL_DEST)
			__ORD_LOCC = ALLTRIM(M.LOCAL_DEST)
		ENDIF
		IF !ISNULL(M.PROV_DEST)
			__ORD_PROC = ALLTRIM(M.PROV_DEST)
		ENDIF
		IF !ISNULL(M.CAP_DEST)
			__ORD_CAPC = ALLTRIM(M.CAP_DEST)
		ENDIF

		IF !ISNULL(M.CIG)
			__ORD_CIG = ALLTRIM(M.CIG)
		ENDIF
		IF !ISNULL(M.CUP)
			__ORD_CUP = ALLTRIM(M.CUP)
		ENDIF
		IF !ISNULL(M.ESPETRASPO)
			__ORD_SPTRAS = M.ESPETRASPO
		ENDIF
		
		IF !ISNULL(NUMCOLLI)
			__ORD_COLLI = ALLTRIM(STR(NUMCOLLI))
		ENDIF
		__ORD_PESNET = PESONETTO
		IF !ISNULL(VETTORE_1)
			__ORD_VETTO1 = SUBSTR(ALLTRIM(VETTORE_1),3,3)
		ENDIF
		IF !ISNULL(PORTO)
			__ORD_PORTO = ALLTRIM(PORTO)
		ENDIF
		IF !ISNULL(ASPESTBENI)
			DO CASE
				CASE UPPER(ALLTRIM(ASPESTBENI)) = "CAR"
					__ORD_ASPETT = '03'
				CASE UPPER(ALLTRIM(ASPESTBENI)) = "BUS"
					__ORD_ASPETT = '04'
				CASE UPPER(ALLTRIM(ASPESTBENI)) = "CAS"
					__ORD_ASPETT = '04'
				CASE UPPER(ALLTRIM(ASPESTBENI)) = "PAC"
					__ORD_ASPETT = '04'
				CASE UPPER(ALLTRIM(ASPESTBENI)) = "PAL"
					__ORD_ASPETT = '01'
				CASE UPPER(ALLTRIM(ASPESTBENI)) = "VIS"
					__ORD_ASPETT = '02'
			ENDCASE
		ENDIF
		IF !ISNULL(MODALSPEDI)
			__ORD_ACURA = SUBSTR(MODALSPEDI,1,1)
		ENDIF
		
		IF !EMPTY(__ORD_RAGC) AND !EMPTY(__ORD_INDC) AND !EMPTY(__ORD_LOCC) AND !EMPTY(__ORD_PROC) AND !EMPTY(__ORD_CAPC)
			__ORD_ALTDES = 1
			x_soci = "LOC_CODSOC = '" + PUB_CODSOC + "'"
			x_clfo = "LOC_CF = 'C'"
			x_codi = "LOC_CODCLI = '" + __ORD_CODCLI + "'"
			x_ragc = "LOC_RAGSOC = '" + __ORD_RAGC + "'"
			x_indi = "LOC_INDIRI = '" + __ORD_INDC + "'"
			x_loca = "LOC_LOCALI = '" + __ORD_LOCC + "'"
			x_capp = "LOC_CAP = '" + __ORD_PROC + "'"
			x_prov = "LOC_PROVIN = '" + __ORD_CAPC + "'"
			x_cond = x_soci + " and " + x_clfo + " and " + x_codi + " and " + x_ragc + " and " + x_indi + " and " + x_loca + " and " + x_capp + " and " + x_prov 
			cSql = "SELECT * FROM U_LOC_AN WHERE " + x_cond
			IF !ExecCommand(cSql,"CX_LOC_AN")
				RETURN .F.
			ENDIF
			SELECT CX_LOC_AN
			GO TOP
			IF !EOF()
				__ORD_CODLOC = ALLTRIM(LOC_CODLOC)
			ENDIF
		ENDIF		
*!*		ENDIF	
	
	cSql = "SELECT * FROM U_FAT_TT WHERE 1=0"
	IF !ExecRW(cSql,"U_FAT_TT","R")
	   return
	ENDIF
	SELECT U_FAT_TT
	APPEND BLANK
	REPLACE TAGGANCIO  WITH __TAGGANCIO
	REPLACE ORD_CODSOC WITH __ORD_CODSOC
	REPLACE TNUMERO    WITH __TNUMERO
	REPLACE ORD_CODCLI WITH __ORD_CODCLI
	REPLACE ORD_RAGSOC WITH __ORD_RAGSOC
	REPLACE ORD_INDIRI WITH __ORD_INDIRI
	REPLACE ORD_CAP    WITH __ORD_CAP
	REPLACE ORD_LOCALI WITH __ORD_LOCALI
	REPLACE ORD_PROVIN WITH __ORD_PROVIN
	REPLACE ORD_PARIVA WITH __ORD_PARIVA
	*REPLACE ORD_FAX    WITH __ORD_FAX
	*REPLACE ORD_CDIMBA WITH __ORD_CDIMBA
	REPLACE ORD_CPA    WITH __ORD_CPA
	REPLACE ORD_BANCA  WITH __ORD_BANCA
	REPLACE ORD_CODNAZ WITH __ORD_CODNAZ
	REPLACE ORD_VALUTA WITH __ORD_VALUTA
	REPLACE ORD_AGE    WITH __ORD_AGE
	REPLACE ORD_CAMBIO WITH __ORD_CAMBIO
	REPLACE ORD_ANNO   WITH __ORD_ANNO
	REPLACE ORD_NUMORD WITH __ORD_NUMORD
	REPLACE ORD_DATORD WITH __ORD_DATORD
	REPLACE ORD_CAUS   WITH __ORD_CAUS
	REPLACE ORD_RIFERI WITH __ORD_RIFERI
	REPLACE ORD_AGE    WITH __ORD_AGE
	REPLACE ORD_DTCONS WITH __ORD_DTCONS
	
	REPLACE ORD_PESO   WITH __ORD_PESO
	REPLACE ORD_VARIE WITH __ORD_VARIE
	REPLACE ORD_RAGC   WITH __ORD_RAGC
	REPLACE ORD_INDC   WITH __ORD_INDC
	REPLACE ORD_LOCC   WITH __ORD_LOCC
	REPLACE ORD_PROC   WITH __ORD_PROC
	REPLACE ORD_CAPC   WITH __ORD_CAPC
	REPLACE ORD_CODLOC WITH __ORD_CODLOC
	REPLACE ORD_ALTDES WITH __ORD_ALTDES
	
	REPLACE ORD_SPTRAS WITH __ORD_SPTRAS
	
	*REPLACE ORD_CODOPE WITH __ORD_CODOPE
	REPLACE ORD_CODEMI WITH __ORD_CODEMI
	REPLACE ORD_RAGEMI WITH __ORD_RAGEMI
	*REPLACE ORD_MAGS   WITH __ORD_MAGS
	*REPLACE ORD_TIPORD WITH __ORD_TIPORD
	REPLACE REG_CODOPE WITH __REG_CODOPE
	REPLACE REG_NOMOPE WITH __REG_NOMOPE
	REPLACE REG_DATREG WITH __REG_DATREG
	REPLACE REG_ORAREG WITH __REG_ORAREG
	
	REPLACE ORD_COLLI  WITH __ORD_COLLI
	REPLACE ORD_PESNET WITH __ORD_PESNET
	REPLACE ORD_VETTO1 WITH __ORD_VETTO1
	REPLACE ORD_PORTO  WITH __ORD_PORTO
	REPLACE ORD_ASPETT WITH __ORD_ASPETT
	REPLACE ORD_ACURA  WITH __ORD_ACURA
	IF !ExecRW(cSql,"U_FAT_TT","W")
	   return
	ENDIF
	
	_ULT_NUMORD = VAL(M.NUMEPROTOC)
	
	
	*** CALCOLO IMPONIBILE DOCUMENTO, NECESSARIO NEL CASO IN CUI NON ESISTONO DETTAGLI DOCUMENTO IN TABELLA CARD_MOVIMAG
	_IMPONIBILE_DOCUMENTO = 0
	_CODIVA_AQ_DOCUMENTO = ""
	_ALIQIVA_AQ_DOCUMENTO = 0
	IF M.ETOTIMPORT > 0
		
		IF !ISNULL(M.ASSOGCLIEN)
			_CODIVA_AQ_DOCUMENTO = ALLTRIM(CARDIOLINE_DECODIFICA_CODICE_IVA(ALLTRIM(M.ASSOGCLIEN)))
		ELSE
			SELECT CX_CLI_AN
			GO TOP
			IF !EOF()
				_CODIVA_AQ_DOCUMENTO = CLI_CODIVA
			ENDIF
		ENDIF
		
		IF !EMPTY(_CODIVA_AQ_DOCUMENTO)
			IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(_CODIVA_AQ_DOCUMENTO ) + "'","TMP_PARA_IVA")
				return
			ENDIF
			SELECT TMP_PARA_IVA
			IF !EOF()
				ALIQ = SUBSTR(LIBERA,1,3)
				_ALIQIVA_AQ_DOCUMENTO = VAL(ALIQ)
			ENDIF
		ENDIF
	
		_IMPONIBILE_DOCUMENTO = M.ETOTIMPORT / (1 + _ALIQIVA_AQ_DOCUMENTO/100)
		
	ENDIF
	
	
	_RIGHE_TROVATE = .F.
	_RIGHE_TROVATE_DA_DDT = .F.
	
	x_eser = "ESERCIZIO = '" + M.ESERPROTOC + "'"
	x_nume = "NUMERO = '" + M.NUMERO + "'"
	x_cond = x_eser + " and " + x_nume 
	cSql   = "SELECT * FROM CARD_MOVIMAG WHERE " + x_cond + " ORDER BY RIGA"
	IF !ExecCommand(cSql,"CX_CARD_MOVIMAG_TT_DD")
	   return
	ENDIF
	SELECT CX_CARD_MOVIMAG_TT_DD
	GO TOP
	IF !EOF()
		_RIGHE_TROVATE = .T.
	ELSE
		x_eser = "ESERPROTOC = '" + M.ESERRIFERI + "'"
		x_nrif = "NUMEPROTOC = '" + M.NUMERIFERI + "'"
		x_trif = "TIPOPROTOC = '" + M.TIPORIFERI + "'"
		x_drif = "DATAPROTOC = '" + M.DATARIFERI + "'"
		x_cond = x_eser + " and " + x_nrif + " and " + x_trif + " and " + x_drif
		cSql   = "SELECT NUMERO FROM CARD_TESDOCUM WHERE " + x_cond
		IF !ExecCommand(cSql,"RIF_CARD_TESDOCUM")
		   return
		ENDIF
		SELECT RIF_CARD_TESDOCUM
		GO TOP
		IF !EOF()
			x_nume = "NUMERO = '" + NUMERO + "'"
			x_cond = x_nume 
			cSql   = "SELECT * FROM CARD_MOVIMAG WHERE " + x_cond + " ORDER BY RIGA"
			IF !ExecCommand(cSql,"CX_CARD_MOVIMAG_TT_DD")
			   return
			ENDIF
			SELECT CX_CARD_MOVIMAG_TT_DD
			GO TOP
			IF !EOF()
				_RIGHE_TROVATE = .T.
				_RIGHE_TROVATE_DA_DDT = .T.
			ENDIF
		ENDIF
	ENDIF
	
	IF !_RIGHE_TROVATE
		SELECT CX_CARD_MOVIMAG_TT_DD
		APPEND BLANK
		REPLACE ESERCIZIO WITH M.ESERPROTOC
		REPLACE NUMERO WITH M.NUMERO
		REPLACE ARTICOLO WITH "..."
		REPLACE DESARCOMPL WITH "----------"
		REPLACE MAGAZZINO WITH IIF(!ISNULL(M.MAGAZZINO),M.MAGAZZINO,"")
		REPLACE UNIMISURA WITH "NR"
		REPLACE CODIVA WITH IIF(!ISNULL(M.ASSOGCLIEN),M.ASSOGCLIEN,"")
		REPLACE QUANTITA WITH 1
		REPLACE EVASO WITH 0
		REPLACE EPRLORDO WITH _IMPONIBILE_DOCUMENTO
		REPLACE SCONTO1 WITH 0
		REPLACE SCONTO2 WITH 0
		REPLACE SCONTO3 WITH 0
		REPLACE SCONTO4 WITH 0
		REPLACE SCONTO5 WITH 0		
		REPLACE DATAPREEVA WITH M.DATAPREEVA
		REPLACE OMAGGIO_SN WITH ""
		REPLACE IVAOMAGGI WITH ""
		REPLACE PROVAGENTE WITH M.PROVVIAGEN
		REPLACE EVASION_SN WITH M.EVASO_SN
		REPLACE CONTROPART WITH ""   && ?????????????????????????????????????????????????????????
		REPLACE CENTRCOSTO WITH M.CENTRCOSTO
	ENDIF
	
	__ORD_SEQUEN = 0
	SELECT CX_CARD_MOVIMAG_TT_DD
	GO TOP
	SCAN
		SCATTER MEMVAR MEMO
		
		_ACT_NUMERO = M.NUMERO 
		_ACT_RIGA = M.RIGA 
		
		__ORD_SEQUEN = __ORD_SEQUEN + 10
		__DAGGANCIO = _NEW_AGGA 
		__ORD_CODART = ALLTRIM(M.ARTICOLO)
		
		*__ORD_DES2	  = ART_DESEST
		*__ORD_PREZZO  = 0
		__ORD_COORD   = "" 
		__ORD_QTXCON  = 0 
		__ORD_SCORMI  = 0
		__ORD_CODTAG  = ""
		__ORD_DESTAG  = ""
		__ORD_CODCOL  = ""
		__ORD_DESCOL  = ""
		__ORD_PESOUM  = 0
		__ORD_CODMAT  = ""
		__ORD_DESMAT  = ""
		__ORD_CODCOL  = ""
		__ORD_DESCOL  = ""
		__ORD_SPESSO  = 0
		__ORD_ALTEZZ  = 0
		__ORD_LUNGHE  = 0
		__ORD_CODIMB  = ""
		__ORD_DESIMB  = ""
		__ORD_LOTMIN  = 0
		
		__ORS_NUMDDT  = ""
		__ORS_DATDDT  = ""
		IF _RIGHE_TROVATE_DA_DDT
			__ORS_NUMDDT = SUBSTR(M.NUMEROPROT,2,6)
			__ORS_DATDDT = SUBSTR(M.DATAPROT,1,4) + '/' + SUBSTR(M.DATAPROT,5,2) + '/' + SUBSTR(M.DATAPROT,7,2)
		ENDIF
		
		x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
		x_codi = "ART_CODPRI = '" + __ORD_CODART + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "SELECT * FROM U_ART_PR WHERE " + x_cond
		IF !ExecCommand(cSql,"CX_ART_PR")
			RETURN .F.
		ENDIF
		SELECT CX_ART_PR
		GO TOP
		IF !EOF()
			__ORD_COORD   = ART_COORD 
			__ORD_QTXCON  = ART_QTACON 
			__ORD_SCORMI  = ART_SCORMI
			__ORD_CODTAG  = ART_CODTAG 
			__ORD_DESTAG  = ART_DESTAG 
			__ORD_CODCOL  = ART_CODCOL 
			__ORD_DESCOL  = ART_DESCOL 
			__ORD_PUBBLI  = ART_PUBBLI
			__ORD_PESOUM  = ART_PESOUM
			__ORD_CODMAT  = ART_CODMAT
			__ORD_DESMAT  = ART_DESMAT
			__ORD_CODCOL  = ART_CODCOL
			__ORD_DESCOL  = ART_DESCOL
			__ORD_SPESSO  = ART_SPESSO
			__ORD_ALTEZZ  = ART_ALTEZZ
			__ORD_LUNGHE  = ART_LUNGHE
			__ORD_CODIMB  = ART_CODIMB
			__ORD_DESIMB  = ART_DESIMB
			__ORD_LOTMIN  = ART_LOTMIN
		ENDIF
		
		__ORD_DESART = IIF(ISNULL(M.DESARCOMPL),"",ALLTRIM(M.DESARCOMPL))
		__ORD_MAGA = IIF(ISNULL(M.MAGAZZINO),PUB_CODM,ALLTRIM(M.MAGAZZINO))
		IF UPPER(ALLTRIM(__ORD_MAGA)) == "VEN"
			__ORD_MAGA = "SEDE"
		ENDIF
		__ORD_UM = ALLTRIM(M.UNIMISURA)
		__ORD_IVA = IIF(!ISNULL(M.CODIVA),(ALLTRIM(CARDIOLINE_DECODIFICA_CODICE_IVA(M.CODIVA))),"")
		IF EMPTY(__ORD_IVA) AND _CODIVA_AQ_DOCUMENTO <> ''
			__ORD_IVA = _CODIVA_AQ_DOCUMENTO 
		ENDIF
		
		__ORD_QTAORD = M.QUANTITA
		__ORD_QTAEV = M.EVASO
		__ORD_PREZZO = M.EPRLORDO
		__ORD_SC1 = M.SCONTO1
		__ORD_SC2 = M.SCONTO2
		__ORD_SC3 = M.SCONTO3
		__ORD_SC4 = M.SCONTO4
		__ORD_SC5 = M.SCONTO5
				
		VPRE         = __ORD_PREZZO
		VPRE         = VPRE-ROUND((VPRE*__ORD_SC1/100),6)
		VPRE         = VPRE-ROUND((VPRE*__ORD_SC2/100),6)
		VPRE         = VPRE-ROUND((VPRE*__ORD_SC3/100),6)
		VPRE         = VPRE-ROUND((VPRE*__ORD_SC4/100),6)
		VPRE         = VPRE-ROUND((VPRE*__ORD_SC5/100),6)
		__ORD_PRZNET = VPRE
		__ORD_PRZNET = ROUND(__ORD_PRZNET,6)
		__ORD_VALORE = CALCOLA_VALORE_RIGA_DOCUMENTO(__ORD_PRZNET,__ORD_QTAORD)
		
		__ORD_DATCON = IIF(!ISNULL(M.DATAPREEVA),SUBSTR(M.DATAPREEVA,1,4) + '/' + SUBSTR(M.DATAPREEVA,5,2) + '/' + SUBSTR(M.DATAPREEVA,7,2),__ORD_DATORD)
		
		__ORD_PUBBLI = ''
		IF M.OMAGGIO_SN = 'S' AND M.IVAOMAGGI = 'S'
			__ORD_PUBBLI = 'O'
		ENDIF
		
		__ORD_PRORIG = M.PROVAGENTE
		__ORD_CODSYS = SYS(2015)
		__ORD_LEGSYS = SYS(2015)
		
		__ORD_CDAPRD = __ORD_CODART
		__ORD_DSAPRD = __ORD_DESART
		
		__ORD_CHIUSO = IIF(M.EVASION_SN = 'S',.T.,.F.)
		
		IF !__ORD_CHIUSO
			__ORD_CHIUSO_TT = .F.
		ENDIF
		
		__ORD_CONDET = ""
		IF !ISNULL(M.CONTROPART)
			__ORD_CONDET = ALLTRIM(M.CONTROPART)
		ENDIF
		__ORD_CCODET = ""
		IF !ISNULL(M.CENTRCOSTO)
			__ORD_CCODET = ALLTRIM(M.CENTRCOSTO)
		ENDIF
		
		
		cSql = "SELECT * FROM U_FAT_DD WHERE 1=0"
		IF !ExecRW(cSql,"U_FAT_DD","R")
		   return
		ENDIF
		SELECT U_FAT_DD
		APPEND BLANK

		REPLACE ORD_SEQUEN WITH __ORD_SEQUEN
		REPLACE DAGGANCIO  WITH __DAGGANCIO 
		REPLACE ORD_CODART WITH __ORD_CODART
		REPLACE ORD_COORD  WITH __ORD_COORD 
		REPLACE ORD_QTXCON WITH __ORD_QTXCON
		REPLACE ORD_SCORMI WITH __ORD_SCORMI
		REPLACE ORD_CODTAG WITH __ORD_CODTAG
		REPLACE ORD_DESTAG WITH __ORD_DESTAG
		REPLACE ORD_CODCOL WITH __ORD_CODCOL
		REPLACE ORD_DESCOL WITH __ORD_DESCOL
		REPLACE ORD_PESOUM WITH __ORD_PESOUM
		REPLACE ORD_CODMAT WITH __ORD_CODMAT
		REPLACE ORD_DESMAT WITH __ORD_DESMAT
		REPLACE ORD_CODCOL WITH __ORD_CODCOL
		REPLACE ORD_DESCOL WITH __ORD_DESCOL
		REPLACE ORD_SPESSO WITH __ORD_SPESSO
		REPLACE ORD_ALTEZZ WITH __ORD_ALTEZZ
		REPLACE ORD_LUNGHE WITH __ORD_LUNGHE
		REPLACE ORD_CODIMB WITH __ORD_CODIMB
		REPLACE ORD_DESIMB WITH __ORD_DESIMB
		REPLACE ORD_LOTMIN WITH __ORD_LOTMIN
		REPLACE ORD_CDAPRD WITH __ORD_CDAPRD
		REPLACE ORD_DSAPRD WITH __ORD_DSAPRD
		**REPLACE ORD_DESART WITH __ORD_DESART
		REPLACE ORD_DESART WITH IIF(ISNULL(__ORD_DESART),"",ALLTRIM(__ORD_DESART)) && ESEGUENDO LA SITUAZIONE DEGLI ORDINI MI HA TROVATO UN NULL SULLA DESCRIZIONE
		REPLACE ORD_MAGA   WITH __ORD_MAGA
		REPLACE ORD_UM     WITH __ORD_UM
		REPLACE ORD_IVA    WITH __ORD_IVA
		REPLACE ORD_QTAORD WITH __ORD_QTAORD
		REPLACE ORD_QTAEV  WITH __ORD_QTAEV 
		REPLACE ORD_PREZZO WITH __ORD_PREZZO
		REPLACE ORD_SC1    WITH __ORD_SC1
		REPLACE ORD_SC2    WITH __ORD_SC2
		REPLACE ORD_SC3    WITH __ORD_SC3
		REPLACE ORD_SC4    WITH __ORD_SC4
		REPLACE ORD_SC5    WITH __ORD_SC5
		REPLACE ORD_PRZNET WITH __ORD_PRZNET
		REPLACE ORD_VALORE WITH __ORD_VALORE
		REPLACE ORD_DATCON WITH __ORD_DATCON
		REPLACE ORD_PUBBLI WITH __ORD_PUBBLI
		REPLACE ORD_PRORIG WITH __ORD_PRORIG
		REPLACE ORD_CODSYS WITH __ORD_CODSYS
		REPLACE ORD_LEGSYS WITH __ORD_LEGSYS
		REPLACE ORD_CHIUSO WITH __ORD_CHIUSO
		
		*REPLACE ORS_MAGS   WITH __ORD_MAGS
		*REPLACE ORS_MAGD   WITH ""
		REPLACE ORS_CODCLI WITH __ORD_CODCLI
		REPLACE ORS_RAGSOC WITH __ORD_RAGSOC
		REPLACE ORS_NUMORD WITH __ORD_NUMORD
		REPLACE ORS_DATORD WITH __ORD_DATORD
		REPLACE ORS_CODEMI WITH __ORD_CODEMI
		REPLACE ORS_RAGEMI WITH __ORD_RAGEMI
		*REPLACE ORS_TIPORD WITH __ORD_TIPORD
		*REPLACE ORS_DESTIN WITH 
		REPLACE ORS_VALUTA WITH __ORD_VALUTA
		*REPLACE ORS_FLGABP WITH
		
		REPLACE ORD_CONDET WITH __ORD_CONDET
		REPLACE ORD_CCODET WITH __ORD_CCODET
		
		REPLACE ORS_NUMDDT WITH __ORS_NUMDDT
		REPLACE ORS_DATDDT WITH __ORS_DATDDT
		
		IF !ExecRW(cSql,"U_FAT_DD","W")
		   return
		ENDIF
	
		*** RICERCA E INSERIMENTO EVENTUALI NOTE COLLEGATE ALLA RIGA
		x_nume = "NUMEMOVIME = '" + _ACT_NUMERO + "'"
		x_riga = "RIGAMOVIME = '" + _ACT_RIGA + "'"
		x_cond = x_nume + " and " + x_riga 
		cSql = "SELECT * FROM CARD_NOTE WHERE " + x_cond + " ORDER BY PROGRESSIV"
		IF !ExecCommand(cSql,"CX_CARD_NOTE")
			RETURN .F.
		ENDIF
		SELECT CX_CARD_NOTE
		GO TOP
		IF !EOF()
			__CODICE = IIF(!ISNULL(CODICE),ALLTRIM(CODICE),"")
			__NOTE = ""
			SCAN
				IF RECNO() > 1
					__NOTE = __NOTE + CHR(13)
				ENDIF
				__NOTE = __NOTE + IIF(!ISNULL(NOTA),ALLTRIM(NOTA),"")
			ENDSCAN
			
			__ORD_SEQUEN = __ORD_SEQUEN + 10
			
			cSql = "SELECT * FROM U_FAT_DD WHERE 1=0"
			IF !ExecRW(cSql,"U_FAT_DD","R")
			   return
			ENDIF
			SELECT U_FAT_DD
			APPEND BLANK
			REPLACE DAGGANCIO  WITH __DAGGANCIO 
			REPLACE ORD_DESART WITH "*** COMMENTO ***"
			REPLACE ORD_CODSYS WITH SYS(2015)
			REPLACE ORD_SEQUEN WITH __ORD_SEQUEN
			REPLACE ORD_NOTE   WITH __NOTE
			REPLACE ORD_CODICE WITH __CODICE 

			*REPLACE ORS_MAGS   WITH __ORD_MAGS
			*REPLACE ORS_MAGD   WITH ""
			REPLACE ORS_CODCLI WITH __ORD_CODCLI
			REPLACE ORS_RAGSOC WITH __ORD_RAGSOC
			REPLACE ORS_NUMORD WITH __ORD_NUMORD
			REPLACE ORS_DATORD WITH __ORD_DATORD
			REPLACE ORS_CODEMI WITH __ORD_CODEMI
			REPLACE ORS_RAGEMI WITH __ORD_RAGEMI
			*REPLACE ORS_TIPORD WITH __ORD_TIPORD
			*REPLACE ORS_DESTIN WITH 
			REPLACE ORS_VALUTA WITH __ORD_VALUTA
			IF !ExecRW(cSql,"U_FAT_DD","W")
			   return
			ENDIF
		ENDIF
	ENDSCAN
	
	*** COMMENTO DDT DI RIFERIMENTO
	IF _RIGHE_TROVATE_DA_DDT
		__CODICE = ""
		__NOTE = "DDT n. " + SUBSTR(M.NUMEROPROT,2,6) + " DEL " + SUBSTR(M.DATAPROT,7,2) + '/' + SUBSTR(M.DATAPROT,5,2) + '/' + SUBSTR(M.DATAPROT,1,4)
		__ORD_SEQUEN = 5
		
		cSql = "SELECT * FROM U_FAT_DD WHERE 1=0"
		IF !ExecRW(cSql,"U_FAT_DD","R")
		   return
		ENDIF
		SELECT U_FAT_DD
		APPEND BLANK
		REPLACE DAGGANCIO  WITH __DAGGANCIO 
		REPLACE ORD_DESART WITH "*** COMMENTO ***"
		REPLACE ORD_CODSYS WITH SYS(2015)
		REPLACE ORD_SEQUEN WITH __ORD_SEQUEN
		REPLACE ORD_NOTE   WITH __NOTE
		REPLACE ORD_CODICE WITH __CODICE 
		REPLACE ORS_CODCLI WITH __ORD_CODCLI
		REPLACE ORS_RAGSOC WITH __ORD_RAGSOC
		REPLACE ORS_NUMORD WITH __ORD_NUMORD
		REPLACE ORS_DATORD WITH __ORD_DATORD
		REPLACE ORS_CODEMI WITH __ORD_CODEMI
		REPLACE ORS_RAGEMI WITH __ORD_RAGEMI
		REPLACE ORS_VALUTA WITH __ORD_VALUTA
		IF !ExecRW(cSql,"U_FAT_DD","W")
		   return
		ENDIF
	ENDIF
	
	*** CONTRAGGIORNAMENTO CAMPI DI TESTATA
	x_agga = "TAGGANCIO = '" + _NEW_AGGA + "'"
	x_cond = x_agga
	cSql = "SELECT * FROM U_FAT_TT WHERE " + x_cond
	IF !ExecCommand(cSql,"CU_FAT_TT")
	   return
	ENDIF
	SELECT CU_FAT_TT
	GO TOP
	SCATTER MEMVAR MEMO
	
	x_agga = "DAGGANCIO = '" + _NEW_AGGA + "'"
	x_cond = x_agga
	cSql = "SELECT * FROM U_FAT_DD WHERE " + x_cond
	IF !ExecCommand(cSql,"CU_FAT_DD")
	   return
	ENDIF
	SELECT CU_FAT_DD
	GO TOP
	
	DO CALCFAT
	
	_nVALORE = M.ORD_VALORE
	_cVALORE = ALLTRIM(STR(_nVALORE,17,3))
	_cVALORE = STRTRAN(_cVALORE,",",".")
	
	_nIMPONIB = M.ORD_IMPONIB
	_cIMPONIB = ALLTRIM(STR(_nIMPONIB,17,3))
	_cIMPONIB = STRTRAN(_cIMPONIB,",",".")
	
	_nIMPOSTA = M.ORD_IMPOSTA
	_cIMPOSTA = ALLTRIM(STR(_nIMPOSTA,17,3))
	_cIMPOSTA = STRTRAN(_cIMPOSTA,",",".")
	
	__cORD_CHIUSO_TT_SQL = IIF(__ORD_CHIUSO_TT,'1','0')
		
	y_cond = "TAGGANCIO = '" + _NEW_AGGA + "'"
	Csql = "UPDATE U_FAT_TT SET ORD_VALORE = &_cVALORE, ORD_IMPONIB = &_cIMPONIB, ORD_IMPOSTA = &_cIMPOSTA, ORD_CHIUSO = &__cORD_CHIUSO_TT_SQL, ORD_CGE = 1 WHERE " + y_cond
	IF !ExecCommand(cSql,"UPD_TABELLA_TT")
		return(.f.)
	ENDIF
	
	_TOT_COUNT = _TOT_COUNT + 1
	
ENDSCAN

*!*	*** AGGIORNAMENTO CONTATORE NUMERO ORDINE
*!*	x_codi = "CODICE = 'NUMORD" + PUB_CODSOC + "'"
*!*	x_cond = x_codi
*!*	cSql = "SELECT * FROM PARA WHERE " + x_cond
*!*	IF !ExecRW(cSql,"PARA","R")
*!*		RETURN .F.
*!*	ENDIF
*!*	SELECT PARA
*!*	GO TOP
*!*	IF EOF()
*!*		APPEND BLANK
*!*		REPLACE CODICE WITH 'NUMORD'+PUB_CODSOC
*!*		REPLACE DESCRI WITH 'NUMERO PROGR. DOCUMENTO - NUMORD'
*!*	ENDIF
*!*	REPLACE LIBERA WITH STR(_ULT_NUMORD,7,0)
*!*	IF !ExecRW(cSql,"PARA","W")
*!*		RETURN .F.
*!*	ENDIF


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Fatture clienti convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN

RETURN



****************************************************************
FUNCTION CONVERSIONE_FATTURE_MANUALI_ASSOLO
****************************************************************


RETURN





