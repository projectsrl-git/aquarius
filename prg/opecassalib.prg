**************************************************************************
PROCEDURE GESTIONE_OPECASSA  			 && SCARICA IL MAGAZZINO E I SALDI
**************************************************************************

RELEASE PUB_CODSOC,PUB_VALRIF,XYZ_NUMAGG,XYZ_UNIQUE,XYZ_TIPO
PUBLIC  PUB_CODSOC,PUB_VALRIF,XYZ_NUMAGG,XYZ_UNIQUE,XYZ_TIPO
PUB_CODSOC = '01'
PUB_VALRIF = 'EUR'
XYZ_NUMAGG = 0
XYZ_UNIQUE = ""
XYZ_TIPO   = 'OP'

V_CONT = 0
V_NOCO = 0
V_ALTR = 0
V_TROV = .F.

x_cond = "cas_flgagg = 0"
Csql   = "select * from u_pdv_op where " + x_cond + " order by cas_codmag,cas_datope,cas_oraope"
IF !ExecRW(cSql,"U_PDV_OP","R")
   return(.f.)
ENDIF

SELECT U_PDV_OP
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO

   XYZ_UNIQUE = ID_UNIQUE
   XYZ_NUMAGG = 0

   *x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
   *x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
   *x_cond = x_uniq + " and " + x_tipo
   *Csql   = "select * from u_pdv_cn where " + x_cond 
   *IF !ExecRW(cSql,"U_PDV_CN","R")
   *   return(.f.)
   *ENDIF
   *IF EOF()
   *   APPEND BLANK
   *   REPLACE ID_UNIQUE  WITH XYZ_UNIQUE
   *   REPLACE CAS_TIPO   WITH XYZ_TIPO
   *   REPLACE CAS_NUMAGG WITH 0
   *ENDIF
   *XYZ_NUMAGG = CAS_NUMAGG
   *IF !ExecRW(cSql,"U_PDV_CN","W")
   *   return(.f.)
   *ENDIF

   IF XYZ_NUMAGG > 0
   ELSE
      V_TROV = .F.
      Csql = "select * from u_pdv_sc where 1=0"
      IF !ExecCommand(cSql,"CU_PDV_SC")
         return(.f.)
      ENDIF
      x_cpdv = "cas_codpdv = '" + ALLTRIM(M.CAS_CODPDV) + "'"
      x_maga = "cas_codmag = '" + ALLTRIM(M.CAS_CODMAG) + "'"
      x_cass = "cas_codcas = '" + ALLTRIM(M.CAS_CODCAS) + "'"
      x_peri = "cas_datope = '" + M.CAS_DATOPE + "'"
      x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
      Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
      IF !ExecCommand(cSql,"U_PDV_SC")
         return(.f.)
      ENDIF
      SELECT U_PDV_SC
      IF RECCOUNT() <> 0
         V_TROV = .T.
      ELSE
         x_cpdv = "cas_codpdv = '" + ALLTRIM(M.CAS_CODPDV) + "'"
         x_maga = "cas_codmag = '" + ALLTRIM(M.CAS_CODMAG) + "'"
         x_cass = "cas_codcas = '" + ALLTRIM(M.CAS_CODCAS) + "'"
         x_peri = "cas_datope <= '" + M.CAS_DATOPE + "'"
         x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
         Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
         IF !ExecCommand(cSql,"U_PDV_SC")
            return(.f.)
         ENDIF
         SELECT U_PDV_SC
         GO TOP
         IF EOF()
         ELSE
            GO BOTTOM
            XY_CODPDV = CAS_CODPDV
            XY_CODCAS = CAS_CODCAS
            XY_CODMAG = CAS_CODMAG
            XY_DATOPE = M.CAS_DATOPE
            XY_ORAOPE = CAS_ORAOPE
            XY_VALCON = CAS_VALCON
            XY_VALNOC = CAS_VALNOC
            XY_VALPOS = CAS_VALPOS
            XY_VALCAR = CAS_VALCAR
            XY_VALASS = CAS_VALASS
            XY_VALFIN = CAS_VALFIN
            XY_VALALT = CAS_VALALT
            SELECT CU_PDV_SC
            APPEND BLANK
            REPLACE CAS_CODPDV WITH XY_CODPDV
            REPLACE CAS_CODCAS WITH XY_CODCAS
            REPLACE CAS_CODMAG WITH XY_CODMAG
            REPLACE CAS_DATOPE WITH XY_DATOPE
            REPLACE CAS_ORAOPE WITH XY_ORAOPE
            REPLACE CAS_VALCON WITH XY_VALCON
            REPLACE CAS_VALNOC WITH XY_VALNOC
            REPLACE CAS_VALPOS WITH XY_VALPOS
            REPLACE CAS_VALCAR WITH XY_VALCAR
            REPLACE CAS_VALASS WITH XY_VALASS
            REPLACE CAS_VALFIN WITH XY_VALFIN
            REPLACE CAS_VALALT WITH XY_VALALT
            V_TROV = .T.
            IF !ExecRW('','u_pdv_sc','I','','CU_PDV_SC')
               return(.f.)
            ENDIF
         ENDIF
      ENDIF

      IF V_TROV
      ELSE
         SELECT CU_PDV_SC
         APPEND BLANK
         REPLACE CAS_CODPDV WITH M.CAS_CODPDV
         REPLACE CAS_CODCAS WITH M.CAS_CODCAS
         REPLACE CAS_CODMAG WITH M.CAS_CODMAG
         REPLACE CAS_DATOPE WITH M.CAS_DATOPE
         REPLACE CAS_ORAOPE WITH M.CAS_ORAOPE
         REPLACE CAS_VALCON WITH 0
         REPLACE CAS_VALNOC WITH 0
         REPLACE CAS_VALPOS WITH 0
         REPLACE CAS_VALCAR WITH 0
         REPLACE CAS_VALASS WITH 0
         REPLACE CAS_VALFIN WITH 0
         REPLACE CAS_VALALT WITH 0
         IF !ExecRW('','u_pdv_sc','I','','CU_PDV_SC')
            return(.f.)
         ENDIF
      ENDIF     

      x_cpdv = "cas_codpdv = '" + ALLTRIM(M.CAS_CODPDV) + "'"
      x_maga = "cas_codmag = '" + ALLTRIM(M.CAS_CODMAG) + "'"
      x_cass = "cas_codcas = '" + ALLTRIM(M.CAS_CODCAS) + "'"
      x_peri = "cas_datope = '" + M.CAS_DATOPE + "'"
      x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
      Csql   = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
      IF !ExecRW(cSql,"U_PDV_SC","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_SC
      IF RECCOUNT() <> 0
         REPLACE CAS_ORAOPE WITH M.CAS_ORAOPE
         IF SUBSTR(M.CAS_TIPMOV,1,1) = 'C'
            IF M.CAS_SEGNO = '+'
               REPLACE CAS_VALCON WITH CAS_VALCON + M.CAS_IMPORT
            ELSE
               REPLACE CAS_VALCON WITH CAS_VALCON - M.CAS_IMPORT
            ENDIF
         ENDIF
         IF SUBSTR(M.CAS_TIPMOV,1,1) = 'V' .OR. SUBSTR(M.CAS_TIPMOV,1,1) = 'R' .OR. SUBSTR(M.CAS_TIPMOV,1,1) = 'N'
            IF M.CAS_SEGNO = '+'
               REPLACE CAS_VALCON WITH CAS_VALCON + M.CAS_IMPORT
               REPLACE CAS_VALNOC WITH CAS_VALNOC + M.CAS_IMPORT
            ELSE
               REPLACE CAS_VALCON WITH CAS_VALCON - M.CAS_IMPORT
               REPLACE CAS_VALNOC WITH CAS_VALNOC - M.CAS_IMPORT
            ENDIF
         ENDIF
         IF SUBSTR(M.CAS_TIPMOV,1,1) = 'B'
            IF M.CAS_SEGNO = '+'
               REPLACE CAS_VALPOS WITH CAS_VALPOS + M.CAS_IMPORT
            ELSE
               REPLACE CAS_VALPOS WITH CAS_VALPOS - M.CAS_IMPORT
            ENDIF
         ENDIF
         IF SUBSTR(M.CAS_TIPMOV,1,1) = 'P' .OR. SUBSTR(M.CAS_TIPMOV,1,1) = 'S' .OR. ;
            SUBSTR(M.CAS_TIPMOV,1,1) = 'E' .OR. SUBSTR(M.CAS_TIPMOV,1,1) = 'K' .OR. ;
            SUBSTR(M.CAS_TIPMOV,1,1) = 'T' .OR. SUBSTR(M.CAS_TIPMOV,1,1) = 'M' .OR. ;
            SUBSTR(M.CAS_TIPMOV,1,1) = 'I' .OR. SUBSTR(M.CAS_TIPMOV,1,1) = 'D'
            IF M.CAS_SEGNO = '+'
               REPLACE CAS_VALCAR WITH CAS_VALCAR + M.CAS_IMPORT
            ELSE
               REPLACE CAS_VALCAR WITH CAS_VALCAR - M.CAS_IMPORT
            ENDIF
         ENDIF
         IF SUBSTR(M.CAS_TIPMOV,1,1) = 'A'
            IF M.CAS_SEGNO = '+'
               REPLACE CAS_VALASS WITH CAS_VALASS + M.CAS_IMPORT
            ELSE
               REPLACE CAS_VALASS WITH CAS_VALASS - M.CAS_IMPORT
            ENDIF
         ENDIF
         IF SUBSTR(M.CAS_TIPMOV,1,1) = 'F'
            IF M.CAS_SEGNO = '+'
               REPLACE CAS_VALFIN WITH CAS_VALFIN + M.CAS_IMPORT
            ELSE
               REPLACE CAS_VALFIN WITH CAS_VALFIN - M.CAS_IMPORT
            ENDIF
         ENDIF
         V_CONT = CAS_VALCON
         V_NOCO = CAS_VALNOC
         V_ALTR = CAS_VALPOS + CAS_VALCAR + CAS_VALASS + CAS_VALFIN + CAS_VALALT
      ENDIF
      IF !ExecRW(cSql,"U_PDV_SC","W")
         return(.f.)
      ENDIF

      *x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
      *x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
      *x_cond = x_uniq + " and " + x_tipo
      *Csql   = "select * from u_pdv_cn where " + x_cond 
      *IF !ExecRW(cSql,"U_PDV_CN","R")
      *   return(.f.)
      *ENDIF
      *IF EOF()
      *   APPEND BLANK
      *   REPLACE ID_UNIQUE WITH XYZ_UNIQUE
      *   REPLACE CAS_TIPO  WITH XYZ_TIPO
      *ENDIF
      *REPLACE CAS_NUMAGG WITH 1
      *IF !ExecRW(cSql,"U_PDV_CN","W")
      *   return(.f.)
      *ENDIF

   ENDIF
   
   SELECT U_PDV_OP
   REPLACE CAS_FLGAGG WITH .T.
   REPLACE CAS_NUMAGG WITH 100

   *x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
   *x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
   *x_cond = x_uniq + " and " + x_tipo
   *Csql   = "select * from u_pdv_cn where " + x_cond 
   *IF !ExecRW(cSql,"U_PDV_CN","R")
   *   return(.f.)
   *ENDIF
   *IF EOF()
   *   APPEND BLANK
   *   REPLACE ID_UNIQUE WITH XYZ_UNIQUE
   *   REPLACE CAS_TIPO  WITH XYZ_TIPO
   *ENDIF
   *REPLACE CAS_NUMAGG WITH 100
   *IF !ExecRW(cSql,"U_PDV_CN","W")
   *   return(.f.)
   *ENDIF
   
   SELECT U_PDV_OP   
   SKIP +1
   
ENDDO

IF !ExecRW(cSql,"U_PDV_OP","W")
   return(.f.)
ENDIF

RETURN


************************
FUNCTION CAMBIADT
************************
PARA _DATA,_NOMEDT

IF _DATA = '  /  /    ' .OR. _DATA = SPACE(10) .OR. ;
   _DATA = '    /  /  ' .OR. EMPTY(_DATA)
   REPLACE &_NOMEDT WITH SPACE(10)
ELSE
   IF SUBSTR(_DATA,3,1) = '/'
      REPLACE &_NOMEDT WITH RIBALTA2(_DATA)
   ELSE
      REPLACE &_NOMEDT WITH _DATA
   ENDIF
ENDIF

RETURN(.T.)


*************************************************************************
* Funzione - STR_EXTRACT      Data: 26.07.94     Autore: Project
*************************************************************************
* Questa funzione permette di estrarre da una stringa determinate
* sottostringhe contenute tra il delimitatore specificato.
* Esempio:
*     AA="Pippo,Pluto,Paperino"
*     ? STR_EXTRACT(AA,",",2)      && Ritornerà  "Pluto"
* Sintassi:
*     STR_EXTRACT(<ExpC1>,<ExpC2>,<ExpN1>)
*     ExpC1 - Stringa di origine
*     ExpC2 - Carattere delimitatore di lista
*     ExpN1 - Numero di occorrenze nella lista
*
*************************************************************************
FUNCTION STR_EXTRACT
********************

PARA SRIG,DEL,OCC

SRIG=SRIG+DEL

FOR K=1 TO OCC-1
   STAR=AT(DEL,SRIG)+1
   IF STAR >LEN(SRIG)
      SRIG=""
      EXIT
   ENDIF
   SRIG=SUBSTR(SRIG,STAR)
NEXT

FINE=AT(DEL,SRIG)

IF SRIG==""
   RETURN("")
ELSE
   RETURN(SUBSTR(SRIG,1,FINE-1))
ENDIF


***********************************************************************
* Funzione - RIBALTA2     Data: 15.11.95   Autore: Project
***********************************************************************
*
*  Consente di convertire il formato data
*  AAAA.MM.GG in GG.MM.AAAA e viceversa
*  Sintassi: RIBALTA(Stringa da convertire)
*  Parametro: Carattere
*  Ritorna:   Carattere
*  Se il contenuto di GG,MM,AA è nullo ritorna SPACE(10)
*
***********************************************************************
FUNCTION RIBALTA2
*****************

PARAMETER _VALCAMPO

_SEPARA="/.-"

DO CASE
   CASE SUBSTR(_VALCAMPO,3,1) $ _SEPARA   && GG.MM.AAAA
        _SEPARA=SUBSTR(_VALCAMPO,3,1)
        _GIORNO=SUBSTR(_VALCAMPO,1,2)
        _MESE  =SUBSTR(_VALCAMPO,4,2)
        _ANNO  =SUBSTR(_VALCAMPO,7,4)
        _TUTTO =_ANNO+_SEPARA+_MESE+_SEPARA+_GIORNO
   CASE SUBSTR(_VALCAMPO,5,1) $ _SEPARA   && AAAA.MM.GG
        _SEPARA=SUBSTR(_VALCAMPO,5,1)
        _GIORNO=SUBSTR(_VALCAMPO,9,2)
        _MESE  =SUBSTR(_VALCAMPO,6,2)
        _ANNO  =SUBSTR(_VALCAMPO,1,4)
        _TUTTO =_GIORNO+_SEPARA+_MESE+_SEPARA+_ANNO
   OTHERWISE                              && NON VALIDO !
        _TUTTO=SPACE(10)
ENDCASE

RETURN(_TUTTO)

***********************************************************************
* Funzione - TRC     Data: 18.03.97   Autore: Project
***********************************************************************
*
*  AGGIUNGE ZERI INIZIALI AD UN NUMERO IN FORMATO CARATTERE
*  PARAMETRI DA PASSARE
*  _LUN  = LUNGEZZA DEL CAMPO
*  _COD = VARIABILE CONTENENTE VALORE
*
*  sintassi:
*  V_COD=TRC(10,V_COD)
**************************
FUNCTION TRC
**************************
PARA _LUN,_COD

_COD=ALLTRIM(_COD)
IF LEN(_COD) > _LUN
 RETURN(_COD)
ENDIF

_LUN1=_LUN - LEN(_COD)
_OUT=REPLICATE('0',_LUN1)+_COD

RETURN(_OUT)

