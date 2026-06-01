*************************************************************************
*            PROGRAMMA : DI CHIUSURA ORDINI A CLIENTI TESTATE E         *
*                        DETTAGLI QUANDO EVASI (ORD_FLBOL = 'S')        *
*************************************************************************

cSql = "select * from u_ord_tt order by taggancio"
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


   SELECT U_ORD_TT
   
   IF ORD_FLBOL <> "S"
     SKIP +1
     LOOP
   ENDIF


   O_CHIUSO = .T.
   
   AGGA = TAGGANCIO
   
   WAIT windows "Ordine in elaborazione numero : " + ord_numord nowait
   
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


      REPLACE ORD_QTAEV  WITH ORD_QTAORD 
      REPLACE ORD_CHIUSO WITH .T. 


      SKIP +1

   ENDDO
   
   IF !ExecRW(cSql,"U_ORD_DD","W")
      RETURN .F.
   ENDIF 

   SELECT U_ORD_TT


   REPLACE ORD_CHIUSO WITH .T.  && ORDINE CHIUSO
   REPLACE ORD_FLBOL  WITH 'S'
   REPLACE SELEZIONE WITH ""


   
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

V_RIT=MESSAGEBOX('Sistemazione ordini clienti finito',62,'*** ATTENZIONE ***')

RETURN