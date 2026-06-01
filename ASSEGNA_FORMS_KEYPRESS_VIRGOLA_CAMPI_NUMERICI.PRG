
_pub_dir_ = sys(5)+sys(2003)
_form_dir_ = _pub_dir_ + "\form"

IF DIRECTORY(_form_dir_)
ELSE
	MESSAGEBOX("Directory '" + _form_dir_ + "' non trovata",48,"Attenzione")
	SET DEFA TO &_pub_dir_
	RETURN
ENDIF

SET DEFAULT TO &_form_dir_
lnTotalScx=ADIR(aSCX,'*.scx')

_new_procedure_keypress = ""
TEXT TO _new_procedure_keypress NOSHOW
PROCEDURE KeyPress
LPARAMETERS nKeyCode, nShiftAltCtrl

IF nKeyCode = ASC('.')
	KEYBOARD ","
	NODEFAULT
ENDIF
ENDPROC
ENDTEXT

_risp = MESSAGEBOX("Impostare il metodo 'KeyPress' per interpretare il punto come virgola su tutti i TextBox numerici dei form di Aquarius della relativa directory?",4+32+256,"Impostazione metodo 'KeyPress' per TextBox numerici dei form di Aquarius")
IF _risp = 6
ELSE
	MESSAGEBOX("Operazione annullata",64,"Informazione")
	SET DEFA TO &_pub_dir_
	RETURN
ENDIF

_CONTAFRM = 0
_CONTAOBJ = 0
for nF=1 to lnTotalScx
	cSCX=aSCX(nF,1)
	IF UPPER(ALLTRIM(cSCX)) == "MENU_PRIMANOT.SCX"
	ELSE
		LOOP
	ENDIF
	WAIT WINDOWS "Impostazione metodo 'KeyPress' in file di form '" + cSCX + "'" NOWAIT
	USE (cSCX) && open the SCX as a table
	SCAN
		IF UPPER(ALLTRIM(baseclass)) == 'TEXTBOX'
			
			_properties = properties
			_rigaInputMask = ""
			IF OCCURS("InputMask",_properties) > 0  && Esiste già la proprietà BackColor personalizzata, quindi la ripulisco
				_succ	= SUBSTR(_properties,AT('InputMask',_properties))
				_chrini = AT("InputMask",_properties)
				_nmchar = AT(CHR(13)+CHR(10),_succ)+1
				_rigaInputMask = SUBSTR(_properties,_chrini,_nmchar)
			ENDIF
			IF "9.9" $ _rigaInputMask  && solo se cè un inputmask numerico con decimali
			ELSE
				LOOP
			ENDIF
			
			_prima = Methods 
			_dopo  = ""
			IF OCCURS("PROCEDURE KeyPress",_prima) > 0  && Esiste già il metodo KeyPress
				LOOP
			ELSE
				_dopo = _prima + CHR(13) + CHR(10) + _new_procedure_keypress + CHR(13) + CHR(10)
				REPLACE Methods WITH _dopo
			ENDIF
			
			_CONTAOBJ = _CONTAOBJ + 1
				
		ENDIF
	ENDSCAN
	_CONTAFRM = _CONTAFRM + 1
	USE
	
	_command = "COMPILE FORM " + JUSTSTEM(cSCX)
	&_command
ENDFOR

SET DEFA TO &_pub_dir_

WAIT CLEAR

MESSAGEBOX("Operazione completata" + CHR(13) + ;
			  "Metodo 'KeyPress' per interpretare il punto come virgola su tutti i TextBox numerici impostato in " + ALLTRIM(STR(_CONTAOBJ,10,0)) + " TextBox rilevati in " + ALLTRIM(STR(_CONTAFRM,10,0)) + " form." + CHR(13) + CHR(13) + ;
			  "Ricompilare il progetto per attuare le nuove impostazioni",64,"Informazione")

RETURN
