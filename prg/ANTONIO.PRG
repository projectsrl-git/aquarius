***********************************************************
PROCEDURE APITOSPA  && SOSTITUISCE UN APICE CON UNO SPAZIO
***********************************************************

PARA _STRINGA

RELEASE XXX_STRINGA,XXX_LUNG,XXX_NUOVA
PUBLIC  XXX_STRINGA,XXX_LUNG,XXX_NUOVA

XXX_STRINGA = _STRINGA
XXX_LUNG    = LEN(XXX_STRINGA)
XXX_NUOVA   = ""

FOR I=1 TO XXX_LUNG
   
   IF SUBSTR(XXX_STRINGA,I,1) = "'"
      XXX_NUOVA = XXX_NUOVA + " "
   ELSE
      XXX_NUOVA = XXX_NUOVA + SUBSTR(XXX_STRINGA,I,1)
   ENDIF
      
ENDFOR

RETURN XXX_NUOVA
