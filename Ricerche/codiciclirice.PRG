PARAMETERS V_SEEK

_CODICE_CLIENTE_AQUARIUS_FITTIZIO = '9999999999'

x_cond   = "CODCLI_AQUARIUS <> '" + ALLTRIM(_CODICE_CLIENTE_AQUARIUS_FITTIZIO) + "'"

  


DO CASE

   CASE V_SCELTA=1          				&& ACCESSO PER RAGIONE SOCIALE AQUARIUS

        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "RAGSOC_AQUARIUS  like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = "select * from u_cli_ex where " + x_cond + ;
                                                      " order by RAGSOC_AQUARIUS" 
        ELSE
           x_rags = "RAGSOC_AQUARIUS like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF
        _ii_cSql   = "select * from u_cli_ex where " + x_cond + ;
                                                      " order by RAGSOC_AQUARIUS" 


   CASE V_SCELTA=2                          && ACCESSO PER CODICE CLIENTE AQUARIUS
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_cond   = "CODCLI_AQUARIUS = '" + ALLTRIM(V_SEEK) + "'"
           ENDIF
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))        
           x_cond   = "CODCLI_AQUARIUS = '" + ALLTRIM(V_SEEK) + "'"
        ENDIF
        _ii_cSql = "select * from u_cli_ex where " + x_cond + ;
                                                 " order by CODCLI_AQUARIUS" 


   CASE V_SCELTA=3          				&& ACCESSO PER CLIENTE ZUCCHETTI
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_cond   = "CODCLI_ZUCCHETTI = '" + ALLTRIM(V_SEEK) + "'"
           ENDIF
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))        
           x_cond   = "CODCLI_ZUCCHETTI = '" + ALLTRIM(V_SEEK) + "'"
        ENDIF
        _ii_cSql = "select * from u_cli_ex where " + x_cond + ;
                                                 " order by CODCLI_ZUCCHETTI" 



   CASE V_SCELTA=4          				&& ACCESSO PER CLIENTE SISPAC
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_cond   = "CODCLI_SISPAC = '" + ALLTRIM(V_SEEK) + "'"
           ENDIF
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))        
           x_cond   = "CODCLI_SISPAC = '" + ALLTRIM(V_SEEK) + "'"
        ENDIF
        _ii_cSql = "select * from u_cli_ex where " + x_cond + ;
                                                 " order by CODCLI_SISPAC" 

 		
   CASE V_SCELTA=5          				&& ACCESSO PER CLIENTE COPERNICO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_cond   = "CODCLI_COPERNICO = '" + ALLTRIM(V_SEEK) + "'"
           ENDIF
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))        
           x_cond   = "CODCLI_COPERNICO = '" + ALLTRIM(V_SEEK) + "'"
        ENDIF
        _ii_cSql = "select * from u_cli_ex where " + x_cond + ;
                                                 " order by CODCLI_COPERNICO"    
                                                 
                                                 
ENDCASE
