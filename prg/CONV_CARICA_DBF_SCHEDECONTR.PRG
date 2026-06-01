*************************************************************************************************
*					         	    CARICAMENTO DBF RIFERIMENTI IMPIANTI   			            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Marzo 2022 : Assolo		 			 														*
*************************************************************************************************

SET DEFAULT TO &PUB_DIR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DELLA TABELLA RIFERIMENTI (SCHEDECONTR) IMPIANTI ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	
WAIT WINDOWS "SELEZIONA LA TABELLA : SCHEDECONTR" 
**** CARICAMENTO DEL FILE DBF
TABELLA_INPUT = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

IF EMPTY(TABELLA_INPUT)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF
WAIT WINDOWS "Selezionato file DBF  >>>>>>>>>>> "+TABELLA_INPUT 



*** CANCELLAZIONE DEI RECORD DELLA TABELLA AQ_SCHEDE SQL
WAIT WINDOWS "Cancellazione IMPIANTI_CO ...  -  Prego Attendere" NOWAIT
cSql = "delete from IMPIANTI_CO where 1=1"
IF !ExecCommand(cSql,"IMPIANTI_CO")
   return(.f.)
ENDIF

_NOME_TABELLA = SUBSTR(JUSTFNAME(TABELLA_INPUT),1,AT('.',JUSTFNAME(TABELLA_INPUT),1)-1)
IF !USED(TABELLA_INPUT)
   USE &TABELLA_INPUT IN 0 AGAIN
ENDIF

SET DEFAULT TO &PUB_DIR


WAIT WINDOWS "Caricamento dati archivio CONTRATTI_SERVIZI attendere prego ....." NOWAIT

*!*	                    1        CCODSCHE                                                              Character                                                                                                 20                                                   Asc   Machine                                               No
*!*	                    2        ID_PMKEY                                                              Character                                                                                                 10                                                   Asc   Machine                                               No
*!*	                    3        ID_PMCONTR                                                            Character                                                                                                 10                                                   Asc   Machine                                               No
*!*	                    4        CNOTECONTR                                                            Character                                                                                                254                                                                                                               No
*!*	                    5        CCOSTO                                                                Numeric                                                                                                   19                             5                                                                                 No
*!*	                    6        CINIZCONTR                                                            Date                                                                                                       8                                                                                                               No
*!*	                    7        CSCADCONTR                                                            Date                                                                                                       8                                                                                                               No
*!*	                    8        DT_REGIST                                                             Date                                                                                                       8                                                                                                               No
*!*	                    9        ORA_REGIST                                                            Character                                                                                                  8                                                                                                               No
*!*	                   10        ANNO_CONTR                                                            Character                                                                                                  4                                                                                                               No
*!*	                   11        CONTRATTO                                                             Character                                                                                                 30                                                                                                               No
*!*	                   12        DT_CONFERM                                                            Date                                                                                                       8                                                                                                               No
*!*	                   13        DT_DISDETT                                                            Date                                                                                                       8                                                                                                               No
*!*	                   14        DT_INIZIO                                                             Date                                                                                                       8                                                                                                               No
*!*	                   15        DT_FINE                                                               Date                                                                                                       8                                                                                                               No
*!*	                   16        CRINNOVARE                                                            Logical                                                                                                    1                                                                                                               No
*!*	                   17        TIPO_STAG                                                             Character                                                                                                  3                                                                                                               No




SELECT &_NOME_TABELLA
GO TOP 

SCAN

	SCATTER MEMVAR MEMO
	
	M.ID_PMKEY = ALLTRIM(M.ID_PMKEY)
	M.ID_PMCONTR = ALLTRIM(M.ID_PMCONTR)  && ERASMO - 10/11/2022
		
	WAIT WINDOWS "Contratto caricato: " + M.ID_PMKEY NOWAIT


	**==> CREAZIONE TABELLA IMPIANTO
		
	IF !ExecRW("select * from IMPIANTI_CO where 0=1","IMPIANTI_CO","R")
	   return(.f.)
	ENDIF
	SELECT IMPIANTI_CO
	APPEND BLANK
	GATHER MEMVAR MEMO

	REPLACE CINIZCONTR	WITH RIBALTA2(DTOC(M.CINIZCONTR))              
	REPLACE CSCADCONTR	WITH RIBALTA2(DTOC(M.CSCADCONTR))              
	REPLACE DT_REGIST	WITH RIBALTA2(DTOC(M.DT_REGIST))              
	REPLACE DT_CONFERM	WITH RIBALTA2(DTOC(M.DT_CONFERM))              
	REPLACE DT_DISDETT	WITH RIBALTA2(DTOC(M.DT_DISDETT))              
	REPLACE DT_INIZIO	WITH RIBALTA2(DTOC(M.DT_INIZIO))              
	REPLACE DT_FINE		WITH RIBALTA2(DTOC(M.DT_FINE))              

		
	IF !ExecRW("select * from IMPIANTI_CO where 0=1","IMPIANTI_CO","W")
	   return(.f.)
	ENDIF
	

	SELECT &_NOME_TABELLA
	
ENDSCAN


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

