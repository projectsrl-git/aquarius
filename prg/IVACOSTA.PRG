*************************************************************************************
*							STAMPA BOLLATO IVA CORRISPETTIVI
*************************************************************************************

IF EMPTY(ANNO) .OR. EMPTY(MESE)
   RETURN
ENDIF


IF OK_DEFI = 'S'
   IF PUB_AGGPRO
      NUMPRO_DA = NUMPRO_DA - 1
   ENDIF
ENDIF



_WW_RAGSOC = ""
_WW_INDIRI = ""
_WW_LOCALI = ""
_WW_PARIVA = ""  && ERASMO - 22/09/2023
x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
IF !ExecCommand(cSql,"CX_AZI_AN")
   return(.f.)
ENDIF
SELECT CX_AZI_AN
GO TOP
IF EOF()
ELSE
   _WW_RAGSOC = ALLTRIM(AZI_RAGSOC) + " - "
   _WW_INDIRI = ALLTRIM(AZI_INDIRI) + " - "
   _WW_LOCALI = ALLTRIM(AZI_CAP) + " " + ALLTRIM(AZI_LOCALI)
   _WW_PARIVA = ALLTRIM(AZI_PIVA)  && ERASMO - 22/09/2023
ENDIF
_WW_INTESTA = _WW_RAGSOC + _WW_INDIRI + _WW_LOCALI
_WW_INTESTA = ALLTRIM(_WW_INTESTA) + IIF(!EMPTY(_WW_PARIVA)," - P.IVA " + _WW_PARIVA,"")  && ERASMO - 22/09/2023

_WW_TITOLO = ""
_WW_CODIBI = "IVACOSTA"
x_codi = "CODICE = 'IBI" + _WW_CODIBI + "'"
x_cond = x_codi
Csql   = "select LIBERA from para where " + x_cond
IF !ExecCommand(cSql,"TMP_PARA")
   return(.f.)
ENDIF
SELECT TMP_PARA
GO TOP
IF !EOF()
	IF !EMPTY(LIBERA)
		_WW_TITOLO = ALLTRIM(LIBERA)
	ENDIF
ENDIF

ANNO  = PUB_ANNO
ANNOC = PUB_ANNO

PUBLIC SALTO_PAG,OK_PROTCO
PUBLIC PUB_CAROR
PUBLIC PUB_PAGI
PUBLIC PUB_RIGA
PUBLIC KEY_ATT,KEY_PREC,WCHIAVE,WCHIAVER,PAG_IN
SALTO_PAG = OK_NUMRIG && FA SALTO PAGINA
PAG_IN    = 0
OK_PROTCO = 0
PUB_CAROR = "="
KEY_ATT   = 0
KEY_PRE   = 0
WCHIAVE   = 0
WCHAVER   = SPACE(3)
PUB_PAGI  = 0
PUB_RIGA  = 65

IF W_NPAGINI > 0
	PAG_IN = W_NPAGINI
ENDIF

IF !ExecCommand("select libera from para where codice='000SPOOL'","_tmp")
  return(.f.)
ENDIF
SELECT _tmp
IF _TALLY <> 0
	SALTO_PAG=38  && FA SALTO PAGINA
	PUB_RIGA=46
ENDIF

PUBLIC F_IMPONI,F_IMPOST,I_IMPONI,I_IMPOST,E_IMPOST
F_IMPONI = 0 
F_IMPOST = 0
C_IMPONI = 0 
C_IMPOST = 0
E_IMPOST = 0

IF !ExecCommand("select * from u_iva_cl where 0=1","u_iva_cl")
  return(.f.)
ENDIF
SELECT U_IVA_CL
HH=AFIELDS(TRANSIVA)
CREATE CURSOR ANNI_TMP FROM ARRAY TRANSIVA

CREATE CURSOR IVA_STA;
 (RIGAT c(200))

CREATE CURSOR IVA_CL;
 (DTCREA C(10),NUMFAT C(6),NUMDOC C(6),DTFATT C(10),CODCLI C(10),RAGSOC C(40), PIVA C(11),;
 IMPONI N(17,3),IMPOST N(17,3),CODIVA C(3),DESIVA C(21),TOTALE N(17,3),;
 LOCALI C(20),CAP C(6),INDIRI C(10),FATNOT C(1),CHIAVE N(6),ito_codiva c(3),ito_desiva c(30),ito_imponi n(12),ito_impost n(12),ito_dtcrea c(10),ito_fatnot c(1),ito_clifor c(1),chiave_r c(3),RIGA c(200),RIGAT c(200),PAGINA N(10))


DO IVAERA               && RECUPERO IVA ERARIO PRECEDENTE

IF PUB_RIGA > SALTO_PAG
   DO IVATEST             && TESTATA BOLLATO SENZA SALTO PAGINA INIZIALE
ENDIF

DO IVADET               && DETTAGLIO BOLLATO

DO IVATOTC              && TOTALE IVA CORRISPETTIVI  777777

DO OK_SPOOL             && CREA LO SPOOL DI STAMPA


DO OK_PROTO              && AGGIORNA NUMERO DI PROTOCOLLO


ANNO  = SPACE(4)
ANNO1 = SPACE(4)
NDOC  = SPACE(6)

IF OK_FORMATO = 1
ELSE
   =MESSAGEBOX("Fine elaborazione. Procedi con la stampa tramite lo spooler",62,"ATTENZIONE")
   RETURN
ENDIF

X_COMPRESSO = 1

DO STAMPA_A4 WITH _NUMF,X_COMPRESSO

RETURN


*************************
PROCEDURE IVATEST
*************************
* TESTATA  BOLLATO IVA  *      SENZA SALTO PAGINA INIZIALE

IF OK_FORMATO = 3
   DO IVATEST4
   RETURN
ENDIF

*!*	**=> ERASMO - INIZIO 08/06/2007
*!*	_WW_RAGSOC = ""
*!*	_WW_INDIRI = ""
*!*	_WW_LOCALI = ""
*!*	x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
*!*	x_cond = x_soci
*!*	Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
*!*	IF !ExecCommand(cSql,"CX_AZI_AN")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT CX_AZI_AN
*!*	GO TOP
*!*	IF EOF()
*!*	ELSE
*!*	   _WW_RAGSOC = ALLTRIM(AZI_RAGSOC) + " - "
*!*	   _WW_INDIRI = ALLTRIM(AZI_INDIRI) + " - "
*!*	   _WW_LOCALI = ALLTRIM(AZI_CAP) + " " + ALLTRIM(AZI_LOCALI)
*!*	ENDIF
*!*	_WW_INTESTA = _WW_RAGSOC + _WW_INDIRI + _WW_LOCALI
*!*	**=> ERASMO - FINE 08/06/2007

SELECT IVA_CL
APPEND BLANK

APPEND BLANK
RIGA_D = SPACE(50)
*REPLACE RIGA     WITH RIGA_D 
REPLACE RIGA     WITH IIF(_Y_INTAZI,_WW_INTESTA,RIGA_D) && ERASMO - 08/06/2007
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

RIGA_D = SPACE(47)
*RIGA_D = RIGA_D+"REGISTRO CORRISPETTIVI RELATIVO AL MESE DI"+" " + MESE_C + ' ' + ANNO  
RIGA_D = RIGA_D+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"REGISTRO CORRISPETTIVI") + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO  && ERASMO - 04/08/2015

IF  OK_PAGI = 'S' 
	PAG_IN = PAG_IN + 1
	RIGA_D = RIGA_D+SPACE(20)+" Pag. " + STR(PAG_IN,6,0) 
ENDIF

REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(5)
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "|  REGISTRAZIONE |       DOCUMENTO      |           C L I E N T I                             |COD.| COD.            |                  |                     |                     |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "| PROT.     DATA |NUM.   D A T A        |   RAGIONE SOCIALE/DESCRIZIONE        P.IVA/COD.FIS. |IVA | VAL.|  CAMBIO   |     IMPONIBILE   |           IMPOSTA   |        TOT.DOCUM.   |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

PUB_RIGA = 10

RETURN 

    
*************************
PROCEDURE IVATES 
*************************
* TESTATA  BOLLATO IVA  *

IF OK_FORMATO = 3
   DO IVATES4
   RETURN
ENDIF

SELECT IVA_CL
APPEND BLANK

APPEND BLANK
RIGA_D = SPACE(50)

IF _Y_INTAZI
	RIGA_D = _WW_INTESTA
ENDIF

REPLACE RIGA     WITH ""+RIGA_D     && SALTO PAGINA SPOOLER
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

RIGA_D = SPACE(47)
*RIGA_D = RIGA_D+"REGISTRO CORRISPETTIVI RELATIVO AL MESE DI"+" " + MESE_C + ' ' + ANNO  
RIGA_D = RIGA_D+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"REGISTRO CORRISPETTIVI") + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO  && ERASMO - 04/08/2015

IF  OK_PAGI = 'S' 
	PAG_IN = PAG_IN + 1
	RIGA_D = RIGA_D+SPACE(20)+" Pag. " + STR(PAG_IN,6,0) 
ENDIF

REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(5)
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "|  REGISTRAZIONE |       DOCUMENTO      |           C L I E N T I                             |COD.| COD.            |                  |                     |                     |"

REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "| PROT.     DATA |NUM.   D A T A        |   RAGIONE SOCIALE/DESCRIZIONE        P.IVA/COD.FIS. |IVA | VAL.|  CAMBIO   |     IMPONIBILE   |           IMPOSTA   |        TOT.DOCUM.   |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

PUB_RIGA = 10

RETURN 
    

*************************
PROCEDURE IVATESTO 
*************************
* TESTATA  TOTALI BOLLATO  *

IF OK_FORMATO = 3
   DO IVATESO4
   RETURN
ENDIF

SELECT IVA_CL

APPEND BLANK
RIGA_D = SPACE(50)

IF _Y_INTAZI
	RIGA_D = _WW_INTESTA
ENDIF

REPLACE RIGAT    WITH ""+RIGA_D     && SALTO PAGINA SPOOLER
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

RIGA_D = SPACE(47)
*RIGA_D = RIGA_D+"REGISTRO CORRISPETTIVI RELATIVO AL MESE DI"+" " + MESE_C + ' ' + ANNO  
RIGA_D = RIGA_D+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"REGISTRO CORRISPETTIVI") + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO  && ERASMO - 04/08/2015

IF  OK_PAGI = 'S' 
	PAG_IN = PAG_IN + 1
	RIGA_D = RIGA_D+SPACE(20)+" Pag. " + STR(PAG_IN,6,0) 
ENDIF

REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(5)
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(2)
*RIGA_D = RIGA_D+SPACE(42) + "RIEPILOGO FINALE BOLLATO IVA CORRISPETTIVI"
RIGA_D = RIGA_D+SPACE(42) + "RIEPILOGO FINALE "+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"BOLLATO IVA CORRISPETTIVI")  && ERASMO - 04/08/2015
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

PUB_RIGA = 10

RETURN 
    

*************************
PROCEDURE IVATEST4
*************************
* TESTATA  BOLLATO IVA  *   SENZA SALTO PAGINA

SELECT IVA_CL
APPEND BLANK

APPEND BLANK
RIGA_D = SPACE(50)

IF _Y_INTAZI
	RIGA_D = _WW_INTESTA
ENDIF

REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

RIGA_D = SPACE(29)
*RIGA_D = RIGA_D+"REGISTRO CORRISPETTIVI RELATIVO AL MESE DI"+" " + MESE_C + ' ' + ANNO  
RIGA_D = RIGA_D+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"REGISTRO CORRISPETTIVI") + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO  && ERASMO - 04/08/2015

IF  OK_PAGI = 'S' 
	PAG_IN = PAG_IN + 1
	RIGA_D = RIGA_D+SPACE(20)+" Pag. " + STR(PAG_IN,6,0) 
ENDIF

REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(5)
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "----------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "|  REGISTRAZIONE |       DOCUMENTO      |     C L I E N T I             |COD.|                 |                  |                    |"

REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "| PROT.     DATA |COD.   NUM.     DATA  | RAGIONE SOCIALE/DESCRIZIONE   |IVA |    IMPONIBILE   |        IMPOSTA   |        TOT.DOCUM.  |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "----------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"
 
PUB_RIGA = 10

RETURN 

    
*************************
PROCEDURE IVATES4 
*************************
* TESTATA  BOLLATO IVA  *

SELECT IVA_CL
APPEND BLANK

APPEND BLANK
RIGA_D = SPACE(50)

IF _Y_INTAZI
	RIGA_D = _WW_INTESTA
ENDIF

REPLACE RIGA     WITH ""+RIGA_D     && SALTO PAGINA SPOOLER
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

RIGA_D = SPACE(29)
*RIGA_D = RIGA_D+"REGISTRO CORRISPETTIVI RELATIVO AL MESE DI"+" " + MESE_C + ' ' + ANNO  
RIGA_D = RIGA_D+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"REGISTRO CORRISPETTIVI") + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO  && ERASMO - 04/08/2015

IF  OK_PAGI = 'S' 
	PAG_IN = PAG_IN + 1
	RIGA_D = RIGA_D+SPACE(20)+" Pag. " + STR(PAG_IN,6,0) 
ENDIF

REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = SPACE(5)
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "----------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "|  REGISTRAZIONE |       DOCUMENTO      |     C L I E N T I             |COD.|                 |                  |                    |"

REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "| PROT.     DATA |COD.   NUM.     DATA  | RAGIONE SOCIALE/DESCRIZIONE   |IVA |    IMPONIBILE   |        IMPOSTA   |        TOT.DOCUM.  |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "----------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

PUB_RIGA = 10

RETURN 
    

*************************
PROCEDURE IVATESO4 
*************************
* TESTATA  TOTALI BOLLATO  *

SELECT IVA_CL

APPEND BLANK
RIGA_D = SPACE(50)

IF _Y_INTAZI
	RIGA_D = _WW_INTESTA
ENDIF

REPLACE RIGAT    WITH ""+RIGA_D     && SALTO PAGINA SPOOLER
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGA     WITH RIGA_D 
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

RIGA_D = SPACE(29)
*RIGA_D = RIGA_D+"REGISTRO CORRISPETTIVI RELATIVO AL MESE DI"+" " + MESE_C + ' ' + ANNO  
RIGA_D = RIGA_D+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"REGISTRO CORRISPETTIVI") + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO  && ERASMO - 04/08/2015

IF  OK_PAGI = 'S' 
	PAG_IN = PAG_IN + 1
	RIGA_D = RIGA_D+SPACE(20)+" Pag. " + STR(PAG_IN,6,0) 
ENDIF

REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(5)
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

APPEND BLANK
RIGA_D = SPACE(2)
*RIGA_D = RIGA_D+SPACE(42) + "RIEPILOGO FINALE BOLLATO IVA CORRISPETTIVI"
RIGA_D = RIGA_D+SPACE(42) + "RIEPILOGO FINALE "+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"BOLLATO IVA CORRISPETTIVI")  && ERASMO - 04/08/2015
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

PUB_RIGA = 10

RETURN 
    

*************************
PROCEDURE IVADET 
*************************
* DETTAGLIO BOLLATO IVA *

x_soci = "iva_codsoc = '" + PUB_CODSOC + "'"
x_anno = "iva_anno = '" + PUB_ANNO + "'"
x_mese = "iva_mese = '" + MESE + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese
CSQL   = "select * from u_iva_cl where " + x_cond + " order by iva_codsoc,iva_anno,iva_mese" 
IF !ExecCommand(CSQL,"u_iva_cl")
   RETURN (.f.)
ENDIF 
SELECT U_IVA_CL
GO TOP

CTRELAB=0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
   	  LOOP
   ENDIF	

   IF IVA_FATNOT <> "C"     && NON ELABORA I MOVIMENTI IVA NORMALI
      SKIP +1
   	  LOOP
   ENDIF

   SCATTER MEMVAR MEMO

   SELECT ANNI_TMP
   APPEND BLANK
   GATHER MEMVAR MEMO

   CTRELAB=CTRELAB+1

   =CONTATORE("Movimenti Iva",CTRELAB)

   SELECT U_IVA_CL
   SKIP +1

ENDDO

SELECT ANNI_TMP       
INDEX ON  IVA_DTCREA TAG NUM_FAT   && INDICE PER DATA REGISTRAZIONE
SET ORDER TO NUM_FAT
GO TOP

KEY_PRE   = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
  
   WDTCREA   = RIBALTA2(IVA_DTCREA)
   WNUMFAT   = IVA_NUMFAT
   WNUMDOC   = IVA_NUMFAT
   WDTFATT   = RIBALTA2(IVA_DTFATT)
   WCODCLI   = IVA_CODCLI
   WRAGSOC   = IVA_RAGSOC
   WIMPONI   = IVA_IMPONI
   WIMPOST   = IVA_IMPOST
   WCODIVA   = IVA_CODIVA
   WDESIVA   = IVA_DESIVA
   WTOTALE   = IVA_TOTALE
   WLOCALI   = IVA_LOCALI
   WCAP      = IVA_CAP
   WINDIRI   = IVA_INDIRI
   WFATNOT   = IVA_FATNOT
   *WPIVA     = IVA_PARIVA
   WPIVA     = SUBSTR(IVA_PARIVA,1,16)  && ERASMO - 18/11/2019
   WVALUTA   = IVA_VALUTA
   WCAMBIO   = IVA_CAMBIO
   KEY_ATT   = IVA_CHIAVE
   KEY_PRE   = KEY_ATT
  
   PUB_RIGA = PUB_RIGA + 1
   IF PUB_RIGA > SALTO_PAG
      DO IVATES             && TESTATA BOLLATO
   ENDIF

   
   IF OK_DEFI = 'S'
      IF PUB_AGGPRO
         NUMPRO_DA = NUMPRO_DA + 1
         WNUMFAT   = ALLTRIM(STR(NUMPRO_DA,6,0))
         REPLACE IVA_NUMNEW WITH NUMPRO_DA
      ENDIF
   ENDIF
   

   SELECT IVA_CL
   APPEND BLANK
   REPLACE DTCREA   WITH WDTCREA
   REPLACE NUMFAT   WITH WNUMFAT 
   REPLACE NUMDOC   WITH WNUMDOC 
   REPLACE DTFATT   WITH WDTFATT 
   REPLACE CODCLI   WITH WCODCLI
   REPLACE RAGSOC   WITH WRAGSOC
   REPLACE IMPONI   WITH WIMPONI
   REPLACE IMPOST   WITH WIMPOST
   REPLACE CODIVA   WITH WCODIVA
   REPLACE DESIVA   WITH WDESIVA
   REPLACE TOTALE   WITH WTOTALE
   REPLACE LOCALI   WITH WLOCALI
   REPLACE CAP      WITH WCAP
   REPLACE INDIRI   WITH WINDIRI
   REPLACE FATNOT   WITH WFATNOT
   REPLACE PIVA     WITH WPIVA

   IF WFATNOT = "N"
      WT="N"
   ELSE
      WT=" "  
   ENDIF
  
   ** DATI PER DETTAGLIO STAMPA 

   IF OK_FORMATO = 3
      RIGA_D = "|"+ SUBSTR(WNUMFAT,1,5)+" "+ WDTFATT  +"|"+ WT+" "+ SUBSTR(WNUMDOC,1,5) +" "+ WDTFATT +"    |"+SUBSTR(WRAGSOC,1,30) +" "+ "|"+ WCODIVA +" |"+ SUBSTR(TRANSFORM(WIMPONI,"99,999,999,999.99"),1,17) +"|"+ SUBSTR(TRANSFORM(WIMPOST,"999,999,999,999.99"),1,18)+"|  "+ SUBSTR(TRANSFORM(WTOTALE,"99,999,999,999.999"),1,18)+"|"
   ELSE
	  RIGA_D = "|"+ SUBSTR(WNUMFAT,1,5)+" "+ WDTFATT  +"|"+ WT+" "+ SUBSTR(WNUMDOC,1,5) +" "+ WDTFATT +"    |"+SUBSTR(WRAGSOC,1,35) +"  "+WPIVA+ "|"+ WCODIVA +" |"+SUBSTR(WVALUTA,1,3)+"  |"+STR(WCAMBIO,11,6)+"|"+ SUBSTR(TRANSFORM(WIMPONI,"99,999,999,999.999"),1,18) +"|   "+ SUBSTR(TRANSFORM(WIMPOST,"999,999,999,999.99"),1,18)+"|  "+ SUBSTR(TRANSFORM(WTOTALE,"999,999,999,999.99"),1,18)+" |"
   ENDIF

   REPLACE RIGA     WITH RIGA_D 
   REPLACE CHIAVE   WITH VAL(WNUMFAT)
   REPLACE CHIAVE_R WITH "DET"

   SELECT ANNI_TMP
   SKIP +1

ENDDO  

RETURN


*************************
  PROCEDURE IVATOTC 
*************************
* TOTALI CLIENTE        *
   
SELECT IVA_CL

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,80) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
PERI=MESE_C + " " +ANNO
*REPLACE RIGAT     WITH "         TOTALE IVA CORRISPETTIVI RELATIVO AL MESE DI " + PERI
REPLACE RIGAT     WITH "         TOTALE "+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"IVA CORRISPETTIVI") + " RELATIVO AL MESE DI " + PERI  && ERASMO - 04/08/2015
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

*** >>>>>  TOTALI IVA CORRISPETTIVI

IMPONIB_F = 0  && IVE FATTURE
IMPOSTA_F = 0
IMPONIB_N = 0  && IVE NOTE CREDITO
IMPOSTA_N = 0
IMPONIB_X = 0  && IVE INDEDUCIBILI
IMPOSTA_X = 0

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNO + "'"
x_mese = "ito_mese = '" + MESE + "'"
x_tipo = "ito_clifor = 'C'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + x_tipo
CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_clifor" 
IF !ExecCommand(CSQL,"u_iva_to")
   RETURN (.f.)
ENDIF 
SELECT U_IVA_TO
GO TOP

DO WHILE .T. 

   IF EOF()
      EXIT
   ENDIF

   IF ITO_ANNO <> ANNO
      SKIP + 1
      LOOP
   ENDIF

   IF ITO_MESE <> MESE
      SKIP + 1
      LOOP
   ENDIF

   IF ITO_CLIFOR <> 'C'
      SKIP + 1
      LOOP
   ENDIF
  
   IF ITO_FATNOT <> "C"     && NON ELABORA I MOVIMENTI IVA NORMALI
      SKIP +1
      LOOP
   ENDIF

   V_CODIVA = ITO_CODIVA 
   V_FATNOT = ITO_FATNOT 
   V_DESIVA = ITO_DESIVA
   V_IMPONI = ITO_IMPONI
   V_IMPOST = ITO_IMPOST
  
   ** IVE INDEDUCIBILI  
 
   v_seek	= 'IVA'+V_CODIVA
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      TIPOIVA   = SUBSTR(LIBERA,100,1)
   ELSE
      TIPOIVA   = " "
   ENDIF

   SELECT U_IVA_TO
 
   IF TIPOIVA <> "I"
      IF V_FATNOT = "C" 
         IMPONIB_F =  IMPONIB_F  + ITO_IMPONI  && IVE FATTURE
         IMPOSTA_F =  IMPOSTA_F  + ITO_IMPOST
      ENDIF 
   ENDIF  

   IF TIPOIVA <> "I"
      IF V_FATNOT = "N" 
         IMPONIB_N =  IMPONIB_N  + ITO_IMPONI  && IVE NOTE CREDITO
         IMPOSTA_N =  IMPOSTA_N  + ITO_IMPOST
      ENDIF 
   ENDIF 
  
   IF TIPOIVA = "I" 
      IMPONIB_X =  IMPONIB_X  + ITO_IMPONI  && IVE INDEDUCIBILI 
      IMPOSTA_X =  IMPOSTA_X  + ITO_IMPOST
   ENDIF 

   SELECT IVA_CL
   PUB_RIGA = PUB_RIGA + 1   
   IF PUB_RIGA > SALTO_PAG
      DO IVATESTO             && TESTATA BOLLATO
   ENDIF

   SELECT IVA_CL
   APPEND BLANK
   RIGA_D = V_CODIVA + "  " + V_FATNOT + " " + V_DESIVA 
   RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(V_IMPONI,"999,999,999,999.99"),1,18) 
   RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(V_IMPOST,"999,999,999,999.99"),1,18) 
   REPLACE RIGAT       WITH RIGA_D 
   REPLACE RIGA        WITH SPACE(50)
   REPLACE CHIAVE      WITH 777777
   REPLACE CHIAVE_R    WITH "TOC"
   REPLACE ITO_CODIVA  WITH V_CODIVA 
   REPLACE ITO_FATNOT  WITH V_FATNOT 
   REPLACE ITO_DESIVA  WITH V_DESIVA
   REPLACE ITO_IMPONI  WITH V_IMPONI
   REPLACE ITO_IMPOST  WITH V_IMPOST
       
   SELECT U_IVA_TO
   SKIP + 1

ENDDO

SELECT IVA_CL

* AZZERO L'IVA INDEDUC. PERCHE' NON DEVE ESSERE TOLTA DAL TOTALE MA SOLO NON FIGURARE

IMPONIB_X=0
IMPOSTA_X=0

** TOTALI IVA CORRISPETTIVI
** ========================

SELECT IVA_CL
PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
   PUB_RIGA = PUB_RIGA + 1
   APPEND BLANK
   RIGA_D=SPACE(50)
   REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,80) 
   REPLACE RIGA      WITH SPACE(50)
   REPLACE CHIAVE    WITH 777777
   REPLACE CHIAVE_R  WITH "TOC"
   PUB_RIGA = PUB_RIGA + 1
   APPEND BLANK 
   PERI=MESE_C + " " +ANNO
   *REPLACE RIGAT     WITH "         TOTALE IVA CORRISPETTIVI RELATIVO AL MESE DI " + PERI
   REPLACE RIGAT     WITH "         TOTALE "+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"IVA CORRISPETTIVI") + " RELATIVO AL MESE DI " + PERI  && ERASMO - 04/08/2015
   REPLACE RIGA      WITH SPACE(50)
   REPLACE CHIAVE    WITH 777777
   REPLACE CHIAVE_R  WITH "TOC"
ENDIF

APPEND BLANK
REPLACE IMPONI    WITH IMPONIB_F - IMPONIB_N - IMPONIB_X
REPLACE IMPOST    WITH IMPOSTA_F - IMPOSTA_N - IMPOSTA_X
REPLACE CHIAVE_R  WITH "TOC"
REPLACE CHIAVE    WITH 777777

V_IMPONI = IMPONIB_F - IMPONIB_N - IMPONIB_X
V_IMPOST = IMPOSTA_F - IMPOSTA_N - IMPOSTA_X
C_IMPONI = IMPONIB_F - IMPONIB_N - IMPONIB_X
C_IMPOST = IMPOSTA_F - IMPOSTA_N - IMPOSTA_X

RIGA_D = " >>>>> TOTALI GENERALI   " 
RIGA_D = RIGA_D + SPACE(12) + " | " + SUBSTR(TRANSFORM(V_IMPONI,"999,999,999,999.99"),1,18) 
RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(V_IMPOST,"999,999,999,999.99"),1,18) 
REPLACE RIGAT     WITH RIGA_D 
REPLACE RIGA      WITH SPACE(50)

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE CHIAVE_R  WITH "TOC"
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,80) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777

RETURN


*************************
PROCEDURE IVATOTT 
*************************
* TOTALI GENERALI       *
   
SELECT IVA_CL

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 999999
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 999999
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,80) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 999999
REPLACE CHIAVE_R  WITH "TOC"

** TOTALI GENERALI
** ===============

SELECT IVA_CL
PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
   PUB_RIGA = PUB_RIGA + 1
   APPEND BLANK
   RIGA_D=SPACE(50)
   REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,80) 
   REPLACE RIGA      WITH SPACE(50)
   REPLACE CHIAVE    WITH 999999
   REPLACE CHIAVE_R  WITH "TOC"
   PUB_RIGA = PUB_RIGA + 1
   APPEND BLANK 
   PERI=MESE_C + " " +ANNO
   REPLACE RIGAT     WITH "         RIEPILOGO IVA RELATIVO AL MESE DI " + PERI
   REPLACE RIGA      WITH SPACE(50)
   REPLACE CHIAVE    WITH 999999
   REPLACE CHIAVE_R  WITH "TOC"
ENDIF

*****************************  TOTALE IVA CORRISPETTIVI *******************

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,80) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 999999
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
APPEND BLANK 
PERI=MESE_C + " " +ANNO
REPLACE RIGAT     WITH "         RIEPILOGO IVA RELATIVO AL MESE DI " + PERI
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 999999
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE CHIAVE    WITH 999999

RIGA_D = " >>>>> IVA CORRISPETTIVI       " 
RIGA_D = RIGA_D + SPACE(12) + "   " + SPACE(12) 
RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(C_IMPOST,"999,999,999,999.99"),1,18) 
REPLACE RIGAT     WITH RIGA_D 
REPLACE RIGA      WITH SPACE(50)

*****************************  TOTALE DI TUTTI I TOTALI *****************

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE CHIAVE_R  WITH "TOC"
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,80) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 999999

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF
        
APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE CHIAVE    WITH 999999

T_IMPOST = C_IMPOST - F_IMPOST - E_IMPOST

IF T_IMPOST > 0
   PAGO_S_N = "DEBITO"
ELSE
   PAGO_S_N = "CREDITO"
ENDIF

RIGA_D = " >>>>> TOTALI GENERALI   " 
RIGA_D = RIGA_D + SPACE(12) + "   " + SPACE(12) 
RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(T_IMPOST,"999,999,999,999.99"),1,18)  + "    " + PAGO_S_N   
REPLACE RIGAT     WITH RIGA_D 
REPLACE RIGA      WITH SPACE(50)

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE CHIAVE_R  WITH "TOC"
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,80) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 999999

*****************************  FINE RIGHE TOTALI ***********************

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 999999

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 999999

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 999999

SELECT IVA_CL
APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGAT    WITH ""+RIGA_D     && SALTO PAGINA SPOOLER FINALE
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

RETURN


*************************
PROCEDURE IVAERA 
*************************
*RECUPERO IVA PRECEDENTE*

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '0001'"
x_mese = "ito_mese = '01'"
x_civa = "ito_codiva = 'STA'"
x_tipo = "ito_clifor = ' '"
x_fatt = "ito_fatnot = 'S'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese + " and " + ;
         x_civa  + " and " + x_tipo + " and " + x_fatt
CSQL   = "select * from u_iva_to where " + x_cond + " order by ito_codsoc,ito_anno,ito_mese,ito_codiva,ito_clifor,ito_fatnot" 
IF !ExecCommand(CSQL,"u_iva_to")
   RETURN (.f.)
ENDIF 
SELECT U_IVA_TO
GO TOP
IF !EOF()
   E_IMPOST  = ITO_IMPOST   && IMPOSTA DA RECUPERARE
ELSE
   E_IMPOST  = 0 
ENDIF 
SELECT IVA_CL

RETURN


*************************
  PROCEDURE OK_SPOOL 
*************************

SELECT IVA_CL
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
	  LOOP 
   ENDIF

   IF ALLTRIM(CHIAVE_R) = "TOC"
      RIGA_STA = RIGAT
   ELSE
      RIGA_STA = RIGA
   ENDIF
      
   SELECT IVA_STA
   APPEND BLANK
   REPLACE RIGAT WITH RIGA_STA

   SELECT IVA_CL
   SKIP +1

ENDDO

SELECT IVA_STA 
GO TOP

IF OK_FORMATO = 3
   DO CREA_SPOOL WITH "IVA_STA","IVA CORRISPETTIVI (A4): "+MESE+"/"+PUB_ANNO
ELSE

   IF OK_FORMATO = 2 OR OK_FORMATO = 1
   
	  DO CREA_SPOOL WITH "IVA_STA","IVA CORRISPETTIVI (A3): "+MESE+"/"+PUB_ANNO
   ENDIF

ENDIF

RELEASE WINDOW DISPLAY

RETURN



*************************
PROCEDURE OK_PROTO
*************************
IF OK_DEFI <> 'S' 
   RETURN
ENDIF

IF PUB_AGGPRO
ELSE
   RETURN
ENDIF

*=> Aggiornamento numeratore progressivo su u_azi_an
cSql = "select * from u_azi_an"
IF !ExecRW(cSql,"u_azi_an","R")
   return(.f.)
ENDIF
SELECT U_AZI_AN
GO TOP
IF EOF()
ELSE
   REPLACE AZI_PROTCO WITH NUMPRO_DA
ENDIF
IF !ExecRW(cSql,"u_azi_an","W")
   return(.f.)
ENDIF

*=> Loop di aggiornamento numero protocollo solo se cambiato sul bollato iva, movimenti contabili e indice
SELECT ANNI_TMP       
INDEX ON IVF_CHIAVE TAG NUM_FAT   && INDICE PER NUMERO DI PROTOCOLLO
SET ORDER TO NUM_FAT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(IVA_NUMFAT) = ALLTRIM(STR(IVA_NUMNEW,6,0))
   ELSE
      __NUMFAT = IVA_NUMFAT
      __DATFAT = IVA_DTFATT
      __NUMOLD = ALLTRIM(STR(IVA_NUMFAT,6,0))
      __NUMNEW = IVA_NUMNEW

      *=> Aggiornamento sul bollato iva corrispettivi
      x_uniq = "id_unique = '" + ID_UNIQUE + "'"
      x_cond = x_uniq
      CSQL   = "select * from u_iva_cl where " + x_cond
      IF !ExecRW(CSQL,"u_iva_cl","R")
         RETURN (.f.)
      ENDIF  
      SELECT U_IVA_CL
      GO TOP
      IF EOF()
      ELSE
         REPLACE IVA_NUMFAT WITH ALLTRIM(STR(__NUMNEW,6,0))
      ENDIF
      IF !ExecRW(CSQL,"u_iva_cl","W")
         RETURN (.f.)
      ENDIF  

      *=> Aggiornamento sui movimenti contabili
      x_ndoc = "mov_ndoc = '" + ALLTRIM(__NUMFAT) + "'"
      x_ddoc = "mov_DTdoc = '" + ALLTRIM(__DATFAT) + "'"
      x_npro = "mov_nprot = '" + ALLTRIM(__NUMOLD) + "'"
      x_cond = x_ndoc + " and " + x_ddoc + " and " + x_npro
      CSQL   = "select * from mov_cont where " + x_cond
      IF !ExecRW(CSQL,"mov_cont","R")
         RETURN (.f.)
      ENDIF  
      SELECT MOV_CONT
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         REPLACE MOV_NPROT WITH ALLTRIM(STR(__NUMNEW,6,0))
         SKIP +1
      ENDDO
      IF !ExecRW(CSQL,"mov_cont","W")
         RETURN (.f.)
      ENDIF  

      *=> Aggiornamento su indice
      x_ndoc = "mov_ndoc = '" + ALLTRIM(__NUMFAT) + "'"
      x_ddoc = "mov_DTdoc = '" + ALLTRIM(__DATFAT) + "'"
      x_npro = "mov_nprot = '" + ALLTRIM(__NUMOLD) + "'" 
      x_cond = x_ndoc + " and " + x_ddoc + " and " + x_npro
      CSQL   = "select * from indice where " + x_cond
      IF !ExecRW(CSQL,"indice","R")
         RETURN (.f.)
      ENDIF  
      SELECT INDICE
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         REPLACE MOV_NPROT WITH ALLTRIM(STR(__NUMNEW,6,0))
         SKIP +1
      ENDDO
      IF !ExecRW(CSQL,"indice","W")
         RETURN (.f.)
      ENDIF  

   ENDIF
   
   SELECT ANNI_TMP       
   SKIP +1

ENDDO

RETURN


RETURN
