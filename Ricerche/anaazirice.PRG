PARAMETERS V_SEEK

x_soci = "1 = 1"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER TIPO CLIENTE/FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "B_Client = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                      " order by B_Client,Codice,RagSoc" 
        ELSE
           x_tipo = "B_Client = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                   " order by B_Client,Codice,RagSoc" 

   CASE V_SCELTA=2                          && ACCESSO PER CODICE CLIENTE/FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "Codice = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                      " order by Codice,RagSoc,B_Client" 
        ELSE
           x_tipo = "Codice = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                   " order by Codice,RagSoc,B_Client"
                                                   
   CASE V_SCELTA=3                          && ACCESSO PER RAGIONE SOCIALE CLIENTE/FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "RagSoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                      " order by RagSoc,Codice,B_Client" 
        ELSE
           x_tipo = "RagSoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                   " order by RagSoc,Codice,B_Client"
                                                   
   CASE V_SCELTA=4                          && ACCESSO PER ACRONIMO CLIENTE/FORNITORE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "Acronimo like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                      " order by Acronimo,Codice,B_Client" 
        ELSE
           x_tipo = "Acronimo like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                   " order by Acronimo,Codice,B_Client"
                                                   
   CASE V_SCELTA=5                          && ACCESSO PER COMUNE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "ComuneInd like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                      " order by ComuneInd,Codice,RagSoc,B_Client" 
        ELSE
           x_tipo = "ComuneInd like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                   " order by ComuneInd,Codice,RagSoc,B_Client" 
                                                   
   CASE V_SCELTA=6                          && ACCESSO PER TELEFONO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "Telefono like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                      " order by Telefono,Codice,RagSoc,B_Client" 
        ELSE
           x_tipo = "Telefono like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select * from anaazi where " + x_cond + ;
                                                   " order by Telefono,Codice,RagSoc,B_Client" 
        
ENDCASE
