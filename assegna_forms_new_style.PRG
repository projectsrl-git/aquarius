
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
_new_property1 = "HalfHeightCaption = .T." + CHR(13) + CHR(10)
_new_property2 = "BorderStyle = 1" + CHR(13) + CHR(10)
_new_property3 = "MaxButton = .F." + CHR(13) + CHR(10)
_new_property4 = "MinButton = .F." + CHR(13) + CHR(10)

_risp = MESSAGEBOX("Impostare il nuovo stile dei form per la directory '" + _form_dir_ + "' ?",4+32+256,"Impostazione proprietà su tutti i form di Aquarius")
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
	WAIT WINDOWS "Rinnovo proprietà in file di form '" + cSCX + "'" NOWAIT
	USE (cSCX) && open the SCX as a table
	SCAN
		IF UPPER(ALLTRIM(baseclass)) == 'FORM'
			IF "TitleBar = 0" $ properties  && SOLO I FORM CON BARRA DEL TITOLO IN MOSTRA
				LOOP
			ENDIF
			
			*** IMPOSTAZIONE PROPRIETA' "HalfHeightCaption = .T."
			_prima = properties
			_dopo  = ""
			_case1 = "HalfHeightCaption = .T." + CHR(13) + CHR(10)
			_case2 = "HalfHeightCaption = .T." + CHR(13)
			_case3 = "HalfHeightCaption = .F." + CHR(13) + CHR(10)
			_case4 = "HalfHeightCaption = .F." + CHR(13)
			IF _case1 $ _prima
				_prima = STRTRAN(_prima,_case1,"")
			ENDIF
			IF _case2 $ _prima
				_prima = STRTRAN(_prima,_case2,"")
			ENDIF
			IF _case3 $ _prima
				_prima = STRTRAN(_prima,_case3,"")
			ENDIF
			IF _case4 $ _prima
				_prima = STRTRAN(_prima,_case4,"")
			ENDIF
			IF OCCURS("HalfHeightCaption",_prima) > 0
				_succ	= SUBSTR(_prima,AT('HalfHeightCaption',_prima))
				_chrini = AT("HalfHeightCaption",_prima)
				_nmchar = AT(CHR(13)+CHR(10),_succ)+1
				_oldthm = SUBSTR(_prima,_chrini,_nmchar)
				_prima  = STRTRAN(_prima,_oldthm,"")
				_dopo = _prima + _new_property1
				REPLACE Properties WITH _dopo
				_CONTAOBJ = _CONTAOBJ + 1
			ELSE
				_dopo = _prima + _new_property1
				REPLACE Properties WITH _dopo
				_CONTAOBJ = _CONTAOBJ + 1
			ENDIF
			
			*** IMPOSTAZIONE PROPRIETA' "BorderStyle = 1" (Fixed Single)
			_prima = properties
			_dopo  = ""
			_case1 = "BorderStyle = 0" + CHR(13) + CHR(10)
			_case2 = "BorderStyle = 0" + CHR(13)
			_case3 = "BorderStyle = 1" + CHR(13) + CHR(10)
			_case4 = "BorderStyle = 1" + CHR(13)
			_case5 = "BorderStyle = 2" + CHR(13) + CHR(10)
			_case6 = "BorderStyle = 2" + CHR(13)
			_case7 = "BorderStyle = 3" + CHR(13) + CHR(10)
			_case8 = "BorderStyle = 3" + CHR(13)
			IF _case1 $ _prima
				_prima = STRTRAN(_prima,_case1,"")
			ENDIF
			IF _case2 $ _prima
				_prima = STRTRAN(_prima,_case2,"")
			ENDIF
			IF _case3 $ _prima
				_prima = STRTRAN(_prima,_case3,"")
			ENDIF
			IF _case4 $ _prima
				_prima = STRTRAN(_prima,_case4,"")
			ENDIF
			IF _case5 $ _prima
				_prima = STRTRAN(_prima,_case4,"")
			ENDIF
			IF _case6 $ _prima
				_prima = STRTRAN(_prima,_case4,"")
			ENDIF
			IF _case7 $ _prima
				_prima = STRTRAN(_prima,_case4,"")
			ENDIF
			IF _case8 $ _prima
				_prima = STRTRAN(_prima,_case4,"")
			ENDIF
			IF OCCURS("BorderStyle",_prima) > 0
				_succ	= SUBSTR(_prima,AT('BorderStyle',_prima))
				_chrini = AT("BorderStyle",_prima)
				_nmchar = AT(CHR(13)+CHR(10),_succ)+1
				_oldthm = SUBSTR(_prima,_chrini,_nmchar)
				_prima  = STRTRAN(_prima,_oldthm,"")
				_dopo = _prima + _new_property2
				REPLACE Properties WITH _dopo
				_CONTAOBJ = _CONTAOBJ + 1
			ELSE
				_dopo = _prima + _new_property2
				REPLACE Properties WITH _dopo
				_CONTAOBJ = _CONTAOBJ + 1
			ENDIF
			
			*** IMPOSTAZIONE PROPRIETA' "MaxButton = .F."
			_prima = properties
			_dopo  = ""
			_case1 = "MaxButton = .T." + CHR(13) + CHR(10)
			_case2 = "MaxButton = .T." + CHR(13)
			_case3 = "MaxButton = .F." + CHR(13) + CHR(10)
			_case4 = "MaxButton = .F." + CHR(13)
			IF _case1 $ _prima
				_prima = STRTRAN(_prima,_case1,"")
			ENDIF
			IF _case2 $ _prima
				_prima = STRTRAN(_prima,_case2,"")
			ENDIF
			IF _case3 $ _prima
				_prima = STRTRAN(_prima,_case3,"")
			ENDIF
			IF _case4 $ _prima
				_prima = STRTRAN(_prima,_case4,"")
			ENDIF
			IF OCCURS("MaxButton",_prima) > 0
				_succ	= SUBSTR(_prima,AT('MaxButton',_prima))
				_chrini = AT("MaxButton",_prima)
				_nmchar = AT(CHR(13)+CHR(10),_succ)+1
				_oldthm = SUBSTR(_prima,_chrini,_nmchar)
				_prima  = STRTRAN(_prima,_oldthm,"")
				_dopo = _prima + _new_property3
				REPLACE Properties WITH _dopo
				_CONTAOBJ = _CONTAOBJ + 1
			ELSE
				_dopo = _prima + _new_property3
				REPLACE Properties WITH _dopo
				_CONTAOBJ = _CONTAOBJ + 1
			ENDIF
			
			*** IMPOSTAZIONE PROPRIETA' "MinButton = .F."
			_prima = properties
			_dopo  = ""
			_case1 = "MinButton = .T." + CHR(13) + CHR(10)
			_case2 = "MinButton = .T." + CHR(13)
			_case3 = "MinButton = .F." + CHR(13) + CHR(10)
			_case4 = "MinButton = .F." + CHR(13)
			IF _case1 $ _prima
				_prima = STRTRAN(_prima,_case1,"")
			ENDIF
			IF _case2 $ _prima
				_prima = STRTRAN(_prima,_case2,"")
			ENDIF
			IF _case3 $ _prima
				_prima = STRTRAN(_prima,_case3,"")
			ENDIF
			IF _case4 $ _prima
				_prima = STRTRAN(_prima,_case4,"")
			ENDIF
			IF OCCURS("MinButton",_prima) > 0
				_succ	= SUBSTR(_prima,AT('MinButton',_prima))
				_chrini = AT("MinButton",_prima)
				_nmchar = AT(CHR(13)+CHR(10),_succ)+1
				_oldthm = SUBSTR(_prima,_chrini,_nmchar)
				_prima  = STRTRAN(_prima,_oldthm,"")
				_dopo = _prima + _new_property4
				REPLACE Properties WITH _dopo
				_CONTAOBJ = _CONTAOBJ + 1
			ELSE
				_dopo = _prima + _new_property4
				REPLACE Properties WITH _dopo
				_CONTAOBJ = _CONTAOBJ + 1
			ENDIF
		ENDIF
	ENDSCAN
	_CONTAFRM = _CONTAFRM + 1
	USE
ENDFOR

SET DEFA TO &_pub_dir_

WAIT CLEAR

MESSAGEBOX("Operazione completata" + CHR(13) + ;
			  "Modificate " + ALLTRIM(STR(_CONTAOBJ,10,0)) + " proprietà rilevate in " + ALLTRIM(STR(_CONTAFRM,10,0)) + " form." + CHR(13) + CHR(13) + ;
			  "Ricompilare il progetto per attuare le nuove impostazioni",64,"Informazione")

RETURN
