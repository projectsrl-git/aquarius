V_RIT=MESSAGEBOX('Desideri proseguire il'+chr(13)+'controllo fatture',292,'*** ATTENZIONE ***')

DO CASE
   CASE V_RIT = 6  && RISPOSTA SI
   CASE V_RIT = 7  && RISPOSTA NO
		RETURN
ENDCASE

CREATE CURSOR DOPFAT( ;
  RIGA C(80))

* CONTROLLO DA TESTATA A DETTAGLI  
x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_fat_tt where " + x_cond
IF !ExecCommand(cSql,"CUR_TESTATE")
   RETURN .F.
ENDIF 
SELECT CUR_TESTATE
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
   
   AGGA = TAGGANCIO

   x_cond = "daggancio = '" + AGGA + "'"
   cSql = "select * from u_fat_dd where " + x_cond
   IF !ExecCommand(cSql,"CUR_DETTAGLI")
      RETURN .F. 
   ENDIF 
   SELECT CUR_DETTAGLI
   GO TOP
   IF EOF()   
      SELECT DOPFAT
      APPEND BLANK 
      REPLACE RIGA WITH AGGA+"-"+M.ORD_DATORD+"-"+M.ORD_NUMORD+"-"+SUBSTR(M.ORD_RAGSOC,1,30)+"-"+STR(M.ORD_VALORE,12,0)
   ENDIF
  
   SELECT CUR_TESTATE
   SKIP +1
    
ENDDO  

SELECT DOPFAT
GO TOP
BROWSE NORMAL TITLE "FATTURE SENZA DETTAGLI"

CREATE CURSOR DOPFAT( ;
  RIGA C(80))

* VERIFICA LE TESTATE DOPPIE
IF !ExecCommand("select * from u_fat_tt where 0=1","u_fat_tt")
   return(.f.)
ENDIF
SELECT U_FAT_TT
QQ=AFIELDS(PIPPO)
CREATE CURSOR FATTURE FROM ARRAY PIPPO
INDEX ON TAGGANCIO TAG FATTURE

x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_fat_tt where " + x_cond
IF !ExecCommand(cSql,"CUR_TESTATE")
   RETURN .F.
ENDIF 
SELECT CUR_TESTATE
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
  
   SELECT FATTURE
   SEEK M.TAGGANCIO
   IF !FOUND()
      APPEND BLANK
      GATHER MEMVAR
   ELSE
      SELECT DOPFAT
      APPEND BLANK 
      REPLACE RIGA WITH M.TAGGANCIO+"-"+M.ORD_DATORD+"-"+M.ORD_NUMORD+"-"+SUBSTR(M.ORD_RAGSOC,1,30)+"-"+STR(M.ORD_VALORE,12,0)      
   ENDIF
  
   SELECT CUR_TESTATE
   SKIP +1  
   
ENDDO

SELECT DOPFAT
GO TOP
BROWSE NORMAL TITLE "FATTURE CON UNCINO DUPLICATO"

WAIT WINDOW "Operazione conclusa"