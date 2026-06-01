
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

_risp = MESSAGEBOX("Cercare tutti i formset della directory form?",4+32+256,"Ricerca form di tipo FORMSET di Aquarius")
IF _risp = 6
ELSE
   MESSAGEBOX("Operazione annullata",64,"Informazione")
   SET DEFA TO &_pub_dir_
   RETURN
ENDIF

if !file("LISTA_FSET.DBF")
   create dbf LISTA_FSET free (NOME_FILE C(50), NOTA1 C(100), NOTA2 C(100))
   select LISTA_FSET
   USE
ENDIF

USE LISTA_FSET EXCLUSIVE
ZAP

USE

_CONTAFRM = 0
for nF=1 to lnTotalScx
   cSCX=aSCX(nF,1)
   WAIT WINDOWS "Elaborazione file di form '" + cSCX + "'" NOWAIT
   USE (cSCX)  && open the SCX as a table
   GOTO 3
   IF UPPER(ALLTRIM(baseclass)) == 'FORMSET'
      _NOTA2 = ""
      IF "ZTB.START" $ METHODS
         _NOTA2 = "Questo FORMSET potrebbe richiamare la ZTOOLBAR"
      ENDIF
      SCAN
         IF "RELEASE THISFORMSET" $ METHODS
            _OBJNAME = ALLTRIM(OBJNAME)
            _PARENT = ALLTRIM(PARENT)
            USE LISTA_FSET IN 0 AGAIN
            SELECT LISTA_FSET 
            APPEND BLANK
            REPLACE NOME_FILE WITH ALLTRIM(cSCX)
            REPLACE NOTA1 WITH "Stringa 'RELEASE THISFORMSET' presente in " + _OBJNAME + " di " + _PARENT
            REPLACE NOTA2 WITH _NOTA2
            USE
         ENDIF
      ENDSCAN
      _CONTAFRM = _CONTAFRM + 1
   ENDIF
   USE
ENDFOR

WAIT CLEAR

IF _CONTAFRM > 0
   _RISP = MESSAGEBOX("Operazione completata" + CHR(13) + ;
                      "Totale formset rilevati: " + ALLTRIM(STR(_CONTAFRM,10,0)) + CHR(13) + CHR(13) + ;
                      "Visualizzare la lista completa?",32+4,"Informazione")
   IF _RISP = 6
      USE LISTA_FSET IN 0 AGAIN
      BROWSE NORMAL
      SELECT LISTA_FSET
      USE
   ENDIF

ELSE
   MESSAGEBOX("Operazione completata: nessun FORMSET rilevato",64,"Informazione")
ENDIF

SET DEFA TO &_pub_dir_

RETURN
