*************************************************************************
*            PROGRAMMA : DI CHIUSURA ORDINI CLIENTI TESTATE E           *
*                        DETTAGLI QUANDO EVASI                          *
*************************************************************************

CREATE CURSOR TABELLE (ORD_CODART C(16),   ORD_DESART C(40),   ORD_MAGA C(06),   ;
                       ORD_UM C(02),       ORS_NUMORD C(06),   ORS_DATORD C(10),   ;
                       ORD_RAGSOC C(40),   ORD_QTAORD N(11,2), ORD_QTAEV N(11,2), ;
                       ORD_QTADEV N(11,2), ORD_CODCLI C(10),   ORD_PRZNET N(16,3))

CREATE CURSOR TABELLA (ORD_CODART C(16),   ORD_DESART C(40),   ORD_MAGA C(06),   ;
                       ORD_UM C(02),       ORS_NUMORD C(06),   ORS_DATORD C(10),   ;
                       ORS_RAGSOC C(40),   ORD_QTAORD N(11,2), ORD_QTAEV N(11,2), ;
                       ORD_QTADEV N(11,2), ORS_CODCLI C(10),   ORD_PRZNET N(16,3))

SELECT TABELLA 
INDEX ON ORD_CODART    TAG I_TABELLA ADDITIVE
SET ORDER TO I_TABELLA
GO TOP

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_codi = "ord_chiuso = '1'"
x_cond = x_soci + " and " + x_codi
cSql = "select * from u_ord_tt where " + x_cond + " order by ord_codsoc,ord_numord"
IF !ExecRW(cSql,"U_ORD_TT","R")
   RETURN .F.
ENDIF 
SELECT U_ORD_TT
GO TOP
   
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF      

   O_CHIUSO = .T.

   AGGA = TAGGANCIO
   
   x_cond = "daggancio = '" + AGGA + "'"
   cSql = "select * from u_ord_dd where " + x_cond + " order by daggancio,ord_sequen"
   IF !ExecRW(cSql,"U_ORD_DD","R")
      RETURN .F.
   ENDIF 
   SELECT U_ORD_DD
   GO TOP
   IF !EOF()
   ELSE
      **--> CANCELLAZIONE DELLE TESTATE SENZA RIGHE
      SELECT U_ORD_TT
      DELETE
      SKIP +1
      LOOP
   ENDIF
   
   DO WHILE .T.
      
      IF EOF()
         EXIT
      ENDIF
  
      IF DELETED()
         SKIP +1
         LOOP
      ENDIF

      IF ORD_QTAORD > ORD_QTAEV
         O_CHIUSO = .F.
         SCATTER MEMVAR 
         SELECT TABELLE
         APPEND BLANK
         GATHER MEMVAR
         SELECT U_ORD_DD
      ENDIF  

      SKIP +1

   ENDDO

   IF !ExecRW(cSql,"U_ORD_DD","W")
      RETURN .F.
   ENDIF 

   SELECT U_ORD_TT

   IF O_CHIUSO = .F.
      SELECT TABELLE
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
         SELECT TABELLA
         APPEND BLANK
         GATHER MEMVAR
         SELECT TABELLE
         SKIP +1
      ENDDO
   ENDIF
    
   SELECT TABELLE
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      DELETE
      SKIP +1
   ENDDO
   
   SELECT U_ORD_TT
   SKIP +1
   
ENDDO    

IF !ExecRW(cSql,"U_ORD_TT","W")
   RETURN .F.
ENDIF

**--> CANCELLAZIONE DELLE RIGHE SENZA TESTATA

cSql = "select * from u_ord_dd order by daggancio"
IF !ExecRW(cSql,"U_ORD_DD","R")
   RETURN .F.
ENDIF 
SELECT U_ORD_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF      

   AGGA = DAGGANCIO
   
   x_cond = "taggancio = '" + AGGA + "'"
   cSql = "select * from u_ord_tt where " + x_cond + " order by taggancio"
   IF !ExecCommand(cSql,"CUR_TESTATA")
      RETURN .F.
   ENDIF 
   SELECT CUR_TESTATA
   GO TOP  
   IF !EOF()
   ELSE
      SELECT U_ORD_DD
      DELETE
   ENDIF
   
   SELECT U_ORD_DD   
   SKIP +1
   
ENDDO    

IF !ExecRW(cSql,"U_ORD_DD","W")
   RETURN .F.
ENDIF 

SELECT TABELLA
GO TOP
IF !EOF()
   DO PRG\MENUSTA WITH "TABELLA",.T.,.T.,"XXX","ORDCLOSX","ORDCLOSX.FRX"
ELSE
   =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
ENDIF
   
RETURN