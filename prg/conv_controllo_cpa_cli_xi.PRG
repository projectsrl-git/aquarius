*************************************************************************************************
*							CONTROLLO CONDIZIONI DI PAGAMENTO									*
*						 																	    *
*	Controllo codici condizioni pagamento cliente 											    *
*						 																	    *
*						 																	    *
*						 																	    *
*	by Sergio Piaggi per Project S.r.l.															*
*	Gennaio 2012 : Xilopan  			 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con il controllo "+CHR(13)+"codici condizioni pagamento in anagrafica clienti	 ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


IF !ExecCommand("select * from U_CLI_AN where 1=0","cP_U_CLI_AN")
   return
ENDIF

__CONTA = 0

x_cond = "cli_codsoc = '" + PUB_CODSOC + "'"
Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"u_cli_an")
   return(.f.)
ENDIF
SELECT u_cli_an
GO TOP
IF !EOF()

	DO WHILE .NOT.EOF()

		SCATTER MEMVAR MEMO

		IF EMPTY(M.CLI_CONPAG)
			M.CLI_CONPAG = '100'
			REPLACE CLI_CONPAG WITH M.CLI_CONPAG
		ENDIF
			
		v_seek	 = 'CPA'+M.CLI_CONPAG
		v_chiave = "codice"
		IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
		ELSE
			WAIT WINDOWS " ?????????? CPA CLIENTE INESISTENTE SU PARA"+ M.CLI_CONPAG NOWAIT		
			SELECT cP_U_CLI_AN
			APPEND BLANK
			GATHER MEMVAR MEMO
			__CONTA = __CONTA +1
		ENDIF
    
		SELECT U_CLI_AN
		SKIP +1
	
	ENDDO

	IF !ExecRW('','U_CLI_AN','I','','U_CLI_AN')
	  return(.f.)
	ENDIF
		
ENDIF 

WAIT WINDOWS "CODICI CONDIZIONI PAGAMENTO ERRATI : "+STR(__CONTA,7,0)

_TIPOLOGIA_DI_STAMPA = "Tutti i clienti"

SELECT cP_U_CLI_AN
GO TOP

IF !EOF()   
   DO PRG\MENUSTA WITH "cP_U_CLI_AN",.T.,.T.,"XXX","CLCPAKO","CLICPAKO.FRX"
ENDIF



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 