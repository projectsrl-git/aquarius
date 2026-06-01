PARAMETERS V_SEEK

x_soci = "1 = 1"
*x_anno = "SUBSTRING(DATA,1,4) = '" + PUB_ANNO + "'"
x_cond = x_soci
IF DOC_ANNO
   *x_cond = x_cond + " and " + x_anno
ENDIF

x_sele = "select SUBSTRING(ISNULL((SELECT TOP 1 UMCOSTO FROM COSTIST_DD WHERE DAGGANCIO = costistudi.TAGGANCIO ORDER BY SEQUEN),''),1,2) AS C_UMCOSTO, " + ;
         "ISNULL((SELECT TOP 1 UMCOSTO FROM COSTIST_DD WHERE DAGGANCIO = costistudi.TAGGANCIO ORDER BY SEQUEN),0) AS N_COSTO, * from costistudi WHERE "

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE RISORSA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_nume = "CODRIS = '" + TRC(5,ALLTRIM(V_SEEK))  + "'"
              x_cond = x_cond + " and " + x_nume
           ENDIF
        ELSE
           x_nume = "CODRIS = '" + TRC(5,ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_nume
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by CODRIS" 
        
   CASE V_SCELTA=2                          && ACCESSO PER COGNOME E/O NOME RISORSA
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "DESRIS like '%" + RIBALTA2(V_SEEK)  + "%'"
              x_cond = x_cond + " and " + x_data
           ENDIF
        ELSE
           x_data = "DESRIS like '%" + RIBALTA2(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql = x_sele + x_cond + " order by DESRIS" 

ENDCASE

RETURN

		