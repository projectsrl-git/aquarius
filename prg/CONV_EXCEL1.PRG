RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei dati del foglio excel anni 2000/1/2/3 ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

WAIT WINDOWS "ATTENDERE PREGO, INIZIALIZZAZIONE ARCHIVIO." NOWAIT

cSql = "delete from u_exc_el"
IF !ExecCommand(cSql,"U_EXC_EL")
   return(.f.)
ENDIF

PUBLIC Y_CAMPO,V_CAMPO,_CTR
Y_CAMPO = ""
V_CAMPO = ""
_CTR    = 0

cSql   = "select * from u_per_an where 1=0"
IF !ExecCommand(cSql,"CUR_PER_AN")
   return(.f.)
ENDIF

cSql   = "select * from u_con_pe where 1=0"
IF !ExecCommand(cSql,"CUR_CON_PE")
   return(.f.)
ENDIF

=OPENDB("PROVA_RINO")
SELECT PROVA_RINO
GO TOP

DELETE FOR SUBSTR(N1,1,4) = 'NOME'   		ALL
DELETE FOR SUBSTR(N1,1,6) = 'TOTALI' 		ALL
DELETE FOR SUBSTR(N1,1,4) = 'N.B.'   		ALL
DELETE FOR SUBSTR(N1,1,4) = '    ' .AND. ;
           SUBSTR(N2,1,2) = '  ' .AND. ;
           SUBSTR(N3,1,4) = '    ' .AND. ;
           SUBSTR(N4,1,3) = '   ' .AND. ;
           SUBSTR(N5,1,4) = '    ' .AND. ;
           SUBSTR(N6,1,4) = '    ' .AND. ;
           SUBSTR(ANNO_2000,1,2) = ' ' 	.AND. ;
           SUBSTR(ANNO_2001,1,2) = ' ' 	.AND. ;
           SUBSTR(ANNO_2002,1,2) = ' ' 	.AND. ;
           SUBSTR(ANNO_2003,1,2) = ' ' 	   	ALL


V_CONTA = 0

V_PROGRE = 1
V_SEQUEN = 1

SELECT PROVA_RINO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   * GESTIONE ANNO 2000

   X_DESCRI = ALLTRIM(N1)
   X_DESCRI = UPPER(X_DESCRI)
   X_DESCRI = APITOSPA(X_DESCRI)

   IF X_DESCRI = 'RUBANO'
      M.EXE_CODPDV = '017'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF

   IF X_DESCRI = 'LAMEZIA'
      M.EXE_CODPDV = '031'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF

   IF X_DESCRI = 'DECATHLON'
      M.EXE_CODPDV = '035'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF

   IF X_DESCRI = 'BOLZANETTO'
      M.EXE_CODPDV = '036'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF

   IF X_DESCRI = 'VARAZZE'
      M.EXE_CODPDV = '045'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF

   IF X_DESCRI = 'ROMANINA'
      M.EXE_CODPDV = '047'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF

   IF X_DESCRI = 'BOARIO'
      M.EXE_CODPDV = '060'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF
         
   IF X_DESCRI = 'PORTO S. ELPIDIO'
      M.EXE_CODPDV = '061'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF

   IF X_DESCRI = 'PERGINE'
      M.EXE_CODPDV = '062'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF

   IF X_DESCRI = 'PISA'
      M.EXE_CODPDV = '063'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF

   IF X_DESCRI = 'CASALE'
      M.EXE_CODPDV = '064'
      M.EXE_DESPDV = X_DESCRI
      x_cond       = "pdv_codice = '" + ALLTRIM(M.EXE_CODPDV) + "'" 
      cSql         = "select * from u_pdv_an where " + x_cond
      IF !ExecRW(cSql,"U_PDV_AN","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AN
      IF EOF()
         APPEND BLANK
         REPLACE PDV_CODICE WITH M.EXE_CODPDV
         REPLACE PDV_DESCRI WITH M.EXE_DESPDV
      ENDIF   
      IF !ExecRW(cSql,"U_PDV_AN","W")
         return(.f.)
      ENDIF
      V_SEQUEN = 1
      SELECT PROVA_RINO
      SKIP +1
      LOOP
   ENDIF

   IF X_DESCRI = 'VERONA'
      REPLACE N1 WITH 'VERONA 1'
   ENDIF
         
   IF SUBSTR(N1,1,4) = '    '
   ELSE
      IF SUBSTR(N5,1,4) = '    ' 
         IF X_DESCRI = 'NEGOZIO DI FIUMARA 1' .OR. ;
            X_DESCRI = 'NEGOZIO DI TRAGHETTI' .OR. ;
            X_DESCRI = 'NEGOZIO DI ROVIGO' .OR. ;
            X_DESCRI = 'NEGOZIO FIUMARA 1' .OR. ;
            X_DESCRI = 'NEGOZIO DI PISA' .OR. ;
            X_DESCRI = 'NEGOZIO DI ORIO' .OR. ;
            X_DESCRI = 'BIANCHI MARCO' .OR. ;
            X_DESCRI = 'ZANZI MARIA FRANCESCA' .OR. ;
            X_DESCRI = 'BARONCELLI VALENTINA' .OR. ;
            X_DESCRI = 'SCOLARO SERENA' .OR. ;
            X_DESCRI = 'BILANC. DI CASALE' 
         ELSE
            M.EXE_DESPDV = ALLTRIM(N1)
            M.EXE_DESPDV = UPPER(M.EXE_DESPDV)
            M.EXE_DESPDV = APITOSPA(M.EXE_DESPDV)
            x_cond       = "pdv_descri = '" + ALLTRIM(M.EXE_DESPDV) + "'" 
            cSql         = "select * from u_pdv_an where " + x_cond
            IF !ExecCommand(cSql,"U_PDV_AN")
               return(.f.)
            ENDIF
            SELECT U_PDV_AN
            IF RECCOUNT() <> 0
               M.EXE_CODPDV = ALLTRIM(PDV_CODICE)
            ELSE
               M.EXE_CODPDV = SPACE(10)
   	        ENDIF
            V_SEQUEN = 1
            SELECT PROVA_RINO
            SKIP +1
            LOOP
         ENDIF
      ENDIF
   ENDIF

   IF SUBSTR(N1,1,4) = '    ' 
      V_SEQUEN = V_SEQUEN +1
   ENDIF

   M.EXE_NUMRIG = NUMRIG
   M.EXE_TIPCON = ALLTRIM(N2)
   M.EXE_TIPCOL = ALLTRIM(N4)

   X_PERCENT    = ALLTRIM(N3)
   IF SUBSTR(X_PERCENT,1,2) = '0'
      M.EXE_PERCON = 0
   ELSE
      X_LEN        = LEN(X_PERCENT)
      M.EXE_PERCON = VAL(SUBSTR(X_PERCENT,1,X_LEN-1))
   ENDIF
   M.EXE_TIPCOL = ALLTRIM(N4)

   X_DATA       = ALLTRIM(N5)
   IF SUBSTR(X_DATA,1,2) = '  '
      M.EXE_DATINI = SPACE(10)
   ELSE
      GGMM = SUBSTR(X_DATA,1,6)
      AA   = VAL(SUBSTR(X_DATA,7,2))
      AAAA = ALLTRIM(STR(AA,2,0))
      IF LEN(AAAA) = 2
      ELSE
         AAAA = '0' + AAAA
      ENDIF
      IF AA > 50
         M.EXE_DATINI = GGMM + '19' + AAAA
      ELSE
         M.EXE_DATINI = GGMM + '20' + AAAA
      ENDIF
   ENDIF

   X_DATA       = ALLTRIM(N6)
   IF SUBSTR(X_DATA,1,2) = '  '
      M.EXE_DATFIN = SPACE(10)
   ELSE
      GGMM = SUBSTR(X_DATA,1,6)
      AA   = VAL(SUBSTR(X_DATA,7,2))
      AAAA = ALLTRIM(STR(AA,2,0))
      IF LEN(AAAA) = 2
      ELSE
         AAAA = '0' + AAAA
      ENDIF
      IF AA > 50
         M.EXE_DATFIN = GGMM + '19' + AAAA
      ELSE
         M.EXE_DATFIN = GGMM + '20' + AAAA
      ENDIF
   ENDIF

   M.EXE_PROGRE = V_PROGRE
   M.EXE_SEQUEN = V_SEQUEN
   M.EXE_ANNO   = '2000'
   
   X_PERCENT    = ALLTRIM(ANNO_2000)
   IF SUBSTR(X_PERCENT,1,2) = '0'
      M.EXE_PERBIL = 0
   ELSE
      X_LEN        = LEN(X_PERCENT)
      M.EXE_PERBIL = VAL(SUBSTR(X_PERCENT,1,X_LEN-1))
   ENDIF

   M.EXE_DESPER = N8
   
   V_CAMPO      = ALLTRIM(N9)
   DO TOGLI_PUNTI
   M.EXE_UCLMES = VAL(ALLTRIM(Y_CAMPO))
   
   V_CAMPO      = ALLTRIM(N10)
   DO TOGLI_PUNTI
   M.EXE_UCNMES = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N11)
   DO TOGLI_PUNTI
   M.EXE_COLANN = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N12)
   DO TOGLI_PUNTI
   M.EXE_CONANN = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N13)
   DO TOGLI_PUNTI
   M.EXE_VALINC = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N14)
   DO TOGLI_PUNTI
   M.EXE_PERINC = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N15)
   DO TOGLI_PUNTI
   M.EXE_VALUTI = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N16)
   DO TOGLI_PUNTI
   M.EXE_PERUTI = VAL(ALLTRIM(Y_CAMPO))

   IF SUBSTR(N1,1,4) = '    ' 
   ELSE
      M.EXE_DESCOL = ALLTRIM(N1)
      M.EXE_DESCOL = UPPER(M.EXE_DESCOL)
      M.EXE_DESCOL = APITOSPA(M.EXE_DESCOL)
      x_soci = "per_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "per_ragsoc = '" + ALLTRIM(M.EXE_DESCOL) + "'"
      x_cond = x_soci + " and " + x_codi
      cSql   = "select * from u_per_an where " + x_cond
      IF !ExecCommand(cSql,"CU_PER_AN")
         return(.f.)
      ENDIF
      SELECT CU_PER_AN
      IF RECCOUNT() <> 0
         M.EXE_CODCOL = PER_CODICE
      ELSE
         V_CODICE = M.EXE_CODPDV + '01'
         DO WHILE .T.
            x_soci = "per_codsoc = '" + PUB_CODSOC + "'"
            x_codi = "per_codice = '" + ALLTRIM(V_CODICE) + "'"
            x_cond = x_soci + " and " + x_codi
            cSql   = "select * from u_per_an where " + x_cond
            IF !ExecRW(cSql,"U_PER_AN","R")
               return(.f.)
            ENDIF
            SELECT U_PER_AN
            IF EOF()
               APPEND BLANK
               REPLACE PER_CODSOC WITH PUB_CODSOC
               REPLACE PER_CODICE WITH V_CODICE
               REPLACE PER_RAGSOC WITH M.EXE_DESCOL
               IF M.EXE_TIPCON = 'P'
                  REPLACE PER_TIPPER WITH 'P'
                  REPLACE PER_TIPCON WITH '001'
                  REPLACE PER_DESCON WITH 'PROCURATORE'
               ENDIF
               IF M.EXE_TIPCON = 'C'
                  REPLACE PER_TIPCON WITH '003'
                  REPLACE PER_DESCON WITH 'COLLABORAZIONE COORDINATA E CONTINUATIVA'
               ENDIF
               IF M.EXE_TIPCON = 'A'
                  REPLACE PER_TIPCON WITH '002'
                  REPLACE PER_DESCON WITH 'ASSOCIATO'
               ENDIF
               REPLACE PER_DATCON WITH M.EXE_DATINI
               REPLACE PER_CODPDV WITH M.EXE_CODPDV
               REPLACE PER_DESPDV WITH M.EXE_DESPDV
               REPLACE PER_CODCON WITH ALLTRIM(M.EXE_CODPDV) + ALLTRIM(M.EXE_TIPCOL) + '/1'
               IF M.EXE_TIPCOL = 'PT'
                  REPLACE PER_DSCONT WITH 'PART TIME ' + ALLTRIM(M.EXE_DESPDV)
               ELSE
                  REPLACE PER_DSCONT WITH 'FULL TIME ' + ALLTRIM(M.EXE_DESPDV)
               ENDIF
               REPLACE PER_DATINI WITH M.EXE_DATINI
               REPLACE PER_DATFIN WITH M.EXE_DATFIN
               REPLACE PER_COMLOR WITH M.EXE_UCLMES
               REPLACE PER_PERCON WITH M.EXE_PERCON
               REPLACE PER_PFTCON WITH M.EXE_TIPCOL
               SCATTER MEMVAR
               M.EXE_CODCOL = M.PER_CODICE
               V_CODCON = ALLTRIM(M.EXE_CODPDV) + ALLTRIM(M.EXE_TIPCOL) + '/'
               V_NUMERO = 1
               M.PER_CODCON = V_CODCON + ALLTRIM(STR(V_NUMERO,3,0))
               DO WHILE .T.
                  x_codi   = "con_codice = '" + ALLTRIM(M.PER_CODCON) + "'"
                  x_cond   = x_codi
                  cSql     = "select * from u_con_pe where " + x_cond
                  IF !ExecRW(cSql,"CU_CON_PE","R")
                     return(.f.)
                  ENDIF
                  SELECT CU_CON_PE
                  GO TOP
                  IF EOF()
                     SELECT CUR_CON_PE
                     APPEND BLANK
                     REPLACE CON_CODICE WITH ALLTRIM(M.PER_CODCON) 
                     REPLACE CON_DESCRI WITH ALLTRIM(M.PER_DSCONT)
                     REPLACE CON_SIGLA  WITH ALLTRIM(M.PER_PFTCON)
                     REPLACE CON_TIPCON WITH ALLTRIM(M.PER_TIPCON)
                     REPLACE CON_DESCON WITH ALLTRIM(M.PER_DESCON)
                     REPLACE CON_PERCEN WITH M.PER_PERCON
                     REPLACE CON_COMLOR WITH M.PER_COMLOR
                     SELECT CUR_PER_AN
                     REPLACE PER_CODCON WITH M.PER_CODCON
                     SCATTER MEMVAR
                     IF !ExecRW(cSql,"CU_CON_PE","W")
                        return(.f.)
                     ENDIF
                     EXIT
                  ENDIF
                  IF !ExecRW(cSql,"CU_CON_PE","W")
                     return(.f.)
                  ENDIF
                  V_NUMERO = V_NUMERO +1  
                  M.PER_CODCON = V_CODCON + ALLTRIM(STR(V_NUMERO,3,0))
               ENDDO
               IF !ExecRW(cSql,"U_PER_AN","W")
                  return(.f.)
               ENDIF
               EXIT
            ENDIF
            IF !ExecRW(cSql,"U_PER_AN","W")
               return(.f.)
            ENDIF
            V_CALCOLA = VAL(V_CODICE) + 1
            V_CODICE  = ALLTRIM(STR(V_CALCOLA,5,0))
            V_LEN     = LEN(V_CODICE)
            IF V_LEN  = 1
               V_CODICE = '0000' + V_CODICE
            ENDIF
            IF V_LEN  = 2
               V_CODICE = '000' + V_CODICE
            ENDIF
            IF V_LEN  = 3
               V_CODICE = '00' + V_CODICE
            ENDIF
            IF V_LEN  = 4
               V_CODICE = '0' + V_CODICE
            ENDIF
         ENDDO
      ENDIF
   ENDIF
   
   SELECT PROVA_RINO

   M.EXE_BILDEB = 0
   M.EXE_BILCRE = 0
   M.EXE_BILREC = 0
   M.EXE_BILASS = 0
   M.EXE_CREPRE = 0
   M.EXE_CREREC = 0
   M.EXE_CREDAR = 0
   M.EXE_CRETOT = 0

   DO GESTIONE_EXCEL



   *** GESTIONE ANNO 2001

   SELECT PROVA_RINO
   
   M.EXE_ANNO   = '2001'
   
   X_PERCENT    = ALLTRIM(ANNO_2001)
   IF SUBSTR(X_PERCENT,1,2) = '0'
      M.EXE_PERBIL = 0
   ELSE
      X_LEN        = LEN(X_PERCENT)
      M.EXE_PERBIL = VAL(SUBSTR(X_PERCENT,1,X_LEN-1))
   ENDIF

   M.EXE_DESPER = N19
   
   V_CAMPO      = ALLTRIM(N20)
   DO TOGLI_PUNTI
   M.EXE_UCLMES = VAL(ALLTRIM(Y_CAMPO))
   
   V_CAMPO      = ALLTRIM(N21)
   DO TOGLI_PUNTI
   M.EXE_UCNMES = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N22)
   DO TOGLI_PUNTI
   M.EXE_COLANN = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N23)
   DO TOGLI_PUNTI
   M.EXE_CONANN = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N24)
   DO TOGLI_PUNTI
   M.EXE_VALINC = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N25)
   DO TOGLI_PUNTI
   M.EXE_PERINC = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N26)
   DO TOGLI_PUNTI
   M.EXE_VALUTI = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N27)
   DO TOGLI_PUNTI
   M.EXE_PERUTI = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N28)
   DO TOGLI_PUNTI
   M.EXE_BILDEB = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N29)
   DO TOGLI_PUNTI
   M.EXE_BILCRE = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N30)
   DO TOGLI_PUNTI
   M.EXE_BILREC = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N31)
   DO TOGLI_PUNTI
   M.EXE_BILASS = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(CREDITI_)
   DO TOGLI_PUNTI
   M.EXE_CREPRE = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N34)
   DO TOGLI_PUNTI
   M.EXE_CREREC = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N35)
   DO TOGLI_PUNTI
   M.EXE_CREDAR = VAL(ALLTRIM(Y_CAMPO))

   M.EXE_CRETOT = 0
   
   SELECT PROVA_RINO

   DO GESTIONE_EXCEL



   *** GESTIONE ANNO 2002

   SELECT PROVA_RINO

   M.EXE_ANNO   = '2002'
   
   X_PERCENT    = ALLTRIM(ANNO_2002)
   IF SUBSTR(X_PERCENT,1,2) = '0'
      M.EXE_PERBIL = 0
   ELSE
      X_LEN        = LEN(X_PERCENT)
      M.EXE_PERBIL = VAL(SUBSTR(X_PERCENT,1,X_LEN-1))
   ENDIF

   M.EXE_DESPER = N38
   
   V_CAMPO      = ALLTRIM(N39)
   DO TOGLI_PUNTI
   M.EXE_UCLMES = VAL(ALLTRIM(Y_CAMPO))
   
   V_CAMPO      = ALLTRIM(N40)
   DO TOGLI_PUNTI
   M.EXE_UCNMES = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N41)
   DO TOGLI_PUNTI
   M.EXE_COLANN = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N42)
   DO TOGLI_PUNTI
   M.EXE_CONANN = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N43)
   DO TOGLI_PUNTI
   M.EXE_VALINC = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N44)
   DO TOGLI_PUNTI
   M.EXE_PERINC = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N45)
   DO TOGLI_PUNTI
   M.EXE_VALUTI = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N46)
   DO TOGLI_PUNTI
   M.EXE_PERUTI = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N47)
   DO TOGLI_PUNTI
   M.EXE_BILDEB = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N48)
   DO TOGLI_PUNTI
   M.EXE_BILCRE = VAL(ALLTRIM(Y_CAMPO))

   M.EXE_BILREC = 0

   V_CAMPO      = ALLTRIM(N49)
   DO TOGLI_PUNTI
   M.EXE_BILASS = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(CREDITI1)
   DO TOGLI_PUNTI
   M.EXE_CREPRE = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N52)
   DO TOGLI_PUNTI
   M.EXE_CREREC = VAL(ALLTRIM(Y_CAMPO))

   M.EXE_CREDAR = 0

   V_CAMPO      = ALLTRIM(N53)
   DO TOGLI_PUNTI
   M.EXE_CRETOT = VAL(ALLTRIM(Y_CAMPO))
   
   SELECT PROVA_RINO

   DO GESTIONE_EXCEL



   *** GESTIONE ANNO 2003

   SELECT PROVA_RINO

   M.EXE_ANNO   = '2003'
   
   X_PERCENT    = ALLTRIM(ANNO_2003)
   IF SUBSTR(X_PERCENT,1,2) = '0'
      M.EXE_PERBIL = 0
   ELSE
      X_LEN        = LEN(X_PERCENT)
      M.EXE_PERBIL = VAL(SUBSTR(X_PERCENT,1,X_LEN-1))
   ENDIF

   M.EXE_DESPER = N56
   
   V_CAMPO      = ALLTRIM(N57)
   DO TOGLI_PUNTI
   M.EXE_UCLMES = VAL(ALLTRIM(Y_CAMPO))
   
   V_CAMPO      = ALLTRIM(N58)
   DO TOGLI_PUNTI
   M.EXE_UCNMES = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N59)
   DO TOGLI_PUNTI
   M.EXE_COLANN = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N60)
   DO TOGLI_PUNTI
   M.EXE_CONANN = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N61)
   DO TOGLI_PUNTI
   M.EXE_VALINC = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N62)
   DO TOGLI_PUNTI
   M.EXE_PERINC = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N63)
   DO TOGLI_PUNTI
   M.EXE_VALUTI = VAL(ALLTRIM(Y_CAMPO))

   V_CAMPO      = ALLTRIM(N64)
   DO TOGLI_PUNTI
   M.EXE_PERUTI = VAL(ALLTRIM(Y_CAMPO))

   M.EXE_BILDEB = 0
   M.EXE_BILCRE = 0
   M.EXE_BILREC = 0
   M.EXE_BILASS = 0
   M.EXE_CREPRE = 0
   M.EXE_CREREC = 0
   M.EXE_CREDAR = 0
   M.EXE_CRETOT = 0
   
   SELECT PROVA_RINO

   DO GESTIONE_EXCEL

   V_PROGRE = V_PROGRE + 1

   SELECT PROVA_RINO
   SKIP +1
   
ENDDO

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

RETURN


************************
PROCEDURE GESTIONE_EXCEL
************************

cSql   = "select * from u_exc_el where 1=0" 
IF !ExecRW(cSql,"u_exc_el","R")
   return
ENDIF
SELECT u_exc_el
IF EOF()
   APPEND BLANK
   M.ID_UNIQUE = ""
ENDIF

REPLACE EXE_NUMRIG WITH M.EXE_NUMRIG
REPLACE EXE_PROGRE WITH M.EXE_PROGRE
REPLACE EXE_SEQUEN WITH M.EXE_SEQUEN
REPLACE EXE_ANNO   WITH M.EXE_ANNO
REPLACE EXE_CODPDV WITH M.EXE_CODPDV
REPLACE EXE_DESPDV WITH M.EXE_DESPDV
REPLACE EXE_CODCOL WITH M.EXE_CODCOL
REPLACE EXE_DESCOL WITH M.EXE_DESCOL
REPLACE EXE_TIPCON WITH M.EXE_TIPCON
REPLACE EXE_PERCON WITH M.EXE_PERCON
REPLACE EXE_TIPCOL WITH M.EXE_TIPCOL
REPLACE EXE_DATINI WITH M.EXE_DATINI
REPLACE EXE_DATFIN WITH M.EXE_DATFIN
REPLACE EXE_PERBIL WITH M.EXE_PERBIL
REPLACE EXE_DESPER WITH M.EXE_DESPER
REPLACE EXE_UCLMES WITH M.EXE_UCLMES
REPLACE EXE_UCNMES WITH M.EXE_UCNMES
REPLACE EXE_COLANN WITH M.EXE_COLANN
REPLACE EXE_CONANN WITH M.EXE_CONANN
REPLACE EXE_VALINC WITH M.EXE_VALINC
REPLACE EXE_PERINC WITH M.EXE_PERINC
REPLACE EXE_VALUTI WITH M.EXE_VALUTI
REPLACE EXE_PERUTI WITH M.EXE_PERUTI
REPLACE EXE_BILDEB WITH M.EXE_BILDEB
REPLACE EXE_BILCRE WITH M.EXE_BILCRE
REPLACE EXE_BILREC WITH M.EXE_BILREC
REPLACE EXE_BILASS WITH M.EXE_BILASS
REPLACE EXE_CREPRE WITH M.EXE_CREPRE
REPLACE EXE_CREREC WITH M.EXE_CREREC
REPLACE EXE_CREDAR WITH M.EXE_CREDAR
REPLACE EXE_CRETOT WITH M.EXE_CRETOT

IF !ExecRW(cSql,"u_exc_el","W")
   return
ENDIF

V_CONTA  = V_CONTA + 1

_CTR = _CTR +1
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

RETURN

*********************
PROCEDURE TOGLI_PUNTI
*********************

YY      = LEN(V_CAMPO)
XX      = 1
Y_CAMPO =  ' '
DO WHILE .T.
   IF XX > YY
      EXIT
   ENDIF
   IF SUBSTR(V_CAMPO,XX,1) = '.' 
   ELSE
      Y_CAMPO = Y_CAMPO + SUBSTR(V_CAMPO,XX,1) 
   ENDIF
   XX = XX + 1
ENDDO

RETURN

