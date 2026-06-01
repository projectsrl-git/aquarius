******************************************************************
* Libreria di Procedure
* Tesoreria_lib.PRG
******************************************************************
#DEFINE STATO_FINE_TRANSAZIONE 4
#DEFINE STATO_SELEZIONATA_PARTENZA_TRANSAZIONE 2
#DEFINE STATO_SELEZIONATA_DESTINAZIONE_TRANSAZIONE 3


***************************	
* Procedure Crea_Cursor_MovimentiDelleRisorse
***************************
PROCEDURE Crea_Cursor_MovimentiDelleRisorse

	&& ERASMO - 10/09/2015 - ALLARGATO CAMPO NUMEROFATT DA C(10) A C(20)
	&& ERASMO - 02/08/2017 - AGGIUNTO CAMPO DATAFATT C(10)
	CREATE CURSOR MOVIMENTI (;
		SELEZIONE   C(3),;
		ID_MOVIMEN 	C(120),;
		LEGA_MOV 	C(120),;
		CODRIS_DA 	C(20),;
		CODRIS_A 	C(20),;
		DES_DA 		C(50),;
		DES_A 		C(50),;
		CODCAUSALE 	C(20),;
		DES_MOVIME	C(30),;
		IMPORTO		N(17,3),;
		DT_DISPON	C(10),;
		DT_CONTAB	C(10),;
		COD_USER 	C(20),;
		NPART 		N(10,0),;
		NUMEROFATT	C(20), ;
		DATAFATT	C(10), ;
		DTREG		C(10), ;
		tipopagam 	C(10),	;
	    tipologia	C(20),	;
		cosatratta 	C(5),	;
		gradoimpor 	C(5),	;
		formapagam 	C(5),	;
		tipocontra 	C(5),	;
		codacq 		C(3),	;
		pripaga 	C(4),	;
		dtscad 		C(10),	;
		codfor 		C(13),	;
		banca 		C(10),	;
		contocorr 	C(20),	;
		contocont 	C(13),	;
		quantavalu 	N(17,3),;
		quandovalu 	C(10),;
		ABI	C(5),;
		CAB C(5),;
		CIN C(3),;
		PREVIS C(1),;
		FLG_CBI L ;
	)
			
	INDEX ON ALLTRIM(CODRIS_A) + ALLTRIM(STR(NPART))+ DTSCAD TAG DTSCAD		
	INDEX ON ID_MOVIMEN TAG ID_MOVIMEN
	SET ORDER TO ID_MOVIMEN
ENDPROC

*!*	***************************	
*!*	* Procedure Crea_Cursor_CausaliMovimentiBancari
*!*	***************************
*!*	PROCEDURE Crea_Cursor_CausaliMovimentiBancari
*!*		CREATE CURSOR CAUSALI (;
*!*			CODCAUSALE C(10),;
*!*			DESCAUSALE C(50),;
*!*			SEGNO	   N(4),;
*!*			ASSEGNI    L,;
*!*			INCASSI    L,;
*!*			BONIFICI   L,;
*!*			RIBA	   L,;
*!*			RID		   L;
*!*		)
*!*		
*!*	ENDPROC


***************************	
* Procedure Crea_Cursor_CausaliMovimentiBancari
***************************
PROCEDURE Crea_Cursor_CausaliMovimentiBancari
	CREATE CURSOR CAUSALI (;
		CODCAUSALE C(10),;
		DESCAUSALE C(50),;
		SEGNO	   N(4),;
		ENTRATA    L,;
		ASSEGNI    L,;
		INCASSI    L,;
		BONIFICI   L,;
		RIBA	   L,;
		TRASF	   L,;
		RID		   L;
	)
	
ENDPROC

***************************	
* Procedure Crea_Cursor_Saldi
***************************
PROCEDURE Crea_Cursor_Saldi

	CREATE CURSOR SALDI (;
		CODRISORSA C(20),;
		DESRISORSA C(50),;
		ABI	C(5),;
		CAB C(5),;
		CC	C(12),;
		CIN C(3),;
		CONTOCONT C(20),;
		DT_SALDO C(10),;
		SALDO N(17,3),;
		FIDO N(17,3),;
		INCASSO N(17,3),;
		ANTRIBA N(17,3),;
		EFFATT N(17,3),;
		DISPONIB N(17,3),;
		ENT_ASS N(17,3),;
		ENT_BONI N(17,3),;
		ENT_TRAS N(17,3),;
		USC_ASS N(17,3),;
		USC_BONI N(17,3),;
		USC_TRAS N(17,3),;
		DISPONIB2 N(17,3),;
		PAGAMENTI N(17,3),;
		INCASSI N(17,3);
	)
	INDEX ON CODRISORSA TAG CODRISORSA
	INDEX ON DESRISORSA TAG DESRISORSA
	INDEX ON CC TAG CC
	INDEX ON SALDO TAG SALDO
	INDEX ON FIDO TAG FIDO
	INDEX ON DISPONIB TAG DISPONIB
	INDEX ON ENT_ASS TAG ENT_ASS
	INDEX ON ENT_BONI TAG ENT_BONI
	INDEX ON ENT_TRAS TAG ENT_TRAS
	INDEX ON USC_ASS TAG USC_ASS
	INDEX ON USC_BONI TAG USC_BONI
	INDEX ON USC_TRAS TAG USC_TRAS
	INDEX ON DISPONIB2 TAG DISPONIB2
	INDEX ON CONTOCONT TAG CONTOCONT
	
	SELECT SALDI
	SET ORDER TO DESRISORSA


	***CHR(95)+CHR(36)+CHR(46)+CHR(68)+CHR(66)+CHR(70)


RETURN


***************************	
* Procedure Crea_Cursor_Pagamenti
***************************
PROCEDURE Crea_Cursor_Pagamenti

	DO DEF_VIP000
	
	*** PREPARO IL CAMPO NUMFAT SE NON C'E'
	*MODTBL(ALIAS(SELECT()),"NUMEROFATT",  "C(6)")
	MODTBL(ALIAS(SELECT()),"NUMEROFATT",  "C(20)")  && ERASMO - 10/09/2015 - ALLARGATO CAMPO NUMEROFATT DA C(6) A C(20)
	MODTBL(ALIAS(SELECT()),"NAZIONE",  "C(3)")

	gnFieldcount = AFIELDS(gaMyArray)  && Create array

	*** Pagamenti da effettuare
	CREATE CURSOR PAGAMENTI FROM ARRAY gaMyArray
	INDEX ON CODFOR+STR(NPART) 		TAG PARTITA
	INDEX ON ID_PARTITA 			TAG ID_PARTITA
	INDEX ON IIF(!EMPTY(LEGA_SPLIT),LEGA_SPLIT,ID_PARTITA) TAG SPLIT
	SELECT PAGAMENTI
	SET ORDER TO PARTITA
	
	*** Pagamenti effettuati
	CREATE CURSOR PAGATI  FROM ARRAY gaMyArray
	INDEX ON ALLTRIM(CODFOR) + ALLTRIM(STR(NPART))+ DTSCAD TAG DTSCAD			
	INDEX ON CODFOR+STR(NPART) 		TAG PARTITA
	INDEX ON ID_PARTITA 			TAG ID_PARTITA
	SELECT PAGATI
	SET ORDER TO PARTITA

	*** Importi aggiuntivi da contabilizzare
	CREATE CURSOR AGGIUNTIVI FROM ARRAY gaMyArray
	INDEX ON CODFOR+STR(NPART) 		TAG PARTITA
	INDEX ON ID_PARTITA 			TAG ID_PARTITA
	INDEX ON SUBSTR(ID_PARTITA,1,100)+SELEZIONE 	TAG PARTCONTRO
	SELECT AGGIUNTIVI 
	SET ORDER TO PARTITA

	CREATE CURSOR CFINANZIAMENTI  	FROM ARRAY gaMyArray
	CREATE CURSOR CASSEGNI  		FROM ARRAY gaMyArray
	CREATE CURSOR CEFF_ATT  		FROM ARRAY gaMyArray
	CREATE CURSOR CCOLLABORATORI  	FROM ARRAY gaMyArray

  *** Piani di pagamento caricati
	CREATE CURSOR CPIANI_CARICATI (;
		PPA_NUMPPA C(6) ;
	)
	SELECT CPIANI_CARICATI
	INDEX ON PPA_NUMPPA TAG PPA_NUMPPA 
	SET ORDER TO PPA_NUMPPA	
	
ENDPROC




***************************	
* Procedure CONSOLIDA
***************************
PROCEDURE Consolida

	SELECT PAGATI
	SET ORDER TO PARTITA
	COPY TO TESORERIA_PAGATI
	
	do PrgPrint with "0","1","PAGATI","C:\Aquasql\report\lettera.frx"	
	
	SELECT MOVIMENTI 
	ZAP	
	

ENDPROC
****************************


***************************	
* Procedure Tabulati
***************************
PROCEDURE Tabulati

	USE TESORERIA_PAGATI IN 0 AGAIN
	*CreaLetteraWord("TESORERIA_PAGATI",4)
	DO PRG\DOC1

ENDPROC
****************************




****************************
PROCEDURE Tokenizer
*****************************
LPARAMETERS pStringa,pProprieta

LOCAL 	_valore,;
		_posizione,;
		_stringa,;
		_posizioneFinale

_valore=""
_stringa=pStringa
_posizione=AT(pProprieta+":",_stringa)
_posizioneFinale=0

IF _posizione>0
	*_stringa=SUBSTR(_stringa,_posizione+LEN(pProprieta+":"))
	_stringa=SUBSTR(_stringa,_posizione+LEN(pProprieta)+1)  && ERASMO - 21/06/2023
	_posizioneFinale=AT(";",_stringa)-1
	*_valore=ALLTRIM(SUBSTR(_stringa,1,_posizioneFinale))
	**=> ERASMO - INIZIO 10/01/2018
	IF SUBSTR(_stringa,1,1) = ";"  && CASO IN CUI IL VALORE DEVE ESSERE VOLUTAMENTE VUOTO
		_valore=""
	ELSE
		IF _posizioneFinale > 0
			_valore=ALLTRIM(SUBSTR(_stringa,1,_posizioneFinale))
		ELSE
			_valore=ALLTRIM(SUBSTR(_stringa,1))
		ENDIF
	ENDIF
	**=> ERASMO - FINE 10/01/2018
ENDIF


RETURN _valore
ENDPROC 



*****************************
PROCEDURE Colore
*****************************
LPARAMETERS pColore

LOCAL nValoreColore

nValoreColore=0

DO CASE
	CASE pColore="BIANCO"  	
		nValoreColore=RGB(255, 255, 255)	
	CASE pColore="NERO"  
		nValoreColore=RGB(0, 0, 0	     )
	CASE pColore="GRIGIO_CHIARO" 
		nValoreColore=RGB(192, 192, 192)
	CASE pColore="GRIGIO"  
		nValoreColore=RGB(128, 128, 128)
	CASE pColore="ROSSO"  
		nValoreColore=RGB(255, 0, 0	 )
	CASE pColore="BORDEAUX"  
		nValoreColore=RGB(128, 0, 0	 )
	CASE pColore="GIALLO"  
		nValoreColore=RGB(255, 255, 0	 )
	CASE pColore="GIALLO_CHIARO"  
		nValoreColore=RGB(255, 255, 128	 )
	CASE pColore="VERDE_OLIVA"  
		nValoreColore=RGB(128, 128, 0	 )
	CASE pColore="VERDE_LIMONE"  
		nValoreColore=RGB(0, 255, 0	 )
	CASE pColore="VERDE"  
		nValoreColore=RGB(0, 128, 0	 )
	CASE pColore="AZZURRO"  
		nValoreColore=RGB(0, 255, 255	 )
	CASE pColore="VERDE_ACQUA"  
		nValoreColore=RGB(0, 128, 128	 )
	CASE pColore="BLU"  
		nValoreColore=RGB(0, 0, 255	 )
	CASE pColore="BLU_SCURO"  
		nValoreColore=RGB(0, 0, 128	 )
	CASE pColore="FUCSIA"  
		nValoreColore=RGB(255, 0 ,255	 )
	CASE pColore="VIOLA"  
		nValoreColore=RGB(128, 0, 128	 )
	CASE pColore="PUFFO"  
		nValoreColore=RGB(128,128,255	 )
	CASE pColore="CELESTE"  
		nValoreColore=RGB(106,181,255)
	**=> ERASMO - INIZIO 18/03/2025
	CASE pColore="FUCSIA_CHIARO"
		nValoreColore=RGB(255,160,255)
	CASE pColore="ROSSO_CHIARO"
		nValoreColore=RGB(255,128,128)
	**=> ERASMO - FINE 18/03/2025
ENDCASE
RETURN nValoreColore

ENDPROC



***************************	
* Procedure MovimentiConsolidati
***************************	
PROCEDURE MovimentiConsolidati

LOCAL 	cColonnaCausale,;
		cContaCausali 

ON ERROR RETURN "???"

*** Crea cursore con colonne prese dalle righe della tabella TAB_CAUSALI
SELECT * ;
FROM TES_CAUSALI ;
ORDER BY CODCAUSALE ;
WHERE !DELETED() ;
INTO CURSOR CUR_CAUSALI

cColonnaCausale =SPACE(0)

SELECT ;
	T1.CODCAUSALE,;
	T1.ID_MOVIMEN,;
	T2.DESCAUSALE ;
FROM TES_MOVIMENTI AS T1 ;	
INNER JOIN TES_CAUSALI AS T2 ;
ON T1.CODCAUSALE =T2.CODCAUSALE ;
INTO CURSOR CUR_MOVI_CONS
	
SELECT CUR_CAUSALI
GO TOP
cContaCausali=1
DO WHILE !EOF()

	cColonnaCausale=ALLTRIM(CODCAUSALE)

	SELECT ;
		T1.* ,;
		T2.IMPORTO AS &cColonnaCausale ;
	FROM CUR_MOVI_CONS AS T1 ;
	LEFT OUTER JOIN TES_MOVIMENTI AS T2 ;
	ON 	T1.ID_MOVIMEN =T2.ID_MOVIMEN ;
		AND T1.CODCAUSALE = cColonnaCausale ;
	INTO CURSOR CUR_MOVI_CONS
	
	SELECT CUR_CAUSALI
	SKIP 
	LOOP
ENDDO
	
SELECT * ;
FROM CUR_MOVI_CONS AS T1 ;
GROUP BY T1.CODCAUSALE ;
ORDER BY T1.CODCAUSALE ;
INTO CURSOR CUR_MOVI_CONS

RETURN "CUR_MOVI_CONS"

ENDPROC




***************************	
* Procedure MoviEntrate
***************************	
PROCEDURE MoviEntrate

LOCAL 	cColonnaCausale,;
		cContaCausali ,;
		cColonne

ON ERROR RETURN "???"

*** Crea cursore con colonne prese dalle righe della tabella TAB_CAUSALI
SELECT * ;
FROM TES_CAUSALI ;
ORDER BY CODCAUSALE ;
WHERE !DELETED() ;
INTO CURSOR CUR_CAUSALI

SELECT ;
	T1.CODRISORSA,;
	T1.ID_MOVIMEN,;
	T1.CODCAUSALE ;
FROM TES_MOVIMENTI AS T1 ;	
INNER JOIN TES_CAUSALI AS T2 ;
ON T1.CODCAUSALE =T2.CODCAUSALE ;
WHERE T2.ENTRATA ;
INTO CURSOR CUR_MOVI_ENT

cColonnaCausale =SPACE(0)	
cColonne		=SPACE(0)
SELECT CUR_CAUSALI
GO TOP
cContaCausali=1
DO WHILE !EOF()
	
	IF !CUR_CAUSALI.ENTRATA
		SKIP 
		LOOP
	ENDIF

	cColonnaCausale=ALLTRIM(CODCAUSALE)

	SELECT ;
		T1.* ,;
		T2.IMPORTO AS &cColonnaCausale ;
	FROM CUR_MOVI_ENT AS T1 ;
	LEFT OUTER JOIN TES_MOVIMENTI AS T2 ;
	ON 	T1.ID_MOVIMEN =T2.ID_MOVIMEN ;
		AND T1.CODCAUSALE = cColonnaCausale ;
	INTO CURSOR CUR_MOVI_ENT

	cColonne=cColonne+cColonnaCausale+","
	
	SELECT CUR_CAUSALI
	SKIP 
	LOOP
ENDDO

cColonne=SUBSTR(cColonne,1,LEN(cColonne)-1)

RETURN "CUR_MOVI_ENT"

ENDPROC


***************************	
* Procedure MoviUscite
***************************	
PROCEDURE MoviUscite

LOCAL 	cColonnaCausale,;
		cContaCausali,;
		cColonne

ON ERROR RETURN "???"

*** Crea cursore con colonne prese dalle righe della tabella TAB_CAUSALI
SELECT * ;
FROM TES_CAUSALI ;
ORDER BY CODCAUSALE ;
WHERE !DELETED() ;
INTO CURSOR CUR_CAUSALI

SELECT ;
	T1.CODRISORSA,;
	T1.ID_MOVIMEN,;
	T1.CODCAUSALE ;
FROM TES_MOVIMENTI AS T1 ;	
INNER JOIN TES_CAUSALI AS T2 ;
ON T1.CODCAUSALE =T2.CODCAUSALE ;
WHERE !T2.ENTRATA ;
INTO CURSOR CUR_MOVI_USC

cColonnaCausale =SPACE(0)	
cColonne		=SPACE(0)
SELECT CUR_CAUSALI
GO TOP
cContaCausali=1
DO WHILE !EOF()
	
	IF CUR_CAUSALI.ENTRATA
		SKIP 
		LOOP
	ENDIF

	cColonnaCausale=ALLTRIM(CODCAUSALE)

	SELECT ;
		T1.* ,;
		T2.IMPORTO AS &cColonnaCausale ;
	FROM CUR_MOVI_USC AS T1 ;
	LEFT OUTER JOIN TES_MOVIMENTI AS T2 ;
	ON 	T1.ID_MOVIMEN =T2.ID_MOVIMEN ;
		AND T1.CODCAUSALE = cColonnaCausale ;
	INTO CURSOR CUR_MOVI_USC

	cColonne=cColonne+cColonnaCausale+","

	SELECT CUR_CAUSALI
	SKIP 
	LOOP
ENDDO

cColonne=SUBSTR(cColonne,1,LEN(cColonne)-1)

RETURN "CUR_MOVI_USC"

ENDPROC


***************************	
* Procedure MoviTotali
***************************	
PROCEDURE MoviTotali

ON ERROR RETURN "???"

LOCAL 	cCursorEntrate,;
		cSumColonneEntrate,;
		cCursorUscite,;
		cSumColonneUscite
		
PUBLIC 	aColonne

cCursorEntrate=MoviEntrate()

*** Costruico l'array dei campi colonna ENTRATE
SELECT * ;
FROM TES_CAUSALI ;
WHERE 	!DELETED() ;
		AND ENTRATA ;
INTO CURSOR CUR_CAUSALI

SELECT CUR_CAUSALI
GO TOP
cSumColonneEntrate=SPACE(0)
DO WHILE !EOF()
	cSumColonneEntrate=cSumColonneEntrate+" SUM("+ALLTRIM(CODCAUSALE)+") AS "+ALLTRIM(CODCAUSALE)+","
	SKIP
ENDDO
cSumColonneEntrate=SUBSTR(cSumColonneEntrate,1,LEN(cSumColonneEntrate)-1)

*** Costruico l'array dei campi colonna USCITE
cCursorUscite=MoviUscite()

SELECT * ;
FROM TES_CAUSALI ;
WHERE 	!DELETED() ;
		AND !ENTRATA ;
INTO CURSOR CUR_CAUSALI

SELECT CUR_CAUSALI
GO TOP
cSumColonneUscite=SPACE(0)
DO WHILE !EOF()
	cSumColonneUscite=cSumColonneUscite+" SUM("+ALLTRIM(CODCAUSALE)+") AS "+ALLTRIM(CODCAUSALE)+","
	SKIP
ENDDO
cSumColonneUscite=SUBSTR(cSumColonneUscite,1,LEN(cSumColonneUscite)-1)

SELECT ;
	T1.CODRISORSA,;
	T2.DESRISORSA,;
	&cSumColonneEntrate,;
	&cSumColonneUscite;
FROM TES_MOVIMENTI AS T1 ;	
INNER JOIN TES_RISORSE AS T2 ;
ON T1.CODRISORSA = T2.CODRISORSA ;
LEFT OUTER JOIN (cCursorEntrate) AS T3 ;
ON T1.ID_MOVIMEN =T3.ID_MOVIMEN ;
LEFT OUTER JOIN (cCursorUscite) AS T4 ;
ON T1.ID_MOVIMEN =T4.ID_MOVIMEN ;
ORDER BY T1.CODRISORSA ;
GROUP BY T1.CODRISORSA ;
INTO CURSOR CUR_MOVI_TOT 

RETURN "CUR_MOVI_TOT"

ENDPROC



**********************************************************
PROCEDURE Disponibilita
**********************************************************
	SELECT SALDI

	REPLACE DISPONIB WITH SALDO + FIDO ALL

	REPLACE DISPONIB2 WITH DISPONIB + ENT_ASS + ENT_BONI + ENT_TRAS -USC_ASS -USC_BONI -USC_TRAS ALL
	
	SUM ENT_ASS TO nTotaleEntrateAltro
	SUM ENT_BONI TO nTotaleEntrateBonifici
	SUM ENT_TRAS TO nTotaleEntrateTrasferimenti
	SUM USC_ASS TO nTotaleUsciteAltro
	SUM USC_BONI TO nTotaleUsciteBonifici
	SUM USC_TRAS TO nTotaleUsciteTrasferimenti
	SUM DISPONIB2 TO nTotaleEffettivo

	nTotaleEntrateAltro	=	nTotaleEntrateAltro	+	nTotaleEntrateBonifici
	nTotaleUsciteAltro	=	nTotaleUsciteAltro	+	nTotaleUsciteBonifici 
	
RETURN
**********************************************************

**********************************************************
PROCEDURE Crea_Movimento_Pagamento
**********************************************************
PARAMETERS pTipoMovimento,pDesMovimento,pLinkPagamento

LOCAL 	cCONTO_DA,;
		cCONTO_A,;
		cDES_DA,;
		cDES_A,;
		cIMPORTO

	
		
	SELECT SALDI
	*cCONTO_DA	= CODRISORSA
	cCONTO_DA	= CONTOCONT
	cDES_DA		= DESRISORSA
	_CONTOCONT	= CONTOCONT 
	_CONTOCORR	= CC
	_BANCA		= CODRISORSA
	_ABI		= ABI
	_CAB		= CAB
	_CIN		= CIN

	SELECT PAGAMENTI
	cIMPORTO	= NSALDO
	cDES_A		= RAGSOC
	cCONTO_A	= CODFOR
	_dtscad		= dtscad
	_NPART		= NPART
	_CODFOR		= CODFOR
	_QUANTAVALU	= NSALDO
	_QUANDOVALU = dtscad
    _tipopagam 	= tipopagam 
    _cosatratta = cosatratta	
    _gradoimpor = gradoimpor	
    _formapagam = formapagam	
    _tipocontra = tipocontra	
    _codacq 	= codacq    	
    _pripaga 	= pripaga  
    _TIPOLOGIA  = TIPOLOGIA 	
    _NUMEROFATT = NUMEROFATT
    _DATAFATT   = DATAFATT  && ERASMO - 02/08/2017

    ***INIZIA >>> ricava dati banca fornitore **************************************************
	_CODICE_FORNITORE=CODFOR 

	_ER = SOTTOGEN("ITA")
	IF !_ER
	   	_CC = PUB_FF
	ENDIF 
	_X_CODFOR=SUBSTR(_CODICE_FORNITORE,LEN(PUB_FF)+1)
	

	cSql="SELECT * FROM U_FOR_AN WHERE FOR_CODCLI='"+_X_CODFOR+"'"
   	IF !ExecCommand(cSql,"cur_forn")
			return(.f.)
	ENDIF
	
	SELECT cur_forn
	_CC_FORNIT	= FOR_NUMCOC
    _ABI_FORNIT = FOR_CODABI
    _CAB_FORNIT = FOR_CODCAB
    _CIN_FORNIT = FOR_CODCIN
    
    ***FINE >>> ricava dati banca fornitore **************************************************

    Crea_Movimento(cCONTO_DA,cDES_DA,cCONTO_A,cDES_A,pTipoMovimento,pDesMovimento,cIMPORTO,pLinkPagamento,_dtscad,_dtscad)
	
	SELECT MOVIMENTI
	REPLACE 	BANCA  		WITH _BANCA,;
				CONTOCONT	WITH _CONTOCONT,;
				CONTOCORR	WITH _CONTOCORR,;
				QUANTAVALU	WITH _NSALDO,;
				QUANDOVALU	WITH _QUANDOVALU,;
				NPART		WITH _NPART,;
				NUMEROFATT  WITH _NUMEROFATT,;
				DATAFATT	WITH _DATAFATT,;
				DTSCAD		WITH _dtscad,;
				codfor		WITH _CODFOR, ;
				tipopagam   WITH _tipopagam ,;
				cosatratta  WITH _cosatratta,;
				gradoimpor  WITH _gradoimpor,;
				formapagam  WITH _formapagam,;
				tipocontra  WITH _tipocontra,;
				codacq      WITH _codacq    ,;
				pripaga     WITH _pripaga   ,;
				TIPOLOGIA	WITH _TIPOLOGIA ,;
				ABI         WITH _ABI_FORNIT,;
                CAB         WITH _CAB_FORNIT,;
	            CIN         WITH _CIN_FORNIT
	            	            
    * sposto la partita dai pagamenti (da fare) a PAGATI
	SELECT PAGAMENTI
	SCATTER MEMVAR
	
	SELECT PAGATI
	APPEND BLANK
	GATHER MEMVAR
	REPLACE 	BANCA  		WITH _BANCA,;
				CONTOCONT	WITH _CONTOCONT,;
				CONTOCORR	WITH _CONTOCORR,;
				QUANTAVALU	WITH NSALDO,;
				QUANDOVALU	WITH DTSCAD,;
				SELEZIONE	WITH SPACE(0)
	
	
	SELECT PAGAMENTI
	DELETE	

ENDPROC
**********************************************************


**********************************************************
PROCEDURE Crea_Movimento
**********************************************************
PARAMETERS 	pContoDa,;
			pDesContoDa,;
			pContoA,;
			pDesContoA,;
			pTipoMovimento,;
			pDesMovimento,;
			pImporto,;
			pLinkPagamento,;
			pDataDispon,;
			pDataContab

LOCAL		cDT_DISPON,;
			cDT_CONTAB,;
			cAliasCorrente,;
			_id_movimen

cAliasCorrente=SELECT()

	SELECT PAGAMENTI
	_NPART=NPART

	IF PCOUNT()<8
		_id_movimen=SYS(2015)
    ELSE
    	IF pLinkPagamento=""
			_id_movimen=SYS(2015)
		ELSE
			_id_movimen=pLinkPagamento
		ENDIF			
	ENDIF

	IF PCOUNT()<10
		cDT_CONTAB	=DTOC(DATE())
	ELSE
		cDT_CONTAB	=pDataContab
	ENDIF

	IF PCOUNT()<9
		cDT_DISPON	=DTOC(DATE())
	ELSE
		cDT_DISPON	=pDataDispon	
	ENDIF
	
	SELECT MOVIMENTI
	APPEND BLANK
	
	
	REPLACE ID_MOVIMEN  WITH _id_movimen,;
			CODRIS_DA 	WITH pContoDa,;
			CODRIS_A  	WITH pContoA,;
			DES_DA  	WITH pDesContoDa,;
			DES_A  		WITH pDesContoA,;
			CODCAUSALE 	WITH pTipoMovimento,;
			DES_MOVIME	WITH pDesMovimento,;
			IMPORTO		WITH pImporto,;
			DT_DISPON	WITH cDT_DISPON,;
			DT_CONTAB	WITH cDT_CONTAB,;
			NPART		WITH _NPART


SELECT(cAliasCorrente)

ENDPROC
**********************************************************


**********************************************************
PROCEDURE Annulla_Movimento
**********************************************************
LOCAL		cAliasCorrente,;
			_id_movimen,;
			_CODRIS_DA,;
			_CODRIS_A,;
			_IMPORTO,;
			_TIPOLOGIA

cAliasCorrente=SELECT()


SELECT MOVIMENTI
_id_movimen=ALLTRIM(ID_MOVIMEN)
_CODRIS_DA= ALLTRIM(CODRIS_DA)
_CODRIS_A = ALLTRIM(CODRIS_A)
_IMPORTO  = IMPORTO
_TIPOLOGIA= ALLTRIM(TIPOLOGIA)

* CANCELLO IL MOVIMENTO DAL CURSOR MOVIMENTI
DELETE

DO CASE
	CASE CODCAUSALE="USC_TRAS"	
		
		* RIPORTO LE RISORSE ALLA LORO CONDIZIONE
		* PRECEDENTE AL MOVIMENTO:
		*
		* RISORSA-DI-PARTENZA AUMENTA IL SUO SALDO DEL VALORE DI _IMPORTO	
		* RISORSA-DI-ARRIVO DIMINUISCE IL SUO SALDO DEL VALORE DI _IMPORTO	
		
		SELECT SALDI
		SET ORDER TO CONTOCONT
		
		* AUMENTO IL SALDO DELLA RISORSA DI PARTENZA
		SEEK _CODRIS_DA
		IF FOUND()
			REPLACE USC_TRAS WITH USC_TRAS-_IMPORTO,;
					DISPONIB2 WITH DISPONIB2+_IMPORTO
		ENDIF
		
		* DIMINUISCO IL SALDO DELLA RISORSA DI ARRIVO
		SEEK _CODRIS_A
		IF FOUND()
			REPLACE ENT_TRAS WITH ENT_TRAS-_IMPORTO,;
					DISPONIB2 WITH DISPONIB2-_IMPORTO
		ENDIF

		SET ORDER TO DESRISORSA				
		
	OTHERWISE
		* SE NON E' UN MOVIMENTO DI TRASFERIMENTO FONDI DEVO MODIFICARE
		* ANCHE I CURSOR DEI "DA PAGARE" E DEI "PAGATI" SPOSTANDO LA 
		* PARTITA DA "PAGATI" A "DA PAGARE"
		* INOLTRE COME SOPRA RIPORTO IL SALDO DELLA BANCA DI PARTENZA 
		* ALLA CONDIZIONE PRIMA DEL MOVIMENTO (AUMENTO IL SALDO DEL VALORE DI _IMPORTO)
		
		* LEGGO I DATI DELLA PARTITA NEL RECORD DI "PAGATI"
		SELECT PAGATI
		SET ORDER TO ID_PARTITA
		SEEK _id_movimen

		IF FOUND()
			SCATTER MEMVAR MEMO
			* CANCELLO LA PARTITA DAL CURSOR DEI "PAGATI" E....		
			DELETE
			SET ORDER TO PARTITA
		ENDIF
		
		
		* ...LA RIPORTO IDENTICA NEL CURSOR DEI "DA PAGARE"
		SELECT PAGAMENTI
		APPEND BLANK
		GATHER MEMVAR MEMO
		REPLACE SELEZIONE WITH SPACE(0)
		
		* RIPORTO LE RISORSE ALLA LORO CONDIZIONE
		* PRECEDENTE AL MOVIMENTO:
		*
		* RISORSA-DI-PARTENZA AUMENTA IL SUO SALDO DEL VALORE DI _IMPORTO	
		
		SELECT SALDI
		SET ORDER TO CONTOCONT
		
		* AUMENTO IL SALDO DELLA RISORSA DI PARTENZA
		SEEK _CODRIS_DA

		IF _TIPOLOGIA="EFF.PASS." OR _TIPOLOGIA="EFF.ATT."
		
			IF _IMPORTO<0		&& E' UNPAGAMENTO
				REPLACE USC_ASS WITH USC_ASS-ABS(_IMPORTO),;
						DISPONIB2 WITH DISPONIB2+ABS(_IMPORTO)
			ELSE				&& E' UN ACCREDITO
				REPLACE ENT_ASS WITH ENT_ASS-_IMPORTO,;
						DISPONIB2 WITH DISPONIB2-_IMPORTO
			ENDIF

		ELSE
			IF _IMPORTO<0		&& E' UNPAGAMENTO
				REPLACE USC_BONI WITH USC_BONI-ABS(_IMPORTO),;
						DISPONIB2 WITH DISPONIB2+ABS(_IMPORTO)
			ELSE				&& E' UN ACCREDITO
				REPLACE ENT_BONI WITH ENT_BONI-_IMPORTO,;
						DISPONIB2 WITH DISPONIB2-_IMPORTO
			ENDIF
		
		ENDIF
									
		SET ORDER TO DESRISORSA				
		GO TOP
		
ENDCASE		



SELECT SALDI
GO TOP

SELECT PAGAMENTI
GO TOP

SELECT PAGATI
GO TOP

SELECT(cAliasCorrente)

ENDPROC
**********************************************************

**********************************************************
PROCEDURE Crea_Movi_Trasf_Fondi
**********************************************************
PARAMETERS pTipoMovimento,pDesMovimento,pContoDa,pDesContoDa,pContoA,pDesContoA,pImporto

LOCAL 	cCONTODA,;
		cCONTOA,;
		cCODCAUSALE,;
		cDES_MOVIME,;
		cIMPORTO,;
		cDT_CONTAB,;
		cDES_DA,;
		cDES_A

	* Crea movimento di entrata trasferimento

	cCONTODA	= pContoDa
	cCONTOA		= pContoA
	cDES_DA		= pDesContoDa
	cDES_a		= pDesContoA
	cCODCAUSALE	= "USC_TRAS"
	cDES_MOVIME	= pDesMovimento
	cIMPORTO	= pImporto
	cDT_CONTAB	= RIBALTA2(_DATA_VALUTA)
	
	_BANCA		= pContoA
	_CONTOCONT	= pContoA
	_CONTOCORR	= pContoA
	_QUANTAVALU = pImporto
	_QUANDOVALU = RIBALTA2(_DATA_VALUTA)
	_NPART		= 0		 
	_NUMEROFATT = ""
	_DATAFATT   = ""  && ERASMO - 02/08/2017
	_DTSCAD		= RIBALTA2(_DATA_VALUTA)
	_codfor	    = pContoDa
	
	*** SELEZIONA BANCA DI DESTINAZIONE
	SELECT 	* FROM SALDI WHERE CONTOCONT=_CONTOCONT INTO CURSOR CBAN_DEST
	SELECT CBAN_DEST
	_ABI=ABI
	_CAB=CAB
	_CIN=CIN
		
	SELECT MOVIMENTI
	APPEND BLANK
	
	REPLACE ID_MOVIMEN  WITH SYS(2015),;
			CODRIS_DA 	WITH cCONTODA,;
			CODRIS_A  	WITH cCONTOA,;
			DES_DA  	WITH cDES_DA,;
			DES_A  		WITH cDES_A,;
			CODCAUSALE 	WITH cCODCAUSALE,;
			DES_MOVIME	WITH cDES_MOVIME,;
			IMPORTO		WITH cIMPORTO,;
			DT_DISPON	WITH cDT_CONTAB,;
			DT_CONTAB	WITH cDT_CONTAB,;
			BANCA  		WITH _BANCA	    ,;
			CONTOCONT	WITH _CONTOCONT ,;
			CONTOCORR	WITH _CONTOCORR ,;
			QUANTAVALU	WITH _QUANTAVALU,;
			QUANDOVALU	WITH _QUANDOVALU,;
			NPART		WITH _NPART	    ,;
			NUMEROFATT  WITH _NUMEROFATT,;
			DATAFATT	WITH _DATAFATT,;
			DTSCAD		WITH _DTSCAD	,;   
			codfor		WITH _codfor	,;
			TIPOLOGIA   WITH "TRAS-FONDI",;
			ABI         WITH _ABI,;
            CAB         WITH _CAB,;
            CIN         WITH _CIN
	SELECT MOVIMENTI
	GO TOP			
			
ENDPROC
**********************************************************


**********************************************************
* Metodo PROCEDURE StatoTransazioneCelle
**********************************************************
PROCEDURE StatoTransazioneCelle

	PARAMETERS 	pGriglia,;
				pRiga,;
				pColonna,;
				_RECORD_CORRENTE

	LOCAL _NUM_REC_LETTI

	&& ho cliccato ora la cella di partenza
	IF !CliccataPartenza
		
		SELECT PAGAMENTI
		
		IF (NDARE - NAVERE>0)			
			MESSAGEBOX("E' STATO SELEZIONATO UN MOVIMENTO IN DARE CHE NON CORRISPONDE AD UN PAGAMENTO."+CHR(13)+"EFFETTUARE UNA NUOVA SELEZIONE PRENDENDO UNA PARTITA IN AVERE",48,"ATTENZIONE")
			REPLACE SELEZIONE WITH ""
			RETURN 0				
		ENDIF
				
		* stato 2
		GrigliaDiPartenza=pGriglia
		GrigliaDiArrivo=pGriglia
		
		RigaCellaDiPartenza=pRiga
		IF GrigliaDiPartenza="GrigliaRisorse"
			RigaCellaDiPartenza=RECNO()
		ENDIF
		
		ColonnaCellaDiPartenza=pColonna
		CliccataPartenza=.T.
		CliccatoArrivo=.F.
		
		RETURN 2 	&& STATO_SELEZIONATA_PARTENZA_TRANSAZIONE
	ENDIF
	
	
	&& ho cliccato ora la cella di arrivo
	* stato 3
	GrigliaDiArrivo=pGriglia
	RigaCellaDiArrivo=pRiga
	IF GrigliaDiPartenza="GrigliaRisorse"
		RigaCellaDiArrivo=RECNO()
	ENDIF
	ColonnaCellaDiArrivo=pColonna
	CliccataPartenza=.T.
	CliccatoArrivo=.T.

	&& Quali sono le transazioni accettate?
	DO CASE
		&& Traferimento di forndi tra due risorse
		CASE GrigliaDiPartenza="GrigliaRisorse" AND GrigliaDiArrivo ="GrigliaRisorse"
    	
			RELEASE pubVecchioImporto,pubNuovoImporto,pubRimanenteImporto,pubContoDa,pubContoA,_DATA_VALUTA
			PUBLIC  pubVecchioImporto,pubNuovoImporto,pubRimanenteImporto,pubContoDa,pubContoA,_DATA_VALUTA

			SELECT SALDI
			GO RigaCellaDiArrivo
			pubContoA=ALLT(CONTOCONT)+" - "+DESRISORSA
			
			SELECT SALDI
			GO RigaCellaDiPartenza
			pubContoDA			=ALLT(CONTOCONT)+" - "+DESRISORSA
			pubVecchioImporto	=SALDI.DISPONIB2
			pubNuovoImporto		=0
			pubRimanenteImporto	=pubVecchioImporto
			
			DO FORM trasfer_fondi
    		
			IF	pubNuovoImporto=0
				RELEASE pubVecchioImporto,pubNuovoImporto,pubRimanenteImporto
				TESORERIA.cntTastiera.TASTO_ANNULLA.click()
				RETURN 4 	&& STATO_FINE_TRANSAZIONE
			ENDIF
    		
			*** conto di partenza
			SELECT SALDI
			GO RigaCellaDiPartenza
			cContoDa	= SALDI.CONTOCONT
			cDesContoDa = SALDI.DESRISORSA+" "+SALDI.CC
			REPLACE USC_TRAS WITH USC_TRAS+pubNuovoImporto
			
    		
			*** conto di partenza
			SELECT SALDI
			GO RigaCellaDiArrivo
			REPLACE ENT_TRAS WITH ENT_TRAS+pubNuovoImporto
    		
			cContoA		= SALDI.CONTOCONT
			cDesContoA	= SALDI.DESRISORSA+" "+SALDI.CC
    		
			DO Crea_Movi_Trasf_Fondi WITH ;
				"USC_TRAS",;
				"TRAS-FONDI",;
				cContoDa,;
				cDesContoDa,;
				cContoA,;
				cDesContoA,;
				pubNuovoImporto
    		
			DO 	Disponibilita		
			
			RELEASE pubVecchioImporto,pubNuovoImporto,pubRimanenteImporto,pubContoDa,pubContoA,_DATA_VALUTA
		
		&& Pagamento partita
		CASE GrigliaDiPartenza="GrigliaPagamenti" AND GrigliaDiArrivo ="GrigliaRisorse"
		
			*** INIZIO ELABORA COMPENSAZIONE PARZIALE
			SELECT PAGAMENTI
			
			IF TIPOLOGIA="COMP"
				*** HO SELEZIONATO UNA PARTITA DI COMPENSAZIONE
				*** MODIFICO GLI IMPORTI NON COMPENSATI
					
					SELECT SALDI
					RELEASE ___codban,___DESBAN
					PUBLIC  ___codban,___DESBAN
					___codban=CONTOCONT
					___DESBAN=""
	
					DO CONTABCOMP WITH .F.

					SELECT CESITOCOMP
					
					_MASTRO_FORNITORI = SUBSTR(PUB_FF,1,2)
   					_MASTRO_CLIENTI	  = SUBSTR(PUB_CC,1,2)	
					
					SET FILTER TO SUBSTR(CONTO,1,LEN(ALLTRIM(_MASTRO_FORNITORI)))=ALLTRIM(_MASTRO_FORNITORI) OR SUBSTR(CONTO,1,LEN(ALLTRIM(_MASTRO_CLIENTI)))=ALLTRIM(_MASTRO_CLIENTI)
					GO TOP
 					DO prg\TESORERIA_COMPVIEW WITH "CESITOCOMP","Compensazione partite ed eventuali pagamenti/incassi",;
 						"NPART:N.partita;CLIFOR:Cli/For;CONTO:Conto;TOP:Top,W:4;DARE:Dare,W:15,READONLY:NO;AVERE:Avere,W:15,READONLY:NO;DESMOV:Descrizione;",500,900,.F.
 						
					_DARE_COMPENSAZIONI=0
					_AVERE_COMPENSAZIONI=0
					SUM DARE TO _DARE_COMPENSAZIONI 
					SUM AVERE TO _AVERE_COMPENSAZIONI
					
					************************
					
					SELECT CESITOCOMP
					=AFIELDS(_ARRAY_CUR_COMP)			
					CREATE CURSOR COMP2WORD FROM ARRAY 	_ARRAY_CUR_COMP
									
					SELECT CESITOCOMP
					GO TOP
					DO WHILE !EOF()
						IF DELETED()
							SKIP
							LOOP
						ENDIF
						
						IF EMPTY(DESCRI)
							SKIP
							LOOP
						ENDIF
						
						SCATTER MEMVAR
						
						SELECT COMP2WORD
						APPEND BLANK
						GATHER MEMVAR
						
						_NOTA_DA_PAGARE=""
						
						IF (DARE=0 AND AVERE=0)
							
							IF SALDO>0 
								REPLACE DARE WITH SALDO
								REPLACE AVERE WITH 0
							ELSE
								REPLACE DARE WITH 0
								REPLACE AVERE WITH ABS(SALDO)
							ENDIF

							_NOTA_DA_PAGARE="* "
							
						ENDIF
							
						REPLACE DESMOV WITH _NOTA_DA_PAGARE + SUBSTR(DESMOV,1,LEN("COMPENSAZIONE AUTOMATICA"))
						
						SELECT CESITOCOMP
						SKIP
						
					ENDDO				
					
					
					*******************
					
					SELECT CESITOCOMP
					SET ORDER TO 
					SET FILTER TO 
					GO TOP
					_ALERT_MODIFICA=.F.
					_DARE_MODIFICA=0
					_AVERE_MODIFICA=0
					
					DO WHILE !EOF()
						
						IF _ALERT_MODIFICA
							REPLACE DARE  WITH _AVERE_MODIFICA
							REPLACE AVERE WITH _DARE_MODIFICA
							REPLACE SALDO WITH DARE-AVERE

							_ALERT_MODIFICA=.F.
							_DARE_MODIFICA=0
							_AVERE_MODIFICA=0
							SKIP
							LOOP
						ENDIF
					
						IF (ABS(DARE)!=ABS(SALDO) AND ABS(AVERE)!=ABS(SALDO)) OR  (DARE=0 AND AVERE=0) OR (SALDO=0)
							REPLACE SALDO WITH DARE-AVERE
							_ALERT_MODIFICA=.T.
							_DARE_MODIFICA=DARE
							_AVERE_MODIFICA=AVERE
						ENDIF
						
						SKIP
					ENDDO
					
					SELECT PAGAMENTI
					REPLACE NDARE WITH _AVERE_COMPENSAZIONI 
					REPLACE NAVERE WITH _DARE_COMPENSAZIONI
					REPLACE NSALDO WITH _AVERE_COMPENSAZIONI-_DARE_COMPENSAZIONI
					
					SELECT CESITOCOMP
					GO TOP								

					RELEASE ___codban,___DESBAN
										
			ENDIF		
			*** FINE ELABORA COMPENSAZIONE PARZIALE
		
			SELECT PAGAMENTI
			*  seleziono il record corrente che sicuramente verra' pagato
			_RECORD_CORRENTE=RECNO()

			SELECT SUM(NSALDO) AS NSALDO FROM PAGAMENTI INTO ARRAY _SOMMA_SALDO WHERE !EMPTY(SELEZIONE) OR RECNO()=_RECORD_CORRENTE 
			
			SELECT SALDI
			_DISPONIB2=DISPONIB2
			
			IF _SOMMA_SALDO<0 AND ABS(_SOMMA_SALDO)>_DISPONIB2
*** FABIANO 26/01/2006 - POSSIBILITA' DI SALDI NEGATIVI						
***				MESSAGEBOX("Impossibile pagare importo superiore alla disponibilità."+CHR(13)+"Selezionare un'altra banca.",48,"Pagamento non possibile!")
				MESSAGEBOX("Attenzione, si sta effettuando il pagamento di un importo superiore alla disponibilità.",48,"Disponibilità insufficiente")
			ENDIF
***			ELSE

				SELECT PAGAMENTI
				*** SALVO L'ALIAS DELL'INDICE CORRENTE PERCHE' DEVO MODIFICARE I DATI DEL CURSOR IN RUNTIME
				*** E SE MODIFICO LA CHIAVE DELL'INDICE POTREBBE SALTARE LA LOGICA DI SCORRIMENTO DEL CICLO
				*** ALLA FINE DEL CICLO RIFACCIO --> SET ORDER TO _ORDER_CORRENTE + GO _RECORD_CORRENTE
				_ORDER_CORRENTE = ORDER()
				SET ORDER TO
				GO TOP
				
			
				DO WHILE !EOF()
	
					IF EMPTY(SELEZIONE) AND RECNO()!=_RECORD_CORRENTE
						SKIP
						LOOP
					ENDIF
					
					***############################ GESTIONE RICEVUTE   ############################
					*** BLOCCO PAGAMENTO SU BANCA DIFFERENTE DA BANCA IMPOSTATA IN RICEVUTA
					
					SELECT PAGAMENTI

					IF ALLTRIM(TIPOLOGIA)="RICEV"
						
						_CHK_RICEVUTE_BANCA_PAGAMENTI=ALLTRIM(BANCA)
						
						SELECT SALDI
						_CHK_RICEVUTE_BANCA_RISORSE=ALLTRIM(CODRISORSA)
					
						IF _CHK_RICEVUTE_BANCA_PAGAMENTI<>_CHK_RICEVUTE_BANCA_RISORSE
							
							MESSAGEBOX("Impossibile effettuare il pagamento tramite un conto corrente diverso da quello impostato nella partita.",48,"Pagamento ricevuta")
						
							SELECT PAGAMENTI
							SKIP 
							LOOP
						ENDIF
						
					ENDIF					
					
					
					***############################ GESTIONE EFFETTI ATTIVI   ############################à
					*** ELENCO PARTITE DA ASSOCIARE AGLI EFFETTI ATTIVI
					
					SELECT PAGAMENTI

					IF ALLTRIM(TIPOLOGIA)="EFF.ATT."
					
						IF NPART=0
							_EP_CODFOR=codfor
							_EP_RAGSOC=RAGSOC
							_EP_NSALDO=NSALDO
							_EP_DTSCAD=DTSCAD
							
							_NUM_REC_LETTI=	SELE_APERTE_CLI (GETCONTOCONTABILECLI(_EP_CODFOR),_EP_RAGSOC,_EP_NSALDO,_EP_DTSCAD)
							
							IF _NUM_REC_LETTI<>1
								SELECT PAGAMENTI
								SKIP 
								LOOP
							ENDIF
							
							IF CHECK_NPART_GIA_ASSEGNATO()
								SELECT WORK 
								______NPART=WPART 		
								______NUMEROFATT = WNUMFAT
								______DATAFATT = WDATFAT  && ERASMO - 02/08/2017
								
								SELECT PAGAMENTI
								REPLACE NPART WITH VAL(______NPART)
								REPLACE NUMEROFATT WITH ______NUMEROFATT
								REPLACE DATAFATT WITH ______DATAFATT  && ERASMO - 02/08/2017
							ELSE
								SELECT PAGAMENTI
								SKIP 
								LOOP
							ENDIF
							
						ENDIF
						
					ENDIF					
					
					***############################ GESTIONE EFFETTI PASSIVI  ############################à
					*** ELENCO PARTITE DA ASSOCIARE AGLI EFFETTI PASSIVI
					
					SELECT PAGAMENTI
					
					IF ALLTRIM(TIPOLOGIA)="EFF.PASS."
					
					*** BLOCCO PAGAMENTO SU BANCA DIFFERENTE DA BANCA IMPOSTATA IN PARTITA
						_CHK_RICEVUTE_BANCA_PAGAMENTI=ALLTRIM(BANCA)
						
						SELECT SALDI
						_CHK_RICEVUTE_BANCA_RISORSE=ALLTRIM(CODRISORSA)
					
						IF _CHK_RICEVUTE_BANCA_PAGAMENTI<>_CHK_RICEVUTE_BANCA_RISORSE
							
							MESSAGEBOX("Impossibile effettuare il pagamento tramite un conto corrente diverso da quello impostato nella partita.",48,"Pagamento ricevuta")
						
							SELECT PAGAMENTI
							SKIP 
							LOOP
						ENDIF
						
						SELECT PAGAMENTI
						
						IF NPART=0
							_EP_CODFOR=codfor
							_EP_RAGSOC=RAGSOC
							_EP_NSALDO=NSALDO
							_EP_DTSCAD=DTSCAD
							
							_NUM_REC_LETTI=	SELE_APERTE_FOR (GETCONTOCONTABILEFOR(_EP_CODFOR),_EP_RAGSOC,_EP_NSALDO,_EP_DTSCAD)
							
							IF _NUM_REC_LETTI<>1
								SELECT PAGAMENTI
								SKIP 
								LOOP
							ENDIF
							
							IF CHECK_NPART_GIA_ASSEGNATO()
								SELECT WORK 
								______NPART=WPART 		
								______NUMEROFATT = WNUMFAT
								______DATAFATT = WDATFAT  && ERASMO - 02/08/2017
								
								SELECT PAGAMENTI
								REPLACE NPART WITH VAL(______NPART)
								REPLACE NUMEROFATT WITH ______NUMEROFATT
								REPLACE DATAFATT WITH ______DATAFATT  && ERASMO - 02/08/2017
							ELSE
								SELECT PAGAMENTI
								SKIP 
								LOOP
							ENDIF
						ENDIF
						
					ENDIF


					***############################ GESTIONE CONTRATTI  ############################à
					*** ELENCO PARTITE DA ASSOCIARE AI CONTRATTI
					
					SELECT PAGAMENTI
					
					IF ALLTRIM(TIPOLOGIA)="CONTRATTO"
					
						IF NPART=0
							_EP_CODFOR=codfor
							_EP_RAGSOC=RAGSOC
							_EP_NSALDO=NSALDO
							_EP_DTSCAD=DTSCAD
							
							_NUM_REC_LETTI=	SELE_APERTE_FOR (GETCONTOCONTABILEFOR(_EP_CODFOR),_EP_RAGSOC,_EP_NSALDO,_EP_DTSCAD)
							
							IF _NUM_REC_LETTI<>1
								SELECT PAGAMENTI
								SKIP 
								LOOP
							ENDIF
							
							IF CHECK_NPART_GIA_ASSEGNATO()
								
								SELECT WORK 
								______NPART=WPART 		
								______NUMEROFATT = WNUMFAT
								______DATAFATT = WDATFAT  && ERASMO - 02/08/2017
								
								SELECT PAGAMENTI
								REPLACE NPART WITH VAL(______NPART)
								REPLACE NUMEROFATT WITH ______NUMEROFATT
								REPLACE DATAFATT WITH ______DATAFATT  && ERASMO - 02/08/2017
							ELSE
								SELECT PAGAMENTI
								SKIP 
								LOOP
							ENDIF
						ENDIF
						
					ENDIF
					
					***############################ GESTIONE LEASING  ############################à
					*** ELENCO PARTITE DA ASSOCIARE AI LEASING  
					
					SELECT PAGAMENTI
					
					IF ALLTRIM(TIPOLOGIA)="LEASING"
					
						IF NPART=0
							_EP_CODFOR=codfor
							_EP_RAGSOC=RAGSOC
							_EP_NSALDO=NSALDO
							_EP_DTSCAD=DTSCAD
							
							_NUM_REC_LETTI=	SELE_APERTE_FOR (GETCONTOCONTABILEFOR(_EP_CODFOR),_EP_RAGSOC,_EP_NSALDO,_EP_DTSCAD)
							
							IF _NUM_REC_LETTI<>1
								SELECT PAGAMENTI
								SKIP 
								LOOP
							ENDIF
							
							IF CHECK_NPART_GIA_ASSEGNATO()
								SELECT WORK 
								______NPART=WPART 		
								______NUMEROFATT = WNUMFAT
								______DATAFATT = WDATFAT  && ERASMO - 02/08/2017
								
								SELECT PAGAMENTI
								REPLACE NPART WITH VAL(______NPART)
								REPLACE NUMEROFATT WITH ______NUMEROFATT
								REPLACE DATAFATT WITH ______DATAFATT  && ERASMO - 02/08/2017
							ELSE
								SELECT PAGAMENTI
								SKIP 
								LOOP
							ENDIF
							
						ENDIF
						
					ENDIF

					
					***############################ GESTIONE FINANZIAMENTI   ############################à
					*** ELENCO PARTITE DA ASSOCIARE AI FINANZIAMENTI     
					
* 					SELECT PAGAMENTI
* 					
* 					IF ALLTRIM(TIPOLOGIA)="FINANZIAMENTO"
* 					
* 						IF NPART=0
* 							_EP_CODFOR=codfor
* 							_EP_RAGSOC=RAGSOC
* 							_EP_NSALDO=NSALDO
* 							_EP_DTSCAD=DTSCAD
* 							
* 							_NUM_REC_LETTI=	SELE_APERTE_FOR (GETCONTOCONTABILEFOR(_EP_CODFOR),_EP_RAGSOC,_EP_NSALDO,_EP_DTSCAD)
* 							
* 							IF _NUM_REC_LETTI<>1
* 								SELECT PAGAMENTI
* 								SKIP 
* 								LOOP
* 							ENDIF
* 							
* 							IF CHECK_NPART_GIA_ASSEGNATO()
* 								SELECT WORK 
* 								______NPART=WPART 		
* 								______NUMEROFATT = WNUMFAT		
* 								
* 								SELECT PAGAMENTI
* 								REPLACE NPART WITH VAL(______NPART)
*								REPLACE NUMEROFATT WITH ______NUMEROFATT
* 							ELSE
* 								SELECT PAGAMENTI
* 								SKIP 
* 								LOOP
* 							ENDIF
* 						ENDIF
* 						
* 					ENDIF
					
					
					***############################ FINE GESTIONE ############################
					
					
					*** CREA I MOVIMENTI
					_NSALDO=NSALDO
					_RAGSOC=RAGSOC
					_ID_PARTITA =ID_PARTITA
					_NPART =NPART
					_CODFOR=CODFOR
					_TIPOLOGIA=TIPOLOGIA
					
					SELECT SALDI
					IF _NSALDO>0
						IF ALLTRIM(_TIPOLOGIA)="EFF.PASS." OR ALLTRIM(_TIPOLOGIA)="EFF.ATT."
							REPLACE ENT_ASS WITH ENT_ASS+_NSALDO
							DO Crea_Movimento_Pagamento WITH "ENT_ASS",ALLT(_TIPOLOGIA)+" "+ALLT(STR(_NPART)),_ID_PARTITA
						ELSE
							REPLACE ENT_BONI WITH ENT_BONI+_NSALDO
							DO Crea_Movimento_Pagamento WITH "ENT_BONI",ALLT(_TIPOLOGIA)+" "+ALLT(STR(_NPART)),_ID_PARTITA
						ENDIF			
				    ELSE
						IF ALLTRIM(_TIPOLOGIA)="EFF.PASS." OR ALLTRIM(_TIPOLOGIA)="EFF.ATT."
							REPLACE USC_ASS WITH USC_ASS+ABS(_NSALDO)
							DO Crea_Movimento_Pagamento WITH "USC_ASS",ALLT(_TIPOLOGIA)+" "+ALLT(STR(_NPART)),_ID_PARTITA
						ELSE			
							REPLACE USC_BONI WITH USC_BONI+ABS(_NSALDO)
							DO Crea_Movimento_Pagamento WITH "USC_BONI",ALLT(_TIPOLOGIA)+" "+ALLT(STR(_NPART)),_ID_PARTITA
						ENDIF
					ENDIF
				
					SELECT PAGAMENTI
					SKIP
											
				ENDDO
				
				*** SELEZIONO I PAGAMENTI E RE-IMPOSTO L'ORDER SALVATO PRIMA DEL CICLO + GO _RECORD_CORRENTE
				*** COSI' LA VISUALIZZAZIONE DELLA GRIGLIA SARA' CONSERVATA IDENTICA A PRIMA
				SELECT PAGAMENTI
				SET ORDER TO &_ORDER_CORRENTE
				GO TOP
				
				IF RECCOUNT()>0
					GO _RECORD_CORRENTE
				ENDIF
*** FABIANO 26/01/2006 - POSSIBILITA' DI SALDI NEGATIVI						
***			ENDIF
				
		&& negli altri casi non fa nulla	
		OTHERWISE	
	ENDCASE		

	* stato 4
	SELECT MOVIMENTI
    SET FILTER TO 
    CliccataPartenza=.F.
    CliccatoArrivo=.F.
    RigaCellaDiPartenza=0
    ColonnaCellaDiPartenza=0
    RigaCellaDiArrivo=0
    ColonnaCellaDiArrivo=0
    GrigliaDiPartenza=SPACE(0)
    GrigliaDiArrivo=SPACE(0)
	TESORERIA.cntTastiera.TASTO_ANNULLA.click()

	RETURN 4	&& STATO_FINE_TRANSAZIONE
ENDPROC




***************************
* Metodo 
* Procedure GestioneErrore
***************************
PROCEDURE GestioneErrore
	
	LOCAL CRLF,pLogFile
	
	CRLF = CHR(13)+CHR(10)
	pLogFile="TESORERIA.LOG"
	
	mess=MESSAGE( )
	mess1=MESSAGE(1)
	mprog=PROGRAM()
	
	STRTOFILE(DTOC(DATE())+" - "+TimeMillisec()+" -----------------------"+CRLF,pLogFile,.t.)
	STRTOFILE('Error message:---------------' + mess+CRLF,pLogFile,.t.)
	STRTOFILE('Linea del codice con errore:-' + mess1+CRLF,pLogFile,.t.)
	STRTOFILE('Programma con errore:--------' + mprog+CRLF+CRLF,pLogFile,.t.)
		
ENDPROC


*****************************
procedure legge_config
*****************************
parameters _configfile,_proprieta

LOCAL _valore

_valore=""

IF FILE(_configfile)	  && Esiste il file? 

	gnConfigFile = FOPEN(_configfile)	  	&& Se esiste, lo apre in lettura
	IF gnConfigFile >= 0  					&& Verifica errore in apertura del file
											&& Se non viene trovato alcun errore legge file
		do while !feof(gnConfigFile)
			riga=FGETS(gnConfigFile)
			
			if at('=',riga)>0
				chiave=upper(substr(riga,1,at("=",riga)-1))
				valore=allt(substr(riga,at("=",riga)+1))

				if	chiave=_proprieta
					_valore=valore
				endif
			endif
		enddo
	ENDIF
	=FCLOSE(gnConfigFile)	

ENDIF

return _valore

ENDPROC



*****************************
procedure scrive_config
*****************************
parameters _configfile,_proprieta,_valore

CRLF = CHR(13)+CHR(10)
STRTOFILE(alltrim(_proprieta)+'='+alltrim(_valore)+CRLF,_configfile,.t.)

ENDPROC


***************************
* Procedure GetTimestamp
***************************
PROCEDURE GetTimestamp

  LPARAMETERS pFormato
  
  LOCAL data,;
  		ora,;
  		timestamp,;
  		AAAA,;
  		MM,;
  		GG,;
  		hh,;
  		pp,;
  		ss,;
		mmm,;
		nNumeroParametri
		
  nNumeroParametri=PARAMETERS()
		
  data=dtoc(date())
  ora=TimeMillisec()

  AAAA=substr(data,7,4)
  MM=substr(data,4,2)
  GG=substr(data,1,2)
  
  hh=substr(ora,1,2)
  pp=substr(ora,4,2)
  ss=substr(ora,7,2)
  mmm=substr(ora,10,3)
    
  timestamp=""

  IF nNumeroParametri>=1
	  timestamp=timestamp+&pFormato
  ELSE
	  timestamp=timestamp;
  				+AAAA;
  				+MM;
  				+GG;		&& data in formato AAAAMMGG
  				+hh;
  				+pp;
  				+ss;
  				+mmm		&& ora in formato HHMMssmmm
  ENDIF
  
  return timestamp
  
ENDPROC


***************************
* Procedure TimeMillisec
***************************
PROCEDURE TimeMillisec
  LOCAL data,;
  		ora,;
  		timestamp,;
  		secondiDaMezzanotte,;
  		millisecondi,;
  		str_millisecondi

  secondiDaMezzanotte=seconds()
  ora=substr(TIME(secondiDaMezzanotte),1,8)
  
  millisecondi=(secondiDaMezzanotte-int(secondiDaMezzanotte))*1000
  str_millisecondi="000"+alltrim(str(millisecondi,3,0))
  str_millisecondi=substr(str_millisecondi,len(str_millisecondi)-2)
  
  return ora+":"+str_millisecondi

ENDPROC

  	
***************************
* Procedure LogError
***************************
PROCEDURE LogError
	LPARAMETER pLogFile

	LOCAL CRLF
	
	CRLF = CHR(13)+CHR(10)
	
	merror=ERROR( )
	mess=MESSAGE( )
	mess1=MESSAGE(1)
	mprog=PROGRAM( )
	mlineno=LINENO( )

	STRTOFILE(GetTimestamp()+" -----------------------"+CRLF,pLogFile,.t.)
	STRTOFILE('Error number: ' + LTRIM(STR(merror))+CRLF,pLogFile,.t.)
	STRTOFILE('Error message: ' + mess+CRLF,pLogFile,.t.)
	STRTOFILE('Line of code with error: ' + mess1+CRLF,pLogFile,.t.)
	STRTOFILE('Line number of error: ' + LTRIM(STR(mlineno))+CRLF,pLogFile,.t.)
	STRTOFILE('Program with error: ' + mprog+CRLF,pLogFile,.t.)
RETURN
***************************


**********************************************************
* Classe TestoPerGriglia
**********************************************************
DEFINE CLASS TestoPerGriglia AS TextBox
	alreadyClick=.F.
	clickTime=0
	
	*****************************
	* Metodo PROCEDURE Init
	*****************************
	PROCEDURE Init
		
		WITH this
			.height=20
			.FontName=this.Parent.Parent.FontName
			.FontSize=this.Parent.Parent.FontSize
			.FontBold=this.Parent.Parent.FontBold
			.SpecialEffect=1
			.BorderStyle=0 && 0-none 1-fixed single
			.BackColor=RGB(255,255,255)
			.ForeColor=RGB(0,0,0)
			.SelectedBackColor=RGB(255,0,0)
			.SelectedForeColor=RGB(255,255,255)
			.DisabledBackColor=RGB(255,0,0)
			.DisabledForeColor=RGB(255,255,255)
		ENDWITH	

	ENDPROC
	*- FINE Metodo: Init
    ***************************

    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
		THIS.Parent.Parent.DefaultClick()
		THIS.Parent.Parent.VerificaSelezioneMultipla()
		THIS.FontBold=.T.
		
		IF this.Parent.Parent.Name="GrigliaPagati"
			this.Parent.Parent.Parent.Seleziona_Movimenti()
		ENDIF
				
	ENDPROC
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick

	ENDPROC
	*- FINE Metodo: DblClick
    ***************************

ENDDEFINE
*- FINE CLASSE TestoPerGriglia
**********************************************************


**********************************************************
* Classe TestoStandard
**********************************************************
DEFINE CLASS TestoStandard AS TestoPerGriglia
	
	alreadyClick=.F.
	clickTime=0

	*****************************
	* Metodo PROCEDURE Init
	*****************************
	PROCEDURE Init
		
		WITH this
			.height=20
			.FontName=this.Parent.Parent.FontName
			.FontSize=this.Parent.Parent.FontSize
			.FontBold=this.Parent.Parent.FontBold
			.SpecialEffect=1
			.BorderStyle=0 && 0-none 1-fixed single
			.BackColor=RGB(255,255,255)
			.ForeColor=RGB(0,0,0)
			.SelectedBackColor=RGB(255,0,0)
			.SelectedForeColor=RGB(255,255,255)
			.DisabledBackColor=RGB(255,0,0)
			.DisabledForeColor=RGB(255,255,255)
		ENDWITH	
		
	RETURN
	*- FINE Metodo: Init
    ***************************	
		  		  
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
		WITH this
			_ALIAS=.Parent.Parent.RecordSourceAlias
			SELECT &_ALIAS
			_RECNO=ALLTRIM(STR(RECNO()))
			* seleziona la casella corrente con un colore diverso
			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()="+_RECNO+",COLORE('ROSSO'),COLORE('BIANCO'))", "Column")
			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()="+_RECNO+",COLORE('GIALLO'),COLORE('NERO'))", "Column")
			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()="+_RECNO+",.T.,.F.)","Column") 
			
			.Parent.Parent.Refresh()
		ENDWITH
	RETURN
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
	
	RETURN
	*- FINE Metodo: DblClick
    ***************************
    
ENDDEFINE
*- FINE CLASSE TestoStandard
**********************************************************


**********************************************************
* Classe CheckBoxPerGriglia
**********************************************************
DEFINE CLASS CheckBoxPerGriglia AS CheckBox
	
    WIDTH = 18
    AUTOSIZE = .T.
    CAPTION = ""
    NAME = "CheckBoxPerGriglia"

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click

		SELECT (this.Parent.Parent.RECORDSOURCE)
		IF RECCOUNT()=0
			RETURN
		ENDIF
	
		IF !THIS.Parent.Parent.VerificaSelezioneMultipla()
			SELECT (THIS.Parent.Parent.RecordSource) 
			IF EMPTY(SELEZIONE)
				REPLACE SELEZIONE WITH THIS.Parent.Parent.SimboloSelezione
			ELSE
				REPLACE SELEZIONE WITH SPACE(0)
			ENDIF
		ENDIF

		IF this.Parent.Parent.Name="GrigliaPagati"
			this.Parent.Parent.Parent.Seleziona_Movimenti()
		ENDIF
		
		THIS.Parent.Parent.Refresh()
	ENDPROC
	*- FINE Metodo: Click
    ***************************

ENDDEFINE
*- FINE CLASSE CheckBoxPerGriglia
**********************************************************




**********************************************************
* Classe CheckBoxPerGrigliaCompensazioni
**********************************************************
DEFINE CLASS CheckBoxPerGrigliaCompensazioni AS CheckBox
	
    WIDTH = 18
    AUTOSIZE = .T.
    CAPTION = ""
    NAME = "CheckBoxPerGrigliaCompensazioni"

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click

		SELECT CSPLITCOMP
		IF RECCOUNT()=0
			RETURN
		ENDIF
	
		IF !THIS.Parent.Parent.VerificaSelezioneMultipla()
			SELECT CSPLITCOMP 
			IF EMPTY(SELEZIONE)
				REPLACE SELEZIONE WITH THIS.Parent.Parent.SimboloSelezione
			ELSE
				REPLACE SELEZIONE WITH SPACE(0)
			ENDIF
		ENDIF

		DO CALCOLACOMPENSAZIONE
		
		SELECT CSPLITCOMP
		GO TOP
		
		THIS.Parent.Parent.Refresh()
		THIS.Parent.Parent.Parent.GrigliaRisorse.Refresh()

	ENDPROC
	*- FINE Metodo: Click
    ***************************

ENDDEFINE
*- FINE CLASSE CheckBoxPerGriglia
**********************************************************



**********************************************************
* Classe CasellaDiTesto
**********************************************************
DEFINE CLASS CasellaDiTesto AS TestoPerGriglia
  		  
    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click

	
		WITH this
			.Parent.Parent.DefaultClick()
			IF !.alreadyClick
				.Parent.Parent.VerificaSelezioneMultipla()
* 				.BackColor=RGB(255,0,0)
* 				.ForeColor=RGB(255,255,255)
*				.FontBold=.T.
				.alreadyClick=.T.
				.clickTime=SECONDS()
			ELSE
				.alreadyClick=.F.
				IF (SECONDS()-.clickTime)*100<40
					IF .Parent.Parent.StatoSelezioneMultipla>0
						MESSAGEBOX("Prima di effettuare un'operazione di pagamento o trasferimento disattivare la selezione multipla",48,"Attenzione!")
					ELSE
						.DblClick()	
					ENDIF	
				ELSE
					.Parent.Parent.VerificaSelezioneMultipla()
				ENDIF
			ENDIF
		ENDWITH
	ENDPROC
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
		WITH this
		
* 			SELECT (.Parent.Parent.RecordSource)		
* 			.Parent.Parent.TAG=ALLTRIM(STR(RECNO()))
		
			* seleziona tutte le caselle selezionate con un colore diverso
			* e....
			* seleziona la casella corrente con un colore diverso
			* anche se non ho selezionato nulla questa la devo selezionare comunque
*!*				IF .Parent.Parent.AbilitaSelezione
*!*					REPLACE SELEZIONE WITH .Parent.Parent.SimboloSelezione
*!*					.Parent.Parent.SetAll("DynamicBackColor","IIF(!EMPTY(SELEZIONE) OR RECNO()=VAL(THIS.TAG), COLORE('ROSSO'),COLORE('GRIGIO_CHIARO'))", "Column")
*!*					.Parent.Parent.SetAll("DynamicForeColor","IIF(!EMPTY(SELEZIONE) OR RECNO()=VAL(THIS.TAG), COLORE('GIALLO'),COLORE('GRIGIO'))", "Column")
*!*					.Parent.Parent.SetAll("DynamicFontBold","IIF(!EMPTY(SELEZIONE) OR RECNO()=VAL(THIS.TAG),.T.,.F.)","Column") 
*!*				ELSE			
*!*		 			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()=VAL(THIS.TAG), COLORE('ROSSO'),COLORE('GRIGIO_CHIARO'))", "Column")
*!*		 			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()=VAL(THIS.TAG), COLORE('GIALLO'),COLORE('GRIGIO'))", "Column")
*!*		 			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()=VAL(THIS.TAG),.T.,.F.)","Column") 
*!*				ENDIF			
			
			.Parent.Parent.StatoTransazioneCelle
			.Parent.Parent.Refresh()
		ENDWITH
	ENDPROC
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaDiTesto
**********************************************************


**********************************************************
* Classe CasellaDiTestoPerPianiPagamento
**********************************************************
DEFINE CLASS CasellaDiTestoPerPianiPagamento AS TestoPerGriglia
  		  
	*****************************
	* Metodo PROCEDURE Init
	*****************************
	PROCEDURE Init
		
		WITH this
			.height=20
			.FontName=this.Parent.Parent.FontName
			.FontSize=this.Parent.Parent.FontSize
			.FontBold=this.Parent.Parent.FontBold
			.SpecialEffect=1
			.BorderStyle=0 && 0-none 1-fixed single
			.BackColor=RGB(255,255,255)
			.ForeColor=RGB(0,0,0)
			.Parent.Parent.SetAll("DynamicForeColor","IIF(ALLTRIM(UPPER(PAGATO))='SI', COLORE('GRIGIO'),COLORE('NERO'))", "Column")
		ENDWITH	

	ENDPROC
	*- FINE Metodo: Init
    ***************************
    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
		WITH this
			_ALIAS=.Parent.Parent.RecordSourceAlias
			SELECT &_ALIAS
			_RECNO=ALLTRIM(STR(RECNO()))
			* seleziona la casella corrente con un colore diverso
			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()="+_RECNO+",IIF(ALLTRIM(UPPER(PAGATO))='SI' ,COLORE('GRIGIO_CHIARO'),COLORE('ROSSO')),COLORE('BIANCO'))", "Column")
			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()="+_RECNO+", IIF(ALLTRIM(UPPER(PAGATO))='SI' ,COLORE('GRIGIO'),COLORE('GIALLO')),IIF(ALLTRIM(UPPER(PAGATO))='SI', COLORE('GRIGIO'),COLORE('NERO')))", "Column")
			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()="+_RECNO+",.T.,.F.)","Column") 
			
			.Parent.Parent.Refresh()
		ENDWITH
	RETURN
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
	RETURN
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaDiTestoPerPianiPagamento
**********************************************************



**********************************************************
* Classe CasellaDiTestoPerDettagliPianiPagamento
**********************************************************
DEFINE CLASS CasellaDiTestoPerDettagliPianiPagamento AS TestoPerGriglia
  		  
	*****************************
	* Metodo PROCEDURE Init
	*****************************
	PROCEDURE Init

		WITH this
			.height=20
			.FontName=this.Parent.Parent.FontName
			.FontSize=this.Parent.Parent.FontSize
			.FontBold=this.Parent.Parent.FontBold
			.SpecialEffect=1
			.BorderStyle=0 && 0-none 1-fixed single
			.BackColor=RGB(255,255,255)
			.ForeColor=RGB(128,128,128)
			.Parent.Parent.SetAll("DynamicForeColor","IIF(ALLTRIM(UPPER(C_PIANOP_TT.PAGATO))='SI', COLORE('GRIGIO'),COLORE('NERO'))", "Column")
		ENDWITH	

	ENDPROC
	*- FINE Metodo: Init
    ***************************
    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
	RETURN
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
	RETURN
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaDiTestoPerDettagliPianiPagamento
**********************************************************


**********************************************************
* Classe CasellaAnomalia
**********************************************************
DEFINE CLASS CasellaAnomalia AS TestoPerGriglia

	ReadOnly=.T.

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
	ENDPROC
	*- FINE Metodo: Click
    ***************************	
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
		IF !EMPTY(ANOMALIA)
		   V_SEEK   = 'ANO'+ANOMALIA
		   V_CHIAVE = 'codice'
		   IF seek_std('para',v_seek,v_chiave,'CURS_PARA')
		      SELECT CURS_PARA
		      xdescri = DESCRI
		   ENDIF
		ELSE
		      xdescri = CHR(13)+CHR(13)+"NESSUNA ANOMALIA DA EVIDENZIARE"
		ENDIF

	  SET CLASSLIB TO "proj_lib.vcx" additive
	  oForm=CreateObject("MsgErr") 
	  oform.edit1.Value=ALLTRIM(XDESCRI)+CHR(13)
	  oform.Show
	  RELEASE oForm 
	  
	ENDPROC
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaAnomalia
**********************************************************


**********************************************************
* Classe ViewText
**********************************************************
DEFINE CLASS ViewText AS TestoPerGriglia

	ReadOnly=.T.

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
	ENDPROC
	*- FINE Metodo: Click
    ***************************	
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
		_VISUALIZZA="MODI COMM "+NOMEFILE
		&_VISUALIZZA
	ENDPROC
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE ViewText
**********************************************************




**********************************************************
* Classe CasellaSelezione
**********************************************************
DEFINE CLASS CasellaSelezione AS TestoPerGriglia 

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
	
		SELECT (this.Parent.Parent.RECORDSOURCE)
		IF RECCOUNT()=0
			RETURN
		ENDIF
		IF EMPTY(SELEZIONE)
			REPLACE SELEZIONE WITH THIS.Parent.Parent.SimboloSelezione
		ELSE
			REPLACE SELEZIONE WITH SPACE(0)
		ENDIF

		IF this.Parent.Parent.Name="GrigliaPagati"
			this.Parent.Parent.Parent.Seleziona_Movimenti()
		ENDIF
		
		this.Parent.Parent.Parent.Refresh()
		
	ENDPROC
	*- FINE Metodo: Click
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaSelezione
**********************************************************



**********************************************************
* Classe TestoPerGrigliaViewCompensazioni
**********************************************************
DEFINE CLASS TestoPerGrigliaViewCompensazioni AS TestoPerGriglia

	ReadOnly=.T.

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
	ENDPROC
	*- FINE Metodo: Click
    ***************************	
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
		LOCAL _CODICE
	
		DO VIEWCOMPENSAZIONIPERTESORERIA		
	
	ENDPROC
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE TestoPerGrigliaViewCompensazioni
**********************************************************

**********************************************************
* Classe CasellaSplitCompensazioni
**********************************************************
DEFINE CLASS CasellaSplitCompensazioni AS TestoPerGriglia

	ReadOnly=.T.

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
	ENDPROC
	*- FINE Metodo: Click
    ***************************	
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
		LOCAL _CODICE
	
		DO SCORPORA_DETTAGLIO_COMPENSAZIONE		
		
		THIS.Parent.Parent.Parent.SplitCompensazioni()
		
	ENDPROC
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaSplitCompensazioni
**********************************************************

**********************************************************
PROCEDURE SCORPORA_DETTAGLIO_COMPENSAZIONE
**********************************************************

DELETE FROM CSPLITCOMP 

SELECT CSALDI_PARTITE

IF TIPOLOGIA="COMP"
	_CODICE=CODFOR
	
	SELECT DISTINCT GRUPPO,CODFOR ;
	FROM COMPENSAZIONI ;
	INTO CURSOR _TEMP_CGRUPPI
	
	SELECT * ;
	FROM COMPENSAZIONI ;
	WHERE GRUPPO IN ;
		(SELECT GRUPPO ;
		FROM _TEMP_CGRUPPI ;
		WHERE CODFOR=_CODICE) ;
	INTO CURSOR _TEMP_SPLIT_COMP
	
	
	SELECT _TEMP_SPLIT_COMP
	GO TOP

	DO WHILE !EOF()

		SELECT _TEMP_SPLIT_COMP
		SCATTER MEMVAR MEMO
		
		SELECT CSPLITCOMP
		APPEND BLANK
		GATHER MEMVAR MEMO
		REPLACE SELEZIONE WITH "==>"
		
		SELECT 	_TEMP_SPLIT_COMP			
		SKIP
	ENDDO
	
	SELECT CSPLITCOMP
    INDEX ON DTSCAD TAG _TMPINDEX  
    SET ORDER TO _TMPINDEX
    GO TOP
	
	
	SELECT CSALDI_PARTITE
	*** SELEZIONO SOLO QUELLO CHE HO IMPOSTATO
	_SALVARECORD=RECNO()
	REPLACE SELEZIONE WITH "" ALL
	GO _SALVARECORD
	REPLACE SELEZIONE WITH "==>"

	SET FILTER TO TIPOLOGIA="COMP"

ENDIF

RETURN
		
*FINE PROCEDURE SCORPORA_DETTAGLIO_COMPENSAZIONE
**********************************************************


**********************************************************
* Classe Intestazione
**********************************************************
DEFINE CLASS Intestazione AS HEADER
	AlreadyOrdered=.F.
	OrderAscending=.F.
    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
		LOCAL 	_ALIAS,;
				_ORDER,;
				_TAG_NAME
				
* 	    IF !_PUB_ABILITA_ORDINAMENTO_CAMPI
* 			RETURN
* 	    ENDIF
    
        WITH THIS
        	 
			_ALIAS=.PARENT.PARENT.RECORDSOURCE
			*_ORDER=.PARENT.CONTROLSOURCE
			**=> ERASMO - INIZIO 05/05/2015
			_ORDER=STRTRAN(.PARENT.CONTROLSOURCE,ALLTRIM(_ALIAS)+'.','')
			IF SUBSTR(_ORDER,1,9) = "RIBALTA2("
				_ORDER = SUBSTR(_ORDER,10)
				_ORDER = SUBSTR(_ORDER,1,RAT(')',_ORDER,1) - 1)
			ENDIF
			**=> ERASMO - FINE 05/05/2015
			
			IF _ORDER='SELEZIONE'
				RETURN
			ENDIF
			
			* ERASMO - SERGIO 2013/05/21 - SUI CAMPI DI TIPO CARATTERE O MEMO DEVO FARE UNA SUBSTRING DEL CAMPO PERCHE' ALTRIMENTI 
			* MI DA' ERRORE "INVALID KEY LENGTH"
			_FLAG_SUBSTR = .F.
			LOCAL _I
			SELECT &_ALIAS
			AFIELDS(A_STRUTTURA_CAMPI)
			FOR _I = 1 TO ALEN(A_STRUTTURA_CAMPI,1)
				IF _ORDER = A_STRUTTURA_CAMPI(_I,1)
					IF (A_STRUTTURA_CAMPI(_I,2) = 'C' OR A_STRUTTURA_CAMPI(_I,2) = 'M') AND A_STRUTTURA_CAMPI(_I,3) > 100
						_FLAG_SUBSTR = .T.
						EXIT
					ENDIF
				ENDIF
			NEXT
			RELEASE A_STRUTTURA_CAMPI

			
			SELECT &_ALIAS
			IF .AlreadyOrdered
				DELETE TAG _TMPINDEX
			ENDIF
			
			IF !_FLAG_SUBSTR
				IF .OrderAscending
					INDEX ON &_ORDER TAG _TMPINDEX DESC
					.OrderAscending=.F.
				ELSE
					INDEX ON &_ORDER TAG _TMPINDEX 
					.OrderAscending=.T.
				ENDIF
			ELSE
				IF .OrderAscending
					INDEX ON SUBSTR(&_ORDER,1,100) TAG _TMPINDEX DESC
					.OrderAscending=.F.
				ELSE
					INDEX ON SUBSTR(&_ORDER,1,100) TAG _TMPINDEX 
					.OrderAscending=.T.
				ENDIF
			ENDIF
			
			SET ORDER TO _TMPINDEX
			.AlreadyOrdered=.T.
			.PARENT.PARENT.REFRESH()
		ENDWITH
	ENDPROC
    *- FINE Metodo: Click
    ***************************	

	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DBLCLICK
        WITH THIS
            LOCAL lnOldArea, lcType, lcSource, llForceScan, lnFSize, lnHeaderSize, lnRecNo, llChanged, llAllowScan
            LOCAL lcFontName, lnFontSize, cFontStyle, lcFontName2, lnFontSize2, cFontStyle2, loControl, lcNullDisplay
            m.llChanged = .F.
            IF !EMPTY(.PARENT.CONTROLSOURCE)
                m.lnOldArea = SELECT(0)
                SELECT (.PARENT.PARENT.RECORDSOURCE)
                m.lcSource = .PARENT.CONTROLSOURCE
                m.lcType = TYPE(m.lcSource)
                IF ! (m.lcType $ 'GOPUS')
                    m.llForceScan = m.lcType == 'M'
                    IF !m.llForceScan
                        IF '.' $ m.lcSource AND ;
                                USED(LEFT(m.lcSource,AT('.',m.lcSource)-1))
                            m.lnFSize = FSIZE(SUBSTR(m.lcSource,AT('.',m.lcSource)+1),LEFT(m.lcSource,AT('.',m.lcSource)-1))
                            m.llForceScan = (m.lnFSize=0 OR m.lnFSize > 10) OR m.lcType$"YNIBF" && fields longer than 30 require scanning too, currency/integer/numeric field require scan anyway because a wide range
                        ELSE
                            m.llForceScan = .T.
                        ENDIF
                    ENDIF
                    WITH .PARENT
                        m.lcFontName = .FONTNAME
                        m.lnFontSize = .FONTSIZE
                        m.lcFontStyle = IIF(.FONTBOLD,"B","") + ;
                            IIF(.FONTITALIC,"I","") + ;
                            IIF(.FONTSTRIKETHRU,"-","") + ;
                            IIF(.FONTUNDERLINE,"U","")
                        m.lcNullDisplay = SET("NULLDISPLAY")
                        IF !EMPTY(.CURRENTCONTROL)
                            m.loControl = EVAL('.' + .CURRENTCONTROL)
                            IF TYPE("m.loControl.FontName")=="C"
                                m.lcFontName2 = m.loControl.FONTNAME
                                m.lnFontSize2 = m.loControl.FONTSIZE
                                m.lcFontStyle2 = IIF(m.loControl.FONTBOLD,"B","") + ;
                                    IIF(.FONTITALIC,"I","") + ;
                                    IIF(.FONTSTRIKETHRU,"-","") + ;
                                    IIF(.FONTUNDERLINE,"U","")
                                IF TXTWIDTH(REPLICATE("O",20), m.lcFontName, m.lnFontSize, m.lcFontStyle) < ;
                                        TXTWIDTH(REPLICATE("O",20), m.lcFontName2, m.lnFontSize2, m.lcFontStyle2)
                                    m.lcFontName = m.lcFontName2
                                    m.lnFontSize = m.lnFontSize2
                                    m.lcFontStyle = m.lcFontStyle2
                                    IF TYPE("m.loControl.NullDisplay") == "C"
                                        m.lcNullDisplay = IIF(EMPTY(m.loControl.NULLDISPLAY),SET("NULLDISPLAY"),m.loControl.NULLDISPLAY)
                                    ENDIF
                                ENDIF
                            ENDIF
                        ENDIF
                    ENDWITH
                    IF m.llForceScan
                        m.llAllowScan = .T.
                        IF INLIST(CURSORGETPROP('buffering'),2,3)
                            m.lcFldState = GETFLDSTATE(-1)
                            m.llAllowScan = !('2' $ m.lcFldState OR '3' $ m.lcFldState OR '4' $ m.lcFldState)
                        ENDIF
                        IF m.llAllowScan
                            m.lnHeaderSize = 0
                            m.lnRecNo = IIF(EOF(),0,RECNO())
                            IF !BOF()
                                SKIP -20
                            ENDIF
                            SCAN NEXT 40
                                IF .PARENT.INPUTMASK = ""
                                    m.lnHeaderSize = MAX(m.lnHeaderSize, ;
                                        CEILING((TXTWIDTH(NVL(ALLTRIM(TRANSFORM(EVAL(m.lcSource))),m.lcNullDisplay), ;
                                        m.lcFontName, m.lnFontSize, m.lcFontStyle)+1) * ;
                                        FONTMETRIC(6, m.lcFontName, m.lnFontSize, m.lcFontStyle)))
                                ELSE
                                    m.lnHeaderSize = MAX(m.lnHeaderSize, ;
                                        CEILING((TXTWIDTH(NVL(ALLTRIM(TRANSFORM(EVAL(m.lcSource),.PARENT.INPUTMASK)),m.lcNullDisplay), ;
                                        m.lcFontName, m.lnFontSize, m.lcFontStyle)+1) * ;
                                        FONTMETRIC(6, m.lcFontName, m.lnFontSize, m.lcFontStyle)))
                                ENDIF
                            ENDSCAN
                            IF m.lnRecNo=0
                                GO BOTTOM
                                IF !EOF()
                                    SKIP
                                ENDIF
                            ELSE
                                GO (m.lnRecNo)
                            ENDIF
                            m.llChanged = .T.
                        ENDIF
                    ELSE
                        DO CASE
                        CASE m.lcType = "D"
                            m.lnFSize = 10
                        CASE m.lcType = "T"
                            m.lnFSize = 20
                        ENDCASE
                        m.lnHeaderSize = TXTWIDTH(REPLICATE("0",m.lnFSize+1),m.lcFontName, m.lnFontSize, m.lcFontStyle) * ;
                            FONTMETRIC(6, m.lcFontName, m.lnFontSize, m.lcFontStyle)
                        m.llChanged = .T.
                    ENDIF
                    IF m.llChanged
                        m.lnHeaderSize = MAX(m.lnHeaderSize, ;
                            CEILING(TXTWIDTH(.CAPTION,.FONTNAME,.FONTSIZE,IIF(.FONTBOLD,"B","") + ;
                            IIF(.FONTITALIC,"I","") + ;
                            IIF(.FONTSTRIKETHRU,"-","") + ;
                            IIF(.FONTUNDERLINE,"U","")) * ;
                            FONTMETRIC(6, .FONTNAME,.FONTSIZE,IIF(.FONTBOLD,"B","") + ;
                            IIF(.FONTITALIC,"I","") + ;
                            IIF(.FONTSTRIKETHRU,"-","") + ;
                            IIF(.FONTUNDERLINE,"U","")) )+4)

                        .PARENT.WIDTH = MAX(m.lnHeaderSize,10)
                    ENDIF
                ENDIF
                SELECT (m.lnOldArea)
            ENDIF
            IF NOT m.llChanged
                .PARENT.WIDTH = MAX(.DefaultWidth,10)
            ELSE
                IF NOT(OBJTOCLIENT(THIS,3) = .PARENT.WIDTH) AND .PARENT.COLUMNORDER <> .PARENT.PARENT.LEFTCOLUMN
                    .PARENT.SETFOCUS
                ENDIF
                IF NOT(OBJTOCLIENT(THIS,3) = .PARENT.WIDTH) AND .PARENT.COLUMNORDER <> .PARENT.PARENT.LEFTCOLUMN
                    .PARENT.PARENT.DOSCROLL(5)
                ENDIF
            ENDIF
        ENDWITH
    ENDPROC
    *- FINE Metodo: DblClick
    ***************************
    
ENDDEFINE
*- FINE CLASSE Intestazione
**********************************************************

****************************************************
PROCEDURE CreaLetteraWord

	LPARAMETERS  aliasTabella,ln_numcols

	LOCAL 	oWord,;
			numeroRighetabella
	
	DIMENSION arrayColonne[3,ln_numcols] 

	arrayColonne[1,1] = "Ns.Riferimento"
	arrayColonne[1,2] = "Vs.Riferimento"
	arrayColonne[1,3] = "Importo pagato"
	arrayColonne[1,4] = "Data valuta"

	arrayColonne[2,1] = "ALLTRIM(STR(NPART))" 
	arrayColonne[2,2] = "'Fattura corrispondente a partita '+ALLTRIM(STR(NPART))"
	arrayColonne[2,3] = "ALLTRIM(STR(QUANTAVALU))"
	arrayColonne[2,4] = "RIBALTA2(QUANDOVALU)" 

	arrayColonne[3,1] = 100
	arrayColonne[3,2] = 200 
	arrayColonne[3,3] = 100 
	arrayColonne[3,4] = 100  

	
	SELECT 	&aliasTabella
	numeroRighetabella=RECCOUNT()
				
	
	*-- Create the OLE object in WinWord
	    oWord = CREATEOBJECT('Word.Application')
	
	*-- Base the new document on the NORMAL template
	    oWord.Documents.Add
	
	*-- Display WinWord's application window so we can see what is happening.
	    WITH oWord
	         .ActiveWindow.View.Type = 1                         && Switch to normal view. Page view=3
	*!*             .ActiveWindow.ActivePane.View.SeekView = 0   && Open main document.
	         .Selection.Homekey(6)                               && Go to top of document.
	         .Visible = .T.                                      && Make Word visible.
	         .Application.Activate                               && Bring Word forward.
	         .WindowState = 0                                    && Show Word in normal state. Maximized=1
	         .ActiveWindow.ActivePane.View.ShowAll = 0           && No nonprinting items.
	         .Selection.ParagraphFormat.Alignment = 1            && Set Text Alignment; 1 = Center
	         .Selection.Font.Name = "Arial"                      && Set Font Type
	         .Selection.Font.Size = 8                            && Set Font Size
	         .Selection.ParagraphFormat.LineSpacingRule = 4      && Set Line Spacing Rule; 4 = Exactly
	         .Selection.ParagraphFormat.LineSpacing = 8.5        && Set Line Spacing to 8.5 pt
		ENDWITH
	    
		      
	      
	*-- Generate the table and insert form fields where appropriate.
	    owRange = oWord.Activedocument.Range(0,0)
	    oWord.Activedocument.Tables.Add(owRange, numeroRighetabella+1, ln_numcols)
	    oTable = oWord.ActiveDocument.Tables(1) && Assign a table object
	
	    FOR j = 1 TO ln_numcols
	        oWord.Selection.SelectColumn
	        oWord.Selection.Columns.PreferredWidth = arrayColonne[3,j]        && Set column width for individual columns
			oWord.Selection.Range.Cells(1).VerticalAlignment = 1
	        oWord.Selection.Move(1,1)
	    ENDFOR
	
	*-- Build column headers
    WITH oWord
        .Selection.Homekey(6)
        
		FOR contaColonne=1 to ln_numcols
	        .Selection.TypeText(arrayColonne[1,contaColonne])
       		.Selection.Move(1,1)
       	NEXT
    
		SELECT &aliasTabella
		GO TOP
		DO WHILE !EOF()
			FOR contaColonne=1 to ln_numcols
        		.Selection.Move(1,1)
        		.Selection.TypeText(&arrayColonne[2,contaColonne])
        	NEXT
        	SKIP
		ENDDO
    ENDWITH
    
RETURN
* FINE PROCEDURE CREALETTERAWORD
********************************************


********************************************
PROCEDURE CARICA_PARTITE
********************************************
LPARAMETERS P_CF,;
			P_CODICE_FORNITORE,;
			P_NAZIONE,;
			P_DATA_DAL,;
			P_DATA_AL,;
			P_DATA_SCADENZA_DA_FILTRARE,;
			P_DTSCADUTO,;
			P_DTSCADERE
			

RELEASE 	_DTSCADERE,;
			_DTSCADUTO

PUBLIC	 	_DTSCADERE,;
			_DTSCADUTO
			
LOCAL		_CODICE_FORNITORE,;
			_NAZIONE,;
			_DATA_DAL,;
			_DATA_AL,;
			_DATA_SCADENZA_DA_FILTRARE

			

DO CASE
	CASE PCOUNT()=2 
		_CODICE_FORNITORE  	= 	P_CODICE_FORNITORE	
		_NAZIONE  			= 	"ITA"
		_DATA_DAL			=	"1900/01/01"
		_DATA_AL			=	"2999/12/31"
		_DATA_SCADENZA_DA_FILTRARE =""
		_DTSCADERE=""
		_DTSCADUTO=""

	CASE PCOUNT()=3 
		_CODICE_FORNITORE  	= 	P_CODICE_FORNITORE	
		_NAZIONE  			= 	P_NAZIONE
		_DATA_DAL			=	"1900/01/01"
		_DATA_AL			=	"2999/12/31"
		_DATA_SCADENZA_DA_FILTRARE =""
		_DTSCADERE=""
		_DTSCADUTO=""

	CASE PCOUNT()=4
		_CODICE_FORNITORE  	= 	P_CODICE_FORNITORE	
		_NAZIONE  			= 	P_NAZIONE
		
		IF !EMPTY(P_DATA_DAL)
			_DATA_DAL		=	P_DATA_DAL
		ELSE
			_DATA_DAL		=	"1900/01/01"
		ENDIF
		_DATA_AL			=	"2999/12/31"

		_DATA_SCADENZA_DA_FILTRARE =""
		_DTSCADERE=""
		_DTSCADUTO=""


	CASE PCOUNT()=5
		_CODICE_FORNITORE  = P_CODICE_FORNITORE	
		_NAZIONE  = P_NAZIONE

		IF !EMPTY(P_DATA_DAL)
			_DATA_DAL			=	P_DATA_DAL
		ELSE
			_DATA_DAL			=	"1900/01/01"
		ENDIF

		IF !EMPTY(P_DATA_AL)
			_DATA_AL			=	P_DATA_AL
		ELSE
			_DATA_DAL			=	"2999/12/31"
		ENDIF
		_DATA_SCADENZA_DA_FILTRARE =""
		_DTSCADERE=""
		_DTSCADUTO=""

	CASE PCOUNT()=6
		_CODICE_FORNITORE  = P_CODICE_FORNITORE	
		_NAZIONE  = P_NAZIONE

		IF !EMPTY(P_DATA_DAL)
			_DATA_DAL			=	P_DATA_DAL
		ELSE
			_DATA_DAL			=	"1900/01/01"
		ENDIF

		IF !EMPTY(P_DATA_AL)
			_DATA_AL			=	P_DATA_AL
		ELSE
			_DATA_DAL			=	"2999/12/31"
		ENDIF
		
		_DATA_SCADENZA_DA_FILTRARE = P_DATA_SCADENZA_DA_FILTRARE
		_DTSCADERE=""
		_DTSCADUTO=""
		
		IF EMPTY(_DATA_SCADENZA_DA_FILTRARE)
			_DTSCADUTO=""
			_DTSCADERE=""
		ELSE
			IF RIBALTA2(_DATA_SCADENZA_DA_FILTRARE)<=RIBALTA2(_DATA_OGGI) 
				&& filtro su partite gia' scadute
				_DTSCADUTO=_DATA_SCADENZA_DA_FILTRARE
				_DTSCADERE=_DATA_OGGI
			ELSE
				&& filtro su partite a scadere
				_DTSCADUTO=DTOC(CTOD(_DATA_OGGI)+1)
				_DTSCADERE=_DATA_SCADENZA_DA_FILTRARE
			ENDIF
		ENDIF
					
	CASE PCOUNT()=8
		_CODICE_FORNITORE  = P_CODICE_FORNITORE	
		_NAZIONE  = P_NAZIONE

		IF !EMPTY(P_DATA_DAL)
			_DATA_DAL			=	P_DATA_DAL
		ELSE
			_DATA_DAL			=	"1900/01/01"
		ENDIF

		IF !EMPTY(P_DATA_AL)
			_DATA_AL			=	P_DATA_AL
		ELSE
			_DATA_DAL			=	"2999/12/31"
		ENDIF
		
		_DATA_SCADENZA_DA_FILTRARE 	= ""
		_DTSCADERE					= P_DTSCADERE
		_DTSCADUTO					= P_DTSCADUTO
		
	OTHERWISE
		RETURN
ENDCASE
	
IF _CODICE_FORNITORE!="TUTTI"
	V_ER = SOTTOGEN(_NAZIONE)
	IF !V_ER
    	_CODICE_FORNITORE = PUB_FF+ALLTRIM(_CODICE_FORNITORE)
	ENDIF 
ENDIF

*****************************************************************************************
*	 						 CREA I SALDI PARTITE CLENTI/FORNITORI           		    * 
*****************************************************************************************			
* _cf = C : CLIENTI
*       F : FORNITORI
*
* _codcli = codice del cliente o del fornitore
*
* _npart  = numero partita cliente fornitore
*
* _dtscad = data di scadenza della singola riga della partita 
*
* _estrai = A 		: ESTRAE SENZA AGGIORNARE SOLO SALDO PARTITE APERTE
*           C 		: ESTRAE SENZA AGGIORNARE SOLO SALDO PARTITE CHIUSE
*           T 		: ESTRAE SENZA AGGIORNARE TUTTI I SALDI DELLE PARTITE SIA APERTE CHE CHIUSE
*			
*
*			=========
*           CREA    : AGGIORNA I SALDI SUI PARTITARI
*           ANNU    : ANNULLA TUTTI I SALDI DELLA PARTITA 			      
* 			ANNUA   : ANNULLA I SALDI ANCORA APERTI DELLA PARTITA
*			ANNUC   : ANNULLA I SALDI CHIUSI DELLA PARTITA
*
*
* _estrai_tutto     : se = "ESTRAILEPARTITEDELCLIENTE-FORNITORE" , elabora tutte le partite del SINGOLO cliente/fornitore
*  				    : se = "ESTRAITUTTELEPARTITE" , elabora tutte le partite dei clienti/fornitori
*
*  ULTERIORI FUNZIONALITA' COMBINATE
*  =================================
*
*    SE _estrai = CREA e  _codcli = "TUTTO" e _npart = "TUTTO >>>>>>>> vengono RICREATI TUTTI I SALDI CLIENTI/FORNITORI
*    SE _estrai = ANNU e  _codcli = "TUTTO" e _npart = "TUTTO >>>>>>>> vengono CANCELLATI tutti i saldi clienti/fornitori
*
*
* _dettagli_partite : SI  : ESTRAE DOPO AVER CREATO IL CURSORE CUR_SALDI_CLI/CUR_SALDI_FOR LE PARTITE INDICATE DAL FLAG 
*							DI ESTRAZIONE A LIVELLO DI SALDO = .T.	(SOLO NELLE FUNZIONI DI ESTRAZIONE)
*
* >>>>>>>>> CURSORI RESTITUITI : 
*								CSALDI_PARTITE 	contiene i saldi clienti / fornitori
*								PARTITECF		contiene il dettaglio delle partite aperte (CLI/FOR) desiderate

_cf = P_CF
_codcli = _CODICE_FORNITORE
_npart  = ""
_dtscad = ""
_estrai = "CREA"
_dettagli_partite="NO"

IF _CODICE_FORNITORE="TUTTI"
	_estrai_tutto="ESTRAITUTTELEPARTITE" 
	IF PUB_SENZA_ANOMALIE=1 AND PUB_CON_ANOMALIE=0
		_estrai_tutto="ESTRAITUTTELEPARTITE-SENZAANOMALIE" 
	ENDIF
	IF PUB_CON_ANOMALIE=1 AND PUB_SENZA_ANOMALIE=0
		_estrai_tutto="ESTRAITUTTELEPARTITE-CONANOMALIE" 
	ENDIF
ELSE
	_estrai_tutto="ESTRAILEPARTITEDELCLIENTE-FORNITORE" 
	IF PUB_SENZA_ANOMALIE=1 AND PUB_CON_ANOMALIE=0
		_estrai_tutto="ESTRAITUTTELEPARTITE-SENZAANOMALIE-DEL-CLI-FOR" 
	ENDIF
	IF PUB_CON_ANOMALIE=1 AND PUB_SENZA_ANOMALIE=0
		_estrai_tutto="ESTRAITUTTELEPARTITE-CONANOMALIE-DEL-CLI-FOR" 
	ENDIF
ENDIF

CREA_SALDI_CF(_cf,_codcli,'99999998',"XXXXXXXXXX",_estrai,"NO","ESTRAITUTTELEPARTITEFORNITORE")	

_estrai = "A"

CREA_SALDI_CF(_cf,_codcli,_npart,_dtscad,_estrai,_dettagli_partite,_estrai_tutto,_DATA_DAL,_DATA_AL,_DTSCADUTO,_DTSCADERE,.T.)

SELECT CSALDI_PARTITE
GO TOP 

RELEASE 	_DTSCADERE,;
			_DTSCADUTO
			
			
* FINE PROCEDURE CARICA_PARTITE
********************************************


**********************************************************************************************
PROCEDURE TESPAGA
*--------------------------------------------------------------------------------------------
*    CREA PRIME NOTE A FRONTE DEI PAGAMENTI FATTI A FORNITORE 
**********************************************************************************************

PARAMETERS PAR_CONTABILIZZA

LOCAL	_NUMPRO_MENTRE_PAGO_O_INCASSO

IF PCOUNT()>0 AND !PAR_CONTABILIZZA
ELSE
	PUB_ERRORE=MESSAGEBOX("Desideri contabilizzare i pagamenti ? ",292,'*** ATTENZIONE ***') 
	IF PUB_ERRORE= 7  && RISPOSTA NO
	     RETURN .F.
	ENDIF
ENDIF

************************* INIZIO DEFINIZIONE DELLE VARIABILI *****************************

RELEASE ___COSATRATTA         
RELEASE ___GRADOIMPORTANZA     
RELEASE ___FORMAPAGAMENTO     
RELEASE ___TIPOCONTRATTO     
RELEASE ___CODACQ             
RELEASE ___PRIPAGA             
RELEASE ___RAGSOC     
RELEASE ___DATAREGISTRAZIONE     
RELEASE _TOTALE_PRIMA_NOTA

PUBLIC ___COSATRATTA         
PUBLIC ___GRADOIMPORTANZA     
PUBLIC ___FORMAPAGAMENTO     
PUBLIC ___TIPOCONTRATTO     
PUBLIC ___CODACQ             
PUBLIC ___PRIPAGA             
PUBLIC ___RAGSOC              
PUBLIC ___DATAREGISTRAZIONE      
PUBLIC _TOTALE_PRIMA_NOTA


*!*	IF EMPTY(PUB_INCCLI)
*!*	    PUB_INCCLI="ICL"
*!*	ENDIF

IF EMPTY(PUB_PAGAFOR)
    PUB_PAGAFOR="PGF"
ENDIF

IF EMPTY(PUB_PAGANCR)
    PUB_PAGANCR="PNC"                && PAGAMENTO NOTA CREDITO
ENDIF

IF EMPTY(PUB_TRF)
    PUB_TRF="TRF"
ENDIF

___COSATRATTA      	= SPACE(05)
___GRADOIMPORTANZA 	= SPACE(05)
___FORMAPAGAMENTO  	= SPACE(05)    
___TIPOCONTRATTO   	= SPACE(05)
___CODACQ          	= SPACE(03) 
___PRIPAGA         	= SPACE(03) 
___RAGSOC          	= SPACE(30)
___DATAREGISTRAZIONE= SPACE(10) 



************************* FINE DEFINIZIONE DELLE VARIABILI *****************************

SELECT TESORERIA_PAGATI

GO TOP
IF EOF()
   PUB_ERRORE=MESSAGEBOX("Nessun pagamento da contabilizzare",64,"Cosolida movimenti") 
   RETURN .F.
ENDIF
CONTAMOV = 0

*** INIZIO GESTIONE RAGGRUPPAMENTO PARTITE
RELEASE	___LEGA_MOV,;
		___RAGGRUPPA_NUMPRO,;
		___RAGGRUPPA_NREG,;
		___RAGGRUPPA_TOTALE_PRIMA_NOTA,;
		___RAGGRUPPA_SEQUEN


PUBLIC 	___LEGA_MOV,;
		___RAGGRUPPA_NUMPRO,;
		___RAGGRUPPA_NREG,;
		___RAGGRUPPA_TOTALE_PRIMA_NOTA,;
		___RAGGRUPPA_SEQUEN

___LEGA_MOV=LEGA_MOV

___RAGGRUPPA_NUMPRO	=""
___RAGGRUPPA_NREG	=""
___RAGGRUPPA_TOTALE_PRIMA_NOTA=0
___RAGGRUPPA_SEQUEN = 0

IF PUB_RAGGRUPPA_PARTITE_PER_TIPOLOGIA_E_FORNITORE

	SELECT TESORERIA_PAGATI
	MODTBL(ALIAS(SELECT()),"RIGA_BANCA",  "L")
	MODTBL(ALIAS(SELECT()),"IMPO_BANCA",  "N(17,6)")
	GO TOP 
	_CLIFOR_ROTTURA=ALLTRIM(codfor)
	_BANCA_ROTTURA=BANCA
	_TOTALE_BANCA=0
	DO WHILE !EOF()

		IF DELETED()
			SKIP
			LOOP
		ENDIF

		IF BANCA != _BANCA_ROTTURA OR ALLTRIM(codfor)!=_CLIFOR_ROTTURA
			
			SKIP -1
			REPLACE RIGA_BANCA WITH .T.
			REPLACE IMPO_BANCA WITH ABS(_TOTALE_BANCA)
			
			SKIP +1
			
			_TOTALE_BANCA = 0
			_BANCA_ROTTURA=BANCA
			_CLIFOR_ROTTURA=ALLTRIM(codfor)
			
		ENDIF

		REPLACE RIGA_BANCA WITH .F.
		_TOTALE_BANCA =_TOTALE_BANCA + quantavalu
		
		SKIP

	ENDDO



	*** SISTEMO ULTIMA RIGA CHE NON HA SENTITO LA ROTTURA
	SELECT TESORERIA_PAGATI
	GO BOTTOM
	REPLACE RIGA_BANCA WITH .T.
	REPLACE IMPO_BANCA WITH ABS(_TOTALE_BANCA)

ENDIF
*** FINE GESTIONE RAGGRUPPAMENTO PARTITE


SELECT TESORERIA_PAGATI
GO TOP


DO WHILE !EOF()

        SELECT TESORERIA_PAGATI
        SCATTER MEMVAR MEMO

	    =DEF_AQUAREP()
			
		_NUMPRO_MENTRE_PAGO_O_INCASSO  = SPACE(0)  	
		
        CGE_DATES="DA-TES"
        KABBUO      = 0
        saldo_prec  = 0

        ___xrecno    =RECNO()
        ___totpag   =ABS(quantavalu)
    	___codfor	=ALLTRIM(codfor)
        ___desfor   =DES_A
        ___codban   =contocont
        ___desban   =DES_DA
        ___dtscad   =DATA_GGMMAAAA(dtscad)
        
        IF PCOUNT()>0 AND !PAR_CONTABILIZZA
        	PUB_DTVALU=""
        ENDIF
                
        IF ALLTRIM(PUB_DTVALU)=""
        	___dtvalu   =DATA_GGMMAAAA(quandovalu)
        ELSE
        	___dtvalu   =DATA_GGMMAAAA(PUB_DTVALU)
        ENDIF
        
	*** GESTIONE NUMERO DI PARTITA        
	***
        ___npart    =npart
        IF	___npart=0
        
			*************************************************************************
			*   PRELEVA NUMERO PARTITA                                   
			*	E AGGIORNA PARA INCREMENTANDO IL NUMERO STESSO
			*************************************************************************
		   RELEASE _NUMPARK 
		   PUBLIC  _NUMPARK 
		   _NUMPARK = SPACE(06)
		   v_seek	 = 'NUMPRC'+PUB_CODSOC
		   v_chiave  = "codice"
		   cSql      = "select * from para where " + v_chiave + " = '" + v_seek + "'"
		   IF !ExecRW(cSql,"PARA","R")
		      return(.f.)
		   ENDIF
		   SELECT PARA
		   IF RECCOUNT() = 0
			  _NUMPARK = "    "
		   ELSE
		      V2=VAL(SUBSTR(LIBERA,1,7)) + 1
		      REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
		      _NUMPARK  = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
		   ENDIF
		   IF !ExecRW(cSql,"PARA","W")
		      return(.f.)
		   ENDIF
		
		   ___npart  =VAL(_NUMPARK)
		   RELEASE _NUMPARK 
		   
        ENDIF
        
        
	*** GESTIONE DELLA DATA DI REGISTRAZIONE
	***
	*** NEI MOVIMENTI HO IL CAMPO DTREG DISPONIBILE E NON UTILIZZATO
	***
        IF PCOUNT()>0 AND !PAR_CONTABILIZZA
        	PUB_DTREG=""
        ENDIF

        IF !EMPTY(DTREG)
			___DATAREGISTRAZIONE	=	DTREG
        ELSE
           	___DATAREGISTRAZIONE	= 	PUB_DTREG
        ENDIF

        
        IF TIPOLOGIA="STIPENDIO"
        	___ndocu    =ALLTRIM(STR(___npart))
        ELSE
        	___ndocu    =ALLTRIM(STR(___npart,10,0))
        ENDIF    
        	                   
        ___COSATRATTA		= cosatratta    
        ___GRADOIMPORTANZA  = gradoimpor
        ___FORMAPAGAMENTO   = formapagam 
        ___TIPOCONTRATTO    = tipocontra  
        ___CODACQ           = codacq           
        ___PRIPAGA          = pripaga                 
        ___TIPOLOGIA        = TIPOLOGIA


	*** IMPOSTO I TOP STANDARD DA UTILIZZARE PER I PAGAMENTI
	*** SONO DIFFERENZIATI PER TIPO DI PARTITA CHE VADO A PAGARE/INCASSARE
	
       	CGE_TOPX        = PUB_PAGAFOR       && PAGAMENTO FORNITORE/RISORSA (DEFAULT)            
       	
	    IF ___TIPOLOGIA="STIPENDIO"
	    	CGE_TOPX        = PUB_STIPE        		&& PAGAMENTO STIPENDI
	    	
	    	*** IL CONTO PRIMARIO E' IMPOSTATO NEL TOP NEL CAMPO CONTO1

			cSql=""     
			cNomeCursorSql="___PARA"
			
			TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
			
			SELECT 	T1.CONTO1	AS CONTO,
					T2.CON_DESCR AS DESCRI 	
				FROM PARA AS T1 
				INNER JOIN CONTI AS T2
				ON T1.CONTO1=T2.CON_CONTO
				WHERE 	T1.CODICE = 'TOP<<PUB_STIPE>>'
					AND T2.CON_ANNO='<<PUB_ANNO>>' 
					AND T2.CON_SOC='<<PUB_CODSOC>>'
				
			ENDTEXT					&& FINE SCRITTURA QUERY
			
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF

			SELECT ___PARA
			GO TOP
			IF EOF()
				___codfor   ="XXXXXXXXXX"				
		        ___desfor   ="CONTO INESISTENTE SU TOP "+PUB_STIPE+" PER STIPENDI"
			ENDIF			
	    	___codfor   = CONTO
	        ___desfor   = DESCRI 

	    	
		ENDIF

        IF quantavalu > 0                       && NOTE CREDITO                            
            CGE_TOPX=PUB_PAGANCR
        ENDIF

        IF ___TIPOLOGIA="TRAS-FONDI"            && TRASFERIMENTO FONDI
            CGE_TOPX=PUB_TRF
            ___codfor   =contocont
            ___desfor   =DES_DA
            ___codban   =codfor
            ___desban   =DES_A
        ENDIF
        
       	IF ___TIPOLOGIA="RICEV"
			CGE_TOPX=PUB_RRIFOR
       	ENDIF
        
       	IF ___TIPOLOGIA="LEASING"
			CGE_TOPX=PUB_LEASIN
       	ENDIF
       	
       	IF ___TIPOLOGIA="FINANZIAMENTO"
			CGE_TOPX=PUB_FINAN
       	ENDIF
       	
       	IF ___TIPOLOGIA="CONTRATTO"
			CGE_TOPX=PUB_CONTR
       	ENDIF

       	IF ___TIPOLOGIA="EFF.PASS."
			CGE_TOPX=PUB_EFFPAS
       	ENDIF
       	
       	IF ___TIPOLOGIA="EFF.ATT."
			CGE_TOPX=PUB_EFFATT
       	ENDIF

       	
		IF PUB_RAGGRUPPA_PARTITE_PER_TIPOLOGIA_E_FORNITORE
		
			*** INIZIO GESTIONE RAGGRUPPAMENTO PARTITE
			
			SELECT TESORERIA_PAGATI
			IF ___LEGA_MOV!=ID_MOVIMEN AND ___LEGA_MOV=LEGA_MOV
				
				CGE_SEQUEN  =___RAGGRUPPA_SEQUEN
			ELSE
		        CGE_SEQUEN  =0
			ENDIF
			
			*** FINE GESTIONE RAGGRUPPAMENTO PARTITE
			
		ELSE
	        CGE_SEQUEN  =0
	    ENDIF 
       	    

	*** CREAZIONE DEL PAGAMENTO/INCASSO
	*** SE SI TRATTA DI COMPENSAZIONI USO UNA ROUTINE SEPARATA  --> CONTABCOMP
        
	   
        IF ___TIPOLOGIA="COMP"            && COMPENSAZIONI
        
	***##############################  TRATTO LE COMPENSAZIONI
        
        	CONTA_MOV_COMP=0
        	        	
        	IF PCOUNT()>0 AND !PAR_CONTABILIZZA
	        	CONTA_MOV_COMP=CONTABCOMP(PAR_CONTABILIZZA)
	        	RETURN .T.
	        ELSE
	        	CONTA_MOV_COMP=CONTABCOMP(.T.)
	        ENDIF
	        
        	CONTAMOV = CONTAMOV +  CONTA_MOV_COMP
        	
        ELSE
        
    ***##############################  AGGIORNO LE CONTOPARTITE ASSEGNATE DIRETTAMENTE AI DOCUMENTI
        
		*** FINANZIAMENTO
		****************************************************************
	        IF ___TIPOLOGIA="FINANZIAMENTO"  
	      		SELECT TESORERIA_PAGATI
	      		_ID_PARTITA=ALLTRIM(ID_MOVIMEN)
	        
				cSql=""     
				cNomeCursorSql="CFIN_DD"
				
				TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
				
					SELECT * FROM U_FIN_DD 
					WHERE ID_UNIQUE ='<<_ID_PARTITA>>'
					
				ENDTEXT					&& FINE SCRITTURA QUERY
				
				IF !ExecPreparedCommand(cSql,cNomeCursorSql)
					return(.F.)
				ENDIF
				
	            ___codfor   =""
	            ___desfor   =""

				SELECT CFIN_DD
	            IF !EOF()
		            ___codfor   =FIN_CONTROP
		            ___desfor   =FIN_DESCONP
				ENDIF

				SELECT TESORERIA_PAGATI
				
    		
        	ENDIF
        
	***##############################  TUTTI I PAGAMENTI NORMALI (CIOE' UNA SINGOLA PARTITA)

        	IF ___TIPOLOGIA="EFF.ATT."
        	
        	
        		IF PUB_RAGGRUPPA_PARTITE_PER_TIPOLOGIA_E_FORNITORE
        		
					*** INIZIO GESTIONE RAGGRUPPAMENTO PARTITE
					SELECT TESORERIA_PAGATI
					IF ___LEGA_MOV!=ID_MOVIMEN AND ___LEGA_MOV=LEGA_MOV
						CGE_NUMPRO	=	___RAGGRUPPA_NUMPRO
						CGE_NREG	=	___RAGGRUPPA_NREG
						=MOVIMENTO_DARE_BANCA("NON CREARE NUOVO NUMPRO","INDICE CARICATO","NON CREARE NUOVO NUMREG","NON CREARE NUOVO NUMDOC")
						
						___RAGGRUPPA_TOTALE_PRIMA_NOTA	=	___RAGGRUPPA_TOTALE_PRIMA_NOTA + CGE_DA +CGE_AV
						
					ELSE
				        =MOVIMENTO_DARE_BANCA()
						___RAGGRUPPA_NUMPRO	=	CGE_NUMPRO
						___RAGGRUPPA_NREG  	=	CGE_NREG
						___RAGGRUPPA_TOTALE_PRIMA_NOTA	=	CGE_DA  +CGE_AV
					ENDIF

			        IF RIGA_BANCA 
				        ___totpag=IMPO_BANCA
				        =MOVIMENTO_AVERE_CLIENTE()
				    ENDIF
					
			        _NUMPRO_MENTRE_PAGO_O_INCASSO = CGE_NUMPRO
			        
					*** FINE GESTIONE RAGGRUPPAMENTO PARTITE
					
				ELSE
			        =MOVIMENTO_DARE_BANCA()
				
			        =MOVIMENTO_AVERE_CLIENTE()
			        
			        _NUMPRO_MENTRE_PAGO_O_INCASSO = CGE_NUMPRO
		        
			    ENDIF 
		        
		        CONTAMOV = CONTAMOV + 1
		        
		    
		    ELSE
		        
        		IF PUB_RAGGRUPPA_PARTITE_PER_TIPOLOGIA_E_FORNITORE

        			*** INIZIO GESTIONE RAGGRUPPAMENTO PARTITE
					SELECT TESORERIA_PAGATI
					IF ___LEGA_MOV!=ID_MOVIMEN AND ___LEGA_MOV=LEGA_MOV
						_RAGGRUPPA_INDICE	="INDICE CARICATO"
						_RAGGRUPPA_NDOC		=""
						CGE_NUMPRO	=	___RAGGRUPPA_NUMPRO
						CGE_NREG	=	___RAGGRUPPA_NREG
						=MOVIMENTO_DARE("NON CREARE NUOVO NUMPRO","INDICE CARICATO","NON CREARE NUOVO NUMREG","NON CREARE NUOVO NUMDOC")
						
						___RAGGRUPPA_TOTALE_PRIMA_NOTA	=	___RAGGRUPPA_TOTALE_PRIMA_NOTA + CGE_DA  + CGE_AV
						
					ELSE
				        =MOVIMENTO_DARE()
						___RAGGRUPPA_NUMPRO				=	CGE_NUMPRO
						___RAGGRUPPA_NREG  				=	CGE_NREG
						___RAGGRUPPA_TOTALE_PRIMA_NOTA	=	CGE_DA + CGE_AV
					ENDIF
					
			        IF RIGA_BANCA 
				        ___totpag=IMPO_BANCA
				        =MOVIMENTO_AVERE()
				    ENDIF
				    
					___RAGGRUPPA_SEQUEN	= CGE_SEQUEN
					
			        _NUMPRO_MENTRE_PAGO_O_INCASSO  = CGE_NUMPRO
			        
			        =AGGIORNA_TOTINDICE(CGE_NUMPRO ,___RAGGRUPPA_TOTALE_PRIMA_NOTA)
				    
					*** FINE GESTIONE RAGGRUPPAMENTO PARTITE
				ELSE
				
			        =MOVIMENTO_DARE()
			        
			        =MOVIMENTO_AVERE()
			        
			        _NUMPRO_MENTRE_PAGO_O_INCASSO  = CGE_NUMPRO
			        
			    ENDIF

		        
		        CONTAMOV = CONTAMOV + 1

				
		    ENDIF

	        *** VERIFICO SE ESISTONO DEGLI IMPORTI AGGIUNTIVI
	        DO PRG\TESORERIA_CONTAB_AGG
		    	        
        ENDIF  ___TIPOLOGIA="COMP" 
        
    ***##############################  AGGIORNO DOCUMENTI EXTRACONTABILI CHIUDENDOLI
        
		*** FINANZIAMENTO
		****************************************************************
	        IF ___TIPOLOGIA="FINANZIAMENTO"  

      		SELECT TESORERIA_PAGATI
      		_ID_PARTITA=ALLTRIM(ID_MOVIMEN)
			
			cSql=""     
			cNomeCursorSql="CFIN_DD"
			
			TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
			
				UPDATE U_FIN_DD 
				SET FIN_STATUS='Pagato' ,
					FIN_NUMPRO = '<<_NUMPRO_MENTRE_PAGO_O_INCASSO>>' 
				WHERE ID_UNIQUE ='<<_ID_PARTITA>>'
				
			ENDTEXT					&& FINE SCRITTURA QUERY
			
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF
    		
        ENDIF
        
		*** LEASING
		****************************************************************
		IF ___TIPOLOGIA="LEASING"  

      		SELECT TESORERIA_PAGATI
      		_ID_PARTITA=ALLTRIM(ID_MOVIMEN)
			
			cSql=""     
			cNomeCursorSql="CLEA_DD"
			
			TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
			
				UPDATE U_LEA_DD 
				SET LEA_STATUS='Pagato' ,
					LEA_NUMPRO = '<<_NUMPRO_MENTRE_PAGO_O_INCASSO>>' 
				WHERE ID_UNIQUE ='<<_ID_PARTITA>>'
				
			ENDTEXT					&& FINE SCRITTURA QUERY
			
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF
    		
        ENDIF

	    
		*** CONTRATTO
		****************************************************************
	    IF ___TIPOLOGIA="CONTRATTO"  

      		SELECT TESORERIA_PAGATI
      		_ID_PARTITA=ALLTRIM(ID_MOVIMEN)
			
			cSql=""     
			cNomeCursorSql="CCON_DD"
			
			TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
			
				UPDATE U_CON_DD 
				SET CON_STATUS= 'Pagato',
					CON_NUMPRO = '<<_NUMPRO_MENTRE_PAGO_O_INCASSO>>' 
				WHERE ID_UNIQUE ='<<_ID_PARTITA>>'
				
			ENDTEXT					&& FINE SCRITTURA QUERY
			
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF
    		
        ENDIF


		*** EFFETTI PASSIVI
		****************************************************************
        IF ___TIPOLOGIA="EFF.PASS."  
      		SELECT TESORERIA_PAGATI
      		_ID_PARTITA=ALLTRIM(ID_MOVIMEN)
      		
				
			cSql=""     
			cNomeCursorSql="CEFF_DD"
			
			TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
			
				UPDATE U_ASS_DD 
				SET ASS_STATUS = 'Incassato',
					ASS_NUMPRO = '<<_NUMPRO_MENTRE_PAGO_O_INCASSO>>' 
				WHERE ID_UNIQUE ='<<_ID_PARTITA>>'
				
			ENDTEXT					&& FINE SCRITTURA QUERY
			
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF
        ENDIF
        
		*** EFFETTI ATTIVI
		****************************************************************

        IF ___TIPOLOGIA="EFF.ATT."  
      		SELECT TESORERIA_PAGATI
      		_ID_PARTITA=ALLTRIM(ID_MOVIMEN)
      		
			cSql=""     
			cNomeCursorSql="CEFF_DD"
			
			TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
			
				UPDATE U_ASC_DD 
				SET ASS_STATUS = 'Incassato',
					ASS_NUMPRO = '<<_NUMPRO_MENTRE_PAGO_O_INCASSO>>' 
				WHERE ID_UNIQUE ='<<_ID_PARTITA>>'
				
			ENDTEXT					&& FINE SCRITTURA QUERY
			
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF
        ENDIF
        
*** FABIANO 20/09/2006
***        
		*** STIPENDIO
		****************************************************************

        IF ___TIPOLOGIA="STIPENDIO"
      		SELECT TESORERIA_PAGATI
      		
			_MESE_STIPENDIO=ALLTRIM(STR(NPART))
      		
			cSql=""     
			cNomeCursorSql="CSTIP"
			
			
			TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
			
				UPDATE U_GPP_MO
				SET GPP_PAGATO='S'
				WHERE GPP_ANNO+GPP_MESE='<<_MESE_STIPENDIO>>' 
				
			ENDTEXT					&& FINE SCRITTURA QUERY
			
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF
        ENDIF

*** FABIANO 20/09/2006
*** FINE       
        SELECT TESORERIA_PAGATI
        
		*** INIZIO GESTIONE RAGGRUPPAMENTO PARTITE
		IF ___LEGA_MOV!=LEGA_MOV

			___LEGA_MOV=LEGA_MOV
		ENDIF
		*** FINE GESTIONE RAGGRUPPAMENTO PARTITE
		
        
        SKIP +1
    
        
ENDDO WHILE !EOF()

*** INIZIO GESTIONE RAGGRUPPAMENTO PARTITE
RELEASE ___LEGA_MOV

*** FINE GESTIONE RAGGRUPPAMENTO PARTITE


PUB_ERRORE=MESSAGEBOX("CONTABILIZZAZIONE EFFETTUATA , NUMERO MOVIMENTI CREATI :"+STR(CONTAMOV,8,0),64,"*** ATTENZIONE ***") 

RETURN .T.
ENDPROC
* FINE... PROCEDURE TESPAGA
**************************************************************************


**************************************************************************
FUNCTION MOVIMENTO_DARE           && CREA IL MOVIMENTO DARE : FORNITORE
**************************************************************************
PARAMETERS _PAR_NUMPRO ,;  
           _PAR_INDICE ,;  
           _PAR_NREG   ,;
           _PAR_NDOC   


_NPARF              = ""                  && SE NON IMPOSTATA CARICA AUTOMATICAMENTE CGE_NPARF
CGE_NPARF           = ___NPART            

IF PCOUNT()>=1 
	_NUMPRO             = _PAR_NUMPRO          
ELSE
	_NUMPRO             = "CARICA"          && AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
ENDIF

IF PCOUNT()>=2 
	_INDICE             = _PAR_INDICE          
ELSE
	_INDICE             = "CARICA"          && CREA INDICE
ENDIF

IF PCOUNT()>=3 
	_NREG               = _PAR_NREG          
ELSE
	_NREG               = "CARICA"            &&CERCA IL NUMERO DI REGISTRAZIONE UTENTE
ENDIF

IF PCOUNT()>=4 
	_NDOC               = _PAR_NDOC         
ELSE
	_NDOC               = ___NDOCU          && IMPOSTA IL NUMERO DI DOCUMENTO = PARTITA
ENDIF

CGE_CON             = ___codfor
CGE_DA              = ___totpag
CGE_AV              = 0

IF CGE_TOPX=PUB_PAGANCR
    CGE_DA               = 0
    CGE_AV               = ___totpag
ENDIF

CGE_IV               = "NO"
CGE_IMP              = 0.00

CGE_DESCO              = ___desfor
CGE_CECOS              = SPACE(13)  
CGE_WCCAGE             = SPACE(3)
CGE_KABBUO             = 0
CGE_XNOTE              = SPACE(13)
CGE_XCCLI              = SPACE(10)
CGE_XCFOR              = SPACE(10)
CGE_DATAREG            = ___DATAREGISTRAZIONE
CGE_DATADOC            = ___DATAREGISTRAZIONE
CGE_NDOC            = ___NDOCU
CGE_FR                = .F.
CGE_PESO            = 0
CGE_TISPE            = SPACE(03)
CGE_PORTO            = SPACE(03)
CGE_CLDOG            = SPACE(16)
CGE_BANCA            = "001"
CGE_DATASCAD        = ___dtscad
CGE_CPA                = PUB_CPA
CGE_BOLLATOIVA        = SPACE(01)

CGE_COSATRATTA        = ___COSATRATTA
CGE_GRADOIMPORTANZA    = ___GRADOIMPORTANZA
CGE_FORMAPAGAMENTO    = ___FORMAPAGAMENTO
CGE_TIPOCONTRATTO    = ___TIPOCONTRATTO 
CGE_CODACQ            = ___CODACQ
CGE_PRIPAGA            = ___PRIPAGA


CGE_XCAMBIO            = PUB_CAMBIO
CGE_XVALUTA            = "EUR"

*** Fabiano 14/04/2005 - GESTIONE DATA VALUTA
CGE_XDATAVAL        = ___dtvalu 
CGE_XANOMAX            = SPACE(3) 
CGE_CECO            = SPACE(10)
CGE_SEQUEN            = CGE_SEQUEN            +10                && AD OGNI RIGA INSERITA SOMMARE 10 

CGE_COMM             = "PAGAMENTO N.: "+ALLTRIM(CGE_NDOC)+" DEL "+CGE_DATADOC
CGE_COM1             = "REGISTRAZIONE DEL : "+CGE_DATAREG

*** Fabiano 14/04/2005 - GESTIONE DATA VALUTA
CGE_DTPAG			 = ___dtscad

IF pub_consolida_prev=1
    PUB_TIPOGE            = "PREVISIONALE"    && CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ELSE
    PUB_TIPOGE            = "EFFETTIVA"    && CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ENDIF

=AQUAREP("FOR",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)

RETURN
*** FINE FUNCTION MOVIMENTO_DARE
**************************************************************************


**************************************************************************
FUNCTION MOVIMENTO_DARE_BANCA           && CREA IL MOVIMENTO DARE : BANCA
**************************************************************************
PARAMETERS _PAR_NUMPRO ,;  
           _PAR_INDICE ,;  
           _PAR_NREG   ,;
           _PAR_NDOC   
           
_NPARF              = ""                  && SE NON IMPOSTATA CARICA AUTOMATICAMENTE CGE_NPARF
CGE_NPARF           = ___NPART            

IF PCOUNT()>=1 
	_NUMPRO             = _PAR_NUMPRO          
ELSE
	_NUMPRO             = "CARICA"          && AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
ENDIF

IF PCOUNT()>=2 
	_INDICE             = _PAR_INDICE          
ELSE
	_INDICE             = "CARICA"          && CREA INDICE
ENDIF

IF PCOUNT()>=3 
	_NREG               = _PAR_NREG          
ELSE
	_NREG               = "CARICA"            &&CERCA IL NUMERO DI REGISTRAZIONE UTENTE
ENDIF

IF PCOUNT()>=4 
	_NDOC               = _PAR_NDOC         
ELSE
	_NDOC               = ___NDOCU          && IMPOSTA IL NUMERO DI DOCUMENTO = PARTITA
ENDIF

CGE_CON             = ___codban
CGE_DA              = ___totpag
CGE_AV              = 0

IF CGE_TOPX=PUB_PAGANCR
    CGE_DA               = 0
    CGE_AV               = ___totpag
ENDIF

CGE_IV               = "NO"
CGE_IMP              = 0.00

CGE_DESCO              = ___desban
CGE_CECOS              = SPACE(13)  
CGE_WCCAGE             = SPACE(3)
CGE_KABBUO             = 0
CGE_XNOTE              = SPACE(13)
CGE_XCCLI              = SPACE(10)
CGE_XCFOR              = SPACE(10)
CGE_DATAREG            = ___DATAREGISTRAZIONE
CGE_DATADOC            = ___DATAREGISTRAZIONE
CGE_NDOC            = ___NDOCU
CGE_FR                = .F.
CGE_PESO            = 0
CGE_TISPE            = SPACE(03)
CGE_PORTO            = SPACE(03)
CGE_CLDOG            = SPACE(16)
CGE_BANCA            = "001"
CGE_DATASCAD        = ___dtscad
CGE_CPA                = PUB_CPA
CGE_BOLLATOIVA        = SPACE(01)

CGE_COSATRATTA        = ___COSATRATTA
CGE_GRADOIMPORTANZA    = ___GRADOIMPORTANZA
CGE_FORMAPAGAMENTO    = ___FORMAPAGAMENTO
CGE_TIPOCONTRATTO    = ___TIPOCONTRATTO 
CGE_CODACQ            = ___CODACQ
CGE_PRIPAGA            = ___PRIPAGA


CGE_XCAMBIO            = PUB_CAMBIO
CGE_XVALUTA            = "EUR"

*** Fabiano 14/04/2005 - GESTIONE DATA VALUTA
CGE_XDATAVAL        = ___dtvalu 
CGE_XANOMAX            = SPACE(3) 
CGE_CECO            = SPACE(10)
CGE_SEQUEN            = CGE_SEQUEN            +10                && AD OGNI RIGA INSERITA SOMMARE 10 

CGE_COMM             = "PAGAMENTO N.: "+ALLTRIM(CGE_NDOC)+" DEL "+CGE_DATADOC
CGE_COM1             = "REGISTRAZIONE DEL : "+CGE_DATAREG

*** Fabiano 14/04/2005 - GESTIONE DATA VALUTA
CGE_DTPAG			 = ___dtscad

IF pub_consolida_prev=1
    PUB_TIPOGE            = "PREVISIONALE"    && CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ELSE
    PUB_TIPOGE            = "EFFETTIVA"    && CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ENDIF

=AQUAREP("FOR",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)

RETURN
*** FINE FUNCTION MOVIMENTO_DARE_BANCA
**************************************************************************



**************************************************************************
FUNCTION MOVIMENTO_AVERE           && CREA IL MOVIMENTO AVERE : BANCA
**************************************************************************
PARAMETERS _PAR_NPART

************************************************* RECORD BANCA  *****************************
*CGE_TOPX            = PUB_PAGAFOR        && TIPO OPERAZIONE                        


IF PCOUNT()>=1 
	_NPARF             = _PAR_NPART          
ELSE
ENDIF

_NPARF              = ""                && SE NON IMPOSTATA CARICA AUTOMATICAMENTE CGE_NPARF
_NUMPRO             = CGE_NUMPRO          && AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
_INDICE             = "INDICE CARICATO" && NON CREA INDICE
_NREG               = ""                && MANTIENE IL NUMERO DI REGISTRAZIONE UTENTE
_NDOC               = ""                && MANTIENE IL NUMERO DI REGISTRAZIONE PRECEDENTE

CGE_CON             = ___codban

CGE_DA              = 0
CGE_AV              = ___totpag

IF CGE_TOPX=PUB_PAGANCR
    CGE_DA          = ___totpag
    CGE_AV          = 0
ENDIF

CGE_IV               = "NO"
CGE_IMP              = 0                    && IMPOSTA CALCOLATA SOLO SE SI TRATTA DI FATTURA

CGE_DESCO              = ___desban
CGE_CECOS              = SPACE(13)  
CGE_WCCAGE             = SPACE(3)
CGE_KABBUO             = 0
CGE_XNOTE              = SPACE(13)
CGE_XCCLI              = SPACE(10)
CGE_XCFOR              = SPACE(10)
CGE_DATAREG            = ___DATAREGISTRAZIONE
CGE_DATADOC            = ___DATAREGISTRAZIONE
CGE_NDOC            = ___NDOCU
CGE_FR                = .F.
CGE_PESO            = 0
CGE_TISPE            = SPACE(03)
CGE_PORTO            = SPACE(03)
CGE_CLDOG            = SPACE(16)
CGE_BANCA            = "001"
CGE_DATASCAD        = ___dtscad
CGE_CPA                = PUB_CPA
CGE_BOLLATOIVA        = SPACE(01)

CGE_COSATRATTA        = ___COSATRATTA
CGE_GRADOIMPORTANZA    = ___GRADOIMPORTANZA
CGE_FORMAPAGAMENTO    = ___FORMAPAGAMENTO
CGE_TIPOCONTRATTO    = ___TIPOCONTRATTO 
CGE_CODACQ            = ___CODACQ
CGE_PRIPAGA            = ___PRIPAGA



CGE_XCAMBIO            = PUB_CAMBIO
CGE_XVALUTA            = "EUR"
*** Fabiano 14/04/2005 - GESTIONE DATA VALUTA
CGE_XDATAVAL        = ___dtvalu
CGE_XANOMAX            = SPACE(3) 
CGE_CECO            = SPACE(10)
CGE_SEQUEN            = CGE_SEQUEN            +10                && AD OGNI RIGA INSERITA SOMMARE 10 

IF pub_consolida_prev=1
    PUB_TIPOGE            = "PREVISIONALE"    && CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ELSE
    PUB_TIPOGE            = "EFFETTIVA"    && CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ENDIF
CGE_COMM             = "PAGAMENTO N.: "+ALLTRIM(CGE_NDOC)+" DEL "+CGE_DATADOC
CGE_COM1             = "REGISTRAZIONE DEL : "+CGE_DATAREG


*** Fabiano 14/04/2005 - GESTIONE DATA VALUTA
CGE_DTPAG			 = ___dtscad


=AQUAREP("CLI",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)

RETURN
*** FINE FUNCTION MOVIMENTO_AVERE
**************************************************************************


**************************************************************************
FUNCTION MOVIMENTO_AVERE_CLIENTE           && CREA IL MOVIMENTO AVERE : cliente
**************************************************************************
PARAMETERS _PAR_NPART

************************************************* RECORD BANCA  *****************************
*CGE_TOPX            = PUB_PAGAFOR        && TIPO OPERAZIONE                        


IF PCOUNT()>=1 
	_NPARF             = _PAR_NPART          
ELSE
ENDIF

_NPARF                 = ""                && SE NON IMPOSTATA CARICA AUTOMATICAMENTE CGE_NPARF
_NUMPRO             = CGE_NUMPRO          && AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
_INDICE             = "INDICE CARICATO" && NON CREA INDICE
_NREG                = ""                && MANTIENE IL NUMERO DI REGISTRAZIONE UTENTE
_NDOC                = ""                && MANTIENE IL NUMERO DI REGISTRAZIONE PRECEDENTE

CGE_CON                = ___codfor

CGE_DA               = 0
CGE_AV               = ___totpag

IF CGE_TOPX=PUB_PAGANCR
    CGE_DA               = ___totpag
    CGE_AV               = 0
ENDIF

CGE_IV               = "NO"
CGE_IMP              = 0                    && IMPOSTA CALCOLATA SOLO SE SI TRATTA DI FATTURA

CGE_DESCO              = ___desfor
CGE_CECOS              = SPACE(13)  
CGE_WCCAGE             = SPACE(3)
CGE_KABBUO             = 0
CGE_XNOTE              = SPACE(13)
CGE_XCCLI              = SPACE(10)
CGE_XCFOR              = SPACE(10)
CGE_DATAREG            = ___DATAREGISTRAZIONE
CGE_DATADOC            = ___DATAREGISTRAZIONE
CGE_NDOC            = ___NDOCU
CGE_FR                = .F.
CGE_PESO            = 0
CGE_TISPE            = SPACE(03)
CGE_PORTO            = SPACE(03)
CGE_CLDOG            = SPACE(16)
CGE_BANCA            = "001"
CGE_DATASCAD        = ___dtscad
CGE_CPA                = PUB_CPA
CGE_BOLLATOIVA        = SPACE(01)

CGE_COSATRATTA        = ___COSATRATTA
CGE_GRADOIMPORTANZA    = ___GRADOIMPORTANZA
CGE_FORMAPAGAMENTO    = ___FORMAPAGAMENTO
CGE_TIPOCONTRATTO    = ___TIPOCONTRATTO 
CGE_CODACQ            = ___CODACQ
CGE_PRIPAGA            = ___PRIPAGA



CGE_XCAMBIO            = PUB_CAMBIO
CGE_XVALUTA            = "EUR"
*** Fabiano 14/04/2005 - GESTIONE DATA VALUTA
CGE_XDATAVAL        = ___dtvalu
CGE_XANOMAX            = SPACE(3) 
CGE_CECO            = SPACE(10)
CGE_SEQUEN            = CGE_SEQUEN            +10                && AD OGNI RIGA INSERITA SOMMARE 10 

IF pub_consolida_prev=1
    PUB_TIPOGE            = "PREVISIONALE"    && CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ELSE
    PUB_TIPOGE            = "EFFETTIVA"    && CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ENDIF
CGE_COMM             = "PAGAMENTO N.: "+ALLTRIM(CGE_NDOC)+" DEL "+CGE_DATADOC
CGE_COM1             = "REGISTRAZIONE DEL : "+CGE_DATAREG


*** Fabiano 14/04/2005 - GESTIONE DATA VALUTA
CGE_DTPAG			 = ___dtscad


=AQUAREP("CLI",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)

RETURN
*** FUNCTION MOVIMENTO_AVERE_CLIENTE
**************************************


***************************	
* Procedure EstrazioneIncassiPerTabulato
***************************

PROCEDURE EstrazioneIncassiPerTabulato

IF FILE("_$.BAK")

		IF !USED('STRINGSQL')
			USE	STRINGSQL IN 0 AGAIN
		ENDIF

		SELECT STRINGSQL 
		replace CONNDEF WITH 'S' FOR ID_WRK!=SYS(0)
		USE
		
ENDIF	
	

SELECT MOVIMENTI 
DELETE FOR "INC. PREVISTO" $ TIPOLOGIA 

cSql=""     
cNomeCursorSql="CUR_CONTI"

TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

SELECT 	T1.ORD_DESCCO AS DES_DA,
        T2.ORD_NOTE AS NOTE, 
	    T1.ORD_CONTO AS CODRIS_DA,   
	    T2.ORD_VALORE AS IMPORTO,               
	    T2.ORD_DATREG AS DT_CONTAB,
	    T2.ORD_CAUS AS TIPOTOP            
FROM U_CCO_TT AS T1 
INNER JOIN U_CCO_DD AS T2 
ON T1.TAGGANCIO=T2.DAGGANCIO 
AND (T2.ORD_CAUS='<<PUB_INCCLI>>' OR T2.ORD_CAUS='<<PUB_ANTRIB>>'  OR T2.ORD_CAUS='BAC'   OR T2.ORD_CAUS='INC' )
INNER JOIN U_BAN_AN AS T3     
ON T1.ORD_BANCA=T3.BAN_CODBAN 

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

_DESCRIZIONE=""

SELECT CUR_CONTI

GO TOP
DO WHILE !EOF()

	SELECT CUR_CONTI
 	SCATTER MEMVAR MEMO

 	_NOTE=""
	STORE MEMLINES(NOTE) TO gnNumLines   && Number of lines in memo field
	FOR gnCount = 1 TO gnNumLines   && Loop for # of lines in memo field
	   _NOTE =_NOTE+MLINE(NOTE, gnCount)      && Display each line
	NEXT
 	
	_TOP=TIPOTOP
	_DESCRIZIONE=GET_DES("TOP",_TOP)+" ("+_TOP+")"
	
	
 	SELECT MOVIMENTI
	APPEND BLANK
	GATHER MEMVAR
	
	REPLACE DES_MOVIME 	WITH _DESCRIZIONE,;
			TIPOLOGIA	WITH 'INC. PREVISTO ('+ALLTRIM(_TOP)+')',;
			DES_A		WITH _DESCRIZIONE+' '+IIF(!EMPTY(ALLTRIM(_NOTE)),ALLTRIM(_NOTE),' (su '+ALLTRIM(M.DES_DA)+')'),;
			ID_MOVIMEN	WITH SYS(2015)
	
	SELECT CUR_CONTI
	SKIP
ENDDO

SELECT MOVIMENTI
RETURN 
***************************


*************************************************************************
*   					CREA PARTITARI E SALDI PARTITE             		*
*************************************************************************
FUNCTION TESORERIA_REP_PARTIT

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_annp = "con_anno = '" + PUB_ANNOP + "'"
x_cont = "con_conto = '" + ALLTRIM(CGE_CON) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
x_conp = x_soci + " and " + x_annp + " and " + x_cont
IF M.TOP = "CHI"
   Csql   = "select * from conti where " + x_conp + " order by con_soc,con_anno,con_conto"
ELSE
   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
ENDIF
IF !ExecCommand(cSql,"cur_conti")
   return(.f.)
ENDIF
SELECT cur_conti
GO TOP
IF EOF()
   PUB_ERRORE=MESSAGEBOX('Conto inesistente durante'+CHR(13)+"l'aggiornamento partitario",64,'*** ATTENZIONE ***')
   RETURN
ENDIF
CLI_FOR = SUBSTR(CON_TIPOCO,1,1)


IF CLI_FOR='C'
   =AQUAREP_PARCLI()         && AGGIORNA PARTITARIO CLIENTI
ENDIF

IF CLI_FOR='F'
   =TESORERIA_REP_PARFOR()         && AGGIORNA PARTITARIO FORNITORI
ENDIF

RETURN


*************************************************************************
*   			CREA PARTITARI E SALDI PARTITE FORNITORI           		*
*************************************************************************
FUNCTION TESORERIA_REP_PARFOR


*** QUESTI MANCAVANO RICHIAMANDO DIRETTAMENTE AQUAREP_PARTFOR
CGE_XVALUTA="EUR"
__CONTO="F"
SELECT TESORERIA_PAGATI
CGE_DATASCAD=TESORERIA_PAGATI.DTSCAD

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
*x_codi = "for_codcli = '" + SUBSTR(CGE_CON,PUB_SOTTOG,PUB_CONTO) + "'"
x_codi = "for_codcli = '" + IIF(PUB_CONTOSIMILCEE, TRC(PUB_LCL,ALLTRIM(SUBSTR(CGE_CON,RAT('.',CGE_CON,1)+1))), ALLTRIM(SUBSTR(CGE_CON,PUB_SOTTOG,PUB_CONTO))) + "'"  && SERGIO - 18/12/2021

x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"cur_fornitori")
   return(.f.)
ENDIF

RELEASE V_DESCRIC
PUBLIC V_DESCRIC


SELECT cur_fornitori
GO TOP
IF EOF()
   V_DESCRIC = SPACE(15)
   V_TELEFO  = SPACE(15)
   V_PARIVA  = SPACE(11)
   V_CONPAG  = PUB_CPA 
ELSE
   V_DESCRIC = FOR_RAGSOC
   V_TELEFO  = FOR_TELEFO
   V_PARIVA  = FOR_PARIVA
   V_CONPAG  = FOR_CONPAG
ENDIF

IF !ExecCommand("select * from part_for where 0=1","cur_partfor")
   return(.f.)
ENDIF


SELECT CUR_PARTFOR
APPEND BLANK
REC_PART=RECNO()


REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
REPLACE PAR_TIPODO  WITH "FAT"

IF FATTURA='P'
   REPLACE PAR_TIPODO  WITH "PAG"
ENDIF

IF FATTURA='I'
   REPLACE PAR_TIPODO  WITH "INS"
ENDIF

IF FATTURA='N'
   REPLACE PAR_TIPODO  WITH "NCR"
ENDIF

											
IF FATTURA='A'
   REPLACE PAR_TIPODO  			WITH "PAG"
   REPLACE PAR_NPARTO           WITH CGE_NPARF  && CONSIDERA COME NUMERO DI PARTITA ETERNO
ENDIF


REPLACE PAR_CODCLI  WITH CGE_CON
REPLACE PAR_RAGSOC  WITH V_DESCRIC
REPLACE PAR_DTREG   WITH RIBALTA2(CGE_DATAREG)
REPLACE PAR_DTFAT   WITH RIBALTA2(CGE_DATADOC)
REPLACE PAR_TIPFAT  WITH CGE_TOPX
REPLACE PAR_TOTIM   WITH (CGE_TOTDOCU-CGE_IMP+CGE_KABBUO)       
REPLACE PAR_TIMPOS  WITH CGE_IMP
REPLACE PAR_FATT    WITH CGE_TOTDOCU+CGE_KABBUO                                    && SOMMA EVENTUALE ABBUONO
REPLACE PAR_NUMFAT  WITH CGE_NDOC

* --------  Gestione contabilità previsionale -------- *
 IF ALLTRIM(PUB_TIPOGE) = "PREVISIONALE"
   REPLACE PAR_CONTABILITA_PREVISIONALE    WITH "P"
 ELSE
   REPLACE PAR_CONTABILITA_PREVISIONALE    WITH " "
 ENDIF
* --------  Gestione contabilità previsionale -------- *

      * --------  Blocca / sblocca registrazione previsionale -------- *
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIEFFETTIVA"
	      REPLACE PAR_CONTABILITA_PREVISIONALE    WITH " "
	  ENDIF
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIPREVISIONALE"
	      REPLACE PAR_CONTABILITA_PREVISIONALE    WITH "P"
	  ENDIF
      * --------  Blocca / sblocca registrazione previsionale -------- *

* --------  Classifica la partita -------- *
REPLACE PAR_COSATRATTA 		WITH CGE_COSATRATTA
REPLACE PAR_GRADOIMPORTANZA WITH CGE_GRADOIMPORTANZA
REPLACE PAR_FORMAPAGAMENTO 	WITH CGE_FORMAPAGAMENTO
REPLACE PAR_TIPOCONTRATTO 	WITH CGE_TIPOCONTRATTO
REPLACE PAR_CODACQ			WITH CGE_CODACQ
REPLACE PAR_PRIPAGA			WITH CGE_PRIPAGA
* --------  Classifica la partita -------- *

* ---------  Controllo ddt/fatture -------- *
REPLACE PAR_ANOMAX			WITH CGE_XANOMAX    
* ---------  Controllo ddt/fatture -------- *



* ------- MAX Nuovi Campi Per Euro ------- *
REPLACE PAR_CAMBIO WITH CGE_XCAMBIO
REPLACE PAR_VALUTA WITH CGE_XVALUTA
REPLACE PAR_DTVAL  WITH RIBALTA2(CGE_XDATAVAL)
* ------- MAX Nuovi Campi Per Euro ------- *
REPLACE PAR_BANCA   WITH CGE_BANCA
IF EMPTY(TOP_COL)
   REPLACE PAR_NPROG   WITH 100
ELSE
   REPLACE PAR_NPROG   WITH 900
ENDIF
IF PAR_TIPODO <> "FAT"  && GESTIONE INSERIMENTO DA PRIMA NOTA
   REPLACE PAR_NPROG   WITH 900
ENDIF
IF __CONTO ='I'   && APERTURA DI BILANCIO PER CLIENTI FORNITORI
   REPLACE PAR_TIPODO  WITH "PAG"
   REPLACE PAR_NPROG   WITH 900
ENDIF 


_SALVA_TOTDOCU=CGE_TOTDOCU
_SALVA_DA=CGE_DA

CGE_TOTDOCU=___totpag

CGE_DA=___totpag



REPLACE PAR_NPART   WITH CGE_NPARF       && CONSIDERA COME NUMERO DI PARTITA ETERNO
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(CGE_NREG)
REPLACE PAR_NUMPRO  WITH ALLTRIM(CGE_PN_C)
REPLACE PAR_CIVA1   WITH CGE_IV
REPLACE PAR_IMPO1   WITH (CGE_TOTDOCU-CGE_IMP+CGE_KABBUO)
REPLACE PAR_IMPOS1  WITH CGE_IMP
REPLACE PAR_TOT1    WITH CGE_TOTDOCU+CGE_KABBUO
REPLACE PAR_TOTIM   WITH (CGE_TOTDOCU-CGE_IMP+CGE_KABBUO)
REPLACE PAR_TIMPOS  WITH CGE_IMP
REPLACE PAR_FATT    WITH CGE_TOTDOCU+CGE_KABBUO
REPLACE PAR_DESMOV  WITH CGE_COMM
REPLACE PAR_DESMO1  WITH CGE_COM1
REPLACE PAR_FATRI   WITH CGE_FR        && FATTURE FORNITORI IN RITARDO


IF CGE_DA<>0
   REPLACE PAR_TMOV WITH "D"
ENDIF
IF CGE_AV<>0
   REPLACE PAR_TMOV WITH "A"
ENDIF

IF FATTURA='P' .OR.  FATTURA='I'  .OR. CGE_AGGANCIAPARTITARI = 'S'          && GESTISCO UNA SECONDA REPLACE A QUESTO PUNTO
   REPLACE PAR_TOTIM   WITH CGE_DA+CGE_AV+KABBUO                            && SOMMA EVENTUALE ABBUONO
   REPLACE PAR_TIMPOS  WITH 0
   REPLACE PAR_FATT    WITH CGE_DA+CGE_AV+KABBUO                            && SOMMA EVENTUALE ABBUONO
   REPLACE PAR_IMPO1   WITH 0
   REPLACE PAR_IMPOS1  WITH 0
   REPLACE PAR_TOT1    WITH 0
   REPLACE PAR_NPROG   WITH 900
ENDIF

DATA_SCAD=SPACE(10)
=AQUAREP_SCADF()      && GESTIONE SCADENZIARIO FORNITORI SOLO SE FATTURE / EFFETTI


SELECT CUR_PARTFOR
GO TOP

XYZ_CONTO   = PAR_CODCLI	 && CODICE DEL FORNITORE
XYZ_PARTITA = PAR_NPART	 	 && PARTITA FORNITORE


IF EMPTY(DATA_SCAD)
	REPLACE PAR_DTSCAD  		 WITH RIBALTA2(CGE_DATASCAD)
ELSE
	REPLACE PAR_DTSCAD  		 WITH RIBALTA2(DATA_SCAD)
ENDIF


*** Fabiano 14/04/2005 - GESTIONE PAR_DATPAG
IF EMPTY(CGE_DTPAG)
	REPLACE PAR_DATPAG WITH PAR_DTSCAD 
ELSE
	REPLACE PAR_DATPAG WITH CGE_DTPAG 
ENDIF




IF !ExecRW('','part_for','I','','CUR_PARTFOR')
   return(.f.)
ENDIF



=CREA_SALDI_CF("F",XYZ_CONTO,XYZ_PARTITA,"XXXXXXXXXX","CREA")



CGE_TOTDOCU	=_SALVA_TOTDOCU
CGE_DA		=_SALVA_DA


RETURN




**********************************
PROCEDURE AGGIORNA_TOTINDICE
**********************************
PARAMETERS _NUMPRO,_TOTALE_DA_SOSTITUIRE

  IF !ExecCommand("select * from indice where MOV_NUMPRO ='"+ALLTRIM(_NUMPRO)+"'","_CCCCC_INDICE")
     return(.f.)
  ENDIF
  SELECT _CCCCC_INDICE
  REPLACE MOV_IMP 	WITH _TOTALE_DA_SOSTITUIRE
  IF !ExecRW('','indice','I','','_CCCCC_INDICE')
     return(.f.)
  ENDIF
      
*** FINE PROCEDURE AGGIORNA_TOTINDICE
***********************************

**************************************************************************
FUNCTION VIEWCOMPENSAZIONIPARTITA
**************************************************************************
PARAMETERS PAR_NPART

cSql=""     
cNomeCursorSql="_CCCMP"

TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

	SELECT
		CONTI.CON_DESCR AS DESCRI,
		U_CMP_TT.*
    FROM U_CMP_TT 
	INNER JOIN CONTI
	ON CONTI.CON_CONTO=U_CMP_TT.CMP_CONTO
	WHERE CONTI.CON_ANNO='<<PUB_ANNO>>'
	AND CMP_ID IN (SELECT CMP_ID FROM U_CMP_TT WHERE CMP_NPART=<<PAR_NPART>>)
	ORDER BY CONTI.CON_DESCR,CMP_NPART


ENDTEXT					&& FINE SCRITTURA QUERY

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

DO prg\browseview WITH "_CCCMP","Elenco compensazioni associate alla partita "+ALLTRIM(STR(PAR_NPART)),;
	"CMP_NPART:N.partita;CMP_CLIFOR:Cli/For;CMP_CONTO:Conto;DESCRI:Descrizione conto,W:20;CMP_TOP:Top;CMP_DARE:Dare,W:15;CMP_AVERE:Avere,W:15;CMP_DESMOV:Descrizione;",500,900,.F.

SELECT _CCCMP
USE

*** FINE FUNCTION SALVAESITOCOMP
**************************************************************************

**************************************************************************
FUNCTION VIEWCOMPENSAZIONIPERTESORERIA
**************************************************************************

SELECT PAGATI

IF TIPOLOGIA!="COMP"
	RETURN
ENDIF


SELECT * FROM MOVIMENTI ;
	WHERE 	(CODRIS_A NOT LIKE PUB_CC+'%' AND CODRIS_DA NOT LIKE PUB_CC+'%' AND TIPOLOGIA!='RIBA') ;
			OR TIPOLOGIA='COMP' 	;	
	INTO CURSOR TESORERIA_PAGATI
	
SELECT TESORERIA_PAGATI

IF !TESPAGA(.F.)
	RETURN
ENDIF

SELECT CESITOCOMP
GO TOP

DO prg\browseview WITH "CESITOCOMP","Elenco partite associate alla compensazione selezionata",;
	"NPART:N.partita;CLIFOR:Cli/For;CONTO:Conto;TOP:Top;DARE:Dare,W:15;AVERE:Avere,W:15;DESMOV:Descrizione;",500,900,.F.

SELECT CESITOCOMP
GO TOP

*** FINE FUNCTION VIEWCOMPENSAZIONIPERTESORERIA
**************************************************************************



**************************************************************************
PROCEDURE CANCCOMP
**************************************************************************
PARAMETERS PAR_ID

cSql=""     
cNomeCursorSql="_CCCMP"

TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

	DELETE
    FROM U_CMP_TT 
	WHERE CMP_ID = '<<PAR_ID>>'


ENDTEXT					&& FINE SCRITTURA QUERY



IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF


*** FINE PROCEDURE CANCCOMP
**************************************************************************




******************************
PROCEDURE SELE_APERTE_CLI
******************************
PARA XXX_CONTO,XXX_DESCRI,XXX_NSALDO,XXX_DTSCAD

LOCAL nNumeroRecord

nNumeroRecord=0

=DEF_EURO()		&& DEFINISCE IL CURSORE PER LA GESTIONE DEI PARTITARI

**-2005-02-22 GESTIONE FATTURE CON ACCONTI ANTICIPATI
CREATE CURSOR WORK (;
  SELEZIONE C(3),;
  WANNO    C(04), ;
  WSELEZ   C(06), ;
  WCONTO   C(13), ;
  WPART    C(10), ;
  WPARTW   C(10), ;
  WNREGIS  C(06), ;
  WNUMFAT  C(06), ;
  WDATFAT  C(10), ;
  WDATFAK  C(10), ;
  WPROTO   N(10), ;
  WDTSCAD  C(10), ;
  WDTSCAX  C(10), ;
  WCOVAL   C(03), ;
  WIMPVRIF N(17,3), ;
  WCAMBIO  N(17,10), ;
  WIMPORTO N(17,3), ;
  WDARE	   N(17,3), ;
  WAVERE   N(17,3), ;
  WIMPITL  N(17,3), ;
  WABBUO   N(17,3), ;
  WPAGA    N(17,3), ;
  WFATAGE  C(06), ;
  WSCARTABOLLATO C(1), ;
  WTOP C(10), ;
  WPAGATO  N(17,3))

INDEX ON WPART+WDTSCAX                          		TAG WORK
INDEX ON WDTSCAX+WTOP 									TAG SCAD_TOP
INDEX ON RIBALTA2(WDATFAT)+WNUMFAT+WDTSCAX              TAG WORKD
INDEX ON WANNO+STR(VAL(WPARTW))                 		TAG WORKE



PUB_NOAGG = .F.
IF PUB_VARPN		&& VARIAZIONE DELLA PRIMA NOTA
   PUB_NOAGG = .T.
   DO REG_ANCLFO   && ANNULLO PARTITARI	
ENDIF

IF CANT = "C"							&& GESTIONE INCASSO CLIENTE ANTICIPATO
	DO REG_NUMPAC 						&& PRELEVA IL NUMERO DI PARTITA 
ENDIF


OK_WORK = .F.

x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
x_codi = "par_codcli = '" + ALLTRIM(XXX_CONTO) + "'"
cSql   = "SELECT * FROM PART_CLI WHERE " + x_soci + " and " + x_codi + " order by par_codsoc,par_codcli"
IF !ExecCommand(cSql,"cur_partcli")
   	RETURN nNumeroRecord
ENDIF

SELECT CUR_PARTCLI
GO TOP
IF EOF()
	MESSAGEBOX("PER CORTESIA INSERIRE ALMENO UNA FATTURA per il cliente "+ALLTRIM(XXX_DESCRI)+" !!! GRAZIE!!!",48,"Incasso effetti attivi")
    RETURN nNumeroRecord
ENDIF


DO WHILE !EOF()

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF PAR_TIPODO = 'FAT' .AND. PAR_NPROG = 100
      SKIP + 1
      LOOP
   ENDIF

   IF PAR_TIPODO = 'INC' .AND. PAR_NPROG = 100
      SKIP + 1
      LOOP
   ENDIF

   IF PAR_TIPFAT = "AR$"   && TRATTA L'ARROTONDAMENTO PRECEDENTEMENTE CREATO
      SKIP + 1
      LOOP
   ENDIF

   * VERIFICA SE LA PARTITA E' CHIUSA

   VCONTO   = PAR_CODCLI	 && CODICE DEL CLIENTE
   VPARTITA = PAR_NPART	 && PARTITA CLIETE
   VCURSORE = "VERPART"	 && NOME DEL CURSORE DI LAVORO
   VRAGGR   = .T.           && .T. RAGGRUPPA RITORNA UN RECORD CON IL SALDO DI TUTTI I MOVIMENTI DARE-AVERE
   VDIFFAR  = .F.			 && .T. CREA UN RECORD PER CHIUDERE LA PARTITA NEL CASO DI DIFFERENZA DOVUTA ALL'EURO DI 0,02 CENTESIMI
   VTIPO    = "C"			 && C= CLIENTE F= FORNITORE	


   IF AGGANCIAPARTITARI = "S"			&& MOSTRA ANCHE LE PARTITE CHIUSE NEL CASO DI AGANCIO DEI PARTITARI
   ELSE
	   IF EUR_PART(VTIPO,"PART_CLI",VCONTO,VPARTITA,VCURSORE,VRAGGR,VDIFFAR)  && PARTITA CHIUSA
		  SELECT CUR_PARTCLI		
	      SKIP + 1
	      LOOP
	   ENDIF
   ENDIF

   SELECT CUR_PARTCLI
   M.WANNO    = PAR_ANNO
   M.WSELEZ   = SPACE(06)
   M.WCONTO   = PAR_CODCLI
   M.WPART    = STR(PAR_NPART,10,0)
   M.WPARTW   = STR(PAR_NPART,10,0)
   M.WNREGIS  = PAR_NREG   
   M.WNUMFAT  = PAR_NUMFAT
   M.WDATFAT  = PAR_DTFAT
   M.WDATFAK  = PAR_DTFAT
   M.WPROTO   = PAR_NPART
   M.WDTSCAD  = PAR_DTSCAD
   M.WDTSCAX  = PAR_DTSCAD
   M.WNP      = STR(PAR_NPART,10,0)
   M.WFATAGE  = PAR_NPROT
   M.WCAMBIO  = PAR_CAMBIO
   M.WCOVAL   = PAR_VALUTA
   M.WTOP	  = PAR_TIPFAT	

   IF PAR_TIPODO="FAT" .OR. PAR_TIPODO="INS"
      IF PAR_TIPFAT = "AR$"   && TRATTA L'ARROTONDAMENTO PRECEDENTEMENTE CREATO
         M.WIMPORTO = PAR_FATT
    	 M.WIMPITL  = 0
      ELSE
         IF PAR_TMOV = "A"	&&NOTA DI CREDITO
            M.WIMPORTO = (TEURO(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))) * -1
            M.WIMPITL  = (TLIRE(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))) * -1
         ELSE
            M.WIMPORTO = TEURO(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))
            M.WIMPITL  = TLIRE(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))
         ENDIF
      ENDIF
      M.WPAGATO  = 0
      M.WIMPVRIF = PAR_FATT
   ELSE
      IF PAR_TIPFAT = "AR$"   && TRATTA L'ARROTONDAMENTO PRECEDENTEMENTE CREATO
         M.WIMPORTO = PAR_FATT * -1
         M.WIMPITL  = 0
         M.WPAGATO  = 0
      ELSE
  	     IF PAR_TMOV = "D"	&&NOTA DI CREDITO
            M.WIMPORTO = (TEURO(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT)))
            M.WIMPITL  = (TLIRE(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT)))
         ELSE
	        M.WIMPORTO = (TEURO(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT)) * -1)
		    M.WIMPITL  = (TLIRE(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))) * -1
		 ENDIF
	     M.WPAGATO  = (TLIRE(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT)))
      ENDIF
      M.WIMPVRIF = PAR_FATT * -1
   ENDIF

   SELECT WORK
   SET ORDER TO WORK
   _SEEK = M.WPART+M.WDTSCAX
   SEEK _SEEK
   IF FOUND()
      REPLACE WIMPORTO WITH WIMPORTO+M.WIMPORTO
      REPLACE WIMPITL  WITH WIMPITL+M.WIMPITL
      REPLACE WPAGATO  WITH WPAGATO +M.WPAGATO
   ELSE
      APPEND BLANK
      GATHER MEMVAR MEMO
      REPLACE WIMPVRIF WITH WIMPVRIF+M.WIMPVRIF
      REPLACE WDATFAT  WITH RIBALTA2(M.WDATFAT)
      REPLACE WDTSCAD  WITH RIBALTA2(M.WDTSCAD)
   ENDIF

   SELECT CUR_PARTCLI
   SKIP +1

ENDDO


SELECT WORK
GO TOP

SELECT WORK
SET ORDER TO WORKE
IF AGGANCIAPARTITARI = "S"			&& MOSTRA ANCHE LE PARTITE CHIUSE NEL CASO DI AGGANCIO DEI PARTITARI
ELSE
	SET FILTER TO WIMPORTO <> 0 OR WAVERE <> 0
ENDIF
GO TOP

OK_WORK = .F.
DO WHILE .NOT.EOF()       && VERIFICA SE EFFETTIVAMENTE ESISTE FATTURA IN LISTA

   OK_WORK = .T.           && SE HO I PAGAMENTI E NON LA FATTURA IMPORTO PAGATO > WIMPORTO

   IF WIMPORTO < 0
	     REPLACE WDARE   WITH 0
	     REPLACE WAVERE  WITH ABS(WIMPORTO)
   ELSE
	     REPLACE WAVERE  WITH 0
	     REPLACE WDARE   WITH ABS(WIMPORTO)
   ENDIF

   SKIP +1
ENDDO

IF !OK_WORK
	MESSAGEBOX("PER CORTESIA INSERIRE ALMENO UNA FATTURA per il cliente "+ALLTRIM(XXX_DESCRI)+" !!! GRAZIE!!!",48,"Incasso effetti attivi")
   	RETURN nNumeroRecord
ENDIF

*** RECUPERO LA TIPOLOGIA DA INDICARE NEL TITOLO
SELECT PAGAMENTI
_TIPOLOGIA_PER_DESCRIZIONE=ALLTRIM(TIPOLOGIA)

SELECT WORK
SET ORDER TO SCAD_TOP
GO TOP
DO prg\browseview WITH "WORK",_TIPOLOGIA_PER_DESCRIZIONE+" ["+ALLTRIM(XXX_DESCRI)+" - € "+ALLTRIM(STR(XXX_NSALDO))+" scad. "+RIBALTA2(XXX_DTSCAD)+"]:10",;
	"WNUMFAT:N.fatt.;WPART:N.partita;WDTSCAD:Data scadenza;WTOP:TOP,W:13;WDARE:Dare,W:18;WAVERE:Avere,W:18;WIMPORTO:Saldo,W:18;",500,700,.F.,.T.

SELECT WORK
nNumeroRecord= NumeroRecordLetti

IF nNumeroRecord=0
	MESSAGEBOX("Selezionare una fattura da associare all'Effetto Attivo del cliente "+ALLTRIM(XXX_DESCRI)+" - € "+ALLTRIM(STR(XXX_NSALDO))+" scad. "+RIBALTA2(XXX_DTSCAD),48,"Incasso effetti attivi")
ENDIF


RETURN nNumeroRecord

* FINE PROCEDURE SELE_APERTE_CLI
**************************************************************************





******************************
PROCEDURE SELE_APERTE_FOR
******************************
PARA XXX_CONTO,XXX_DESCRI,XXX_NSALDO,XXX_DTSCAD

LOCAL 	nNumeroRecord

nNumeroRecord=0

=DEF_EURO()		&& DEFINISCE IL CURSORE PER LA GESTIONE DEI PARTITARI

**-2005-02-22 GESTIONE FATTURE CON ACCONTI ANTICIPATI

CREATE CURSOR WORK (;
  SELEZIONE C(3),;
  WANNO    C(04), ;
  WSELEZ   C(06), ;
  WCONTO   C(13), ;
  WPART    C(10), ;
  WPARTW   C(10), ;
  WNREGIS  C(06), ;
  WNUMFAT  C(06), ;
  WDATFAT  C(10), ;
  WDATFAK  C(10), ;
  WPROTO   N(10), ;
  WDTSCAD  C(10), ;
  WDTSCAX  C(10), ;
  WCOVAL   C(03), ;
  WIMPVRIF N(17,3), ;
  WCAMBIO  N(17,10), ;
  WIMPORTO N(17,3), ;
  WAVERE   N(17,3), ;
  WDARE    N(17,3), ;
  WIMPITL  N(17,3), ;
  WABBUO   N(17,3), ;
  WPAGA    N(17,3), ;
  WFATAGE  C(06), ;
  WPAGATO  N(17,3), ;
  Wcosatratta C(5), ;
  Wgradoimportanza C(5), ;
  Wformapagamento C(5), ;
  Wtipocontratto C(5), ;
  Wcodacq C(3), ;
  WSCARTABOLLATO C(1), ;
  WANOMAX C(3), ;
  WTOP C(10), ;
  Wpripaga C(4))

INDEX ON WPART+WDTSCAX                          		TAG WORK
INDEX ON WDTSCAX+WTOP 									TAG SCAD_TOP
INDEX ON RIBALTA2(WDATFAT)+WNUMFAT+WDTSCAX              TAG WORKD
INDEX ON WANNO+STR(VAL(WPARTW))                 		TAG WORKE

PUB_NOAGG = .F.
IF PUB_VARPN		&& VARIAZIONE DELLA PRIMA NOTA
   PUB_NOAGG = .T.
   DO REG_ANCLFO   && ANNULLO PARTITARI	
ENDIF


IF CANT = "F"							&& GESTIONE PAGAMENTO FORNITORE ANTICIPATO
	DO REG_NUMPRF 						&& PRELEVA IL NUMERO DI PARTITA 
ENDIF

OK_WORK = .F.

x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
x_codi = "par_codcli = '" + ALLTRIM(XXX_CONTO) + "'"
cSql="SELECT * FROM PART_FOR WHERE " + x_soci + " and " + x_codi + " order by par_codsoc,par_codcli"
IF !ExecCommand(cSql,"cur_partfor")
   return(.f.)
ENDIF
SELECT CUR_PARTFOR
GO TOP
IF EOF()
	MESSAGEBOX("Nessuna partita trovata da associare all'Effetto Passivo del fornitore "+ALLTRIM(XXX_DESCRI),48,"Pagamento effetti passivi")
   	RETURN nNumeroRecord
ENDIF


DO WHILE !EOF()

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF PAR_TIPODO = 'FAT' .AND. PAR_NPROG = 100
      SKIP + 1
      LOOP
   ENDIF

   IF PAR_TIPODO = 'INC' .AND. PAR_NPROG = 100
      SKIP + 1
      LOOP
   ENDIF

   IF PAR_TIPFAT = "AR$"   && TRATTA L'ARROTONDAMENTO PRECEDENTEMENTE CREATO
      SKIP + 1
      LOOP
   ENDIF


   SELECT CUR_PARTFOR

   * VERIFICA SE LA PARTITA E' CHIUSA
   VCONTO   = PAR_CODCLI	 && CODICE DEL FORNITORE
   VPARTITA = PAR_NPART	 && PARTITA FORNITORE
   VCURSORE = "VERPART"	 && NOME DEL CURSORE DI LAVORO
   VRAGGR   = .T.           && .T. RAGGRUPPA RITORNA UN RECORD CON IL SALDO DI TUTTI I MOVIMENTI DARE-AVERE
   VDIFFAR  = .F.			&& .T. CREA UN RECORD PER CHIUDERE LA PARTITA NEL CASO DI DIFFERENZA DOVUTA ALL'EURO DI 0,02 CENTESIMI
   VTIPO    = "F"			&& C= CLIENTE F= FORNITORE	

   IF AGGANCIAPARTITARI = "S"			&& MOSTRA ANCHE LE PARTITE CHIUSE NEL CASO DI AGGANCIO DEI PARTITARI
   ELSE
	   IF EUR_PART(VTIPO,"PART_FOR",VCONTO,VPARTITA,VCURSORE,VRAGGR,VDIFFAR)  && PARTITA CHIUSA
		  SELECT CUR_PARTFOR	
	      SKIP + 1
	      LOOP
	   ENDIF
   ENDIF		
	
   SELECT CUR_PARTFOR

   M.WANNO    			= PAR_ANNO
   M.WSELEZ   			= SPACE(06)
   M.WCONTO   			= PAR_CODCLI
   M.WPART    			= STR(PAR_NPART,10,0)
   M.WPARTW   			= STR(PAR_NPART,10,0)
   M.WNUMFAT  			= PAR_NUMFAT
   M.WNREGIS  			= PAR_NREG   
   M.WDATFAT  			= PAR_DTFAT
   M.WDATFAK  			= PAR_DTFAT
   M.WPROTO   			= PAR_NPART
   M.WDTSCAD  			= PAR_DTSCAD
   M.WDTSCAX  			= PAR_DTSCAD
   M.WNP      			= STR(PAR_NPART,10,0)
   M.WCAMBIO  			= PAR_CAMBIO
   M.WCOVAL   			= PAR_VALUTA
   M.Wcosatratta 		= PAR_cosatratta 
   M.Wgradoimportanza 	= PAR_gradoimportanza
   M.Wformapagamento 	= PAR_formapagamento
   M.Wtipocontratto 	= PAR_tipocontratto
   M.Wcodacq 			= PAR_codacq
   M.Wpripaga			= PAR_pripaga
   M.Wanomax			= PAR_anomax
   M.WTOP	  			= PAR_TIPFAT	

   IF PAR_TIPODO="FAT" .OR. PAR_TIPODO="INS"
      IF PAR_TIPFAT = "AR$"   && TRATTA L'ARROTONDAMENTO PRECEDENTEMENTE CREATO
	      M.WIMPORTO = PAR_FATT
    	  M.WIMPITL  = 0
      ELSE
		  IF PAR_TMOV = "D"	&&NOTA DI CREDITO
	          M.WIMPORTO = (TEURO(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))) * -1
    	      M.WIMPITL  = (TLIRE(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))) * -1
		  ELSE				&&FATTURA EFFETTIVA
	          M.WIMPORTO = TEURO(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))
    	      M.WIMPITL  = TLIRE(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))
		  ENDIF
      ENDIF
      M.WPAGATO  = 0
      M.WIMPVRIF = PAR_FATT
   ELSE
      IF PAR_TIPFAT = "AR$"   && TRATTA L'ARROTONDAMENTO PRECEDENTEMENTE CREATO
	     M.WIMPORTO = PAR_FATT * -1
    	 M.WIMPITL  = 0
         M.WPAGATO  = 0
      ELSE
		 IF PAR_TMOV = "A"	&&NOTA DI CREDITO
  	        M.WIMPORTO = TEURO(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))
		    M.WIMPITL  = TLIRE(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT))
         ELSE
  	        M.WIMPORTO = (TEURO(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT)) *-1)
		    M.WIMPITL  = (TLIRE(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT)) *-1)
         ENDIF
         M.WPAGATO  = (TLIRE(M.WCOVAL,PAR_FATT,RIBALTA2(M.WDATFAT)))
      ENDIF
      M.WIMPVRIF = PAR_FATT * -1
   ENDIF

   SELECT WORK
   SET ORDER TO WORK
   _SEEK = M.WPART+M.WDTSCAX
   SEEK _SEEK
   IF FOUND()
      REPLACE WIMPORTO WITH WIMPORTO+M.WIMPORTO
      REPLACE WIMPITL  WITH WIMPITL+M.WIMPITL
      REPLACE WPAGATO  WITH WPAGATO +M.WPAGATO
   ELSE
      APPEND BLANK
      GATHER MEMVAR MEMO
      REPLACE WIMPVRIF WITH WIMPVRIF+M.WIMPVRIF
      REPLACE WDATFAT  WITH RIBALTA2(M.WDATFAT)
      REPLACE WDTSCAD  WITH RIBALTA2(M.WDTSCAD)
   ENDIF


   SELECT CUR_PARTFOR
   SKIP +1

ENDDO

SELECT WORK
SET ORDER TO WORKE

IF AGGANCIAPARTITARI = "S"			&& MOSTRA ANCHE LE PARTITE CHIUSE NEL CASO DI AGGANCIO DEI PARTITARI
ELSE
	SET FILTER TO WIMPORTO <> 0 OR WAVERE <> 0
ENDIF

GO TOP

OK_WORK = .F.
DO WHILE .NOT.EOF()       			&& VERIFICA SE EFFETTIVAMENTE ESISTE FATTURA IN LISTA

   OK_WORK = .T.           			&& SE HO I PAGAMENTI E NON LA FATTURA IMPORTO PAGATO > WIMPORTO

   IF WIMPORTO > 0
     REPLACE WAVERE   WITH ABS(WIMPORTO)
     REPLACE WDARE    WITH 0
     REPLACE WIMPORTO WITH WIMPORTO*-1
   ELSE
     REPLACE WDARE    WITH ABS(WIMPORTO)
     REPLACE WAVERE   WITH 0
     REPLACE WIMPORTO WITH ABS(WIMPORTO)
   ENDIF

   SKIP +1
   
ENDDO

IF !OK_WORK
	MESSAGEBOX("Nessuna partita trovata da associare all'Effetto Passivo del fornitore "+ALLTRIM(XXX_DESCRI),48,"Pagamento effetti passivi")
   	RETURN nNumeroRecord
ENDIF

*** RECUPERO LA TIPOLOGIA DA INDICARE NEL TITOLO
SELECT PAGAMENTI
_TIPOLOGIA_PER_DESCRIZIONE=ALLTRIM(TIPOLOGIA)

SELECT WORK
SET ORDER TO SCAD_TOP
GO TOP
DO prg\browseview WITH "WORK",_TIPOLOGIA_PER_DESCRIZIONE+" ["+ALLTRIM(XXX_DESCRI)+" - € "+ALLTRIM(STR(XXX_NSALDO))+" scad. "+RIBALTA2(XXX_DTSCAD)+"]:10",;
	"WNUMFAT:N.fatt.;WPART:N.partita;WDTSCAD:Data scadenza;WTOP:TOP,W:13;WDARE:Dare,W:18;WAVERE:Avere,W:18;WIMPORTO:Saldo,W:18;",500,700,.F.,.T.

nNumeroRecord= NumeroRecordLetti

IF nNumeroRecord=0
	MESSAGEBOX("Selezionare una fattura da associare all'Effetto Passivo del fornitore "+ALLTRIM(XXX_DESCRI)+" - € "+ALLTRIM(STR(XXX_NSALDO))+" scad. "+RIBALTA2(XXX_DTSCAD),48,"Pagamento effetti passivi")
ENDIF

RETURN nNumeroRecord
* FINE PROCEDURE SELE_APERTE_FOR
**************************************************************************



**************************************************************************
PROCEDURE GETCONTOCONTABILECLI
**************************************************************************
PARAMETERS _CONTO

PRIVATE _RET_CONTO

_RET_CONTO=_CONTO

IF SUBSTR(_CONTO,1,LEN(PUB_CC))!=PUB_CC 
	_RET_CONTO=PUB_CC+ALLTRIM(_CONTO)
ENDIF

RETURN _RET_CONTO
*** FINE PROCEDURE CANCCOMP
**************************************************************************


**************************************************************************
PROCEDURE GETCONTOCONTABILEFOR
**************************************************************************
PARAMETERS _CONTO

PRIVATE _RET_CONTO

_RET_CONTO=_CONTO

* IF SUBSTR(_CONTO,1,LEN(PUB_FF))!=PUB_FF
* 	_RET_CONTO=PUB_FF+ALLTRIM(_CONTO)
* ENDIF

RETURN _RET_CONTO
*** FINE PROCEDURE CANCCOMP
**************************************************************************


**************************************************************************
PROCEDURE GIA_PIANO
**************************************************************************
PARAMETERS _npart
	
____SS=STR(SELECT())

cNumPiano= ''

cSql="SELECT * FROM PIANOP_P1 WHERE npart="+alltrim(str(_npart))+" UNION SELECT * FROM PIANOP_P2 WHERE npart="+alltrim(str(_npart))
IF !ExecCommand(cSql,"CGIAPIANO")
   RETURN ''
ENDIF

SELECT CGIAPIANO
GO TOP
IF !EOF()
	cNumPiano='X'
ENDIF

*!*	cSql="SELECT * FROM PIANOP_P2 WHERE npart="+alltrim(str(_npart))
*!*	IF !ExecCommand(cSql,"CGIAPIANO")
*!*	   RETURN ''
*!*	ENDIF

*!*	SELECT CGIAPIANO
*!*	GO TOP
*!*	IF !EOF()
*!*		cNumPiano='X'
*!*	ENDIF

SELECT &____SS
RETURN cNumPiano

*** FINE PROCEDURE GIA_PIANO
**************************************************************************


**************************************************************************
PROCEDURE CHECK_NPART_GIA_ASSEGNATO
**************************************************************************
LOCAL 	____NPART,;
		____SS,;
		____ORDER,;
		____RECNO,;
		____ESITO
		
____SS=STR(SELECT())
____ORDER=ORDER()
____RECNO=RECNO()

____ESITO=.T.

SELECT WORK 
____NPART=WPART 				

IF VAL(____NPART)=0
	____ESITO=.T.
	RETURN ____ESITO
ENDIF

SELECT * ;
	FROM PAGAMENTI ;
	WHERE NPART=VAL(____NPART) ;
	INTO CURSOR CCHKNPART

SELECT CCHKNPART		
GO TOP
IF !EOF()
	IF 6=MESSAGEBOX("Il numero di partita "+ALLTRIM(____NPART)+" e' gia' stato assegnato ad un altro pagamento/incasso in questa sessione di tesoreria."+chr(13)+;
		"Procedere comunque con l'assegnazione?",4+32,"Assegnazione numero partita")
		____ESITO=.T.
	ELSE
		____ESITO=.F.
		SELECT PAGAMENTI
		REPLACE SELEZIONE WITH ""
	ENDIF
ELSE
	____ESITO=.T.
ENDIF
	
SELECT &____SS
SET ORDER TO &____ORDER
GO ____RECNO

RETURN ____ESITO
*** FINE PROCEDURE CHECK_NPART_GIA_ASSEGNATO
**************************************************************************



**************************************************************************
PROCEDURE VERIFICA_SE_TOP_RIBA
**************************************************************************
PARAMETERS P_TOP

LOCAL _TOP,cNomeCursorSql,cSql

_TOP=ALLTRIM(P_TOP)

IF PCOUNT()<1
	=MESSAGEBOX("Si sta cercando di individuare se un TOP è di tipo RI.BA. senza specificare il top."+CHR(13)+"MANCA PARAMETRO A PROCEDURA <<VERIFICA_SE_TOP_RIBA>> DI TESORERIA_LIB.PRG",48,"ERRORE TECNICO")
	RETURN .F.
ENDIF

cNomeCursorSql="X"+SUBSTR(SYS(2015),2)

TEXT TO cSql  NOSHOW 	&& INIZIO SCRITTURA QUERY

	SELECT * 
	FROM PARA 
	WHERE CODICE = 'TOP<<_TOP>>'

ENDTEXT					&& FINE SCRITTURA QUERY
		
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT &cNomeCursorSql
IF RECCOUNT()=0
	=MESSAGEBOX("Si sta cercando di individuare se un TOP è di tipo RI.BA. per un TOP che non esiste. INSERIRE TOP "+_TOP+" NEI PARAMETRI",48,"ATTENZIONE")
	RETURN (.F.)
ENDIF

* se e' una RIBA allora torno TRUE
IF SUBSTR(LIBERA,10,1)='S' 	&& condizione di controllo sul PARA per capire se COND PAG e' RIBA
	RETURN .T.
ENDIF

RETURN .F.

*** FINE PROCEDURE VERIFICA_SE_TOP_RIBA
**************************************************************************
