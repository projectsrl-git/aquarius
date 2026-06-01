*.*
*!*	PROCEDURA PER IL RICALCOLO DELL'IMPONIBILE,IMPOSTA SULLET TESTATE DEI DOCUMENTI:
*.*
*.* OFF-ORD-BOL-FAP-FAT-ORF-RDA
*.*
*.*
*.*

PJ_PWD   = ""
PUB_PJPWD=.F.
PUB_MESS="Procedure riservate Aquarius"+CHR(13)+;
         "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
         ""+CHR(13)+;
         "Digitare password di accesso ....."  

DO FORM FORM\PJPWD LINKED 
IF PJ_PWD<>"1QAZ"
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF
V_RIT=MESSAGEBOX('Desideri proseguire il ricalcolo dei valori imponibile,imposta,totale sui documenti evidenziati?',292,'*** ATTENZIONE ***')
DO CASE
   CASE V_RIT = 6  && RISPOSTA SI
   CASE V_RIT = 7  && RISPOSTA NO
		RETURN
ENDCASE



WAIT WINDOWS " ############## AGGIORNAMENTO OFF ################# " nowait
x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_OFF_tt where " + x_cond + " order by ord_numord "
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
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
   SCATTER MEMVAR MEMO
   AGGA = TAGGANCIO
   =CALCdocge1(AGGA,"OFFhookd","U_OFF_DD","U_OFF_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE
   SELECT CUR_TESTATE
   SKIP +1
ENDDO  




WAIT WINDOWS " ############## AGGIORNAMENTO ORD ################# " nowait
x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_ORD_tt where " + x_cond + " order by ord_numord "
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
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
   SCATTER MEMVAR MEMO
   AGGA = TAGGANCIO
   =CALCdocge1(AGGA,"ORDhookd","U_ORD_DD","U_ORD_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE
   SELECT CUR_TESTATE
   SKIP +1
ENDDO  


WAIT WINDOWS " ############## AGGIORNAMENTO BOL ################# " nowait
x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_BOL_tt where " + x_cond + " order by ord_numord "
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
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
   
   IF ORD_FORNI
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
  
   
   SCATTER MEMVAR MEMO
   AGGA = TAGGANCIO
   =CALCdocge1(AGGA,"BOLhookd","U_BOL_DD","U_BOL_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE
   SELECT CUR_TESTATE
   SKIP +1
ENDDO  



WAIT WINDOWS " ############## AGGIORNAMENTO FAP ################# " nowait
x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_FAP_tt where " + x_cond + " order by ord_numord "
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
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
   SCATTER MEMVAR MEMO
   AGGA = TAGGANCIO
   =CALCdocge1(AGGA,"FAPhookd","U_FAP_DD","U_FAP_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE
   SELECT CUR_TESTATE
   SKIP +1
ENDDO  





WAIT WINDOWS " ############## AGGIORNAMENTO FAT ################# " nowait
x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_fat_tt where " + x_cond + " order by ord_numord "
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
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
   SCATTER MEMVAR MEMO
   AGGA = TAGGANCIO
   =CALCdocge1(AGGA,"fathookd","U_FAT_DD","U_FAT_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE
   SELECT CUR_TESTATE
   SKIP +1
ENDDO  






WAIT WINDOWS " ############## AGGIORNAMENTO ORF ################# " nowait
x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_ORF_tt where " + x_cond + " order by ord_numord "
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
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
   SCATTER MEMVAR MEMO
   AGGA = TAGGANCIO
   =CALCdocge1(AGGA,"ORFhookd","U_ORF_DD","U_ORF_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE
   SELECT CUR_TESTATE
   SKIP +1
ENDDO  



WAIT WINDOWS " ############## AGGIORNAMENTO BFO ################# " nowait
x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_BFO_tt where " + x_cond + " order by ord_numord "
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
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
   SCATTER MEMVAR MEMO
   AGGA = TAGGANCIO
   =CALCdocge1(AGGA,"BFOhookd","U_BFO_DD","U_BFO_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE
   SELECT CUR_TESTATE
   SKIP +1
ENDDO  



WAIT WINDOWS " ############## AGGIORNAMENTO BOF ################# " nowait
x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_BOF_tt where " + x_cond + " order by ord_numord "
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
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
   SCATTER MEMVAR MEMO
   AGGA = TAGGANCIO
   =CALCdocge1(AGGA,"BOFhookd","U_BOF_DD","U_BOF_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE
   SELECT CUR_TESTATE
   SKIP +1
ENDDO  





*!*	WAIT WINDOWS " ############## AGGIORNAMENTO RDA ################# " nowait
*!*	cSql = "select * from rda_tt order by NUMERO"
*!*	IF !ExecCommand(cSql,"CUR_TESTATE")
*!*	   RETURN .F.
*!*	ENDIF 
*!*	SELECT CUR_TESTATE
*!*	GO TOP
*!*	DO WHILE .T.

*!*	   IF EOF()
*!*	      EXIT
*!*	   ENDIF
*!*	   IF DELETED() 
*!*	      SELECT CUR_TESTATE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	   SCATTER MEMVAR MEMO
*!*	   AGGA = TAGGANCIO
*!*	   =CALCdocge1(AGGA,"RDAhookd","RDA_DD","RDA_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE
*!*	   SELECT CUR_TESTATE
*!*	   SKIP +1
*!*	ENDDO  




WAIT WINDOW "Operazione conclusa"