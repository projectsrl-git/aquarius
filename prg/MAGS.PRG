************************************************************************************
PROCEDURE BOLRESISC  && SCARICA IL MAGAZZINO (FASE DI AGGIORNAMENTO GESTIONALE)
************************************************************************************

SELECT CU_PCK_DD
SET FILTER TO
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
      SKIP +1
      LOOP
   ENDIF

   IF ORD_FLGMOD = 'A' .OR. ORD_FLGMOD = 'M'
   ELSE
      IF ORD_FLGMOD = 'I' 
         U_AGGIORNA = .T.
      ENDIF
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO

  
   _CURSORE 	= "CU_PCK_DD"
   _TABELLA		= "U_PCK_DD"
   _DADOVE		= "PCK"

   =MAG_GESTIONE_IMPEGNATO(_CURSORE,_TABELLA,"-",_DADOVE,M.ORD_QTAORD) && SCARICA IMPEGNATO CON LA QTA DELLA TABELLA ORIGINALE
         


   SELECT CU_PCK_DD
   SKIP +1
   
ENDDO

RETURN



















****##############################################################################################################‡‡

*!*	      DO MAG_SCARICA_IMPEGNATO WITH "CU_PCK_DD","U_PCK_DD","-","PCK"
**********************************************************************************
FUNCTION MAG_SCARICA_IMPEGNATO
**********************************************************************************
PARAMETERS _CURSORE,_TABELLA,_SEGNO,_DADOVE

SELECT &_CURSORE
GO TOP
DO WHILE .not.eof()

	SCATTER MEMVAR memo
	

	SELECT &_CURSORE
	SKIP +1
	
ENDDO




RETURN 

**********************************************************************************
FUNCTION GESTIONE_QTA_IMEGNATA_PER_ARTICOLO_MAGAZZINO_FORNITORE_DI_CARICO
**********************************************************************************

   x_soci   = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data   = "mag_datagg = '" + SPACE(10) + "'"
   x_codi   = "mag_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
   x_maga   = "mag_codmag = '" + ALLTRIM(M.ORD_CODMAG) + "'"
   x_forn   = "mag_fornit = '" + ALLTRIM(M.ORD_FORNIT) + "'"
   x_cpdv   = "mag_codpdv = '" + SPACE(10) + "'"

   x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
   Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF

   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.ORD_QTAORD
      ELSE
         REPLACE MAG_QTAIMP WITH MAG_QTAIMP - M.ORD_QTAORD
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH SPACE(10)
      REPLACE MAG_CODMAG WITH M.ORD_CODMAG
      REPLACE MAG_CODART WITH M.ORD_CODART
      REPLACE MAG_DESART WITH M.ORD_DESART
      REPLACE MAG_CODPDV WITH SPACE(10)				&& RINO
      REPLACE MAG_FORNIT WITH M.COD_FORNIT
      REPLACE MAG_DESFOR WITH SPACE(30)				&& RINO
      IF _SEGNO = '+'
         REPLACE MAG_QTAIMP WITH M.ORD_QTAORD
      ELSE
         REPLACE MAG_QTAIMP WITH M.ORD_QTAORD * -1
      ENDIF
      REPLACE MAG_PRZCON WITH 0
      REPLACE MAG_UNIQUE WITH SYS(2015)
      REPLACE MAG_CODMAT WITH M.ORD_CODMAT
      REPLACE MAG_DESMAT WITH M.ORD_DESMAT
      REPLACE MAG_CODCOL WITH M.ORD_CODCOL
      REPLACE MAG_DESCOL WITH M.ORD_DESCOL
      REPLACE MAG_SPESSO WITH M.ORD_SPESSO
      REPLACE MAG_ALTEZZ WITH M.ORD_ALTEZZ
      REPLACE MAG_LUNGHE WITH M.ORD_LUNGHE
      
*!*	      REPLACE MAG_NRLINT WITH M.ORD_NRLINT	&& RINO
*!*	      REPLACE MAG_ANAART WITH M.ORD_ANAART	&& RINO
*!*	      REPLACE MAG_TIPART WITH M.ORD_TIPART	&& RINO

   ENDIF
  
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.


   IF !ExecRw(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF



RETURN





**********************************************************************************
FUNCTION GESTIONE_QTA_IMPEGNATA_PER_DATA_ARTICOLO_MAGAZZINO_FORNITORE_DI_CARICO
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

