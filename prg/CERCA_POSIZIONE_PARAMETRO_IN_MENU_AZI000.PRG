
LPARAMETERS _par_cNomeCampo

USE FORM\MENU_AZI000.SCX
_TROVATO = .F.
GO TOP
SCAN
	IF UPPER(ALLTRIM(_par_cNomeCampo)) $ UPPER(PROPERTIES)
		_TROVATO = .T.
		EXIT
	ENDIF
ENDSCAN
IF _TROVATO 
	MESSAGEBOX("Il campo " + UPPER(ALLTRIM(_par_cNomeCampo)) + " si trova in: " + CHR(13) + CHR(13) + ;
		ALLTRIM(PARENT)  + " del form FORM\MENU_AZI000.SCX",64,"Informazione")
ELSE
	MESSAGEBOX("Campo " + UPPER(ALLTRIM(_par_cNomeCampo)) + " non trovato nel form FORM\MENU_AZI000.SCX",64,"Informazione")
ENDIF

BROWSE NORMAL
USE
