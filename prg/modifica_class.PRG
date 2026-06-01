
USE form\MENU_PRIMANOT_TEST.scx

GO TOP
SCAN
	IF ALLTRIM(UPPER(baseclass))= UPPER("textbox") AND ALLTRIM(UPPER(parent))= UPPER("PRIMANO2")
	
		IF "GotFocus" $ methods
			WAIT WINDOW "campo con GotFocus da modificare a mano "+ALLTRIM(objname) 
		ENDIF
		
		IF "LostFocus" $ methods
			WAIT WINDOW "campo con LostFocus da modificare a mano "+ALLTRIM(objname) 
		ENDIF
	
		**replace methods WITH STRTRAN(methods,"PROCEDURE GotFocus","PROCEDURE GotFocus"+ CHR(13) + CHR(10)+"dodefault()")
	
		replace class WITH "text_con_focus"
		replace classloc WITH "..\project.vcx"
		
	
		WAIT WINDOW "ho trovato da modificare "+ALLTRIM(objname) nowait
	ENDIF
	
ENDSCAN
