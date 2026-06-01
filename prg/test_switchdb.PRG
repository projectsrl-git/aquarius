COMPILE PRG\SQLLIB.PRG
DO setlib

SET PROCEDURE TO PRG\UTILITA.PRG 		ADDITIVE

DO FORM form\pass

cSql="SELECT * FROM U_azi_AN"
   	IF !ExecCommand(cSql,"curU_azi_AN")
		return(.f.)
ENDIF

SELECT curU_azi_AN
BROWSE normal

WAIT WINDOW "PROVO IL COMANDO SwicthDB() senza parametri: va al primo db alternativo impostato"
SwicthDB()

cSql="SELECT * FROM U_azi_AN"
   	IF !ExecCommand(cSql,"curU_azi_AN")
		return(.f.)
ENDIF

SELECT curU_azi_AN
BROWSE normal

WAIT WINDOW "PROVO IL COMANDO SwicthDB(1)"
SwicthDB(1)

cSql="SELECT * FROM U_azi_AN"
   	IF !ExecCommand(cSql,"curU_azi_AN")
		return(.f.)
ENDIF

SELECT curU_azi_AN
BROWSE normal

WAIT WINDOW "PROVO IL COMANDO SwicthDB(2)"
SwicthDB(2)

cSql="SELECT * FROM U_azi_AN"
   	IF !ExecCommand(cSql,"curU_azi_AN")
		return(.f.)
ENDIF

SELECT curU_azi_AN
BROWSE normal

WAIT WINDOW "PROVO IL COMANDO SwicthDB(3)"
SwicthDB(3)

cSql="SELECT * FROM U_azi_AN"
   	IF !ExecCommand(cSql,"curU_azi_AN")
		return(.f.)
ENDIF

SELECT curU_azi_AN
BROWSE normal


WAIT WINDOW "PROVO IL COMANDO SetHomeDB() per tornare al db di partenza di in modo che posso proseguire normalmente l'elaborazione"
SetHomeDB()
cSql="SELECT * FROM U_azi_AN"
   	IF !ExecCommand(cSql,"curU_azi_AN")
		return(.f.)
ENDIF

SELECT curU_azi_AN
BROWSE normal
