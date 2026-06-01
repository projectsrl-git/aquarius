PARAMETERS V_SEEK

x_soci = "1 = 1"
x_anno = "SUBSTRING(DATA,1,4) = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

x_sele = "select SUBSTRING(DATA,1,4) AS ANNO, " + ;
         "SUBSTRING(ISNULL((SELECT TOP 1 DESATTIV FROM CONTRST_DD WHERE DAGGANCIO = contrstudi.TAGGANCIO ORDER BY SEQUEN),''),1,30) AS C_DESATTIV, " + ;
         "CASE CHIUSO WHEN 1 THEN 'Chiuso' WHEN 0 THEN 'Aperto' ELSE '' END AS C_CHIUSO, SUBSTRING(RAGSOC,1,40) AS C_RAGSOC, " + ;
         "CASE DATA WHEN '' THEN '' ELSE ISNULL(SUBSTRING(DATA,9,2)+'/'+SUBSTRING(DATA,6,2)+'/'+SUBSTRING(DATA,1,4),'') END AS R_DATA, * from contrstudi WHERE "

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER NUMERO
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nume = "NUMERO = '" + TRC(5,ALLTRIM(V_SEEK))  + "'"
              x_cond = x_cond + " and " + x_nume
           ENDIF
        ELSE
           x_nume = "NUMERO = '" + TRC(5,ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_nume
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by ANNO,NUMERO,DATA" 
        
   CASE V_SCELTA=2                          && ACCESSO PER DATA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "DATA = '" + RIBALTA2(V_SEEK)  + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "DATA = '" + RIBALTA2(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by ANNO,DATA,NUMERO" 
        
   CASE V_SCELTA=3                          && ACCESSO PER COD.CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clie = "CODCLI = '" + TRC(PUB_LCL,ALLTRIM(V_SEEK))  + "'"
              x_cond = x_cond + " and " + x_clie 
           ENDIF
        ELSE
           x_clie = "CODCLI = '" + TRC(PUB_LCL,ALLTRIM(V_SEEK))  + "'"
           x_cond = x_cond + " and " + x_clie 
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by ANNO,CODCLI,NUMERO" 
        
   CASE V_SCELTA=4                          && ACCESSO PER RAG.SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clie = "RAGSOC like '" + ALLTRIM(V_SEEK)  + "%'"
              x_cond = x_cond + " and " + x_clie 
           ENDIF
        ELSE
           x_clie = "RAGSOC like '" + ALLTRIM(V_SEEK)  + "%'"
           x_cond = x_cond + " and " + x_clie 
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by ANNO,RAGSOC,NUMERO" 
        
   CASE V_SCELTA=5                          && ACCESSO PER RAG.SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_clse = IIF(ALLTRIM(V_SEEK)=='A',"CHIUSO = 0",IIF(ALLTRIM(V_SEEK)=='C',"CHIUSO = 1","1=1"))
              x_cond = x_cond + " and " + x_clse 
           ENDIF
        ELSE
           x_clse = IIF(ALLTRIM(V_SEEK)=='A',"CHIUSO = 0",IIF(ALLTRIM(V_SEEK)=='C',"CHIUSO = 1","1=1"))
           x_cond = x_cond + " and " + x_clse 
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by ANNO,CHIUSO,NUMERO" 

ENDCASE

RETURN

		