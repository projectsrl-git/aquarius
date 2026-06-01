**************************************************************************
PROCEDURE GESTIONE_INCASSO  			 && SCARICA IL MAGAZZINO E I SALDI
**************************************************************************

PARAMETERS _DACHI

RELEASE ASD_DACHI
PUBLIC  ASD_DACHI
ASD_DACHI = _DACHI				

RELEASE PUB_CODSOC,PUB_VALRIF,PUB_FORPRE,PUB_CODBUN,PUB_PROGAA, ;
        XYZ_FORNIT,XYZ_RAGSOC,XYZ_NUMAGG,XYZ_UNIQUE,XYZ_TIPO,   ;
        M.ORD_CODSYS,M.ORD_LEGAME,M.ORD_CAUS,PUB_CAUTRA,PUB_CODOPE, ;
        PUB_NOMOPE,PUB_CAUREF
PUBLIC  PUB_CODSOC,PUB_VALRIF,PUB_FORPRE,PUB_CODBUN,PUB_PROGAA, ;
        XYZ_FORNIT,XYZ_RAGSOC,XYZ_NUMAGG,XYZ_UNIQUE,XYZ_TIPO,   ;
        M.ORD_CODSYS,M.ORD_LEGAME,M.ORD_CAUS,PUB_CAUTRA,PUB_CODOPE, ;
        PUB_NOMOPE,PUB_CAUREF
PUB_CODSOC = '01'
PUB_VALRIF = 'EUR'
PUB_FORPRE = .F.
PUB_CODBUN = SPACE(10)
PUB_PROGAA = .F.
XYZ_FORNIT = SPACE(10)
XYZ_RAGSOC = SPACE(50)
XYZ_NUMAGG = 0
XYZ_UNIQUE = ""
XYZ_TIPO   = 'CA'
M.ORD_CODSYS = SPACE(10)
M.ORD_LEGAME = SPACE(10)
M.ORD_CAUS   = SPACE(03)
PUB_CAUTRA   = 'XXX'
PUB_CODOPE   = 'CAS'
PUB_NOMOPE   = 'CASSIERE'
PUB_CAUREF   = 'XXX'

PUBLIC PUB_TIPCON,PUB_PRZBAS,PUB_DATOLD,PUB_CAMCOS
PUB_TIPCON = .F.
PUB_PRZBAS = .F.
PUB_DATOLD = .F. 
PUB_CAMCOS = .F.

* ==> INIZIO RINO 16/03/2004
PUBLIC PUB_NUMCAM,PUB_DATCAM,PUB_INICAM,PUB_FINCAM,PUB_SC1CAM,PUB_SC2CAM,PUB_SC3CAM,PUB_SC4CAM,PUB_SC5CAM,PUB_FISCAM,PUB_PRZCAM
PUB_NUMCAM = SPACE(06)
PUB_DATCAM = SPACE(10)
PUB_INICAM = SPACE(10)
PUB_FINCAM = SPACE(10)
PUB_SC1CAM = 0
PUB_SC2CAM = 0
PUB_SC3CAM = 0
PUB_SC4CAM = 0
PUB_SC5CAM = 0
PUB_FISCAM = 0
PUB_PRZCAM = 0
* ==> FINE RINO 16/03/2004

x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
Csql   = "select * from u_azi_an where " + x_cond 
IF !ExecCommand(cSql,"u_azi_an")
   return(.f.)
ENDIF
SELECT u_azi_an
GO TOP
IF EOF()
ELSE
   PUB_FORPRE = AZI_FORPRE
   PUB_CODBUN = AZI_CODBUN
   PUB_PROGAA = AZI_PROGAA
   * ==> INIZIO RINO 24/02/2004
   PUB_TIPCON = AZI_TIPCON
   PUB_PRZBAS = AZI_PRZBAS
   PUB_DATOLD = AZI_DATOLD 
   PUB_CAMCOS = AZI_CAMCOS
   * ==> FINE RINO 24/02/2004
ENDIF

x_cond = "cas_flgagg = 0"
Csql   = "select * from u_pdv_ca where " + x_cond + " order by cas_codmag,cas_progre,cas_datope,cas_oraope"
IF !ExecRW(cSql,"U_PDV_CA","R")
   return(.f.)
ENDIF

SELECT U_PDV_CA
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   SCATTER MEMVAR MEMO
   
   IF EMPTY(CAS_ARTOLD) .OR. CAS_ARTOLD = SPACE(16)
   ELSE
      DO GESTIONE_AGGIORNA
      SELECT U_PDV_CA
      x_uniq = "id_unique = '" + ID_UNIQUE + "'"
      x_tipo = "cas_tipo = 'CA'"
      x_cond = x_uniq + " and " + x_tipo
      Csql   = "delete from u_pdv_cn where " + x_cond 
      IF !ExecCommand(cSql,"U_PDV_CN")
         return(.f.)
      ENDIF
      SELECT U_PDV_CA
   ENDIF

   XYZ_UNIQUE = ID_UNIQUE

   x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
   x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
   x_cond = x_uniq + " and " + x_tipo
   Csql   = "select * from u_pdv_cn where " + x_cond 
   IF !ExecRW(cSql,"U_PDV_CN","R")
      return(.f.)
   ENDIF
   IF EOF()
      APPEND BLANK
      REPLACE ID_UNIQUE  WITH XYZ_UNIQUE
      REPLACE CAS_TIPO   WITH XYZ_TIPO
      REPLACE CAS_NUMAGG WITH 0
   ENDIF
   XYZ_NUMAGG = CAS_NUMAGG
   IF !ExecRW(cSql,"U_PDV_CN","W")
      return(.f.)
   ENDIF

   IF CAS_QUANTI <> 0 

      IF XYZ_NUMAGG > 8
      ELSE
         IF ASD_DACHI = 'PDV'
            **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
            H_DADOVE = 'ECASH'
            H_GENMOV = 'SI' 
            H_TIPO   = 'GIA'
            H_MAGSCA = M.CAS_CODMAG
            H_MAGCAR = ""
            H_CODART = M.CAS_CODART
            H_TOPSCA = M.CAS_TOP
            H_TOPCAR = ""
            H_QUANTI = M.CAS_QTA
            H_NUMDOC = M.CAS_PROGRE
            H_DATDOC = M.CAS_DATOPE
            H_DATREG = RIBALTA2(DTOC(DATE()))
            H_ORAMOV = M.CAS_ORAOPE
            H_CLIFOR = M.CAS_CODCLI
            H_PRZACQ = 0
            H_PRZVEN = M.CAS_VAL
            H_CODIVA = M.CAS_CODIVA
            H_SCONTO = M.CAS_SCONTO
            H_VALUTA = ""
            H_NOTE   = M.CAS_NOTE
            H_SAC    = ""
            H_GGG    = "SI"
            H_FORNIT = ""
            H_FLGTRA = .F.
            H_CODPDV = M.CAS_CODPDV
            H_CODCAS = M.CAS_CODCAS
            H_LEGSYS = M.CAS_LEGSYS
            =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_SAC,H_GGG,H_FORNIT,H_FLGTRA,H_CODPDV,H_CODCAS,H_LEGSYS)
         ENDIF
         x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
         x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
         x_cond = x_uniq + " and " + x_tipo
         Csql   = "select * from u_pdv_cn where " + x_cond 
         IF !ExecRW(cSql,"U_PDV_CN","R")
            return(.f.)
         ENDIF
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH XYZ_UNIQUE
            REPLACE CAS_TIPO  WITH XYZ_TIPO
         ENDIF
         REPLACE CAS_NUMAGG WITH 9
         IF !ExecRW(cSql,"U_PDV_CN","W")
            return(.f.)
         ENDIF
      ENDIF
      IF ASD_DACHI = 'PDV'
         SELECT U_PDV_CA        	                
         REPLACE CAS_FORNIT WITH XYZ_FORNIT        
         REPLACE CAS_RAGFOR WITH XYZ_RAGSOC        
      ENDIF
      x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
      x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
      x_cond = x_uniq + " and " + x_tipo
      Csql   = "select * from u_pdv_cn where " + x_cond 
      IF !ExecRW(cSql,"U_PDV_CN","R")
          return(.f.)
      ENDIF
      IF EOF()
         APPEND BLANK
         REPLACE ID_UNIQUE WITH XYZ_UNIQUE
         REPLACE CAS_TIPO  WITH XYZ_TIPO  
      ENDIF
      REPLACE CAS_NUMAGG WITH 10
      IF !ExecRW(cSql,"U_PDV_CN","W")
         return(.f.)
      ENDIF

      IF XYZ_NUMAGG > 10
      ELSE
         *=> GESTIONE SALDO A LIVELLO DI PUNTO DI VENDITA ED ARTICOLO VENDUTO
         V_PDV     = M.CAS_CODPDV
         V_PERI_G  = M.CAS_DATOPE
         V_PERI_M  = SUBSTR(V_PERI_G,1,4) + "/" + SUBSTR(V_PERI_G,6,2) + SPACE(03)
         V_PERI_A  = SUBSTR(V_PERI_G,1,4) + SPACE(06)
         x_tipo    = "sal_tipo = '2G'"
         x_cpdv    = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
         x_peri    = "sal_period = '" + V_PERI_G + "'"
         x_codi    = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
         x_cond    = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
         Csql      = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
         IF !ExecRW(cSql,"U_PDV_SA","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SA
         IF RECCOUNT() <> 0
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
            REPLACE SAL_QUANTI WITH SAL_QUANTI + M.CAS_QUANTI
         ELSE
            APPEND BLANK
            REPLACE SAL_TIPO   WITH '2G'
            REPLACE SAL_CODPDV WITH V_PDV
            REPLACE SAL_PERIOD WITH V_PERI_G
            REPLACE SAL_CODART WITH M.CAS_CODART
            REPLACE SAL_DESART WITH M.CAS_DESART
            REPLACE SAL_VALORE WITH M.CAS_IMPORT
            REPLACE SAL_QUANTI WITH M.CAS_QUANTI
         ENDIF
         IF !ExecRW(cSql,"U_PDV_SA","W")
            return(.f.)
         ENDIF
         
         V_PREC_G  = RIBALTA2(DTOC(CTOD(RIBALTA2(M.CAS_DATOPE)) + 7))
         x_prec_p  = "sal_period = '" + V_PREC_G + "'"
         x_cond    = x_tipo + " and " + x_cpdv + " and " + x_prec_p + " and " + x_codi
         Csql      = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
         IF !ExecRW(cSql,"U_PDV_SA","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SA
         IF RECCOUNT() <> 0
            REPLACE SAL_PREVAL WITH SAL_PREVAL + M.CAS_IMPORT
            REPLACE SAL_PREQTA WITH SAL_PREQTA + M.CAS_QUANTI
         ELSE
            x_cond = "codice = 'EDR" + ALLTRIM(M.CAS_EDITOR) + "'"
            Csql   = "select * from para where " + x_cond 
            IF !ExecCommand(cSql,"CUR_PARA")
               return(.f.)
            ENDIF
            SELECT CUR_PARA
            IF RECCOUNT() <> 0
               X_DESEDI = DESCRI
            ELSE
               X_DESEDI = SPACE(50)
            ENDIF
            SELECT U_PDV_SA
            APPEND BLANK
            REPLACE SAL_TIPO   WITH '2G'
            REPLACE SAL_CODPDV WITH V_PDV
            REPLACE SAL_PERIOD WITH V_PREC_G
            REPLACE SAL_CODART WITH M.CAS_CODART
            REPLACE SAL_DESART WITH M.CAS_DESART
            REPLACE SAL_PREVAL WITH M.CAS_IMPORT
            REPLACE SAL_PREQTA WITH M.CAS_QUANTI
            REPLACE SAL_EDITOR WITH M.CAS_EDITOR
            REPLACE SAL_DESEDI WITH X_DESEDI
         ENDIF
         IF !ExecRW(cSql,"U_PDV_SA","W")
            return(.f.)
         ENDIF

         x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
         x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
         x_cond = x_uniq + " and " + x_tipo
         Csql   = "select * from u_pdv_cn where " + x_cond 
         IF !ExecRW(cSql,"U_PDV_CN","R")
            return(.f.)
         ENDIF
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH XYZ_UNIQUE
            REPLACE CAS_TIPO  WITH XYZ_TIPO
         ENDIF
         REPLACE CAS_NUMAGG WITH 11
         IF !ExecRW(cSql,"U_PDV_CN","W")
            return(.f.)
         ENDIF
      ENDIF
        
      IF XYZ_NUMAGG > 11
      ELSE
         x_tipo = "sal_tipo = '2M'"
         x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
         x_peri = "sal_period = '" + V_PERI_M + "'"
         x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
         x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
         Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
         IF !ExecRW(cSql,"U_PDV_SA","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SA
         IF RECCOUNT() <> 0
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
            REPLACE SAL_QUANTI WITH SAL_QUANTI + M.CAS_QUANTI
         ELSE
            APPEND BLANK
            REPLACE SAL_TIPO   WITH '2M'
            REPLACE SAL_CODPDV WITH V_PDV
            REPLACE SAL_PERIOD WITH V_PERI_M
            REPLACE SAL_CODART WITH M.CAS_CODART
            REPLACE SAL_DESART WITH M.CAS_DESART
            REPLACE SAL_VALORE WITH M.CAS_IMPORT
            REPLACE SAL_QUANTI WITH M.CAS_QUANTI
         ENDIF
         IF !ExecRW(cSql,"U_PDV_SA","W")
            return(.f.)
         ENDIF
         
         IF VAL(SUBSTR(V_PERI_M,6,2)) = 12
            V_AA = STR((VAL(SUBSTR(V_PERI_M,1,4)) + 1),4,0)
            V_MM = '01'
         ELSE
            V_AA = SUBSTR(V_PERI_M,1,4)
            V_MM = ALLTRIM(STR((VAL(SUBSTR(V_PERI_M,6,2)) + 1),2,0))
            IF VAL(V_MM) < 10
               V_MM = '0' + V_MM
            ENDIF
         ENDIF
         V_PREC_M  = V_AA + "/" + V_MM + SPACE(03)
         x_prec_p  = "sal_period = '" + V_PREC_M + "'"
         x_cond    = x_tipo + " and " + x_cpdv + " and " + x_prec_p + " and " + x_codi
         Csql      = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
         IF !ExecRW(cSql,"U_PDV_SA","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SA
         IF RECCOUNT() <> 0
            REPLACE SAL_PREVAL WITH SAL_PREVAL + M.CAS_IMPORT
            REPLACE SAL_PREQTA WITH SAL_PREQTA + M.CAS_QUANTI
         ELSE
            x_cond = "codice = 'EDR" + ALLTRIM(M.CAS_EDITOR) + "'"
            Csql   = "select * from para where " + x_cond 
            IF !ExecCommand(cSql,"CUR_PARA")
               return(.f.)
            ENDIF
            SELECT CUR_PARA
            IF RECCOUNT() <> 0
               X_DESEDI = DESCRI
            ELSE
               X_DESEDI = SPACE(50)
            ENDIF
            SELECT U_PDV_SA
            APPEND BLANK
            REPLACE SAL_TIPO   WITH '2M'
            REPLACE SAL_CODPDV WITH V_PDV
            REPLACE SAL_PERIOD WITH V_PREC_M
            REPLACE SAL_CODART WITH M.CAS_CODART
            REPLACE SAL_DESART WITH M.CAS_DESART
            REPLACE SAL_PREVAL WITH M.CAS_IMPORT
            REPLACE SAL_PREQTA WITH M.CAS_QUANTI
            REPLACE SAL_EDITOR WITH M.CAS_EDITOR
            REPLACE SAL_DESEDI WITH X_DESEDI
         ENDIF
         IF !ExecRW(cSql,"U_PDV_SA","W")
            return(.f.)
         ENDIF
                  
         x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
         x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
         x_cond = x_uniq + " and " + x_tipo
         Csql   = "select * from u_pdv_cn where " + x_cond 
         IF !ExecRW(cSql,"U_PDV_CN","R")
            return(.f.)
         ENDIF
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH XYZ_UNIQUE
            REPLACE CAS_TIPO  WITH XYZ_TIPO
         ENDIF
         REPLACE CAS_NUMAGG WITH 12
         IF !ExecRW(cSql,"U_PDV_CN","W")
            return(.f.)
         ENDIF
      ENDIF
      
      IF XYZ_NUMAGG > 12
      ELSE
         x_tipo = "sal_tipo = '2A'"
         x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
         x_peri = "sal_period = '" + V_PERI_A + "'"
         x_codi = "sal_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
         x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
         Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
         IF !ExecRW(cSql,"U_PDV_SA","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SA
         IF RECCOUNT() <> 0
            REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
            REPLACE SAL_QUANTI WITH SAL_QUANTI + M.CAS_QUANTI
         ELSE
            APPEND BLANK
            REPLACE SAL_TIPO   WITH '2A'
            REPLACE SAL_CODPDV WITH V_PDV
            REPLACE SAL_PERIOD WITH V_PERI_A
            REPLACE SAL_CODART WITH M.CAS_CODART
            REPLACE SAL_DESART WITH M.CAS_DESART
            REPLACE SAL_VALORE WITH M.CAS_IMPORT
            REPLACE SAL_QUANTI WITH M.CAS_QUANTI
         ENDIF
         IF !ExecRW(cSql,"U_PDV_SA","W")
            return(.f.)
         ENDIF

         V_AA      = STR((VAL(SUBSTR(V_PERI_A,1,4)) + 1),4,0)
         V_PREC_A  = V_AA + SPACE(06)
         x_prec_p  = "sal_period = '" + V_PREC_A + "'"
         x_cond    = x_tipo + " and " + x_cpdv + " and " + x_prec_p + " and " + x_codi
         Csql      = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
         IF !ExecRW(cSql,"U_PDV_SA","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SA
         IF RECCOUNT() <> 0
            REPLACE SAL_PREVAL WITH SAL_PREVAL + M.CAS_IMPORT
            REPLACE SAL_PREQTA WITH SAL_PREQTA + M.CAS_QUANTI
         ELSE
            x_cond = "codice = 'EDR" + ALLTRIM(M.CAS_EDITOR) + "'"
            Csql   = "select * from para where " + x_cond 
            IF !ExecCommand(cSql,"CUR_PARA")
               return(.f.)
            ENDIF
            SELECT CUR_PARA
            IF RECCOUNT() <> 0
               X_DESEDI = DESCRI
            ELSE
               X_DESEDI = SPACE(50)
            ENDIF
            SELECT U_PDV_SA
            APPEND BLANK
            REPLACE SAL_TIPO   WITH '2A'
            REPLACE SAL_CODPDV WITH V_PDV
            REPLACE SAL_PERIOD WITH V_PREC_A
            REPLACE SAL_CODART WITH M.CAS_CODART
            REPLACE SAL_DESART WITH M.CAS_DESART
            REPLACE SAL_PREVAL WITH M.CAS_IMPORT
            REPLACE SAL_PREQTA WITH M.CAS_QUANTI
            REPLACE SAL_EDITOR WITH M.CAS_EDITOR
            REPLACE SAL_DESEDI WITH X_DESEDI
         ENDIF
         IF !ExecRW(cSql,"U_PDV_SA","W")
            return(.f.)
         ENDIF

         x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
         x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
         x_cond = x_uniq + " and " + x_tipo
         Csql   = "select * from u_pdv_cn where " + x_cond 
         IF !ExecRW(cSql,"U_PDV_CN","R")
            return(.f.)
         ENDIF
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH XYZ_UNIQUE
            REPLACE CAS_TIPO  WITH XYZ_TIPO
         ENDIF
         REPLACE CAS_NUMAGG WITH 13
         IF !ExecRW(cSql,"U_PDV_CN","W")
            return(.f.)
         ENDIF
      ENDIF
      
      *=> GESTIONE CORRISPETTIVI IVA A LIVELLO DI PUNTO DI VENDITA E GIORNO
      IF XYZ_NUMAGG > 13
      ELSE
         NUM_ALIQ = M.CAS_IVA
         DES_ALIQ = M.CAS_DES
         V_PDV    = M.CAS_CODPDV
         V_PERI   = M.CAS_DATOPE
         x_soci   = "cor_codsoc = '" + pub_codsoc + "'"
         x_cpdv   = "cor_codpdv = '" + ALLTRIM(V_PDV) + "'"
         x_peri   = "cor_data = '" + V_PERI + "'"
         x_cond   = x_soci + " and " + x_cpdv + " and " + x_peri
         Csql     = "select * from u_iva_co where " + x_cond + " order by cor_codsoc,cor_codpdv,cor_data"
         IF !ExecRW(cSql,"U_IVA_CO","R")
            return(.f.)
         ENDIF
         SELECT U_IVA_CO
         IF RECCOUNT() <> 0
         ELSE
            APPEND BLANK
            REPLACE COR_CODSOC WITH PUB_CODSOC
            REPLACE COR_CODPDV WITH V_PDV
            REPLACE COR_DATA   WITH V_PERI
            REPLACE COR_ANNO   WITH SUBSTR(V_PERI,1,4)
         ENDIF
         REPLACE COR_TOTALE WITH COR_TOTALE + M.CAS_IMPORT
         IF NUM_ALIQ = 0
            IF EMPTY(COR_CDIVAN) .OR. COR_CDIVAN = SPACE(03)
               REPLACE COR_CDIVAN WITH M.CAS_CODIVA
               REPLACE COR_DEIVAN WITH DES_ALIQ
            ENDIF
            REPLACE COR_VAIVAN    WITH COR_VAIVAN + M.CAS_IMPORT
         ELSE
            V_IVA = .F.
            IF NUM_ALIQ = 4
               REPLACE COR_CDIVA1 WITH M.CAS_CODIVA
               REPLACE COR_PEIVA1 WITH NUM_ALIQ
               REPLACE COR_VAIVA1 WITH COR_VAIVA1 + M.CAS_IMPORT
               REPLACE COR_IMIVA1 WITH COR_IMIVA1 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2) 
               REPLACE COR_IVIVA1 WITH COR_VAIVA1 - COR_IMIVA1
               V_IVA = .T.
            ENDIF    
            IF NUM_ALIQ = 10
               REPLACE COR_CDIVA2 WITH M.CAS_CODIVA
               REPLACE COR_PEIVA2 WITH NUM_ALIQ
               REPLACE COR_VAIVA2 WITH COR_VAIVA2 + M.CAS_IMPORT
               REPLACE COR_IMIVA2 WITH COR_IMIVA2 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA2 WITH COR_VAIVA2 - COR_IMIVA2
               V_IVA = .T.
            ENDIF    
            IF NUM_ALIQ = 20
               REPLACE COR_CDIVA3 WITH M.CAS_CODIVA
               REPLACE COR_PEIVA3 WITH NUM_ALIQ
               REPLACE COR_VAIVA3 WITH COR_VAIVA3 + M.CAS_IMPORT
               REPLACE COR_IMIVA3 WITH COR_IMIVA3 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
               REPLACE COR_IVIVA3 WITH COR_VAIVA3 - COR_IMIVA3
               V_IVA = .T.
            ENDIF    
            IF V_IVA 
            ELSE
               IF COR_CDIVA4 = M.CAS_CODIVA
                  REPLACE COR_VAIVA4 WITH COR_VAIVA4 + M.CAS_IMPORT
                  REPLACE COR_IMIVA4 WITH COR_IMIVA4 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
                  REPLACE COR_IVIVA4 WITH COR_VAIVA4 - COR_IMIVA4
                  V_IVA = .T.
               ENDIF    
               IF COR_CDIVA5 = M.CAS_CODIVA
                  REPLACE COR_VAIVA5 WITH COR_VAIVA5 + M.CAS_IMPORT
                  REPLACE COR_IMIVA5 WITH COR_IMIVA5 + ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
                  REPLACE COR_IVIVA5 WITH COR_VAIVA5 - COR_IMIVA5
                  V_IVA = .T.
               ENDIF    
            ENDIF 
            IF V_IVA 
            ELSE
               IF EMPTY(COR_CDIVA4) .OR. COR_CDIVA4 = SPACE(03)
                  REPLACE COR_CDIVA4 WITH M.CAS_CODIVA
                  REPLACE COR_PEIVA4 WITH NUM_ALIQ
                  REPLACE COR_VAIVA4 WITH M.CAS_IMPORT
                  REPLACE COR_IMIVA4 WITH ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
                  REPLACE COR_IVIVA4 WITH COR_VAIVA4 - COR_IMIVA4
               ELSE
                  IF EMPTY(COR_CDIVA5) .OR. COR_CDIVA5 = SPACE(03)
                     REPLACE COR_CDIVA5 WITH M.CAS_CODIVA
                     REPLACE COR_PEIVA5 WITH NUM_ALIQ
                     REPLACE COR_VAIVA5 WITH M.CAS_IMPORT
                     REPLACE COR_IMIVA5 WITH ROUND((M.CAS_IMPORT / ((NUM_ALIQ / 100) + 1)),2)
                     REPLACE COR_IVIVA5 WITH COR_VAIVA5 - COR_IMIVA5
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         REPLACE COR_NETIVA WITH COR_IMIVA1 + COR_IMIVA2  + COR_IMIVA3 + COR_IMIVA4 + COR_IMIVA5 + COR_VAIVAN
         IF !ExecRW(cSql,"U_IVA_CO","W")
            return(.f.)
         ENDIF
         x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
         x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
         x_cond = x_uniq + " and " + x_tipo
         Csql   = "select * from u_pdv_cn where " + x_cond 
         IF !ExecRW(cSql,"U_PDV_CN","R")
            return(.f.)
         ENDIF
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH XYZ_UNIQUE
            REPLACE CAS_TIPO  WITH XYZ_TIPO
         ENDIF
         REPLACE CAS_NUMAGG WITH 14
         IF !ExecRW(cSql,"U_PDV_CN","W")
            return(.f.)
         ENDIF
      ENDIF
   ENDIF

   IF M.CAS_TIPINC = SPACE(03) .OR. EMPTY(M.CAS_TIPINC)
   ELSE
      *=> GESTIONE SALDO A LIVELLO DI PUNTO DI VENDITA
      IF XYZ_NUMAGG > 14
      ELSE
         V_PDV     = M.CAS_CODPDV
         V_PERI_G  = M.CAS_DATOPE
         V_PERI_M  = SUBSTR(V_PERI_G,1,4) + "/" + SUBSTR(V_PERI_G,6,2) + SPACE(03)
         V_PERI_A  = SUBSTR(V_PERI_G,1,4) + SPACE(06)
         x_tipo    = "sal_tipo = '1G'"
         x_cpdv    = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
         x_peri    = "sal_period = '" + V_PERI_G + "'"
         x_codi    = "sal_codart = '" + SPACE(16) + "'"
         x_cond    = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
         Csql      = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
         IF !ExecRW(cSql,"U_PDV_SA","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SA
         IF RECCOUNT() <> 0
            IF M.CAS_TIPINC = 'RES'
               REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
            ELSE
               REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
            ENDIF
         ELSE
            APPEND BLANK
            REPLACE SAL_TIPO   WITH '1G'
            REPLACE SAL_CODPDV WITH V_PDV
            REPLACE SAL_PERIOD WITH V_PERI_G
            IF M.CAS_TIPINC = 'RES'
               REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
            ELSE
               REPLACE SAL_VALORE WITH M.CAS_IMPORT
            ENDIF
         ENDIF
         IF !ExecRW(cSql,"U_PDV_SA","W")
            return(.f.)
         ENDIF
         x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
         x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
         x_cond = x_uniq + " and " + x_tipo
         Csql   = "select * from u_pdv_cn where " + x_cond 
         IF !ExecRW(cSql,"U_PDV_CN","R")
            return(.f.)
         ENDIF
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH XYZ_UNIQUE
            REPLACE CAS_TIPO  WITH XYZ_TIPO
         ENDIF
         REPLACE CAS_NUMAGG WITH 15
         IF !ExecRW(cSql,"U_PDV_CN","W")
            return(.f.)
         ENDIF
      ENDIF
      
      IF XYZ_NUMAGG > 15
      ELSE
         x_tipo = "sal_tipo = '1M'"
         x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
         x_peri = "sal_period = '" + V_PERI_M + "'"
         x_codi = "sal_codart = '" + SPACE(16) + "'"
         x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
         Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
         IF !ExecRW(cSql,"U_PDV_SA","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SA
         IF RECCOUNT() <> 0
            IF M.CAS_TIPINC = 'RES'
               REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
            ELSE
               REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
            ENDIF
         ELSE
            APPEND BLANK
            REPLACE SAL_TIPO   WITH '1M'
            REPLACE SAL_CODPDV WITH V_PDV
            REPLACE SAL_PERIOD WITH V_PERI_M
            IF M.CAS_TIPINC = 'RES'
               REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
            ELSE
               REPLACE SAL_VALORE WITH M.CAS_IMPORT
            ENDIF
         ENDIF
         IF !ExecRW(cSql,"U_PDV_SA","W")
            return(.f.)
         ENDIF
         x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
         x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
         x_cond = x_uniq + " and " + x_tipo
         Csql   = "select * from u_pdv_cn where " + x_cond 
         IF !ExecRW(cSql,"U_PDV_CN","R")
            return(.f.)
         ENDIF
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH XYZ_UNIQUE
            REPLACE CAS_TIPO  WITH XYZ_TIPO
         ENDIF
         REPLACE CAS_NUMAGG WITH 16
         IF !ExecRW(cSql,"U_PDV_CN","W")
            return(.f.)
         ENDIF
      ENDIF
      
      IF XYZ_NUMAGG > 16
      ELSE
         x_tipo = "sal_tipo = '1A'"
         x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
         x_peri = "sal_period = '" + V_PERI_A + "'"
         x_codi = "sal_codart = '" + SPACE(16) + "'"
         x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
         Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
         IF !ExecRW(cSql,"U_PDV_SA","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_SA
         IF RECCOUNT() <> 0
            IF M.CAS_TIPINC = 'RES'
               REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
            ELSE
               REPLACE SAL_VALORE WITH SAL_VALORE + M.CAS_IMPORT
            ENDIF
         ELSE
            APPEND BLANK
            REPLACE SAL_TIPO   WITH '1A'
            REPLACE SAL_CODPDV WITH V_PDV
            REPLACE SAL_PERIOD WITH V_PERI_A
            IF M.CAS_TIPINC = 'RES'
               REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
            ELSE
               REPLACE SAL_VALORE WITH M.CAS_IMPORT
            ENDIF
         ENDIF
         IF !ExecRW(cSql,"U_PDV_SA","W")
            return(.f.)
         ENDIF
         x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
         x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
         x_cond = x_uniq + " and " + x_tipo
         Csql   = "select * from u_pdv_cn where " + x_cond 
         IF !ExecRW(cSql,"U_PDV_CN","R")
            return(.f.)
         ENDIF
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH XYZ_UNIQUE
            REPLACE CAS_TIPO  WITH XYZ_TIPO
         ENDIF
         REPLACE CAS_NUMAGG WITH 17
         IF !ExecRW(cSql,"U_PDV_CN","W")
            return(.f.)
         ENDIF
      ENDIF
      
      IF XYZ_NUMAGG > 17
      ELSE
         X_TIPPAG = M.CAS_TIP
         V_TROV   = .F.
         Csql = "select * from u_pdv_sc where 1=0"
         IF !ExecCommand(cSql,"CU_PDV_SC")
            return(.f.)
         ENDIF
         x_cpdv   = "cas_codpdv = '" + ALLTRIM(M.CAS_CODPDV) + "'"
         x_maga   = "cas_codmag = '" + ALLTRIM(M.CAS_CODMAG) + "'"
         x_cass   = "cas_codcas = '" + ALLTRIM(M.CAS_CODCAS) + "'"
         x_peri   = "cas_datope = '" + M.CAS_DATOPE + "'"
         x_cond   = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_peri
         Csql     = "select * from u_pdv_sc where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
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
            IF X_TIPPAG = 'C'
               REPLACE CAS_VALCON WITH CAS_VALCON + M.CAS_IMPORT
            ENDIF
            IF X_TIPPAG = 'R'
               REPLACE CAS_VALCON WITH CAS_VALCON - M.CAS_IMPORT
            ENDIF
            IF X_TIPPAG = 'B'
               REPLACE CAS_VALPOS WITH CAS_VALPOS + M.CAS_IMPORT
            ENDIF
            IF X_TIPPAG = 'P'
               REPLACE CAS_VALCAR WITH CAS_VALCAR + M.CAS_IMPORT
            ENDIF
            IF X_TIPPAG = 'A'
               REPLACE CAS_VALASS WITH CAS_VALASS + M.CAS_IMPORT
            ENDIF
            IF X_TIPPAG = 'F'
               REPLACE CAS_VALFIN WITH CAS_VALFIN + M.CAS_IMPORT
            ENDIF
            IF X_TIPPAG = 'V'
               REPLACE CAS_VALALT WITH CAS_VALALT + M.CAS_IMPORT
            ENDIF
         ENDIF
         IF !ExecRW(cSql,"U_PDV_SC","W")
            return(.f.)
         ENDIF
         x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
         x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
         x_cond = x_uniq + " and " + x_tipo
         Csql   = "select * from u_pdv_cn where " + x_cond 
         IF !ExecRW(cSql,"U_PDV_CN","R")
            return(.f.)
         ENDIF
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH XYZ_UNIQUE
            REPLACE CAS_TIPO  WITH XYZ_TIPO
         ENDIF
         REPLACE CAS_NUMAGG WITH 18
         IF !ExecRW(cSql,"U_PDV_CN","W")
            return(.f.)
         ENDIF
      ENDIF
      
      *=> GESTIONE CORRISPETTIVI IVA A LIVELLO DI PUNTO DI VENDITA E GIORNO
      IF XYZ_NUMAGG > 18
      ELSE
         V_PDV  = M.CAS_CODPDV
         V_PERI = M.CAS_DATOPE
         x_soci = "cor_codsoc = '" + pub_codsoc + "'"
         x_cpdv = "cor_codpdv = '" + ALLTRIM(V_PDV) + "'"
         x_peri = "cor_data = '" + V_PERI + "'"
         x_cond = x_soci + " and " + x_cpdv + " and " + x_peri
         Csql   = "select * from u_iva_co where " + x_cond + " order by cor_codsoc,cor_codpdv,cor_data"
         IF !ExecRW(cSql,"U_IVA_CO","R")
            return(.f.)
         ENDIF
         SELECT U_IVA_CO
         IF RECCOUNT() <> 0
         ELSE
            APPEND BLANK
            REPLACE COR_CODSOC WITH PUB_CODSOC
            REPLACE COR_CODPDV WITH V_PDV
            REPLACE COR_DATA   WITH V_PERI
            REPLACE COR_ANNO   WITH SUBSTR(V_PERI,1,4)
         ENDIF
         REPLACE COR_NUMSCO    WITH COR_NUMSCO + 1
         IF !ExecRW(cSql,"U_IVA_CO","W")
            return(.f.)
         ENDIF
         x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
         x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
         x_cond = x_uniq + " and " + x_tipo
         Csql   = "select * from u_pdv_cn where " + x_cond 
         IF !ExecRW(cSql,"U_PDV_CN","R")
            return(.f.)
         ENDIF
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH XYZ_UNIQUE
            REPLACE CAS_TIPO  WITH XYZ_TIPO
         ENDIF
         REPLACE CAS_NUMAGG WITH 19
         IF !ExecRW(cSql,"U_PDV_CN","W")
            return(.f.)
         ENDIF
      ENDIF 
   ENDIF

   SELECT U_PDV_CA
   REPLACE CAS_FLGAGG WITH .T.
   REPLACE CAS_NUMAGG WITH 100

   x_uniq = "id_unique = '" + XYZ_UNIQUE + "'"
   x_tipo = "cas_tipo = '" + XYZ_TIPO + "'"
   x_cond = x_uniq + " and " + x_tipo
   Csql   = "select * from u_pdv_cn where " + x_cond 
   IF !ExecRW(cSql,"U_PDV_CN","R")
      return(.f.)
   ENDIF
   IF EOF()
      APPEND BLANK
      REPLACE ID_UNIQUE WITH XYZ_UNIQUE
      REPLACE CAS_TIPO  WITH XYZ_TIPO
   ENDIF
   REPLACE CAS_NUMAGG WITH 100
   IF !ExecRW(cSql,"U_PDV_CN","W")
      return(.f.)
   ENDIF
   
   SELECT U_PDV_CA   
   SKIP +1

ENDDO

IF !ExecRW(cSql,"U_PDV_CA","W")
   return(.f.)
ENDIF

RETURN


*******************************************************************************
* -->> Funzione per la gestione delle movimentazioni articolo su magazzino
*
* _DADOVE = NOME DELLA FUNZIONE O FORM O PRG DA CUI VIENE CHIAMATA
*           => 'ECASH' = PROVENIENTE DA OPERAZIONI DI SCARICO PER VENDITA A CLIENTI
* _GENMOV = GENERAZIONE DEL MOVIMENTO
*           => 'SI' = GENERA IL MOVIMENTO (U_MAG_MO)
* _TIPO   = TIPO DI PROVENIENZA (DA COMPONENTI)
*           => 'GIA' = TOCCA LA GIACENZA
* _MAGSCA = CODICE DEL MAGAZZINO DA CUI SCARICARE
* _MAGCAR = CODICE DEL MAGAZZINO SU CUI CARICARE
* _CODART = CODICE DELL'ARTICOLO DA MOVIMENTARE
* _TOPSCA = CODICE CAUSALE PER LO SCARICO
* _TOPCAR = CODICE CAUSALE PER IL CARICO
* _QUANTI = QUANTITA' DA MOVIMENTARE
* _NUMDOC = NUMERO DEL DOCUMENTO CHE HA GENERATO IL MOVIMENTO
* _DATDOC = DATA DEL DOCUMENTO CHE HA GENERATO IL MOVIMENTO
* _DATREG = DATA IN CUI E' AVVENUTA LA REGISTRAZIONE
* _ORAMOV = ORA IN CUI E' AVVENUTA LA REGISTRAZIONE DEL MOVIMENTO
* _CLIFOR = CODICE DEL CLIENTE/FORNITORE CHE HA GENERATO IL MOVIMENTO
* _PRZACQ = PREZZO DI ACQUISTO (SIGNIFICATIVO SOLO PER OPERAZIONI DI CARICO DA ACQUISTI)
* _PRZVEN = PREZZO DI VENDITA (SIGNIFICATIVO SOLO PER OPERAZIONI DI SCARICO PER VENDITA)
* _CODIVA = CODICE IVA
* _SCONTO = PERCENTUALE DI SCONTO
* _VALUTA = CODICE VALUTA
* _NOTE   = NOTE VARIE
* _SAC    = ROTTURA PEZZO IN AVANZAMENTO LAVORI (PRODUZIONE)
* _GGG    = GESTISCE IL MAGAZZINO RIEPILOGATO PER GIORNO
* _FORNIT = CODICE FORNITORE DA CUI E' STATO SCARICATO IN FASE DI INCASSO
* _FLGTRA = FLAG CHE INDICA SE IL RECORD MOVIMENTO E' STATO TRASMESSO OPPURE NO
* _CODPDV = CODICE DELLA BUSINESS UNIT
* _CODCAS = CODICE DELLA CASSA ECASH
* _LEGSYS = CODSYS CHE SERVIRA' A LEGARE LA RIGA DI VENDITA AL/AI MOVIMENTI DI MAGAZZINO
*
*******************************************************************************

FUNCTION MOVIMAGA
PARAMETERS _DADOVE,_GENMOV,_TIPO,_MAGSCA,_MAGCAR,_CODART,_TOPSCA,_TOPCAR,_QUANTI,_NUMDOC,_DATDOC,_DATREG,_ORAMOV,_CLIFOR,_PRZACQ,_PRZVEN,_CODIVA,_SCONTO,_VALUTA,_NOTE,_SAC,_GGG,_FORNIT,_FLGTRA,_CODPDV,_CODCAS,_LEGSYS

IF SUBSTR(_DATDOC,3,1) = '/'
   _DATDOC = RIBALTA2(_DATDOC)
ENDIF
IF SUBSTR(_DATREG,3,1) = '/'
   _DATREG = RIBALTA2(_DATREG)
ENDIF

PRIMA=SELECT()

RELEASE V_NAT,V_LIB,V_TMOV,_IMPE
PUBLIC  V_NAT,V_LIB,V_TMOV,_IMPE
V_NAT  = " "
V_LIB  = " "
V_TMOV = "  "
_IMPE  = ""

x_cond = "codice = 'TOP" + ALLTRIM(_TOPSCA) + "'"
Csql   = "select * from para where " + x_cond + " order by codice"
IF !ExecCommand(cSql,"PARA_TOP")
   return(.f.)
ENDIF
SELECT PARA_TOP
GO TOP
IF EOF()
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF

V_NAT  = SUBSTR(LIBERA,1,1)   && (NATURA C=CARICO - S=SCARICO - D=DARE - A=AVERE)
V_LIB  = SUBSTR(LIBERA,12,1)  && (C=CLIENTE - F=FORNITORE - +/-=COMP.D.B. - A=ALTRO)
V_TMOV = SUBSTR(LIBERA,33,2)				

IF V_NAT = 'S'
ELSE
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF

X_SEGNO  = '-'
A_DESART = SPACE(45)
A_UNIMIS = SPACE(02)
A_PRZCOS = 0
A_PRZVEN = 0
A_CODIVA = SPACE(03)
A_CODTAG = SPACE(03)
A_DESTAG = SPACE(30)
A_CODCOL = SPACE(03)
A_DESCOL = SPACE(30)
A_COORD  = SPACE(30)

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
IF RECCOUNT() <> 0
   IF ART_NONMOV
      RETURN
   ENDIF
   SCATTER MEMVAR MEMO
   IF ART_ULDSCA < _DATDOC .OR. (ART_ULDSCA = _DATDOC .AND. ART_ULNSCA < _NUMDOC)
      REPLACE ART_ULDSCA WITH _DATDOC
      REPLACE ART_ULNSCA WITH _NUMDOC
      REPLACE ART_ULQSCA WITH _QUANTI
      REPLACE ART_ULPSCA WITH _PRZVEN
      REPLACE ART_TOTSCA WITH ART_TOTSCA + _QUANTI
   ENDIF
   A_DESART = ART_DESCR
   A_UNIMIS = ART_UNIMIS
   A_PRZCOS = ART_PRZCOS
   A_PRZVEN = ART_PRZVEN
   A_CODIVA = ART_CODIVA
   A_CODTAG = ART_CODTAG
   A_DESTAG = ART_DESTAG
   A_CODCOL = ART_CODCOL
   A_DESCOL = ART_DESCOL
   A_COORD  = ART_COORD
   IF !ExecRW(cSql,"U_ART_PR","W")
      return(.f.)
   ENDIF
ELSE
   RETURN
ENDIF   

_PRZVEN = ART_PRZVEN
 
*-->> RICERCA DELL'ANAGRAFICA FORNITORE/CLIENTE  ----------------------------

RELEASE M_CLIFOR,M_RAGSOC,M_FORNIT,M_DESFOR,M_PRIMOF,M_QTAFOR,M_QUANTI,M_GENMOV, ;
        M_GIAFOR,M_CODPDV
PUBLIC  M_CLIFOR,M_RAGSOC,M_FORNIT,M_DESFOR,M_PRIMOF,M_QTAFOR,M_QUANTI,M_GENMOV, ;
        M_GIAFOR,M_CODPDV
M_CLIFOR = _CLIFOR
M_RAGSOC = ""
M_FORNIT = ""
M_DESFOR = ""
M_PRIMOF = _CLIFOR
M_QTAFOR = 0
M_QUANTI = _QUANTI
M_GENMOV = _GENMOV
M_GIAFOR = 0
M_CODPDV = _CODPDV

*==> OPERAZIONI SUL MAGAZZINO PRINCIPALE
=MAGAMOVI(_MAGSCA,_TOPSCA)

XYZ_FORNIT = M_FORNIT			&& RINO 07/07/2003
XYZ_RAGSOC = M_RAGSOC			&& RINO 07/07/2003

RETURN


*******************************************************************************
* -->> Funzione per la gestione delle movimentazioni articolo su magazzino
*
* _MAG = MAGAZZINO (DI CARICO/SCARICO)
* _TOP = CAUSALE   (DI CARICO/SCARICO) 
*
*******************************************************************************

FUNCTION MAGAMOVI
PARAMETERS _MAG,_TOP

RELEASE _MAG1,_TOP1,X_SEGNO1
PUBLIC  _MAG1,_TOP1,X_SEGNO1
_MAG1      = ""
_TOP1      = ""
X_SEGNO1   = ""

*SET STEP ON 

*-->> RICERCA DEL FORNITORE PRINCIPALE CON AGGIORNAMENTO GIACENZE PER FORNITORE E MOVIMENTI --

IF _GGG = "SI"

   IF PUB_FORPRE
      DO GESTIONE_FORN_PREF
   ELSE
      DO GESTIONE_NOFORN_PREF
   ENDIF

   M_GENMOV = "NO"

ENDIF

*-->> SCARICA LA GIACENZA DI MAGAZZINO ----------------------------

DO MAGAZZINO_STANDARD

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


***************************
PROCEDURE GESTIONE_AGGIORNA
***************************

V_CAUCON = SPACE(03)
x_cond   = "codice = 'TOP" + ALLTRIM(M.CAS_TOP) + "'"
Csql     = "select * from para where " + x_cond + " order by codice"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   V_CAUCON = ""
ELSE
	** SERGIO 19/11/2021 INIZIO 
   	*V_CAUCON = SUBSTR(LIBERA,35,3)
	V_CAUCON = CERCA_CAUSALI_TOP(M.CAS_TOP,'CONCAU')	&& CAUSALE CONTRARIA A QUELLA DIGITATA
	** SERGIO 19/11/2021 FINE  
ENDIF
IF V_CAUCON = SPACE(03) .OR. EMPTY(V_CAUCON)
   V_CAUCON = '100'
ENDIF

**==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO IN AGGIORNAMENTO
H_DADOVE = 'ECASH'
H_GENMOV = 'SI' 
H_TIPO   = 'GIA'
H_MAGSCA = M.CAS_CODMAG
H_MAGCAR = ""
H_CODART = M.CAS_ARTOLD
H_TOPSCA = V_CAUCON
H_TOPCAR = ""
H_QUANTI = M.CAS_QTA
H_NUMDOC = M.CAS_PROGRE
H_DATDOC = M.CAS_DATOPE
H_DATREG = RIBALTA2(DTOC(DATE()))
H_ORAMOV = M.CAS_ORAOPE
H_CLIFOR = M.CAS_CODCLI
H_PRZACQ = 0
H_PRZVEN = M.CAS_VAL
H_CODIVA = M.CAS_CODIVA
H_SCONTO = M.CAS_SCONTO
H_VALUTA = ""
H_NOTE   = M.CAS_NOTE
H_SAC    = ""
H_GGG    = "SI"
H_FORNIT = M.CAS_FORNIT
H_FLGTRA = .T.
H_CODPDV = M.CAS_CODPDV

=AGGIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_SAC,H_GGG,H_FORNIT,H_FLGTRA,H_CODPDV)

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(M.CAS_ARTOLD) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
IF RECCOUNT() <> 0
   XXX_DESART = ART_DESCR
ELSE
   XXX_DESART = SPACE(50)
ENDIF

*=> GESTIONE SALDO A LIVELLO DI PUNTO DI VENDITA ED ARTICOLO VENDUTO
V_PDV     = M.CAS_CODPDV
V_PERI_G  = M.CAS_DATOPE
V_PERI_M  = SUBSTR(V_PERI_G,1,4) + "/" + SUBSTR(V_PERI_G,6,2) + SPACE(03)
V_PERI_A  = SUBSTR(V_PERI_G,1,4) + SPACE(06)
x_tipo    = "sal_tipo = '2G'"
x_cpdv    = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
x_peri    = "sal_period = '" + V_PERI_G + "'"
x_codi    = "sal_codart = '" + ALLTRIM(M.CAS_ARTOLD) + "'"
x_cond    = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
Csql      = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
IF !ExecRW(cSql,"U_PDV_SA","R")
   return(.f.)
ENDIF
SELECT U_PDV_SA
IF RECCOUNT() <> 0
   REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
   REPLACE SAL_QUANTI WITH SAL_QUANTI - M.CAS_QUANTI
ELSE
   APPEND BLANK
   REPLACE SAL_TIPO   WITH '2G'
   REPLACE SAL_CODPDV WITH V_PDV
   REPLACE SAL_PERIOD WITH V_PERI_G
   REPLACE SAL_CODART WITH M.CAS_ARTOLD
   REPLACE SAL_DESART WITH XXX_DESART
   REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
   REPLACE SAL_QUANTI WITH M.CAS_QUANTI * -1
ENDIF
IF !ExecRW(cSql,"U_PDV_SA","W")
   return(.f.)
ENDIF
        
x_tipo = "sal_tipo = '2M'"
x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
x_peri = "sal_period = '" + V_PERI_M + "'"
x_codi = "sal_codart = '" + ALLTRIM(M.CAS_ARTOLD) + "'"
x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
IF !ExecRW(cSql,"U_PDV_SA","R")
   return(.f.)
ENDIF
SELECT U_PDV_SA
IF RECCOUNT() <> 0
   REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
   REPLACE SAL_QUANTI WITH SAL_QUANTI - M.CAS_QUANTI
ELSE
   APPEND BLANK
   REPLACE SAL_TIPO   WITH '2M'
   REPLACE SAL_CODPDV WITH V_PDV
   REPLACE SAL_PERIOD WITH V_PERI_M
   REPLACE SAL_CODART WITH M.CAS_CODART
   REPLACE SAL_DESART WITH XXX_DESART
   REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
   REPLACE SAL_QUANTI WITH M.CAS_QUANTI * -1
ENDIF
IF !ExecRW(cSql,"U_PDV_SA","W")
   return(.f.)
ENDIF
      
x_tipo = "sal_tipo = '2A'"
x_cpdv = "sal_codpdv = '" + ALLTRIM(V_PDV) + "'"
x_peri = "sal_period = '" + V_PERI_A + "'"
x_codi = "sal_codart = '" + ALLTRIM(M.CAS_ARTOLD) + "'"
x_cond = x_tipo + " and " + x_cpdv + " and " + x_peri + " and " + x_codi
Csql   = "select * from u_pdv_sa where " + x_cond + " order by sal_tipo,sal_codpdv,sal_period,sal_codart"
IF !ExecRW(cSql,"U_PDV_SA","R")
   return(.f.)
ENDIF
SELECT U_PDV_SA
IF RECCOUNT() <> 0
   REPLACE SAL_VALORE WITH SAL_VALORE - M.CAS_IMPORT
   REPLACE SAL_QUANTI WITH SAL_QUANTI - M.CAS_QUANTI
ELSE
   APPEND BLANK
   REPLACE SAL_TIPO   WITH '2A'
   REPLACE SAL_CODPDV WITH V_PDV
   REPLACE SAL_PERIOD WITH V_PERI_A
   REPLACE SAL_CODART WITH M.CAS_CODART
   REPLACE SAL_DESART WITH XXX_DESART
   REPLACE SAL_VALORE WITH M.CAS_IMPORT * -1
   REPLACE SAL_QUANTI WITH M.CAS_QUANTI * -1
ENDIF
IF !ExecRW(cSql,"U_PDV_SA","W")
   return(.f.)
ENDIF

x_arti = "ord_codart = '" + ALLTRIM(M.CAS_ARTOLD) + "'"
x_nume = "ors_numord = '" + ALLTRIM(M.CAS_NUMFAT) + "'"
x_data = "ors_datord = '" + ALLTRIM(M.CAS_DATFAT) + "'"
x_clie = "ors_codcli = '" + ALLTRIM(M.CAS_CODCLI) + "'"
x_cond = x_arti + " and " + x_nume + " and " + x_data + " and " + x_clie
Csql   = "select * from u_fat_dd where " + x_cond
IF !ExecRW(cSql,"U_FAT_DD","R")
   return(.f.)
ENDIF
XXX_AGGANCIO = SPACE(10)
SELECT U_FAT_DD
IF RECCOUNT() <> 0
   XXX_AGGANCIO = DAGGANCIO
   REPLACE ORD_CODART WITH M.CAS_CODART
   REPLACE ORD_DESART WITH M.CAS_DESART
ENDIF
IF !ExecRW(cSql,"U_FAT_DD","W")
   return(.f.)
ENDIF
IF XXX_AGGANCIO = SPACE(10)
ELSE
   x_agga = "taggancio = '" + XXX_AGGANCIO + "'"
   x_cond = x_agga
   Csql   = "select * from u_fat_tt where " + x_cond
   IF !ExecRW(cSql,"U_FAT_TT","R")
      return(.f.)
   ENDIF
   SELECT U_FAT_TT
   IF RECCOUNT() <> 0
      REPLACE ORD_FLGTRA WITH .F.
   ENDIF
   IF !ExecRW(cSql,"U_FAT_TT","W")
      return(.f.)
   ENDIF
ENDIF

RETURN


*******************************************************************************************
* -->> Funzione per la gestione delle movimentazioni articolo su magazzino in aggiornamento
*******************************************************************************************

FUNCTION AGGIMAGA
PARAMETERS _DADOVE,_GENMOV,_TIPO,_MAGSCA,_MAGCAR,_CODART,_TOPSCA,_TOPCAR,_QUANTI,_NUMDOC,_DATDOC,_DATREG,_ORAMOV,_CLIFOR,_PRZACQ,_PRZVEN,_CODIVA,_SCONTO,_VALUTA,_NOTE,_SAC,_GGG,_FORNIT,_FLGTRA,_CODPDV

IF SUBSTR(_DATDOC,3,1) = '/'
   _DATDOC = RIBALTA2(_DATDOC)
ENDIF
IF SUBSTR(_DATREG,3,1) = '/'
   _DATREG = RIBALTA2(_DATREG)
ENDIF

PRIMA=SELECT()

x_cond = "codice = 'TOP" + ALLTRIM(_TOPSCA) + "'"
Csql   = "select * from para where " + x_cond + " order by codice"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   SELECT(PRIMA)
   RETURN(.t.)
ELSE
   M.NAT  = SUBSTR(LIBERA,1,1)   && (NATURA C=CARICO - S=SCARICO - D=DARE - A=AVERE)
   M.LIB  = SUBSTR(LIBERA,12,1)  && (C=CLIENTE - F=FORNITORE - +/-=COMP.D.B. - A=ALTRO)
   M.TMOV = SUBSTR(LIBERA,33,2)				
ENDIF

IF M.NAT = 'C' 
ELSE
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF

X_SEGNO = '+'								

A_DESART = SPACE(45)
A_UNIMIS = SPACE(02)
A_PRZCOS = 0
A_PRZVEN = 0
A_CODIVA = SPACE(03)
A_CODTAG = SPACE(03)
A_DESTAG = SPACE(30)
A_CODCOL = SPACE(03)
A_DESCOL = SPACE(30)
A_COORD  = SPACE(30)

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
IF RECCOUNT() <> 0
   IF ART_NONMOV
      RETURN
   ENDIF
   SCATTER MEMVAR MEMO
   IF ART_ULDSCA = _DATDOC .AND. ART_ULNSCA = _NUMDOC
      REPLACE ART_ULDSCA WITH SPACE(10)
      REPLACE ART_ULNSCA WITH SPACE(06)
      REPLACE ART_ULQSCA WITH 0
      REPLACE ART_ULPSCA WITH 0
      REPLACE ART_TOTSCA WITH ART_TOTSCA - _QUANTI
   ENDIF
   A_DESART = ART_DESCR
   A_UNIMIS = ART_UNIMIS
   A_PRZCOS = ART_PRZCOS
   A_PRZVEN = ART_PRZVEN
   A_CODIVA = ART_CODIVA
   A_CODTAG = ART_CODTAG
   A_DESTAG = ART_DESTAG
   A_CODCOL = ART_CODCOL
   A_DESCOL = ART_DESCOL
   A_COORD  = ART_COORD
   IF !ExecRW(cSql,"U_ART_PR","W")
      return(.f.)
   ENDIF
ELSE
   RETURN
ENDIF   

*-->> RICERCA DELL'ANAGRAFICA FORNITORE/CLIENTE  ----------------------------

RELEASE M_CLIFOR,M_RAGSOC,M_FORNIT,M_DESFOR,M_PRIMOF,M_QTAFOR,M_QUANTI,M_GENMOV, ;
        M_GIAFOR,M_CODPDV
PUBLIC  M_CLIFOR,M_RAGSOC,M_FORNIT,M_DESFOR,M_PRIMOF,M_QTAFOR,M_QUANTI,M_GENMOV, ;
        M_GIAFOR,M_CODPDV
M_CLIFOR = _CLIFOR
M_RAGSOC = ""
M_FORNIT = ""
M_DESFOR = ""
M_PRIMOF = _CLIFOR
M_QTAFOR = 0
M_QUANTI = _QUANTI
M_GENMOV = _GENMOV
M_GIAFOR = 0
M_CODPDV = _CODPDV

*==> OPERAZIONI SUL MAGAZZINO PRINCIPALE
=AGGIMOVI(_MAGSCA,_TOPSCA,X_SEGNO)

XYZ_FORNIT = M_FORNIT			&& RINO 07/07/2003
XYZ_RAGSOC = M_RAGSOC			&& RINO 07/07/2003

RETURN


*******************************************************************************
* -->> Funzione per la gestione delle movimentazioni articolo su magazzino
*
* _MAG = MAGAZZINO (DI CARICO/SCARICO)
* _TOP = CAUSALE   (DI CARICO/SCARICO) 
*
*******************************************************************************

FUNCTION AGGIMOVI
PARAMETERS _MAG,_TOP,_SEGNO

X_SEGNO = _SEGNO

IF EMPTY(M_CLIFOR) .OR. M_CLIFOR = SPACE(10)
ELSE
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(M_CLIFOR) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"u_cli_an")
      return(.f.)
   ENDIF
   SELECT u_cli_an
   GO TOP
   IF !EOF()
      M_RAGSOC = CLI_RAGSOC
   ELSE
      x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "for_codcli = '" + ALLTRIM(M_CLIFOR) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
      IF !ExecCommand(cSql,"u_for_an")
         return(.f.)
      ENDIF
      SELECT u_for_an
      GO TOP
      IF !EOF()
         M_RAGSOC = FOR_RAGSOC
      ENDIF
   ENDIF
ENDIF

*-->> RICERCA DEL FORNITORE PRINCIPALE CON AGGIORNAMENTO GIACENZE PER FORNITORE E MOVIMENTI --

IF _GGG = "SI"

   M_PRIMOF = ""

   IF EMPTY(_FORNIT) .OR. _FORNIT = SPACE(10)
      x_soci   = "fpr_codsoc = '" + PUB_CODSOC + "'"
      x_maga   = "fpr_codmag = '" + ALLTRIM(_MAG) + "'"
      x_codi   = "fpr_codart = '" + ALLTRIM(_CODART) + "'"
      x_cond   = x_soci + " and " + x_maga + " and " + x_codi 
      Csql     = "select * from u_for_pr where " + x_cond + " order by fpr_codsoc,fpr_codart,fpr_seqpri"
      IF !ExecCommand(cSql,"U_FOR_PR")
         return(.f.)
      ENDIF
   ELSE
      x_soci   = "fpr_codsoc = '" + PUB_CODSOC + "'"
      x_maga   = "fpr_codmag = '" + ALLTRIM(_MAG) + "'"
      x_codi   = "fpr_codart = '" + ALLTRIM(_CODART) + "'"
      x_forn   = "fpr_codfor = '" + ALLTRIM(_FORNIT) + "'"
      x_cond   = x_soci + " and " + x_maga + " and " + x_codi + " and " + x_forn
      Csql     = "select * from u_for_pr where " + x_cond + " order by fpr_codsoc,fpr_codart,fpr_codfor,fpr_seqpri"
      IF !ExecCommand(cSql,"U_FOR_PR")
         return(.f.)
      ENDIF
   ENDIF

   SELECT U_FOR_PR
   GO TOP
   IF !EOF()
      M_PRIMOF = FPR_CODFOR
   ENDIF   

   M_QUANTI = _QUANTI

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      M_FORNIT = FPR_CODFOR
      M_DESFOR = ""

      *-->> RICERCA DELLA RAGIONE SOCIALE DEL FORNITORE DI CARICO
      x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "for_codcli = '" + ALLTRIM(M_FORNIT) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
      IF !ExecCommand(cSql,"u_for_an")
         return(.f.)
      ENDIF
      SELECT u_for_an
      GO TOP
      IF !EOF()
         M_DESFOR = FOR_RAGSOC
      ELSE 
         M_DESFOR = ""
      ENDIF
      
      *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
      x_soci   = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_data   = "mag_datagg = '" + SPACE(10) + "'"
      x_codi   = "mag_codart = '" + ALLTRIM(_CODART) + "'"
      x_maga   = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
      x_forn   = "mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
      x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
      Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
      IF !ExecRW(cSql,"U_MAG_GG","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_GG
      IF RECCOUNT() = 0
         APPEND BLANK
         REPLACE MAG_CODSOC WITH PUB_CODSOC
         REPLACE MAG_DATAGG WITH SPACE(10)
         REPLACE MAG_CODMAG WITH _MAG
         REPLACE MAG_CODART WITH _CODART
         REPLACE MAG_DESART WITH A_DESART
         REPLACE MAG_CODPDV WITH M_CODPDV
         REPLACE MAG_FORNIT WITH M_FORNIT
         REPLACE MAG_DESFOR WITH M_DESFOR
         REPLACE MAG_GIACEN WITH 0
      ENDIF
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QUANTI
      M_QTAFOR = M_QUANTI
      M_QUANTI = 0
      M_GIAFOR = MAG_GIACEN
      IF !ExecRW(cSql,"U_MAG_GG","W")
         return(.f.)
      ENDIF
      
      *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_data = "mag_datagg = '" + _DATREG + "'"
      x_codi = "mag_codart = '" + ALLTRIM(_CODART) + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
      x_forn = "mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
      x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
      Csql     = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
      IF !ExecRW(cSql,"U_MAG_GG","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_GG
      IF RECCOUNT() = 0
         APPEND BLANK
         REPLACE MAG_CODSOC WITH PUB_CODSOC
         REPLACE MAG_DATAGG WITH _DATREG
         REPLACE MAG_CODMAG WITH _MAG
         REPLACE MAG_CODART WITH _CODART
         REPLACE MAG_DESART WITH A_DESART
         REPLACE MAG_CODPDV WITH M_CODPDV
         REPLACE MAG_FORNIT WITH M_FORNIT
         REPLACE MAG_DESFOR WITH M_DESFOR
         REPLACE MAG_GIACEN WITH 0
      ENDIF
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QTAFOR
      IF !ExecRW(cSql,"U_MAG_GG","W")
         return(.f.)
      ENDIF

      IF _GENMOV = "SI"
         * CREA IL MOVIMENTO DI RICARICO MAGAZZINO ---------------------------
         Csql   = "select * from u_mag_mo"
         IF !ExecRW(cSql,"U_MAG_MO","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_MO
         APPEND BLANK
         REPLACE MOV_CODSOC WITH PUB_CODSOC
         REPLACE MOV_CODMAG WITH _MAG
         REPLACE MOV_CODART WITH _CODART
         REPLACE MOV_DESART WITH A_DESART
         REPLACE MOV_TOP    WITH _TOP
         REPLACE MOV_QTAMOV WITH M_QTAFOR
         IF _PRZVEN = 0
            REPLACE MOV_PREVEN WITH A_PRZVEN
         ELSE
            REPLACE MOV_PREVEN WITH _PRZVEN
         ENDIF
         IF _PRZACQ = 0
            REPLACE MOV_PREACQ WITH A_PRZCOS
         ELSE
            REPLACE MOV_PREACQ WITH _PRZACQ
         ENDIF
         IF EMPTY(_CODIVA)
            REPLACE MOV_IVAVEN WITH A_CODIVA
         ELSE
            REPLACE MOV_IVAVEN WITH _CODIVA
         ENDIF
         IF EMPTY(_VALUTA)
            REPLACE MOV_VALUTA WITH PUB_VALRIF
         ELSE
            REPLACE MOV_VALUTA WITH _VALUTA
         ENDIF
         REPLACE MOV_SCONTO WITH _SCONTO
         REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
         REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
         REPLACE MOV_NUMDOC WITH _NUMDOC
         REPLACE MOV_DTDOCU WITH _DATDOC
         REPLACE MOV_CODFOR WITH M_CLIFOR
         REPLACE MOV_RAGSOC WITH M_RAGSOC
         REPLACE MOV_DTREGI WITH _DATREG
         REPLACE MOV_CODTAG WITH A_CODTAG
         REPLACE MOV_DESTAG WITH A_DESTAG
         REPLACE MOV_CODCOL WITH A_CODCOL
         REPLACE MOV_DESCOL WITH A_DESCOL
         REPLACE MOV_NOTVAR WITH _NOTE
         REPLACE MOV_UM     WITH A_UNIMIS
         REPLACE MOV_CODPDV WITH M_CODPDV				
         REPLACE MOV_ORAMOV WITH _ORAMOV					
         REPLACE MOV_SEGNO  WITH X_SEGNO					
         REPLACE MOV_TIPMOV WITH M.TMOV				
         REPLACE MOV_FORNIT WITH M_FORNIT
         REPLACE MOV_DESFOR WITH M_DESFOR
         REPLACE MOV_COORD  WITH A_COORD
         REPLACE MOV_FLGTRA WITH _FLGTRA
         REPLACE MOV_CODOPE WITH PUB_CODOPE
         REPLACE MOV_NOMOPE WITH PUB_NOMOPE
         IF !ExecRW(cSql,"U_MAG_MO","W")
            return(.f.)
         ENDIF
      ENDIF
      
      **==>> RICHIAMA LA FUNZIONE PER GESTIRE I CAMPI PROGRESSIVI ANNUALI DI CARICO/SCARICO + ANAGR.ART.
      IF _PRZVEN = 0
         R_PRZVEN = A_PRZVEN
      ELSE
         R_PRZVEN = _PRZVEN
      ENDIF
      IF _PRZACQ = 0
         R_PRZCOS = A_PRZCOS
      ELSE 
         R_PRZCOS = _PRZACQ
      ENDIF
      *=MOVIARTI(ALLTRIM(_CODART),_MAG,_NUMDOC,_DATDOC,M_QTAFOR,R_PRZCOS,R_PRZVEN,_TOP,M_CLIFOR)

      IF M_QUANTI = 0
         EXIT
      ENDIF

      SELECT U_FOR_PR
      SKIP +1

   ENDDO

   M_GENMOV = "NO"

ENDIF

*-->> RICARICA LA GIACENZA DI MAGAZZINO ----------------------------
x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
x_codi = "mag_codart = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_maga + " and " + x_codi
Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
IF !ExecRW(cSql,"U_MAG_AN","R")
   return(.f.)
ENDIF
SELECT U_MAG_AN
IF RECCOUNT() <> 0
   IF _TIPO = "GIA"	
      REPLACE MAG_GIACEN WITH MAG_GIACEN + _QUANTI
   ENDIF
ELSE
   APPEND BLANK
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_CODMAG WITH _MAG
   REPLACE MAG_CODART WITH _CODART
   REPLACE MAG_DESART WITH A_DESART
   IF _TIPO = "GIA"	
      REPLACE MAG_GIACEN WITH _QUANTI
   ENDIF
   REPLACE MAG_CODFOR WITH M_CLIFOR
   REPLACE MAG_COSTO  WITH A_PRZCOS
   REPLACE MAG_UNIMIS WITH A_UNIMIS
   REPLACE MAG_DTCREA WITH _DATREG
   REPLACE MAG_CODTAG WITH A_CODTAG
   REPLACE MAG_DESTAG WITH A_DESTAG
   REPLACE MAG_CODCOL WITH A_CODCOL
   REPLACE MAG_DESCOL WITH A_DESCOL
   REPLACE MAG_CODPDV WITH M_CODPDV	
ENDIF
IF !ExecRW(cSql,"U_MAG_AN","W")
   return(.f.)
ENDIF

IF M_GENMOV = "SI"
   * CREA IL MOVIMENTO DI RICARICO MAGAZZINO --------------------------- 
   Csql   = "select * from u_mag_mo"
   IF !ExecRW(cSql,"U_MAG_MO","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_MO
   APPEND BLANK
   REPLACE MOV_CODSOC WITH PUB_CODSOC
   REPLACE MOV_CODMAG WITH _MAG
   REPLACE MOV_CODART WITH _CODART 
   REPLACE MOV_DESART WITH A_DESART
   REPLACE MOV_TOP    WITH _TOP
   REPLACE MOV_QTAMOV WITH _QUANTI
   IF _PRZVEN = 0
      REPLACE MOV_PREVEN WITH A_PRZVEN
   ELSE
      REPLACE MOV_PREVEN WITH _PRZVEN
   ENDIF
   IF _PRZACQ = 0
      REPLACE MOV_PREACQ WITH A_PRZCOS
   ELSE
      REPLACE MOV_PREACQ WITH _PRZACQ
   ENDIF
   IF EMPTY(_CODIVA)
      REPLACE MOV_IVAVEN WITH A_CODIVA
   ELSE
      REPLACE MOV_IVAVEN WITH _CODIVA
   ENDIF
   IF EMPTY(_VALUTA)
      REPLACE MOV_VALUTA WITH PUB_VALRIF
   ELSE
      REPLACE MOV_VALUTA WITH _VALUTA
   ENDIF
   REPLACE MOV_SCONTO WITH _SCONTO
   REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
   REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
   REPLACE MOV_NUMDOC WITH _NUMDOC
   REPLACE MOV_DTDOCU WITH _DATDOC
   REPLACE MOV_CODFOR WITH M_CLIFOR
   REPLACE MOV_RAGSOC WITH M_RAGSOC
   REPLACE MOV_DTREGI WITH _DATREG
   REPLACE MOV_CODTAG WITH A_CODTAG
   REPLACE MOV_DESTAG WITH A_DESTAG
   REPLACE MOV_CODCOL WITH A_CODCOL
   REPLACE MOV_DESCOL WITH A_DESCOL
   REPLACE MOV_NOTVAR WITH _NOTE
   REPLACE MOV_UM     WITH A_UNIMIS
   REPLACE MOV_CODPDV WITH M_CODPDV				
   REPLACE MOV_ORAMOV WITH _ORAMOV					
   REPLACE MOV_SEGNO  WITH X_SEGNO					
   REPLACE MOV_TIPMOV WITH M.TMOV				
   REPLACE MOV_FORNIT WITH ""
   REPLACE MOV_DESFOR WITH ""
   REPLACE MOV_COORD  WITH A_COORD
   REPLACE MOV_FLGTRA WITH _FLGTRA
   REPLACE MOV_CODOPE WITH PUB_CODOPE
   REPLACE MOV_NOMOPE WITH PUB_NOMOPE
   IF !ExecRW(cSql,"U_MAG_MO","W")
      return(.f.)
   ENDIF
ENDIF

RETURN

