SET STEP ON
_filename_in = "C:\Users\Erasmo\Desktop\TEST BLUENEXT\PIPPO.xml"
_filename_out = "C:\Users\Erasmo\Desktop\TEST BLUENEXT\PLUTO.zip"

IF !CREATE_ZIP_FILE(_filename_in,_filename_out)
	MESSAGEBOX("ERRORE")
ELSE
	MESSAGEBOX("FILE CREATO: "+_filename_out)
	_V_DIR_OUTPUT = JUSTPATH(_filename_out)
	_RISP = MESSAGEBOX("Aprire la directory contenente i files generati?",36,"Attenzione")
	IF _RISP = 6
		_V_RUN = "/N Explorer /e," + _V_DIR_OUTPUT
		RUN &_V_RUN
		RETURN
	ELSE
		RETURN
	ENDIF
	
ENDIF