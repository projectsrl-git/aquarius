*************************************************************************************
*					STAMPA BOLLATO IVA FORNITORI ABITUALI CEE						*
*************************************************************************************
PARAMETERS _par_Caption,_par_Flag_E_R_A

SET DECIMAL TO 3

IF OK_DEFI = 'S'
   IF PUB_AGGPRO
      NUMPRO_DA = NUMPRO_DA - 1
   ENDIF
ENDIF

RELEASE __DEDUCIBILE
PUBLIC __DEDUCIBILE
__DEDUCIBILE = .F.



_WW_RAGSOC = ""
_WW_INDIRI = ""
_WW_LOCALI = ""
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
ENDIF
_WW_INTESTA = _WW_RAGSOC + _WW_INDIRI + _WW_LOCALI

*!*	**=> ERASMO - INIZIO 04/08/2015
*!*	_WW_TITOLO = ""
*!*	_WW_CODIBI = "IVAFOCEE"
*!*	x_codi = "CODICE = 'IBI" + _WW_CODIBI + "'"
*!*	x_cond = x_codi
*!*	Csql   = "select LIBERA from para where " + x_cond
*!*	IF !ExecCommand(cSql,"TMP_PARA")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT TMP_PARA
*!*	GO TOP
*!*	IF !EOF()
*!*		IF !EMPTY(LIBERA)
*!*			_WW_TITOLO = ALLTRIM(LIBERA)
*!*		ENDIF
*!*	ENDIF
*!*	**=> ERASMO - FINE 04/08/2015
_WW_TITOLO = UPPER(ALLTRIM(_par_Caption))

PUBLIC NEW_PLAF,OLD_PLAF,OK_PLAF
NEW_PLAF = 0
OLD_PLAF = 0
OK_PLAF  = .F.
ANNO     = PUB_ANNO
ANNOC    = PUB_ANNO

IF EMPTY(ANNO) .OR. EMPTY(MESE)
   RETURN
ENDIF

PUBLIC SALTO_PAG
PUBLIC PUB_CAROR
PUBLIC PUB_PAGI
PUBLIC PUB_RIGA
PUBLIC KEY_ATT,KEY_PREC,WCHIAVE,WCHIAVER,PAG_IN,ANNO_ATT,ANNO_PRE

PAG_IN    = 0
PUB_CAROR = "="
SALTO_PAG = OK_NUMRIG && FA SALTO PAGINA
ANNO_ATT  = SPACE(04)
ANNO_PRE  = SPACE(04)
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

IF !ExecCommand("select * from u_ivf_cl where 0=1","u_ivf_cl")
  return(.f.)
ENDIF
SELECT U_IVF_CL
HH=AFIELDS(TRANSIVA)
CREATE CURSOR ANNI_TMP FROM ARRAY TRANSIVA

CREATE CURSOR IVA_STA;
 (RIGAT c(240))

CREATE CURSOR IVA_FO;
 (DTCREA C(10),NUMFAT C(6),DTFATT C(10),CODCLI C(13),RAGSOC C(40), PIVA C(11),;
 IMPONI N(17,3),IMPOST N(17,3),CODIVA C(3),DESIVA C(21),TOTALE N(17,3),;
 LOCALI C(20),CAP C(6),INDIRI C(10),FATNOT C(1),CHIAVE N(6),ito_codiva c(3),ito_desiva c(30),ito_imponi n(17,3),ito_impost n(17,3),ito_dtcrea c(10),ito_fatnot c(1),ito_clifor c(1),chiave_r c(3),RIGA c(240),RIGAT c(240),PAGINA N(10))

DO IVATEST              && TESTATA BOLLATO SENZA SALTO PAGINA

DO IVADET               && DETTAGLIO BOLLATO

IF OK_RIEIVA			&& RAGGRUPPA IL RIEPILOGO IVA TOGLIENDO LE NOTE CREDITO	
   DO IVATORF           && TOTALE IVA FORNITORI        777777
ELSE
   DO IVATOTF           && TOTALE IVA FORNITORI        777777
ENDIF

IF AGG_PLAF
   DO IVAPLAF           && GESTIONE PLAFOND            777777
   DO AGGPLAF			&& AGGIORNA IL PLAFOND
ENDIF

ANNO  = SPACE(4)
ANNO1 = SPACE(4)
NDOC  = SPACE(6)

DO OK_SPOOL             && CREA LO SPOOL DI STAMPA


DO OK_PROTO              && AGGIORNA NUMERO DI PROTOCOLLO


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
* TESTATA  BOLLATO IVA  *   SENZA SALTO PAGINA

IF OK_FORMATO = 3
   DO IVATEST4
   RETURN
ENDIF

SELECT IVA_FO
APPEND BLANK

APPEND BLANK
RIGA_D = SPACE(50)
*REPLACE RIGA     WITH RIGA_D 
REPLACE RIGA     WITH IIF(_Y_INTAZI,_WW_INTESTA,RIGA_D)
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

RIGA_D = SPACE(49)
RIGA_D = RIGA_D+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"REGISTRO DELLE FATTURE FORNITORI ABITUALI CEE") + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO

IF  OK_PAGI = 'S' 
	PAG_IN = PAG_IN + 1
	RIGA_D = RIGA_D+SPACE(40)+" Pag. " + STR(PAG_IN,6,0) 
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
RIGA_D = "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "|  REGISTRAZIONE |              DOCUMENTO             |           F O R N I T O R I                         |COD.|   DESCRIZIONE     | COD.|           |                  |                     |                    |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "| PROT.     DATA |COD.        NUM.            DATA    |   RAGIONE SOCIALE/DESCRIZIONE        P.IVA/COD.FIS. |IVA |      IVA          | VAL.|  CAMBIO   |     IMPONIBILE   |           IMPOSTA   |        TOT.DOCUM.  |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
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

SELECT IVA_FO
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

RIGA_D = SPACE(49)
RIGA_D = RIGA_D+UPPER(_WW_TITOLO) + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO

IF  OK_PAGI = 'S' 
	PAG_IN = PAG_IN + 1
	RIGA_D = RIGA_D+SPACE(40)+" Pag. " + STR(PAG_IN,6,0) 
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
RIGA_D = "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "|  REGISTRAZIONE |              DOCUMENTO             |           F O R N I T O R I                         |COD.|   DESCRIZIONE     | COD.|           |                  |                     |                    |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "| PROT.     DATA |COD.        NUM.            DATA    |   RAGIONE SOCIALE/DESCRIZIONE        P.IVA/COD.FIS. |IVA |      IVA          | VAL.|  CAMBIO   |     IMPONIBILE   |           IMPOSTA   |        TOT.DOCUM.  |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
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

SELECT IVA_FO

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
RIGA_D = RIGA_D+UPPER(_WW_TITOLO) + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO

IF  OK_PAGI = 'S' 
	PAG_IN = PAG_IN + 1
	RIGA_D = RIGA_D+SPACE(40)+" Pag. " + STR(PAG_IN,6,0) 
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
RIGA_D = RIGA_D+SPACE(42) + "RIEPILOGO FINALE BOLLATO IVA FORNITORI"
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

PUB_RIGA = 10

RETURN 


*************************
PROCEDURE IVATEST4
*************************
* TESTATA  BOLLATO IVA  *   SENZA SALTO PAGINA

SELECT IVA_FO
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
RIGA_D = RIGA_D+UPPER(_WW_TITOLO) + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO

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
RIGA_D = "------------------------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "|  REGISTRAZIONE |              DOCUMENTO             |     F O R N I T O R I         |COD.|                 |                  |                    |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "| PROT.     DATA |COD.        NUM.            DATA    | RAGIONE SOCIALE/DESCRIZIONE   |IVA |    IMPONIBILE   |        IMPOSTA   |        TOT.DOCUM.  |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "------------------------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

PUB_RIGA = 10

RETURN 
    

*************************
PROCEDURE IVATES4 
*************************
* TESTATA  BOLLATO IVA  *

SELECT IVA_FO
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
RIGA_D = RIGA_D+UPPER(_WW_TITOLO) + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO

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
RIGA_D = "------------------------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "|  REGISTRAZIONE |              DOCUMENTO             |     F O R N I T O R I         |COD.|                 |                  |                    |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "| PROT.     DATA |COD.        NUM.            DATA    | RAGIONE SOCIALE/DESCRIZIONE   |IVA |    IMPONIBILE   |        IMPOSTA   |        TOT.DOCUM.  |"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

APPEND BLANK
RIGA_D = "------------------------------------------------------------------------------------------------------------------------------------------------------"
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "DET"

PUB_RIGA = 10

RETURN 
    

*************************
PROCEDURE IVATESO4 
*************************
* TESTATA  TOTALI BOLLATO  *

SELECT IVA_FO

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
RIGA_D = RIGA_D+UPPER(_WW_TITOLO) + " RELATIVO AL MESE DI " + MESE_C + ' ' + ANNO

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
RIGA_D = RIGA_D+SPACE(42) + "RIEPILOGO FINALE BOLLATO IVA FORNITORI"
REPLACE RIGAT    WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

PUB_RIGA = 10

RETURN


*************************
PROCEDURE IVADET 
*************************
* DETTAGLIO BOLLATO IVA *

x_soci = "ivf_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ivf_anno = '" + PUB_ANNO + "'"
x_mese = "ivf_mese = '" + MESE + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese
CSQL   = "select * from u_ivf_cl where " + x_cond + " order by ivf_codsoc,ivf_anno,ivf_mese" 
IF !ExecCommand(CSQL,"u_ivf_cl")
   RETURN (.f.)
ENDIF 
SELECT U_IVF_CL
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

   SCATTER MEMVAR MEMO

   CTRELAB=CTRELAB+1
   =CONTATORE("Movimenti Iva",CTRELAB)

   v_seek	= 'TOP'+ALLTRIM(M.IVF_TOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      CEE   = SUBSTR(LIBERA,23,1)
   ELSE
      CEE    = SPACE(1)
   ENDIF

   IF CEE = _par_Flag_E_R_A  && TRATTA SOLO IL TIPO TOP SPECIFICATO
   ELSE
      SELECT U_IVF_CL
      SKIP +1
      LOOP
   ENDIF  

   SELECT ANNI_TMP
   APPEND BLANK
   GATHER MEMVAR MEMO

   SELECT U_IVF_CL
   SKIP +1

ENDDO
  
SELECT ANNI_TMP       
IF OK_DEFI = 'S'
   IF PUB_AGGPRO
      INDEX ON IVF_DTCREA + IVF_DTFATT + IVF_CODCLI + IVF_NUMFAT TAG NUM_FAT   && INDICE PER NUMERO DI PROTOCOLLO
   ELSE
      INDEX ON IVF_CHIAVE TAG NUM_FAT   && INDICE PER NUMERO DI PROTOCOLLO
   ENDIF
ELSE
   INDEX ON IVF_CHIAVE TAG NUM_FAT   && INDICE PER NUMERO DI PROTOCOLLO
ENDIF
SET ORDER TO NUM_FAT
GO TOP

KEY_PRE   = SPACE(10) + SPACE(10) + SPACE(10) + SPACE(10)


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
    
  
  
   WTOP		 = IVF_TOP 
   WT		 = IVF_TOP
   WDTCREA   = RIBALTA2(IVF_DTCREA)
   WNUMFAT   = IVF_NUMFAT
   WDTFATT   = RIBALTA2(IVF_DTFATT)
   WCODCLI   = IVF_CODCLI
   WRAGSOC   = IVF_RAGSOC
   WIMPONI   = IVF_IMPONI
   WIMPOST   = IVF_IMPOST
   WCODIVA   = IVF_CODIVA
   WDESIVA   = IVF_DESIVA
   WTOTALE   = IVF_IMPONI + IVF_IMPOST  
   WLOCALI   = IVF_LOCALI
   WCAP      = IVF_CAP
   WINDIRI   = IVF_INDIRI
   WFATNOT   = IVF_FATNOT
   WCHIAVE   = IVF_CHIAVE
   *WPIVA     = IVF_PARIVA  
   WPIVA     = SUBSTR(IVF_PARIVA,1,16)  && ERASMO - 18/11/2019
   WBDOG  	 = IVF_BDOG            && BOLLE DOGANALI
   WVALUTA   = IVF_VALUTA
   WCAMBIO   = IVF_CAMBIO
   KEY_ATT   = STR(WCHIAVE)
   ANNO_ATT  = IVF_ANNO

   KEY_ATT   = IVF_DTCREA + IVF_DTFATT + IVF_CODCLI + IVF_NUMFAT

   
   IF OK_DEFI = 'S'
      IF PUB_AGGPRO
         IF KEY_ATT <> KEY_PRE         
            NUMPRO_DA = NUMPRO_DA + 1
            WCHIAVE   = NUMPRO_DA
         ELSE
            WCHIAVE   = NUMPRO_DA
         ENDIF
         REPLACE IVF_NUMNEW WITH WCHIAVE
      ENDIF
   ENDIF
 
*!*	 IF ALLTRIM(IVF_CHIAVE) = '22' OR '26'
*!*	 SET STEP ON ON
*!*	 ENDIF
*!*	 
   
	**=> ERASMO - INIZIO 22/11/2018
	IF PUB_PRDISP
		Csql = "SELECT TOP 1 MOV_DESMOV FROM MOV_CONT WHERE MOV_NUMPRO = '"+MOV_NUMPRO+"' ORDER BY MOV_SEQUEN"
		IF !ExecCommand(cSql,"_TEMP")
			return(.f.)
		ENDIF
		SELECT _TEMP
		GO TOP
		IF !EOF()

		    **==> SERGIO 16/07/2019 INIZIO
			**IF SUBSTR(MOV_DESMOV,1,12) = 'Autofattura ' AND OCCURS(' FT ',UPPER(MOV_DESMOV)) > 0									

			_ULT_DES_ATTRIBUITA = .F.
			SAVE_WRAGSOC = WRAGSOC
			

            IF  OCCURS(' FT ',UPPER(MOV_DESMOV)) > 0
 				IF UPPER(SUBSTR(MOV_DESMOV,1,12)) = 'AUTOFATTURA ' 							
					WRAGSOC = PADR(ALLTRIM(SAVE_WRAGSOC)+"-"+ALLTRIM(SUBSTR(MOV_DESMOV,13,AT(' FT ',UPPER(MOV_DESMOV),1)-13)),40,' ')
					_ULT_DES_ATTRIBUITA = .T.
				ENDIF
			ENDIF
  
            IF  OCCURS(' FAT ',UPPER(MOV_DESMOV)) > 0
				IF UPPER(SUBSTR(MOV_DESMOV,1,12)) = 'AUTOFATTURA '  							
					WRAGSOC = PADR(ALLTRIM(SAVE_WRAGSOC)+"-"+ALLTRIM(SUBSTR(MOV_DESMOV,13,AT(' FAT ',UPPER(MOV_DESMOV),1)-13)),40,' ')
					_ULT_DES_ATTRIBUITA = .T.
				ENDIF
			ENDIF


			IF !_ULT_DES_ATTRIBUITA 

				IF UPPER(SUBSTR(MOV_DESMOV,1,2)) = 'AU' 								 
					_ULT_DESCRIZ = ALLTRIM(SUBSTR(MOV_DESMOV,13,100))	
					_WRAGSOC     = ALLTRIM(SAVE_WRAGSOC)+"-"+_ULT_DESCRIZ
					WRAGSOC = SUBSTR(_WRAGSOC,1,40)
					
				ENDIF
			ENDIF
		    **==> SERGIO 16/07/2019 FINE

		ENDIF
		
		
		SELECT ANNI_TMP
	ENDIF
	
	**=> ERASMO - FINE 22/11/2018

   ** GESTIONE TOTALE FATTURA
   IF KEY_ATT <> KEY_PRE         && SBIANCA SOLO SE HO PIU' RECORD=XFATT
      IF EMPTY(KEY_PRE)
	     KEY_PRE   = KEY_ATT	&& PRIMA VOLTA
		 ANNO_PRE  = ANNO_ATT
      ELSE
    	 DO TOTFAT
   	     KEY_PRE   = KEY_ATT		&& ROTTURA EFFETTIVA
		 ANNO_PRE  = ANNO_ATT
	  ENDIF
   ENDIF 

   PUB_RIGA = PUB_RIGA + 1
   IF PUB_RIGA > SALTO_PAG
      DO IVATES             && TESTATA BOLLATO
   ENDIF

   SELECT IVA_FO
   APPEND BLANK
   REPLACE DTCREA   WITH WDTCREA
   REPLACE NUMFAT   WITH WNUMFAT 
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

   ** DATI PER DETTAGLIO STAMPA 

   v_seek	= 'TOP'+ALLTRIM(WT)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      NOTAC	=SUBSTR(LIBERA,11,1)
   ELSE
      NOTAC	=" "
   ENDIF
   SELECT IVA_FO

   IF NOTAC = "S"
      WTOTALE = WTOTALE * -1
      WIMPOST = WIMPOST * -1   
	  WIMPONI = WIMPONI * -1
   ENDIF

   IF OK_FORMATO = 3
	  IF WCODIVA = "BD2"     && SE BOLLA DOGANALE 
  	     RIGA_D = "|"+ STR(WCHIAVE,5)+" "+ WDTCREA  +"|"+ WT+"  "+ WNUMFAT +" "+ WDTFATT +"|"+SUBSTR(WRAGSOC,1,30) +" "+ "|"+ WCODIVA +"|"+ SUBSTR(TRANSFORM(WIMPONI,"999,999,999,999.99"),1,18) +"|   "+ SUBSTR(TRANSFORM(WIMPOST,"9999,999,999.99"),1,15)+"|  "+ SUBSTR(TRANSFORM(WIMPOST,"999,999,999,999.99"),1,18)+"|"
	  ELSE
	     RIGA_D = "|"+ STR(WCHIAVE,5)+" "+ WDTCREA  +"|"+ WT+"  "+ WNUMFAT +" " + WDTFATT +"|"+SUBSTR(WRAGSOC,1,30) +" "+"|"+ WCODIVA +"|"+ SUBSTR(TRANSFORM(WIMPONI,"999,999,999,999.99"),1,18) +"|   "+ SUBSTR(TRANSFORM(WIMPOST,"9999,999,999.99"),1,15)+"|  "+ SUBSTR(TRANSFORM(WTOTALE,"999,999,999,999.99"),1,18)+"|"
	  ENDIF	
   ELSE
	  IF WCODIVA = "BD2"     && SE BOLLA DOGANALE 
  	     RIGA_D = "|"+ STR(WCHIAVE,5)+" "+ WDTCREA  +"|"+ WT+"  "+ WNUMFAT +" " + WDTFATT +"|"+SUBSTR(WRAGSOC,1,35) +"  "+WPIVA+ "|"+ WCODIVA +" |"+SUBSTR(WDESIVA,1,18) +" |"+SUBSTR(WVALUTA,1,3)+"  |"+STR(WCAMBIO,11,6)+"|"+ SUBSTR(TRANSFORM(WIMPONI,"999,999,999,999.99"),1,18) +"|   "+ SUBSTR(TRANSFORM(WIMPOST,"999,999,999,999.99"),1,18)+"|  "+ SUBSTR(TRANSFORM(WIMPOST,"999,999,999,999.99"),1,18)+"|"
	  ELSE
	 	 RIGA_D = "|"+ STR(WCHIAVE,5)+" "+ WDTCREA  +"|"+ WT+"  "+ WNUMFAT +" " + WDTFATT +"|"+SUBSTR(WRAGSOC,1,35) +"  "+WPIVA+ "|"+ WCODIVA +" |"+SUBSTR(WDESIVA,1,18) +" |"+SUBSTR(WVALUTA,1,3)+"  |"+STR(WCAMBIO,11,6)+"|"+ SUBSTR(TRANSFORM(WIMPONI,"999,999,999,999.99"),1,18) +"|   "+ SUBSTR(TRANSFORM(WIMPOST,"999,999,999,999.99"),1,18)+"|  "+ SUBSTR(TRANSFORM(WTOTALE,"999,999,999,999.99"),1,18)+"|"
	  ENDIF	
   ENDIF

   REPLACE RIGA     WITH RIGA_D 
   REPLACE CHIAVE   WITH WCHIAVE
   REPLACE CHIAVE_R WITH "DET"

   SELECT ANNI_TMP
   SKIP +1

ENDDO  

DO TOTFAT    && TOTALE DELL'ULTIMA FATTURA

RETURN


******************
PROCEDURE GETPIVA
******************
PARA XX_COD

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + ALLTRIM(SUBSTR(XX_COD,PUB_SOTTOG,9)) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"CUR_FORNITORI")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORI
GO TOP   
IF !EOF()
   OUT=FOR_PARIVA+SPACE(05)
   IF EMPTY(FOR_PARIVA) 
      OUT=FOR_CODFIS
   ENDIF 
ELSE
   OUT=SPACE(16)
ENDIF

RETURN(OUT)


*************************
PROCEDURE TOTFAT 
*************************
* TOTALI FATTURA       *

IF !OK_TOTDOC 
   RETURN
ENDIF

* CALCOLA TOTALE DOCUMENTO 
  
SS=STR(SELECT())
    
SELECT *;
  FROM ANNI_TMP;
  WHERE IVF_CHIAVE==VAL(KEY_PRE) .AND. IVF_ANNO = ANNO_PRE INTO CURSOR TMP1

SELECT TMP1
GO TOP
SUM IVF_TOTALE  TO _TOTALE

SELECT &SS 
    
PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATES             && TESTATA BOLLATO
ENDIF

SELECT IVA_FO
APPEND BLANK
REPLACE DTCREA   WITH WDTCREA
REPLACE NUMFAT   WITH WNUMFAT 
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

** DATI PER DETTAGLIO STAMPA 

IF OK_FORMATO = 3
   RIGA_D = "|     "+"           |  "+ "    "+ "                |"+SPACE(30) +" "+"|"+"   |"+ "                  |   "+ "===============|  "+ SUBSTR(TRANSFORM(_TOTALE,"999,999,999,999.99"),1,18)+"|"
ENDIF
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH VAL(KEY_PRE)
REPLACE CHIAVE_R WITH "DET"

RETURN


*************************
PROCEDURE IVATOTF 
*************************
* TOTALI FORNITORE      *
   
SELECT IVA_FO

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
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,124) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
PERI=MESE_C + " " +ANNO
REPLACE RIGAT     WITH "                         TOTALE "+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"IVA FORNITORI") + " RELATIVO AL MESE DI " + PERI
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,124) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
PERI=MESE_C + " " +ANNO
REPLACE RIGAT     WITH "COD  DESCRIZIONE IVA                         IMPONIBILE           IMPOSTA             IMPONIBILE              IMPOSTA     "
REPLACE RIGA      WITH SPACE(50)  
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
PERI=MESE_C + " " +ANNO
REPLACE RIGAT     WITH "IVA                                          DEDUCIBILE          DEDUCIBILE          INDEDUCIBILE         NON DETRAIBILE "
REPLACE RIGA      WITH SPACE(50) 
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

*** >>>>>  TOTALI IVA FORNITORI

IMPONIB_F = 0  && IVE FATTURE
IMPOSTA_F = 0
IMPONIB_N = 0  && IVE NOTE CREDITO
IMPOSTA_N = 0
IMPONIB_X = 0  && IVE INDEDUCIBILI
IMPOSTA_X = 0

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNO + "'"
x_mese = "ito_mese = '" + MESE + "'"
*x_tipo = "ito_clifor = 'E'"
x_tipo = "ito_clifor = '" + _par_Flag_E_R_A + "'"
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
      V_DTIPOMOV = DTIPOMOV  	&& ERASMO - 21/10/2022
   ELSE
      TIPOIVA   = " "
      V_DTIPOMOV = ""  			&& ERASMO - 21/10/2022
   ENDIF
   
   SELECT U_IVA_TO

   IND_100 = ' '
   IF ITO_IND100 = 'S'  && IVA INDEDUCIBILE AL 100%
      IND_100   = "S"
   ENDIF

   __DEDUCIBILE = ITO_DEDUCIBILE	&& IMPOSTA INDEDUCIBILE = .F. / IMPOSTA DEDUCIBILE = .T.

   **IF IND_100 = 'S'	.OR. "*" $ V_CODIVA	 && IMPOSTE INDEDUCIBILI  
   IF IND_100 = 'S'	.OR. __DEDUCIBILE	 && IMPOSTE INDEDUCIBILI  
      *IF IND_100 = 'S'
      IF IND_100 = 'S' AND V_DTIPOMOV <> 'S'  && ERASMO - 21/10/2022
	     IF V_FATNOT = "F" 
	 	    IMPONIB_X =  IMPONIB_X  + ITO_IMPONI + ITO_IMPOST  && IVE INDEDUCIBILI AL 100%
			IMPOSTA_X =  IMPOSTA_X  + ITO_IMPOST
	 		V_IMPONI  =  ITO_IMPONI + ITO_IMPOST 				&& IVE INDEDUCIBILI AL 100%
		 ELSE
			IMPONIB_X =  IMPONIB_X  - ITO_IMPONI - ITO_IMPOST  && PER NOTE C. TOGLIE
			IMPOSTA_X =  IMPOSTA_X  - ITO_IMPOST
	 		V_IMPONI  =  ITO_IMPONI + ITO_IMPOST 				&& IVE INDEDUCIBILI AL 100%
		 ENDIF
      ELSE
         IF V_FATNOT = "F" 
		    IMPONIB_X =  IMPONIB_X  + ITO_IMPONI  				&& IVE INDEDUCIBILI AL 100%
		    IMPOSTA_X =  IMPOSTA_X  + ITO_IMPOST
		 ELSE
		    IMPONIB_X =  IMPONIB_X  - ITO_IMPONI  				&& IVE INDEDUCIBILI AL 100%
		    IMPOSTA_X =  IMPOSTA_X  - ITO_IMPOST
		 ENDIF
 	  ENDIF	 
   ELSE 
      IF V_FATNOT = "F" 
         IMPONIB_F =  IMPONIB_F  + ITO_IMPONI  && IVE FATTURE
         IMPOSTA_F =  IMPOSTA_F  + ITO_IMPOST
      ENDIF 
      IF V_FATNOT = "N" 
         IMPONIB_F =  IMPONIB_F  - ITO_IMPONI  && IVE NOTE CREDITO
         IMPOSTA_F =  IMPOSTA_F  - ITO_IMPOST
      ENDIF 
   ENDIF

   SELECT IVA_FO
   PUB_RIGA = PUB_RIGA + 1   
   IF PUB_RIGA > SALTO_PAG
      DO IVATESTO             && TESTATA BOLLATO
   ENDIF

   SELECT IVA_FO
   APPEND BLANK

   *====>>> RIGA DI DETTAGLIO
  
   IF ALLTRIM(V_FATNOT) = "N"
	  S_IMPONI = V_IMPONI * -1
	  S_IMPOST = V_IMPOST * -1
   ELSE
	  S_IMPONI = V_IMPONI 
	  S_IMPOST = V_IMPOST 
   ENDIF

   **IF IND_100 = 'S'	.OR. "*" $ V_CODIVA	 && IMPOSTE INDEDUCIBILI  
   IF IND_100 = 'S'	.OR. __DEDUCIBILE && IMPOSTE INDEDUCIBILI  
	  RIGA_D = V_CODIVA + "  " + V_FATNOT + " " + V_DESIVA +  " | " +SPACE(18)+ " | " +SPACE(18)
	  RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(S_IMPONI,"999,999,999,999.99"),1,18) 
	  RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(S_IMPOST,"999,999,999,999.99"),1,18)
   ELSE
	  RIGA_D = V_CODIVA + "  " + V_FATNOT + " " + V_DESIVA 
	  RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(S_IMPONI,"999,999,999,999.99"),1,18) 
	  RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(S_IMPOST,"999,999,999,999.99"),1,18)+  " | " +SPACE(18)+ " | "
   ENDIF	

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

SELECT IVA_FO


** TOTALI IVA FORNITORI
** ==================

SELECT IVA_FO
PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
   PUB_RIGA = PUB_RIGA + 1
   APPEND BLANK
   RIGA_D=SPACE(50)
   REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,124) 
   REPLACE RIGA      WITH SPACE(50)
   REPLACE CHIAVE    WITH 777777
   REPLACE CHIAVE_R  WITH "TOC"
   PUB_RIGA = PUB_RIGA + 1
   APPEND BLANK 
   PERI=MESE_C + " " +ANNO
   REPLACE RIGAT     WITH "         TOTALE "+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"IVA FORNITORI") + " RELATIVO AL MESE DI " + PERI
   REPLACE RIGA      WITH SPACE(50)
   REPLACE CHIAVE    WITH 777777
   REPLACE CHIAVE_R  WITH "TOC"
ENDIF

APPEND BLANK
REPLACE IMPONI    WITH IMPONIB_F - IMPONIB_N + IMPONIB_X
REPLACE IMPOST    WITH IMPOSTA_F - IMPOSTA_N + IMPOSTA_X

REPLACE CHIAVE_R  WITH "TOC"
REPLACE CHIAVE    WITH 777777

V_IMPOND =IMPONIB_F 
V_IMPOSD =IMPOSTA_F 

RIGA_D = " >>>>> TOTALI GENERALI   " 
RIGA_D = RIGA_D + SPACE(12) + " | " + SUBSTR(TRANSFORM(V_IMPOND,"999,999,999,999.99"),1,18) 
RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(V_IMPOSD,"999,999,999,999.99"),1,18)

RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(IMPONIB_X,"999,999,999,999.99"),1,18) 
RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(IMPOSTA_X,"999,999,999,999.99"),1,18)

REPLACE RIGAT     WITH RIGA_D 
REPLACE RIGA      WITH SPACE(50)

RETURN


*************************
PROCEDURE IVATORF 
*************************
* TOTALI FORNITORE      *
   
SELECT IVA_FO

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
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,124) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
PERI=MESE_C + " " +ANNO
REPLACE RIGAT     WITH "                         TOTALE "+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"IVA FORNITORI") + " RELATIVO AL MESE DI " + PERI
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,124) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
PERI=MESE_C + " " +ANNO
REPLACE RIGAT     WITH "COD  DESCRIZIONE IVA                         IMPONIBILE           IMPOSTA             IMPONIBILE              IMPOSTA     "
REPLACE RIGA      WITH SPACE(50)  
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
PERI=MESE_C + " " +ANNO
REPLACE RIGAT     WITH "IVA                                          DEDUCIBILE          DEDUCIBILE          INDEDUCIBILE         NON DETRAIBILE "
REPLACE RIGA      WITH SPACE(50) 
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

*** >>>>>  TOTALI IVA FORNITORI 

IMPONIB_F = 0  && IVE FATTURE
IMPOSTA_F = 0
IMPONIB_N = 0  && IVE NOTE CREDITO
IMPOSTA_N = 0
IMPONIB_X = 0  && IVE INDEDUCIBILI
IMPOSTA_X = 0

IF !ExecCommand("select * from u_iva_to where 0=1","u_iva_to")
  return(.f.)
ENDIF
SELECT U_IVA_TO
HH=AFIELDS(TRANSIVTO)
CREATE CURSOR CU_IVA_TO FROM ARRAY TRANSIVTO
INDEX ON  ito_codsoc+ito_anno+ito_mese+ito_codiva+ito_clifor TAG RIE_IVA   

* RAGGRUPPA LA I TOTALI IVA SOTTRAENDO LE NOTE DI CREDITO

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNO + "'"
x_mese = "ito_mese = '" + MESE + "'"
*x_tipo = "ito_clifor = 'E'"
x_tipo = "ito_clifor = '" + _par_Flag_E_R_A + "'"
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

   SCATTER MEMVAR MEMO 

   IF M.ITO_FATNOT = "N"
      M.ITO_IMPONI = M.ITO_IMPONI * -1
      M.ITO_IMPOST = M.ITO_IMPOST * -1
      M.ITO_IMPONR = M.ITO_IMPONR * -1
      M.ITO_IMPOSR = M.ITO_IMPOSR * -1
   ENDIF
  
   SELECT CU_IVA_TO 
   SET ORDER TO RIE_IVA
   _KK= m.ito_codsoc+m.ito_anno+m.ito_mese+m.ito_codiva+m.ito_clifor
   SEEK _KK
   IF FOUND()
      REPLACE ITO_IMPONI WITH ITO_IMPONI + M.ITO_IMPONI
      REPLACE ITO_IMPOST WITH ITO_IMPOST + M.ITO_IMPOST 
      REPLACE ITO_IMPONR WITH ITO_IMPONR + M.ITO_IMPONR 
      REPLACE ITO_IMPOSR WITH ITO_IMPOSR + M.ITO_IMPOSR 
      REPLACE ITO_FATNOT WITH "F"
   ELSE
      APPEND BLANK
      GATHER MEMVAR MEMO
      REPLACE ITO_FATNOT WITH "F"
   ENDIF

   SELECT U_IVA_TO
   SKIP + 1

ENDDO

SELECT CU_IVA_TO
GO TOP

DO WHILE .T. 

   IF EOF()
      EXIT
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
   SELECT CU_IVA_TO

   IND_100 = ' '
   IF ITO_IND100 = 'S'  && IVA INDEDUCIBILE AL 100%
      IND_100   = "S"
   ENDIF


   __DEDUCIBILE = ITO_DEDUCIBILE	&& IMPOSTA INDEDUCIBILE = .F. / IMPOSTA DEDUCIBILE = .T.

   **IF IND_100 = 'S'	.OR. "*" $ V_CODIVA	 && IMPOSTE INDEDUCIBILI  
   IF IND_100 = 'S'	.OR. __DEDUCIBILE	 && IMPOSTE INDEDUCIBILI  
      IF IND_100 = 'S'
	     IF V_FATNOT = "F" 
			IMPONIB_X =  IMPONIB_X  + ITO_IMPONI + ITO_IMPOST  && IVE INDEDUCIBILI AL 100%
			IMPOSTA_X =  IMPOSTA_X  + ITO_IMPOST
	 		V_IMPONI  =  ITO_IMPONI + ITO_IMPOST 				&& IVE INDEDUCIBILI AL 100%
		 ELSE
			IMPONIB_X =  IMPONIB_X  - ITO_IMPONI - ITO_IMPOST  && PER NOTE C. TOGLIE
			IMPOSTA_X =  IMPOSTA_X  - ITO_IMPOST
	 		V_IMPONI  =  ITO_IMPONI + ITO_IMPOST 				&& IVE INDEDUCIBILI AL 100%
		 ENDIF
      ELSE
         IF V_FATNOT = "F" 
		    IMPONIB_X =  IMPONIB_X  + ITO_IMPONI  				&& IVE INDEDUCIBILI AL 100%
		    IMPOSTA_X =  IMPOSTA_X  + ITO_IMPOST
		 ELSE
		    IMPONIB_X =  IMPONIB_X  - ITO_IMPONI  				&& IVE INDEDUCIBILI AL 100%
		    IMPOSTA_X =  IMPOSTA_X  - ITO_IMPOST
		 ENDIF
	  ENDIF	 
   ELSE 
      IF V_FATNOT = "F" 
         IMPONIB_F =  IMPONIB_F  + ITO_IMPONI  && IVE FATTURE
         IMPOSTA_F =  IMPOSTA_F  + ITO_IMPOST
      ENDIF 
      IF V_FATNOT = "N" 
         IMPONIB_F =  IMPONIB_F  - ITO_IMPONI  && IVE NOTE CREDITO
         IMPOSTA_F =  IMPOSTA_F  - ITO_IMPOST
      ENDIF 
   ENDIF

   SELECT IVA_FO
   PUB_RIGA = PUB_RIGA + 1   
   IF PUB_RIGA > SALTO_PAG
      DO IVATESTO             && TESTATA BOLLATO
   ENDIF

   SELECT IVA_FO
   APPEND BLANK

   *====>>> RIGA DI DETTAGLIO
    
   IF ALLTRIM(V_FATNOT) = "N"
	  S_IMPONI = V_IMPONI * -1
 	  S_IMPOST = V_IMPOST * -1
   ELSE
	  S_IMPONI = V_IMPONI 
	  S_IMPOST = V_IMPOST 
   ENDIF


   **IF IND_100 = 'S'	.OR. "*" $ V_CODIVA	 && IMPOSTE INDEDUCIBILI  
   IF IND_100 = 'S'	.OR. __DEDUCIBILE	 && IMPOSTE INDEDUCIBILI  
	  RIGA_D = V_CODIVA + "  " + V_FATNOT + " " + V_DESIVA +  " | " +SPACE(18)+ " | " +SPACE(18)
	  RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(S_IMPONI,"999,999,999,999.99"),1,18) 
	  RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(S_IMPOST,"999,999,999,999.99"),1,18)
   ELSE
	  RIGA_D = V_CODIVA + "  " + V_FATNOT + " " + V_DESIVA 
	  RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(S_IMPONI,"999,999,999,999.99"),1,18) 
	  RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(S_IMPOST,"999,999,999,999.99"),1,18)+  " | " +SPACE(18)+ " | "
   ENDIF	

   REPLACE RIGAT       WITH RIGA_D 
   REPLACE RIGA        WITH SPACE(50)
   REPLACE CHIAVE      WITH 777777
   REPLACE CHIAVE_R    WITH "TOC"

   REPLACE ITO_CODIVA  WITH V_CODIVA 
   REPLACE ITO_FATNOT  WITH V_FATNOT 
   REPLACE ITO_DESIVA  WITH V_DESIVA
   REPLACE ITO_IMPONI  WITH V_IMPONI
   REPLACE ITO_IMPOST  WITH V_IMPOST
     
   SELECT CU_IVA_TO
   SKIP + 1

ENDDO

SELECT IVA_FO

** TOTALI IVA FORNITORI
** ==================

SELECT IVA_FO
PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
   PUB_RIGA = PUB_RIGA + 1
   APPEND BLANK
   RIGA_D=SPACE(50)
   REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,124) 
   REPLACE RIGA      WITH SPACE(50)
   REPLACE CHIAVE    WITH 777777
   REPLACE CHIAVE_R  WITH "TOC"
   PUB_RIGA = PUB_RIGA + 1
   APPEND BLANK 
   PERI=MESE_C + " " +ANNO
   REPLACE RIGAT     WITH "         TOTALE "+IIF(!EMPTY(_WW_TITOLO),_WW_TITOLO,"IVA FORNITORI") + " RELATIVO AL MESE DI " + PERI
   REPLACE RIGA      WITH SPACE(50)
   REPLACE CHIAVE    WITH 777777
   REPLACE CHIAVE_R  WITH "TOC"
ENDIF

APPEND BLANK
REPLACE IMPONI    WITH IMPONIB_F - IMPONIB_N + IMPONIB_X
REPLACE IMPOST    WITH IMPOSTA_F - IMPOSTA_N + IMPOSTA_X
REPLACE CHIAVE_R  WITH "TOC"
REPLACE CHIAVE    WITH 777777

V_IMPOND =IMPONIB_F 
V_IMPOSD =IMPOSTA_F 

RIGA_D = " >>>>> TOTALI GENERALI   " 
RIGA_D = RIGA_D + SPACE(12) + " | " + SUBSTR(TRANSFORM(V_IMPOND,"999,999,999,999.99"),1,18) 
RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(V_IMPOSD,"999,999,999,999.99"),1,18)

RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(IMPONIB_X,"999,999,999,999.99"),1,18) 
RIGA_D = RIGA_D + " | " + SUBSTR(TRANSFORM(IMPOSTA_X,"999,999,999,999.99"),1,18)

REPLACE RIGAT     WITH RIGA_D 
REPLACE RIGA      WITH SPACE(50)

RETURN


*************************
PROCEDURE IVAPLAF 
*************************
* TOTALI PLAFOND      *

_SEL=SELECT()

v_seek	 = "PLA"+PUB_ANNO + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   OLD_PLAF= VAL(LIBERA) 
   IF OLD_PLAF = 0    && VERIFICA SE EFFETTIVAMENTE DEVE GESTIRE IL PLAFOND
	  SELECT(_SEL)
	  RETURN
   ENDIF	  
ELSE
   SELECT(_SEL)
   RETURN
ENDIF  

CREATE CURSOR IVA_PLA;
   (CODIVA C(3),DESIVA C(30),IMPONI N(17,3))
INDEX ON ALLTRIM(CODIVA) TAG CODICE

*** >>>>>  CALCOLO TOTALI IVA GESTITI IN PLAFOND

OK_PLAF = .F.

x_soci = "ito_codsoc = '" + PUB_CODSOC + "'"
x_anno = "ito_anno = '" + ANNO + "'"
x_mese = "ito_mese = '" + MESE + "'"
*x_tipo = "ito_clifor = 'E'"
x_tipo = "ito_clifor = '" + _par_Flag_E_R_A + "'"
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

   V_CODIVA = ITO_CODIVA 
   V_DESIVA = ITO_DESIVA

   IF !SUM_PLAF(V_CODIVA) 		&& SCARTA IVE NON GESTITE IN PLAGOND
      SKIP + 1
      LOOP
   ENDIF

   IF ITO_FATNOT = "F"
	  V_IMPONI = ITO_IMPONI
   ELSE
	  V_IMPONI = ITO_IMPONI * -1   && NOTA DI CREDITO
   ENDIF  
  
   SELECT IVA_PLA
   SET ORDER TO CODICE
   SEEK V_CODIVA
   IF FOUND()
      REPLACE IMPONI  WITH   IMPONI + V_IMPONI
   ELSE
	  APPEND BLANK
      REPLACE CODIVA  WITH   V_CODIVA
      REPLACE DESIVA  WITH   V_DESIVA
      REPLACE IMPONI  WITH   V_IMPONI
      OK_PLAF = .T.  
   ENDIF
  
   SELECT U_IVA_TO
   SKIP + 1

ENDDO

* >>>> VERIFICA SE ESISTE PLAFOND

IF !OK_PLAF
   SELECT(_SEL)
   RETURN
ENDIF

* >>>> ARROTONDAMENTO ALLE 500 LIRE SUPERIORI

IF PUB_VALRIF = "ITL" .OR. PUB_VALRIF = "LIT"
   SELECT IVA_PLA
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
 	  SELECT IVA_PLA
	  X_CODIVA = CODIVA
	  X_DESIVA = DESIVA
	  X_PLAF   = IMPONI
      NEW_IMP=STR(X_PLAF,13,0)
      IF VAL(SUBSTR(NEW_IMP,11,3)) > 501
	     NEW_IMP1=VAL(SUBSTR(NEW_IMP,10,1)) + 1
	     X_PLAF=VAL(SUBSTR(NEW_IMP,1,9)+STR(NEW_IMP1,1,0) + '000')
	  ELSE
	     X_PLAF=VAL(SUBSTR(NEW_IMP,1,10) + '000')
	  ENDIF
      REPLACE  IMPONI WITH X_PLAF
	  SELECT IVA_PLA 
	  SKIP +1
   ENDDO
ENDIF

DO IVATPLAF    && TESTATA PLAFOND

* >>> STAMPA PLAFOND ATTUALE

SELECT IVA_FO
APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE CHIAVE    WITH 777777
RIGA_D = ">>>>>>> TOTALE PLAFOND   " 
RIGA_D = RIGA_D + SPACE(12) + " | " + SUBSTR(TRANSFORM(OLD_PLAF,"999,999,999,999.99"),1,18) 
REPLACE RIGAT     WITH RIGA_D 
REPLACE RIGA      WITH SPACE(50)
PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

SELECT IVA_PLA
GO TOP

TOT_PLAF = 0
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   X_CODIVA  = CODIVA
   X_DESIVA  = DESIVA
   X_PLAF    = IMPONI
   TOT_PLAF  =  TOT_PLAF + IMPONI

   SELECT IVA_FO
   APPEND BLANK
   REPLACE CHIAVE_R  WITH "TOC"
   REPLACE CHIAVE    WITH 777777
   RIGA_D = X_CODIVA + " " + X_DESIVA 
   RIGA_D = RIGA_D + SPACE(3) + " | " + SUBSTR(TRANSFORM(X_PLAF,"999,999,999,999.99"),1,18) 
   REPLACE RIGAT     WITH RIGA_D 
   REPLACE RIGA      WITH SPACE(50)

   PUB_RIGA = PUB_RIGA + 1
   IF PUB_RIGA > SALTO_PAG
	  DO IVATESTO             && TESTATA BOLLATO
   ENDIF

   SELECT IVA_PLA 
   SKIP +1

ENDDO

* ==================================================
* >>>>>>>  CALCOLO NUOVO PLAFOND

SELECT IVA_FO

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,90) 
REPLACE RIGA      WITH SPACE(50)	
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

NEW_PLAF = OLD_PLAF - TOT_PLAF

SELECT IVA_FO
APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE CHIAVE    WITH 777777
RIGA_D = ">>>>>>> NUOVO PLAFOND    " 
RIGA_D = RIGA_D + SPACE(12) + " | " + SUBSTR(TRANSFORM(NEW_PLAF,"999,999,999,999.99"),1,18) 
REPLACE RIGAT     WITH RIGA_D 
REPLACE RIGA      WITH SPACE(50)
PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

* ==================================================

SELECT IVA_FO
PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,90) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

SELECT IVA_FO

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

SELECT IVA_FO
APPEND BLANK
REPLACE CHIAVE_R  WITH "TOC"
REPLACE RIGAT     WITH SPACE(50)
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777

SELECT IVA_FO
APPEND BLANK
RIGA_D = SPACE(50)
REPLACE RIGAT    WITH ""+RIGA_D     && SALTO PAGINA SPOOLER FINALE
REPLACE RIGA     WITH RIGA_D 
REPLACE CHIAVE   WITH 0
replace chiave_r with "TOC"

RETURN


*************************
PROCEDURE IVATPLAF 
*************************
* TESTATA TOTALI PLAFOND      *

SELECT IVA_FO

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
PERI=MESE_C + " " +ANNO
REPLACE RIGAT     WITH "            RIEPILOGO PLAFOND RELATIVO AL MESE DI " + PERI
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

APPEND BLANK
RIGA_D=SPACE(50)
REPLACE RIGAT     WITH REPLICATE(PUB_CAROR,90) 
REPLACE RIGA      WITH SPACE(50)
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

APPEND BLANK
PERI=MESE_C + " " +ANNO
REPLACE RIGAT     WITH "COD  DESCRIZIONE                               UTILIZZO     "
REPLACE RIGA      WITH SPACE(50)  
REPLACE CHIAVE    WITH 777777
REPLACE CHIAVE_R  WITH "TOC"

PUB_RIGA = PUB_RIGA + 1
IF PUB_RIGA > SALTO_PAG
   DO IVATESTO             && TESTATA BOLLATO
ENDIF

RETURN


********************
FUNCTION SUM_PLAF
********************
PARA _COD_IVA

OUT=.F.
IVA_SEL=SELECT()

v_seek	 = "IVA"+ALLTRIM(_COD_IVA)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF SUBSTR(LIBERA,121,1) = "S"    && GESTIONE PLAFOND
      OUT=.T.
      IF !EMPTY(DESIVA)
	     V_DESIVA = DESIVA
      ENDIF	    
   ENDIF	  
ENDIF  

SELECT(IVA_SEL)
RETURN(OUT)


*************************
PROCEDURE AGGPLAF 
*************************
* AGGIORNA PLAFOND      *

IF !OK_PLAF
   =MESSAGEBOX("Plafond non aggiornato in quanto può non esistere iva in questo "+CHR(13)+ ;
               "mese, oppure non è stato digitato totale plafond in apposita"+CHR(13)+ ;
               "procedura parametri",62,"ATTENZIONE")
   RETURN
ENDIF

_SEL=SELECT()

v_seek   = "PLA"+PUB_ANNO + PUB_CODSOC
v_chiave = "codice"
cSql     = "select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
   REPLACE LIBERA WITH STR(NEW_PLAF,17,3)
   =MESSAGEBOX("Plafond aggiornato correttamente",62,"ATTENZIONE")
ENDIF  
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

SELECT(_SEL)
RETURN


*************************
PROCEDURE OK_SPOOL 
*************************

SELECT IVA_FO
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

   SELECT IVA_FO
   SKIP +1

ENDDO
         
SELECT IVA_STA 
GO TOP

IF OK_FORMATO = 3
   DO CREA_SPOOL WITH "IVA_STA","IVA FORNITORI (A4): "+MESE+"/"+PUB_ANNO
ELSE
   IF OK_FORMATO = 2 OR OK_FORMATO = 1
	  DO CREA_SPOOL WITH "IVA_STA","IVA FORNITORI (A3): "+MESE+"/"+PUB_ANNO
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

*=> Aggiornamento numeratore progressivo su u_azi_an/u_azi_pa
cSql = "select * from u_azi_pa"
IF !ExecRW(cSql,"u_azi_pa","R")
   return(.f.)
ENDIF
SELECT U_AZI_PA
GO TOP
IF EOF()
ELSE
   IF AZI_NRSEBF
      REPLACE AZI_PROTFA WITH NUMPRO_DA
   ELSE
      cSql = "select * from u_azi_an"
      IF !ExecRW(cSql,"u_azi_an","R")
         return(.f.)
      ENDIF
      SELECT U_AZI_AN
      GO TOP
      IF EOF()
      ELSE
         REPLACE AZI_PROTFO WITH NUMPRO_DA
      ENDIF
      IF !ExecRW(cSql,"u_azi_an","W")
         return(.f.)
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"u_azi_pa","W")
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

   IF IVF_CHIAVE = IVF_NUMNEW
   ELSE
      __NUMFAT = IVF_NUMFAT
      __DATFAT = IVF_DTFATT
      __NUMOLD = ALLTRIM(STR(IVF_CHIAVE,6,0))
      __NUMNEW = IVF_NUMNEW

      *=> Aggiornamento sul bollato iva fornitori
      x_uniq = "id_unique = '" + ID_UNIQUE + "'"
      x_cond = x_uniq
      CSQL   = "select * from u_ivf_cl where " + x_cond
      IF !ExecRW(CSQL,"u_ivf_cl","R")
         RETURN (.f.)
      ENDIF  
      SELECT U_IVF_CL
      GO TOP
      IF EOF()
      ELSE
         REPLACE IVF_CHIAVE WITH __NUMNEW
      ENDIF
      IF !ExecRW(CSQL,"u_ivf_cl","W")
         RETURN (.f.)
      ENDIF  

      *=> Aggiornamento sul bollato iva clienti
      x_ndoc = "iva_numfat = '" + ALLTRIM(__NUMFAT) + "'"
      x_ddoc = "iva_dtfatt = '" + ALLTRIM(__DATFAT) + "'"
      x_npro = "iva_numdoc = '" + ALLTRIM(__NUMOLD) + "'"
      x_cond = x_ndoc + " and " + x_ddoc + " and " + x_npro
      CSQL   = "select * from u_iva_cl where " + x_cond
      IF !ExecRW(CSQL,"u_iva_cl","R")
         RETURN (.f.)
      ENDIF  
      SELECT U_IVA_CL
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF IVA_FATNOT = "C"     && NON ELABORA I MOVIMENTI IVA CORRISPETTIVI
            SKIP +1
   	        LOOP
         ENDIF
         IF EMPTY(IVA_NUMCEE)    && NON ELABORA I MOVIMENTI RELATIVI A FATTURE/NOTE DI VENDITA CLI.
            SKIP +1
   	        LOOP
         ENDIF
         REPLACE IVA_NUMDOC WITH ALLTRIM(STR(__NUMNEW,6,0))
         SKIP +1
      ENDDO
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





