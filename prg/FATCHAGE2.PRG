**********************************************************************
* CAMBIA IL CODICE AGENTE		SU FATTURE		 				     *
* SE NON ESISTE L'AGEBTE FORZA QUELLO DI ANAGRAFICA             	 *
**********************************************************************


**=> ERASMO - INIZIO 16/03/2012

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_dt1  = RIBALTA2(DATADAL)
x_dt2  = RIBALTA2(DATAAL)
x_data = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_cond = x_soci + " and " + x_data 


**=> ERASMO - FINE 16/03/2012
cSql = "select * from u_fat_tt where " + x_cond + " order by ord_codsoc,ord_codcli,ord_age"
IF !ExecRW(cSql,"u_fat_tt","R")
   RETURN .F.
ENDIF
SELECT u_fat_tt

**=> ERASMO - INIZIO 16/03/2012
REPLACE SELEZIONE WITH "" ALL
GO TOP
IF EOF()
	MESSAGEBOX("Nessuna fattura con il codice agente selezionato",16,"Attenzione")
	IF !ExecRW(cSql,"u_fat_tt","W")
	   RETURN .F.
	ENDIF
	RETURN .F.
ENDIF


SELECT u_fat_tt
GO TOP



WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

CT      = 0
CTRELAB = 0

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SELECT u_fat_tt
      SKIP +1
      LOOP
   ENDIF
 
    SELECT u_fat_tt
    _CLI_CODCLI 		= ORD_CODCLI
    _AGENTE_FATTURA 	= ORD_AGE
    _ORD_NUMORD    		= ORD_NUMORD   

*!*	IF VAL(_CLI_CODCLI) = 1952
*!*	SET STEP ON 
*!*	ENDIF


	x_soci  = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_clie  = "cli_codcli = '" + _CLI_CODCLI  + "'"
    x_cond  = x_soci + " and " + x_clie 
				
	Csql    = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	IF !ExecCommand(cSql,"u_cli_an")
	   return(.f.)
	ENDIF

    SELECT u_cli_an
    GO TOP	
	IF !EOF()
	
		_AGE_CLI = CLI_AGE
		
		v_seek	 = 'AGE'+ALLTRIM(_AGE_CLI)
		v_chiave = "codice"
		
		IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
		ELSE
		
		    _AGE_CLI = '001'	&& FORZO 001 IN ANAGRAFICA CLIENTI IN QUANTO ERRATA
		    
			SELECT u_cli_an
			REPLACE CLI_AGE WITH _AGE_CLI 
			WAIT WINDOWS "AGENTE INESISTENTE IN ANAGRAFICA CLIENTE "+ _CLI_CODCLI + " FORZO AGENTE 001"	 NOWAIT		
			IF !ExecRW('','U_CLI_AN','I','','U_CLI_AN')
			  return(.f.)
			ENDIF
		
		ENDIF
	
	ELSE
		_AGE_CLI = '001'	&& FORZO 090
		WAIT WINDOWS "FATTURA SENZA ANAGRAFICA CLIENTE "+ _CLI_CODCLI 
        SELECT u_fat_tt
        SKIP +1
        LOOP		
	ENDIF 

    SELECT u_fat_tt

	v_seek	 = 'AGE'+ALLTRIM(_AGENTE_FATTURA)
	v_chiave = "codice"
	IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
        SELECT u_fat_tt		&& AGENTE TROVATO SU PARAMETRO : OKKKKKKKKKK
        SKIP +1
        LOOP
	ELSE
		WAIT WINDOWS "CODICE AGENTE MANCANTE IN PARAMETRI : IMPOSTO IL CODICE "+ _AGE_CLI +" DI ANAGRAFICA PER IL CLIENTE "+ _CLI_CODCLI + " FATTURA : " + _ORD_NUMORD   NOWAIT
	ENDIF


     
   SELECT U_FAT_TT
   REPLACE ORD_AGE WITH _AGE_CLI 
 
   CT = CT +1
   WAIT WINDOWS "Fatture aggiornate "+STR(CT,9,0) NOWAIT

   SKIP +1

ENDDO

IF !ExecRW(cSql,"U_FAT_TT","W")
   RETURN .F.
ENDIF 

=MESSAGEBOX("Fine elaborazione",64,"ATTENZIONE")

RELEASE WINDOW DISPLAY