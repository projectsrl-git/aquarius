*******************************************************
* PROGRAMMA PER RIEMPIMENTO CAMPI ANAGRAFICA ARTICOLI *
*******************************************************

RELEASE CONTATORE,XXX_CODICE,XXX_DESCRI
PUBLIC  CONTATORE,XXX_CODICE,XXX_DESCRI
CONTATORE  = 0
XXX_CODICE = ""
XXX_DESCRI = ""

RIT = MESSAGEBOX("Procedo con il completamento dei campi ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

x_cond = "art_codsoc = '" + PUB_CODSOC + "'"
cSql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"u_art_pr","R")
   return
ENDIF
SELECT U_ART_PR
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   CONTATORE = CONTATORE + 1
   WAIT WINDOWS "RECORDS LETTI/AGGIORNATI : "+STR(CONTATORE,10,0) NOWAIT
   
   IF ART_PRZVEN = 0
      SELECT U_ART_PR
      REPLACE ART_PRZVEN WITH 8
      REPLACE ART_PRZIVA WITH 10
   ENDIF

   IF EMPTY(ART_CATMER) .OR. ART_CATMER = SPACE(03)     
      DO CASE
         CASE CONTATORE < 10000
              x_cond = "codice = 'MER001'"
         CASE ((CONTATORE >= 10000) .AND. (CONTATORE < 20000))
              x_cond = "codice = 'MER002'"
         CASE ((CONTATORE >= 20000) .AND. (CONTATORE < 30000))
              x_cond = "codice = 'MER003'"
         CASE ((CONTATORE >= 30000) .AND. (CONTATORE < 40000))
              x_cond = "codice = 'MER004'"
         CASE ((CONTATORE >= 40000) .AND. (CONTATORE < 50000))
              x_cond = "codice = 'MER005'"
         CASE ((CONTATORE >= 50000) .AND. (CONTATORE < 60000))
              x_cond = "codice = 'MER006'"
         CASE ((CONTATORE >= 60000) .AND. (CONTATORE < 70000))
              x_cond = "codice = 'MER007'"
         CASE ((CONTATORE >= 70000) .AND. (CONTATORE < 80000))
              x_cond = "codice = 'MER008'"
         CASE ((CONTATORE >= 80000) .AND. (CONTATORE < 90000))
              x_cond = "codice = 'MER009'"
         CASE ((CONTATORE >= 90000) .AND. (CONTATORE < 100000))
              x_cond = "codice = 'MER010'"
         CASE ((CONTATORE >= 100000) .AND. (CONTATORE < 110000))
              x_cond = "codice = 'MER011'"
         CASE ((CONTATORE >= 110000) .AND. (CONTATORE < 120000))
              x_cond = "codice = 'MER012'"
         CASE CONTATORE >= 120000
              x_cond = "codice = 'MER013'"
      ENDCASE
      cSql   = "select * from PARA where " + x_cond + " order by codice"
      IF !ExecCommand(cSql,"CUR_PARA")
         RETURN .f.
      ENDIF
      SELECT CUR_PARA
      GO TOP
      IF !EOF()
         XXX_CODICE = SUBSTR(CODICE,4,3)
         XXX_DESCRI = DESCRI
      ENDIF
      SELECT U_ART_PR
      REPLACE ART_CATMER WITH XXX_CODICE
      REPLACE ART_DESMER WITH XXX_DESCRI
   ENDIF

   IF EMPTY(ART_GRUEDI) .OR. ART_GRUEDI = SPACE(05)     
      DO CASE
         CASE CONTATORE < 10000
              x_cond = "codice = 'GEDACB'"
         CASE ((CONTATORE >= 10000) .AND. (CONTATORE < 20000))
              x_cond = "codice = 'GEDACI'"
         CASE ((CONTATORE >= 20000) .AND. (CONTATORE < 30000))
              x_cond = "codice = 'GEDADDIC'"
         CASE ((CONTATORE >= 30000) .AND. (CONTATORE < 40000))
              x_cond = "codice = 'GEDADDIS'"
         CASE ((CONTATORE >= 40000) .AND. (CONTATORE < 50000))
              x_cond = "codice = 'GEDADELP'"
         CASE ((CONTATORE >= 50000) .AND. (CONTATORE < 60000))
              x_cond = "codice = 'GEDADMED'"
         CASE ((CONTATORE >= 60000) .AND. (CONTATORE < 70000))
              x_cond = "codice = 'GEDADNKR'"
         CASE ((CONTATORE >= 70000) .AND. (CONTATORE < 80000))
              x_cond = "codice = 'GEDADOBE'"
         CASE ((CONTATORE >= 80000) .AND. (CONTATORE < 90000))
              x_cond = "codice = 'GEDADP'"
         CASE ((CONTATORE >= 90000) .AND. (CONTATORE < 100000))
              x_cond = "codice = 'GEDAGOST'"
         CASE ((CONTATORE >= 100000) .AND. (CONTATORE < 110000))
              x_cond = "codice = 'GEDAGRI'"
         CASE ((CONTATORE >= 110000) .AND. (CONTATORE < 120000))
              x_cond = "codice = 'GEDAIRON'"
         CASE CONTATORE >= 120000
              x_cond = "codice = 'GEDALBE'"
      ENDCASE
      cSql   = "select * from PARA where " + x_cond + " order by codice"
      IF !ExecCommand(cSql,"CUR_PARA")
         RETURN .f.
      ENDIF
      SELECT CUR_PARA
      GO TOP
      IF !EOF()
         XXX_CODICE = SUBSTR(CODICE,4,5)
         XXX_DESCRI = DESCRI
      ENDIF
      SELECT U_ART_PR
      REPLACE ART_GRUEDI WITH XXX_CODICE
      REPLACE ART_DESGRE WITH XXX_DESCRI
   ENDIF

   IF EMPTY(ART_EDITOR) .OR. ART_EDITOR = SPACE(05)     
      DO CASE
         CASE CONTATORE < 10000
              x_cond = "codice = 'EDRACB'"
         CASE ((CONTATORE >= 10000) .AND. (CONTATORE < 20000))
              x_cond = "codice = 'EDRACI'"
         CASE ((CONTATORE >= 20000) .AND. (CONTATORE < 30000))
              x_cond = "codice = 'EDRADDIC'"
         CASE ((CONTATORE >= 30000) .AND. (CONTATORE < 40000))
              x_cond = "codice = 'EDRADDIS'"
         CASE ((CONTATORE >= 40000) .AND. (CONTATORE < 50000))
              x_cond = "codice = 'EDRADELP'"
         CASE ((CONTATORE >= 50000) .AND. (CONTATORE < 60000))
              x_cond = "codice = 'EDRADMED'"
         CASE ((CONTATORE >= 60000) .AND. (CONTATORE < 70000))
              x_cond = "codice = 'EDRADNKR'"
         CASE ((CONTATORE >= 70000) .AND. (CONTATORE < 80000))
              x_cond = "codice = 'EDRADOBE'"
         CASE ((CONTATORE >= 80000) .AND. (CONTATORE < 90000))
              x_cond = "codice = 'EDRADP'"
         CASE ((CONTATORE >= 90000) .AND. (CONTATORE < 100000))
              x_cond = "codice = 'EDRAGOPE'"
         CASE ((CONTATORE >= 100000) .AND. (CONTATORE < 110000))
              x_cond = "codice = 'EDRAGRI'"
         CASE ((CONTATORE >= 110000) .AND. (CONTATORE < 120000))
              x_cond = "codice = 'EDRAGOS1'"
         CASE CONTATORE >= 120000
              x_cond = "codice = 'EDRAGOS2'"
      ENDCASE
      cSql   = "select * from PARA where " + x_cond + " order by codice"
      IF !ExecCommand(cSql,"CUR_PARA")
         RETURN .f.
      ENDIF
      SELECT CUR_PARA
      GO TOP
      IF !EOF()
         XXX_CODICE = SUBSTR(CODICE,4,5)
         XXX_DESCRI = DESCRI
      ENDIF
      SELECT U_ART_PR
      REPLACE ART_EDITOR WITH XXX_CODICE
      REPLACE ART_DESEDI WITH XXX_DESCRI
   ENDIF
   
   IF EMPTY(ART_COLLAN) .OR. ART_COLLAN = SPACE(03)     
      DO CASE
         CASE CONTATORE < 10000
              x_cond = "codice = 'COA001'"
         CASE ((CONTATORE >= 10000) .AND. (CONTATORE < 20000))
              x_cond = "codice = 'COA002'"
         CASE ((CONTATORE >= 20000) .AND. (CONTATORE < 30000))
              x_cond = "codice = 'COA003'"
         CASE ((CONTATORE >= 30000) .AND. (CONTATORE < 40000))
              x_cond = "codice = 'COA004'"
         CASE ((CONTATORE >= 40000) .AND. (CONTATORE < 50000))
              x_cond = "codice = 'COA005'"
         CASE ((CONTATORE >= 50000) .AND. (CONTATORE < 60000))
              x_cond = "codice = 'COA006'"
         CASE ((CONTATORE >= 60000) .AND. (CONTATORE < 70000))
              x_cond = "codice = 'COA007'"
         CASE ((CONTATORE >= 70000) .AND. (CONTATORE < 80000))
              x_cond = "codice = 'COA008'"
         CASE ((CONTATORE >= 80000) .AND. (CONTATORE < 90000))
              x_cond = "codice = 'COA009'"
         CASE ((CONTATORE >= 90000) .AND. (CONTATORE < 100000))
              x_cond = "codice = 'COA010'"
         CASE ((CONTATORE >= 100000) .AND. (CONTATORE < 110000))
              x_cond = "codice = 'COA011'"
         CASE ((CONTATORE >= 110000) .AND. (CONTATORE < 120000))
              x_cond = "codice = 'COA012'"
         CASE CONTATORE >= 120000
              x_cond = "codice = 'COA013'"
      ENDCASE
      cSql   = "select * from PARA where " + x_cond + " order by codice"
      IF !ExecCommand(cSql,"CUR_PARA")
         RETURN .f.
      ENDIF
      SELECT CUR_PARA
      GO TOP
      IF !EOF()
         XXX_CODICE = SUBSTR(CODICE,4,3)
         XXX_DESCRI = DESCRI
      ENDIF
      SELECT U_ART_PR
      REPLACE ART_COLLAN WITH XXX_CODICE
      REPLACE ART_DESCOA WITH XXX_DESCRI
   ENDIF

   IF EMPTY(ART_CATAGO) .OR. ART_CATAGO = SPACE(50)     
      DO CASE
         CASE CONTATORE < 10000
              XXX_DESCRI = 'PRIMO CATALOGO'
         CASE ((CONTATORE >= 10000) .AND. (CONTATORE < 20000))
              XXX_DESCRI = 'SECONDO CATALOGO'
         CASE ((CONTATORE >= 20000) .AND. (CONTATORE < 30000))
              XXX_DESCRI = 'TERZO CATALOGO'
         CASE ((CONTATORE >= 30000) .AND. (CONTATORE < 40000))
              XXX_DESCRI = 'QUARTO CATALOGO'
         CASE ((CONTATORE >= 40000) .AND. (CONTATORE < 50000))
              XXX_DESCRI = 'QUINTO CATALOGO'
         CASE ((CONTATORE >= 50000) .AND. (CONTATORE < 60000))
              XXX_DESCRI = 'SESTO CATALOGO'
         CASE ((CONTATORE >= 60000) .AND. (CONTATORE < 70000))
              XXX_DESCRI = 'SETTIMO CATALOGO'
         CASE ((CONTATORE >= 70000) .AND. (CONTATORE < 80000))
              XXX_DESCRI = 'OTTAVO CATALOGO'
         CASE ((CONTATORE >= 80000) .AND. (CONTATORE < 90000))
              XXX_DESCRI = 'NONO CATALOGO'
         CASE ((CONTATORE >= 90000) .AND. (CONTATORE < 100000))
              XXX_DESCRI = 'DECIMO CATALOGO'
         CASE ((CONTATORE >= 100000) .AND. (CONTATORE < 110000))
              XXX_DESCRI = 'UNDICESIMO CATALOGO'
         CASE ((CONTATORE >= 110000) .AND. (CONTATORE < 120000))
              XXX_DESCRI = 'DODICESIMO CATALOGO'
         CASE CONTATORE >= 120000
              XXX_DESCRI = 'TREDICESIMO CATALOGO'
      ENDCASE        
      SELECT U_ART_PR
      REPLACE ART_CATAGO WITH XXX_DESCRI
   ENDIF

   IF EMPTY(ART_AUTORE) .OR. ART_AUTORE = SPACE(50)     
      DO CASE
         CASE CONTATORE < 10000
              XXX_DESCRI = 'PRIMO AUTORE'
         CASE ((CONTATORE >= 10000) .AND. (CONTATORE < 20000))
              XXX_DESCRI = 'SECONDO AUTORE'
         CASE ((CONTATORE >= 20000) .AND. (CONTATORE < 30000))
              XXX_DESCRI = 'TERZO AUTORE'
         CASE ((CONTATORE >= 30000) .AND. (CONTATORE < 40000))
              XXX_DESCRI = 'QUARTO AUTORE'
         CASE ((CONTATORE >= 40000) .AND. (CONTATORE < 50000))
              XXX_DESCRI = 'QUINTO AUTORE'
         CASE ((CONTATORE >= 50000) .AND. (CONTATORE < 60000))
              XXX_DESCRI = 'SESTO AUTORE'
         CASE ((CONTATORE >= 60000) .AND. (CONTATORE < 70000))
              XXX_DESCRI = 'SETTIMO AUTORE'
         CASE ((CONTATORE >= 70000) .AND. (CONTATORE < 80000))
              XXX_DESCRI = 'OTTAVO AUTORE'
         CASE ((CONTATORE >= 80000) .AND. (CONTATORE < 90000))
              XXX_DESCRI = 'NONO AUTORE'
         CASE ((CONTATORE >= 90000) .AND. (CONTATORE < 100000))
              XXX_DESCRI = 'DECIMO AUTORE'
         CASE ((CONTATORE >= 100000) .AND. (CONTATORE < 110000))
              XXX_DESCRI = 'UNDICESIMO AUTORE'
         CASE ((CONTATORE >= 110000) .AND. (CONTATORE < 120000))
              XXX_DESCRI = 'DODICESIMO AUTORE'
         CASE CONTATORE >= 120000
              XXX_DESCRI = 'TREDICESIMO AUTORE'
      ENDCASE        
      SELECT U_ART_PR
      REPLACE ART_AUTORE WITH XXX_DESCRI
   ENDIF

   IF EMPTY(ART_ARGOME) .OR. ART_ARGOME = SPACE(50)     
      DO CASE
         CASE CONTATORE < 10000
              XXX_DESCRI = 'PRIMO ARGOMENTO'
         CASE ((CONTATORE >= 10000) .AND. (CONTATORE < 20000))
              XXX_DESCRI = 'SECONDO ARGOMENTO'
         CASE ((CONTATORE >= 20000) .AND. (CONTATORE < 30000))
              XXX_DESCRI = 'TERZO ARGOMENTO'
         CASE ((CONTATORE >= 30000) .AND. (CONTATORE < 40000))
              XXX_DESCRI = 'QUARTO ARGOMENTO'
         CASE ((CONTATORE >= 40000) .AND. (CONTATORE < 50000))
              XXX_DESCRI = 'QUINTO ARGOMENTO'
         CASE ((CONTATORE >= 50000) .AND. (CONTATORE < 60000))
              XXX_DESCRI = 'SESTO ARGOMENTO'
         CASE ((CONTATORE >= 60000) .AND. (CONTATORE < 70000))
              XXX_DESCRI = 'SETTIMO ARGOMENTO'
         CASE ((CONTATORE >= 70000) .AND. (CONTATORE < 80000))
              XXX_DESCRI = 'OTTAVO ARGOMENTO'
         CASE ((CONTATORE >= 80000) .AND. (CONTATORE < 90000))
              XXX_DESCRI = 'NONO ARGOMENTO'
         CASE ((CONTATORE >= 90000) .AND. (CONTATORE < 100000))
              XXX_DESCRI = 'DECIMO ARGOMENTO'
         CASE ((CONTATORE >= 100000) .AND. (CONTATORE < 110000))
              XXX_DESCRI = 'UNDICESIMO ARGOMENTO'
         CASE ((CONTATORE >= 110000) .AND. (CONTATORE < 120000))
              XXX_DESCRI = 'DODICESIMO ARGOMENTO'
         CASE CONTATORE >= 120000
              XXX_DESCRI = 'TREDICESIMO ARGOMENTO'
      ENDCASE        
      SELECT U_ART_PR
      REPLACE ART_ARGOME WITH XXX_DESCRI
   ENDIF

   SELECT U_ART_PR
   SKIP +1
   
ENDDO

IF !ExecRW(cSql,"u_art_pr","W")
   return
ENDIF

=MESSAGEBOX("Operazione terminata correttamente ",62,"ATTENZIONE")

RETURN