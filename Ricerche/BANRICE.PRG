PARAMETERS V_SEEK

x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE BANCA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "ban_codban = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "ban_codban = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_ban_an where " + x_cond + ;
                                                 " order by ban_codsoc,ban_codban" 

   CASE V_SCELTA=2          				&& ACCESSO PER BANCA DI PRESENTAZIONE EFFETTI


        IF PUB_VISRIC 
              v_prese = "S"
              x_PRESE  = "ban_prese = '" + ALLTRIM(V_PRESE) + "'"
              x_cond  = x_cond + " and " + x_PRESE
        ELSE
           v_prese = "S"
           x_PRESE  = "ban_prese = '" + ALLTRIM(V_PRESE) + "'"
           x_cond  = x_cond + " and " + x_PRESE
        ENDIF
        _ii_cSql = "select * from u_ban_an where " + x_cond + ;
                                                 " order by ban_codsoc,ban_desban" 
 		
   CASE V_SCELTA=3          				&& ACCESSO DENOMINAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_desc = "ban_desban like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_desc
           ENDIF
        ELSE
           x_desc = "ban_desban like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_desc
        ENDIF
        _ii_cSql = "select * from u_ban_an where " + x_cond + ;
                                                 " order by ban_codsoc,ban_desban" 
   
   CASE V_SCELTA=4          				&& ACCESSO LOCALITA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_loca = "ban_loca like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_loca
           ENDIF
        ELSE
           x_loca = "ban_loca like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_loca
        ENDIF
        _ii_cSql = "select * from u_ban_an where " + x_cond + ;
                                                 " order by ban_codsoc,ban_loca" 

   CASE V_SCELTA=5          				&& ACCESSO CODICE ABI
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "ban_codabi = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "ban_codabi = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_ban_an where " + x_cond + ;
                                                 " order by ban_codsoc,ban_codabi,ban_codcab" 

   CASE V_SCELTA=6          				&& ACCESSO CODICE CAB
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "ban_codcab = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "ban_codcab = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select * from u_ban_an where " + x_cond + ;
                                                 " order by ban_codsoc,ban_codcab,ban_codabi" 
   
ENDCASE
