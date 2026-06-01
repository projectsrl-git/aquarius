**************************************************************************************************************
*																			 								 *
*																			 								 *
* 			 							UTILITY PER ESTRARRE U_PDV_CD											 *
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

SET STEP ON 

x_cond = "1=1"

Csql1 = "select * from u_pdv_cd where " + x_cond + " order by pdv_codpdv"


IF !ExecRW(Csql1,"U_PDV_CD","R")
	DO aggiorna_u_ela_an WITH "KO","ERRORE DURANTE LA LETTURA DELLA TABELLA U_PDV_CD"	
    return(.f.)
ENDIF


SELECT U_PDV_CD
GO TOP
DELETE ALL


APPEND FROM SU_PDV_CD

IF !ExecRW('','U_PDV_CD','I','','U_PDV_CD')
   return(.f.)
ENDIF




return