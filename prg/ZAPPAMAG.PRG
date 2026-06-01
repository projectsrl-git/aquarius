
PUB_PJPWD= .F.
PUB_MESS = "Installazione archivi Aquarius"+CHR(13)+;
           "Accesso consentito solo a persone autorizzate munite di password"+CHR(13)+;
           ""+CHR(13)+;
           "Digitare la password di accesso ....."  
DO FORM FORM\PJPWD LINKED 
IF !PUB_PJPWD
   =MESSAGEB("Password non abilitata !!!",16,"*** ATTENZIONE ***")
   RETURN
ENDIF  

PUB_ERRORE=MESSAGEBOX('Installazione archivi'+CHR(13)+'procedere ?',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
  	    RETURN
ENDCASE

PUB_ERRORE=MESSAGEBOX('Questa procedura azzera gli archivi di magazzino'+CHR(13)+'procedere ?',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
	    RETURN
ENDCASE

PUB_ERRORE=MESSAGEBOX('Ultimo avviso'+CHR(13)+'Procedere ?',292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
	    RETURN
ENDCASE



CSQL = "DELETE FROM U_MAG_AN"
IF !ExecCommand(CSQL,"U_MAG_AN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_AR"
IF !ExecCommand(CSQL,"U_MAG_AR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_CA"
IF !ExecCommand(CSQL,"U_MAG_CA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_CL"
IF !ExecCommand(CSQL,"U_MAG_CL")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_CP"
IF !ExecCommand(CSQL,"U_MAG_CP")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_DA"
IF !ExecCommand(CSQL,"U_MAG_DA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_DF"
IF !ExecCommand(CSQL,"U_MAG_DF")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_DM"
IF !ExecCommand(CSQL,"U_MAG_DM")
   RETURN (.f.)
ENDIF 


CSQL = "DELETE FROM U_MAG_FO"
IF !ExecCommand(CSQL,"U_MAG_FO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_GG"
IF !ExecCommand(CSQL,"U_MAG_GG")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_IN"
IF !ExecCommand(CSQL,"U_MAG_IN")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_MA"
IF !ExecCommand(CSQL,"U_MAG_MA")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_MF"
IF !ExecCommand(CSQL,"U_MAG_MF")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_MO"
IF !ExecCommand(CSQL,"U_MAG_MO")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_PR"
IF !ExecCommand(CSQL,"U_MAG_PR")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_RI"
IF !ExecCommand(CSQL,"U_MAG_RI")
   RETURN (.f.)
ENDIF 

CSQL = "DELETE FROM U_MAG_SA"
IF !ExecCommand(CSQL,"U_MAG_SA")
   RETURN (.f.)
ENDIF 


PUB_ERRORE=MESSAGEBOX('Fine cancellazione archivi magazzino Aquarius',64,'*** ATTENZIONE ***') 

RETURN
