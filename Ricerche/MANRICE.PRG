PARAMETERS V_SEEK

x_cond   = "1=1"

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER ALTEZZA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "man_alteda = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "man_alteda = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_man_co where " + x_cond + ;
                                                 " order by man_alteda,man_lungda,man_spesda,man_codper,man_codman" 
                                                 
   CASE V_SCELTA=2                         && ACCESSO PER LUNGHEZZA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "man_lungda = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "man_lungda = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_man_co where " + x_cond + ;
                                                 " order by man_lungda,man_alteda,man_spesda,man_codper,man_codman"     
                                                 
   CASE V_SCELTA=3                         && ACCESSO PER SPESSORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "man_spesda = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "man_spesda = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_man_co where " + x_cond + ;
                                                 " order by man_spesda,man_alteda,man_lungda,man_codper,man_codman" 
                                                 
   CASE V_SCELTA=4                         && ACCESSO PER COD.PERSONAL.
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "man_codper like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "man_codper like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_man_co where " + x_cond + ;
                                                 " order by man_codper,man_alteda,man_lungda,man_spesda,man_codman"  
                                                 
   CASE V_SCELTA=5                         && ACCESSO PER COD.MANDRINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "man_codman like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "man_codman like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_man_co where " + x_cond + ;
                                                 " order by man_codman,man_alteda,man_lungda,man_spesda,man_codper" 

   CASE V_SCELTA=6                         && ACCESSO PER DESCR.MANDRINO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "man_desman like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "man_desman like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_man_co where " + x_cond + ;
                                                 " order by man_desman,man_codman,man_alteda,man_lungda,man_spesda,man_codper"                                                                                                                                                                                                                                                           

   
ENDCASE
