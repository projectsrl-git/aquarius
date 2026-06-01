**** riporta il sys su tutte le testate della distinta base


DO SETLIB


cSql   = "SELECT * FROM U_DIS_TT " +  " order by dit_gruppo"
IF !ExecRW(cSql,"U_DIS_TT","R")
   return(.f.)
ENDIF


SELECT U_DIS_TT
GO TOP

DO WHILE .NOT.EOF()

	IF DELETED()
		SELECT U_DIS_TT
	   	SKIP +1
		LOOP
	ENDIF	
 	
	REPLACE DIT_SYSTT  WITH SYS(2015)
   	
	SELECT U_DIS_TT
   	SKIP +1

ENDDO
   
IF !ExecRW("","U_DIS_TT","W")
   return(.f.)
ENDIF
