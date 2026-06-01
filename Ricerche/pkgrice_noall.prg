
PARAMETERS V_SEEK

x_csys = "pkg_codsys = pkg_codsys"
x_cond = x_csys
IF DOC_ANNO
   x_anno = "pkg_annpkg = '" + PUB_ANNO + "'"
ELSE
   x_anno = "pkg_annpkg = pkg_annpkg"
ENDIF
x_noal = "pkg_sc_pkg <> 'S'"
x_cond = x_cond + " and " + x_anno + " and " + x_noal

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER NUMERO PICKING
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nor6   = 6
              x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
              x_nord   = "pkg_numpkg = '" + x_nor0 + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
           x_nord   = "pkg_numpkg = '" + x_nor0 + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from u_pkg_td where " + x_cond + ;
                                                 " order by pkg_numpkg,pkg_datpkg,pkg_numprb,pkg_ragsoc,pkg_destin,pkg_codart" 

   CASE V_SCELTA=2                          && ACCESSO PER DATA PICKING
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "pkg_datpkg = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "pkg_datpkg = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql = "select * from u_pkg_td where " + x_cond + ;
                                                 " order by pkg_datpkg,pkg_numpkg,pkg_numprb,pkg_ragsoc,pkg_destin,pkg_codart" 

   CASE V_SCELTA=3          				&& ACCESSO PER NUMERO PREBOLLA
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nor6   = 6
              x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
              x_nord   = "pkg_numprb = '" + x_nor0 + "'"
              x_cond   = x_cond + " and " + x_nord
           ENDIF
        ELSE
           x_nor6   = 6
           x_nor0   = TRC(x_nor6,ALLTRIM(V_SEEK))
           x_nord   = "pkg_numprb = '" + x_nor0 + "'"
           x_cond   = x_cond + " and " + x_nord
        ENDIF
        _ii_cSql = "select * from u_pkg_td where " + x_cond + ;
                                                 " order by pkg_numprb,pkg_datpkg,pkg_numpkg,pkg_ragsoc,pkg_destin,pkg_codart" 

   CASE V_SCELTA=4          				&& ACCESSO PER CODICE CLIENTE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "pkg_codcli like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
        ELSE
           x_rags = "pkg_codcli like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_pkg_td where " + x_cond + ;
                                                 " order by pkg_codcli,pkg_numprb,pkg_datpkg,pkg_numpkg,pkg_destin,pkg_codart" 

   CASE V_SCELTA=5          				&& ACCESSO PER RAGIONE SOCIALE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "pkg_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
        ELSE
           x_rags = "pkg_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_pkg_td where " + x_cond + ;
                                                 " order by pkg_ragsoc,pkg_numprb,pkg_datpkg,pkg_numpkg,pkg_destin,pkg_codart" 

   CASE V_SCELTA=6          				&& ACCESSO PER DESTINAZIONE
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "pkg_destin like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
        ELSE
           x_rags = "pkg_destin like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_pkg_td where " + x_cond + ;
                                                 " order by pkg_destin,pkg_numprb,pkg_datpkg,pkg_numpkg,pkg_ragsoc,pkg_codart" 

   CASE V_SCELTA=7          				&& ACCESSO PER CODICE ARTICOLO
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "pkg_codart like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
        ELSE
           x_rags = "pkg_codart like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_pkg_td where " + x_cond + ;
                                                 " order by pkg_codart,pkg_numprb,pkg_datpkg,pkg_numpkg,pkg_ragsoc,pkg_destin" 

   CASE V_SCELTA=8          				&& ACCESSO PER SALDO/IN CONTO PICKING
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "pkg_sc_pkg = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
        ELSE
           x_rags = "pkg_sc_pkg = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_pkg_td where " + x_cond + ;
                                                 " order by pkg_sc_pkg,pkg_numprb,pkg_datpkg,pkg_numpkg,pkg_ragsoc,pkg_destin,pkg_codart" 
       
ENDCASE

RETURN

