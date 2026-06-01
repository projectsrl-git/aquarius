
_pub_dir_ = sys(5)+sys(2003)
_report_dir_ = _pub_dir_ + "\report"

IF DIRECTORY(_report_dir_)
ELSE
   MESSAGEBOX("Directory '" + _report_dir_ + "' non trovata",48,"Attenzione")
   SET DEFA TO &_pub_dir_
   RETURN
ENDIF

*** CANCELLAZIONE REPORT NON PIU' UTILIZZATI CHE DANNO PROBLEMI
ERASE famstage.frx
ERASE famstage.frt

SET DEFAULT TO &_report_dir_
lnTotalFrx=ADIR(aFRX,'*.frx')

_risp = MESSAGEBOX("Eliminare le informazioni stampante su tutti i report della relativa directory di Aquarius?",4+32+256,"Eliminazione informazioni stampante su tutti i report di Aquarius")
IF _risp = 6
ELSE
   MESSAGEBOX("Operazione annullata",64,"Informazione")
   SET DEFA TO &_pub_dir_
   RETURN
ENDIF

_CONTA = 0
for nF=1 to lnTotalFrx
   cFRX=aFRX(nF,1)
   WAIT WINDOWS "Elaborazione file di report '" + cFRX + "'" NOWAIT
   USE (cFRX) && open the FRX as a table
   GO TOP
   
   *** MODIFICA CAMPO "EXPR"
   _prima = Expr
   _orien = ""
   _paper = ""
   _color = ""
   _dopo  = ""
   IF OCCURS("ORIENTATION",_prima) > 0
      _succ   = SUBSTR(_prima,AT('ORIENTATION',_prima))
      _chrini = AT("ORIENTATION",_prima)
      _nmchar = AT(CHR(13)+CHR(10),_succ)+1
      _oldprp = SUBSTR(_prima,_chrini,_nmchar)
      _orien = _oldprp 
   ENDIF
   IF OCCURS("PAPERSIZE",_prima) > 0
      _succ   = SUBSTR(_prima,AT('PAPERSIZE',_prima))
      _chrini = AT("PAPERSIZE",_prima)
      _nmchar = AT(CHR(13)+CHR(10),_succ)+1
      _oldprp = SUBSTR(_prima,_chrini,_nmchar)
      _paper = _oldprp 
   ENDIF
   IF OCCURS("COLOR",_prima) > 0
      _succ   = SUBSTR(_prima,AT('COLOR',_prima))
      _chrini = AT("COLOR",_prima)
      _nmchar = AT(CHR(13)+CHR(10),_succ)+1
      _oldprp = SUBSTR(_prima,_chrini,_nmchar)
      _color = _oldprp 
   ENDIF
   _dopo = _orien + _paper + _color 
   REPLACE Expr WITH _dopo
   
   *** MODIFICA CAMPO "TAG"
   _prima = Tag
   _dopo  = ""
   REPLACE Tag WITH ""
   
   *** MODIFICA CAMPO "TAG"
   _prima = Tag2
   _dopo  = ""
   REPLACE Tag2 WITH ""
   
   _CONTA = _CONTA + 1
   USE
ENDFOR

SET DEFA TO &_pub_dir_

WAIT CLEAR

MESSAGEBOX("Operazione completata" + CHR(13) + ;
           "Informazioni stampante eliminate in " + ALLTRIM(STR(_CONTA,10,0)) + " report." + CHR(13) + CHR(13) + ;
           "Non è necessario ricompilare il progetto",64,"Informazione")

RETURN
