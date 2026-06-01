RELEASE PJ_PWD
PUBLIC PJ_PWD
PJ_PWD=""

PUB_PJPWD=.F.
PUB_MESS="Manutenzione archivi Aquarius"+CHR(13)+;
         "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
         ""+CHR(13)+;
         "Digitare password di accesso ....."  

DO FORM FORM\PJPWD LINKED 

IF PJ_PWD<>"1234"
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF


RIT = MESSAGEBOX("Procedo con la generazione"+CHR(13)+"del numero di distinta per banca ??? ",292,"ATTENZIONE")

IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

cSql = "delete from para where codice like 'NUMCAN%'"
IF !ExecCommand(cSql,"PARA")
   RETURN .F.
ENDIF

cSql = "select * from para where codice like 'NUMDIR%' order by codice"
IF !ExecCommand(cSql,"CU_PARA_DIR")
   RETURN .F.
ENDIF
SELECT CU_PARA_DIR
GO TOP   

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   SCATTER MEMVAR MEMO

   V_CODOLD = CODICE
   V_CODNEW = 'NUMCAN' + SUBSTR(V_CODOLD,7,7)

   x_cond = "codice = '" + V_CODNEW + "'" 
   cSql = "select * from para where " + x_cond
   IF !ExecRW(cSql,"PARA","R")
      RETURN .F.
   ENDIF
   SELECT PARA
   APPEND BLANK
   REPLACE CODICE WITH V_CODNEW
   REPLACE DESCRI WITH M.DESCRI
   REPLACE LIBERA WITH '0000000000'
   REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
   IF !ExecRW(cSql,"PARA","W")
      RETURN .F.
   ENDIF

   SELECT CU_PARA_DIR
   SKIP +1
	
ENDDO


RIT = MESSAGEBOX("Generazione numeri di distinta per banca"+CHR(13)+"aggiornato correttamente",16,"ATTENZIONE")

