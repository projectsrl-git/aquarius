PARAMETERS V_SEEK

DO CASE
   
   CASE V_SCELTA=1                          && ACCESSO PER CODICE LAVORAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from U_PRO_IM order by imp_datimp" 
           ELSE             
              x_codi = "imp_codlav like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                               " order by imp_datimp" 
           ENDIF
        ELSE            
           x_codi = "imp_codlav like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                            " order by imp_datimp"
        ENDIF
   
   CASE V_SCELTA=2                          && ACCESSO PER CODICE MACCHINA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from U_PRO_IM order by imp_datimp"
           ELSE
              x_codi = "imp_codmac like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                               " order by imp_datimp"
           ENDIF
        ELSE
           x_codi = "imp_codmac like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                            " order by imp_datimp"
        ENDIF
        
    CASE V_SCELTA=3                          && ACCESSO PER DATA IMPEGNATA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from U_PRO_IM order by imp_datimp"
           ELSE
              x_codi = "inv_datimp like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                               " order by imp_datimp"
           ENDIF
        ELSE
           x_codi = "inv_datimp like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                            " order by imp_datimp"
        ENDIF
        
    CASE V_SCELTA=4                          && ACCESSO PER SETTIMANA IMPEGNATA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from U_PRO_IM order by imp_datimp"
           ELSE
              x_codi = "inv_setimp like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                               " order by imp_datimp"
           ENDIF
        ELSE
           x_codi = "inv_setimp like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                            " order by imp_datimp"
        ENDIF
        
     CASE V_SCELTA=5                          && ACCESSO PER NUMERO PROGRAMMA 1
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from U_PRO_IM order by imp_datimp"
           ELSE
              IF VAL(ALLTRIM(V_SEEK)) = 0                     
                 V_SEEK = ALLTRIM(V_SEEK)
              ELSE
                 PUB_LNO = 6
                 V_SEEK = TRC(PUB_LNO,ALLTRIM(V_SEEK))
                 _SCREEN.ActiveForm.REFRESH
              ENDIF    
              x_codi = "imp_nrprg1 = '" + ALLTRIM(v_seek) + "'"
              x_cond = x_codi
              _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                               " order by imp_datimp"
           ENDIF
        ELSE
           IF VAL(ALLTRIM(V_SEEK)) = 0                     
              V_SEEK = ALLTRIM(V_SEEK)
           ELSE
              PUB_LNO = 6
              V_SEEK = TRC(PUB_LNO,ALLTRIM(V_SEEK))
              _SCREEN.ActiveForm.REFRESH
           ENDIF    
           x_codi = "imp_nrprg1 = '" + ALLTRIM(v_seek) + "'"
           x_cond = x_codi
           _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                            " order by imp_datimp"
        ENDIF
        
    CASE V_SCELTA=6                          && ACCESSO PER DATA PROGRAMMA 1
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from U_PRO_IM order by imp_datimp"
           ELSE
              x_codi = "inv_dtprg1 like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                               " order by imp_datimp"
           ENDIF
        ELSE
           x_codi = "inv_dtprg1 like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                            " order by imp_datimp"
        ENDIF
        
     CASE V_SCELTA=7                          && ACCESSO PER NUMERO PROGRAMMA 2
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from U_PRO_IM order by imp_datimp"
           ELSE
              IF VAL(ALLTRIM(V_SEEK)) = 0                     
                 V_SEEK = ALLTRIM(V_SEEK)
              ELSE
                 PUB_LNO = 6
                 V_SEEK = TRC(PUB_LNO,ALLTRIM(V_SEEK))
                 _SCREEN.ActiveForm.REFRESH
              ENDIF    
              x_codi = "imp_nrprg2 = '" + ALLTRIM(v_seek) + "'"
              x_cond = x_codi
              _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                               " order by imp_datimp"
           ENDIF
        ELSE
           IF VAL(ALLTRIM(V_SEEK)) = 0                     
              V_SEEK = ALLTRIM(V_SEEK)
           ELSE
              PUB_LNO = 6
              V_SEEK = TRC(PUB_LNO,ALLTRIM(V_SEEK))
              _SCREEN.ActiveForm.REFRESH
           ENDIF    
           x_codi = "imp_nrprg2 = '" + ALLTRIM(v_seek) + "'"
           x_cond = x_codi
           _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                            " order by imp_datimp"
        ENDIF
        
    CASE V_SCELTA=8                          && ACCESSO PER DATA PROGRAMMA 2
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
              _ii_cSql = "select * from U_PRO_IM order by imp_datimp"
           ELSE
              x_codi = "inv_dtprg2 like '" + ALLTRIM(v_seek) + "%'"
              x_cond = x_codi
              _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                               " order by imp_datimp"
           ENDIF
        ELSE
           x_codi = "inv_dtprg2 like '" + ALLTRIM(v_seek) + "%'"
           x_cond = x_codi
           _ii_cSql = "select * from U_PRO_IM where " + x_cond + ;
                                            " order by imp_datimp"
        ENDIF

ENDCASE

