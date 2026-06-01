PARAMETERS V_SEEK

*x_cond = "ANNOXFATT = '" + PUB_ANNO + "'"

**=> ERASMO - INIZIO 25/06/2010
x_soci = "1 = 1"
x_anno = "SUBSTRING(DATAINIZIO,1,4) = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF
**=> ERASMO - FINE 25/06/2010

**=> ERASMO - INIZIO 12/07/2010
x_sele = 	"SELECT CASE WHEN len(rtrim(RAGSOC)) > 25 THEN SUBSTRING(RAGSOC,1,22)+'...' ELSE SUBSTRING(RAGSOC,1,25) END AS STR_RAGSOC, " + ;
			"CASE WHEN len(rtrim(DESATTIV)) > 30 THEN SUBSTRING(DESATTIV,1,27)+'...' ELSE SUBSTRING(DESATTIV,1,30) END AS STR_DESATTIV, " + ;
			"CASE XFATTURAZ WHEN 1 THEN 'SI    ' WHEN 0 THEN 'NO    ' ELSE '      ' END AS STR_XFATTURAZ, " + ;
			"CASE FLGFATTURAB WHEN 1 THEN 'SI    ' WHEN 0 THEN 'NO    ' ELSE '      ' END AS STR_FLGFATTURAB, " + ;
			"CASE DATAINIZIO WHEN '' THEN '' ELSE ISNULL(SUBSTRING(DATAINIZIO,9,2)+'/'+SUBSTRING(DATAINIZIO,6,2)+'/'+SUBSTRING(DATAINIZIO,1,4),'') END AS R_DATAINIZIO, " + ;
			"CASE DATAFINE WHEN '' THEN '' ELSE ISNULL(SUBSTRING(DATAFINE,9,2)+'/'+SUBSTRING(DATAFINE,6,2)+'/'+SUBSTRING(DATAFINE,1,4),'') END AS R_DATAFINE, " + ;
			"* FROM attivitanc WHERE "
**=> ERASMO - FINE 12/07/2010

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE CLIENTE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))
              x_codi   = "CODCLI = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           V_SEEK = TRC(PUB_LCL,ALLTRIM(V_SEEK))        
           x_codi   = "CODCLI = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by CODCLI,DATAINIZIO" 

   **=> ERASMO - INIZIO 12/07/2010
   CASE V_SCELTA=2          				&& ACCESSO PER RAG.SOCIALE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "RAGSOC LIKE '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE      
           x_codi   = "RAGSOC LIKE '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by RAGSOC,CODCLI,DATAINIZIO" 
 		
   CASE V_SCELTA=3          				&& ACCESSO PER CODICE ATTIVITA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              V_SEEK = TRC(5,ALLTRIM(V_SEEK))
              x_codi   = "CODATTIV = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           V_SEEK = TRC(5,ALLTRIM(V_SEEK))        
           x_codi   = "CODATTIV = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by CODATTIV,CODCLI,DATAINIZIO" 
  
   CASE V_SCELTA=4          				&& ACCESSO PER DESCRIZIONE ATTIVITA'
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "DESATTIV LIKE '" + ALLTRIM(V_SEEK) + "%'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE      
           x_codi   = "DESATTIV LIKE '" + ALLTRIM(V_SEEK) + "%'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by DESATTIV,CODCLI,DATAINIZIO" 

   CASE V_SCELTA=5          				&& ACCESSO PER MESE DI FATTURAZIONE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "MESEXFATT = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "MESEXFATT = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by MESEXFATT,CODCLI,DATAINIZIO" 

   **=> ERASMO - FINE 12/07/2010
   
ENDCASE
