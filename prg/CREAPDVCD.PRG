**************************************************************************************************************
*																			 								 *
*																			 								 *
* 			 							UTILITY PER CREARE U_PDV_CD											 *
*																			 								 *
*																											 *
**************************************************************************************************************
*


*!*	DUPLICA LA TABELLA U_PDV_CD PER PUNTO DI VENDITA


IF !ExecCommand("select * from U_PDV_CD where 0=1","X_PDV_CD")
  return(.f.)
ENDIF

SELECT X_PDV_CD
HH=AFIELDS(TRANSITO)
CREATE CURSOR W_PDV_CD FROM ARRAY TRANSITO



x_cond = "1=1"

Csql1 = "select * from u_pdv_cd where " + x_cond + " order by pdv_codpdv"


IF !ExecRW(Csql1,"U_PDV_CD","R")
	DO aggiorna_u_ela_an WITH "KO","ERRORE DURANTE LA LETTURA DELLA TABELLA U_PDV_CD"	
    return(.f.)
ENDIF


SELECT U_PDV_CD
GO TOP
SCAN 
	SCATTER MEMVAR MEMO
	INSERT INTO W_PDV_CD FROM MEMVAR
	REPLACE id_unique WITH  " "
	REPLACE PDV_CODPDV WITH  "007"
ENDSCAN

SELECT W_PDV_CD
GO TOP
SCAN 
	SCATTER MEMVAR MEMO
	INSERT INTO U_PDV_CD FROM MEMVAR
ENDSCAN

SELECT U_PDV_CD
GO TOP
BROWSE NORMAL


IF !ExecRW('','U_PDV_CD','I','','U_PDV_CD')
   DO aggiorna_u_ela_an WITH "KO","ERRORE DURANTE L'AGGIORNAMENTO FINALE DELLA TABELLA U_PDV_CD"
   return(.f.)
ENDIF


RETURN


return