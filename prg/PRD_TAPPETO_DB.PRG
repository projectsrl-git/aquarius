
**********************************************************
PROCEDURE RESET_LIVELLI
**********************************************************

	DO RESET_U_PRD_D1
	
	DO RESET_U_PRD_D2
	
	DO RESET_U_PRD_D3
	
	DO RESET_U_PRD_D4
	
	DO RESET_U_PRD_DR
	
	DO RESET_U_PRD_D5
		
* PROCEDURE RESET_LIVELLI
**********************************************************


**********************************************************
PROCEDURE WRITE_LIVELLI
**********************************************************

	IF !ExecRW('','U_PRD_D1','I','','U_PRD_D1')
		return(.f.)
	ENDIF
	
	IF !ExecRW('','U_PRD_D2','I','','U_PRD_D2')
		return(.f.)
	ENDIF
	
	IF !ExecRW('','U_PRD_D3','I','','U_PRD_D3')
		return(.f.)
	ENDIF

	IF !ExecRW('','U_PRD_D4','I','','U_PRD_D4')
		return(.f.)
	ENDIF
	
	IF !ExecRW('','U_PRD_DR','I','','U_PRD_DR')
		return(.f.)
	ENDIF

	IF !ExecRW('','U_PRD_D5','I','','U_PRD_D5')
		return(.f.)
	ENDIF
	
	
* PROCEDURE WRITE_LIVELLI
**********************************************************



**********************************************************
PROCEDURE READ_U_PRD_D1
**********************************************************
	LPARAMETERS _P_PJ_PRGPRD1
	
	LOCAL _PJ_PRGPRD1
	_PJ_PRGPRD1=ALLTRIM(PUB_PJ_PRGPRD1)
	
	IF PCOUNT()=1 
		IF !EMPTY(_P_PJ_PRGPRD1)
			_PJ_PRGPRD1=_P_PJ_PRGPRD1
		ENDIF	
	ENDIF
	
	*** cancella i dati di U_PRD_D1 relativi a questo piano di produzione
	***
	IF USED("U_PRD_D1")
		TABLEREVERT(.T.,"U_PRD_D1")
	ENDIF

	cSql = "select * from U_PRD_D1 where PJ_PRGPRD1='"+_PJ_PRGPRD1+"'"
	IF !ExecRW(cSql,"U_PRD_D1","R")
		return(.f.)
	ENDIF
	
* PROCEDURE READ_U_PRD_D1
**********************************************************


**********************************************************
PROCEDURE WRITE_U_PRD_D1
**********************************************************

	IF !ExecRW("","U_PRD_D1","W")
		return(.f.)
	ENDIF	
	
* PROCEDURE WRITE_U_PRD_D1
**********************************************************

**********************************************************
PROCEDURE RESET_U_PRD_D1
**********************************************************

	*** cancella i dati di U_PRD_D1 relativi a questo piano di produzione
	***
	IF USED("U_PRD_D1")
		TABLEREVERT(.T.,"U_PRD_D1")
	ENDIF

		
	cSql = "DELETE from U_PRD_D1 where PJ_PRGPRD1='"+ALLTRIM(PUB_PJ_PRGPRD1)+"' "
    IF !ExecCommand(CSQL,"U_PRD_D1")
       RETURN (.f.)
    ENDIF  
   
	IF !ExecCommand("select * from U_PRD_D1 where 0=1","U_PRD_D1")
		return(.f.)
	ENDIF


	
* PROCEDURE RESET_U_PRD_D1
**********************************************************

**********************************************************
PROCEDURE RESET_U_PRD_D2
**********************************************************
		
	*** cancella i dati di U_PRD_D2 relativi a questo piano di produzione
	***
	
	cSql = "DELETE from U_PRD_D2 where PJ_PRGPRD1='"+ALLTRIM(PUB_PJ_PRGPRD1)+"' "
    IF !ExecCommand(CSQL,"U_PRD_D2")
       RETURN (.f.)
    ENDIF  
   
	IF !ExecCommand("select * from U_PRD_D2 where 0=1","U_PRD_D2")
		return(.f.)
	ENDIF

	
* PROCEDURE RESET_U_PRD_D2
**********************************************************	

**********************************************************
PROCEDURE RESET_U_PRD_D3
**********************************************************
	
	*** cancella i dati di U_PRD_D3 relativi a questo piano di produzione
	***
	
    cSql = "DELETE from U_PRD_D3 where PJ_PRGPRD1='"+ALLTRIM(PUB_PJ_PRGPRD1)+"'"
    IF !ExecCommand(CSQL,"U_PRD_D3")
       RETURN (.f.)
    ENDIF  
		
	IF !ExecCommand("select * from U_PRD_D3 where 0=1","U_PRD_D3")
		return(.f.)
	ENDIF


* PROCEDURE RESET_U_PRD_D3
**********************************************************	

**********************************************************
PROCEDURE RESET_U_PRD_D4
**********************************************************
	
	*** cancella i dati di U_PRD_D4 relativi a questo piano di produzione
	***
	
    cSql = "DELETE from U_PRD_D4 where PJ_PRGPRD1='"+ALLTRIM(PUB_PJ_PRGPRD1)+"'"
    IF !ExecCommand(CSQL,"U_PRD_D4")
       RETURN (.f.)
    ENDIF  
		
	IF !ExecCommand("select * from U_PRD_D4 where 0=1","U_PRD_D4")
		return(.f.)
	ENDIF

* PROCEDURE RESET_U_PRD_D4
**********************************************************	
	

**********************************************************
PROCEDURE RESET_U_PRD_DR
**********************************************************
	
	*** cancella i dati di U_PRD_DR relativi a questo piano di produzione
	***
	
    cSql = "DELETE from U_PRD_DR where PJ_PRGPRD1='"+ALLTRIM(PUB_PJ_PRGPRD1)+"'"
    IF !ExecCommand(CSQL,"U_PRD_DR")
       RETURN (.f.)
    ENDIF  
		
	IF !ExecCommand("select * from U_PRD_DR where 0=1","U_PRD_DR")
		return(.f.)
	ENDIF


* PROCEDURE RESET_U_PRD_DR
**********************************************************	

**********************************************************
PROCEDURE RESET_U_PRD_D5
**********************************************************
	
	*** cancella i dati di U_PRD_D5 relativi a questo piano di produzione
	***
	
    cSql = "DELETE from U_PRD_D5 where PJ_PRGPRD1='"+ALLTRIM(PUB_PJ_PRGPRD1)+"'"
    IF !ExecCommand(cSql,"U_PRD_D5")
       RETURN (.f.)
    ENDIF  
		
	IF !ExecCommand("select * from U_PRD_D5 where 0=1","U_PRD_D5")
		return(.f.)
	ENDIF


* PROCEDURE RESET_U_PRD_D5
**********************************************************	
		

