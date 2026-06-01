*************************************************************************************************
*							CONTROLLO AGENTI CLIENTE											*
*						 																	    *
*	Controllo codici agenti cliente 														    *
*						 																	    *
*						 																	    *
*						 																	    *
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2011 : Xilopan 			 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con il controllo "+CHR(13)+"codici agenti cliente	 ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


IF !ExecCommand("select * from U_CLI_AN where 1=0","cA_U_CLI_AN")
   return
ENDIF

__CONTA = 0

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
*!*	local_codage = ''
*!*	x_codage = "cli_age <> '" + ALLTRIM(local_codage) + "'"
*!*	x_cond = x_soci + " and " + x_codage  

x_cond = x_soci 
   
Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"u_cli_an")
   return(.f.)
ENDIF
SELECT u_cli_an
GO TOP
IF !EOF()

	DO WHILE .NOT.EOF()
		SCATTER MEMVAR MEMO

        
		IF EMPTY(M.CLI_AGE) 
			REPLACE CLI_AGE WITH '090'								&& CONTROAGGIORNA IL CODICE AGENTE
		ELSE 
		
				_AGENTE_CLIENTE_ESISTENTE = .F.
				=CERCA_AGE(M.CLI_AGE)
				IF 	!_AGENTE_CLIENTE_ESISTENTE 
					WAIT WINDOWS " ?????????? AGENTE CLIENTE INESISTENTE SU PARA"+ M.CLI_AGE NOWAIT
					SELECT cA_U_CLI_AN
					APPEND BLANK
					GATHER MEMVAR MEMO
					__CONTA = __CONTA +1
				ENDIF
		
		ENDIF
		SELECT U_CLI_AN
		SKIP +1
	ENDDO

	IF !ExecRW('','U_CLI_AN','I','','U_CLI_AN')
	  return(.f.)
	ENDIF
		
ENDIF 

WAIT WINDOWS "CODICI AGENTI INESISTENTI : "+STR(__CONTA,7,0)

_TIPOLOGIA_DI_STAMPA = "Tutti glii agenti"

SELECT cA_U_CLI_AN
GO TOP

IF !EOF()   
   DO PRG\MENUSTA WITH "cA_U_CLI_AN",.T.,.T.,"XXX","CLIAGEKO","CLIAGEKO.FRX"
ENDIF


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 