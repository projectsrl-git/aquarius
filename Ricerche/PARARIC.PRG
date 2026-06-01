PARAMETERS V_SEEK



XY_LEN1  = ALLTRIM(WFILT)
XY_LEN2  = VAL(WFILT) + 1
XY_LEN3  = STR(XY_LEN2,2,0)
XY_LEN4  = ALLTRIM(XY_LEN3)


XY_LENTOT = ALLTRIM(STR(VAL(WFILT) + VAL(WLONG)))

*!*	DO CASE

*!*	   CASE V_SCELTA=1                          && ACCESSO PER CODICE
*!*	        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           _II_SEEK = WPARA
*!*	           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
*!*	                             "CODICE, " + ;
*!*	                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
*!*	                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
*!*	                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
*!*	                             "INGLESE, FRANCESE, TEDESCO " + ;
*!*	                      "FROM PARA " + ;
*!*	                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "' " + ;
*!*	                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
*!*	                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
*!*	                      "ORDER BY CODICE"
*!*	        ELSE
*!*	           _II_SEEK = WPARA+ALLTRIM(V_SEEK)
*!*	           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
*!*	                             "CODICE, " + ;
*!*	                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
*!*	                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
*!*	                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
*!*	                             "INGLESE, FRANCESE, TEDESCO " + ;
*!*	                      "FROM PARA " + ;
*!*	                      "WHERE CODICE LIKE '" + _II_SEEK + "%' " + ;
*!*	                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
*!*	                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
*!*	                      "ORDER BY CODICE"
*!*	        ENDIF


*!*	   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE
*!*	        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
*!*	           _II_SEEK = WPARA
*!*	           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
*!*	                             "CODICE, " + ;
*!*	                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
*!*	                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
*!*	                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
*!*	                             "INGLESE, FRANCESE, TEDESCO " + ;
*!*	                      "FROM PARA " + ;
*!*	                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "' " + ;
*!*	                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
*!*	                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
*!*	                      "ORDER BY DESCRI"
*!*	        ELSE
*!*	           _II_SEEK = ALLTRIM(V_SEEK)
*!*	           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
*!*	                             "CODICE, " + ;
*!*	                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
*!*	                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
*!*	                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
*!*	                             "INGLESE, FRANCESE, TEDESCO " + ;
*!*	                      "FROM PARA " + ;
*!*	                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "' " + ;
*!*	                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
*!*	                      "AND DESCRI LIKE '%" + _II_SEEK + "%' " + ;
*!*	                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
*!*	                      "ORDER BY DESCRI"
*!*	        ENDIF
*!*	        
*!*	ENDCASE


**=> ERASMO - INIZIO 31/03/2023
x_tutti = ""
IF _OPZ_TUTTI
ELSE
   x_tutti = " AND DISATTIVO = 0 "
ENDIF

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           _II_SEEK = WPARA
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
                             "CODICE, SUBSTRING(CODICE,"+XY_LEN4+","+WLONG+") AS C_CODICE, " + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
                             "INGLESE, FRANCESE, TEDESCO, " + ;
                             "CASE DISATTIVO WHEN 1 THEN 'SI' ELSE '  ' END AS C_DISATTIVO " + ;
                      "FROM PARA " + ;
                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "' " + x_tutti + ;
                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
                      "ORDER BY CODICE"
        ELSE
           _II_SEEK = WPARA+ALLTRIM(V_SEEK)
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
                             "CODICE, SUBSTRING(CODICE,"+XY_LEN4+","+WLONG+") AS C_CODICE, " + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
                             "INGLESE, FRANCESE, TEDESCO, " + ;
                             "CASE DISATTIVO WHEN 1 THEN 'SI' ELSE '  ' END AS C_DISATTIVO " + ;
                      "FROM PARA " + ;
                      "WHERE CODICE LIKE '" + _II_SEEK + "%' " + x_tutti + ;
                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
                      "ORDER BY CODICE"
        ENDIF


   CASE V_SCELTA=2                          && ACCESSO PER DESCRIZIONE
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           _II_SEEK = WPARA
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
                             "CODICE, SUBSTRING(CODICE,"+XY_LEN4+","+WLONG+") AS C_CODICE, " + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
                             "INGLESE, FRANCESE, TEDESCO, " + ;
                             "CASE DISATTIVO WHEN 1 THEN 'SI' ELSE '  ' END AS C_DISATTIVO " + ;
                      "FROM PARA " + ;
                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "' " + x_tutti + ;
                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
                      "ORDER BY DESCRI"
        ELSE
           _II_SEEK = ALLTRIM(V_SEEK)
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
                             "CODICE, SUBSTRING(CODICE,"+XY_LEN4+","+WLONG+") AS C_CODICE, " + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
                             "INGLESE, FRANCESE, TEDESCO, " + ;
                             "CASE DISATTIVO WHEN 1 THEN 'SI' ELSE '  ' END AS C_DISATTIVO " + ;
                      "FROM PARA " + ;
                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "' " + x_tutti + ;
                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
                      "AND DESCRI LIKE '%" + _II_SEEK + "%' " + ;
                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
                      "ORDER BY DESCRI"
        ENDIF
        
   **=> ERASMO - INIZIO 13/12/2024
   CASE V_SCELTA=3                          && ACCESSO PER CODICE CONV.
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           _II_SEEK = WPARA
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
                             "CODICE, SUBSTRING(CODICE,"+XY_LEN4+","+WLONG+") AS C_CODICE, " + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
                             "INGLESE, FRANCESE, TEDESCO, " + ;
                             "CASE DISATTIVO WHEN 1 THEN 'SI' ELSE '  ' END AS C_DISATTIVO " + ;
                      "FROM PARA " + ;
                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "' " + x_tutti + ;
                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
                      "ORDER BY CODPGO"
        ELSE
           _II_SEEK = ALLTRIM(V_SEEK)
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
                             "CODICE, SUBSTRING(CODICE,"+XY_LEN4+","+WLONG+") AS C_CODICE, " + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
                             "INGLESE, FRANCESE, TEDESCO, " + ;
                             "CASE DISATTIVO WHEN 1 THEN 'SI' ELSE '  ' END AS C_DISATTIVO " + ;
                      "FROM PARA " + ;
                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "' " + x_tutti + ;
                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
                      "AND CODPGO LIKE '%" + _II_SEEK + "%' " + ;
                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
                      "ORDER BY CODPGO"
        ENDIF
        
   CASE V_SCELTA=4                          && ACCESSO PER LIBERA
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           _II_SEEK = WPARA
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
                             "CODICE, SUBSTRING(CODICE,"+XY_LEN4+","+WLONG+") AS C_CODICE, " + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
                             "INGLESE, FRANCESE, TEDESCO, " + ;
                             "CASE DISATTIVO WHEN 1 THEN 'SI' ELSE '  ' END AS C_DISATTIVO " + ;
                      "FROM PARA " + ;
                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "' " + x_tutti + ;
                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
                      "ORDER BY LIBERA"
        ELSE
           _II_SEEK = ALLTRIM(V_SEEK)
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, " + ;
                             "CODICE, SUBSTRING(CODICE,"+XY_LEN4+","+WLONG+") AS C_CODICE, " + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, " + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, " + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, " + ;
                             "INGLESE, FRANCESE, TEDESCO, " + ;
                             "CASE DISATTIVO WHEN 1 THEN 'SI' ELSE '  ' END AS C_DISATTIVO " + ;
                      "FROM PARA " + ;
                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "' " + x_tutti + ;
                      "AND substring(CODICE,"+XY_LEN4+",1) <> ' ' " + ;
                      "AND LIBERA LIKE '%" + _II_SEEK + "%' " + ;
                      "AND LEN(RTRIM(CODICE)) <= " + XY_LENTOT + " " + ;
                      "ORDER BY LIBERA"
        ENDIF
   **=> ERASMO - FINE 13/12/2024
        
ENDCASE
**=> ERASMO - FINE 31/03/2023
