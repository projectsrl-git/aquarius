*************************************************************************************************
*					      	    CARICAMENTO DBF PRESTAZIONI TREVICALOR				            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2022 : Aster/Trevicalor		 														*
*************************************************************************************************

PERCORSO_TREVICALOR= "D:\Trevicalor\asterdat"
WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
SET DEFAULT TO &PERCORSO_TREVICALOR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA (PRESTAZ) TREVICALOR ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PRESTAZ
WAIT WINDOWS "Cancellazione PRESTAZ TREVICALOR ...  -  Prego Attendere" NOWAIT

cSql = "delete from PARA where CODICE LIKE 'ATT%'"   
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF




_V_PERCORSO= "D:\Trevicalor\asterdat"
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH
=OPENDB("PRESTAZ")
SELECT PRESTAZ

*PUB_DIR     = SYS(2003)
SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio PRESTAZ attendere prego ....." NOWAIT

** CAMPI DA CONVERTIRE
*!*	                    1        ID_PREST                                                              Character                                                                                                  3                                                                                                               No
*!*	                    2        DEX                                                                   Character                                                                                                 60                                                   Asc   Machine                                               No
*!*	                    3        UN_MISURA                                                             Character                                                                                                  8                                                                                                               No
*!*	                    4        IMPORTO                                                               Numeric                                                                                                   11                             2                                                                                 No
*!*	                    5        NUM_INTERV                                                            Numeric                                                                                                    3                                                                                                               No
*!*	                    6        ID_CONTRAT                                                            Character                                                                                                  3                                                                                                               No
*!*	                    7        ID_TARIFFA                                                            Character                                                                                                  3                                                                                                               No
*!*	                    8        ID_IVA                                                                Character                                                                                                  3                                                                                                               No
*!*	                    9        MAS_CONTO                                                             Character                                                                                                  8                                                                                                               No
*!*	                   10        PCO_CORRIS                                                            Character                                                                                                  8                                                                                                               No
*!*	                   11        IVA_ANAG                                                              Logical                                                                                                    1                                                                                                               No
*!*	                   12        ATTIVO                                                                Logical                                                                                                    1                                                                                                               No



_CONTA_REC = 0
SELECT PRESTAZ
GO TOP 


DO WHILE !EOF()


    IF DELETED()
       SELECT PRESTAZ  
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR MEMO 
 

	IF ISNULL(M.ID_PREST) 
		M.CODICE   = ""
	ELSE
		M.CODICE   = ALLTRIM(CONV_CLEAR(ID_PREST))
    ENDIF 	


		
	M.CODICE    ="ATT"+M.CODICE
	M.DESCRI    =ALLTRIM(CONV_CLEAR(M.DEX))


 	SELECT curs_PARA							&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 							&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

    REPLACE PERANT			WITH 1    			&& COEFFICENTE DI CALCOLO DELLA TRARIFFA SULLA PRESTAZIONE
	REPLACE CONTO1  		WITH M.UN_MISURA	&& UM  
	REPLACE PAR_COSTCAD1  	WITH M.IMPORTO  	&& IMPORTO PRESTAZIONE
	REPLACE CONTO2  		WITH M.ID_CONTRAT	&& CONTRATTO  
	REPLACE CONTO3  		WITH M.ID_TARIFFA	&& CODICE TARIFFA  
	REPLACE CONTO4  		WITH "5.1.2.1."		&& SERGIO 24/05/2023 FORZATURA MA COMUNQUE E' DA GESTIRE MANUALMENTE IN QUANTO VOGLIONO DIVERSIFICARE LE ATTIVITA' M.MAS_CONTO	&& CONTO CONTABILE


    	
    _CONTA_REC  = _CONTA_REC  + 1
    	
    SELECT PRESTAZ   && &_NOME_TABELLA
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

