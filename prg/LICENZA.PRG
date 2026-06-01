** ###################################################################
** GESTIONE DELLE AUTORIZZAZIONI ALL'USO DELLA LICENZA DI AQUARIUS  **
** ###################################################################
RELEASE PJ_PWD
PUBLIC PJ_PWD
PJ_PWD=""


PUB_PJPWD=.F.
PUB_MESS="Autorizzazione all'uso della licenza di Aquarius"+CHR(13)+;
         "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
         ""+CHR(13)+;
         "Digitare password di accesso ....."  

DO FORM FORM\PJPWD LINKED 




IF PJ_PWD<>"LICENZA"
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF

DO FORM FORM\LICENZA

RETURN
  
