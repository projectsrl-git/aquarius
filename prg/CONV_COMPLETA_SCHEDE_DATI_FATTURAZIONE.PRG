*************************************************************************************************
*					       	    CARICAMENTO DATI DEGLI AMMINISTRATORI 	 			            *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Luglio 2023 : Aster	 			 															*
*************************************************************************************************
* IL PROGRAMMA AGGIORNA L'ANAGRAFICA DEL CLIENTE CREANDO LA LOCALITA' DI CONSEGNA E LA 
* TABELLA DELLE LOCALITA' DI CONSEGNA DA UN FOGLIO EXCEL
*


SET DEFAULT TO &PUB_DIR


RIT = MESSAGEBOX("PROCEDO CON IL CARICAMENTO DEL FOGLIO EXCEL PER IL COMPLETAMENTO DEI DATI DI FATTURAZIONE TRAMITE LOCALITA' DI CONSEGNA ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF
	


WAIT WINDOWS "SELEZIONA FOGLIO EXCEL CONTENENTE I DATI DEGLI AMMINISTRATORI" 

**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA

WAIT WINDOWS "ATTENDERE PREGO, CARICAMENTO FILE DA CONVERTIRE" NOWAIT


gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	RETURN
ENDIF



WAIT WINDOWS "Selezionato file EXCEL "+gcFile 	NOWAIT 	


*!*	cSql = "DELETE FROM U_LOC_AN"
*!*	IF !ExecCommand(cSql,"DEL_LOC_AN")
*!*	   return
*!*	ENDIF


* CURSORE PER STAMPA ANOMLIE
CREATE CURSOR STAMPAERR (CODCLI C(10), RAGSOC C(200), ERRORE C(200))
INDEX ON ALLTRIM(CODCLI) TAG ORDERR ADDITIVE
	
	

	
CREATE CURSOR IMPORTAXLS (CCODCLI C(10),;
	CCODSCHE C(50),;
	CRAGSOC C(240),;
	CINDINS C(200),;
	CINDDES C(200),;
	CCODLIS C(200),;
	COD_FATTUR C(10))

SELECT IMPORTAXLS
APPEND FROM (gcFile) TYPE xls	


SELECT IMPORTAXLS
GO TOP 

SCAN

	SCATTER MEMVAR MEMO

    IF M.CCODCLI = "ccodcli"
    	SELECT IMPORTAXLS
    	LOOP
    ENDIF	
	
	M.LOC_CODCLX = CONV_CLEAR(ALLTRIM(M.CCODCLI))
    M.LOC_CODCLI = TRC(PUB_LCL,ALLTRIM(M.LOC_CODCLX)) 
    M.LOC_CF     = 'C'
    M.LOC_RAGSOC = CONV_CLEAR(ALLTRIM(M.CRAGSOC))
    IF EMPTY(COD_FATTUR)
    	__COD_FATTUR = ""
    ELSE
	    __COD_FATTUX = CONV_CLEAR(ALLTRIM(COD_FATTUR))
	    __COD_FATTUR = TRC(PUB_LCL,ALLTRIM(__COD_FATTUX))
    ENDIF
    
    M.LOC_DATINS = RIBALTA2(DTOC(DATE()))
    
    IF EMPTY(__COD_FATTUR)	&& SCARTA I RECORD CHE NON DEVONO ESSERE GESTITI COME AMMINISTRATORI
    	SELECT IMPORTAXLS
    	LOOP
    ENDIF
    

	** ACCESSO ALLE LOCALITA' DI CONSEGNA PER VERIFICARE SE ESISTE GIA' UN CODICE DI LOCALITA'	
	
	x_soci = "loc_codsoc = '" + PUB_CODSOC + "'"
	x_ccff = "loc_cf     = '" + M.LOC_CF + "'"
	x_clie = "loc_codcli = '" + M.LOC_CODCLI + "'"
	*x_loca = "loc_codloc = '" + M.LOC_CODLOC + "'"
	x_cond = x_soci + " and " + x_ccff + " and " + x_clie &&	+ " and " + x_loca
	cSql = "select * from u_loc_an where " + x_cond + " order by loc_codsoc,loc_cf,loc_codcli,loc_codloc"
	IF !ExecCommand(cSql,"CX_LOC_AN")
	   RETURN .F. 
	ENDIF	
	
	SELECT CX_LOC_AN
	GO TOP
	IF EOF()
		_CODICE_LOCALITA = '000'
 	ELSE
		SELECT CX_LOC_AN
		GO BOTT
		_CODICE_LOCALITA = LOC_CODLOC
	ENDIF	
	
	
	_CODICE_LOCALITA_NUM = VAL(_CODICE_LOCALITA) + 1
	
	_CODICE_LOCALITA_STR = ALLTRIM(STR(_CODICE_LOCALITA_NUM,5,0))
	
	_LEN__CODICE_LOCALITA_STR = LEN(_CODICE_LOCALITA_STR)
	
	IF _LEN__CODICE_LOCALITA_STR = 1
		_CODICE_LOCALITA_STR  = "00"+_CODICE_LOCALITA_STR 
	ENDIF
	
	IF _LEN__CODICE_LOCALITA_STR = 2
		_CODICE_LOCALITA_STR  = "0"+_CODICE_LOCALITA_STR 
	ENDIF
	
	M.LOC_CODLOC = _CODICE_LOCALITA_STR  
	
	** VERIFICO CHE IL CLIENTE ESISTA IN ANAGRAFICA CLIENTI	
	
    x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
    x_codi = "cli_codcli = '" + M.LOC_CODCLI + "'"
    x_cond = x_soci + " and " + x_codi
    cSql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
    IF !ExecCommand(cSql,"CUR_CLIENTE")
       RETURN .F.
    ENDIF
    SELECT CUR_CLIENTE
    GO TOP
    IF EOF()
        _V_ERRORE = "CLIENTE INESISTENTE IN ANAGRAFICA CLIENTI: " + M.LOC_CODCLI
   		SELECT CX_LOC_AN
   		SCATTER MEMVAR MEMO 
		  
      	SELECT STAMPAERR
	  	APPEND BLANK
	  	REPLACE CODCLI   WITH   M.LOC_CODCLI ,;
	            RAGSOC   WITH   M.LOC_RAGSOC,;
	            ERRORE   WITH   _V_ERRORE 
  		SELECT IMPORTAXLS
   		LOOP   
    ENDIF	
	
	** VERIFICO CHE IL CLIENTE AMMINISTRATORE ESISTA IN ANAGRAFICA CLIENTI	
	
	M.LOC_DESNAZ = ""
	
    x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
    x_codi = "cli_codcli = '" + __COD_FATTUR + "'"
    x_cond = x_soci + " and " + x_codi
    cSql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
    IF !ExecCommand(cSql,"CUR_CLIENTE")
       RETURN .F.
    ENDIF
    SELECT CUR_CLIENTE
    GO TOP
    IF EOF()
        _V_ERRORE = "CODICE FATTURAZIONE INESISTENTE IN ANAGRAFICA CLIENTI: " + __COD_FATTUR 
   		SELECT CX_LOC_AN
   		SCATTER MEMVAR MEMO 
		  
      	SELECT STAMPAERR
	  	APPEND BLANK
	  	REPLACE CODCLI   WITH   __COD_FATTUR,;
	            RAGSOC   WITH   M.LOC_RAGSOC,;
	            ERRORE   WITH   _V_ERRORE 
  		SELECT IMPORTAXLS
   		LOOP   
    ELSE
    	SELECT CUR_CLIENTE
    	SCATTER MEMVAR MEMO		&& PRELEVO I DATI ANAGRAFICI DELL'AMMINISTRATORE
    	
		V_SEEK   = 'STA'+M.CLI_NAZION
		V_CHIAVE = 'codice'
		IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
		   SELECT CUR_PARA
		   M.LOC_DESNAZ= ALLTRIM(DESCRI)
		ENDIF
    ENDIF	
	
		
	WAIT WINDOWS "Cliente caricato lelle località di consegna: " + M.LOC_CODCLI NOWAIT


	** AGGIORNAMENTO ANAGRAFICA LOCALITA' DI CONSEGNA CON IL CODICE CLIENTE EFFETTIVO MA CON I DATI DELL' AMMINISTRATORE 
		
    cSql="select * from u_loc_an where 1=0"
    IF !ExecCommand(cSql,"CUR_LOC_AN")
       return(.f.)
    ENDIF
    SELECT CUR_LOC_AN
    APPEND BLANK
	REPLACE LOC_CODSOC WITH PUB_CODSOC
	REPLACE LOC_CODLOC WITH M.LOC_CODLOC
	REPLACE LOC_CODCLI WITH M.LOC_CODCLI
	REPLACE LOC_RAGSOC WITH M.CLI_RAGSOC
	REPLACE LOC_LOCALI WITH M.CLI_LOCALI
	REPLACE LOC_INDIRI WITH M.CLI_INDIR
	REPLACE LOC_CAP    WITH M.CLI_CAP
	REPLACE LOC_CF     WITH M.LOC_CF
	REPLACE LOC_PROVIN WITH M.CLI_PROVIN

	REPLACE LOC_DATINS WITH M.LOC_DATINS

	REPLACE LOC_ATTENZIONE   WITH ""
	REPLACE LOC_VARIE   WITH ""
	REPLACE LOC_CODNAZ  WITH M.CLI_NAZION   
	REPLACE LOC_DESNAZ  WITH M.LOC_DESNAZ  
	REPLACE LOC_CODAGE  WITH "001"
 
    IF !ExecRW('','u_loc_an','I','','CUR_LOC_AN')
       return(.f.)
    ENDIF

	** AGGIORNAMENTO ANAGRAFICA CLIENTI
	
	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" +  M.LOC_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	IF !ExecRW(cSql,"u_cli_an","R")
	   return(.f.)
	ENDIF
	SELECT U_CLI_AN
	GO TOP 
	IF EOF()
		APPEND BLANK
	ENDIF
	
	REPLACE CLI_LOCDOC WITH M.LOC_CODLOC
	
	IF !ExecRW(cSql,"u_cli_an","W")
	   return(.f.)
	ENDIF
	
	**=> ERASMO - INIZIO 06/09/2023
	*** AGGIORNAMENTO CAMPO PER INDIRIZZO CORRISPONDENZA SU TABELLA IMPIANTO
	IF !EMPTY(M.LOC_CODLOC) AND !EMPTY(M.CCODSCHE)
		x_cond = "CCODSCHE = '" + ALLTRIM(M.CCODSCHE) + "'"
		cSql = "select * from IMPIANTI_TT where " + x_cond
		IF !ExecRW(cSql,"IMPIANTI_TT","R")
		   return(.f.)
		ENDIF
		SELECT IMPIANTI_TT
		GO TOP 
		IF !EOF()
			REPLACE CRAGSOC1 WITH M.LOC_CODLOC
		ENDIF
		IF !ExecRW(cSql,"IMPIANTI_TT","W")
		   return(.f.)
		ENDIF
	ENDIF
	**=> ERASMO - FINE 06/09/2023
	
	SELECT IMPORTAXLS
	
ENDSCAN



SELECT STAMPAERR
SET ORDER TO ORDERR
GO TOP
IF !EOF()  
 	DO PRG\MENUSTA WITH "STAMPAERR",.T.,.T.,"XXX","CLIERR","CLIERR.FRX",.T.
ENDIF   


=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

