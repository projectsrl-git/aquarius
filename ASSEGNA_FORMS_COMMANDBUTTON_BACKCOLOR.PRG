
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

_new_color = "212,208,200"
_new_property_1 = "BackColor = " + _new_color + CHR(13) + CHR(10)
_new_property_2 = "DisabledBackColor = " + _new_color + CHR(13) + CHR(10)

_risp = MESSAGEBOX("Impostare le proprietà 'BackColor' e 'DisabledBackColor' su tutti i command button dei form della relativa directory?",4+32+256,"Impostazione proprietà 'BackColor' e 'DisabledBackColor' sui Command button dei form di Aquarius")
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
   WAIT WINDOWS "Rinnovo proprietà 'BackColor' dei Command button in file di form '" + cSCX + "'" NOWAIT
   USE (cSCX) && open the SCX as a table
   SCAN
      IF UPPER(ALLTRIM(baseclass)) == 'COMMANDBUTTON'
      
         _prima = properties
         _dopo  = ""
         IF OCCURS("BackColor",_prima) > 0  && Esiste già la proprietà BackColor personalizzata, quindi la ripulisco
            _succ   = SUBSTR(_prima,AT('BackColor',_prima))
            _chrini = AT("BackColor",_prima)
            _nmchar = AT(CHR(13)+CHR(10),_succ)+1
            _oldtbc = SUBSTR(_prima,_chrini,_nmchar)
            _prima  = STRTRAN(_prima,_oldtbc,"")
            _dopo = _prima + _new_property_1 
            REPLACE Properties WITH _dopo
         ELSE
            _dopo = _prima + _new_property_1 
            REPLACE Properties WITH _dopo
         ENDIF
         
         _prima = properties
         _dopo  = ""
         IF OCCURS("DisabledBackColor",_prima) > 0  && Esiste già la proprietà DisabledBackColor personalizzata, quindi la ripulisco
            _succ   = SUBSTR(_prima,AT('DisabledBackColor',_prima))
            _chrini = AT("DisabledBackColor",_prima)
            _nmchar = AT(CHR(13)+CHR(10),_succ)+1
            _oldtbc = SUBSTR(_prima,_chrini,_nmchar)
            _prima  = STRTRAN(_prima,_oldtbc,"")
            _dopo = _prima + _new_property_2 
            REPLACE Properties WITH _dopo
         ELSE
            _dopo = _prima + _new_property_2 
            REPLACE Properties WITH _dopo
         ENDIF
         
         _CONTAOBJ = _CONTAOBJ + 1
            
      ENDIF
   ENDSCAN
   _CONTAFRM = _CONTAFRM + 1
   USE
ENDFOR

SET DEFA TO &_pub_dir_

WAIT CLEAR

MESSAGEBOX("Operazione completata" + CHR(13) + ;
           "Proprietà 'BackColor' e 'DisabledBackColor' modificate in " + ALLTRIM(STR(_CONTAOBJ,10,0)) + " Command button rilevati in " + ALLTRIM(STR(_CONTAFRM,10,0)) + " form." + CHR(13) + CHR(13) + ;
           "Ricompilare il progetto per attuare le nuove impostazioni",64,"Informazione")

RETURN
