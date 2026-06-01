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




V_RIT=MESSAGEBOX('Desideri proseguire il'+chr(13)+'controllo del VALORE/IMPONIBILE delle DDT ?',292,'*** ATTENZIONE ***')

DO CASE
   CASE V_RIT = 6  && RISPOSTA SI
   CASE V_RIT = 7  && RISPOSTA NO
		RETURN
ENDCASE

CREATE CURSOR VAL_DDT( ;
  RIGA C(80), VAL_OLD N(17,2), VAL_NEW N(17,2), IMP_OLD N(17,2), IMP_NEW N(17,2))

* CONTROLLO DA TESTATA A DETTAGLI  
x_cond = "ord_codsoc = '" + PUB_CODSOC + "'"
cSql = "select * from u_bol_tt where " + x_cond + " order by ord_numord "
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

*!*	   IF ALLTRIM(M.ORD_NUMORD) <> '000500'
*!*	      SELECT CUR_TESTATE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
   
   
   IF SUBSTR(M.ORD_DATORD,1,4) <> PUB_ANNO
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
   
   IF M.ORD_FORNI && SE FORNITORE LOOP
      SELECT CUR_TESTATE
      SKIP +1
      LOOP
   ENDIF
      
   
   _OKAGG = .F. && NON AGGIORNA LA TESTATA 
   
   AGGA = TAGGANCIO
   ___VALORE_ORIGINALE_TESTATA_DDT  = M.ORD_VALORE 
   ___IMPONIBILE_ORIGINALE_TESTATA_DDT  = M.ORD_IMPONIB
   
   =CALCdocge1(AGGA,"bolhookd","u_bol_dd","u_bol_tt",.F.) && CALCOLA IL VALORE DEL DOCUMENTO SU DBASE EFFETTIVO SENZA AGGIORNARE IL DBASE

   IF ___VALORE_ORIGINALE_TESTATA_DDT  <> M.ORD_VALORE 
      SELECT VAL_DDT
      APPEND BLANK 
      REPLACE RIGA WITH AGGA+"-"+M.ORD_DATORD+"-"+M.ORD_NUMORD+"-"+SUBSTR(M.ORD_RAGSOC,1,30)
      REPLACE VAL_OLD WITH ___VALORE_ORIGINALE_TESTATA_DDT  
      REPLACE VAL_NEW WITH M.ORD_VALORE
   ENDIF


   IF ___IMPONIBILE_ORIGINALE_TESTATA_DDT  <> M.ORD_IMPONIB 
      SELECT VAL_DDT
      APPEND BLANK 
      REPLACE RIGA WITH AGGA+"-"+M.ORD_DATORD+"-"+M.ORD_NUMORD+"-"+SUBSTR(M.ORD_RAGSOC,1,30)
      REPLACE IMP_OLD WITH ___IMPONIBILE_ORIGINALE_TESTATA_DDT  
      REPLACE IMP_NEW WITH M.ORD_IMPONIB
   ENDIF

  
   SELECT CUR_TESTATE
   SKIP +1
    
ENDDO  

SELECT VAL_DDT
GO TOP
BROWSE NORMAL TITLE "DDT con importi da controllare - valore vecchio / nuovo"



WAIT WINDOW "Operazione conclusa"