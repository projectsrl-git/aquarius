
PUB_PJPWD=.F.
PUB_MESS="Manutenzione archivi Aquarius"+CHR(13)+;
         "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
         ""+CHR(13)+;
         "Digitare password di accesso ....."  

DO FORM FORM\PJPWD LINKED 

IF ALLTRIM(PJ_PWD) <> "1QAZ"
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF

DO FORM FORM\DBSOCIETA000 LINKED
