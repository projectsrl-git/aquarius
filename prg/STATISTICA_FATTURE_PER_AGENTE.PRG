*******************************
* STATISTICA_FATTURE_PER_AGENTE
*******************************
LPARAMETERS _NR_GIORNI,_COD_AGE

IF PCOUNT()<1
	RETURN .F.
ENDIF

IF PCOUNT()<2
	_COD_AGE = ""
ENDIF

LOCAL _SAVE_SEL,_PDF_SUBDIR_,_FILE_DA_ALLEGARE,_PDF_DESCRIZIONE_,_PDF_SELECT_ ,_PDF_REPORT_ ,_PROGRESSIVO_PROGRAMMA,_ALLEGATI

_SAVE_SEL = SELECT()
_PROGRESSIVO_PROGRAMMA = SYS(2015)

_ALLEGATI=""
_FILE_DA_ALLEGARE=""
_PDF_DESCRIZIONE_=""
_PDF_SELECT_ =""
_PDF_REPORT_ =""
_PDF_SUBDIR_ = LEGGE_CONFIG("AQ_SCHEDULER_CONFIG.CFG","PATH_EMAIL")	&& RICERCA DIRECTORY E SOTTODIRECTORY CONTENENTE IL FILE PDF DA CREARE

RELEASE V_TITOLO,V_NR_GIORNI,V_COD_NAZ
PUBLIC V_TITOLO,V_NR_GIORNI,V_COD_NAZ

V_NR_GIORNI = _NR_GIORNI
*V_TITOLO = "Ordini clienti " + IIF(EMPTY(V_COD_NAZ),"",V_COD_NAZ+" ") + "inseriti negli ultimi " + ALLTRIM(STR(_NR_GIORNI,10,0)) + " giorni"
_V_CODAGE = _COD_AGE
_V_DESAGE = ""
IF !EMPTY(_V_CODAGE)
   x_codi = "codice = 'AGE" + _V_CODAGE + "'"
   Csql   = "select * from para where " + x_codi
   IF !ExecCommand(cSql,"cur_para")
      return(.f.)
   ENDIF
   SELECT cur_para
   GO TOP
   IF EOF()
   ELSE
      _V_DESAGE = ALLTRIM(DESCRI)
   ENDIF
ENDIF
   
_V_OPZMQ = .T.
_V_DORDDA = DTOC(DATE() - _NR_GIORNI)
_V_OPZART = 1
V_TITOLO = "STATISTICA FATTURE PER AGENTE DAL " + _V_DORDDA + CHR(13) + IIF(EMPTY(_V_CODAGE),"(TUTTI GLI AGENTI)","(AGENTE " + ALLTRIM(_V_CODAGE) + " - " + ALLTRIM(_V_DESAGE) + ")")

WAIT WINDOWS "ESEGUE PROGRAMMA STATISTICA_FATTURE_PER_AGENTE" TIMEOUT 3

CREATE CURSOR CU_FAT_DD (ORS_NUMORD C(6),    ORS_DATORD C(10),  ORS_CODCLI C(10),    ORS_RAGSOC C(50),   ;
                         ORD_CODART C(30),   ORD_DESART C(50),  ORD_CODMAT C(3),     ORD_DESMAT C(30),   ;
                         ORD_CODCOL C(3),    ORD_DESCOL C(30),  ORD_SPESSO N(3,0),   ORD_ALTEZZ N(5,0),  ;
                         ORD_LUNGHE N(6,0),  ORD_UM C(02),      ORD_NUMBOB N(6,0),   ORD_QTAORD N(14,2), ;
                         ORD_PRZNET N(19,6), ORD_IVA C(03),     ORD_VALORE N(17,2),  ORS_AGE C(03),      ;
                         ORS_DESAGE C(50),   ORS_CGE L,         ORD_QTAMQ N(14,2),   ORD_VALMQ N(17,2),  ;
                         ORD_PRZMQ N(19,6),  ORD_CDAPRD C(30),  ORS_CODNAZ C(03),    ORS_DESNAZ C(50),   ;
                         ORD_SCADENZE C(254))      
              
SELECT CU_FAT_DD 
INDEX ON ORS_DESAGE+ORS_CODCLI+ORS_DATORD+ORS_NUMORD+ORD_CODART+ORD_CODMAT+ORD_CODCOL+STR(ORD_SPESSO,5,0)+STR(ORD_ALTEZZ,5,0)+STR(ORD_LUNGHE,6,0) TAG I_DESAGE ADDITIVE

x_dord = "ors_datord >= '" + RIBALTA2(ALLTRIM(_V_DORDDA)) + "'"
x_cage = IIF(EMPTY(_V_CODAGE),"1=1","DAGGANCIO IN (SELECT TAGGANCIO FROM U_FAT_TT WHERE ORD_AGE = '" + _V_CODAGE + "')")
x_cond = x_dord + " and " + x_cage 
cSql   = "select * from u_fat_dd where " + x_cond
IF !ExecCommand(cSql,"U_FAT_DD")
   return(.f.)
ENDIF

SELECT CU_FAT_DD
ZAP

SELECT U_FAT_DD
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) <> '*** COMMENTO ***'
   ELSE
      SKIP +1
      LOOP
   ENDIF
   
  
   IF _V_OPZMQ
      IF ALLTRIM(ORD_UM) = "MQ"
      ELSE
         SELECT U_FAT_DD
         SKIP +1
         LOOP      
      ENDIF
   ENDIF 
   
   XX_CAGE = SPACE(03)
   XX_DAGE = SPACE(50)
   XX_CGE  = .F.
   
   x_agga = "taggancio = '" + DAGGANCIO + "'"
   x_cond = x_agga
   cSql   = "select * from u_fat_tt where " + x_cond
   IF !ExecCommand(cSql,"U_FAT_TT")
      return(.f.)
   ENDIF  
   SELECT U_FAT_TT
   GO TOP
   IF EOF()
      SELECT U_FAT_DD
      SKIP +1
      LOOP
   ELSE
      SELECT U_FAT_TT
      _XX_CODNAZ = ORD_CODNAZ
      SELECT U_FAT_TT
      M.ORS_CODNAZ = ORD_CODNAZ
      cSql = "select * from para where codice = 'STA" + ALLTRIM(M.ORS_CODNAZ) + "' order by codice"
      IF !ExecCommand(cSql,"PARA")
         RETURN .F.
      ENDIF
      SELECT PARA
      GO TOP
      IF EOF()
         M.ORS_DESNAZ = SPACE(50)
      ELSE
         M.ORS_DESNAZ = DESCRI
      ENDIF
      SELECT U_FAT_TT      
   ENDIF
   
   IF ORD_CAUS = "VEN" && SOLO VENDITA
   ELSE
      SELECT U_FAT_DD
      SKIP +1
      LOOP     
   ENDIF
   
   IF EMPTY(ALLTRIM(_V_CODAGE))  && FILTRO AGENTE
   ELSE
      IF _V_CODAGE = ORD_AGE
      ELSE
         SELECT U_FAT_DD
         SKIP +1
         LOOP          
      ENDIF
   ENDIF
   
   XX_CGE  = ORD_CGE   
   
   x_codi = "codice = 'AGE" + ORD_AGE + "'"
   Csql   = "select * from para where " + x_codi
   IF !ExecCommand(cSql,"cur_para")
      return(.f.)
   ENDIF
   SELECT cur_para
   GO TOP
   IF EOF()
   ELSE
      XX_CAGE = SUBSTR(CODICE,4,3)
      XX_DAGE = DESCRI
   ENDIF

   SELECT U_FAT_DD
   IF _V_OPZART = 1
      XXX_CODART = ORD_CODART
   ELSE
      XXX_CODART = ORD_CDAPRD
   ENDIF

   _VV_CODMAT = ""
   _VV_DESMAT = ""
   _VV_CODCOL = ""
   _VV_DESCOL = ""
   _VV_SPESSO = 0

   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + XXX_CODART + "'"
   x_cond = x_soci + " and " + x_codi
   cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"CUR_ARTICOLI")
      RETURN .F.
   ENDIF
   SELECT CUR_ARTICOLI
   GO TOP
   IF EOF()
   ELSE
      _VV_CODMAT = ART_CODMAT
      _VV_DESMAT = ART_DESMAT
      _VV_CODCOL = ART_CODCOL
      _VV_DESCOL = ART_DESCOL
      _VV_SPESSO = ART_SPESSO
   ENDIF

   SELECT U_FAT_DD   
   SCATTER MEMVAR MEMO
   
	M.ORD_SCADENZE = ""
	cSql=""     
	cNomeCursorSql="TMP_SCADENZE"
	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

		SELECT
			RIGHE_PART.PAR_NPROT AS NUM_FATTURA,
			RIGHE_PART.PAR_DTFAT AS DATA_FATTURA,
			RIGHE_PART.PAR_DTSCAD AS DATA_SCADENZA,
			RIGHE_PART.PAR_FATT AS IMPORTO
		FROM PART_CLI AS RIGHE_PART
		WHERE
			RIGHE_PART.PAR_NPROG <> 100 
			AND (RIGHE_PART.PAR_TMOV = 'D' AND RIGHE_PART.PAR_TIPODO = 'FAT')
			AND RIGHE_PART.PAR_DTFAT = '<<M.ORS_DATORD>>' AND RIGHE_PART.PAR_NPROT = '<<M.ORS_NUMORD>>'
		ORDER BY RIGHE_PART.PAR_DTSCAD
		
	ENDTEXT					&& FINE SCRITTURA QUERY
	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF
	SELECT TMP_SCADENZE
	GO TOP
	SCAN
		M.ORD_SCADENZE = ALLTRIM(M.ORD_SCADENZE) + IIF(EMPTY(M.ORD_SCADENZE),""," - ") + RIBALTA2(DATA_SCADENZA)
	ENDSCAN
   
   SELECT CU_FAT_DD
   APPEND BLANK
   GATHER MEMVAR
   
   IF _V_OPZART = 1
      REPLACE ORD_CODART WITH M.ORD_CODART 
      REPLACE ORD_DESART WITH M.ORD_DESART 
   ELSE
      REPLACE ORD_CODART WITH M.ORD_CDAPRD 
      REPLACE ORD_DESART WITH M.ORD_DSAPRD 
   ENDIF
   REPLACE ORD_CDAPRD WITH M.ORD_CDAPRD      
   REPLACE ORS_AGE    WITH XX_CAGE
   REPLACE ORS_DESAGE WITH XX_DAGE
   REPLACE ORS_CGE    WITH XX_CGE     
   IF ALLTRIM(ORD_UM) = "MQ"
      REPLACE ORD_QTAMQ WITH ORD_QTAORD
      REPLACE ORD_VALMQ WITH ORD_VALORE
      REPLACE ORD_PRZMQ WITH ORD_PRZNET
   ELSE
      REPLACE ORD_QTAMQ WITH 0
      REPLACE ORD_VALMQ WITH 0
      REPLACE ORD_PRZMQ WITH 0
   ENDIF
   REPLACE ORS_CODNAZ WITH M.ORS_CODNAZ
   REPLACE ORS_DESNAZ WITH M.ORS_DESNAZ

   
   SELECT U_FAT_DD
   SKIP +1
  
ENDDO

SELECT CU_FAT_DD
SET ORDER TO I_DESAGE
GO TOP

_PDF_REPORT_ 		= ALLTRIM(CERCAREPO("XXX","STATISTICA_FATTURE_PER_AGENTE","STATISTICA_FATTURE_PER_AGENTE.FRX"))
_PDF_DESCRIZIONE_	= STRTRAN(STRTRAN(V_TITOLO,'/','-'),CHR(13),SPACE(2))+_PROGRESSIVO_PROGRAMMA
_PDF_SELECT_ 		= "CU_FAT_DD"

IF !EMPTY(_PDF_SUBDIR_)
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_PDF_SUBDIR_ )
ELSE
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
ENDIF

_FILE_DA_ALLEGARE = ALLTRIM(_PDF_DESCRIZIONE_)+".PDF"

_ALLEGATI = _ALLEGATI + IIF(EMPTY(_ALLEGATI),"",";")+_FILE_DA_ALLEGARE 


_ERRORE =.F.
DO PRG\INVIA_MAIL_SCHEDULATE WITH _ERRORE,_ALLEGATI ,_ID_EMAIL_DA_INVIARE


SELECT(_SAVE_SEL )
	
