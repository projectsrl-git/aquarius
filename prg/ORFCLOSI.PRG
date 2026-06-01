*************************************************************************
*            PROGRAMMA : DI CHIUSURA ORDINI A FORNITORI TESTATE E         *
*                        DETTAGLI QUANDO EVASI                          *
*************************************************************************

cSql = "select * from u_orf_tt order by taggancio"
IF !ExecRW(cSql,"U_ORF_TT","R")
   RETURN .F.
ENDIF 
SELECT U_ORF_TT
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
   cSql = "select * from u_orf_dd where " + x_cond + " order by daggancio,ord_sequen"
   IF !ExecRW(cSql,"U_ORF_DD","R")
      RETURN .F.
   ENDIF 
   SELECT U_ORF_DD
   GO TOP
   IF !EOF()
   ELSE
      **--> CANCELLAZIONE DELLE TESTATE SENZA RIGHE
      SELECT U_ORF_TT
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

      *IF ORD_CHIUSO
      *   SKIP +1
      *   LOOP
      *ENDIF

      IF ORD_QTAORD > ORD_QTAEV
         REPLACE ORD_CHIUSO WITH .F.
         O_CHIUSO = .F.
      ELSE
         REPLACE ORD_CHIUSO WITH .T.
      ENDIF  

      SKIP +1

   ENDDO

   IF !ExecRW(cSql,"U_ORF_DD","W")
      RETURN .F.
   ENDIF 

   SELECT U_ORF_TT

   IF O_CHIUSO = .F.
      REPLACE ORD_CHIUSO WITH .F.  && ORDINE APERTO
      REPLACE ORD_FLBOL  WITH 'N'
   ELSE
      REPLACE ORD_CHIUSO WITH .T.  && ORDINE CHIUSO
      REPLACE ORD_FLBOL  WITH 'S'
   ENDIF 
   
   SKIP +1
   
ENDDO    

IF !ExecRW(cSql,"U_ORF_TT","W")
   RETURN .F.
ENDIF 

**--> CANCELLAZIONE DELLE RIGHE SENZA TESTATA

cSql = "select * from u_orf_dd order by daggancio"
IF !ExecRW(cSql,"U_ORF_DD","R")
   RETURN .F.
ENDIF 
SELECT U_ORF_DD
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
      SELECT U_ORF_DD
      DELETE
   ENDIF
   
   SELECT U_ORF_DD   
   SKIP +1
   
ENDDO    

IF !ExecRW(cSql,"U_ORF_DD","W")
   RETURN .F.
ENDIF 

RETURN