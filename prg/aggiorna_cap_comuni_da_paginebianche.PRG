
*** AGGIORNA IL CAP DEL COMUNE INTERROGANDO IL SITO WWW.PAGINEBIANCHE.IT

_RISP = MESSAGEBOX("Aggiornare il CAP della tabella sql COMUNI?",4+48,"Attenzione")
IF _RISP = 6
ELSE
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF

_flg_agg_cap_non_vuoti = .F.
_RISP = MESSAGEBOX("Contraggiornare anche i CAP attuali non vuoti?",4+48+256,"Attenzione")
IF _RISP = 6
	_flg_agg_cap_non_vuoti = .T.
	MESSAGEBOX("Verranno contraggiornati anche i CAP non vuoti",64,"Informazione")
ELSE
	MESSAGEBOX("Verranno contraggiornati solo i CAP vuoti",64,"Informazione")
ENDIF

**=> ERASMO - INIZIO 22/09/2021
_flg_agg_anagr_clifor = .F.
_RISP = MESSAGEBOX("Contraggiornare anche le anagrafiche clienti/fornitori?",4+48+256,"Attenzione")
IF _RISP = 6
	_flg_agg_anagr_clifor = .T.
	MESSAGEBOX("Verranno contraggiornate anche le anagrafiche clienti/fornitori",64,"Informazione")
ENDIF
**=> ERASMO - FINE 22/09/2021

x_cond = IIF(_flg_agg_cap_non_vuoti,"1=1","CAP = ''")
cSql="select * from COMUNI WHERE " + x_cond + " order by COMUNE"
IF !ExecCommand(cSql,"CU_COMUNI")
   return(.f.)
ENDIF

v_conta = 0
v_conta_agg = 0
**=> ERASMO - INIZIO 22/09/2021
v_conta_cli_agg = 0
v_conta_cli_a_agg = 0
v_conta_for_agg = 0
**=> ERASMO - FINE 22/09/2021

_C_POINTER_STR = '<span class="result-cont-li li-cap">'

SELECT CU_COMUNI
GO TOP
SCAN
	
	_PAR_LOCALITA = ALLTRIM(COMUNE)
	
	_cSrcLocalita = UPPER(_PAR_LOCALITA)
	_cSrcLocalita = STRTRAN(_cSrcLocalita,"`","'")
	_cSrcLocalita = STRTRAN(_cSrcLocalita,"À","A")
	_cSrcLocalita = STRTRAN(_cSrcLocalita,"È","E")
	_cSrcLocalita = STRTRAN(_cSrcLocalita,"É","E")
	_cSrcLocalita = STRTRAN(_cSrcLocalita,"Ì","I")
	_cSrcLocalita = STRTRAN(_cSrcLocalita,"Ò","O")
	_cSrcLocalita = STRTRAN(_cSrcLocalita,"Ù","U")
	
	_lAbbandona = .F.
	    
    FOR I=1 TO 3  && MAX 3 TENTATIVI
		
		SELECT CU_COMUNI
		
		_cMessaggio = "Comune " + _PAR_LOCALITA + " (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%) - [" + ;
			ALLTRIM(STR(v_conta_agg)) + " aggiornati su " + ALLTRIM(STR(v_conta)) + " elaborati]"
		*WAIT WINDOWS _cMessaggio NOWAIT
			
		IF !AQ_WAITBAR(_SCREEN,"CU_COMUNI",.T.,_cMessaggio)
			_lAbbandona = .T.
			EXIT
		ENDIF
		
		V_BODY = ""
		V_CAP = ""
		
		_lAbbandonaAttesaAutorizz = .F.
		DO WHILE .T.
			lcUrl = "https://www.paginebianche.it/cap?dv="+ALLTRIM(_cSrcLocalita)
			*lcFilename = SYS(5)+SYS(2003)+"\CAP_"+_PAR_LOCALITA+".TXT"
			lExit = .F.
			TRY
				loRequest = Createobject('MsXml2.XmlHttp')
				loRequest.Open("GET",lcUrl,.F.)
				loRequest.Send()
			CATCH
				TRY
					loRequest = Createobject('MSXML2.ServerXMLHTTP')
					loRequest.Open("GET",lcUrl,.F.)
					loRequest.Send()
				CATCH
					MESSAGEBOX("Servizio non disponibile per '" + lcUrl + "'",48,"Attenzione")
					lExit = .t.
				ENDTRY
			ENDTRY
			
			IF lExit
				_lAbbandonaAttesaAutorizz = .T.
				EXIT
			ENDIF
			
			V_BODY = STRCONV(loRequest.ResponseBody,11)
			RELEASE loRequest
			
			IF "403 Forbidden" $ V_BODY
				IF !AQ_WAITBAR(_SCREEN,"CU_COMUNI",.T.,"ATTESA AUTORIZZAZIONE - " + _cMessaggio)
					_lAbbandonaAttesaAutorizz = .T.
					EXIT
				ENDIF
				DO AQM_ATTENDI_N_SECONDI WITH 10
			ELSE
				EXIT
			ENDIF
		ENDDO
		IF _lAbbandonaAttesaAutorizz
			_lAbbandona = .T.
			EXIT
		ENDIF

		IF OCCURS(_C_POINTER_STR,V_BODY) > 0
			V_CAP = SUBSTR(V_BODY, AT(_C_POINTER_STR,V_BODY,1) + LEN(_C_POINTER_STR), 5)
			IF !ISDIGIT(V_CAP)
				IF SUBSTR(V_CAP,1,1) = "("  && CASO COMUNI CON CAP A RANGE (ES ALESSANDRIA: "(15121 - 15122)")
					V_CAP = SUBSTR(V_CAP,2,2) + "100"
				ELSE
					V_CAP = ""
				ENDIF
			ENDIF
			EXIT
		ELSE
			LOOP
		ENDIF
		
	NEXT
	
	IF _lAbbandona
		SELECT CU_COMUNI
		GO BOTTOM
		AQ_WAITBAR(_SCREEN,"CU_COMUNI",.T.,"Chiusura in corso...")
		EXIT
	ENDIF

	*STRTOFILE(loRequest.ResponseBody,lcFilename)

	IF !EMPTY(V_CAP)
	   _old_cap = ""  && ERASMO - 22/09/2021
	   v_seek   = _PAR_LOCALITA
	   v_chiave = "COMUNE"
	   cSql="select * from COMUNI where " + v_chiave + " = '" + v_seek + "'"
	   IF !ExecRW(cSql,"COMUNI","R")
	      return(.f.)
	   ENDIF
	   SELECT COMUNI
	   GO TOP
	   IF !EOF()
	      _old_cap = UPPER(ALLTRIM(CAP))  && ERASMO - 22/09/2021
	      IF ALLTRIM(_old_cap) <> ALLTRIM(V_CAP)  && ERASMO - 22/09/2021
		      REPLACE CAP WITH V_CAP
		      v_conta_agg = v_conta_agg + 1
		  ENDIF
	   ENDIF
	   IF !ExecRW(cSql,"COMUNI","W")
	      return(.f.)
	   ENDIF
	   
		**=> ERASMO - INIZIO 22/09/2021
		IF _flg_agg_anagr_clifor AND ALLTRIM(_old_cap) <> ALLTRIM(V_CAP)
		   *** AGGIORNAMENTO ANAGRAFICA CLIENTI (CAP)
		   x_loca = "CLI_LOCALI = '" + _PAR_LOCALITA + "'"
		   x_ocap = "CLI_CAP = '" + _old_cap + "'"
		   x_cond = x_loca + " and " + x_ocap 
		   cSql   = "select * from U_CLI_AN where " + x_cond + " order by cli_codcli"
		   IF !ExecCommand(cSql,"CHK_CLI_AN")
		      return(.f.)
		   ENDIF
		   SELECT CHK_CLI_AN
		   GO TOP
		   SCAN
			   v_seek   = CLI_CODCLI
			   v_chiave = "CLI_CODCLI"
			   cSql="select * from U_CLI_AN where " + v_chiave + " = '" + v_seek + "'"
			   IF !ExecRW(cSql,"U_CLI_AN","R")
			      return(.f.)
			   ENDIF
			   SELECT U_CLI_AN
			   GO TOP
			   IF !EOF()
			      REPLACE CLI_CAP WITH V_CAP
			      REPLACE CLI_DATINS WITH RIBALTA2(DTOC(DATE()))
			      v_conta_cli_agg = v_conta_cli_agg + 1
			   ENDIF
			   IF !ExecRW(cSql,"U_CLI_AN","W")
			      return(.f.)
			   ENDIF
			   
			   cSql="select * from U_ANA_CL where " + v_chiave + " = '" + v_seek + "'"
			   IF !ExecRW(cSql,"U_ANA_CL","R")
			      return(.f.)
			   ENDIF
			   SELECT U_ANA_CL
			   GO TOP
			   IF !EOF()
			      REPLACE MOD_CODOPE WITH PUB_CODOPE
			      REPLACE MOD_NOMOPE WITH PUB_NOMOPE
			      REPLACE MOD_DATREG WITH RIBALTA2(DTOC(DATE()))
			      REPLACE MOD_ORAREG WITH TIME()
			   ENDIF
			   IF !ExecRW(cSql,"U_ANA_CL","W")
			      return(.f.)
			   ENDIF
		   ENDSCAN
		   
		   *** AGGIORNAMENTO ANAGRAFICA CLIENTI (CAP SCHEDA 'FATTURARE A')
		   x_loca = "CLI_LOCALIA = '" + _PAR_LOCALITA + "'"
		   x_ocap = "CLI_CAPA = '" + _old_cap + "'"
		   x_cond = x_loca + " and " + x_ocap 
		   cSql   = "select * from U_CLI_AN where " + x_cond + " order by cli_codcli"
		   IF !ExecCommand(cSql,"CHK_CLI_AN")
		      return(.f.)
		   ENDIF
		   SELECT CHK_CLI_AN
		   GO TOP
		   SCAN
			   v_seek   = CLI_CODCLI
			   v_chiave = "CLI_CODCLI"
			   cSql="select * from U_CLI_AN where " + v_chiave + " = '" + v_seek + "'"
			   IF !ExecRW(cSql,"U_CLI_AN","R")
			      return(.f.)
			   ENDIF
			   SELECT U_CLI_AN
			   GO TOP
			   IF !EOF()
			      REPLACE CLI_CAPA WITH V_CAP
			      REPLACE CLI_DATINS WITH RIBALTA2(DTOC(DATE()))
			      v_conta_cli_a_agg = v_conta_cli_a_agg + 1
			   ENDIF
			   IF !ExecRW(cSql,"U_CLI_AN","W")
			      return(.f.)
			   ENDIF
			   
			   cSql="select * from U_ANA_CL where " + v_chiave + " = '" + v_seek + "'"
			   IF !ExecRW(cSql,"U_ANA_CL","R")
			      return(.f.)
			   ENDIF
			   SELECT U_ANA_CL
			   GO TOP
			   IF !EOF()
			      REPLACE MOD_CODOPE WITH PUB_CODOPE
			      REPLACE MOD_NOMOPE WITH PUB_NOMOPE
			      REPLACE MOD_DATREG WITH RIBALTA2(DTOC(DATE()))
			      REPLACE MOD_ORAREG WITH TIME()
			   ENDIF
			   IF !ExecRW(cSql,"U_ANA_CL","W")
			      return(.f.)
			   ENDIF
		   ENDSCAN
		   
		   *** AGGIORNAMENTO ANAGRAFICA FORNITORI (CAP)
		   x_loca = "FOR_LOCALI = '" + _PAR_LOCALITA + "'"
		   x_ocap = "FOR_CAP = '" + _old_cap + "'"
		   x_cond = x_loca + " and " + x_ocap 
		   cSql   = "select * from U_FOR_AN where " + x_cond + " order by for_codcli"
		   IF !ExecCommand(cSql,"CHK_FOR_AN")
		      return(.f.)
		   ENDIF
		   SELECT CHK_FOR_AN
		   GO TOP
		   SCAN
			   v_seek   = FOR_CODCLI
			   v_chiave = "FOR_CODCLI"
			   cSql="select * from U_FOR_AN where " + v_chiave + " = '" + v_seek + "'"
			   IF !ExecRW(cSql,"U_FOR_AN","R")
			      return(.f.)
			   ENDIF
			   SELECT U_FOR_AN
			   GO TOP
			   IF !EOF()
			      REPLACE FOR_CAP WITH V_CAP
			      REPLACE FOR_DATINS WITH RIBALTA2(DTOC(DATE()))
			      v_conta_for_agg = v_conta_for_agg + 1
			   ENDIF
			   IF !ExecRW(cSql,"U_FOR_AN","W")
			      return(.f.)
			   ENDIF
		   ENDSCAN
		ENDIF
		**=> ERASMO - FINE 22/09/2021
	ENDIF
	
	v_conta = v_conta + 1
ENDSCAN

SELECT CU_COMUNI
USE

WAIT CLEAR

**=> ERASMO - INIZIO 22/09/2021
IF _flg_agg_anagr_clifor
	MESSAGEBOX("Operazione effettuata" + REPLICATE(CHR(13),2) + ;
		ALLTRIM(STR(v_conta_agg)) + " comuni aggiornati su un totale di " + ALLTRIM(STR(v_conta)) + " comuni elaborati" + CHR(13) + ;
		ALLTRIM(STR(v_conta_cli_agg)) + " CAP aggiornati su anagrafiche clienti" + CHR(13) + ;
		ALLTRIM(STR(v_conta_cli_agg)) + " CAP scheda 'Fatturare a' aggiornati su anagrafiche clienti" + CHR(13) + ;
		ALLTRIM(STR(v_conta_for_agg)) + " CAP aggiornati su anagrafiche fornitori",64,"Informazione")
ELSE
**=> ERASMO - FINE 22/09/2021
	MESSAGEBOX("Operazione effettuata" + REPLICATE(CHR(13),2) + ;
		ALLTRIM(STR(v_conta_agg)) + " comuni aggiornati su un totale di " + ALLTRIM(STR(v_conta)) + " comuni elaborati",64,"Informazione")
ENDIF

RETURN




