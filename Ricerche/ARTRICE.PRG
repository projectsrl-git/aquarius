* ------------------------------------------------------------------------------------------
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* -->> versione originale 
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK



*x_soci  = "art_codsoc = '" + PUB_CODSOC + "'"
x_soci  = "U_ART_PR.art_codsoc = '" + PUB_CODSOC + "'"  && ERASMO - 16/07/2018
x_cond = x_soci


IF _OPZ_TUTTI
ELSE
   x_tutt = "art_obsol <> 'S'"
   x_cond = x_cond + " and " + x_tutt
ENDIF

*!*	** 24/06/2022 SERGIO INIZIO
*!*	IF V_SCELTA <> 2 
*!*		_campi = "U_ART_PR.art_codpri,U_ART_PR.art_descr,U_ART_PR.art_unimis,U_ART_PR.art_przven,U_ART_PR.art_przcos,U_ART_PR.art_cstmat,U_ART_PR.art_linea,U_ART_PR.art_coord," + ;
*!*			"U_ART_PR.art_codmat,U_ART_PR.art_desmat,U_ART_PR.art_codcol,U_ART_PR.art_descol,U_ART_PR.art_cddiba,U_ART_PR.art_dsdiba,U_ART_PR.art_cge,U_ART_PR.art_datins," + ;
*!*			"U_ART_PR.art_datvar,U_ART_PR.art_spesso,U_ART_PR.art_catmer,U_ART_PR.art_cldog" 
*!*		x_select = "SELECT "+_campi+",U_ART_AN.ART_SCOMAGG FROM U_ART_PR LEFT OUTER JOIN U_ART_AN ON U_ART_PR.ART_CODPRI = U_ART_AN.ART_CODPRI "
*!*	ELSE
*!*		_campi = "U_ART_PR.art_codpri,U_ART_PR.art_descr,U_ART_PR.art_unimis,U_ART_PR.art_przven,U_ART_PR.art_przcos,U_ART_PR.art_cstmat,U_ART_PR.art_linea,U_ART_PR.art_coord," + ;
*!*			"U_ART_PR.art_codmat,U_ART_PR.art_desmat,U_ART_PR.art_codcol,U_ART_PR.art_descol,U_ART_PR.art_cddiba,U_ART_PR.art_dsdiba,U_ART_PR.art_cge,U_ART_PR.art_datins," + ;
*!*			"U_ART_PR.art_datvar,U_ART_PR.art_spesso,U_ART_PR.art_catmer,U_ART_PR.art_cldog" 
*!*		x_select = "SELECT "+_campi+" FROM U_ART_PR"
*!*	ENDIF
*!*	** 24/06/2022 SERGIO FINE
*!*	**=> ERASMO - INIZIO 22/05/2023
*!*	IF V_SCELTA <> 2 
*!*		_campi = "U_ART_PR.art_codpri,U_ART_PR.art_descr,U_ART_PR.art_unimis,U_ART_PR.art_przven,U_ART_PR.art_przcos,U_ART_PR.art_cstmat,U_ART_PR.art_linea,U_ART_PR.art_coord," + ;
*!*			"U_ART_PR.art_codmat,U_ART_PR.art_desmat,U_ART_PR.art_codcol,U_ART_PR.art_descol,U_ART_PR.art_cddiba,U_ART_PR.art_dsdiba,U_ART_PR.art_cge,U_ART_PR.art_datins," + ;
*!*			"U_ART_PR.art_datvar,U_ART_PR.art_spesso,U_ART_PR.art_catmer,U_ART_PR.art_cldog,U_ART_PR.art_desrid" 
*!*		x_select = "SELECT "+_campi+",U_ART_AN.ART_SCOMAGG FROM U_ART_PR LEFT OUTER JOIN U_ART_AN ON U_ART_PR.ART_CODPRI = U_ART_AN.ART_CODPRI "
*!*	ELSE
*!*		_campi = "U_ART_PR.art_codpri,U_ART_PR.art_descr,U_ART_PR.art_unimis,U_ART_PR.art_przven,U_ART_PR.art_przcos,U_ART_PR.art_cstmat,U_ART_PR.art_linea,U_ART_PR.art_coord," + ;
*!*			"U_ART_PR.art_codmat,U_ART_PR.art_desmat,U_ART_PR.art_codcol,U_ART_PR.art_descol,U_ART_PR.art_cddiba,U_ART_PR.art_dsdiba,U_ART_PR.art_cge,U_ART_PR.art_datins," + ;
*!*			"U_ART_PR.art_datvar,U_ART_PR.art_spesso,U_ART_PR.art_catmer,U_ART_PR.art_cldog,U_ART_PR.art_desrid" 
*!*		x_select = "SELECT "+_campi+" FROM U_ART_PR"
*!*	ENDIF
*!*	**=> ERASMO - FINE 22/05/2023
*!*	**=> ERASMO - INIZIO 19/09/2023
*!*	IF V_SCELTA <> 2 
*!*		_campi = "U_ART_PR.art_codpri,U_ART_PR.art_descr,U_ART_PR.art_unimis,U_ART_PR.art_przven,U_ART_PR.art_przcos,U_ART_PR.art_ulpcar,U_ART_PR.art_linea,U_ART_PR.art_coord," + ;
*!*			"U_ART_PR.art_codmat,U_ART_PR.art_desmat,U_ART_PR.art_codcol,U_ART_PR.art_descol,U_ART_PR.art_cddiba,U_ART_PR.art_dsdiba,U_ART_PR.art_cge,U_ART_PR.art_datins," + ;
*!*			"U_ART_PR.art_datvar,U_ART_PR.art_spesso,U_ART_PR.art_catmer,U_ART_PR.art_cldog,U_ART_PR.art_desrid" 
*!*		x_select = "SELECT "+_campi+",U_ART_AN.ART_SCOMAGG FROM U_ART_PR LEFT OUTER JOIN U_ART_AN ON U_ART_PR.ART_CODPRI = U_ART_AN.ART_CODPRI "
*!*	ELSE
*!*		_campi = "U_ART_PR.art_codpri,U_ART_PR.art_descr,U_ART_PR.art_unimis,U_ART_PR.art_przven,U_ART_PR.art_przcos,U_ART_PR.art_ulpcar,U_ART_PR.art_linea,U_ART_PR.art_coord," + ;
*!*			"U_ART_PR.art_codmat,U_ART_PR.art_desmat,U_ART_PR.art_codcol,U_ART_PR.art_descol,U_ART_PR.art_cddiba,U_ART_PR.art_dsdiba,U_ART_PR.art_cge,U_ART_PR.art_datins," + ;
*!*			"U_ART_PR.art_datvar,U_ART_PR.art_spesso,U_ART_PR.art_catmer,U_ART_PR.art_cldog,U_ART_PR.art_desrid" 
*!*		x_select = "SELECT "+_campi+" FROM U_ART_PR"
*!*	ENDIF
*!*	**=> ERASMO - FINE 19/09/2023
*!*	**=> ERASMO - INIZIO 26/02/2024
*!*	_campi = "U_ART_PR.art_codpri,U_ART_PR.art_descr,U_ART_PR.art_unimis,U_ART_PR.art_przven,U_ART_PR.art_przcos,U_ART_PR.art_ulpcar,U_ART_PR.art_linea,U_ART_PR.art_coord," + ;
*!*		"U_ART_PR.art_codmat,U_ART_PR.art_desmat,U_ART_PR.art_codcol,U_ART_PR.art_descol,U_ART_PR.art_cddiba,U_ART_PR.art_dsdiba,U_ART_PR.art_cge,U_ART_PR.art_datins," + ;
*!*		"U_ART_PR.art_datvar,U_ART_PR.art_spesso,U_ART_PR.art_catmer,U_ART_PR.art_cldog,U_ART_PR.art_desrid,U_ART_AN.ART_SCOMAGG,U_ART_PR.ART_CODF1,COALESCE(U_FOR_AN.FOR_RAGSOC,'') AS ART_DESF1,U_ART_PR.ART_NOTA1" 
*!*	x_select = "SELECT "+_campi+" FROM U_ART_PR LEFT OUTER JOIN U_ART_AN ON U_ART_PR.ART_CODPRI = U_ART_AN.ART_CODPRI " + ;
*!*		"LEFT OUTER JOIN U_FOR_AN ON U_FOR_AN.FOR_CODCLI = U_ART_PR.ART_CODF1 "
*!*	**=> ERASMO - FINE 26/02/2024
*!*	**=> ERASMO - INIZIO 08/05/2024
*!*	_campi = "U_ART_PR.art_codpri,U_ART_PR.art_descr,U_ART_PR.art_unimis,U_ART_PR.art_przven,U_ART_PR.art_przcos,U_ART_PR.art_ulpcar,U_ART_PR.art_linea,U_ART_PR.art_coord," + ;
*!*		"U_ART_PR.art_codmat,U_ART_PR.art_desmat,U_ART_PR.art_codcol,U_ART_PR.art_descol,U_ART_PR.art_cddiba,U_ART_PR.art_dsdiba,U_ART_PR.art_cge,U_ART_PR.art_datins," + ;
*!*		"U_ART_PR.art_datvar,U_ART_PR.art_spesso,U_ART_PR.art_catmer,U_ART_PR.art_cldog,U_ART_PR.art_desrid,U_ART_AN.ART_SCOMAGG,U_ART_PR.ART_CODF1,COALESCE(U_FOR_AN.FOR_RAGSOC,'') AS ART_DESF1,U_ART_PR.ART_NOTA1,U_ART_PR.ART_DESEST" 
*!*	x_select = "SELECT "+_campi+" FROM U_ART_PR LEFT OUTER JOIN U_ART_AN ON U_ART_PR.ART_CODPRI = U_ART_AN.ART_CODPRI " + ;
*!*		"LEFT OUTER JOIN U_FOR_AN ON U_FOR_AN.FOR_CODCLI = U_ART_PR.ART_CODF1 "
*!*	**=> ERASMO - FINE 08/05/2024
**=> ERASMO - INIZIO 19/05/2026
_campi = "U_ART_PR.art_codpri,U_ART_PR.art_descr,U_ART_PR.art_unimis,U_ART_PR.art_przven,U_ART_PR.art_przcos,U_ART_PR.art_ulpcar,U_ART_PR.art_linea,U_ART_PR.art_coord," + ;
	"U_ART_PR.art_codmat,U_ART_PR.art_desmat,U_ART_PR.art_codcol,U_ART_PR.art_descol,U_ART_PR.art_cddiba,U_ART_PR.art_dsdiba,U_ART_PR.art_cge,U_ART_PR.art_datins," + ;
	"U_ART_PR.art_datvar,U_ART_PR.art_spesso,U_ART_PR.art_catmer,U_ART_PR.art_cldog,U_ART_PR.art_desrid,U_ART_AN.ART_SCOMAGG,U_ART_PR.ART_CODF1,COALESCE(U_FOR_AN.FOR_RAGSOC,'') AS ART_DESF1," + ;
	"U_ART_PR.ART_NOTA1,U_ART_PR.ART_DESEST,U_ART_PR.ART_OBSOL" 
x_select = "SELECT "+_campi+" FROM U_ART_PR LEFT OUTER JOIN U_ART_AN ON U_ART_PR.ART_CODPRI = U_ART_AN.ART_CODPRI " + ;
	"LEFT OUTER JOIN U_FOR_AN ON U_FOR_AN.FOR_CODCLI = U_ART_PR.ART_CODF1 "
**=> ERASMO - FINE 19/05/2026

RELEASE XXX_VISRIC
PUBLIC  XXX_VISRIC

XXX_VISRIC = PUB_VISRIC
*PUB_VISRIC = .F.

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE ARTICOLO (CONTENUTO)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              *x_codi   = "art_codpri like '" + ALLTRIM(V_SEEK) + "%'"
              x_codi   = "U_ART_PR.art_codpri like '%" + ALLTRIM(V_SEEK) + "%'"  && ERASMO - 16/07/2018
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           *_ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_codpri"
        ELSE
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              *x_codi   = "art_codpri = '" + ALLTRIM(V_SEEK) + "%'"
              x_codi   = "U_ART_PR.art_codpri like '%" + ALLTRIM(V_SEEK) + "%'"  && ERASMO - 16/07/2018
           ELSE
              *x_codi   = "art_codpri like '" + ALLTRIM(V_SEEK) + "%'"
              x_codi   = "U_ART_PR.art_codpri like '%" + ALLTRIM(V_SEEK) + "%'"  && ERASMO - 16/07/2018
           ENDIF
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        *_ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_codpri"
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_codpri"  && ERASMO - 16/07/2018


** 24/06/2022 SERGIO INIZIO
   CASE V_SCELTA=2                          && ACCESSO PER CODICE ARTICOLO (INIZIA PER)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "U_ART_PR.art_codpri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           *_ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_codpri"
        ELSE
           x_codi   = "U_ART_PR.art_codpri like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        *_ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_codpri"
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
** 24/06/2022 SERGIO FINE


   CASE V_SCELTA=3                          && ACCESSO PER DESCRIZIONE ARTICOLO  (INIZIA PER)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "U_ART_PR.art_descr like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           *_ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_descr"
        ELSE
           x_codi   = "U_ART_PR.art_descr like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        *_ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_descr"
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_descr"  && ERASMO - 16/07/2018
                                                 
   CASE V_SCELTA=4                          && ACCESSO PER DESCRIZIONE ARTICOLO (CONTIENE)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "U_ART_PR.art_descr like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           *_ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_descr"
        ELSE
           x_codi   = "U_ART_PR.art_descr like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        *_ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_descr"
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_descr"  && ERASMO - 16/07/2018


** 01/07//2022 SERGIO INIZIO
    CASE V_SCELTA=5                          && ACCESSO PER DESCRIZIONE RIDOTTA/REF  (CONTIENE)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "U_ART_PR.art_desrid like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           *_ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_desrid"
        ELSE
           x_codi   = "U_ART_PR.art_desrid like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        *_ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_desrid"
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_desrid"  && ERASMO - 16/07/2018

** 01/07//2022 SERGIO FINE
 
 
 
 
   CASE V_SCELTA=6                          && ACCESSO PER LINEA DI PRODOTTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clin = "U_ART_PR.art_linea = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clin
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_linea,art_codpri" 
        ELSE
           x_clin = "U_ART_PR.art_linea = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clin
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_linea,art_codpri" 
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_linea,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
		  	         				
   CASE V_SCELTA=7                          && ACCESSO PER COORDINATE DI MAGAZZINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_coor = "U_ART_PR.art_coord like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_coor
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_coor = "U_ART_PR.art_coord like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_coor
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri" 
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_coord,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018

   CASE V_SCELTA=8                          && ACCESSO PER CODICE MATERIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cmat = "U_ART_PR.art_codmat like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_cmat 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_cmat = "U_ART_PR.art_codmat like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_cmat 
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri"   
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_codmat,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
                                                   
   CASE V_SCELTA=9                          && ACCESSO PER DESCRIZIONE MATERIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_dmat = "U_ART_PR.art_desmat like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_dmat 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_dmat = "U_ART_PR.art_desmat like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_dmat 
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri"
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_desmat,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018

   CASE V_SCELTA=10                          && ACCESSO PER CODICE COLORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_ccol = "art_codcol like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_ccol 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_ccol = "U_ART_PR.art_codcol like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_ccol
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri" 
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_codcol,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
                                                   
   CASE V_SCELTA=11                          && ACCESSO PER DESCRIZIONE COLORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_dcol = "U_ART_PR.art_descol like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_dcol 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_dcol = "U_ART_PR.art_descol like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_dcol
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri"   
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_descol,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
                                                   
   CASE V_SCELTA=12                          && ACCESSO PER CODICE DISTINTA DI BASE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cddb = "U_ART_PR.art_cddiba like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_cddb 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_cddb = "U_ART_PR.art_cddiba like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_cddb 
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri" 
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_cddiba,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
                                                   
   CASE V_SCELTA=13                          && ACCESSO PER DESCRIZIONE DISTINTA DI BASE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_dddb = "U_ART_PR.art_dsdiba like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_dddb 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_dddb = "U_ART_PR.art_dsdiba like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_dddb
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri"   
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_dsdiba,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
                                                   
   CASE V_SCELTA=14                          && ACCESSO PER CODICE CONTO CONTABILE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cdge = "U_ART_PR.art_cge like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_cdge 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_cdge = "U_ART_PR.art_cge like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_cdge
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri"    
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_cge,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
                                                   
   CASE V_SCELTA=15                          && ACCESSO PER DATA INSERIMENTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_dins = "U_ART_PR.art_datins like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_dins 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_dins = "U_ART_PR.art_datins like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_dins
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri" 
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_datins,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
                                                   
   CASE V_SCELTA=16                          && ACCESSO PER DATA MODIFICA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_dvar = "U_ART_PR.art_datvar like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_dvar 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_dvar = "U_ART_PR.art_datvar like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_dvar
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri"  
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_datvar,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
                                                   
   CASE V_SCELTA=17                          && ACCESSO PER SPESSORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_spes = "U_ART_PR.art_spesso = " + STR(VAL(ALLTRIM(V_SEEK)))
              x_cond = x_cond + " and " + x_spes
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_coord,art_codpri" 
        ELSE
           x_spes = "U_ART_PR.art_spesso = " + STR(VAL(ALLTRIM(V_SEEK)))
           x_cond = x_cond + " and " + x_spes
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_coord,art_codpri"  
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_spesso,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
   
   CASE V_SCELTA=18                          && ACCESSO PER CATEGORIA MERCEOLOGICA
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cmer = "U_ART_PR.art_catmer like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_cmer 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_catmer" 
        ELSE
           x_cmer = "U_ART_PR.art_catmer like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_cmer 
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_catmer"  
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_catmer,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
 
   
   CASE V_SCELTA=19                          && ACCESSO PER CLASSE DOGANALE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cmer = "U_ART_PR.art_cldog like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_cmer 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_cldog" 
        ELSE
           x_cmer = "U_ART_PR.art_cldog like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_cmer 
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_cldog"
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_cldog,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018


   CASE V_SCELTA=20                          && ACCESSO PER SPECIFICA DI ACQUISTO (CONTIENE)
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              *x_spec = "art_codpri in (select codart from U_ART_SP where cdarfo like '%" + ALLTRIM(V_SEEK) + "%')"
              x_spec = "U_ART_PR.art_codpri in (select codart from U_ART_SP where cdarfo like '%" + ALLTRIM(V_SEEK) + "%')"  && ERASMO - 19/10/2021
              x_cond = x_cond + " and " + x_spec 
           ENDIF
	       *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_codpri" 
        ELSE
           *x_spec = "art_codpri in (select codart from U_ART_SP where cdarfo like '%" + ALLTRIM(V_SEEK) + "%')"
           x_spec = "U_ART_PR.art_codpri in (select codart from U_ART_SP where cdarfo like '%" + ALLTRIM(V_SEEK) + "%')"  && ERASMO - 19/10/2021
           x_cond = x_cond + " and " + x_spec 
        ENDIF
        *_ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_codpri"  
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
                                                   
   CASE V_SCELTA=21                          && ACCESSO PER ALMENO UNO DEI CODICI FORNITORI DELLA SCHEDA "ARTICOLI FORNITORI"
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_forn = "'" + ALLTRIM(V_SEEK) + "' in (U_ART_PR.art_codf1,U_ART_PR.art_codf2,U_ART_PR.art_codf3,U_ART_PR.art_codf4,U_ART_PR.art_codf5)"
              x_cond = x_cond + " and " + x_forn
           ENDIF
        ELSE
           x_forn = "'" + ALLTRIM(V_SEEK) + "' in (U_ART_PR.art_codf1,U_ART_PR.art_codf2,U_ART_PR.art_codf3,U_ART_PR.art_codf4,U_ART_PR.art_codf5)"
           x_cond = x_cond + " and " + x_forn
        ENDIF
        *_ii_cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codf1"
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_codf1"  && ERASMO - 16/07/2018
        
 
   CASE V_SCELTA=22                          && ACCESSO PER ALMENO UNA DELLA RAGIONE SOCIALE FORNITORI DELLA SCHEDA "ARTICOLI FORNITORI" (CONTIENE)
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE              
              x_forn = "EXISTS ((SELECT FOR_RAGSOC FROM U_FOR_AN WHERE FOR_CODCLI IN (U_ART_PR.art_codf1,U_ART_PR.art_codf2,U_ART_PR.art_codf3,U_ART_PR.art_codf4,U_ART_PR.art_codf5) AND FOR_RAGSOC LIKE '%" + ALLTRIM(V_SEEK) + "%'))"
              x_cond = x_cond + " and " + x_forn
           ENDIF
        ELSE
           x_forn = "EXISTS ((SELECT FOR_RAGSOC FROM U_FOR_AN WHERE FOR_CODCLI IN (U_ART_PR.art_codf1,U_ART_PR.art_codf2,U_ART_PR.art_codf3,U_ART_PR.art_codf4,U_ART_PR.art_codf5) AND FOR_RAGSOC LIKE '%" + ALLTRIM(V_SEEK) + "%'))"
           x_cond = x_cond + " and " + x_forn
        ENDIF
        *_ii_cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codf1"
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_codf1,U_ART_PR.art_codf2,U_ART_PR.art_codf3,U_ART_PR.art_codf4,U_ART_PR.art_codf5"  && ERASMO - 16/07/2018
        
   **=> ERASMO - INIZIO 16/05/2016
   CASE V_SCELTA=23                          && ACCESSO PER ALMENO UNO DEI CODICI ARTICOLO FORNITORE DELLA SCHEDA "ARTICOLI FORNITORI" (CONTIENE)
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE              
              x_carf = "'|'+U_ART_PR.ART_NOTA1+'|'+U_ART_PR.ART_NOTA2+'|'+U_ART_PR.ART_NOTA3+'|'+U_ART_PR.ART_NOTA4+'|'+U_ART_PR.ART_NOTA5+'|' LIKE '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_carf
           ENDIF
        ELSE
           x_carf = "'|'+U_ART_PR.ART_NOTA1+'|'+U_ART_PR.ART_NOTA2+'|'+U_ART_PR.ART_NOTA3+'|'+U_ART_PR.ART_NOTA4+'|'+U_ART_PR.ART_NOTA5+'|' LIKE '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_carf
        ENDIF
        *_ii_cSql = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_PR.art_codpri"  && ERASMO - 16/07/2018
   **=> ERASMO - FINE 16/05/2016


   CASE V_SCELTA=24                          && ACCESSO PER CODICE FAMIGLIA SCONTO
          
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clin = "U_ART_PR.art_scomagg = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clin
           ENDIF
	       *_ii_cSql   = "select * from u_art_an where " + x_cond + ;
                                                      " order by art_codsoc,art_scomagg,art_codpri" 
        ELSE
           x_clin = "U_ART_PR.art_scomagg = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clin
        ENDIF
        *_ii_cSql   = "select * from u_art_an where " + x_cond + ;
                                                   " order by art_codsoc,art_scomagg,art_codpri" 
        _ii_cSql = x_select + " where " + x_cond + " order by U_ART_AN.art_scomagg,U_ART_PR.art_codpri"  && ERASMO - 16/07/2018


ENDCASE

PUB_VISRIC = XXX_VISRIC

RETURN


* ------------------------------------------------------------------------------------------
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* -->> nuova versione con la gestione delle paginazioni e delle store procedure SQL
* ------------------------------------------------------------------------------------------

PARAMETERS V_SEEK

x_soci  = "art_codsoc = '" + PUB_CODSOC + "'"
_x_cond	= x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE ARTICOLO
		_CampiFiltro = "U2.art_codsoc = U1.art_codsoc and U2.art_codpri < U1.art_codpri"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
  		   _x_cond = _x_cond + " and art_codpri like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
		_Ordine	= "art_codsoc,art_codpri"
  
   CASE V_SCELTA=2          				&& ACCESSO PER DESCRIZIONE ARTICOLO
		_CampiFiltro = "U2.art_codsoc = U1.art_codsoc and U2.art_descr < U1.art_descr"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
		   _x_cond = _x_cond + " and art_descr like '" + ALLTRIM(V_SEEK) + "%'"
        ENDIF
		_Ordine	= "art_codsoc,art_descr"
                                                      
   CASE V_SCELTA=3          				&& ACCESSO PER LINEA DI PRODOTTO
		_CampiFiltro = "U2.art_codsoc = U1.art_codsoc and U2.art_linea < U1.art_linea"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
	  	   _x_cond = _x_cond + " and art_linea = '" + ALLTRIM(V_SEEK) + "'"
		ENDIF
		_Ordine	= "art_codsoc,art_linea,art_codpri"

   CASE V_SCELTA=4          				&& ACCESSO PER COORDINATE DI MAGAZZINO
		_CampiFiltro = "U2.art_codsoc = U1.art_codsoc and U2.art_coord < U1.art_coord"
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
        ELSE
		   _x_cond	= _x_cond + " and art_coord like '" + ALLTRIM(V_SEEK) + "%'"
		ENDIF
		_Ordine = "art_codsoc,art_coord,art_codpri"

ENDCASE


_maxRighe		= ALLTRIM(STR(pub_pagina))
_iPag			= ALLTRIM(STR(pub_paginazione))
_Tabella 		= "u_art_pr"
_CampiVista		= STRTRAN(_x_campi,";",",")
_CampiFiltro1 	= _x_cond

_ii_cSql = 'EXEC Sp_Gestionale ' +_maxRighe+','+_iPag+',"'+_Tabella+'","'+_CampiVista+'","'+_CampiFiltro+'","'+_CampiFiltro1+'","'+_Ordine+'"'

RETURN