***************************
PROCEDURE DEFCBIPUB
***************************

DO 		RELEASECBIPUB

PUBLIC  _causale,;
		_codiceSIA,;
		_ProgrDisp,;
		_progressivo_file,;
		_abiOrdinante,;
		_cabOrdinante,;
		_cinOrdinante,;
		_ccOrdinante,;
		_checkDigitOrdinante,;
		_abiDest,;
		_cabDest,;
		_cinDest,;
		_ccDest,;
		_chkdgtDest,;
		_Importo,;
		_Segno,;
		_CodDivisa,;
		_TipoPagamento,;
		_TipoFlusso,;
		_IdFlusso,;
		_DataApplicativa,;
		_TotDisp,;
		_TotImportiNeg,;
		_TotImportiPos,;
		_NumeroRecord,;
		_SoggVeicolatore,;
		_centroApp,;
		_RagioneSocialeOrdinante,;
		_IndirizzoOrdinante,;
		_LocalitaOrdinante,;		
		_CodiceFiscaleOrdinante,;
		_SegmentoDatiDestinatario,;
		_CodiceFiscaleDestinatario,;
		_IndirizzoDest,;
		_ComuneProvinciaDest,;
		_CAPDest,;
		_Riferimenti,;
		_CodControllo,;
		_FlagRichiesta,;
		_IdDisposizione,;
		_SecretKey,;
		_CodMP,;
		_directoryDestinazione,;
		_dataValutaBeneficiario,;
		_dataEsecuzioneBonifico,;
		ANNO_STIPENDIO,MESE_STIPENDIO,_nomeFileCBI,_DATA_CREAZIONE,_ORA_CREAZIONE
		

_codiceSIA	                = legge_config_cbi("CodiceSIA")
_abiOrdinante	            = legge_config_cbi("ABIOrdinante")
_cabOrdinante	            = legge_config_cbi("CABOrdinante")
_ccOrdinante  	            = legge_config_cbi("CCOrdinante")
_cinOrdinante				= legge_config_cbi("CINOrdinante")
_checkDigitOrdinante		= legge_config_cbi("CINOrdinante")
_RagioneSocialeOrdinante    = legge_config_cbi("RagioneSocialeOrdinante")
_IndirizzoOrdinante			= legge_config_cbi("IndirizzoOrdinante")
_LocalitaOrdinante			= legge_config_cbi("LocalitaOrdinante")
_CodiceFiscaleOrdinante     = legge_config_cbi("CodiceFiscaleOrdinante")
_IdFlusso                   = legge_config_cbi("IdFlusso") 					&& "$"
_CodDivisa                  = legge_config_cbi("CodDivisa")
_CodicePaese                = legge_config_cbi("CodicePaese")
_SoggVeicolatore            = legge_config_cbi("SoggVeicolatore")
_CodMP		                = legge_config_cbi("CodMP")
_CodControllo	            = legge_config_cbi("CodControllo") 				&& Codice di controllo scambiato tra centri applicativi
_TipoFlusso	 	            = legge_config_cbi("TipoFlusso")
_CentroApp                  = legge_config_cbi("CentroApp")
_DataApplicativa            = legge_config_cbi("DataApplicativa")
_directoryDestinazione      = legge_config_cbi("directoryDestinazione")


_dataValutaBeneficiario     =""
_dataEsecuzioneBonifico     =""
_chkdgtDest                 =""

_ORA_CREAZIONE=TIME(SECONDS())
_DATA_CREAZIONE=DTOC(DATE())

*** FORMATO NOME FILE: CODICE SIA (5 CHAR) + ULTIMA CIFRA ANNO (1 CHAR) + MMGGHHMMSS.TXT
_nomeFileCBI=_codiceSIA+substr(_DATA_CREAZIONE,10)+substr(_DATA_CREAZIONE,4,2)+substr(_DATA_CREAZIONE,1,2)+substr(_ORA_CREAZIONE,1,2)+substr(_ORA_CREAZIONE,4,2)+substr(_ORA_CREAZIONE,7,2)+".TXT"

return
***************************

***************************
procedure releasecbipub
***************************
release	_causale,;
		_codiceSIA,;
		_ProgrDisp,;
		_progressivo_file,;
		_abiOrdinante,;
		_cabOrdinante,;
		_cinOrdinante,;
		_ccOrdinante,;
		_checkDigitOrdinante,;
		_abiDest,;
		_cabDest,;
		_cinDest,;
		_chkdgtDest,;
		_ccDest,;
		_Importo,;
		_Segno,;
		_CodDivisa,;
		_TipoPagamento,;
		_TipoFlusso,;
		_IdFlusso,;
		_DataApplicativa,;
		_TotDisp,;
		_TotImportiNeg,;
		_TotImportiPos,;
		_NumeroRecord,;
		_SoggVeicolatore,;
		_centroApp,;
		_RagioneSocialeOrdinante,;
		_IndirizzoOrdinante,;
		_LocalitaOrdinante,;		
		_CodiceFiscaleOrdinante,;
		_SegmentoDatiDestinatario,;
		_CodiceFiscaleDestinatario,;
		_IndirizzoDest,;
		_ComuneProvinciaDest,;
		_CAPDest,;
		_Riferimenti,;
		_CodControllo,;
		_FlagRichiesta,;
		_IdDisposizione,;
		_SecretKey,;
		_CodMP,;
		_directoryDestinazione,;
		_dataValutaBeneficiario,;
		_dataEsecuzioneBonifico,;
		ANNO_STIPENDIO,MESE_STIPENDIO,_DATA_CREAZIONE,_ORA_CREAZIONE

return
***************************


***************************
procedure storerecord 
***************************
parameters stringaRecord, nomefile
	LOCAL CRLF
	CRLF = CHR(13)+CHR(10)
	
	if len(stringaRecord)<120 
		logerror(nomefile+" - "+stringaRecord+" record di "+str(len(stringaRecord))+" caratteri")
	endif
	
	STRTOFILE(stringaRecord+CRLF,_directoryDestinazione+nomefile,.t.)
return
***************************


***************************
procedure logerror
***************************
parameters stringaErrore
	LOCAL CRLF,pLogFile
	
	CRLF = CHR(13)+CHR(10)
	pLogFile="cbi.log"
	
	
	STRTOFILE(DTOC(DATE())+" - "+stringaErrore+CRLF,pLogFile,.t.)
return
***************************


*****************************
procedure bonificoformatter
*****************************
parameters pNomeCursor

do defcbipub

local 	contaRecordCBI

*** imposta i dati caratteristici del bonifico generico
_causale		="48000"
_segno			="+"
_TipoPagamento 	="1"  && bonifico
_FlagRichiesta 	=""   && blank=come da accordi tra cliente e banca


if !used(pNomeCursor)
	messagebox("Impossibile aprire sorgente dati.",48,"Creazione tracciato CBI")
	return
endif

contaRecordCBI=0


select &pNomeCursor
REPLACE BANCA_PART WITH BANCA ALL
REPLACE TIPOLOGIA WITH "BONIFICO" FOR EMPTY(TIPOLOGIA)

select &pNomeCursor

GO TOP

DO WHILE !EOF()

	IF TIPOLOGIA='STIPENDIO'

		MESE_STIPENDIO=SUBSTR(M.RAGSOC,LEN("STIP.")+1,2)
		ANNO_STIPENDIO=SUBSTR(M.RAGSOC,LEN("STIP.MM/")+1,4)
	
		***DO SPLIT_STIPENDI
	ENDIF

	select &pNomeCursor
	
	SKIP

ENDDO

INDEX ON BANCA_PART+CODFOR+QUANDOVALU TAG INDICE
SET ORDER TO INDICE

CREATE CURSOR CURSORCBI (;
	ID_UNIQUE  C(200),;
	TIPOLOGIA  C(30),;
	LNKGRUPPO  C(40) ,;
	RIFERIMEN  C(200),;
	CODFOR     C(13),;
	BANCA_PART C(10),;
	QUANDOVALU C(10),;
	QUANTAVALU N(20,3),;
	MATRICOLA C(5);
)

SELECT  &pNomeCursor
SET FILTER TO !EMPTY(SELEZIONE)
GO TOP

_BANCA_PART_RAGGRUPPAMENTO=BANCA_PART
_CODFOR_RAGGRUPPAMENTO=CODFOR
_QUANDOVALU_RAGGRUPPAMENTO=QUANDOVALU
_QUANTAVALU_RAGGRUPPAMENTO=0
_RIFERIMENTI_RAGGRUPPAMENTO=""

SET FILTER TO
GO TOP

_MATRICOLA=""
_TIPOLOGIA=""

IF PUB_RAGGRUPPA_PER_DESTINATARIO

	IF PUB_RAGGRUPPA_PER_DATA_VALUTA
	
		_LNKGRUPPO=ALLTRIM(_BANCA_PART_RAGGRUPPAMENTO)+"-"+ALLTRIM(_CODFOR_RAGGRUPPAMENTO)+"-"+ALLTRIM(_QUANDOVALU_RAGGRUPPAMENTO)

		DO WHILE !EOF()
		
			IF DELETED()
				SKIP
				LOOP
			ENDIF
			
			IF EMPTY(SELEZIONE)
				SKIP
				LOOP
			ENDIF
			
			IF BANCA_PART = _BANCA_PART_RAGGRUPPAMENTO AND CODFOR=_CODFOR_RAGGRUPPAMENTO AND  QUANDOVALU = _QUANDOVALU_RAGGRUPPAMENTO
				_QUANTAVALU_RAGGRUPPAMENTO = _QUANTAVALU_RAGGRUPPAMENTO + QUANTAVALU
				_RIFERIMENTI_RAGGRUPPAMENTO = _RIFERIMENTI_RAGGRUPPAMENTO+IIF(!EMPTY(_RIFERIMENTI_RAGGRUPPAMENTO)," - ","")+"FAT.N."+alltrim(NUMEROFATT)
			ELSE
			&& ROTTURA PER DESTINATARIO
	
				*** SCRIVO LA RIGA CHE RAGGRUPPA		
				SELECT CURSORCBI
				APPEND BLANK
				REPLACE QUANTAVALU WITH _QUANTAVALU_RAGGRUPPAMENTO,;
						QUANDOVALU WITH _QUANDOVALU_RAGGRUPPAMENTO,;
						CODFOR	   WITH _CODFOR_RAGGRUPPAMENTO,;
						BANCA_PART WITH _BANCA_PART_RAGGRUPPAMENTO,;
						RIFERIMEN  WITH ALLTRIM(_RIFERIMENTI_RAGGRUPPAMENTO),;
						LNKGRUPPO  WITH _LNKGRUPPO,;
						TIPOLOGIA  WITH _TIPOLOGIA,;
						MATRICOLA  WITH _MATRICOLA

				SELECT &pNomeCursor 		
				*** AZZERO I DATI DEL RAGGRUPPAMENTO
				_BANCA_PART_RAGGRUPPAMENTO=BANCA_PART
				_CODFOR_RAGGRUPPAMENTO=CODFOR
				_QUANDOVALU_RAGGRUPPAMENTO=QUANDOVALU
				_QUANTAVALU_RAGGRUPPAMENTO=QUANTAVALU
				_RIFERIMENTI_RAGGRUPPAMENTO="FAT.N."+alltrim(NUMEROFATT)
				_LNKGRUPPO=ALLTRIM(BANCA_PART)+"-"+ALLTRIM(CODFOR)+"-"+ALLTRIM(QUANDOVALU)
	
			ENDIF
		
			SELECT &pNomeCursor
			
			_TIPOLOGIA=TIPOLOGIA
						
			IF TIPOLOGIA='STIPENDIO'
				_MATRICOLA=COSATRATTA
			ELSE
				_MATRICOLA=""
			ENDIF

			SELECT &pNomeCursor
			SKIP
			
		ENDDO
		
		*** SCRIVO L'ULTIMA RIGA CHE RAGGRUPPA		
		SELECT CURSORCBI
		APPEND BLANK
		REPLACE QUANTAVALU WITH _QUANTAVALU_RAGGRUPPAMENTO,;
				QUANDOVALU WITH _QUANDOVALU_RAGGRUPPAMENTO,;
				CODFOR	   WITH _CODFOR_RAGGRUPPAMENTO,;
				BANCA_PART WITH _BANCA_PART_RAGGRUPPAMENTO,;
				RIFERIMEN  WITH ALLTRIM(_RIFERIMENTI_RAGGRUPPAMENTO),;
				LNKGRUPPO  WITH _LNKGRUPPO,;
				TIPOLOGIA  WITH _TIPOLOGIA,;
				MATRICOLA  WITH _MATRICOLA

	ELSE
	
		_LNKGRUPPO=ALLTRIM(_BANCA_PART_RAGGRUPPAMENTO)+"-"+ALLTRIM(_CODFOR_RAGGRUPPAMENTO)

		DO WHILE !EOF()
		
			IF DELETED()
				SKIP
				LOOP
			ENDIF
		
			IF EMPTY(SELEZIONE)
				SKIP
				LOOP
			ENDIF

			_TIPOLOGIA=TIPOLOGIA
						
			IF BANCA_PART = _BANCA_PART_RAGGRUPPAMENTO AND CODFOR=_CODFOR_RAGGRUPPAMENTO
				_QUANTAVALU_RAGGRUPPAMENTO = _QUANTAVALU_RAGGRUPPAMENTO + QUANTAVALU
				_RIFERIMENTI_RAGGRUPPAMENTO = _RIFERIMENTI_RAGGRUPPAMENTO+IIF(!EMPTY(_RIFERIMENTI_RAGGRUPPAMENTO)," - ","")+"FAT.N."+alltrim(NUMEROFATT)
				
			ELSE
			&& ROTTURA PER DESTINATARIO
	
				*** SCRIVO LA RIGA CHE RAGGRUPPA		
				SELECT CURSORCBI
				APPEND BLANK
				REPLACE QUANTAVALU WITH _QUANTAVALU_RAGGRUPPAMENTO,;
						QUANDOVALU WITH _QUANDOVALU_RAGGRUPPAMENTO,;
						CODFOR	   WITH _CODFOR_RAGGRUPPAMENTO,;
						BANCA_PART WITH _BANCA_PART_RAGGRUPPAMENTO,;
						RIFERIMEN  WITH ALLTRIM(_RIFERIMENTI_RAGGRUPPAMENTO),;
						LNKGRUPPO  WITH _LNKGRUPPO,;
						TIPOLOGIA  WITH _TIPOLOGIA
		
				SELECT &pNomeCursor 		
				*** AZZERO I DATI DEL RAGGRUPPAMENTO
				_BANCA_PART_RAGGRUPPAMENTO=BANCA_PART
				_CODFOR_RAGGRUPPAMENTO=CODFOR
				_QUANDOVALU_RAGGRUPPAMENTO=QUANDOVALU
				_QUANTAVALU_RAGGRUPPAMENTO=QUANTAVALU
				_RIFERIMENTI_RAGGRUPPAMENTO="FAT.N."+alltrim(NUMEROFATT)
				_LNKGRUPPO=ALLTRIM(BANCA_PART)+"-"+ALLTRIM(CODFOR)
				
			
			ENDIF
		
			SELECT &pNomeCursor
			SKIP
			
		ENDDO
			
		*** SCRIVO L'ULTIMA RIGA CHE RAGGRUPPA		
		SELECT CURSORCBI
		APPEND BLANK
		REPLACE QUANTAVALU WITH _QUANTAVALU_RAGGRUPPAMENTO,;
				QUANDOVALU WITH _QUANDOVALU_RAGGRUPPAMENTO,;
				CODFOR	   WITH _CODFOR_RAGGRUPPAMENTO,;
				BANCA_PART WITH _BANCA_PART_RAGGRUPPAMENTO,;
				RIFERIMEN  WITH ALLTRIM(_RIFERIMENTI_RAGGRUPPAMENTO),;
				LNKGRUPPO  WITH _LNKGRUPPO,;
				TIPOLOGIA  WITH _TIPOLOGIA				
	ENDIF				
			
ELSE 

	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
	
		IF EMPTY(SELEZIONE)
			SKIP
			LOOP
		ENDIF
		
		SELECT &pNomeCursor
		
		_ID_UNIQUE = ID_UNIQUE 
		_BANCA_PART_RAGGRUPPAMENTO=BANCA_PART
		_CODFOR_RAGGRUPPAMENTO=CODFOR
		_QUANDOVALU_RAGGRUPPAMENTO=QUANDOVALU
		_QUANTAVALU_RAGGRUPPAMENTO=QUANTAVALU
		_RIFERIMENTI_RAGGRUPPAMENTO="FAT.N."+alltrim(NUMEROFATT)
		
		SELECT CURSORCBI
		APPEND BLANK
	
		REPLACE ID_UNIQUE  WITH _ID_UNIQUE,;
		        QUANTAVALU WITH _QUANTAVALU_RAGGRUPPAMENTO,;
				QUANDOVALU WITH _QUANDOVALU_RAGGRUPPAMENTO,;
				CODFOR	   WITH _CODFOR_RAGGRUPPAMENTO,;
				BANCA_PART WITH _BANCA_PART_RAGGRUPPAMENTO,;
				RIFERIMEN  WITH ALLTRIM(_RIFERIMENTI_RAGGRUPPAMENTO)
				
		SELECT  &pNomeCursor
		SKIP
		
	ENDDO

ENDIF

_ProgrDisp		=0
_TotDisp		=0
_TotImportiNeg	=0
_TotImportiPos	=0
_NumeroRecord	=0

_ABI=""
_CAB=""
_CC ="" 
_CIN=""
_CHKDGT=""

____CONTA_OPERAZIONI=0



SELECT CURSORCBI
GO TOP
DO WHILE !EOF()
		
	_CODICE_BANCA_ORDINANTE=ALLTRIM(BANCA_PART)

	IF !EXECCOMMAND("SELECT * FROM U_CCO_TT WHERE ORD_BANCA='"+_CODICE_BANCA_ORDINANTE+"'","CUR_U_CCO_TT")
		MESSAGEBOX("Non trovata banca ordinante cliente/fornitore "+_CODFOR,48,"Attenzione")
  		SELECT CURSORCBI
  		SKIP
  		LOOP
  	ENDIF	

  	SELECT CUR_U_CCO_TT
  	
	_ABI=ABI
	_CAB=CAB
	_CC =CC 
	_CIN=CIN
	_CHKDGT=CHKDGT
		
	select CURSORCBI
	
	IF TIPOLOGIA ="STIPENDIO"
		_nomeFileCBI	= SUBSTR(ALLTRIM(_nomeFileCBI),1,LEN(ALLTRIM(_nomeFileCBI))-3)+"sti"
	ENDIF
	
	IF ALLTRIM(_abiOrdinante) != ALLTRIM(_ABI)
		
		IF !EMPTY(_abiOrdinante)
			_NumeroRecord	=_NumeroRecord	+1 
			do creaRecordEF
		ENDIF

		_ProgrDisp		=0
		_TotDisp		=0
		_TotImportiNeg	=0
		_TotImportiPos	=0
		_NumeroRecord	=0
		_abiOrdinante	= fillWithInitialZero(_ABI,5)
		_cabOrdinante	= fillWithInitialZero(_CAB,5)
		_ccOrdinante  	= fillWithInitialZero(_CC,12)
		_cinOrdinante	= fillWithInitialZero(_CIN,1)
		_checkDigitOrdinante = fillWithInitialZero(_CHKDGT,2)
		do creaRecordPC
		_NumeroRecord	=_NumeroRecord	+1 
		
	ENDIF


	*** imposta i dati caratteristici della specifica disposizione
	
	*** dati obbligatori
	_Importo		= round(QUANTAVALU,2)*100
	
	if _Importo=0
		skip
		loop
	endif
	
	
	IF TIPOLOGIA !="STIPENDIO"
	
		IF !RICERCA_DATI_BANCARI(CODFOR)		
		  	SELECT CURSORCBI
		  	SKIP
  			LOOP
		ENDIF
		
		SELECT CURSORCBI
		_Riferimenti	= RIFERIMEN 

			
	
	ELSE	
	
		_CODFOR=codfor
		_MATRICOLA = ALLTRIM(MATRICOLA)
	
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
	  		SELECT CURSORCBI
	  		SKIP
	  		LOOP
		ELSE 	  		

		SELECT cpersone

			_for_codabi=ABI 
			_for_codcab=CAB 
			_for_numcoc=CC 
			_for_codcin=CIN 
			_for_chkdgt=CHK_DIGIT
			
			_for_ragsoc=ALLTRIM(COGNOME)+ ' '+ ALLTRIM(NOME)
			_for_pariva=""
			_for_codfis=""	
		  	
			IF EMPTY(_for_codabi)
				MESSAGEBOX("Non trovato ABI dipendente "+_for_ragsoc,48,"Attenzione")
		  		SELECT CURSORCBI
		  		SKIP
		  		LOOP
		  	ENDIF	

			IF EMPTY(_for_codcab)
				MESSAGEBOX("Non trovato CAB dipendente "+_for_ragsoc,48,"Attenzione")
		  		SELECT CURSORCBI
		  		SKIP
		  		LOOP
		  	ENDIF	

			IF EMPTY(_for_numcoc)
				MESSAGEBOX("Non trovato CC dipendente "+_for_ragsoc,48,"Attenzione")
		  		SELECT CURSORCBI
		  		SKIP
		  		LOOP
		  	ENDIF	
		  	  	
			_abiDest		= _for_codabi
			_cabDest		= _for_codcab
			_ccDest 		= _for_numcoc 
			_CINDest		= _for_codcin
			_chkdgtDest     = _for_chkdgt
			_SegmentoDatiDestinatario	= _for_ragsoc 	&& denominazione o ragione sociale destinatario
			_Riferimenti			    = ""
			*** dati facoltativi
			
			_CodiceFiscaleDestinatario=""
			IF !EMPTY(_for_pariva) 
				_CodiceFiscaleDestinatario	=_for_pariva && facoltativo per bonifico 
			ELSE
				IF !EMPTY(_for_codfis)
					_CodiceFiscaleDestinatario	=_for_codfis && facoltativo per bonifico 
				ENDIF
			ENDIF
		

			*** IMPOSTO DATI CARATTERISTICI DEGLI STIPENDI
			_causale		="27000"
			
			IF EMPTY(MESE_STIPENDIO) .OR.  EMPTY(ANNO_STIPENDIO) 
				=MESSAGEBOX("Impossibile creare il file di pagamento degli stipendi perchè non è stato correttamente identificato il mese/anno di riferimento",48,"Attenzione")
		  		SELECT CURSORCBI
		  		SKIP
		  		LOOP
		  	ENDIF	

			_Riferimenti	= "STIPENDI MESE DI "+DESCRIZIONE_MESE(MESE_STIPENDIO)+" "+ANNO_STIPENDIO	
			
		ENDIF	

		SELECT CURSORCBI
	
	ENDIF TIPOLOGIA !="STIPENDIO"
	
	_IndirizzoDest				="" 		&& facoltativo per bonifico
	_ComuneProvinciaDest		="" 		&& facoltativo per bonifico
	_CAPDest					="" 		&& facoltativo per bonifico
	_SecretKey					=""			&& facoltativo per bonifico
	_IdDisposizione 			=""         && obbligatorio solo se il flag richiesta e' diverdo da blank
		
	*** dati riepilogo
	_ProgrDisp		=_ProgrDisp+1
	_TotDisp		=_TotDisp		+1     
	_TotImportiPos	=_TotImportiPos	+_Importo
	
	
	_dataValutaBeneficiario = SUBSTR(QUANDOVALU,9,2)+SUBSTR(QUANDOVALU,6,2)+SUBSTR(QUANDOVALU,3,2)

	____CONTA_OPERAZIONI=____CONTA_OPERAZIONI+1
	
		
	do creaRecord10
	_NumeroRecord	=_NumeroRecord	+1 
	do creaRecord16
	_NumeroRecord	=_NumeroRecord	+1 
	do creaRecord17
	_NumeroRecord	=_NumeroRecord	+1 
	do creaRecord20
	_NumeroRecord	=_NumeroRecord	+1 
	do creaRecord30
	_NumeroRecord	=_NumeroRecord	+1 
	do creaRecord40
	_NumeroRecord	=_NumeroRecord	+1 
	do creaRecord50

	do creaRecord70
	_NumeroRecord	=_NumeroRecord	+1 
	
	
	
	_BANCA_PART =BANCA_PART
	_CODFOR		=CODFOR
	_QUANDOVALU =QUANDOVALU
	
	IF PUB_RAGGRUPPA_PER_DESTINATARIO

		SELECT &pNomeCursor
		GO TOP
		DO WHILE !EOF()
		
			IF DELETED()
				SKIP
				LOOP
			ENDIF
		
			IF EMPTY(SELEZIONE)
				SKIP
				LOOP
			ENDIF

			IF !(BANCA_PART=_BANCA_PART AND CODFOR=_CODFOR)
				SKIP
				LOOP
			ENDIF
			
			_ID_UNIQUE=ALLTRIM(ID_UNIQUE)
			IF !EXECCOMMAND("UPDATE PIANOP_DD SET CREATOCBI='SI' WHERE ID_UNIQUE='"+_ID_UNIQUE+"'","CTEMP")
				MESSAGEBOX("ERRORE NELL'AGGIORNAMENTO DEL PIANO DI PAGAMENTO",48,"Attenzione")
		  	ENDIF	

			
			SELECT &pNomeCursor
			SKIP
		
		ENDDO
		
		IF PUB_RAGGRUPPA_PER_DATA_VALUTA
		
			SELECT &pNomeCursor
			GO TOP
			DO WHILE !EOF()
			
				IF DELETED()
					SKIP
					LOOP
				ENDIF
			
				IF EMPTY(SELEZIONE)
					SKIP
					LOOP
				ENDIF
	
				IF !(BANCA_PART=_BANCA_PART AND CODFOR=_CODFOR AND QUANDOVALU=_QUANDOVALU)
					SKIP
					LOOP
				ENDIF
				
				_ID_UNIQUE=ALLTRIM(ID_UNIQUE)
				IF !EXECCOMMAND("UPDATE PIANOP_DD SET CREATOCBI='SI' WHERE ID_UNIQUE='"+_ID_UNIQUE+"'","CTEMP")
					MESSAGEBOX("ERRORE NELL'AGGIORNAMENTO DEL PIANO DI PAGAMENTO",48,"Attenzione")
			  	ENDIF	
					
				SELECT &pNomeCursor
				SKIP
			
			ENDDO
		
		ENDIF
		
	ELSE
	
		_ID_UNIQUE=ALLTRIM(ID_UNIQUE)

		IF !EXECCOMMAND("UPDATE PIANOP_DD SET CREATOCBI='SI' WHERE ID_UNIQUE='"+_ID_UNIQUE+"'","CTEMP")
			MESSAGEBOX("ERRORE NELL'AGGIORNAMENTO DEL PIANO DI PAGAMENTO",48,"Attenzione")
	  	ENDIF	
	
	ENDIF
	
	select CURSORCBI
	skip
	
enddo


IF ____CONTA_OPERAZIONI>0
	_NumeroRecord	=_NumeroRecord	+1 
	do creaRecordEF
	MESSAGEBOX("Operazione terminata. Creato file "+_nomeFileCBI,64,"Creato file cbi")
	
ENDIF

do releasecbipub

return _nomeFileCBI           
*****************************            

*****************************
procedure crearecordpc
*****************************
local _record

_record = SPACE(1)+"PC"

_record = _record + _codiceSIA
_record = _record + _abiOrdinante

_DATA_CREAZIONE=dtoc(date())
_record = _record + substr(_DATA_CREAZIONE,1,2)+substr(_DATA_CREAZIONE,4,2)+substr(_DATA_CREAZIONE,9,2)
*DataCreazione	n	6	# Data di esecuzione della distinta formato GGMMAA

*NomeSupporto	an	20	# Info di libera composizione da parte dell'Azienda Ordinanteente
_record = _record + substr(_nomeFileCBI,1,20)

_record = _record + space(6)
*CampoLibero		an	6	# Campo a disposizione dell'Azienda Ordinante

_record = _record + space(59)
*Filler1			an	59	# valorizzato blank

_record = _record + cbistringformatter(_TipoFlusso,1)
_record = _record + cbistringformatter(_IdFlusso,1)
_record = _record + cbistringformatter(_SoggVeicolatore,5)
_record = _record + space(2)
_record = _record + cbistringformatter(_CodDivisa,1)
_record = _record + space(1)
_record = _record + cbistringformatter(_CentroApp,5)


storerecord(_record,_nomeFileCBI)
                  
return            
*****************************       

*****************************
procedure crearecordef
*****************************
local _record

_record=SPACE(1)+"EF"
_record = _record + _codiceSIA
_record = _record + _abiOrdinante

_DATA_CREAZIONE=dtoc(date())
_record = _record + substr(_DATA_CREAZIONE,1,2)+substr(_DATA_CREAZIONE,4,2)+substr(_DATA_CREAZIONE,9,2)
*DataCreazione	n	6	# Data di esecuzione della distinta formato GGMMAA

_record = _record + substr(_nomeFileCBI,1,20)

_record = _record + space(6)
*	CampoLibero		an	6	# Campo a disposizione dell'Azienda Ordinanteente

_record = _record + cbinumberformatter(_TotDisp,7)
_record = _record + cbinumberformatter(_TotImportiNeg,15)
_record = _record + cbinumberformatter(_TotImportiPos,15)
_record = _record + cbinumberformatter(_NumeroRecord,7)

_record = _record + space(24)
_record = _record + cbistringformatter(_CodDivisa,1)
_record = _record + cbistringformatter(_DataApplicativa,6)

storerecord(_record,_nomeFileCBI)
return            
*****************************       

*****************************
procedure crearecord10
*****************************
local _record


_record=SPACE(1)+"10"

_record = _record + cbinumberformatter(_ProgrDisp,7)
_record = _record + space(6)

*_DataEsecuzione  n	6   # Data di esecuzione del bonifico formato GGMMAA
_record = _record + fillWithSpace(_dataEsecuzioneBonifico,6)

*_DataValuta      n 6   # Data valuta del beneficiario formato GGMMAA
_record = _record + fillWithSpace(_dataValutaBeneficiario,6)

_record = _record + _Causale
_record = _record + cbinumberformatter(ABS(_Importo),13)
_record = _record + _Segno
_record = _record + _abiOrdinante
_record = _record + _cabOrdinante
_record = _record + fillWithInitialZero(_ccOrdinante,12)
_record = _record + fillWithInitialZero(_abiDest,5)
_record = _record + fillWithInitialZero(_cabDest,5)
_record = _record + fillWithInitialZero(_ccDest,12)
_record = _record + fillWithInitialZero(_codiceSIA,5)

*_TipoCodice		an	1	# Assume un valore preciso condizionato dal campo CodClienteBeneficiario
_record = _record + space(1)

*_CodClienteDest	an	16	# Codice con il quale l'Azienda identifica il cliente beneficiario della disposizione di pagamento
_record = _record + space(16)

_record = _record + _TipoPagamento
_record = _record + space(5)
_record = _record + _CodDivisa

storerecord(_record,_nomeFileCBI)
return            
*****************************       


*****************************
procedure crearecord16
*****************************
local _record

_record=SPACE(1)+"16"

_record = _record + cbinumberformatter(_ProgrDisp,7)

*11-12	o	an	codice paese
*	V	Il codice paese deve essere uguale a IT o SM
_record = _record + "IT"

*13-14	o	n	check digit	V	check digit IBAN
_record = _record + _checkDigitOrdinante

*15-44	o	an	BBAN
*	F	codice BBAN 
*I dati che seguono, fino alla posizione 44, costituiscono le specifiche del BBAN secondo gli standard domestici
*15-	o	an	CIN	F	CIN della coordinata BBAN
*16-20	o	n	codice ABI	V	Codice ABI della banca:
*- deve corrispondere con il codice ABI del ricevente (pos. 9-13) presente sul record di testa;
*21-25	o	n	codice CAB	V	Codice CAB della banca; 
*26-37	o	an	numero conto	F	Conto corrente ;
*38-44	-	-	filler	N	per l'Italia (e R.S.Marino) Blank
_record = _record + _cinOrdinante+_abiOrdinante+_cabOrdinante+_ccOrdinante

*45-120	-	-	filler	N	Blank
_record = _record + SPACE(76)


storerecord(_record,_nomeFileCBI)
return            
*****************************       


*****************************
procedure crearecord17
*****************************
local _record

_record=SPACE(1)+"17"

_record = _record + cbinumberformatter(_ProgrDisp,7)

*11-12	o	an	codice paese
*	V	Il codice paese deve essere uguale a IT o SM
_record = _record + "IT"

*13-14	o	n	check digit	V	check digit IBAN
_record = _record + _chkdgtDest     
*15-44	o	an	BBAN
*	F	codice BBAN 
*I dati che seguono, fino alla posizione 44, costituiscono le specifiche del BBAN secondo gli standard domestici
*15-	o	an	CIN	F	CIN della coordinata BBAN
*16-20	o	n	codice ABI	V	Codice ABI della banca:
*- deve corrispondere con il codice ABI del ricevente (pos. 9-13) presente sul record di testa;
*21-25	o	n	codice CAB	V	Codice CAB della banca; 
*26-37	o	an	numero conto	F	Conto corrente ;
*38-44	-	-	filler	N	per l'Italia (e R.S.Marino) Blank
_record = _record + _CINDest+_abiDest+_cabDest+_ccDest 

*45-120	-	-	filler	N	Blank
_record = _record + SPACE(76)


storerecord(_record,_nomeFileCBI)
return            
*****************************       

*****************************
procedure crearecord20
*****************************
local _record
_record=SPACE(1)+"20"
_record = _record + cbinumberformatter(_ProgrDisp,7)
_record = _record + cbistringformatter(_RagioneSocialeOrdinante,30)
_record = _record + cbistringformatter(_IndirizzoOrdinante,30)
_record = _record + cbistringformatter(_LocalitaOrdinante,30)
_record = _record + cbistringformatter(_CodiceFiscaleOrdinante,16)
_record = _record + space(4)

storerecord(_record,_nomeFileCBI)
return            
*****************************       

*****************************
procedure crearecord30
*****************************
local _record
_record=SPACE(1)+"30"
                  

_record = _record + cbinumberformatter(_ProgrDisp,7)
_record = _record + cbistringformatter(_SegmentoDatiDestinatario,90)
_record = _record + cbistringformatter(_CodiceFiscaleDestinatario,16)
_record = _record + space(4)

storerecord(_record,_nomeFileCBI)
return            
*****************************       

*****************************
procedure crearecord40
*****************************
local _record
_record=SPACE(1)+"40"

_record = _record + cbinumberformatter(_ProgrDisp,7)
_record = _record + cbistringformatter(_IndirizzoDest,30)
_record = _record + cbistringformatter(_CAPDest,5)
_record = _record + cbistringformatter(_ComuneProvinciaDest,25)
_record = _record + space(50)
*Filler1				an	50	# Coordinate della banca del beneficiario
                  
storerecord(_record,_nomeFileCBI)
return            
*****************************      

*****************************
procedure crearecord50
*****************************
local _record

IF LEN(ALLTRIM(_Riferimenti))<=90
	
	_record	= SPACE(1)+"50"
	_record = _record + cbinumberformatter(_ProgrDisp,7)
	_record = _record + cbistringformatter(_Riferimenti,90)
	_record = _record + space(20)
	storerecord(_record,_nomeFileCBI)
	_NumeroRecord	=_NumeroRecord	+1 

ELSE

	DO WHILE .T.
	
		_RiferimentiParziale=ALLTRIM(SUBSTR(_Riferimenti,1,90))
		_Riferimenti=ALLTRIM(SUBSTR(_Riferimenti,91))
		
		_record	= SPACE(1)+"60"
		_record = _record + cbinumberformatter(_ProgrDisp,7)
		_record = _record + cbistringformatter(_RiferimentiParziale,90)
		_record = _record + space(20)
		storerecord(_record,_nomeFileCBI)
		_NumeroRecord	=_NumeroRecord	+1 
		
		IF  EMPTY(_Riferimenti)
			EXIT
		ENDIF
		
	ENDDO

ENDIF

return            
*****************************        

*****************************
procedure crearecord70
*****************************
local _record
_record=SPACE(1)+"70"
_record = _record + cbinumberformatter(_ProgrDisp,7)
_record = _record + space(15)
_record = _record + cbistringformatter(_CodControllo,5)
_record = _record + cbistringformatter(_TipoFlusso,1)
_record = _record + cbistringformatter(_IdFlusso,1)
_record = _record + cbistringformatter(_SoggVeicolatore,5)
_record = _record + cbistringformatter(_CodMP,5)
_record = _record + space(27)
_record = _record + cbistringformatter(_FlagRichiesta,1)
_record = _record + cbistringformatter(_IdDisposizione,30)
_record = _record + space(10)
_record = _record + cbistringformatter(_CINDest,1)
_record = _record + space(1)
_record = _record + cbistringformatter(_SecretKey,8)
                  
storerecord(_record,_nomeFileCBI)
return            
*****************************       


*****************************
function cbinumberformatter
*****************************
parameters numero,numeroCifre

local stringNumero
                 
stringNumero=replicate("0",numerocifre)+alltrim(str(numero))
stringNumero=substr(stringNumero,len(stringNumero)-numeroCifre+1)

return stringNumero           
*****************************       

*****************************
function cbistringformatter
*****************************
parameters stringa,numeroCifre

local stringa1
                 
stringa1=alltrim(stringa)+replicate(space(1),numerocifre)
stringa1=substr(stringa1,1,numeroCifre)

return stringa1           
*****************************       

*****************************
procedure legge_config_cbi
*****************************
parameters _proprieta

DO CASE 

	CASE _proprieta = "CodiceSIA"
		IF !EMPTY(PUB_CODSIA)
			RETURN PUB_CODSIA
		ENDIF
	
	CASE _proprieta = "directoryDestinazione"
		IF !EMPTY(PUB_DIRCBI)
			RETURN PUB_DIRCBI
		ENDIF
	
	CASE _proprieta = "RagioneSocialeOrdinante"
		IF !EMPTY(PUB_RAGSOC)
			RETURN PUB_RAGSOC
		ENDIF
	
	CASE _proprieta = "IndirizzoOrdinante"	
		IF !EMPTY(PUB_INDIRI)
			RETURN PUB_INDIRI
		ENDIF
	
	CASE _proprieta = "LocalitaOrdinante"	
		IF !EMPTY(PUB_LOCALI)
			RETURN PUB_LOCALI
		ENDIF
	
	CASE _proprieta = "CodiceFiscaleOrdinante"	
		IF !EMPTY(PUB_PIVA)
			RETURN PUB_PIVA
		ENDIF
		
		IF !EMPTY(PUB_CODFIS)
			RETURN PUB_CODFIS
		ENDIF
		
	
	CASE _proprieta = "CodicePaese"	
		RETURN "ITA"
	
	CASE _proprieta = "CodDivisa"	
		RETURN "E"

ENDCASE

return legge_config("cbi_conf.cfg",_proprieta)
*****************************



*****************************
procedure legge_config
*****************************
parameters _configfile,_proprieta

LOCAL _valore

_valore=""

IF FILE(_configfile) && Esiste il file? 

	gnConfigFile = FOPEN(_configfile) && Se esiste, lo apre in lettura
	IF gnConfigFile >= 0 && Verifica errore in apertura del file
		&& Se non viene trovato alcun errore legge file
		do while !feof(gnConfigFile)
			riga=FGETS(gnConfigFile)

			if at('=',riga)>0
				chiave=ALLTRIM(substr(riga,1,at("=",riga)-1))
				valore=ALLTRIM(substr(riga,at("=",riga)+1))

				if upper(chiave)=upper(ALLTRIM(_proprieta))
					_valore=valore
				endif
			endif
		enddo
	ENDIF

	=FCLOSE(gnConfigFile) 

ENDIF

return _valore


*****************************
procedure leggidescrittore
*****************************
parameters _configfile,_proprieta

LOCAL _valore[10]

for i=1 to 10
	_valore[i]=""
next


IF FILE(_configfile) && Esiste il file? 

	gnConfigFile = FOPEN(_configfile) && Se esiste, lo apre in lettura
	IF gnConfigFile >= 0 && Verifica errore in apertura del file
		&& Se non viene trovato alcun errore legge file
		do while !feof(gnConfigFile)
			riga=alltrim(FGETS(gnConfigFile))
			
			
			if substr(riga,1,1)='#'
				loop
			endif

			if at('=',riga)>0
				chiave=upper(substr(riga,1,at("=",riga)-1))
				valore=allt(substr(riga,at("=",riga)+1))

				if chiave=_proprieta
					_valore=valore
				endif
			endif
		enddo
	ENDIF

	=FCLOSE(gnConfigFile) 

ENDIF

return _valore

**********************************************************
procedure fillWithSpace(stringa,numeroCaratteri)
**********************************************************
return substr(stringa+space(numeroCaratteri),1,numeroCaratteri)

**********************************************************
procedure fillWithInitialZero(stringa,numeroCaratteri)
**********************************************************
stringona=REPLICATE("0",numeroCaratteri)+ALLTRIM(stringa)
return substr(stringona,LEN(stringona)-numeroCaratteri+1)




**********************************************************
procedure SPLIT_STIPENDI
**********************************************************
PRIVATE _ALIAS


_ALIAS=ALIAS()

SCATTER MEMVAR

DELETE



MESE_STIPENDIO=SUBSTR(M.RAGSOC,LEN("STIP.")+1,2)
ANNO_STIPENDIO=SUBSTR(M.RAGSOC,LEN("STIP.MM/")+1,4)


cSql=""     
cNomeCursorSql="CSTIPENDI"

TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

SELECT * FROM U_GPP_MO WHERE GPP_MESE='<<MESE_STIPENDIO>>' AND GPP_ANNO='<<ANNO_STIPENDIO>>' AND GPP_PAGATO = ''
	
ENDTEXT					&& FINE SCRITTURA QUERY

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF	

SELECT CSTIPENDI
GO TOP 
DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF
	
	
	M.TIPOLOGIA	= "STIPENDIO"
	
	M.ABI = GPP_ABI
	M.CAB = GPP_CAB
	M.CIN = GPP_CIN
	M.CONTOCORR = GPP_CC
	M.QUANTAVALU= GPP_DAPAGA
	M.CODFOR = GPP_MATRI
	M.RAGSOC = GPP_COGNOM
	
	SELECT &_ALIAS
	APPEND BLANK
	GATHER MEMVAR
	
	
	SELECT CSTIPENDI
	SKIP
ENDDO


return 
*** FINE procedure SPLIT_STIPENDI
**********************************************************


**********************************************************
procedure DESCRIZIONE_MESE
**********************************************************
PARAMETERS _MESE_IN_CIFRE

PRIVATE _MESE_IN_LETTERE

_MESE_IN_LETTERE=""

DO CASE
	CASE _MESE_IN_CIFRE='01'
		_MESE_IN_LETTERE='GENNAIO'
	CASE _MESE_IN_CIFRE='02'
		_MESE_IN_LETTERE='FEBBRAIO'
	CASE _MESE_IN_CIFRE='03'
		_MESE_IN_LETTERE='MARZO'
	CASE _MESE_IN_CIFRE='04'
		_MESE_IN_LETTERE='APRILE'
	CASE _MESE_IN_CIFRE='05'
		_MESE_IN_LETTERE='MAGGIO'
	CASE _MESE_IN_CIFRE='06'
		_MESE_IN_LETTERE='GIUGNO'
	CASE _MESE_IN_CIFRE='07'
		_MESE_IN_LETTERE='LUGLIO'
	CASE _MESE_IN_CIFRE='08'
		_MESE_IN_LETTERE='AGOSTO'
	CASE _MESE_IN_CIFRE='09'
		_MESE_IN_LETTERE='SETTEMBRE'
	CASE _MESE_IN_CIFRE='10'
		_MESE_IN_LETTERE='OTTOBRE'
	CASE _MESE_IN_CIFRE='11'
		_MESE_IN_LETTERE='NOVEMBRE'
	CASE _MESE_IN_CIFRE='12'
		_MESE_IN_LETTERE='DICEMBRE'
ENDCASE


RETURN _MESE_IN_LETTERE
*** FINE procedure SPLIT_STIPENDI
**********************************************************






**********************************************************
procedure RICERCA_DATI_BANCARI
**********************************************************
PARAMETERS _P_CODFOR

LOCAL _CODFOR,_CLI_FOR

_CODFOR=""
_CLI_FOR=""

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
	RETURN .F.
ELSE
	CSQL="SELECT * FROM U_FOR_AN WHERE FOR_CODCLI='"+_CODFOR+"'"
ENDIF

IF !EXECCOMMAND(CSQL,"CU_IBAN")
	RETURN(.F.)
ENDIF	

SELECT CU_IBAN
	  	
*!*	M.cli_nazion
*!*	M.cli_codche
*!*	M.cli_codcin
*!*	M.cli_codabi
*!*	M.cli_codcab
*!*	m.cli_numcc
	  	
IF (EMPTY(FOR_BA2ABI) OR EMPTY(FOR_BA2CAB) OR EMPTY(FOR_BA2CC))
  	MESSAGEBOX("Per il fornitore "+ALLTRIM(FOR_RAGSOC)+" non sono complete le informazioni relative alla banca per bonifici" ,48,"Attenzione")
	RETURN .F.
ENDIF
  	
_for_codabi=ALLTRIM(FOR_BA2ABI)
_for_codcab=ALLTRIM(FOR_BA2CAB)
_for_numcoc=ALLTRIM(FOR_BA2CC) 
_for_codcin=ALLTRIM(FOR_BA2CIN)

_for_ragsoc=ALLTRIM(FOR_RAGSOC)
_for_pariva=ALLTRIM(FOR_PARIVA)
_for_codfis=ALLTRIM(FOR_CODFIS)	
_for_ba2chk=ALLTRIM(FOR_BA2CHK)
  	
IF EMPTY(_for_codabi)
	MESSAGEBOX("Non trovato ABI fornitore "+_for_ragsoc,48,"Attenzione")
	RETURN .F.
ENDIF	

IF EMPTY(_for_codcab)
	MESSAGEBOX("Non trovato CAB fornitore "+_for_ragsoc,48,"Attenzione")
	RETURN .F.
ENDIF	

IF EMPTY(_for_numcoc)
	MESSAGEBOX("Non trovato CC fornitore "+_for_ragsoc,48,"Attenzione")
	RETURN .F.
ENDIF	


*** dati facoltativi
_CodiceFiscaleDestinatario=""
IF !EMPTY(_for_pariva) 
	_CodiceFiscaleDestinatario	=_for_pariva && facoltativo per bonifico 
ELSE
	IF !EMPTY(_for_codfis)
		_CodiceFiscaleDestinatario	=_for_codfis && facoltativo per bonifico 
	ENDIF
ENDIF
		
  	  	
SELECT CURSORCBI
  	
_abiDest		= _for_codabi
_cabDest		= _for_codcab
_ccDest 		= _for_numcoc 
_CINDest		= _for_codcin
_chkdgtDest     = _for_ba2chk
_SegmentoDatiDestinatario	= _for_ragsoc 	&& denominazione o ragione sociale destinatario

RETURN .T.






******************************************************
PROCEDURE RIBAFORMATTER
******************************************************

PARA  _CBANCA,_NDISTINTA

_nomeFileCBI=""

IF EMPTY(ALLTRIM(_NDISTINTA))
	MESSAGEBOX("Codice banca non valorizzato.",48,"Attenzione")
	RETURN 	_nomeFileCBI
ENDIF

IF EMPTY(ALLTRIM(_CBANCA))
	MESSAGEBOX("Numero distinta non valorizzato.",48,"Attenzione")
	RETURN	_nomeFileCBI
ENDIF

DO DEFCBIPUB

IF USED("CUR_U_RIC_TT")
  SELECT CUR_U_RIC_TT
  USE
ENDIF


cSql=""     
cNomeCursorSql="CUR_U_RIC_TT"
	
TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
	
	SELECT * FROM U_RIC_TT 
	WHERE RTRIM(RIC_NUMDIS)='<<ALLTRIM(_NDISTINTA)>>' 
		AND RTRIM(RIC_BAPRES)='<<ALLTRIM(_CBANCA)>>' 
		
ENDTEXT					&& FINE SCRITTURA QUERY
	
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF


RELEASE REC,XX_MITT,XX_RICEV,XX_MIFIS,XX_DTCREA,XX_NOMESUP,XX_PROGRE,XX_DESFIS,XX_NUMCC,XX_CPA
RELEASE XX_CODAZI,XX_INDIRI,XX_CAP,XX_COMUNE,XX_NUMCCC,XX_CODFIS
RELEASE I_FIN,V_CAMPO,CONTAREC
RELEASE R01,R02,R03,R04,R05,R06,R07,R08,R09,R10,R11,R12
RELEASE NOMEPROC,VUOTO,TOTIMPO,CONTAGIRO
RELEASE __CONTARIBA__,__VERIFICA_RIBA


PUBLIC REC,XX_MITT,XX_RICEV,XX_MIFIS,XX_DTCREA,XX_NOMESUP,XX_PROGRE,XX_DESFIS,XX_NUMCC,XX_CPA
PUBLIC XX_CODAZI,XX_INDIRI,XX_CAP,XX_COMUNE,XX_NUMCCC,XX_CODFIS
PUBLIC I_FIN,V_CAMPO,CONTAREC
PUBLIC R01,R02,R03,R04,R05,R06,R07,R08,R09,R10,R11,R12
PUBLIC NOMEPROC,VUOTO,TOTIMPO,CONTAGIRO
PUBLIC __CONTARIBA__,__VERIFICA_RIBA


REC        = _CBANCA

_codiceSIA	                = legge_config_cbi("CodiceSIA")
_abiOrdinante	            = legge_config_cbi("ABIOrdinante")
_cabOrdinante	            = legge_config_cbi("CABOrdinante")
_ccOrdinante  	            = legge_config_cbi("CCOrdinante")
_cinOrdinante				= legge_config_cbi("CINOrdinante")
_checkDigitOrdinante		= legge_config_cbi("CINOrdinante")
_RagioneSocialeOrdinante    = legge_config_cbi("RagioneSocialeOrdinante")
_IndirizzoOrdinante			= legge_config_cbi("IndirizzoOrdinante")
_LocalitaOrdinante			= legge_config_cbi("LocalitaOrdinante")
_CodiceFiscaleOrdinante     = legge_config_cbi("CodiceFiscaleOrdinante")
_IdFlusso                   = legge_config_cbi("IdFlusso") 					&& "$"
_CodDivisa                  = legge_config_cbi("CodDivisa")
_CodicePaese                = legge_config_cbi("CodicePaese")
_SoggVeicolatore            = legge_config_cbi("SoggVeicolatore")
_CodMP		                = legge_config_cbi("CodMP")
_CodControllo	            = legge_config_cbi("CodControllo") 				&& Codice di controllo scambiato tra centri applicativi
_TipoFlusso	 	            = legge_config_cbi("TipoFlusso")
_CentroApp                  = legge_config_cbi("CentroApp")
_DataApplicativa            = legge_config_cbi("DataApplicativa")
_directoryDestinazione      = legge_config_cbi("directoryDestinazione")

_ORA_CREAZIONE=TIME(SECONDS())
_DATA_CREAZIONE=DTOC(DATE())

*** FORMATO NOME FILE: CODICE SIA (5 CHAR) + ULTIMA CIFRA ANNO (1 CHAR) + MMGGHHMMSS.RIB
_nomeFileCBI=_codiceSIA+substr(_DATA_CREAZIONE,10)+substr(_DATA_CREAZIONE,4,2)+substr(_DATA_CREAZIONE,1,2)+substr(_ORA_CREAZIONE,1,2)+substr(_ORA_CREAZIONE,4,2)+substr(_ORA_CREAZIONE,7,2)+".RIB"


XX_MIFIS   = _SoggVeicolatore            
XX_DESFIS  = _CentroApp                  
XX_NOMESUP = _nomeFileCBI
XX_CODAZI  = _codiceSIA


IF !EXECCOMMAND("SELECT * FROM U_CCO_TT WHERE ORD_BANCA='"+_CBANCA+"'","CUR_U_CCO_TT")
	RETURN
ENDIF	

SELECT CUR_U_CCO_TT
GO TOP

IF EOF()
	MESSAGEBOX("Non trovata banca ordinante "+_CBANCA,48,"Attenzione")
	RETURN
ENDIF  	

SELECT CUR_U_CCO_TT
		
_abiOrdinante	= fillWithSpace(ABI,5)
_cabOrdinante	= fillWithSpace(CAB,5)
_ccOrdinante  	= fillWithSpace(CC,12)
_cinOrdinante	= fillWithSpace(CIN,1)
_checkDigitOrdinante = fillWithSpace(CHKDGT,2)

XX_CODABI  = _abiOrdinante
XX_MITT    = _codiceSIA
XX_NUMCC   = _ccOrdinante  
XX_INDIRI  = SPACE(30)
XX_CAP     = SPACE(05)
XX_COMUNE  = SPACE(30)
XX_NUMCCC  = SPACE(12)
XX_CODFIS  = SPACE(16)


IF EMPTY(XX_MITT) .OR. EMPTY(XX_CODABI) .OR. EMPTY(XX_NOMESUP) .OR. EMPTY(XX_CODAZI)
   =MESSAGEBOX("PARAMETRI RIBA MANCANTI "+CHR(13)+"IMPOSSIBILE CONTINUARE",62,"ATTENZIONE")
   RETURN
ENDIF

CREATE CURSOR RID (CAMPO C(120))

SETDATA = SET("CENTURY")
SET CENTURY OFF


VUOTO      = .T.
TOTIMPO    = 0
CONTAREC   = 0
CONTAGIRO  = 0
XX_PROGRE  = 0  && SERGIO 2008-02-05
__CONTARIBA__  = 0
__VERIFICA_RIBA   = 0


SELECT CUR_U_RIC_TT
GO TOP

DO WHILE !EOF()

   IF RIC_TRASF
      SKIP + 1
      LOOP
   ENDIF

   SCATTER MEMVAR
  
   __CONTARIBA__ = __CONTARIBA__ + 1
   TOTIMPO = TOTIMPO + RIC_TRANC

   _DATA_CREAZIONE= DTOC(DATE())
  
   XX_DTCREA  = SUBSTR(_DATA_CREAZIONE,1,2)+SUBSTR(_DATA_CREAZIONE,4,2)+SUBSTR(_DATA_CREAZIONE,7,2)
   XX_PROGRE   = XX_PROGRE + 1  && SERGIO 2008-02-05 
   XX_DTSCAD  = SUBSTR(RIC_DTSCAD,9,2)+SUBSTR(RIC_DTSCAD,6,2)+SUBSTR(RIC_DTSCAD,3,2)
   XX_IMPO    = RIC_TRANC
   XX_BANCAP  = RIC_BAPRES
   XX_BANCAC  = RIC_BACLI
   XX_CODCLI  = RIC_CODCLI
   XX_DATSCA  = RIBALTA2(RIC_DTSCAD)
   XX_RICEV   = CHKBAN(M.RIC_BAPRES)
  
   IF XX_RICEV = "NO"
      __CONTARIBA__ = __CONTARIBA__ - 1
      TOTIMPO = TOTIMPO - RIC_TRANC
      SELECT CUR_U_RIC_TT
      SKIP + 1
      LOOP
   ENDIF
 
   DO DATICLI WITH XX_CODCLI
  
   IF EMPTY(XX_INDIRI) .OR. EMPTY(XX_CAP) .OR. EMPTY(XX_COMUNE) 
      =MESSAGEBOX("DATI ANAGRAFICI CLIENTE NON COMPLETI "+CHR(13)+;
                  "CLIENTE   : "+M.RIC_CODCLI+CHR(13)+;
                  "FATTURA   : "+ALLTRIM(M.RIC_NFATT)+CHR(13)+;
                  "INDIRIZZO : "+XX_INDIRI+CHR(13)+;
                  "CAP       : "+XX_CAP+CHR(13)+;
                  "COMUNE    : "+XX_COMUNE+CHR(13)+;
                  "N.CONTO C.: "+XX_NUMCCC+CHR(13)+;
                  "NON ELABORO LA RIBA",62,"ATTENZIONE")
      SELECT CUR_U_RIC_TT
      SKIP + 1
      LOOP             
   ENDIF
    
   IF VUOTO 
      DO PRIMOREC
      CONTAGIRO = CONTAGIRO + 1
   ENDIF
   
   FOR II = 1 TO 7
       CONTAREC = CONTAREC + 1  
       NOMEPROC = "RECORD"+STR(II,1,0)
       DO &NOMEPROC  
   NEXT
  
   VUOTO = .F.
  
   __VERIFICA_RIBA   = __VERIFICA_RIBA + 1

   SELECT CUR_U_RIC_TT
   REPLACE RIC_TRASF WITH .T.
   
   SKIP +1

ENDDO


CONTAREC = CONTAREC + 2

IF CONTAGIRO > 0
   DO LASTREC
ENDIF  

SET CENTURY &SETDATA
SET CENTURY ON

IF __VERIFICA_RIBA = 0
	RELEASE __CONTARIBA__,__VERIFICA_RIBA
	_nomeFileCBI=""
	
	RETURN _nomeFileCBI
ENDIF

_directoryDestinazione =ALLTRIM(_directoryDestinazione)
_nomeFileCBI=ALLTRIM(_nomeFileCBI)

_TXTRID="'"+_directoryDestinazione + _nomeFileCBI+"'"
* -->> copia file riba x remot
SELECT RID
GO TOP
COPY TO &_TXTRID SDF
SET DEFA TO &PUB_DIR


IF !FILE(SYS(5)+SYS(2003)+"\"+ALLTRIM(_directoryDestinazione + _nomeFileCBI) )
	_nomeFileCBI=""
ENDIF



RELEASE __CONTARIBA__,__VERIFICA_RIBA

RETURN _nomeFileCBI

****************************
PROCEDURE DATICLI
****************************
PARA CLIENTE

x_soci = "CLI_CODSOC = '" + PUB_CODSOC + "'"
x_cont = "CLI_CODCLI = '" + ALLTRIM(CLIENTE) + "'"
x_cond = x_soci +  " and " + x_cont
Csql   = "select * from U_CLI_AN where " + x_cond + " order by CLI_CODCLI"
IF !ExecCommand(cSql,"CU_CLI_AN")
   return(.f.)
ENDIF
SELECT CU_CLI_AN
IF !EOF()
   XX_CPA    = CLI_CONPAG
   XX_INDIRI = CLI_INDIR
   XX_CAP    = CLI_CAP
   XX_COMUNE = CLI_LOCALI
   XX_NUMCCC = CLI_NUMCC
*!*	   XX_CODFIS = CLI_CODFIS
*!*	   IF EMPTY(XX_CODFIS) 
*!*	      XX_CODFIS = CLI_PARIVA
*!*	   ENDIF
   **=> ERASMO - INIZIO 02/03/2022
   XX_CODFIS = CLI_PARIVA
   IF EMPTY(XX_CODFIS) 
      XX_CODFIS = CLI_CODFIS
   ENDIF
   **=> ERASMO - FINE 02/03/2022   
ELSE
   XX_CPA    = SPACE(03)
   XX_INDIRI  = SPACE(30)
   XX_CAP     = SPACE(05)
   XX_COMUNE  = SPACE(30)
   XX_NUMCCC  = SPACE(12)
   XX_CODFIS  = SPACE(16)
ENDIF
*** END COUGAR
RETURN

****************************
PROCEDURE PRIMOREC
****************************
** RECORD DI TESTA DI TUTTI I MOVIMENTI

FILLER     = SPACE(1)
FILLER2    = SPACE(65)
VUOTO1     = SPACE(11)
VUOTO_6    = SPACE(06)
*TIPREC     = "IB"  && (MOD.RINO)
TIPREC     = "IB"   && (MOD.RINO)

I_FIN    = 5
V_CAMPO  = XX_MIFIS 
DO ZERISIX
XX_MIFIS = V_CAMPO

I_FIN    = 5
V_CAMPO  = XX_DESFIS 
DO ZERISIX
XX_DESFIS = V_CAMPO

I_FIN   = 5
V_CAMPO = XX_MITT  
DO ZERISIX
XX_MITT = V_CAMPO

I_FIN   = 5
V_CAMPO = XX_RICEV  
DO ZERISIX
XX_RICEV = V_CAMPO
 
RIGA = FILLER+TIPREC+XX_MITT+XX_CODABI+XX_DTCREA+XX_NOMESUP+VUOTO1+XX_MIFIS+XX_DESFIS+FILLER2

SELECT RID
APPEND BLANK
REPLACE CAMPO WITH substr(RIGA,1,113)+'E'+substr(RIGA,115)
  
RETURN

****************************
PROCEDURE RECORD1
****************************

  FILLER   = SPACE(1)
  TIPREC   = "14"
  PROGRE   = STR(XX_PROGRE,7,0)
  CAU      = "30000"
  IMPORTO  = STR((XX_IMPO*100),13,0)
  SEGNO    = "-"
  TIPCOD   = "4"
  FILLER3  = SPACE(6)
  f1       = SPACE(12)

  Csql   ="select * from U_BAN_AN where BAN_CODSOC = '"+PUB_CODSOC+"' and BAN_CODBAN = '"+ALLTRIM(XX_BANCAP)+"'"
  IF !ExecCommand(cSql,"RECORD1_BAN")
	return(.f.)
  ENDIF
  
  SELECT RECORD1_BAN
  GO TOP 
  IF !EOF()
     BANCABIP = BAN_CODABI
     SPORTP   = BAN_CODCAB
  ELSE
     BANCABIP = XX_BANCAP
     SPORTP   = SPACE(05)
  ENDIF    

  Csql   ="select * from U_BAN_AN where BAN_CODSOC = '"+PUB_CODSOC+"' and BAN_CODBAN = '"+ALLTRIM(XX_BANCAC)+"'"
  IF !ExecCommand(cSql,"RECORD1_BAN")
	return(.f.)
  ENDIF
  
  SELECT RECORD1_BAN
  GO TOP 
     
  IF !EOF()
     BANCABIC = BAN_CODABI
     SPORTC   = BAN_CODCAB
  ELSE
     BANCABIC = XX_BANCAC
     SPORTC   = SPACE(05)
  ENDIF    

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO

  I_FIN   = 13
  V_CAMPO = IMPORTO  
  DO ZERISIX
  IMPORTO  = V_CAMPO

  I_FIN   = 5
  V_CAMPO = BANCABIP  
  DO ZERISIX
  BANCABIP= V_CAMPO
 
  I_FIN   = 5
  V_CAMPO = SPORTP  
  DO ZERISIX
  SPORTP  = V_CAMPO

  I_FIN   = 5
  V_CAMPO = BANCABIC  
  DO ZERISIX
  BANCABIC= V_CAMPO

  I_FIN   = 5
  V_CAMPO = SPORTC  
  DO ZERISIX
  SPORTC  = V_CAMPO

  I_FIN   = 16
  V_CAMPO = XX_CODCLI  
  DO ZERISIX
  YY_CODCLI= V_CAMPO

    
  RIGA = FILLER+TIPREC+PROGRE+SPACE(12)+XX_DTSCAD+CAU+IMPORTO+SEGNO+;
         XX_CODABI+SPORTP+XX_NUMCC+BANCABIC+SPORTC+XX_NUMCCC+XX_CODAZI+;
         TIPCOD+YY_CODCLI+FILLER3   
     
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH SUBSTR(RIGA,1,119)+"E"    
   

RETURN

****************************
PROCEDURE RECORD2
****************************

  FILLER   = SPACE(1)
  TIPREC   = "20"
  PROGRE   = STR(XX_PROGRE,7,0)
  SEG1     = ALLTRIM(_RagioneSocialeOrdinante )
  IF LEN(SEG1) < 24
    SEG1 = SEG1+SPACE(24-LEN(SEG1))
  ENDIF
  IF LEN(SEG1) > 24
    SEG1 = SUBSTR(SEG1,1,24)
  ENDIF
  
  SEG2     = ALLTRIM(_IndirizzoOrdinante)
  IF LEN(SEG2) < 24
    SEG2 = SEG2+SPACE(24-LEN(SEG2))
  ENDIF
  IF LEN(SEG2) > 24
    SEG2 = SUBSTR(SEG2,1,24)
  ENDIF
 
  SEG3     = ALLTRIM(_LocalitaOrdinante)
  IF LEN(SEG3) < 24
    SEG3 = SEG3+SPACE(24-LEN(SEG3))
  ENDIF
  IF LEN(SEG3) > 24
    SEG3 = SUBSTR(SEG3,1,24)
  ENDIF
 
   
  SEG4     = SPACE(24)
  FILLER2  = SPACE(14)

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO
  
  RIGA = FILLER+TIPREC+PROGRE+SEG1+SEG2+SEG3+SEG4+FILLER2
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH RIGA

RETURN
 

****************************
PROCEDURE RECORD3
****************************

  FILLER   = SPACE(1)
  TIPREC   = "30"
  PROGRE   = STR(XX_PROGRE,7,0)
  SEG1     = SUBSTR(M.RIC_RAGSOC,1,30)
  SEG2     = SUBSTR(M.RIC_RAGSOC,31,10) + SPACE(20)
  CODFISD  = SPACE(16)
  FILLER2  = SPACE(34)

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO
  
  RIGA = FILLER+TIPREC+PROGRE+SEG1+SEG2+XX_CODFIS+FILLER2
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH RIGA

RETURN

****************************
PROCEDURE RECORD4
****************************

  FILLER   = SPACE(1)
  TIPREC   = "40"
  PROGRE   = STR(XX_PROGRE,7,0)
  FILLER2  = SPACE(20)

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO
  
  RIGA = FILLER+TIPREC+PROGRE+SUBSTR(XX_INDIRI,1,30)+PADL(ALLTRIM(XX_CAP),5,"0")+SUBSTR(XX_COMUNE,1,25)+FILLER2
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH RIGA

RETURN

****************************
PROCEDURE RECORD5
****************************


  R01	= ""
  R02	= ""
  R03	= ""
  R04	= ""
  R05	= ""
  R06	= ""
  R07	= ""
  R08	= ""
  R09	= ""
  R10	= ""
  R11	= ""
  R12	= ""


  _SEG1    = CHKDET(M.TAGGANCIO)	&& AGGANCIA I DETTAGLI

  XIMPORTO  = STR((XX_IMPO*100),13,0)
  IF _SEG1 = "NO"						&& DETTAGLI NON TR0VATI
	  SEG1     = "FATT N. "+M.RIC_NFATT+" DEL "+RIBALTA2(M.RIC_DTFATT) +"  DI IMPORTO: " + SUBSTR(XIMPORTO,1,11) + "," + SUBSTR(XIMPORTO,12,2) + " SCAD. " + XX_DATSCA
	  _R01 = CREA50_60(SEG1,"","50",.T.)
  ENDIF

  IF LEN(ALLTRIM(R01+R02+R03+R04+R05+R06)) < 81

	  _R01 = CREA50_60(R01,R02,"50",.F.)

  ELSE
	  _R01 = CREA50_60(R01,R02,"50",.F.)
	  _R01 = CREA50_60(R03,R04,"50",.F.)
	  IF !EMPTY(R03)
	  	  CONTAREC=CONTAREC+1
	  ENDIF
      _R01 = CREA50_60(R05,R06,"50",.F.)
	  IF !EMPTY(R05)
	  	  CONTAREC=CONTAREC+1
	  ENDIF
  ENDIF



RETURN


****************************
PROCEDURE RECORD6
****************************

	*** FABIANO 11/05/2015 - AGGIUNGO LA DATA DI CREAZIONE MA NON E' DA STANDARD!!!
	LOCAL V_DATA_CREAZIONE_PER_RECORD_51
	*DATA VALUTA DI ADDEBITO: POS.92-97 formato GGMMAA
	
	V_DATA_CREAZIONE_PER_RECORD_51=DTOC(DATE())
	V_DATA_CREAZIONE_PER_RECORD_51=SUBSTR(V_DATA_CREAZIONE_PER_RECORD_51,1,2)+SUBSTR(V_DATA_CREAZIONE_PER_RECORD_51,4,2)+SUBSTR(V_DATA_CREAZIONE_PER_RECORD_51,7,2)
	*** FABIANO 11/05/2015 - AGGIUNGO LA DATA DI CREAZIONE MA NON E' DA STANDARD!!!

	FILLER   = SPACE(1)
	TIPREC   = "51"
	  
	PROGRE   = STR(XX_PROGRE,7,0)
	PROGRE   = PADL(ALLTRIM(PROGRE) ,7,"0")		&& 7 BYTE

	*NUMDISP  = M.RIC_NUMDIS
	NUMDISP  = M.RIC_NFATT
	***  FABIANO 11/05/2015 - RIDUCO IL NUMDISP  A 4 BYTE PER AGGIUNGERE LA DATA DI CREAZIONE MA NON E' DA STANDARD!!!
	*!*		NUMDISP  = PADL(ALLTRIM(NUMDISP  ) ,10,"0")	&& 10 BYTE
	NUMDISP  = PADL(ALLTRIM(NUMDISP  ) ,4,"0")	&& 10 BYTE

	FIRMEMI  = PADR(ALLTRIM(PUB_DESSOC),20,SPACE(1)) && 20 BYTE
	  
	RIGA = FILLER			&& 1
	RIGA = RIGA +TIPREC	&& 2-3
	RIGA = RIGA +PROGRE	&& 4-10
	RIGA = RIGA + V_DATA_CREAZIONE_PER_RECORD_51 + NUMDISP && 11-20
*!*		RIGA = RIGA +  NUMDISP && 11-20
	RIGA = RIGA +FIRMEMI	&& 21-40
	RIGA = PADR(RIGA ,120,SPACE(1)) && FILLER BLANK FINO ALLA POS 120 COMPRESA

	  
	SELECT RID
	APPEND BLANK
	REPLACE CAMPO WITH RIGA

RETURN



****************************
PROCEDURE RECORD7
****************************

  FILLER   = SPACE(1)
  TIPREC   = "70"
  PROGRE   = STR(XX_PROGRE,7,0)
  FILLER2  = SPACE(90)
  TIPDOC   = SPACE(01)
  RICESI   = SPACE(01)
  FILLER3  = SPACE(18)

  I_FIN   = 7
  V_CAMPO = PROGRE  
  DO ZERISIX
  PROGRE  = V_CAMPO
  
  RIGA = FILLER+TIPREC+PROGRE+FILLER2+TIPDOC+RICESI+FILLER3
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH RIGA

RETURN

****************************
PROCEDURE LASTREC
****************************

  FILLER     = SPACE(1)
  TIPREC     = "EF"
  NUMDISP    = STR(__CONTARIBA__,7,0)  
  TOTIMP     = STR((TOTIMPO*100),15,0)
  VUOTO0     = '000000000000000'
  CONTAREC   = STR(CONTAREC,7,0)
  MIFIS      = XX_MIFIS
  VUOTO1     = SPACE(11)
  VUOTO2     = SPACE(6)
  _DATA_CREAZIONE       = DTOC(DATE())
  GIORNATA   = SUBSTR(_DATA_CREAZIONE,1,2)+SUBSTR(_DATA_CREAZIONE,4,2)+SUBSTR(_DATA_CREAZIONE,7,2)
  FILLER2    = SPACE(15)

  I_FIN   = 7
  V_CAMPO = NUMDISP  
  DO ZERISIX
  NUMDISP = V_CAMPO

  I_FIN   = 15
  V_CAMPO = TOTIMP  
  DO ZERISIX
  TOTIMP  = V_CAMPO

  I_FIN   = 7
  V_CAMPO = CONTAREC  
  DO ZERISIX
  CONTAREC = V_CAMPO

  RIGA = FILLER+TIPREC+XX_MITT+XX_CODABI+XX_DTCREA+XX_NOMESUP+VUOTO2+;
         NUMDISP+TOTIMP+VUOTO0+CONTAREC+SPACE(24)
  
  SELECT RID
  APPEND BLANK
  REPLACE CAMPO WITH SUBSTR(RIGA,1,113)+"E"
  
RETURN


****************************
PROCEDURE ZERISIX
****************************
** RIEMPIMENTO CON ZERI NON SIGNIFICATIVI A SINISTRA DEL NUMERO

V_CAMPO = ALLTRIM(V_CAMPO)
V_LEN   = LEN(V_CAMPO)
V_ZERI  = I_FIN - V_LEN

IF V_LEN < I_FIN
   V_CAMPO = REPLICATE("0",V_ZERI) +  V_CAMPO
ENDIF

RETURN



****************************
PROCEDURE CHKBAN
****************************
PARA _BANCA

Csql   ="select * from U_BAN_AN where BAN_CODSOC = '"+PUB_CODSOC+"' and BAN_CODBAN = '"+ALLTRIM(_BANCA)+"'"
IF !ExecCommand(cSql,"CUR_CHKBAN")
	return(.f.)
ENDIF
  
SELECT CUR_CHKBAN
GO TOP 
IF !EOF()
   OUT = BAN_CODABI
ELSE
   =MESSAGEBOX("NON TROVATO CODICE ABI DELLA BANCA:" +_BANCA+CHR(13)+;
               "DEL CLIENTE : "+M.RIC_CODCLI+CHR(13)+;
               "DELL'EFFETTO NUMERO : "+ALLTRIM(M.RIC_NFATT)+CHR(13)+;
               "IN SCADENZA AL : "+RIBALTA2(M.RIC_DTSCAD)+CHR(13)+;
               "IMPOSSIBILE TRATTARE LA RIBA",48,"ATTENZIONE")
   OUT = "NO"
ENDIF
  
RETURN(OUT)


****************************
PROCEDURE CHKDET
****************************
PARA _TAGGA

******** NON PIU' ATTIVA SERGIO


SELE=SELECT()

OUT=""

_CONTA = 0
  

x_tagg = "DAGGANCIO = '" + ALLTRIM(_TAGGA)+ "'"
x_cond = x_tagg 
Csql   = "select * from U_RIC_DD where " + x_cond + " order by daggancio"
IF !ExecCommand(cSql,"K_RIC_DD")
   return(.f.)
ENDIF

SELECT K_RIC_DD
GO top

IF !EOF()

   DO WHILE .NOT. EOF()

      IF DELETED()
         SELECT K_RIC_DD
         SKIP +1
         LOOP
      ENDIF

      IF ALLTRIM(_TAGGA) <> ALLTRIM(DAGGANCIO)
         EXIT
      ENDIF
      
      _CONTA = _CONTA +1

      IF _CONTA = 1 .OR. _CONTA = 2 
         R01 = R01+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA = 3 .OR. _CONTA = 4 
	     R02 = R02+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA = 5 .OR. _CONTA = 6 
	     R03 = R03+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA = 7 .OR. _CONTA = 8 
	     R04 = R04+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA = 8 .OR. _CONTA = 10 
	     R05 = R05+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA = 11 .OR. _CONTA = 12 
	     R06 = R06+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      IF _CONTA > 12 
	     R06 = R06+" F.N."+ALLTRIM(RIC_FATAGE)+"-"+RIBALTA2(RIC_DATFAT)
	  ENDIF	

      SELECT K_RIC_DD
      SKIP +1

   ENDDO

ELSE
   OUT = "NO"
ENDIF

SELECT(SELE)
  
RETURN(OUT)


****************************
PROCEDURE CREA50_60
****************************
PARA _DATI1,_DATI2,_TR,_SOLO_PRIMA_PARTE

OUT = ""

IF EMPTY(_DATI1)       && NON SCRIVE NIENTE
   RETURN(OUT)
ENDIF

SELE=SELECT()

FILLER   = SPACE(1)
PROGRE   = STR(XX_PROGRE,7,0)
TIPREC   = _TR
SEG1     = SPACE(45)
SEG2     = SPACE(45)


IF _SOLO_PRIMA_PARTE

    SEG1     = SUBSTR(_DATI1,1,90)

ELSE
    
    SEG1     = ALLTRIM(_DATI1)
	IF LEN(SEG1) < 40 
	   SEG1 = SEG1 + SPACE(45 - LEN(SEG1))
	ENDIF

	IF LEN(SEG1) > 40 
	   SEG1 = SUBSTR(SEG1,1,45)
	ENDIF

	SEG2     = ALLTRIM(_DATI2)

	IF LEN(SEG2) < 40 
	   SEG2 = SEG2 + SPACE(45 - LEN(SEG2))
	ENDIF

	IF LEN(SEG2) > 40 
	   SEG2 = SUBSTR(SEG2,1,45)
	ENDIF

ENDIF

FILLER2  = SPACE(30)

I_FIN   = 7
V_CAMPO = PROGRE  
DO ZERISIX
PROGRE  = V_CAMPO
  
RIGA = FILLER+TIPREC+PROGRE+SEG1+SEG2+FILLER2
RIGA = SUBSTR(RIGA,1,100)+SUBSTR(_CodiceFiscaleOrdinante,1,11)+SUBSTR(RIGA,112,9)	&& FORZATURA SERGIO 2008-02-05 : SUL RECORD 50 DALLA 101 VUOLE LA PARTITA IVA

  
SELECT RID
APPEND BLANK
REPLACE CAMPO WITH RIGA

SELECT(SELE)
  
RETURN(OUT)


