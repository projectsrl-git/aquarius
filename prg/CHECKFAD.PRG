V_RIT=MESSAGEBOX('Desideri proseguire il'+chr(13)+'controllo articoli fatture',292,'*** ATTENZIONE ***')

DO CASE
   CASE V_RIT = 6  && RISPOSTA SI
   CASE V_RIT = 7  && RISPOSTA NO
		RETURN
ENDCASE

CREATE CURSOR DOPFAT( ;
  RIGA C(80))

CREATE CURSOR ARTFAT( ;
  DAGGA C(10) , ARTIC C(30))
INDEX ON DAGGA+ARTIC TO INDICE

cSql = "select * from u_fat_dd order by daggancio"
IF !ExecCommand(cSql,"CUR_DETTAGLI")
   RETURN .F.
ENDIF 
SELECT CUR_DETTAGLI
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED() 
      SKIP +1
      LOOP
   ENDIF
  
   _SEEK = DAGGANCIO + ORD_CODART
   _AGGA = DAGGANCIO
   _ARTI = ORD_CODART
  
   SELECT ARTFAT
   SET ORDER TO INDICE

   SEEK _SEEK            && VERIFICA DETTAGLI DOPPI

   IF FOUND()
      x_cond = "taggancio = '" + _AGGA + "'"
      cSql = "select * from u_fat_tt where " + x_cond
      IF !ExecCommand(cSql,"CUR_TESTATE")
         RETURN .F.
      ENDIF 
      SELECT CUR_TESTATE
      GO TOP
      
      IF !EOF()
         SCATTER MEMVAR MEMO
         SELECT DOPFAT
         APPEND BLANK 
         REPLACE RIGA WITH _AGGA+"-"+M.ORD_DATORD+"-"+M.ORD_NUMORD+"-"+SUBSTR(M.ORD_RAGSOC,1,25)+"-"+STR(M.ORD_VALORE,12,0)+" ART.DOP"
      ELSE
         SELECT DOPFAT
         APPEND BLANK 
         REPLACE RIGA WITH _AGGA+"DETTAGLI SENZA TESTATA FATTURA"
      ENDIF
   ELSE
      SELECT ARTFAT
      APPEND BLANK 
      REPLACE DAGGA WITH  _AGGA
      REPLACE ARTIC WITH  _ARTI
   ENDIF
  
   SELECT CUR_DETTAGLI
   SKIP +1
    
ENDDO  

*********** CONTROLLO DA DETTAGLI A TESTATE SE ESISTONO ARTICOLI NO TESTATE

cSql = "select * from u_fat_dd order by daggancio"
IF !ExecCommand(cSql,"CUR_DETTAGLI")
   RETURN .F.
ENDIF 
SELECT CUR_DETTAGLI
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED() 
      SKIP +1
      LOOP
   ENDIF
  
   _AGGA = DAGGANCIO

   x_cond = "taggancio = '" + _AGGA + "'"
   cSql = "select * from u_fat_tt where " + x_cond
   IF !ExecCommand(cSql,"CUR_TESTATE")
      RETURN .F.
   ENDIF 
   SELECT CUR_TESTATE
   GO TOP  

   IF EOF()
      SELECT DOPFAT
      APPEND BLANK 
      REPLACE RIGA WITH _AGGA+"DETTAGLI SENZA TESTATA FATTURA*********"
   ENDIF

   SELECT CUR_DETTAGLI
   SKIP +1
    
ENDDO  

SELECT DOPFAT
GO TOP
BROWSE NORMAL

WAIT WINDOW "Operazione conclusa"