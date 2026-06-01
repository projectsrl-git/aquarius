RELEASE PJ_PWD
PUBLIC PJ_PWD
PJ_PWD=""


PUB_PJPWD=.F.
PUB_MESS="Manutenzione archivi Aquarius"+CHR(13)+;
         "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
         ""+CHR(13)+;
         "Digitare password di accesso ....."  

DO FORM FORM\PJPWD LINKED 




IF PJ_PWD<>"1QAZ"
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF


RIT = MESSAGEBOX("Procedo con l'impianto"+CHR(13)+"del campo AUTORIZZAZIONE  sull'archivio TAB_MENU ??? ",292,"ATTENZIONE")

IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

cSql = "select * from TBL_MENU "
IF !ExecCommand(cSql,"CUR_TMENU")
   RETURN .F.
ENDIF
SELECT CUR_TMENU
GO TOP   
BROWSE NORMAL

DO WHILE .NOT. EOF()


	REPLACE autorizzazione WITH .t.
	SELECT CUR_TMENU
	SKIP +1
	
ENDDO



SELECT CUR_TMENU
GO TOP   

IF !ExecRW('','TBL_MENU','I','','CUR_TMENU')
     return(.f.)
ENDIF



RIT = MESSAGEBOX("Archivio TAB_MENU  "+CHR(13)+"aggiornato correttamente",16,"ATTENZIONE")