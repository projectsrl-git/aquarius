PARAMETERS V_SEEK


XY_LEN1  = '50' 		&& ALLTRIM(WFILT)
WFILT    = "40"
XY_LEN2  = VAL(WFILT) + 1
XY_LEN3  = STR(XY_LEN2,2,0)
XY_LEN4  = ALLTRIM(XY_LEN3)
WPARA    = ALLTRIM(_V_GRUPPIMANU)

DO CASE

   CASE V_SCELTA=1                          && ACCESSO PER CODICE
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           _II_SEEK = WPARA
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, "        + ;
                             "CODICE, "      + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, "    + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, "    + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, "    + ;
                             "INGLESE, FRANCESE, TEDESCO "                 + ;
                      "FROM PARA "                                              + ;
                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "'" + ;
                      "ORDER BY CODICE"
        ELSE
           _II_SEEK = WPARA+ALLTRIM(V_SEEK)
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, "   + ;
                             "CODICE, " + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, "    + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, "    + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, "    + ;
                             "INGLESE, FRANCESE, TEDESCO "                 + ;
                      "FROM PARA "                                         + ;
                      "WHERE CODICE LIKE '" + _II_SEEK + "%' "   + ;
                      "ORDER BY CODICE"
        ENDIF


   CASE V_SCELTA=2                          && ACCESSO PER TIPO MANUTENZIONE
        IF EMPTY(V_SEEK) .OR. SUBSTR(V_SEEK,1,5) = SPACE(05)
           _II_SEEK = WPARA
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, "        + ;
                             "CODICE, "      + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, "    + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, "    + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, "    + ;
                             "INGLESE, FRANCESE, TEDESCO "                 + ;
                      "FROM PARA "                                              + ;
                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "'" + ;
                      "ORDER BY DESCRI"
        ELSE
           _II_SEEK = ALLTRIM(V_SEEK)
           _ii_cSql = "SELECT substring(CODICE,1,"+XY_LEN1+") AS TIPO, "        + ;
                             "CODICE, "      + ;
                             "DESCRI, CODPGO, LIBERA, ITALIANO, NOTE, "    + ;
                             "DESIVA, CLASSE, CONTO1, CONTO2, CONTO3, "    + ;
                             "CONTO4, CONIVA, GG_LAV, PERANT, PERSAL, "    + ;
                             "INGLESE, FRANCESE, TEDESCO "                 + ;
                      "FROM PARA "                                              + ;
                      "WHERE substring(CODICE,1,"+XY_LEN1+") = '" + WPARA + "'" + ;
                      " AND LIBERA LIKE '" + _II_SEEK + "%' "                   + ;
                      "ORDER BY LIBERA"
        ENDIF
        
ENDCASE





