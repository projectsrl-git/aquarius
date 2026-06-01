*************************************************************************************************
*				    		 CARICAMENTO DBF DIRITTO FISSO TREVICALOR					        *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2022 : Aster/Trevicalor		 														*
*************************************************************************************************

PERCORSO_TREVICALOR= "D:\Trevicalor\asterdat"
WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
SET DEFAULT TO &PERCORSO_TREVICALOR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA (DIRFISSO) TREVICALOR ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	

*** CANCELLAZIONE DEI RECORD DELLA TABELLA DIRFISSO
WAIT WINDOWS "Cancellazione DIRITTO FISSO TREVICALOR ...  -  Prego Attendere" NOWAIT

cSql = "delete from PARA where CODICE LIKE 'DFI%'"   
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


_V_PERCORSO= "D:\Trevicalor\asterdat"
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH
=OPENDB("DIRFISSO")
SELECT DIRFISSO

*PUB_DIR     = SYS(2003)
SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio DIRFISSO attendere prego ....." NOWAIT

** CAMPI DA CONVERTIRE
*!*	                    1        ID_DIRFISS                                                            Character                                                                                                  3                                                                                                               No
*!*	                    2        DEX                                                                   Character                                                                                                100                                                                                                               No
*!*	                    3        IMPORTO                                                               Numeric                                                                                                   11                             2                                                                                 No
*!*	                    4        ID_IVA                                                                Character                                                                                                  3                                                                                                               No


_CONTA_REC = 0
SELECT DIRFISSO
GO TOP 


DO WHILE !EOF()


    IF DELETED()
       SELECT DIRFISSO  
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR MEMO 
 

	IF ISNULL(M.ID_DIRFISS) 
		M.CODICE   = ""
	ELSE
		M.CODICE   = ALLTRIM(CONV_CLEAR(M.ID_DIRFISS))
    ENDIF 	


		
	M.CODICE    ="DFI"+M.CODICE
	M.DESCRI    =ALLTRIM(CONV_CLEAR(M.DEX))


 	SELECT curs_PARA							&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 							&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 


    REPLACE PAR_COSTCAD1 WITH M.IMPORTO			&& IMPORTO
 
   	
    _CONTA_REC  = _CONTA_REC  + 1
    	
    SELECT DIRFISSO   && &_NOME_TABELLA
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

