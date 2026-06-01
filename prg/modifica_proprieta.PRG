

CLOSE DATABASES


*!*	WAIT WINDOW 'Aggiornamento campo memo !!' NOWAIT
*!*	MODIFY MEMO methods NOEDIT  									&& Aprire il campo note memo
*!*	COPY MEMO methods TO c:\aquarius\dodefault.txt  				&& Crea il file di test dal campo memo
*!*	MODIFY FILE c:\aquarius\dodefault.txt NOEDIT 					&& Apre il file di testo 
*!*	APPEND MEMO methods FROM c:\aquarius\dodefault.txt  			&& Aggiunge il contenuto del file di testo
*!*	MODIFY MEMO methods NOEDIT  									&& Dispolay del campo memo
*!*	APPEND MEMO methods FROM c:\aquarius\dodefault.txt OVERWRITE  	&& Aggiorna il campo memo
*!*	MODIFY MEMO methods NOEDIT NOWAIT

**DELETE FILE c:\aquarius\dodefault.txt






SET STEP ON 






****##############################################
USE form\MENU_PRIMANOT_TEST.scx

GO TOP
SCAN
	IF ALLTRIM(UPPER(baseclass))= UPPER("textbox") AND ALLTRIM(UPPER(parent))= UPPER("PRIMANO2")
	
		IF "GotFocus" $ methods
			WAIT WINDOW "campo con GotFocus da modificare a mano "+ALLTRIM(objname) 
			APPEND MEMO methods FROM c:\aquarius\dodefault.txt OVERWRITE  	&& Aggiorna il campo memo
            REPLACE 	methods WITH methods 
		ENDIF
		
		IF "LostFocus" $ methods
			WAIT WINDOW "campo con LostFocus da modificare a mano "+ALLTRIM(objname) 
		ENDIF

	ENDIF
	
ENDSCAN
