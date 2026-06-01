*.*
*!*	PROCEDURA PER IL RICALCOLO DELL'IMPONIBILE,IMPOSTA SULLET TESTATE DEI DOCUMENTI:
*.*
*.* ORD
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
V_RIT=MESSAGEBOX('Desideri proseguire il ricalcolo dei valori imponibile,imposta,totale su tutti gli ordini clienti?',292,'*** ATTENZIONE ***')
DO CASE
   CASE V_RIT = 6  && RISPOSTA SI
   CASE V_RIT = 7  && RISPOSTA NO
		RETURN
ENDCASE


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
   
   WAIT WINDOWS "Ricalcolo valori ordine " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) + " ..." NOWAIT
   
   AGGA = TAGGANCIO
   =CALCdocge1(AGGA,"ORDhookd","U_ORD_DD","U_ORD_TT",.T.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO AGGIORNANDO AGGIORNARE IL DBASE
   SELECT CUR_TESTATE
   SKIP +1
ENDDO  


WAIT WINDOW "Operazione conclusa"