*************************************************************************************************
*					       VERIFICA STUTTURA SCHEDE IMPIANTI CON BRUCIATORI			            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Settembre 2022 : Assolo		 			 													*
*************************************************************************************************

SET DEFAULT TO &PUB_DIR


RIT = MESSAGEBOX("PROCEDO CON LA VERIFICA DELLA TABELLA SCHEDE IMPIANTI ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	


WAIT WINDOWS "SELEZIONA LA TABELLA IMPIANTI: SCHEDE" 
**** CARICAMENTO DEL FILE DBF
TABELLA_INPUT = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

IF EMPTY(TABELLA_INPUT)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF
WAIT WINDOWS "Selezionato file DBF  >>>>>>>>>>> "+TABELLA_INPUT 



WAIT WINDOWS "SELEZIONA LA TABELLA IMPIANTI: SCHEDEBRU" 
**** CARICAMENTO DEL FILE DBF
TABELLA_BRU= GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

IF EMPTY(TABELLA_BRU)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF
WAIT WINDOWS "Selezionato file DBF  >>>>>>>>>>> "+TABELLA_BRU


** CURSORE DELLE ANOMALIE RISCONTRATE
CREATE CURSOR NONTROVATI (ID_PMKEY c(20),;
    ID_RIGO      c(05),;
    CCODSCHE     c(20),;
	CDITTABRU    c(80),;
	CMODBRU      c(40))
INDEX ON ID_PMKEY+ID_RIGO  TAG I_CODICE
SET ORDER TO I_CODICE 

CREATE CURSOR NONTROVATI2 (ID_PMKEY c(20),;
    ID_RIGO      c(05),;
    CCODSCHE     c(20),;
	CDITTABRU    c(80),;
	CMODBRU      c(40))
INDEX ON ID_PMKEY+ID_RIGO  TAG I_CODICE
SET ORDER TO I_CODICE 

SET EXCLUSIVE ON

*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA AQ_SCHEDE SQL
*!*	WAIT WINDOWS "Cancellazione AQ_SCHEDE ...  -  Prego Attendere" NOWAIT
*!*	cSql = "delete from AQ_SCHEDE where 1=1"
*!*	IF !ExecCommand(cSql,"AQ_SCHEDE")
*!*	   return(.f.)
*!*	ENDIF

_NOME_TABELLA = SUBSTR(JUSTFNAME(TABELLA_INPUT),1,AT('.',JUSTFNAME(TABELLA_INPUT),1)-1)
IF !USED(TABELLA_INPUT)
   USE &TABELLA_INPUT IN 0 AGAIN
ENDIF


_NOME_TABELLA_BRU = SUBSTR(JUSTFNAME(TABELLA_BRU),1,AT('.',JUSTFNAME(TABELLA_BRU),1)-1)
IF !USED(TABELLA_BRU)
   USE &TABELLA_BRU IN 0 AGAIN
ENDIF
SELECT &_NOME_TABELLA_BRU 
INDEX ON ALLTRIM(CCODSCHE)  TAG ID_IMP  ADDITIVE
SET ORDER TO ID_IMP  
GO TOP

SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Verifica dati archivio SCHEDE attendere prego ....." NOWAIT
SET STEP ON 

SELECT &_NOME_TABELLA
GO TOP 

SCAN

	SCATTER MEMVAR MEMO
	
	__CCODSCHE  = ALLTRIM(M.CCODSCHE)
	
	WAIT WINDOWS "Impianto in verifica: " + __CCODSCHE NOWAIT

	SELECT &_NOME_TABELLA_BRU 
	SET ORDER TO ID_IMP    
    _SEEK = __CCODSCHE
    SEEK _SEEK
    
    IF FOUND()
    
    	SELECT NONTROVATI2 
    	ZAP
    	
		SELECT &_NOME_TABELLA_BRU 
    	
     	DO WHILE .NOT. EOF()
     	

            SCATTER MEMVAR MEMO

     		IF ALLTRIM(_SEEK) <> ALLTRIM(M.CCODSCHE)
    			EXIT
    		ENDIF
            
            
			SELECT NONTROVATI2 
			APPEND BLANK
			REPLACE ID_PMKEY     WITH   M.ID_PMKEY 
			REPLACE ID_RIGO      WITH   M.ID_RIGO
			REPLACE CCODSCHE  	 WITH 	M.CCODSCHE  
			REPLACE CDITTABRU    WITH 	M.CDITTABRU    
			REPLACE CMODBRU      WITH 	M.CMODBRU      
 	    	
    		SELECT &_NOME_TABELLA_BRU 
    		SKIP +1
    	
    	
    	ENDDO   	
    	
    	SELECT NONTROVATI2
    	COUNT TO _CONTA_BRU
    	GO TOP

    	IF _CONTA_BRU > 1
    		
    		DO WHILE .NOT. EOF()
    		
    			SCATTER MEMVAR MEMO
    			
    			SELECT NONTROVATI
    			APPEND BLANK
    			GATHER MEMVAR MEMO
    			
    			SELECT NONTROVATI2
    			SKIP +1
    			
    		ENDDO   
    		
    	ENDIF

    ENDIF
    
    
	SELECT &_NOME_TABELLA
    
    
ENDSCAN
    
SET EXCLUSIVE OFF

SELECT NONTROVATI
GO TOP
BROWSE NORMAL
GO TOP

COPY TO BRUC_DOPPI SDF

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

