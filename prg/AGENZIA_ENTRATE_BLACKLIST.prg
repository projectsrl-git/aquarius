**********************************************************************************************************
**  COMUNICAZIONE BLACKLIST
**********************************************************************************************************

CREATE CURSOR PRINT_CUR_BLACKLIST	(codcli C(10), ragsoc C(40), indiri C(30), locali C(30), cap C(5), provi C(4) ,codfis C(16), pariva C(25), nazione C(3) ,valore N(17,3), imponi N(17,3), iva N(17,3),;
									 esenz N(17,3), art8 N(17,3),art8bis N(17,3),art9 N(17,3),art40 N(17,3),art41 N(17,3),art52 N(17,3),art72 N(17,3),altrees N(17,3),imponi_indeducibile N(17,3),iva_indeducibile N(17,3),;
									 pivacod C(3), pivades C(40), pivaperc N(3,0), pivatipo C(1), pivaperI N(3,0), TIPOREC C(1),;
									 FATNOT C(1), DTFATT c(8), NUMDOC C(15), TOP C(3), CLIFOR c(1), ;
								     COGNOME C(24), NOME C(20), DTNASCITA C(8), COMUNENAS C(40), PROVINAS C(2), STATODOM C(3), ;
					  		         DENOMINAZ C(60), CITTALEG C(40), STATOLEG C(3), INDIREST C(40), TIPOSOGGETTO C(1), ;
					  		         MODPAG C(01), TIPOOPE C(01), DATAFAT C(08), NUMEROFAT C(15), VARIMPONI C(01), VARIMPOST C(01), INELENCO C(1) )
					  		         
INDEX ON ALLTRIM(TIPOREC)+alltrim(CODCLI) TAG IDX

SELECT PRINT_CUR_BLACKLIST
HH=AFIELDS(TRANSPRN)
CREATE CURSOR TMP_PRINT FROM ARRAY TRANSPRN


** Creo cursore finale
CREATE CURSOR CUR_BLACKLIST ( codcli C(10), ragsoc C(40), indiri C(30), locali C(30), cap C(5), provi C(4) ,codfis C(16), pariva C(25), nazione C(3) ,valore N(17,3), imponi N(17,3), iva N(17,3),;
							  esenz N(17,3), art8 N(17,3),art8bis N(17,3),art9 N(17,3),art40 N(17,3),art41 N(17,3),art52 N(17,3),art72 N(17,3),altrees N(17,3),imponi_indeducibile N(17,3),iva_indeducibile N(17,3),;
							  pivacod C(3), pivades C(40), pivaperc N(3,0), pivatipo C(1), pivaperI N(3,0), ;
						  	  FATNOT C(1), DTFATT c(8), NUMDOC C(15), TOP C(3), CLIFOR c(1), ;
							  COGNOME C(24), NOME C(20), DTNASCITA C(8), COMUNENAS C(40), PROVINAS C(2), STATODOM C(3), ;
					  		  DENOMINAZ C(60), CITTALEG C(60), STATOLEG C(3), INDIREST C(40), TIPOSOGGETTO C(1), INELENCO C(1) )

INDEX ON ALLTRIM(codcli) + PADR(ALLTRIM(NUMDOC),15,' ') TAG M_NDOC
INDEX ON alltrim(codcli)+ALLTRIM(FATNOT) TAG DesCFAT


CREATE CURSOR elencoAltro ( codiceAltro C(50) )

CREATE CURSOR dividiAliquota ( Aliq C(3), cdIVA C(3), dsIVA C(40), Impo_DED N(17,3), Impo_NO_D N(17,3), Iva_DED N(17,3), Iva_NO_D N(17,3), ESE_NOIMP N(17,3), ALTRO N(17,3))
INDEX ON cdIVA TAG pAli

cSql = "select * from PARA"
IF !ExecCommand(cSql,"PARA")
   RETURN .F.
ENDIF
SELECT PARA
INDEX ON CODICE TAG CODICE ADDITIVE


cSql = "select * from NAZIONI_UNICO WHERE BLACK = 'X'"
IF !ExecCommand(cSql,"BLACK")
   RETURN .F.
ENDIF
SELECT BLACK
INDEX ON CODICE TAG COD ADDITIVE


select distinct SUBSTR(codice,4,3) as codAliq, SUBSTR(LIBERA,1,3) as perAliq, alltrim(descri) as desAliq from para where codice like 'IVA%' into cursor listaAliquote


select listaAliquote
DO WHILE !EOF()
	if EOF()
		EXIT
	endif
	_PerAliq = perAliq
	_codAliq = codAliq
	_desAliq = desAliq
		
	select dividiAliquota
	append blank

	REPLACE cdIVA 		with 	_codAliq	
	REPLACE dsIVA 		with 	_desAliq
	REPLACE Aliq 		with 	_PerAliq	
	REPLACE Impo_DED	with 	0
	REPLACE Impo_NO_D	with 	0
	REPLACE Iva_DED		with 	0
	REPLACE Iva_NO_D	with 	0			
	REPLACE ESE_NOIMP 	WITH    0
	REPLACE ALTRO 		WITH    0
	
	select listaAliquote
	skip + 1
ENDDO

ANNODAL=SUBSTR(DATADAL,7,4)
MESEDAL=SUBSTR(DATADAL,4,2)
V_ANNO		=ANNODAL
V_MESE		=MESEDAL
CONTA_REC 	=0

RELEASE imponibile_indeducibile,imposta_indeducibile,_elenco_codAltro
PUBLIC imponibile_indeducibile,imposta_indeducibile,_elenco_codAltro
imponibile_indeducibile	= 0
imposta_indeducibile	= 0
_elenco_codAltro	    = ''

PUBLIC  OK_PROTCL 
OK_PROTCL = 0


WAIT WINDOWS "Lettura archivi in corso...  -  Prego attendere" nowait

cSql = "select * from U_AZI_AN"
IF !ExecCommand(cSql,"U_AZI_AN")
   RETURN .F.
ENDIF
SELECT U_AZI_AN
INDEX ON AZI_CODSOC TAG U_AZI_AN ADDITIVE

cSql = "select * from U_IVA_CL"
IF !ExecCommand(cSql,"U_IVA_CL")
   RETURN .F.
ENDIF
SELECT U_IVA_CL
INDEX ON IVA_CODSOC+IVA_ANNO+IVA_MESE TAG ANNOMESE ADDITIVE
INDEX ON IVA_CODSOC+IVA_DTFATT TAG DATAFATT ADDITIVE 

cSql = "select * from U_IVF_CL"
IF !ExecCommand(cSql,"U_IVF_CL")
   RETURN .F.
ENDIF
SELECT U_IVF_CL
INDEX ON IVF_CODSOC+IVF_ANNO+IVF_MESE TAG ANNOMESE ADDITIVE
INDEX ON IVF_CODSOC+IVF_DTFATT TAG DATAFATT ADDITIVE 

cSql = "select * from U_FOR_AN"
IF !ExecCommand(cSql,"U_FOR_AN")
   RETURN .F.
ENDIF
SELECT U_FOR_AN
INDEX ON FOR_CODSOC+FOR_CODCLI TAG U_FOR_AN ADDITIVE
INDEX ON FOR_CODSOC+FOR_RAGSOC TAG U_FOR_RG ADDITIVE

cSql = "select * from U_CLI_AN"
IF !ExecCommand(cSql,"U_CLI_AN")
   RETURN .F.
ENDIF
SELECT U_CLI_AN
INDEX ON CLI_CODSOC+CLI_CODCLI TAG U_CLI_AN ADDITIVE
INDEX ON CLI_CODSOC+CLI_RAGSOC TAG U_CLI_RG ADDITIVE

WAIT WINDOWS "Elaborazione dati in corso...  -  Prego attendere" nowait


IF (EMPTY(MESEDAL)) .OR. (EMPTY(ANNODAL))  
  RETURN
ENDIF  

SELECT U_AZI_AN
SET ORDER TO U_AZI_AN

SEEK PUB_CODSOC
IF FOUND()
  OK_ESECLI = AZI_ARTPUB  && ARTICOLO PUBBLICITARIO
  OK_PROTCL = AZI_PROTCL
ELSE
  OK_ESECLI = .F.  && ARTICOLO PUBBLICITARIO
  OK_PROTCL = -1
  WAIT WINDOW "PER CORTESIA CODIFICA IL PARAMETRO BOLLATI IVA"
ENDIF


***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE/FORNITORE
SELECT PARA
SET ORDER TO CODICE

SEEK 'GEN'+PUB_CODSOC
IF !FOUND()
  RIT=MSGBOX("ERRORE MANCA PARAMETRO GEN 4 CARATTERI CONTI CLI",'ATTENZIONE',31)
  RETURN(3)
ENDIF
CCC=SUBSTR(LIBERA,01,PUB_SOTTOG-1)
FFF=SUBSTR(LIBERA,18,PUB_SOTTOG-1)

IF __CLIFOR = 1
	DO CLIENTI WITH __FATNOT
ELSE
	DO FORNITORI WITH __FATNOT
ENDIF

RELEASE WINDOW DISPLAY

select distinct codiceAltro from elencoAltro into cursor elencoAltro
select elencoAltro

DO WHILE !EOF()
	if EOF()
		EXIT
	endif
	_singoloCod = alltrim(codiceAltro)
	_elenco_codAltro = _elenco_codAltro + _singoloCod + chr(13)
	
	select elencoAltro
	skip + 1
	
ENDDO

select * from dividiAliquota where Impo_DED <> 0 or Impo_NO_D <> 0 or Iva_DED <> 0 or Iva_NO_D <> 0 ;
		OR ESE_NOIMP <> 0 ;
		OR ALTRO <> 0 ;
		into cursor dividiAliquota
		
select dividiAliquota

** Stampo
_TOTALE_PER_FORNITURA = 0
SELECT CUR_BLACKLIST
GO TOP

DO WHILE !EOF()
	IF DELETED()
		SKIP
		LOOP
	ENDIF

	SELECT CUR_BLACKLIST
	__STATODOM = STATODOM
	__STATOLEG = STATOLEG	
		
	SELECT BLACK
	SET ORDER TO COD
	SEEK __STATODOM 
	IF FOUND()
	   SELECT CUR_BLACKLIST
	   SKIP +1
	   LOOP
	ENDIF
	
	SELECT BLACK
	SET ORDER TO COD
	SEEK __STATOLEG 
	IF FOUND()
	   SELECT CUR_BLACKLIST
	   SKIP +1
	   LOOP
	ENDIF
	
	SELECT CUR_BLACKLIST


	*** ##########################################################################################	
	***   VISIONE DEGLI IMPORTI FRAZIONATI -- DEVO VERIFICARE GLI ORDINI
	***   INIZIO
	
		REGIS_DA_INCLUDERE_IN_ELENCO = .F.
		__MODALITAPAG = "1"
		__NUMERODOC = CUR_BLACKLIST.NUMDOC
		__DATADOC   = SUBSTR(CUR_BLACKLIST.DTFATT,5,4) + "/" + SUBSTR(CUR_BLACKLIST.DTFATT,3,2) + "/" + SUBSTR(CUR_BLACKLIST.DTFATT,1,2)
		__TOTDOCU 	= CUR_BLACKLIST.imponi + CUR_BLACKLIST.imponi_indeducibile		
		
		cSql=""
		cNomeCursorSql="SEL_DDT"

		TEXT TO cSql NOSHOW

			SELECT  DISTINCT DD.ORS_NUMDDT,
							 DD.ORS_DATDDT
			FROM U_FAT_TT AS TT,
				U_FAT_DD AS DD
			WHERE 
				TT.TAGGANCIO = DD.DAGGANCIO
				AND ORS_NUMDDT != ''
				AND (TT.ORD_NUMORD = '<<__NUMERODOC>>'		
				AND TT.ORD_DATORD  = '<<__DATADOC>>')	
				
		ENDTEXT
		IF !ExecPreparedCommand(cSql,cNomeCursorSql)
			return(.F.)
		ENDIF
		
		SELECT SEL_DDT
		GO TOP
		DO WHILE !EOF()
		
			__NUMERODOC = SEL_DDT.ORS_NUMDDT
			__DATADOC   = SEL_DDT.ORS_DATDDT
			cSql=""
			cNomeCursorSql="SEL_ORD"

			TEXT TO cSql NOSHOW

				SELECT  DISTINCT DD.ORS_NUMORC,
								 DD.ORS_DATORC
				FROM U_BOL_TT AS TT,
					U_BOL_DD AS DD
				WHERE 
					TT.TAGGANCIO = DD.DAGGANCIO
					AND ORS_NUMORC != ''
					AND (TT.ORD_NUMORD = '<<__NUMERODOC>>'		
					AND TT.ORD_DATORD = '<<__DATADOC>>')	
					
			ENDTEXT
			IF !ExecPreparedCommand(cSql,cNomeCursorSql)
				return(.F.)
			ENDIF		
			SELECT SEL_ORD
			GO TOP
			DO WHILE !EOF()

				__NUMERODOC = SEL_ORD.ORS_NUMORC
				__DATADOC   = SEL_ORD.ORS_DATORC
				cSql=""
				cNomeCursorSql="SUM_ORD"

				TEXT TO cSql NOSHOW

					SELECT SUM(TOT) AS TOTALE
					FROM (
							SELECT  TT.ORD_NUMORD,
									DD.ORD_VALORE AS TOT,
									TT.TAGGANCIO,
									DD.DAGGANCIO
							FROM U_ORD_TT AS TT,
								U_ORD_DD AS DD
							WHERE 
								TT.TAGGANCIO = DD.DAGGANCIO
								AND (TT.ORD_NUMORD = '<<__NUMERODOC>>'
								AND TT.ORD_DATORD = '<<__DATADOC>>')
					) AS T1
						
				ENDTEXT
				IF !ExecPreparedCommand(cSql,cNomeCursorSql)
					return(.F.)
				ENDIF
				SELECT SUM_ORD
				__SOMMA = SUM_ORD.TOTALE
				
				REGIS_DA_INCLUDERE_IN_ELENCO = .T.
										
			
				SELECT SEL_ORD
				SKIP + 1
			ENDDO
			
			SELECT SEL_DDT
			SKIP + 1
			
		ENDDO


	SELECT CUR_BLACKLIST		


	IF CLIFOR == "F"	&& SOLO PER I FORNITORI
		__INELENCO = CUR_BLACKLIST.INELENCO	
		IF __INELENCO == "S"
			REGIS_DA_INCLUDERE_IN_ELENCO = .T.
			__MODALITAPAG = "2"
		ENDIF
	ENDIF
	
	
	
	***   VISIONE DEGLI IMPORTI FRAZIONATI -- DEVO VERIFICARE GLI ORDINI
	***   FINE
	*** ##########################################################################################	


	SCATTER MEMVAR MEMO	
	SELECT TMP_PRINT 
	APPEND BLANK
	GATHER MEMVAR MEMO

	*** DEFINIZIONE DEI TIPI RECORD
	
	*** CLIENTI - FATTURE
	IF (__CLIFOR == 1 .AND. __FATNOT == "F")
	
	   IF (ALLTRIM(m.nazione) == 'ITA')   
		   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'  
			   REPLACE TIPOREC	WITH "2"   
		   ELSE
			   REPLACE TIPOREC	WITH "1"   	     && PERSONA FISICA
		   ENDIF
	   ELSE
		   REPLACE TIPOREC	WITH "3"   
	   ENDIF
	
	   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'
		   IF (ALLTRIM(m.nazione) == 'ITA')
			   ***REPLACE MODPAG   WITH "1"
			   REPLACE MODPAG   WITH __MODALITAPAG 
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			      REPLACE TIPOOPE    WITH "1"	&& Cessiono e/o prestazione 
			   ELSE
			      REPLACE TIPOOPE    WITH "2"	&& Cessione e/o prestazione ricevuta
			   ENDIF       
		   ELSE
			   ***REPLACE MODPAG   WITH "1"
			   REPLACE MODPAG   WITH __MODALITAPAG 
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			      REPLACE TIPOOPE    WITH "1"	&& Cessiono e/o prestazione 
			   ELSE
			      REPLACE TIPOOPE    WITH "2"	&& Cessione e/o prestazione ricevuta
			   ENDIF       
		   ENDIF
	   ELSE									 && PERSONA FISICA
		   ***REPLACE MODPAG   WITH "1"
		   REPLACE MODPAG   WITH __MODALITAPAG 
	   ENDIF
	ENDIF

	*** CLIENTI - NOTE VARIAZIONE
	IF (__CLIFOR == 1 .AND. __FATNOT == "N")
	   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'
		   IF (ALLTRIM(m.nazione) == 'ITA')
			   REPLACE TIPOREC	  WITH "4"  
	      	   REPLACE DATAFAT    WITH "3112"+SUBSTR(ALLTRIM(M.DTFATT),5)
	           REPLACE NUMEROFAT  WITH SPACE(15)
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			  	  VARIAZIONE = "C"	&& Credito
			   ELSE
			  	  VARIAZIONE = "D"	&& Debito
			   ENDIF      
		       REPLACE VARIMPONI  WITH VARIAZIONE 
		       REPLACE VARIMPOST  WITH VARIAZIONE 			   
		   ELSE
			   REPLACE TIPOREC	WITH "5"  
	      	   REPLACE DATAFAT    WITH "3112"+SUBSTR(ALLTRIM(M.DTFATT),5)
	           REPLACE NUMEROFAT  WITH SPACE(15)
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			  	  VARIAZIONE = "C"	&& Credito
			   ELSE
			  	  VARIAZIONE = "D"	&& Debito
			   ENDIF      
		       REPLACE VARIMPONI  WITH VARIAZIONE 
		       REPLACE VARIMPOST  WITH VARIAZIONE 			   			   
		   ENDIF
	   ELSE									 && PERSONA FISICA (NON INTERESSANO LE NOTE DI VARIAZIONE)
		   SKIP+1
		   LOOP
	   ENDIF
	ENDIF

	*** FORNITORI - FATTURE
	IF (__CLIFOR == 2 .AND. __FATNOT == "F")
	
	   IF (ALLTRIM(m.nazione) == 'ITA')   
		   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'  
			   REPLACE TIPOREC	WITH "2"   
		   ELSE
			   REPLACE TIPOREC	WITH "1"   	     && PERSONA FISICA
		   ENDIF
	   ELSE
		   REPLACE TIPOREC	WITH "3"   
	   ENDIF
	
	   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'
		   IF (ALLTRIM(m.nazione) == 'ITA')
			   ***REPLACE MODPAG   WITH "1"
			   REPLACE MODPAG   WITH __MODALITAPAG 
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			      REPLACE TIPOOPE    WITH "1"	&& Cessiono e/o prestazione 
			   ELSE
			      REPLACE TIPOOPE    WITH "2"	&& Cessione e/o prestazione ricevuta
			   ENDIF       
		   ELSE
			   ***REPLACE MODPAG   WITH "1"
			   REPLACE MODPAG   WITH __MODALITAPAG 
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			      REPLACE TIPOOPE    WITH "1"	&& Cessiono e/o prestazione 
			   ELSE
			      REPLACE TIPOOPE    WITH "2"	&& Cessione e/o prestazione ricevuta
			   ENDIF       
		   ENDIF
	   ELSE									 && PERSONA FISICA 
		   ***REPLACE MODPAG   WITH "1"
		   REPLACE MODPAG   WITH __MODALITAPAG 
	   ENDIF   
	ENDIF

	*** FORNITORI - NOTE VARIAZIONE
	IF (__CLIFOR == 2 .AND. __FATNOT == "N")
	   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'
		   IF (ALLTRIM(m.nazione) == 'ITA')
			   REPLACE TIPOREC	WITH "4"
	      	   REPLACE DATAFAT    WITH "3112"+SUBSTR(ALLTRIM(M.DTFATT),5)
	           REPLACE NUMEROFAT  WITH SPACE(15)
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			  	  VARIAZIONE = "C"	&& Credito
			   ELSE
			  	  VARIAZIONE = "D"	&& Debito
			   ENDIF      
		       REPLACE VARIMPONI  WITH VARIAZIONE 
		       REPLACE VARIMPOST  WITH VARIAZIONE 			   			      
		   ELSE
			   REPLACE TIPOREC	WITH "5"
	      	   REPLACE DATAFAT    WITH "3112"+SUBSTR(ALLTRIM(M.DTFATT),5)
	           REPLACE NUMEROFAT  WITH SPACE(15)
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			  	  VARIAZIONE = "C"	&& Credito
			   ELSE
			  	  VARIAZIONE = "D"	&& Debito
			   ENDIF      
		       REPLACE VARIMPONI  WITH VARIAZIONE 
		       REPLACE VARIMPOST  WITH VARIAZIONE 			   			         
		   ENDIF
	   ELSE									 && PERSONA FISICA (NON INTERESSANO LE NOTE DI VARIAZIONE)
		   SKIP+1
		   LOOP
	   ENDIF   
	ENDIF
		
	SELECT CUR_BLACKLIST
	SKIP + 1
ENDDO

SELECT TMP_PRINT 
GO TOP
DO WHILE !EOF()
	IF !EMPTY(ALLTRIM(TIPOREC))
		SCATTER MEMVAR MEMO
		SELECT PRINT_CUR_BLACKLIST
		APPEND BLANK
		GATHER MEMVAR MEMO
	ENDIF
	SELECT TMP_PRINT 
	SKIP + 1
ENDDO


SELECT PRINT_CUR_BLACKLIST
SET ORDER TO IDX
GO TOP

RELEASE PUB_TITOLO
PUBLIC PUB_TITOLO
PUB_TITOLO="STAMPA ELENCO "

IF __CLIFOR = 1
	PUB_TITOLO=	PUB_TITOLO + "CLIENTI"
	IF __FATNOT = "F"
		PUB_TITOLO=	PUB_TITOLO + " - FATTURE"
	ELSE
		PUB_TITOLO=	PUB_TITOLO + " - NOTE DI VARIAZIONE"	
	ENDIF
ELSE
	PUB_TITOLO=	PUB_TITOLO + "FORNITORI"
	IF __FATNOT = "F"
		PUB_TITOLO=	PUB_TITOLO + " - FATTURE"
	ELSE
		PUB_TITOLO=	PUB_TITOLO + " - NOTE DI VARIAZIONE"	
	ENDIF
ENDIF

WAIT CLEAR

IF _WW_OKSTA
   DO PRG\MENUSTA WITH "PRINT_CUR_BLACKLIST",.T.,.T.,"XXX","spesometro_ctrl.frx","spesometro_ctrl.frx"
   DO PRG\MENUSTA WITH "dividiAliquota",.T.,.T.,"XXX","spesometro_ctrl_rie.frx","spesometro_ctrl_rie.frx"
ENDIF

RELEASE PUB_TITOLO

RETURN



*###################################################################################
***
***    F O R N I T O R I 
***
*###################################################################################


**********************************************************************************************
     PROCEDURE FORNITORI    
***********************************************************************************************
LPARAMETERS __FATTURA_O_NOTACREDITO
__FTNC = ALLTRIM(__FATTURA_O_NOTACREDITO)

SET NEAR OFF
SET EXACT ON
SET EXCLUSIVE OFF

SELECT U_IVF_CL
HH=AFIELDS(TRANSIVC)
CREATE CURSOR IVA FROM ARRAY TRANSIVC


DATA_DA = RIBALTA2(DATADAL)
DATA_A  =  RIBALTA2(DATAAL)
ANNO_DA = substr(data_da,1,4)
MESE_DA = substr(data_da,6,2)
MESE_A  = substr(data_a,6,2)


SET NEAR ON
SELECT U_IVF_CL

SET ORDER TO DATAFATT
GO TOP

CTRELAB = 0

DO WHILE !EOF()       && CARICA I RECORD PRINCIPALI DI FATTURAZIONE
  IF DELETED()
    SELECT U_IVF_CL
    SKIP +1
    LOOP
  ENDIF

  ** Considero i movimenti relaviti all'anno contabile di cui desidero estrarre il tracciato
  IF IVF_ANNO != __ANNO__
    SELECT U_IVF_CL
    SKIP +1
    LOOP
  ENDIF

  ** Salto tutti i record DIVERSI DAL PARAMETRO PASSATO IN INPUT ALLA PROCEDURA
  IF (ALLTRIM(IVF_FATNOT) != ALLTRIM(__FTNC))
    SELECT U_IVF_CL
    SKIP +1
    LOOP
  ENDIF
  
  
  SELECT U_IVF_CL
  

  SCATTER MEMVAR MEMO	    && Salva i vecchi valori
  SELECT IVA
  APPEND BLANK
  GATHER MEMVAR MEMO		&& Salva le modifiche

  CTRELAB=CTRELAB+1 
  =CONTATORE("Movimenti fornitori",CTRELAB)


  SELECT U_IVF_CL
  SKIP

ENDDO



CT = 0
SELECT IVA
GO TOP



*************************
* INIZIA L'ELABORAZIONE *
*************************
DO WHILE !EOF()
	
	IF DELETED()
        SELECT IVA
    	SKIP +1
    	LOOP
  	ENDIF

	__IVFDL78 = ""
	IF IVF_DL78
		__IVFDL78 = "S"
	ENDIF
	
  	ANNO   	= IVF_ANNO
  	WTOP   	= IVF_TOP
  	WCONTO 	= IVF_CODCLI
  	WCODCLI = IVF_CODCLI

  	CT = CT + 1

  	_NUMFAT     = IVF_NUMFAT
  	_ANNO       = IVF_ANNO

	IF (__FTNC == "F")
		WAIT WINDOWS "Fattura FORNITORE elaborata n. " + _NUMFAT     NOWAIT	
	ELSE
		WAIT WINDOWS "Nota Variazione FORNITORE elaborata n. " + _NUMFAT     NOWAIT	
	ENDIF

  	WTOP        = IVF_TOP
  	
	___RAGSOC= IVF_RAGSOC  	
  
  	** Prelevo i dati anagrafici dei clienti (dati non contabili)
    SELECT U_FOR_AN
    SET ORDER TO U_FOR_AN

    WCOD = ALLTRIM(WCODCLI)

    SEEK PUB_CODSOC+ALLTRIM(WCOD)
    IF FOUND()
    
      WRAGSOC   = FOR_RAGLEG
	  IF EMPTY(WRAGSOC)	      
	      WRAGSOC   = FOR_RAGSOC
	  ENDIF
	  
      WINDIRI   = FOR_INDLEG
	  IF EMPTY(WINDIRI)	      
	      WINDIRI = FOR_INDIR
	  ENDIF
	  
      WLOCALI   = FOR_LOCLEG
	  IF EMPTY(WLOCALI)	      
	      WLOCALI = FOR_LOCALI
	  ENDIF
	  
      WCAP      = FOR_CAPLEG
	  IF EMPTY(WCAP)	      
	      WCAP = FOR_CAP
	  ENDIF
	  
      WPARIVA   = FOR_PIVALG
	  IF EMPTY(WPARIVA)	      
	      WPARIVA   = FOR_PARIVA
	  ENDIF
	  
      WCODFIS   = FOR_CFISLG
	  IF EMPTY(WCODFIS)	      
	      WCODFIS   = FOR_CODFIS
	  ENDIF
	  
      WNAZION   = FOR_NAZION
	  
	  *** GESTIONE IVA CEE
      WIVCELG   = FOR_IVCELG
	  IF EMPTY(WIVCELG)	      
	      WIVCELG   = FOR_IVACEE
	  ENDIF      
	  
      WCODIVA	= FOR_CODIVA
	  WPROVI    = ""

  	  WTIPOSOGGETTO = ALLTRIM(STR(FOR_RECCAT))  	  
      WCOGNOME      = FOR_reccog
      WNOME		    = FOR_recnom
      WDATANAS  	= FOR_ESTNAS      
	  WPROVINAS     = FOR_PRONAS       
      WCOMUNESTNAS  = FOR_ESTCOM
      WSTATOESTDOM  = FOR_ESTDOM      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
      WSTATOESTLEG  = FOR_ESTNAZ      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
      WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
      WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
	  
	  
	  
    ELSE
    
      *** NON L'HO TROVATO
      *** CERCO PER RAGIONE SOCIALE
	  SELECT U_FOR_AN
	  SET ORDER TO U_FOR_RG
	  SEEK PUB_CODSOC+ALLTRIM(___RAGSOC)
      
	  IF FOUND()
	  
	      WRAGSOC   = FOR_RAGLEG
		  IF EMPTY(WRAGSOC)	      
	    	  WRAGSOC   = FOR_RAGSOC
		  ENDIF
	  
    	  WINDIRI   = FOR_INDLEG
		  IF EMPTY(WINDIRI)	      
		      WINDIRI = FOR_INDIR
		  ENDIF
	  
    	  WLOCALI   = FOR_LOCLEG
		  IF EMPTY(WLOCALI)	      
		      WLOCALI = FOR_LOCALI
		  ENDIF
	  
	      WCAP      = FOR_CAPLEG
		  IF EMPTY(WCAP)	      
		      WCAP = FOR_CAP
		  ENDIF
	  
	      WPARIVA   = FOR_PIVALG
		  IF EMPTY(WPARIVA)	      
		      WPARIVA   = FOR_PARIVA
		  ENDIF
	  
	      WCODFIS   = FOR_CFISLG
		  IF EMPTY(WCODFIS)	      
		      WCODFIS   = FOR_CODFIS
		  ENDIF

	      WNAZION   = FOR_NAZION	  
	      WCODIVA	= FOR_CODIVA

		  *** GESTIONE IVA CEE
	      WIVCELG   = FOR_IVCELG
		  IF EMPTY(WIVCELG)	      
		      WIVCELG   = FOR_IVACEE
		  ENDIF      
      
		  WPROVI    = ""
		  
	  	  WTIPOSOGGETTO = ALLTRIM(STR(FOR_RECCAT))  		  
	      WCOGNOME      = FOR_reccog
	      WNOME		    = FOR_recnom
	      WDATANAS  	= FOR_ESTNAS 
		  WPROVINAS     = FOR_PRONAS       	           
	      WCOMUNESTNAS  = FOR_ESTCOM
	      WSTATOESTDOM  = FOR_ESTDOM      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
	      WSTATOESTLEG  = FOR_ESTNAZ      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
	      WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
	      WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
		  

	  ELSE      
	  

	      *** NON L'HO TROVATO NEANCHE PER RAGIONE SOCIALE
	      *** USO I CAMPI SUL CURSOR IVA GIA' VALORIZZATI
	      *** MI ACCORGO CHE SONO IN QUESTO CASO PERCHE' NEL DETTAGLIO
	      *** DEL FORNITORE MANCA IL CAMPO IVA E CODICE FISCALE
	      *** CHE QUI VALORIZZO A ""
	      *** 
	      SELECT IVA
      
    	  WRAGSOC   = IVF_RAGSOC
	      WINDIRI   = IVF_INDIRI
	      WLOCALI   = IVF_LOCALI
	      WCAP      = IVF_CAP
	      WPARIVA   = IVF_PARIVA
	      WCODFIS   = ""
		  WCODIVA	= ""      
		  WPROVI    = ""
	      WNAZION   = ""
    	  WIVCELG   = ""	
    	  
	  	  WTIPOSOGGETTO = ""
	      WCOGNOME      = ""
	      WNOME		    = ""
	      WDATANAS  	= ""
		  WPROVINAS     = ""
	      WCOMUNESTNAS  = ""
	      WSTATOESTDOM  = ""      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
	      WSTATOESTLEG  = ""      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
	      WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
	      WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
    	  
    	  	  
	   ENDIF
	   
	ENDIF

	SELECT PARA
	SET ORDER TO CODICE
	SEEK 'IVA'+WCODIVA
	IF FOUND()
		WDESIVA	   = alltrim(DESCRI)			&& Descrizione del codice IVA
		WPERCIVA   = VAL(SUBSTR(LIBERA,1,3))	&& Percentuale IVA
		WPERCIVACHR= SUBSTR(LIBERA,1,3)			&& CARATTERE Percentuale IVA		
  		WTIPOIVA   = SUBSTR(LIBERA,100,1)		&& Tipo IVA ( SE = "I" è INDEDUCIBILE )
  		WPERCIVA_I = VAL(SUBSTR(LIBERA,110,3))  && Percentuale di INDEDUCIBILITA'		
	ELSE
		WDESIVA	   = ''  && Descrizione del codice IVA
  		WPERCIVA   = 0	 && PERCENTUALE IVA INESISTENTE (caso assurdo) ???
		WPERCIVACHR= ''  && CARATTERE PERCENTUALE IVA INESISTENTE (caso assurdo) ???  		
	  	WTIPOIVA   = ''	 && Non ha il valore che mi interessa : "I" di indeducibile
  		WPERCIVA_I = 0	 && Non ha valore se non esiste la "I" di indeducibile
	ENDIF


	SELECT IVA
    
	*** AZZERA LE VARIABILI USATE PER LA STAMPA
	
	Imponibile 				= 0
	Imposta    				= 0
	ValoreTot  				= 0
	imponibile_indeducibile	= 0
	imposta_indeducibile	= 0
	
	__totArt10 		= 0
	__totArt8 		= 0
	__totArt8bis 	= 0
	__totArt9 		= 0
	__totArt40		= 0
	__totArt41 		= 0
	__totArt52 		= 0
	__totArt72 		= 0
	__totAltro 		= 0
	

	WTOTIM      = IVF_IMPONI
	WTOTIMPO    = IVF_IMPOST

	WFATNOT	  = ALLTRIM(IVF_FATNOT)
	
	_datafatt = RIBALTA2(ALLTRIM(IVF_DTFATT))
	WDTFATT	  = SUBSTR(_datafatt,1,2) + SUBSTR(_datafatt,4,2) + SUBSTR(_datafatt,7,4)		    && DATA DOCUMENTO
	WNUMDOC	  = PADR(ALLTRIM(IVF_NUMFAT),15,' ')										 		&& NUMERO DOCUMENTO			
	WTOPDOC	  = ALLTRIM(IVF_TOP)			    												&& TIPO OPERAZIONE			
	IF !EMPTY(ALLTRIM(WDATANAS))
		__DATANASCITA = SUBSTR(WDATANAS,1,2) + SUBSTR(WDATANAS,4,2) + SUBSTR(WDATANAS,7,4)
	ELSE	
		__DATANASCITA = SPACE(8)
	ENDIF	
     		 	      		 	      		 	
	ValoreTot  = WTOTIM

      		
	DO RIPARTIZIONE_IMPONIBILI_ESENZIONI_FORNITORI		   		

	** Salvo nel mio cursore finale i totali calcolati
	SELECT CUR_BLACKLIST
	SET ORDER TO M_NDOC		&& ordinato per numero fattura fornitore (solo per i fornitori ci possono essere più righe)
	__seek_numfat = ALLTRIM(WCODCLI) + PADL(ALLTRIM(WNUMDOC),15,' ')
	SEEK __seek_numfat 
	
	IF FOUND()
	
		** Il numero fattura è già stato trovato
		** Sommo i totali calcolati a quelli già presenti
		REPLACE Iva    					with 	Iva     + Imposta
		REPLACE valore 					with 	valore  + ValoreTot
		REPLACE imponi 					with 	imponi  + Imponibile
		REPLACE imponi_indeducibile 	with	imponi_indeducibile + imponibile_indeducibile
		REPLACE iva_indeducibile 		with	iva_indeducibile + imposta_indeducibile

		REPLACE esenz  					with 	esenz   + __totArt10			
		REPLACE art8  					with 	art8  	 + __totArt8			
		REPLACE art8bis 				with 	art8bis + __totArt8bis
		REPLACE art9  					with 	art9  	 + __totArt9
		REPLACE art40  					with 	art40   + __totArt40
		REPLACE art41  					with 	art41   + __totArt41
		REPLACE art52  					with 	art52   + __totArt52
		REPLACE art72  					with 	art72   + __totArt72
		REPLACE altrees					with 	altrees + __totAltro	
				
	ELSE
	
		** Il numero fattura NON E' ANCORA stato trovato
		** Credo il record con il nuovo dato
		APPEND BLANK
		REPLACE INELENCO	 		    WITH __IVFDL78			&& SIMONE - 16/12/2011		
		REPLACE TIPOSOGGETTO 		    WITH WTIPOSOGGETTO
		REPLACE codcli  				with WCOD
		REPLACE ragsoc  				with WRAGSOC
		REPLACE indiri  				with WINDIRI
		REPLACE locali  				with WLOCALI
		REPLACE cap						with WCAP
		REPLACE provi					with WPROVI
*!*			REPLACE nazione 				with WNAZION
*!*			IF !EMPTY(ALLTRIM(WPARIVA))
*!*				REPLACE pariva  			with WPARIVA
*!*			ELSE	
*!*				REPLACE pariva  			with WIVCELG			    && PARTITA IVA CEE
*!*			ENDIF	
		REPLACE codfis  				with WCODFIS
		REPLACE pivacod					with WCODIVA	&& Codice IVA
		REPLACE pivades  				with WDESIVA	&& Descrizione del codice IVA
		REPLACE pivaperc  				with WPERCIVA	&& Percentuale IVA
		REPLACE pivatipo  				with WTIPOIVA	&& Tipo IVA ( SE = "I" è INDEDUCIBILE )
		REPLACE pivaperI  				with WPERCIVA_I	&& Percentuale di INDEDUCIBILITA'
	  	REPLACE FATNOT 					with WFATNOT    && FATTURA / NOTA CREDITO
	  	REPLACE DTFATT					with WDTFATT    && DATA DOCUMENTO
	  	REPLACE NUMDOC					with WNUMDOC    && NUMERO DOCUMENTO				
	  	REPLACE TOP  					with WTOPDOC	&& TIPO OPERAZIONE DOCUMENTO				
	  	REPLACE CLIFOR					with "F"	    && FORNITORE
		&& INIZIO ESTERO #################################################################################
		  && PERSONA FISICA -----------------------------------------------------------------------
		  REPLACE COGNOME 				WITH WCOGNOME		&& OBBLIGATORIO SE PERSONA FISICA
		  REPLACE NOME 					WITH WNOME			&& OBBLIGATORIO SE PERSONA FISICA
		  REPLACE DTNASCITA 			WITH __DATANASCITA 	&& OBBLIGATORIO SE PERSONA FISICA
		  REPLACE COMUNENAS 			WITH WCOMUNESTNAS  	&& OBBLIGATORIO SE PERSONA FISICA
		  REPLACE PROVINAS 				WITH WPROVINAS	 	&& OBBLIGATORIO SE PERSONA FISICA - GESTITA NEL FORM
		  REPLACE STATODOM 				WITH WSTATOESTDOM  	&& CODICE STATO COME DA MODELLO "UNICO"
		  && PERSONA GIURIDICA --------------------------------------------------------------------
		  REPLACE DENOMINAZ 			WITH WRAGSOC		&& OBBLIGATORIO SE PERSONA GIURIDICA
		  REPLACE CITTALEG				WITH WCITTAESTERO	&& NON OBBLIGATORIO
		  REPLACE STATOLEG 				WITH WSTATOESTLEG	&& CODICE STATO COME DA MODELLO "UNICO"
		  REPLACE INDIREST 				WITH WINDESTERO		&& NON OBBLIGATORIO
		&& FINE ESTERO ###################################################################################	  
		REPLACE valore  				with ValoreTot
		REPLACE imponi  				with Imponibile
		REPLACE Iva     				with Imposta
		REPLACE imponi_indeducibile 	WITH imponibile_indeducibile
		REPLACE iva_indeducibile 		WITH imposta_indeducibile
		REPLACE esenz  					with __totArt10			
		REPLACE art8  					with __totArt8			
		REPLACE art8bis 				with __totArt8bis
		REPLACE art9  					with __totArt9
		REPLACE art40  					with __totArt40
		REPLACE art41  					with __totArt41
		REPLACE art52  					with __totArt52
		REPLACE art72  					with __totArt72
		REPLACE altrees					with __totAltro			
		
	ENDIF
	
	SELECT IVA
    SKIP +1

ENDDO


*SELECT * from CUR_BLACKLIST where valore <> 0 order by ragsoc into cursor CUR_BLACKLIST
SELECT CUR_BLACKLIST
GO TOP


RETURN




**********************************************************************************
** RIPARTISCE il valore dell' imponibile e/o esenzioni per ogni movimento iva   **
** 
** solo per fornitori
**
**********************************************************************************
PROCEDURE RIPARTIZIONE_IMPONIBILI_ESENZIONI_FORNITORI

__moviva = alltrim(IVA.IVF_CODIVA)
__E_INDEDUCIBILE= .F.

IF "*" $ __moviva
	__E_INDEDUCIBILE= .T.
ENDIF

IF IVA.IVF_IND100="S"
	__E_INDEDUCIBILE= .T.
ENDIF

__imponibile_indeducibile	= 0
__imposta_indeducibile		= 0	
__imponibile_deducibile		= 0
__imposta_deducibile		= 0	
      		 		
IF __E_INDEDUCIBILE		&& iva indeducibile
	__imponibile_indeducibile   = IVA.IVF_IMPONI
	__imposta_indeducibile		= IVA.IVF_IMPOST
ELSE
	__imponibile_deducibile   	= IVA.IVF_IMPONI
	__imposta_deducibile		= IVA.IVF_IMPOST
ENDIF

__classIva = classiva(__moviva)
  
  

     		 	      
DO CASE
    
		CASE __classIva = 1
    		__totArt10 = __totArt10 + (WTOTIM)    	&& ESENZIONE ARTICOLO 10
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
 
    	CASE __classIva = 2
    		__totArt8 = __totArt8 + (WTOTIM)			&& NON IMPONIBILE ARTICOLO 8 
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 3
    		__totArt8bis = __totArt8bis + (WTOTIM)	&& NON IMPONIBILE ARTICOLO 8-BIS
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 4
    		__totArt9 = __totArt9 + (WTOTIM)			&& NON IMPONIBILE ARTICOLO 9
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 5
    		__totArt40 = __totArt40 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 40
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 6
    		__totArt41 = __totArt41 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 41
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 7
    		__totArt52 = __totArt52 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 52
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 8
    		__totArt72 = __totArt72 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 72
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					
    		      		 			
    	CASE __classIva = 9
    		__totAltro = __totAltro + (WTOTIM)		&& ALTRE ESENZIONI NON IN ELENCO CLIENTI / FORNITORI
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ALTRO        with ALTRO    + (WTOTIM)
			ENDIF	      		 					

    		      		 				
    	OTHERWISE
   			imponibile_indeducibile = imponibile_indeducibile + (__imponibile_indeducibile)								&& IMPONIBILE INDEDUCIBILE
   			imposta_indeducibile 	= imposta_indeducibile + (__imposta_indeducibile)
   			Imponibile 				= Imponibile + (__imponibile_deducibile)		&& IMPONIBILE al netto dell'imponibile indeducibile e dell'imposta indeducibile
   			Imposta 				= Imposta 	 + (__imposta_deducibile)		
    		
    			
			select dividiAliquota
			set order to pAli
			go top
   			SEEK __moviva
   			IF FOUND()
				REPLACE Impo_NO_D  with Impo_NO_D + (__imponibile_indeducibile)   	
				REPLACE Iva_NO_D   with Iva_NO_D + (__imposta_indeducibile)
				REPLACE Impo_DED   with Impo_DED + (__imponibile_deducibile)
				REPLACE Iva_DED    with Iva_DED + (__imposta_deducibile)		
			ENDIF	      		 					

    	
ENDCASE
  		 		     
RETURN

*###################################################################################


*###################################################################################
***
***    C L I E N T I 
***
*###################################################################################


***********************************************************************************************
     PROCEDURE CLIENTI    
***********************************************************************************************
LPARAMETERS __FATTURA_O_NOTACREDITO
__FTNC = ALLTRIM(__FATTURA_O_NOTACREDITO)

SET NEAR OFF
SET EXACT ON
SET EXCLUSIVE OFF

SELECT U_IVA_CL
HH=AFIELDS(TRANSIVC)
CREATE CURSOR IVA FROM ARRAY TRANSIVC
INDEX ON VAL(IVA_NUMDOC) TAG I_NDOC

DATA_DA = RIBALTA2(DATADAL)
DATA_A =  RIBALTA2(DATAAL)

ANNO_DA = substr(data_da,1,4)
MESE_DA = substr(data_da,6,2)
MESE_A = substr(data_a,6,2)


SET NEAR ON
SELECT U_IVA_CL
SET ORDER TO DATAFATT
GO TOP
_SK = PUB_CODSOC+DATA_DA

SEEK _SK

CTRELAB = 0


DO WHILE !EOF()       && CARICA I RECORD PRINCIPALI DI FATTURAZIONE
  IF DELETED()
    SELECT U_IVA_CL
    SKIP +1
    LOOP
  ENDIF


  ** Se la data fattura è minore della data inizio (01/01/anno) allora la scarto
  IF IVA_DTFATT < DATA_DA
    EXIT
  ENDIF
  
  
  ** Salto tutti i record successivi alla data fine (31/12/anno)
  IF IVA_DTFATT > DATA_A
    SELECT U_IVA_CL
    SKIP +1
    LOOP
  ENDIF
  
  ** Salto tutti i record DIVERSI DAL PARAMETRO PASSATO IN INPUT ALLA PROCEDURA
  IF (ALLTRIM(IVA_FATNOT) != ALLTRIM(__FTNC))
    SELECT U_IVA_CL
    SKIP +1
    LOOP
  ENDIF

  SELECT U_IVA_CL

  SCATTER MEMVAR MEMO	    && Salva i vecchi valori
  SELECT IVA
  APPEND BLANK
  GATHER MEMVAR MEMO		&& Salva le modifiche

  CTRELAB=CTRELAB+1 
  =CONTATORE("Movimenti CLIENTI",CTRELAB)

  SELECT U_IVA_CL
  SKIP

ENDDO


CT = 0
SELECT IVA
SET ORDER TO I_NDOC
GO TOP


*************************
* INIZIA L'ELABORAZIONE *
*************************
DO WHILE !EOF()
	
	IF DELETED()
        SELECT IVA
    	SKIP +1
    	LOOP
  	ENDIF

	ANNO   	= IVA_ANNO
  	WCONTO 	= IVA_CODCLI
  	WCODCLI = IVA_CODCLI

  	CT = CT + 1

  	_NUMDOC     = IVA_NUMDOC
  	_ANNO       = IVA_ANNO

	IF (__FTNC == "F")
		WAIT WINDOWS "Fattura CLIENTE elaborata n. " + _NUMDOC     NOWAIT	
	ELSE
		WAIT WINDOWS "Nota Variazione CLIENTE elaborata n. " + _NUMDOC     NOWAIT	
	ENDIF



	___RAGSOC= IVA_RAGSOC  	
  
  	** Prelevo i dati anagrafici dei clienti (dati non contabili)
    SELECT U_CLI_AN
    SET ORDER TO U_CLI_AN

    WCOD = ALLTRIM(WCODCLI)

    SEEK PUB_CODSOC+ALLTRIM(WCOD)
    IF FOUND()
    
      WRAGSOC   = CLI_RAGLEG
	  IF EMPTY(WRAGSOC)	      
	      WRAGSOC   = CLI_RAGSOC
	  ENDIF
	  
      WINDIRI   = CLI_INDLEG
	  IF EMPTY(WINDIRI)	      
	      WINDIRI = CLI_INDIR
	  ENDIF
	  
      WLOCALI   = CLI_LOCLEG
	  IF EMPTY(WLOCALI)	      
	      WLOCALI = CLI_LOCALI
	  ENDIF
	  
      WCAP      = CLI_CAPLEG
	  IF EMPTY(WCAP)	      
	      WCAP = CLI_CAP
	  ENDIF
	  
      WPARIVA   = CLI_PIVALG
	  IF EMPTY(WPARIVA)	      
	      WPARIVA   = CLI_PARIVA
	  ENDIF
	  
	  WCODFIS   = CLI_RECCDF
	  IF EMPTY(WCODFIS)	      
	      WCODFIS   = CLI_CFISLG
		  IF EMPTY(WCODFIS)	      
		      WCODFIS   = CLI_CODFIS
		  ENDIF
	  ENDIF	  

      WNAZION   = CLI_NAZLEG
	  IF EMPTY(WNAZION)	      
	      WNAZION   = CLI_NAZION
	  ENDIF

	  *** GESTIONE IVA CEE
      WIVCELG   = CLI_IVCELG
	  IF EMPTY(WIVCELG)	      
	      WIVCELG   = CLI_IVACEE
	  ENDIF      
	  
	  WPROVI    = CLI_PROLEG
	  IF EMPTY(WPROVI)	      
	      WPROVI = CLI_PROVIN
	  ENDIF
	  
      WCODIVA	= CLI_CODIVA

	  WTIPOSOGGETTO = ALLTRIM(STR(CLI_RECCAT))  
      WCOGNOME      = cli_reccog
      WNOME		    = cli_recnom
      WDATANAS  	= CLI_ESTNAS  
	  WPROVINAS     = CLI_PRONAS                 
      WCOMUNESTNAS  = CLI_ESTCOM
      WSTATOESTDOM  = CLI_ESTDOM      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
      WSTATOESTLEG  = CLI_ESTNAZ      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
      WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
      WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
      

    ELSE
    
      *** NON L'HO TROVATO
      *** CERCO PER RAGIONE SOCIALE
	  SELECT U_CLI_AN
	  SET ORDER TO U_CLI_RG
	  SEEK PUB_CODSOC+ALLTRIM(___RAGSOC)
      
	  IF FOUND()
	  
	      WRAGSOC   = CLI_RAGLEG
		  IF EMPTY(WRAGSOC)	      
	    	  WRAGSOC   = CLI_RAGSOC
		  ENDIF
	  
    	  WINDIRI   = CLI_INDLEG
		  IF EMPTY(WINDIRI)	      
		      WINDIRI = CLI_INDIR
		  ENDIF
	  
    	  WLOCALI   = CLI_LOCLEG
		  IF EMPTY(WLOCALI)	      
		      WLOCALI = CLI_LOCALI
		  ENDIF
	  
	      WCAP      = CLI_CAPLEG
		  IF EMPTY(WCAP)	      
		      WCAP = CLI_CAP
		  ENDIF
	  
	      WPARIVA   = CLI_PIVALG
		  IF EMPTY(WPARIVA)	      
		      WPARIVA   = CLI_PARIVA
		  ENDIF
	  
		  WCODFIS   = CLI_RECCDF
		  IF EMPTY(WCODFIS)	      
		      WCODFIS   = CLI_CFISLG
			  IF EMPTY(WCODFIS)	      
			      WCODFIS   = CLI_CODFIS
			  ENDIF
		  ENDIF	  
	  
	      WNAZION   = CLI_NAZLEG
		  IF EMPTY(WNAZION)	      
		      WNAZION   = CLI_NAZION
		  ENDIF
	  
	      WCODIVA	= CLI_CODIVA

		  *** GESTIONE IVA CEE
	      WIVCELG   = CLI_IVCELG
		  IF EMPTY(WIVCELG)	      
		      WIVCELG   = CLI_IVACEE
		  ENDIF      
      
		  WPROVI    = CLI_PROLEG
		  IF EMPTY(WPROVI)	      
		      WPROVI = CLI_PROVIN
		  ENDIF

	  	  WTIPOSOGGETTO = ALLTRIM(STR(CLI_RECCAT))  
	      WCOGNOME      = cli_reccog
	      WNOME		    = cli_recnom
     	  WDATANAS  	= CLI_ESTNAS   
		  WPROVINAS     = CLI_PRONAS            	     
	      WCOMUNESTNAS  = CLI_ESTCOM
	      WSTATOESTDOM  = CLI_ESTDOM      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
	      WSTATOESTLEG  = CLI_ESTNAZ      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
	      WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
	      WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<


	  ELSE      
	      
	      *** NON L'HO TROVATO NEANCHE PER RAGIONE SOCIALE
	      *** USO I CAMPI SUL CURSOR IVA GIA' VALORIZZATI
	      *** MI ACCORGO CHE SONO IN QUESTO CASO PERCHE' NEL DETTAGLIO
	      *** DEL CLIENTE MANCA IL CAMPO IVA E CODICE FISCALE
	      *** CHE QUI VALORIZZO A ""
	      *** 
	      SELECT IVA
      
    	  WRAGSOC   = IVA_RAGSOC
	      WINDIRI   = IVA_INDIRI
	      WLOCALI   = IVA_LOCALI
	      WCAP      = IVA_CAP
	      WPARIVA   = IVA_PARIVA
	      WCODFIS   = ""
		  WCODIVA	= ""      
		  WPROVI    = ""
		  
	  	  WTIPOSOGGETTO = ""
	      WCOGNOME      = ""
	      WNOME		    = ""
     	  WDATANAS  	= ""
		  WPROVINAS     = ""
	      WCOMUNESTNAS  = ""
	      WSTATOESTDOM  = ""      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
	      WSTATOESTLEG  = ""      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
	      WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
	      WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
		  
		  
	   ENDIF
	   
	ENDIF

	SELECT PARA
	SET ORDER TO CODICE
	SEEK 'IVA'+WCODIVA
	IF FOUND()
		WDESIVA	   = alltrim(DESCRI)			&& Descrizione del codice IVA
		WPERCIVA   = VAL(SUBSTR(LIBERA,1,3))	&& Percentuale IVA
		WPERCIVACHR= SUBSTR(LIBERA,1,3)			&& CARATTERE Percentuale IVA		
  		WTIPOIVA   = SUBSTR(LIBERA,100,1)		&& Tipo IVA ( SE = "I" è INDEDUCIBILE )
  		WPERCIVA_I = VAL(SUBSTR(LIBERA,110,3))  && Percentuale di INDEDUCIBILITA'		
	ELSE
		WDESIVA	   = ''  && Descrizione del codice IVA
  		WPERCIVA   = 0	 && PERCENTUALE IVA INESISTENTE (caso assurdo) ???
		WPERCIVACHR= ''  && CARATTERE PERCENTUALE IVA INESISTENTE (caso assurdo) ???  		
	  	WTIPOIVA   = ''	 && Non ha il valore che mi interessa : "I" di indeducibile
  		WPERCIVA_I = 0	 && Non ha valore se non esiste la "I" di indeducibile
	ENDIF


	SELECT IVA
    
	*** AZZERA LE VARIABILI USATE PER LA STAMPA
	
	Imponibile 				= 0
	Imposta    				= 0
	ValoreTot  				= 0
	imponibile_indeducibile	= 0
	imposta_indeducibile	= 0
	
	__totArt10 		= 0
	__totArt8 		= 0
	__totArt8bis 	= 0
	__totArt9 		= 0
	__totArt40		= 0
	__totArt41 		= 0
	__totArt52 		= 0
	__totArt72 		= 0
	__totAltro 		= 0
	

	WTOTIM      = IVA_IMPONI
	WTOTIMPO    = IVA_IMPOST

	
	WFATNOT	  = ALLTRIM(IVA_FATNOT)			    												&& FATTURA / NOTA CREDITO
	_datafatt = RIBALTA2(ALLTRIM(IVA_DTFATT))
	WDTFATT	  = SUBSTR(_datafatt,1,2) + SUBSTR(_datafatt,4,2) + SUBSTR(_datafatt,7,4)		    && DATA DOCUMENTO
	WNUMDOC	  = PADR(ALLTRIM(IVA_NUMDOC),15,' ')						 			    		&& NUMERO DOCUMENTO			
	WTOPDOC	  = ALLTRIM(IVA_TOP)			    												&& TIPO OPERAZIONE			
	IF !EMPTY(ALLTRIM(WDATANAS))
		__DATANASCITA = SUBSTR(WDATANAS,1,2) + SUBSTR(WDATANAS,4,2) + SUBSTR(WDATANAS,7,4)
	ELSE	
		__DATANASCITA = SPACE(8)
	ENDIF	

	ValoreTot  = WTOTIM 

      		
		
	SELECT IVA
    SKIP +1

ENDDO


*SELECT * from CUR_BLACKLIST where valore <> 0 order by ragsoc into cursor CUR_BLACKLIST
SELECT CUR_BLACKLIST
GO TOP

RETURN



**********************************************************************************
** RIPARTISCE il valore dell' imponibile e/o esenzioni per ogni movimento iva   **
** 
** solo per CLIENTI
**
**********************************************************************************
PROCEDURE RIPARTIZIONE_IMPONIBILI_ESENZIONI_CLIENTI

__moviva = alltrim(IVA.IVA_CODIVA)
__E_INDEDUCIBILE= .F.

IF "*" $ __moviva
	__E_INDEDUCIBILE= .T.
ENDIF


__imponibile_indeducibile	= 0
__imposta_indeducibile		= 0	
__imponibile_deducibile		= 0
__imposta_deducibile		= 0	
      		 		
IF __E_INDEDUCIBILE		&& iva indeducibile
	__imponibile_indeducibile   = IVA.IVA_IMPONI
	__imposta_indeducibile		= IVA.IVA_IMPOST
ELSE
	__imponibile_deducibile   	= IVA.IVA_IMPONI
	__imposta_deducibile		= IVA.IVA_IMPOST
ENDIF

__classIva = classiva(__moviva)
  
DO CASE
    
		CASE __classIva = 1
    		__totArt10 = __totArt10 + (WTOTIM)    	&& ESENZIONE ARTICOLO 10
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
 
    	CASE __classIva = 2
    		__totArt8 = __totArt8 + (WTOTIM)			&& NON IMPONIBILE ARTICOLO 8 
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 3
    		__totArt8bis = __totArt8bis + (WTOTIM)	&& NON IMPONIBILE ARTICOLO 8-BIS
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 4
    		__totArt9 = __totArt9 + (WTOTIM)			&& NON IMPONIBILE ARTICOLO 9
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 5
    		__totArt40 = __totArt40 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 40
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 6
    		__totArt41 = __totArt41 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 41
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 7
    		__totArt52 = __totArt52 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 52
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 8
    		__totArt72 = __totArt72 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 72
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					
    		      		 			
    	CASE __classIva = 9
    		__totAltro = __totAltro + (WTOTIM)		&& ALTRE ESENZIONI NON IN ELENCO CLIENTI / FORNITORI
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ALTRO        with ALTRO    + (WTOTIM)
			ENDIF	      		 					

    		      		 				
    	OTHERWISE
   			imponibile_indeducibile = imponibile_indeducibile + __imponibile_indeducibile								&& IMPONIBILE INDEDUCIBILE
   			imposta_indeducibile 	= imposta_indeducibile + __imposta_indeducibile
   			Imponibile 				= Imponibile + __imponibile_deducibile		&& IMPONIBILE al netto dell'imponibile indeducibile e dell'imposta indeducibile
   			Imposta 				= Imposta 	 + __imposta_deducibile		
    		
    			
			select dividiAliquota
			set order to pAli
			go top
   			SEEK __moviva
   			IF FOUND()
				REPLACE Impo_NO_D  with Impo_NO_D + __imponibile_indeducibile   	
				REPLACE Iva_NO_D   with Iva_NO_D + __imposta_indeducibile
				REPLACE Impo_DED   with Impo_DED + __imponibile_deducibile
				REPLACE Iva_DED    with Iva_DED + __imposta_deducibile		
			ENDIF	      		 					

    	
ENDCASE
  		 		     
RETURN



*###################################################################################


**********************************************************************************
** Funzione per la determinazione della classe di appartenenza del codice IVA	**
** che verrà riportato nell'elenco Clienti/Fornitori							**
**********************************************************************************
function classiva
PARA _CODIVA

AABBSSIMO=SELECT()

*!*	=OPENDB("PARA")
**=> ERASMO - INIZIO 13/03/2007
cSql = "select * from PARA"
IF !ExecCommand(cSql,"PARA")
   RETURN .F.
ENDIF
SELECT PARA
INDEX ON CODICE TAG CODICE ADDITIVE
**=> ERASMO - FINE 13/03/2007
SELECT PARA
SET ORDER TO CODICE

SEEK 'IVA'+_CODIVA
IF FOUND()
  _valRit  = val(CLASSIVA)
  if VAL(CLASSIVA) = 9
  	_desc = alltrim(DESCRI)
  	select elencoAltro
  	append blank
  	REPLACE codiceAltro with alltrim(_CODIVA) + " - "+ _desc + ";"
  endif
ELSE
  _valRit = 10   && Assume il valore di "Nessuna classificazione" sul form PARA006
ENDIF

SELECT(AABBSSIMO)

RETURN _valRit




