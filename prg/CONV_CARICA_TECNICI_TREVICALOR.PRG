*************************************************************************************************
*				      	   	   CARICAMENTO DBF TECNICI TREVICALOR						        *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2022 : Aster/Trevicalor		 														*
*************************************************************************************************



__connectString = PUB_NOMEDB
__connectString_DATABASE = SUBSTR(__connectString,AT("DATABASE=",__connectString),AT(';',SUBSTR(__connectString,AT("DATABASE=",__connectString)))-1)
_V_DBAL = STRTRAN(__connectString_DATABASE,"DATABASE=","")
__config_name = "conversioni_" + _V_DBAL + ".cfg"
PERCORSO_TREVICALOR=legge_config(__config_name,"PERCORSO_ASTERDAT")						&& RICERCA VARIABILE
WAIT WINDOWS "PERCORSO ARCHIVI TREVICALOR: " + PERCORSO_TREVICALOR
SET DEFAULT TO &PERCORSO_TREVICALOR



RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA (TECNICI) TREVICALOR ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	

*** CANCELLAZIONE DEI RECORD DELLA TABELLA TECNICI
WAIT WINDOWS "Cancellazione TECNICI TREVICALOR ...  -  Prego Attendere" NOWAIT

cSql = "delete from PARA where CODICE LIKE 'TEI%'"   
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


_V_PERCORSO= PERCORSO_TREVICALOR

SET EXCLUSIVE ON

V_PATH = ALLTRIM(_V_PERCORSO)
SET DEFAULT TO &V_PATH
=OPENDB("TECNICI")
SELECT TECNICI

SET DEFAULT TO &PUB_DIR

WAIT WINDOWS "Caricamento dati archivio TECNICI attendere prego ....." NOWAIT

** CAMPI DA CONVERTIRE
*!*	                    1        ID_TECNICO                                                            Character                                                                                                  3                                                                                                               No
*!*	                    2        ATTIVO                                                                Logical                                                                                                    1                                                                                                               No
*!*	                    3        SOTTOCONTO                                                            Character                                                                                                  4                                                                                                               No
*!*	                    4        DEX                                                                   Character                                                                                                 60                                                   Asc   Machine                                               No
*!*	                    5        INDIRIZZO                                                             Character                                                                                                 60                                                                                                               No
*!*	                    6        LOCALITÀ                                                              Character                                                                                                 60                                                                                                               No
*!*	                    7        PROVINCIA                                                             Character                                                                                                  2                                                                                                               No
*!*	                    8        CAP                                                                   Character                                                                                                  5                                                                                                               No
*!*	                    9        TEL_FAX                                                               Character                                                                                                100                                                                                                               No
*!*	                   10        NOTE                                                                  Character                                                                                                100                                                                                                               No
*!*	                   11        DEX_BREVE                                                             Character                                                                                                 10                                                                                                               No


_CONTA_REC = 0
SELECT TECNICI
GO TOP 


DO WHILE !EOF()


    IF DELETED()
       SELECT TECNICI  
       SKIP +1
       LOOP
    ENDIF 
  
    SCATTER MEMVAR MEMO 
 
 	_INDIRIZZO = ALLTRIM(CONV_CLEAR(M.INDIRIZZO))
 	_LOCALITÀ  = ALLTRIM(CONV_CLEAR(M.LOCALITÀ))
 	_PROVINCIA = ALLTRIM(CONV_CLEAR(M.PROVINCIA))
 	_CAP       = ALLTRIM(CONV_CLEAR(M.CAP))
 	_TEL_FAX   = ALLTRIM(CONV_CLEAR(M.TEL_FAX))
 	_NOTE      = ALLTRIM(CONV_CLEAR(M.NOTE))

	IF ISNULL(M.ID_TECNICO) 
		M.CODICE   = ""
	ELSE
		M.CODICE   = ALLTRIM(CONV_CLEAR(M.ID_TECNICO))
    ENDIF 	


		
	M.CODICE    ="TEI"+M.CODICE
	M.DESCRI    =ALLTRIM(CONV_CLEAR(M.DEX))


 	SELECT curs_PARA							&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 							&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 


    REPLACE LIBERA    WITH _INDIRIZZO			&& INDIRIZZO
	REPLACE DTIPOMOV  WITH _LOCALITÀ			&& LOCALITA'
	REPLACE CONTO1    WITH _CAP  				&& CAP
	REPLACE CONTO2    WITH _PROVINCIA			&& PROVINCA 
	REPLACE NOTE      WITH _NOTE   				&& NOTE
	REPLACE CONTO3    WITH _TEL_FAX   			&& TELEFONO/FAX
 
   	
    _CONTA_REC  = _CONTA_REC  + 1
    	
    SELECT TECNICI   && &_NOME_TABELLA
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

