
Local oActCtrl

IF TYPE("_screen.ActiveForm.activecontrol") == "O"
ELSE
	RETURN
ENDIF

AMOUSEOBJ(aActCtrl)
oActCtrl = aActCtrl(1)
RELEASE aActCtrl

IF UPPER(ALLTRIM(oActCtrl.Class)) == "TEXTBOX" .OR. ;
   UPPER(ALLTRIM(oActCtrl.BaseClass)) == "TEXTBOX" .OR. ;
   UPPER(ALLTRIM(oActCtrl.Class)) == "EDITBOX" .OR. ;
   UPPER(ALLTRIM(oActCtrl.BaseClass)) == "EDITBOX"
ELSE
   RETURN
ENDIF

*** VERIFICO CHE NON SIA PRESENTE GIA' DEL CODICE PERSONALIZZATO NEL METODO RIGHTCLICK DEL CONTROLLO ATTIVO
lModifiedCode = PEMSTATUS(oActCtrl,"RightClick",0)
IF lModifiedCode 
   RETURN
ENDIF

RELEASE _SelStart,_SelLength 
PUBLIC  _SelStart,_SelLength 
_SelStart  = oActCtrl.SelStart
_SelLength = oActCtrl.SelLength

RELEASE oHandler
PUBLIC oHandler
oHandler=NEWOBJECT("myhandler")

BINDEVENT(oActCtrl,"RightClick",oHandler,"myRightClick")

DEFINE CLASS myhandler AS Session

   PROCEDURE myRightClick

		SWSX=STR(SELECT())
		
		AMOUSEOBJ(aActCtrl)
		oThisCtrl = aActCtrl(1)
		
		DEACTIVATE POPUP _my_shortmenu 
		RELEASE POPUP _my_shortmenu EXTENDED

		DEFINE POPUP _my_shortmenu SHORTCUT RELATIVE FROM MROW(),MCOL()
		
*!*			IF "?HELP?" $ oThisCtrl.Tag
*!*				LOCAL cPictureName
*!*				cPictureName = sys(5)+sys(2003)+"\BMP\ambiente\ztoolbar\_ricerca.bmp"
*!*				DEFINE BAR 1 OF _my_shortmenu PROMPT "\<Apri Elenco" PICTURE cPictureName
*!*				DEFINE BAR 2 OF _my_shortmenu PROMPT "\-"
*!*			ENDIF
		
		DEFINE BAR _med_cut OF _my_shortmenu PROMPT "Tag\<lia" KEY CTRL+X, "Ctrl+X" PICTRES _med_cut MESSAGE "Removes the selection and places it onto the Clipboard" 
		DEFINE BAR _med_copy OF _my_shortmenu PROMPT "\<Copia" KEY CTRL+C, "Ctrl+C" PICTRES _med_copy MESSAGE "Copies the selection onto the Clipboard" 
		DEFINE BAR _med_paste OF _my_shortmenu PROMPT "Inc\<olla" KEY CTRL+V, "Ctrl+V" PICTRES _med_paste MESSAGE "Pastes the contents of the Clipboard" 
		DEFINE BAR _med_clear OF _my_shortmenu PROMPT "Canc\<ella" MESSAGE "Removes the selection and does not place it onto the Clipboard"
		DEFINE BAR 5 OF _my_shortmenu PROMPT "\-"
		DEFINE BAR _med_slcta OF _my_shortmenu PROMPT "Sele\<ziona tutto" KEY CTRL+A, "Ctrl+A" PICTRES _med_slcta MESSAGE "Selects all text or items in the current window"
		
		IF TYPE("oThisCtrl") == "O"
			IF PEMSTATUS(oThisCtrl,"SelStart",5)
				oThisCtrl.SelStart = _SelStart
			ENDIF
			IF PEMSTATUS(oThisCtrl,"SelLength",5)
				oThisCtrl.SelLength = _SelLength
			ENDIF
		ENDIF
		
*!*			_elenco = .F.
*!*			IF "?HELP?" $ oThisCtrl.Tag
*!*				ON SELECTION BAR 1 OF _my_shortmenu _elenco = .T.
*!*			ENDIF
				
		ACTIVATE POPUP _my_shortmenu &&NOWAIT

		SELECT &SWSX
				
*!*			IF _elenco = .T.
*!*				oThisCtrl.Value = "?"
*!*				oThisCtrl.Valid
*!*			ENDIF
		
		RETURN
		
	ENDPROC
	
ENDDEFINE
