PARAMETERS V_SEEK

x_soci = "int_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci 

DO CASE

   CASE V_SCELTA=1          				&& ACCESSO N.CONTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi = "int_conto = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql   = "select * from u_bri_tt where " + x_cond + ;
                                                      " order by int_codsoc,int_conto" 
        ELSE
           x_codi = "int_conto = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql   = "select * from u_bri_tt where " + x_cond + ;
                                                   " order by int_codsoc,int_conto" 

   CASE V_SCELTA=2          				&& ACCESSO N.R.DARE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_LEN = LEN(ALLTRIM(V_SEEK))
              IF V_LEN = 9
                 V_SEEK = ' ' + V_SEEK
              ENDIF
              IF V_LEN = 8
                 V_SEEK = '  ' + V_SEEK
              ENDIF
              IF V_LEN = 7
                 V_SEEK = '   ' + V_SEEK
              ENDIF
              IF V_LEN = 6
                 V_SEEK = '    ' + V_SEEK
              ENDIF
              IF V_LEN = 5
                 V_SEEK = '     ' + V_SEEK
              ENDIF
              IF V_LEN = 4
                 V_SEEK = '      ' + V_SEEK
              ENDIF
              IF V_LEN = 3
                 V_SEEK = '       ' + V_SEEK
              ENDIF
              IF V_LEN = 2
                 V_SEEK = '        ' + V_SEEK
              ENDIF
              IF V_LEN = 1
                 V_SEEK = '        ' + V_SEEK
              ENDIF
              x_codi = "int_codrig = '" + V_SEEK + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql   = "select * from u_bri_tt where " + x_cond + ;
                                                      " order by int_codsoc,int_codrig" 
        ELSE
           V_LEN = LEN(ALLTRIM(V_SEEK))
           IF V_LEN = 9
              V_SEEK = ' ' + V_SEEK
           ENDIF
           IF V_LEN = 8
              V_SEEK = '  ' + V_SEEK
           ENDIF
           IF V_LEN = 7
              V_SEEK = '   ' + V_SEEK
           ENDIF
           IF V_LEN = 6
              V_SEEK = '    ' + V_SEEK
           ENDIF
           IF V_LEN = 5
              V_SEEK = '     ' + V_SEEK
           ENDIF
           IF V_LEN = 4
              V_SEEK = '      ' + V_SEEK
           ENDIF
           IF V_LEN = 3
              V_SEEK = '       ' + V_SEEK
           ENDIF
           IF V_LEN = 2
              V_SEEK = '        ' + V_SEEK
           ENDIF
           IF V_LEN = 1
              V_SEEK = '        ' + V_SEEK
           ENDIF
           x_codi = "int_codrig = '" + V_SEEK + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql   = "select * from u_bri_tt where " + x_cond + ;
                                                   " order by int_codsoc,int_codrig" 

   CASE V_SCELTA=3          				&& ACCESSO N.R.AVERE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_LEN = LEN(ALLTRIM(V_SEEK))
              IF V_LEN = 9
                 V_SEEK = ' ' + V_SEEK
              ENDIF
              IF V_LEN = 8
                 V_SEEK = '  ' + V_SEEK
              ENDIF
              IF V_LEN = 7
                 V_SEEK = '   ' + V_SEEK
              ENDIF
              IF V_LEN = 6
                 V_SEEK = '    ' + V_SEEK
              ENDIF
              IF V_LEN = 5
                 V_SEEK = '     ' + V_SEEK
              ENDIF
              IF V_LEN = 4
                 V_SEEK = '      ' + V_SEEK
              ENDIF
              IF V_LEN = 3
                 V_SEEK = '       ' + V_SEEK
              ENDIF
              IF V_LEN = 2
                 V_SEEK = '        ' + V_SEEK
              ENDIF
              IF V_LEN = 1
                 V_SEEK = '        ' + V_SEEK
              ENDIF
              x_codi = "int_codria = '" + V_SEEK + "'"
              x_cond = x_cond + " and " + x_codi
           ENDIF
           _ii_cSql   = "select * from u_bri_tt where " + x_cond + ;
                                                      " order by int_codsoc,int_codria" 
        ELSE
           V_LEN = LEN(ALLTRIM(V_SEEK))
           IF V_LEN = 9
              V_SEEK = ' ' + V_SEEK
           ENDIF
           IF V_LEN = 8
              V_SEEK = '  ' + V_SEEK
           ENDIF
           IF V_LEN = 7
              V_SEEK = '   ' + V_SEEK
           ENDIF
           IF V_LEN = 6
              V_SEEK = '    ' + V_SEEK
           ENDIF
           IF V_LEN = 5
              V_SEEK = '     ' + V_SEEK
           ENDIF
           IF V_LEN = 4
              V_SEEK = '      ' + V_SEEK
           ENDIF
           IF V_LEN = 3
              V_SEEK = '       ' + V_SEEK
           ENDIF
           IF V_LEN = 2
              V_SEEK = '        ' + V_SEEK
           ENDIF
           IF V_LEN = 1
              V_SEEK = '        ' + V_SEEK
           ENDIF
           x_codi = "int_codria = '" + V_SEEK + "'"
           x_cond = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql   = "select * from u_bri_tt where " + x_cond + ;
                                                   " order by int_codsoc,int_codria" 

ENDCASE