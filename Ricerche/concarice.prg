PARAMETERS V_SEEK

x_cond   = "1=1"

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER COD.VETTORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "con_codvet like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "con_codvet like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_con_ca where " + x_cond + ;
                                                 " order by con_codvet,con_desvet,con_desreg,con_codprv" 
                                                 
   CASE V_SCELTA=2                         && ACCESSO PER DESCRIZIONE VETTORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "con_desvet like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "con_desvet like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_con_ca where " + x_cond + ;
                                                 " order by con_desvet,con_codvet,con_desreg,con_codprv" 
                                                 
   CASE V_SCELTA=3                         && ACCESSO PER DESCRIZIONE NAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "con_desnaz like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "con_desnaz like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_con_ca where " + x_cond + ;
                                                 " order by con_desnaz,con_codvet,con_desreg,con_codprv"                                                                                                  
                                                 
   CASE V_SCELTA=4                         && ACCESSO PER SIGLA PROVINCIA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "con_codprv like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "con_codprv like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_con_ca where " + x_cond + ;
                                                 " order by con_codprv,con_desreg,con_codvet,con_desvet" 
                                                 
   CASE V_SCELTA=5                         && ACCESSO PER DESCRIZIONE REGIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "con_desreg like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "con_desreg like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_con_ca where " + x_cond + ;
                                                 " order by con_desreg,con_codprv,con_codvet,con_desvet"                                                                                                                                                                                   
   
ENDCASE
