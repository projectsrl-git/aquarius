PARAMETERS V_SEEK

x_soci = "1 = 1"
x_anno = "SUBSTRING(D_DATA,1,4) = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

x_sele = "select SUBSTRING(Titolo,1,100) as Titolo_STR, CASE B_Interna WHEN 1 THEN 'Interna' WHEN 2 THEN 'Esterna' ELSE '' END AS C_Interna, " + ;
         "ISNULL(SUBSTRING(CLIE_C.RAGSOC_C,1,30),'') AS RAGSOC_F, " + ;
         "SUBSTRING(ISNULL((SELECT TOP 1 DESSOGG FROM COMMESSA_DC WHERE IDCOMMESSAD = commessa_tt.IDCOMMESSA ORDER BY SEQUEN),''),1,30) AS DESSOGG_C, " + ;
         "CASE B_Chiusa WHEN 1 THEN 'Chiusa' WHEN 0 THEN 'Aperta' ELSE '' END AS C_Chiusa, " + ;
         "CASE D_DATA WHEN '' THEN '' ELSE ISNULL(SUBSTRING(D_DATA,9,2)+'/'+SUBSTRING(D_DATA,6,2)+'/'+SUBSTRING(D_DATA,1,4),'') END AS R_DATA, " + ;
         "CASE D_INIZIO WHEN '' THEN '' ELSE ISNULL(SUBSTRING(D_INIZIO,9,2)+'/'+SUBSTRING(D_INIZIO,6,2)+'/'+SUBSTRING(D_INIZIO,1,4),'') END AS R_INIZIO, " + ;
         "CASE D_FINE WHEN '' THEN '' ELSE ISNULL(SUBSTRING(D_FINE,9,2)+'/'+SUBSTRING(D_FINE,6,2)+'/'+SUBSTRING(D_FINE,1,4),'') END AS R_FINE, " + ;
         "* from commessa_tt " + ;
         "LEFT OUTER JOIN (SELECT DISTINCT IDCOMMESSAC,RAGSOC AS RAGSOC_C FROM CLIENTIC WHERE CLIENTEXFAT = 1) AS CLIE_C ON COMMESSA_TT.IDCOMMESSA = CLIE_C.IDCOMMESSAC WHERE "

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "Codice like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           *_ii_cSql   = x_sele + x_cond + " order by Codice,D_Data" 
        ELSE
           x_tipo = "Codice like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by Codice,D_Data" 
                                                   
   CASE V_SCELTA=2                          && ACCESSO PER DATA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "D_Data = '" + RIBALTA2(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           *_ii_cSql   = x_sele + x_cond + " order by D_Data,Codice" 
        ELSE
           x_tipo = "D_Data = '" + RIBALTA2(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by D_Data,Codice" 
                                                   
   **=> ERASMO - INIZIO 23/04/2009
   CASE V_SCELTA=3                          && ACCESSO PER Tipo (Interna=1/Esterna=2)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "B_Interna = " + ALLTRIM(V_SEEK)
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           *_ii_cSql   = x_sele + x_cond + " order by B_Interna,Codice" 
        ELSE
           x_tipo = "B_Interna = " + ALLTRIM(V_SEEK)
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by B_Interna,Codice" 
                                                   
   CASE V_SCELTA=4                          && ACCESSO PER Aperta/Chiusa (A/C)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "B_Chiusa = " + IIF(ALLTRIM(V_SEEK)='C',"1",IIF(ALLTRIM(V_SEEK)='A',"0","B_Chiusa"))
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           *_ii_cSql   = x_sele + x_cond + " order by C_Chiusa desc,Codice" 
        ELSE
           x_tipo = "B_Chiusa = " + IIF(ALLTRIM(V_SEEK)='C',"1",IIF(ALLTRIM(V_SEEK)='A',"0","B_Chiusa"))
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by C_Chiusa desc,Codice" 
                                                   
   CASE V_SCELTA=5                          && ACCESSO PER Cliente (Rag.soc.)
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_tipo = "RAGSOC_C like '" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_tipo 
           ENDIF
           *_ii_cSql   = x_sele + x_cond + " order by RAGSOC_C,Codice" 
        ELSE
           x_tipo = "RAGSOC_C like '" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_tipo 
        ENDIF
        _ii_cSql   = x_sele + x_cond + " order by RAGSOC_C,Codice" 
                                                   
   **=> ERASMO - FINE 23/04/2009

ENDCASE

RETURN

		