CLOSE DATABASES ALL
CLEAR ALL
DO SETLIB

SET DEFAULT TO C:\AQUARIUS\FILE_DA_CONVERTIRE

gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')




IF EMPTY(gcFile)
	THISFORM.VisualizzaMessaggio("Nessun file selezionato.")		
	RETURN
ENDIF

WAIT WINDOWS "Selezionato file EXCEL "+gcFile 		

	
CREATE CURSOR IMPORTAXLS (__RAGSOC  c(35),;
	__INDIRIZZO   c(35),;
	__LOCALITA  c(35),;
	__CAP c(5),;
	__PARTITAIVA  c(11),;
	__CODICEFISCALE c(16),;
	__TELEFONO c(25),;
	__FAX c(25),;
	__CODICEATTIVITA c(06),;
	__DESCRIZIONEATTIVITA c(35),;
	__RICAVOXDIP c(16),;
	__COSTOXDIP c(16))

	
Csql   = "SELECT * FROM U_cli_an WHERE 1=0"
IF !ExecRW(Csql,"CU_CLI_an","R")
	return(.f.)
ENDIF

	
SELECT IMPORTAXLS
APPEND FROM (gcFile) TYPE xls	

SELECT IMPORTAXLS
GO TOP 
BROWSE NORMAL
GO TOP 

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTAXLS   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
        SCATTER MEMVAR memo
        
    	SELECT cu_cli_an
    	APPEND BLANK
    	replace cli_ragsoc WITH m.__RAGSOC  
    	
    	
    	
    SELECT IMPORTAXLS
	SKIP
ENDDO


SELECT cu_cli_an
GO top
BROWSE normal
	

*!*	SET STEP ON 	
*!*	** istruzioni per inserire aggiornare il dbase u_cli_an con l cursor

*!*	IF !ExecRW(Csql,"CU_CLI_an","I")
*!*		return(.f.)
*!*	ENDIF


SET DEFAULT TO C:\AQUARIUS

