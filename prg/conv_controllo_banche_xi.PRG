*************************************************************************************************
*							CONTROLLO BANCHE CLIENTE											*
*						 																	    *
*	Controllo codici banche cliente 														    *
*						 																	    *
*						 																	    *
*						 																	    *
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2011 : Xilopan 			 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con il controllo "+CHR(13)+"codici banche cliente	 ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


IF !ExecCommand("select * from U_CLI_AN where 1=0","cB_U_CLI_AN")
   return
ENDIF

__CONTA = 0

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
local_codabi = ''
x_codabi = "cli_codabi <> '" + ALLTRIM(local_codabi) + "'"
local_codcab = ''
x_codcab = "cli_codcab <> '" + ALLTRIM(local_codcab) + "'"

x_cond = x_soci + " and " + x_codabi + " and " + x_codcab 
Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"u_cli_an")
   return(.f.)
ENDIF
SELECT u_cli_an
GO TOP
IF !EOF()

	DO WHILE .NOT.EOF()

		SCATTER MEMVAR MEMO

		IF !EMPTY(M.CLI_CODABI) 
			IF !EMPTY(M.CLI_CODCAB)
		    	M.CLI_BAE = ALLTRIM(M.CLI_CODABI)+ALLTRIM(M.CLI_CODCAB)
		    	
				REPLACE CLI_BAE WITH M.CLI_BAE								&& CONTROAGGIORNA IL CODICE BANCA
				
				SCATTER MEMVAR MEMO
				
				_BANCA_CLIENTE_ESISTENTE = .F.
				=CERCA_BANCA(M.CLI_BAE)
				IF 	!_BANCA_CLIENTE_ESISTENTE
					WAIT WINDOWS " ?????????? BANCA CLIENTE INESISTENTE SU U_BAN_AN"+ M.CLI_BAE NOWAIT
					SELECT cB_U_CLI_AN
					APPEND BLANK
					GATHER MEMVAR MEMO
					__CONTA = __CONTA +1
				ENDIF
			ENDIF
		ENDIF
		
    
		SELECT U_CLI_AN
		SKIP +1
	ENDDO

	IF !ExecRW('','U_CLI_AN','I','','U_CLI_AN')
	  return(.f.)
	ENDIF
		
ENDIF 

WAIT WINDOWS "CODICI BANCA ERRATI : "+STR(__CONTA,7,0)

_TIPOLOGIA_DI_STAMPA = "Tutti i clienti"

SELECT cB_U_CLI_AN
GO TOP

IF !EOF()   
   DO PRG\MENUSTA WITH "cB_U_CLI_AN",.T.,.T.,"XXX","CLIBANKO","CLIBANKO.FRX"
ENDIF



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 