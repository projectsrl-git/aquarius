**** riporta il sys su tutti i dettagli della distinta base


DO SETLIB


cSql   = "SELECT * FROM U_DIS_DD " +  " order by dis_gruppo,dis_sequen"
IF !ExecRW(cSql,"U_DIS_DD","R")
   return(.f.)
ENDIF


SELECT U_DIS_DD
GO TOP

DO WHILE .NOT.EOF()

	IF DELETED()
		SELECT U_DIS_DD
	   	SKIP +1
		LOOP
	ENDIF	
 	
	REPLACE DIS_SYSDD  WITH SYS(2015)
   	
	SELECT U_DIS_DD
   	SKIP +1

ENDDO
   
IF !ExecRW("","U_DIS_DD","W")
   return(.f.)
ENDIF
