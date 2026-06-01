
PARAMETERS V_SEEK

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_flag = "art_flgmim = 1" 
x_cond = x_soci + " and " + x_flag

RELEASE XXX_VISRIC
PUBLIC  XXX_VISRIC

XXX_VISRIC = PUB_VISRIC
PUB_VISRIC = .F.

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE CONFEZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "art_codpac like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_codpac"
        ELSE
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              x_codi   = "art_codpac = '" + ALLTRIM(V_SEEK) + "%'"
           ELSE
              x_codi   = "art_codpac like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_codpac"

   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE CONFEZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "art_despac like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_despac"
        ELSE
           x_codi   = "art_despac like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_despac"

   CASE V_SCELTA=3                          && ACCESSO PER CODICE ARTICOLO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "art_codpri like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_codpri"
        ELSE
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              x_codi   = "art_codpri = '" + ALLTRIM(V_SEEK) + "%'"
           ELSE
              x_codi   = "art_codpri like '" + ALLTRIM(V_SEEK) + "%'"
           ENDIF
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_codpri"

   CASE V_SCELTA=4                          && ACCESSO PER DESCRIZIONE ARTICOLO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "art_descr like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                    " order by art_codsoc,art_descr"
        ELSE
           x_codi   = "art_descr like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_art_pr where " + x_cond + ;
                                                 " order by art_codsoc,art_descr"

   CASE V_SCELTA=5                          && ACCESSO PER SERIAL NUMBER
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clin = "art_sernum = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clin
           ENDIF
	       _ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_sernum" 
        ELSE
           x_clin = "art_sernum = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clin
        ENDIF
        _ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_sernum" 
		  	         				
   CASE V_SCELTA=6                          && ACCESSO PER LINEA DI PRODOTTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clin = "art_tipcom = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_clin
           ENDIF
	       _ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                      " order by art_codsoc,art_tipcom,art_codpri" 
        ELSE
           x_clin = "art_tipcom = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_clin
        ENDIF
        _ii_cSql   = "select * from u_art_pr where " + x_cond + ;
                                                   " order by art_codsoc,art_tipcom,art_codpri" 
 	
ENDCASE

PUB_VISRIC = XXX_VISRIC

RETURN


