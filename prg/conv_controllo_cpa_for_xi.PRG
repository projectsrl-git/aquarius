*************************************************************************************************
*							CONTROLLO CONDIZIONI DI PAGAMENTO									*
*						 																	    *
*	Controllo codici condizioni pagamento fornitore											    *
*						 																	    *
*						 																	    *
*						 																	    *
*	by Sergio Piaggi per Project S.r.l.															*
*	Gennaio 2012 : Xilopan  			 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con il controllo "+CHR(13)+"codici condizioni pagamento in anagrafica fornitori ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


IF !ExecCommand("select * from U_FOR_AN where 1=0","cP_U_FOR_AN")
   return
ENDIF

__CONTA = 0

x_cond = "for_codsoc = '" + PUB_CODSOC + "'"
Csql   = "select * from U_FOR_AN where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"U_FOR_AN")
   return(.f.)
ENDIF
SELECT U_FOR_AN
GO TOP
IF !EOF()

	DO WHILE .NOT.EOF()

		SCATTER MEMVAR MEMO

		IF EMPTY(M.for_CONPAG)
			M.for_conpag = '100'
			REPLACE for_CONPAG WITH M.for_CONPAG
		ENDIF
			
		v_seek	 = 'CPA'+M.for_CONPAG
		v_chiave = "codice"
		IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
		ELSE
			WAIT WINDOWS " ?????????? CPA FORNITORE INESISTENTE SU PARA"+ M.for_CONPAG NOWAIT		
			SELECT cP_U_FOR_AN
			APPEND BLANK
			GATHER MEMVAR MEMO
			__CONTA = __CONTA +1
		ENDIF
    
		SELECT U_FOR_AN
		SKIP +1
	
	ENDDO

	IF !ExecRW('','U_FOR_AN','I','','U_FOR_AN')
	  return(.f.)
	ENDIF
		
ENDIF 

WAIT WINDOWS "CODICI CONDIZIONI PAGAMENTO ERRATI : "+STR(__CONTA,7,0)

_TIPOLOGIA_DI_STAMPA = "Tutti i fornitori"

SELECT cP_U_FOR_AN
GO TOP

IF !EOF()   
   DO PRG\MENUSTA WITH "cP_U_FOR_AN",.T.,.T.,"XXX","FORCPAKO","FORCPAKO.FRX"
ENDIF



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 