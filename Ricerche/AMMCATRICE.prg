
PARAMETERS V_SEEK

x_cond = "1=1"

DO CASE

   CASE V_SCELTA = 1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "amm_codamm like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_amm_ca where " + x_cond + ;
                                                    " order by amm_codamm" 
        ELSE
           x_codi   = "amm_codamm like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_amm_ca where " + x_cond + ;
                                                 " order by amm_codamm" 
 		
   CASE V_SCELTA = 2          				&& ACCESSO PER DESCRIZIONE 1
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "amm_descr1 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_amm_ca where " + x_cond + ;
                                                    " order by amm_descr1" 
        ELSE
           x_codi   = "amm_descr1 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_amm_ca where " + x_cond + ;
                                                 " order by amm_descr1" 
                                                 
   CASE V_SCELTA = 3          				&& ACCESSO PER PERCENT.AMM.BASE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "amm_peramm = " + ALLTRIM(V_SEEK)
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_amm_ca where " + x_cond + ;
                                                    " order by amm_peramm" 
        ELSE
           x_codi   = "amm_peramm = " + ALLTRIM(V_SEEK)
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_amm_ca where " + x_cond + ;
                                                 " order by amm_peramm" 
                                                 
   CASE V_SCELTA = 4          				&& ACCESSO PER CONTO CONTAB.
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "amm_contab like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_amm_ca where " + x_cond + ;
                                                    " order by amm_contab" 
        ELSE
           x_codi   = "amm_contab like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_amm_ca where " + x_cond + ;
                                                 " order by amm_contab" 
                                                 
   CASE V_SCELTA = 5          				&& ACCESSO PER CONTROPART.CONTAB.
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "amm_conpar like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql = "select * from u_amm_ca where " + x_cond + ;
                                                    " order by amm_conpar" 
        ELSE
           x_codi   = "amm_conpar like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_amm_ca where " + x_cond + ;
                                                 " order by amm_conpar"                                             
ENDCASE

