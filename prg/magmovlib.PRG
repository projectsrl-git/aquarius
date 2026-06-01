
*** ##############################################################################################

*** **********************************************************************************************
*** ***         PROJECT SRL - LIBRERIA DELLE APPLICAZIONI PER MAGAZZINO E MOVIMENTI            ***
*** ***                                                                                        ***
*** **********************************************************************************************

*** ##############################################################################################



****************************************************************************************
PROCEDURE RIGENERA_MOV_DA_BOL
****************************************************************************************

PARAMETERS _ARCH_DD

SELECT &_ARCH_DD
GO TOP
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
      SELECT &_ARCH_DD
      SKIP +1
      LOOP
   ENDIF

   * SI CREA LE VARIABILI DAL RECORD
   *SCATTER MEMVAR MEMO

*!*	   IF V_PRIMARICERCA = .T.								&& RINO 20/10/2006
*!*	      V_PRIMARICERCA = .F.								&& RINO 20/10/2006
*!*	      PUB_NUMCSI = RILEVA_NUMERO_INTERNO()				&& RINO 20/10/2006
*!*	   ENDIF												&& RINO 20/10/2006

   PUB_NUMCSI = ''

   SELECT &_ARCH_DD
   SCATTER MEMVAR MEMO
   
   RELEASE XYZ_FORNIT,XYZ_RAGSOC,XYZ_PRZUCA,XYZ_RAGFOR
   PUBLIC  XYZ_FORNIT,XYZ_RAGSOC,XYZ_PRZUCA,XYZ_RAGFOR
   XYZ_FORNIT = M.ORD_FORNIT
   XYZ_RAGSOC = M.ORD_RAGFOR 
   XYZ_PRZUCA = M.ORD_PRZULC
   XYZ_RAGFOR = M.ORD_RAGFOR
   
   _TOPSCA = M.ORD_CAUS
   IMPE     = ""

   v_seek   = 'TOP'+M.ORD_CAUS
   v_chiave = "codice"
   *** CONTROCAUSALE DI CARICO
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      IMPE    = SUBSTR(LIBERA,26,1)
	  ** SERGIO 19/11/2021 INIZIO 
   	  * _TOPCAR = SUBSTR(LIBERA,35,3)
	  _TOPCAR = CERCA_CAUSALI_TOP(M.ORD_CAUS,'CONCAU')	&& CAUSALE CONTRARIA A QUELLA DIGITATA
	  ** SERGIO 19/11/2021 FINE  
   ELSE
      _TOPCAR = '100 '  
   ENDIF
   
   IF EMPTY(_TOPCAR) .OR. _TOPCAR = SPACE(03)
      _TOPCAR = '100 '  
   ENDIF
   
   *** ELIMINO IL VECCHIO MOVIMENTO LEGATO AL DETTAGLIO DDT
   x_lega = "mov_legsys = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
   x_cond = x_lega
   Csql = "delete FROM U_MAG_MO where " + x_cond
   IF !ExecCommand(cSql,'DEL_MAG_MO')
      return(.f.)
   ENDIF
   
   *** AGGIORNO IL CAMPO DI LEGAME MOVIMENTI CON IL NUOVO VALORE
   SELECT &_ARCH_DD
   M.ORD_LEGSYS = SYS(2015)
   REPLACE ORD_LEGSYS WITH M.ORD_LEGSYS
   x_uniq = "id_unique = '" + ALLTRIM(M.ID_UNIQUE) + "'"
   x_cond = x_uniq 
   Csql = "update U_BOL_DD set ord_legsys = '" + M.ORD_LEGSYS + "' where " + x_cond
   IF !ExecCommand(cSql,'UPD_BOL_DD')
      return(.f.)
   ENDIF
   
   *** ELIMINO I DETTAGLI DI TERZO LIVELLO LEGATI AL DETTAGLIO DDT
   x_lega = "leg_sysbol = '" + ALLTRIM(M.ORD_CODSYS) + "'"
   x_cond = x_lega
   Csql = "delete FROM U_BOL_LE where " + x_cond
   IF !ExecCommand(cSql,'DEL_BOL_LE')
      return(.f.)
   ENDIF
   
   SELECT &_ARCH_DD
   
   **=> ERASMO - INIZIO 16/03/2009
   *** SCRIVE IL MOVIMENTO DI CARICO MATERIALE (GENERICO) DA PRODUZIONE
   A_DESART = ""
   A_UNIMIS = ""
   A_PRZCOS = 0
   A_PRZVEN = 0
   A_CODIVA = ""
   A_CODTAG = ""
   A_DESTAG = ""
   A_CODCOL = ""
   A_DESCOL = ""
   A_COORD  = ""
   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + ALLTRIM(M.ORD_CODART) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"CXX_ART_PR")
      return(.f.)
   ENDIF
   SELECT CXX_ART_PR
   GO TOP
   IF !EOF()
      A_DESART = ART_DESCR
      A_UNIMIS = ART_UNIMIS
      A_PRZCOS = ART_PRZCOS
      A_PRZVEN = ART_PRZVEN
      A_CODIVA = ART_CODIVA
      A_CODTAG = ART_CODTAG
      A_DESTAG = ART_DESTAG
      A_CODCOL = ART_CODCOL
      A_DESCOL = ART_DESCOL
      A_COORD  = ART_COORD
      A_TIPART = ART_TIPART
   ENDIF

   Csql   = "select * from u_mag_mo where 1=0"
   IF !ExecRW(cSql,"U_MAG_MO","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_MO
   APPEND BLANK
   REPLACE MOV_CODSOC WITH PUB_CODSOC
   REPLACE MOV_CODMAG WITH M.ORD_MAGA
   REPLACE MOV_CODART WITH M.ORD_CODART
   REPLACE MOV_ANAART WITH M.ORD_CODART
   REPLACE MOV_DESART WITH M.ORD_DESART
   REPLACE MOV_TOP    WITH 'CAP'  && CARICO AVANZAMENTO PRODUZIONE
   REPLACE MOV_QTAMOV WITH M.ORD_QTAORD
   REPLACE MOV_PREVEN WITH M.ORD_PRZNET
   REPLACE MOV_PREACQ WITH 0
   REPLACE MOV_IVAVEN WITH M.ORD_IVA
   REPLACE MOV_VALUTA WITH PUB_VALRIF
   IF M.ORD_PREZZO <= 0
      __SCONTO = 0
   ELSE
	  __SCONTO = ((M.ORD_PREZZO - M.ORD_PRZNET) / M.ORD_PREZZO) * 100
   ENDIF	  
   REPLACE MOV_SCONTO WITH __SCONTO
   REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
   REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
   REPLACE MOV_NUMDOC WITH M.ORD_NUMORD
   REPLACE MOV_DTDOCU WITH M.ORD_DATORD
   REPLACE MOV_CODFOR WITH PUB_CFDEF
   REPLACE MOV_RAGSOC WITH PUB_DESSOC
   REPLACE MOV_DTREGI WITH M.ORD_DATORD
   REPLACE MOV_CODTAG WITH A_CODTAG
   REPLACE MOV_DESTAG WITH A_DESTAG
   REPLACE MOV_CODCOL WITH A_CODCOL
   REPLACE MOV_DESCOL WITH A_DESCOL
   REPLACE MOV_NOTVAR WITH ""
   REPLACE MOV_UM     WITH M.ORD_UM
   REPLACE MOV_CODPDV WITH PUB_CODBUN
   REPLACE MOV_ORAMOV WITH "11:59:59"
   REPLACE MOV_SEGNO  WITH "+"
   REPLACE MOV_TIPMOV WITH ""
   REPLACE MOV_FORNIT WITH PUB_CFDEF
   REPLACE MOV_DESFOR WITH PUB_DESSOC
   REPLACE MOV_COORD  WITH A_COORD
   REPLACE MOV_FLGTRA WITH .F.
   REPLACE MOV_LEGSYS WITH M.ORD_LEGSYS
*!*	   REPLACE MOV_LEGAME WITH M.ALT_LEGAME
*!*	   REPLACE MOV_PAGAME WITH M.ALT_PAGAME
*!*	   REPLACE MOV_CODACQ WITH M.ALT_CODACQ
*!*	   REPLACE MOV_NUMORF WITH M.ALT_NUMORF
*!*	   REPLACE MOV_DATORF WITH M.ALT_DATORF
*!*	   REPLACE MOV_SC1    WITH M.ALT_SC1
*!*	   REPLACE MOV_SC2    WITH M.ALT_SC2
*!*	   REPLACE MOV_SC3    WITH M.ALT_SC3
*!*	   REPLACE MOV_NUMIDE WITH M.ALT_NUMIDE
*!*	   REPLACE MOV_CODBUN WITH M.ALT_CODBUN
   REPLACE MOV_ANNO WITH SUBSTR(MOV_DTREGI,1,4)
   REPLACE MOV_DATSCA WITH ""
   REPLACE MOV_UNIQUE WITH SYS(2015)
   REPLACE MOV_TIPART WITH A_TIPART 
   REPLACE MOV_TIPTRA WITH ""
   REPLACE MOV_SYSGGG WITH ""
   REPLACE MOV_SYSGGS WITH ""
   REPLACE MOV_SYSDAG WITH ""
   REPLACE MOV_SYSDAS WITH ""
   REPLACE MOV_CODOPE WITH PUB_CODOPE
   REPLACE MOV_NOMOPE WITH PUB_NOMOPE
   REPLACE MOV_CODCLI WITH M.ORD_CODCLI
   REPLACE MOV_DESCLI WITH M.ORD_RAGSOC
   IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
      REPLACE MOV_QTAMQ  WITH 0
      REPLACE MOV_QTAKG  WITH 0
      REPLACE MOV_QTAML  WITH 0
      REPLACE MOV_QTAMQA WITH 0
      REPLACE MOV_QTAMLA WITH 0
      REPLACE MOV_QTAKGA WITH 0
   ENDIF
   REPLACE MOV_FILA_X WITH ""
   REPLACE MOV_PIAN_X WITH ""
   REPLACE MOV_UBIC_X WITH ""
   REPLACE MOV_FILA_N WITH 0
   REPLACE MOV_PIAN_N WITH 0
   REPLACE MOV_UBIC_N WITH 0
   REPLACE MOV_CSTMAN WITH 0
   REPLACE MOV_CSTSCA WITH 0
   REPLACE MOV_NUMMOV WITH PUB_NUMCSI
   IF !ExecRW(cSql,"U_MAG_MO","W")
      return(.f.)
   ENDIF
   **=> ERASMO - FINE 16/03/2009
   
   RELEASE V_STD
   PUBLIC  V_STD
   V_STD = .T.
      
   IF V_STD
      H_DADOVE = 'BOLSCMAG'
      H_GENMOV = 'SI' 
      H_TIPO   = 'GIA'
      H_IMPE   = IMPE
      H_MAGSCA = M.ORD_MAGA
      H_MAGCAR = M.ORD_MAGD
      H_CODART = M.ORD_CODART
      H_TOPSCA = _TOPSCA
      H_TOPCAR = _TOPCAR
      H_QUANTI = M.ORD_QTAORD
      H_NUMDOC = M.ORD_NUMORD
      H_DATDOC = M.ORD_DATORD
      H_DATREG = M.ORD_DATORD
      H_ORAMOV = "12:00:00"
      H_CLIFOR = M.ORD_CODCLI
      H_PRZACQ = M.ORD_PRZCON
      H_PRZVEN = M.ORD_PRZNET
      H_CODIVA = M.ORD_IVA
      H_SCONTO = M.ORD_SC1
      H_VALUTA = M.ORD_VALUTA
      H_NOTE   = ""
      H_CSC    = M.ORD_CODCLI
      H_GGG    = "SI"
      H_FORNIT = M.ORD_FORNIT
      H_FLGTRA = .F.
      H_LEGSYS = M.ORD_LEGSYS
      H_LEGAME = M.ORD_CODACQ
      =MOVIMAGAZ(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_GGG,H_FORNIT,H_FLGTRA,H_LEGSYS,H_LEGAME)
   ENDIF

*!*	   **  Lancio procedura di carico/scarico componenti in automatico se TOP lo prevede
*!*	   IF CSC = 'X'
*!*	      SSSS=SELECT()
*!*	      x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
*!*	      x_codi = "dit_gruppo = '" + ALLTRIM(M.ORD_CODART) + "'"
*!*	      x_cond = x_soci + " and " + x_codi
*!*	      Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
*!*	      IF !ExecCommand(cSql,"cur_diba")
*!*	         return(.f.)
*!*	      ENDIF
*!*	      SELECT cur_diba
*!*	      GO TOP
*!*	      IF EOF()
*!*	      ELSE
*!*	         TP = 'S'
*!*	         RELEASE W_MAGAZ,W_QUANTI
*!*	         PUBLIC  W_MAGAZ,W_QUANTI
*!*	         W_MAGAZ  = M.ORD_MAGA
*!*	         W_QUANTI = M.ORD_QTAORD
*!*	         DO ALBERELLO WITH .F.,M.ORD_CODART
*!*	         DO CARI_COMP WITH "BOL"
*!*	      ENDIF
*!*	      SELECT(SSSS)
*!*	   ENDIF

   _CONTA = _CONTA + 1

   SELECT &_ARCH_DD
   SKIP +1

ENDDO

RETURN



****************************************************************************************
PROCEDURE RIGENERA_MAG_DA_MOV
****************************************************************************************

WAIT WINDOWS "Lettura saldi movimenti riepilogati per Codice articolo Interno..." NOWAIT

x_aart = IIF(EMPTY(ALLTRIM(_V_CODART)),"mov_anaart = mov_anaart","mov_anaart = '" + ALLTRIM(_V_CODART) + "'")
x_nrlt = "MOV_NRLINT > 0"
x_cart = "MOV_CODART <> ''"
x_cond = x_aart + " and " + x_nrlt + " and " + x_cart 
Csql = "SELECT MOV_CODART AS CODINT,SUM(CASE MOV_SEGNO WHEN '-' THEN (-MOV_QTAMOV) ELSE MOV_QTAMOV END) AS SALDO_MOV,0.000000 AS GIACENZA " + ;
	"FROM U_MAG_MO WHERE " + x_cond + " GROUP BY MOV_CODART ORDER BY MOV_CODART"
IF !ExecCommand(cSql,'CUR_RIEP_MOV')
	return(.f.)
ENDIF
SELECT CUR_RIEP_MOV
GO TOP
DO WHILE .T.
	IF EOF()
		EXIT
	ENDIF
	IF DELETED()
		SKIP +1
		LOOP
	ENDIF
	
	WAIT WINDOWS "Lettura giacenze attuali per Codice articolo Interno - Articolo " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ;
		ALLTRIM(STR(RECCOUNT(),10,0)) + " (" + ALLTRIM(CODINT) + ")" NOWAIT
	
	_CODINT = CODINT
	_GIACENZA = 0
	x_cint = "MAG_CODART = '" + ALLTRIM(_CODINT) + "'"
	x_data = "MAG_DATAGG <> ''"
	x_cond = x_cint + " and " + x_data 
	Csql = "SELECT MAG_GIACEN FROM U_MAG_GG WHERE " + x_cond
	IF !ExecCommand(cSql,'CX_GIACENZA')
		return(.f.)
	ENDIF
	SELECT CX_GIACENZA
	GO TOP
	SCAN
		_GIACENZA = _GIACENZA  + MAG_GIACEN
	ENDSCAN
	
	SELECT CUR_RIEP_MOV
	REPLACE GIACENZA WITH _GIACENZA	
	
	SELECT CUR_RIEP_MOV
	SKIP +1
ENDDO

SELECT CUR_RIEP_MOV
GO TOP
DO WHILE .T.
	IF EOF()
		EXIT
	ENDIF
	IF DELETED()
		SKIP +1
		LOOP
	ENDIF
	
	WAIT WINDOWS "Analisi e correzione disallineamenti movimenti/giacenze - Articolo " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ;
		ALLTRIM(STR(RECCOUNT(),10,0)) + " (" + ALLTRIM(CODINT) + ")" NOWAIT
	
	_CODINT = CODINT
	_SALDO_MOV = SALDO_MOV
	
	_TOT_ARTICOLI_ELABORATI = _TOT_ARTICOLI_ELABORATI + 1
	
	IF SALDO_MOV = GIACENZA
		_TOT_MOVGIAC_ALLINEATI = _TOT_MOVGIAC_ALLINEATI + 1
		SELECT CUR_RIEP_MOV
		SKIP +1
		LOOP
	ENDIF
	
	IF _SALDO_MOV <= 0
		
		*** CANCELLO LA GIACENZA
		x_cint = "MAG_CODART = '" + ALLTRIM(_CODINT) + "'"
		x_data = "MAG_DATAGG <> ''"
		x_cond = x_cint + " and " + x_data 
		Csql = "DELETE FROM U_MAG_GG WHERE " + x_cond
		IF !ExecCommand(cSql,'DEL_U_MAG_GG')
			return(.f.)
		ENDIF
		
		IF _SALDO_MOV < 0
			*** SCRIVO IL MOVIMENTO DI RETTIFICA POSITIVO, PRENDENDO COME RIFERIMENTO L'ULTIMA RIGA DI MOVIMENTO DI SCARICO
			x_cint = "MOV_CODART = '" + ALLTRIM(_CODINT) + "'"
			x_segn = "MOV_SEGNO = '-'"
			x_cond = x_cint
			Csql = "SELECT * FROM U_MAG_MO WHERE " + x_cond + " ORDER BY MOV_DTREGI DESC, MOV_ORAMOV DESC"
			IF !ExecRW(cSql,'U_MAG_MO',"R")
				return(.f.)
			ENDIF
			SELECT U_MAG_MO
			GO TOP
			IF EOF()
			ELSE
				SCATTER MEMVAR MEMO
				SELECT U_MAG_MO
				APPEND BLANK
				M.MOV_TOP = "FL+"
				M.MOV_SEGNO = "+"
				M.MOV_NUMDOC = "000000"
				M.MOV_QTAMOV = ABS(_SALDO_MOV)
				M.MOV_UNIQUE = SYS(2015)
				DO U_MAG_MO
				_TOT_MOVIMENTI_RETTIFICATI = _TOT_MOVIMENTI_RETTIFICATI + 1
			ENDIF
			IF !ExecRW(cSql,'U_MAG_MO',"W")
				return(.f.)
			ENDIF
		ENDIF

	ELSE
		
		x_cint = "MAG_CODART = '" + ALLTRIM(_CODINT) + "'"
		x_data = "MAG_DATAGG <> ''"
		x_cond = x_cint + " and " + x_data 
		Csql = "SELECT * FROM U_MAG_GG WHERE " + x_cond
		IF !ExecRW(cSql,'U_MAG_GG',"R")
			return(.f.)
		ENDIF
		SELECT U_MAG_GG
		GO TOP
		IF EOF()
			*** SCRIVO LA GIACENZA, PRENDENDO COME RIFERIMENTO L'ULTIMA RIGA DI MOVIMENTO DI CARICO
			x_cint = "MOV_CODART = '" + ALLTRIM(_CODINT) + "'"
			x_segn = "MOV_SEGNO = '+'"
			x_cond = x_cint
			Csql = "SELECT * FROM U_MAG_MO WHERE " + x_cond + " ORDER BY MOV_DTREGI DESC, MOV_ORAMOV DESC"
			IF !ExecCommand(cSql,'CX_MAG_MO')
				return(.f.)
			ENDIF
			SELECT CX_MAG_MO
			GO TOP
			IF EOF()
			ELSE
				SCATTER MEMVAR MEMO
				SELECT U_MAG_GG
				APPEND BLANK
				REPLACE MAG_CODSOC WITH PUB_CODSOC
				REPLACE MAG_DATAGG WITH M.MOV_DATSCA
				REPLACE MAG_CODMAG WITH M.MOV_CODMAG
				REPLACE MAG_CODART WITH M.MOV_CODART
				REPLACE MAG_DESART WITH M.MOV_DESART
				REPLACE MAG_CODPDV WITH M.MOV_CODPDV
				REPLACE MAG_FORNIT WITH M.MOV_FORNIT
				REPLACE MAG_DESFOR WITH M.MOV_DESFOR
				REPLACE MAG_GIACEN WITH _SALDO_MOV
				REPLACE MAG_QTAKG  WITH 0
				REPLACE MAG_QTAMQ  WITH 0
				REPLACE MAG_QTAML  WITH 0
				REPLACE MAG_PRZCON WITH M.MOV_PREACQ
				REPLACE MAG_LEGAME WITH M.MOV_LEGAME
				REPLACE MAG_CODACQ WITH M.MOV_CODACQ
				REPLACE MAG_PAGAME WITH M.MOV_PAGAME
				REPLACE MAG_UNIQUE WITH SYS(2015)
				REPLACE MAG_NUMIDE WITH M.MOV_NUMIDE
				REPLACE MAG_CODBUN WITH M.MOV_CODBUN
				REPLACE MAG_ANNO   WITH M.MOV_ANNO
				REPLACE MAG_CODMAT WITH M.MOV_CODMAT
				REPLACE MAG_DESMAT WITH M.MOV_DESMAT
				REPLACE MAG_CODCOL WITH M.MOV_CODCOL
				REPLACE MAG_DESCOL WITH M.MOV_DESCOL
				REPLACE MAG_SPESSO WITH M.MOV_SPESSO
				REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
				REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
				REPLACE MAG_NRLINT WITH M.MOV_NRLINT
				REPLACE MAG_ANAART WITH M.MOV_ANAART
				REPLACE MAG_TIPART WITH M.MOV_TIPART
				REPLACE MAG_FILA_X WITH M.MOV_FILA_X 
				REPLACE MAG_PIAN_X WITH M.MOV_PIAN_X 
				REPLACE MAG_UBIC_X WITH M.MOV_UBIC_X 
				REPLACE MAG_FILA_N WITH M.MOV_FILA_N 
				REPLACE MAG_PIAN_N WITH M.MOV_PIAN_N 
				REPLACE MAG_UBIC_N WITH M.MOV_UBIC_N 
			ENDIF
			
		ELSE
			*** AGGIORNO LA GIACENZA, ELIMINANDO EVENTUALI ALTRE RIGHE DI GIACENZA IN ECCESSO
			SCAN
				IF RECNO() = 1
					REPLACE MAG_GIACEN WITH _SALDO_MOV
				ELSE
					DELETE
				ENDIF
			ENDSCAN
		ENDIF
		IF !ExecRW(cSql,'U_MAG_GG',"W")
			return(.f.)
		ENDIF
	
	ENDIF

	_TOT_MOVGIAC_DISALLINEATI = _TOT_MOVGIAC_DISALLINEATI + 1
	
	SELECT CUR_RIEP_MOV
	SKIP +1
ENDDO

WAIT CLEAR

RETURN