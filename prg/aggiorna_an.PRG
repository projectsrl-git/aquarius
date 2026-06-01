
PARAMETERS __TIPO_ARCHIVIO,_TIPO_AGGIORNAMENTO

IF PCOUNT() >= 2
ELSE
	_TIPO_AGGIORNAMENTO = 1
ENDIF

IF ALLTRIM(__TIPO_ARCHIVIO) = 'CLIENTI'
	=AGGIORNA_ANAGRAFICHE_CLIENTI()
ELSE
	=AGGIORNA_ANAGRAFICHE_FORNITORI()
ENDIF

*****************************************
FUNCTION AGGIORNA_ANAGRAFICHE_CLIENTI
*****************************************

**
** ####################### AGGIORNA I DATI LEGALI DELLE ANAGRAFICHE CLIENTI #######################
**

__xxannop = VAL(pub_anno) - 1
RIT = MESSAGEBOX("Procedo con l'aggiornamento dei DATI LEGALI "+CHR(13)+"relativi all' anagrafica clienti ? ",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


RELEASE _conta_rec 
PUBLIC _conta_rec 
_conta_rec = 0

_CONTA_REC_SENZA_RECCAT = 0   

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_pariva"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SELECT CUR_CLIENTI
      SKIP +1
      LOOP
   ENDIF   
   
   _CONTA_REC = _CONTA_REC  + 1
   
   WAIT windows "Clienti elaborati : " + STR(_conta_rec,5,0) nowait

	SELECT CUR_CLIENTI	
	SCATTER MEMVAR MEMO
	
	M.CLI_RECCAT = M.CLI_RECCAT
	
	IF M.CLI_RECCAT = 1	OR M.CLI_RECCAT = 2
	ELSE
		M.CLI_RECCAT = 1
	ENDIF

	IF M.cli_reccat = 1															&& PERSONA GIURIDICA
		M.CLI_RAGLEG  = M.CLI_RAGSOC	&& DATI PERSONA GIURIDICA
		M.CLI_RGLEG2  = M.CLI_RAGDUE
		M.CLI_INDLEG  = M.CLI_INDIR
		M.CLI_LOCLEG  = M.CLI_LOCALI
		M.CLI_PROLEG  = M.CLI_PROVIN
		M.CLI_NAZLEG  = M.CLI_NAZION
		M.CLI_CAPLEG  = M.CLI_CAP
		M.CLI_CFISLG  = M.CLI_CODFIS
		M.CLI_PIVALG  = M.CLI_PARIVA
		M.CLI_IVCELG  = M.CLI_IVACEE

		M.cli_reccog  = ""				&& DATI PERSONA FISICA
		M.cli_recnom  = ""
		M.cli_PRONAS  = ""
		M.cli_reccdf  = ""
	ELSE																		&& PERSONA FISICA
		M.cli_reccog  = M.CLI_RAGSOC	&& DATI PERSONA FISICA
		M.cli_recnom  = M.CLI_RAGDUE
		M.cli_PRONAS  = M.CLI_PROVIN
		M.cli_reccdf  = M.CLI_CODFIS

		M.CLI_RAGLEG  = ""				&& DATI PERSONA GIURIDICA
		M.CLI_RGLEG2  = ""
		M.CLI_INDLEG  = ""
		M.CLI_LOCLEG  = ""
		M.CLI_PROLEG  = ""
		M.CLI_NAZLEG  = ""
		M.CLI_CAPLEG  = ""
		M.CLI_CFISLG  = ""
		M.CLI_PIVALG  = ""
		M.CLI_IVCELG  = ""
	ENDIF
	M.CLI_ESTNAZ  = ""
	M.CLI_ESTDOM  = ""

	IF M.CLI_RECCAT = 1										&& PERSONA GIURIDICA
		x_cond = "PA.CODICE = 'STA" + M.CLI_NAZLEG + "'"
	ELSE													&& PERSONA FISICA
		x_cond = "PA.CODICE = 'STA" + M.CLI_NAZION + "'"
	ENDIF
	cSql = "SELECT PA.DTIPOMOV AS CODNAZ_UNI, COALESCE(NU.DESCRI,'') AS DESNAZ_UNI FROM PARA AS PA " + ;
		"LEFT OUTER JOIN NAZIONI_UNICO AS NU ON NU.CODICE = PA.DTIPOMOV WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_PARA_NAZ")
		RETURN .F.
	ENDIF
	SELECT CX_PARA_NAZ
	GO TOP
	IF !EOF()
		IF M.CLI_RECCAT = 1								&& PERSONA GIURIDICA
			M.CLI_ESTNAZ = ALLTRIM(CODNAZ_UNI)
		ELSE											&& PERSONA FISICA
			M.CLI_ESTDOM = ALLTRIM(CODNAZ_UNI)
		ENDIF
	ENDIF
	**=> ERASMO - FINE 04/10/2013
	
	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
	IF !ExecRW(cSql,"u_cli_an","R")
	  return(.f.)
	ENDIF

	SELECT U_CLI_AN
	
	IF _TIPO_AGGIORNAMENTO = 1					&& AGGIORNA SOLO DATI LEGALI VUOTI
		IF CLI_RECCAT <> 1 AND CLI_RECCAT <> 2
			REPLACE CLI_RECCAT WITH M.CLI_RECCAT
		ENDIF
		IF EMPTY(CLI_RAGLEG)
			REPLACE CLI_RAGLEG WITH M.CLI_RAGLEG     
		ENDIF
		IF EMPTY(CLI_RGLEG2)
			REPLACE CLI_RGLEG2 WITH M.CLI_RGLEG2     
		ENDIF
		IF EMPTY(CLI_INDLEG)
			REPLACE CLI_INDLEG WITH M.CLI_INDLEG     
		ENDIF
		IF EMPTY(CLI_LOCLEG)
			REPLACE CLI_LOCLEG WITH M.CLI_LOCLEG     
		ENDIF
		IF EMPTY(CLI_PROLEG)
			REPLACE CLI_PROLEG WITH M.CLI_PROLEG     
		ENDIF
		IF EMPTY(CLI_NAZLEG)
			REPLACE CLI_NAZLEG WITH M.CLI_NAZLEG     
		ENDIF
		IF EMPTY(CLI_CAPLEG)
			REPLACE CLI_CAPLEG WITH M.CLI_CAPLEG     
		ENDIF
		IF EMPTY(CLI_CFISLG)
			REPLACE CLI_CFISLG WITH M.CLI_CFISLG     
		ENDIF
		IF EMPTY(CLI_PIVALG)
			REPLACE CLI_PIVALG WITH M.CLI_PIVALG     
		ENDIF
		IF EMPTY(CLI_IVCELG)
			REPLACE CLI_IVCELG WITH M.CLI_IVCELG     
		ENDIF
		IF EMPTY(CLI_ESTNAZ)
		    REPLACE CLI_ESTNAZ WITH M.CLI_ESTNAZ
		ENDIF
    ELSE										&& AGGIORNA TUTTI I DATI LEGAMI
    	REPLACE CLI_RECCAT WITH M.CLI_RECCAT
		REPLACE CLI_RAGLEG WITH M.CLI_RAGLEG     
		REPLACE CLI_RGLEG2 WITH M.CLI_RGLEG2     
		REPLACE CLI_INDLEG WITH M.CLI_INDLEG     
		REPLACE CLI_LOCLEG WITH M.CLI_LOCLEG     
		REPLACE CLI_PROLEG WITH M.CLI_PROLEG     
		REPLACE CLI_NAZLEG WITH M.CLI_NAZLEG     
		REPLACE CLI_CAPLEG WITH M.CLI_CAPLEG     
		REPLACE CLI_CFISLG WITH M.CLI_CFISLG     
		REPLACE CLI_PIVALG WITH M.CLI_PIVALG     
		REPLACE CLI_IVCELG WITH M.CLI_IVCELG     
	    REPLACE CLI_ESTNAZ WITH M.CLI_ESTNAZ
    ENDIF
  
    IF !ExecRW(cSql,"u_cli_an","W")
	  return(.f.)
    ENDIF  
  
  
   SELECT CUR_CLIENTI
   SKIP +1

ENDDO


RIT = MESSAGEBOX("Fine aggiornamento DATI LEGALI relativi all'anagrafica clienti",62,"ATTENZIONE")
*RELEASE WINDOW DISPLAY

**=> ERASMO - INIZIO 04/10/2013
WAIT CLEAR

IF _CONTA_REC_SENZA_RECCAT > 0
	_RISP = MESSAGEBOX("Rilevati " + ALLTRIM(STR(_CONTA_REC_SENZA_RECCAT,10,0)) + " clienti non classificati nè come Persona Giuridica, nè come Persona Fisica " + ;
		"per i quali non è stato possibile riportare i dati legali" + REPLICATE(CHR(13),2) + ;
		"Stampare una lista di tali clienti?",4+48,"Attenzione")
	IF _RISP = 6
		SELECT * FROM CUR_CLIENTI WHERE CLI_RECCAT <> 1 AND CLI_RECCAT <> 2 ORDER BY CLI_RAGSOC INTO CURSOR CTRL_CLI_STA
		SELECT CTRL_CLI_STA
		GO TOP
		IF !EOF()
			DO PRG\MENUSTA WITH "CTRL_CLI_STA",.T.,.T.,"XXX","CLI000","CLI000.FRX",.T.
		ENDIF
	ENDIF
ENDIF
**=> ERASMO - FINE 04/10/2013


RETURN


*****************************************
FUNCTION AGGIORNA_ANAGRAFICHE_FORNITORI
*****************************************

**
** ####################### AGGIORNA I DATI LEGALI DELLE ANAGRAFICHE FORNITORI #######################
**

__xxannop = VAL(pub_anno) - 1
RIT = MESSAGEBOX("Procedo con l'aggiornamento dei DATI LEGALI "+CHR(13)+"relativi all' anagrafica fornitori ? ",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


RELEASE _conta_rec 
PUBLIC _conta_rec 
_conta_rec = 0

_CONTA_REC_SENZA_RECCAT = 0   

x_soci = "FOR_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_for_an where " + x_cond + " order by FOR_codsoc,FOR_pariva"
IF !ExecCommand(cSql,"CUR_FORNITORI")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORI
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SELECT CUR_FORNITORI
      SKIP +1
      LOOP
   ENDIF   
   

   
   _CONTA_REC = _CONTA_REC  + 1
   
   
   WAIT windows "Fornitori elaborati : " + STR(_conta_rec,5,0) nowait


	SELECT CUR_FORNITORI	
	SCATTER MEMVAR MEMO
	
	M.FOR_RECCAT = M.FOR_RECCAT
	
	IF M.FOR_RECCAT = 1	OR M.FOR_RECCAT = 2
	ELSE
		M.FOR_RECCAT = 1
	ENDIF

	IF M.FOR_reccat = 1															&& PERSONA GIURIDICA
		M.FOR_RAGLEG  = M.FOR_RAGSOC	&& DATI PERSONA GIURIDICA
		M.FOR_RGLEG2  = M.FOR_RAGDUE
		M.FOR_INDLEG  = M.FOR_INDIR
		M.FOR_LOCLEG  = M.FOR_LOCALI
		M.FOR_PROLEG  = M.FOR_PROVIN
		M.FOR_NAZLEG  = M.FOR_NAZION
		M.FOR_CAPLEG  = M.FOR_CAP
		M.FOR_CFISLG  = M.FOR_CODFIS
		M.FOR_PIVALG  = M.FOR_PARIVA
		M.FOR_IVCELG  = M.FOR_IVACEE

		M.FOR_reccog  = ""				&& DATI PERSONA FISICA
		M.FOR_recnom  = ""
		M.FOR_PRONAS  = ""
		M.FOR_reccdf  = ""
	ELSE																		&& PERSONA FISICA
		M.FOR_reccog  = M.FOR_RAGSOC	&& DATI PERSONA FISICA
		M.FOR_recnom  = M.FOR_RAGDUE
		M.FOR_PRONAS  = M.FOR_PROVIN
		M.FOR_reccdf  = M.FOR_CODFIS

		M.FOR_RAGLEG  = ""				&& DATI PERSONA GIURIDICA
		M.FOR_RGLEG2  = ""
		M.FOR_INDLEG  = ""
		M.FOR_LOCLEG  = ""
		M.FOR_PROLEG  = ""
		M.FOR_NAZLEG  = ""
		M.FOR_CAPLEG  = ""
		M.FOR_CFISLG  = ""
		M.FOR_PIVALG  = ""
		M.FOR_IVCELG  = ""
	ENDIF
	M.FOR_ESTNAZ  = ""
	M.FOR_ESTDOM  = ""

	IF M.FOR_RECCAT = 1										&& PERSONA GIURIDICA
		x_cond = "PA.CODICE = 'STA" + M.FOR_NAZLEG + "'"
	ELSE													&& PERSONA FISICA
		x_cond = "PA.CODICE = 'STA" + M.FOR_NAZION + "'"
	ENDIF
	cSql = "SELECT PA.DTIPOMOV AS CODNAZ_UNI, COALESCE(NU.DESCRI,'') AS DESNAZ_UNI FROM PARA AS PA " + ;
		"LEFT OUTER JOIN NAZIONI_UNICO AS NU ON NU.CODICE = PA.DTIPOMOV WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_PARA_NAZ")
		RETURN .F.
	ENDIF
	SELECT CX_PARA_NAZ
	GO TOP
	IF !EOF()
		IF M.FOR_RECCAT = 1								&& PERSONA GIURIDICA
			M.FOR_ESTNAZ = ALLTRIM(CODNAZ_UNI)
		ELSE											&& PERSONA FISICA
			M.FOR_ESTDOM = ALLTRIM(CODNAZ_UNI)
		ENDIF
	ENDIF

	x_soci = "FOR_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "FOR_codcli = '" + M.FOR_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from u_for_an where " + x_cond + " order by FOR_codsoc,FOR_codcli"
	IF !ExecRW(cSql,"u_for_an","R")
	  return(.f.)
	ENDIF

	SELECT u_for_an
	
	IF _TIPO_AGGIORNAMENTO = 1					&& AGGIORNA SOLO DATI LEGALI VUOTI
		IF FOR_RECCAT <> 1 AND FOR_RECCAT <> 2
			REPLACE FOR_RECCAT WITH M.FOR_RECCAT
		ENDIF
		IF EMPTY(FOR_RAGLEG)
			REPLACE FOR_RAGLEG WITH M.FOR_RAGLEG     
		ENDIF
		IF EMPTY(FOR_RGLEG2)
			REPLACE FOR_RGLEG2 WITH M.FOR_RGLEG2     
		ENDIF
		IF EMPTY(FOR_INDLEG)
			REPLACE FOR_INDLEG WITH M.FOR_INDLEG     
		ENDIF
		IF EMPTY(FOR_LOCLEG)
			REPLACE FOR_LOCLEG WITH M.FOR_LOCLEG     
		ENDIF
		IF EMPTY(FOR_PROLEG)
			REPLACE FOR_PROLEG WITH M.FOR_PROLEG     
		ENDIF
		IF EMPTY(FOR_NAZLEG)
			REPLACE FOR_NAZLEG WITH M.FOR_NAZLEG     
		ENDIF
		IF EMPTY(FOR_CAPLEG)
			REPLACE FOR_CAPLEG WITH M.FOR_CAPLEG     
		ENDIF
		IF EMPTY(FOR_CFISLG)
			REPLACE FOR_CFISLG WITH M.FOR_CFISLG     
		ENDIF
		IF EMPTY(FOR_PIVALG)
			REPLACE FOR_PIVALG WITH M.FOR_PIVALG     
		ENDIF
		IF EMPTY(FOR_IVCELG)
			REPLACE FOR_IVCELG WITH M.FOR_IVCELG     
		ENDIF
		IF EMPTY(FOR_ESTNAZ)
		    REPLACE FOR_ESTNAZ WITH M.FOR_ESTNAZ
		ENDIF
    ELSE										&& AGGIORNA TUTTI I DATI LEGALI
    	REPLACE FOR_RECCAT WITH M.FOR_RECCAT
		REPLACE FOR_RAGLEG WITH M.FOR_RAGLEG     
		REPLACE FOR_RGLEG2 WITH M.FOR_RGLEG2     
		REPLACE FOR_INDLEG WITH M.FOR_INDLEG     
		REPLACE FOR_LOCLEG WITH M.FOR_LOCLEG     
		REPLACE FOR_PROLEG WITH M.FOR_PROLEG     
		REPLACE FOR_NAZLEG WITH M.FOR_NAZLEG     
		REPLACE FOR_CAPLEG WITH M.FOR_CAPLEG     
		REPLACE FOR_CFISLG WITH M.FOR_CFISLG     
		REPLACE FOR_PIVALG WITH M.FOR_PIVALG     
		REPLACE FOR_IVCELG WITH M.FOR_IVCELG     
	    REPLACE FOR_ESTNAZ WITH M.FOR_ESTNAZ
	ENDIF
  
    IF !ExecRW(cSql,"u_for_an","W")
	  return(.f.)
    ENDIF  
  
  
   SELECT CUR_FORNITORI
   SKIP +1

ENDDO


RIT = MESSAGEBOX("Fine aggiornamento DATI LEGALI relativi all'anagrafica fornitori ",62,"ATTENZIONE")

WAIT CLEAR

IF _CONTA_REC_SENZA_RECCAT > 0
	_RISP = MESSAGEBOX("Rilevati " + ALLTRIM(STR(_CONTA_REC_SENZA_RECCAT,10,0)) + " fornitori non classificati nè come Persona Giuridica, nè come Persona Fisica " + ;
		"per i quali non è stato possibile riportare i dati legali" + REPLICATE(CHR(13),2) + ;
		"Stampare una lista di tali fornitori?",4+48,"Attenzione")
	IF _RISP = 6
		SELECT * FROM CUR_FORNITORI WHERE FOR_RECCAT <> 1 AND FOR_RECCAT <> 2 ORDER BY FOR_RAGSOC INTO CURSOR CTRL_FOR_STA
		SELECT CTRL_FOR_STA
		GO TOP
		IF !EOF()
			DO PRG\MENUSTA WITH "CTRL_FOR_STA",.T.,.T.,"XXX","FOR000","FOR000.FRX",.T.
		ENDIF
	ENDIF
ENDIF

RETURN






