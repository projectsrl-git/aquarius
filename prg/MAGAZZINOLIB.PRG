

*!*	##############################################################################################################

					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE APPLICAZIONI DEL MAGAZZINO                        ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################

****************************
PROCEDURE GESTIONE_FORN_SING		&& GESTIONE SECONDO UNO SPECIFICO FORNITORE
****************************

RETURN


****************************
PROCEDURE GESTIONE_FORN_PREF		&& GESTIONE SECONDO IL FORNITORE PREFERENZIALE
****************************

RELEASE M_CODACQ
PUBLIC  M_CODACQ
M_CODACQ = SPACE(03)

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

M_PRIMOF = SPACE(10)

IF EMPTY(_FORNIT) .OR. _FORNIT = SPACE(10)
   x_soci   = "fpr_codsoc = '" + PUB_CODSOC + "'"
   x_maga   = "fpr_codmag = '" + ALLTRIM(_MAG) + "'"
   x_codi   = "fpr_codart = '" + ALLTRIM(_CODART) + "'"
   x_cond   = x_soci + " and " + x_maga + " and " + x_codi 
   Csql     = "select * from u_for_pr where " + x_cond + " order by fpr_seqpri"
ELSE
   x_soci   = "fpr_codsoc = '" + PUB_CODSOC + "'"
   x_maga   = "fpr_codmag = '" + ALLTRIM(_MAG) + "'"
   x_codi   = "fpr_codart = '" + ALLTRIM(_CODART) + "'"
   x_forn   = "fpr_codfor = '" + ALLTRIM(_FORNIT) + "'"
   x_cond   = x_soci + " and " + x_maga + " and " + x_codi + " and " + x_forn
   Csql     = "select * from u_for_pr where " + x_cond + " order by fpr_codsoc,fpr_codart,fpr_codfor,fpr_seqpri"
ENDIF

IF !ExecCommand(cSql,"U_FOR_PR")
   return(.f.)
ENDIF
SELECT U_FOR_PR
GO TOP
IF EOF()
   M_PRIMOF = SPACE(10)
ELSE
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

   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO

   x_soci = "u_mag_gg.mag_codsoc = '" + PUB_CODSOC + "'"
   x_data = "u_mag_gg.mag_datagg <> '" + SPACE(10) + "'"
   x_codi = "u_mag_gg.mag_codart = '" + ALLTRIM(_CODART) + "'"
   x_maga = "u_mag_gg.mag_codmag = '" + ALLTRIM(_MAG) + "'"
   x_forn = "u_mag_gg.mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
   x_giac = "u_mag_gg.mag_giacen > 0"
   x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
            x_forn + " and " + x_giac

   x_oggi = ribalta2(DTOC(DATE()))
   Csql_1 = "select top 10 case when u_mag_cp.mag_datini <= '" + x_oggi + "' and u_mag_cp.mag_datfin >= '" + x_oggi + "'"
   Csql_2 = " then u_mag_cp.mag_przsco else u_mag_gg.mag_przcon end as mag_przuff, *"
   Csql_3 = " from u_mag_gg left outer join u_mag_cp on"
   Csql_4 = " u_mag_gg.mag_codsoc=u_mag_cp.mag_codsoc and u_mag_gg.mag_codmag=u_mag_cp.mag_codmag and"  
   Csql_5 = " u_mag_gg.mag_codart=u_mag_cp.mag_codart and u_mag_gg.mag_fornit=u_mag_cp.mag_fornit and" 
   Csql_6 = " u_mag_gg.mag_codacq=u_mag_cp.mag_codacq and u_mag_gg.mag_numide=u_mag_cp.mag_numide and"
   Csql_7 = " u_mag_gg.mag_codbun=u_mag_cp.mag_codbun and u_mag_gg.mag_anno=u_mag_cp.mag_anno and"  
   Csql_8 = " u_mag_gg.mag_datagg=u_mag_cp.mag_datagg and u_mag_gg.mag_przcon=u_mag_cp.mag_przcon" 
   Csql_9 = " where " + x_cond
   Csql   = Csql_1 + Csql_2 + Csql_3 + Csql_4 + Csql_5 + Csql_6 + Csql_7 + Csql_8 + Csql_9 
   
   x_Csql = trovsele(Csql,.F.)

   IF !ExecCommand(x_Csql,"CUR_MAG_GG")
      return(.f.)
   ENDIF
   SELECT CUR_MAG_GG
   IF RECCOUNT() = 0
      SELECT U_FOR_PR
      SKIP +1
      LOOP
   ENDIF

   GO TOP

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      IF M_QUANTI < 1
         EXIT
      ENDIF

      _DATREG  = MAG_DATAGG     
      _PRZACQ  = MAG_PRZCON       
      M_FORNIT = MAG_FORNIT
      M_DESFOR = MAG_DESFOR
      M_CODACQ = MAG_CODACQ

      PUB_FILA_X = MAG_FILA_X
      PUB_PIAN_X = MAG_PIAN_X
      PUB_UBIC_X = MAG_UBIC_X
      PUB_FILA_N = MAG_FILA_N
      PUB_PIAN_N = MAG_PIAN_N
      PUB_UBIC_N = MAG_UBIC_N

      PUB_NUMCAM = MAG_NUMCAM1
      PUB_DATCAM = MAG_DATCAM1
      PUB_INICAM = MAG_DATINI1
      PUB_FINCAM = MAG_DATFIN1
      PUB_SC1CAM = MAG_SC11
      PUB_SC2CAM = MAG_SC21
      PUB_SC3CAM = MAG_SC31
      PUB_SC4CAM = MAG_SC41
      PUB_SC5CAM = MAG_SC51
      PUB_FISCAM = MAG_PRZFIS1
      PUB_PRZCAM = MAG_PRZSCO1
      
      IF ISNULL(PUB_NUMCAM)
         PUB_NUMCAM = SPACE(06)
      ENDIF
      IF ISNULL(PUB_DATCAM)
         PUB_DATCAM = SPACE(10)
      ENDIF
      IF ISNULL(PUB_INICAM) 
         PUB_INICAM = SPACE(10)
      ENDIF
      IF ISNULL(PUB_FINCAM) 
         PUB_FINCAM = SPACE(10)
      ENDIF
      IF ISNULL(PUB_SC1CAM) 
         PUB_SC1CAM = 0
      ENDIF
      IF ISNULL(PUB_SC2CAM) 
         PUB_SC2CAM = 0
      ENDIF
      IF ISNULL(PUB_SC3CAM) 
         PUB_SC3CAM = 0
      ENDIF
      IF ISNULL(PUB_SC4CAM) 
         PUB_SC4CAM = 0
      ENDIF
      IF ISNULL(PUB_SC5CAM) 
         PUB_SC5CAM = 0
      ENDIF
      IF ISNULL(PUB_FISCAM)
         PUB_FISCAM = 0
      ENDIF
      IF ISNULL(PUB_PRZCAM) 
         PUB_PRZCAM = 0
      ENDIF
      
      DO MAGAZZINO_GG WITH 'SIDATA'

      SELECT CUR_MAG_GG
      SKIP +1

   ENDDO
            
   IF M_QUANTI = 0
      EXIT
   ENDIF

   SELECT U_FOR_PR
   SKIP +1

ENDDO

IF M_QUANTI = 0
ELSE
   M_QTAFOR = M_QUANTI
   M_FORNIT = SPACE(10)
   M_DESFOR = SPACE(40)
   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci = "u_mag_gg.mag_codsoc = '" + PUB_CODSOC + "'"
   x_data = "u_mag_gg.mag_datagg <> '" + SPACE(10) + "'"
   x_codi = "u_mag_gg.mag_codart = '" + ALLTRIM(_CODART) + "'"
   x_maga = "u_mag_gg.mag_codmag = '" + ALLTRIM(_MAG) + "'"
   x_forn = "u_mag_gg.mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
   x_giac = "u_mag_gg.mag_giacen > 0"
   x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
            x_forn + " and " + x_giac

   x_oggi = ribalta2(DTOC(DATE()))
   Csql_1 = "select top 10 case when u_mag_cp.mag_datini <= '" + x_oggi + "' and u_mag_cp.mag_datfin >= '" + x_oggi + "'"
   Csql_2 = " then u_mag_cp.mag_przsco else u_mag_gg.mag_przcon end as mag_przuff, *"
   Csql_3 = " from u_mag_gg left outer join u_mag_cp on"
   Csql_4 = " u_mag_gg.mag_codsoc=u_mag_cp.mag_codsoc and u_mag_gg.mag_codmag=u_mag_cp.mag_codmag and"  
   Csql_5 = " u_mag_gg.mag_codart=u_mag_cp.mag_codart and u_mag_gg.mag_fornit=u_mag_cp.mag_fornit and" 
   Csql_6 = " u_mag_gg.mag_codacq=u_mag_cp.mag_codacq and u_mag_gg.mag_numide=u_mag_cp.mag_numide and"
   Csql_7 = " u_mag_gg.mag_codbun=u_mag_cp.mag_codbun and u_mag_gg.mag_anno=u_mag_cp.mag_anno and"  
   Csql_8 = " u_mag_gg.mag_datagg=u_mag_cp.mag_datagg and u_mag_gg.mag_przcon=u_mag_cp.mag_przcon" 
   Csql_9 = " where " + x_cond
   Csql   = Csql_1 + Csql_2 + Csql_3 + Csql_4 + Csql_5 + Csql_6 + Csql_7 + Csql_8 + Csql_9 
   
   x_Csql = trovsele(Csql,.F.)

   IF !ExecCommand(x_Csql,"CUR_MAG_GG")
      return(.f.)
   ENDIF
   SELECT CUR_MAG_GG
   IF RECCOUNT() = 0
      PUB_FILA_X = SPACE(05)
      PUB_PIAN_X = SPACE(05)
      PUB_UBIC_X = SPACE(05)
      PUB_FILA_N = 0
      PUB_PIAN_N = 0
      PUB_UBIC_N = 0
      DO MAGAZZINO_GG WITH 'NODATA'
   ELSE
      SELECT CUR_MAG_GG
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF M_QUANTI < 1
            EXIT
         ENDIF
         PUB_FILA_X = MAG_FILA_X
         PUB_PIAN_X = MAG_PIAN_X
         PUB_UBIC_X = MAG_UBIC_X
         PUB_FILA_N = MAG_FILA_N
         PUB_PIAN_N = MAG_PIAN_N
         PUB_UBIC_N = MAG_UBIC_N
         _DATREG    = MAG_DATAGG     
         _PRZACQ    = MAG_PRZCON       
         M_FORNIT   = MAG_FORNIT
         M_DESFOR   = MAG_DESFOR
         M_CODACQ   = MAG_CODACQ
         PUB_NUMCAM = MAG_NUMCAM1
         PUB_DATCAM = MAG_DATCAM1
         PUB_INICAM = MAG_DATINI1
         PUB_FINCAM = MAG_DATFIN1
         PUB_SC1CAM = MAG_SC11
         PUB_SC2CAM = MAG_SC21
         PUB_SC3CAM = MAG_SC31
         PUB_SC4CAM = MAG_SC41
         PUB_SC5CAM = MAG_SC51
         PUB_FISCAM = MAG_PRZFIS1
         PUB_PRZCAM = MAG_PRZSCO1
         IF ISNULL(PUB_NUMCAM)
            PUB_NUMCAM = SPACE(06)
         ENDIF
         IF ISNULL(PUB_DATCAM) 
            PUB_DATCAM = SPACE(10)
         ENDIF
         IF ISNULL(PUB_INICAM) 
            PUB_INICAM = SPACE(10)
         ENDIF
         IF ISNULL(PUB_FINCAM) 
            PUB_FINCAM = SPACE(10)
         ENDIF
         IF ISNULL(PUB_SC1CAM)
            PUB_SC1CAM = 0
         ENDIF
         IF ISNULL(PUB_SC2CAM)
            PUB_SC2CAM = 0
         ENDIF
         IF ISNULL(PUB_SC3CAM)
            PUB_SC3CAM = 0
         ENDIF
         IF ISNULL(PUB_SC4CAM) 
            PUB_SC4CAM = 0
         ENDIF
         IF ISNULL(PUB_SC5CAM)
            PUB_SC5CAM = 0
         ENDIF
         IF ISNULL(PUB_FISCAM)
            PUB_FISCAM = 0
         ENDIF
         IF ISNULL(PUB_PRZCAM)
            PUB_PRZCAM = 0
         ENDIF
         DO MAGAZZINO_GG WITH 'SIDATA'
         SELECT CUR_MAG_GG          
         SKIP +1
         LOOP
      ENDDO
      IF M_QUANTI = 0
      ELSE
         M_QTAFOR = M_QUANTI
         M_FORNIT = SPACE(10)
         M_DESFOR = SPACE(40)
         M_CODACQ = SPACE(03)
         DO MAGAZZINO_GG WITH 'NSDATA'
      ENDIF
   ENDIF
ENDIF

RETURN


******************************
PROCEDURE GESTIONE_NOFORN_PREF		&& GESTIONE NON TENENDO PRESENTE IL FORNITORE PREFERENZIALE
******************************

RELEASE M_CODACQ
PUBLIC  M_CODACQ
M_CODACQ = SPACE(03)

M_PRIMOF = SPACE(10)
M_QUANTI = _QUANTI
M_DESFOR = ""

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

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO

x_soci = "u_mag_gg.mag_codsoc = '" + PUB_CODSOC + "'"
x_data = "u_mag_gg.mag_datagg <> '" + SPACE(10) + "'"
x_codi = "u_mag_gg.mag_codart = '" + ALLTRIM(_CODART) + "'"
x_maga = "u_mag_gg.mag_codmag = '" + ALLTRIM(_MAG) + "'"
x_giac = "u_mag_gg.mag_giacen > 0"
x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_giac

x_oggi = ribalta2(DTOC(DATE()))
Csql_1 = "select top 10 case when u_mag_cp.mag_datini <= '" + x_oggi + "' and u_mag_cp.mag_datfin >= '" + x_oggi + "'"
Csql_2 = " then u_mag_cp.mag_przsco else u_mag_gg.mag_przcon end as mag_przuff, *"
Csql_3 = " from u_mag_gg left outer join u_mag_cp on"
Csql_4 = " u_mag_gg.mag_codsoc=u_mag_cp.mag_codsoc and u_mag_gg.mag_codmag=u_mag_cp.mag_codmag and"  
Csql_5 = " u_mag_gg.mag_codart=u_mag_cp.mag_codart and u_mag_gg.mag_fornit=u_mag_cp.mag_fornit and" 
Csql_6 = " u_mag_gg.mag_codacq=u_mag_cp.mag_codacq and u_mag_gg.mag_numide=u_mag_cp.mag_numide and"
Csql_7 = " u_mag_gg.mag_codbun=u_mag_cp.mag_codbun and u_mag_gg.mag_anno=u_mag_cp.mag_anno and"  
Csql_8 = " u_mag_gg.mag_datagg=u_mag_cp.mag_datagg and u_mag_gg.mag_przcon=u_mag_cp.mag_przcon" 
Csql_9 = " where " + x_cond
Csql   = Csql_1 + Csql_2 + Csql_3 + Csql_4 + Csql_5 + Csql_6 + Csql_7 + Csql_8 + Csql_9 
   
x_Csql = trovsele(Csql,.F.)

IF !ExecCommand(x_Csql,"CUR_MAG_GG")
   return(.f.)
ENDIF
SELECT CUR_MAG_GG
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF M_QUANTI < 1
      EXIT
   ENDIF

   _DATREG  = MAG_DATAGG     
   _PRZACQ  = MAG_PRZCON       
   M_FORNIT = MAG_FORNIT
   M_DESFOR = MAG_DESFOR
   M_CODACQ = MAG_CODACQ

   PUB_FILA_X = MAG_FILA_X
   PUB_PIAN_X = MAG_PIAN_X
   PUB_UBIC_X = MAG_UBIC_X
   PUB_FILA_N = MAG_FILA_N
   PUB_PIAN_N = MAG_PIAN_N
   PUB_UBIC_N = MAG_UBIC_N

   PUB_NUMCAM = MAG_NUMCAM1
   PUB_DATCAM = MAG_DATCAM1
   PUB_INICAM = MAG_DATINI1
   PUB_FINCAM = MAG_DATFIN1
   PUB_SC1CAM = MAG_SC11
   PUB_SC2CAM = MAG_SC21
   PUB_SC3CAM = MAG_SC31
   PUB_SC4CAM = MAG_SC41
   PUB_SC5CAM = MAG_SC51
   PUB_FISCAM = MAG_PRZFIS1
   PUB_PRZCAM = MAG_PRZSCO1

   IF ISNULL(PUB_NUMCAM)
      PUB_NUMCAM = SPACE(06)
   ENDIF
   IF ISNULL(PUB_DATCAM) 
      PUB_DATCAM = SPACE(10)
   ENDIF
   IF ISNULL(PUB_INICAM) 
      PUB_INICAM = SPACE(10)
   ENDIF
   IF ISNULL(PUB_FINCAM) 
      PUB_FINCAM = SPACE(10)
   ENDIF
   IF ISNULL(PUB_SC1CAM)
      PUB_SC1CAM = 0
   ENDIF
   IF ISNULL(PUB_SC2CAM)
      PUB_SC2CAM = 0
   ENDIF
   IF ISNULL(PUB_SC3CAM) 
      PUB_SC3CAM = 0
   ENDIF
   IF ISNULL(PUB_SC4CAM) 
      PUB_SC4CAM = 0
   ENDIF
   IF ISNULL(PUB_SC5CAM) 
      PUB_SC5CAM = 0
   ENDIF
   IF ISNULL(PUB_FISCAM)
      PUB_FISCAM = 0
   ENDIF
   IF ISNULL(PUB_PRZCAM) 
      PUB_PRZCAM = 0
   ENDIF
      
   DO MAGAZZINO_GG WITH 'SIDATA'

   SELECT CUR_MAG_GG
   SKIP +1

ENDDO
            
IF M_QUANTI < 1
ELSE
   M_QTAFOR = M_QUANTI
   M_FORNIT = SPACE(10)
   M_DESFOR = SPACE(40)
   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci = "u_mag_gg.mag_codsoc = '" + PUB_CODSOC + "'"
   x_data = "u_mag_gg.mag_datagg <> '" + SPACE(10) + "'"
   x_codi = "u_mag_gg.mag_codart = '" + ALLTRIM(_CODART) + "'"
   x_maga = "u_mag_gg.mag_codmag = '" + ALLTRIM(_MAG) + "'"
   x_forn = "u_mag_gg.mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
   x_giac = "u_mag_gg.mag_giacen > 0"
   x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
            x_forn + " and " + x_giac

   x_oggi = ribalta2(DTOC(DATE()))
   Csql_1 = "select top 10 case when u_mag_cp.mag_datini <= '" + x_oggi + "' and u_mag_cp.mag_datfin >= '" + x_oggi + "'"
   Csql_2 = " then u_mag_cp.mag_przsco else u_mag_gg.mag_przcon end as mag_przuff, *"
   Csql_3 = " from u_mag_gg left outer join u_mag_cp on"
   Csql_4 = " u_mag_gg.mag_codsoc=u_mag_cp.mag_codsoc and u_mag_gg.mag_codmag=u_mag_cp.mag_codmag and"  
   Csql_5 = " u_mag_gg.mag_codart=u_mag_cp.mag_codart and u_mag_gg.mag_fornit=u_mag_cp.mag_fornit and" 
   Csql_6 = " u_mag_gg.mag_codacq=u_mag_cp.mag_codacq and u_mag_gg.mag_numide=u_mag_cp.mag_numide and"
   Csql_7 = " u_mag_gg.mag_codbun=u_mag_cp.mag_codbun and u_mag_gg.mag_anno=u_mag_cp.mag_anno and"  
   Csql_8 = " u_mag_gg.mag_datagg=u_mag_cp.mag_datagg and u_mag_gg.mag_przcon=u_mag_cp.mag_przcon" 
   Csql_9 = " where " + x_cond
   Csql   = Csql_1 + Csql_2 + Csql_3 + Csql_4 + Csql_5 + Csql_6 + Csql_7 + Csql_8 + Csql_9 
   
   x_Csql = trovsele(Csql,.F.)

   IF !ExecCommand(x_Csql,"CUR_MAG_GG")
      return(.f.)
   ENDIF
   SELECT CUR_MAG_GG
   IF RECCOUNT() = 0
      PUB_FILA_X = SPACE(05)
      PUB_PIAN_X = SPACE(05)
      PUB_UBIC_X = SPACE(05)
      PUB_FILA_N = 0
      PUB_PIAN_N = 0
      PUB_UBIC_N = 0
      DO MAGAZZINO_GG WITH 'NODATA'
   ELSE
      SELECT CUR_MAG_GG
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF M_QUANTI < 1
            EXIT
         ENDIF
         _DATREG  = MAG_DATAGG     
         _PRZACQ  = MAG_PRZCON       
         M_FORNIT = MAG_FORNIT
         M_DESFOR = MAG_DESFOR
         M_CODACQ = MAG_CODACQ
         PUB_FILA_X = MAG_FILA_X
         PUB_PIAN_X = MAG_PIAN_X
         PUB_UBIC_X = MAG_UBIC_X
         PUB_FILA_N = MAG_FILA_N
         PUB_PIAN_N = MAG_PIAN_N
         PUB_UBIC_N = MAG_UBIC_N
         PUB_NUMCAM = MAG_NUMCAM1
         PUB_DATCAM = MAG_DATCAM1
         PUB_INICAM = MAG_DATINI1
         PUB_FINCAM = MAG_DATFIN1
         PUB_SC1CAM = MAG_SC11
         PUB_SC2CAM = MAG_SC21
         PUB_SC3CAM = MAG_SC31
         PUB_SC4CAM = MAG_SC41
         PUB_SC5CAM = MAG_SC51
         PUB_FISCAM = MAG_PRZFIS1
         PUB_PRZCAM = MAG_PRZSCO1
         IF ISNULL(PUB_NUMCAM)
            PUB_NUMCAM = SPACE(06)
         ENDIF
         IF ISNULL(PUB_DATCAM) 
            PUB_DATCAM = SPACE(10)
         ENDIF
         IF ISNULL(PUB_INICAM) 
            PUB_INICAM = SPACE(10)
         ENDIF
         IF ISNULL(PUB_FINCAM) 
            PUB_FINCAM = SPACE(10)
         ENDIF
         IF ISNULL(PUB_SC1CAM) 
            PUB_SC1CAM = 0
         ENDIF
         IF ISNULL(PUB_SC2CAM) 
            PUB_SC2CAM = 0
         ENDIF
         IF ISNULL(PUB_SC3CAM) 
            PUB_SC3CAM = 0
         ENDIF
         IF ISNULL(PUB_SC4CAM) 
            PUB_SC4CAM = 0
         ENDIF
         IF ISNULL(PUB_SC5CAM)
            PUB_SC5CAM = 0
         ENDIF
         IF ISNULL(PUB_FISCAM) 
            PUB_FISCAM = 0
         ENDIF
         IF ISNULL(PUB_PRZCAM) 
            PUB_PRZCAM = 0
         ENDIF
         DO MAGAZZINO_GG WITH 'SIDATA'
         SELECT CUR_MAG_GG          
         SKIP +1
         LOOP
      ENDDO
      IF M_QUANTI = 0
      ELSE
         M_QTAFOR = M_QUANTI
         M_FORNIT = SPACE(10)
         M_DESFOR = SPACE(40)
         M_CODACQ = SPACE(03)
         DO MAGAZZINO_GG WITH 'NSDATA'
      ENDIF
   ENDIF
ENDIF

RETURN


***********************
PROCEDURE GESTIONE_RESO		&& GESTIONE DEL RESO
***********************

RELEASE M_CODACQ
PUBLIC  M_CODACQ
M_CODACQ = SPACE(03)

M_PRIMOF = SPACE(10)
M_QUANTI = _QUANTI
M_DESFOR = ""

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

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO

x_soci = "u_mag_gg.mag_codsoc = '" + PUB_CODSOC + "'"
x_data = "u_mag_gg.mag_datagg <> '" + SPACE(10) + "'"
x_codi = "u_mag_gg.mag_codart = '" + ALLTRIM(_CODART) + "'"
x_maga = "u_mag_gg.mag_codmag = '" + ALLTRIM(_MAG) + "'"
x_forn = "u_mag_gg.mag_fornit = '" + ALLTRIM(_FORNIT) + "'"
x_giac = "u_mag_gg.mag_giacen > 0"
x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_giac

x_oggi = ribalta2(DTOC(DATE()))
Csql_1 = "select top 10 case when u_mag_cp.mag_datini <= '" + x_oggi + "' and u_mag_cp.mag_datfin >= '" + x_oggi + "'"
Csql_2 = " then u_mag_cp.mag_przsco else u_mag_gg.mag_przcon end as mag_przuff, *"
Csql_3 = " from u_mag_gg left outer join u_mag_cp on"
Csql_4 = " u_mag_gg.mag_codsoc=u_mag_cp.mag_codsoc and u_mag_gg.mag_codmag=u_mag_cp.mag_codmag and"  
Csql_5 = " u_mag_gg.mag_codart=u_mag_cp.mag_codart and u_mag_gg.mag_fornit=u_mag_cp.mag_fornit and" 
Csql_6 = " u_mag_gg.mag_codacq=u_mag_cp.mag_codacq and u_mag_gg.mag_numide=u_mag_cp.mag_numide and"
Csql_7 = " u_mag_gg.mag_codbun=u_mag_cp.mag_codbun and u_mag_gg.mag_anno=u_mag_cp.mag_anno and"  
Csql_8 = " u_mag_gg.mag_datagg=u_mag_cp.mag_datagg and u_mag_gg.mag_przcon=u_mag_cp.mag_przcon" 
Csql_9 = " where " + x_cond
Csql   = Csql_1 + Csql_2 + Csql_3 + Csql_4 + Csql_5 + Csql_6 + Csql_7 + Csql_8 + Csql_9 
   
x_Csql = trovsele(Csql,.T.)

IF !ExecCommand(x_Csql,"CUR_MAG_GG")
   return(.f.)
ENDIF
SELECT CUR_MAG_GG
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF M_QUANTI < 1
      EXIT
   ENDIF

   _DATREG  = MAG_DATAGG     
   _PRZACQ  = MAG_PRZCON       
   M_FORNIT = MAG_FORNIT
   M_DESFOR = MAG_DESFOR
   M_CODACQ = MAG_CODACQ

   PUB_FILA_X = MAG_FILA_X
   PUB_PIAN_X = MAG_PIAN_X
   PUB_UBIC_X = MAG_UBIC_X
   PUB_FILA_N = MAG_FILA_N
   PUB_PIAN_N = MAG_PIAN_N
   PUB_UBIC_N = MAG_UBIC_N

   PUB_NUMCAM = MAG_NUMCAM1
   PUB_DATCAM = MAG_DATCAM1
   PUB_INICAM = MAG_DATINI1
   PUB_FINCAM = MAG_DATFIN1
   PUB_SC1CAM = MAG_SC11
   PUB_SC2CAM = MAG_SC21
   PUB_SC3CAM = MAG_SC31
   PUB_SC4CAM = MAG_SC41
   PUB_SC5CAM = MAG_SC51
   PUB_FISCAM = MAG_PRZFIS1
   PUB_PRZCAM = MAG_PRZSCO1

   IF ISNULL(PUB_NUMCAM)
      PUB_NUMCAM = SPACE(06)
   ENDIF
   IF ISNULL(PUB_DATCAM) 
      PUB_DATCAM = SPACE(10)
   ENDIF
   IF ISNULL(PUB_INICAM) 
      PUB_INICAM = SPACE(10)
   ENDIF
   IF ISNULL(PUB_FINCAM) 
      PUB_FINCAM = SPACE(10)
   ENDIF
   IF ISNULL(PUB_SC1CAM)
      PUB_SC1CAM = 0
   ENDIF
   IF ISNULL(PUB_SC2CAM)
      PUB_SC2CAM = 0
   ENDIF
   IF ISNULL(PUB_SC3CAM) 
      PUB_SC3CAM = 0
   ENDIF
   IF ISNULL(PUB_SC4CAM) 
      PUB_SC4CAM = 0
   ENDIF
   IF ISNULL(PUB_SC5CAM) 
      PUB_SC5CAM = 0
   ENDIF
   IF ISNULL(PUB_FISCAM)
      PUB_FISCAM = 0
   ENDIF
   IF ISNULL(PUB_PRZCAM) 
      PUB_PRZCAM = 0
   ENDIF
      
   DO MAGAZZINO_GG WITH 'SIDATA'

   SELECT CUR_MAG_GG
   SKIP +1

ENDDO
            
IF M_QUANTI < 1
ELSE
   M_QTAFOR = M_QUANTI
   M_FORNIT = SPACE(10)
   M_DESFOR = SPACE(40)
   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci = "u_mag_gg.mag_codsoc = '" + PUB_CODSOC + "'"
   x_data = "u_mag_gg.mag_datagg <> '" + SPACE(10) + "'"
   x_codi = "u_mag_gg.mag_codart = '" + ALLTRIM(_CODART) + "'"
   x_maga = "u_mag_gg.mag_codmag = '" + ALLTRIM(_MAG) + "'"
   x_forn = "u_mag_gg.mag_fornit = '" + ALLTRIM(_FORNIT) + "'"
   x_giac = "u_mag_gg.mag_giacen > 0"
   x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
            x_forn + " and " + x_giac

   x_oggi = ribalta2(DTOC(DATE()))
   Csql_1 = "select top 10 case when u_mag_cp.mag_datini <= '" + x_oggi + "' and u_mag_cp.mag_datfin >= '" + x_oggi + "'"
   Csql_2 = " then u_mag_cp.mag_przsco else u_mag_gg.mag_przcon end as mag_przuff, *"
   Csql_3 = " from u_mag_gg left outer join u_mag_cp on"
   Csql_4 = " u_mag_gg.mag_codsoc=u_mag_cp.mag_codsoc and u_mag_gg.mag_codmag=u_mag_cp.mag_codmag and"  
   Csql_5 = " u_mag_gg.mag_codart=u_mag_cp.mag_codart and u_mag_gg.mag_fornit=u_mag_cp.mag_fornit and" 
   Csql_6 = " u_mag_gg.mag_codacq=u_mag_cp.mag_codacq and u_mag_gg.mag_numide=u_mag_cp.mag_numide and"
   Csql_7 = " u_mag_gg.mag_codbun=u_mag_cp.mag_codbun and u_mag_gg.mag_anno=u_mag_cp.mag_anno and"  
   Csql_8 = " u_mag_gg.mag_datagg=u_mag_cp.mag_datagg and u_mag_gg.mag_przcon=u_mag_cp.mag_przcon" 
   Csql_9 = " where " + x_cond
   Csql   = Csql_1 + Csql_2 + Csql_3 + Csql_4 + Csql_5 + Csql_6 + Csql_7 + Csql_8 + Csql_9 
   
   x_Csql = trovsele(Csql,.T.)

   IF !ExecCommand(x_Csql,"CUR_MAG_GG")
      return(.f.)
   ENDIF
   SELECT CUR_MAG_GG
   IF RECCOUNT() = 0
      PUB_FILA_X = SPACE(05)
      PUB_PIAN_X = SPACE(05)
      PUB_UBIC_X = SPACE(05)
      PUB_FILA_N = 0
      PUB_PIAN_N = 0
      PUB_UBIC_N = 0
      DO MAGAZZINO_GG WITH 'NODATA'
   ELSE
      SELECT CUR_MAG_GG
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF M_QUANTI < 1
            EXIT
         ENDIF
         _DATREG  = MAG_DATAGG     
         _PRZACQ  = MAG_PRZCON       
         M_FORNIT = MAG_FORNIT
         M_DESFOR = MAG_DESFOR
         M_CODACQ = MAG_CODACQ
         PUB_FILA_X = MAG_FILA_X
         PUB_PIAN_X = MAG_PIAN_X
         PUB_UBIC_X = MAG_UBIC_X
         PUB_FILA_N = MAG_FILA_N
         PUB_PIAN_N = MAG_PIAN_N
         PUB_UBIC_N = MAG_UBIC_N
         PUB_NUMCAM = MAG_NUMCAM1
         PUB_DATCAM = MAG_DATCAM1
         PUB_INICAM = MAG_DATINI1
         PUB_FINCAM = MAG_DATFIN1
         PUB_SC1CAM = MAG_SC11
         PUB_SC2CAM = MAG_SC21
         PUB_SC3CAM = MAG_SC31
         PUB_SC4CAM = MAG_SC41
         PUB_SC5CAM = MAG_SC51
         PUB_FISCAM = MAG_PRZFIS1
         PUB_PRZCAM = MAG_PRZSCO1
         IF ISNULL(PUB_NUMCAM)
            PUB_NUMCAM = SPACE(06)
         ENDIF
         IF ISNULL(PUB_DATCAM) 
            PUB_DATCAM = SPACE(10)
         ENDIF
         IF ISNULL(PUB_INICAM) 
            PUB_INICAM = SPACE(10)
         ENDIF
         IF ISNULL(PUB_FINCAM) 
            PUB_FINCAM = SPACE(10)
         ENDIF
         IF ISNULL(PUB_SC1CAM) 
            PUB_SC1CAM = 0
         ENDIF
         IF ISNULL(PUB_SC2CAM) 
            PUB_SC2CAM = 0
         ENDIF
         IF ISNULL(PUB_SC3CAM) 
            PUB_SC3CAM = 0
         ENDIF
         IF ISNULL(PUB_SC4CAM) 
            PUB_SC4CAM = 0
         ENDIF
         IF ISNULL(PUB_SC5CAM)
            PUB_SC5CAM = 0
         ENDIF
         IF ISNULL(PUB_FISCAM) 
            PUB_FISCAM = 0
         ENDIF
         IF ISNULL(PUB_PRZCAM) 
            PUB_PRZCAM = 0
         ENDIF
         DO MAGAZZINO_GG WITH 'SIDATA'
         SELECT CUR_MAG_GG          
         SKIP +1
         LOOP
      ENDDO
      IF M_QUANTI = 0
      ELSE
         M_QTAFOR = M_QUANTI
         M_FORNIT = SPACE(10)
         M_DESFOR = SPACE(40)
         M_CODACQ = SPACE(03)
         DO MAGAZZINO_GG WITH 'NSDATA'
      ENDIF
   ENDIF
ENDIF

RETURN



**************************************************************************
PROCEDURE MAGAZZINO_GG 			       && SCARICA IL MAGAZZINO GIORNALIERO
**************************************************************************

PARAMETERS _DATA

RELEASE QWE_SYSGGG,QWE_SYSGGS,QWE_SYSDAG,QWE_SYSSAS
PUBLIC  QWE_SYSGGG,QWE_SYSGGS,QWE_SYSDAG,QWE_SYSSAS
QWE_SYSGGG = SPACE(10)
QWE_SYSGGS = SPACE(10)
QWE_SYSDAG = SPACE(10)
QWE_SYSDAS = SPACE(10)

RELEASE RIN_DATSCAR 
PUBLIC  RIN_DATSCAR
RIN_DATSCAR = SPACE(10)

**=> ERASMO - INIZIO 13/12/2010
IF PUB_GGDTSP
	*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
	*=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
	x_soci   = "mag_codsoc = '" + PUB_CODSOC + "'"
	x_data   = "mag_datagg = '" + SPACE(10) + "'"
	x_codi   = "mag_codart = '" + ALLTRIM(_CODART) + "'"
	x_maga   = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
	x_forn   = "mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
	x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
	*IF _DATA = 'NSDATA'
	*   Csql  = "select * from u_mag_gg where 1=0"
	*ELSE
	   Csql  = "select * from u_mag_gg where " + x_cond
	*ENDIF
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
	   *REPLACE MAG_GIACEN WITH M_QTAFOR * (-1)
	   REPLACE MAG_GIACEN WITH M_QUANTI * (-1)
	   REPLACE MAG_QTAKG  WITH M_QTAKG * (-1)
	   REPLACE MAG_QTAMQ  WITH M_QTAMQ * (-1)
	   REPLACE MAG_QTAML  WITH M_QTAML * (-1)
	   REPLACE MAG_UNIQUE WITH SYS(2015)
	   IF SUBSTR(_DADOVE,1,8) = 'PRODAVAN'
	      REPLACE MAG_QTAMQA WITH M_QUANTI * (-1)
	      REPLACE MAG_QTAMLA WITH TROVA_ML_DA_MQ(MAG_ALTEZZ,MAG_QTAMQA) * (-1)
	      REPLACE MAG_QTAKGA WITH TROVA_KG_DA_MQ(MAG_CODART,MAG_SPESSO,MAG_QTAMQA,1) * (-1)
	      SELECT U_MAG_GG
	   ENDIF
	ELSE
	   *REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QTAFOR
	   REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QUANTI
	   REPLACE MAG_QTAKG  WITH MAG_QTAKG - M_QTAKG
	   REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M_QTAMQ
	   REPLACE MAG_QTAML  WITH MAG_QTAML - M_QTAML
	   IF SUBSTR(_DADOVE,1,8) = 'PRODAVAN'
	      REPLACE MAG_QTAMQA WITH M_QTAMQA
	      REPLACE MAG_QTAMLA WITH TROVA_ML_DA_MQ(MAG_ALTEZZ,MAG_QTAMQA)
	      REPLACE MAG_QTAKGA WITH TROVA_KG_DA_MQ(MAG_CODART,MAG_SPESSO,MAG_QTAMQA,1)
	      SELECT U_MAG_GG
	      IF _DADOVE = 'PRODAVAN'
	         REPLACE MAG_QTAIMP WITH 0
	         REPLACE MAG_GMLIMP WITH 0
	         REPLACE MAG_GKGIMP WITH 0
	      ELSE
	         REPLACE MAG_QTAIMP WITH MAG_QTAIMP - MAG_QTAMQA
	         REPLACE MAG_GMLIMP WITH MAG_GMLIMP - MAG_QTAMLA
	         REPLACE MAG_GKGIMP WITH MAG_GKGIMP - MAG_QTAKGA
	      ENDIF
	      IF MAG_QTAIMP < 0 .OR. MAG_GMLIMP < 0 .OR. MAG_GKGIMP < 0
	         REPLACE MAG_QTAIMP WITH 0
	         REPLACE MAG_GMLIMP WITH 0
	         REPLACE MAG_GKGIMP WITH 0
	      ENDIF
	   ENDIF
	ENDIF
	IF _DADOVE = 'PRODSPOSTA'
	   REPLACE MAG_LUNGHE WITH MAG_QTAML
	ENDIF
	REPLACE MAG_FLGTRA WITH .F.
	SCATTER MEMVAR MEMO
	IF !ExecRw(cSql,"U_MAG_GG","W")
	   return(.f.)
	ENDIF

	IF EMPTY(ALLTRIM(_MAG1))
	ELSE
	   x_soci = "mag_codsoc = '" + M.MAG_CODSOC + "'"
	   x_data = "mag_datagg = '" + SPACE(10) + "'"
	   x_codi = "mag_codart = '" + ALLTRIM(M.MAG_CODART) + "'"
	   x_maga = "mag_codmag = '" + ALLTRIM(_MAG1) + "'"
	   x_forn = "mag_fornit = '" + ALLTRIM(M.MAG_FORNIT) + "'"
	   x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
	   Csql   = "select * from u_mag_gg where " + x_cond 
	   IF !ExecRW(cSql,"U_MAG_GG","R")
	      return(.f.)
	   ENDIF
	   SELECT U_MAG_GG
	   GO TOP       
	   IF EOF()
	      APPEND BLANK
	      DO U_MAG_GG
	      REPLACE MAG_DATAGG WITH SPACE(10)
	      REPLACE MAG_CODMAG WITH _MAG1
	      *REPLACE MAG_GIACEN WITH M_QTAFOR
	      REPLACE MAG_GIACEN WITH M_QUANTI
	      REPLACE MAG_QTAKG  WITH M_QTAKG
	      REPLACE MAG_QTAMQ  WITH M_QTAMQ
	      REPLACE MAG_QTAML  WITH M_QTAML
	      REPLACE MAG_UNIQUE WITH SYS(2015)
	   ELSE
	      *REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QTAFOR
	      REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QUANTI
	      REPLACE MAG_QTAKG  WITH MAG_QTAKG + M_QTAKG
	      REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M_QTAMQ
	      REPLACE MAG_QTAML  WITH MAG_QTAML + M_QTAML
	   ENDIF
	   IF _DADOVE = 'PRODSPOSTA'
	      REPLACE MAG_LUNGHE WITH MAG_QTAML
	   ENDIF
	   REPLACE MAG_FLGTRA WITH .F.
	   QWE_SYSGGS = MAG_UNIQUE
	   IF !ExecRW(cSql,"U_MAG_GG","W")
	      return(.f.)
	   ENDIF
	ENDIF
ENDIF
**=> ERASMO - FINE 13/12/2010

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO

x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
IF _DATA = 'SIDATA' .OR. _DATA = 'SPDATA' 
   x_data = "mag_datagg = '" + _DATREG + "'"
ELSE
   x_data = "mag_datagg <> '" + SPACE(10) + "'"
ENDIF
x_codi = "mag_codart = '" + ALLTRIM(_CODART) + "'"
x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
x_forn = "mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
x_giac = "mag_giacen > 0"
x_fila = "mag_fila_n = " + ALLTRIM(STR(PUB_FILA_N,5,0))
x_pian = "mag_pian_n = " + ALLTRIM(STR(PUB_PIAN_N,5,0))
x_ubic = "mag_ubic_n = " + ALLTRIM(STR(PUB_UBIC_N,5,0))

IF _DATA = 'SPDATA' .OR. _DATA = 'SIDATA' 
   XXX_PRZACQ  = _PRZACQ
   XX_PRZACQ   = ALLTRIM(STR(_PRZACQ,17,6))
   XX_PRZACQ   = STRTRAN(XX_PRZACQ,",",".")
   x_prez      = "mag_przcon = " + XX_PRZACQ
   x_tipo      = "mag_codacq = '" + ALLTRIM(M_CODACQ) + "'"
   x_cond      = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                 x_forn + " and " + x_giac + " and " + x_tipo + " and " + x_prez + " and " + ;
                 x_fila + " and " + x_pian + " and " + x_ubic
   Csql        = "select top 1 * from u_mag_gg where " + x_cond + " order by mag_codacq,mag_przcon,mag_datagg,mag_giacen"
ELSE
   x_prez      = "mag_przcon = mag_przcon"
   x_tipo      = "mag_codacq = mag_codacq"
   x_cond      = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                 x_forn + " and " + x_giac + " and " + x_tipo + " and " + x_prez + " and " + ;
                 x_fila + " and " + x_pian + " and " + x_ubic
   IF _DATA = 'NODATA'
      Csql  = "select top 10 * from u_mag_gg where " + x_cond + " order by mag_codacq,mag_przcon,mag_datagg,mag_giacen"
   ELSE
      Csql  = "select * from u_mag_gg where 1=0"
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
GO TOP       

RELEASE V_DIFIMP
PUBLIC  V_DIFIMP
V_DIFIMP = 0

IF EOF()
   APPEND BLANK
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_DATAGG WITH _DATREG
   REPLACE MAG_CODMAG WITH _MAG
   REPLACE MAG_CODART WITH _CODART
   REPLACE MAG_DESART WITH A_DESART
   REPLACE MAG_CODPDV WITH M_CODPDV
   REPLACE MAG_FORNIT WITH M_FORNIT
   REPLACE MAG_DESFOR WITH M_DESFOR
   REPLACE MAG_GIACEN WITH M_QTAFOR * (-1)
   REPLACE MAG_QTAKG  WITH M_QTAKG * (-1)
   REPLACE MAG_QTAMQ  WITH M_QTAMQ * (-1)
   REPLACE MAG_QTAML  WITH M_QTAML * (-1)
   REPLACE MAG_PRZCON WITH _PRZACQ
   REPLACE MAG_UNIQUE WITH SYS(2015)
   IF SUBSTR(_DADOVE,1,8) = 'PRODAVAN'
      REPLACE MAG_QTAMQA WITH M_QTAMQA * (-1)
      REPLACE MAG_QTAMLA WITH TROVA_ML_DA_MQ(MAG_ALTEZZ,MAG_QTAMQA) * (-1)
      REPLACE MAG_QTAKGA WITH TROVA_KG_DA_MQ(MAG_CODART,MAG_SPESSO,MAG_QTAMQA,1) * (-1)
      SELECT U_MAG_GG
      IF _DADOVE = 'PRODAVAN'
         M_QUANTI = M_QTAMQ
      ENDIF
   ENDIF
   IF EMPTY(ALLTRIM(MAG_ANNO))
      REPLACE MAG_ANNO WITH SUBSTR(MAG_DATAGG,1,4)
   ENDIF
   REPLACE MAG_FILA_X WITH PUB_FILA_X
   REPLACE MAG_PIAN_X WITH PUB_PIAN_X
   REPLACE MAG_UBIC_X WITH PUB_UBIC_X
   REPLACE MAG_FILA_N WITH PUB_FILA_N
   REPLACE MAG_PIAN_N WITH PUB_PIAN_N
   REPLACE MAG_UBIC_N WITH PUB_UBIC_N
   REPLACE MAG_ANAART WITH _CODART  && ERASMO 04/12/2007
ELSE
   IF _DADOVE = 'PRODAVAN'
      IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
      ELSE
         M_QUANTI = M_QTAMQ
      ENDIF
   ENDIF
   IF MAG_GIACEN > M_QUANTI
      REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QUANTI
      REPLACE MAG_QTAKG  WITH MAG_QTAKG - M_QTAKG
      REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M_QTAMQ
      REPLACE MAG_QTAML  WITH MAG_QTAML - M_QTAML
      M_QTAFOR = M_QUANTI
      M_QUANTI = 0

      IF _DADOVE = 'PRODSPOSTA' 
         IF MAG_GIACEN < MAG_QTAIMP
            V_DIFIMP = MAG_QTAIMP - MAG_GIACEN
            REPLACE MAG_QTAIMP WITH MAG_GIACEN
         ELSE
            V_DIFIMP = 0
         ENDIF
      ENDIF

   ELSE
      M_QUANTI = M_QUANTI - MAG_GIACEN
      M_QTAFOR = MAG_GIACEN
      REPLACE MAG_GIACEN WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAML  WITH 0

      IF _DADOVE = 'PRODSPOSTA' 
         V_DIFIMP = MAG_QTAIMP
      ENDIF

   ENDIF
   IF SUBSTR(_DADOVE,1,8) = 'PRODAVAN'
      *=> INIZIO RINO 18/04/2006
      *REPLACE MAG_QTAMQA WITH M_QTAMQA
      *REPLACE MAG_QTAMLA WITH TROVA_ML_DA_MQ(MAG_ALTEZZ,MAG_QTAMQA)
      *REPLACE MAG_QTAKGA WITH TROVA_KG_DA_MQ(MAG_CODART,MAG_SPESSO,MAG_QTAMQA,1)
      REPLACE MAG_QTAMQA WITH M_QTAMQ
      REPLACE MAG_QTAMLA WITH M_QTAML
      REPLACE MAG_QTAKGA WITH M_QTAKG
      *=> FINE RINO 18/04/2006
      SELECT U_MAG_GG
      IF _DADOVE = 'PRODAVAN'
         REPLACE MAG_QTAIMP WITH 0
         REPLACE MAG_GMLIMP WITH 0
         REPLACE MAG_GKGIMP WITH 0
      ELSE
         REPLACE MAG_QTAIMP WITH MAG_QTAIMP - MAG_QTAMQA
         REPLACE MAG_GMLIMP WITH MAG_GMLIMP - MAG_QTAMLA
         REPLACE MAG_GKGIMP WITH MAG_GKGIMP - MAG_QTAKGA
      ENDIF
      IF MAG_QTAIMP < 0 .OR. MAG_GMLIMP < 0 .OR. MAG_GKGIMP < 0
         REPLACE MAG_QTAIMP WITH 0
         REPLACE MAG_GMLIMP WITH 0
         REPLACE MAG_GKGIMP WITH 0
      ENDIF
   ENDIF
   **=> ERASMO - INIZIO 25/02/2010
   REPLACE MAG_FILA_X WITH PUB_FILDES_X 
   REPLACE MAG_PIAN_X WITH PUB_PIADES_X 
   REPLACE MAG_UBIC_X WITH PUB_UBIDES_X 
   REPLACE MAG_FILA_N WITH PUB_FILDES_N 
   REPLACE MAG_PIAN_N WITH PUB_PIADES_N 
   REPLACE MAG_UBIC_N WITH PUB_UBIDES_N 
   **=> ERASMO - FINE 25/02/2010
ENDIF

IF MAG_GIACEN > 0
ELSE
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_QTAIMP WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF

IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF

RIN_DATSCAR = MAG_DATAGG

_DATAOGGI = RIBALTA2(DTOC(DATE()))
IF EMPTY(ALLTRIM(M_DATREG)) .OR. M_DATREG = '  /  /    ' .OR. M_DATREG = '    /  /  '
   M.MAG_DATAGG = _DATAOGGI
ELSE
   M.MAG_DATAGG = M_DATREG
ENDIF

IF MAG_NRLINT > 50000000 
   REPLACE MAG_FLGRIB WITH .T.
ENDIF

*IF _DADOVE = 'PRODSPOSTA' 
IF _DADOVE = 'PRODSPOSTA' .OR. _DADOVE = 'PRODAVANS'  && ERASMO - 25/02/2011
   REPLACE MAG_LUNGHE WITH MAG_QTAML
ENDIF
REPLACE MAG_FLGTRA WITH .F.
RELEASE QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME,   ;
        QWE_LEGSYS,QWE_NUMORF,QWE_DATORF,QWE_SC1,QWE_SC2,QWE_SC3,QWE_NUMIDE,QWE_CODBUN, ;
        QWE_ANNO
PUBLIC  QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME,   ;
        QWE_LEGSYS,QWE_NUMORF,QWE_DATORF,QWE_SC1,QWE_SC2,QWE_SC3,QWE_NUMIDE,QWE_CODBUN, ;
        QWE_ANNO
QWE_FORNIT = MAG_FORNIT
QWE_DESFOR = MAG_DESFOR
QWE_CODACQ = MAG_CODACQ
QWE_DESACQ = MAG_DESACQ
QWE_PRZCON = MAG_PRZCON
QWE_PAGAME = MAG_PAGAME
QWE_LEGAME = MAG_LEGAME
QWE_LEGSYS = MAG_LEGSYS
QWE_NUMORF = SPACE(06)
QWE_DATORF = SPACE(10)
QWE_SC1    = 0
QWE_SC2    = 0
QWE_SC3    = 0
QWE_NUMIDE = MAG_NUMIDE
QWE_CODBUN = MAG_CODBUN
QWE_ANNO   = MAG_ANNO
SCATTER MEMVAR MEMO
IF EMPTY(ALLTRIM(PUB_MAGNO0))
ELSE
   IF MAG_GIACEN = 0
      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
      ELSE
         DELETE
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF

IF _DADOVE = 'SOS_SCARICA'
   QWR_FORNIT = M.MAG_FORNIT
   QWR_DESFOR = M.MAG_DESFOR
   QWR_CODACQ = M.MAG_CODACQ
   QWR_DESACQ = M.MAG_DESACQ
   QWR_PRZCON = M.MAG_PRZCON
   QWR_PAGAME = M.MAG_PAGAME
   QWR_LEGAME = M.MAG_LEGAME
   QWR_LEGSYS = M.MAG_LEGSYS
   QWR_NUMORF = SPACE(06)
   QWR_DATORF = SPACE(10)
   QWR_SC1    = 0
   QWR_SC2    = 0
   QWR_SC3    = 0
   QWR_NUMIDE = M.MAG_NUMIDE
   QWR_CODBUN = M.MAG_CODBUN
   QWR_ANNO   = M.MAG_ANNO
ENDIF

IF EMPTY(ALLTRIM(_MAG1))
ELSE
   x_soci      = "mag_codsoc = '" + M.MAG_CODSOC + "'"
   x_data      = "mag_datagg = '" + M.MAG_DATAGG + "'"
   x_codi      = "mag_codart = '" + ALLTRIM(M.MAG_CODART) + "'"
   x_maga      = "mag_codmag = '" + ALLTRIM(_MAG1) + "'"
   x_forn      = "mag_fornit = '" + ALLTRIM(M.MAG_FORNIT) + "'"
   XXX_PRZACQ  = M.MAG_PRZCON
   XX_PRZACQ   = ALLTRIM(STR(M.MAG_PRZCON,17,6))
   XX_PRZACQ   = STRTRAN(XX_PRZACQ,",",".")
   x_prez      = "mag_przcon = " + XX_PRZACQ
   x_tipo      = "mag_codacq = '" + ALLTRIM(QWE_CODACQ) + "'"
   x_cide      = "mag_numide = '" + ALLTRIM(QWE_NUMIDE) + "'"
   x_cpdv      = "mag_codbun = '" + ALLTRIM(QWE_CODBUN) + "'"
   x_anno      = "mag_anno = mag_anno"
   x_fila      = "mag_fila_n = " + ALLTRIM(STR(PUB_FILDES_N,5,0))
   x_pian      = "mag_pian_n = " + ALLTRIM(STR(PUB_PIADES_N,5,0))
   x_ubic      = "mag_ubic_n = " + ALLTRIM(STR(PUB_UBIDES_N,5,0))
   x_cond      = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                 x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                 x_cpdv + " and " + x_anno + " and " + x_fila + " and " + x_pian + " and " + ;
                 x_ubic
   Csql        = "select top 1 * from u_mag_gg where " + x_cond + " order by mag_codacq,mag_przcon,mag_datagg"
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   GO TOP       
   IF EOF()
      APPEND BLANK
      DO U_MAG_GG
      REPLACE MAG_CODMAG WITH _MAG1
      REPLACE MAG_GIACEN WITH M_QTAFOR
      REPLACE MAG_QTAKG  WITH M_QTAKG
      REPLACE MAG_QTAMQ  WITH M_QTAMQ
      REPLACE MAG_QTAML  WITH M_QTAML
      *REPLACE MAG_PRZCON WITH _PRZACQ
      REPLACE MAG_PRZCON WITH IIF(_PRZACQ > 0,_PRZACQ,A_PRZCOS)  && ERASMO - 04/07/2008
      REPLACE MAG_UNIQUE WITH SYS(2015)
      REPLACE MAG_NUMPED WITH 0
      IF EMPTY(ALLTRIM(MAG_ANNO))
         REPLACE MAG_ANNO WITH SUBSTR(MAG_DATAGG,1,4)
      ENDIF
   ELSE
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QTAFOR
      REPLACE MAG_QTAKG  WITH MAG_QTAKG + M_QTAKG
      REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M_QTAMQ
      REPLACE MAG_QTAML  WITH MAG_QTAML + M_QTAML
   ENDIF
   IF _DADOVE = 'PRODSPOSTA'
      REPLACE MAG_LUNGHE WITH MAG_QTAML
      REPLACE MAG_QTAIMP WITH V_DIFIMP
   ENDIF
   IF MAG_NRLINT > 50000000 
      REPLACE MAG_FLGRIB WITH .T.
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   IF MAG_GIACEN < 0
      REPLACE MAG_GIACEN WITH 0
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_QTAIMP WITH 0
      REPLACE MAG_GKGIMP WITH 0
      REPLACE MAG_GMLIMP WITH 0
   ENDIF
   IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_GKGIMP WITH 0
      REPLACE MAG_GMLIMP WITH 0
   ENDIF
   *=> Inizio - Rino 04/10/2004
   REPLACE MAG_FILA_X WITH PUB_FILDES_X
   REPLACE MAG_PIAN_X WITH PUB_PIADES_X
   REPLACE MAG_UBIC_X WITH PUB_UBIDES_X
   REPLACE MAG_FILA_N WITH PUB_FILDES_N
   REPLACE MAG_PIAN_N WITH PUB_PIADES_N
   REPLACE MAG_UBIC_N WITH PUB_UBIDES_N
   *=> Fine - Rino 04/10/2004
   QWE_SYSGGG = MAG_UNIQUE
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF
ENDIF

_DATAOGGI = RIBALTA2(DTOC(DATE()))

*-->> CREA IL MOVIMENTO DI SCARICO MAGAZZINO

IF _GENMOV = "SI"
   QWE_NUMORF = SPACE(06)
   QWE_DATORF = SPACE(10)
   QWE_SC1    = 0
   QWE_SC2    = 0
   QWE_SC3    = 0
   x_maga = "ord_maga = '" + ALLTRIM(_MAG) + "'"
   x_lega = "ord_legsys = '" + ALLTRIM(QWE_LEGSYS) + "'"
   x_cond = x_maga + " and " + x_lega
   cSql   = "SELECT * FROM U_ORF_DD WHERE " + x_cond
   IF !ExecCommand(cSql,"U_ORF_DD")
      return(.f.)
   ENDIF 
   SELECT U_ORF_DD
   GO TOP
   IF EOF()
   ELSE
      QWE_NUMORF = ORS_NUMORD
      QWE_DATORF = ORS_DATORD
      QWE_SC1    = ORD_SC1
      QWE_SC2    = ORD_SC2
      QWE_SC3    = ORD_SC3
   ENDIF
*!*	   x_soci = "mov_codsoc = '" + PUB_CODSOC + "'"
*!*	   x_arti = "mov_codart = '" + ALLTRIM(_CODART) + "'"
*!*	   IF SUBSTR(_DADOVE,1,8) = 'PRODAVAN'
*!*	      x_maga = "mov_codmag = '" + ALLTRIM(_MAG) + "'"
*!*	      x_caus = "mov_top = '" + ALLTRIM(XYZ_CAUSCA) + "'"
*!*	   ELSE
*!*	      x_maga = "mov_codmag = '" + ALLTRIM(PUB_CARORF) + "'"
*!*	      x_caus = "mov_top = '" + ALLTRIM(PUB_BFO) + "'"
*!*	   ENDIF
*!*	   x_forn = "mov_codfor = '" + ALLTRIM(M.MAG_FORNIT) + "'"
*!*	   x_cond = x_soci + " and " + x_maga + " and " + x_arti + " and " + x_caus + " and " + x_forn
*!*	   Csql   = "select * from u_mag_mo where " + x_cond
*!*	   IF !ExecCommand(cSql,"CUX_MAG_MO")
*!*	      return(.f.)
*!*	   ENDIF
   
   **=> ERASMO - INIZIO 02/10/2006
   x_soci = "mov_codsoc = '" + PUB_CODSOC + "'"
   x_arti = "mov_codart = '" + ALLTRIM(_CODART) + "'"
   IF SUBSTR(_DADOVE,1,8) = 'PRODAVAN'
      x_maga = "mov_codmag = '" + ALLTRIM(_MAG) + "'"
      x_caus = "mov_top = '" + ALLTRIM(XYZ_CAUSCA) + "'"
   ELSE
      x_maga = "mov_codmag = '" + ALLTRIM(PUB_CARORF) + "'"
      x_caus = "mov_top = '" + ALLTRIM(PUB_BFO) + "'"
   ENDIF
   x_forn = "mov_codfor = '" + ALLTRIM(M.MAG_FORNIT) + "'"
   x_lsys = "mov_legsys = '" + ALLTRIM(QWE_LEGSYS) + "'"
   x_cond = x_soci + " and " + x_arti + " and " + x_maga + " and " + x_caus + " and " + x_forn + " and " + x_lsys
   Csql   = "select * from u_mag_mo where " + x_cond
   IF !ExecCommand(cSql,"CUX_MAG_MO")
      return(.f.)
   ENDIF
   **=> ERASMO - FINE 02/10/2006
   
   SELECT CUX_MAG_MO
   IF !EOF()
       SCATTER MEMVAR MEMO
       Csql = "select * from u_mag_mo where 1=0"
       IF !ExecRW(Csql,"U_MAG_MO","R")
          return(.f.)
       ENDIF
       SELECT U_MAG_MO
       APPEND BLANK
       M.MOV_CODMAT = M.MAG_CODMAT
       M.MOV_CODCOL = M.MAG_CODCOL
       DO U_MAG_MO
       IF M.MOV_CODMAT = '001' .OR. M.MOV_CODMAT = '004'
       ELSE
          REPLACE MOV_UM WITH 'MQ'
       ENDIF
   	   IF EMPTY(ALLTRIM(_NUMDOC))
   	   ELSE
   	      REPLACE MOV_NUMDOC WITH _NUMDOC
   	   ENDIF
   	   IF EMPTY(ALLTRIM(_DATDOC)) .OR. _DATDOC = '  /  /    ' .OR. _DATDOC = '    /  /  ' 
   	   ELSE
   	      REPLACE MOV_DTDOCU WITH _DATDOC
   	   ENDIF
   	   IF EMPTY(ALLTRIM(M_DATREG)) .OR. M_DATREG = '  /  /    ' .OR. M_DATREG = '    /  /  ' 
   	      REPLACE MOV_DTREGI WITH _DATAOGGI
   	   ELSE
          REPLACE MOV_DTREGI WITH M_DATREG
       ENDIF
       REPLACE MOV_DATSCA WITH RIN_DATSCAR
       REPLACE MOV_CODMAG WITH _MAG 
       REPLACE MOV_LUNGHE WITH M_QTAML
       REPLACE MOV_TOP    WITH _TOP
	   REPLACE MOV_QTAMOV WITH M_QTAFOR
       IF M.MOV_CODMAT = '001' .OR. M.MOV_CODMAT = '004'
   		  IF M.MAG_QTAMQ > 0
   		     REPLACE MOV_QTAMQ WITH M_QTAFOR
   		  ELSE
             REPLACE MOV_QTAMQ  WITH M_QTAMQ
   		  ENDIF
          REPLACE MOV_QTAML  WITH M_QTAML
          REPLACE MOV_QTAKG  WITH M_QTAKG
       ELSE
   	      REPLACE MOV_QTAMQ  WITH M_QTAMQ
	      REPLACE MOV_QTAML  WITH M_QTAML
	      REPLACE MOV_QTAKG  WITH M_QTAKG
	   ENDIF
       IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
          REPLACE MOV_QTAMQ  WITH 0
          REPLACE MOV_QTAKG  WITH 0
          REPLACE MOV_QTAML  WITH 0
          REPLACE MOV_QTAMQA WITH 0
          REPLACE MOV_QTAMLA WITH 0
          REPLACE MOV_QTAKGA WITH 0
          M_QTAMQA = 0
       ENDIF
	   REPLACE MOV_PREVEN WITH _PRZVEN
	   IF MOV_TOP = PUB_CAUREF .AND. MOV_QTAKG > 0
          REPLACE MOV_VALVEN WITH 0
	      REPLACE MOV_VALACQ WITH ROUND((MOV_QTAKG * MOV_PREACQ),2)
       ELSE
          REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
	      REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
	   ENDIF
       RELEASE P_TIPO
       PUBLIC  P_TIPO
       P_TIPO = CERCATIPO(MOV_ANAART)
       SELECT U_MAG_MO
       IF P_TIPO = '3'	&& GESTIONE MANDRINI
          P_VALACQ = ROUND(((MOV_ALTEZZ / 1000) * MOV_PREACQ),2)
	      REPLACE MOV_VALACQ WITH P_VALACQ
       ENDIF
	   REPLACE MOV_ORAMOV WITH _ORAMOV					
	   REPLACE MOV_SEGNO  WITH X_SEGNO					
	   REPLACE MOV_TIPMOV WITH V_TMOV				
	   REPLACE MOV_UNIQUE WITH SYS(2015)
       REPLACE MOV_FLGTRA WITH _FLGTRA
   	   REPLACE MOV_LEGSYS WITH _LEGSYS
       IF SUBSTR(_DADOVE,1,8) = 'PRODAVAN'
          *=> INIZIO RINO 18/04/2006
          *REPLACE MOV_QTAMQA WITH M_QTAMQA
          *REPLACE MOV_QTAMLA WITH TROVA_ML_DA_MQ(MOV_ALTEZZ,MOV_QTAMQA)
          *REPLACE MOV_QTAKGA WITH TROVA_KG_DA_MQ(MOV_CODART,MOV_SPESSO,MOV_QTAMQA,1)
          REPLACE MOV_QTAMQA WITH M_QTAMQ
          REPLACE MOV_QTAMLA WITH M_QTAML
          REPLACE MOV_QTAKGA WITH M_QTAKG
          *=> FINE RINO 18/04/2006
          SELECT U_MAG_MO
       ENDIF
       IF EMPTY(ALLTRIM(MOV_ANNO))
          REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
       ENDIF
       REPLACE MOV_CODCLI WITH M_CODCLI
       REPLACE MOV_DESCLI WITH M_DESCLI
       *=> Inizio - Rino 04/10/2004
       REPLACE MOV_FILA_X WITH M.MAG_FILA_X
       REPLACE MOV_PIAN_X WITH M.MAG_PIAN_X
       REPLACE MOV_UBIC_X WITH M.MAG_UBIC_X
       REPLACE MOV_FILA_N WITH M.MAG_FILA_N
       REPLACE MOV_PIAN_N WITH M.MAG_PIAN_N
       REPLACE MOV_UBIC_N WITH M.MAG_UBIC_N
       *=> Fine - Rino 04/10/2004
   	   REPLACE MOV_CODOPE WITH PUB_CODOPE
   	   REPLACE MOV_NOMOPE WITH PUB_NOMOPE
       SCATTER MEMVAR MEMO
       IF !ExecRW(Csql,"U_MAG_MO","W")
          return(.f.)
       ENDIF
       **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
       DO GESTIONE_SALDI_MOV
   ELSE
   		Csql = "select * from u_mag_mo where 1=0"
   		IF !ExecRW(Csql,"U_MAG_MO","R")
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
   		IF M.MAG_QTAMQ > 0
   		   REPLACE MOV_QTAMQ WITH M_QTAFOR
   		ELSE
           REPLACE MOV_QTAMQ  WITH M_QTAMQ
   		ENDIF
        REPLACE MOV_QTAML  WITH M_QTAML
        REPLACE MOV_QTAKG  WITH M_QTAKG
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
        IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
           REPLACE MOV_QTAMQ  WITH 0
           REPLACE MOV_QTAKG  WITH 0
           REPLACE MOV_QTAML  WITH 0
           REPLACE MOV_QTAMQA WITH 0
           REPLACE MOV_QTAMLA WITH 0
           REPLACE MOV_QTAKGA WITH 0
           M_QTAMQA = 0
        ENDIF
	    IF MOV_TOP = PUB_CAUREF .AND. MOV_QTAKG > 0
           REPLACE MOV_VALVEN WITH 0
	       REPLACE MOV_VALACQ WITH ROUND((MOV_QTAKG * MOV_PREACQ),2)
        ELSE
           REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
	       REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
	    ENDIF
   	    IF EMPTY(ALLTRIM(_NUMDOC))
   	    ELSE
   	       REPLACE MOV_NUMDOC WITH _NUMDOC
   	    ENDIF
   	    IF EMPTY(ALLTRIM(_DATDOC)) .OR. _DATDOC = '  /  /    ' .OR. _DATDOC = '    /  /  ' 
   	    ELSE
   	       REPLACE MOV_DTDOCU WITH _DATDOC
   	    ENDIF
   	    IF EMPTY(ALLTRIM(M_DATREG)) .OR. M_DATREG = '  /  /    ' .OR. M_DATREG = '    /  /  ' 
   	       REPLACE MOV_DTREGI WITH _DATAOGGI
   	    ELSE
           REPLACE MOV_DTREGI WITH M_DATREG
        ENDIF
        REPLACE MOV_DATSCA WITH RIN_DATSCAR
   		REPLACE MOV_CODFOR WITH M.MAG_FORNIT
   		REPLACE MOV_RAGSOC WITH M.MAG_DESFOR
   		REPLACE MOV_CODTAG WITH A_CODTAG
   		REPLACE MOV_DESTAG WITH A_DESTAG
   		REPLACE MOV_CODCOL WITH M.MAG_CODCOL
   		REPLACE MOV_DESCOL WITH M.MAG_DESCOL
   		REPLACE MOV_CODMAT WITH M.MAG_CODMAT
   		REPLACE MOV_DESMAT WITH M.MAG_DESMAT
   		REPLACE MOV_NOTVAR WITH _NOTE
   		REPLACE MOV_UM     WITH A_UNIMIS
        IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
        ELSE
           REPLACE MOV_UM WITH 'MQ'
        ENDIF
   		REPLACE MOV_CODPDV WITH M_CODPDV				
   		REPLACE MOV_ORAMOV WITH _ORAMOV					
   		REPLACE MOV_SEGNO  WITH X_SEGNO					
   		REPLACE MOV_TIPMOV WITH V_TMOV				
   		REPLACE MOV_FORNIT WITH M_FORNIT
   		REPLACE MOV_DESFOR WITH M_DESFOR
   		REPLACE MOV_COORD  WITH A_COORD
   		REPLACE MOV_FLGTRA WITH _FLGTRA
   		REPLACE MOV_LEGSYS WITH _LEGSYS
   		REPLACE MOV_CODCAS WITH _CODCAS
   		REPLACE MOV_LEGAME WITH QWE_LEGAME
   		REPLACE MOV_PAGAME WITH QWE_PAGAME
   		REPLACE MOV_CODACQ WITH QWE_CODACQ
   		REPLACE MOV_NUMORF WITH QWE_NUMORF
   		REPLACE MOV_DATORF WITH QWE_DATORF
   		REPLACE MOV_SC1    WITH QWE_SC1
   		REPLACE MOV_SC2    WITH QWE_SC2
   		REPLACE MOV_SC3    WITH QWE_SC3
   		REPLACE MOV_NUMIDE WITH QWE_NUMIDE
   		REPLACE MOV_CODBUN WITH QWE_CODBUN
        IF EMPTY(ALLTRIM(QWE_ANNO))
           REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
        ENDIF
   		REPLACE MOV_UNIQUE WITH SYS(2015)
   		REPLACE MOV_CODOPE WITH PUB_CODOPE
   		REPLACE MOV_NOMOPE WITH PUB_NOMOPE
   		REPLACE MOV_NUMCAM WITH PUB_NUMCAM
   		REPLACE MOV_DATCAM WITH PUB_DATCAM
   		REPLACE MOV_INICAM WITH PUB_INICAM
   		REPLACE MOV_FINCAM WITH PUB_FINCAM
   		REPLACE MOV_SC1CAM WITH PUB_SC1CAM
   		REPLACE MOV_SC2CAM WITH PUB_SC2CAM
   		REPLACE MOV_SC3CAM WITH PUB_SC3CAM
   		REPLACE MOV_SC4CAM WITH PUB_SC4CAM
   		REPLACE MOV_SC5CAM WITH PUB_SC5CAM
   		REPLACE MOV_FISCAM WITH PUB_FISCAM
   		REPLACE MOV_PRZCAM WITH PUB_PRZCAM
        REPLACE MOV_SPESSO WITH M.MAG_SPESSO 
        REPLACE MOV_ALTEZZ WITH M.MAG_ALTEZZ
        REPLACE MOV_LUNGHE WITH M_QTAML
        REPLACE MOV_NRLINT WITH M.MAG_NRLINT
        REPLACE MOV_NRDBOB WITH M.MAG_NRDBOB
        REPLACE MOV_CDAFOR WITH M.MAG_CDAFOR
        REPLACE MOV_OINFOR WITH M.MAG_OINFOR
        REPLACE MOV_PINFOR WITH M.MAG_PINFOR
        REPLACE MOV_DTPFOR WITH M.MAG_DTPFOR
        REPLACE MOV_TRAFOR WITH M.MAG_TRAFOR
        REPLACE MOV_NBAFOR WITH M.MAG_NBAFOR
        REPLACE MOV_BDAFOR WITH M.MAG_BDAFOR
        REPLACE MOV_BALFOR WITH M.MAG_BALFOR
        REPLACE MOV_PNKFOR WITH M.MAG_PNKFOR
        REPLACE MOV_ANAART WITH M.MAG_ANAART
        REPLACE MOV_DTINCQ WITH M.MAG_DTINCQ
        REPLACE MOV_ORINCQ WITH M.MAG_ORINCQ
        REPLACE MOV_DTFICQ WITH M.MAG_DTFICQ
        REPLACE MOV_ORFICQ WITH M.MAG_ORFICQ
        REPLACE MOV_CDRECQ WITH M.MAG_CDRECQ
        REPLACE MOV_DSRECQ WITH M.MAG_DSRECQ
        REPLACE MOV_QTAKGA WITH M.MAG_QTAKGA
        REPLACE MOV_QTAMQA WITH M.MAG_QTAMQA
        REPLACE MOV_QTAMLA WITH M.MAG_QTAMLA
        REPLACE MOV_TIPART WITH M.MAG_TIPART
        REPLACE MOV_SERIE  WITH M.MAG_SERIE
        REPLACE MOV_AAPROD WITH M.MAG_AAPROD
        REPLACE MOV_QTACON WITH M.MAG_QTACON
        REPLACE MOV_SERBOL WITH M.MAG_SERBOL
        REPLACE MOV_SERNUM WITH M.MAG_SERNUM
        REPLACE MOV_NUMEDA WITH M.MAG_NUMEDA
        REPLACE MOV_NUMEAL WITH M.MAG_NUMEAL
        REPLACE MOV_CBFISC WITH M.MAG_CBFISC
        IF EMPTY(ALLTRIM(MOV_ANNO))
           REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
        ENDIF
        IF SUBSTR(_DADOVE,1,8) = 'PRODAVAN'
          *=> INIZIO RINO 18/04/2006
          *REPLACE MOV_QTAMQA WITH M_QTAMQA
          *REPLACE MOV_QTAMLA WITH TROVA_ML_DA_MQ(MOV_ALTEZZ,MOV_QTAMQA)
          *REPLACE MOV_QTAKGA WITH TROVA_KG_DA_MQ(MOV_CODART,MOV_SPESSO,MOV_QTAMQA,1)
          REPLACE MOV_QTAMQA WITH M_QTAMQ
          REPLACE MOV_QTAMLA WITH M_QTAML
          REPLACE MOV_QTAKGA WITH M_QTAKG
          *=> FINE RINO 18/04/2006
           SELECT U_MAG_MO
        ENDIF
        REPLACE MOV_FLGCEL WITH .F.
        REPLACE MOV_CODCLI WITH M_CODCLI
        REPLACE MOV_DESCLI WITH M_DESCLI
        REPLACE MOV_CSTMAN WITH M.MAG_CSTMAN
        REPLACE MOV_CSTSCA WITH M.MAG_CSTSCA
       *=> Inizio - Rino 04/10/2004
       REPLACE MOV_FILA_X WITH M.MAG_FILA_X
       REPLACE MOV_PIAN_X WITH M.MAG_PIAN_X
       REPLACE MOV_UBIC_X WITH M.MAG_UBIC_X
       REPLACE MOV_FILA_N WITH M.MAG_FILA_N
       REPLACE MOV_PIAN_N WITH M.MAG_PIAN_N
       REPLACE MOV_UBIC_N WITH M.MAG_UBIC_N
       *=> Fine - Rino 04/10/2004
       RELEASE P_TIPO
       PUBLIC  P_TIPO
       P_TIPO = CERCATIPO(MOV_ANAART)
       SELECT U_MAG_MO
       IF P_TIPO = '3'	&& GESTIONE MANDRINI
          P_VALACQ = ROUND(((MOV_ALTEZZ / 1000) * MOV_PREACQ),2)
	      REPLACE MOV_VALACQ WITH P_VALACQ
       ENDIF
       REPLACE MOV_NUMMOV WITH PUB_NUMCSI				&& RINO 20/10/2006
   		SCATTER MEMVAR MEMO
        IF !ExecRW(Csql,"U_MAG_MO","W")
           return(.f.)
        ENDIF
        **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
        DO GESTIONE_SALDI_MOV
   ENDIF
   IF EMPTY(ALLTRIM(_MAG1))
   ELSE
      Csql = "select * from u_mag_mo where 1=0"
      IF !ExecRW(cSql,"U_MAG_MO","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_MO
      APPEND BLANK
      DO U_MAG_MO
      REPLACE MOV_CODMAG WITH _MAG1
      REPLACE MOV_TOP    WITH _TOP1
      REPLACE MOV_SEGNO  WITH X_SEGNO1					
      REPLACE MOV_TIPMOV WITH V_TMOV1				
      REPLACE MOV_UNIQUE WITH SYS(2015)
      IF EMPTY(ALLTRIM(MOV_ANNO))
         REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
      ENDIF
      *=> Inizio - Rino 04/10/2004
      REPLACE MOV_FILA_X WITH PUB_FILDES_X
      REPLACE MOV_PIAN_X WITH PUB_PIADES_X
      REPLACE MOV_UBIC_X WITH PUB_UBIDES_X
      REPLACE MOV_FILA_N WITH PUB_FILDES_N
      REPLACE MOV_PIAN_N WITH PUB_PIADES_N
      REPLACE MOV_UBIC_N WITH PUB_UBIDES_N
      *=> Fine - Rino 04/10/2004
      IF !ExecRW(cSql,"U_MAG_MO","W")
         return(.f.)
      ENDIF
      **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
      M.MOV_CODMAG = _MAG1
      M.MOV_TOP    = _TOP1
      M.MOV_SEGNO  = X_SEGNO1
      M.MOV_TIPMOV = V_TMOV1
      DO GESTIONE_SALDI_MOV
   ENDIF
ENDIF         

*!*	  SERGIO INIZIO 23/09/2004
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
M.MAG_MATCHC = PUB_CODSOC
_NEW_SEGNO   = " "
=MOVIARTI(ALLTRIM(_CODART),_MAG,_NUMDOC,_DATREG,M_QTAFOR,R_PRZCOS,R_PRZVEN,_TOP,M_FORNIT,M_DESFOR,QWE_CODACQ,"",M.MAG_MATCHC,_NEW_SEGNO)
IF EMPTY(ALLTRIM(_MAG1))
ELSE
   M.MAG_MATCHC = PUB_CODSOC
   _NEW_SEGNO   = " "
   =MOVIARTI(ALLTRIM(_CODART),_MAG1,_NUMDOC,_DATREG,M_QTAFOR,R_PRZCOS,R_PRZVEN,_TOP1,M_FORNIT,M_DESFOR,QWE_CODACQ,"",M.MAG_MATCHC,_NEW_SEGNO)
ENDIF
*!*	  SERGIO FINE 23/09/2004

RETURN


**************************************************************************
PROCEDURE MAGAZZINO_STANDARD	          && SCARICA IL MAGAZZINO STANDARD 
**************************************************************************

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
      IF X_SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + _QUANTI 
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M_QTAMQ 
         REPLACE MAG_QTAML  WITH MAG_QTAML + M_QTAML 
         REPLACE MAG_QTAKG  WITH MAG_QTAKG + M_QTAKG 
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - _QUANTI 
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M_QTAMQ 
         REPLACE MAG_QTAML  WITH MAG_QTAML - M_QTAML 
         REPLACE MAG_QTAKG  WITH MAG_QTAKG - M_QTAKG 
      ENDIF
   ENDIF
   IF _IMPE  = "X"
      IF X_SEGNO = '+'
         REPLACE MAG_IMPORD WITH MAG_IMPORD + _QUANTI
      ELSE
         REPLACE MAG_IMPORD WITH MAG_IMPORD - _QUANTI
      ENDIF
   ENDIF
   IF _DADOVE = 'PRODISBA'
      IF _SAC = 'R'	
      ELSE 					
         IF X_SEGNO = '+'
            REPLACE MAG_QTAIMG WITH MAG_QTAIMG + _QUANTI
         ELSE
            REPLACE MAG_QTAIMG WITH MAG_QTAIMG - _QUANTI
         ENDIF
      ENDIF
   ENDIF 				
ELSE
   APPEND BLANK
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_CODMAG WITH _MAG
   REPLACE MAG_CODART WITH _CODART
   REPLACE MAG_DESART WITH A_DESART
   IF _TIPO = "GIA"	
      IF X_SEGNO = '+'
         REPLACE MAG_GIACEN WITH _QUANTI 
         REPLACE MAG_QTAMQ  WITH M_QTAMQ 
         REPLACE MAG_QTAML  WITH M_QTAML 
         REPLACE MAG_QTAKG  WITH M_QTAKG 
      ELSE
         REPLACE MAG_GIACEN WITH _QUANTI * (-1)
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ * (-1)
         REPLACE MAG_QTAML  WITH MAG_QTAML * (-1)
         REPLACE MAG_QTAKG  WITH MAG_QTAKG * (-1)
      ENDIF
   ENDIF
   IF _IMPE  = "X"
      IF X_SEGNO = '+'
         REPLACE MAG_IMPORD WITH _QUANTI 
      ELSE
         REPLACE MAG_IMPORD WITH _QUANTI * (-1)
      ENDIF
   ENDIF
   IF _DADOVE = 'PRODISBA'
      IF _SAC = 'R'	
      ELSE 					
         IF X_SEGNO = '+'
            REPLACE MAG_QTAIMG WITH _QUANTI
         ELSE
            REPLACE MAG_QTAIMG WITH _QUANTI * (-1)
         ENDIF
      ENDIF
   ENDIF 				
   REPLACE MAG_CODFOR WITH M_FORNIT
   REPLACE MAG_COSTO  WITH A_PRZCOS
   REPLACE MAG_UNIMIS WITH A_UNIMIS
   REPLACE MAG_DTCREA WITH _DATREG
   REPLACE MAG_CODTAG WITH A_CODTAG
   REPLACE MAG_DESTAG WITH A_DESTAG
   REPLACE MAG_CODCOL WITH A_CODCOL
   REPLACE MAG_DESCOL WITH A_DESCOL
   REPLACE MAG_CODPDV WITH M_CODPDV	
   REPLACE MAG_UNIQUE WITH SYS(2015)
ENDIF
REPLACE MAG_FLGTRA WITH .F.
IF _DADOVE  = 'BFOCAMAG'
   REPLACE MAG_CODMAT WITH M.ALT_CODMAT
   REPLACE MAG_DESMAT WITH M.ALT_DESMAT
   REPLACE MAG_CODCOL WITH M.ALT_CODCOL
   REPLACE MAG_DESCOL WITH M.ALT_DESCOL
   REPLACE MAG_SPESSO WITH M.ALT_SPESSO
   REPLACE MAG_ALTEZZ WITH M.ALT_ALTEZZ
   REPLACE MAG_LUNGHE WITH M.ALT_LUNGHE
   REPLACE MAG_NRLINT WITH M.ALT_NRLINT
   REPLACE MAG_NRDBOB WITH M.ALT_NRDBOB
   REPLACE MAG_QTAKG  WITH M.ALT_QTAKG
   REPLACE MAG_QTAMQ  WITH M.ALT_QTAMQ
   REPLACE MAG_QTAML  WITH M.ALT_QTAML
   REPLACE MAG_CDAFOR WITH M.ALT_CDAFOR
   REPLACE MAG_OINFOR WITH M.ALT_OINFOR
   REPLACE MAG_PINFOR WITH M.ALT_PINFOR
   =CAMBIADT(M.ALT_DTPFOR,"MAG_DTPFOR")
   REPLACE MAG_TRAFOR WITH M.ALT_TRAFOR
   REPLACE MAG_NBAFOR WITH M.ALT_NBAFOR
   REPLACE MAG_BDAFOR WITH M.ALT_BDAFOR
   REPLACE MAG_BALFOR WITH M.ALT_BALFOR
   REPLACE MAG_PNKFOR WITH M.ALT_PNKFOR
   REPLACE MAG_ANAART WITH M.ALT_ARTORF
   REPLACE MAG_TIPART WITH M.ALT_TIPART
ENDIF
IF MAG_GIACEN < 0
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_QTAIMP WITH 0
ENDIF
IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
ENDIF
SCATTER MEMVAR MEMO
IF EMPTY(ALLTRIM(PUB_MAGNO0))
ELSE
   IF MAG_GIACEN = 0
      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
      ELSE
         DELETE
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_AN","W")
   return(.f.)
ENDIF

IF EMPTY(ALLTRIM(_MAG1))
ELSE
   x_soci = "mag_codsoc = '" + M.MAG_CODSOC + "'"  
   x_maga = "mag_codmag = '" + ALLTRIM(_MAG1) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MAG_CODART) + "'"
   x_cond = x_soci + " and " + x_maga + " and " + x_codi
   Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
   IF !ExecRW(cSql,"U_MAG_AN","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_AN
   IF RECCOUNT() <> 0
      IF _TIPO = "GIA"
         IF X_SEGNO1 = '+'
            REPLACE MAG_GIACEN WITH MAG_GIACEN + _QUANTI 
            REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M_QTAMQ 
            REPLACE MAG_QTAML  WITH MAG_QTAML + M_QTAML 
            REPLACE MAG_QTAKG  WITH MAG_QTAKG + M_QTAKG 
         ELSE
            REPLACE MAG_GIACEN WITH MAG_GIACEN - _QUANTI 
            REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M_QTAMQ 
            REPLACE MAG_QTAML  WITH MAG_QTAML - M_QTAML 
            REPLACE MAG_QTAKG  WITH MAG_QTAKG - M_QTAKG 
         ENDIF
      ENDIF
      IF _IMPE  = "X"
         IF X_SEGNO1 = '+'
            REPLACE MAG_IMPORD WITH MAG_IMPORD + _QUANTI
         ELSE
            REPLACE MAG_IMPORD WITH MAG_IMPORD - _QUANTI
         ENDIF
      ENDIF
      IF _DADOVE = 'PRODISBA'
         IF _SAC = 'R'	
         ELSE 					
            IF X_SEGNO1 = '+'
               REPLACE MAG_QTAIMG WITH MAG_QTAIMG + _QUANTI
            ELSE
               REPLACE MAG_QTAIMG WITH MAG_QTAIMG - _QUANTI
            ENDIF
         ENDIF
      ENDIF 				
   ELSE
      APPEND BLANK
      DO U_MAG_AN
      REPLACE MAG_CODMAG WITH _MAG1
      IF _TIPO = "GIA"	
         IF X_SEGNO1 = '+'
            REPLACE MAG_GIACEN WITH _QUANTI 
            REPLACE MAG_QTAMQ  WITH M_QTAMQ 
            REPLACE MAG_QTAML  WITH M_QTAML 
            REPLACE MAG_QTAKG  WITH M_QTAKG 
         ELSE
            REPLACE MAG_GIACEN WITH _QUANTI * (-1)
            REPLACE MAG_QTAMQ  WITH M_QTAMQ * (-1) 
            REPLACE MAG_QTAML  WITH M_QTAML * (-1) 
            REPLACE MAG_QTAKG  WITH M_QTAKG * (-1) 
         ENDIF
      ENDIF
      IF _IMPE  = "X"
         IF X_SEGNO1 = '+'
            REPLACE MAG_IMPORD WITH _QUANTI 
         ELSE
            REPLACE MAG_IMPORD WITH _QUANTI * (-1)
         ENDIF
      ENDIF
      IF _DADOVE = 'PRODISBA'
         IF _SAC = 'R'	
         ELSE 					
            IF X_SEGNO1 = '+'
               REPLACE MAG_QTAIMG WITH _QUANTI
            ELSE
               REPLACE MAG_QTAIMG WITH _QUANTI * (-1)
            ENDIF
         ENDIF
      ENDIF 				
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.
   IF MAG_GIACEN < 0
      REPLACE MAG_GIACEN WITH 0
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_QTAIMP WITH 0
   ENDIF
   IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
   ENDIF
   IF _MAG1 = 'VIAGGI'
      IF ZZZ_FLGTIP = 2
         REPLACE MAG_FLGVIA WITH .T.
      ENDIF
   ENDIF
   *=> Inizio - Rino 04/10/2004
   REPLACE MAG_FILA_X WITH PUB_FILDES_X
   REPLACE MAG_PIAN_X WITH PUB_PIADES_X
   REPLACE MAG_UBIC_X WITH PUB_UBIDES_X
   REPLACE MAG_FILA_N WITH PUB_FILDES_N
   REPLACE MAG_PIAN_N WITH PUB_PIADES_N
   REPLACE MAG_UBIC_N WITH PUB_UBIDES_N
   *=> Fine - Rino 04/10/2004
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_AN","W")
      return(.f.)
   ENDIF
ENDIF

IF M_GENMOV = "SI"
   * CREA IL MOVIMENTO DI SCARICO/SCARICO MAGAZZINO --------------------------- 
   Csql   = "select * from u_mag_mo where 1=0"
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
   REPLACE MOV_TIPMOV WITH V_TMOV				
   REPLACE MOV_FORNIT WITH M_FORNIT
   REPLACE MOV_DESFOR WITH M_DESFOR
   REPLACE MOV_COORD  WITH A_COORD
   REPLACE MOV_FLGTRA WITH _FLGTRA
   REPLACE MOV_LEGSYS WITH _LEGSYS
   REPLACE MOV_CODCAS WITH _CODCAS
   REPLACE MOV_UNIQUE WITH SYS(2015)
   REPLACE MOV_CODOPE WITH PUB_CODOPE
   REPLACE MOV_NOMOPE WITH PUB_NOMOPE
   IF _DADOVE  = 'BFOCAMAG'
      REPLACE MOV_CODMAT WITH M.ALT_CODMAT
      REPLACE MOV_DESMAT WITH M.ALT_DESMAT
      REPLACE MOV_CODCOL WITH M.ALT_CODCOL
      REPLACE MOV_DESCOL WITH M.ALT_DESCOL
      REPLACE MOV_SPESSO WITH M.ALT_SPESSO
      REPLACE MOV_ALTEZZ WITH M.ALT_ALTEZZ
      REPLACE MOV_LUNGHE WITH M.ALT_LUNGHE
      REPLACE MOV_NRLINT WITH M.ALT_NRLINT
      REPLACE MOV_NRDBOB WITH M.ALT_NRDBOB
      REPLACE MOV_QTAKG  WITH M.ALT_QTAKG
      REPLACE MOV_QTAMQ  WITH M.ALT_QTAMQ
      REPLACE MOV_QTAML  WITH M.ALT_QTAML
      REPLACE MOV_CDAFOR WITH M.ALT_CDAFOR
      REPLACE MOV_OINFOR WITH M.ALT_OINFOR
      REPLACE MOV_PINFOR WITH M.ALT_PINFOR
      =CAMBIADT(M.ALT_DTPFOR,"MOV_DTPFOR")
      REPLACE MOV_TRAFOR WITH M.ALT_TRAFOR
      REPLACE MOV_NBAFOR WITH M.ALT_NBAFOR
      REPLACE MOV_BDAFOR WITH M.ALT_BDAFOR
      REPLACE MOV_BALFOR WITH M.ALT_BALFOR
      REPLACE MOV_PNKFOR WITH M.ALT_PNKFOR
      REPLACE MOV_ANAART WITH M.ALT_ARTORF
      REPLACE MOV_TIPART WITH M.ALT_TIPART
      REPLACE MOV_FLGCEL WITH M.ALT_FLGCEL
      REPLACE MOV_QTACON WITH M.ALT_QTACON
      REPLACE MOV_SERIE  WITH M.ALT_SERIE
      REPLACE MOV_SERBOL WITH M.ALT_SERBOL
      REPLACE MOV_SERNUM WITH M.ALT_SERNUM
      REPLACE MOV_NUMEDA WITH M.ALT_NUMEDA
      REPLACE MOV_NUMEAL WITH M.ALT_NUMEAL
      REPLACE MOV_AAPROD WITH M.ALT_AAPROD
      REPLACE MOV_CBFISC WITH M.ALT_CBFISC
   ENDIF
   REPLACE MOV_LUNGHE WITH MOV_QTAML
   IF EMPTY(ALLTRIM(MOV_ANNO))
      REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
   ENDIF
   REPLACE MOV_FLGCEL WITH .F.
   REPLACE MOV_QTACON WITH 0
   REPLACE MOV_NUMEDA WITH 0
   REPLACE MOV_NUMEAL WITH 0
   REPLACE MOV_CODCLI WITH M_CODCLI
   REPLACE MOV_DESCLI WITH M_DESCLI
   IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
      REPLACE MOV_QTAMQ  WITH 0
      REPLACE MOV_QTAKG  WITH 0
      REPLACE MOV_QTAML  WITH 0
      REPLACE MOV_QTAMQA WITH 0
      REPLACE MOV_QTAMLA WITH 0
      REPLACE MOV_QTAKGA WITH 0
   ENDIF
   REPLACE MOV_CSTMAN WITH M.MAG_CSTMAN
   REPLACE MOV_CSTSCA WITH M.MAG_CSTSCA
   RELEASE P_TIPO
   PUBLIC  P_TIPO
   P_TIPO = CERCATIPO(MOV_ANAART)
   SELECT U_MAG_MO
   IF P_TIPO = '3'	&& GESTIONE MANDRINI
      P_VALACQ = ROUND(((MOV_ALTEZZ / 1000) * MOV_PREACQ),2)
      REPLACE MOV_VALACQ WITH P_VALACQ
   ENDIF
   *=> Inizio - Rino 04/10/2004
   REPLACE MOV_FILA_X WITH M.MAG_FILA_X
   REPLACE MOV_PIAN_X WITH M.MAG_PIAN_X
   REPLACE MOV_UBIC_X WITH M.MAG_UBIC_X
   REPLACE MOV_FILA_N WITH M.MAG_FILA_N
   REPLACE MOV_PIAN_N WITH M.MAG_PIAN_N
   REPLACE MOV_UBIC_N WITH M.MAG_UBIC_N
   *=> Fine - Rino 04/10/2004
   REPLACE MOV_NUMMOV WITH PUB_NUMCSI				&& RINO 20/10/2006
   SCATTER MEMVAR MEMO
   IF !ExecRW(cSql,"U_MAG_MO","W")
      return(.f.)
   ENDIF
   **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
   DO GESTIONE_SALDI_MOV
   IF EMPTY(ALLTRIM(_MAG1))
   ELSE
      Csql   = "select * from u_mag_mo where 1=0"
      IF !ExecRW(cSql,"U_MAG_MO","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_MO
      APPEND BLANK
      DO U_MAG_MO
      REPLACE MOV_CODMAG WITH _MAG1
      REPLACE MOV_TOP    WITH _TOP1
      REPLACE MOV_SEGNO  WITH X_SEGNO1					
      REPLACE MOV_TIPMOV WITH V_TMOV1				
      REPLACE MOV_UNIQUE WITH SYS(2015)
      *=> Inizio - Rino 04/10/2004
      REPLACE MOV_FILA_X WITH PUB_FILDES_X
      REPLACE MOV_PIAN_X WITH PUB_PIADES_X
      REPLACE MOV_UBIC_X WITH PUB_UBIDES_X
      REPLACE MOV_FILA_N WITH PUB_FILDES_N
      REPLACE MOV_PIAN_N WITH PUB_PIADES_N
      REPLACE MOV_UBIC_N WITH PUB_UBIDES_N
      *=> Fine - Rino 04/10/2004
      IF EMPTY(ALLTRIM(MOV_ANNO))
         REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
      ENDIF
      IF !ExecRW(cSql,"U_MAG_MO","W")
         return(.f.)
      ENDIF
      **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
      M.MOV_CODMAG = _MAG1
      M.MOV_TOP    = _TOP1
      M.MOV_SEGNO  = X_SEGNO1					
      M.MOV_TIPMOV = V_TMOV1				
      DO GESTIONE_SALDI_MOV
   ENDIF
ENDIF


RETURN


*****************************************************************
PROCEDURE GESTIONE_CARICA_MAGA	          && CARICA IL MAGAZZINO 
*****************************************************************

*SET STEP ON 

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

x_dove = "alt_dadove = '" + ALLTRIM(_DADOVE) + "'"
x_maga = "alt_codmag = '" + ALLTRIM(_MAGSCA) + "'"
x_csys = "alt_legame = '" + ALLTRIM(_LEGAME) + "'"
x_cond = x_dove + " and " + x_maga + " and " + x_csys
cSql   = "SELECT * FROM U_ALT_DA WHERE " + x_cond
IF !ExecCommand(cSql,"U_ALT_DA")
   return(.f.)
ENDIF 
SELECT U_ALT_DA
GO TOP
SCATTER MEMVAR

IF _DADOVE  = 'BFOCAMAG'
   **=> ERASMO - INIZIO 17/09/2010
   *** LE GIACENZE FISCALI DEVONO ESSERE INDIVIDUATE CON IL CODICE ARTICOLO INTERNO
   IF ALLTRIM(ALT_SERIE) = 'ZI' .OR. ALT_FLGCEL
      _CODART  = M.ALT_CODART
   ENDIF
   **=> ERASMO - FINE 17/09/2010
   IF M.ALT_ALTEZZ > 0 .AND. M.ALT_LUNGHE = 0
      M_QTAFOR = M.ALT_NUMBOB
      _QUANTI  = M.ALT_NUMBOB
   ENDIF
   IF M.ALT_QTAKG > 0
      _CODART  = M.ALT_CODART
      M_QTAFOR = M.ALT_QTAKG
      _QUANTI  = M.ALT_QTAKG
      IF M.ALT_UMMAGA = 'KG'
         M_QTAFOR = M.ALT_QTAKG
         _QUANTI  = M.ALT_QTAKG
      ENDIF    
      IF M.ALT_UMMAGA = 'MQ'
         M_QTAFOR = M.ALT_QTAMQ
         _QUANTI  = M.ALT_QTAMQ
      ENDIF    
      IF M.ALT_UMMAGA = 'ML'
         M_QTAFOR = M.ALT_QTAML
         _QUANTI  = M.ALT_QTAML
      ENDIF    
   ENDIF
ENDIF

*-->> RICERCA DEL CODICE PDV DEL CLIENTE
RELEASE CS_CODPDV
PUBLIC  CS_CODPDV
x_cond = "pdv_codcli = '" + ALLTRIM(M.ALT_CODCLI) + "'"
Csql   = "select * from u_pdv_an where " + x_cond
IF !ExecCommand(Csql,"CU_PDV_AN")
   return(.f.)
ENDIF
SELECT CU_PDV_AN
GO TOP
IF EOF()
   CS_CODPDV = PUB_CODBUN
ELSE
   CS_CODPDV = PDV_CODICE
ENDIF         

**=> ERASMO - INIZIO 13/12/2010
IF PUB_GGDTSP
	*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
	*=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
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
	   REPLACE MAG_GIACEN WITH MAG_GIACEN + M_QTAFOR
	ELSE
	   APPEND BLANK
	   REPLACE MAG_CODSOC WITH PUB_CODSOC
	   REPLACE MAG_CODMAG WITH _MAG
	   REPLACE MAG_CODART WITH _CODART
	   REPLACE MAG_DESART WITH A_DESART
	   REPLACE MAG_CODPDV WITH PUB_CODBUN
	   REPLACE MAG_FORNIT WITH M_FORNIT
	   REPLACE MAG_DESFOR WITH M_DESFOR
	   REPLACE MAG_GIACEN WITH M_QTAFOR
	   REPLACE MAG_UNIQUE WITH SYS(2015)
	ENDIF
	REPLACE MAG_FLGTRA WITH .F.
	M_GIAFOR = MAG_GIACEN

	IF _DADOVE  = 'BFOCAMAG'
	   REPLACE MAG_CODMAT WITH M.ALT_CODMAT
	   REPLACE MAG_DESMAT WITH M.ALT_DESMAT
	   REPLACE MAG_CODCOL WITH M.ALT_CODCOL
	   REPLACE MAG_DESCOL WITH M.ALT_DESCOL
	   REPLACE MAG_SPESSO WITH M.ALT_SPESSO
	   REPLACE MAG_ALTEZZ WITH M.ALT_ALTEZZ
	   REPLACE MAG_LUNGHE WITH M.ALT_LUNGHE
	   REPLACE MAG_NRLINT WITH M.ALT_NRLINT
	   REPLACE MAG_NRDBOB WITH M.ALT_NRDBOB
	   REPLACE MAG_QTAKG  WITH M.ALT_QTAKG
	   REPLACE MAG_QTAMQ  WITH M.ALT_QTAMQ
	   REPLACE MAG_QTAML  WITH M.ALT_QTAML
	   REPLACE MAG_CDAFOR WITH M.ALT_CDAFOR
	   REPLACE MAG_OINFOR WITH M.ALT_OINFOR
	   REPLACE MAG_PINFOR WITH M.ALT_PINFOR
	   =CAMBIADT(M.ALT_DTPFOR,"MAG_DTPFOR")
	   REPLACE MAG_TRAFOR WITH M.ALT_TRAFOR
	   REPLACE MAG_NBAFOR WITH M.ALT_NBAFOR
	   REPLACE MAG_BDAFOR WITH M.ALT_BDAFOR
	   REPLACE MAG_BALFOR WITH M.ALT_BALFOR
	   REPLACE MAG_PNKFOR WITH M.ALT_PNKFOR
	   REPLACE MAG_ANAART WITH M.ALT_ARTORF
	   REPLACE MAG_TIPART WITH M.ALT_TIPART
	   REPLACE MAG_FLGRIB WITH M.ALT_FLGRIB
	   REPLACE MAG_FLGIMB WITH M.ALT_FLGIMB

	   REPLACE MAG_FLGCEL WITH M.ALT_FLGCEL
	   REPLACE MAG_QTACON WITH M.ALT_QTACON
	   REPLACE MAG_SERIE  WITH M.ALT_SERIE
	   REPLACE MAG_SERBOL WITH M.ALT_SERBOL
	   REPLACE MAG_SERNUM WITH M.ALT_SERNUM
	   REPLACE MAG_NUMEDA WITH M.ALT_NUMEDA
	   REPLACE MAG_NUMEAL WITH M.ALT_NUMEAL
	   REPLACE MAG_AAPROD WITH M.ALT_AAPROD
	   REPLACE MAG_CBFISC WITH M.ALT_CBFISC

	ENDIF

	SCATTER MEMVAR MEMO
	IF !ExecRw(cSql,"U_MAG_GG","W")
	   return(.f.)
	ENDIF

	IF EMPTY(ALLTRIM(_MAG1))
	ELSE
	   x_soci = "mag_codsoc = '" + M.MAG_CODSOC + "'"
	   x_data = "mag_datagg = '" + SPACE(10) + "'"
	   x_codi = "mag_codart = '" + ALLTRIM(M.MAG_CODART) + "'"
	   x_maga = "mag_codmag = '" + ALLTRIM(_MAG1) + "'"
	   x_forn = "mag_fornit = '" + ALLTRIM(M.MAG_FORNIT) + "'"
	   x_cpdv = "mag_codpdv = '" + ALLTRIM(CS_CODPDV) + "'"
	   IF _MAG1 = 'VIAGGI'
	      M.MAG_CODPDV = CS_CODPDV
	      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_cpdv
	   ELSE
	      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
	   ENDIF
	   Csql   = "select * from u_mag_gg where " + x_cond 
	   IF !ExecRW(cSql,"U_MAG_GG","R")
	      return(.f.)
	   ENDIF
	   SELECT U_MAG_GG
	   GO TOP       
	   IF EOF()
	      APPEND BLANK
	      DO U_MAG_GG
	      REPLACE MAG_CODMAG WITH _MAG1
	      REPLACE MAG_GIACEN WITH M_QTAFOR * -1
	      REPLACE MAG_UNIQUE WITH SYS(2015)
	   ELSE
	      REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QTAFOR
	   ENDIF
	   REPLACE MAG_FLGTRA WITH .F.
	   REPLACE MAG_FLGVIA WITH .F.
	   IF _MAG1 = 'VIAGGI'
	      IF ZZZ_FLGTIP = 2
	         REPLACE MAG_FLGVIA WITH .T.
	      ENDIF
	   ENDIF
	   QWE_SYSGGS = MAG_UNIQUE
	   IF !ExecRW(cSql,"U_MAG_GG","W")
	      return(.f.)
	   ENDIF
	ENDIF
ENDIF
**=> ERASMO - FINE 13/12/2010

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
IF ALLTRIM(_MAGSCA) = '004'
   x_data = "mag_datagg = '" + _DATREG + "'"
ELSE
   x_data = "mag_datagg = '" + _DATDOC + "'"
ENDIF
IF PUB_DAINVE_PDA
   x_data = "mag_datagg = '" + _DATREG + "'"
ENDIF
x_codi = "mag_codart = '" + ALLTRIM(_CODART) + "'"
x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
x_forn = "mag_fornit = '" + ALLTRIM(M_FORNIT) + "'"
x_tipo = "mag_codacq = '" + ALLTRIM(M.ALT_CODACQ) + "'"
IF _PRZACQ = 0
   XXX_PRZACQ = A_PRZCOS
   XX_PRZACQ  = ALLTRIM(STR(A_PRZCOS,17,6))
ELSE
   XXX_PRZACQ = _PRZACQ
   XX_PRZACQ  = ALLTRIM(STR(_PRZACQ,17,6))
ENDIF
XX_PRZACQ = STRTRAN(XX_PRZACQ,",",".")
x_prez = "mag_przcon = " + XX_PRZACQ
x_cide = "mag_numide = '" + ALLTRIM(M.ALT_NUMIDE) + "'"
x_cpdv = "mag_codbun = '" + ALLTRIM(M.ALT_CODBUN) + "'"
x_anno = "mag_anno = mag_anno"
x_fila = "mag_fila_n = " + ALLTRIM(STR(PUB_FILCAR_N,5,0))
x_pian = "mag_pian_n = " + ALLTRIM(STR(PUB_PIACAR_N,5,0))
x_ubic = "mag_ubic_n = " + ALLTRIM(STR(PUB_UBICAR_N,5,0))
x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
         x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
         x_cpdv + " and " + x_anno + " and " + x_fila + " and " + x_pian + " and " + x_ubic

Csql   = "select * from u_mag_gg where " + x_cond 
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
   IF ALLTRIM(_MAGSCA) = '004'
      REPLACE MAG_DATAGG WITH _DATREG
   ELSE
      REPLACE MAG_DATAGG WITH _DATDOC
   ENDIF
   IF PUB_DAINVE_PDA
      REPLACE MAG_DATAGG WITH _DATREG
   ENDIF
   REPLACE MAG_CODMAG WITH _MAG
   REPLACE MAG_CODART WITH _CODART
   REPLACE MAG_DESART WITH A_DESART
   REPLACE MAG_CODPDV WITH PUB_CODBUN
   REPLACE MAG_FORNIT WITH M_FORNIT
   REPLACE MAG_DESFOR WITH M_DESFOR
   IF X_SEGNO = '+'
      REPLACE MAG_GIACEN WITH M_QTAFOR
   ELSE
      REPLACE MAG_GIACEN WITH M_QTAFOR * -1
   ENDIF
   REPLACE MAG_PRZCON WITH XXX_PRZACQ
   REPLACE MAG_LEGAME WITH M.ALT_LEGAME
   REPLACE MAG_CODACQ WITH M.ALT_CODACQ
   REPLACE MAG_DESACQ WITH M.ALT_DESACQ
   REPLACE MAG_PRZUFF WITH XXX_PRZACQ
   REPLACE MAG_DATINI WITH SPACE(10)
   REPLACE MAG_DATFIN WITH SPACE(10)
   REPLACE MAG_SC1    WITH 0
   REPLACE MAG_SC2    WITH 0
   REPLACE MAG_SC3    WITH 0
   REPLACE MAG_SC4    WITH 0
   REPLACE MAG_SC5    WITH 0
   REPLACE MAG_PRZSCO WITH 0
   REPLACE MAG_PAGAME WITH M.ALT_PAGAME
   REPLACE MAG_NUMIDE WITH M.ALT_NUMIDE
   REPLACE MAG_CODBUN WITH M.ALT_CODBUN
   REPLACE MAG_ANNO   WITH M.ALT_ANNO
   IF EMPTY(ALLTRIM(MAG_ANNO))
      REPLACE MAG_ANNO WITH SUBSTR(MAG_DATAGG,1,4)
   ENDIF
   REPLACE MAG_UNIQUE WITH SYS(2015)
   REPLACE MAG_TIPART WITH M.ALT_TIPART
ENDIF
IF X_SEGNO = '+'
   REPLACE MAG_LEGSYS WITH _LEGSYS
ENDIF
IF MAG_NRLINT > 50000000 
   REPLACE MAG_FLGRIB WITH .T.
ENDIF
REPLACE MAG_FLGTRA WITH .F.
IF _DADOVE  = 'BFOCAMAG'
   REPLACE MAG_CODMAT WITH M.ALT_CODMAT
   REPLACE MAG_DESMAT WITH M.ALT_DESMAT
   REPLACE MAG_CODCOL WITH M.ALT_CODCOL
   REPLACE MAG_DESCOL WITH M.ALT_DESCOL
   REPLACE MAG_SPESSO WITH M.ALT_SPESSO
   REPLACE MAG_ALTEZZ WITH M.ALT_ALTEZZ
   REPLACE MAG_LUNGHE WITH M.ALT_LUNGHE
   REPLACE MAG_NRLINT WITH M.ALT_NRLINT
   REPLACE MAG_NRDBOB WITH M.ALT_NRDBOB
   REPLACE MAG_QTAKG  WITH M.ALT_QTAKG
   REPLACE MAG_QTAMQ  WITH M.ALT_QTAMQ
   REPLACE MAG_QTAML  WITH M.ALT_QTAML
   REPLACE MAG_CDAFOR WITH M.ALT_CDAFOR
   REPLACE MAG_OINFOR WITH M.ALT_OINFOR
   REPLACE MAG_PINFOR WITH M.ALT_PINFOR
   =CAMBIADT(M.ALT_DTPFOR,"MAG_DTPFOR")
   REPLACE MAG_TRAFOR WITH M.ALT_TRAFOR
   REPLACE MAG_NBAFOR WITH M.ALT_NBAFOR
   REPLACE MAG_BDAFOR WITH M.ALT_BDAFOR
   REPLACE MAG_BALFOR WITH M.ALT_BALFOR
   REPLACE MAG_PNKFOR WITH M.ALT_PNKFOR
   REPLACE MAG_ANAART WITH M.ALT_ARTORF
   REPLACE MAG_TIPART WITH M.ALT_TIPART
   REPLACE MAG_FLGRIB WITH M.ALT_FLGRIB
   REPLACE MAG_FLGIMB WITH M.ALT_FLGIMB
   
   REPLACE MAG_FLGCEL WITH M.ALT_FLGCEL
   REPLACE MAG_QTACON WITH M.ALT_QTACON
   REPLACE MAG_SERIE  WITH M.ALT_SERIE
   REPLACE MAG_SERBOL WITH M.ALT_SERBOL
   REPLACE MAG_SERNUM WITH M.ALT_SERNUM
   REPLACE MAG_NUMEDA WITH M.ALT_NUMEDA
   REPLACE MAG_NUMEAL WITH M.ALT_NUMEAL
   REPLACE MAG_AAPROD WITH M.ALT_AAPROD
   REPLACE MAG_CBFISC WITH M.ALT_CBFISC
ENDIF
IF MAG_GIACEN < 0
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_QTAIMP WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF
IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF
*=> Inizio - Rino 04/10/2004
REPLACE MAG_FILA_X WITH PUB_FILCAR_X
REPLACE MAG_PIAN_X WITH PUB_PIACAR_X
REPLACE MAG_UBIC_X WITH PUB_UBICAR_X
REPLACE MAG_FILA_N WITH PUB_FILCAR_N
REPLACE MAG_PIAN_N WITH PUB_PIACAR_N
REPLACE MAG_UBIC_N WITH PUB_UBICAR_N
*=> Fine - Rino 04/10/2004
SCATTER MEMVAR MEMO
XXY_UNIQUE = M.MAG_UNIQUE  && ERASMO - 23/02/2011
RELEASE QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME,   ;
        QWE_LEGSYS,QWE_NUMORF,QWE_DATORF,QWE_SC1,QWE_SC2,QWE_SC3,QWE_NUMIDE,QWE_CODBUN, ;
        QWE_ANNO
PUBLIC  QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME,   ;
        QWE_LEGSYS,QWE_NUMORF,QWE_DATORF,QWE_SC1,QWE_SC2,QWE_SC3,QWE_NUMIDE,QWE_CODBUN, ;
        QWE_ANNO
QWE_FORNIT = MAG_FORNIT
QWE_DESFOR = MAG_DESFOR
QWE_CODACQ = MAG_CODACQ
QWE_DESACQ = MAG_DESACQ
QWE_PRZCON = MAG_PRZCON
QWE_PAGAME = MAG_PAGAME
QWE_LEGAME = MAG_LEGAME
QWE_LEGSYS = MAG_LEGSYS
QWE_NUMORF = SPACE(06)
QWE_DATORF = SPACE(10)
QWE_SC1    = 0
QWE_SC2    = 0
QWE_SC3    = 0
QWE_NUMIDE = MAG_NUMIDE
QWE_CODBUN = MAG_CODBUN
QWE_ANNO   = MAG_ANNO
IF EMPTY(ALLTRIM(PUB_MAGNO0))
ELSE
   IF MAG_GIACEN = 0
      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
      ELSE
         DELETE
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF

IF EMPTY(ALLTRIM(_MAG1))
ELSE
   x_soci      = "mag_codsoc = '" + M.MAG_CODSOC + "'"
   x_data      = "mag_datagg = '" + M.MAG_DATAGG + "'"
   x_codi      = "mag_codart = '" + ALLTRIM(M.MAG_CODART) + "'"
   x_maga      = "mag_codmag = '" + ALLTRIM(_MAG1) + "'"
   x_forn      = "mag_fornit = '" + ALLTRIM(M.MAG_FORNIT) + "'"
   XXX_PRZACQ  = M.MAG_PRZCON
   XX_PRZACQ   = ALLTRIM(STR(M.MAG_PRZCON,17,6))
   XX_PRZACQ   = STRTRAN(XX_PRZACQ,",",".")
   x_prez      = "mag_przcon = " + XX_PRZACQ
   x_tipo      = "mag_codacq = '" + ALLTRIM(QWE_CODACQ) + "'"
   x_cide      = "mag_numide = '" + ALLTRIM(QWE_NUMIDE) + "'"
   x_cpdv      = "mag_codbun = '" + ALLTRIM(QWE_CODBUN) + "'"
   x_anno      = "mag_anno = mag_anno"
   x_xpdv      = "mag_codpdv = '" + ALLTRIM(CS_CODPDV) + "'"
   IF _MAG1 = 'VIAGGI'
      x_data       = "mag_datagg = '" + M.ALT_DTASCA + "'"
      M.MAG_DATAGG = M.ALT_DTASCA
      M.MAG_CODPDV = CS_CODPDV
      x_cond       = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                     x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                     x_cpdv + " and " + x_anno + " and " + x_xpdv
   ELSE
      x_cond       = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                     x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                     x_cpdv + " and " + x_anno
   ENDIF
   Csql        = "select top 1 * from u_mag_gg where " + x_cond + " order by mag_codacq,mag_przcon,mag_datagg"
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   GO TOP       
   IF EOF()
      APPEND BLANK
      DO U_MAG_GG
      REPLACE MAG_CODMAG WITH _MAG1
      REPLACE MAG_GIACEN WITH M_QTAFOR * -1
      REPLACE MAG_PRZCON WITH _PRZACQ
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ELSE
      REPLACE MAG_GIACEN WITH MAG_GIACEN - M_QTAFOR
   ENDIF
   IF MAG_NRLINT > 50000000 
      REPLACE MAG_FLGRIB WITH .T.
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.
   IF MAG_GIACEN < 0
      REPLACE MAG_GIACEN WITH 0
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_QTAIMP WITH 0
      REPLACE MAG_GKGIMP WITH 0
      REPLACE MAG_GMLIMP WITH 0
   ENDIF
   IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_GKGIMP WITH 0
      REPLACE MAG_GMLIMP WITH 0
   ENDIF
   IF _MAG1 = 'VIAGGI'
      IF ZZZ_FLGTIP = 2
         REPLACE MAG_FLGVIA WITH .T.
      ENDIF
   ENDIF
   QWE_SYSGGG = MAG_UNIQUE
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF
ENDIF

IF _GENMOV = "SI"
   * CREA IL MOVIMENTO DI SCARICO/SCARICO MAGAZZINO ---------------------------
   Csql   = "select * from u_mag_mo where 1=0"
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
   REPLACE MOV_CODPDV WITH PUB_CODBUN				
   REPLACE MOV_ORAMOV WITH _ORAMOV					
   REPLACE MOV_SEGNO  WITH X_SEGNO					
   REPLACE MOV_TIPMOV WITH M.TMOV				
   REPLACE MOV_FORNIT WITH M_FORNIT
   REPLACE MOV_DESFOR WITH M_DESFOR
   REPLACE MOV_COORD  WITH A_COORD
   REPLACE MOV_FLGTRA WITH _FLGTRA
   IF X_SEGNO = '+'
      REPLACE MOV_LEGSYS WITH _LEGSYS
   ENDIF
   REPLACE MOV_LEGAME WITH M.ALT_LEGAME
   REPLACE MOV_PAGAME WITH M.ALT_PAGAME
   REPLACE MOV_CODACQ WITH M.ALT_CODACQ
   REPLACE MOV_NUMORF WITH M.ALT_NUMORF
   REPLACE MOV_DATORF WITH M.ALT_DATORF
   REPLACE MOV_SC1    WITH M.ALT_SC1
   REPLACE MOV_SC2    WITH M.ALT_SC2
   REPLACE MOV_SC3    WITH M.ALT_SC3
   REPLACE MOV_NUMIDE WITH M.ALT_NUMIDE
   REPLACE MOV_CODBUN WITH M.ALT_CODBUN
   IF EMPTY(ALLTRIM(M.ALT_ANNO))
      REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
   ENDIF
   IF ALLTRIM(_MAGSCA) = '004'
      REPLACE MOV_DATSCA WITH _DATREG
   ELSE
      REPLACE MOV_DATSCA WITH _DATDOC
   ENDIF
   IF PUB_DAINVE_PDA
      REPLACE MOV_DATSCA WITH _DATREG
   ENDIF
   REPLACE MOV_UNIQUE WITH SYS(2015)
   REPLACE MOV_TIPART WITH M.ALT_TIPART
   IF ZZZ_FLGTIP = 1
      REPLACE MOV_TIPTRA WITH 'TRA'
      REPLACE MOV_SYSGGG WITH M.ORD_SYSGGG
      REPLACE MOV_SYSGGS WITH M.ORD_SYSGGS
      REPLACE MOV_SYSDAG WITH M.ORD_SYSDAG
      REPLACE MOV_SYSDAS WITH M.ORD_SYSDAS
   ELSE
      REPLACE MOV_TIPTRA WITH SPACE(03)
      REPLACE MOV_SYSGGG WITH SPACE(10)
      REPLACE MOV_SYSGGS WITH SPACE(10)
      REPLACE MOV_SYSDAG WITH SPACE(10)
      REPLACE MOV_SYSDAS WITH SPACE(10)
   ENDIF
   REPLACE MOV_CODOPE WITH PUB_CODOPE
   REPLACE MOV_NOMOPE WITH PUB_NOMOPE

   IF _DADOVE  = 'BFOCAMAG'
      REPLACE MOV_CODMAT WITH M.ALT_CODMAT
      REPLACE MOV_DESMAT WITH M.ALT_DESMAT
      REPLACE MOV_CODCOL WITH M.ALT_CODCOL
      REPLACE MOV_DESCOL WITH M.ALT_DESCOL
      REPLACE MOV_SPESSO WITH M.ALT_SPESSO
      REPLACE MOV_ALTEZZ WITH M.ALT_ALTEZZ
      REPLACE MOV_LUNGHE WITH M.ALT_LUNGHE
      REPLACE MOV_NRLINT WITH M.ALT_NRLINT
      REPLACE MOV_NRDBOB WITH M.ALT_NRDBOB
      REPLACE MOV_QTAKG  WITH M.ALT_QTAKG
      REPLACE MOV_QTAMQ  WITH M.ALT_QTAMQ
      REPLACE MOV_QTAML  WITH M.ALT_QTAML
      REPLACE MOV_CDAFOR WITH M.ALT_CDAFOR
      REPLACE MOV_OINFOR WITH M.ALT_OINFOR
      REPLACE MOV_PINFOR WITH M.ALT_PINFOR
      =CAMBIADT(M.ALT_DTPFOR,"MOV_DTPFOR")
      REPLACE MOV_TRAFOR WITH M.ALT_TRAFOR
      REPLACE MOV_NBAFOR WITH M.ALT_NBAFOR
      REPLACE MOV_BDAFOR WITH M.ALT_BDAFOR
      REPLACE MOV_BALFOR WITH M.ALT_BALFOR
      REPLACE MOV_PNKFOR WITH M.ALT_PNKFOR
      REPLACE MOV_ANAART WITH M.ALT_ARTORF
      REPLACE MOV_TIPART WITH M.ALT_TIPART
      
      REPLACE MOV_FLGCEL WITH M.ALT_FLGCEL
      REPLACE MOV_QTACON WITH M.ALT_QTACON
      REPLACE MOV_SERIE  WITH M.ALT_SERIE
      REPLACE MOV_SERBOL WITH M.ALT_SERBOL
      REPLACE MOV_SERNUM WITH M.ALT_SERNUM
      REPLACE MOV_NUMEDA WITH M.ALT_NUMEDA
      REPLACE MOV_NUMEAL WITH M.ALT_NUMEAL
      REPLACE MOV_AAPROD WITH M.ALT_AAPROD
      REPLACE MOV_CBFISC WITH M.ALT_CBFISC
   ENDIF

   IF EMPTY(ALLTRIM(MOV_ANNO))
      REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
   ENDIF

   REPLACE MOV_CODCLI WITH M_CODCLI
   REPLACE MOV_DESCLI WITH M_DESCLI

   IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
      REPLACE MOV_QTAMQ  WITH 0
      REPLACE MOV_QTAKG  WITH 0
      REPLACE MOV_QTAML  WITH 0
      REPLACE MOV_QTAMQA WITH 0
      REPLACE MOV_QTAMLA WITH 0
      REPLACE MOV_QTAKGA WITH 0
   ENDIF

   *=> Inizio - Rino 04/10/2004
   REPLACE MOV_FILA_X WITH PUB_FILCAR_X
   REPLACE MOV_PIAN_X WITH PUB_PIACAR_X
   REPLACE MOV_UBIC_X WITH PUB_UBICAR_X
   REPLACE MOV_FILA_N WITH PUB_FILCAR_N
   REPLACE MOV_PIAN_N WITH PUB_PIACAR_N
   REPLACE MOV_UBIC_N WITH PUB_UBICAR_N
   *=> Fine - Rino 04/10/2004

   REPLACE MOV_CSTMAN WITH M.MAG_CSTMAN
   REPLACE MOV_CSTSCA WITH M.MAG_CSTSCA

   RELEASE P_TIPO
   PUBLIC  P_TIPO
   P_TIPO = CERCATIPO(MOV_ANAART)
   SELECT U_MAG_MO
   IF P_TIPO = '3'	&& GESTIONE MANDRINI
      P_VALACQ = ROUND(((MOV_ALTEZZ / 1000) * MOV_PREACQ),2)
      REPLACE MOV_VALACQ WITH P_VALACQ
   ENDIF
   
   REPLACE MOV_NUMMOV WITH PUB_NUMCSI				&& RINO 20/10/2006

   SCATTER MEMVAR MEMO
   IF !ExecRW(cSql,"U_MAG_MO","W")
      return(.f.)
   ENDIF

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
   DO GESTIONE_SALDI_MOV

   IF EMPTY(ALLTRIM(_MAG1))
   ELSE
      Csql = "select * from u_mag_mo where 1=0"
      IF !ExecRW(cSql,"U_MAG_MO","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_MO
      APPEND BLANK
      DO U_MAG_MO
      REPLACE MOV_CODMAG WITH _MAG1
      REPLACE MOV_TOP    WITH _TOP1
      REPLACE MOV_SEGNO  WITH X_SEGNO1					
      REPLACE MOV_TIPMOV WITH V_TMOV1				
      REPLACE MOV_UNIQUE WITH SYS(2015)
      IF EMPTY(ALLTRIM(MOV_ANNO))
         REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
      ENDIF
      IF _MAG1 = 'VIAGGI'
         REPLACE MOV_CODPDV WITH CS_CODPDV
         REPLACE MOV_DATSCA WITH M.ALT_DTASCA
      ENDIF
      IF !ExecRW(cSql,"U_MAG_MO","W")
         return(.f.)
      ENDIF
      **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
      M.MOV_CODMAG = _MAG1
      M.MOV_TOP    = _TOP1
      M.MOV_SEGNO  = X_SEGNO1					
      M.MOV_TIPMOV = V_TMOV1				
      DO GESTIONE_SALDI_MOV
   ENDIF

ENDIF

*!*	  SERGIO INIZIO 23/09/2004
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
M.MAG_MATCHC= PUB_CODSOC
_NEW_SEGNO  = " "
=MOVIARTI(ALLTRIM(_CODART),_MAG,_NUMDOC,_DATDOC,M_QTAFOR,R_PRZCOS,R_PRZVEN,_TOP,M_CLIFOR,M_DESFOR,M.ALT_CODACQ,M.ALT_DESACQ,M.MAG_MATCHC,_NEW_SEGNO)
*!*	  SERGIO FINE 23/09/2004

RETURN  


*************************
PROCEDURE GESTIONE_SPOSTA	&& GESTIONE DEL SPOSTAMENTO GIACENZE DA UN MAGAZZINO AD UN ALTRO
*************************

RELEASE M_CODACQ
PUBLIC  M_CODACQ
M_CODACQ = SPACE(03)

M_PRIMOF = SPACE(10)
M_QUANTI = _QUANTI
M_DESFOR = ""

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

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO

SELECT CU_MAG_GM
SCATTER MEMVAR MEMO

*=> Inizio - Rino 04/10/2004
_CAMPO = "MAG_FILDES_X"
ESISTE = .F.
_TotFields=afields(_NameFields)
for _x=1 to _TotFields
    IF ALLTRIM(_NameFields[_x,1]) == ALLTRIM(_CAMPO)
       ESISTE=.T.
       EXIT
    ENDIF
next
IF !ESISTE
   PUB_FILDES_X = SPACE(05)
   PUB_PIADES_X = SPACE(05)
   PUB_UBIDES_X = SPACE(05)
   PUB_FILDES_N = 0
   PUB_PIADES_N = 0
   PUB_UBIDES_N = 0
ELSE
   PUB_FILDES_X = MAG_FILDES_X
   PUB_PIADES_X = MAG_PIADES_X
   PUB_UBIDES_X = MAG_UBIDES_X
   PUB_FILDES_N = MAG_FILDES_N
   PUB_PIADES_N = MAG_PIADES_N
   PUB_UBIDES_N = MAG_UBIDES_N
ENDIF
*=> Fine - Rino 04/10/2004

x_iden = "id_unique = '" + M.ID_UNIQUE + "'"
x_cond = x_iden
cSql   = "select * from u_mag_gg where " + x_cond
IF !ExecCommand(cSql,"CUR_MAG_GG")
   return(.f.)
ENDIF
SELECT CUR_MAG_GG
GO TOP
IF EOF()
   PUB_FILA_X = SPACE(05)
   PUB_PIAN_X = SPACE(05)
   PUB_UBIC_X = SPACE(05)
   PUB_FILA_N = 0
   PUB_PIAN_N = 0
   PUB_UBIC_N = 0
ELSE
   PUB_FILA_X = MAG_FILA_X
   PUB_PIAN_X = MAG_PIAN_X
   PUB_UBIC_X = MAG_UBIC_X
   PUB_FILA_N = MAG_FILA_N
   PUB_PIAN_N = MAG_PIAN_N
   PUB_UBIC_N = MAG_UBIC_N
   _CODART  = MAG_CODART
   _DATREG  = MAG_DATAGG     
   _PRZACQ  = MAG_PRZCON       
   M_FORNIT = MAG_FORNIT
   M_DESFOR = MAG_DESFOR
   M_CODACQ = MAG_CODACQ
   IF _DADOVE = 'PRODAVANS'
      M_QTAMQ = M_QTAMQA
      M_QTAML = TROVA_ML_DA_MQ(MAG_ALTEZZ,M_QTAMQ)
      *=> INIZIO RINO 18/04/2006
      *M_QTAKG = TROVA_KG_DA_MQ(MAG_CODART,MAG_SPESSO,M_QTAMQ,1)
      IF _TOP = 'SPS'
         ___VALMQ = (MAG_QTAKG*MAG_PRZCON) / MAG_QTAMQ
         ___VALSC = ___VALMQ * M_QTAMQ
         ___QTAKG = ___VALSC / MAG_PRZCON
         M_QTAKG = ROUND(___QTAKG,2)
      ELSE
         M_QTAKG = TROVA_KG_DA_MQ(MAG_CODART,MAG_SPESSO,M_QTAMQ,1)
      ENDIF
      *=> FINE RINO 18/04/2006
      SELECT CUR_MAG_GG
   ELSE
      M_QTAMQ  = MAG_QTAMQ
      M_QTAML  = MAG_QTAML
      M_QTAKG  = MAG_QTAKG
   ENDIF
   IF _DADOVE = 'PRODSCALTRO'
      M_QTAMQ  = 0
      M_QTAML  = 0
      M_QTAKG  = 0
   ENDIF
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
   DO MAGAZZINO_GG WITH 'SIDATA'
ENDIF

RETURN

************************************************************************************
PROCEDURE MAG_IN_AGG  && AGGIORNAMENTO MAGAZZINO IN FASE DI AGGIORNAMENTO GESTIONALE
************************************************************************************

PARAMETERS _CURSORE,_TABELLA,_SEGNO,_DADOVE

*==> ACCESSO ALLA TABELLA SQL SUL RECORD LEGATO AL CURSORE

IF _DADOVE = 'BOL'
	x_agga = "daggancio = '" + M.DAGGANCIO + "'"
	x_maga = "ord_maga = ord_maga " 
	x_lega = "ord_CODSYS = '" + ALLTRIM(M.ORD_CODSYS) + "'"
	*x_lega2 = "ord_LEGSYS = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
	***x_lega3 = "ord_DESART != '*** COMMENTO ***'"
	*x_cond = x_agga + " and " + x_maga + " and " + x_lega + " and " + x_lega2
	x_cond = x_agga + " and " + x_maga + " and " + x_lega  && ERASMO - 13/10/2009
	cSql   = "SELECT * FROM " + ALLTRIM(_TABELLA) + " WHERE " + x_cond +" ORDER BY ORD_CODART DESC"
ELSE
	x_agga = "daggancio = '" + M.DAGGANCIO + "'"
	x_maga = "ord_maga = ord_maga " 
	x_lega = "ord_legsys = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
	x_cond = x_agga + " and " + x_maga + " and " + x_lega
	cSql   = "SELECT * FROM " + ALLTRIM(_TABELLA) + " WHERE " + x_cond
ENDIF

IF !ExecCommand(cSql,"&_TABELLA")
   return(.f.)
ENDIF 
SELECT &_TABELLA
GO TOP
IF EOF()
   RETURN
ENDIF

XXX_QTAEVA = ORD_QTAORD

IF _DADOVE = 'RES'
   XXX_NUMBOB = ORD_NUMBOB
   x_cond = "ord_codsys = '" + ALLTRIM(ORD_SYSDDT) + "'"
   cSql   = "select * from u_bol_dd where " + x_cond
   IF !ExecRW(cSql,"U_BOL_DD","R")
      return(.f.)
   ENDIF
   SELECT U_BOL_DD
   GO TOP
   IF EOF()
   ELSE
      REPLACE ORD_NRERES WITH ORD_NRERES - XXX_NUMBOB
      REPLACE ORD_QTERES WITH ORD_QTERES - XXX_QTAEVA
      IF ORD_NUMBOB > (ORD_NRBRES + ORD_NRERES) .OR. ORD_QTAORD > (ORD_QTARES + ORD_QTERES)
         REPLACE ORD_TIPCON WITH ' '
      ELSE
         REPLACE ORD_TIPCON WITH 'S'
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_BOL_DD","W")
      return(.f.)
   ENDIF
   x_agga = "daggancio = '" + M.DAGGANCIO + "'"
   x_maga = "ord_maga = ord_maga " 
   x_lega = "ord_legsys = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
   x_cond = x_agga + " and " + x_maga + " and " + x_lega
   cSql   = "SELECT * FROM " + ALLTRIM(_TABELLA) + " WHERE " + x_cond
   IF !ExecCommand(cSql,"&_TABELLA")
      return(.f.)
   ENDIF 
   SELECT &_TABELLA
   GO TOP
   IF EOF()
      RETURN
   ENDIF
   XXX_QTAEVA = ORD_QTAORD
ENDIF

RELEASE U_AGGORF,U_SYSORF,U_CODORF,U_NUMPED,U_DATPED,U_NUMDDT,U_DATDDT,U_CODCLI,U_FLGPKL,U_CODSYS
PUBLIC  U_AGGORF,U_SYSORF,U_CODORF,U_NUMPED,U_DATPED,U_NUMDDT,U_DATDDT,U_CODCLI,U_FLGPKL,U_CODSYS
U_AGGORF = ORD_LEGAME
IF _TABELLA = "U_BOL_DD"
   U_SYSORF = SPACE(10)
ELSE
   U_SYSORF = ORD_LEGASY
ENDIF
U_AGGANC = DAGGANCIO
U_CODORF = ""
U_NUMPED = 0
U_DATPED = SPACE(10)
U_NUMDDT = SPACE(06)
U_DATDDT = SPACE(10)
U_CODCLI = SPACE(10)
U_FLGPKL = .F.
U_CODSYS = SPACE(10)
IF _TABELLA = "U_BOL_DD"
   U_NUMPED = ORD_NUMPED
   U_DATPED = ORD_DATPED
   U_NUMDDT = ORS_NUMORD
   U_DATDDT = ORS_DATORD
   U_CODCLI = ORS_CODCLI
   U_FLGPKL = ORD_FLGPKL
   U_CODSYS = ORD_CODSYS
ENDIF

*==> GESTIONE DEL CASO DI MODIFICA FATTA DALL'UTENTE :
*==> - SE E' STATA MODIFICATA LA SEQUENZA (NUMERO DI RIGA), VIENE ALZATO UN FLAG CHE INDICHERA'
*==>   ALLA FUNZIONE DI CANCELLAZIONE DEI RECORD DI TABELLA CHE DEVE CANCELLARLI TUTTI PERCHE'
*==>   POI VERRANNO REINSERITI CON LA NUOVA SEQUENZA.
*==> - VIENE AGGIORNATO IL RECORD DELLA TABELLA SQL (TRANNE LA SEQUENZA)
*==> - SE NON E' STATO MODIFICATO ALCUN CAMPO "CHIAVE", NON FA NIENTE, ALTRIMENTI VA AVANTI
*==>   PER CONTRAGGIORNARE GLI ARCHIVI DI MAGAZZINO

U_QTA    = ORD_QTAORD
U_LEGAME = ORD_LEGAME 
U_CODSYS = ORD_CODSYS

IF M.ORD_FLGMOD = 'M'
   U_ESCI = .F.
   IF ORD_SEQUEN = M.ORD_SEQUEN
   ELSE
      U_CANCELLA = .T.
   ENDIF
*!*	   IF ORD_CODART = M.ORD_CODART .AND. ;
*!*	      ORD_MAGA = M.ORD_MAGA .AND. ;
*!*	      ORD_MAGD = M.ORD_MAGD .AND. ;
*!*	      ORD_QTAORD = M.ORD_QTAORD .AND. ;
*!*	      ORD_PRZNET = M.ORD_PRZNET .AND. ;
*!*	      ORD_IVA = M.ORD_IVA .AND. ;
*!*	      ORD_FLGCEL = M.ORD_FLGCEL
*!*	      U_ESCI = .T.
*!*	   ENDIF
   **=> ERASMO - INIZIO 06/05/2011
   *** MODIFICA PER GESTIONE LOCAZIONI IN FASE DI MODIFICA RIGA BFO
   IF VARTYPE(M.ORD_FILA_X) == 'C' .AND. VARTYPE(M.ORD_PIAN_X) == 'C' .AND. VARTYPE(M.ORD_UBIC_X) == 'C'
	   IF ORD_CODART = M.ORD_CODART .AND. ;
	      ORD_MAGA = M.ORD_MAGA .AND. ;
	      ORD_FILA_X = M.ORD_FILA_X .AND. ;
	      ORD_PIAN_X = M.ORD_PIAN_X .AND. ;
	      ORD_UBIC_X = M.ORD_UBIC_X .AND. ;
	      ORD_MAGD = M.ORD_MAGD .AND. ;
	      ORD_QTAORD = M.ORD_QTAORD .AND. ;
	      ORD_PRZNET = M.ORD_PRZNET .AND. ;
	      ORD_IVA = M.ORD_IVA .AND. ;
	      ORD_FLGCEL = M.ORD_FLGCEL
	      U_ESCI = .T.
	   ENDIF
   ELSE
	   IF ORD_CODART = M.ORD_CODART .AND. ;
	      ORD_MAGA = M.ORD_MAGA .AND. ;
	      ORD_MAGD = M.ORD_MAGD .AND. ;
	      ORD_QTAORD = M.ORD_QTAORD .AND. ;
	      ORD_PRZNET = M.ORD_PRZNET .AND. ;
	      ORD_IVA = M.ORD_IVA .AND. ;
	      ORD_FLGCEL = M.ORD_FLGCEL
	      U_ESCI = .T.
	   ENDIF
   ENDIF
   **=> ERASMO - FINE 06/05/2011
   **=> ERASMO - INIZIO 02/02/2006
   IF _TABELLA = "U_BOL_DD" .AND. PUB_BOLMOD .AND. U_ESCI
      U_ESCI = .F.
   ENDIF   
   **=> ERASMO - FINE 02/02/2006   
   IF U_CANCELLA
   ELSE
      IF !ExecRW(cSql,"&_TABELLA","R")
         return(.f.)
      ENDIF 
      SELECT &_TABELLA
      M.ORD_SEQUEN = ORD_SEQUEN
      M.ORD_FLGMOD = SPACE(01)
      DO &_TABELLA
      IF !ExecRW(cSql,"&_TABELLA","W")
         return(.f.)
      ENDIF 
   ENDIF
   IF U_ESCI
      x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "art_codpri = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_art_pr where " + x_cond
      IF !ExecCommand(cSql,"cur_articoli")
         return(.f.)
      ENDIF
      SELECT cur_articoli
      GO TOP
      IF EOF()
         _CODMAT = '001'
         _SERIE  = '   '
      ELSE
         _CODMAT = ART_CODMAT
         _SERIE  = ART_SERIE
      ENDIF
      x_codi = "codice = 'MAT" + _CODMAT + "'"
      Csql   = "select * from para where " + x_codi
      IF !ExecCommand(cSql,"cur_para")
         return(.f.)
      ENDIF
      SELECT cur_para
      GO TOP
      IF EOF()
         V_TIPO = '0'
      ELSE
         V_TIPO = SUBSTR(LIBERA,1,1)
      ENDIF  
      IF V_TIPO = '1' .OR. V_TIPO = '2'
      ELSE
         IF ALLTRIM(_SERIE) = 'ZI'
         ELSE
            RETURN
         ENDIF
      ENDIF
   ENDIF
ENDIF

*==> GESTIONE DEL CASO DI CANCELLAZIONE FATTA DALL'UTENTE :
*==> - VIENE CANCELLATO IL RECORD SULLA TABELLA SQL E POI VA AVANTI PER CONTRAGGIORNARE 
*==>   GLI ARCHIVI DI MAGAZZINO
IF M.ORD_FLGMOD = 'A'
   IF !ExecRW(cSql,"&_TABELLA","R")
      return(.f.)
   ENDIF 
   SELECT &_TABELLA
   DELETE
   IF !ExecRW(cSql,"&_TABELLA","W")
      return(.f.)
   ENDIF 
ENDIF

IF _DADOVE = 'ORD'
   IF IMPE  = "X"
      x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
      x_maga = "mag_codmag = '" + ALLTRIM(M.ORD_MAGA) + "'"  
      x_codi = "mag_codart = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_maga + " and " + x_codi
      Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
      IF !ExecRW(cSql,"U_MAG_AN","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_AN
      IF RECCOUNT() <> 0
         REPLACE MAG_IMPORD WITH MAG_IMPORD - U_QTA
         REPLACE MAG_FLGTRA WITH .F.
         U_AGGIORNA = .T.
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_AN","W")
      return(.f.)
   ENDIF
   RETURN
ENDIF

IF U_NUMPED > 0
   IF _DADOVE = 'RES'
   ELSE
	   x_clie = "mag_codcli = '" + ALLTRIM(U_CODCLI) + "'"
	   x_nped = "mag_numped = " + ALLTRIM(STR(U_NUMPED,8,0))
	   x_dped = "mag_datped = '" + U_DATPED + "'"
	   x_nddt = "mag_numddt = '" + U_NUMDDT + "'"
	   x_dddt = "mag_datddt = '" + U_DATDDT + "'"
	   x_cond = x_clie + " and " + x_nped + " and " + x_dped + " and " + x_nddt + " and " + x_dddt
	   Csql   = "select * from u_ped_pl where " + x_cond + " order by mag_datped,mag_numped"
	   IF !ExecRW(cSql,"U_PED_PL","R")
	      return(.f.)
	   ENDIF
	   SELECT U_PED_PL
	   GO TOP
	   DO WHILE .T.
	      IF EOF()
	         EXIT
	      ENDIF
	      SCATTER MEMVAR MEMO
	      REPLACE MAG_NUMDDT WITH SPACE(06)
	      REPLACE MAG_DATDDT WITH SPACE(10)
	      REPLACE MAG_SYSDDT WITH SPACE(10)
	      x_csys = "ord_codsys = '" + M.MAG_SYSORD + "'"
	      Csql   = "select * from u_ord_dd where " + x_csys
	      IF !ExecRW(cSql,"U_ORD_DD","R")
	         return(.f.)
	      ENDIF
	      SELECT U_ORD_DD
	      GO TOP
	      IF EOF()
	      ELSE
	         REPLACE ORD_QTAEV  WITH ORD_QTAEV - M.MAG_QTAMQ
	         REPLACE ORD_NUMBOE WITH ORD_NUMBOE - 1
	         REPLACE ORD_QTAKGE WITH ORD_QTAKGE - M.MAG_QTAKG
	         REPLACE ORD_QTAMQE WITH ORD_QTAMQE - M.MAG_QTAMQ
	         REPLACE ORD_QTAMLE WITH ORD_QTAMLE - M.MAG_LUNGHE
	      ENDIF
	      IF !ExecRW(cSql,"U_ORD_DD","W")
	         return(.f.)
	      ENDIF
	      SELECT U_PED_PL
	      SKIP +1    
	   ENDDO
	   IF !ExecRW(cSql,"U_PED_PL","W")
	      return(.f.)
	   ENDIF
   ENDIF
ENDIF

*IF U_FLGPKL
   RELEASE XXX_COND
   PUBLIC  XXX_COND
   XXX_COND = ""
   x_agga   = "leg_agganc = '" + U_AGGANC + "'"
   x_csys   = "leg_sysbol = '" + ALLTRIM(U_CODSYS) + "'"
   x_cond   = x_agga + " and " + x_csys
   XXX_COND = x_cond
   Csql     = "select * from u_bol_le where " + x_cond 
   IF !ExecCommand(cSql,"CUR_BOL_LE")
      return(.f.)
   ENDIF
   SELECT CUR_BOL_LE
   GO TOP
   IF EOF()
   ELSE
      _CURSORE = "CUR_BOL_LE"
      _SEGNO   = "+"
      _DADOVE  = "PCK"
      =GESTIONE_IMPEGNATO_MAG_DA_BOL(_CURSORE,_SEGNO,_DADOVE) && SCARICA IMPEGNATO CON LA QTA DEL CURSORE ORIGINALE
      Csql     = "delete from u_bol_le where " + XXX_COND
      IF !ExecCommand(cSql,"U_BOL_LE")
         return(.f.)
      ENDIF
   ENDIF
*ENDIF

*==> RIPRISTINO DELLE QTA EVASE SULL'ORDINE A FORNITORE
x_agga = "daggancio = '" + U_AGGANC + "'"
x_aggo = "ord_aggorf = '" + U_AGGORF + "'"
x_syso = "ord_sysorf = '" + U_SYSORF + "'"
x_cond = x_agga + " and " + x_aggo + " and " + x_syso 
cSql   = "select * from u_bfo_dl where " + x_cond
IF !ExecCommand(cSql,"U_BFO_DL")
   return(.f.)
ENDIF
SELECT U_BFO_DL
GO TOP
IF EOF()
ELSE
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF ORD_QTAKG > 0
      ELSE
         SKIP +1
         LOOP
      ENDIF
      _DLEGAME   = DLEGAME
      _CODMAT    = ORD_CODMAT
      _CODCOL    = ORD_CODCOL
      _SPESSO    = ORD_SPESSO
      _ALTEZZ    = ORD_ALTEZZ
      _LUNGHE    = ORD_LUNGHE
      _AGGORF    = ORD_AGGORF
      _CODORF    = ORD_CODORF
      _QTAKG     = ORD_QTAKG
      _QTAMQ     = ORD_QTAMQ
      _QTAML     = ORD_QTAML
      _SALCON    = ORD_SALCON
      x_lega = "dlegame = '" + _DLEGAME + "'"
      x_mate = "ord_codmat = '" + _CODMAT + "'"
      x_colo = "ord_codcol = '" + _CODCOL + "'"
      x_spes = "ord_spesso = " + ALLTRIM(STR(_SPESSO,5,0))
      x_alte = "ord_altezz = " + ALLTRIM(STR(_ALTEZZ,7,0))
      x_lung = "ord_lunghe = " + ALLTRIM(STR(_LUNGHE,8,0))
      x_agga = "daggancio = '" + _AGGORF + "'"
      x_csys = "ord_codsys = '" + _CODORF + "'"
      x_cond = x_lega + " and " + x_mate + " and " + x_colo + " and " + x_spes + " and " + x_alte + " and " + ;
               x_lung + " and " + x_agga + " and " + x_csys
      cSql   = "select * from u_orf_dl where " + x_cond
      IF !ExecRW(cSql,"U_ORF_DL","R")
         return(.f.)
      ENDIF
      SELECT U_ORF_DL
      GO TOP
      IF EOF()
      ELSE
         REPLACE ORD_QTAKGE WITH ORD_QTAKGE - _QTAKG
         REPLACE ORD_QTAMQE WITH ORD_QTAMQE - _QTAMQ
         REPLACE ORD_QTAMLE WITH ORD_QTAMLE - _QTAML
         REPLACE ORD_SALCON WITH 'C'
         REPLACE ORD_CHIUSO WITH .F.
      ENDIF
      IF !ExecRW(cSql,"U_ORF_DL","W")
         return(.f.)
      ENDIF
      SELECT U_BFO_DL
      SKIP +1
   ENDDO
ENDIF

x_agga = "daggancio = '" + U_AGGANC + "'"
x_aggo = "ord_aggorf = '" + U_AGGORF + "'"
x_syso = "ord_sysorf = '" + U_SYSORF + "'"
x_cond = x_agga + " and " + x_aggo + " and " + x_syso 
cSql = "delete from u_bfo_dl where " + x_cond
IF !ExecCommand(cSql,"U_BFO_DL")
   return(.f.)
ENDIF

*==> ACCESSO ALLA ANAGRAFICA ARTICOLI PER VERIFICARE SE TRATTASI DI ARTICOLO CHE MOVIMENTA 
*==> LA GIACENZA O MENO

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(M.ORD_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
IF EOF()
   RETURN
ENDIF
IF ART_NONMOV
   RETURN
ENDIF
IF _DADOVE = 'ACQ' .OR. SUBSTR(_DADOVE,1,3) = 'BFO'
   IF _SEGNO = '+'
      REPLACE ART_TOTCAR WITH ART_TOTCAR + U_QTA
   ELSE
      REPLACE ART_TOTCAR WITH ART_TOTCAR - U_QTA
   ENDIF
ENDIF
IF _DADOVE = 'VEN' .OR. SUBSTR(_DADOVE,1,3) = 'BOL'
   IF _SEGNO = '+'
      REPLACE ART_TOTSCA WITH ART_TOTSCA - U_QTA
   ELSE
      REPLACE ART_TOTSCA WITH ART_TOTSCA + U_QTA
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_ART_PR","W")
   return(.f.)
ENDIF

RELEASE CS_CODPDV
PUBLIC  CS_CODPDV
x_cond = "pdv_codcli = '" + ALLTRIM(M.ORS_CODCLI) + "'"
Csql   = "select * from u_pdv_an where " + x_cond
IF !ExecCommand(Csql,"CU_PDV_AN")
   return(.f.)
ENDIF
SELECT CU_PDV_AN
GO TOP
IF EOF()
   CS_CODPDV = PUB_CODBUN
ELSE
   CS_CODPDV = PDV_CODICE
ENDIF         

*==> LOOP SU TUTTI I MOVIMENTI DI MAGAZZINO CHE SONO LEGATI AL RECORD DEL GESTIONALE

x_maga = "mov_codmag = mov_codmag "
x_lega = "mov_legsys = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
IF _TABELLA = "U_BOL_DD"
   x_nide = "mov_numide = mov_numide"
ELSE
   x_nide = "mov_numide = '" + ALLTRIM(M.ORS_NUMIDE) + "'"
ENDIF
x_cond = "(" + x_maga + " and " + x_lega + " and " + x_nide + ")"
IF M.RIN_NUMRIN = 'RES'
*-->> RICERCA DEL CODICE PDV DEL CLIENTE
   x_maga = "mov_codpdv = '" + ALLTRIM(CS_CODPDV) + "'"
   x_lega = "mov_legsys = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
   x_cond = x_cond + " or (" + x_maga + " and " + x_lega + ")"
ENDIF
cSql   = "SELECT * FROM U_MAG_MO WHERE " + x_cond
IF !ExecRW(cSql,"U_MAG_MO","R")
   return(.f.)
ENDIF 
   
SELECT U_MAG_MO
GO TOP
                     
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   SELECT U_MAG_MO
   SCATTER MEMVAR MEMO

   IF M.MOV_SEGNO = '+'
      _SEGNO = '-'
   ELSE
      IF M.MOV_SEGNO = '-'
         _SEGNO = '+'
      ENDIF
   ENDIF

   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci     = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data     = "mag_datagg = '" + ALLTRIM(M.MOV_DATSCA) + "'"
   x_codi     = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga     = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn     = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_tipo     = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   XXX_PRZACQ = M.MOV_PREACQ
   XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
   x_prez     = "mag_przcon = " + XX_PRZACQ
   x_cide     = "mag_numide = '" + ALLTRIM(M.MOV_NUMIDE) + "'"
   x_cpdv     = "mag_codbun = '" + ALLTRIM(M.MOV_CODBUN) + "'"
   x_anno     = "mag_anno = mag_anno"
   x_xpdv     = "mag_codpdv = '" + ALLTRIM(CS_CODPDV) + "'"
   x_fila     = "mag_fila_n = " + ALLTRIM(STR(M.MOV_FILA_N,5,0))
   x_pian     = "mag_pian_n = " + ALLTRIM(STR(M.MOV_PIAN_N,5,0))
   x_ubic     = "mag_ubic_n = " + ALLTRIM(STR(M.MOV_UBIC_N,5,0))
   IF M.MOV_CODMAG = 'VIAGGI'
      x_xpdv      = "mag_codpdv = '" + ALLTRIM(CS_CODPDV) + "'"
      M.MOV_CODPDV = CS_CODPDV
      x_cond       = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                     x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                     x_cpdv + " and " + x_anno + " and " + x_xpdv + " and " + x_fila + " and " + ;
                     x_pian + " and " + x_ubic
   ELSE
      x_xpdv      = "mag_codpdv = mag_codpdv"
      x_cond       = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                     x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                     x_cpdv + " and " + x_anno + " and " + x_xpdv + " and " + x_fila + " and " + ;
                     x_pian + " and " + x_ubic
   ENDIF
   Csql       = "select * from u_mag_gg where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH MAG_QTAKG + M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH MAG_QTAML + M.MOV_QTAML
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH MAG_QTAKG - M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH MAG_QTAML - M.MOV_QTAML
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH M.MOV_DATSCA
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH M.MOV_QTAML
      ELSE
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
         REPLACE MAG_QTAKG  WITH M.MOV_QTAKG * -1
         REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ * -1
         REPLACE MAG_QTAML  WITH M.MOV_QTAML * -1
      ENDIF
      REPLACE MAG_PRZCON WITH M.MOV_PREACQ
      REPLACE MAG_LEGAME WITH M.MOV_LEGAME
      REPLACE MAG_CODACQ WITH M.MOV_CODACQ
      REPLACE MAG_PAGAME WITH M.MOV_PAGAME
      REPLACE MAG_UNIQUE WITH SYS(2015)
      **=> ERASMO - INIZIO 05/02/2009
      _UNIQUE_GIACENZA_CANCELLATA = ''
      IF _CURSORE = "CU_BOL_DD" .AND. _TABELLA = "U_BOL_DD" .AND. _SEGNO = "+" .AND. _DADOVE = "BOL" .AND. USED("CU_BOL_LE")
         SELECT CU_BOL_LE
         _UNIQUE_GIACENZA_CANCELLATA = LEG_SYSMAG
      ENDIF
      SELECT U_MAG_GG
      IF !EMPTY(ALLTRIM(_UNIQUE_GIACENZA_CANCELLATA))
         REPLACE MAG_UNIQUE WITH _UNIQUE_GIACENZA_CANCELLATA
      ENDIF
      **=> ERASMO - FINE 05/02/2009
      REPLACE MAG_NUMIDE WITH M.MOV_NUMIDE
      REPLACE MAG_CODBUN WITH M.MOV_CODBUN
      REPLACE MAG_ANNO   WITH M.MOV_ANNO
      REPLACE MAG_CODMAT WITH M.MOV_CODMAT
      REPLACE MAG_DESMAT WITH M.MOV_DESMAT
      REPLACE MAG_CODCOL WITH M.MOV_CODCOL
      REPLACE MAG_DESCOL WITH M.MOV_DESCOL
      REPLACE MAG_SPESSO WITH M.MOV_SPESSO
      REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
      REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
      REPLACE MAG_NRLINT WITH M.MOV_NRLINT
      REPLACE MAG_ANAART WITH M.MOV_ANAART
      REPLACE MAG_TIPART WITH M.MOV_TIPART
   ENDIF
   REPLACE MAG_FILA_X WITH M.MOV_FILA_X 
   REPLACE MAG_PIAN_X WITH M.MOV_PIAN_X 
   REPLACE MAG_UBIC_X WITH M.MOV_UBIC_X 
   REPLACE MAG_FILA_N WITH M.MOV_FILA_N 
   REPLACE MAG_PIAN_N WITH M.MOV_PIAN_N 
   REPLACE MAG_UBIC_N WITH M.MOV_UBIC_N 
   IF MAG_NRLINT > 50000000 
      REPLACE MAG_FLGRIB WITH .T.
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.
   IF MAG_GIACEN < 0
      REPLACE MAG_GIACEN WITH 0
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_QTAIMP WITH 0
      REPLACE MAG_GKGIMP WITH 0
      REPLACE MAG_GMLIMP WITH 0
   ENDIF
   IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_GKGIMP WITH 0
      REPLACE MAG_GMLIMP WITH 0
   ENDIF
   IF M.MOV_CODMAG = 'VIAGGI'
      IF ZZZ_FLGTIP = 2
         REPLACE MAG_FLGVIA WITH .T.
      ENDIF
   ENDIF
   RELEASE QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
           QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
   PUBLIC  QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
           QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
   QWE_FORNIT = MAG_FORNIT
   QWE_DESFOR = MAG_DESFOR
   QWE_CODACQ = MAG_CODACQ
   QWE_DESACQ = MAG_DESACQ
   QWE_PRZCON = MAG_PRZCON
   QWE_PAGAME = MAG_PAGAME
   QWE_LEGAME = MAG_LEGAME 
   QWE_NUMIDE = MAG_NUMIDE
   QWE_CODBUN = MAG_CODBUN
   QWE_ANNO   = MAG_ANNO
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF

   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO E MAGAZZINO (STANDARD)
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_cond = x_soci + " and " + x_maga + " and " + x_codi
   Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
   IF !ExecRW(cSql,"U_MAG_AN","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_AN
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH MAG_QTAKG + M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH MAG_QTAML + M.MOV_QTAML
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV 
         REPLACE MAG_QTAKG  WITH MAG_QTAKG - M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH MAG_QTAML - M.MOV_QTAML
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
      ENDIF
      REPLACE MAG_CODFOR WITH M.MOV_FORNIT
      REPLACE MAG_COSTO  WITH M.MOV_PREACQ
      REPLACE MAG_UNIMIS WITH M.MOV_UM
      REPLACE MAG_DTCREA WITH M.MOV_DTDOCU
      REPLACE MAG_CODTAG WITH M.MOV_CODTAG
      REPLACE MAG_DESTAG WITH M.MOV_DESTAG
      REPLACE MAG_CODCOL WITH M.MOV_CODCOL
      REPLACE MAG_DESCOL WITH M.MOV_DESCOL
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV	
      REPLACE MAG_UNIQUE WITH SYS(2015)
      REPLACE MAG_CODMAT WITH M.MOV_CODMAT
      REPLACE MAG_DESMAT WITH M.MOV_DESMAT
      REPLACE MAG_CODCOL WITH M.MOV_CODCOL
      REPLACE MAG_DESCOL WITH M.MOV_DESCOL
      REPLACE MAG_SPESSO WITH M.MOV_SPESSO
      REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
      REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
      REPLACE MAG_NRLINT WITH M.MOV_NRLINT
      REPLACE MAG_ANAART WITH M.MOV_ANAART
      REPLACE MAG_TIPART WITH M.MOV_TIPART
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.
   IF MAG_GIACEN < 0
      REPLACE MAG_GIACEN WITH 0
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_QTAIMP WITH 0
   ENDIF
   IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
   ENDIF
   IF M.MOV_CODMAG = 'VIAGGI'
      IF ZZZ_FLGTIP = 2
         REPLACE MAG_FLGVIA WITH .T.
      ENDIF
   ENDIF
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_AN","W")
      return(.f.)
   ENDIF

   IF M.MOV_CODMAG = 'VIAGGI'
      M.MOV_CODPDV = CS_CODPDV
   ENDIF
   
   * CREA IL MOVIMENTO DI CANCELLATO SU NUOVO ARCHIVIO ---------------------------
*   Csql   = "select * from u_mag_ca where 1=0"
*   IF !ExecRW(cSql,"U_MAG_CA","R")
*      return(.f.)
*   ENDIF
*   SELECT U_MAG_CA
*   APPEND BLANK
*   DO U_MAG_MO
*   REPLACE MOV_FLGTRA WITH .F.
*   IF !ExecRW(cSql,"U_MAG_CA","W")
*      return(.f.)
*   ENDIF

   * CONTROAGGIORNA L'ARCHIVIO RIEPILOGHI DI MAGAZZINO

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE I CAMPI PROGRESSIVI ANNUALI DI CARICO/SCARICO + ANAGR.ART.
   SELECT U_MAG_MO
   I_CODART = M.MOV_CODART
   I_MAG	= M.MOV_CODMAG
   I_NUMDOC = M.MOV_NUMDOC
   I_DATDOC = M.MOV_DTDOCU
   I_QTAFOR = M.MOV_QTAMOV
   I_PRZCOS = M.MOV_PREACQ
   I_PRZCOS = M.MOV_PREACQ
   I_PRZVEN = M.MOV_PREVEN
   I_TOP    = M.MOV_TOP
   I_CLIFOR = M.MOV_FORNIT
   I_DESFOR = M.MOV_DESFOR
   I_CODACQ = M.MOV_CODACQ
   I_DESACQ = SPACE(15)
   I_MATCHC = PUB_CODSOC   
   I_NEW_SEGNO = _SEGNO 

   =MOVIARTI(ALLTRIM(I_CODART),I_MAG,I_NUMDOC,I_DATDOC,I_QTAFOR,I_PRZCOS,I_PRZVEN,I_TOP,I_CLIFOR,I_DESFOR,I_CODACQ,I_DESACQ,I_MATCHC,I_NEW_SEGNO)

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
   M.MOV_SEGNO = _SEGNO
   DO GESTIONE_SALDI_MOV

   * CANCELLA IL MOVIMENTO ---------------------------
   SELECT U_MAG_MO
   DELETE

   U_AGGIORNA = .T.
      
   SKIP +1
      
ENDDO

IF !ExecRW(cSql,"U_MAG_MO","W")
   return(.f.)
ENDIF 

RETURN


***********************************************************************************************
PROCEDURE MAG_IN_AGG_DA_MOVIMENTI  && RISISTEMAZIONE MAGAZZINO IN BASE AI MOVIMENTI SELEZIONATI
***********************************************************************************************

PARAMETERS __CDMAGAZ,__CDUNIQUE

*==> LOOP SU TUTTI I MOVIMENTI DI MAGAZZINO CHE SONO LEGATI AL RECORD DEL GESTIONALE

x_maga = "mov_codmag = '" + __CDMAGAZ + "'"
x_uniq = "mov_unique = '" + __CDUNIQUE + "'"
x_cond = x_maga + " and " + x_uniq
cSql   = "SELECT * FROM U_MAG_MO WHERE " + x_cond
IF !ExecRW(cSql,"U_MAG_MO","R")
   return(.f.)
ENDIF 
   
SELECT U_MAG_MO
GO TOP
                     
IF EOF()
   IF !ExecRW(cSql,"U_MAG_MO","W")
      return(.f.)
   ENDIF 
   RETURN
ENDIF

SELECT U_MAG_MO
SCATTER MEMVAR MEMO

IF M.MOV_SEGNO = '+'
   _SEGNO = '-'
ELSE
   IF M.MOV_SEGNO = '-'
      _SEGNO = '+'
   ENDIF
ENDIF

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
x_soci     = "mag_codsoc = '" + PUB_CODSOC + "'"
x_data     = "mag_datagg = '" + ALLTRIM(M.MOV_DATSCA) + "'"
x_codi     = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
x_maga     = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
x_forn     = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
x_tipo     = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
XXX_PRZACQ = M.MOV_PREACQ
XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
x_prez     = "mag_przcon = " + XX_PRZACQ
x_cide     = "mag_numide = '" + ALLTRIM(M.MOV_NUMIDE) + "'"
x_cpdv     = "mag_codbun = '" + ALLTRIM(M.MOV_CODBUN) + "'"
x_anno     = "mag_anno = mag_anno"
x_xpdv     = "mag_codpdv = mag_codpdv"
x_fila     = "mag_fila_n = " + ALLTRIM(STR(M.MOV_FILA_N,5,0))
x_pian     = "mag_pian_n = " + ALLTRIM(STR(M.MOV_PIAN_N,5,0))
x_ubic     = "mag_ubic_n = " + ALLTRIM(STR(M.MOV_UBIC_N,5,0))
IF M.MOV_CODMAG = 'VIAGGI'
   x_xpdv      = "mag_codpdv = '" + ALLTRIM(CS_CODPDV) + "'"
   M.MOV_CODPDV = CS_CODPDV
   x_cond       = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                  x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                  x_cpdv + " and " + x_anno + " and " + x_xpdv + " and " + x_fila + " and " + ;
                  x_pian + " and " + x_ubic
ELSE
   x_xpdv      = "mag_codpdv = mag_codpdv"
   x_cond      = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                 x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                 x_cpdv + " and " + x_anno + " and " + x_xpdv + " and " + x_fila + " and " + ;
                 x_pian + " and " + x_ubic
ENDIF
Csql       = "select * from u_mag_gg where " + x_cond 
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
IF RECCOUNT() <> 0
   IF _SEGNO = '+'
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
      REPLACE MAG_QTAKG  WITH MAG_QTAKG + M.MOV_QTAKG
      REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M.MOV_QTAMQ
      REPLACE MAG_QTAML  WITH MAG_QTAML + M.MOV_QTAML
   ELSE
      REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
      REPLACE MAG_QTAKG  WITH MAG_QTAKG - M.MOV_QTAKG
      REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M.MOV_QTAMQ
      REPLACE MAG_QTAML  WITH MAG_QTAML - M.MOV_QTAML
   ENDIF
ELSE
   APPEND BLANK
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_DATAGG WITH M.MOV_DATSCA
   REPLACE MAG_CODMAG WITH M.MOV_CODMAG
   REPLACE MAG_CODART WITH M.MOV_CODART
   REPLACE MAG_DESART WITH M.MOV_DESART
   REPLACE MAG_CODPDV WITH M.MOV_CODPDV
   REPLACE MAG_FORNIT WITH M.MOV_FORNIT
   REPLACE MAG_DESFOR WITH M.MOV_DESFOR
   IF _SEGNO = '+'
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      REPLACE MAG_QTAKG  WITH M.MOV_QTAKG
      REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ
      REPLACE MAG_QTAML  WITH M.MOV_QTAML
   ELSE
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
      REPLACE MAG_QTAKG  WITH M.MOV_QTAKG * -1
      REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ * -1
      REPLACE MAG_QTAML  WITH M.MOV_QTAML * -1
   ENDIF
   REPLACE MAG_PRZCON WITH M.MOV_PREACQ
   REPLACE MAG_LEGAME WITH M.MOV_LEGAME
   REPLACE MAG_CODACQ WITH M.MOV_CODACQ
   REPLACE MAG_PAGAME WITH M.MOV_PAGAME
   REPLACE MAG_UNIQUE WITH SYS(2015)
   REPLACE MAG_NUMIDE WITH M.MOV_NUMIDE
   REPLACE MAG_CODBUN WITH M.MOV_CODBUN
   REPLACE MAG_ANNO   WITH M.MOV_ANNO
   REPLACE MAG_CODMAT WITH M.MOV_CODMAT
   REPLACE MAG_DESMAT WITH M.MOV_DESMAT
   REPLACE MAG_CODCOL WITH M.MOV_CODCOL
   REPLACE MAG_DESCOL WITH M.MOV_DESCOL
   REPLACE MAG_SPESSO WITH M.MOV_SPESSO
   REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
   REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
   REPLACE MAG_NRLINT WITH M.MOV_NRLINT
   REPLACE MAG_ANAART WITH M.MOV_ANAART
   REPLACE MAG_TIPART WITH M.MOV_TIPART
ENDIF
REPLACE MAG_FILA_X WITH M.MOV_FILA_X 
REPLACE MAG_PIAN_X WITH M.MOV_PIAN_X 
REPLACE MAG_UBIC_X WITH M.MOV_UBIC_X 
REPLACE MAG_FILA_N WITH M.MOV_FILA_N 
REPLACE MAG_PIAN_N WITH M.MOV_PIAN_N 
REPLACE MAG_UBIC_N WITH M.MOV_UBIC_N 
IF MAG_NRLINT > 50000000 
   REPLACE MAG_FLGRIB WITH .T.
ENDIF
REPLACE MAG_FLGTRA WITH .F.
REPLACE MAG_FLGVIA WITH .F.
IF MAG_GIACEN < 0
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_QTAIMP WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF
IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF
IF M.MOV_CODMAG = 'VIAGGI'
   IF ZZZ_FLGTIP = 2
      REPLACE MAG_FLGVIA WITH .T.
   ENDIF
ENDIF
RELEASE QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
        QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
PUBLIC  QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
        QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
QWE_FORNIT = MAG_FORNIT
QWE_DESFOR = MAG_DESFOR
QWE_CODACQ = MAG_CODACQ
QWE_DESACQ = MAG_DESACQ
QWE_PRZCON = MAG_PRZCON
QWE_PAGAME = MAG_PAGAME
QWE_LEGAME = MAG_LEGAME 
QWE_NUMIDE = MAG_NUMIDE
QWE_CODBUN = MAG_CODBUN
QWE_ANNO   = MAG_ANNO
IF EMPTY(ALLTRIM(PUB_MAGNO0))
ELSE
   IF MAG_GIACEN = 0
      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
      ELSE
         DELETE
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO E MAGAZZINO (STANDARD)
x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
x_cond = x_soci + " and " + x_maga + " and " + x_codi
Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
IF !ExecRW(cSql,"U_MAG_AN","R")
   return(.f.)
ENDIF
SELECT U_MAG_AN
IF RECCOUNT() <> 0
   IF _SEGNO = '+'
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
      REPLACE MAG_QTAKG  WITH MAG_QTAKG + M.MOV_QTAKG
      REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M.MOV_QTAMQ
      REPLACE MAG_QTAML  WITH MAG_QTAML + M.MOV_QTAML
   ELSE
      REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV 
      REPLACE MAG_QTAKG  WITH MAG_QTAKG - M.MOV_QTAKG
      REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M.MOV_QTAMQ
      REPLACE MAG_QTAML  WITH MAG_QTAML - M.MOV_QTAML
   ENDIF
ELSE
   APPEND BLANK
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_CODMAG WITH M.MOV_CODMAG
   REPLACE MAG_CODART WITH M.MOV_CODART
   REPLACE MAG_DESART WITH M.MOV_DESART
   IF _SEGNO = '+'
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
   ELSE
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
   ENDIF
   REPLACE MAG_CODFOR WITH M.MOV_FORNIT
   REPLACE MAG_COSTO  WITH M.MOV_PREACQ
   REPLACE MAG_UNIMIS WITH M.MOV_UM
   REPLACE MAG_DTCREA WITH M.MOV_DTDOCU
   REPLACE MAG_CODTAG WITH M.MOV_CODTAG
   REPLACE MAG_DESTAG WITH M.MOV_DESTAG
   REPLACE MAG_CODCOL WITH M.MOV_CODCOL
   REPLACE MAG_DESCOL WITH M.MOV_DESCOL
   REPLACE MAG_CODPDV WITH M.MOV_CODPDV	
   REPLACE MAG_UNIQUE WITH SYS(2015)
   REPLACE MAG_CODMAT WITH M.MOV_CODMAT
   REPLACE MAG_DESMAT WITH M.MOV_DESMAT
   REPLACE MAG_CODCOL WITH M.MOV_CODCOL
   REPLACE MAG_DESCOL WITH M.MOV_DESCOL
   REPLACE MAG_SPESSO WITH M.MOV_SPESSO
   REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
   REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
   REPLACE MAG_NRLINT WITH M.MOV_NRLINT
   REPLACE MAG_ANAART WITH M.MOV_ANAART
   REPLACE MAG_TIPART WITH M.MOV_TIPART
ENDIF
REPLACE MAG_FLGTRA WITH .F.
REPLACE MAG_FLGVIA WITH .F.
IF MAG_GIACEN < 0
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_QTAIMP WITH 0
ENDIF
IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
ENDIF
IF M.MOV_CODMAG = 'VIAGGI'
   IF ZZZ_FLGTIP = 2
      REPLACE MAG_FLGVIA WITH .T.
   ENDIF
ENDIF
IF EMPTY(ALLTRIM(PUB_MAGNO0))
ELSE
   IF MAG_GIACEN = 0
      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
      ELSE
         DELETE
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_AN","W")
   return(.f.)
ENDIF

IF M.MOV_CODMAG = 'VIAGGI'
   M.MOV_CODPDV = CS_CODPDV
ENDIF
   
* CONTROAGGIORNA L'ARCHIVIO RIEPILOGHI DI MAGAZZINO

**==>> RICHIAMA LA FUNZIONE PER GESTIRE I CAMPI PROGRESSIVI ANNUALI DI CARICO/SCARICO + ANAGR.ART.
SELECT U_MAG_MO
I_CODART    = M.MOV_CODART
I_MAG	    = M.MOV_CODMAG
I_NUMDOC    = M.MOV_NUMDOC
I_DATDOC    = M.MOV_DTDOCU
I_QTAFOR    = M.MOV_QTAMOV
I_PRZCOS    = M.MOV_PREACQ
I_PRZCOS    = M.MOV_PREACQ
I_PRZVEN    = M.MOV_PREVEN
I_TOP       = M.MOV_TOP
I_CLIFOR    = M.MOV_FORNIT
I_DESFOR    = M.MOV_DESFOR
I_CODACQ    = M.MOV_CODACQ
I_DESACQ    = SPACE(15)
I_MATCHC    = PUB_CODSOC   
I_NEW_SEGNO = _SEGNO 

=MOVIARTI(ALLTRIM(I_CODART),I_MAG,I_NUMDOC,I_DATDOC,I_QTAFOR,I_PRZCOS,I_PRZVEN,I_TOP,I_CLIFOR,I_DESFOR,I_CODACQ,I_DESACQ,I_MATCHC,I_NEW_SEGNO)

**==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
M.MOV_SEGNO = _SEGNO
DO GESTIONE_SALDI_MOV

* CANCELLA IL MOVIMENTO ---------------------------
SELECT U_MAG_MO
DELETE

IF !ExecRW(cSql,"U_MAG_MO","W")
   return(.f.)
ENDIF 

RETURN


************************************************************************************
PROCEDURE MAG_IN_AGG_RESO_STD  && AGGIORNAMENTO MAGAZZINO IN FASE DI AGGIORNAMENTO GESTIONALE
************************************************************************************

PARAMETERS _QUANTITA,_LEGASYSC

RELEASE U_AGGORF,U_SYSORF,U_CODORF,U_NUMPED,U_DATPED,U_NUMDDT,U_DATDDT,U_CODCLI
PUBLIC  U_AGGORF,U_SYSORF,U_CODORF,U_NUMPED,U_DATPED,U_NUMDDT,U_DATDDT,U_CODCLI
U_AGGORF = ORD_LEGAME
U_SYSORF = SPACE(10)
U_AGGANC = DAGGANCIO
U_CODORF = ""
U_NUMPED = 0
U_DATPED = SPACE(10)
U_NUMDDT = SPACE(06)
U_DATDDT = SPACE(10)
U_CODCLI = SPACE(10)
U_QTA    = ORD_QTAORD
U_LEGAME = ORD_LEGAME 
U_CODSYS = ORD_CODSYS

*==> ACCESSO ALLA ANAGRAFICA ARTICOLI PER VERIFICARE SE TRATTASI DI ARTICOLO CHE MOVIMENTA 
*==> LA GIACENZA O MENO

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(M.ORD_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"U_ART_PR")
   return(.f.)
ENDIF
SELECT U_ART_PR
IF EOF()
   RETURN
ENDIF
IF ART_NONMOV
   RETURN
ENDIF

RELEASE CS_CODPDV
PUBLIC  CS_CODPDV
x_cond = "pdv_codcli = '" + ALLTRIM(M.ORS_CODCLI) + "'"
Csql   = "select * from u_pdv_an where " + x_cond
IF !ExecCommand(Csql,"CU_PDV_AN")
   return(.f.)
ENDIF
SELECT CU_PDV_AN
GO TOP
IF EOF()
   CS_CODPDV = PUB_CODBUN
ELSE
   CS_CODPDV = PDV_CODICE
ENDIF         

*==> LOOP SU TUTTI I MOVIMENTI DI MAGAZZINO CHE SONO LEGATI AL RECORD DEL GESTIONALE

x_maga = "mov_codmag = mov_codmag "
x_lega = "mov_legsys = '" + ALLTRIM(M.ORD_LEGSYS) + "'"
x_nide = "mov_numide = mov_numide"
x_cond = "(" + x_maga + " and " + x_lega + " and " + x_nide + ")"
cSql   = "SELECT * FROM U_MAG_MO WHERE " + x_cond
IF !ExecCommand(cSql,"CURS_MAG_MO")
   return(.f.)
ENDIF 
   
SELECT CURS_MAG_MO
GO TOP
                     
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF _QUANTITA < 1
      EXIT
   ENDIF
   
   SCATTER MEMVAR MEMO

   IF M.MOV_QTAMOV > _QUANTITA
      M.MOV_QTAMOV = _QUANTITA
      _QUANTITA = 0
   ELSE
      _QUANTITA = _QUANTITA - M.MOV_QTAMOV
   ENDIF

   IF M.MOV_SEGNO = '+'
      _SEGNO = '-'
   ELSE
      IF M.MOV_SEGNO = '-'
         _SEGNO = '+'
      ENDIF
   ENDIF

   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci     = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data     = "mag_datagg = '" + ALLTRIM(M.MOV_DATSCA) + "'"
   x_codi     = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga     = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn     = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_tipo     = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   XXX_PRZACQ = M.MOV_PREACQ
   XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
   x_prez     = "mag_przcon = " + XX_PRZACQ
   x_cide     = "mag_numide = '" + ALLTRIM(M.MOV_NUMIDE) + "'"
   x_cpdv     = "mag_codbun = '" + ALLTRIM(M.MOV_CODBUN) + "'"
   x_anno     = "mag_anno = mag_anno"
   x_fila     = "mag_fila_n = " + ALLTRIM(STR(M.MOV_FILA_N,5,0))
   x_pian     = "mag_pian_n = " + ALLTRIM(STR(M.MOV_PIAN_N,5,0))
   x_ubic     = "mag_ubic_n = " + ALLTRIM(STR(M.MOV_UBIC_N,5,0))
   IF M.MOV_CODMAG = 'VIAGGI'
      x_xpdv       = "mag_codpdv = '" + ALLTRIM(CS_CODPDV) + "'"
      M.MOV_CODPDV = CS_CODPDV
      x_cond       = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                     x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                     x_cpdv + " and " + x_anno + " and " + x_xpdv + " and " + x_fila + " and " + ;
                     x_pian + " and " + x_ubic
   ELSE
      x_xpdv       = "mag_codpdv = mag_codpdv"
      x_cond       = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                     x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                     x_cpdv + " and " + x_anno + " and " + x_xpdv + " and " + x_fila + " and " + ;
                     x_pian + " and " + x_ubic
   ENDIF
   Csql       = "select * from u_mag_gg where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH MAG_QTAKG + M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH MAG_QTAML + M.MOV_QTAML
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH MAG_QTAKG - M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH MAG_QTAML - M.MOV_QTAML
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH M.MOV_DATSCA
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH M.MOV_QTAML
      ELSE
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
         REPLACE MAG_QTAKG  WITH M.MOV_QTAKG * -1
         REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ * -1
         REPLACE MAG_QTAML  WITH M.MOV_QTAML * -1
      ENDIF
      REPLACE MAG_PRZCON WITH M.MOV_PREACQ
      REPLACE MAG_LEGAME WITH M.MOV_LEGAME
      REPLACE MAG_CODACQ WITH M.MOV_CODACQ
      REPLACE MAG_PAGAME WITH M.MOV_PAGAME
      REPLACE MAG_UNIQUE WITH SYS(2015)
      REPLACE MAG_NUMIDE WITH M.MOV_NUMIDE
      REPLACE MAG_CODBUN WITH M.MOV_CODBUN
      REPLACE MAG_ANNO   WITH M.MOV_ANNO
      REPLACE MAG_CODMAT WITH M.MOV_CODMAT
      REPLACE MAG_DESMAT WITH M.MOV_DESMAT
      REPLACE MAG_CODCOL WITH M.MOV_CODCOL
      REPLACE MAG_DESCOL WITH M.MOV_DESCOL
      REPLACE MAG_SPESSO WITH M.MOV_SPESSO
      REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
      REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
      REPLACE MAG_NRLINT WITH M.MOV_NRLINT
      REPLACE MAG_ANAART WITH M.MOV_ANAART
      REPLACE MAG_TIPART WITH M.MOV_TIPART
   ENDIF
   REPLACE MAG_FILA_X WITH M.MOV_FILA_X 
   REPLACE MAG_PIAN_X WITH M.MOV_PIAN_X 
   REPLACE MAG_UBIC_X WITH M.MOV_UBIC_X 
   REPLACE MAG_FILA_N WITH M.MOV_FILA_N 
   REPLACE MAG_PIAN_N WITH M.MOV_PIAN_N 
   REPLACE MAG_UBIC_N WITH M.MOV_UBIC_N 
   IF MAG_NRLINT > 50000000 
      REPLACE MAG_FLGRIB WITH .T.
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.
   IF MAG_GIACEN < 0
      REPLACE MAG_GIACEN WITH 0
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_QTAIMP WITH 0
      REPLACE MAG_GKGIMP WITH 0
      REPLACE MAG_GMLIMP WITH 0
   ENDIF
   IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_GKGIMP WITH 0
      REPLACE MAG_GMLIMP WITH 0
   ENDIF
   IF M.MOV_CODMAG = 'VIAGGI'
      IF ZZZ_FLGTIP = 2
         REPLACE MAG_FLGVIA WITH .T.
      ENDIF
   ENDIF
   RELEASE QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
           QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
   PUBLIC  QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
           QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
   QWE_FORNIT = MAG_FORNIT
   QWE_DESFOR = MAG_DESFOR
   QWE_CODACQ = MAG_CODACQ
   QWE_DESACQ = MAG_DESACQ
   QWE_PRZCON = MAG_PRZCON
   QWE_PAGAME = MAG_PAGAME
   QWE_LEGAME = MAG_LEGAME 
   QWE_NUMIDE = MAG_NUMIDE
   QWE_CODBUN = MAG_CODBUN
   QWE_ANNO   = MAG_ANNO
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF


   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO E MAGAZZINO (STANDARD)
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_cond = x_soci + " and " + x_maga + " and " + x_codi
   Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
   IF !ExecRW(cSql,"U_MAG_AN","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_AN
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
         REPLACE MAG_QTAKG  WITH MAG_QTAKG + M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH MAG_QTAML + M.MOV_QTAML
      ELSE
         REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV 
         REPLACE MAG_QTAKG  WITH MAG_QTAKG - M.MOV_QTAKG
         REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M.MOV_QTAMQ
         REPLACE MAG_QTAML  WITH MAG_QTAML - M.MOV_QTAML
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      IF _SEGNO = '+'
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      ELSE
         REPLACE MAG_GIACEN WITH M.MOV_QTAMOV * -1
      ENDIF
      REPLACE MAG_CODFOR WITH M.MOV_FORNIT
      REPLACE MAG_COSTO  WITH M.MOV_PREACQ
      REPLACE MAG_UNIMIS WITH M.MOV_UM
      REPLACE MAG_DTCREA WITH M.MOV_DTDOCU
      REPLACE MAG_CODTAG WITH M.MOV_CODTAG
      REPLACE MAG_DESTAG WITH M.MOV_DESTAG
      REPLACE MAG_CODCOL WITH M.MOV_CODCOL
      REPLACE MAG_DESCOL WITH M.MOV_DESCOL
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV	
      REPLACE MAG_UNIQUE WITH SYS(2015)
      REPLACE MAG_CODMAT WITH M.MOV_CODMAT
      REPLACE MAG_DESMAT WITH M.MOV_DESMAT
      REPLACE MAG_CODCOL WITH M.MOV_CODCOL
      REPLACE MAG_DESCOL WITH M.MOV_DESCOL
      REPLACE MAG_SPESSO WITH M.MOV_SPESSO
      REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
      REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
      REPLACE MAG_NRLINT WITH M.MOV_NRLINT
      REPLACE MAG_ANAART WITH M.MOV_ANAART
      REPLACE MAG_TIPART WITH M.MOV_TIPART
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.
   IF MAG_GIACEN < 0
      REPLACE MAG_GIACEN WITH 0
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
      REPLACE MAG_QTAIMP WITH 0
   ENDIF
   IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
      REPLACE MAG_QTAMQ  WITH 0
      REPLACE MAG_QTAKG  WITH 0
      REPLACE MAG_QTAML  WITH 0
   ENDIF
   IF M.MOV_CODMAG = 'VIAGGI'
      IF ZZZ_FLGTIP = 2
         REPLACE MAG_FLGVIA WITH .T.
      ENDIF
   ENDIF
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_AN","W")
      return(.f.)
   ENDIF

   IF M.MOV_CODMAG = 'VIAGGI'
      M.MOV_CODPDV = CS_CODPDV
   ENDIF
   
   * CREA IL MOVIMENTO DI MAGAZZINO ---------------------------
   Csql = "select * from u_mag_mo where 1=0"
   IF !ExecRW(Csql,"U_MAG_MO","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_MO
   APPEND BLANK
   DO U_MAG_MO
   REPLACE MOV_TOP    WITH M.ORD_CAUS
   REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
   REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
   REPLACE MOV_NUMDOC WITH M.ORD_NUMORD
   REPLACE MOV_DTDOCU WITH M.ORD_DATORD
   REPLACE MOV_DTREGI WITH _DATAOGGI
   REPLACE MOV_ORAMOV WITH TIME()					
   REPLACE MOV_SEGNO  WITH _SEGNO					
   REPLACE MOV_TIPMOV WITH 'RE'				
   REPLACE MOV_FLGTRA WITH .F.
   REPLACE MOV_LEGSYS WITH _LEGASYSC
   REPLACE MOV_UNIQUE WITH SYS(2015)
   REPLACE MOV_CODOPE WITH PUB_CODOPE
   REPLACE MOV_NOMOPE WITH PUB_NOMOPE
   IF EMPTY(ALLTRIM(MOV_ANNO))
      REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
   ENDIF
   REPLACE MOV_CODCLI WITH M_CODCLI
   REPLACE MOV_DESCLI WITH M_DESCLI
   IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
      REPLACE MOV_QTAMQ  WITH 0
      REPLACE MOV_QTAKG  WITH 0
      REPLACE MOV_QTAML  WITH 0
      REPLACE MOV_QTAMQA WITH 0
      REPLACE MOV_QTAMLA WITH 0
      REPLACE MOV_QTAKGA WITH 0
   ENDIF
       RELEASE P_TIPO
       PUBLIC  P_TIPO
       P_TIPO = CERCATIPO(MOV_ANAART)
       SELECT U_MAG_MO
       IF P_TIPO = '3'	&& GESTIONE MANDRINI
          P_VALACQ = ROUND(((MOV_ALTEZZ / 1000) * MOV_PREACQ),2)
	      REPLACE MOV_VALACQ WITH P_VALACQ
       ENDIF
   SCATTER MEMVAR MEMO
   IF !ExecRW(Csql,"U_MAG_MO","W")
       return(.f.)
   ENDIF

   * CONTROAGGIORNA L'ARCHIVIO RIEPILOGHI DI MAGAZZINO

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE I CAMPI PROGRESSIVI ANNUALI DI CARICO/SCARICO + ANAGR.ART.
   I_CODART = M.MOV_CODART
   I_MAG	= M.MOV_CODMAG
   I_NUMDOC = M.MOV_NUMDOC
   I_DATDOC = M.MOV_DTDOCU
   I_QTAFOR = M.MOV_QTAMOV
   I_PRZCOS = M.MOV_PREACQ
   I_PRZCOS = M.MOV_PREACQ
   I_PRZVEN = M.MOV_PREVEN
   I_TOP    = M.MOV_TOP
   I_CLIFOR = M.MOV_FORNIT
   I_DESFOR = M.MOV_DESFOR
   I_CODACQ = M.MOV_CODACQ
   I_DESACQ = SPACE(15)
   I_MATCHC = PUB_CODSOC   
   I_NEW_SEGNO = _SEGNO 

   =MOVIARTI(ALLTRIM(I_CODART),I_MAG,I_NUMDOC,I_DATDOC,I_QTAFOR,I_PRZCOS,I_PRZVEN,I_TOP,I_CLIFOR,I_DESFOR,I_CODACQ,I_DESACQ,I_MATCHC,I_NEW_SEGNO)

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
   DO GESTIONE_SALDI_MOV

   U_AGGIORNA = .T.
      
   SELECT CURS_MAG_MO
   SKIP +1
      
ENDDO

RETURN



*******************************************************************************************
PROCEDURE MAG_IN_AGG_RESO  && AGGIORNAMENTO MAGAZZINO IN FASE DI RESO RICHIAMATO DA MAGA000
*******************************************************************************************

PARAMETERS _ARTICOLO,_QUANTITA,_MAGAZZINO,_LEGAME

_LEGSYS = SYS(2015)

*==> ACCESSO ALLA ANAGRAFICA ARTICOLI PER VERIFICARE SE TRATTASI DI ARTICOLO CHE MOVIMENTA 
*==> LA GIACENZA O MENO

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_ARTICOLO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecRW(cSql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
IF EOF()
   RETURN
ENDIF
IF ART_NONMOV
   RETURN
ENDIF
REPLACE ART_TOTSCA WITH ART_TOTSCA - _QUANTITA
IF !ExecRW(cSql,"U_ART_PR","W")
   return(.f.)
ENDIF

*==> LOOP SU TUTTI I MOVIMENTI DI MAGAZZINO CHE SONO LEGATI AL RECORD DEL GESTIONALE
   
x_maga = "mov_codpdv = '" + ALLTRIM(_MAGAZZINO) + "'"
x_lega = "mov_legsys = '" + ALLTRIM(_LEGAME) + "'"
x_cond = x_maga + " and " + x_lega
cSql   = "SELECT * FROM U_MAG_MO WHERE " + x_cond
IF !ExecCommand(cSql,"U_MAG_MO")
   return(.f.)
ENDIF 
   
SELECT U_MAG_MO
GO TOP
                     
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF _QUANTITA < 1
      EXIT
   ENDIF
   
   SCATTER MEMVAR MEMO

   IF M.MOV_QTAMOV > _QUANTITA
      M.MOV_QTAMOV = _QUANTITA
      _QUANTITA = 0
   ENDIF
   
   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
   x_soci     = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data     = "mag_datagg = '" + ALLTRIM(M.MOV_DATSCA) + "'"
   x_codi     = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga     = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn     = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_tipo     = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   x_giac     = "mag_giacen > 0"
   XXX_PRZACQ = M.MOV_PREACQ
   XX_PRZACQ  = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
   x_prez     = "mag_przcon = " + XX_PRZACQ
   x_cide     = "mag_numide = '" + ALLTRIM(M.MOV_NUMIDE) + "'"
   x_cpdv     = "mag_codbun = '" + ALLTRIM(M.MOV_CODBUN) + "'"
   x_anno     = "mag_anno = mag_anno"
   x_fila     = "mag_fila_n = " + ALLTRIM(STR(M.MOV_FILA_N,5,0))
   x_pian     = "mag_pian_n = " + ALLTRIM(STR(M.MOV_PIAN_N,5,0))
   x_ubic     = "mag_ubic_n = " + ALLTRIM(STR(M.MOV_UBIC_N,5,0))
   x_cond     = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
                x_cpdv + " and " + x_anno + " and " + x_fila + " and " + x_pian + " and " + ;
                x_ubic
   Csql       = "select * from u_mag_gg where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_DATAGG WITH M.MOV_DATSCA
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV
      REPLACE MAG_FORNIT WITH M.MOV_FORNIT
      REPLACE MAG_DESFOR WITH M.MOV_DESFOR
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      REPLACE MAG_PRZCON WITH M.MOV_PREACQ
      REPLACE MAG_LEGAME WITH M.MOV_LEGAME
      REPLACE MAG_CODACQ WITH M.MOV_CODACQ
      REPLACE MAG_PAGAME WITH M.MOV_PAGAME
      REPLACE MAG_UNIQUE WITH SYS(2015)
      REPLACE MAG_NUMIDE WITH M.MOV_NUMIDE
      REPLACE MAG_CODBUN WITH M.MOV_CODBUN
      REPLACE MAG_ANNO   WITH M.MOV_ANNO
   ENDIF
   REPLACE MAG_FILA_X WITH M.MOV_FILA_X 
   REPLACE MAG_PIAN_X WITH M.MOV_PIAN_X 
   REPLACE MAG_UBIC_X WITH M.MOV_UBIC_X 
   REPLACE MAG_FILA_N WITH M.MOV_FILA_N 
   REPLACE MAG_PIAN_N WITH M.MOV_PIAN_N 
   REPLACE MAG_UBIC_N WITH M.MOV_UBIC_N 
   IF MAG_NRLINT > 50000000 
      REPLACE MAG_FLGRIB WITH .T.
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
	IF MAG_GIACEN < 0
	   REPLACE MAG_GIACEN WITH 0
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_QTAIMP WITH 0
	   REPLACE MAG_GKGIMP WITH 0
	   REPLACE MAG_GMLIMP WITH 0
	ENDIF
	IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_GKGIMP WITH 0
	   REPLACE MAG_GMLIMP WITH 0
	ENDIF
   RELEASE QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
           QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
   PUBLIC  QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME, ;
           QWE_NUMIDE,QWE_CODBUN,QWE_ANNO
   QWE_FORNIT = MAG_FORNIT
   QWE_DESFOR = MAG_DESFOR
   QWE_CODACQ = MAG_CODACQ
   QWE_DESACQ = MAG_DESACQ
   QWE_PRZCON = MAG_PRZCON
   QWE_PAGAME = MAG_PAGAME
   QWE_LEGAME = MAG_LEGAME 
   QWE_NUMIDE = MAG_NUMIDE
   QWE_CODBUN = MAG_CODBUN
   QWE_ANNO   = MAG_ANNO
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF


   _DATAOGGI = RIBALTA2(DTOC(DATE()))
   
   *-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO E MAGAZZINO (STANDARD)
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
   x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_cond = x_soci + " and " + x_maga + " and " + x_codi
   Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
   IF !ExecRW(cSql,"U_MAG_AN","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_AN
   IF RECCOUNT() <> 0
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   ELSE
      APPEND BLANK
      REPLACE MAG_CODSOC WITH PUB_CODSOC
      REPLACE MAG_CODMAG WITH M.MOV_CODMAG
      REPLACE MAG_CODART WITH M.MOV_CODART
      REPLACE MAG_DESART WITH M.MOV_DESART
      REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
      REPLACE MAG_CODFOR WITH M.MOV_FORNIT
      REPLACE MAG_COSTO  WITH M.MOV_PREACQ
      REPLACE MAG_UNIMIS WITH M.MOV_UM
      REPLACE MAG_DTCREA WITH M.MOV_DTDOCU
      REPLACE MAG_CODTAG WITH M.MOV_CODTAG
      REPLACE MAG_DESTAG WITH M.MOV_DESTAG
      REPLACE MAG_CODCOL WITH M.MOV_CODCOL
      REPLACE MAG_DESCOL WITH M.MOV_DESCOL
      REPLACE MAG_CODPDV WITH M.MOV_CODPDV	
      REPLACE MAG_UNIQUE WITH SYS(2015)
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
	IF MAG_GIACEN < 0
	   REPLACE MAG_GIACEN WITH 0
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_QTAIMP WITH 0
	ENDIF
	IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	ENDIF
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_AN","W")
      return(.f.)
   ENDIF
   
   SELECT CUY_MAG_MOV
   APPEND BLANK
   GATHER MEMVAR MEMO

   SELECT CUR_MAG_MOV
   GO TOP
   SCATTER MEMVAR MEMO

   SELECT CUY_MAG_MOV
   REPLACE ID_UNIQUE  WITH ""
   REPLACE MOV_TOP    WITH M.MOV_TOP
   REPLACE MOV_NUMDOC WITH M.MOV_NUMDOC
   REPLACE MOV_DTDOCU WITH M.MOV_DTDOCU
   REPLACE MOV_DTREGI WITH M.MOV_DTREGI
   REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
   REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
   REPLACE MOV_ORAMOV WITH TIME()					
   REPLACE MOV_SEGNO  WITH '+'					
   REPLACE MOV_FLGTRA WITH .F.
   REPLACE MOV_TRASME WITH .F.
   REPLACE MOV_LEGSYS WITH _LEGSYS
   REPLACE MOV_TIPORI WITH M.MOV_TIPORI
   REPLACE MOV_NUMORI WITH M.MOV_NUMORI
   REPLACE MOV_DATORI WITH M.MOV_DATORI
   REPLACE MOV_FLGTRA WITH .F.
   REPLACE MOV_UNIQUE WITH SYS(2015)
   REPLACE MOV_CODOPE WITH PUB_CODOPE
   REPLACE MOV_NOMOPE WITH PUB_NOMOPE
   IF EMPTY(ALLTRIM(MOV_ANNO))
      REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
   ENDIF
   REPLACE MOV_NUMMOV WITH PUB_NUMCSI				&& RINO 20/10/2006
   SCATTER MEMVAR MEMO
   
   **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
   DO GESTIONE_SALDI_MOV
      
   SELECT U_MAG_MO
   SKIP +1
      
ENDDO

SELECT CUY_MAG_MOV
GO TOP

IF !ExecRW('','u_mag_mo','I','','CUY_MAG_MOV')
   return(.f.)
ENDIF

RETURN



** ###################################################################################### **
**  Funzione per la gestione delle movimentazioni articolo su anagrafica articoli
**  e creazione achivio riepiloghi di magazzino per le varie viste sulle valorizzazioni
** ###################################################################################### **
**
** I SEGMENTI CREATI SONO I SEGUENTI : 
**
**   1) RECORD RIEPILOGATIVO VALORI VENDUTO / COSTI ACQUISTO A LIVELLO DI :  CODICE MAGAZINO
**
**
**	_NEW_SEGNO : SE = +/- SIGNIFICA CHE SI STA CONTROAGGIORNAMDO IL MAGAZZINO ANNULLANDO O VARIANDO LE QTA MOVIMENTATE
**


FUNCTION MOVIARTI
PARA _CODART,_CODMAG,_NUMDOC,_DATDOC,_QTADOC,_PRZCOS,_PRZVEN,_CODCAU,_CLIFOR,_DESFOR,_CODACQ,_DESACQ,_MATCHC,_NEW_SEGNO


SET EXACT ON
 
RELEASE NATURA_OPERAZIONE_ORIGINALE
PUBLIC NATURA_OPERAZIONE_ORIGINALE
NATURA_OPERAZIONE_ORIGINALE = ' '

PRIMA=SELECT()


IF PUB_PROGAA				&& SE FUNZIONE NON ATTIVATA IN U_AZI_AN TERMINA IMMEDIATAMENTE
ELSE
   SELECT(PRIMA)
   RETURN(.T.)
ENDIF


IF SUBSTR(_DATDOC,3,1) = '/'
   _DATDOC = RIBALTA2(_DATDOC)
ENDIF

 
   
x_cond = "codice = 'TOP" + ALLTRIM(_CODCAU) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"CUR_PARA")
   return(.f.)
ENDIF
SELECT CUR_PARA
IF RECCOUNT() <> 0
   M.NAT	 =SUBSTR(LIBERA,1,1)   	&& (NATURA C=CARICO - S=SCARICO - D=DARE - A=AVERE)
   M.LIB	 =SUBSTR(LIBERA,12,1)  	&& (C=CLIENTE - F=FORNITORE - +/-=COMP.D.B. - A=ALTRO)
   M.CSC     =SUBSTR(LIBERA,25,1)  	&& (X=CARICO/SCARICO COMPONENTI ATTIVATO)
   M.IMPE    =SUBSTR(LIBERA,26,1)  	&& (X=CARICO/SCARICO IMPEGNATO ATTIVATO)
   M.RFOR    =SUBSTR(LIBERA,27,1)  	&& (X=CARICO/SCARICO RESO A FORNITORE)
   M.RCLI    =SUBSTR(LIBERA,28,1)  	&& (X=CARICO/SCARICO RESO DA CLIENTE)
   M.CLAV    =SUBSTR(LIBERA,29,1)  	&& (C=CARICO - S=SCARICO QTA' C/LAVORO)
   M.CDEP    =SUBSTR(LIBERA,30,1)  	&& (C=CARICO - S=SCARICO QTA' DEPOSITO)
   M.TMOV   = SUBSTR(LIBERA,33,2)	&& (RE=RESA A FORNITORE )

   IF M.NAT = 'C' OR  M.NAT = 'S'
	   IF M.NAT = 'C'
	       NATURA_OPERAZIONE_ORIGINALE = '+'		&& SI SALVA LA NATURA ORIGINALE PER I CONTROAGGIORNAMENTI SI DOCUMENTI
	   ELSE
	       NATURA_OPERAZIONE_ORIGINALE = '-'
	   ENDIF
   ENDIF

ELSE
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF

IF _NEW_SEGNO <> SPACE(01)				&& CONTROAGGORNAMENTO MOVIMENTO DI MAGAZZINO : FORZA VALORI

	IF _NEW_SEGNO = "+"		
		M.NAT = 'C'
	ELSE
		M.NAT = 'S'
	ENDIF	

	M.TMOV = "MO"

ENDIF

IF M.NAT = 'C' .OR. M.NAT = 'S'
ELSE
   SELECT(PRIMA)
   RETURN(.t.)
ENDIF


** ######################################### ACCESSO ALL'ANAGRAFICA ARTICOLI


x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"U_ART_PR")
   return(.f.)
ENDIF
SELECT U_ART_PR
SCATTER MEMVAR MEMO


** ######################################### PREPARA LE VARIABILI COMUNI A TUTTI I SEGMENTI 

RELEASE RIE_CODSOC,RIE_QTRESF,RIE_VARESF,RIE_QTRESC,RIE_VARESC,RIE_DESART,RIE_DESFOR,RIE_DESACQ,RIE_DATAGG,RIE_DESMAG,RIE_VACARI,RIE_VASCAR
RELEASE RIE_QTMOVI,RIE_VALVEN,RIE_VALCOS,RIE_SCOSTA,RIE_PERSCO,RIE_QTRESF,RIE_VARESF,RIE_QTRESC,RIE_VARESC,RIE_QTCARI,RIE_QTSCAR

PUBLIC RIE_CODSOC,RIE_QTRESF,RIE_VARESF,RIE_QTRESC,RIE_VARESC,RIE_DESART,RIE_DESFOR,RIE_DESACQ,RIE_DATAGG,RIE_DESMAG,RIE_VACARI,RIE_VASCAR
PUBLIC RIE_QTMOVI,RIE_VALVEN,RIE_VALCOS,RIE_SCOSTA,RIE_PERSCO,RIE_QTRESF,RIE_VARESF,RIE_QTRESC,RIE_VARESC,RIE_QTCARI,RIE_QTSCAR

RELEASE RIE_UNIQUE,RIE_FLGTRA,RIE_VAVEND
PUBLIC RIE_UNIQUE,RIE_FLGTRA,RIE_VAVEND

RIE_UNIQUE = SPACE(10)
RIE_FLGTRA = .F.
RIE_VAVEND = 0

V_OGGI   = RIBALTA2(DTOC(DATE()))
X_ANNO   = SUBSTR(_DATDOC,1,4)
X_MESE   = SUBSTR(_DATDOC,6,2)
X_PERI_X = X_ANNO+X_MESE

M.MAG_CODSOC		= PUB_CODSOC
M.MAG_QTRESF 		= 0
M.MAG_VARESF 		= 0
M.MAG_QTRESC 		= 0
M.MAG_VARESC 		= 0
M.MAG_DESART		= M.ART_DESCR
M.MAG_DESFOR 		= _DESFOR
M.MAG_DESACQ		= _DESACQ
M.MAG_DESMAG        = SPACE(30)

M.MAG_QTCARI		= 0
M.MAG_VACARI		= 0
M.MAG_QTSCAR		= 0
M.MAG_VASCAR		= 0

M.MAG_VAVEND		= 0

M.MAG_DATAGG 		=  V_OGGI
M.MAG_UNIQUE 		= SPACE(10)
M.MAG_FLGTRA 		= .F.

DO CASE
	CASE M.NAT = 'C'	&& OPERAZIONE DI CARICO  MAGAZZINO

			IF  NATURA_OPERAZIONE_ORIGINALE = '-'	
				**  STO FACENDO UNO SCARICO DI MAGAZZINO E STO AGGIORNANDO UNA RIGA ESISTENTE DELLA DDT
				**  IN QUESTO CASO LO SCARICO INIZIALE VIENE DECURTATO DELLA QTA ORIGINALE 
				M.MAG_QTSCAR		= _QTADOC   
				M.MAG_VASCAR		= _QTADOC * _PRZCOS
				M.MAG_VAVEND		= _QTADOC * _PRZVEN  
			ELSE
*!*				    IF PUB_SPOSTAMAGA
*!*				    ELSE
	  				M.MAG_QTCARI		= _QTADOC 					&& QUANTITA' CARICATA
					M.MAG_VACARI		= _QTADOC * _PRZCOS			&& VALORE QUANTITA' CARICATA
*!*	 				ENDIF
			ENDIF

			M.MAG_QTMOVI		= _QTADOC   
			M.MAG_VALVEN		= _QTADOC * _PRZVEN
			M.MAG_VALCOS		= _QTADOC * _PRZCOS
			M.MAG_SCOSTA		= M.MAG_VALVEN - M.MAG_VALCOS
			_PERSCO				= (M.MAG_SCOSTA/M.MAG_VALVEN)*100
			__PERSCO			= STR(_PERSCO,12,2)
			M.MAG_PERSCO		= VAL(__PERSCO)
			IF M.MAG_SCOSTA < 0
				M.MAG_PERSCO		= VAL(__PERSCO) * -1
			ENDIF
			IF M.TMOV = 'RE'		&& OPERAZIONE DI RESA A FORNITORE
				M.MAG_QTRESF 		= _QTADOC 
				M.MAG_VARESF 		= _QTADOC * _PRZCOS
			ENDIF

			IF M.TMOV = 'RC'		&& OPERAZIONE DI RESA A CLIENTE
				M.MAG_QTRESC 		= _QTADOC 
				M.MAG_VARESC 		= _QTADOC * _PRZVEN
			ENDIF


	CASE M.NAT = 'S'	&& OPERAZIONE DI SCARICO MAGAZZINO

			___QTADOC = _QTADOC * -1  

			IF  NATURA_OPERAZIONE_ORIGINALE = '+'	
				**  STO FACENDO UN CARICO DI MAGAZZINO E STO AGGIORNANDO UNA RIGA ESISTENTE DELLA DDT
				**  IN QUESTO CASO IL CARICO INIZIALE VIENE DECURTATO DELLA QTA ORIGINALE (_QTADOC E' NEGATIVA)
				M.MAG_QTCARI		= ___QTADOC 					&& QUANTITA' CARICATA
				M.MAG_VACARI		= ___QTADOC * _PRZCOS			&& VALORE QUANTITA' CARICATA
			ELSE
*!*				    IF PUB_SPOSTAMAGA
*!*				    ELSE
	   				M.MAG_QTSCAR		= ___QTADOC * -1			   	    && QUANTITA' SCARICATA PER VENDITA 
					M.MAG_VASCAR		= (___QTADOC * _PRZCOS) * -1		&& VALORE COSTO SCARICATO
					M.MAG_VAVEND		= (___QTADOC * _PRZVEN) * -1		&& VALORE VENDITA SCARICATA
*!*	 				ENDIF
			ENDIF

			M.MAG_QTMOVI		= ___QTADOC 
			M.MAG_VALVEN		= ___QTADOC * _PRZVEN
			M.MAG_VALCOS		= ___QTADOC * _PRZCOS
			M.MAG_SCOSTA		= M.MAG_VALVEN - M.MAG_VALCOS
			_PERSCO				= (M.MAG_SCOSTA/M.MAG_VALVEN)*100
			__PERSCO			= STR(_PERSCO,12,2)
			M.MAG_PERSCO		= VAL(__PERSCO)
			IF M.MAG_SCOSTA < 0
				M.MAG_PERSCO		= VAL(__PERSCO) * -1
			ENDIF

			IF M.TMOV = 'RE'		&& OPERAZIONE DI RESA A FORNITORE
				M.MAG_QTRESF 		= ___QTADOC 
				M.MAG_VARESF 		= ___QTADOC * _PRZCOS
			ENDIF

			IF M.TMOV = 'RC'		&& OPERAZIONE DI RESA A CLIENTE
				M.MAG_QTRESC 		= ___QTADOC 
				M.MAG_VARESC 		= ___QTADOC * _PRZVEN
			ENDIF


ENDCASE


**  SALVA LE VARIABILI ORIGINALI PER I SEGMENTI SUCCESSIVI
RIE_CODSOC		= M.MAG_CODSOC
RIE_DESART		= M.MAG_DESART
RIE_DESFOR 		= M.MAG_DESFOR
RIE_DESACQ		= M.MAG_DESACQ
RIE_DESMAG      = M.MAG_DESMAG

RIE_QTMOVI		= M.MAG_QTMOVI

RIE_QTCARI		= M.MAG_QTCARI
RIE_VACARI		= M.MAG_VACARI
RIE_QTSCAR		= M.MAG_QTSCAR
RIE_VASCAR		= M.MAG_VASCAR

RIE_VAVEND		= M.MAG_VAVEND

RIE_VALVEN		= M.MAG_VALVEN
RIE_VALCOS		= M.MAG_VALCOS
RIE_SCOSTA		= M.MAG_SCOSTA
RIE_PERSCO		= M.MAG_PERSCO
RIE_QTRESF 		= M.MAG_QTRESF 
RIE_VARESF 		= M.MAG_VARESF
RIE_QTRESC 		= M.MAG_QTRESC 
RIE_VARESC 		= M.MAG_VARESC

RIE_DATAGG 		= M.MAG_DATAGG 
RIE_UNIQUE 		= M.MAG_UNIQUE
RIE_FLGTRA 		= M.MAG_FLGTRA



** ######################################### CREAZIONE SEGMENTI PER LE VALORIZZAZIONI DI MAGAZZINO

IF PUB_VMAGAZ
	_TIPO_VISTA 						= "MAGAZZINO"
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)
ENDIF

IF PUB_VMAGPE
	_TIPO_VISTA 						= "MAGAZZINO-PERIODO"
	=SPOSTA_VARIABILI_COMUNI()
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)
ENDIF

IF PUB_VMAGAR
	_TIPO_VISTA 						= "MAGAZZINO-ARTICOLO"
	=SPOSTA_VARIABILI_COMUNI()
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)
ENDIF

IF PUB_VARTIC
	_TIPO_VISTA 						= "ARTICOLO"
	=SPOSTA_VARIABILI_COMUNI()
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)
ENDIF

IF PUB_VMARPE
	_TIPO_VISTA 						= "MAGAZZINO-ARTICOLO-AAAAMM"
	=SPOSTA_VARIABILI_COMUNI()
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)
ENDIF

IF PUB_VFOMAR
	_TIPO_VISTA 						= "FORNITORE-MAGAZZINO-ARTICOLO"
	=SPOSTA_VARIABILI_COMUNI()
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)
ENDIF

IF PUB_VFOMAP
	_TIPO_VISTA 						= "FORNITORE-MAGAZZINO-ARTICOLO-AAAAMM"
	=SPOSTA_VARIABILI_COMUNI()
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)
ENDIF

IF PUB_VFORNI
	_TIPO_VISTA 						= "FORNITORE"
	=SPOSTA_VARIABILI_COMUNI()
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)
ENDIF

IF PUB_VMAGTC
	_TIPO_VISTA 						= "MAGAZZINO-TIPO-CONTRATTO"
	=SPOSTA_VARIABILI_COMUNI()
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)

	_TIPO_VISTA 						= "MAGAZZINO-TIPO-CONTRATTO-AAAAMM"
	=SPOSTA_VARIABILI_COMUNI()
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)

ENDIF

IF PUB_VMATCH
	_TIPO_VISTA 						= "MATCH-CODE"
	=SPOSTA_VARIABILI_COMUNI()
	=CREA_VISTE_MAGAZZINO(_TIPO_VISTA)
ENDIF

SELECT(PRIMA)

RETURN(.T.)


*******************************************************************************
*       PREPARA LE VARIABILI COMUNI PER LA CREAZIONE DELLE VISTE DI MAGAZZINO
*******************************************************************************

FUNCTION SPOSTA_VARIABILI_COMUNI

M.MAG_CODSOC		= RIE_CODSOC
M.MAG_DESART		= RIE_DESART
M.MAG_DESFOR 		= RIE_DESFOR
M.MAG_DESACQ		= RIE_DESACQ


M.MAG_QTMOVI		= RIE_QTMOVI

M.MAG_QTCARI		= RIE_QTCARI
M.MAG_VACARI		= RIE_VACARI
M.MAG_QTSCAR		= RIE_QTSCAR
M.MAG_VASCAR		= RIE_VASCAR

M.MAG_VAVEND		= RIE_VAVEND

M.MAG_VALVEN		= RIE_VALVEN
M.MAG_VALCOS		= RIE_VALCOS
M.MAG_SCOSTA		= RIE_SCOSTA
M.MAG_PERSCO		= RIE_PERSCO
M.MAG_QTRESF 		= RIE_QTRESF 
M.MAG_VARESF 		= RIE_VARESF
M.MAG_QTRESC 		= RIE_QTRESC 
M.MAG_VARESC 		= RIE_VARESC

M.MAG_DATAGG 		= RIE_DATAGG 

M.MAG_UNIQUE 		= RIE_UNIQUE
M.MAG_FLGTRA 		= RIE_FLGTRA

RETURN(.T.)


*******************************************************************************
*       CREA VISTE FISICHE PER LA VALORIZZAZIONE DEL MAGAZZINO
*******************************************************************************

FUNCTION CREA_VISTE_MAGAZZINO
PARA _TIPO_VISTA_


DO CASE 
	CASE _TIPO_VISTA_ = "MAGAZZINO"   

		** ___________________________CHIAVE PER "MAGAZZINO"									&& ################# 1
		__CODMAG 	= _CODMAG
		__PERI 		= SPACE(06)
		__CODART 	= SPACE(16)
		__CLIFOR    = SPACE(10)
		__CODACQ   	= SPACE(03)
		__MATCHC 	= SPACE(50)

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_DESART		= SPACE(16)
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_DESFOR 		= SPACE(30)
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.


	CASE _TIPO_VISTA_ = "MAGAZZINO-PERIODO"

		** ___________________________CHIAVE PER "MAGAZZINO-PERIODO"							&& ################# 2
		__CODMAG 	= _CODMAG
		__PERI 		= X_PERI_X
		__CODART 	= SPACE(16)
		__CLIFOR    = SPACE(10)
		__CODACQ   	= SPACE(03)
		__MATCHC 	= SPACE(50)

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_DESART		= SPACE(16)
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_DESFOR 		= SPACE(30)
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.

	CASE _TIPO_VISTA_ = "MAGAZZINO-ARTICOLO"

		** ___________________________CHIAVE PER "MAGAZZINO-ARTICOLO"							&& ################# 3
		__CODMAG 	= _CODMAG
		__PERI 		= SPACE(06)
		__CODART 	= _CODART
		__CLIFOR    = SPACE(10)
		__CODACQ   	= SPACE(03)
		__MATCHC 	= SPACE(50)

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_DESFOR 		= SPACE(30)
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.

	CASE _TIPO_VISTA_ = "ARTICOLO"

		** ___________________________CHIAVE PER "ARTICOLO"										&& ################# 4
		__CODMAG 	= SPACE(06)
		__PERI 		= SPACE(06)
		__CODART 	= _CODART
		__CLIFOR    = SPACE(10)
		__CODACQ   	= SPACE(03)
		__MATCHC 	= SPACE(50)

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_DESFOR 		= SPACE(30)
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.
		
	CASE _TIPO_VISTA_ = "MAGAZZINO-ARTICOLO-AAAAMM"

		** ___________________________CHIAVE PER "MAGAZZINO-ARTICOLO-AAAAMM"					&& ################# 5
		__CODMAG 	= _CODMAG
		__PERI 		= X_PERI_X
		__CODART 	= _CODART
		__CLIFOR    = SPACE(10)
		__CODACQ   	= SPACE(03)
		__MATCHC 	= SPACE(50)

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_DESFOR 		= SPACE(30)
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.
				
	CASE _TIPO_VISTA_ = "FORNITORE-MAGAZZINO-ARTICOLO"

		** ___________________________CHIAVE PER "FORNITORE-MAGAZZINO-ARTICOLO"					&& ################# 6
		__CODMAG 	= _CODMAG
		__PERI 		= SPACE(06)
		__CODART 	= _CODART
		__CLIFOR    = _CLIFOR
		__CODACQ   	= _CODACQ
		__MATCHC 	= SPACE(50)

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.		
				
	CASE _TIPO_VISTA_ = "FORNITORE-MAGAZZINO-ARTICOLO-AAAAMM"

		** ___________________________CHIAVE PER "FORNITORE-MAGAZZINO-ARTICOLO-AAAAMM"			&& ################# 7
		__CODMAG 	= _CODMAG
		__PERI 		= X_PERI_X
		__CODART 	= _CODART
		__CLIFOR    = _CLIFOR
		__CODACQ   	= _CODACQ
		__MATCHC 	= SPACE(50)

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.
		
	CASE _TIPO_VISTA_ = "FORNITORE"

		** ___________________________CHIAVE PER "FORNITORE"									&& ################# 8
		__CODMAG 	= SPACE(06)
		__PERI 		= SPACE(06)
		__CODART 	= SPACE(16)
		__CLIFOR    = _CLIFOR
		__CODACQ   	= SPACE(03)
		__MATCHC 	= SPACE(50)

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_DESART		= SPACE(16)		
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.
		
	CASE _TIPO_VISTA_ = "MAGAZZINO-TIPO-CONTRATTO"   

		** ___________________________CHIAVE PER "MAGAZZINO-TIPO-CONTRATTO"						&& ################# 9
		__CODMAG 	= _CODMAG
		__PERI 		= SPACE(06)
		__CODART 	= SPACE(16)
		__CLIFOR    = SPACE(10)
		__CODACQ   	= _CODACQ
		__MATCHC 	= SPACE(50)

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_DESART		= SPACE(16)
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_DESFOR 		= SPACE(30)
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.
		
	CASE _TIPO_VISTA_ = "MAGAZZINO-TIPO-CONTRATTO-AAAAMM"   

		** ___________________________CHIAVE PER "MAGAZZINO-TIPO-CONTRATTO-AAAAMM"					&& ################# 9
		__CODMAG 	= _CODMAG
		__PERI 		= X_PERI_X
		__CODART 	= SPACE(16)
		__CLIFOR    = SPACE(10)
		__CODACQ   	= _CODACQ
		__MATCHC 	= SPACE(50)

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_DESART		= SPACE(16)
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_DESFOR 		= SPACE(30)
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.
		
	CASE _TIPO_VISTA_ = "MATCH-CODE"   

		** ___________________________CHIAVE PER "MATCH-CODE"									&& ################# 10
		__CODMAG 	= SPACE(06)
		__PERI 		= SPACE(06)
		__CODART 	= SPACE(16)
		__CLIFOR    = SPACE(10)
		__CODACQ   	= SPACE(03)
		__MATCHC 	= _MATCHC

		** ___________________________DATI
		M.MAG_CODMAG		= __CODMAG
		M.MAG_PERI    		= __PERI
		M.MAG_CODART 		= __CODART
		M.MAG_DESART		= SPACE(16)
		M.MAG_FORNIT 		= __CLIFOR
		M.MAG_DESFOR 		= SPACE(30)
		M.MAG_CODACQ		= __CODACQ
		M.MAG_DESACQ		= CERCA_DESCRIZIONE_TIPOCONTR(M.MAG_CODACQ)
		M.MAG_MATCHC   		= __MATCHC
		M.MAG_DESMAG		= CERCA_DESCRIZIONE_MAGAZZINO(M.MAG_CODMAG)
		M.MAG_FLGTRA		= .F.

ENDCASE


x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
x_peri = "mag_peri = '" + __PERI + "'"
x_maga = "mag_codmag = '" + ALLTRIM(__CODMAG) + "'"
x_arti = "mag_codart = '" + ALLTRIM(__CODART) + "'"
x_forn = "mag_fornit = '" + ALLTRIM(__CLIFOR) + "'"
x_coda = "mag_codacq = '" + ALLTRIM(__CODACQ) + "'"
x_matc = "mag_matchc = '" + ALLTRIM(__MATCHC) + "'"
x_cond = x_soci + " and " + x_peri + " and " + x_maga + " and " + x_arti  + " and " + x_forn  + " and " + x_coda  + " and " + x_matc

 

DO CASE 	

	CASE _TIPO_VISTA_ = "ARTICOLO"

		Csql   = "select * from u_mag_ar where " + x_cond + " order by mag_codart"

		IF !ExecCommand(cSql,"U_MAG_AR")
		   return(.f.)
		ENDIF


		SELECT U_MAG_AR
		IF RECCOUNT() = 0
		   APPEND BLANK
		   =SE_SCARICO_E_PRIMA_VOLTA()
		ELSE
		   =VALORIZZA_MAGAZZINO()
		ENDIF



	CASE _TIPO_VISTA_ = "MAGAZZINO-ARTICOLO"

		Csql   = "select * from u_mag_ma where " + x_cond + " order by mag_codmag"

		IF !ExecCommand(cSql,"U_MAG_MA")
		   return(.f.)
		ENDIF


		SELECT U_MAG_MA
		IF RECCOUNT() = 0
		   APPEND BLANK
		   =SE_SCARICO_E_PRIMA_VOLTA()
		ELSE
		   =VALORIZZA_MAGAZZINO()
		ENDIF


	CASE _TIPO_VISTA_ = "MAGAZZINO-ARTICOLO-AAAAMM"

		Csql   = "select * from u_mag_ma where " + x_cond + " order by mag_codmag"

		IF !ExecCommand(cSql,"U_MAG_MA")
		   return(.f.)
		ENDIF


		SELECT U_MAG_MA
		IF RECCOUNT() = 0
		   APPEND BLANK
		   =SE_SCARICO_E_PRIMA_VOLTA()
		ELSE
		   =VALORIZZA_MAGAZZINO()
		ENDIF

	CASE _TIPO_VISTA_ = "FORNITORE-MAGAZZINO-ARTICOLO"


		Csql   = "select * from u_mag_mf where " + x_cond + " order by mag_codmag"

		IF !ExecCommand(cSql,"U_MAG_MF")
		   return(.f.)
		ENDIF


		SELECT U_MAG_MF
		IF RECCOUNT() = 0
		   APPEND BLANK
		   =SE_SCARICO_E_PRIMA_VOLTA()
		ELSE
		   =VALORIZZA_MAGAZZINO()
		ENDIF


	CASE _TIPO_VISTA_ = "FORNITORE-MAGAZZINO-ARTICOLO-AAAAMM"

		Csql   = "select * from u_mag_mf where " + x_cond + " order by mag_codmag"

		IF !ExecCommand(cSql,"U_MAG_MF")
		   return(.f.)
		ENDIF


		SELECT U_MAG_MF
		IF RECCOUNT() = 0
		   APPEND BLANK
		   =SE_SCARICO_E_PRIMA_VOLTA()
		ELSE
		   =VALORIZZA_MAGAZZINO()
		ENDIF



	CASE _TIPO_VISTA_ = "FORNITORE"

		Csql   = "select * from u_mag_fo where " + x_cond + " order by mag_codmag"

		IF !ExecCommand(cSql,"U_MAG_FO")
		   return(.f.)
		ENDIF


		SELECT U_MAG_FO
		IF RECCOUNT() = 0
		   APPEND BLANK
		   =SE_SCARICO_E_PRIMA_VOLTA()
		ELSE
		   =VALORIZZA_MAGAZZINO()
		ENDIF


	OTHERWISE
		
		Csql   = "select * from u_mag_ri where " + x_cond + " order by mag_codmag"

		IF !ExecCommand(cSql,"U_MAG_RI")
		   return(.f.)
		ENDIF


		SELECT U_MAG_RI
		IF RECCOUNT() = 0
		   APPEND BLANK
		   =SE_SCARICO_E_PRIMA_VOLTA()
		ELSE
		   =VALORIZZA_MAGAZZINO()
		ENDIF


ENDCASE


DO U_MAG_RI			&& AGGIORNA/ CREA I RIEPILOGHI A SECONDA DELLA TABELLA SELEZIONATA IN PRECEDENZA



DO CASE 	

	CASE _TIPO_VISTA_ = "ARTICOLO"

		IF !ExecRW('','U_MAG_AR','I','','U_MAG_AR')
		  return(.f.)
		ENDIF

	CASE _TIPO_VISTA_ = "MAGAZZINO-ARTICOLO"

		IF !ExecRW('','U_MAG_MA','I','','U_MAG_MA')
		  return(.f.)
		ENDIF

	CASE _TIPO_VISTA_ = "MAGAZZINO-ARTICOLO-AAAAMM"

		IF !ExecRW('','U_MAG_MA','I','','U_MAG_MA')
		  return(.f.)
		ENDIF
		
	CASE _TIPO_VISTA_ = "FORNITORE-MAGAZZINO-ARTICOLO"

		IF !ExecRW('','U_MAG_MF','I','','U_MAG_MF')
		  return(.f.)
		ENDIF

	CASE _TIPO_VISTA_ = "FORNITORE-MAGAZZINO-ARTICOLO-AAAAMM"

		IF !ExecRW('','U_MAG_MF','I','','U_MAG_MF')
		  return(.f.)
		ENDIF

	CASE _TIPO_VISTA_ = "FORNITORE"

		IF !ExecRW('','U_MAG_FO','I','','U_MAG_FO')
		  return(.f.)
		ENDIF

	OTHERWISE
		
		IF !ExecRW('','U_MAG_RI','I','','U_MAG_RI')
		  return(.f.)
		ENDIF

ENDCASE



RETURN(.T.)


*******************************************************************************
*       			VALORIZZAZIONE DEL MAGAZZINO
*******************************************************************************

FUNCTION SE_SCARICO_E_PRIMA_VOLTA

M.MAG_UNIQUE =  sys(2015)		&& ASSEGNA PER TUTTI IL SYS PER GLI AGGANCI CON I DEMONI RELATIVI AGLI SCARICHI DA INCASSO E/O VARIE

IF M.NAT = 'S'	&& OPERAZIONE DI SCARICO MAGAZZINO

	M.MAG_VASCAR    = ABS(M.MAG_VASCAR)
	M.MAG_VALVEN    = ABS(M.MAG_VALVEN)
	M.MAG_VALCOS    = ABS(M.MAG_VALCOS)
	M.MAG_SCOSTA    = ABS(M.MAG_SCOSTA)	
	M.MAG_PERSCO    = ABS(M.MAG_PERSCO)	
	M.MAG_VAVEND    = ABS(M.MAG_VAVEND)
		
ENDIF

RETURN(.T.)


*******************************************************************************
*       			VALORIZZAZIONE DEL MAGAZZINO
*******************************************************************************

FUNCTION VALORIZZA_MAGAZZINO

SCATTER MEMVAR MEMO

M.MAG_UNIQUE =  MAG_UNIQUE		&& RIASSEGNA LA VARIABILE PER TUTTI I RIEPILOGHI


	DO CASE
		CASE M.NAT = 'C'	&& OPERAZIONE DI CARICO  MAGAZZINO


				IF  NATURA_OPERAZIONE_ORIGINALE = '-'	
					**  STO FACENDO UNO SCARICO DI MAGAZZINO E STO AGGIORNANDO UNA RIGA ESISTENTE DELLA DDT
					**  IN QUESTO CASO LO SCARICO INIZIALE VIENE SOMMATO DELLA QTA ORIGINALE 
					M.MAG_QTSCAR		= MAG_QTSCAR -	_QTADOC   
					M.MAG_VASCAR		= MAG_VASCAR - 	(_QTADOC * _PRZCOS)
					M.MAG_VAVEND		= MAG_VAVEND - 	(_QTADOC * _PRZVEN)
				ELSE
*!*					    IF PUB_SPOSTAMAGA
*!*					    ELSE
						M.MAG_QTCARI		= MAG_QTCARI +_QTADOC 					&& QUANTITA' CARICATA
						M.MAG_VACARI		= MAG_VACARI + (_QTADOC * _PRZCOS)		&& VALORE QUANTITA' CARICATA
*!*						ENDIF
				ENDIF
				
				M.MAG_QTMOVI		= MAG_QTMOVI +_QTADOC 
				M.MAG_VALVEN		= MAG_VALVEN + (_QTADOC * _PRZVEN)
				M.MAG_VALCOS		= MAG_VALCOS + (_QTADOC * _PRZCOS)
				M.MAG_SCOSTA		= M.MAG_VALVEN - M.MAG_VALCOS
				_PERSCO				= (M.MAG_SCOSTA/M.MAG_VALVEN)*100
				__PERSCO			= STR(_PERSCO,12,2)
				M.MAG_PERSCO		= VAL(__PERSCO)
				IF M.MAG_SCOSTA < 0
					M.MAG_PERSCO		= VAL(__PERSCO) * -1
				ENDIF
			
				IF M.TMOV = 'RE'		&& OPERAZIONE DI RESA A FORNITORE
					M.MAG_QTRESF 		= MAG_QTRESF + _QTADOC 
					M.MAG_VARESF 		= MAG_VARESF + (_QTADOC * _PRZCOS)
				ENDIF

				IF M.TMOV = 'RC'		&& OPERAZIONE DI RESA A CLIENTE
					M.MAG_QTRESC 		= MAG_QTRESC + _QTADOC 
					M.MAG_VARESC 		= MAG_VARESC + (_QTADOC * _PRZCOS)
				ENDIF
				
		CASE M.NAT = 'S'	&& OPERAZIONE DI SCARICO MAGAZZINO

				IF  NATURA_OPERAZIONE_ORIGINALE = '+'	
					**  STO FACENDO UN CARICO DI MAGAZZINO E STO AGGIORNANDO UNA RIGA ESISTENTE DELLA DDT
					**  IN QUESTO CASO IL CARICO INIZIALE VIENE DECURTATO DELLA QTA ORIGINALE 
					M.MAG_QTCARI		= MAG_QTCARI -  _QTADOC 					&& QUANTITA' CARICATA
					M.MAG_VACARI		= MAG_VACARI -  (_QTADOC * _PRZCOS)			&& VALORE QUANTITA' CARICATA
				ELSE
*!*					    IF PUB_SPOSTAMAGA
*!*					    ELSE
	 				    M.MAG_QTSCAR		= MAG_QTSCAR +_QTADOC   
					    M.MAG_VASCAR		= MAG_VASCAR + (_QTADOC * _PRZCOS)
					    M.MAG_VAVEND		= MAG_VAVEND + (_QTADOC * _PRZVEN)
*!*						ENDIF
				ENDIF

				M.MAG_QTMOVI		= MAG_QTMOVI -_QTADOC   
				M.MAG_VALVEN		= MAG_VALVEN - (_QTADOC * _PRZVEN)
				M.MAG_VALCOS		= MAG_VALCOS - (_QTADOC * _PRZCOS)
				M.MAG_SCOSTA		= M.MAG_VALVEN - M.MAG_VALCOS
				_PERSCO				= (M.MAG_SCOSTA/M.MAG_VALVEN)*100
				__PERSCO			= STR(_PERSCO,12,2)
				M.MAG_PERSCO		= VAL(__PERSCO)
				IF M.MAG_SCOSTA < 0
					M.MAG_PERSCO		= VAL(__PERSCO) * -1
				ENDIF
			
				IF M.TMOV = 'RE'		&& OPERAZIONE DI RESA A FORNITORE
					M.MAG_QTRESF 		= MAG_QTRESF - _QTADOC 
					M.MAG_VARESF 		= MAG_VARESF - (_QTADOC * _PRZCOS)
				ENDIF

				IF M.TMOV = 'RC'		&& OPERAZIONE DI RESA A CLIENTE
					M.MAG_QTRESC 		= MAG_QTRESC - _QTADOC 
					M.MAG_VARESC 		= MAG_VARESC - (_QTADOC * _PRZCOS)
				ENDIF
	ENDCASE

   PUB_SPOSTAMAGA = .F.



RETURN(.T.)

*******************************************************************************
*       CERCA DESCRIZIONE MAGAZZINO
*******************************************************************************

FUNCTION CERCA_DESCRIZIONE_MAGAZZINO
PARA _CODMAG_

IF EMPTY(_CODMAG_)
   	_DESMAG_       = SPACE(30)
	RETURN(_DESMAG_)
ENDIF

v_seek   = 'MAG'+ALLTRIM(_CODMAG_)
v_chiave = 'codice'
cSql="SELECT * FROM para WHERE "+V_CHIAVE+ " = ?V_SEEK"
IF !ExecCommand(cSql,"mag_para")
   return(.f.)
ENDIF
SELECT MAG_PARA
GO TOP
IF EOF()
   _DESMAG_       = SPACE(30)
ELSE
   _DESMAG_       = DESCRI
ENDIF

RETURN(_DESMAG_)


*******************************************************************************
*       CERCA DESCRIZIONE TIPO CONTRATTO
*******************************************************************************

FUNCTION CERCA_DESCRIZIONE_TIPOCONTR
PARA _CODACQ_

IF EMPTY(_CODACQ_)
   	_DESACQ_       = SPACE(30)
	RETURN(_DESACQ_)
ENDIF

v_seek   = 'TCA'+ALLTRIM(_CODACQ_)
v_chiave = 'codice'
cSql     = "SELECT * FROM para WHERE "+V_CHIAVE+ " = ?V_SEEK"
IF !ExecCommand(cSql,"ACQ_para")
   return(.f.)
ENDIF
SELECT ACQ_PARA
GO TOP
IF EOF()
   _DESACQ_       = SPACE(30)
ELSE
   _DESACQ_       = DESCRI
ENDIF

RETURN(_DESACQ_)



*******************************************************************************
*       VALORIZZA IL MAGAZZINO CONSULTANDO GLI ARCHIVI DEI RIEPILOGHI
*******************************************************************************

FUNCTION CERCA_COSTO_DEL_VENDUTO
PARAMETERS _PARAMETRO_COSTO_VENDUTO,_V_CODART

SET EXACT ON

_N_PAR  = PARAMETERS()											
IF _N_PAR   = 1													
   _V_CODART  = SPACE(16)												
ENDIF																


__PERI 		= SPACE(06)
__CODMAG	= SPACE(06)
__CODACQ    = SPACE(06)
__CODART    = SPACE(16)
__CLIFOR	= SPACE(10)
__CODACQ	= SPACE(03)
__MATCHC	= SPACE(50)

__P_DATINI  = SUBSTR(_V_DATINI,7,4)+SUBSTR(_V_DATINI,4,2) 
__P_DATFIN  = SUBSTR(_V_DATFIN,7,4)+SUBSTR(_V_DATFIN,4,2)  

x_soce = "mag_codsoc = '" + PUB_CODSOC + "'"
x_peri = "mag_peri = '" + __PERI + "'"

x_maga = "mag_codmag = '" + ALLTRIM(__CODMAG) + "'"
x_coda = "mag_codacq = '" + ALLTRIM(__CODACQ) + "'"

x_arti = "mag_codart = '" + ALLTRIM(__CODART) + "'"
x_forn = "mag_fornit = '" + ALLTRIM(__CLIFOR) + "'"
x_matc = "mag_matchc = '" + ALLTRIM(__MATCHC) + "'"

 
DO CASE

	CASE _PARAMETRO_COSTO_VENDUTO == "TUTTI-MAGAZZINI"
		
			x_maga = "mag_codmag >= '" + ALLTRIM(__CODMAG) + "'"


	CASE _PARAMETRO_COSTO_VENDUTO == "TUTTI-MAGAZZINI-TIPO-CONTRATTO"

		
			x_maga = "mag_codmag >= '" + ALLTRIM(__CODMAG) + "'"
			x_coda = "mag_codacq <> '" + ALLTRIM(__CODACQ) + "'"
			x_peri = "mag_peri between '" + __P_DATINI + "' and '" + __P_DATFIN + "'"


	CASE _PARAMETRO_COSTO_VENDUTO == "TUTTI-MAGAZZINI-AAAAMM"

			
			x_peri = "mag_peri >= '" + __PERI + "'"
			x_maga = "mag_codmag >= '" + ALLTRIM(__CODMAG) + "'"
			x_peri = "mag_peri between '" + __P_DATINI + "' and '" + __P_DATFIN + "'"

	CASE _PARAMETRO_COSTO_VENDUTO == "ARTICOLO"

			
			x_arti = "mag_codart >= '" + ALLTRIM(_V_CODART) + "'"
			x_maga = "mag_codmag >= '" + ALLTRIM(__CODMAG) + "'"
*!*				x_peri = "mag_peri between '" + __P_DATINI + "' and '" + __P_DATFIN + "'"   && non è gestito il periodo su questo riepilogo


	CASE _PARAMETRO_COSTO_VENDUTO == "ARTICOLO-TUTTI-MAGAZZINI"
		
			__PERI = "1990"
			x_peri = "mag_peri >= '" + __PERI + "'"
			x_arti = "mag_codart = '" + ALLTRIM(_V_CODART) + "'"
			x_maga = "mag_codmag >= '" + ALLTRIM(__CODMAG) + "'"
			x_peri = "mag_peri between '" + __P_DATINI + "' and '" + __P_DATFIN + "'"


	CASE _PARAMETRO_COSTO_VENDUTO == "ARTICOLO-TUTTI-MAGAZZINI-AAAAMM"

		
			x_arti = "mag_codart = '" + ALLTRIM(_V_CODART) + "'"
			x_maga = "mag_codmag >= '" + ALLTRIM(__CODMAG) + "'"
			x_peri = "mag_peri between '" + __P_DATINI + "' and '" + __P_DATFIN + "'"


	CASE _PARAMETRO_COSTO_VENDUTO == "FORNITORE"


			x_forn = "mag_fornit = '" + ALLTRIM(_V_CODFOR) + "'"			
			x_arti = "mag_codart >= '" + ALLTRIM(__CODART) + "'"
			x_maga = "mag_codmag >= '" + ALLTRIM(__CODMAG) + "'"
			x_coda = "mag_codacq >= '" + ALLTRIM(__CODACQ) + "'"
			x_matc = "mag_matchc >= '" + ALLTRIM(__MATCHC) + "'"		
*!*				x_peri = "mag_peri between '" + __P_DATINI + "' and '" + __P_DATFIN + "'"   && non è gestito il periodo su questo riepilogo



	CASE _PARAMETRO_COSTO_VENDUTO == "FORNITORE-ARTICOLO-TUTTI-MAGAZZINI"


			x_forn = "mag_fornit = '" + ALLTRIM(_V_CODFOR) + "'"			

			IF !EMPTY(_V_CODART)
				x_arti = "mag_codart = '" + ALLTRIM(_V_CODART) + "'"
			ELSE
				x_arti = "mag_codart >= '" + ALLTRIM(_V_CODART) + "'"
			ENDIF
			
			x_maga = "mag_codmag >= '" + ALLTRIM(__CODMAG) + "'"

			__CODACQ	= SPACE(03)
			x_coda = "mag_codacq <> '" + ALLTRIM(__CODACQ) + "'"

			x_peri = "mag_peri between '" + __P_DATINI + "' and '" + __P_DATFIN + "'"


	

	CASE _PARAMETRO_COSTO_VENDUTO == "FORNITORE-ARTICOLO-TUTTI-MAGAZZINI-AAAAMM"

 

			x_peri = "mag_peri between '" + __P_DATINI + "' and '" + __P_DATFIN + "'"

			IF !EMPTY(_V_CODFOR)
				x_forn = "mag_fornit = '" + ALLTRIM(_V_CODFOR) + "'"			
			ELSE
				x_forn = "mag_fornit = '" + ALLTRIM(_V_CODFOR) + "'"			
			ENDIF

			IF !EMPTY(_V_CODART)
				x_arti = "mag_codart = '" + ALLTRIM(_V_CODART) + "'"
			ELSE
				x_arti = "mag_codart >= '" + ALLTRIM(_V_CODART) + "'"
			ENDIF
			x_maga = "mag_codmag >= '" + ALLTRIM(__CODMAG) + "'"

			IF !EMPTY(_CODACQ)
				__CODACQ	= _CODACQ
				x_coda = "mag_codacq = '" + ALLTRIM(__CODACQ) + "'"
			ELSE
				__CODACQ	= SPACE(03)
				x_coda = "mag_codacq <> '" + ALLTRIM(__CODACQ) + "'"
			ENDIF



	CASE _PARAMETRO_COSTO_VENDUTO == "ARTICOLO-MAGAZZINO-FORNITORE"
			
			x_arti = "mag_codart = '" + ALLTRIM(_V_CODART) + "'"
			x_maga = "mag_codmag >= '" + ALLTRIM(__CODMAG) + "'"
			x_forn = "mag_fornit >= '" + ALLTRIM(__CLIFOR) + "'"			
			x_coda = "mag_codacq >= '" + ALLTRIM(__CODACQ) + "'"
			x_matc = "mag_matchc >= '" + ALLTRIM(__MATCHC) + "'"		
			x_peri = "mag_peri between '" + __P_DATINI + "' and '" + __P_DATFIN + "'"



	CASE _PARAMETRO_COSTO_VENDUTO == "MATCH-CODE"


			x_matc = "mag_matchc >= '" + ALLTRIM(_V_MATCH_CODE) + "'"		

 

			
ENDCASE




x_cond = x_soce + " and " + x_peri + " and " + x_maga + " and " + x_arti  + " and " + x_forn  + " and " + x_coda  + " and " + x_matc




DO CASE

	CASE _PARAMETRO_COSTO_VENDUTO == "TUTTI-MAGAZZINI-TIPO-CONTRATTO"
	
			Csql   = "select * from u_mag_ri where " + x_cond + " order by mag_codmag,mag_codacq"	


	CASE _PARAMETRO_COSTO_VENDUTO == "TUTTI-MAGAZZINI-AAAAMM"
			
			Csql   = "select * from u_mag_ri where " + x_cond + " order by mag_codmag,mag_peri"	


	CASE _PARAMETRO_COSTO_VENDUTO == "ARTICOLO"
 	
			Csql   = "select * from u_mag_ar where " + x_cond + " order by mag_codart,mag_codmag"	


	CASE _PARAMETRO_COSTO_VENDUTO == "ARTICOLO-TUTTI-MAGAZZINI"
	
			Csql   = "select * from u_mag_ma where " + x_cond + " order by mag_codart,mag_codmag"	
	
	
	CASE _PARAMETRO_COSTO_VENDUTO == "ARTICOLO-TUTTI-MAGAZZINI-AAAAMM"
	
			Csql   = "select * from u_mag_ma where " + x_cond + " order by mag_codart,mag_codmag,mag_peri"	
	

	CASE _PARAMETRO_COSTO_VENDUTO == "FORNITORE"

			Csql   = "select * from u_mag_fo where " + x_cond + " order by mag_fornit,mag_codart,mag_codmag"	


	CASE _PARAMETRO_COSTO_VENDUTO == "FORNITORE-ARTICOLO-TUTTI-MAGAZZINI"

			Csql   = "select * from u_mag_mf where " + x_cond + " order by mag_fornit,mag_codart,mag_codmag"	


	CASE _PARAMETRO_COSTO_VENDUTO == "FORNITORE-ARTICOLO-TUTTI-MAGAZZINI-AAAAMM"

			Csql   = "select * from u_mag_mf where " + x_cond + " order by mag_fornit,mag_codart,mag_codmag,mag_peri"	


	CASE _PARAMETRO_COSTO_VENDUTO == "ARTICOLO-MAGAZZINO-FORNITORE"

			Csql   = "select * from u_mag_mf where " + x_cond + " order by mag_codart,mag_codmag,mag_fornit"	


	CASE _PARAMETRO_COSTO_VENDUTO == "MATCH-CODE"
			
			Csql   = "select * from u_mag_ri where " + x_cond + " order by mag_codmag,mag_peri"	



	OTHERWISE

			Csql   = "select * from u_mag_ri where " + x_cond + " order by mag_codmag"	
	
ENDCASE




IF !ExecCommand(cSql,"CUJ_MAG_RI")
   return(.f.)
ENDIF

select CUK_MAG_RI
zap

_V_VENDITA	= 0
_V_COSTO	= 0
_V_DELTA	= 0
_V_PERIN    = 0
_V_RESOC	= 0
_V_RESOF	= 0
 ** SERGIO 24/09/2004 inizio
_V_VASCAR   = 0
_V_VAVEND   = 0
 ** SERGIO 24/09/2004 fine


SELECT CUJ_MAG_RI
GO TOP
SCAN 

  SCATTER MEMVAR MEMO
  INSERT INTO CUK_MAG_RI FROM MEMVAR
  _V_VENDITA = _V_VENDITA + M.MAG_VALVEN
  _V_COSTO   = _V_COSTO   + M.MAG_VALCOS
  _V_DELTA   = _V_VENDITA - _V_COSTO

  _PERIN 	 = (_V_DELTA/_V_VENDITA)*100
  __PERIN  	 = STR(_PERIN,12,2)
  _V_PERIN 	 = VAL(__PERIN)

  _V_RESOC   = _V_RESOC   + M.MAG_VARESC
  _V_RESOF   = _V_RESOF   + M.MAG_VARESF

  * SALVATAGGIO DELLE VARIABII DI TOTALE
  _S_VENDITA = _V_VENDITA 
  _S_COSTO   = _V_COSTO   
  _S_DELTA   = _V_DELTA
  _S_PERIN 	 = _V_PERIN
  _S_RESOC   = _V_RESOC 
  _S_RESOF   = _V_RESOF 
  
  ** SERGIO 24/09/2004 inizio
  
  _V_VASCAR   = _V_VASCAR   + M.MAG_VASCAR
  _V_VAVEND   = _V_VAVEND   + M.MAG_VAVEND
  _S_VASCAR   = _V_VASCAR 
  _S_VAVEND   = _V_VAVEND 
  
  ** SERGIO 24/09/2004 fine



ENDSCAN

RETURN(.T.)


** #####################################################################
**                     ZAPPA GLI ARCHIVI ELENCATI 
** #####################################################################
**
**
**	SE _TIPO_ZAP_ = "TUTTI"
**
**		ZAPPA TUTTI GLI ARCHIVI 
**  
**	SE _TIPO_ZAP_ = "DDTFOR"
**
** 		U_BFO_TT		
**		U_BFO_DD
**
**
**	SE _TIPO_ZAP_ = "MAGAZZINO"
**
** 		U_MAG_AN	- GIACENZE STANDARD	
**		U_MAG_CL	- ??
**		U_MAG_CP	- ??
**		U_MAG_DA	- GIACENZE PER DATA
**		U_MAG_DF	- GIACENZE PER DATA/FORNITORE
**		U_MAG_DM	- MOVIMENTI ??
**		U_MAG_CA	- SALVATAGGIO MOVIMENTI DI MAGAZZINO CANCELLATI DALLE PROCEDURE PER EVENTUALI RIPESCAGGI
**		U_MAG_GG	- GIACENZE PER DATA
**		U_MAG_IN	- GIACENZE ??
**		U_MAG_PR	- PROGRESSIVI STORICI 
**		U_MAG_AR	- VALORIZZAZIONE MAGAZZINO PER ARTICOLO
**		U_MAG_FO	- VALORIZZAZIONE MAGAZZINO PER FORNITORE
**		U_MAG_MA	- VALORIZZAZIONE MAGAZZINO PER MAGAZZINO/ARTICOLO
**		U_MAG_MF	- VALORIZZAZIONE MAGAZZINO PER MAGAZZINO/FORNITORE		
**		U_MAG_RI	- VALORIZZAZIONE MAGAZZINO RIEPILOGATE PER MAGAZZINO , O PER MAGAZZINO PERIODO , O PER MATCH CODE
**
**
**
**



FUNCTION ZAPPA_ARCHIVI
PARA _TIPO_ZAP_



DO CASE 

	CASE _TIPO_ZAP_ = "TUTTI"   

			=ZAPPA_BFO()
			=ZAPPA_MAGAZZINI()
			
	CASE _TIPO_ZAP_ = "DDTFOR"   

			=ZAPPA_BFO()
			
			
	CASE _TIPO_ZAP_ = "MAGAZZINO"   

			=ZAPPA_MAGAZZINI()

ENDCASE

RETURN(.T.)


** #####################################################################
**                     ZAPPA GLI ARCHIVI 
** #####################################################################
**
**


FUNCTION ZAPPA_BFO

	Csql   = "delete from u_bfo_tt " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_bfo_dd " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

RETURN(.T.)

** #####################################################################
**                     ZAPPA GLI ARCHIVI 
** #####################################################################
**
**

FUNCTION ZAPPA_MAGAZZINI



	Csql   = "delete from u_mag_an " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_cl " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF


	Csql   = "delete from u_mag_cp " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_da " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_df " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_dm " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF
	
	Csql   = "delete from u_mag_ca " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_gg " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_in " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_pr " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_ar " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_fo " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_ma " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_mf " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

	Csql   = "delete from u_mag_ri " 
	IF !ExecCommand(cSql,"")
	   return(.f.)
	ENDIF

RETURN(.T.)


*!*	  SERGIO FINE 07/08/2004


********************************
PROCEDURE RIPRISTINA_GIAC_VIAGGI
********************************

PARAMETERS _SEGNO

IF MOV_TIPTRA = 'TRA'
ELSE
   RETURN
ENDIF

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
x_maga   = "mag_codmag = 'VIAGGI'"
x_csys   = "mag_unique = '" + ALLTRIM(M.MOV_SYSGGS) + "'"
x_cond   = x_maga + " and " + x_csys
Csql     = "select * from u_mag_gg where " + x_cond
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
IF RECCOUNT() <> 0
   IF _SEGNO = '-'
      REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
   ELSE
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   ENDIF
   IF MAG_NRLINT > 50000000 
      REPLACE MAG_FLGRIB WITH .T.
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
	IF MAG_GIACEN < 0
	   REPLACE MAG_GIACEN WITH 0
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_QTAIMP WITH 0
	   REPLACE MAG_GKGIMP WITH 0
	   REPLACE MAG_GMLIMP WITH 0
	ENDIF
	IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_GKGIMP WITH 0
	   REPLACE MAG_GMLIMP WITH 0
	ENDIF
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF !ExecRw(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
x_maga   = "mag_codmag = 'VIAGGI'"
x_csys   = "mag_unique = '" + ALLTRIM(M.MOV_SYSGGG) + "'"
x_cond   = x_maga + " and " + x_csys
Csql     = "select * from u_mag_gg where " + x_cond
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
IF RECCOUNT() <> 0
   IF _SEGNO = '-'
      REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
   ELSE
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   ENDIF
   IF MAG_NRLINT > 50000000 
      REPLACE MAG_FLGRIB WITH .T.
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
	IF MAG_GIACEN < 0
	   REPLACE MAG_GIACEN WITH 0
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_QTAIMP WITH 0
	   REPLACE MAG_GKGIMP WITH 0
	   REPLACE MAG_GMLIMP WITH 0
	ENDIF
	IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_GKGIMP WITH 0
	   REPLACE MAG_GMLIMP WITH 0
	ENDIF
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF !ExecRw(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF



x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"  
x_maga = "mag_codmag = 'VIAGGI'"
x_codi = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
x_cond = x_soci + " and " + x_maga + " and " + x_codi
Csql   = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
IF !ExecRW(cSql,"U_MAG_AN","R")
   return(.f.)
ENDIF
SELECT U_MAG_AN
IF RECCOUNT() <> 0
   IF _SEGNO = '-'
      REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
   ELSE
      REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
	IF MAG_GIACEN < 0
	   REPLACE MAG_GIACEN WITH 0
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_QTAIMP WITH 0
	ENDIF
	IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	ENDIF
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_AN","W")
   return(.f.)
ENDIF

*==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
DO GESTIONE_SALDI_MOV

RETURN  


*******************************************************************************
* -->> Funzione che identifica l'ordine con cui gestire lo scarico in fase di
* -->> vendita in base ai parametri aziendali relativi alla gestione del magazzino
*******************************************************************************

FUNCTION TROVSELE
PARAMETERS _Csql,_RESO

x_orderby = ""
x_order1  = ""
x_order2  = ""
x_order3  = ""

IF PUB_TIPCON
   x_order1 = "u_mag_gg.mag_codacq,"
   IF _RESO
      x_order1 = "u_mag_gg.mag_codacq DESC,"
   ENDIF
ENDIF

IF PUB_PRZBAS
   x_order2 = "mag_przuff,"
   IF _RESO
      x_order2 = "mag_przuff DESC,"
   ENDIF
ENDIF

IF PUB_DATOLD
   x_order3 = "u_mag_gg.mag_datagg,"
ENDIF

IF EMPTY(x_order1) .AND. EMPTY(x_order2) .AND. EMPTY(x_order3)
ELSE
   x_orderby = " order by "
   IF EMPTY(x_order1)
   ELSE
      x_orderby = x_orderby + x_order1
   ENDIF
   IF EMPTY(x_order2)
   ELSE
      x_orderby = x_orderby + x_order2
   ENDIF
   IF EMPTY(x_order3)
   ELSE
      x_orderby = x_orderby + x_order3
   ENDIF
   x_lenordby = LEN(X_ORDERBY)
   IF SUBSTR(x_orderby,x_lenordby,1) = ','
      x_orderby = SUBSTR(x_orderby,1,x_lenordby-1)
   ENDIF
ENDIF

IF EMPTY(x_orderby)
ELSE
   _Csql = _Csql + x_orderby
ENDIF

RETURN(_Csql)


******************************
PROCEDURE GESTIONE_RESO_PEDANA
******************************

RELEASE M_CODACQ
PUBLIC  M_CODACQ
M_CODACQ = SPACE(03)

M_PRIMOF = SPACE(10)
M_QUANTI = _QUANTI
M_DESFOR = ""

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

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO

SELECT CU_MAG_GM
SCATTER MEMVAR MEMO

x_iden = "id_unique = '" + M.ID_UNIQUE + "'"
x_cond = x_iden
cSql   = "select * from u_mag_gg where " + x_cond
IF !ExecCommand(cSql,"CUR_MAG_GG")
   return(.f.)
ENDIF
SELECT CUR_MAG_GG
GO TOP
IF EOF()
   PUB_FILA_X = SPACE(05)
   PUB_PIAN_X = SPACE(05)
   PUB_UBIC_X = SPACE(05)
   PUB_FILA_N = 0
   PUB_PIAN_N = 0
   PUB_UBIC_N = 0
ELSE
   PUB_FILA_X = MAG_FILA_X
   PUB_PIAN_X = MAG_PIAN_X
   PUB_UBIC_X = MAG_UBIC_X
   PUB_FILA_N = MAG_FILA_N
   PUB_PIAN_N = MAG_PIAN_N
   PUB_UBIC_N = MAG_UBIC_N
   ZV_MAGA  = MAG_CODMAG
   _CODART  = MAG_CODART
   _DATREG  = MAG_DATAGG     
   _PRZACQ  = MAG_PRZCON       
   M_FORNIT = MAG_FORNIT
   M_DESFOR = MAG_DESFOR
   M_CODACQ = MAG_CODACQ
   M_QTAFOR = M_QUANTI
   M_QTAMQ  = M_QTAMQA
   M_QTAML  = TROVA_ML_DA_MQ(MAG_ALTEZZ,M_QTAMQ)
   M_QTAKG  = TROVA_KG_DA_MQ(MAG_CODART,MAG_SPESSO,M_QTAMQ,1)
   SELECT CUR_MAG_GG
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
   DO MAGAZZINO_RESO
ENDIF

RETURN



***************************************************************************
PROCEDURE MAGAZZINO_RESO		       && RICARICA IL MAGAZZINO GIORNALIERO
***************************************************************************

RELEASE QWE_SYSGGG,QWE_SYSGGS,QWE_SYSDAG,QWE_SYSSAS
PUBLIC  QWE_SYSGGG,QWE_SYSGGS,QWE_SYSDAG,QWE_SYSSAS
QWE_SYSGGG = SPACE(10)
QWE_SYSGGS = SPACE(10)
QWE_SYSDAG = SPACE(10)
QWE_SYSDAS = SPACE(10)

RELEASE RIN_DATSCAR 
PUBLIC  RIN_DATSCAR
RIN_DATSCAR = SPACE(10)

SELECT CUR_MAG_GG
SCATTER MEMVAR MEMO

*-->> GESTIONE DELLE GIACENZE RIEPILOGATE PER DATA/ARTICOLO/MAGAZZINO/FORNITORE DI CARICO

x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
x_tmat = "mag_codmat = mag_codmat"
x_colo = "mag_codcol = mag_codcol"
x_spes = "mag_spesso = mag_spesso"
x_alte = "mag_altezz = mag_altezz"
x_lung = "mag_lunghe = mag_lunghe"
x_arti = "mag_anaart = '" + ALLTRIM(M.MAG_ANAART) + "'" 
x_nrli = "mag_nrlint = " + ALLTRIM(STR(M.MAG_NRLINT,8,0))
x_maga = "mag_codmag = '" + ALLTRIM(_MAG) + "'"
x_forn = "mag_fornit = mag_fornit"
x_nide = "mag_numide = mag_numide"
x_anno = "mag_anno = mag_anno"
x_data = "mag_datagg <> SPACE(10)"
x_giac = "mag_giacen = mag_giacen"
x_impe = "mag_qtaimp = mag_qtaimp"
x_fila = "mag_fila_n = " + ALLTRIM(STR(PUB_FILA_N,5,0))
x_pian = "mag_pian_n = " + ALLTRIM(STR(PUB_PIAN_N,5,0))
x_ubic = "mag_ubic_n = " + ALLTRIM(STR(PUB_UBIC_N,5,0))
x_cond = x_soci + " and " + x_tmat + " and " + x_colo + " and " + x_spes + " and " + x_alte
x_cond = x_cond + " and " + x_lung + " and " + x_arti + " and " + x_nrli + " and " + x_maga
x_cond = x_cond + " and " + x_forn + " and " + x_nide + " and " + x_anno + " and " + x_data 
x_cond = x_cond + " and " + x_giac + " and " + x_impe + " and " + x_fila + " and " + x_pian + " and " + x_ubic
cSql   = "select * from u_mag_gg where " + x_cond + " order by mag_datagg,mag_codart"
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
GO TOP       
IF EOF()
   APPEND BLANK
   DO U_MAG_GG
   REPLACE MAG_CODMAG WITH _MAG
ENDIF

RIN_DATSCAR = MAG_DATAGG

REPLACE MAG_LUNGHE WITH M_QTAML
REPLACE MAG_GIACEN WITH M_QTAFOR
REPLACE MAG_QTAKG  WITH M_QTAKG 
REPLACE MAG_QTAMQ  WITH M_QTAMQ 
REPLACE MAG_QTAML  WITH M_QTAML 
REPLACE MAG_QTAIMP WITH 0 
REPLACE MAG_GKGIMP WITH 0 
REPLACE MAG_GMLIMP WITH 0 
REPLACE MAG_ANNO WITH SUBSTR(MAG_DATAGG,1,4)
REPLACE MAG_CLIENT WITH SPACE(50)
REPLACE MAG_NUMORD WITH SPACE(06)
REPLACE MAG_DATORD WITH SPACE(10)
REPLACE MAG_SYSORD WITH SPACE(10)
REPLACE MAG_NUMPED WITH 0   
REPLACE MAG_FLGTRA WITH .F.

REPLACE MAG_FILA_X WITH PUB_FILA_X
REPLACE MAG_PIAN_X WITH PUB_PIAN_X
REPLACE MAG_UBIC_X WITH PUB_UBIC_X
REPLACE MAG_FILA_N WITH PUB_FILA_N
REPLACE MAG_PIAN_N WITH PUB_PIAN_N
REPLACE MAG_UBIC_N WITH PUB_UBIC_N

IF MAG_NRLINT > 50000000 
   REPLACE MAG_FLGRIB WITH .T.
ENDIF
IF MAG_GIACEN < 0
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_QTAIMP WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF
IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF

RELEASE QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME,   ;
        QWE_LEGSYS,QWE_NUMORF,QWE_DATORF,QWE_SC1,QWE_SC2,QWE_SC3,QWE_NUMIDE,QWE_CODBUN, ;
        QWE_ANNO
PUBLIC  QWE_FORNIT,QWE_DESFOR,QWE_CODACQ,QWE_DESACQ,QWE_PRZCON,QWE_PAGAME,QWE_LEGAME,   ;
        QWE_LEGSYS,QWE_NUMORF,QWE_DATORF,QWE_SC1,QWE_SC2,QWE_SC3,QWE_NUMIDE,QWE_CODBUN, ;
        QWE_ANNO
QWE_FORNIT = MAG_FORNIT
QWE_DESFOR = MAG_DESFOR
QWE_CODACQ = MAG_CODACQ
QWE_DESACQ = MAG_DESACQ
QWE_PRZCON = MAG_PRZCON
QWE_PAGAME = MAG_PAGAME
QWE_LEGAME = MAG_LEGAME
QWE_LEGSYS = MAG_LEGSYS
QWE_NUMORF = SPACE(06)
QWE_DATORF = SPACE(10)
QWE_SC1    = 0
QWE_SC2    = 0
QWE_SC3    = 0
QWE_NUMIDE = MAG_NUMIDE
QWE_CODBUN = MAG_CODBUN
QWE_ANNO   = MAG_ANNO
SCATTER MEMVAR MEMO
IF EMPTY(ALLTRIM(PUB_MAGNO0))
ELSE
   IF MAG_GIACEN = 0
      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
      ELSE
         DELETE
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF

*-->> CREA IL MOVIMENTO DI RICARICO MAGAZZINO

IF _GENMOV = "SI"
   QWE_NUMORF = SPACE(06)
   QWE_DATORF = SPACE(10)
   QWE_SC1    = 0
   QWE_SC2    = 0
   QWE_SC3    = 0
   x_maga = "ord_maga = '" + ALLTRIM(ZV_MAGA) + "'"
   x_lega = "ord_legsys = '" + ALLTRIM(QWE_LEGSYS) + "'"
   x_cond = x_maga + " and " + x_lega
   cSql   = "SELECT * FROM U_ORF_DD WHERE " + x_cond
   IF !ExecCommand(cSql,"U_ORF_DD")
      return(.f.)
   ENDIF 
   SELECT U_ORF_DD
   GO TOP
   IF EOF()
   ELSE
      QWE_NUMORF = ORS_NUMORD
      QWE_DATORF = ORS_DATORD
      QWE_SC1    = ORD_SC1
      QWE_SC2    = ORD_SC2
      QWE_SC3    = ORD_SC3
   ENDIF
   SELECT CU_BOL_DD
   x_soci = "mov_codsoc = '" + PUB_CODSOC + "'"
   x_arti = "mov_codart = '" + ALLTRIM(_CODART) + "'"
   x_maga = "mov_codmag = '" + ALLTRIM(ZV_MAGA) + "'"
   x_caus = "mov_top = '" + PUB_BOLLA + "'"
   x_forn = "mov_codfor = '" + ALLTRIM(M.MAG_FORNIT) + "'"
   x_ndoc = "mov_numdoc = '" + ALLTRIM(ORS_NUMDDT) + "'"
   x_anno = "mov_anno = mov_anno"
   x_cond = x_soci + " and " + x_maga + " and " + x_arti + " and " + x_caus + " and " + x_forn + " and " + ;
            x_ndoc + " and " + x_anno
   Csql   = "select * from u_mag_mo where " + x_cond
   IF !ExecCommand(cSql,"CUX_MAG_MO")
      return(.f.)
   ENDIF
   SELECT CUX_MAG_MO
   IF !EOF()
       SCATTER MEMVAR MEMO
       Csql = "select * from u_mag_mo where 1=0"
       IF !ExecRW(Csql,"U_MAG_MO","R")
          return(.f.)
       ENDIF
       SELECT U_MAG_MO
       APPEND BLANK
       M.MOV_CODMAT = M.MAG_CODMAT
       M.MOV_CODCOL = M.MAG_CODCOL
       DO U_MAG_MO
       IF M.MOV_CODMAT = '001' .OR. M.MOV_CODMAT = '004'
       ELSE
          REPLACE MOV_UM WITH 'MQ'
       ENDIF
   	   IF EMPTY(ALLTRIM(_NUMDOC))
   	   ELSE
   	      REPLACE MOV_NUMDOC WITH _NUMDOC
   	   ENDIF
   	   IF EMPTY(ALLTRIM(_DATDOC)) .OR. _DATDOC = '  /  /    ' .OR. _DATDOC = '    /  /  ' 
   	   ELSE
   	      REPLACE MOV_DTDOCU WITH _DATDOC
   	   ENDIF
       REPLACE MOV_DTREGI WITH RIBALTA2(DTOC(DATE()))
       REPLACE MOV_DATSCA WITH RIN_DATSCAR
	   REPLACE MOV_CODMAG WITH _MAG 
       REPLACE MOV_LUNGHE WITH M_QTAML
       REPLACE MOV_TOP    WITH _TOP
	   REPLACE MOV_QTAMOV WITH M_QTAFOR
       IF M.MOV_CODMAT = '001' .OR. M.MOV_CODMAT = '004'
   		  IF M.MAG_QTAMQ > 0
   		     REPLACE MOV_QTAMQ WITH M_QTAFOR
   		  ELSE
             REPLACE MOV_QTAMQ  WITH M_QTAMQ
   		  ENDIF
          REPLACE MOV_QTAML  WITH M_QTAML
          REPLACE MOV_QTAKG  WITH M_QTAKG
       ELSE
   	      REPLACE MOV_QTAMQ  WITH M_QTAMQ
	      REPLACE MOV_QTAML  WITH M_QTAML
	      REPLACE MOV_QTAKG  WITH M_QTAKG
	   ENDIF
	   REPLACE MOV_PREVEN WITH _PRZVEN
	   REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
	   REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
	   REPLACE MOV_ORAMOV WITH _ORAMOV					
	   REPLACE MOV_SEGNO  WITH X_SEGNO					
	   REPLACE MOV_TIPMOV WITH V_TMOV				
	   REPLACE MOV_UNIQUE WITH SYS(2015)
       REPLACE MOV_FLGTRA WITH _FLGTRA
   	   REPLACE MOV_LEGSYS WITH _LEGSYS
       REPLACE MOV_ANNO   WITH SUBSTR(MOV_DTDOCU,1,4)
       REPLACE MOV_CODOPE WITH PUB_CODOPE
       REPLACE MOV_NOMOPE WITH PUB_NOMOPE
       REPLACE MOV_CODCLI WITH M_CODCLI
       REPLACE MOV_DESCLI WITH M_DESCLI

       REPLACE MOV_FILA_X WITH PUB_FILA_X
       REPLACE MOV_PIAN_X WITH PUB_PIAN_X
       REPLACE MOV_UBIC_X WITH PUB_UBIC_X
       REPLACE MOV_FILA_N WITH PUB_FILA_N
       REPLACE MOV_PIAN_N WITH PUB_PIAN_N
       REPLACE MOV_UBIC_N WITH PUB_UBIC_N
		
		IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
		   REPLACE MOV_QTAMQ  WITH 0
		   REPLACE MOV_QTAKG  WITH 0
		   REPLACE MOV_QTAML  WITH 0
		   REPLACE MOV_QTAMQA WITH 0
		   REPLACE MOV_QTAMLA WITH 0
		   REPLACE MOV_QTAKGA WITH 0
		ENDIF
       RELEASE P_TIPO
       PUBLIC  P_TIPO
       P_TIPO = CERCATIPO(MOV_ANAART)
       SELECT U_MAG_MO
       IF P_TIPO = '3'	&& GESTIONE MANDRINI
          P_VALACQ = ROUND(((MOV_ALTEZZ / 1000) * MOV_PREACQ),2)
	      REPLACE MOV_VALACQ WITH P_VALACQ
       ENDIF
       SCATTER MEMVAR MEMO
       IF !ExecRW(Csql,"U_MAG_MO","W")
          return(.f.)
       ENDIF
       **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
       DO GESTIONE_SALDI_MOV
   ELSE
   		Csql = "select * from u_mag_mo where 1=0"
   		IF !ExecRW(Csql,"U_MAG_MO","R")
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
   		IF M.MAG_QTAMQ > 0
   		   REPLACE MOV_QTAMQ WITH M_QTAFOR
   		ELSE
           REPLACE MOV_QTAMQ  WITH M_QTAMQ
   		ENDIF
        REPLACE MOV_QTAML  WITH M_QTAML
        REPLACE MOV_QTAKG  WITH M_QTAKG
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
   	    IF EMPTY(ALLTRIM(_NUMDOC))
   	    ELSE
   	       REPLACE MOV_NUMDOC WITH _NUMDOC
   	    ENDIF
   	    IF EMPTY(ALLTRIM(_DATDOC)) .OR. _DATDOC = '  /  /    ' .OR. _DATDOC = '    /  /  ' 
   	    ELSE
   	       REPLACE MOV_DTDOCU WITH _DATDOC
   	    ENDIF
   	    REPLACE MOV_DTREGI WITH RIBALTA2(DTOC(DATE()))
        REPLACE MOV_DATSCA WITH RIN_DATSCAR
   		REPLACE MOV_CODFOR WITH M.MAG_FORNIT
   		REPLACE MOV_RAGSOC WITH M.MAG_DESFOR
   		REPLACE MOV_CODTAG WITH A_CODTAG
   		REPLACE MOV_DESTAG WITH A_DESTAG
   		REPLACE MOV_CODCOL WITH M.MAG_CODCOL
   		REPLACE MOV_DESCOL WITH M.MAG_DESCOL
   		REPLACE MOV_CODMAT WITH M.MAG_CODMAT
   		REPLACE MOV_DESMAT WITH M.MAG_DESMAT
   		REPLACE MOV_NOTVAR WITH _NOTE
   		REPLACE MOV_UM     WITH A_UNIMIS
        IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
        ELSE
           REPLACE MOV_UM WITH 'MQ'
        ENDIF
   		REPLACE MOV_CODPDV WITH M_CODPDV				
   		REPLACE MOV_ORAMOV WITH _ORAMOV					
   		REPLACE MOV_SEGNO  WITH X_SEGNO					
   		REPLACE MOV_TIPMOV WITH V_TMOV				
   		REPLACE MOV_FORNIT WITH M_FORNIT
   		REPLACE MOV_DESFOR WITH M_DESFOR
   		REPLACE MOV_COORD  WITH A_COORD
   		REPLACE MOV_FLGTRA WITH _FLGTRA
   		REPLACE MOV_LEGSYS WITH _LEGSYS
   		REPLACE MOV_CODCAS WITH _CODCAS
   		REPLACE MOV_LEGAME WITH QWE_LEGAME
   		REPLACE MOV_PAGAME WITH QWE_PAGAME
   		REPLACE MOV_CODACQ WITH QWE_CODACQ
   		REPLACE MOV_NUMORF WITH QWE_NUMORF
   		REPLACE MOV_DATORF WITH QWE_DATORF
   		REPLACE MOV_SC1    WITH QWE_SC1
   		REPLACE MOV_SC2    WITH QWE_SC2
   		REPLACE MOV_SC3    WITH QWE_SC3
   		REPLACE MOV_NUMIDE WITH QWE_NUMIDE
   		REPLACE MOV_CODBUN WITH QWE_CODBUN
        REPLACE MOV_ANNO WITH SUBSTR(MOV_DTDOCU,1,4)
   		REPLACE MOV_UNIQUE WITH SYS(2015)
   		REPLACE MOV_CODOPE WITH PUB_CODOPE
   		REPLACE MOV_NOMOPE WITH PUB_NOMOPE
   		REPLACE MOV_NUMCAM WITH PUB_NUMCAM
   		REPLACE MOV_DATCAM WITH PUB_DATCAM
   		REPLACE MOV_INICAM WITH PUB_INICAM
   		REPLACE MOV_FINCAM WITH PUB_FINCAM
   		REPLACE MOV_SC1CAM WITH PUB_SC1CAM
   		REPLACE MOV_SC2CAM WITH PUB_SC2CAM
   		REPLACE MOV_SC3CAM WITH PUB_SC3CAM
   		REPLACE MOV_SC4CAM WITH PUB_SC4CAM
   		REPLACE MOV_SC5CAM WITH PUB_SC5CAM
   		REPLACE MOV_FISCAM WITH PUB_FISCAM
   		REPLACE MOV_PRZCAM WITH PUB_PRZCAM
        REPLACE MOV_SPESSO WITH M.MAG_SPESSO 
        REPLACE MOV_ALTEZZ WITH M.MAG_ALTEZZ
        REPLACE MOV_LUNGHE WITH M_QTAML
        REPLACE MOV_NRLINT WITH M.MAG_NRLINT
        REPLACE MOV_NRDBOB WITH M.MAG_NRDBOB
        REPLACE MOV_CDAFOR WITH M.MAG_CDAFOR
        REPLACE MOV_OINFOR WITH M.MAG_OINFOR
        REPLACE MOV_PINFOR WITH M.MAG_PINFOR
        REPLACE MOV_DTPFOR WITH M.MAG_DTPFOR
        REPLACE MOV_TRAFOR WITH M.MAG_TRAFOR
        REPLACE MOV_NBAFOR WITH M.MAG_NBAFOR
        REPLACE MOV_BDAFOR WITH M.MAG_BDAFOR
        REPLACE MOV_BALFOR WITH M.MAG_BALFOR
        REPLACE MOV_PNKFOR WITH M.MAG_PNKFOR
        REPLACE MOV_ANAART WITH M.MAG_ANAART
        REPLACE MOV_DTINCQ WITH M.MAG_DTINCQ
        REPLACE MOV_ORINCQ WITH M.MAG_ORINCQ
        REPLACE MOV_DTFICQ WITH M.MAG_DTFICQ
        REPLACE MOV_ORFICQ WITH M.MAG_ORFICQ
        REPLACE MOV_CDRECQ WITH M.MAG_CDRECQ
        REPLACE MOV_DSRECQ WITH M.MAG_DSRECQ
        REPLACE MOV_QTAKGA WITH M.MAG_QTAKGA
        REPLACE MOV_QTAMQA WITH M.MAG_QTAMQA
        REPLACE MOV_QTAMLA WITH M.MAG_QTAMLA
        REPLACE MOV_TIPART WITH M.MAG_TIPART
        REPLACE MOV_CODOPE WITH PUB_CODOPE
        REPLACE MOV_CODCLI WITH M_CODCLI
        REPLACE MOV_DESCLI WITH M_DESCLI
        REPLACE MOV_FILA_X WITH PUB_FILA_X
        REPLACE MOV_PIAN_X WITH PUB_PIAN_X
        REPLACE MOV_UBIC_X WITH PUB_UBIC_X
        REPLACE MOV_FILA_N WITH PUB_FILA_N
        REPLACE MOV_PIAN_N WITH PUB_PIAN_N
        REPLACE MOV_UBIC_N WITH PUB_UBIC_N
		IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
		   REPLACE MOV_QTAMQ  WITH 0
		   REPLACE MOV_QTAKG  WITH 0
		   REPLACE MOV_QTAML  WITH 0
		   REPLACE MOV_QTAMQA WITH 0
		   REPLACE MOV_QTAMLA WITH 0
		   REPLACE MOV_QTAKGA WITH 0
		ENDIF
        REPLACE MOV_CSTMAN WITH M.MAG_CSTMAN
        REPLACE MOV_CSTSCA WITH M.MAG_CSTSCA
       RELEASE P_TIPO
       PUBLIC  P_TIPO
       P_TIPO = CERCATIPO(MOV_ANAART)
       SELECT U_MAG_MO
       IF P_TIPO = '3'	&& GESTIONE MANDRINI
          P_VALACQ = ROUND(((MOV_ALTEZZ / 1000) * MOV_PREACQ),2)
	      REPLACE MOV_VALACQ WITH P_VALACQ
       ENDIF
       REPLACE MOV_NUMMOV WITH PUB_NUMCSI				&& RINO 20/10/2006
   		SCATTER MEMVAR MEMO
        IF !ExecRW(Csql,"U_MAG_MO","W")
           return(.f.)
        ENDIF
        **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
        DO GESTIONE_SALDI_MOV
   ENDIF
ENDIF         

*!*	  SERGIO INIZIO 23/09/2004
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
M.MAG_MATCHC = PUB_CODSOC
_NEW_SEGNO   = " "
=MOVIARTI(ALLTRIM(_CODART),_MAG,_NUMDOC,_DATREG,M_QTAFOR,R_PRZCOS,R_PRZVEN,_TOP,M_FORNIT,M_DESFOR,QWE_CODACQ,"",M.MAG_MATCHC,_NEW_SEGNO)
IF EMPTY(ALLTRIM(_MAG1))
ELSE
   M.MAG_MATCHC = PUB_CODSOC
   _NEW_SEGNO   = " "
   =MOVIARTI(ALLTRIM(_CODART),_MAG1,_NUMDOC,_DATREG,M_QTAFOR,R_PRZCOS,R_PRZVEN,_TOP1,M_FORNIT,M_DESFOR,QWE_CODACQ,"",M.MAG_MATCHC,_NEW_SEGNO)
ENDIF
*!*	  SERGIO FINE 23/09/2004

RETURN


**********************************************************************************
FUNCTION GESTIONE_IMPEGNATO_MAG
**********************************************************************************

PARAMETERS _CURSORE,_SEGNO,_DADOVE

IF _SEGNO = '+'
   _ARCHIVIO = _CURSORE
ELSE
   x_agga = "leg_agganc = '" + M.DAGGANCIO + "'"
   x_csys = "leg_syspck = leg_syspck"
   x_uniq = "leg_unique = '" + ALLTRIM(M.ORD_UNIQUE) + "'"
   x_cond = x_agga + " and " + x_csys + " and " + x_uniq
   cSql   = "select * from u_pck_le where " + x_cond
   IF !ExecCommand(Csql,"U_PCK_LE")
      return(.f.)
   ENDIF
   _ARCHIVIO = "U_PCK_LE"
ENDIF

SELECT &_ARCHIVIO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF LEG_UNIQUE = M.ORD_UNIQUE
   ELSE
      SKIP +1
      LOOP
   ENDIF
   
   SCATTER MEMVAR MEMO
   
   *=> Aggiornamento quantità impegnata sulla giacenza di dettaglio
   x_cond = "mag_unique = '" + M.LEG_SYSMAG + "'"
   Csql   = "select * from u_mag_gg where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
      ELSE
         REPLACE MAG_QTAIMP WITH MAG_QTAIMP - M.LEG_QUANTI
      ENDIF
   ENDIF
   IF MAG_QTAIMP < 0
      REPLACE MAG_QTAIMP WITH 0
   ENDIF
   IF MAG_NRLINT > 50000000 
      REPLACE MAG_FLGRIB WITH .T.
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.
   SCATTER MEMVAR MEMO   
   IF !ExecRw(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF

   *=> Aggiornamento quantità impegnata sulla giacenza di riepilogo
   *=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
   IF PUB_GGDTSP
	   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
	   x_data   = "mag_datagg = '" + SPACE(10) + "'"
	   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
	   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
	   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
	   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
	   Csql     = "select * from u_mag_gg where " + x_cond
	   IF !ExecRW(cSql,"U_MAG_GG","R")
	      return(.f.)
	   ENDIF
	   SELECT U_MAG_GG
	   IF RECCOUNT() <> 0
	      IF _SEGNO = '+'
	         REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
	      ELSE
	         REPLACE MAG_QTAIMP WITH MAG_QTAIMP - M.LEG_QUANTI
	      ENDIF
	   ENDIF
       IF MAG_QTAIMP < 0
          REPLACE MAG_QTAIMP WITH 0
       ENDIF
       IF MAG_NRLINT > 50000000 
          REPLACE MAG_FLGRIB WITH .T.
       ENDIF
	   REPLACE MAG_FLGTRA WITH .F.
	   REPLACE MAG_FLGVIA WITH .F.
	   SCATTER MEMVAR MEMO   
	   IF !ExecRw(cSql,"U_MAG_GG","W")
	      return(.f.)
	   ENDIF
   ENDIF
   

   *=> Aggiornamento quantità già evasa su dettaglio ordine cliente per packing list
   __UNCINO = SPACE(10)
   x_cond = "ord_codsys = '" + M.LEG_SYSPCK + "'"
   Csql   = "select * from U_ORD_DD where " + x_cond
   IF !ExecRW(cSql,"U_ORD_DD","R")
      return(.f.)
   ENDIF
   SELECT U_ORD_DD
   
   **=> ERASMO - INIZIO 20/09/2010
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF EMPTY(ALLTRIM(ORD_CODART))
         SKIP +1
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDDO
   **=> ERASMO - FINE 20/09/2010   
   
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE ORD_QTAPCK WITH ORD_QTAPCK + M.LEG_QUANTI		
      ELSE
         REPLACE ORD_QTAPCK WITH ORD_QTAPCK - M.LEG_QUANTI		
      ENDIF
      IF _SEGNO = '+'
      ELSE
         IF ORD_QTAORD > ORD_QTAPCK   
         	 REPLACE ORD_PKLOK WITH " "
         ELSE
   	        REPLACE ORD_PKLOK WITH "S"
         ENDIF
      ENDIF
      __UNCINO = DAGGANCIO
   ENDIF
   IF !ExecRW(cSql,"U_ORD_DD","W")
      return(.f.)
   ENDIF

   *=> Aggiornamento flag di evaso totalmente su testata ordine cliente per packing list
   IF EMPTY(ALLTRIM(__UNCINO))
   ELSE
      __PKLOK = 'S'
      x_cond = "daggancio = '" + __UNCINO + "'"
      Csql   = "select * from U_ORD_DD where " + x_cond
      IF !ExecCommand(cSql,"U_ORD_DD")
         return(.f.)
      ENDIF
      SELECT U_ORD_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF ORD_PKLOK = 'S'
         ELSE
            __PKLOK = ' '
            EXIT
         ENDIF
         SKIP +1
      ENDDO    
      x_cond = "taggancio = '" + __UNCINO + "'"
	  Csql   = "select * from U_ORD_TT where " + x_cond + " order by taggancio"
	  IF !ExecRW(cSql,"U_ORD_TT","R")
	     return(.f.)
	  ENDIF
	  SELECT U_ORD_TT
      REPLACE ORD_PKLOK WITH __PKLOK
      IF !ExecRW(cSql,"U_ORD_TT","W")
	     return(.f.)
	  ENDIF
   ENDIF
   
   SELECT &_ARCHIVIO
   SKIP +1
   
ENDDO

RETURN



**********************************************************************************
FUNCTION GESTIONE_IMPEGNATO_MAG_DA_BOL
**********************************************************************************

PARAMETERS _CURSORE,_SEGNO,_DADOVE

_ARCHIVIO = _CURSORE

SELECT &_ARCHIVIO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF LEG_SYSBOL = M.ORD_CODSYS
   ELSE
      SKIP +1
      LOOP
   ENDIF
   
   SCATTER MEMVAR MEMO
   
   *=> Aggiornamento quantità già evasa su dettaglio ordine cliente per packing list
   __UNCINO = SPACE(10)
   x_cond = "ord_codsys = '" + M.LEG_SYSPCK + "'"
   Csql   = "select * from U_ORD_DD where " + x_cond
   IF !ExecRW(cSql,"U_ORD_DD","R")
      return(.f.)
   ENDIF
   SELECT U_ORD_DD
   IF RECCOUNT() <> 0
      REPLACE ORD_QTADEV WITH 0
      IF _SEGNO = '-'
         REPLACE ORD_QTAEV   WITH ORD_QTAEV  + M.LEG_QUANTI		&& QUANTITA' PRELEVATA
         IF !PUB_CARICAPCK
            REPLACE ORD_QTAPCK  WITH ORD_QTAPCK + M.LEG_QUANTI		&& QUANTITA' PRELEVATA
         ENDIF
      ELSE
         REPLACE ORD_QTAEV  WITH ORD_QTAEV  - M.LEG_QUANTI		&& QUANTITA' PRELEVATA
         REPLACE ORD_QTAPCK WITH ORD_QTAPCK - M.LEG_QUANTI		&& QUANTITA' PRELEVATA
      ENDIF
      IF ORD_QTAEV < ORD_QTAORD
         REPLACE ORD_CHIUSO WITH .F.						&& RIGA ORDINE SEMPRE APERTA
         REPLACE ORD_SALCON WITH 'N'
      ELSE
         REPLACE ORD_CHIUSO WITH .T.						&& CHIUDE LA RIGA ORDINE
         REPLACE ORD_SALCON WITH 'S'
      ENDIF
      IF ORD_QTAORD > ORD_QTAPCK   
      	 REPLACE ORD_PKLOK WITH " "
      ELSE
   	     REPLACE ORD_PKLOK WITH "S"
      ENDIF
      __UNCINO = DAGGANCIO
   ENDIF
   IF !ExecRW(cSql,"U_ORD_DD","W")
      return(.f.)
   ENDIF

   *=> Aggiornamento flag di evaso totalmente su testata ordine cliente per packing list
   IF EMPTY(ALLTRIM(__UNCINO))
   ELSE
      __PKLOK = 'S'
      __CLOSE = .T.
      x_cond = "daggancio = '" + __UNCINO + "'"
      Csql   = "select * from U_ORD_DD where " + x_cond
      IF !ExecCommand(cSql,"U_ORD_DD")
         return(.f.)
      ENDIF
      SELECT U_ORD_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF ORD_CHIUSO
         ELSE
            __CLOSE = .F.
         ENDIF
         IF ORD_PKLOK = 'S'
         ELSE
            __PKLOK = ' '
         ENDIF
         SKIP +1
      ENDDO    
      x_cond = "taggancio = '" + __UNCINO + "'"
	  Csql   = "select * from U_ORD_TT where " + x_cond + " order by taggancio"
	  IF !ExecRW(cSql,"U_ORD_TT","R")
	     return(.f.)
	  ENDIF
	  SELECT U_ORD_TT
      REPLACE ORD_CHIUSO WITH __CLOSE
      REPLACE ORD_PKLOK WITH __PKLOK
      IF !ExecRW(cSql,"U_ORD_TT","W")
	     return(.f.)
	  ENDIF
   ENDIF
   
   SELECT &_ARCHIVIO
   SKIP +1
   
ENDDO

RETURN


**********************************************************************************
FUNCTION GESTIONE_IMPEGNATO_MAG_DA_BOL_SOLOIMP
**********************************************************************************

PARAMETERS _CURSORE,_SEGNO,_DADOVE

_ARCHIVIO = _CURSORE

SELECT &_ARCHIVIO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF LEG_SYSBOL = M.ORD_CODSYS
   ELSE
      SKIP +1
      LOOP
   ENDIF
   
   SCATTER MEMVAR MEMO
   
   *=> Aggiornamento quantità impegnata sulla giacenza di dettaglio
   x_cond = "mag_unique = '" + M.LEG_SYSMAG + "'"
   Csql   = "select * from u_mag_gg where " + x_cond 
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   IF RECCOUNT() <> 0
      IF _SEGNO = '+'
         REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
      ELSE
         REPLACE MAG_QTAIMP WITH MAG_QTAIMP - M.LEG_QUANTI
      ENDIF
   ENDIF
   IF MAG_QTAIMP < 0
      REPLACE MAG_QTAIMP WITH 0
   ENDIF
   IF MAG_NRLINT > 50000000 
      REPLACE MAG_FLGRIB WITH .T.
   ENDIF
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FLGVIA WITH .F.
   SCATTER MEMVAR MEMO   
   IF !ExecRw(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF

   *=> Aggiornamento quantità impegnata sulla giacenza di riepilogo
   *=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
   IF PUB_GGDTSP
	   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
	   x_data   = "mag_datagg = '" + SPACE(10) + "'"
	   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
	   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
	   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
	   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
	   Csql     = "select * from u_mag_gg where " + x_cond
	   IF !ExecRW(cSql,"U_MAG_GG","R")
	      return(.f.)
	   ENDIF
	   SELECT U_MAG_GG
	   IF RECCOUNT() <> 0
	      IF _SEGNO = '+'
	         REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
	      ELSE
	         REPLACE MAG_QTAIMP WITH MAG_QTAIMP - M.LEG_QUANTI
	      ENDIF
	   ENDIF
       IF MAG_QTAIMP < 0
          REPLACE MAG_QTAIMP WITH 0
       ENDIF
       IF MAG_NRLINT > 50000000 
          REPLACE MAG_FLGRIB WITH .T.
       ENDIF
	   REPLACE MAG_FLGTRA WITH .F.
	   REPLACE MAG_FLGVIA WITH .F.
	   SCATTER MEMVAR MEMO   
	   IF !ExecRw(cSql,"U_MAG_GG","W")
	      return(.f.)
	   ENDIF
   ENDIF
   

   SELECT &_ARCHIVIO
   SKIP +1
   
ENDDO

RETURN


***************************
PROCEDURE RICARICA_GIACENZA
***************************

PARAMETERS _TIPOMOD

*=> Registrazione del movimenti ri ricarico

IF _TIPOMOD = 'SPA'
   M.MOV_TOP    = 'AV+'				&& RINO 08/03/2005
ENDIF
IF _TIPOMOD = 'RIB'
   M.MOV_TOP    = 'RA+'				&& RINO 08/03/2005
ENDIF
IF _TIPOMOD = 'TAG'
   M.MOV_TOP    = 'TA+'				&& RINO 08/03/2005
ENDIF

M.MOV_DTREGI = RIBALTA2(DTOC(DATE()))
M.MOV_ORAMOV = TIME()
M.MOV_SEGNO  = '+'
M.MOV_UNIQUE = SYS(2015)
M.MOV_CODOPE = PUB_CODOPE
M.MOV_NOMOPE = PUB_NOMOPE

cSql = "select * from u_mag_mo where 1=0"
IF !ExecRW(cSql,'U_MAG_MO','R')
   return(.f.)
ENDIF
SELECT U_MAG_MO
APPEND BLANK
DO U_MAG_MO
IF !ExecRW(cSql,'U_MAG_MO','W')
   return(.f.)
ENDIF

*=> Ricarico sulla giacenza per data -   U_MAG_GG

x_soci      = "mag_codsoc = '" + PUB_CODSOC + "'"
x_data      = "mag_datagg = '" + M.MOV_DATSCA + "'"
x_codi      = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
x_maga      = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
x_forn      = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
x_giac      = "mag_giacen = mag_giacen"
XXX_PRZACQ  = M.MOV_PREACQ
XX_PRZACQ   = ALLTRIM(STR(M.MOV_PREACQ,17,6))
XX_PRZACQ   = STRTRAN(XX_PRZACQ,",",".")
x_prez      = "mag_przcon = " + XX_PRZACQ
x_tipo      = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
x_fila      = "mag_fila_n = " + ALLTRIM(STR(M.MOV_FILA_N,5,0))
x_pian      = "mag_pian_n = " + ALLTRIM(STR(M.MOV_PIAN_N,5,0))
x_ubic      = "mag_ubic_n = " + ALLTRIM(STR(M.MOV_UBIC_N,5,0))
x_cond      = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
              x_forn + " and " + x_giac + " and " + x_tipo + " and " + x_prez + " and " + ;
              x_fila + " and " + x_pian + " and " + x_ubic
Csql        = "select top 1 * from u_mag_gg where " + x_cond + " order by mag_codacq,mag_przcon,mag_datagg"
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
GO TOP       
IF EOF()
   APPEND BLANK
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_DATAGG WITH M.MOV_DATSCA
   REPLACE MAG_CODMAG WITH M.MOV_CODMAG
   REPLACE MAG_CODART WITH M.MOV_CODART
   REPLACE MAG_DESART WITH M.MOV_DESART
   REPLACE MAG_CODPDV WITH M.MOV_CODPDV
   REPLACE MAG_FORNIT WITH M.MOV_FORNIT
   REPLACE MAG_DESFOR WITH M.MOV_DESFOR
   REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
   REPLACE MAG_PRZCON WITH M.MOV_PREACQ
   REPLACE MAG_CSTAMQ WITH M.MOV_PREACQ
   REPLACE MAG_CODACQ WITH M.MOV_CODACQ
   REPLACE MAG_PRZUFF WITH M.MOV_PREACQ
   REPLACE MAG_DATINI WITH M.MOV_INICAM
   REPLACE MAG_DATFIN WITH M.MOV_FINCAM
   REPLACE MAG_SC1    WITH M.MOV_SC1CAM
   REPLACE MAG_SC2    WITH M.MOV_SC2CAM
   REPLACE MAG_SC3    WITH M.MOV_SC3CAM
   REPLACE MAG_SC4    WITH M.MOV_SC4CAM
   REPLACE MAG_SC5    WITH M.MOV_SC5CAM
   REPLACE MAG_PRZSCO WITH M.MOV_FISCAM
   REPLACE MAG_PAGAME WITH M.MOV_PAGAME
   REPLACE MAG_NUMIDE WITH M.MOV_NUMIDE
   REPLACE MAG_CODBUN WITH M.MOV_CODBUN
   REPLACE MAG_ANNO   WITH M.MOV_ANNO
   IF EMPTY(ALLTRIM(MAG_ANNO))
      REPLACE MAG_ANNO WITH SUBSTR(MAG_DATAGG,1,4)
   ENDIF
   REPLACE MAG_UNIQUE WITH SYS(2015)
   REPLACE MAG_TIPART WITH M.MOV_TIPART
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_CODMAT WITH M.MOV_CODMAT
   REPLACE MAG_DESMAT WITH M.MOV_DESMAT
   REPLACE MAG_CODCOL WITH M.MOV_CODCOL
   REPLACE MAG_DESCOL WITH M.MOV_DESCOL
   REPLACE MAG_SPESSO WITH M.MOV_SPESSO
   REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
   REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
   REPLACE MAG_NRLINT WITH M.MOV_NRLINT
   REPLACE MAG_NRDBOB WITH M.MOV_NRDBOB
   REPLACE MAG_QTAKG  WITH M.MOV_QTAKG
   REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ
   REPLACE MAG_QTAML  WITH M.MOV_QTAML
   REPLACE MAG_CDAFOR WITH M.MOV_CDAFOR
   REPLACE MAG_OINFOR WITH M.MOV_OINFOR
   REPLACE MAG_PINFOR WITH M.MOV_PINFOR
   =CAMBIADT(M.MOV_DTPFOR,"MAG_DTPFOR")
   REPLACE MAG_TRAFOR WITH M.MOV_TRAFOR
   REPLACE MAG_NBAFOR WITH M.MOV_NBAFOR
   REPLACE MAG_BDAFOR WITH M.MOV_BDAFOR
   REPLACE MAG_BALFOR WITH M.MOV_BALFOR
   REPLACE MAG_PNKFOR WITH M.MOV_PNKFOR
   REPLACE MAG_ANAART WITH M.MOV_ANAART
   REPLACE MAG_TIPART WITH M.MOV_TIPART
   REPLACE MAG_FLGCEL WITH M.MOV_FLGCEL
   REPLACE MAG_QTACON WITH M.MOV_QTACON
   REPLACE MAG_SERIE  WITH M.MOV_SERIE
   REPLACE MAG_SERBOL WITH M.MOV_SERBOL
   REPLACE MAG_SERNUM WITH M.MOV_SERNUM
   REPLACE MAG_NUMEDA WITH M.MOV_NUMEDA
   REPLACE MAG_NUMEAL WITH M.MOV_NUMEAL
   REPLACE MAG_AAPROD WITH M.MOV_AAPROD
   REPLACE MAG_CBFISC WITH M.MOV_CBFISC
   IF EMPTY(ALLTRIM(_TIPOMOD))
      REPLACE MAG_QTAIMP WITH 0
      REPLACE MAG_GKGIMP WITH 0
      REPLACE MAG_GMLIMP WITH 0
   ELSE
      REPLACE MAG_QTAIMP WITH M.MOV_QTAMOV
      REPLACE MAG_GKGIMP WITH M.MOV_QTAKG
      REPLACE MAG_GMLIMP WITH M.MOV_QTAML
   ENDIF
   IF MAG_QTAIMP < 0 .OR. MAG_GKGIMP < 0 .OR. MAG_GMLIMP < 0
      REPLACE MAG_QTAIMP WITH 0
      REPLACE MAG_GKGIMP WITH 0
      REPLACE MAG_GMLIMP WITH 0
   ENDIF
   REPLACE MAG_DTINCQ WITH M.MOV_DTINCQ
   REPLACE MAG_ORINCQ WITH M.MOV_ORINCQ
   REPLACE MAG_DTFICQ WITH M.MOV_DTFICQ
   REPLACE MAG_ORFICQ WITH M.MOV_ORFICQ
   REPLACE MAG_CDRECQ WITH M.MOV_CDRECQ
   REPLACE MAG_DSRECQ WITH M.MOV_DSRECQ
   REPLACE MAG_CSTMAN WITH M.MOV_CSTMAN
   REPLACE MAG_CSTSCA WITH M.MOV_CSTSCA
ELSE
   REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   REPLACE MAG_QTAKG  WITH MAG_QTAKG + M.MOV_QTAKG
   REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M.MOV_QTAMQ
   REPLACE MAG_QTAML  WITH MAG_QTAML + M.MOV_QTAML
   REPLACE MAG_LUNGHE WITH MAG_QTAML
   REPLACE MAG_FLGTRA WITH .F.
   IF EMPTY(ALLTRIM(_TIPOMOD))
   ELSE
      REPLACE MAG_QTAIMP WITH MAG_GIACEN
      REPLACE MAG_GKGIMP WITH MAG_QTAKG
      REPLACE MAG_GMLIMP WITH MAG_QTAML
   ENDIF
ENDIF
REPLACE MAG_FILA_X WITH M.MOV_FILA_X
REPLACE MAG_PIAN_X WITH M.MOV_PIAN_X
REPLACE MAG_UBIC_X WITH M.MOV_UBIC_X
REPLACE MAG_FILA_N WITH M.MOV_FILA_N
REPLACE MAG_PIAN_N WITH M.MOV_PIAN_N
REPLACE MAG_UBIC_N WITH M.MOV_UBIC_N
IF MAG_NRLINT > 50000000 
   REPLACE MAG_FLGRIB WITH .T.
ENDIF
IF MAG_GIACEN < 0
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_QTAIMP WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF
IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF
P_TIPO = CERCATIPO(M.MOV_ANAART)
SELECT U_MAG_GG
IF P_TIPO = '3'	&& GESTIONE MANDRINI
   REPLACE MAG_QTAIMP WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF
IF EMPTY(ALLTRIM(PUB_MAGNO0))
ELSE
   IF MAG_GIACEN = 0
      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
      ELSE
         DELETE
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF

*=> Ricarico sulla giacenza sul magazzino standard -   U_MAG_AN

x_soci      = "mag_codsoc = '" + PUB_CODSOC + "'"  
x_maga      = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
x_codi      = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
x_cond      = x_soci + " and " + x_maga + " and " + x_codi
Csql        = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
IF !ExecRW(cSql,"U_MAG_AN","R")
   return(.f.)
ENDIF
SELECT U_MAG_AN
GO TOP
IF EOF()
   APPEND BLANK
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_CODMAG WITH M.MOV_CODMAG
   REPLACE MAG_CODART WITH M.MOV_CODART
   REPLACE MAG_DESART WITH M.MOV_DESART
   REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
   REPLACE MAG_UNIQUE WITH SYS(2015)
   REPLACE MAG_TIPART WITH M.MOV_TIPART
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_CODMAT WITH M.MOV_CODMAT
   REPLACE MAG_DESMAT WITH M.MOV_DESMAT
   REPLACE MAG_CODCOL WITH M.MOV_CODCOL
   REPLACE MAG_DESCOL WITH M.MOV_DESCOL
   REPLACE MAG_SPESSO WITH M.MOV_SPESSO
   REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
   REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
   REPLACE MAG_NRLINT WITH M.MOV_NRLINT
   REPLACE MAG_NRDBOB WITH M.MOV_NRDBOB
   REPLACE MAG_QTAKG  WITH M.MOV_QTAKG
   REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ
   REPLACE MAG_QTAML  WITH M.MOV_QTAML
   REPLACE MAG_QTAIMP WITH M.MOV_QTAMOV
ELSE
   REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   REPLACE MAG_QTAKG  WITH MAG_QTAKG + M.MOV_QTAKG
   REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M.MOV_QTAMQ
   REPLACE MAG_QTAML  WITH MAG_QTAML + M.MOV_QTAML
   REPLACE MAG_LUNGHE WITH MAG_QTAML
   REPLACE MAG_FLGTRA WITH .F.
ENDIF
IF MAG_GIACEN < 0
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_QTAIMP WITH 0
ENDIF
IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
ENDIF
IF EMPTY(ALLTRIM(PUB_MAGNO0))
ELSE
   IF MAG_GIACEN = 0
      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
      ELSE
         DELETE
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_AN","W")
   return(.f.)
ENDIF

**==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
DO GESTIONE_SALDI_MOV

**==>> RICHIAMA LA FUNZIONE PER GESTIRE I CAMPI PROGRESSIVI ANNUALI DI CARICO/SCARICO + ANAGR.ART.
_CODART      = M.MOV_CODART
_MAG         = M.MOV_CODMAG
_NUMDOC      = M.MOV_DTDOCU
_DATREG      = M.MOV_DTREGI
M_QTAFOR     = M.MOV_QTAMOV
R_PRZVEN     = M.MOV_PREVEN
R_PRZCOS     = M.MOV_PREACQ
_TOP         = 'AV-'				&& RINO 16/01/2005
M_FORNIT     = M.MOV_FORNIT
M_DESFOR     = M.MOV_DESFOR
QWE_CODACQ   = M.MOV_DESFOR
M.MAG_MATCHC = PUB_CODSOC
_NEW_SEGNO   = " "
M_CODCLI     = M.MOV_CODCLI
M_DESCLI     = M.MOV_DESCLI
=MOVIARTI(ALLTRIM(_CODART),_MAG,_NUMDOC,_DATREG,M_QTAFOR,R_PRZCOS,R_PRZVEN,_TOP,M_FORNIT,M_DESFOR,QWE_CODACQ,"",M.MAG_MATCHC,_NEW_SEGNO)

RETURN



***************************
PROCEDURE MODIFICA_GIACENZA
***************************

*=> Posizionamento sul movimento di magazzino originale della bobina con relativo aggiornamento

x_soci = "mov_codsoc = '" + PUB_CODSOC + "'"
IF _V_TIPOMOD = "SPA"
   x_maga = "mov_codmag = '" + ALLTRIM(PUB_SPAPRO) + "'" 
ENDIF
IF _V_TIPOMOD = "RIB"
   x_maga = "mov_codmag = '" + ALLTRIM(PUB_RIBPRO) + "'" 
ENDIF
IF _V_TIPOMOD = "TAG"
   x_maga = "mov_codmag = '" + ALLTRIM(PUB_TAGPRO) + "'" 
ENDIF
x_arti = "mov_codart = '" + M.NUD_CODINT + "'"
x_ctop = "mov_top = 'SPC'"
x_ndoc = "mov_numdoc = mov_numdoc"
x_ddoc = "mov_dtdocu = mov_dtdocu"
x_dreg = "mov_dtregi = '" + M.AVA_AMGAVA + "'"
x_oreg = "mov_oramov <= '" + M.AVA_ORAAVA + "'"
x_cond = x_soci + " and " + x_maga + " and " + x_arti + " and " + x_ctop + " and " + x_ndoc
x_cond = x_cond + " and " + x_ddoc + " and " + x_dreg + " and " + x_oreg
cSql = "select * from u_mag_mo where " + x_cond + " order by mov_dtregi,mov_oramov DESC"
IF !ExecRW(cSql,'U_MAG_MO','R')
   return(.f.)
ENDIF
V_TROV_ARTI  = .F.
SELECT U_MAG_MO
GO TOP
IF EOF()
ELSE

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
   SCATTER MEMVAR MEMO
   IF MOV_SEGNO = '+'
      M.MOV_SEGNO = '-'
   ELSE
      M.MOV_SEGNO = '+'
   ENDIF
   DO GESTIONE_SALDI_MOV

   _QTAMQ = TROVA_MQ_DA_AL(M.AVA_ALTDIG,M.AVA_LUNDIG,1)
   _QTAKG = TROVA_KG_DA_MQ(MOV_ANAART,MOV_SPESSO,_QTAMQ,1)
   REPLACE MOV_ORAMOV WITH M.AVA_ORADIG
   REPLACE MOV_DTREGI WITH RIBALTA2(M.AVA_DATDIG)
   REPLACE MOV_ALTEZZ WITH M.AVA_ALTDIG
   REPLACE MOV_LUNGHE WITH M.AVA_LUNDIG
   REPLACE MOV_QTAMOV WITH _QTAMQ
   REPLACE MOV_QTAMQ  WITH _QTAMQ
   REPLACE MOV_QTAKG  WITH _QTAKG
   REPLACE MOV_QTAML  WITH M.AVA_LUNDIG
   REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
   REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
       RELEASE P_TIPO
       PUBLIC  P_TIPO
       P_TIPO = CERCATIPO(MOV_ANAART)
       SELECT U_MAG_MO
       IF P_TIPO = '3'	&& GESTIONE MANDRINI
          P_VALACQ = ROUND(((MOV_ALTEZZ / 1000) * MOV_PREACQ),2)
	      REPLACE MOV_VALACQ WITH P_VALACQ
       ENDIF
   SCATTER MEMVAR memo
   V_TROV_ARTI = .T.

   **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
   DO GESTIONE_SALDI_MOV

ENDIF
IF !ExecRW(cSql,'U_MAG_MO','W')
   return(.f.)
ENDIF

*=> Aggiornamento sulla giacenza per data -   U_MAG_GG

x_soci      = "mag_codsoc = '" + PUB_CODSOC + "'"
x_data      = "mag_datagg = '" + M.MOV_DATSCA + "'"
x_codi      = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
x_maga      = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
x_forn      = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
x_giac      = "mag_giacen = mag_giacen"
XXX_PRZACQ  = M.MOV_PREACQ
XX_PRZACQ   = ALLTRIM(STR(M.MOV_PREACQ,17,6))
XX_PRZACQ   = STRTRAN(XX_PRZACQ,",",".")
x_prez      = "mag_przcon = " + XX_PRZACQ
x_tipo      = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
x_fila      = "mag_fila_n = " + ALLTRIM(STR(M.MOV_FILA_N,5,0))
x_pian      = "mag_pian_n = " + ALLTRIM(STR(M.MOV_PIAN_N,5,0))
x_ubic      = "mag_ubic_n = " + ALLTRIM(STR(M.MOV_UBIC_N,5,0))
x_cond      = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
              x_forn + " and " + x_giac + " and " + x_tipo + " and " + x_prez + " and " + ;
              x_fila + " and " + x_pian + " and " + x_ubic
Csql        = "select top 1 * from u_mag_gg where " + x_cond + " order by mag_codacq,mag_przcon,mag_datagg"
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
GO TOP       
IF EOF()
ELSE
   REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
   REPLACE MAG_QTAKG  WITH M.MOV_QTAKG
   REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ
   REPLACE MAG_QTAML  WITH M.MOV_QTAML
   REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
   REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_CSTAMQ WITH (MAG_CSTADE + MAG_CSTFNU) / MAG_QTAMQ
   REPLACE MAG_FILA_X WITH M.MOV_FILA_X
   REPLACE MAG_PIAN_X WITH M.MOV_PIAN_X
   REPLACE MAG_UBIC_X WITH M.MOV_UBIC_X
   REPLACE MAG_FILA_N WITH M.MOV_FILA_N
   REPLACE MAG_PIAN_N WITH M.MOV_PIAN_N
   REPLACE MAG_UBIC_N WITH M.MOV_UBIC_N
   IF MAG_NRLINT > 50000000 
      REPLACE MAG_FLGRIB WITH .T.
   ENDIF
	IF MAG_GIACEN < 0
	   REPLACE MAG_GIACEN WITH 0
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_QTAIMP WITH 0
	   REPLACE MAG_GKGIMP WITH 0
	   REPLACE MAG_GMLIMP WITH 0
	ENDIF
	IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_GKGIMP WITH 0
	   REPLACE MAG_GMLIMP WITH 0
	ENDIF
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF


*=> Aggiornamento sulla giacenza sul magazzino standard -   U_MAG_AN

x_soci      = "mag_codsoc = '" + PUB_CODSOC + "'"  
x_maga      = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
x_codi      = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
x_cond      = x_soci + " and " + x_maga + " and " + x_codi
Csql        = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
IF !ExecRW(cSql,"U_MAG_AN","R")
   return(.f.)
ENDIF
SELECT U_MAG_AN
GO TOP
IF EOF()
ELSE
   REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
   REPLACE MAG_QTAKG  WITH M.MOV_QTAKG
   REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ
   REPLACE MAG_QTAML  WITH M.MOV_QTAML
   REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
   REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
   REPLACE MAG_FLGTRA WITH .F.
	IF MAG_GIACEN < 0
	   REPLACE MAG_GIACEN WITH 0
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_QTAIMP WITH 0
	ENDIF
	IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	ENDIF
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_AN","W")
   return(.f.)
ENDIF


RETURN


*******************************
PROCEDURE MODIFICA_GIACENZA_INV
*******************************

*=> Generazione del movimento di scarico della vecchia giacenza

x_soci = "mov_codsoc = '" + PUB_CODSOC + "'"
x_maga = "mov_codmag = '" + M.MAG_CODMAG + "'" 
x_arti = "mov_codart = '" + M.MAG_CODART + "'"
x_ctop = "mov_top = mov_top"
x_ndoc = "mov_numdoc = mov_numdoc"
x_ddoc = "mov_dtdocu = mov_dtdocu"
x_dreg = "mov_dtregi = mov_dtregi"
x_oreg = "mov_oramov = mov_oramov"
x_cond = x_soci + " and " + x_maga + " and " + x_arti + " and " + x_ctop + " and " + x_ndoc
x_cond = x_cond + " and " + x_ddoc + " and " + x_dreg + " and " + x_oreg
cSql = "select top 1 * from u_mag_mo where " + x_cond + " order by mov_dtregi desc,mov_oramov DESC"
IF !ExecCommand(cSql,'U_MAG_MO')
   return(.f.)
ENDIF
SELECT U_MAG_MO
SCATTER MEMVAR MEMO

IF M.INV_INSERI
ELSE
   Csql = "select * from u_mag_mo where 1=0"
   IF !ExecRW(Csql,"U_MAG_MO","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_MO
   APPEND BLANK
   DO U_MAG_MO
   REPLACE MOV_NUMDOC WITH '000001'
   REPLACE MOV_DTDOCU WITH RIBALTA2(DTOC(DATE()))
   REPLACE MOV_DTREGI WITH _V_DATINV
   REPLACE MOV_ORAMOV WITH _V_ORAINV				
   REPLACE MOV_TOP    WITH 'IN-'
   REPLACE MOV_QTAMOV WITH M.MAG_GIACEN
   REPLACE MOV_QTAMQ  WITH M.MAG_QTAMQ
   REPLACE MOV_QTAML  WITH M.MAG_QTAML
   REPLACE MOV_QTAKG  WITH M.MAG_QTAKG
   REPLACE MOV_ALTEZZ WITH M.MAG_ALTEZZ
   REPLACE MOV_LUNGHE WITH M.MAG_LUNGHE
   REPLACE MOV_SPESSO WITH M.MAG_SPESSO
   REPLACE MOV_CODMAT WITH M.MAG_CODMAT
   REPLACE MOV_DESMAT WITH M.MAG_DESMAT
   REPLACE MOV_CODCOL WITH M.MAG_CODCOL
   REPLACE MOV_DESCOL WITH M.MAG_DESCOL
   REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
   REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
   REPLACE MOV_SEGNO  WITH '-'					
   REPLACE MOV_TIPMOV WITH 'MO'				
   REPLACE MOV_UNIQUE WITH SYS(2015)
   REPLACE MOV_FILA_X WITH M.MAG_FILA_X
   REPLACE MOV_PIAN_X WITH M.MAG_PIAN_X
   REPLACE MOV_UBIC_X WITH M.MAG_UBIC_X
   REPLACE MOV_FILA_N WITH M.MAG_FILA_N
   REPLACE MOV_PIAN_N WITH M.MAG_PIAN_N
   REPLACE MOV_UBIC_N WITH M.MAG_UBIC_N
   IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
	  REPLACE MOV_QTAMQ  WITH 0
	  REPLACE MOV_QTAKG  WITH 0
	  REPLACE MOV_QTAML  WITH 0
	  REPLACE MOV_QTAMQA WITH 0
	  REPLACE MOV_QTAMLA WITH 0
	  REPLACE MOV_QTAKGA WITH 0
   ENDIF
   RELEASE P_TIPO
   PUBLIC  P_TIPO
   P_TIPO = CERCATIPO(MOV_ANAART)
   SELECT U_MAG_MO
   IF P_TIPO = '3'	&& GESTIONE MANDRINI
      P_VALACQ = ROUND(((MOV_ALTEZZ / 1000) * MOV_PREACQ),2)
	  REPLACE MOV_VALACQ WITH P_VALACQ
   ENDIF
   SCATTER MEMVAR MEMO
   IF !ExecRW(Csql,"U_MAG_MO","W")
      return(.f.)
   ENDIF
   **==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
   DO GESTIONE_SALDI_MOV
   OLD_TIME = TIME()
   DO WHILE .T.
      NEW_TIME = TIME()
      IF NEW_TIME = OLD_TIME
      ELSE
         EXIT
      ENDIF
   ENDDO

   *=> Aggiornamento sulla giacenza per data -   U_MAG_GG

   x_soci      = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data      = "mag_datagg = '" + M.MOV_DATSCA + "'"
   x_codi      = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga      = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn      = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_giac      = "mag_giacen = mag_giacen"
   XXX_PRZACQ  = M.MOV_PREACQ
   XX_PRZACQ   = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ   = STRTRAN(XX_PRZACQ,",",".")
   x_prez      = "mag_przcon = " + XX_PRZACQ
   x_tipo      = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   x_fila      = "mag_fila_n = " + ALLTRIM(STR(M.MOV_FILA_N,5,0))
   x_pian      = "mag_pian_n = " + ALLTRIM(STR(M.MOV_PIAN_N,5,0))
   x_ubic      = "mag_ubic_n = " + ALLTRIM(STR(M.MOV_UBIC_N,5,0))
   x_cond      = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                 x_forn + " and " + x_giac + " and " + x_tipo + " and " + x_prez + " and " + ;
                 x_fila + " and " + x_pian + " and " + x_ubic
   Csql        = "select top 1 * from u_mag_gg where " + x_cond + " order by mag_codacq,mag_przcon,mag_datagg"
   IF !ExecRW(cSql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   GO TOP       
   IF EOF()
   ELSE
      REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
      REPLACE MAG_QTAKG  WITH MAG_QTAKG - M.MOV_QTAKG
      REPLACE MAG_QTAMQ  WITH MAG_QTAMQ - M.MOV_QTAMQ
      REPLACE MAG_QTAML  WITH MAG_QTAML - M.MOV_QTAML
      REPLACE MAG_LUNGHE WITH MAG_QTAML
      REPLACE MAG_FLGTRA WITH .F.
      IF MAG_QTAMQ = 0
         REPLACE MAG_CSTAMQ WITH 0
      ELSE
         REPLACE MAG_CSTAMQ WITH (MAG_CSTADE + MAG_CSTFNU) / MAG_QTAMQ
      ENDIF
      IF MAG_NRLINT > 50000000 
         REPLACE MAG_FLGRIB WITH .T.
      ENDIF
	  IF MAG_GIACEN < 0
	     REPLACE MAG_GIACEN WITH 0 
   	     REPLACE MAG_QTAMQ  WITH 0
	     REPLACE MAG_QTAKG  WITH 0
	     REPLACE MAG_QTAML  WITH 0
	     REPLACE MAG_QTAIMP WITH 0
	     REPLACE MAG_GKGIMP WITH 0
	     REPLACE MAG_GMLIMP WITH 0
	  ENDIF
	  IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
	     REPLACE MAG_QTAMQ  WITH 0
	     REPLACE MAG_QTAKG  WITH 0
	     REPLACE MAG_QTAML  WITH 0
	     REPLACE MAG_GKGIMP WITH 0
	     REPLACE MAG_GMLIMP WITH 0
	  ENDIF
      IF EMPTY(ALLTRIM(PUB_MAGNO0))
      ELSE
         IF MAG_GIACEN = 0
            IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
            ELSE
               DELETE
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF !ExecRW(cSql,"U_MAG_GG","W")
      return(.f.)
   ENDIF
ENDIF


*=> Generazione del movimento di carico della nuova giacenza

Csql = "select * from u_mag_mo where 1=0"
IF !ExecRW(Csql,"U_MAG_MO","R")
   return(.f.)
ENDIF
SELECT U_MAG_MO
APPEND BLANK
DO U_MAG_MO
REPLACE MOV_NUMDOC WITH '000001'
REPLACE MOV_DTDOCU WITH RIBALTA2(DTOC(DATE()))
REPLACE MOV_DTREGI WITH _V_DATINV
REPLACE MOV_ORAMOV WITH _V_ORAINV				
REPLACE MOV_CODMAG WITH M.INV_CODMAG
REPLACE MOV_TOP    WITH 'IN+'
REPLACE MOV_QTAMOV WITH M.INV_GIACEN
REPLACE MOV_QTAMQ  WITH M.INV_QTAMQ
REPLACE MOV_QTAML  WITH M.INV_LUNGHE
REPLACE MOV_QTAKG  WITH M.INV_QTAKG
REPLACE MOV_ALTEZZ WITH M.INV_ALTEZZ
REPLACE MOV_LUNGHE WITH M.INV_LUNGHE
REPLACE MOV_SPESSO WITH M.INV_SPESSO
REPLACE MOV_CODMAT WITH M.INV_CODMAT
REPLACE MOV_DESMAT WITH M.INV_DESMAT
REPLACE MOV_CODCOL WITH M.INV_CODCOL
REPLACE MOV_DESCOL WITH M.INV_DESCOL
REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)
REPLACE MOV_SEGNO  WITH '+'					
REPLACE MOV_TIPMOV WITH 'MO'				
REPLACE MOV_UNIQUE WITH SYS(2015)
REPLACE MOV_FILA_X WITH M.INV_FILA_X
REPLACE MOV_PIAN_X WITH M.INV_PIAN_X
REPLACE MOV_UBIC_X WITH M.INV_UBIC_X
REPLACE MOV_FILA_N WITH M.INV_FILA_N
REPLACE MOV_PIAN_N WITH M.INV_PIAN_N
REPLACE MOV_UBIC_N WITH M.INV_UBIC_N
IF MOV_CODMAT = '001' .OR. MOV_CODMAT = '004'
   REPLACE MOV_QTAMQ  WITH 0
   REPLACE MOV_QTAKG  WITH 0
   REPLACE MOV_QTAML  WITH 0
   REPLACE MOV_QTAMQA WITH 0
   REPLACE MOV_QTAMLA WITH 0
   REPLACE MOV_QTAKGA WITH 0
ENDIF
RELEASE P_TIPO
PUBLIC  P_TIPO
P_TIPO = CERCATIPO(MOV_ANAART)
SELECT U_MAG_MO
IF P_TIPO = '3'	&& GESTIONE MANDRINI
   P_VALACQ = ROUND(((MOV_ALTEZZ / 1000) * MOV_PREACQ),2)
   REPLACE MOV_VALACQ WITH P_VALACQ
ENDIF
SCATTER MEMVAR MEMO
IF !ExecRW(Csql,"U_MAG_MO","W")
   return(.f.)
ENDIF

**==>> RICHIAMA LA FUNZIONE PER GESTIRE I SALDI DEI MOVIMENTI PER ANNO/MESE, MAGAZZINO ED ARTICOLO
DO GESTIONE_SALDI_MOV

*=> Aggiornamento sulla giacenza per data -   U_MAG_GG

IF M.INV_INSERI
   Csql     = "select * from u_mag_gg where 1=0"
ELSE   
   x_soci      = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_data      = "mag_datagg = '" + M.MOV_DATSCA + "'"
   x_codi      = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   x_maga      = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   x_forn      = "mag_fornit = '" + ALLTRIM(M.MOV_FORNIT) + "'"
   x_giac      = "mag_giacen = mag_giacen"
   XXX_PRZACQ  = M.MOV_PREACQ
   XX_PRZACQ   = ALLTRIM(STR(M.MOV_PREACQ,17,6))
   XX_PRZACQ   = STRTRAN(XX_PRZACQ,",",".")
   x_prez      = "mag_przcon = " + XX_PRZACQ
   x_tipo      = "mag_codacq = '" + ALLTRIM(M.MOV_CODACQ) + "'"
   x_fila      = "mag_fila_n = " + ALLTRIM(STR(M.MOV_FILA_N,5,0))
   x_pian      = "mag_pian_n = " + ALLTRIM(STR(M.MOV_PIAN_N,5,0))
   x_ubic      = "mag_ubic_n = " + ALLTRIM(STR(M.MOV_UBIC_N,5,0))
   x_cond      = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
                 x_forn + " and " + x_giac + " and " + x_tipo + " and " + x_prez + " and " + ;
                 x_fila + " and " + x_pian + " and " + x_ubic
   Csql        = "select top 1 * from u_mag_gg where " + x_cond + " order by mag_codacq,mag_przcon,mag_datagg"
ENDIF
IF !ExecRW(cSql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
GO TOP       
IF EOF()
   APPEND BLANK
   DO U_MAG_GG
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_DATAGG WITH M.MOV_DATSCA
   REPLACE MAG_CODART WITH M.MOV_CODART
   REPLACE MAG_CODMAG WITH M.MOV_CODMAG
   REPLACE MAG_FORNIT WITH M.MOV_FORNIT
   REPLACE MAG_PRZCON WITH M.MOV_PREACQ
   REPLACE MAG_CODACQ WITH M.MOV_CODACQ
   REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
   REPLACE MAG_QTAKG  WITH M.MOV_QTAKG
   REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ
   REPLACE MAG_QTAML  WITH M.MOV_QTAML
   REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
ELSE
   REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   REPLACE MAG_QTAKG  WITH MAG_QTAKG + M.MOV_QTAKG
   REPLACE MAG_QTAMQ  WITH MAG_QTAMQ + M.MOV_QTAMQ
   REPLACE MAG_QTAML  WITH MAG_QTAML + M.MOV_QTAML
   REPLACE MAG_LUNGHE WITH MAG_QTAML
ENDIF
REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
REPLACE MAG_SPESSO WITH M.MOV_SPESSO
REPLACE MAG_CODMAT WITH M.MOV_CODMAT
REPLACE MAG_DESMAT WITH M.MOV_DESMAT
REPLACE MAG_CODCOL WITH M.MOV_CODCOL
REPLACE MAG_DESCOL WITH M.MOV_DESCOL
REPLACE MAG_FLGTRA WITH .F.
REPLACE MAG_FILA_X WITH M.MOV_FILA_X
REPLACE MAG_PIAN_X WITH M.MOV_PIAN_X
REPLACE MAG_UBIC_X WITH M.MOV_UBIC_X
REPLACE MAG_FILA_N WITH M.MOV_FILA_N
REPLACE MAG_PIAN_N WITH M.MOV_PIAN_N
REPLACE MAG_UBIC_N WITH M.MOV_UBIC_N
IF MAG_QTAMQ = 0
   REPLACE MAG_CSTAMQ WITH 0
ELSE
   REPLACE MAG_CSTAMQ WITH (MAG_CSTADE + MAG_CSTFNU) / MAG_QTAMQ
ENDIF
IF MAG_NRLINT > 50000000 
   REPLACE MAG_FLGRIB WITH .T.
ENDIF
IF MAG_GIACEN < 0
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_QTAIMP WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF
IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_GKGIMP WITH 0
   REPLACE MAG_GMLIMP WITH 0
ENDIF
IF EMPTY(ALLTRIM(PUB_MAGNO0))
ELSE
   IF MAG_GIACEN = 0
      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
      ELSE
         DELETE
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_GG","W")
   return(.f.)
ENDIF

*=> Aggiornamento sulla giacenza sul magazzino standard -   U_MAG_AN

x_soci      = "mag_codsoc = '" + PUB_CODSOC + "'"  
x_maga      = "mag_codmag = '" + ALLTRIM(M.MAG_CODMAG) + "'"
x_codi      = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
x_cond      = x_soci + " and " + x_maga + " and " + x_codi
Csql        = "select * from u_mag_an where " + x_cond + " order by mag_codsoc,mag_codmag,mag_codart"
IF !ExecRW(cSql,"U_MAG_AN","R")
   return(.f.)
ENDIF
SELECT U_MAG_AN
GO TOP
IF EOF()
ELSE
   IF M.MAG_CODMAG = M.INV_CODMAG
   ELSE 
      REPLACE MAG_CODMAG WITH M.INV_CODMAG
   ENDIF
   REPLACE MAG_GIACEN WITH M.MOV_QTAMOV
   REPLACE MAG_QTAKG  WITH M.MOV_QTAKG
   REPLACE MAG_QTAMQ  WITH M.MOV_QTAMQ
   REPLACE MAG_QTAML  WITH M.MOV_QTAML
   REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
   REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
   REPLACE MAG_SPESSO WITH M.MOV_SPESSO
   REPLACE MAG_CODMAT WITH M.MOV_CODMAT
   REPLACE MAG_DESMAT WITH M.MOV_DESMAT
   REPLACE MAG_CODCOL WITH M.MOV_CODCOL
   REPLACE MAG_DESCOL WITH M.MOV_DESCOL
   REPLACE MAG_FLGTRA WITH .F.
   REPLACE MAG_FILA_X WITH M.INV_FILA_X
   REPLACE MAG_PIAN_X WITH M.INV_PIAN_X
   REPLACE MAG_UBIC_X WITH M.INV_UBIC_X
   REPLACE MAG_FILA_N WITH M.INV_FILA_N
   REPLACE MAG_PIAN_N WITH M.INV_PIAN_N
   REPLACE MAG_UBIC_N WITH M.INV_UBIC_N
	IF MAG_GIACEN < 0
	   REPLACE MAG_GIACEN WITH 0
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	   REPLACE MAG_QTAIMP WITH 0
	ENDIF
	IF MAG_CODMAT = '001' .OR. MAG_CODMAT = '004'
	   REPLACE MAG_QTAMQ  WITH 0
	   REPLACE MAG_QTAKG  WITH 0
	   REPLACE MAG_QTAML  WITH 0
	ENDIF
   IF EMPTY(ALLTRIM(PUB_MAGNO0))
   ELSE
      IF MAG_GIACEN = 0
         IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
         ELSE
            DELETE
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF !ExecRW(cSql,"U_MAG_AN","W")
   return(.f.)
ENDIF

RETURN


** SERGIO 19/01/2005  INIZIO

***********************************
FUNCTION CALCIMPE
***********************************
PARAMETERS _ARTICOLO,_FUNZIONE 


** FUNZIONE PER IL RICALCOLO DELLA QUANTITA' IMPEGNATA DALLE PACKING LIST PER LA GESTIONE DELLE LISTE DI PRELIEVO 
** TRMITE PDA
**
** 1) ACCEDO CON L'ARTICOLO AI DETTAGLI DELLE PACKING LIST (U_PCK_DD) E PER OGNI DETTAGLIO :
**
**    VERIFICO SE E' STATA CREATA UNA DDT TRAMITE LA TABELLA DI LEGAME U_BOL_LE :
**
**         PER QUESTO LEGGO GLI ARTICOLI APPARTENENTI ALLE RIGHE DI PAKING LIST ANCORA APERTE
**                            E LE SALVO IN SAVE_PCK_LE 
**
** 2) RIELABORO LA TABELLA SAVE_PCK_LE E PER OGNI RECORD ACCEDO A U_MAG_GG(MAG_UNIQUE) TRAMITE LEG_SYSMAG 
**    E AZZERO LA QUANTITA' MAG_QTAIMP = 0 SIA A LIVELLO DI RECORD-RIEPILOGO CHE A LIVELLO DI RECORD-DETTAGLIO
**
**
** 3) RIELABORO LA TABELLA SAVE_PCK_LE E PER OGNI RECORD ACCEDO TRAMITE MAG_SYSMAG AL RECORD DEL MAGAZZINO U_MAG_GG 
**    E SOMMO IN  MAG_QTAIMP , LEG_QUANTITA SIA A LIVELLO DI RECORD-RIEPILOGO CHE A LIVELLO DI RECORD-DETTAGLIO
**
**




_RIT = 0  && ERASMO - 09/03/2011

** 0) --- 

**=> ERASMO - INIZIO 09/03/2011
IF USED("SAVE_PCK_LE")
	SELECT SAVE_PCK_LE
	USE
ENDIF
**=> ERASMO - FINE 09/03/2011

   cSql   = "select * from u_pck_le where 1=0"
   IF !ExecCommand(Csql,"SAVE_PCK_LE")				&& CONTIENE I RIFERIMENTI PER AGGIORNARE LA QUANTITA' IMPEGNATA
      return(.f.)
   ENDIF


** 1) ----

   

   **=> ERASMO - INIZIO 07/02/2011
   x_cart = "U_PCK_LE.LEG_ANAART = '" + ALLTRIM(_ARTICOLO) + "'"
   x_comm = "U_PCK_DD.ORD_DESART <> '*** COMMENTO ***'"
   x_clst = "U_PCK_DD.ORD_CHIUSO = 0"
   x_clsd = "U_PCK_TT.ORD_CHIUSO = 0"
   x_cond = x_cart + " and " + x_comm + " and " + x_clst + " and " + x_clsd 
   cSql   = "select U_PCK_TT.ORD_NUMORD,U_PCK_TT.ORD_DATORD,U_PCK_TT.ORD_CHIUSO,* from u_pck_le " + ;
            "LEFT OUTER JOIN U_PCK_DD ON u_pck_le.LEG_AGGANC = U_PCK_DD.DAGGANCIO AND u_pck_le.LEG_SYSPCK = U_PCK_DD.ORD_CODSYS " + ;
            "LEFT OUTER JOIN U_PCK_TT ON u_pck_le.LEG_AGGANC = U_PCK_TT.TAGGANCIO where " + x_cond 
   IF !ExecCommand(Csql,"K_PCK_LE")
      return(.f.)
   ENDIF
   SELECT K_PCK_LE
   GO TOP
   DO WHILE !EOF()
      SCATTER MEMVAR MEMO
      SELECT SAVE_PCK_LE
      APPEND BLANK
      GATHER MEMVAR MEMO
      _RIT = _RIT + M.LEG_QUANTI  && ERASMO - 09/03/2011
      SELECT K_PCK_LE
      SKIP +1
   ENDDO
   **=> ERASMO - FINE 07/02/2011


** 2) ----


*!*		SELECT SAVE_PCK_LE
*!*	    GO TOP 
*!*	    
*!*	    DO WHILE .NOT. EOF()
*!*	   
*!*	       SCATTER MEMVAR MEMO 
*!*	       
*!*		   *=> Azzera quantità impegnata sulla giacenza di dettaglio
*!*		   x_cond = "mag_unique = '" + M.LEG_SYSMAG + "'"
*!*		   Csql   = "select * from u_mag_gg where " + x_cond 
*!*		   IF !ExecRW(cSql,"U_MAG_GG","R")
*!*		      return(.f.)
*!*		   ENDIF
*!*		   
*!*		   SELECT U_MAG_GG
*!*		   IF RECCOUNT() <> 0
*!*	           REPLACE MAG_QTAIMP WITH 0
*!*	           IF MAG_NRLINT > 50000000 
*!*		          REPLACE MAG_FLGRIB WITH .T.
*!*		       ENDIF
*!*		   ENDIF

*!*	       SCATTER MEMVAR MEMO   

*!*	       IF !ExecRw(cSql,"U_MAG_GG","W")
*!*	         return(.f.)
*!*	       ENDIF


*!*		   *=> Aggiornamento quantità impegnata sulla giacenza di riepilogo
*!*	       *=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
*!*	       IF PUB_GGDTSP
*!*			   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
*!*			   x_data   = "mag_datagg = '" + SPACE(10) + "'"
*!*			   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
*!*			   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
*!*			   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
*!*			   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
*!*		       **=> ERASMO - INIZIO 07/02/2011
*!*			   Csql   = "UPDATE u_mag_gg SET MAG_QTAIMP = 0 where " + x_cond 
*!*			   IF !ExecCommand(cSql,"UPD_MAG_GG")
*!*			      return(.f.)
*!*			   ENDIF
*!*			   **=> ERASMO - FINE 07/02/2011
*!*		   ENDIF
*!*		   



*!*		   SELECT SAVE_PCK_LE
*!*		   SKIP +1

*!*		ENDDO

	**=> ERASMO - INIZIO 09/03/2011
	*** L'AZZERAMENTO NON DIPENDE DALLE PACKING LIST IN PIEDI, IN QUANTO SICURAMENTE ESISTONO GIACENZE SENZA PACKING LIST ASSOCIATE
	*=> Azzera quantità impegnata sulle giacenza di dettaglio
	x_arti = "mag_anaart = '" + ALLTRIM(_ARTICOLO) + "'"
	x_giac = "mag_giacen > 0"
	x_data = "mag_datagg <> ''"
	x_cond = x_arti + " and " + x_giac + " and " + x_data 
	Csql   = "select * from u_mag_gg where " + x_cond 
	IF !ExecRW(cSql,"U_MAG_GG","R")
	    return(.f.)
	ENDIF
	SELECT U_MAG_GG
	SCAN
		SCATTER MEMVAR MEMO
		REPLACE MAG_QTAIMP WITH 0

		*=> Aggiornamento quantità impegnata sulle giacenza di riepilogo
		*=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
		IF TYPE("PUB_GGDTSP") = "L"
		ELSE
			PUB_GGDTSP = .T.
		ENDIF
		IF PUB_GGDTSP
			x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
			x_data   = "mag_datagg = '" + SPACE(10) + "'"
			x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
			x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
			x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
			x_giac   = "mag_giacen > 0"
			x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_giac
			Csql1    = "UPDATE u_mag_gg SET MAG_QTAIMP = 0 where " + x_cond 
			IF !ExecCommand(Csql1,"UPD_MAG_GG")
				return(.f.)
			ENDIF
		ENDIF   
   ENDSCAN
   IF !ExecRW(cSql,"U_MAG_GG","W")
     return(.f.)
   ENDIF
   **=> ERASMO - FINE 09/03/2011


** 3) ----

	IF _FUNZIONE = "RICALCOLA"
	
		SELECT SAVE_PCK_LE
	    GO TOP 
	    DO WHILE .NOT. EOF()
	   
	       SCATTER MEMVAR MEMO 
	       
		   *=> Ricalcola e aggiorna la quantità impegnata sulla giacenza di dettaglio
		   x_cond = "mag_unique = '" + M.LEG_SYSMAG + "'"
		   Csql   = "select * from u_mag_gg where " + x_cond 
		   IF !ExecRW(cSql,"U_MAG_GG","R")
		      return(.f.)
		   ENDIF
		   
		   SELECT U_MAG_GG
		   IF RECCOUNT() <> 0
	          REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
	          IF MAG_NRLINT > 50000000 
	             REPLACE MAG_FLGRIB WITH .T.
	          ENDIF
		   ENDIF

	       SCATTER MEMVAR MEMO   

	       IF !ExecRw(cSql,"U_MAG_GG","W")
	         return(.f.)
	       ENDIF

	       **=> ERASMO - INIZIO 07/02/2011
		   *=> Determino la QTA impegnata totale di tutte le giacenze significative a livello di ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
		   _QTAIMP_TOT = 0
		   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
		   x_data   = "mag_datagg <> '" + SPACE(10) + "'"
		   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
		   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
		   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
		   x_giac   = "mag_giacen > 0"
		   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_giac
		   Csql     = "select MAG_QTAIMP from u_mag_gg where " + x_cond
		   IF !ExecCommand(cSql,"QI_MAG_GG")
		      return(.f.)
		   ENDIF
		   SELECT QI_MAG_GG
		   GO TOP
		   SCAN
		      _QTAIMP_TOT = _QTAIMP_TOT + MAG_QTAIMP
		   ENDSCAN
	       **=> ERASMO - FINE 07/02/2011

		   *=> Ricalcola e aggiorna la impegnata sulla giacenza di riepilogo
           *=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
           IF PUB_GGDTSP
			   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
			   x_data   = "mag_datagg = '" + SPACE(10) + "'"
			   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
			   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
			   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
			   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
			   Csql     = "select * from u_mag_gg where " + x_cond
			   IF !ExecRW(cSql,"U_MAG_GG","R")
			      return(.f.)
			   ENDIF
			   SELECT U_MAG_GG
			   IF RECCOUNT() <> 0
			      *REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
			      REPLACE MAG_QTAIMP WITH _QTAIMP_TOT  && ERASMO - 07/02/2011
	              IF MAG_NRLINT > 50000000 
	                 REPLACE MAG_FLGRIB WITH .T.
	              ENDIF
			   ENDIF
			   SCATTER MEMVAR MEMO   
			   IF !ExecRw(cSql,"U_MAG_GG","W")
			      return(.f.)
			   ENDIF
		   ENDIF


		   SELECT SAVE_PCK_LE
		   SKIP +1

		ENDDO
	ENDIF

	IF _FUNZIONE = "RICALCOLA"
	    WAIT WINDOW NOWAIT "Impegnato dell'articolo "+_ARTICOLO+" ricalcolato"
	ELSE
	    WAIT WINDOW NOWAIT "Impegnato dell'articolo "+_ARTICOLO+" azzerato"
	ENDIF



*RETURN
RETURN _RIT  && ERASMO - 09/03/2011

** SERGIO 19/01/2005  FINE


***********************************
FUNCTION CALCIMPE_OLD
***********************************
PARAMETERS _ARTICOLO,_FUNZIONE 


** FUNZIONE PER IL RICALCOLO DELLA QUANTITA' IMPEGNATA DALLE PACKING LIST PER LA GESTIONE DELLE LISTE DI PRELIEVO 
** TRMITE PDA

** 1) ACCEDO CON L'ARTICOLO AI DETTAGLI DELLE PACKING LIST (U_PCK_DD) E PER OGNI DETTAGLIO :
**
**    VERIFICO SE E' STATA CREATA UNA DDT TRAMITE LA TABELLA DI LEGAME U_BOL_LE :
**
**         PER QUESTO LEGGO CON U_PCK_DD.ORD_CODSYS LA TABELLA U_BOL_LE.LEG_SYSPCK 
**               SE NON TROVO NESSUN RECORD ALLORA E' UN DETTAGLIO BUONO PER CALCOLARE L'IMPEGNATO:
**
**                            ACCEDO ALLA PACKING LIST CON CHIAVE U_PCK_LE.LEG_SYSPCK=U_PCK_DD.ORD_CODSYS
**                            SALVO IN SAVE_PCK_LE U_PCK_LE PER I RIFERIMENTI AL MAGAZZINO 
**                                                                (U_PCK_LE.LEG_SYSMAG=U_MAG_GG.MAG_UNIQUE)
**
**               SE LA TROVO SIGNIFICA CHE LA DDT E' STATA CREATA E L'IMPEGNO E' GIA' STATO SCARICATO
**
** 2) RIELABORO LA TABELLA SAVE_PCK_LE E PER OGNI RECORD ACCEDO A U_MAG_GG(MAG_UNIQUE) TRAMITE LEG_SYSMAG 
**    E AZZERO LA QUANTITA' MAG_QTAIMP = 0 SIA A LIVELLO DI RECORD-RIEPILOGO CHE A LIVELLO DI RECORD-DETTAGLIO
**
**
** 3) RIELABORO LA TABELLA SAVE_PCK_LE E PER OGNI RECORD ACCEDO TRAMITE MAG_SYSMAG AL RECORD DEL MAGAZZINO U_MAG_GG 
**    E SOMMO IN  MAG_QTAIMP , LEG_QUANTITA SIA A LIVELLO DI RECORD-RIEPILOGO CHE A LIVELLO DI RECORD-DETTAGLIO
**
**




** 0) --- 


   cSql   = "select * from u_pck_le where 1=0"
   IF !ExecCommand(Csql,"SAVE_PCK_LE")				&& CONTIENE I RIFERIMENTI PER AGGIORNARE LA QUANTITA' IMPEGNATA
      return(.f.)
   ENDIF


** 1) ----


*!*	   x_cond = "ORD_CODART = '" + ALLTRIM(_ARTICOLO) + "'"
*!*	   Csql   = "select * from U_PCK_DD where " + x_cond + " order by daggancio"
*!*	   IF !ExecCommand(cSql,"K_PCK_DD")
*!*	      return(.f.)
*!*	   ENDIF

*!*	   SELECT K_PCK_DD
*!*	   GO TOP
*!*	   DO WHILE .NOT. EOF()

*!*	        SCATTER MEMVAR MEMO

*!*			*!*	IF M.ORD_CODSYS = '_1FH1509GJ'
*!*			*!*	  SET STEP ON
*!*			*!*	ENDIF

*!*	        x_syspck = "leg_syspck = '" + ALLTRIM(M.ORD_CODSYS) + "'"
*!*	        cSql   = "select * from u_bol_le where " + x_syspck  + " order by leg_agganc"
*!*	        IF !ExecCommand(Csql,"K_BOL_LE")
*!*	           return(.f.)
*!*	        ENDIF
*!*	        SELECT K_BOL_LE
*!*	        GO TOP
*!*	        IF EOF()	&& IMPEGNO EFFETTIVO DA GESTIRE : NON ESISTE IL LEGAME TRA LA PACKING LIST E U_BOL_LE : LA BOLLA DEVE ESSERE ANCORA CREATA

*!*	            
*!*		        x_syspck = "leg_syspck = '" + ALLTRIM(M.ORD_CODSYS) + "'"
*!*		        cSql   = "select * from u_pck_le where " + x_syspck  + " order by leg_agganc"
*!*		        IF !ExecCommand(Csql,"K_PCK_LE")
*!*		           return(.f.)
*!*		        ENDIF
*!*		        
*!*		        SELECT K_PCK_LE
*!*		        GO TOP
*!*		        DO WHILE !EOF()

*!*		            SCATTER MEMVAR MEMO			&& CONTIENE I RIFERIMENTI PER AGGIORNARE LA QUANTITA' IMPEGNATA

*!*		            SELECT SAVE_PCK_LE
*!*		            APPEND BLANK
*!*		            GATHER MEMVAR MEMO

*!*	 				SELECT K_PCK_LE
*!*	 				SKIP +1
*!*				ENDDO
*!*				            
*!*	        ENDIF


*!*	  
*!*	    	SELECT K_PCK_DD
*!*			SKIP +1


*!*	   ENDDO
   

   **=> ERASMO - INIZIO 07/02/2011
   x_cart = "U_PCK_LE.LEG_CODART = '" + ALLTRIM(_ARTICOLO) + "'"
   x_comm = "U_PCK_DD.ORD_DESART <> '*** COMMENTO ***'"
   x_clst = "U_PCK_DD.ORD_CHIUSO = 0"
   x_clsd = "U_PCK_TT.ORD_CHIUSO = 0"
   x_cond = x_cart + " and " + x_comm + " and " + x_clst + " and " + x_clsd 
   cSql   = "select U_PCK_TT.ORD_NUMORD,U_PCK_TT.ORD_DATORD,U_PCK_TT.ORD_CHIUSO,* from u_pck_le " + ;
            "LEFT OUTER JOIN U_PCK_DD ON u_pck_le.LEG_AGGANC = U_PCK_DD.DAGGANCIO AND u_pck_le.LEG_SYSPCK = U_PCK_DD.ORD_CODSYS " + ;
            "LEFT OUTER JOIN U_PCK_TT ON u_pck_le.LEG_AGGANC = U_PCK_TT.TAGGANCIO where " + x_cond 
   IF !ExecCommand(Csql,"K_PCK_LE")
      return(.f.)
   ENDIF
   SELECT K_PCK_LE
   GO TOP
   DO WHILE !EOF()
      SCATTER MEMVAR MEMO
      SELECT SAVE_PCK_LE
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT K_PCK_LE
      SKIP +1
   ENDDO
   **=> ERASMO - FINE 07/02/2011


** 2) ----


	SELECT SAVE_PCK_LE
    GO TOP 
    
    DO WHILE .NOT. EOF()
   
       SCATTER MEMVAR MEMO 
       
	   *=> Azzera quantità impegnata sulla giacenza di dettaglio
	   x_cond = "mag_unique = '" + M.LEG_SYSMAG + "'"
	   Csql   = "select * from u_mag_gg where " + x_cond 
	   IF !ExecRW(cSql,"U_MAG_GG","R")
	      return(.f.)
	   ENDIF
	   
	   SELECT U_MAG_GG
	   IF RECCOUNT() <> 0
           REPLACE MAG_QTAIMP WITH 0
           IF MAG_NRLINT > 50000000 
	          REPLACE MAG_FLGRIB WITH .T.
	       ENDIF
	   ENDIF

       SCATTER MEMVAR MEMO   

       IF !ExecRw(cSql,"U_MAG_GG","W")
         return(.f.)
       ENDIF


	   *=> Aggiornamento quantità impegnata sulla giacenza di riepilogo
       *=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
       IF PUB_GGDTSP
		   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
		   x_data   = "mag_datagg = '" + SPACE(10) + "'"
		   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
		   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
		   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
		   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
*!*			   Csql     = "select * from u_mag_gg where " + x_cond
*!*			   IF !ExecRW(cSql,"U_MAG_GG","R")
*!*			      return(.f.)
*!*			   ENDIF
*!*			   SELECT U_MAG_GG
*!*			   IF RECCOUNT() <> 0
*!*		          REPLACE MAG_QTAIMP WITH 0
*!*	 	          IF MAG_NRLINT > 50000000 
*!*		             REPLACE MAG_FLGRIB WITH .T.
*!*		          ENDIF
*!*			   ENDIF
*!*			   SCATTER MEMVAR MEMO   
*!*			   IF !ExecRw(cSql,"U_MAG_GG","W")
*!*			      return(.f.)
*!*			   ENDIF
	       **=> ERASMO - INIZIO 07/02/2011
		   Csql   = "UPDATE u_mag_gg SET MAG_QTAIMP = 0 where " + x_cond 
		   IF !ExecCommand(cSql,"UPD_MAG_GG")
		      return(.f.)
		   ENDIF
		   **=> ERASMO - FINE 07/02/2011
	   ENDIF
	   



	   SELECT SAVE_PCK_LE
	   SKIP +1

	ENDDO


** 3) ----

	IF _FUNZIONE = "RICALCOLA"
	
		SELECT SAVE_PCK_LE
	    GO TOP 
	    DO WHILE .NOT. EOF()
	   
	       SCATTER MEMVAR MEMO 
	       
		   *=> Ricalcola e aggiorna la quantità impegnata sulla giacenza di dettaglio
		   x_cond = "mag_unique = '" + M.LEG_SYSMAG + "'"
		   Csql   = "select * from u_mag_gg where " + x_cond 
		   IF !ExecRW(cSql,"U_MAG_GG","R")
		      return(.f.)
		   ENDIF
		   
		   SELECT U_MAG_GG
		   IF RECCOUNT() <> 0
	          REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
	          IF MAG_NRLINT > 50000000 
	             REPLACE MAG_FLGRIB WITH .T.
	          ENDIF
		   ENDIF

	       SCATTER MEMVAR MEMO   

	       IF !ExecRw(cSql,"U_MAG_GG","W")
	         return(.f.)
	       ENDIF

	       **=> ERASMO - INIZIO 07/02/2011
		   *=> Determino la QTA impegnata totale di tutte le giacenze significative a livello di ARTICOLO/MAGAZZINO/FORNITORE DI CARICO
		   _QTAIMP_TOT = 0
		   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
		   x_data   = "mag_datagg <> '" + SPACE(10) + "'"
		   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
		   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
		   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
		   x_giac   = "mag_giacen > 0"
		   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn + " and " + x_giac
		   Csql     = "select MAG_QTAIMP from u_mag_gg where " + x_cond
		   IF !ExecCommand(cSql,"QI_MAG_GG")
		      return(.f.)
		   ENDIF
		   SELECT QI_MAG_GG
		   GO TOP
		   SCAN
		      _QTAIMP_TOT = _QTAIMP_TOT + MAG_QTAIMP
		   ENDSCAN
	       **=> ERASMO - FINE 07/02/2011

		   *=> Ricalcola e aggiorna la impegnata sulla giacenza di riepilogo
           *=> Vengono gestite le giacenze con data a spazi (record riepilogato) solo se attivo il parametro aziendale
           IF PUB_GGDTSP
			   x_soci   = "mag_codsoc = '" + M.MAG_CODSOC + "'"
			   x_data   = "mag_datagg = '" + SPACE(10) + "'"
			   x_codi   = "mag_codart = '" + M.MAG_CODART + "'"
			   x_maga   = "mag_codmag = '" + M.MAG_CODMAG + "'"
			   x_forn   = "mag_fornit = '" + M.MAG_FORNIT + "'"
			   x_cond   = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + x_forn
			   Csql     = "select * from u_mag_gg where " + x_cond
			   IF !ExecRW(cSql,"U_MAG_GG","R")
			      return(.f.)
			   ENDIF
			   SELECT U_MAG_GG
			   IF RECCOUNT() <> 0
			      *REPLACE MAG_QTAIMP WITH MAG_QTAIMP + M.LEG_QUANTI
			      REPLACE MAG_QTAIMP WITH _QTAIMP_TOT  && ERASMO - 07/02/2011
	              IF MAG_NRLINT > 50000000 
	                 REPLACE MAG_FLGRIB WITH .T.
	              ENDIF
			   ENDIF
			   SCATTER MEMVAR MEMO   
			   IF !ExecRw(cSql,"U_MAG_GG","W")
			      return(.f.)
			   ENDIF
		   ENDIF


		   SELECT SAVE_PCK_LE
		   SKIP +1

		ENDDO
	ENDIF

	IF _FUNZIONE = "RICALCOLA"
	    WAIT WINDOW NOWAIT "Impegnato dell'articolo "+_ARTICOLO+" ricalcolato"
	ELSE
	    WAIT WINDOW NOWAIT "Impegnato dell'articolo "+_ARTICOLO+" azzerato"
	ENDIF



RETURN

** SERGIO 19/01/2005  FINE




****************************
PROCEDURE GESTIONE_SALDI_MOV		&& GESTIONE DEI SALDI DEI MOVIMENTI PER MESE/ANNO, MAGAZZINO ED ARTICOLO
****************************

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(M.MOV_ANAART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond
IF !ExecCommand(cSql,"curx_articoli")
   return(.f.)
ENDIF
SELECT curx_articoli
GO TOP
SCATTER MEMVAR memo
IF EOF()
   M.ART_UNIMIS = 'NR'
ELSE 
   M.ART_UNIMIS = ART_UNIMIS
ENDIF


_X_ANNO = SUBSTR(M.MOV_DTREGI,1,4)
_V_ANNO = VAL(_X_ANNO)
IF MOD(_V_ANNO,400) = 0 .OR. MOD(_V_ANNO,4) = 0 .AND. MOD(_V_ANNO,100) != 0
   _V_BISEST = .T.
ELSE
   _V_BISEST = .F.
ENDIF
_X_SCELTA = SUBSTR(M.MOV_DTREGI,6,2)
DO CASE 
   CASE _X_SCELTA = "01"
        _X_MESE   = "01"
        _X_GIORNO = "31"
   CASE _X_SCELTA = "02"
        _X_MESE = "02"   
      IF _V_BISEST 
         _X_GIORNO = "29"     
      ELSE
         _X_GIORNO = "28"     
      ENDIF 
   CASE _X_SCELTA = "03"
        _X_MESE = "03"   
        _X_GIORNO = "31"      
   CASE _X_SCELTA = "04"
        _X_MESE = "04"   
        _X_GIORNO = "30"      
   CASE _X_SCELTA = "05"
        _X_MESE = "05"   
        _X_GIORNO = "31"      
   CASE _X_SCELTA = "06"
        _X_MESE = "06"   
        _X_GIORNO = "30"      
   CASE _X_SCELTA = "07"
        _X_MESE = "07"  
        _X_GIORNO = "31"       
   CASE _X_SCELTA = "08"
        _X_MESE = "08"  
        _X_GIORNO = "31"       
   CASE _X_SCELTA = "09"
        _X_MESE = "09"  
        _X_GIORNO = "30"       
   CASE _X_SCELTA = "10"
        _X_MESE = "10"   
        _X_GIORNO = "31"      
   CASE _X_SCELTA = "11"
        _X_MESE = "11"  
        _X_GIORNO = "30"       
   CASE _X_SCELTA = "12"
        _X_MESE = "12"
        _X_GIORNO = "31"      
ENDCASE
X_DATAFM = _X_ANNO + "/" + _X_MESE + "/" + _X_GIORNO
X_AAAAMM = _X_ANNO + "/" + _X_MESE

x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
x_data = "mag_aaaamm = '" + X_AAAAMM + "'"
x_maga = "mag_codmag = '" + M.MOV_CODMAG + "'"
x_arti = "mag_codart = '" + M.MOV_CODART + "'"
x_cond = x_soci + " and " + x_data + " and " + x_maga + " and " + x_arti
cSql   = "select * from u_mag_sa where " + x_cond
IF !ExecRW(cSql,'U_MAG_SA','R')
   return(.f.)
ENDIF
SELECT U_MAG_SA

IF EOF()
   APPEND BLANK
   REPLACE MAG_ANAART WITH M.MOV_ANAART
   REPLACE MAG_DATSAL WITH X_DATAFM 
   REPLACE MAG_DATAGG WITH X_DATAFM 
   REPLACE MAG_AAAAMM WITH X_AAAAMM 
   REPLACE MAG_GIACEN WITH 0
   REPLACE MAG_QTAMQ  WITH 0
   REPLACE MAG_QTAKG  WITH 0
   REPLACE MAG_QTAML  WITH 0
   REPLACE MAG_CODSOC WITH PUB_CODSOC
   REPLACE MAG_CODMAG WITH M.MOV_CODMAG
   REPLACE MAG_CODART WITH M.MOV_CODART
   REPLACE MAG_DESART WITH M.MOV_DESART
   REPLACE MAG_CODMAT WITH M.MOV_CODMAT
   REPLACE MAG_DESMAT WITH M.MOV_DESMAT
   REPLACE MAG_CODCOL WITH M.MOV_CODCOL
   REPLACE MAG_DESCOL WITH M.MOV_DESCOL
   REPLACE MAG_SPESSO WITH M.MOV_SPESSO
   REPLACE MAG_ALTEZZ WITH M.MOV_ALTEZZ
   REPLACE MAG_LUNGHE WITH M.MOV_LUNGHE
   REPLACE MAG_NRLINT WITH M.MOV_NRLINT
   REPLACE MAG_FORNIT WITH M.MOV_FORNIT
   REPLACE MAG_DESFOR WITH M.MOV_DESFOR
   REPLACE MAG_CODACQ WITH M.MOV_CODACQ
   REPLACE MAG_PRZCON WITH M.MOV_PREACQ
   REPLACE MAG_PRZVEN WITH M.MOV_PREVEN
   REPLACE MAG_NUMIDE WITH M.MOV_NUMIDE
ENDIF

IF M.ART_UNIMIS = 'KG'
   IF M.MOV_QTAKG = 0
      M.MOV_QTAKG = M.MOV_QTAMOV
   ENDIF
ENDIF
IF M.ART_UNIMIS = 'MQ'
   IF M.MOV_QTAMQ = 0
      M.MOV_QTAMQ = M.MOV_QTAMOV
   ENDIF
ENDIF
   
IF M.MOV_SEGNO = '+'  
   REPLACE MAG_GIACEN WITH MAG_GIACEN + M.MOV_QTAMOV
   REPLACE MAG_QTAMQ  WITH MAG_QTAMQ  + M.MOV_QTAMQ
   REPLACE MAG_QTAKG  WITH MAG_QTAKG  + M.MOV_QTAKG
   REPLACE MAG_QTAML  WITH MAG_QTAML  + M.MOV_QTAML
   **=> ERASMO - INIZIO 26/07/2005
   REPLACE MAG_CSTMAN WITH MAG_CSTMAN + M.MOV_CSTMAN
   REPLACE MAG_CSTSCA WITH MAG_CSTSCA + M.MOV_CSTSCA   
   **=> ERASMO - FINE 26/07/2005   
   REPLACE MAG_VALVEN WITH MAG_VALVEN + (ROUND((M.MOV_QTAMOV * M.MOV_PREVEN),2))
   ** VALORIZZO VALORE DI ACQUISTO 
   IF MAG_CODMAT = '004'
      REPLACE MAG_VALACQ WITH MAG_VALACQ + ROUND((M.MOV_QTAMOV * M.MOV_PREACQ),2)
   ELSE
      IF M.ART_UNIMIS = 'KG'
         REPLACE MAG_VALACQ WITH MAG_VALACQ + ROUND((M.MOV_QTAKG * M.MOV_PREACQ),2)
      ELSE      
         IF M.ART_UNIMIS = 'MQ'
            REPLACE MAG_VALACQ WITH MAG_VALACQ + ROUND((M.MOV_QTAMQ * M.MOV_PREACQ),2)
         ELSE
            IF M.ART_UNIMIS = 'ML'
               REPLACE MAG_VALACQ WITH MAG_VALACQ + ROUND(((ROUND((M.MOV_ALTEZZ/1000),2) * M.MOV_QTAMOV) * M.MOV_PREACQ),2)
            ELSE
               REPLACE MAG_VALACQ WITH MAG_VALACQ + ROUND((M.MOV_QTAMOV * M.MOV_PREACQ),2)
            ENDIF
         ENDIF
      ENDIF
   ENDIF
ELSE
   REPLACE MAG_GIACEN WITH MAG_GIACEN - M.MOV_QTAMOV
   REPLACE MAG_QTAMQ  WITH MAG_QTAMQ  - M.MOV_QTAMQ
   REPLACE MAG_QTAKG  WITH MAG_QTAKG  - M.MOV_QTAKG
   REPLACE MAG_QTAML  WITH MAG_QTAML  - M.MOV_QTAML
   **=> ERASMO - INIZIO 26/07/2005
   REPLACE MAG_CSTMAN WITH MAG_CSTMAN - M.MOV_CSTMAN
   REPLACE MAG_CSTSCA WITH MAG_CSTSCA - M.MOV_CSTSCA      
   **=> ERASMO - FINE 26/07/2005    
   REPLACE MAG_VALVEN WITH MAG_VALVEN - (ROUND((M.MOV_QTAMOV * M.MOV_PREVEN),2))
   ** VALORIZZO VALORE DI ACQUISTO 
   IF MAG_CODMAT = '004'
      REPLACE MAG_VALACQ WITH MAG_VALACQ - ROUND((M.MOV_QTAMOV * M.MOV_PREACQ),2)
   ELSE
      IF M.ART_UNIMIS = 'KG'
         REPLACE MAG_VALACQ WITH MAG_VALACQ - ROUND((M.MOV_QTAKG * M.MOV_PREACQ),2)
      ELSE      
         IF M.ART_UNIMIS = 'MQ'
            REPLACE MAG_VALACQ WITH MAG_VALACQ - ROUND((M.MOV_QTAMQ * M.MOV_PREACQ),2)
         ELSE
            IF M.ART_UNIMIS = 'ML'
               REPLACE MAG_VALACQ WITH MAG_VALACQ - ROUND(((ROUND((M.MOV_ALTEZZ/1000),2) * M.MOV_QTAMOV) * M.MOV_PREACQ),2)
            ELSE
               REPLACE MAG_VALACQ WITH MAG_VALACQ - ROUND((M.MOV_QTAMOV * M.MOV_PREACQ),2)
            ENDIF
         ENDIF
      ENDIF
   ENDIF
ENDIF

IF M.ART_UNIMIS = 'KG'
   IF MAG_QTAKG = 0
      MAG_QTAKG = MAG_GIACEN
   ENDIF
ENDIF
IF M.ART_UNIMIS = 'MQ'
   IF MAG_QTAMQ = 0
      MAG_QTAMQ = MAG_GIACEN
   ENDIF
ENDIF

IF MAG_GIACEN = 0
   REPLACE MAG_PRMVEN WITH 0
   REPLACE MAG_PRMACQ WITH 0
ELSE
   REPLACE MAG_PRMVEN WITH ROUND((MAG_VALVEN/MAG_GIACEN),6) && ricalcolo il prezzo medio di vendita
   ** VALORIZZO VALORE DI ACQUISTO E VALORE DI AQUISTO PONDERATO
   IF M.ART_UNIMIS = 'KG'
      IF MAG_QTAKG <> 0
         REPLACE MAG_PRMACQ WITH ROUND((MAG_VALACQ / MAG_QTAKG),6)
      ELSE
         REPLACE MAG_PRMACQ WITH 0         
      ENDIF
   ELSE      
      IF M.ART_UNIMIS = 'MQ'
         IF MAG_QTAMQ <> 0
            REPLACE MAG_PRMACQ WITH ROUND((MAG_VALACQ / MAG_QTAMQ),6)
         ELSE
            REPLACE MAG_PRMACQ WITH 0            
         ENDIF
      ELSE
         IF M.ART_UNIMIS = 'ML'
            V_QTML = ROUND((ROUND((MAG_ALTEZZ/1000),2) * MAG_GIACEN),2)
            IF V_QTML <> 0
               REPLACE MAG_PRMACQ WITH ROUND((MAG_VALACQ / V_QTML),6)
            ELSE
               REPLACE MAG_PRMACQ WITH 0            
            ENDIF
         ELSE
            IF MAG_GIACEN <> 0
               REPLACE MAG_PRMACQ WITH ROUND((MAG_VALACQ / MAG_GIACEN),6)
            ELSE
               REPLACE MAG_PRMACQ WITH 0
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF MAG_CODMAT = '004'
      IF MAG_GIACEN <> 0
         REPLACE MAG_PRMACQ WITH ROUND((MAG_VALACQ / MAG_GIACEN),6)
      ELSE
         REPLACE MAG_PRMACQ WITH 0
      ENDIF
   ENDIF
ENDIF

x_cond = "codice = 'TCA" + ALLTRIM(M.MOV_CODACQ) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,'PARA')
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   V_DESACQ = SPACE(30)
ELSE
   V_DESACQ = DESCRI
ENDIF     
   
SELECT U_MAG_SA
REPLACE MAG_DESACQ WITH V_DESACQ
   
x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
x_tmat = "mag_codmat = mag_codmat"
x_colo = "mag_codcol = mag_codcol" 
x_spes = "mag_spesso = mag_spesso"
x_alte = "mag_altezz = mag_altezz"
x_lung = "mag_lunghe = mag_lunghe"
x_arti = "mag_codart = '" + ALLTRIM(M.MOV_CODART) + "'"  
x_nrli = "mag_nrlint = " + ALLTRIM(STR(M.MOV_NRLINT,8,0))
x_maga = "mag_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'" 
x_forn = "mag_fornit = mag_fornit" 
x_nide = "mag_numide = mag_numide" 
x_anno = "mag_anno = mag_anno" 
x_data = "mag_datagg <> SPACE(10)"   
x_cond = x_soci + " and " + x_tmat + " and " + x_colo + " and " + x_spes + " and " + x_alte
x_cond = x_cond + " and " + x_lung + " and " + x_arti + " and " + x_nrli + " and " + x_maga
x_cond = x_cond + " and " + x_forn + " and " + x_nide + " and " + x_anno + " and " + x_data    
cSql   = "select TOP 1 * from u_mag_gg where " + x_cond
IF !ExecCommand(cSql,"CUR_MAG_AP")
   RETURN .F.
ENDIF 
SELECT CUR_MAG_AP
GO TOP
IF EOF()
ELSE
   V_FLGIMB = MAG_FLGIMB
   V_FLGRIB = MAG_FLGRIB
   V_DATAGG = MAG_DATAGG
   V_CSTFNU = MAG_CSTFNU 
   V_CSTADE = MAG_CSTADE 
   V_CSTAMQ = MAG_CSTAMQ 
   SELECT U_MAG_SA
   REPLACE MAG_FLGIMB WITH V_FLGIMB 
   REPLACE MAG_FLGRIB WITH V_FLGRIB 
   REPLACE MAG_CSTFNU WITH V_CSTFNU 
   REPLACE MAG_CSTADE WITH V_CSTADE 
   REPLACE MAG_CSTAMQ WITH V_CSTAMQ 
ENDIF

IF !ExecRW(cSql,'U_MAG_SA','W')
   return(.f.)
ENDIF

RETURN


**********************************
PROCEDURE AGGIORNA_SALDI_MAGAZZINO	
**********************************

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(M.MOV_ANAART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond
IF !ExecCommand(cSql,"curx_articoli")
   return(.f.)
ENDIF
SELECT curx_articoli
GO TOP
IF EOF()
   M.ART_UNIMIS = 'NR'
ELSE 
   M.ART_UNIMIS = ART_UNIMIS
ENDIF

_X_ANNO = SUBSTR(M.MOV_DTREGI,1,4)
_V_ANNO = VAL(_X_ANNO)
IF MOD(_V_ANNO,400) = 0 .OR. MOD(_V_ANNO,4) = 0 .AND. MOD(_V_ANNO,100) != 0
   _V_BISEST = .T.
ELSE
   _V_BISEST = .F.
ENDIF
_X_SCELTA = SUBSTR(M.MOV_DTREGI,6,2)
DO CASE 
   CASE _X_SCELTA = "01"
        _X_MESE   = "01"
        _X_GIORNO = "31"
   CASE _X_SCELTA = "02"
        _X_MESE = "02"   
      IF _V_BISEST 
         _X_GIORNO = "29"     
      ELSE
         _X_GIORNO = "28"     
      ENDIF 
   CASE _X_SCELTA = "03"
        _X_MESE = "03"   
        _X_GIORNO = "31"      
   CASE _X_SCELTA = "04"
        _X_MESE = "04"   
        _X_GIORNO = "30"      
   CASE _X_SCELTA = "05"
        _X_MESE = "05"   
        _X_GIORNO = "31"      
   CASE _X_SCELTA = "06"
        _X_MESE = "06"   
        _X_GIORNO = "30"      
   CASE _X_SCELTA = "07"
        _X_MESE = "07"  
        _X_GIORNO = "31"       
   CASE _X_SCELTA = "08"
        _X_MESE = "08"  
        _X_GIORNO = "31"       
   CASE _X_SCELTA = "09"
        _X_MESE = "09"  
        _X_GIORNO = "30"       
   CASE _X_SCELTA = "10"
        _X_MESE = "10"   
        _X_GIORNO = "31"      
   CASE _X_SCELTA = "11"
        _X_MESE = "11"  
        _X_GIORNO = "30"       
   CASE _X_SCELTA = "12"
        _X_MESE = "12"
        _X_GIORNO = "31"      
ENDCASE
X_DATAFM = _X_ANNO + "/" + _X_MESE + "/" + _X_GIORNO
X_AAAAMM = _X_ANNO + "/" + _X_MESE

x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
x_data = "mag_aaaamm = '" + X_AAAAMM + "'"
x_maga = "mag_codmag = '" + M.MOV_CODMAG + "'"
x_arti = "mag_codart = '" + M.MOV_CODART + "'"
x_cond = x_soci + " and " + x_data + " and " + x_maga + " and " + x_arti
cSql   = "select * from u_mag_sa where " + x_cond
IF !ExecRW(cSql,'U_MAG_SA','R')
   return(.f.)
ENDIF
SELECT U_MAG_SA

IF EOF()
   IF !ExecRW(cSql,'U_MAG_SA','W')
      return(.f.)
   ENDIF
   RETURN
ENDIF

IF M.ART_UNIMIS = 'KG'
   IF M.MOV_QTAKG = 0
      M.MOV_QTAKG = M.MOV_QTAMOV
   ENDIF
ENDIF
IF M.ART_UNIMIS = 'MQ'
   IF M.MOV_QTAMQ = 0
      M.MOV_QTAMQ = M.MOV_QTAMOV
   ENDIF
ENDIF

** VALORIZZO VALORE DI ACQUISTO 
IF MAG_CODMAT = '004'
   REPLACE MAG_VALACQ WITH MAG_VALACQ - ROUND((M.MOV_QTAMOV * V_OLDPRE),2)
   REPLACE MAG_VALACQ WITH MAG_VALACQ + ROUND((M.MOV_QTAMOV * VPRE),2)
ELSE
   IF M.ART_UNIMIS = 'KG'
      REPLACE MAG_VALACQ WITH MAG_VALACQ - ROUND((M.MOV_QTAKG * V_OLDPRE),2)
      REPLACE MAG_VALACQ WITH MAG_VALACQ + ROUND((M.MOV_QTAKG * VPRE),2)
   ELSE      
      IF M.ART_UNIMIS = 'MQ'
         REPLACE MAG_VALACQ WITH MAG_VALACQ - ROUND((M.MOV_QTAMQ * V_OLDPRE),2)
         REPLACE MAG_VALACQ WITH MAG_VALACQ + ROUND((M.MOV_QTAMQ * VPRE),2)
      ELSE
         IF M.ART_UNIMIS = 'ML'
            REPLACE MAG_VALACQ WITH MAG_VALACQ - ROUND(((ROUND((M.MOV_ALTEZZ/1000),2) * M.MOV_QTAMOV) * V_OLDPRE),2)
            REPLACE MAG_VALACQ WITH MAG_VALACQ + ROUND(((ROUND((M.MOV_ALTEZZ/1000),2) * M.MOV_QTAMOV) * VPRE),2)
         ELSE
            REPLACE MAG_VALACQ WITH MAG_VALACQ - ROUND((M.MOV_QTAMOV * V_OLDPRE),2)
            REPLACE MAG_VALACQ WITH MAG_VALACQ + ROUND((M.MOV_QTAMOV * VPRE),2)
         ENDIF
      ENDIF
   ENDIF
ENDIF

IF M.ART_UNIMIS = 'KG'
   IF MAG_QTAKG = 0
      MAG_QTAKG = MAG_GIACEN
   ENDIF
ENDIF
IF M.ART_UNIMIS = 'MQ'
   IF MAG_QTAMQ = 0
      MAG_QTAMQ = MAG_GIACEN
   ENDIF
ENDIF

IF MAG_GIACEN = 0
   REPLACE MAG_PRMVEN WITH 0
   REPLACE MAG_PRMACQ WITH 0
ELSE
   IF MAG_GIACEN <> 0
      REPLACE MAG_PRMVEN WITH ROUND((MAG_VALVEN/MAG_GIACEN),6) && ricalcolo il prezzo medio di vendita
   ELSE
      REPLACE MAG_PRMVEN WITH 0
   ENDIF
   ** VALORIZZO VALORE DI ACQUISTO E VALORE DI AQUISTO PONDERATO
   IF M.ART_UNIMIS = 'KG'
      IF MAG_QTAKG <> 0
         REPLACE MAG_PRMACQ WITH ROUND((MAG_VALACQ / MAG_QTAKG),6)
      ELSE
         REPLACE MAG_PRMACQ WITH 0         
      ENDIF
   ELSE      
      IF M.ART_UNIMIS = 'MQ'
         IF MAG_QTAMQ <> 0
            REPLACE MAG_PRMACQ WITH ROUND((MAG_VALACQ / MAG_QTAMQ),6)
         ELSE
            REPLACE MAG_PRMACQ WITH 0            
         ENDIF
      ELSE
         IF M.ART_UNIMIS = 'ML'
            V_QTML = ROUND((ROUND((MAG_ALTEZZ/1000),2) * MAG_GIACEN),2)
            IF V_QTML <> 0
               REPLACE MAG_PRMACQ WITH ROUND((MAG_VALACQ / V_QTML),6)
            ELSE
               REPLACE MAG_PRMACQ WITH 0            
            ENDIF
         ELSE
            IF MAG_GIACEN <> 0
               REPLACE MAG_PRMACQ WITH ROUND((MAG_VALACQ / MAG_GIACEN),6)
            ELSE
               REPLACE MAG_PRMACQ WITH 0
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF MAG_CODMAT = '004'
      IF MAG_GIACEN <> 0
         REPLACE MAG_PRMACQ WITH ROUND((MAG_VALACQ / MAG_GIACEN),6)
      ELSE
         REPLACE MAG_PRMACQ WITH 0
      ENDIF
   ENDIF
ENDIF

REPLACE MAG_PRZCON WITH MAG_PRMACQ

IF !ExecRW(cSql,'U_MAG_SA','W')
   return(.f.)
ENDIF

RETURN


****************************************************************************************
PROCEDURE PKGGESTIONEIMPEGNATO		&& Funzione di gestione dell'impegnato sul magazzino
****************************************************************************************
PARAMETERS _QTA,_SEGNO

*=> 1° Chiave di ricerca per la giacenza (sys)
x_cond1    = "mag_unique = '" + M.LEG_SYSMAG + "'"
Csql1      = "select * from u_mag_gg where " + x_cond1 + " order by mag_datagg,mag_codart,mag_przcon,mag_fornit"

*=> 2° Chiave di ricerca per la giacenza (con tutti i dettagli che ho sul record di legame)
x_soci     = "mag_codsoc = '" + PUB_CODSOC + "'"
x_data     = "mag_datagg = '" + M.LEG_DATAGG + "'"  
x_codi     = "mag_codart = '" + ALLTRIM(M.LEG_CODART) + "'"
x_maga     = "mag_codmag = '" + ALLTRIM(M.LEG_CODMAG) + "'"
x_forn     = "mag_fornit = '" + ALLTRIM(M.LEG_FORNIT) + "'"
x_giac     = "mag_giacen > 0"
x_fila     = "mag_fila_n = " + ALLTRIM(STR(M.LEG_FILA_N,5,0))
x_pian     = "mag_pian_n = " + ALLTRIM(STR(M.LEG_PIAN_N,5,0)) 
x_ubic     = "mag_ubic_n = " + ALLTRIM(STR(M.LEG_UBIC_N,5,0))  
XXX_PRZACQ = M.LEG_PRZCON
XX_PRZACQ  = ALLTRIM(STR(M.LEG_PRZCON,17,6))
XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
x_prez     = "mag_przcon = " + XX_PRZACQ
x_tipo     = "mag_codacq = mag_codacq"
x_cond2    = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
             x_forn + " and " + x_giac + " and " + x_tipo + " and " + x_prez + " and " + ;
             x_fila + " and " + x_pian + " and " + x_ubic
Csql2      = "select * from u_mag_gg where " + x_cond2 + " order by mag_datagg,mag_codart,mag_przcon,mag_fornit"

*=> 3° Chiave di ricerca per la giacenza (con tutti i dettagli che ho sul record di legame tranne le coordinate
*                                         di magazzino ma con il codice di magazzino)
x_soci     = "mag_codsoc = '" + PUB_CODSOC + "'"
x_data     = "mag_datagg = '" + M.LEG_DATAGG + "'"  
x_codi     = "mag_codart = '" + ALLTRIM(M.LEG_CODART) + "'"
x_maga     = "mag_codmag = '" + ALLTRIM(M.LEG_CODMAG) + "'"
x_forn     = "mag_fornit = '" + ALLTRIM(M.LEG_FORNIT) + "'"
x_giac     = "mag_giacen > 0"
x_fila     = "mag_fila_n = mag_fila_n"
x_pian     = "mag_pian_n = mag_pian_n"
x_ubic     = "mag_ubic_n = mag_ubic_n"
XXX_PRZACQ = M.LEG_PRZCON
XX_PRZACQ  = ALLTRIM(STR(M.LEG_PRZCON,17,6))
XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
x_prez     = "mag_przcon = " + XX_PRZACQ
x_tipo     = "mag_codacq = mag_codacq"
x_cond3    = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
             x_forn + " and " + x_giac + " and " + x_tipo + " and " + x_prez + " and " + ;
             x_fila + " and " + x_pian + " and " + x_ubic
Csql3      = "select * from u_mag_gg where " + x_cond3 + " order by mag_datagg,mag_codart,mag_przcon,mag_fornit"

*=> 4° Chiave di ricerca per la giacenza (con tutti i dettagli che ho sul record di legame tranne le coordinate
*                                         di magazzino senza il codice di magazzino)
x_soci     = "mag_codsoc = '" + PUB_CODSOC + "'"
x_data     = "mag_datagg = '" + M.LEG_DATAGG + "'"  
x_codi     = "mag_codart = '" + ALLTRIM(M.LEG_CODART) + "'"
x_maga     = "mag_codmag = mag_codmag"
x_forn     = "mag_fornit = '" + ALLTRIM(M.LEG_FORNIT) + "'"
x_giac     = "mag_giacen > 0"
x_fila     = "mag_fila_n = mag_fila_n"
x_pian     = "mag_pian_n = mag_pian_n"
x_ubic     = "mag_ubic_n = mag_ubic_n"
XXX_PRZACQ = M.LEG_PRZCON
XX_PRZACQ  = ALLTRIM(STR(M.LEG_PRZCON,17,6))
XX_PRZACQ  = STRTRAN(XX_PRZACQ,",",".")
x_prez     = "mag_przcon = " + XX_PRZACQ
x_tipo     = "mag_codacq = mag_codacq"
x_cond4    = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
             x_forn + " and " + x_giac + " and " + x_tipo + " and " + x_prez + " and " + ;
             x_fila + " and " + x_pian + " and " + x_ubic
Csql4      = "select * from u_mag_gg where " + x_cond4 + " order by mag_datagg,mag_codart,mag_przcon,mag_fornit"

V_INDICE = 0

*=> Letture sulla giacenza
IF !ExecCommand(cSql1,"xzu_mag_gg")
   return(.f.)
ENDIF
SELECT xzu_mag_gg
GO TOP
IF EOF()
   IF !ExecCommand(cSql2,"xzu_mag_gg")
      return(.f.)
   ENDIF
   SELECT xzu_mag_gg
   GO TOP
   IF EOF()
      IF !ExecCommand(cSql3,"xzu_mag_gg")
         return(.f.)
      ENDIF
      SELECT xzu_mag_gg
      GO TOP
      IF EOF()
         IF !ExecCommand(cSql4,"xzu_mag_gg")
            return(.f.)
         ENDIF
         SELECT xzu_mag_gg
         GO TOP
         IF EOF()
         ELSE
            V_INDICE = 4      
         ENDIF
      ELSE
         V_INDICE = 3      
      ENDIF
   ELSE
      V_INDICE = 2      
   ENDIF
ELSE
   V_INDICE = 1
ENDIF

IF V_INDICE = 0
   RETURN
ENDIF

x_uniq = "id_unique = '" + ID_UNIQUE + "'"
IF !ExecRW(cSql1,"u_mag_gg","R")
   return(.f.)
ENDIF
SELECT u_mag_gg
GO TOP
IF EOF()
ELSE
   IF _SEGNO = '+'
      REPLACE MAG_QTAIMP WITH MAG_QTAIMP + _QTA
   ELSE
      REPLACE MAG_QTAIMP WITH MAG_QTAIMP - _QTA
   ENDIF
   IF MAG_QTAIMP < 0
      REPLACE MAG_QTAIMP WITH 0
   ENDIF
   M.LEG_SYSMAG = MAG_UNIQUE
   M.LEG_CODMAG = MAG_CODMAG
ENDIF
IF !ExecRW(cSql,"u_mag_gg","W")
   return(.f.)
ENDIF

RETURN


****************************************************************************************
PROCEDURE RILEVA_GIACENZA		&& Funzione di rilevamento della giacenza ed impegnato
****************************************************************************************
PARAMETERS _cdarticolo,_cdmagazz,_cdfornit

**=> ERASMO - INIZIO 29/11/2007
_qtakg = 0
_qtamq = 0
_qtaml = 0
**=> ERASMO - FINE 29/11/2007

SMAGS=STR(SELECT())

_qtgiac = 0
_qtimpe = 0

x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
x_tmat = "mag_codmat = mag_codmat"
x_colo = "mag_codcol = mag_codcol"
x_spes = "mag_spesso = mag_spesso"
x_alte = "mag_altezz = mag_altezz"
x_lung = "mag_lunghe = mag_lunghe"
x_arti = "mag_anaart = '" + ALLTRIM(_cdarticolo) + "'" 
x_nrli = "mag_nrlint = mag_nrlint"
x_maga = IIF(EMPTY(ALLTRIM(_cdmagazz)),"mag_codmag = mag_codmag","mag_codmag = '" + ALLTRIM(_cdmagazz) + "'")
x_forn = IIF(EMPTY(ALLTRIM(_cdfornit)),"mag_fornit = mag_fornit","mag_fornit = '" + ALLTRIM(_cdfornit) + "'")
x_forn = "mag_fornit = mag_fornit"
x_nide = "mag_numide = mag_numide"
x_anno = "mag_anno = mag_anno"
x_data = "mag_datagg <> SPACE(10)"
x_giac = "mag_giacen > 0"
x_impe = "mag_qtaimp = mag_qtaimp"
x_cond = x_soci + " and " + x_tmat + " and " + x_colo + " and " + x_spes + " and " + x_alte
x_cond = x_cond + " and " + x_lung + " and " + x_arti + " and " + x_nrli + " and " + x_maga
x_cond = x_cond + " and " + x_forn + " and " + x_nide + " and " + x_anno + " and " + x_data 
x_cond = x_cond + " and " + x_giac + " and " + x_impe
cSql   = "select * from u_mag_gg where " + x_cond + " order by mag_datagg,mag_codart"
IF !ExecCommand(cSql,'CU_MAG_GW')
   return(.f.)
ENDIF
SELECT CU_MAG_GW
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   _qtgiac = _qtgiac + MAG_GIACEN
   _qtimpe = _qtimpe + MAG_QTAIMP
   **=> ERASMO - INIZIO 29/11/2007
   _qtakg = _qtakg + MAG_QTAKG
   _qtamq = _qtamq + MAG_QTAMQ
   _qtaml = _qtaml + MAG_QTAML
   **=> ERASMO - FINE 29/11/2007
   SKIP +1
ENDDO


SELECT &SMAGS

RETURN





*** ERASMO - 28/06/2011 - PROCEDURA "RILEVA_ORDINATO_A_FORNITORE" TRASFERITA IN NUOVA LIBRERIA DI MAGAZZINO PRG\AQMLIB.PRG
*!*	*******************************************************************************************************************************
*!*	PROCEDURE RILEVA_ORDINATO_A_FORNITORE	&& Funzione di rilevamento del materiale ordinato a fornitore
*!*	*******************************************************************************************************************************
*!*	*
*!*	*  OPZIONI POSSIBILI	:
*!*	*  						: se codice articolo presente : estrae tutti gli ordini a fornitore dell'articolo desiderato
*!*	*						: 								altrimenti estrae tutto
*!*	*						: se data cosegna dal al presente : estrae gli ordini a fornitore che devono essere consegnati
*!*	*						:									altrimenti estrae tutto
*!*	*						: se codice fornitore presente : estrae tutti gli ordini a fornitore del fornitore desiderato
*!*	*						: 								altrimenti estrae tutto
*!*	*						: se date consegna presenti : estrae tutti gli ordini a fornitore del periodo indicao
*!*	*						: 								altrimenti estrae tutto
*!*	*						: se ordini_da_consegnare = TUTTI estrae tutti gli ordini a fornitore 
*!*	*						:   					  = SI estrae solo gli ordini a fornitore con (ord_qtaord - ord_qtaev) > 0
*!*	*						:   					  = NO estrae solo gli ordini a fornitore con (ord_qtaord - ord_qtaev) =< 0
*!*	*						: se date ordini presenti : estrae tutti gli ordini a fornitore del periodo indicato
*!*	*						: 							altrimenti estrae tutto
*!*	*
*!*	*  OUTPUT				:
*!*	*						:
*!*	*						: cursore PRODOTTI_ORDINATI_A_FORNITORE , contenente tutte le righe degli ordini a frornitore per data consegna
*!*	*						: 
*!*	*
*!*	*
*!*	*
*!*	PARAMETERS _codicefornitore,_cdarticolo,_dataconsegna_dal,_dataconsegna_al,_ordini_da_consegnare,_dataordine_dal,_dataordine_al

*!*	SMAGS=STR(SELECT())



*!*	IF !EMPTY(alltrim(_dataordine_dal))
*!*		x_dord = "ors_datord between '" + _dataordine_dal + "' and '" + _dataordine_al + "'"
*!*	ELSE
*!*		x_dord = "ors_datord = ors_datord"
*!*	ENDIF


*!*	x_qtev = "ord_qtaord = ord_qtaord"

*!*	IF _ordini_da_consegnare = "SI"
*!*		x_qtev = "(ord_qtaord - ord_qtaev) > 0"
*!*	ENDIF

*!*	IF _ordini_da_consegnare = "NO"
*!*		x_qtev = " NOT ((ord_qtaord - ord_qtaev) > 0)"
*!*	ENDIF

*!*	IF !EMPTY(alltrim(_dataconsegna_dal))
*!*		x_dsca  = "ord_datcon between '" + _dataconsegna_dal + "' and '" + _dataconsegna_al + "'"
*!*	ELSE
*!*		x_dsca = "ord_datcon = ord_datcon"
*!*	ENDIF

*!*	IF !EMPTY(alltrim(_codicefornitore))
*!*		x_ccli = "ors_codcli = '" + ALLTRIM(_codicefornitore) + "'"
*!*	ELSE
*!*		x_ccli = "ors_codcli = ors_codcli"
*!*	ENDIF 

*!*	IF !EMPTY(ALLTRIM(_cdarticolo))
*!*		x_cart = "ord_codart = '" + ALLTRIM(_cdarticolo) + "'"
*!*	ELSE
*!*		x_cart = "ord_codart = ord_codart" 
*!*	ENDIF

*!*	*!*	   x_cmat = "ord_codmat = '" + ALLTRIM(_X_CODMAT) + "'"
*!*	x_cmat = "ord_codmat = ord_codmat" 
*!*	x_ccol = "ord_codcol = ord_codcol"
*!*	x_spes = "ord_spesso = ord_spesso"
*!*	*!*	   x_alte = IIF(_X_ALTEZZ=0,"ord_altezz = ord_altezz","ord_altezz = " + ALLTRIM(STR(_X_ALTEZZ,5,0)))
*!*	x_alte = "ord_altezz = ord_altezz"
*!*	x_lung = "ord_lunghe = ord_lunghe"
*!*	       
*!*	x_cond = x_dord + " and " + x_dsca + " and " + x_ccli + " and " + x_cart + " and " + x_cmat ;
*!*	         + " and " + x_ccol + " and " + x_spes + " and " + x_alte + " and " + x_lung + " and " + x_qtev 
*!*	cSql   = "select * from u_orf_dd where " + x_cond + " order by ord_datcon"

*!*	*!*	_CLIPTEXT=CSQL  && VARIABILE DI SISTEMA PER CATTURARE IL CONTENUTO DI cSql che è molto lunga

*!*	IF !ExecCommand(cSql,"PRODOTTI_ORDINATI_A_FORNITORE")
*!*	   return(.f.)
*!*	ENDIF   
*!*	SELECT PRODOTTI_ORDINATI_A_FORNITORE
*!*	GO TOP


*!*	SELECT &SMAGS



*!*	RETURN


*** ERASMO - 28/06/2011 - PROCEDURA "RILEVA_ORDINATO_DA_CLIENTE" TRASFERITA IN NUOVA LIBRERIA DI MAGAZZINO PRG\AQMLIB.PRG
*!*	*******************************************************************************************************************************
*!*	PROCEDURE RILEVA_ORDINATO_DA_CLIENTE	&& Funzione di rilevamento del materiale ordinato daa cliente
*!*	*******************************************************************************************************************************
*!*	*
*!*	*  OPZIONI POSSIBILI	:
*!*	*  						: se codice articolo presente : estrae tutti gli ordini da cliente dell'articolo desiderato
*!*	*						: 								altrimenti estrae tutto
*!*	*						: se data cosegna dal al presente : estrae gli ordini da cliente che devono essere consegnati
*!*	*						:									altrimenti estrae tutto
*!*	*						: se codice cliente presente : estrae tutti gli ordini da cliente del fornitore desiderato
*!*	*						: 							   altrimenti estrae tutto
*!*	*						: se date consegna presenti : estrae tutti gli ordini da cliente del periodo indicao
*!*	*						: 								altrimenti estrae tutto
*!*	*						: se ordini_da_consegnare = TUTTI estrae tutti gli ordini da cliente
*!*	*						:   					  = SI estrae solo gli ordini da cliente con (ord_qtaord - ord_qtaev) > 0
*!*	*						:   					  = NO estrae solo gli ordini da cliente con (ord_qtaord - ord_qtaev) =< 0
*!*	*						: se date ordini presenti : estrae tutti gli ordini da cliente del periodo indicato
*!*	*						: 							altrimenti estrae tutto
*!*	*
*!*	*  OUTPUT				:
*!*	*						:
*!*	*						: cursore PRODOTTI_ORDINATI_DA_CLIENTE , contenente tutte le righe degli ordini a frornitore per data consegna
*!*	*						: 
*!*	*
*!*	*
*!*	*
*!*	PARAMETERS _codicecliente,_cdarticolo,_dataconsegna_dal,_dataconsegna_al,_ordini_da_consegnare,_dataordine_dal,_dataordine_al

*!*	SMAGS=STR(SELECT())



*!*	IF !EMPTY(alltrim(_dataordine_dal))
*!*		x_dord = "ors_datord between '" + _dataordine_dal + "' and '" + _dataordine_al + "'"
*!*	ELSE
*!*		x_dord = "ors_datord = ors_datord"
*!*	ENDIF


*!*	x_qtev = "ord_qtaord = ord_qtaord"

*!*	IF _ordini_da_consegnare = "SI"
*!*		x_qtev = "(ord_qtaord - ord_qtaev) > 0"
*!*	ENDIF

*!*	IF _ordini_da_consegnare = "NO"
*!*		x_qtev = " NOT ((ord_qtaord - ord_qtaev) > 0)"
*!*	ENDIF

*!*	IF !EMPTY(alltrim(_dataconsegna_dal))
*!*		x_dsca  = "ord_datcon between '" + _dataconsegna_dal + "' and '" + _dataconsegna_al + "'"
*!*	ELSE
*!*		x_dsca = "ord_datcon = ord_datcon"
*!*	ENDIF

*!*	IF !EMPTY(alltrim(_codicecliente))
*!*		x_ccli = "ors_codcli = '" + ALLTRIM(_codicecliente) + "'"
*!*	ELSE
*!*		x_ccli = "ors_codcli = ors_codcli"
*!*	ENDIF 

*!*	IF !EMPTY(ALLTRIM(_cdarticolo))
*!*		x_cart = "ord_codart = '" + ALLTRIM(_cdarticolo) + "'"
*!*	ELSE
*!*		x_cart = "ord_codart = ord_codart" 
*!*	ENDIF

*!*	*!*	   x_cmat = "ord_codmat = '" + ALLTRIM(_X_CODMAT) + "'"
*!*	x_cmat = "ord_codmat = ord_codmat" 
*!*	x_ccol = "ord_codcol = ord_codcol"
*!*	x_spes = "ord_spesso = ord_spesso"
*!*	*!*	   x_alte = IIF(_X_ALTEZZ=0,"ord_altezz = ord_altezz","ord_altezz = " + ALLTRIM(STR(_X_ALTEZZ,5,0)))
*!*	x_alte = "ord_altezz = ord_altezz"
*!*	x_lung = "ord_lunghe = ord_lunghe"
*!*	       
*!*	x_cond = x_dord + " and " + x_dsca + " and " + x_ccli + " and " + x_cart + " and " + x_cmat ;
*!*	         + " and " + x_ccol + " and " + x_spes + " and " + x_alte + " and " + x_lung + " and " + x_qtev 
*!*	cSql   = "select * from u_ord_dd where " + x_cond + " order by ord_datcon"
*!*	IF !ExecCommand(cSql,"PRODOTTI_ORDINATI_DA_CLIENTE")
*!*	   return(.f.)
*!*	ENDIF   
*!*	SELECT PRODOTTI_ORDINATI_DA_CLIENTE
*!*	GO TOP


*!*	SELECT &SMAGS



*!*	RETURN

