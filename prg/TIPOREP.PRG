*SET PROCEDURE TO WINLIB ADDITIVE

* -->> RICHIESTA PWD DI ACCESSO
PUB_PJPWD = .F.
PUB_MESS  = "Opzione riservata a PROJECT "+CHR(13)+;
            "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
            ""+CHR(13)+;
            "Digitare password di accesso ....."  
DO FORM FORM\PJPWD LINKED 
IF !PUB_PJPWD
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF  

DO FORM FORM\tiporepo LINKED