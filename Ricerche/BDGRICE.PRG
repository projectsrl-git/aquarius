PARAMETERS V_SEEK

x_soci = "1 = 1"
x_anno = "BDG_ANNO = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

_CAMPI = "BDG_ANNO,BDG_CODCLI,SUBSTRING(BDG_RAGSOC,1,40) AS BDG_RAGSOC,BDG_CODNAZ,SUBSTRING(BDG_DESNAZ,1,20) AS BDG_DESNAZ,BDG_UM,BDG_TIPART,BDG_QTATOT"
	
DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER Codice cliente
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "bdg_codcli = '" + IIF(ALLTRIM(V_SEEK)="VARI",ALLTRIM(V_SEEK),TRC(PUB_LCL,ALLTRIM(V_SEEK))) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select &_CAMPI from u_bdg_an where " + x_cond + " order by bdg_anno,bdg_codcli,bdg_codnaz,bdg_um" 
        ELSE
           x_tipo = "bdg_codcli = '" + IIF(ALLTRIM(V_SEEK)="VARI",ALLTRIM(V_SEEK),TRC(PUB_LCL,ALLTRIM(V_SEEK))) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select &_CAMPI from u_bdg_an where " + x_cond + " order by bdg_anno,bdg_codcli,bdg_codnaz,bdg_um" 
        
   CASE V_SCELTA=2                          && ACCESSO PER Ragione sociale
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "bdg_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select &_CAMPI from u_bdg_an where " + x_cond + " order by bdg_anno,bdg_ragsoc,bdg_codnaz,bdg_um" 
        ELSE
           x_tipo = "bdg_ragsoc like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select &_CAMPI from u_bdg_an where " + x_cond + " order by bdg_anno,bdg_ragsoc,bdg_codnaz,bdg_um" 
        
   CASE V_SCELTA=3                          && ACCESSO PER Nazione
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "bdg_codnaz like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           _ii_cSql   = "select &_CAMPI from u_bdg_an where " + x_cond + " order by bdg_anno,bdg_codnaz,bdg_ragsoc,bdg_um" 
        ELSE
           x_tipo = "bdg_codnaz like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = "select &_CAMPI from u_bdg_an where " + x_cond + " order by bdg_anno,bdg_codnaz,bdg_ragsoc,bdg_um" 
                                                           
ENDCASE
