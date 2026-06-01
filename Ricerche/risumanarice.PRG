PARAMETERS V_SEEK

x_soci = "1 = 1"
x_cond = x_soci

_Cselect = "Select substring(CODICE,1,6) AS VIEW_CODICE, substring(NOME,1,20) AS VIEW_NOME, substring(COGNOME,1,20) AS VIEW_COGNOME," + ;
           " VIEW_SESSO = CASE SESSO WHEN 'M' THEN 'Maschio' WHEN 'F' THEN 'Femmina' ELSE '' END, substring(D_NASCITA,9,2) + '/' + substring(D_NASCITA,6,2) + '/' + substring(D_NASCITA,1,4) AS VIEW_D_NASCITA," + ;
           " substring(LOCRESIDENZ,1,50) AS VIEW_LOCRESIDENZ, substring(LOCDOMICIL,1,50) AS VIEW_LOCDOMICIL, * from RisUmana where "

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE RISORSA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(5,ALLTRIM(V_SEEK))
              x_tipo = "Codice = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _Cselect + x_cond + " order by Codice,Cognome,Nome" 
        ELSE
           V_SEEK = TRC(5,ALLTRIM(V_SEEK))
           x_tipo = "Codice = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _Cselect + x_cond + " order by Codice,Cognome,Nome" 
                                                                                                         
   CASE V_SCELTA=2                          && ACCESSO PER COGNOME
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "Cognome like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _Cselect + x_cond + " order by Cognome,Codice,Nome" 
        ELSE
           x_tipo = "Cognome like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _Cselect + x_cond + " order by Cognome,Codice,Nome" 
                                                   
   CASE V_SCELTA=3                          && ACCESSO PER NOME
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "Nome like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _Cselect + x_cond + " order by Nome,Codice,Cognome" 
        ELSE
           x_tipo = "Nome like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _Cselect + x_cond + " order by Nome,Codice,Cognome" 
                                                   
   CASE V_SCELTA=4                          && ACCESSO PER SESSO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "Sesso like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _Cselect + x_cond + " order by Sesso,Codice,Cognome,Nome" 
        ELSE
           x_tipo = "Sesso like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _Cselect + x_cond + " order by Sesso,Codice,Cognome,Nome" 
                                                   
   CASE V_SCELTA=5                          && ACCESSO PER Data di Nascita Dal
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "D_Nascita >= '" + RIBALTA2(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _Cselect + x_cond + " order by D_Nascita,Codice,Cognome,Nome" 
        ELSE
           x_tipo = "D_Nascita >= '" + RIBALTA2(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _Cselect + x_cond + " order by D_Nascita,Codice,Cognome,Nome" 
                                                   
   CASE V_SCELTA=6                          && ACCESSO PER Data di Nascita Al
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "D_Nascita <= '" + RIBALTA2(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _Cselect + x_cond + " order by D_Nascita,Codice,Cognome,Nome" 
        ELSE
           x_tipo = "D_Nascita <= '" + RIBALTA2(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _Cselect + x_cond + " order by D_Nascita,Codice,Cognome,Nome" 
                                                   
   CASE V_SCELTA=7                          && ACCESSO PER LOCALITA' DI Residenza
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "LocResidenz like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _Cselect + x_cond + " order by LocResidenz,Codice,Cognome,Nome" 
        ELSE
           x_tipo = "LocResidenz like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _Cselect + x_cond + " order by LocResidenz,Codice,Cognome,Nome" 
                                                   
   CASE V_SCELTA=8                          && ACCESSO PER LOCALITA' DI Domicilio
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "LocDomicil like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = _Cselect + x_cond + " order by LocDomicil,Codice,Cognome,Nome" 
        ELSE
           x_tipo = "LocDomicil like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = _Cselect + x_cond + " order by LocDomicil,Codice,Cognome,Nome" 
        
ENDCASE
