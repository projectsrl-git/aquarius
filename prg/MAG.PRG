******************************************************************************************************
PROCEDURE MAG_AGGIORNA_IMPEGNATO  && AGGIORNAMENTO MAGAZZINO IN FASE DI AGGIORNAMENTO DA PAKING LIST
******************************************************************************************************

PARAMETERS _CURSORE,_TABELLA,_SEGNO,_DADOVE

*==> ACCESSO ALLA TABELLA SQL SUL RECORD LEGATO AL CURSORE

x_agga = "daggancio = '" + M.DAGGANCIO + "'"
x_maga = "ord_maga = ord_maga " 
x_lega = "ord_legsys = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
x_cond = x_agga + " and " + x_maga + " and " + x_lega
cSql   = "SELECT * FROM " + ALLTRIM(_TABELLA) + " WHERE " + x_cond
IF !ExecCommand(cSql,"&_TABELLA")
   return(.f.)
ENDIF 
SELECT &_TABELLA
GO TOP
IF EOF()
   RETURN
ENDIF

XXX_QTAEVA = ORD_QTAORD

RELEASE U_AGGORF,U_SYSORF,U_CODORF,U_NUMPED,U_DATPED,U_NUMDDT,U_DATDDT,U_CODCLI
PUBLIC  U_AGGORF,U_SYSORF,U_CODORF,U_NUMPED,U_DATPED,U_NUMDDT,U_DATDDT,U_CODCLI
U_AGGORF = ORD_LEGAME
IF _TABELLA = "U_PCK_DD"
   U_SYSORF = SPACE(10)
ELSE
   U_SYSORF = ORD_LEGASY
ENDIF
U_AGGANC = DAGGANCIO
U_CODORF = ""
U_NUMPED = 0
U_DATPED = SPACE(10)
U_NUMDDT = SPACE(06)
U_DATDDT = SPACE(10)
U_CODCLI = SPACE(10)
IF _TABELLA = "U_PCK_DD"
   U_NUMPED = ORD_NUMPED
   U_DATPED = ORD_DATPED
   U_NUMDDT = ORS_NUMORD
   U_DATDDT = ORS_DATORD
   U_CODCLI = ORS_CODCLI
ENDIF

*==> GESTIONE DEL CASO DI MODIFICA FATTA DALL'UTENTE :
*==> - SE E' STATA MODIFICATA LA SEQUENZA (NUMERO DI RIGA), VIENE ALZATO UN FLAG CHE INDICHERA'
*==>   ALLA FUNZIONE DI CANCELLAZIONE DEI RECORD DI TABELLA CHE DEVE CANCELLARLI TUTTI PERCHE'
*==>   POI VERRANNO REINSERITI CON LA NUOVA SEQUENZA.
*==> - VIENE AGGIORNATO IL RECORD DELLA TABELLA SQL (TRANNE LA SEQUENZA)
*==> - SE NON E' STATO MODIFICATO ALCUN CAMPO "CHIAVE", NON FA NIENTE, ALTRIMENTI VA AVANTI
*==>   PER CONTRAGGIORNARE GLI ARCHIVI DI MAGAZZINO

U_QTA    = ORD_QTAORD
U_LEGAME = ORD_LEGAME 
U_CODSYS = ORD_CODSYS

IF M.ORD_FLGMOD = 'M'
   U_ESCI = .F.
   IF ORD_SEQUEN = M.ORD_SEQUEN
   ELSE
      U_CANCELLA = .T.
   ENDIF
   IF ORD_CODART = M.ORD_CODART .AND. ;
      ORD_MAGA = M.ORD_MAGA .AND. ;
      ORD_QTAORD = M.ORD_QTAORD .AND. ;
      ORD_PRZNET = M.ORD_PRZNET .AND. ;
      ORD_IVA = M.ORD_IVA
      U_ESCI = .T.
   ENDIF
   IF U_CANCELLA
   ELSE
      IF !ExecRW(cSql,"&_TABELLA","R")
         return(.f.)
      ENDIF 
      SELECT &_TABELLA
      M.ORD_SEQUEN = ORD_SEQUEN
      M.ORD_FLGMOD = SPACE(01)
      DO &_TABELLA
      IF !ExecRW(cSql,"&_TABELLA","W")
         return(.f.)
      ENDIF 
   ENDIF
   IF U_ESCI
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_art_pr where " + x_cond
      IF !ExecCommand(cSql,"cur_articoli")
         return(.f.)
      ENDIF
      SELECT cur_articoli
      GO TOP
      IF EOF()
         _CODMAT = '001'
      ELSE
         _CODMAT = ART_CODMAT
      ENDIF
      x_codi = "codice = 'MAT" + _CODMAT + "'"
      Csql   = "select * from para where " + x_codi
      IF !ExecCommand(cSql,"cur_para")
         return(.f.)
      ENDIF
      SELECT cur_para
      GO TOP
      IF EOF()
         V_TIPO = '0'
      ELSE
         V_TIPO = SUBSTR(LIBERA,1,1)
      ENDIF  
      IF V_TIPO = '1' .OR. V_TIPO = '2'
      ELSE
         RETURN
      ENDIF
   ENDIF
ENDIF

*==> GESTIONE DEL CASO DI CANCELLAZIONE FATTA DALL'UTENTE :
*==> - VIENE CANCELLATO IL RECORD SULLA TABELLA SQL E POI VA AVANTI PER CONTRAGGIORNARE 
*==>   GLI ARCHIVI DI MAGAZZINO

IF M.ORD_FLGMOD = 'A'
   IF !ExecRW(cSql,"&_TABELLA","R")
      return(.f.)
   ENDIF 
   SELECT &_TABELLA
   DELETE
   IF !ExecRW(cSql,"&_TABELLA","W")
      return(.f.)
   ENDIF 
ENDIF


RETURN

*==> LOOP SU TUTTI GLI ARTICOLI PER IL CONTROAGGIORNAMENTO DELLA QUANTITA' IMPEGNATA

   
SELECT U_MAG_MO
GO TOP
*BROWSE normal
                     
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO

   IF M.MOV_SEGNO = '+'
      _SEGNO = '-'
   ELSE
      IF M.MOV_SEGNO = '-'
         _SEGNO = '+'
      ENDIF
   ENDIF

   =GESTIONE_QTA_IMEGNATA_PER_ARTICOLO_MAGAZZINO_FORNITORE_DI_CARICO()
   =GESTIONE_QTA_IMEGNATA_PER_DATA_ARTICOLO_MAGAZZINO_FORNITORE_DI_CARICO()
   =CREA_IL_MOVIMENTO_DI_CANCELLATO_SU_NUOVO_ARCHIVIO()
   
   SELECT U_MAG_MO

   U_AGGIORNA = .T.
      
   SKIP +1
      
ENDDO


RETURN



**********************************************************************************
FUNCTION GESTIONE_QTA_IMEGNATA_PER_ARTICOLO_MAGAZZINO_FORNITORE_DI_CARICO
**********************************************************************************

   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci   = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data   = "mag_datagg = '" + SPACE(10) + "'"
   x_codi   = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga   = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn   = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_cpdv   = "mag_codpdv = '" + ALLTRIM(CS_CODPDV) + "'"
   IF M.MOV_CODMAG = 'VIAGGI'
      M.MOV_CODPDV = CS_CODPDV
      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_cpdv
   ELSE
      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
   ENDIF
   Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH SPACE(10)
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
      ENDIF
      REPLACE MAG_PRZCON WITH 0
      REPLACE MAG_UNIQUE WITH SYS(2015)
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
  ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.
   IF M.MOV_CODMAG = 'VIAGGI'
      IF ZZZ_FLGTIP = 2
         REPLACE MAG_FLGVIA WITH .T.
      ENDIF
   ENDIF
   IF !ExecRw(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF



RETURN





**********************************************************************************
FUNCTION GESTIONE_QTA_IMEGNATA_PER_DATA_ARTICOLO_MAGAZZINO_FORNITORE_DI_CARICO
**********************************************************************************


   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci     = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data     = "mag_datagg = '" + ALLTRIM(M.MOV_DATSCA) + "'"
   x_codi     = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga     = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn     = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_tipo     = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   XXX_PRZACQ = M.MOV_PREACQ
   XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
   x_prez     = "mag_przcon = " + XX_PRZACQ
   x_cide     = "mag_numide = '" + ALLTRIM(M.MOV_NUMIDE) + "'"
   x_cpdv     = "mag_codbun = '" + ALLTRIM(M.MOV_CODBUN) + "'"
   x_anno     = "mag_anno = '" + ALLTRIM(M.MOV_ANNO) + "'"
   x_xpdv      = "mag_codpdv = '" + ALLTRIM(CS_CODPDV) + "'"
   IF M.MOV_CODMAG = 'VIAGGI'
      M.MOV_CODPDV = CS_CODPDV
      x_cond       = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                     x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                     x_cpdv + " and " + x_anno + " and " + x_xpdv
   ELSE
      x_cond       = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                     x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                     x_cpdv + " and " + x_anno
   ENDIF
   Csql       = "select * from u_mag_gg where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH MAG_QTAKG + M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH MAG_QTAML + M.MOV_QTAML
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH MAG_QTAKG - M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH MAG_QTAML - M.MOV_QTAML
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH M.MOV_DATSCA
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH M.MOV_QTAML
      ELSE
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
         REPLACE MAG_QTAKG  WITH M.MOV_QTAKG * -1
         REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ * -1
         REPLACE MAG_QTAML  WITH M.MOV_QTAML * -1
      ENDIF
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
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.
   IF M.MOV_CODMAG = 'VIAGGI'
      IF ZZZ_FLGTIP = 2
         REPLACE MAG_FLGVIA WITH .T.
      ENDIF
   ENDIF
   RELEASE QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
           QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
   PUBLIC  QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
           QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
   QWE_FORNIT = MAG_FORNIT
   QWE_DESFOR = MAG_DESFOR
   QWE_CODACQ = MAG_CODACQ
   QWE_DESACQ = MAG_DESACQ
   QWE_PRZCON = MAG_PRZCON
   QWE_PAGAME = MAG_PAGAME
   QWE_LEGAME = MAG_LEGAME 
   QWE_NUMIDE = MAG_NUMIDE
   QWE_CODBUN = MAG_CODBUN
   QWE_ANNO   = MAG_ANNO
   IF !ExecRW(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF





RETURN



**********************************************************************************
FUNCTION CREA_IL_MOVIMENTO_DI_CANCELLATO_SU_NUOVO_ARCHIVIO
**********************************************************************************

   * CREA IL MOVIMENTO DI CANCELLATO SU NUOVO ARCHIVIO ---------------------------
   Csql   = "select * from u_mag_ca where 1=0"
   IF !ExecRW(cSql,"U_MAG_CA","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_CA
   APPEND BLANK
   DO U_MAG_MO
   REPLACE MOV_FLGTRA WITH .F.
   IF !ExecRW(cSql,"U_MAG_CA","W")
      return(.f.)
   ENDIF



RETURN
