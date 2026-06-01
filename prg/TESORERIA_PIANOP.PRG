*************************************
PROCEDURE TESORERIA_PIANOP
**************************************
set procedure to prg\cbimaker additive

RELEASE PUB_DTPIAP,PUB_RAGGRUPPA_PER_DESTINATARIO,PUB_RAGGRUPPA_PER_DATA_VALUTA
PUBLIC  PUB_DTPIAP,PUB_RAGGRUPPA_PER_DESTINATARIO,PUB_RAGGRUPPA_PER_DATA_VALUTA

PUB_DTPIAP						=""
PUB_RAGGRUPPA_PER_DESTINATARIO	=.T.
PUB_RAGGRUPPA_PER_DATA_VALUTA 	=.T.

** CREO CURSORE PER TESTATA **
CREATE CURSOR C_PIANOP_TT (;
	TAGGANCIO C(10),;
	SELEZIONE C(3),;
	PPA_NUMPPA C(6),;
	PPA_DTPIAP C(10),;
	PPA_DAPAGA N(20,3),;
	PPA_PAGATO N(20,3),;
	PAGATO C(2),;
	SALDO N(20,3))
	
INDEX ON VAL(PPA_NUMPPA) TAG NUMPPA ADDITIVE    
INDEX ON VAL(PPA_NUMPPA) TAG DESCNUMPPA  DESCENDING ADDITIVE  

DO RICARICA_TESTATE_PIANOP

IF USED("CUR_PIANOP_DD")
  SELECT CUR_PIANOP_DD
  USE
ENDIF

cNomeCursorSql="X"+SUBSTR(SYS(2015),2)
IF !EXECCOMMAND("SELECT * FROM PIANOP_DD WHERE 1=0",cNomeCursorSql)
	RETURN (.F.)
ENDIF	


SELECT &cNomeCursorSql
=AFIELDS(ARRAY_FIELDS_PIANOP_DD)
CREATE CURSOR CUR_PIANOP_DD FROM ARRAY ARRAY_FIELDS_PIANOP_DD
SELECT &cNomeCursorSql
USE

SELECT CUR_PIANOP_DD
=MODTBL(ALIAS(SELECT()),"DTSCADOLD",  "C(10)",.F.,.T.)


INDEX ON RAGSOC+DTSCAD TAG RAGSOC
SET ORDER TO RAGSOC

GO TOP

DO FORM FORM\PIANOP_TT LINKED

RELEASE PUB_DTPIAP,PUB_RAGGRUPPA_PER_DESTINATARIO,PUB_RAGGRUPPA_PER_DATA_VALUTA

RETURN 
* FINE TESORERIA_PIANOP
******************************************************

******************************************************
FUNCTION AGGIUNGI_PIANO_CARICATO
******************************************************
PARAMETERS PNUMPIANO

LOCAL _NOWSEL

IF PCOUNT()=0
	RETURN
ENDIF

_NOWSEL=STR(SELECT())

SELECT CPIANI_CARICATI
SET ORDER TO PPA_NUMPPA
SEEK ALLTRIM(PNUMPIANO)
IF !FOUND()
	APPEND BLANK
	REPLACE PPA_NUMPPA WITH PNUMPIANO
	SELECT &_NOWSEL
	RETURN(.T.)
ENDIF

=MESSAGEBOX("Si sta cercando di caricare un piano di pagamento già caricato in precedenza."+CHR(13)+"L'operazine non è consentita.",48,"Attenzione! Operazione non consentita")

SELECT &_NOWSEL
RETURN(.F.)
* FINE PROCEDURE AGGIUNGI_PIANO_CARICATO
******************************************************

******************************************************
PROCEDURE RIMUOVI_PIANO_CARICATO
******************************************************
PARAMETERS PNUMPIANO

LOCAL _NOWSEL

IF PCOUNT()=0
	RETURN
ENDIF

_NOWSEL=STR(SELECT())

SELECT CPIANI_CARICATI
SET ORDER TO PPA_NUMPPA
SEEK ALLTRIM(PNUMPIANO)
IF FOUND()
	DELETE
	SELECT &_NOWSEL
	RETURN(.T.)
ENDIF

SELECT &_NOWSEL
RETURN(.F.)
* FINE PROCEDURE RIMUOVI_PIANO_CARICATO
******************************************************

******************************************************
PROCEDURE PULISCI_CURSORI_PIANI_PAGAMENTO
******************************************************
_SELECT_PRECEDENTE_PULISCI_CURSORI_PIANI_PAGAMENTO=STR(SELECT())

IF !EXECCOMMAND("SELECT * FROM PIANOP_TT WHERE 1=0","PIANOP_TT")
   RETURN(.F.)
ENDIF

IF !EXECCOMMAND("SELECT * FROM PIANOP_DD WHERE 1=0","CUR_PIANOP_DD")
   RETURN(.F.)
ENDIF

SELECT &_SELECT_PRECEDENTE_PULISCI_CURSORI_PIANI_PAGAMENTO

RETURN
* FINE PROCEDURE PULISCI_CURSORI_PIANI_PAGAMENTO
******************************************************

******************************************************
PROCEDURE CANCELLA_PIANO
******************************************************
PARAMETERS _NUM_PIANO

IF !EXECCOMMAND("SELECT * FROM PIANOP_TT WHERE PPA_NUMPPA='"+ALLTRIM(_NUM_PIANO)+"' ","PIANOP_TT")
   RETURN(.F.)
ENDIF
SELECT PIANOP_TT
GO TOP

IF EOF()
	RETURN
ENDIF

_AGGANCIO=TAGGANCIO

IF !EXECCOMMAND("DELETE FROM PIANOP_DD WHERE DAGGANCIO='"+ALLTRIM(_AGGANCIO)+"' ","PIANOP_TT")
   RETURN(.F.)
ENDIF

IF !EXECCOMMAND("DELETE FROM PIANOP_SA WHERE DAGGANCIO='"+ALLTRIM(_AGGANCIO)+"' ","PIANOP_TT")
   RETURN(.F.)
ENDIF

IF !EXECCOMMAND("DELETE FROM PIANOP_MO WHERE DAGGANCIO='"+ALLTRIM(_AGGANCIO)+"' ","PIANOP_TT")
   RETURN(.F.)
ENDIF

IF !EXECCOMMAND("DELETE FROM PIANOP_P1 WHERE DAGGANCIO='"+ALLTRIM(_AGGANCIO)+"' ","PIANOP_TT")
   RETURN(.F.)
ENDIF

IF !EXECCOMMAND("DELETE FROM PIANOP_P2 WHERE DAGGANCIO='"+ALLTRIM(_AGGANCIO)+"' ","PIANOP_TT")
   RETURN(.F.)
ENDIF

IF !EXECCOMMAND("DELETE FROM PIANOP_TT WHERE TAGGANCIO='"+ALLTRIM(_AGGANCIO)+"' ","PIANOP_TT")
   RETURN(.F.)
ENDIF

RETURN

* FINE CANCELLA_PIANO
******************************************************


******************************************************
PROCEDURE RICARICA_TESTATE_PIANOP
******************************************************
IF !EXECCOMMAND("SELECT * FROM PIANOP_TT","PIANOP_TT")
   RETURN(.F.)
ENDIF

SELECT C_PIANOP_TT
ZAP

SELECT PIANOP_TT

GO TOP 

DO WHILE !EOF() 

	M.SALDO=PPA_PAGATO
	M.PAGATO=IIF(PPA_FLGTRA,'SI','')
	
	SELECT PIANOP_TT
  	SCATTER MEMVAR MEMO
   
	SELECT C_PIANOP_TT
	APPEND BLANK
	
	GATHER MEMVAR MEMO
	SELECT PIANOP_TT
	SKIP +1
ENDDO

SELECT C_PIANOP_TT
SET ORDER TO DESCNUMPPA
GO TOP
* FINE PROCEDURE RICARICA_TESTATE_PIANOP
******************************************************



******************************************************
PROCEDURE CARICA_DETTAGLI_PIANOP
******************************************************
LOCAL	_AGGANCIO,;
		_NUMERO
		

SELECT C_PIANOP_TT

_AGGANCIO	=	TAGGANCIO
_NUMERO		=	PPA_NUMPPA
PUB_DTPIAP = RIBALTA2 (PPA_DTPIAP)

IF !EXECCOMMAND("SELECT * FROM PIANOP_DD WHERE DAGGANCIO='"+ALLTRIM(_AGGANCIO)+"'","_PIANOP_DD")
	RETURN (.F.)
ENDIF	

SELECT _PIANOP_DD
GO TOP
DO WHILE !EOF()
	
	SELECT _PIANOP_DD
	SCATTER MEMVAR MEMO
		
	SELECT CUR_PIANOP_DD
	APPEND BLANK
	GATHER MEMVAR MEMO
	REPLACE TNUMERO WITH _NUMERO

	SELECT _PIANOP_DD
	SKIP
ENDDO

SELECT CUR_PIANOP_DD
GO TOP

PUB_NUMPIANO	=	""

* FINE PROCEDURE CARICA_DETTAGLI_PIANOP
******************************************************



**********************************
* Procedure CreaPianoPagamento
**********************************
PROCEDURE CreaPianoPagamento

	LPARAMETERS dDataPiano,_lFlgContabilizza

	LOCAL 	nNumPianoPag,;
			nAggancio,;
			nTotalePagati,;
			lFlgContabilizza

	lFlgContabilizza = .T.
	IF 	PCOUNT()>1
		lFlgContabilizza =_lFlgContabilizza 
	ENDIF

	
	nNumPianoPag=0
	nAggancio=0
	
	SS=SELECT()
	v_seek   = 'NUMPIP'+PUB_CODSOC
	v_chiave = "codice"
	cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
	IF !ExecRW(cSql,"PARA","R")
	   return(.f.)
	ENDIF
	SELECT PARA
	IF RECCOUNT() <> 0
	   nNumPianoPag=VAL(SUBSTR(LIBERA,1,7)) + 1
	   REPLACE LIBERA WITH SUBSTR(STR(nNumPianoPag,7,0),1,7)
	ELSE
	   RIT = MSGBOX('Parametro numero piano pagamento non trovato','ATTENZIONE',31)
	   SELECT(SS)
	   RETURN 
	ENDIF
	IF !ExecRW(cSql,"PARA","W")
	   return(.f.)
	ENDIF
	SELECT(SS)
	
	
	SS=SELECT()
	v_seek   = 'NUMPIP'
	v_chiave = "codice"
	cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
	IF !ExecRW(cSql,"PARA","R")
	   return(.f.)
	ENDIF
	SELECT PARA
	IF RECCOUNT() <> 0
	   nAggancio=VAL(SUBSTR(LIBERA,1,7)) + 1
	   REPLACE LIBERA WITH SUBSTR(STR(nAggancio,7,0),1,7)
	ELSE
	   APPEND BLANK 
	   REPLACE CODICE WITH "NUMPIP" 
	   REPLACE DESCRI WITH "PROGRESSIVO PIANO PAGAMENTO"
	   nAggancio=1
	   REPLACE LIBERA WITH SUBSTR(STR(nAggancio,7,0),1,7)

	ENDIF
	IF !ExecRW(cSql,"PARA","W")
	   return(.f.)
	ENDIF
	SELECT(SS)
	
	SELECT PAGATI
	SUM QUANTAVALU TO nTotalePagati 
	
	_TAGGANCIO  = nAggancio
	_PPA_CODSOC = PUB_CODSOC
	_TNUMERO    = nNumPianoPag
	_PPA_NOTE01 = SPACE(0)
	_PPA_NOTE02 = SPACE(0)
	_PPA_NOTE03 = SPACE(0)
	_PPA_NOTE04 = SPACE(0)
	_PPA_NUMPPA = ALLTRIM(STR(nNumPianoPag))
	_PPA_DTPIAP = RIBALTA2(dDataPiano)
	_PPA_DAPAGA = ABS(nTotalePagati)
	_PPA_PAGATO = ABS(nTotalePagati)
	_SELEZIONE  = SPACE(0)
	_PPA_ORA    = TIME()
	_PPA_CODOPE = PUB_CODOPE
	IF lFlgContabilizza 
		_PPA_FLGTRA = PUB_CONSOLIDA
	ELSE
		_PPA_FLGTRA = 0
	ENDIF
	
	
	cSql="select * from PIANOP_TT where 1=0"
	RELEASE M.ID_UNIQUE
	IF !ExecRW(cSql,"PIANOP_TT","R")
	   return(.f.)
	ENDIF
	SELECT PIANOP_TT
	APPEND BLANK
	
	REPLACE TAGGANCIO   WITH ALLTRIM(STR(_TAGGANCIO))     
	REPLACE	PPA_CODSOC  WITH _PPA_CODSOC                  
	REPLACE	TNUMERO     WITH ALLTRIM(STR(_TNUMERO))       
	REPLACE	PPA_NOTE01  WITH _PPA_NOTE01                  
	REPLACE	PPA_NOTE02  WITH _PPA_NOTE02                  
	REPLACE	PPA_NOTE03  WITH _PPA_NOTE03                  
	REPLACE	PPA_NOTE04  WITH _PPA_NOTE04                  
	REPLACE	PPA_NUMPPA  WITH _PPA_NUMPPA                  
	REPLACE	PPA_DTPIAP  WITH _PPA_DTPIAP                  
	REPLACE	PPA_DAPAGA  WITH _PPA_DAPAGA                  
	REPLACE	PPA_PAGATO  WITH _PPA_PAGATO                  
	REPLACE	SELEZIONE   WITH _SELEZIONE                   
	REPLACE	PPA_ORA     WITH SUBSTR(_PPA_ORA,1,5)         
	REPLACE	PPA_CODOPE  WITH _PPA_CODOPE                  
	REPLACE	PPA_FLGTRA  WITH IIF(_PPA_FLGTRA=0,.F.,.T.)   
	
	IF !ExecRW(cSql,"PIANOP_TT","W")
	   return(.f.)
	ENDIF

	*** AGGANCIO PER TUTTE LE TABELLE DI DETTAGLIO
	M.DAGGANCIO = ALLTRIM(STR(_TAGGANCIO))
	
**************** DETTAGLI PIANO DI PAGAMENTO	
	SELECT MOVIMENTI
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		cSql="select * from PIANOP_DD where 1=0"
		IF !ExecRW(cSql,"PIANOP_DD","R")
	   		return(.f.)
		ENDIF

		SELECT MOVIMENTI
		***REPLACE QUANDOVALU WITH RIBALTA2(PUB_DTPIAP)
		REPLACE QUANDOVALU WITH RIBALTA2(dDataPiano)
		
		SCATTER MEMVAR MEMO

		*
		* SUL RECORD DEI MOVIMENTI SONO MEMORIZZATE:
		*
		* 1) PAGAMENTO FORNITORE (E ALTRO...)
		*
		*    - DESTINAZIONE
		*		QUANDO HO SELEZIONATO LA FATTURA DEL FORNITORE E L'ATTRIBUISCO ALLA BANCA IN QUEL MOMENTO
		*		RISALGO ALL'ANAGRAFICA DEL FORNITORE, PRENDO LA BANCA FOR_BAE E ACCEDO A U_BAN_AN PER VALORIZZARE:
		*			FOR_BAE		 ===> BANCA
		*			FOR_NUMCOC   ===> contocorr
		*		    FOR_CODABI   ===> ABI   
	    *			FOR_CODCAB   ===> CAB 
	    *			FOR_CODCIN   ===> CIN 
	    *
        *           
        *    - PARTENZA
        *      DAL CONTO CORRENTE (U_CCO_TT) RISALGO AL CODICE BANCA (U_CCO_TT.ORD_BANCA) 
        *      CON QUESTO ACCEDO A U_BAN_AN E RICAVO:
        *			BAN_COBAN    ===> BANCA_PART
		*			ORD_CODCCO   ===> CONTOCORR_PART
		*		    BAN_CODABI   ===> ABI_PART   
	    *			BAN_CODCAB   ===> CAB_PART 
	    *			BAN_CIN	     ===> CIN_PART 
        *                           
		*
		
		_CODRIS_DA=CODRIS_DA
		
		SELECT * FROM SALDI WHERE  CONTOCONT=_CODRIS_DA INTO CURSOR CBANCA_PART
		SELECT CBANCA_PART
		IF !EOF()
			_ABI_PART=ABI
			_CAB_PART=CAB
			_CIN_PART=CIN
			_BANCA_PART=CODRISORSA
			_CONTOCORR_PART=CC
		ELSE		
			_ABI_PART		="***"
			_CAB_PART		="***"
			_CIN_PART		="***"
			_CONTOCORR_PART	="***"
			_BANCA_PART		="***"
		ENDIF		
		
		_RAGSOC	 	=	DES_A
        _QUANTAVALU = 	ABS(quantavalu)
		_NSALDO	 	=	_QUANTAVALU 
		_NUMEROFATT	= 	NUMEROFATT
						
		SELECT PIANOP_DD
		APPEND BLANK
		
		GATHER MEMVAR MEMO
		REPLACE DAGGANCIO WITH ALLTRIM(STR(_TAGGANCIO)),;
				RAGSOC	  WITH _RAGSOC	,; 
				NSALDO	  WITH _NSALDO	,;  
        		ABI_PART  WITH _ABI_PART,;
				CAB_PART  WITH _CAB_PART,;
				CIN_PART  WITH _CIN_PART,;
				CONTOCORR_PART  WITH _CONTOCORR_PART,;
                BANCA_PART WITH _BANCA_PART,;
                NUMEROFATT WITH _NUMEROFATT,;
                QUANTAVALU WITH _QUANTAVALU

		***REPLACE QUANDOVALU WITH RIBALTA2(PUB_DTPIAP)     
		REPLACE QUANDOVALU WITH RIBALTA2(dDataPiano)     
		
                                				
		RELEASE M.ID_UNIQUE
		IF !ExecRW(cSql,"PIANOP_DD","W")
		   return(.f.)
		ENDIF
	
		SELECT MOVIMENTI
		SKIP
	ENDDO
	
	
**************** MOVIMENTI PIANO DI PAGAMENTO	
	SELECT MOVIMENTI
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		cSql="select * from PIANOP_MO where 1=0"
		IF !ExecRW(cSql,"PIANOP_MO","R")
	   		return(.f.)
		ENDIF

		SELECT MOVIMENTI
		SCATTER MEMVAR MEMO
						
		SELECT PIANOP_MO
		APPEND BLANK
		
		GATHER MEMVAR MEMO
          			
                				
		RELEASE M.ID_UNIQUE
		IF !ExecRW(cSql,"PIANOP_MO","W")
		   return(.f.)
		ENDIF
	
		SELECT MOVIMENTI
		SKIP
	ENDDO

**************** SALDI PIANO DI PAGAMENTO	
	SELECT SALDI
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		cSql="select * from PIANOP_SA where 1=0"
		IF !ExecRW(cSql,"PIANOP_SA","R")
	   		return(.f.)
		ENDIF

		SELECT SALDI
		SCATTER MEMVAR MEMO
						
		SELECT PIANOP_SA
		APPEND BLANK
		
		GATHER MEMVAR MEMO
                				
		RELEASE M.ID_UNIQUE
		IF !ExecRW(cSql,"PIANOP_SA","W")
		   return(.f.)
		ENDIF
	
		SELECT SALDI
		SKIP
	ENDDO

	**************** PAGAMENTI PIANO DI PAGAMENTO	
	SELECT AGGIUNTIVI
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		cSql="select * from PIANOP_P1 where 1=0"
		IF !ExecRW(cSql,"PIANOP_P1","R")
	   		return(.f.)
		ENDIF
	
		SELECT AGGIUNTIVI
		***REPLACE QUANDOVALU WITH RIBALTA2(PUB_DTPIAP)     
		REPLACE QUANDOVALU WITH RIBALTA2(dDataPiano)     

		SCATTER MEMVAR MEMO
						
		SELECT PIANOP_P1
		APPEND BLANK
		
		GATHER MEMVAR MEMO
	            				
		RELEASE M.ID_UNIQUE
		IF !ExecRW(cSql,"PIANOP_P1","W")
		   return(.f.)
		ENDIF
	
		SELECT AGGIUNTIVI
		SKIP
	ENDDO
		
		
**************** PAGATI PIANO DI PAGAMENTO	
	SELECT PAGATI
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		cSql="select * from PIANOP_P2 where 1=0"
		IF !ExecRW(cSql,"PIANOP_P2","R")
	   		return(.f.)
		ENDIF

		SELECT PAGATI
		***REPLACE QUANDOVALU WITH RIBALTA2(PUB_DTPIAP)     
		REPLACE QUANDOVALU WITH RIBALTA2(dDataPiano)     
		
		SCATTER MEMVAR MEMO
						
		SELECT PIANOP_P2
		APPEND BLANK
		
		GATHER MEMVAR MEMO
                				
		RELEASE M.ID_UNIQUE
		IF !ExecRW(cSql,"PIANOP_P2","W")
		   return(.f.)
		ENDIF
	
		SELECT PAGATI
		SKIP
	ENDDO
	
IF !lFlgContabilizza 	
	=MESSAGEBOX("Piano di pagamento "+ALLTRIM(STR(nNumPianoPag))+" creato correttamente",48,"Creazione piano di pagamento")	
	AGGIUNGI_PIANO_CARICATO(ALLTRIM(STR(nNumPianoPag)))
ENDIF	
		
RETURN nNumPianoPag
* FINE...Procedure CreaPianoPagamento
**********************************



**********************************
* Procedure AggiornaPianoPagamento
**********************************
PROCEDURE AggiornaPianoPagamento

	LPARAMETERS cNumeroPiano

	cSql="SELECT * FROM PIANOP_TT WHERE TNUMERO='"+cNumeroPiano+"'"
	IF !ExecCommand(cSql,"CPIANOP_TT")
	   return(.f.)
	ENDIF
	
	SELECT CPIANOP_TT
	GO TOP
	IF EOF()
		MESSAGEBOX("Piano di pagamento "+cNumeroPiano+" non trovato",48,"Aggiornamento piano di pagamento")
		RETURN
	ENDIF

	*** AGGANCIO PER TUTTE LE TABELLE DI DETTAGLIO
	M.DAGGANCIO = TAGGANCIO
	
*** AGGIORNA IL TOTALE
	SELECT PAGATI
	SUM QUANTAVALU TO nTotalePagati 
	
	_PPA_DAPAGA = ABS(nTotalePagati)
	_PPA_PAGATO = ABS(nTotalePagati)
	
	cSql="UPDATE PIANOP_TT SET PPA_DTPIAP = '"+RIBALTA2(PUB_DTPIAP)+"', PPA_DAPAGA="+ALLTRIM(STR(_PPA_DAPAGA))+" , PPA_PAGATO="+ALLTRIM(STR(_PPA_PAGATO))+" where TAGGANCIO='"+M.DAGGANCIO+"'"
	IF !ExecCommand(cSql,"CPIANOP_TT")
	   return(.f.)
	ENDIF

**************** DETTAGLI PIANO DI PAGAMENTO	

	cSql="DELETE from PIANOP_DD where DAGGANCIO='"+M.DAGGANCIO+"'"
	IF !ExecCommand(cSql,"PIANOP_DD")
	   return(.f.)
	ENDIF
			
	SELECT MOVIMENTI
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		cSql="select * from PIANOP_DD where 1=0"
		IF !ExecRW(cSql,"PIANOP_DD","R")
	   		return(.f.)
		ENDIF

		SELECT MOVIMENTI
		SCATTER MEMVAR MEMO

		_CODRIS_DA=CODRIS_DA
		
		SELECT * FROM SALDI WHERE  CONTOCONT=_CODRIS_DA INTO CURSOR CBANCA_PART
		SELECT CBANCA_PART
		IF !EOF()
			_ABI_PART=ABI
			_CAB_PART=CAB
			_CIN_PART=CIN
			_BANCA_PART=CODRISORSA
			_CONTOCORR_PART=CC
		ELSE		
			_ABI_PART		="***"
			_CAB_PART		="***"
			_CIN_PART		="***"
			_CONTOCORR_PART	="***"
			_BANCA_PART		="***"
		ENDIF		
		
		_RAGSOC	 	=	DES_A
        _QUANTAVALU = 	ABS(quantavalu)
		_NSALDO	 	=	_QUANTAVALU 
						
		SELECT PIANOP_DD
		APPEND BLANK
		
		GATHER MEMVAR MEMO
		REPLACE DAGGANCIO WITH M.DAGGANCIO,;
				RAGSOC	  WITH _RAGSOC	,; 
				NSALDO	  WITH _NSALDO	,;  
        		ABI_PART  WITH _ABI_PART,;
				CAB_PART  WITH _CAB_PART,;
				CIN_PART  WITH _CIN_PART,;
				CONTOCORR_PART  WITH _CONTOCORR_PART,;
                BANCA_PART WITH _BANCA_PART,;
                QUANTAVALU WITH _QUANTAVALU 
                				
		RELEASE M.ID_UNIQUE
		IF !ExecRW(cSql,"PIANOP_DD","W")
		   return(.f.)
		ENDIF
	
		SELECT MOVIMENTI
		SKIP
	ENDDO
	
	
**************** MOVIMENTI PIANO DI PAGAMENTO	
	cSql="DELETE from PIANOP_MO where DAGGANCIO='"+M.DAGGANCIO+"'"
	IF !ExecCommand(cSql,"CPIANOP_MO")
	   return(.f.)
	ENDIF
	
	SELECT MOVIMENTI
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		cSql="select * from PIANOP_MO where 1=0"
		IF !ExecRW(cSql,"PIANOP_MO","R")
	   		return(.f.)
		ENDIF

		SELECT MOVIMENTI
		SCATTER MEMVAR MEMO
						
		SELECT PIANOP_MO
		APPEND BLANK
		
		GATHER MEMVAR MEMO
          			
                				
		RELEASE M.ID_UNIQUE
		IF !ExecRW(cSql,"PIANOP_MO","W")
		   return(.f.)
		ENDIF
	
		SELECT MOVIMENTI
		SKIP
	ENDDO

**************** SALDI PIANO DI PAGAMENTO	
	cSql="DELETE from PIANOP_SA where DAGGANCIO='"+M.DAGGANCIO+"'"
	IF !ExecCommand(cSql,"CPIANOP_SA")
	   return(.f.)
	ENDIF
	
	SELECT SALDI
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		cSql="select * from PIANOP_SA where 1=0"
		IF !ExecRW(cSql,"PIANOP_SA","R")
	   		return(.f.)
		ENDIF

		SELECT SALDI
		SCATTER MEMVAR MEMO
						
		SELECT PIANOP_SA
		APPEND BLANK
		
		GATHER MEMVAR MEMO
                				
		RELEASE M.ID_UNIQUE
		IF !ExecRW(cSql,"PIANOP_SA","W")
		   return(.f.)
		ENDIF
	
		SELECT SALDI
		SKIP
	ENDDO

	**************** PAGAMENTI PIANO DI PAGAMENTO	
	cSql="DELETE from PIANOP_P1 where DAGGANCIO='"+M.DAGGANCIO+"'"
	IF !ExecCommand(cSql,"CPIANOP_P1")
	   return(.f.)
	ENDIF
	
	SELECT AGGIUNTIVI
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		cSql="select * from PIANOP_P1 where 1=0"
		IF !ExecRW(cSql,"PIANOP_P1","R")
	   		return(.f.)
		ENDIF

		SELECT AGGIUNTIVI
		SCATTER MEMVAR MEMO
						
		SELECT PIANOP_P1
		APPEND BLANK
		
		GATHER MEMVAR MEMO
	            				
		RELEASE M.ID_UNIQUE
		IF !ExecRW(cSql,"PIANOP_P1","W")
		   return(.f.)
		ENDIF
	
		SELECT AGGIUNTIVI
		SKIP
	ENDDO
		
		
	
**************** PAGATI PIANO DI PAGAMENTO	
	cSql="DELETE from PIANOP_P2 where DAGGANCIO='"+M.DAGGANCIO+"'"
	IF !ExecCommand(cSql,"CPIANOP_P2")
	   return(.f.)
	ENDIF
	
	SELECT PAGATI
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF
		
		cSql="select * from PIANOP_P2 where 1=0"
		IF !ExecRW(cSql,"PIANOP_P2","R")
	   		return(.f.)
		ENDIF

		SELECT PAGATI
		SCATTER MEMVAR MEMO
						
		SELECT PIANOP_P2
		APPEND BLANK
		
		GATHER MEMVAR MEMO
                				
		RELEASE M.ID_UNIQUE
		IF !ExecRW(cSql,"PIANOP_P2","W")
		   return(.f.)
		ENDIF
	
		SELECT PAGATI
		SKIP
	ENDDO
	
=MESSAGEBOX("Piano di pagamento "+ALLTRIM(cNumeroPiano)+" aggiornato correttamente",48,"Creazione piano di pagamento")	
		
RETURN cNumeroPiano
* FINE...Procedure AggiornaPianoPagamento
**********************************



**********************************
Procedure CaricaPianoPagamento
**********************************
	PARAMETERS nNumPianoPag

	IF !AGGIUNGI_PIANO_CARICATO(nNumPianoPag)
		RETURN(.F.)
	ENDIF

	SS=STR(SELECT())
	
	cSql="select * from PIANOP_TT where TNUMERO='"+ALLTRIM(nNumPianoPag)+"'"
	IF !ExecCommand(cSql,"PIANOP_TT")
	   return(.f.)
	ENDIF
	
	SELECT PIANOP_TT
	GO TOP
	
	IF EOF()
		MESSAGEBOX("Piano di pagamento n."+ALLTRIM(nNumPianoPag)+" non tovato",48,"Caricamento piano di pagamento")	
		SELECT &SS
		RETURN(.F.)
	ENDIF
	
	
	IF PPA_FLGTRA
		MESSAGEBOX("Piano di pagamento n."+ALLTRIM(nNumPianoPag)+" gia' contabilizzato."+CHR(13)+;
					"Caricamento non consentito",48,"Caricamento piano di pagamento")							
		SELECT &SS
		RETURN(.F.)
	ENDIF
	
	_aggancio=TAGGANCIO
	_DATA_PAGAMENTO=PPA_DTPIAP

**************** DETTAGLI PIANO DI PAGAMENTO	
	SELECT MOVIMENTI
	*ZAP
	
	cSql="select * from PIANOP_MO where DAGGANCIO='"+ALLTRIM(_aggancio)+"'"
	IF !ExecCommand(cSql,"PIANOP_MO")
	   return(.f.)
	ENDIF
	
	SELECT PIANOP_MO
	GO TOP
	
	DO WHILE !EOF()
	
		SELECT PIANOP_MO
		SCATTER MEMVAR MEMO
		
		SELECT MOVIMENTI
		APPEND BLANK
		GATHER MEMVAR MEMO
		
		IF EMPTY(TIPOLOGIA)
		  REPLACE TIPOLOGIA WITH "PAG.GEN."
		ENDIF
		
		IF !EMPTY(_DATA_PAGAMENTO)
		  REPLACE DT_CONTAB WITH _DATA_PAGAMENTO
		ENDIF
                				
		SELECT PIANOP_MO
		SKIP
	ENDDO

	SELECT AGGIUNTIVI
	*ZAP
	
	cSql="select * from PIANOP_P1 where DAGGANCIO='"+ALLTRIM(_aggancio)+"'"
	IF !ExecCommand(cSql,"PIANOP_P1")
	   return(.f.)
	ENDIF
	
	SELECT PIANOP_P1
	GO TOP
	
	DO WHILE !EOF()
	
		SELECT PIANOP_P1
		SCATTER MEMVAR MEMO
		
		SELECT AGGIUNTIVI
		APPEND BLANK
		GATHER MEMVAR MEMO

		IF EMPTY(TIPOLOGIA)
		  REPLACE TIPOLOGIA WITH "PAG.GEN."
		ENDIF
		
		IF !EMPTY(_DATA_PAGAMENTO)
		  REPLACE DTSCAD WITH _DATA_PAGAMENTO
		ENDIF		
                				
		SELECT PIANOP_P1
		SKIP
	ENDDO
		
**************** PAGATI PIANO DI PAGAMENTO	
	SELECT PAGATI
	*ZAP
	
	cSql="select * from PIANOP_P2 where DAGGANCIO='"+ALLTRIM(_aggancio)+"'"
	IF !ExecCommand(cSql,"PIANOP_P2")
	   return(.f.)
	ENDIF
	
	SELECT PIANOP_P2
	GO TOP
	
	DO WHILE !EOF()
	
		SELECT PIANOP_P2
		SCATTER MEMVAR MEMO
		
		SELECT PAGATI
		APPEND BLANK
		GATHER MEMVAR MEMO
		
		IF EMPTY(TIPOLOGIA)
		  REPLACE TIPOLOGIA WITH "PAG.GEN."
		ENDIF
		
		IF !EMPTY(_DATA_PAGAMENTO)
		  REPLACE DTSCAD WITH _DATA_PAGAMENTO
		ENDIF		
                    				
		SELECT PIANOP_P2
		SKIP
	ENDDO
	
SELECT &SS
		
RETURN (.T.)
* FINE...Procedure CaricaPianoPagamento
**********************************


*!*	**********************************
*!*	Procedure SalvaPianoPagamento
*!*	**********************************
*!*		
*!*		cSql="select * from PIANOP_TT where 1=0"
*!*		RELEASE M.ID_UNIQUE
*!*		IF !ExecRW(cSql,"SPIANOP_TT","R")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT PIANOP_TT
*!*		GO TOP
*!*		DO WHILE !EOF()

*!*			SCATTER MEMVAR
*!*			SELECT SPIANOP_TT
*!*			APPEND BLANK
*!*			GATHER MEMVAR
*!*		
*!*			SELECT PIANOP_TT
*!*			SKIP
*!*		ENDDO	
*!*		
*!*		IF !ExecRW(cSql,"PIANOP_TT","W")
*!*		   return(.f.)
*!*		ENDIF



*!*		cSql="select * from PIANOP_DD where 1=0"
*!*		RELEASE M.ID_UNIQUE
*!*		IF !ExecRW(cSql,"SPIANOP_DD","R")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT PIANOP_DD
*!*		GO TOP
*!*		DO WHILE !EOF()

*!*			SCATTER MEMVAR
*!*			SELECT SPIANOP_DD
*!*			APPEND BLANK
*!*			GATHER MEMVAR
*!*		
*!*			SELECT PIANOP_DD
*!*			SKIP
*!*		ENDDO	
*!*		
*!*		IF !ExecRW(cSql,"SPIANOP_DD","W")
*!*		   return(.f.)
*!*		ENDIF




*!*		cSql="select * from PIANOP_MO where 1=0"
*!*		RELEASE M.ID_UNIQUE
*!*		IF !ExecRW(cSql,"SPIANOP_MO","R")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT PIANOP_MO
*!*		GO TOP
*!*		DO WHILE !EOF()

*!*			SCATTER MEMVAR
*!*			SELECT SPIANOP_MO
*!*			APPEND BLANK
*!*			GATHER MEMVAR
*!*		
*!*			SELECT PIANOP_MO
*!*			SKIP
*!*		ENDDO	
*!*		
*!*		IF !ExecRW(cSql,"SPIANOP_MO","W")
*!*		   return(.f.)
*!*		ENDIF
*!*		
*!*		


*!*		cSql="select * from PIANOPSA where 1=0"
*!*		RELEASE M.ID_UNIQUE
*!*		IF !ExecRW(cSql,"SPIANOP_SA","R")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT PIANOP_SA
*!*		GO TOP
*!*		DO WHILE !EOF()

*!*			SCATTER MEMVAR
*!*			SELECT SPIANOP_SA
*!*			APPEND BLANK
*!*			GATHER MEMVAR
*!*		
*!*			SELECT PIANOP_SA
*!*			SKIP
*!*		ENDDO	
*!*		
*!*		IF !ExecRW(cSql,"SPIANOP_SA","W")
*!*		   return(.f.)
*!*		ENDIF
*!*		



*!*		cSql="select * from PIANOP_P1 where 1=0"
*!*		RELEASE M.ID_UNIQUE
*!*		IF !ExecRW(cSql,"SPIANOP_P1","R")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT PIANOP_P1
*!*		GO TOP
*!*		DO WHILE !EOF()

*!*			SCATTER MEMVAR
*!*			SELECT SPIANOP_P1
*!*			APPEND BLANK
*!*			GATHER MEMVAR
*!*		
*!*			SELECT PIANOP_P1
*!*			SKIP
*!*		ENDDO	
*!*		
*!*		IF !ExecRW(cSql,"SPIANOP_P1","W")
*!*		   return(.f.)
*!*		ENDIF



*!*		cSql="select * from PIANOP_P2 where 1=0"
*!*		RELEASE M.ID_UNIQUE
*!*		IF !ExecRW(cSql,"SPIANOP_P2","R")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT PIANOP_P2
*!*		GO TOP
*!*		DO WHILE !EOF()

*!*			SCATTER MEMVAR
*!*			SELECT SPIANOP_P2
*!*			APPEND BLANK
*!*			GATHER MEMVAR
*!*		
*!*			SELECT PIANOP_P2
*!*			SKIP
*!*		ENDDO	
*!*		
*!*		IF !ExecRW(cSql,"SPIANOP_P2","W")
*!*		   return(.f.)
*!*		ENDIF

*!*	* FINE...Procedure SalvaPianoPagamento
*!*	**********************************





**********************************
Procedure SalvaPianoPagamento
**********************************
	IF !ExecRW(cSql,"PIANOP_TT","W")
	   return(.f.)
	ENDIF

	IF !ExecRW(cSql,"PIANOP_DD","W")
	   return(.f.)
	ENDIF


	IF !ExecRW(cSql,"PIANOP_MO","W")
	   return(.f.)
	ENDIF
	
	IF !ExecRW(cSql,"PIANOP_SA","W")
	   return(.f.)
	ENDIF
	

	IF !ExecRW(cSql,"PIANOP_P1","W")
	   return(.f.)
	ENDIF

	
	IF !ExecRW(cSql,"PIANOP_P2","W")
	   return(.f.)
	ENDIF

* FINE...Procedure SalvaPianoPagamento
**********************************


