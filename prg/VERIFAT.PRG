V_RIT=MESSAGEBOX('Desideri proseguire il'+chr(13)+'controllo fatture',292,'*** ATTENZIONE ***')

DO CASE
   CASE V_RIT = 6  && RISPOSTA SI
   CASE V_RIT = 7  && RISPOSTA NO
		RETURN
ENDCASE

x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_fat_tt where " + x_cond
IF !ExecRW(cSql,"U_FAT_TT","R")
   RETURN .F.
ENDIF 
SELECT U_FAT_TT
GO TOP

CT = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF _DATOKO(ALLTRIM(ORD_CODCLI))
      V_RIT=MESSAGEBOX('Fattura errata '+ORD_NUMORD+' '+ORD_DATORD+' '+TAGGANCIO+chr(13)+'La cancello ?',292,'*** ATTENZIONE ***')
      BROWSE NORMAL
	  DO CASE
		 CASE V_RIT = 6  && RISPOSTA SI
		      _TAGGA = TAGGANCIO
			   
			  DELETE

              CSQL="DELETE FROM U_FAT_DD WHERE DAGGANCIO = ?_TAGGA"
              IF !ExecCommand(CSQL,"U_FAT_DD")
                 RETURN (.f.)
              ENDIF			   
						
		 CASE V_RIT = 7  && RISPOSTA NO
	  ENDCASE
   ENDIF

   SELECT U_FAT_TT
   SKIP +1
   
   CT = CT +1
   
   WAIT WINDOWS "Testate fatture elaborate "+STR(CT,8,0) NOWAIT
   
ENDDO

IF !ExecRW(cSql,"U_FAT_TT","W")
   RETURN .F.
ENDIF 

cSql = "select * from u_fat_dd"
IF !ExecRW(cSql,"U_FAT_DD","R")
   RETURN .F.
ENDIF 
SELECT U_FAT_DD
GO TOP

CT = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF EMPTY(ORD_CODART) .AND.  "*** COMMENTO ***"  $ ORD_DESART
      SELECT U_FAT_DD
      SKIP +1
      LOOP
   ENDIF
                          
   IF _DATOKO(ALLTRIM(ORD_CODART))
	  V_RIT=MESSAGEBOX('Dettaglio fattura errato '+DAGGANCIO +chr(13)+'Lo cancello ?',292,'*** ATTENZIONE ***')
      BROWSE NORMAL
      DO CASE
		 CASE V_RIT = 6  && RISPOSTA SI
		      DELETE
		 CASE V_RIT = 7  && RISPOSTA NO
      ENDCASE
   ENDIF

   SELECT U_FAT_DD
   SKIP +1

   CT = CT + 1
   
   WAIT WINDOWS "Dettagli fatture elaborati "+STR(CT,8,0) NOWAIT

ENDDO

IF !ExecRW(cSql,"U_FAT_DD","W")
   RETURN .F.
ENDIF 

V_RIT=MESSAGEBOX('Fine controllo archivi fatture',62,'*** ATTENZIONE ***')