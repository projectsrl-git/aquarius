*!*	##############################################################################################################

					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE FUNZIONI DI UTILITA                               ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################

******************************************************************
PROCEDURE START_LOG
******************************************************************
PARA V_MSG
*DO ADDLOG WITH "Inizio Procedura: "+V_MSG
*DO ADDOPE WITH V_MSG

RETURN

******************************************************************
PROCEDURE END_LOG
******************************************************************
PARA V_MSG
*DO ADDLOG WITH "Fine Procedura: "+V_MSG
*DO ADDOPE WITH ""
RETURN

******************************************************************
PROCEDURE SETMENU
******************************************************************
HH=SELECT()
IF !ExecCommand("select * from res_menu","Res_Menu")
  return
ENDIF
SELECT res_menu
GO TOP
DO WHILE !EOF()
   V_VARNAME=RES_VAR
   PUBLIC &V_VARNAME
   IF '.'+ALLTRIM(PUB_CODOPE)+'.' $ RES_USER
      &V_VARNAME=.F.
   ELSE
      &V_VARNAME=.T.   
   ENDIF
   SKIP
ENDDO
SELECT(HH)
RETURN
*:EOF - PROCEDURE SETMENU

******************************************************************
PROCEDURE ADDLOG
******************************************************************
PARA V_MSG
V_SS=SELECT()
IF !ExecRW("select * from log_user where 1=0","Log_User","R")
  return
ENDIF
SELECT log_user
APPEND BLANK
REPLACE OPERATORE  WITH PUB_CODOPE
REPLACE DESCRI     WITH PUB_nomope
REPLACE DATA       WITH RIBALTA2(DTOC(DATE()))
REPLACE ORA        WITH TIME()
REPLACE OPERAZIONE WITH V_MSG
REPLACE SPID       WITH PUB_SPID  && ERASMO - 16/01/2014
REPLACE PID        WITH getcurrentprocessid(0)  && ERASMO - 06/12/2022
IF !ExecRW("","Log_User","W")
  return
ENDIF
SELECT(V_SS)
RETURN
*:EOF - PROCEDURE ADDLOG

******************************************************************
PROCEDURE ADDOPE
******************************************************************
PARA V_MSG
V_SS=SELECT()

IF !ExecRW("select * from res_oper where codice=?pub_codope","Res_Oper","R")
  return
ENDIF

SELECT res_oper
REPLACE PROCEDURA WITH V_MSG

IF !ExecRW("","Res_Oper","W")
  return
ENDIF

SELECT(V_SS)
RETURN
*:EOF - PROCEDURE ADDLOG


******************************************************************
PROCEDURE FORMTOLOG
******************************************************************
PARA V_MSG


V_MSG = STRTRAN(V_MSG,"'","`")

V_SS=SELECT()
*!*	LOCAL x_key1,x_key2,x_key3,x_key4,x_key
*!*	x_key1 = "OPERATORE  = '" + PUB_CODOPE + "'"
*!*	x_key2 = "DATA       = '" + RIBALTA2(DTOC(DATE())) + "'"
*!*	x_key3 = "OPERAZIONE = '" + V_MSG + "'"
*!*	x_key4 = "SPID       = '" + PUB_SPID + "'"
*!*	x_key  = x_key1 + " and " + x_key2 + " and " + x_key3 + " and " + x_key4
*!*	IF !ExecRW("select TOP 1 * from log_user where " + x_key + " ORDER BY DATA DESC, ORA DESC","Log_User","R")
IF !ExecRW("select * from log_user where 1=0","Log_User","R")  && ERASMO - 09/06/2015
  return
ENDIF
SELECT log_user
GO TOP
IF EOF()
	APPEND BLANK
	REPLACE OPERATORE  WITH PUB_CODOPE
	REPLACE DESCRI     WITH PUB_nomope
	REPLACE DATA       WITH RIBALTA2(DTOC(DATE()))
	REPLACE ORA        WITH TIME()
	REPLACE OPERAZIONE WITH V_MSG
	REPLACE SPID       WITH PUB_SPID
	REPLACE PID        WITH getcurrentprocessid(0)  && ERASMO - 06/12/2022
ENDIF
IF !ExecRW("","Log_User","W")
  return
ENDIF
SELECT(V_SS)
RETURN

******************************************************************
PROCEDURE FORMTOOPE
******************************************************************
PARA V_MSG

V_MSG = STRTRAN(V_MSG,"'","`")

V_SS=SELECT()

IF !ExecRW("select * from res_oper where codice=?pub_codope","Res_Oper","R")
  return
ENDIF

SELECT res_oper
REPLACE PROCEDURA WITH V_MSG

IF !ExecRW("","Res_Oper","W")
  return
ENDIF

SELECT(V_SS)
RETURN


******************************************************************
FUNCTION ENCODE
******************************************************************
PARA V1
V2=""
FOR X=1 TO LEN(V1)
   V2=V2+CHR(ASC(SUBSTR(V1,X,1))-3)
NEXT
RETURN(V2)
*:EOF - FUNCTION ENCODE

******************************************************************
FUNCTION DECODE
******************************************************************
PARA V1
V2=""
FOR X=1 TO LEN(V1)
   V2=V2+CHR(ASC(SUBSTR(V1,X,1))+3)
NEXT
RETURN(V2)
*:EOF - FUNCTION DECODE


******************************************************************
PROCEDURE RESPROC
******************************************************************
PARA V_PROCNAME
V_PROCNAME=ALLTRIM(UPPER(V_PROCNAME))
V_PROCNAME=PADR(V_PROCNAME,10)
V_CODOPE=PADR(ALLTRIM(PUB_CODOPE),10)
VVV=SELECT()

ZTB.AGGIUNGI(.T.)
ZTB.CANCELLA(.T.)
ZTB.MODIFICA(.T.)

*************************************************
* -->> scrivo la query da eseguire in sql
*************************************************
TEXT TO cSql NOSHOW
	SELECT * 
	from res_proc
	WHERE utente=?v_codope
	and procedura=?v_procname
ENDTEXT

IF !ExecCommand(cSql,"Res_Proc")
  return
ENDIF

*************************************************

SELECT RES_PROC
GO top
IF reccount() <> 0
*** WAIT WINDOW 'TROVATO'+_SKK+'<<'
  IF INSERIMENT
	  ZTB.AGGIUNGI(.T.)
  ELSE
	  ZTB.AGGIUNGI(.F.)
  ENDIF	  
  IF CANCELLAZI
	  ZTB.CANCELLA(.T.)
  ELSE
	  ZTB.CANCELLA(.F.)
  ENDIF	  
  IF MODIFICA
	  ZTB.MODIFICA(.T.)
  ELSE
	  ZTB.MODIFICA(.F.)
  ENDIF	  
ELSE
**** WAIT WINDOW 'non TROVATO'+_SKK+'<<'

  ZTB.AGGIUNGI(.T.)
  ZTB.CANCELLA(.T.)
  ZTB.MODIFICA(.T.)
ENDIF
SELECT(VVV)
RETURN

**************************************************************
PROCEDURE POSTEL
**************************************************************
RETURN
*!*	IF !PUB_TIMER 
*!*	  RETURN
*!*	ENDIF

*!*	_S_ALVA=STR(SELECT())
*!*	SET_NEAR = SET("NEAR")
*!*	SET EXACT OFF

*!*	=OPENDB("PJMAIL")
*!*	SELECT PJMAIL
*!*	SET ORDER TO ULTIMO
*!*	SET NEAR ON
*!*	SEEK ALLTRIM(PUB_CODOPE)+"M"
*!*	SET EXACT ON


*!*	IF  ALLTRIM(OPERATORE) <> ALLTRIM(PUB_CODOPE) 
*!*	  SET NEAR &SET_NEAR
*!*	  ZTF.MAIL.PICTURE="GRIGIO.BMP"
*!*	  SELECT &_S_ALVA
*!*	  RETURN
*!*	ENDIF


*!*	IF TIPO <> "M"
*!*	  SET NEAR &SET_NEAR
*!*	  ZTF.MAIL.PICTURE="GRIGIO.BMP"
*!*	  SELECT &_S_ALVA
*!*	  RETURN
*!*	ENDIF

*!*	IF !EMPTY(STATO)
*!*	  SET NEAR &SET_NEAR
*!*	  ZTF.MAIL.PICTURE="GRIGIO.BMP"
*!*	  SELECT &_S_ALVA
*!*	  RETURN
*!*	ENDIF

*!*	SET NEAR &SET_NEAR
*!*	SELECT &_S_ALVA

*!*	*IF ZTF.MAIL.CAPTION="." 
*!*	*  ZTF.MAIL.CAPTION=""
*!*	*ELSE
*!*	*  ZTF.MAIL.CAPTION="."
*!*	*ENDIF


*!*	ZTF.MAIL.PICTURE="BANDIERA.BMP"


*!*	*IF ZTF.MAIL.PICTURE="BANGRIGIO.BMP" .OR. ZTF.MAIL.PICTURE="GRIGIO.BMP"
*!*	*  ZTF.MAIL.PICTURE="ROSSO.BMP"
*!*	*ELSE
*!*	*  ZTF.MAIL.PICTURE="GRIGIO.BMP"
*!*	*ENDIF


*!*	RETURN




