**********************************************************************
* 	  Ripristino delle modifiche effettuate sulle aliquite cespiti   *
* 		    Creazione Cursore dalla struttura di U_AMM_PE			 *
**********************************************************************
                  
IF !ExecCommand("SELECT * FROM U_AMM_DD, U_AMM_PE WHERE 0=1","X_AMM_PE")
   RETURN(.F.)
ENDIF
SELECT X_AMM_PE
CONTA=AFIELDS (VETTORE)
CREATE CURSOR CUJ_AMM_PE FROM ARRAY VETTORE

INDEX ON ORD_CATEG TAG CAT ADDITIVE
INDEX ON ORD_DTREGI TAG DAT ADDITIVE

**********************************************************************

TEXT TO xSql NOSHOW
	SELECT * FROM U_AMM_PE
	ORDER BY ORD_DTREGI
ENDTEXT

IF !ExecCommand( xSql, "CUJ_AMM_PE" )
	RETURN (.F.)
ENDIF

IF EOF()
	=MESSAGEBOX( "Nessuna Simulazione è stata effettuata!!",62,"ATTENZIONE" )
	EST_FLAG = .T.
	RETURN .F.
ENDIF

SELECT CUJ_AMM_PE
GO TOP

TEXT TO cSql NOSHOW
	SELECT * FROM CUJ_AMM_PE GROUP BY ORD_CATEG, ORD_PEORI INTO CURSOR CU_RAGGRUP READWRITE
ENDTEXT
&cSql
DO FORM FORM\MENU_UNDOSIM LINKED