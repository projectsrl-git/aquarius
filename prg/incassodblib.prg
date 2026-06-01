**************************************************************************
PROCEDURE GESTIONE_INCASSO  			 && SCARICA IL MAGAZZINO E I SALDI
**************************************************************************

RELEASE PUB_CODSOC,PUB_VALRIF,XYZ_FORNIT,XYZ_RAGSOC,XYZ_NUMAGG,XYZ_UNIQUE,XYZ_TIPO
PUBLIC  PUB_CODSOC,PUB_VALRIF,XYZ_FORNIT,XYZ_RAGSOC,XYZ_NUMAGG,XYZ_UNIQUE,XYZ_TIPO
PUB_CODSOC = '01'
PUB_VALRIF = 'EUR'
XYZ_FORNIT = SPACE(10)
XYZ_RAGSOC = SPACE(50)
XYZ_NUMAGG = 0
XYZ_UNIQUE = ""
XYZ_TIPO   = 'CA'

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
         **==>> RICHIAMA LA FUNZIONE PER GESTIRE IL MAGAZZINO
         H_DADOVE = 'ECASH'
         H_GENMOV = 'SI' 
         H_TIPO   = 'GIA'
         H_IMPE   = ""
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
         H_FLGTRA = .T.
         H_CODPDV = M.CAS_CODPDV
         =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_SAC,H_GGG,H_FORNIT,H_FLGTRA,H_CODPDV)
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
      SELECT U_PDV_CA        	                
      REPLACE CAS_FORNIT WITH XYZ_FORNIT        
      REPLACE CAS_RAGFOR WITH XYZ_RAGSOC        
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

   *=> GESTIONE SCARICO COMPONENTI RICETTA + CARICO/SCARICO DEL PRODOTTO FINITO
   IF XYZ_NUMAGG > 19
   ELSE
      x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "dit_gruppo = '" + ALLTRIM(M.CAS_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
      IF !ExecCommand(cSql,"cur_diba")
         return(.f.)
      ENDIF
      SELECT cur_diba
      GO TOP
      IF !EOF()
         * DA FARE GESTIONE DI ESPLOSIONE DIS.BAS. ARTICOLO PER SCARICARE SU U_MAG_AN LE QUANTITA'            * (TRATTASI DI ARTICOLO DI ACQUISTO O C/LAV.
         Z_CODART = ALLTRIM(M.CAS_CODART)
         Z_MAGA   = ALLTRIM(M.CAS_CODMAG)
         Z_QTADVE = M.CAS_QUANTI
         Z_SALCON = 'S'
         Z_NUMDOC = M.CAS_PROGRE
         Z_DATDOC = M.CAS_DATOPE
         Z_CODCLI = M.CAS_CODCLI
         Z_CODPDV = M.CAS_CODPDV
         Z_CODIVA = M.CAS_CODIVA
         =PRODISBA("INCASSODB",Z_CODART,Z_MAGA,Z_QTADVE,Z_SALCON,Z_NUMDOC,Z_DATDOC,Z_CODCLI,Z_CODPDV,Z_CODIVA)
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
      REPLACE CAS_NUMAGG WITH 20
      IF !ExecRW(cSql,"U_PDV_CN","W")
         return(.f.)
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
*           => 'ACQ' 'BFO'         = PROVENIENTE DA OPERAZIONI DI CARICO DA FORNITORE
*           => 'VEN' 'ECASH' 'BOL' = PROVENIENTE DA OPERAZIONI DI SCARICO PER VENDITA A CLIENTI
* _GENMOV = GENERAZIONE DEL MOVIMENTO
*           => 'SI' = GENERA IL MOVIMENTO (U_MAG_MO)
* _TIPO   = TIPO DI PROVENIENZA (DA COMPONENTI)
*           => 'GIA' = TOCCA LA GIACENZA
* _IMPE   = FLAG DI GESTIONE IMPEGNATO
*           => 'X' = GESTISCE CAMPI IMPEGNATO
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
*
*******************************************************************************

FUNCTION MOVIMAGA
PARAMETERS _DADOVE,_GENMOV,_TIPO,_IMPE,_MAGSCA,_MAGCAR,_CODART,_TOPSCA,_TOPCAR,_QUANTI,_NUMDOC,_DATDOC,_DATREG,_ORAMOV,_CLIFOR,_PRZACQ,_PRZVEN,_CODIVA,_SCONTO,_VALUTA,_NOTE,_SAC,_GGG,_FORNIT,_FLGTRA,_CODPDV

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

IF M.NAT = 'C' .OR. M.NAT = 'S'
ELSE
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF

IF M.NAT = 'C'									
   X_SEGNO = '+'								
ELSE
   X_SEGNO = '-'								
ENDIF												

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
   IF X_SEGNO = '+'
   ELSE
      IF ART_ULDSCA < _DATDOC .OR. (ART_ULDSCA = _DATDOC .AND. ART_ULNSCA < _NUMDOC)
         REPLACE ART_ULDSCA WITH _DATDOC
         REPLACE ART_ULNSCA WITH _NUMDOC
         REPLACE ART_ULQSCA WITH _QUANTI
         REPLACE ART_ULPSCA WITH _PRZVEN
         REPLACE ART_TOTSCA WITH ART_TOTSCA + _QUANTI
      ENDIF
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
=MAGAMOVI(_MAGSCA,_TOPSCA)

XYZ_FORNIT = M_FORNIT			 
XYZ_RAGSOC = M_RAGSOC			 

IF EMPTY(ALLTRIM(_MAGCAR)) 
ELSE
   *==> OPERAZIONI SUL MAGAZZINO COLLEGATO
   =MAGAMOVI(_MAGCAR,_TOPCAR)
ENDIF

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

x_cond = "codice = 'TOP" + ALLTRIM(_TOP) + "'"
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

IF EMPTY(M_CLIFOR) .OR. M_CLIFOR = SPACE(10)
ELSE
   IF X_SEGNO = '+'
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
      
      IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         XYZ_NUMAGG = 0
      ENDIF
      
      IF XYZ_NUMAGG > 0
      ELSE
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
         IF X_SEGNO = '+'
            REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QUANTI
            M_QTAFOR = M_QUANTI
            M_QUANTI = 0
         ELSE
            IF MAG_GIACEN > 0
               IF MAG_GIACEN > M_QUANTI
                  REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QUANTI
                  M_QTAFOR = M_QUANTI
                  M_QUANTI = 0
               ELSE
                  M_QUANTI = M_QUANTI - MAG_GIACEN
                  M_QTAFOR = MAG_GIACEN
                  REPLACE MAG_GIACEN WITH 0
               ENDIF
            ELSE
               IF !ExecRw(cSql,"U_MAG_GG","W")
                  return(.f.)
               ENDIF
               SELECT U_FOR_PR
               SKIP +1
               LOOP
            ENDIF
         ENDIF
         M_GIAFOR = MAG_GIACEN
         IF !ExecRw(cSql,"U_MAG_GG","W")
            return(.f.)
         ENDIF
         IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         ELSE
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
            ENDIF
            REPLACE CAS_NUMAGG WITH 1
            IF !ExecRW(cSql,"U_PDV_CN","W")
               return(.f.)
            ENDIF
         ENDIF
      ENDIF
      
      *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
      IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         XYZ_NUMAGG = 1
      ENDIF
      
      IF XYZ_NUMAGG > 1
      ELSE
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
         IF RECCOUNT() <> 0
            IF X_SEGNO = '+'
               REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QTAFOR
            ELSE
               REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QTAFOR
            ENDIF
         ELSE
            APPEND BLANK
            REPLACE MAG_CODSOC WITH PUB_CODSOC
            REPLACE MAG_DATAGG WITH _DATREG
            REPLACE MAG_CODMAG WITH _MAG
            REPLACE MAG_CODART WITH _CODART
            REPLACE MAG_DESART WITH A_DESART
            REPLACE MAG_CODPDV WITH M_CODPDV
            REPLACE MAG_FORNIT WITH M_FORNIT
            REPLACE MAG_DESFOR WITH M_DESFOR
            REPLACE MAG_GIACEN WITH M_GIAFOR
         ENDIF
         IF !ExecRW(cSql,"U_MAG_GG","W")
            return(.f.)
         ENDIF
         IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         ELSE
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
            ENDIF
            REPLACE CAS_NUMAGG WITH 2
            IF !ExecRW(cSql,"U_PDV_CN","W")
               return(.f.)
            ENDIF
         ENDIF
      ENDIF

      IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         XYZ_NUMAGG = 2
      ENDIF
      
      IF XYZ_NUMAGG > 2
      ELSE
         IF _GENMOV = "SI"
            * CREA IL MOVIMENTO DI SCARICO/SCARICO MAGAZZINO ---------------------------
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
            IF !ExecRW(cSql,"U_MAG_MO","W")
               return(.f.)
            ENDIF
         ENDIF
         IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         ELSE
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
            ENDIF
            REPLACE CAS_NUMAGG WITH 3
            IF !ExecRW(cSql,"U_PDV_CN","W")
               return(.f.)
            ENDIF
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

   IF M_QUANTI = 0
   ELSE
      M_QTAFOR = M_QUANTI
      M_FORNIT = M_PRIMOF
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
      IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         XYZ_NUMAGG = 3
      ENDIF

      IF XYZ_NUMAGG > 3
      ELSE
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
         IF RECCOUNT() <> 0
            IF X_SEGNO = '+'
               REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QTAFOR
            ELSE
               REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QTAFOR
            ENDIF
         ELSE
            APPEND BLANK
            REPLACE MAG_CODSOC WITH PUB_CODSOC
            REPLACE MAG_CODMAG WITH _MAG
            REPLACE MAG_CODART WITH _CODART
            REPLACE MAG_DESART WITH A_DESART
            REPLACE MAG_CODPDV WITH M_CODPDV
            REPLACE MAG_FORNIT WITH M_FORNIT
            REPLACE MAG_DESFOR WITH M_DESFOR
            IF X_SEGNO = '+'
               REPLACE MAG_GIACEN WITH M_QTAFOR
            ELSE
               REPLACE MAG_GIACEN WITH M_QTAFOR * (-1)
            ENDIF 
         ENDIF
         M_GIAFOR = MAG_GIACEN
         IF !ExecRw(cSql,"U_MAG_GG","W")
            return(.f.)
         ENDIF
         IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         ELSE
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
            ENDIF
            REPLACE CAS_NUMAGG WITH 4
            IF !ExecRW(cSql,"U_PDV_CN","W")
               return(.f.)
            ENDIF
         ENDIF
      ENDIF
      
      *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
      IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         XYZ_NUMAGG = 4
      ENDIF

      IF XYZ_NUMAGG > 4
      ELSE
         x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
         x_data = "mag_datagg = '" + _DATREG + "'"
         x_codi = "mag_codart = '" + ALLTRIM(_CODART) + "'"
         x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
         x_forn = "mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
         x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
         Csql   = "select * from u_mag_gg where " + x_cond + " order by mag_codsoc,mag_datagg,mag_codart,mag_codmag,mag_fornit"
         IF !ExecRW(cSql,"U_MAG_GG","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_GG
         IF RECCOUNT() <> 0
            IF X_SEGNO = '+'
               REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QTAFOR
            ELSE
               REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QTAFOR
            ENDIF
         ELSE
            APPEND BLANK
            REPLACE MAG_CODSOC WITH PUB_CODSOC
            REPLACE MAG_DATAGG WITH _DATREG
            REPLACE MAG_CODMAG WITH _MAG
            REPLACE MAG_CODART WITH _CODART
            REPLACE MAG_DESART WITH A_DESART
            REPLACE MAG_CODPDV WITH M_CODPDV
            REPLACE MAG_FORNIT WITH M_FORNIT
            REPLACE MAG_DESFOR WITH M_DESFOR
            REPLACE MAG_GIACEN WITH M_GIAFOR
         ENDIF
         IF !ExecRW(cSql,"U_MAG_GG","W")
            return(.f.)
         ENDIF
         IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         ELSE
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
            ENDIF
            REPLACE CAS_NUMAGG WITH 5
            IF !ExecRW(cSql,"U_PDV_CN","W")
               return(.f.)
            ENDIF
         ENDIF
      ENDIF
      
      IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         XYZ_NUMAGG = 5
      ENDIF

      IF XYZ_NUMAGG > 5
      ELSE
         IF _GENMOV = "SI"
            * CREA IL MOVIMENTO DI SCARICO/SCARICO MAGAZZINO ---------------------------
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
            IF !ExecRW(cSql,"U_MAG_MO","W")
               return(.f.)
            ENDIF
         ENDIF
         IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
         ELSE
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
            ENDIF
            REPLACE CAS_NUMAGG WITH 6
            IF !ExecRW(cSql,"U_PDV_CN","W")
               return(.f.)
            ENDIF
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
 
   ENDIF
   M_GENMOV = "NO"
ENDIF

*-->> SCARICA/CARICA LA GIACENZA DI MAGAZZINO ----------------------------
IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
   XYZ_NUMAGG = 6
ENDIF

IF XYZ_NUMAGG > 6
ELSE
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
      IF X_SEGNO = '+'
         IF _TIPO = "GIA"	
            REPLACE MAG_GIACEN WITH MAG_GIACEN + _QUANTI
         ENDIF
      ELSE
         IF _TIPO = "GIA"
            REPLACE MAG_GIACEN WITH MAG_GIACEN - _QUANTI 
         ENDIF
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_CODMAG WITH _MAG
      REPLACE MAG_CODART WITH _CODART
      REPLACE MAG_DESART WITH A_DESART
      IF X_SEGNO = '+'
         IF _TIPO = "GIA"	
            REPLACE MAG_GIACEN WITH _QUANTI
         ENDIF
      ELSE
         IF _TIPO = "GIA"	
            REPLACE MAG_GIACEN WITH _QUANTI * (-1)
         ENDIF
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
   IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
   ELSE
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
      ENDIF
      REPLACE CAS_NUMAGG WITH 7
      IF !ExecRW(cSql,"U_PDV_CN","W")
         return(.f.)
      ENDIF
   ENDIF
ENDIF

IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
   XYZ_NUMAGG = 7
ENDIF

IF XYZ_NUMAGG > 7
ELSE
   IF M_GENMOV = "SI"
      * CREA IL MOVIMENTO DI SCARICO/SCARICO MAGAZZINO --------------------------- 
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
      IF !ExecRW(cSql,"U_MAG_MO","W")
         return(.f.)
      ENDIF
   ENDIF
   IF _DADOVE = 'INCASSODB1' .OR. _DADOVE = 'INCASSODB2'
   ELSE
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
      ENDIF
      REPLACE CAS_NUMAGG WITH 8
      IF !ExecRW(cSql,"U_PDV_CN","W")
         return(.f.)
      ENDIF
   ENDIF
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
* Funzione - TRC     Data: 18.03.97   Autore:  Project
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


************************
FUNCTION PRODISBA
************************
**--> ESPLOSIONE DI.BA. PER GESTIONE QTA SUI COMPONENTI.
**--> _PRG => INCASSODB = PRELIEVO DEI COMPONENTI + VERSAMENTO PRODOTTO FINITO
**--> _ART => CODICE ARTICOLO DA ESPLODERE
**--> _MAG => CODICE MAGAZZINO 
**--> _QTA => QUANTITA' DA GESTIRE
**--> _SAC => S = SALDO
**            C = CONTO
**            R = ROTTO
**            W = ALTRO
**--> _NUM => NUMERO DOCUMENTO
**--> _DAT => DATA DOCUMENTO
**--> _CLI => CODICE CLIENTE
**--> _PDV => CODICE PDV
**--> _IVA => CODICE IVA

PARA _PRG,_ART,_MAG,_QTA,_SAC,_NUM,_DAT,_CLI,_PDV,_IVA

SS1=STR(SELECT())

RELEASE XXX_SCARICO,V_SKIPPA,VQTAORD,VQTAMOV2,VQTAMOV3,VQTAMOV4,VQTAMOV5,VQTAMOV6,VQTAMOV7,V_QTAGIA
PUBLIC  XXX_SCARICO,V_SKIPPA,VQTAORD,VQTAMOV2,VQTAMOV3,VQTAMOV4,VQTAMOV5,VQTAMOV6,VQTAMOV7,V_QTAGIA
XXX_SCARICO = 0
V_SKIPPA    = .F.
VQTAORD     = 0
VQTAMOV2    = 0
VQTAMOV3    = 0
VQTAMOV4    = 0
VQTAMOV5    = 0
VQTAMOV6    = 0
VQTAMOV7    = 0
V_QTAGIA    = 0

IF _PRG = "INCASSODB"
   DO ALBE_QTA WITH .F.,_ART,_QTA
   SELECT WEXPLODE
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF WLIV = 1 
         H_DADOVE = 'INCASSODB1'
         H_GENMOV = 'SI' 
         H_TIPO   = 'GIA'
         H_IMPE   = ""
         H_MAGSCA = _MAG
         H_MAGCAR = ""
         H_CODART = WCOD 
         H_TOPSCA = 'CAP'
         H_TOPCAR = ""
         H_QUANTI = WQTA
         H_NUMDOC = _NUM
         H_DATDOC = _DAT
         H_DATREG = RIBALTA2(DTOC(DATE()))
         H_ORAMOV = TIME()
         H_CLIFOR = _CLI
         H_PRZACQ = 0
         H_PRZVEN = 0
         H_CODIVA = ""
         H_SCONTO = 0
         H_VALUTA = _IVA
         H_NOTE   = ""
         H_SAC    = _SAC
         H_GGG    = "SI"
         H_FORNIT = ""
         H_FLGTRA = .F.
         H_CODPDV = _PDV
         =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_SAC,H_GGG,H_FORNIT,H_FLGTRA,H_CODPDV)
         SELECT WEXPLODE
         SKIP +1
         LOOP
      ENDIF
      W_MAGA   = _MAG
      W_CODART = WCOD
      W_DESART = WDES
      W_QTAALL = WQTALL
      W_UM     = WUM
      SCATTER MEMVAR 
      IF M.WLIV = 1
         VQTAORD  = _QTA * M.WQTA  
      ENDIF   
      IF M.WLIV = 2
         VQTAORD  = _QTA * M.WQTA 
         VQTAMOV2 = VQTAORD
      ENDIF   
      IF M.WLIV = 3
         VQTAORD  = VQTAMOV2 * M.WQTA 
         VQTAMOV3 = VQTAORD
      ENDIF   
      IF M.WLIV = 4
         VQTAORD  = VQTAMOV3 * M.WQTA 
         VQTAMOV4 = VQTAORD
      ENDIF   
      IF M.WLIV = 5
         VQTAORD  = VQTAMOV4 * M.WQTA 
         VQTAMOV5 = VQTAORD
      ENDIF   
      IF M.WLIV = 6
         VQTAORD  = VQTAMOV5 * M.WQTA 
         VQTAMOV6 = VQTAORD
      ENDIF   
      IF M.WLIV = 7
         VQTAORD  = VQTAMOV6 * M.WQTA 
         VQTAMOV7 = VQTAORD
      ENDIF   
      IF M.WLIV = 8
         VQTAORD  = VQTAMOV7 * M.WQTA 
      ENDIF   

      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(W_MAGA) + "'"
      x_codi = "mag_codart = '" + ALLTRIM(M.WCOD) + "'"
      x_cond = x_soci + " and " + x_maga + " and " + x_codi
      Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
      IF !ExecCommand(cSql,"U_MAG_AN")
         return(.f.)
      ENDIF
      SELECT U_MAG_AN
      IF RECCOUNT() <> 0
         V_QTAGIA = MAG_GIACEN
      ELSE
         V_QTAGIA = 0
      ENDIF
      V_SKIPPA = .F.
      IF M.WTIP = 'G'
         IF VQTAORD > V_QTAGIA
            XXX_SCARICO = V_QTAGIA
         ELSE
            XXX_SCARICO = VQTAORD
            V_SKIPPA = .T.
         ENDIF
         IF XXX_SCARICO > 0
            IF M.WLIV = 2
               VQTAMOV2 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 3
               VQTAMOV3 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 4
               VQTAMOV4 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 5
               VQTAMOV5 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 6
               VQTAMOV6 = VQTAORD - XXX_SCARICO
            ENDIF   
            IF M.WLIV = 7
               VQTAMOV7 = VQTAORD - XXX_SCARICO
            ENDIF
         ENDIF   
      ELSE
         XXX_SCARICO = VQTAORD
      ENDIF
      IF XXX_SCARICO = 0
      ELSE
         H_DADOVE = 'INCASSODB2'
         H_GENMOV = 'SI' 
         H_TIPO   = 'GIA'
         H_IMPE   = ""
         H_MAGSCA = W_MAGA
         H_MAGCAR = ""
         H_CODART = W_CODART
         H_TOPSCA = 'SCP'
         H_TOPCAR = ""
         H_QUANTI = XXX_SCARICO
         H_NUMDOC = _NUM
         H_DATDOC = _DAT
         H_DATREG = RIBALTA2(DTOC(DATE()))
         H_ORAMOV = TIME()
         H_CLIFOR = _CLI
         H_PRZACQ = 0
         H_PRZVEN = 0
         H_CODIVA = ""
         H_SCONTO = 0
         H_VALUTA = ""
         H_NOTE   = ""
         H_SAC    = _SAC
         H_GGG    = "SI"
         H_FORNIT = ""
         H_FLGTRA = .F.
         H_CODPDV = _PDV
         =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_SAC,H_GGG,H_FORNIT,H_FLGTRA,H_CODPDV)
         SELECT WEXPLODE
      ENDIF
      IF V_SKIPPA
         V_SKIPPA = .F.
         SELECT WEXPLODE
         SKIP +1
         IF EOF()
            EXIT
         ENDIF
         DO WHILE .T.
            IF EOF()
               SKIP -1
               EXIT
            ENDIF
            IF WLIV > M.WLIV
            ELSE
               SKIP -1
               EXIT
            ENDIF
            SELECT WEXPLODE
            SKIP +1
         ENDDO
      ENDIF            
      SELECT WEXPLODE
      SKIP +1 
   ENDDO
ENDIF      

OUT = .T.

SELECT &SS1

RETURN(OUT)


***************************************************************************
PROCEDURE ALBE_QTA
***************************************************************************

PARA SI_VIDEO,XXGRUPPO,XXQTA,LIV_ESPL

PUBLIC LIV_ESPLN
LIV_ESPLN = 0

PUBLIC XX_QTA1,XX_QTA2,XX_QTA3,XX_QTA4,XX_QTA5,XX_QTA6,XX_QTA7
XX_QTA1 = 0
XX_QTA2 = 0
XX_QTA3 = 0
XX_QTA4 = 0
XX_QTA5 = 0
XX_QTA6 = 0
XX_QTA7 = 0

IF LIV_ESPL = .F.
   x_cond = "codice = 'NUMLDBLIV'" 
   Csql   = "select * from para where " + x_cond + " order by codice"
   IF !ExecCommand(cSql,"PARA")
      return(.f.)
   ENDIF
   SELECT PARA
   GO TOP
   IF !EOF()
      LIV_ESPLN = VAL(SUBSTR(LIBERA,1,2))
      IF LIV_ESPLN > 98
         LIV_ESPLN = 98
      ENDIF         
   ELSE
      LIV_ESPLN = 98
   ENDIF
ELSE
   LIV_ESPLN = 98
ENDIF
IF LIV_ESPLN < 1
   LIV_ESPLN = 98
ENDIF         
LIV_ESPLN = LIV_ESPLN + 1

CREATE CURSOR WEXPLODE (WCOD C(30), WDES C(40), WCOS N(17,6), WPRZ N(17,6), ;
                        WTIP C(1),  WLIV N(4) , WQTA N(11,2), TREE C(100),  ;
                        WEXP C(1),  WQTALL N(11,2), WUM C(03))

x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
x_codi = "dit_gruppo = '" + ALLTRIM(XXGRUPPO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
IF !ExecCommand(cSql,"cur_diba")
   return(.f.)
ENDIF
SELECT cur_diba
GO TOP
IF EOF()
   RETURN
ENDIF

V_CODART=DIT_GRUPPO
V_DESCRI=DIT_DESCRI
V_COSTO =DIT_COSTO
V_PREZZO=DIT_PREZZO
V_UM    =DIT_UM

CNT=1
XX_QTA1 = XXQTA
XX_QTA  = XX_QTA1

SELECT WEXPLODE
APPEND BLANK
REPLACE WCOD   WITH V_CODART
REPLACE WDES   WITH V_DESCRI
REPLACE WCOS   WITH V_COSTO
REPLACE WPRZ   WITH V_PREZZO
REPLACE WTIP   WITH "T"
REPLACE WLIV   WITH CNT
REPLACE WQTA   WITH 1
REPLACE TREE   WITH V_CODART
REPLACE WQTALL WITH 0
REPLACE WUM    WITH V_UM

DO TROVA_QTA WITH XXGRUPPO

SELECT WEXPLODE
PUN = RECCOUNT()
K   = SPACE(0)

SELECT WEXPLODE
GO TOP
DELETE FOR WLIV > LIV_ESPLN ALL
GO TOP

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF WLIV = 1
      XX_QTA  = WQTA * XXQTA
      XX_QTA1 = XX_QTA
   ENDIF
   IF WLIV = 2
      XX_QTA  = WQTA * XX_QTA1
      XX_QTA2 = XX_QTA
   ENDIF
   IF WLIV = 3
      XX_QTA  = WQTA * XX_QTA2
      XX_QTA3 = XX_QTA
   ENDIF
   IF WLIV = 4
      XX_QTA  = WQTA * XX_QTA3
      XX_QTA4 = XX_QTA
   ENDIF
   IF WLIV = 5
      XX_QTA  = WQTA * XX_QTA4
      XX_QTA5 = XX_QTA
   ENDIF
   IF WLIV = 6
      XX_QTA  = WQTA * XX_QTA5
      XX_QTA6 = XX_QTA
   ENDIF
   IF WLIV = 7
      XX_QTA  = WQTA * XX_QTA6
      XX_QTA7 = XX_QTA
   ENDIF
   REPLACE WQTALL WITH XX_QTA
   SELECT WEXPLODE
   SKIP +1
ENDDO

SELECT WEXPLODE
GO TOP

IF SI_VIDEO
   V_TIT="ESPLOSIONE GRUPPO - "+XXGRUPPO
   V_TES="ALBERO:TREE:32;Q.TA X 1:WQTA:9;Q.TA X N:WQTALL:13;DESCRIZIONE:WDES:25;PREZZO:WPRZ:10;COSTO:WCOS:10;TIPO:WTIP:1"
   =WSHOWDBF("WEXPLODE",V_TIT,V_TES)
ENDIF

RETURN


************************************************************************
PROCEDURE TROVA_QTA
************************************************************************
PARAMETERS CODE
PRIVATE CODE,REK,GRU

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_DD")
   return(.f.)
ENDIF

SELECT U_DIS_DD
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_DD
   
   IF DIS_TIPO=='G'
      REK = RECNO()
      GRU = CODE
      =TROVA_QTA1(DIS_CODART)
      SELECT U_DIS_DD
      *GOTO REK
      CODE = GRU
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA1
************************************************************************
PARAMETERS CODE1
PRIVATE CODE1,REK1,GRU1

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE1) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D1")
   return(.f.)
ENDIF

SELECT U_DIS_D1
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D1
   
   IF DIS_TIPO=='G'
      REK1 = RECNO()
      GRU1 = CODE
      =TROVA_QTA2(DIS_CODART)
      SELECT U_DIS_D1
      *GOTO REK1
      CODE=GRU1
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA2
************************************************************************
PARAMETERS CODE2
PRIVATE CODE2,REK2,GRU2

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE2) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D2")
   return(.f.)
ENDIF

SELECT U_DIS_D2
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D2
   
   IF DIS_TIPO=='G'
      REK2 = RECNO()
      GRU2 = CODE
      =TROVA_QTA3(DIS_CODART)
      SELECT U_DIS_D2
      *GOTO REK2
      CODE=GRU2
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA3
************************************************************************
PARAMETERS CODE3
PRIVATE CODE3,REK3,GRU3

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE3) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D3")
   return(.f.)
ENDIF

SELECT U_DIS_D3
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D3
   
   IF DIS_TIPO=='G'
      REK3 = RECNO()
      GRU3 = CODE
      =TROVA_QTA4(DIS_CODART)
      SELECT U_DIS_D3
      *GOTO REK3
      CODE=GRU3
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA4
************************************************************************
PARAMETERS CODE4
PRIVATE CODE4,REK4,GRU4

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE4) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D4")
   return(.f.)
ENDIF

SELECT U_DIS_D4
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D4
   
   IF DIS_TIPO=='G'
      REK4 = RECNO()
      GRU4 = CODE
      =TROVA_QTA5(DIS_CODART)
      SELECT U_DIS_D4
      *GOTO REK4
      CODE=GRU4
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA5
************************************************************************
PARAMETERS CODE5
PRIVATE CODE5,REK5,GRU5

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE5) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D5")
   return(.f.)
ENDIF

SELECT U_DIS_D5
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D5
   
   IF DIS_TIPO=='G'
      REK5 = RECNO()
      GRU5 = CODE
      =TROVA_QTA6(DIS_CODART)
      SELECT U_DIS_D5
      *GOTO REK5
      CODE=GRU5
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA6
************************************************************************
PARAMETERS CODE6
PRIVATE CODE6,REK6,GRU6

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE6) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D6")
   return(.f.)
ENDIF

SELECT U_DIS_D6
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D6
   
   IF DIS_TIPO=='G'
      REK6 = RECNO()
      GRU6 = CODE
      =TROVA_QTA7(DIS_CODART)
      SELECT U_DIS_D6
      *GOTO REK6
      CODE = GRU6
   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN


************************************************************************
PROCEDURE TROVA_QTA7
************************************************************************
PARAMETERS CODE7
PRIVATE CODE7,REK7,GRU7

CNT = CNT + 1

x_codi = "dis_gruppo = '" + ALLTRIM(CODE7) + "'"
cSql   = "SELECT * FROM u_dis_dd WHERE " + x_codi + " order by dis_gruppo,dis_sequen"
IF !ExecCommand(cSql,"U_DIS_D7")
   return(.f.)
ENDIF

SELECT U_DIS_D7
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
  
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   V_CODART = DIS_CODART
   V_TIPO   = DIS_TIPO
   V_DESCRI = DIS_DESCRI
   V_COSTO  = DIS_COSTO
   V_PREZZO = DIS_PREZZO
   V_QTA    = DIS_QTA
   V_EXP    = DIS_ESPLOD
   V_QTALL  = 0 
   V_UM     = DIS_UM    
     
   SELECT WEXPLODE
   APPEND BLANK
   REPLACE WCOD   WITH V_CODART
   REPLACE WDES   WITH V_DESCRI
   REPLACE WCOS   WITH V_COSTO
   REPLACE WPRZ   WITH V_PREZZO
   REPLACE WTIP   WITH V_TIPO
   REPLACE WLIV   WITH CNT
   REPLACE WQTA   WITH V_QTA
   V_XTREE = REPLICATE('-',WLIV)
   REPLACE TREE   WITH V_XTREE + SPACE(WLIV) + WCOD
   REPLACE WQTALL WITH 0
   REPLACE WUM    WITH V_UM
      
   SELECT U_DIS_D7
   
*   IF DIS_TIPO=='G'
*      REK7 = RECNO()
*      GRU7 = CODE
*      =TROVA_QTA8(DIS_CODART)
*      SELECT U_DIS_D7
*      GOTO REK7
*      CODE=GRU7
*   ENDIF
      
   SKIP +1
  
ENDDO

CNT=CNT-1

RETURN

**********************************************************************
* Funzione - WSHOWDBF   Data: 01.10.94   Autore: Project
**********************************************************************
* Questa funzione permette di fare una query SQL su di unn database e
* mostrare il risultato in una finestra browse. Equivale alla vecchia
* SHOWDBF delle nostre applicazioni CLIPPER, la sintassi è la seguente:
*
*  WSHOWDBF(<Exp>,<ExpC1>,<ExpC2>[,<ExpC3>[,<ExpC4>]])
*  Exp   = Può essere Numerico o carattere ed è la SELECT in cui è aperto
*          il database Origine.
*  ExpC1 = E' un'espressione carattere contenente il titolo da porre
*          sulla finestra di OutPut
*  ExpC2 = E' un'espressione carettre contenente l'elenco dei campi
*          da visualizzare nella browse, la stringa ha il seguente formato.
*          "Descrizione campo1:NomeCampo1:Lunghezza1;Descrizione Campo2 ..."
*  ExpC3 = E' un'espressione carattere facoltativa contenente la condizione
*          da validare su ogni record della query.
*          (E' la clausola WHERE di SELECT SQL)
*  ExpC4 = E' un'espressione carattere facolativa contenente l'ordinamento
*          dei dati nella query. Ha il seguente formato.
*          "Nomecampo1 [ASC|DESC] ,Nomecampo2 [ASC|DESC]"
*          - Specificare ASC o nullo per un ordine crescente
*          - Specificare DESC per un ordine decrescente
*          (E' la clausola ORDER BY di Select SQL)
*  Nella finestra di Browse è possibile selezionare un record con il
*  tasto sinistro del mouse e confermare con il tasto destro, è anche
*  possibile annullare chiudendo la finestra (vedi sotto).
*  Con i tasti e possibile muoversi all'interno della finestra, ENTER
*  conferma un record ESC annulla la selezione.
*
*  A seguito di una conferma verrà ritornato il N° di record selezionato.
*  A seguito di un annullo verrà ritornato il valore 0.
*
*  Esempio Query sul database parametri.
*
*  TITOLO="TITOLI DI STUDIO"
*  CAMPI ="Codice Titolo:SUBSTR(CODICE,4):15;Descrizione:DESCRI:25"
*  FILTRO="SUBSTR(CODICE,1,3)=='TIT'"
*  ORDINE="CODICE,DESCRI DESC"
*  ? WSHOWDBF("PARA",TITOLO,CAMPI,FILTRO,ORDINE)
*
**********************************************************************
FUNCTION WSHOWDBF
******************

PARA _SELECT,_TITOLO,_CAMPI,_CONDIZIONI,_ORDINE

IF PARAMETERS() < 3
   =MESSAGEBOX("WSHOWDBF: Parametri Insufficienti, ne occorrono almeno 3 !",16,"ERRORE !")
   RETURN
ENDIF

_CONDIZIONI = IIF(PARAMETERS()<4 OR LEN(_CONDIZIONI)=0,".T.",_CONDIZIONI)
_ORDINE     = IIF(PARAMETERS()<5,"",_ORDINE)
_OLDSELECT  = SELECT()

SELECT(_SELECT)
PRIVATE _PUNCAM,_NUMFLD,_TEMP,_QCAMPI,_RETVAL,_MAXALT,_MAXLAR,_ERR

_NUMFLD=OCCURS(";",_CAMPI)+1

DECLARE _ACAMPO[_NUMFLD],_ALUNGO[_NUMFLD],_ADESCR[_NUMFLD]

FOR _PUNCAM=1 TO _NUMFLD
    _TEMP=STR_EXTRACT(_CAMPI,";",_PUNCAM)
    _ADESCR[_PUNCAM]=STR_EXTRACT(_TEMP,":",1)
    IF EMPTY(_ADESCR[_PUNCAM])
       _ERR="O manca una descrizione nell'elenco campi,"+CHR(13)+;
       "oppure hai messo un punto e virgola in "+CHR(13)+"più alla fine "+;
       "della stringa campi ! Posizione: "+ALLTRIM(STR(_PUNCAM))
       =MESSAGEBOX(_ERR,16,"ERRORE - WSHOWDBF")
       RETURN
    ENDIF
    _ACAMPO[_PUNCAM]=STR_EXTRACT(_TEMP,":",2)
    IF EMPTY(_ACAMPO[_PUNCAM])
       _ERR="Manca un campo nell'elenco alla posizione: "+ALLTRIM(STR(_PUNCAM))
       =MESSAGEBOX(_ERR,16,"ERRORE - WSHOWDBF")
       RETURN
    ENDIF
    _ALUNGO[_PUNCAM]=STR_EXTRACT(_TEMP,":",3)
    IF EMPTY(_ALUNGO[_PUNCAM])
       _ERR="Manca una lunghezza nell'elenco alla posizione: "+ALLTRIM(STR(_PUNCAM))
       =MESSAGEBOX(_ERR,16,"ERRORE - WSHOWDBF")
       RETURN
    ENDIF
NEXT

_QCAMPI=""
FOR _PUNCAM=1 TO _NUMFLD
    _QCAMPI=_QCAMPI+_ACAMPO[_PUNCAM]+","
NEXT

_QCAMPI=SUBSTR(_QCAMPI,1,LEN(_QCAMPI)-1)
_CONDIZIONI=" WHERE "+_CONDIZIONI

IF LEN(_ORDINE)>0
   _CONDIZIONI=_CONDIZIONI+" ORDER BY "+_ORDINE
ENDIF

RELEASE N_REC   
PUBLIC  N_REC   

SET TALK WINDOW
SET TALK ON

SELECT *, RECNO() AS N_REC;
  FROM ALIAS(_SELECT) &_CONDIZIONI;
  INTO CURSOR WSHOWDBF

SET TALK OFF
_MAXALT = 0
_MAXLAR = 0
_QCAMPI = ""

FOR _PUNCAM=1 TO _NUMFLD
    _MAXLAR=_MAXLAR+VAL(_ALUNGO[_PUNCAM])
    _QNTMP=ALLTRIM(STR(_PUNCAM))
    _QCAMPI=_QCAMPI+"M"+_QNTMP+"="+_ACAMPO[_PUNCAM]+":";
            +_ALUNGO[_PUNCAM]+":H=["+_ADESCR[_PUNCAM]+"],"
NEXT

_QCAMPI = SUBSTR(_QCAMPI,1,LEN(_QCAMPI)-1)
_MAXLAR = _MAXLAR+3+_NUMFLD
_MAXALT = _MAXLAR*.33

IF _MAXLAR > 85
   _MAXLAR = 85
ENDIF

IF _MAXALT > 25
   _MAXALT = 25
ENDIF

DEFINE WINDOW WSHOWDBF;
   AT  0,0;
   SIZE _MAXALT,_MAXLAR;
   FONT "Courier New",8 HALFHEIGHT;
   FLOAT GROW zoom SYSTEM CLOSE TITLE _TITOLO

MOVE WINDOW WSHOWDBF CENTER
ON KEY LABEL ENTER KEYBOARD CHR(23)
ON KEY LABEL RIGHTMOUSE KEYBOARD "{ENTER}"

BROWSE WINDOW WSHOWDBF;
   FIELDS &_QCAMPI;
   NOAPPEND NODELETE;
   NOEDIT NOMENU REST;
   COLOR ,,,,,,N/R*;
   NORGRID NOLGRID

RELEASE WINDOW WSHOWDBF
ON KEY LABEL ENTER
ON KEY LABEL RIGHTMOUSE

IF LASTKEY()=23
  _RETVAL = N_REC
ELSE
  _RETVAL = 0
ENDIF

SELECT(_OLDSELECT)
RETURN(_RETVAL)



