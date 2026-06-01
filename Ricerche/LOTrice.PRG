PARAMETERS V_SEEK

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE SOCIETA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_lot_ri order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
           ELSE
              x_codi = "lot_codsoc like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from u_lot_ri where " + x_cond + ;
                         " order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
           ENDIF
        ELSE
           x_codi = "lot_codsoc like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from u_lot_ri where " + x_cond + ;
                      " order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
        ENDIF
    
   CASE V_SCELTA=2                          && ACCESSO PER N°LOTTO INIZIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_lot_ri order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
           ELSE
              x_codi = "lot_nloini = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_lot_ri where " + x_cond + ;
                         " order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
           ENDIF
        ELSE
          x_codi = "lot_nloini = " + ALLTRIM(v_seek)
          x_cond = x_codi
          _ii_cSql = "select * from u_lot_ri where " + x_cond + ;
                     " order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope"
        ENDIF
    
   CASE V_SCELTA=3                          && ACCESSO PER DATA OPERAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_lot_ri order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
           ELSE
              x_codi = "lot_datope like '" + RIBALTA2(ALLTRIM(v_seek)) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from u_lot_ri where " + x_cond + ;
                         " order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
           ENDIF
        ELSE
           x_codi = "lot_datope like '" + RIBALTA2(ALLTRIM(v_seek)) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from u_lot_ri where " + x_cond + ;
                      " order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
        ENDIF

   CASE V_SCELTA=4                          && ACCESSO PER CODICE CAUSALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_lot_ri order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
           ELSE
              x_codi = "lot_codcau like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from u_lot_ri where " + x_cond + ;
                         " order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
           ENDIF
        ELSE
           x_codi = "lot_codcau like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from u_lot_ri where " + x_cond + ;
                      " order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
        ENDIF 
        
   CASE V_SCELTA=5                          && ACCESSO PER N°LOTTO FINALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from u_lot_ri order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
           ELSE
              x_codi = "lot_nlofin = " + ALLTRIM(v_seek)
              x_cond = x_codi
              _ii_cSql = "select * from u_lot_ri where " + x_cond + ;
                         " order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope" 
           ENDIF
        ELSE
          x_codi = "lot_nlofin = " + ALLTRIM(v_seek)
          x_cond = x_codi
          _ii_cSql = "select * from u_lot_ri where " + x_cond + ;
                     " order by lot_codsoc,lot_nloini,lot_nlofin,lot_datope"
        ENDIF               
        
ENDCASE

