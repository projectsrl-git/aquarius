PARAMETERS V_SEEK

x_soci = "mai_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CONTATTO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cont   = "mai_conta like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_cont
           ENDIF
        ELSE
           x_cont   = "mai_conta like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_cont
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_conta" 

   CASE V_SCELTA=2                          && ACCESSO PER DITTA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_ditt   = "mai_ditta like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_ditt
           ENDIF
        ELSE
           x_ditt   = "mai_ditta like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_ditt
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_ditta" 

   CASE V_SCELTA=3                          && ACCESSO PER CITTA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_citt   = "mai_citta like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_citt
           ENDIF
        ELSE
           x_citt   = "mai_citta like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_citt
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_citta" 

   CASE V_SCELTA=4                          && ACCESSO PER CAP
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_cap   = "mai_cap like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_cap
           ENDIF
        ELSE
           x_cap   = "mai_cap like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_cap
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_cap" 
 		
   CASE V_SCELTA=5                          && ACCESSO PER GROSSISTA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_gros   = "mai_grossi like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_gros
           ENDIF
        ELSE
           x_gros   = "mai_grossi like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_gros
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_grossi" 
 		
   CASE V_SCELTA=6                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "mai_codice like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "mai_codice like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_codice" 

   CASE V_SCELTA=7                          && ACCESSO PER SOTTOCODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_subc   = "mai_subco like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_subc
           ENDIF
        ELSE
           x_subc   = "mai_subco like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_subc
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_subco" 

   CASE V_SCELTA=8                          && ACCESSO PER KEY1
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_key1   = "mai_key1 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_key1
           ENDIF
        ELSE
           x_key1   = "mai_key1 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_key1
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_key1" 

   CASE V_SCELTA=9                          && ACCESSO PER KEY2
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_key2   = "mai_key2 like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_key2
           ENDIF
        ELSE
           x_key2   = "mai_key2 like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_key2
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_key2" 

   CASE V_SCELTA=10                          && ACCESSO PER IDENTIFICAZIONE DITTA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_idit   = "mai_iditta like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_idit
           ENDIF
        ELSE
           x_idit   = "mai_iditta like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_idit
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_iditta" 

   CASE V_SCELTA=11                          && ACCESSO PER SETTORE ATTIVITA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_sett   = "mai_setat like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_sett
           ENDIF
        ELSE
           x_sett   = "mai_setat like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_sett
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_setat" 

   CASE V_SCELTA=12                          && ACCESSO PER TIPO PRODOTTI
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo   = "mai_tiprod like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_tipo
           ENDIF
        ELSE
           x_tipo   = "mai_tiprod like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_tipo
        ENDIF
        _ii_cSql = "select * from contatti where " + x_cond + ;
                                                 " order by mai_codsoc,mai_tiprod" 
ENDCASE