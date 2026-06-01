PARAMETERS V_SEEK

x_soci = "ftp_codsoc = '" + PUB_CODSOC + "'"
x_cpdv = "ftp_codpdv = '" + V_CODICE + "'"
*x_cond = x_soci + " and " + x_cpdv
x_cond = x_soci 

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE SEDE/PDV
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "ftp_codpdv = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "ftp_codpdv = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_codpdv" 
 		
   CASE V_SCELTA=2          				&& ACCESSO DESCRIZIONE SEDE/PDV
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desc = "ftp_despdv like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
        ELSE
           x_desc = "ftp_despdv like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_despdv" 
   
   CASE V_SCELTA=3          				&& ACCESSO CODICE COMPONENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codc = "ftp_codcas = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_codc
           ENDIF
        ELSE
           x_codc = "ftp_codcas like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_codc
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_codcas" 

   CASE V_SCELTA=4          				&& ACCESSO DESCRIZIONE COMPONENTE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_deca = "ftp_descas like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_deca
           ENDIF
        ELSE
           x_deca = "ftp_descas like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_deca
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_descas" 

   CASE V_SCELTA=5          				&& ACCESSO NUMERO DI SERIE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nume = "ftp_numser like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_nume
           ENDIF
        ELSE
           x_nume = "ftp_numser like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_nume
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_numser" 

   CASE V_SCELTA=6          				&& ACCESSO NUMERO DOCUMENTO
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_numd = "ftp_numdoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_numd
           ENDIF
        ELSE
           x_numd = "ftp_numdoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_numd
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_numdoc" 

   CASE V_SCELTA=7          				&& ACCESSO DATA DOCUMENTO
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_dtdo = "ftp_datdoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_dtdo
           ENDIF
        ELSE
           x_dtdo = "ftp_datdoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_dtdo
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_datdoc" 

   CASE V_SCELTA=8          				&& ACCESSO FORNITORE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_forn = "ftp_ragfor like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_forn
           ENDIF
        ELSE
           x_forn = "ftp_ragfor like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_forn
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_ragfor" 

   CASE V_SCELTA=9          				&& ACCESSO TIPO
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "ftp_tipo like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo
           ENDIF
        ELSE
           x_tipo = "ftp_tipo like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_tipo" 

   CASE V_SCELTA=10          				&& ACCESSO HOST
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_host = "ftp_host like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_host
           ENDIF
        ELSE
           x_host = "ftp_host like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_host
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_host" 

   CASE V_SCELTA=11          				&& ACCESSO USERS
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_user = "ftp_user like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_user
           ENDIF
        ELSE
           x_user = "ftp_user like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_user
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_user" 

   CASE V_SCELTA=12          				&& ACCESSO NOME FILE
        IF PUB_VISRIC
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nomf = "ftp_nomefi like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_nomf
           ENDIF
        ELSE
           x_nomf = "ftp_nomefi like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_nomf
        ENDIF
        _ii_cSql = "select * from u_ftp_an where " + x_cond + ;
                                                 " order by ftp_codsoc,ftp_nomefi" 
   
ENDCASE