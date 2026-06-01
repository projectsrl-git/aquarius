*************************************************************************************************
*				    		 CARICAMENTO DBF TARIFFE ORARIE TREVICALOR					        *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2022 : Aster/Trevicalor		 														*
*************************************************************************************************

PERCORSO_TREVICALOR= "D:\Trevicalor\asterdat"
WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
SET DEFAULT TO &PERCORSO_TREVICALOR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA (TARIFFE) TREVICALOR ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	

*** CANCELLAZIONE DEI RECORD DELLA TABELLA TARIFFE
WAIT WINDOWS "Cancellazione TARIFFE TREVICALOR ...  -  Prego Attendere" NOWAIT

cSql = "delete from PARA where CODICE LIKE 'TOR%'"   
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


_V_PERCORSO= "D:\Trevicalor\asterdat"
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH
=OPENDB("TARIFFE")
SELECT TARIFFE


*PUB_DIR     = SYS(2003)
SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio TARIFFE attendere prego ....." NOWAIT

** CAMPI DA CONVERTIRE
*!*	                    1        ID_TARIFFA                                                            Character                                                                                                  3                                                                                                               No
*!*	                    2        DEX                                                                   Character                                                                                                100                                                                                                               No
*!*	                    3        ID_IVA                                                                Character                                                                                                  3                                                                                                               No
*!*	                    4        C_ORARIO                                                              Numeric                                                                                                   11                             2                                                                                 No
*!*	                    5        DIR_FISSO                                                             Numeric                                                                                                   11                             2                                                                                 No
*!*	                    6        ID_DIRFISS                                                            Character                                                                                                  3                                                                                                               No


_CONTA_REC = 0
SELECT TARIFFE
GO TOP 


DO WHILE !EOF()


    IF DELETED()
       SELECT TARIFFE  
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR MEMO 
 

	IF ISNULL(M.ID_TARIFFA) 
		M.CODICE   = ""
	ELSE
		M.CODICE   = ALLTRIM(CONV_CLEAR(M.ID_TARIFFA))
    ENDIF 	


		
	M.CODICE    ="TOR"+M.CODICE
	M.DESCRI    =ALLTRIM(CONV_CLEAR(M.DEX))


 	SELECT curs_PARA							&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 							&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 


    REPLACE PAR_COSTCAD1 WITH M.C_ORARIO  		&& TARIFFA ORARIA
	REPLACE PAR_RICCAD1  WITH M.DIR_FISSO 		&& DIRITTO FISSO
 
   	
    _CONTA_REC  = _CONTA_REC  + 1
    	
    SELECT TARIFFE   && &_NOME_TABELLA
	SKIP

ENDDO


   

SELECT curs_PARA
GO TOP


****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 	 

WAIT WINDOWS "MOVIMENTI INSERITI: "+ STR(_CONTA_REC,5,0)



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

