
********************************************************************************************************
FUNCTION CREA_FILE_XML_SEPA
*
* SINTASSI:
*
*	_NOMEFILESEPA =	CREA_FILE_XML_SEPA(<NOME_CURSORE_DETTAGLI_PIANI_PAGAMENTO>,<IBANContoAddebito>,<ContoContabileBanca>)
*
********************************************************************************************************
LPARAMETERS _par_nome_cursore_input,_par_IBANContoAddebito,_par_ContoContabileBanca

IF PCOUNT()<3
	MESSAGEBOX("CREA_FILE_XML_SEPA: Parametri insufficienti",48,"Attenzione")
ENDIF

_NOME_CURSORE_DETTAGLI_PAGAMENTI = _par_nome_cursore_input

_h_IBANContoAddebito = _par_IBANContoAddebito
_h_AbiBancaDebitore = SUBSTR(_h_IBANContoAddebito,6,5)

_X_ContoContabileBanca = _par_ContoContabileBanca

LOCAL POSIZIONE_INIZIO_DETTAGLI,POSIZIONE_FINE_DETTAGLI
POSIZIONE_INIZIO_DETTAGLI = 0
POSIZIONE_FINE_DETTAGLI = 0

IF FILE("xml_sepa.xml")	  && Esiste il file? 
ELSE
	MESSAGEBOX("File xml_sepa.xml non presente nella directory di AQUARIUS" + REPLICATE(CHR(13),2) + "Il file è necessario per creare le disposizioni di pagamento SEPA";
		+CHR(13)+"Contattare assistenza",48,"Errore creazione XML SEPA")
	RETURN ""
ENDIF

IF FILE("sepa_conf.cfg")	  && Esiste il file? 
ELSE
	MESSAGEBOX("File sepa_conf.cfg non presente nella directory di AQUARIUS" + REPLICATE(CHR(13),2) + "Il file è necessario per creare le disposizioni di pagamento SEPA";
		+CHR(13)+"Contattare assistenza",48,"Errore creazione XML SEPA")
	RETURN ""     
ENDIF

*_h_IdentificativoUnivocoMessaggio = "DistintaXml-"+SUBSTR(STRTRAN(RIBALTA2(DTOC(DATE())),'/',''),3,6) + "-" + STRTRAN(TIME(),':','')
*_h_IdentificativoUnivocoMessaggio = "DistintaXml"+SYS(2015)
_h_IdentificativoUnivocoMessaggio = "DistintaXml"+ALLTRIM(SUBSTR(SYS(2015),2))  && ERASMO - 29/11/2016
_h_DataOraCreazione = STRTRAN(RIBALTA2(DTOC(DATE())),'/','-') + "T" + TIME() + "+01:00"
_n_NumeroTransazioni = 0
_n_TotaleImportiTransazioni = 0
_h_NumeroTransazioni = ""
_h_TotaleImportiTransazioni = ""
_h_CodiceCUCAziendaMittente = legge_config("sepa_conf.cfg","CODICECUCAZIENDAMITTENTE")
_h_DataEsecuzioneRichiesta = STRTRAN(RIBALTA2(DTOC(DATE())),'/','-')

*** CERCO LA VERSIONE DEL FILE XML PERSONALIZZATO PER IBAN BANCA DEBITORE
_h_VersioneSchemaCBIPaymentRequest = legge_config("sepa_conf.cfg","VERSIONESCHEMACBIPAYMENTREQUEST"+"_"+ALLTRIM(_par_IBANContoAddebito))
*** CERCO LA VERSIONE DEL FILE XML INDIPENDENTE DALL' IBAN BANCA DEBITORE
IF EMPTY(_h_VersioneSchemaCBIPaymentRequest)
	_h_VersioneSchemaCBIPaymentRequest = legge_config("sepa_conf.cfg","VERSIONESCHEMACBIPAYMENTREQUEST")
ENDIF
*** VERSIONE DEL FILE XML DI DEFAULT
IF EMPTY(_h_VersioneSchemaCBIPaymentRequest)
	_h_VersioneSchemaCBIPaymentRequest = "00.03.09"
ENDIF


DO CREA_CURSOR_DETTAGLI_PAGAMENTI_SEPA

SELECT DETTAGLI_PAGAMENTI_SEPA
GO TOP
SCAN
	_n_NumeroTransazioni = _n_NumeroTransazioni + 1
	_n_TotaleImportiTransazioni = _n_TotaleImportiTransazioni + ImportoDisposizione
ENDSCAN
_h_NumeroTransazioni = ALLTRIM(STR(_n_NumeroTransazioni,10,0))
_h_TotaleImportiTransazioni = STRTRAN(ALLTRIM(STR(_n_TotaleImportiTransazioni,10,2)),',','.')

DO CREA_CURSOR_DATI_HEADER_SEPA

*** crea il file xml: per ora è vuoto e nei passi successivi vengono aggiunti i vari elementi
_DIRECTORY_DI_DESTINAZIONE_FILE_SEPA = legge_config("sepa_conf.cfg","DIRECTORYDESTINAZIONE")
IF DIRECTORY(_DIRECTORY_DI_DESTINAZIONE_FILE_SEPA)
ELSE
	_COMMAND = "MKDIR &_DIRECTORY_DI_DESTINAZIONE_FILE_SEPA"
	&_COMMAND
ENDIF
_FILE_XML_SEPA = _DIRECTORY_DI_DESTINAZIONE_FILE_SEPA+_h_IdentificativoUnivocoMessaggio+".xml"

STRTOFILE("",_FILE_XML_SEPA,0)

_TEMPLATE_XML_SEPA=FILETOSTR("xml_sepa.xml")

**=> ERASMO/SERGIO - INIZIO 17/11/2023
_cPrefissoNomeFileXmlPerVersione = "xml_sepa_CBIPaymentRequest."
_cNomeFileXmlPerVersione = _cPrefissoNomeFileXmlPerVersione + _h_VersioneSchemaCBIPaymentRequest + ".xml"
IF FILE(_cNomeFileXmlPerVersione,1)
	_TEMPLATE_XML_SEPA=FILETOSTR(_cNomeFileXmlPerVersione)
ENDIF
**=> ERASMO/SERGIO - FINE 17/11/2023

**** HEADER

*** SOSTITUISCO LE STRINGHE PER LA VERSIONE DEFINITA NEL FILE "sepa_conf.cfg"
_TEMPLATE_XML_SEPA = STRTRAN(_TEMPLATE_XML_SEPA,"CBIBdyPaymentRequest.99.99.99","CBIBdyPaymentRequest."+_h_VersioneSchemaCBIPaymentRequest)
_TEMPLATE_XML_SEPA = STRTRAN(_TEMPLATE_XML_SEPA,"CBIPaymentRequest.99.99.99","CBIPaymentRequest."+_h_VersioneSchemaCBIPaymentRequest)

_TEMPLATE_XML_SEPA=SOSTITUISCE_CAMPI_CURSOR_SU_TESTO_SEPA("HEADER_SEPA",_TEMPLATE_XML_SEPA)

POSIZIONE_INIZIO_DETTAGLI	=ATC("<CdtTrfTxInf",_TEMPLATE_XML_SEPA)
POSIZIONE_FINE_DETTAGLI		=ATC("</CdtTrfTxInf>",_TEMPLATE_XML_SEPA)+LEN("</CdtTrfTxInf>")

_STRING_XML=SUBSTR(_TEMPLATE_XML_SEPA,1,POSIZIONE_INIZIO_DETTAGLI - 1)
APPEND_XML_FILE_SEPA("HEADER_SEPA",_STRING_XML,_FILE_XML_SEPA)    

**** DETTAGLI DISPOSIZIONI

_STRING_XML=SUBSTR(_TEMPLATE_XML_SEPA,POSIZIONE_INIZIO_DETTAGLI,POSIZIONE_FINE_DETTAGLI-POSIZIONE_INIZIO_DETTAGLI)
APPEND_XML_FILE_SEPA("DETTAGLI_PAGAMENTI_SEPA",_STRING_XML,_FILE_XML_SEPA )

**** FOOTER

_STRING_XML=SUBSTR(_TEMPLATE_XML_SEPA,POSIZIONE_FINE_DETTAGLI)
APPEND_XML_FILE_SEPA("HEADER_SEPA",_STRING_XML,_FILE_XML_SEPA )

SELECT HEADER_SEPA
USE

SELECT DETTAGLI_PAGAMENTI_SEPA
USE

WAIT WINDOW "CREAZIONE FILE SEPA "+_FILE_XML_SEPA+" TERMINATA CORRETTAMENTE" NOWAIT

RETURN _FILE_XML_SEPA


******************************************************************************
PROCEDURE APPEND_XML_FILE_SEPA
******************************************************************************

LPARAMETERS P_CURSOR,P_XML_STRING,P_XML_FILE

LOCAL _XML_STRING

SELECT &P_CURSOR
GO TOP

_NUMERO_RIGA=0

SCAN 

	_XML_STRING = P_XML_STRING

	_NUMERO_RIGA= _NUMERO_RIGA+1
	*_XML_STRING = STRTRAN(_XML_STRING ,"#NUMERO_RIGA#"  ,ALLTRIM(STR(_NUMERO_RIGA,2,0)))
	_XML_STRING = STRTRAN(_XML_STRING ,"#NUMERO_RIGA#",ALLTRIM(STR(_NUMERO_RIGA,10,0)))  && ERASMO - 06/12/2023

	_XML_STRING =SOSTITUISCE_CAMPI_CURSOR_SU_TESTO_SEPA(P_CURSOR,_XML_STRING)

	STRTOFILE(_XML_STRING ,P_XML_FILE,1)
	
ENDSCAN

RETURN
* FINE PROCEDURE APPEND_XML_FILE_SEPA
******************************************************************************




******************************************************************************
PROCEDURE SOSTITUISCE_CAMPI_CURSOR_SU_TESTO_SEPA
******************************************************************************

LPARAMETERS P_CURSOR,P_XML_STRING

LOCAL _XML_STRING

_XML_STRING = P_XML_STRING

SELECT &P_CURSOR

SCATTER MEMVAR MEMO

_NUMERO_CAMPI=AFIELDS(_ARRAY_CAMPI_CURSOR)

FOR nCount  = 1 TO _NUMERO_CAMPI
	_NOME_CAMPO="M."+ALLTRIM(_ARRAY_CAMPI_CURSOR(nCount ,1))
	_NOME_TAG  ="#"+ALLTRIM(_ARRAY_CAMPI_CURSOR(nCount ,1))+"#"
	
	DO CASE
		 CASE _ARRAY_CAMPI_CURSOR(nCount ,2) ="C"
			_VALORE_CAMPO=EVALUATE("ALLTRIM("+_NOME_CAMPO+")")
		 CASE _ARRAY_CAMPI_CURSOR(nCount ,2) ="N"
		 	_DIMENSIONE= _ARRAY_CAMPI_CURSOR(nCount ,3)
		 	_DECIMALI= _ARRAY_CAMPI_CURSOR(nCount ,4)
		 	IF _DECIMALI>0
				_VALORE_CAMPO=EVALUATE("STRTRAN(ALLTRIM(STR("+_NOME_CAMPO+","+STR(_DIMENSIONE,3,0)+",2)),',','.')")
			ELSE
				_VALORE_CAMPO=EVALUATE("ALLTRIM(STR("+_NOME_CAMPO+","+STR(_DIMENSIONE,3,0)+",0))")
			ENDIF					
			
	ENDCASE
	
	_XML_STRING= STRTRAN(_XML_STRING,_NOME_TAG  ,_VALORE_CAMPO)
	
ENDFOR

RETURN _XML_STRING

* FINE PROCEDURE SOSTITUISCE_CAMPI_CURSOR_SU_TESTO_SEPA
******************************************************************************

******************************************************************************
PROCEDURE CREA_CURSOR_DATI_HEADER_SEPA
******************************************************************************
TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

	SELECT 
		RTRIM(azi_ragsoc) as NomeAziendaMittente,
		'<<_h_IdentificativoUnivocoMessaggio>>' as IdentificativoUnivocoMessaggio,
		'<<_h_DataOraCreazione>>' as DataOraCreazione,
		'<<_h_NumeroTransazioni>>' as NumeroTransazioni,
		'<<_h_TotaleImportiTransazioni>>' as TotaleImportiTransazioni,
		'<<_h_CodiceCUCAziendaMittente>>' as CodiceCUCAziendaMittente,
		'<<_h_DataEsecuzioneRichiesta>>' as DataEsecuzioneRichiesta,
		'<<_h_IBANContoAddebito>>' as IBANContoAddebito,
		'<<_h_AbiBancaDebitore>>' as AbiBancaDebitore
	FROM U_AZI_AN

ENDTEXT					&& FINE SCRITTURA QUERY

IF !ExecPreparedCommand(cSql,"HEADER_SEPA")
	return(.F.)
ENDIF

**=> ERASMO - INIZIO 22/03/2016
SELECT HEADER_SEPA
GO TOP
IF !EOF()
	REPLACE NomeAziendaMittente WITH PARSE_STRING_XML(ALLTRIM(NomeAziendaMittente))
ENDIF
**=> ERASMO - FINE - 22/03/2016

RETURN
* FINE PROCEDURE CREA_CURSOR_DATI_HEADER_SEPA
******************************************************************************

******************************************************************************
PROCEDURE CREA_CURSOR_DETTAGLI_PAGAMENTI_SEPA
******************************************************************************

SELECT ;
	SPACE(35) AS ProgressivoDisposizione, ;
	NSALDO AS ImportoDisposizione, ;
	ALLTRIM(PUB_VALRIF) AS DivisaDisposizione, ;
	SPACE(35) AS NomeBeneficiario, ;
	SPACE(27) AS IBANBeneficiario, ;
	SPACE(140) AS CausaleDisposizione, ;
	SPACE(4) AS CausaleBancaria, ;
	FORMAPAGAM, ;
	NUMEROFATT, ;
	DATAFATT, ;
	TIPOLOGIA, ;
	CODFOR, ;
	RAGSOC, ;
	COSATRATTA AS MATRICOLA	;
FROM &_NOME_CURSORE_DETTAGLI_PAGAMENTI ;
WHERE 1=0 ;
INTO CURSOR DETTAGLI_PAGAMENTI_SEPA READWRITE

INDEX ON ALLTRIM(CODFOR)+ALLTRIM(TIPOLOGIA)+ALLTRIM(MATRICOLA) TAG I_RAGGR
INDEX ON ProgressivoDisposizione TAG I_PROGRE

_PROGRE_DISPOSIZIONE = 0

SELECT &_NOME_CURSORE_DETTAGLI_PAGAMENTI
GO TOP
SCAN
	
	**=> ERASMO - INIZIO 26/01/2017
	*** I FILE SEPA CON DISPOSIZIONI AD IMPORTO ZERO VERREBBERO SCARTATI
	IF NSALDO <> 0
	ELSE
		LOOP
	ENDIF
	**=> ERASMO - FINE 26/01/2017

	M.NSALDO = NSALDO
	M.QUANTAVALU = QUANTAVALU
	M.FORMAPAGAM = FORMAPAGAM 
	M.NUMEROFATT = NUMEROFATT 
	M.DATAFATT = DATAFATT  && ERASMO - 02/08/2017
	M.TIPOLOGIA = TIPOLOGIA 
	M.CODFOR = CODFOR 
	*M.RAGSOC = RAGSOC 
	M.MATRICOLA = COSATRATTA 
	M.RAGSOC = PARSE_STRING_XML(ALLTRIM(RAGSOC))  && ERASMO - 22/03/2016
	
	SELECT &_NOME_CURSORE_DETTAGLI_PAGAMENTI
	
	IF TIPOLOGIA !="STIPENDIO"  && SE BONIFICO A FORNITORE, NO STIPENDIO, RAGGRUPPO I PAGAMENTI
			
		SELECT DETTAGLI_PAGAMENTI_SEPA
		SET ORDER TO I_RAGGR
		GO TOP
		_SEEK = ALLTRIM(M.CODFOR)+ALLTRIM(M.TIPOLOGIA)+ALLTRIM(M.MATRICOLA)
		SEEK _SEEK
		IF !FOUND()	
			
			_IBAN_BENEFICIARIO = RICERCA_IBAN_CLIFOR(M.CODFOR)
			_NOME_BENEFICIARIO = ALLTRIM(M.RAGSOC)
			
			_PROGRE_DISPOSIZIONE = _PROGRE_DISPOSIZIONE + 1
			
			SELECT DETTAGLI_PAGAMENTI_SEPA
			APPEND BLANK
			REPLACE ProgressivoDisposizione WITH _h_IdentificativoUnivocoMessaggio + "-" + PADL(ALLTRIM(STR(_PROGRE_DISPOSIZIONE,4,0)),4,'0')
			REPLACE ImportoDisposizione WITH M.NSALDO
			REPLACE DivisaDisposizione WITH ALLTRIM(PUB_VALRIF)
			REPLACE NomeBeneficiario WITH _NOME_BENEFICIARIO
			REPLACE IBANBeneficiario WITH _IBAN_BENEFICIARIO
			*REPLACE CausaleDisposizione WITH "DOCUM. NR. " + ALLTRIM(M.NUMEROFATT)
			REPLACE CausaleDisposizione WITH "DOCUM. NR. " + ALLTRIM(M.NUMEROFATT) + " DEL " + ALLTRIM(M.DATAFATT)  && ERASMO - 02/08/2017
			
			REPLACE CausaleBancaria WITH "SUPP"
			
			REPLACE FORMAPAGAM WITH M.FORMAPAGAM 
			REPLACE NUMEROFATT WITH M.NUMEROFATT 
			REPLACE DATAFATT WITH M.DATAFATT  && ERASMO - 02/08/2017			
			REPLACE TIPOLOGIA WITH M.TIPOLOGIA 
			REPLACE CODFOR WITH M.CODFOR 
			REPLACE RAGSOC WITH M.RAGSOC 
			REPLACE MATRICOLA WITH M.MATRICOLA 
		ELSE
			SELECT DETTAGLI_PAGAMENTI_SEPA
			REPLACE ImportoDisposizione WITH ImportoDisposizione + M.NSALDO
			*REPLACE CausaleDisposizione WITH ALLTRIM(CausaleDisposizione) + " - " + ALLTRIM(M.NUMEROFATT)
			REPLACE CausaleDisposizione WITH ALLTRIM(CausaleDisposizione) + " - " + ALLTRIM(M.NUMEROFATT) + " DEL " + ALLTRIM(M.DATAFATT)  && ERASMO - 02/08/2017
		ENDIF
		
	ELSE	
	
		_CODFOR = M.CODFOR
		_MATRICOLA = ALLTRIM(M.MATRICOLA)
	
		cSql=""
		cNomeCursorSql="cpersone"
		
		TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

			SELECT 
				ANA.COGNOME,
				ANA.NOME,
				RAP.CONTOCONT,
				RAP.MATRICOLA,
				COALESCE(BAN.IBAN,'') AS  IBAN,
				SUBSTRING(COALESCE(BAN.IBAN,''),1,2) AS COD_NAZIONE,
				SUBSTRING(COALESCE(BAN.IBAN,''),3,2) AS CHK_DIGIT,
				SUBSTRING(COALESCE(BAN.IBAN,''),5,1) AS CIN,
				SUBSTRING(COALESCE(BAN.IBAN,''),6,5) AS ABI,
				SUBSTRING(COALESCE(BAN.IBAN,''),11,5) AS CAB,
				SUBSTRING(COALESCE(BAN.IBAN,''),16,12) AS CC 
			FROM RISUMANA AS ANA
			LEFT OUTER JOIN RISURAPP AS RAP
			ON ANA.TAGGANCIO=RAP.DAGGANCIO AND B_INCORSO='S'
			LEFT OUTER JOIN RISUBANC AS BAN
			ON ANA.TAGGANCIO=BAN.DAGGANCIO AND B_RIFER='S' 
			WHERE RAP.MATRICOLA='<<_MATRICOLA>>'
		
		ENDTEXT					&& FINE SCRITTURA QUERY

		IF !ExecPreparedCommand(cSql,cNomeCursorSql)
			MESSAGEBOX("Non trovato dipendente matr.:"+_CODFOR,48,"Attenzione")
	  		SELECT &_NOME_CURSORE_DETTAGLI_PAGAMENTI
	  		LOOP
		ENDIF 	  		

		SELECT cpersone
		GO TOP
		IF EOF()
			MESSAGEBOX("Non trovato dipendente matr.:"+_CODFOR,48,"Attenzione")
	  		SELECT &_NOME_CURSORE_DETTAGLI_PAGAMENTI
	  		LOOP
		ENDIF
			
		_IBAN_BENEFICIARIO = ALLTRIM(IBAN)
		_NOME_BENEFICIARIO = ALLTRIM(COGNOME) + " " + ALLTRIM(NOME)
		_NOME_BENEFICIARIO = PARSE_STRING_XML(_NOME_BENEFICIARIO)  && ERASMO - 22/03/2016
		MESE_STIPENDIO=SUBSTR(M.RAGSOC,LEN("STIP.")+1,2)
		ANNO_STIPENDIO=SUBSTR(M.RAGSOC,LEN("STIP.MM/")+1,4)
		
		_PROGRE_DISPOSIZIONE = _PROGRE_DISPOSIZIONE + 1
		
		SELECT DETTAGLI_PAGAMENTI_SEPA
		APPEND BLANK
		REPLACE ProgressivoDisposizione WITH _h_IdentificativoUnivocoMessaggio + "-" + PADL(ALLTRIM(STR(_PROGRE_DISPOSIZIONE,4,0)),4,'0')
		REPLACE ImportoDisposizione WITH ABS(M.QUANTAVALU)  && NON SO PERCHE' M.NSALDO NON E' AFFIDABILE E M.QUANTAVALU E' NEGATIVO
		REPLACE DivisaDisposizione WITH ALLTRIM(PUB_VALRIF)
		REPLACE NomeBeneficiario WITH _NOME_BENEFICIARIO
		REPLACE IBANBeneficiario WITH _IBAN_BENEFICIARIO
		*REPLACE CausaleDisposizione WITH "STIPENDIO MESE DI "+DESCRIZIONE_MESE(MESE_STIPENDIO)+" "+ANNO_STIPENDIO
		REPLACE CausaleDisposizione WITH ALLTRIM(M.RAGSOC)  && ERASMO - 23/09/2021
		REPLACE CausaleBancaria WITH "SALA"
		
		REPLACE FORMAPAGAM WITH M.FORMAPAGAM 
		REPLACE NUMEROFATT WITH M.NUMEROFATT 
		REPLACE DATAFATT WITH M.DATAFATT  && ERASMO - 02/08/2017
		REPLACE TIPOLOGIA WITH M.TIPOLOGIA 
		REPLACE CODFOR WITH M.CODFOR 
		REPLACE RAGSOC WITH M.RAGSOC 
		REPLACE MATRICOLA WITH M.MATRICOLA 
	
	ENDIF TIPOLOGIA !="STIPENDIO"

ENDSCAN

SELECT DETTAGLI_PAGAMENTI_SEPA
DELETE FOR NSALDO <= 0  && ERASMO - 26/01/2017
SET ORDER TO I_PROGRE
GO TOP

RETURN
* FINE PROCEDURE CREA_CURSOR_DETTAGLI_PAGAMENTI_SEPA
******************************************************************************


**********************************************************
FUNCTION RICERCA_IBAN_CLIFOR
**********************************************************
PARAMETERS _P_CODFOR

LOCAL _CODFOR,_CLI_FOR,_ACT_SELECT

_CODFOR=""
_RAGSOC=""
_CLI_FOR=""

_ACT_SELECT = SELECT()

IF SUBSTR(_P_CODFOR,1,LEN(PUB_FF))=PUB_FF
	*** FORNITORE
	_CODFOR= SUBSTR(_P_CODFOR,LEN(PUB_FF)+1)
	_CLI_FOR="FOR"
ELSE
	*** CLIENTE
	_CODFOR= SUBSTR(_P_CODFOR,LEN(PUB_CC)+1)
	_CLI_FOR="CLI"
ENDIF

CSQL=""

IF _CLI_FOR="CLI"	
	CSQL="SELECT CLI_RAGSOC AS RAG_SOCIALE,cli_cdiban AS IBAN FROM U_CLI_AN WHERE CLI_CODCLI='"+_CODFOR+"'"
ELSE
	CSQL="SELECT FOR_RAGSOC AS RAG_SOCIALE,for_ba2iba AS IBAN FROM U_FOR_AN WHERE FOR_CODCLI='"+_CODFOR+"'"
ENDIF

IF !EXECCOMMAND(CSQL,"CU_IBAN")
	SELECT(_ACT_SELECT)
	RETURN(.F.)
ENDIF	

SELECT CU_IBAN
GO TOP
IF EOF()
  	MESSAGEBOX("Anagrafica " + IIF(_CLI_FOR = "FOR","Fornitore",IIF(_CLI_FOR = "CLI", "Cliente", "")) + ALLTRIM(_P_CODFOR) + " non trovata" ,48,"Attenzione")
  	SELECT(_ACT_SELECT)
	RETURN ""
ELSE
	IF EMPTY(IBAN)
	  	MESSAGEBOX("Per il " + IIF(_CLI_FOR = "FOR","Fornitore",IIF(_CLI_FOR = "CLI", "Cliente", "")) +ALLTRIM(RAG_SOCIALE)+" non sono complete le informazioni relative alla banca per bonifici" ,48,"Attenzione")
	  	SELECT(_ACT_SELECT)
		RETURN ""
	ENDIF
ENDIF

_RIT=ALLTRIM(IBAN)

SELECT(_ACT_SELECT)

RETURN _RIT
