

*** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR
	RETURN
ENDIF

CREATE CURSOR IMPORTAXLS (cntr N(10,0), ;
	ESERCIZIO C(4), ;
	NUMERO C(10), ;
	RIGA C(10), ;
	ESERCIPROT C(4), ;
	TIPOPROT C(3), ;
	NUMEROPROT C(10), ;
	DATAPROT C(10), ;
	C_F C(1), ;
	CLI_FOR C(10), ;
	RAGIONESOC C(254), ;
	RIGAPROT C(10), ;
	CENTRCOSTO C(10), ;
	ARTICOLO C(30), ;
	DESARTICOL C(200), ;
	QUANTITA N(19,4), ;
	QUANTCONFE N(19,4), ;
	NOTE_CONCATENATE C(254))

APPEND FROM (gcFile) TYPE xls	

***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP
SELECT IMPORTAXLS
GO TOP
IF !EOF()
	DELETE  && CANCELLO INTESTAZIONI DI COLONNA
ELSE
	MESSAGEBOX("File vuoto",16,"Attenzione")
	RETURN .F.
ENDIF

RELEASE _C_MAG_VISIONI,_C_MAG_SPOSTAMENTO,_V_CODCAUS,_C_MOTIVAZIONE,_V_CAUSCA,_V_CAUCAR,_V_DATAGR
PUBLIC _C_MAG_VISIONI,_C_MAG_SPOSTAMENTO,_V_CODCAUS,_C_MOTIVAZIONE,_V_CAUSCA,_V_CAUCAR,_V_DATAGR
_C_MAG_VISIONI = ""
_C_MAG_SPOSTAMNETO = ""
_V_CODCAUS = ""
_C_MOTIVAZIONE = ""
_V_CAUSCA = ""
_V_CAUCAR = ""
_V_DATAGR = "12/01/2015"

_C_MAG_VISIONI = PJ_INPUTBOX("Inserire il codice magazzino visioni da allineare","Selezione magazzino visioni","VIS")
IF EMPTY(_C_MAG_VISIONI)
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF
_C_MAG_VISIONI = seek_para('MAG',ALLTRIM(_C_MAG_VISIONI),'CODICE','CODICE',"4,6")
IF EMPTY(_C_MAG_VISIONI)
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF

_C_MAG_SPOSTAMENTO = PJ_INPUTBOX("Inserire il codice magazzino per lo spostamento","Selezione magazzino di destinazione","")
IF EMPTY(_C_MAG_SPOSTAMENTO)
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF
_C_MAG_SPOSTAMENTO = seek_para('MAG',ALLTRIM(_C_MAG_SPOSTAMENTO),'CODICE','CODICE',"4,6")
IF EMPTY(_C_MAG_SPOSTAMENTO)
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF

_V_DATAGR = PJ_INPUTBOX("Inserire la data carico giacenze da filtrare","Selezione data carico",_V_DATAGR)
IF EMPTY(_V_DATAGR)
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF
IF VALID_DATA(_V_DATAGR)
   _V_DATAGR=OK_DATA(_V_DATAGR)
ELSE
	MESSAGEBOX('Data non valida',64,'*** ATTENZIONE ***')
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF

_V_CODCAUS = PJ_INPUTBOX("Inserire la causale di scarico per lo spostamento","Selezione causale di spostamento","")
IF EMPTY(_V_CODCAUS)
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF
_V_CODCAUS = SEEK_PARA1('TOP',ALLTRIM(_V_CODCAUS),'CODICE','CODICE',"4,10","","","S")
SAY_CAUS   = ""
IF EMPTY(_V_CODCAUS)
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF

SELECT _pj_para
DES      = DESCRI
TP       = SUBSTR(LIBERA,1,1)
CSC      = SUBSTR(LIBERA,25,1)
SAY_CAUS = SUBSTR(DESCRI,1,30)

** SERGIO 19/11/2021 INIZIO 
* _TOPCAR = SUBSTR(LIBERA,35,3)
_TOPCAR = CERCA_CAUSALI_TOP(_V_CODCAUS,'CONCAU')	&& CAUSALE CONTRARIA A QUELLA DIGITATA
** SERGIO 19/11/2021 FINE   

_V_DESCAUS = DES
_V_CAUSCA  = _V_CODCAUS
_V_CAUCAR  = _TOPCAR

IF TP = 'S'
ELSE
	MESSAGEB("Il codice causale non è di tipo 'Spostamento'",16,"*** ATTENZIONE ***")
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF

IF EMPTY(ALLTRIM(_TOPCAR))
	MESSAGEB("Contro causale inesistente",16,"*** ATTENZIONE ***")
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF

_C_MOTIVAZIONE = ""
_RISP = MESSAGEBOX("Inserire un commento sulla motivazione dello spostamento di magazzino?",4+32+256,"Attenzione")
IF _RISP = 6
	_C_MOTIVAZIONE = PJ_INPUTBOX("Inserire la motivazione dello spostamento di magazzino","Motivazione di spostamento",'')
ENDIF

RIT = MESSAGEBOX("Procedo con Allineamento giacenze mag. visioni da file excel con spostamento in altro mag.?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

SELECT ARTICOLO, SUM(QUANTITA) AS QTATOT FROM IMPORTAXLS GROUP BY ARTICOLO ORDER BY ARTICOLO INTO CURSOR IMPORTAXLS_RAGGR

CREATE CURSOR CU_MAG_GI (MAG_CODMAG C(06),   MAG_DESMAG C(30),   MAG_CODART C(30),   MAG_DESART C(50),   MAG_CODMAT C(03),   ;
                         MAG_DESMAT C(50),   MAG_CODIMB C(03),   MAG_DESIMB C(50),   MAG_CODCOL C(03),   MAG_DESCOL C(50),   ;
                         MAG_SPESSO N(05),   MAG_ALTEZZ N(05),   MAG_LUNGHE N(06),   MAG_NRLINT N(08),   MAG_UMMAGA C(03),   ;
                         MAG_GIACEN N(19,4), MAG_UNIMIS C(03),   MAG_PRZCON N(13,6), MAG_CODFOR C(10),   MAG_DESFOR C(50),   ;
                         MAG_CODACQ C(03),   MAG_DESACQ C(30),   MAG_NUMIDE C(07),   MAG_ANAART C(30),   MAG_ANNIDE C(04),   ;
                         MAG_VALGIV N(10,2), MAG_VALGIC N(10,2), MAG_PRZVEM N(13,6), MAG_PRZCOM N(13,6), MAG_QTAVET N(10,0), ;
                         MAG_DATULV C(10),   MAG_PRZULV N(13,6), MAG_QTAULV N(19,4), MAG_QTACAT N(19,4), MAG_DATULC C(10),   ;
                         MAG_PRZULC N(13,6), MAG_QTAULC N(19,4), MAG_PRZVEN N(13,6), MAG_QTAKG N(19,4),  MAG_QTAMQ N(19,4),  ;
                         MAG_QTAML N(19,4),  MAG_CODSYS C(10),   MAG_VALVEN N(17,2), MAG_VALCAR N(17,2), MAG_DATCAR C(10),   ;
                         MAG_NUMBOB N(10,0), MAG_CSTFNU N(10,2), MAG_CSTADE N(10,2), MAG_CSTAMQ N(16,6), ID_UNIQUE C(50),    ;
                         SELEZIONE C(10),    MAG_QTAIMP N(19,4), MAG_GKGIMP N(19,4), MAG_GMLIMP N(19,4), MAG_NUMPRG C(06),   ;
                         MAG_DATPRG C(10),   MAG_FILA_X C(05),   MAG_PIAN_X C(05),   MAG_UBIC_X C(05),   MAG_FILA_N N(5,0),  ;
                         MAG_PIAN_N N(5,0),  MAG_UBIC_N N(5,0),  MAG_PRENOT L,       MAG_UNIQUE C(10),   MAG_CODSOC C(2),    ;
                         MAG_SERIAL C(20))

CREATE CURSOR CU_MAG_GM (MAG_CODMAG C(06),   MAG_DESMAG C(30),   MAG_CODART C(30),   MAG_DESART C(50),   MAG_CODMAT C(03),   ;
                         MAG_DESMAT C(50),   MAG_CODIMB C(03),   MAG_DESIMB C(50),   MAG_CODCOL C(03),   MAG_DESCOL C(50),   ;
                         MAG_SPESSO N(05),   MAG_ALTEZZ N(05),   MAG_LUNGHE N(06),   MAG_NRLINT N(08),   MAG_UMMAGA C(03),   ;
                         MAG_GIACEN N(19,4), MAG_UNIMIS C(03),   MAG_PRZCON N(13,6), MAG_CODFOR C(10),   MAG_DESFOR C(50),   ;
                         MAG_CODACQ C(03),   MAG_DESACQ C(30),   MAG_NUMIDE C(07),   MAG_ANAART C(30),   MAG_ANNIDE C(04),   ;
                         MAG_VALGIV N(10,2), MAG_VALGIC N(10,2), MAG_PRZVEM N(13,6), MAG_PRZCOM N(13,6), MAG_QTAVET N(10,0), ;
                         MAG_DATULV C(10),   MAG_PRZULV N(13,6), MAG_QTAULV N(10,0), MAG_QTACAT N(10,0), MAG_DATULC C(10),   ;
                         MAG_PRZULC N(13,6), MAG_QTAULC N(19,4), MAG_PRZVEN N(13,6), MAG_QTAKG N(19,4),  MAG_QTAMQ N(19,4),  ;
                         MAG_QTAML N(19,4),  MAG_CODSYS C(10),   MAG_VALVEN N(17,2), MAG_VALCAR N(17,2), MAG_DATCAR C(10),   ;
                         MAG_NUMBOB N(10,0), MAG_CSTFNU N(10,2), MAG_CSTADE N(10,2), MAG_CSTAMQ N(16,6), ID_UNIQUE C(50),    ;
                         MAG_NUMPRG C(06),   MAG_DATPRG C(10),   MAG_AMGPRG C(10),   MAG_LEGSYS C(10),   SELEZIONE C(10),    ;
                         MAG_QTAIMP N(19,4), MAG_GKGIMP N(19,4), MAG_GMLIMP N(19,4), MAG_FILA_X C(05),   MAG_PIAN_X C(05),   ;
                         MAG_UBIC_X C(05),   MAG_FILDES_X C(05), MAG_PIADES_X C(05), MAG_UBIDES_X C(05), MAG_CDMDES C(06),   ;
                         MAG_DSMDES C(50),   MAG_GIADES N(19,4), MAG_FILA_N N(5,0),  MAG_PIAN_N N(5,0),  MAG_UBIC_N N(5,0),  ;
                         MAG_FILDES_N N(5,0),MAG_PIADES_N N(5,0),MAG_UBIDES_N N(5,0),MAG_PRENOT L,       MAG_UNIQUE C(10),   ;
                         MAG_CODSOC C(2),    MAG_SERIAL C(20))


_N_ARTICOLI_SPOSTATI = 0

x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
x_maga = "mag_codmag = '" + ALLTRIM(_C_MAG_VISIONI) + "'"
x_data = "mag_datagg <= '" + RIBALTA2(_V_DATAGR) + "'"
x_cond = x_soci  + " and " + x_maga + " and " + x_data
cSql = "select MAG_ANAART, SUM(MAG_GIACEN) AS TOT_GIACEN FROM u_mag_gg where " + x_cond + " group by MAG_ANAART order by MAG_ANAART"
IF !ExecCommand(cSql,'CX_MAG_GG_RAGGR')
   return(.f.)
ENDIF
SELECT CX_MAG_GG_RAGGR
GO TOP
SCAN

	WAIT WINDOWS "Elaborazione spostamenti giacenze in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT

	SCATTER MEMVAR
	
	IF EMPTY(M.MAG_ANAART)
		LOOP
	ENDIF
	
	SELECT CU_MAG_GI
	ZAP
	
	SELECT CU_MAG_GM
	ZAP
	
	_ARTICOLO = M.MAG_ANAART
	_QTA_GIACENZA = 0
	
	SELECT * FROM IMPORTAXLS_RAGGR WHERE ARTICOLO = _ARTICOLO INTO CURSOR ACT_IMPORTAXLS_RAGGR
	SELECT ACT_IMPORTAXLS_RAGGR
	GO TOP
	IF EOF()
		_QTA_DA_TENERE = 0
	ELSE
		_QTA_DA_TENERE = QTATOT
	ENDIF
	
	x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
	x_arti = "mag_anaart = '" + ALLTRIM(_ARTICOLO) + "'"
	x_maga = "mag_codmag = '" + ALLTRIM(_C_MAG_VISIONI) + "'"
	x_data = "mag_datagg <= '" + RIBALTA2(_V_DATAGR) + "'"
	x_cond = x_soci  + " and " + x_arti + " and " + x_maga + " and " + x_data
	cSql = "select T2.ART_CODPRI,T2.ART_DESCR,T2.ART_CODIMB,T2.ART_DESIMB,T2.ART_UMMAGA,T2.ART_UNIMIS,T2.ART_PRZVEN," + ;
	       "T1.* FROM u_mag_gg AS T1 INNER join (SELECT ART_CODPRI,ART_DESCR,ART_CODIMB,ART_DESIMB,ART_UMMAGA,ART_UNIMIS,ART_PRZVEN FROM u_art_pr) " + ;
	       "AS T2 on T1.mag_anaart = T2.art_codpri where " + x_cond + " order by mag_datagg, mag_oracar"
	IF !ExecCommand(cSql,'U_MAG_GG')
	   return(.f.)
	ENDIF
	SELECT U_MAG_GG
	GO TOP

	DO WHILE .T.

	   IF EOF()
	      EXIT
	   ENDIF

	   IF DELETED()
	      SKIP +1
	      LOOP
	   ENDIF
	
	   SCATTER MEMVAR MEMO
	
	   IF MAG_GIACEN > 0
	   ELSE
	      SKIP +1
	      LOOP
	   ENDIF
	
	   SELECT CU_MAG_GI
	   APPEND BLANK
	
	   GATHER MEMVAR MEMO
	
	   REPLACE ID_UNIQUE  WITH M.ID_UNIQUE
	   REPLACE MAG_CODMAG WITH M.MAG_CODMAG
	   REPLACE MAG_DESMAG WITH ""
	   REPLACE MAG_CODART WITH M.MAG_CODART
	   REPLACE MAG_DESART WITH M.ART_DESCR
	   REPLACE MAG_CODMAT WITH M.MAG_CODMAT
	   REPLACE MAG_DESMAT WITH M.MAG_DESMAT
	   REPLACE MAG_CODIMB WITH M.ART_CODIMB
	   REPLACE MAG_DESIMB WITH M.ART_DESIMB
	   REPLACE MAG_CODCOL WITH M.MAG_CODCOL
	   REPLACE MAG_DESCOL WITH M.MAG_DESCOL
	   REPLACE MAG_SPESSO WITH M.MAG_SPESSO
	   REPLACE MAG_ALTEZZ WITH M.MAG_ALTEZZ
	   REPLACE MAG_LUNGHE WITH M.MAG_LUNGHE
	   REPLACE MAG_NRLINT WITH M.MAG_NRLINT
	   REPLACE MAG_UMMAGA WITH M.ART_UMMAGA
	   REPLACE MAG_GIACEN WITH M.MAG_GIACEN
	   REPLACE MAG_UNIMIS WITH M.ART_UNIMIS
	   REPLACE MAG_PRZCON WITH M.MAG_PRZCON
	   REPLACE MAG_PRZVEN WITH M.ART_PRZVEN
	   REPLACE MAG_CODFOR WITH M.MAG_FORNIT
	   REPLACE MAG_DESFOR WITH M.MAG_DESFOR
	   REPLACE MAG_CODACQ WITH M.MAG_CODACQ
	   REPLACE MAG_DESACQ WITH M.MAG_DESACQ
	   REPLACE MAG_NUMIDE WITH M.MAG_NUMIDE
	   REPLACE MAG_ANAART WITH M.MAG_ANAART
	   REPLACE MAG_ANNIDE WITH M.MAG_ANNO
	   REPLACE MAG_QTAKG  WITH M.MAG_QTAKG
	   REPLACE MAG_QTAMQ  WITH M.MAG_QTAMQ
	   REPLACE MAG_QTAML  WITH M.MAG_QTAML
	   REPLACE MAG_QTAIMP WITH M.MAG_QTAIMP
	   REPLACE MAG_GKGIMP WITH M.MAG_GKGIMP
	   REPLACE MAG_GMLIMP WITH M.MAG_GMLIMP
	   REPLACE MAG_VALGIV WITH ROUND((MAG_GIACEN * MAG_PRZVEN),2)
	   *=> Se trattasi di adesivi o altro (non bobine), ricalcolo il valore di acquisto prendendo in considerazione la quantita' in giacenza
	   IF MAG_CODMAT = '004' .OR. M.MAG_CODMAT = '001'
	      REPLACE MAG_VALGIC WITH ROUND((M.MAG_GIACEN * M.MAG_PRZCON),2)
	   ELSE
	      *=> Ricalcolo il valore di acquisto in base alla unità di misura di acquisto
	      IF MAG_UNIMIS = 'MQ'
	         REPLACE MAG_VALGIC WITH ROUND((M.MAG_QTAMQ * M.MAG_PRZCON),2)
	      ELSE
	         IF MAG_UNIMIS = 'KG'
	            REPLACE MAG_VALGIC WITH ROUND((M.MAG_QTAKG * M.MAG_PRZCON),2)
	         ELSE
	            REPLACE MAG_VALGIC WITH ROUND((M.MAG_GIACEN * M.MAG_PRZCON),2)
	         ENDIF
	      ENDIF
	   ENDIF
	   REPLACE MAG_DATCAR WITH M.MAG_DATAGG
	   REPLACE MAG_NUMBOB WITH 1
	   REPLACE MAG_CSTFNU WITH M.MAG_CSTFNU
	   REPLACE MAG_CSTADE WITH M.MAG_CSTADE
	   REPLACE MAG_CSTAMQ WITH M.MAG_CSTAMQ
	   REPLACE MAG_FILA_X WITH M.MAG_FILA_X
	   REPLACE MAG_PIAN_X WITH M.MAG_PIAN_X
	   REPLACE MAG_UBIC_X WITH M.MAG_UBIC_X
	
	   _QTA_GIACENZA = _QTA_GIACENZA + MAG_GIACEN
	
	   SELECT U_MAG_GG
	   SKIP +1
	ENDDO
	
	
	_QTA_DA_SPOSTARE = _QTA_GIACENZA - _QTA_DA_TENERE
	
	SELECT CU_MAG_GI
	GO TOP
	SCAN
		SCATTER MEMVAR
		
		IF _QTA_DA_SPOSTARE <= 0
			EXIT
		ENDIF
		
		IF M.MAG_GIACEN <= _QTA_DA_SPOSTARE
			M.MAG_GIADES = M.MAG_GIACEN
		ELSE
			M.MAG_GIADES = MIN(_QTA_DA_SPOSTARE,M.MAG_GIACEN)
		ENDIF
		
		_QTA_DA_SPOSTARE = _QTA_DA_SPOSTARE - M.MAG_GIADES
		
		M.MAG_FILDES_X = ""
		M.MAG_PIADES_X = ""
		M.MAG_UBIDES_X = ""
		M.MAG_FILDES_N = 0
		M.MAG_PIADES_N = 0
		M.MAG_UBIDES_N = 0
		M.MAG_CDMDES   = _C_MAG_SPOSTAMENTO
		M.MAG_DSMDES   = ""
		
		SELECT CU_MAG_GM
		APPEND BLANK
		GATHER MEMVAR MEMO
	ENDSCAN
	
	SELECT CU_MAG_GM
	GO TOP
	IF !EOF()		
		_OK_SPOSTATE = AQM_SPOSTA_GIACENZE_MAGAZZINO("CU_MAG_GM",_V_CAUSCA,_V_CAUCAR,"",_C_MOTIVAZIONE,"",DTOC(DATE()),.F.,.F.,.F.,.F.,.F.,_V_DATAGR)
		IF _OK_SPOSTATE
			_N_ARTICOLI_SPOSTATI = _N_ARTICOLI_SPOSTATI + 1
		ELSE
			MESSAGEBOX("Errore spostamento articolo " + ALLTRIM(_ARTICOLO),64,"Attenzione")
		ENDIF
	ELSE
		
	ENDIF
	
ENDSCAN

WAIT CLEAR

=MESSAGEBOX("Operazione terminata: " + ALLTRIM(STR(_N_ARTICOLI_SPOSTATI)) + " articoli spostati",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN



