PARAMETERS V_SEEK

x_anno = "substring(ord_datreg,1,4) = '" + PUB_ANNO + "'"
*x_cond = "1=1"
**=> ERASMO - INIZIO 17/01/2024
IF _OPZ_TUTTI
	x_cond = "1=1"
ELSE
	x_cond = "ord_close = 0"
ENDIF
**=> ERASMO - FINE 17/01/2024
IF DOC_ANNO
   x_cond = x_cond + " and " + x_anno
ENDIF

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              *x_codi   = "ord_codice = '" + ALLTRIM(V_SEEK) + "'"
              x_codi   = "ord_codric like '%" + ALLTRIM(V_SEEK) + "%'"  && ERASMO - 19/01/2024
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           *x_codi   = "ord_codice = '" + ALLTRIM(V_SEEK) + "'"
           x_codi   = "ord_codric like '%" + ALLTRIM(V_SEEK) + "%'"  && ERASMO - 19/01/2024
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select  substring(ord_noteric,1,254) as ord_noteric_r,dbo.ribalta2(ord_datreg) as ord_data_r,dbo.ribalta2(ord_dtults) as ord_dtults_r, * from IMPIANTI_RI where " + x_cond + ;
                   " order by ord_codric" 

   CASE V_SCELTA=2          				&& ACCESSO PER DATA
 		
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "ord_data = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
          ELSE
           x_data = "ord_data = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select substring(ord_noteric,1,254) as ord_noteric_r,dbo.ribalta2(ord_datreg) as ord_data_r,dbo.ribalta2(ord_dtults) as ord_dtults_r, * from IMPIANTI_RI where " + x_cond + ;
 		           " order by ord_datreg,ord_codric" 

   **=> ERASMO - INIZIO 16/02/2024
   CASE V_SCELTA=3          				&& ACCESSO PER DATA ULTIMO SOLLECITO
 		
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_data = "ord_dtults = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
              x_cond = x_cond + " and " + x_data
           ENDIF
          ELSE
           x_data = "ord_dtults = '" + RIBALTA2(ALLTRIM(V_SEEK)) + "'"
           x_cond = x_cond + " and " + x_data
        ENDIF
        _ii_cSql   = "select substring(ord_noteric,1,254) as ord_noteric_r,dbo.ribalta2(ord_datreg) as ord_data_r,dbo.ribalta2(ord_dtults) as ord_dtults_r, * from IMPIANTI_RI where " + x_cond + ;
 		           " order by ord_dtults,ord_datreg,ord_codric" 
   **=> ERASMO - FINE 16/02/2024


   CASE V_SCELTA=4          				&& CODICE IMPIANTO (TESTO CONTENUTO)


        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_impia = "ord_ccodsche like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_impia 
           ENDIF
           _ii_cSql   = x_cond + " order by ord_ccodsche" 
        ELSE
           x_impia = "ord_ccodsche like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_impia 
        ENDIF
        _ii_cSql = "select  substring(ord_noteric,1,254) as ord_noteric_r,dbo.ribalta2(ord_datreg) as ord_data_r,dbo.ribalta2(ord_dtults) as ord_dtults_r, * from IMPIANTI_RI where " + x_cond + ;
                   " order by ord_ccodsche" 



   CASE V_SCELTA=5          				&& CODICE CLIENTE
 
        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_codi   = "ord_codcli = '" + ALLTRIM(V_SEEK) + "'"
              x_cond   = x_cond + " and " + x_codi
           ENDIF
        ELSE
           x_codi   = "ord_codcli = '" + ALLTRIM(V_SEEK) + "'"
           x_cond   = x_cond + " and " + x_codi
        ENDIF
        _ii_cSql = "select  substring(ord_noteric,1,254) as ord_noteric_r,dbo.ribalta2(ord_datreg) as ord_data_r,dbo.ribalta2(ord_dtults) as ord_dtults_r, * from IMPIANTI_RI where " + x_cond + ;
                   " order by ord_codcli" 
 
 
 
   CASE V_SCELTA=6          				&& RAGIONE SOCIALE CLIENTE

        IF PUB_VISRIC 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_rags = "ord_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_rags
           ENDIF
           _ii_cSql   = x_cond + " order by ord_ragsoc" 
        ELSE
           x_rags = "ord_ragsoc like '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_rags
        ENDIF

        _ii_cSql = "select  substring(ord_noteric,1,254) as ord_noteric_r,dbo.ribalta2(ord_datreg) as ord_data_r,dbo.ribalta2(ord_dtults) as ord_dtults_r, * from IMPIANTI_RI where " + x_cond + ;
                   " order by ord_ragsoc" 
                   
   **=> ERASMO - INIZIO 15/03/2024
   CASE V_SCELTA=7          				&& ACCESSO PER CODICE ZONA
 		
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_zona = "ord_zona = '" + ALLTRIM(V_SEEK) + "'"
              x_cond = x_cond + " and " + x_zona
           ENDIF
          ELSE
           x_zona = "ord_zona = '" + ALLTRIM(V_SEEK) + "'"
           x_cond = x_cond + " and " + x_zona
        ENDIF
        _ii_cSql   = "select substring(ord_noteric,1,254) as ord_noteric_r,dbo.ribalta2(ord_datreg) as ord_data_r,dbo.ribalta2(ord_dtults) as ord_dtults_r, * from IMPIANTI_RI where " + x_cond + ;
 		           " order by ord_zona,ord_datreg,ord_codric" 
   **=> ERASMO - FINE 15/03/2024

   **=> ERASMO - INIZIO 26/08/2024
   CASE V_SCELTA=8          				&& ACCESSO PER NOTE
 		
        IF PUB_VISRID 
           IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           ELSE
              x_note = "SUBSTRING(ORD_NOTERIC,1,8000) LIKE '%" + ALLTRIM(V_SEEK) + "%'"
              x_cond = x_cond + " and " + x_note 
           ENDIF
          ELSE
           x_note = "SUBSTRING(ORD_NOTERIC,1,8000) LIKE '%" + ALLTRIM(V_SEEK) + "%'"
           x_cond = x_cond + " and " + x_note 
        ENDIF
        _ii_cSql   = "select substring(ord_noteric,1,254) as ord_noteric_r,dbo.ribalta2(ord_datreg) as ord_data_r,dbo.ribalta2(ord_dtults) as ord_dtults_r, * from IMPIANTI_RI where " + x_cond + ;
 		           " order by ord_datreg,ord_codric" 
   **=> ERASMO - FINE 26/08/2024

  
ENDCASE
