*************************************************************************************************
*									CONVERSIONE TESTI STANDARD									*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Settembre 2013 : Cardioline			 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei testi standard in formato testo ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


** ASSEGNAZIONE DELLA VARIABILE PATH **************************
		
		
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO

SELECT PERCORSO
V_PATH = ALLTRIM(PER_PATH)

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	RETURN .F.
ENDIF

SET DEFAULT TO &V_PATH 

****** DEFINIZIONE DEI CURSORI STP


IF !ExecCommand("select * from NOTE_COM where 1=0","curs_NOTE_COM")
   return
ENDIF


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHI TESTI STANDARD" NOWAIT
cSql = "delete from NOTE_COM where NOT_CONVERT = 1 "
IF !ExecCommand(cSql,"NOTE_COM")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CODICE_ZONA,_CODICE_PERSONA 
PUBLIC _CODICE_ZONA,_CODICE_PERSONA 
_CODICE_ZONA = 0
_CODICE_PERSONA  = 0


RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO TESTO


gcFile = GETFILE('TXT', '', 'Browse', 1, 'Seleziona')

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	
	RETURN
ENDIF



WAIT WINDOWS "Selezionato file FORMATO TXT >>>>>>>>>>> "+gcFile 		

CREATE CURSOR IMPORTATXT (CAMPO  c(250))
APPEND FROM (gcFile) TYPE sdf	

***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP
SELECT IMPORTATXT
GO TOP 



DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTATXT   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    IF SUBSTR(CAMPO,1,5) = SPACE(05)
       SELECT IMPORTATXT   && scarto record
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO,1,6) = 'Attivo'
       SELECT IMPORTATXT   && scarto record
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO,1,5) = '99999'
       SELECT IMPORTATXT   && scarto record
       SKIP +1
       LOOP
    ENDIF 

    SCATTER MEMVAR MEMO
    
    
*!*	#####################################################

	M.NOT_CONVERT = .T.					&& RECORD CONVERTITO
	M.NOT_CODSOC  = PUB_CODSOC

	_CODICE_PRE  = ALLTRIM(SUBSTR(CAMPO,8,5)) 	
	_CODICE      = ALLTRIM(SUBSTR(CAMPO,8,5))
  		    		

 	M.NOT_CODICE = ALLTRIM (_CODICE)
   	M.NOT_CODICE = UPPER(M.NOT_CODICE)
    M.NOT_CODICE = APITOSPA(M.NOT_CODICE)

	M.NOT_TESTO  = ALLTRIM(SUBSTR(CAMPO,18,50))
   	M.NOT_TESTO  = UPPER(M.NOT_TESTO)
    M.NOT_TESTO  = APITOSPA(M.NOT_TESTO)


    SELECT IMPORTATXT
	SKIP +1		&& MI SPOSTO SUL RECORD SUCCESSIVO PER VERIFICARE LE ROTTURA DEL CODICE TESTO STANDARD
    DO WHILE .NOT. EOF()
        
    	_CODICE_ATT  = ALLTRIM(SUBSTR(CAMPO,8,5))     
        
        IF _CODICE_ATT <> _CODICE_PRE
        	EXIT
        ENDIF		        



		M.NOT_TESTOATT  = ALLTRIM(SUBSTR(CAMPO,18,50))
	   	M.NOT_TESTOATT  = UPPER(M.NOT_TESTOATT)
	    M.NOT_TESTOATT  = APITOSPA(M.NOT_TESTOATT)

        M.NOT_TESTO     = M.NOT_TESTO + CHR(13) + M.NOT_TESTOATT
        
        
        SELECT IMPORTATXT
    	SKIP +1	
    
    ENDDO
    																			
	
	SELECT curs_NOTE_COM				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
			
							   
   	_CTR = _CTR +1
   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
    	
    SELECT IMPORTATXT
	*SKIP


ENDDO




SELECT curs_NOTE_COM
GO TOP

****** AGGIORNA TABELLA NOTE_COM SQL
IF !ExecRW('','NOTE_COM','I','','curs_NOTE_COM')
   return(.f.)
ENDIF
	 




=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 