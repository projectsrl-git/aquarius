*************************************************************************************************
*							CONVERSIONE ANAGRAFICA Clienti										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2010 				 																*
*************************************************************************************************

*** DEFINIZIONE VARIABILI


*** conferma utente

		RIT = MESSAGEBOX("Procedo con la creazione "+CHR(13)+"della tabella di decodifica anagrafiche clienti ?",292,"ATTENZIONE")
		IF RIT = 7 
		   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
		   RETURN
		ENDIF




****** DEFINIZIONE DEI CURSORI STP


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA CLIENTI" NOWAIT

		IF !ExecCommand("select * from U_CLI_EX where 1=0","curs_U_CLI_EX")
		   return
		ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CLI_EX SQL ESCLUDENDO IL CODICE CLIENTE STUDIO PER LA GESTIONE AZIENDA



		cSql   = "delete from U_CLI_EX " 
		IF !ExecCommand(cSql,"U_CLI_EX")
		   return(.f.)
		ENDIF


******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO



******** ELABORA ANAGRAFICA CLIENTI 


x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP

CTRELAB = 0

DO WHILE .T.
   
    IF EOF()
       EXIT
    ENDIF

    IF DELETED()
       SKIP +1
       LOOP
    ENDIF   

    M.CODCLI_AQUARIUS = CLI_CODCLI 
    M.RAGSOC_AQUARIUS = CLI_RAGSOC 

    SELECT curs_U_CLI_EX
    APPEND BLANK
    
    REPLACE ID_UNIQUE       	WITH "" 
	REPLACE CODCLI_AQUARIUS 	WITH M.CODCLI_AQUARIUS 
	REPLACE RAGSOC_AQUARIUS 	WITH M.RAGSOC_AQUARIUS 	
 
    CTRELAB = CTRELAB +1
    WAIT WINDOWS "Numero clienti elaborati : " + STR(ctrelab,5,0) nowait
 
    SELECT CUR_CLIENTI
    SKIP +1

ENDDO 


IF !ExecRW('','U_CLI_EX','I','','curs_U_CLI_EX')
  	return(.f.)
ENDIF



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN
