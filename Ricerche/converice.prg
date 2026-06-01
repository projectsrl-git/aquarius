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
        _ii_cSql = "select con_codvet,con_desvet,con_valida,con_valial,DBO.RIBALTA2(con_valida) AS valida,DBO.RIBALTA2(con_valial) AS valial from u_con_ve where " + x_cond + ;
           " group by con_codvet,con_desvet,con_valida,con_valial order by con_codvet,con_desvet,con_valida"
                                                 
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
        _ii_cSql = "select con_codvet,con_desvet,con_valida,con_valial,DBO.RIBALTA2(con_valida) AS valida,DBO.RIBALTA2(con_valial) AS valial from u_con_ve where " + x_cond + ;
           " group by con_codvet,con_desvet,con_valida,con_valial order by con_codvet,con_desvet,con_valida"
                                                 
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
        _ii_cSql = "select con_codvet,con_desvet,con_valida,con_valial,DBO.RIBALTA2(con_valida) AS valida,DBO.RIBALTA2(con_valial) AS valial from u_con_ve where " + x_cond + ;
           " group by con_codvet,con_desvet,con_valida,con_valial order by con_codvet,con_desvet,con_valida"
                                                 
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
        _ii_cSql = "select con_codvet,con_desvet,con_valida,con_valial,DBO.RIBALTA2(con_valida) AS valida,DBO.RIBALTA2(con_valial) AS valial from u_con_ve where " + x_cond + ;
           " group by con_codvet,con_desvet,con_valida,con_valial order by con_codvet,con_desvet,con_valida"
                                                 
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
        _ii_cSql = "select con_codvet,con_desvet,con_valida,con_valial,DBO.RIBALTA2(con_valida) AS valida,DBO.RIBALTA2(con_valial) AS valial from u_con_ve where " + x_cond + ;
           " group by con_codvet,con_desvet,con_valida,con_valial order by con_codvet,con_desvet,con_valida"
   
ENDCASE
