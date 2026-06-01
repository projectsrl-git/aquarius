
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
_new_property = "Themes = .F." + CHR(13) + CHR(10)

_risp = MESSAGEBOX("Impostare la proprietà 'Themes' a FALSE su tutti i form della relativa directory e sulle Toolbar Aquarius?",4+32+256,"Impostazione proprietà 'Themes' su tutti i form di Aquarius")
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
   WAIT WINDOWS "Rinnovo proprietà 'Themes' file di form '" + cSCX + "'" NOWAIT
   USE (cSCX) && open the SCX as a table
   SCAN
      IF UPPER(ALLTRIM(baseclass)) == 'FORM' .OR. UPPER(ALLTRIM(baseclass)) == 'GRID' .OR. UPPER(ALLTRIM(baseclass)) == 'COMMANDBUTTON' .OR. ;
         UPPER(ALLTRIM(baseclass)) == 'PAGEFRAME' .OR. UPPER(ALLTRIM(baseclass)) == 'SPINNER' .OR. UPPER(ALLTRIM(baseclass)) == 'CHECKBOX' .OR. ;
         UPPER(ALLTRIM(baseclass)) == 'IMAGE' .OR. UPPER(ALLTRIM(baseclass)) == 'OPTIONGROUP'  .OR. UPPER(ALLTRIM(baseclass)) == 'COMBOBOX'
         _prima = properties
         _dopo  = ""
         _case1 = "Themes = .T." + CHR(13) + CHR(10)
         _case2 = "Themes = .T." + CHR(13)
         _case3 = "Themes = .F." + CHR(13) + CHR(10)
         _case4 = "Themes = .F." + CHR(13)
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
         IF OCCURS("Themes",_prima) > 0  && Esiste già la proprietà Themes personalizzata, quindi la ripulisco
            _succ   = SUBSTR(_prima,AT('Themes',_prima))
            _chrini = AT("Themes",_prima)
            _nmchar = AT(CHR(13)+CHR(10),_succ)+1
            _oldthm = SUBSTR(_prima,_chrini,_nmchar)
            _prima  = STRTRAN(_prima,_oldthm,"")
            _dopo = _prima + _new_property 
            REPLACE Properties WITH _dopo
            _CONTAOBJ = _CONTAOBJ + 1
         ELSE
            _dopo = _prima + _new_property 
            REPLACE Properties WITH _dopo
            _CONTAOBJ = _CONTAOBJ + 1
         ENDIF
      ENDIF
   ENDSCAN
   _CONTAFRM = _CONTAFRM + 1
   USE
ENDFOR

SET DEFA TO &_pub_dir_

*** MODIFICA PROPRIETA' NELLE TOOLBAR AQUARIUS
IF FILE("ZCLASLIB.VCX")
   WAIT WINDOWS "Rinnovo proprietà 'Themes' Toolbar Aquarius'" NOWAIT
   USE ZCLASLIB.VCX
   SCAN
      IF UPPER(ALLTRIM(baseclass)) == 'FORM' .OR. UPPER(ALLTRIM(baseclass)) == 'GRID' .OR. UPPER(ALLTRIM(baseclass)) == 'COMMANDBUTTON' .OR. ;
         UPPER(ALLTRIM(baseclass)) == 'PAGEFRAME' .OR. UPPER(ALLTRIM(baseclass)) == 'SPINNER' .OR. UPPER(ALLTRIM(baseclass)) == 'CHECKBOX' .OR. ;
         UPPER(ALLTRIM(baseclass)) == 'IMAGE' .OR. UPPER(ALLTRIM(baseclass)) == 'OPTIONGROUP'  .OR. UPPER(ALLTRIM(baseclass)) == 'COMBOBOX'
         _prima = properties
         _dopo  = ""
         _case1 = "Themes = .T." + CHR(13) + CHR(10)
         _case2 = "Themes = .T." + CHR(13)
         _case3 = "Themes = .F." + CHR(13) + CHR(10)
         _case4 = "Themes = .F." + CHR(13)
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
         IF OCCURS("Themes",_prima) > 0  && Esiste già la proprietà Themes personalizzata, quindi la ripulisco ### QUESTO CASO NON SI DOVREBBE VERIFICARE MAI INQUANTO LA VARIABILE _prima E' STATA APPENA RIPULITA DALLA PROPRIETA' THEMES
            _succ   = SUBSTR(_prima,AT('Themes',_prima))
            _chrini = AT("Themes",_prima)
            _nmchar = AT(CHR(13)+CHR(10),_succ)+1
            _oldthm = SUBSTR(_prima,_chrini,_nmchar)
            _prima  = STRTRAN(_prima,_oldthm,"")
            _dopo = _prima + _new_property 
            REPLACE Properties WITH _dopo
            _CONTAOBJ = _CONTAOBJ + 1
         ELSE
            _dopo = _prima + _new_property 
            REPLACE Properties WITH _dopo
            _CONTAOBJ = _CONTAOBJ + 1
         ENDIF
      ENDIF
   ENDSCAN
   _CONTAFRM = _CONTAFRM + 1
   USE
ENDIF

WAIT CLEAR

MESSAGEBOX("Operazione completata" + CHR(13) + ;
           "Proprietà 'Themes' modificata in " + ALLTRIM(STR(_CONTAOBJ,10,0)) + " oggetti rilevati in " + ALLTRIM(STR(_CONTAFRM,10,0)) + " form." + CHR(13) + CHR(13) + ;
           "Ricompilare il progetto per attuare le nuove impostazioni",64,"Informazione")

RETURN
