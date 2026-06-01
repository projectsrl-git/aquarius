
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
_new_property = "Icon = ..\ICO\2_aquarius.ICO" + CHR(13) + CHR(10)

_opz_overwrite = .F.
_risp = MESSAGEBOX("Sovrascrivere la proprietà 'Icon' anche su form aventi già un'icona personalizzata?",3+32+256,"Impostazione proprietà 'Icon' su tutti i form di Aquarius")

DO CASE

   CASE _risp = 6
      _opz_overwrite = .T.
      
   CASE _risp = 7
      _opz_overwrite = .F.
      
   OTHERWISE
      MESSAGEBOX("Operazione annullata",64,"Informazione")
      SET DEFA TO &_pub_dir_
      RETURN
      
ENDCASE

_CONTA = 0
for nF=1 to lnTotalScx
   cSCX=aSCX(nF,1)
   WAIT WINDOWS "Rinnovo Icona file di form '" + cSCX + "'" NOWAIT
   USE (cSCX) && open the SCX as a table
   SCAN 
      IF ALLTRIM(baseclass) == 'form'
         _prima = properties
         _dopo  = ""
         _none1 = "Icon = ..\" + CHR(13) + CHR(10)
         _none2 = "Icon = ..\" + CHR(13)
         IF _none1 $ _prima 
            _prima = STRTRAN(_prima,_none1,"")
         ENDIF
         IF _none2 $ _prima 
            _prima = STRTRAN(_prima,_none2,"")
         ENDIF
         IF OCCURS("Icon",_prima) > 0  && Esiste già un'icona personalizzata, quindi la ripulisco
            IF _opz_overwrite 
               _succ   = SUBSTR(_prima,AT('Icon',_prima))
               _chrini = AT("Icon",_prima)
               _nmchar = AT(CHR(13)+CHR(10),_succ)+1
               _oldico = SUBSTR(_prima,_chrini,_nmchar)
               _prima  = STRTRAN(_prima,_oldico,"")
               _dopo = _prima + _new_property 
               REPLACE Properties WITH _dopo
               _CONTA = _CONTA + 1
            ELSE
               LOOP
            ENDIF
         ELSE
            _dopo = _prima + _new_property 
            REPLACE Properties WITH _dopo
            _CONTA = _CONTA + 1
         ENDIF
      ENDIF
   ENDSCAN
   USE
ENDFOR

SET DEFA TO &_pub_dir_

WAIT CLEAR

MESSAGEBOX("Operazione completata" + CHR(13) + ;
           "Proprietà 'Icon' modificata in " + ALLTRIM(STR(_CONTA,10,0)) + " files di form." + CHR(13) + CHR(13) + ;
           "Ricompilare il progetto per attuare le nuove impostazioni",64,"Informazione")

RETURN
