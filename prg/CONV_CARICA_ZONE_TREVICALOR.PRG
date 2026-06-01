*************************************************************************************************
*					         	    CARICAMENTO DBF ZONE TREVICALOR		  			            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2022 : Aster/Trevicalor		 														*
*************************************************************************************************

PERCORSO_TREVICALOR= "D:\Trevicalor\asterdat"
WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
SET DEFAULT TO &PERCORSO_TREVICALOR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA (ZONE) TREVICALOR ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	
	
*!*	**** CARICAMENTO DEL FILE DBF
*!*	TABELLA_INPUT = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

*!*	IF EMPTY(TABELLA_INPUT)
*!*		MESSAGEBOX("Nessun file selezionato",64,"Informazione")
*!*		SET DEFAULT TO &PUB_DIR  
*!*		RETURN
*!*	ENDIF
*!*	WAIT WINDOWS "Selezionato file DBF  >>>>>>>>>>> "+TABELLA_INPUT 
*!*	_NOME_TABELLA = SUBSTR(JUSTFNAME(TABELLA_INPUT),1,AT('.',JUSTFNAME(TABELLA_INPUT),1)-1)
*!*	IF !USED(TABELLA_INPUT)
*!*	   USE &TABELLA_INPUT IN 0 AGAIN
*!*	ENDIF
*!*	SET DEFAULT TO &PUB_DIR

*** CANCELLAZIONE DEI RECORD DELLA TABELLA ZONE
WAIT WINDOWS "Cancellazione ZONE TREVICALOR ...  -  Prego Attendere" NOWAIT

cSql = "delete from PARA where CODICE LIKE 'ZON%' AND CLASSE = 1"   
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF



_V_PERCORSO= "D:\Trevicalor\asterdat"
V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH
=OPENDB("ZONE")
SELECT ZONE

*PUB_DIR     = SYS(2003)
SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio ZONE attendere prego ....." NOWAIT

** CAMPI DA CONVERTIRE
*!*	 ID_ZONA                                                               Character                                                                                                  5                                                   Asc   Machine                                               No
*!*	 DEX                                                                   Character                                                                                                 60                                                   Asc   Machine                                               No
*!*	 N_FORECOLOR                                                           Numeric                                                                                                   16                                                                                                               No
*!*	 N_BACKCOLOR                                                           Numeric                                                                                                   16                                                                                                               No
*!*	 FLAGESCLUSO                                                           Logical                                                                                                    1                                                                                                               No


_CONTA_REC = 0
*SELECT &_NOME_TABELLA
SELECT ZONE
GO TOP 


DO WHILE !EOF()


    IF DELETED()
       SELECT ZONE  && &_NOME_TABELLA  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR MEMO 
 

	IF ISNULL(M.ID_ZONA) 
		M.CODICE   = ""
	ELSE
		M.CODICE   = ALLTRIM(CONV_CLEAR(ID_ZONA))
    ENDIF 	


		
	M.CODICE    ="ZON"+M.CODICE
	M.DESCRI    =ALLTRIM(CONV_CLEAR(M.DEX))


 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

    REPLACE CLASSE WITH 1				&& IDENTIFICA LE ZONE DI ASTERDAT TREVICALOR RISPETTO ALLE ZONE ASSOLO
    REPLACE NOTE   WITH "FORECOLOR: " + STR(N_FORECOLOR,10,0) + " BACKCOLOR " +STR(N_BACKCOLOR,10,0)	
    	
    _CONTA_REC  = _CONTA_REC  + 1
    	
    SELECT ZONE   && &_NOME_TABELLA
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

