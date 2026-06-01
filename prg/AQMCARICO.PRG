
*!*	*!*	____________________________________________________________________________________________________________________ CREA U_MAG_GG PER LA QTA DELTA TOTALE RICARICATO
*!*	=AQM_VALORIZZA_VARIABILI_MAGAZZINO("AQMLIB_MIVIMENTO_MAGAZZINO")

*!*	_FUNZIONE  = "CREA-U-MAG-GG"
*!*	_IMPEGNI   = "NON-AGGIORNA-IMPEGNI"
*!*	_MOVIMENTO = "NON-CREA-MOVIMENTO"
*!*	_IDUNIQUE  = ""
*!*	_SEGNO     = "+"

*!*	AQM_GIACEN  = LOCAL_DELTA_QTA_DA_SCARICARE_QTAORD 
*!*	AQM_QTAMQ	= LOCAL_DELTA_QTA_DA_SCARICARE_QTAMQ 
*!*	AQM_QTAKG	= LOCAL_DELTA_QTA_DA_SCARICARE_QTAKG 
*!*	AQM_QTAML	= LOCAL_DELTA_QTA_DA_SCARICARE_QTAML	


*!*	=AQM_MAGACS(_FUNZIONE,_IMPEGNI,_MOVIMENTO,_IDUNIQUE,_SEGNO)	



	*!*		Csql = "select * from u_mag_gg where 1=0"
	*!*		IF !ExecRW(Csql,"u_mag_gg","R")
	*!*		   return(.f.)
	*!*		ENDIF

	*!*	    SELECT u_mag_gg
	*!*	    APPEND BLANK
	*!*	    REPLACE MAG_CODSOC WITH PUB_CODSOC
	*!*	    REPLACE MAG_DATAGG WITH AQM_DATAGG 
	*!*	    REPLACE MAG_CODMAG WITH AQM_CODMAG 
	*!*	    REPLACE MAG_CODART WITH AQM_CODART 
	*!*	    REPLACE MAG_DESART WITH AQM_DESART
	*!*	    REPLACE MAG_CODPDV WITH AQM_CODPDV
	*!*	    REPLACE MAG_FORNIT WITH AQM_CODFOR
	*!*	    REPLACE MAG_DESFOR WITH AQM_DESFOR
	*!*	    REPLACE MAG_GIACEN WITH AQM_GIACEN * (-1)
	*!*	    REPLACE MAG_QTAKG  WITH AQM_QTAKG  * (-1)
	*!*	    REPLACE MAG_QTAMQ  WITH AQM_QTAMQ  * (-1)
	*!*	    REPLACE MAG_QTAML  WITH AQM_QTAML  * (-1)
	*!*	    REPLACE MAG_PRZCON WITH AQM_PRZCON
	*!*	    REPLACE MAG_UNIQUE WITH SYS(2015)
	*!*	    IF EMPTY(ALLTRIM(MAG_ANNO))
	*!*	      REPLACE MAG_ANNO WITH SUBSTR(MAG_DATAGG,1,4)
	*!*	    ENDIF
	*!*	    REPLACE MAG_FILA_X WITH AQM_FILA_X
	*!*	    REPLACE MAG_PIAN_X WITH AQM_PIAN_X
	*!*	    REPLACE MAG_UBIC_X WITH AQM_UBIC_X
	*!*	    REPLACE MAG_FILA_N WITH AQM_FILA_N
	*!*	    REPLACE MAG_PIAN_N WITH AQM_PIAN_N
	*!*	    REPLACE MAG_UBIC_N WITH AQM_UBIC_N
	*!*	    REPLACE MAG_ANAART WITH AQM_ANAART
	*!*	    
	*!*		IF !ExecRW(cSql,"U_MAG_GG","W")		&& AGGIORNA U_MAG_GG
	*!*		   return(.f.)
	*!*		ENDIF






*****************************
FUNCTION AQM_CARICA_MAGAZZINO        
*****************************

SS=STR(SELECT())

*!*	____________________________________________________________________________________________________________________ RICERCA DELLA RAGIONE SOCIALE DEL FORNITORE 
x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + ALLTRIM(AQM_CODFOR) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"u_for_an")
   return(.f.)
ENDIF
SELECT u_for_an
GO TOP
IF !EOF()
   AQM_DESFOR = for_ragsoc
ELSE 
   AQM_DESFOR = ""
ENDIF

*!*	____________________________________________________________________________________________________________________ RICERCA DELLA DESCRIZIONE ARTICOLO 
x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(aqm_anaart) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"u_art_pr")
   return(.f.)
ENDIF
SELECT u_art_pr
GO TOP
IF !EOF()
   aqm_desart = art_descr
ELSE 
   aqm_desart = ""
ENDIF



_x_soci 	= "mag_codsoc = '" + aqm_codsoc + "'"
_x_data 	= "mag_datagg = '" + aqm_datagg + "'"
_x_codi 	= "mag_anaart = '" + ALLTRIM(aqm_anaart) + "'"
_x_maga 	= "mag_codmag = '" + ALLTRIM(aqm_codmag) + "'"
_x_forn 	= "mag_fornit = '" + ALLTRIM(AQM_CODFOR) + "'"
_x_giac 	= "mag_giacen > 0"
_x_fila 	= "mag_fila_n = " + ALLTRIM(STR(aqm_fila_n,5,0))
_x_pian 	= "mag_pian_n = " + ALLTRIM(STR(aqm_pian_n,5,0))
_x_ubic 	= "mag_ubic_n = " + ALLTRIM(STR(aqm_ubic_n,5,0))
_przacq     = aqm_przcon
xx_przacq   = alltrim(str(_przacq,17,6))
xx_przacq   = strtran(xx_przacq,",",".")
_x_prez     = "mag_przcon = " + xx_przacq
_x_cond     = _x_soci + " and " + _x_data + " and " + _x_codi + " and " + _x_maga + " and " + _x_forn + " and " + _x_giac +  " and " + _x_prez + " and " + _x_fila + " and " + _x_pian + " and " + _x_ubic
Csql        = "select top 1 * from u_mag_gg where " + _x_cond + " order by mag_datagg,mag_przcon,mag_giacen"


IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
GO TOP       
IF EOF()
   APPEND BLANK
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_DATAGG WITH AQM_DATAGG 
   REPLACE MAG_CODMAG WITH AQM_CODMAG 
   REPLACE MAG_CODART WITH AQM_CODART 
   REPLACE MAG_DESART WITH AQM_DESART
   REPLACE MAG_CODPDV WITH AQM_CODPDV
   REPLACE MAG_FORNIT WITH AQM_CODFOR
   REPLACE MAG_DESFOR WITH AQM_DESFOR
   REPLACE MAG_GIACEN WITH AQM_GIACEN * (-1)
   REPLACE MAG_QTAKG  WITH AQM_QTAKG  * (-1)
   REPLACE MAG_QTAMQ  WITH AQM_QTAMQ  * (-1)
   REPLACE MAG_QTAML  WITH AQM_QTAML  * (-1)
   REPLACE MAG_PRZCON WITH AQM_PRZCON
   REPLACE MAG_UNIQUE WITH SYS(2015)
   IF EMPTY(ALLTRIM(MAG_ANNO))
      REPLACE MAG_ANNO WITH SUBSTR(MAG_DATAGG,1,4)
   ENDIF
   REPLACE MAG_FILA_X WITH AQM_FILA_X
   REPLACE MAG_PIAN_X WITH AQM_PIAN_X
   REPLACE MAG_UBIC_X WITH AQM_UBIC_X
   REPLACE MAG_FILA_N WITH AQM_FILA_N
   REPLACE MAG_PIAN_N WITH AQM_PIAN_N
   REPLACE MAG_UBIC_N WITH AQM_UBIC_N
   REPLACE MAG_ANAART WITH AQM_ANAART
ELSE
   IF MAG_GIACEN > AQM_GIACEN
      REPLACE MAG_GIACEN WITH MAG_GIACEN - AQM_GIACEN
      REPLACE MAG_QTAKG  WITH MAG_QTAKG  - AQM_QTAKG
      REPLACE MAG_QTAMQ  WITH MAG_QTAMQ  - AQM_QTAMQ
      REPLACE MAG_QTAML  WITH MAG_QTAML  - AQM_QTAML
   ELSE
      AQM_GIACEN = AQM_GIACEN - MAG_GIACEN
      REPLACE MAG_GIACEN WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAML  WITH 0
   ENDIF
   
   REPLACE MAG_FILA_X WITH aqm_fila_x 
   REPLACE MAG_PIAN_X WITH aqm_pian_x 
   REPLACE MAG_UBIC_X WITH aqm_ubic_x 
   REPLACE MAG_FILA_N WITH aqm_fila_n
   REPLACE MAG_PIAN_N WITH aqm_pian_n 
   REPLACE MAG_UBIC_N WITH aqm_ubic_n 


ENDIF



IF MAG_GIACEN > 0									&& NON SONO GESTITE GIACENZE NEGATIVE
ELSE
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_QTAIMP WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF


IF EMPTY(ALLTRIM(PUB_MAGNO0))
ELSE
   IF MAG_GIACEN = 0								&& CANCELLA IL RECORD SU U_MAG_GG SE E' = 0 ED E' PREVISTO NEI PARAMETRI AZIENDALI 
      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
      ELSE
         DELETE
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_GG","W")						&& CREA IL RECORD U_MAG_GG
   return(.f.)
ENDIF


SELECT &SS

RETURN(.T.)

