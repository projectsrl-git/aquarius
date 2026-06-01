PARAMETERS V_SEEK

x_cond   = "1=1"

DO CASE

   CASE V_SCELTA=1                         && ACCESSO PER NOME PROCEDURA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "att_proced like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "att_proced like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_att_op where " + x_cond + ;
                                                 " order by att_proced,att_codope" 
                                                 
   CASE V_SCELTA=2                         && ACCESSO PER DESCRIZIONE PROCEDURA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "att_despro like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "att_despro like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_att_op where " + x_cond + ;
                                                 " order by att_despro,att_codope" 
 		
   CASE V_SCELTA=3                         && ACCESSO PER CODICE OPERATORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "att_codope like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "att_codope like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_att_op where " + x_cond + ;
                                                 " order by att_codope,att_despro" 
                                                 
   CASE V_SCELTA=4                         && ACCESSO PER DESCRIZIONE OPERATORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "att_nomope like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "att_nomope like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_att_op where " + x_cond + ;
                                                 " order by att_nomope,att_proced"                                                  
   
ENDCASE
