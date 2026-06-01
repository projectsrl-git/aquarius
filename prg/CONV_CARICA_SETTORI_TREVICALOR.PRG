*************************************************************************************************
*				      	    CARICAMENTO DBF SETTORI DI APPARTENENZA TREVICALOR			        *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2022 : Aster/Trevicalor		 														*
*************************************************************************************************

PERCORSO_TREVICALOR= "D:\Trevicalor\asterdat"
WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
SET DEFAULT TO &PERCORSO_TREVICALOR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA (SETTORE) TREVICALOR ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	

*** CANCELLAZIONE DEI RECORD DELLA TABELLA SETTORE
WAIT WINDOWS "Cancellazione SETTORE TREVICALOR ...  -  Prego Attendere" NOWAIT

*cSql = "delete from PARA where CODICE LIKE 'SEA%'"   
cSql = "delete from PARA where CODICE LIKE 'SDA%'"  && ERASMO - 30/11/2022
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF




_V_PERCORSO= "D:\Trevicalor\asterdat"
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH
=OPENDB("SETTORE")
SELECT SETTORE

*PUB_DIR     = SYS(2003)
SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio SETTORE attendere prego ....." NOWAIT

** CAMPI DA CONVERTIRE
*!*	                    1        ID_SETTORE                                                            Character                                                                                                  2                                                   Asc   Machine                                               No
*!*	                    2        DEX                                                                   Character                                                                                                 60                                                                                                               No
*!*	                    3        CODVERB                                                               Numeric                                                                                                    6                                                                                                               No
*!*	                    4        ID_DOCU_CORREDO                                                       Character                                                                                                  5                                                                                                               No



_CONTA_REC = 0
SELECT SETTORE
GO TOP 


DO WHILE !EOF()


    IF DELETED()
       SELECT SETTORE  
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR MEMO 
 

	IF ISNULL(M.ID_SETTORE) 
		M.CODICE   = ""
	ELSE
		M.CODICE   = ALLTRIM(CONV_CLEAR(ID_SETTORE))
    ENDIF 	


		
	*M.CODICE    ="SEA"+M.CODICE
	M.CODICE    ="SDA"+M.CODICE  && ERASMO - 30/11/2022
	M.DESCRI    =ALLTRIM(CONV_CLEAR(M.DEX))


 	SELECT curs_PARA							&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 							&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
    REPLACE LIBERA  WITH ID_DOCU_CORREDO
    	
    _CONTA_REC  = _CONTA_REC  + 1
    	
    SELECT SETTORE   && &_NOME_TABELLA
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

