
************************************************************************
PROCEDURE GESTIONE_RICPDVSEDE  			 && RICEZIONE DATI DA PDV A SEDE
************************************************************************

*=> DEFINIZIONE VARIABILI DI SVILUPPO

RELEASE V_DIR_COPY,V_SONOQUI,V_DISK
PUBLIC  V_DIR_COPY,V_SONOQUI,V_DISK

Csql = "Select * from u_azi_an where azi_codsoc = '01'"
IF !ExecCommand(Csql,"U_AZI_AN")
   return(.f.)
ENDIF
SELECT U_AZI_AN
GO TOP
IF EOF()
   V_DIR      = 'C:\DATI\MINERVA_PDV\TRASMISSIONE' 
ELSE
   V_DIR      = AZI_FTPROT                         
   PUB_CODBUN = AZI_CODBUN                        
   PUB_CFDEF  = AZI_CFDEF
ENDIF

V_SONOQUI = SYS(5)+SYS(2003)

RELEASE V_NUMCLI,V_NUMFOR,V_NUMART,V_NUMINC,V_NUMOPC,V_NUMCAN,V_NUMMOV,V_NUMFAT,V_NUMBOL, ;
        V_NUMORD,V_NUMORF,V_NUMBFO,V_NUMAUT,V_NUMPNC,V_NUMPNS,V_NUMFID,V_NUMRIC,V_NUMMEG, ;
        V_NUMDDT,V_NUMRES,V_NUMPRB,V_NUMASS,V_NUMMOC,V_NUMMOP,V_NUMALT,V_NUMFPR,V_NUMGGG, ;
        V_NUMGDA,V_NUMGAN,V_NUMGPR,V_NUMCAL,V_NUMCAM,V_NUMMSG
PUBLIC  V_NUMCLI,V_NUMFOR,V_NUMART,V_NUMINC,V_NUMOPC,V_NUMCAN,V_NUMMOV,V_NUMFAT,V_NUMBOL, ;
        V_NUMORD,V_NUMORF,V_NUMBFO,V_NUMAUT,V_NUMPNC,V_NUMPNS,V_NUMFID,V_NUMRIC,V_NUMMEG, ;
        V_NUMDDT,V_NUMRES,V_NUMPRB,V_NUMASS,V_NUMMOC,V_NUMMOP,V_NUMALT,V_NUMFPR,V_NUMGGG, ;
        V_NUMGDA,V_NUMGAN,V_NUMGPR,V_NUMCAL,V_NUMCAM,V_NUMMSG
V_NUMCLI = 0
V_NUMFOR = 0
V_NUMART = 0
V_NUMINC = 0
V_NUMOPC = 0
V_NUMCAN = 0
V_NUMMOV = 0
V_NUMFAT = 0
V_NUMBOL = 0
V_NUMORD = 0
V_NUMORF = 0
V_NUMBFO = 0
V_NUMAUT = 0
V_NUMPNC = 0
V_NUMPNS = 0
V_NUMFID = 0
V_NUMRIC = 0
V_NUMMEG = 0
V_NUMDDT = 0
V_NUMRES = 0
V_NUMPRB = 0
V_NUMASS = 0
V_NUMMOC = 0
V_NUMMOP = 0
V_NUMALT = 0
V_NUMFPR = 0
V_NUMGGG = 0
V_NUMGDA = 0
V_NUMGAN = 0
V_NUMGPR = 0
V_NUMCAL = 0
V_NUMCAM = 0
V_NUMMSG = 0

Csql = "Select * from u_ftp_an where ftp_tipcom = 'S'"
IF !ExecCommand(Csql,"U_FTP_AN")
   return(.f.)
ENDIF
SELECT U_FTP_AN
GO TOP

DO WHILE !EOF()

   IF FTP_TIPO = 'R'
   ELSE
      SKIP +1
      LOOP
   ENDIF
	   
   V_DIR_COPY  = ALLTRIM(FTP_PATHAL)    && PERCORSO DA DOVE PRELEVARE LE TABELLE FOX PER AGGIORNARE SQL
	   
   SET DEFAULT TO &V_DIR_COPY

   IF !FILE("SEMAFORO.SE2")
	  HD=FCREATE("SEMAFORO.PD2")
	  =FPUTS(HD,"PIPPO")
	  =FCLOSE(HD)
   ELSE
	  SELECT U_FTP_AN
	  skip+1
	  loop
   ENDIF
	   
   *=> AGGIORNAMENTO TABELLE SQL DA TABELLE FOX DEI PDV

   *===> Anagrafica clienti

   IF FILE("P_CLI_AN.DBF")
      =OPENDB("P_CLI_AN")
      SELECT P_CLI_AN
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         M.CLI_FLGTRA = .F.
         x_soci = "cli_codsoc = '" + M.CLI_CODSOC + "'"
         x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
         x_cond = x_soci + " and " + x_codi
         Csql = "Select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
         IF !ExecRW(Csql,"U_CLI_AN","R")
            return(.f.)
         ENDIF
         SELECT U_CLI_AN
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_CLI_AN
         REPLACE CLI_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_CLI_AN","W")
            return(.f.)
         ENDIF
         V_NUMCLI = V_NUMCLI + 1
         SELECT P_CLI_AN
         SKIP +1
      ENDDO
   ENDIF

   *===> Clienti Fidelizzati
   IF FILE("P_CLI_FI.DBF")
      =OPENDB("P_CLI_FI")
      SELECT P_CLI_FI
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         M.FID_FLGTRA = .F.
         x_soci = "fid_codsoc = '" + M.FID_CODSOC + "'"
         x_codi = "fid_codcli = '" + M.FID_CODCLI + "'"
         x_cond = x_soci + " and " + x_codi
         Csql = "Select * from u_cli_fi where " + x_cond + " order by fid_codsoc,fid_codcli"
         IF !ExecRW(Csql,"U_CLI_FI","R")
            return(.f.)
         ENDIF
         SELECT U_CLI_FI
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_CLI_FI
         REPLACE FID_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_CLI_FI","W")
            return(.f.)
         ENDIF
         V_NUMFID = V_NUMFID + 1
         SELECT P_CLI_FI
         SKIP +1
      ENDDO
   ENDIF

   *===> Anagrafica fornitori
   IF FILE("P_FOR_AN.DBF")
      =OPENDB("P_FOR_AN") 
      SELECT P_FOR_AN
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         M.FOR_FLGTRA = .F.
         x_soci = "for_codsoc = '" + M.FOR_CODSOC + "'"
         x_codi = "for_codcli = '" + M.FOR_CODCLI + "'"
         x_cond = x_soci + " and " + x_codi
         Csql = "Select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
         IF !ExecRW(Csql,"U_FOR_AN","R")
            return(.f.)
         ENDIF
         SELECT U_FOR_AN
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO X_FOR_AN
         REPLACE FOR_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_FOR_AN","W")
            return(.f.)
         ENDIF
         V_NUMFOR = V_NUMFOR + 1
         SELECT P_FOR_AN
         SKIP +1
      ENDDO
   ENDIF

   *===> Anagrafica articoli
   IF FILE("P_ART_PR.DBF")
      =OPENDB("P_ART_PR")
      SELECT P_ART_PR
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         M.ART_FLGTRA = .F.
         x_soci = "art_codsoc = '" + M.ART_CODSOC + "'"
         x_codi = "art_codpri = '" + M.ART_CODPRI + "'"
         x_cond = x_soci + " and " + x_codi
         Csql = "Select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
         IF !ExecRW(Csql,"U_ART_PR","R")
            return(.f.)
         ENDIF
         SELECT U_ART_PR
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_ART_PR
         REPLACE ART_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_ART_PR","W")
            return(.f.)
         ENDIF
         V_NUMART = V_NUMART + 1
         SELECT P_ART_PR
         SKIP +1
      ENDDO
   ENDIF

   *===> Incassi cancellati

   *===> Incassi

   IF FILE("P_PDV_CA.DBF")
      =OPENDB("P_PDV_CA")
      SELECT P_PDV_CA
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.CAS_FLGTRA = .F.
         M.CAS_FLGAGG = .F.
         x_cass = "cas_codcas = '" + ALLTRIM(M.CAS_CODCAS) + "'"
         x_maga = "cas_codmag = '" + ALLTRIM(M.CAS_CODMAG) + "'"
         x_prog = "cas_progre = '" + ALLTRIM(M.CAS_PROGRE) + "'"
         x_data = "cas_datope = '" + ALLTRIM(M.CAS_DATOPE) + "'"
         x_ora  = "cas_oraope = '" + ALLTRIM(M.CAS_ORAOPE) + "'"
         x_tipo = "cas_tipinc = '" + ALLTRIM(M.CAS_TIPINC) + "'"
         x_arti = "cas_codart = '" + ALLTRIM(M.CAS_CODART) + "'"
         x_sequ = "cas_sequen = " + ALLTRIM(STR(M.CAS_SEQUEN,5,0)) 
         x_cond = x_cass + " and " + x_maga + " and " + x_prog + " and " + x_data + " and " + x_ora + " and " + x_tipo + " and " + x_arti + " and " + x_sequ
         Csql   = "Select * from u_pdv_ca where " + x_cond 
         IF !ExecRW(Csql,"U_PDV_CA","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_CA
         GO TOP
         *x_cond = "id_unique = '" + M.ID_UNIQUE + "'"
         *Csql   = "Select * from u_pdv_ca where " + x_cond + " order by cas_codmag,cas_progre,cas_datope,cas_oraope"
         *IF !ExecRW(Csql,"U_PDV_CA","R")
         *   return(.f.)
         *ENDIF
         *SELECT U_PDV_CA
         *GO TOP
         IF EOF()
            APPEND BLANK
         *   REPLACE ID_UNIQUE WITH M.ID_UNIQUE
         ENDIF
         DO U_PDV_CA
         REPLACE CAS_FLGTRA WITH .F.
         REPLACE CAS_FLGAGG WITH .F.
         IF !ExecRW(Csql,"U_PDV_CA","W")
            return(.f.)
         ENDIF
         V_NUMINC = V_NUMINC + 1
         SELECT P_PDV_CA
         SKIP +1
      ENDDO
   ENDIF

   *===> Operazioni di cassa

   IF FILE("P_PDV_OP.DBF")
      =OPENDB("P_PDV_OP")
      SELECT P_PDV_OP
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.CAS_FLGTRA = .F.
         M.CAS_FLGAGG = .F.
         *x_cpdv = "cas_codpdv = '" + M.CAS_CODPDV + "'"
         *x_maga = "cas_codmag = '" + M.CAS_CODMAG + "'"
         *x_cass = "cas_codcas = '" + M.CAS_CODCAS + "'"
         *x_data = "cas_datope = '" + M.CAS_DATOPE + "'"
         *x_cond = x_cpdv + " and " + x_maga + " and " + x_cass + " and " + x_data
         x_cond = "id_unique = '" + M.ID_UNIQUE + "'"
         Csql = "Select * from u_pdv_op where " + x_cond + " order by cas_codpdv,cas_codmag,cas_codcas,cas_datope"
         IF !ExecRW(Csql,"U_PDV_OP","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_OP
         GO TOP
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH M.ID_UNIQUE
         ENDIF
         DO U_PDV_OP
         REPLACE CAS_FLGTRA WITH .F.
         REPLACE CAS_FLGAGG WITH .F.
         IF !ExecRW(Csql,"U_PDV_OP","W")
            return(.f.)
         ENDIF
         V_NUMOPC = V_NUMOPC + 1
         SELECT P_PDV_OP
         SKIP +1
      ENDDO
   ENDIF

   *===> Autorizzazioni alle spese 

   IF FILE("P_PDV_AU.DBF")
      =OPENDB("P_PDV_AU")
      SELECT P_PDV_AU
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         *x_soci = "pdv_codsoc = '" + M.PDV_CODSOC + "'"
         *x_data = "pdv_dataut = '" + M.PDV_DATAUT + "'"
         *x_uten = "pdv_codute = '" + M.PDV_CODUTE + "'"
         *x_cond = x_soci + " and " + x_data + " and " + x_uten
         x_cond = "id_unique = '" + M.ID_UNIQUE + "'"
         Csql = "Select * from u_pdv_au where " + x_cond
         IF !ExecRW(Csql,"U_PDV_AU","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_AU
         GO TOP
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH M.ID_UNIQUE
         ENDIF
         DO U_PDV_AU
         REPLACE PDV_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_PDV_AU","W")
            return(.f.)
         ENDIF
         V_NUMAUT = V_NUMAUT + 1
         SELECT P_PDV_AU
         SKIP +1
      ENDDO
   ENDIF

   *===> Record di chiusura di cassa definitiva

   IF FILE("P_PDV_CD.DBF")
      =OPENDB("P_PDV_CD")
      SELECT P_PDV_CD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.PDV_FLGTRA = .F.
         x_soci = "pdv_codsoc = '" + ALLTRIM(M.PDV_CODSOC) + "'"
         x_cpdv = "pdv_codpdv = '" + ALLTRIM(M.PDV_CODPDV) + "'"
         x_data = "pdv_datchi = '" + ALLTRIM(M.PDV_DATCHI) + "'"
         x_cond = x_soci + " and " + x_cpdv + " and " + x_data
         Csql   = "Select * from U_PDV_CD where " + x_cond 
         IF !ExecRW(Csql,"U_PDV_CD","R")
            return(.f.)
         ENDIF
         SELECT U_PDV_CD
         GO TOP
         IF EOF()
            APPEND BLANK
            *REPLACE ID_UNIQUE WITH M.ID_UNIQUE
         ENDIF
         DO U_PDV_CD
         REPLACE pdv_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_PDV_CD","W")
            return(.f.)
         ENDIF
         V_NUMMEG = V_NUMMEG + 1
         SELECT P_PDV_CD
         SKIP +1
      ENDDO
   ENDIF

   *===> Prima nota cassa business unit 

   IF FILE("P_PNC_BU.DBF")
      =OPENDB("P_PNC_BU") 
      SELECT P_PNC_BU
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         *x_soci = "pnc_codsoc = '" + M.PNC_CODSOC + "'"
         *x_cpdv = "pnc_codbun = '" + ALLTRIM(M.PNC_CODBUN) + "'"
         *x_uten = "pnc_codute = '" + ALLTRIM(M.PNC_CODUTE) + "'"
         *x_dope = "pnc_desope = '" + ALLTRIM(M.PNC_DESOPE) + "'"
         *x_data = "pnc_datreg = '" + M.PNC_DATREG + "'"
         *x_orao = "pnc_orareg = '" + M.PNC_ORAREG + "'"
         *x_cond = x_soci + " and " + x_cpdv + " and " + x_uten + " and " + x_dope + " and " + x_data + " and " + x_orao
         x_cond = "id_unique = '" + M.ID_UNIQUE + "'"
         Csql   = "Select * from u_pnc_bu where " + x_cond 
         IF !ExecRW(Csql,"U_PNC_BU","R")
            return(.f.)
         ENDIF
         SELECT U_PNC_BU
         GO TOP
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH M.ID_UNIQUE
         ENDIF
         DO U_PNC_BU
         REPLACE PNC_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_PNC_BU","W")
            return(.f.)
         ENDIF
         V_NUMPNC = V_NUMPNC + 1
         SELECT P_PNC_BU
         SKIP +1
      ENDDO
   ENDIF

   *===> Saldi per mese prima nota cassa business unit 

   IF FILE("P_PNC_SA.DBF")
     =OPENDB("P_PNC_SA")
      SELECT P_PNC_SA
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         *x_soci = "pnc_codsoc = '" + M.PNC_CODSOC + "'"
         *x_cpdv = "pnc_codbun = '" + M.PNC_CODBUN + "'"
         *x_mese = "pnc_mese = '" + M.PNC_MESE + "'"
         *x_anno = "pnc_anno = '" + M.PNC_ANNO + "'"
         *x_cond = x_soci + " and " + x_cpdv + " and " + x_mese + " and " + x_anno
         x_cond = "id_unique = '" + M.ID_UNIQUE + "'"
         Csql = "Select * from u_pnc_sa where " + x_cond 
         IF !ExecRW(Csql,"U_PNC_SA","R")
            return(.f.)
         ENDIF
         SELECT U_PNC_SA
         GO TOP
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH M.ID_UNIQUE
         ENDIF
         DO U_PNC_SA
         REPLACE PNC_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_PNC_SA","W")
            return(.f.)
         ENDIF
         V_NUMPNS = V_NUMPNS + 1
         SELECT P_PNC_SA
         SKIP +1
      ENDDO
   ENDIF

   *===> Richieste varie dei clienti

   IF FILE("P_RIC_VA.DBF")
      =OPENDB("P_RIC_VA")
      SELECT P_RIC_VA
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.RIC_FLGTRA = .F.
         x_cond = "id_unique = '" + M.ID_UNIQUE + "'"
         Csql = "Select * from U_RIC_VA where " + x_cond 
         IF !ExecRW(Csql,"U_RIC_VA","R")
            return(.f.)
         ENDIF
         SELECT U_RIC_VA
         GO TOP
         IF EOF()
            APPEND BLANK
            REPLACE ID_UNIQUE WITH M.ID_UNIQUE
         ENDIF
         DO U_RIC_VA
         REPLACE RIC_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_RIC_VA","W")
            return(.f.)
         ENDIF
         V_NUMRIC = V_NUMRIC + 1
         SELECT P_RIC_VA
         SKIP +1
      ENDDO
   ENDIF

   *===> Calendario annuale con gli orari di apertura/apertura del pdv

   IF FILE("P_CAL_CO.DBF")
      =OPENDB("P_CAL_CO")
      SELECT P_CAL_CO
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.COP_FLGTRA = .F.
         x_soci = "cop_codsoc = '" + M.COP_CODSOC + "'"
         x_cpdv = "cop_codpdv = '" + M.COP_CODPDV + "'"
         x_anno = "cop_anno = " + ALLTRIM(STR(M.COP_ANNO,4,0))
         x_mese = "cop_mese = " + ALLTRIM(STR(M.COP_MESE,2,0))
         x_sett = "cop_settim = " + ALLTRIM(STR(M.COP_SETTIM,2,0))
         x_cond = x_soci + " and " + x_cpdv + " and " + x_anno + " and " + x_mese + " and " + x_sett
         Csql   = "Select * from U_CAL_CO where " + x_cond 
         IF !ExecRW(Csql,"U_CAL_CO","R")
            return(.f.)
         ENDIF
         SELECT U_CAL_CO
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_CAL_CO
         REPLACE COP_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_CAL_CO","W")
            return(.f.)
         ENDIF
         V_NUMCAL = V_NUMCAL + 1
         SELECT P_CAL_CO
         SKIP +1
      ENDDO
   ENDIF

   *===> Assenze dei collaboratori dei pdv

   IF FILE("P_CAL_AS.DBF")
      =OPENDB("P_CAL_AS")
      SELECT P_CAL_AS
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.CAL_FLGTRA = .F.
         x_soci = "cal_codsoc = '" + M.CAL_CODSOC + "'"
         x_cpdv = "cal_codpdv = '" + M.CAL_CODPDV + "'"
         x_anno = "cal_anno = " + ALLTRIM(STR(M.CAL_ANNO,4,0))
         x_sett = "cal_settim = " + ALLTRIM(STR(M.CAL_SETTIM,2,0))
         x_coll = "cal_codcol = '" + M.CAL_CODCOL + "'"
         x_data = "cal_data = '" + M.CAL_DATA + "'"
         x_cond = x_soci + " and " + x_cpdv + " and " + x_anno + " and " + x_sett + " and " + x_coll + " and " + x_data
         Csql   = "Select * from U_CAL_AS where " + x_cond 
         IF !ExecRW(Csql,"U_CAL_AS","R")
            return(.f.)
         ENDIF
         SELECT U_CAL_AS
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_CAL_AS
         REPLACE CAL_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_CAL_AS","W")
            return(.f.)
         ENDIF
         V_NUMASS = V_NUMASS + 1
         SELECT P_CAL_AS
         SKIP +1
      ENDDO
   ENDIF

   *===> Monitoraggio casse

   IF FILE("P_MON_CA.DBF")
      =OPENDB("P_MON_CA")
      SELECT P_MON_CA
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.MON_FLGTRA = .F.
         x_soci = "MON_CODSOC = '" + M.MON_CODSOC + "'"
         x_cpdv = "MON_CODPDV = '" + M.MON_CODPDV + "'"
         x_cass = "MON_CODCAS = '" + M.MON_CODCAS + "'"
         x_dtin = "MON_DATINI = '" + M.MON_DATINI + "'"
         x_orin = "MON_ORAINI = '" + M.MON_ORAINI + "'"
         x_cond = x_soci + " and " + x_cpdv + " and " + x_cass + " and " + x_dtin + " and " + x_orin
         Csql   = "select * from u_mon_ca where " + x_cond
         IF !ExecRW(Csql,"U_MON_CA","R")
            return(.f.)
         ENDIF
         SELECT U_MON_CA
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_MON_CA
         REPLACE MON_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_MON_CA","W")
            return(.f.)
         ENDIF
         V_NUMMOC = V_NUMMOC + 1
         SELECT P_MON_CA
         SKIP +1
      ENDDO
   ENDIF

   *===> Monitoraggio visitatori del pdv

   IF FILE("P_MON_PE.DBF")
      =OPENDB("P_MON_PE")
      SELECT P_MON_PE
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.MON_FLGTRA = .F.
         x_soci = "MON_CODSOC = '" + M.MON_CODSOC + "'"
         x_cpdv = "MON_CODPDV = '" + M.MON_CODPDV + "'"
         x_data = "MON_DATGMA = '" + M.MON_DATGMA + "'"
         x_cond = x_soci + " and " + x_cpdv + " and " + x_data
         Csql   = "select * from u_mon_pe where " + x_cond
         IF !ExecRW(Csql,"U_MON_PE","R")
            return(.f.)
         ENDIF
         SELECT U_MON_PE
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_MON_PE
         REPLACE MON_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_MON_PE","W")
            return(.f.)
         ENDIF
         V_NUMMOP = V_NUMMOP + 1
         SELECT P_MON_PE
         SKIP +1
      ENDDO
   ENDIF

   *===> Fornitori preferenziali

   IF FILE("P_FOR_PR.DBF")
      =OPENDB("P_FOR_PR")
      SELECT P_FOR_PR
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.FPR_FLGTRA = .F.
         x_soci = "FPR_CODSOC = '" + M.FPR_CODSOC + "'"
         x_arti = "FPR_CODART = '" + M.FPR_CODART + "'"
         x_forn = "FPR_CODFOR = '" + M.FPR_CODFOR + "'"
         x_cond = x_soci + " and " + x_arti + " and " + x_forn
         Csql   = "select * from u_for_pr where " + x_cond
         IF !ExecRW(Csql,"U_FOR_PR","R")
            return(.f.)
         ENDIF
         SELECT U_FOR_PR
         GO TOP
         IF EOF()
            APPEND BLANK
            DO U_FOR_PR
            REPLACE FPR_FLGTRA WITH .F.
         ENDIF         
         IF !ExecRW(Csql,"U_FOR_PR","W")
            return(.f.)
         ENDIF
         V_NUMFPR = V_NUMFPR + 1
         SELECT P_FOR_PR
         SKIP +1
      ENDDO
   ENDIF

   *===> Altri dati
   
   IF FILE("P_ALT_DA.DBF")
      =OPENDB("P_ALT_DA")
      SELECT P_ALT_DA
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ALT_FLGTRA = .F.
         x_maga = "ALT_CODMAG = '" + M.ALT_CODMAG + "'"
         x_uniq = "ALT_UNIQUE = '" + M.ALT_UNIQUE + "'"
         x_cond = x_maga + " and " + x_uniq
         Csql   = "select * from u_alt_da where " + x_cond
         IF !ExecRW(Csql,"U_ALT_DA","R")
            return(.f.)
         ENDIF
         SELECT U_ALT_DA
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_ALT_DA
         REPLACE ALT_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_ALT_DA","W")
            return(.f.)
         ENDIF
         V_NUMALT = V_NUMALT + 1
         SELECT P_ALT_DA
         SKIP +1
      ENDDO
   ENDIF

   *===> Movimenti di magazzino cancellati

   IF FILE("P_MAG_CA.DBF")
      =OPENDB("P_MAG_CA")
      SELECT P_MAG_CA
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.MOV_FLGTRA = .F.
         x_maga = "MOV_CODMAG = '" + M.MOV_CODMAG + "'"
         x_uniq = "MOV_UNIQUE = '" + M.MOV_UNIQUE + "'"
         x_cond = x_maga + " and " + x_uniq
         Csql   = "select * from u_mag_ca where " + x_cond
         IF !ExecRW(Csql,"U_MAG_CA","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_CA
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_MAG_MO
         REPLACE MOV_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_MAG_CA","W")
            return(.f.)
         ENDIF

         x_maga = "MOV_CODMAG = '" + M.MOV_CODMAG + "'"
         x_uniq = "MOV_UNIQUE = '" + M.MOV_UNIQUE + "'"
         x_cond = x_maga + " and " + x_uniq
         Csql   = "select * from u_mag_mo where " + x_cond
         IF !ExecRW(Csql,"U_MAG_MO","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_MO
         GO TOP
         IF EOF()
         ELSE
            DO RIPRISTINA_GIAC_VIAGGI WITH '+'
            SELECT U_MAG_MO
            DELETE
         ENDIF
         IF !ExecRW(Csql,"U_MAG_MO","W")
            return(.f.)
         ENDIF

         V_NUMCAM = V_NUMCAM + 1
         SELECT P_MAG_CA
         SKIP +1
      ENDDO
   ENDIF

   *===> Movimenti di magazzino (escluso quelli movimentati dall'incasso)

   IF FILE("P_MAG_MO.DBF")
      =OPENDB("P_MAG_MO")
      SELECT P_MAG_MO
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.MOV_FLGTRA = .F.
         x_maga = "MOV_CODMAG = '" + M.MOV_CODMAG + "'"
         x_uniq = "MOV_UNIQUE = '" + M.MOV_UNIQUE + "'"
         x_cond = x_maga + " and " + x_uniq
         Csql   = "select * from u_mag_mo where " + x_cond
         IF !ExecRW(Csql,"U_MAG_MO","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_MO
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_MAG_MO
         REPLACE MOV_FLGTRA WITH .F.
         DO RIPRISTINA_GIAC_VIAGGI WITH '-'
         IF !ExecRW(Csql,"U_MAG_MO","W")
            return(.f.)
         ENDIF
         V_NUMMOV = V_NUMMOV + 1
         SELECT P_MAG_MO
         SKIP +1
      ENDDO
   ENDIF

   *RELEASE XX_CODPDV,XX_VALRIF
   *PUBLIC  XX_CODPDV,XX_VALRIF
   *XX_VALRIF = 'EUR'
   *XX_CODSOC = '01'
   *IF FILE("P_MAG_MO.DBF")
   *   =OPENDB("P_MAG_MO")
   *   SELECT P_MAG_MO
   *   GO TOP
   *   DO WHILE .T.
   *      IF EOF()
   *         EXIT
   *      ENDIF
   *      SCATTER MEMVAR MEMO
   *      x_soci = "mov_codsoc = '" + ALLTRIM(M.MOV_CODSOC) + "'"
   *      x_maga = "mov_codmag = '" + ALLTRIM(M.MOV_CODMAG) + "'"
   *      x_arti = "mov_codart = '" + ALLTRIM(M.MOV_CODART) + "'"
   *      x_ctop = "mov_top = '" + ALLTRIM(M.MOV_TOP) + "'"
   *      x_ndoc = "mov_numdoc = '" + ALLTRIM(M.MOV_NUMDOC) + "'"
   *      x_ddoc = "mov_dtdocu = '" + ALLTRIM(M.MOV_DTDOCU) + "'"
   *      x_dreg = "mov_dtregi = '" + ALLTRIM(M.MOV_DTREGI) + "'"
   *      x_odoc = "mov_oramov = '" + ALLTRIM(M.MOV_ORAMOV) + "'"
   *      x_cond = x_soci + " and " + x_maga + " and " + x_arti + " and " + x_ctop + " and " + x_ndoc  + " and " + x_ddoc + " and " + x_dreg + " and " + x_odoc
   *      Csql   = "Select * from u_mag_mo where " + x_cond 
   *      IF !ExecRW(Csql,"U_MAG_MO","R")
   *         return(.f.)
   *      ENDIF
   *      SELECT U_MAG_MO
   *      GO TOP
   *      IF EOF()
   *         IF !ExecRW(Csql,"U_MAG_MO","W")
   *            return(.f.)
   *         ENDIF
   *      ELSE
   *         REPLACE MOV_FLGTRA WITH .F.
   *         IF !ExecRW(Csql,"U_MAG_MO","W")
   *            return(.f.)
   *         ENDIF
   *         V_NUMMOV = V_NUMMOV + 1
   *         SELECT p_mag_mo
   *         SKIP +1
   *         LOOP
   *      ENDIF
   *      H_DADOVE     = ' '
   *      H_GENMOV     = 'SI' 
   *      H_TIPO       = 'GIA'
   *      H_IMPE       = ""
   *      H_MAGSCA     = M.MOV_CODMAG
   *      H_MAGCAR     = ""
   *      H_CODART     = M.MOV_CODART
   *      H_TOPSCA     = M.MOV_TOP
   *      H_TOPCAR     = ""
   *      H_QUANTI     = M.MOV_QTAMOV
   *      H_NUMDOC     = M.MOV_NUMDOC
   *      H_DATDOC     = M.MOV_DTDOCU
   *      H_DATREG     = M.MOV_DTREGI
   *      H_ORAMOV     = M.MOV_ORAMOV
   *      H_CLIFOR     = M.MOV_CODFOR
   *      H_PRZACQ     = M.MOV_PREACQ
   *      H_PRZVEN     = M.MOV_PREVEN
   *      H_CODIVA     = M.MOV_IVAVEN
   *      H_SCONTO     = M.MOV_SCONTO
   *      H_VALUTA     = M.MOV_VALUTA
   *      H_NOTE       = M.MOV_NOTE
   *      H_CSC        = ""
   *      H_SAC        = ""
   *      H_GGG        = "SI"
   *      H_FORNIT     = M.MOV_FORNIT
   *      H_FLGTRA     = .F.
   *      H_CODPDV     = M.MOV_CODPDV
   *      =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA,H_CODPDV)
   *      V_NUMMOV = V_NUMMOV + 1
   *      SELECT P_MAG_MO
   *      SKIP +1
   *   ENDDO
   *ENDIF

   *===> Giacenze per carico (data/mag/art/forn/tipo/prz)

   IF FILE("P_MAG_GG.DBF")
      =OPENDB("P_MAG_GG")
      SELECT P_MAG_GG
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.MAG_FLGTRA = .F.
         x_maga = "MAG_CODMAG = '" + M.MAG_CODMAG + "'"
         x_uniq = "MAG_UNIQUE = '" + M.MAG_UNIQUE + "'"
         x_cond = x_maga + " and " + x_uniq
         Csql   = "select * from u_mag_gg where " + x_cond
         IF !ExecRW(Csql,"U_MAG_GG","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_GG
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_MAG_GG
         REPLACE MAG_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_MAG_GG","W")
            return(.f.)
         ENDIF
         V_NUMGGG = V_NUMGGG + 1
         SELECT P_MAG_GG
         SKIP +1
      ENDDO
   ENDIF

   *===> Giacenze per data (data/mag/art/forn/tipo/prz)

   IF FILE("P_MAG_DA.DBF")
      =OPENDB("P_MAG_DA")
      SELECT P_MAG_DA
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.MAG_FLGTRA = .F.
         x_maga = "MAG_CODMAG = '" + M.MAG_CODMAG + "'"
         x_uniq = "MAG_UNIQUE = '" + M.MAG_UNIQUE + "'"
         x_cond = x_maga + " and " + x_uniq
         Csql   = "select * from u_mag_da where " + x_cond
         IF !ExecRW(Csql,"U_MAG_DA","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_DA
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_MAG_DA
         REPLACE MAG_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_MAG_DA","W")
            return(.f.)
         ENDIF
         V_NUMGDA = V_NUMGDA + 1
         SELECT P_MAG_DA
         SKIP +1
      ENDDO
   ENDIF

   *===> Giacenze al momento (mag/art)

   IF FILE("P_MAG_AN.DBF")
      =OPENDB("P_MAG_AN")
      SELECT P_MAG_AN
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.MAG_FLGTRA = .F.
         x_soci = "MAG_CODSOC = '" + M.MAG_CODSOC + "'"
         x_maga = "MAG_CODMAG = '" + M.MAG_CODMAG + "'"
         x_arti = "MAG_CODART = '" + M.MAG_CODART + "'"
         x_cond = x_soci + " and " + x_maga + " and " + x_arti
         Csql   = "select * from u_mag_an where " + x_cond
         IF !ExecRW(Csql,"U_MAG_AN","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_AN
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_MAG_AN
         REPLACE MAG_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_MAG_AN","W")
            return(.f.)
         ENDIF
         V_NUMGAN = V_NUMGAN + 1
         SELECT P_MAG_AN
         SKIP +1
      ENDDO
   ENDIF

   *===> Giacenze progressive (anno/mag/art)

   IF FILE("P_MAG_PR.DBF")
      =OPENDB("P_MAG_PR")
      SELECT P_MAG_PR
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.MAG_FLGTRA = .F.
         x_maga = "MAG_CODMAG = '" + M.MAG_CODMAG + "'"
         x_uniq = "MAG_UNIQUE = '" + M.MAG_UNIQUE + "'"
         x_cond = x_maga + " and " + x_uniq
         Csql   = "select * from u_mag_pr where " + x_cond
         IF !ExecRW(Csql,"U_MAG_PR","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_PR
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_MAG_PR
         REPLACE MAG_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_MAG_PR","W")
            return(.f.)
         ENDIF
         V_NUMGPR = V_NUMGPR + 1
         SELECT P_MAG_PR
         SKIP +1
      ENDDO
   ENDIF

   *===> Carichi con documenti del fornitore

   IF FILE("P_ORF_DT.DBF")
      =OPENDB("P_ORF_DT")
      SELECT P_ORF_DT
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ORF_FLGTRA = .T.
         x_agga = "orf_agganc = '" + M.ORF_AGGANC + "'"
         x_csys = "orf_syssys = '" + M.ORF_SYSSYS + "'"
         x_npro = "orf_numpro = '" + M.ORF_NUMPRO + "'"
         x_nord = "orf_numord = '" + M.ORF_NUMORD + "'"
         x_nddt = "orf_numddt = '" + M.ORF_NUMDDT + "'"
         x_cond = x_agga + " and " + x_csys + " and " + x_npro + " and " + x_nord + " and " + x_nddt
         Csql   = "Select * from U_ORF_DT where " + x_cond 
         IF !ExecRW(Csql,"U_ORF_DT","R")
            return(.f.)
         ENDIF
         SELECT U_ORF_DT
         GO TOP
         IF EOF()
         ELSE
            DELETE
         ENDIF
         IF !ExecRW(Csql,"U_ORF_DT","W")
            return(.f.)
         ENDIF
         SELECT P_ORF_DT
         REPLACE ORF_FLGTRA WITH .F.
         V_NUMDDT = V_NUMDDT + 1
         SKIP +1
      ENDDO
      IF !ExecRW('','u_orf_dt','I','','P_ORF_DT')
         return(.f.)
      ENDIF
   ENDIF

   *===> Bolle di trasferimento da pdv a pdv / da pdv a sede / da sede a pdv

   IF FILE("P_ORF_CO.DBF")
      =OPENDB("P_ORF_CO")
      SELECT P_ORF_CO
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         x_csys = "orf_codsys = '" + ALLTRIM(M.ORF_CODSYS) + "'"
         x_arti = "orf_codart = '" + ALLTRIM(M.ORF_CODART) + "'"
         x_maga = "orf_codmag = '" + ALLTRIM(M.ORF_CODMAG) + "'"
         x_cond = x_csys + " and " + x_arti + " and " + x_maga
         Csql   = "select * from u_orf_co where " + x_cond
         IF !ExecRW(Csql,"U_ORF_CO","R")
            return(.f.)
         ENDIF
         SELECT U_ORF_CO
         GO TOP
         IF EOF()
            APPEND BLANK
            XXX_QTAEVA = 0
         ELSE
            XXX_QTAEVA = ORF_QTASPE
         ENDIF
         M.ORF_FLGTRA = .F.
         DO U_ORF_CO
         REPLACE ORF_QTASPE WITH XXX_QTAEVA
         IF ORF_QTADDT > ORF_QTASPE
            REPLACE ORF_CHIUSO WITH .F.
         ELSE
            REPLACE ORF_CHIUSO WITH .T.
         ENDIF
         *IF ORF_TIPAGG = 'A'
         *   DELETE
         *ENDIF
         IF !ExecRW(Csql,"U_ORF_CO","W")
            return(.f.)
         ENDIF
         V_NUMBOL = V_NUMBOL + 1
         SELECT P_ORF_CO
         SKIP +1
      ENDDO
   ENDIF

   *===> Bolle di reso da pdv a sede CANCELLATE

   IF FILE("P_CAN_RE.DBF")
      =OPENDB("P_CAN_RE")
      IF FILE("P_BOL_RE.DBF")
         =OPENDB("P_BOL_RE")
         SELECT P_BOL_RE
         INDEX ON ORF_CODFOR+ORF_CODSYS+ORF_AGGANC+ORF_NUMDDT+ORF_NUMIDE+ORF_ANNSCA TAG I_ORF_CO ADDITIVE
         SET ORDER TO I_BOL_RE
      ENDIF
      SELECT P_CAN_RE
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         x_uniq = "orf_unique = '" + ALLTRIM(M.ORF_UNIQUE) + "'"
         x_lega = "orf_agganc = '" + ALLTRIM(M.ORF_AGGANC) + "'"
         x_cond = x_uniq + " and " + x_lega
         Csql   = "select * from u_bol_re where " + x_cond
         IF !ExecRW(Csql,"U_BOL_RE","R")
            return(.f.)
         ENDIF
         SELECT U_BOL_RE
         GO TOP
         DO WHILE .T.
            IF EOF()
               EXIT
            ENDIF
            IF ORF_QTASPE > 0
               SCATTER MEMVAR MEMO
               IF FILE("P_BOL_RE.DBF")
                  SELECT P_BOL_RE
                  SET ORDER TO I_BOL_RE
                  SEEK M.ORF_CODFOR+M.ORF_CODSYS+M.ORF_AGGANC+M.ORF_NUMDDT+M.ORF_NUMIDE+M.ORF_ANNSCA
                  DO WHILE .T.
                     IF EOF()
                        EXIT
                     ENDIF
                     REPLACE ORF_QTASPE WITH M.ORF_QTASPE
                     IF ORF_QTADDT > ORF_QTASPE
                        REPLACE ORF_CHIUSO WITH .F.
                     ELSE
                        REPLACE ORF_CHIUSO WITH .T.
                     ENDIF
                     SKIP +1
                  ENDDO
               ENDIF
            ENDIF      
            SELECT U_BOL_RE
            DELETE
            SKIP +1
         ENDDO
         IF !ExecRW(Csql,"U_BOL_RE","W")
            return(.f.)
         ENDIF
         x_uniq = "orf_unique = '" + ALLTRIM(M.ORF_UNIQUE) + "'"
         x_lega = "orf_agganc = '" + ALLTRIM(M.ORF_AGGANC) + "'"
         x_cond = x_uniq + " and " + x_lega
         Csql   = "select * from u_can_re where " + x_cond
         IF !ExecRW(Csql,"U_CAN_RE","R")
            return(.f.)
         ENDIF
         SELECT U_CAN_RE
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         M.ORF_FLGTRA = .T.
         DO U_BOL_RE
         IF !ExecRW(Csql,"U_CAN_RE","W")
            return(.f.)
         ENDIF
         SELECT P_CAN_RE
         SKIP +1
      ENDDO
   ENDIF

   *===> Bolle di reso da pdv a sede

   IF FILE("P_BOL_RE.DBF")
      =OPENDB("P_BOL_RE")
      SELECT P_BOL_RE
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         x_uniq = "orf_unique = '" + ALLTRIM(M.ORF_UNIQUE) + "'"
         x_lega = "orf_agganc = '" + ALLTRIM(M.ORF_AGGANC) + "'"
         x_cond = x_uniq + " and " + x_lega
         Csql   = "select * from u_bol_re where " + x_cond
         IF !ExecRW(Csql,"U_BOL_RE","R")
            return(.f.)
         ENDIF
         SELECT U_BOL_RE
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         M.ORF_FLGTRA = .T.
         DO U_BOL_RE
         IF !ExecRW(Csql,"U_BOL_RE","W")
            return(.f.)
         ENDIF
         SELECT P_BOL_RE
         V_NUMRES = V_NUMRES + 1
         SKIP +1
      ENDDO
   ENDIF

   *===> Fatture emesse a clienti

   IF FILE("P_FAT_TT.DBF")
      =OPENDB("P_FAT_TT")
      SELECT P_FAT_TT
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         x_cond = "taggancio = '" + M.TAGGANCIO + "'"
         Csql   = "Select * from u_fat_tt where " + x_cond + " order by taggancio"
         IF !ExecRW(Csql,"U_FAT_TT","R")
            return(.f.)
         ENDIF
         SELECT U_FAT_TT
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_FAT_TT
         REPLACE ORD_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_FAT_TT","W")
            return(.f.)
         ENDIF
         V_NUMFAT = V_NUMFAT + 1
         SELECT P_FAT_TT
         SKIP +1
      ENDDO
   ENDIF

   IF FILE("P_FAT_DD.DBF")
      =OPENDB("P_FAT_DD")
      SELECT P_FAT_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         x_cond = "daggancio = '" + daggancio + "'"
         Csql   = "delete from u_fat_dd where " + x_cond 
         IF !ExecCommand(Csql,"U_FAT_DD")
            return(.f.)
         ENDIF
         SELECT P_FAT_DD
         SKIP +1
      ENDDO   
      SELECT P_FAT_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         Csql   = "Select * from u_fat_dd where 1=0"
         IF !ExecRW(Csql,"U_FAT_DD","R")
            return(.f.)
         ENDIF
         SELECT U_FAT_DD
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_FAT_DD
         IF !ExecRW(Csql,"U_FAT_DD","W")
            return(.f.)
         ENDIF
         SELECT P_FAT_DD
         SKIP +1
      ENDDO
   ENDIF

   *===> Ordini clienti

   IF FILE("P_ORD_TT.DBF")
      =OPENDB("P_ORD_TT")
      SELECT P_ORD_TT
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         x_cond = "taggancio = '" + M.TAGGANCIO + "'"
         Csql   = "Select * from u_ord_tt where " + x_cond + " order by taggancio"
         IF !ExecRW(Csql,"U_ORD_TT","R")
            return(.f.)
         ENDIF
         SELECT U_ORD_TT
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_ORD_TT
         REPLACE ORD_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_ORD_TT","W")
            return(.f.)
         ENDIF
         V_NUMORD = V_NUMORD + 1
         SELECT P_ORD_TT
         SKIP +1
      ENDDO
   ENDIF

   IF FILE("P_ORD_DD.DBF")
      =OPENDB("P_ORD_DD")
      SELECT P_ORD_DD
      GO TOP   
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         x_cond = "daggancio = '" + daggancio + "'"
         Csql   = "delete from u_ord_dd where " + x_cond 
         IF !ExecCommand(Csql,"U_ORD_DD")
            return(.f.)
         ENDIF
         SELECT P_ORD_DD
         SKIP +1
      ENDDO   
      SELECT P_ORD_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         Csql   = "Select * from u_ord_dd where 1=0"
         IF !ExecRW(Csql,"U_ORD_DD","R")
            return(.f.)
         ENDIF
         SELECT U_ORD_DD
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_ORD_DD
         IF !ExecRW(Csql,"U_ORD_DD","W")
            return(.f.)
         ENDIF
         SELECT P_ORD_DD
         SKIP +1
      ENDDO
   ENDIF

   *===> Ordini fornitori / Proposte d'ordine

   IF FILE("P_ORF_TT.DBF")
      =OPENDB("P_ORF_TT") 
      SELECT P_ORF_TT
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         x_cond = "taggancio = '" + M.TAGGANCIO + "'"
         Csql   = "Select * from u_orf_tt where " + x_cond + " order by taggancio"
         IF !ExecRW(Csql,"U_ORF_TT","R")
            return(.f.)
         ENDIF
         SELECT U_ORF_TT
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_ORF_TT
         REPLACE ORD_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_ORF_TT","W")
            return(.f.)
         ENDIF
         V_NUMORF = V_NUMORF + 1
         SELECT P_ORF_TT
         SKIP +1
      ENDDO
   ENDIF

   IF FILE("P_ORF_DD.DBF")
      =OPENDB("P_ORF_DD")
      SELECT P_ORF_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         x_cond = "daggancio = '" + daggancio + "'"
         Csql   = "delete from u_orf_dd where " + x_cond 
         IF !ExecCommand(Csql,"U_ORF_DD")
            return(.f.)
         ENDIF
         SELECT P_ORF_DD
         SKIP +1
      ENDDO   
      SELECT P_ORF_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         Csql   = "Select * from u_orf_dd where 1=0"
         IF !ExecRW(Csql,"U_ORF_DD","R")
            return(.f.)
         ENDIF
         SELECT U_ORF_DD
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_ORF_DD
         IF !ExecRW(Csql,"U_ORF_DD","W")
            return(.f.)
         ENDIF
         SELECT P_ORF_DD
         SKIP +1
      ENDDO
   ENDIF

   *===> Bolle di carico dei fornitori

   IF FILE("P_BFO_TT.DBF")
      =OPENDB("P_BFO_TT")
      SELECT P_BFO_TT
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         x_cond = "taggancio = '" + M.TAGGANCIO + "'"
         Csql   = "Select * from u_bfo_tt where " + x_cond + " order by taggancio"
         IF !ExecRW(Csql,"U_BFO_TT","R")
            return(.f.)
         ENDIF
         SELECT U_BFO_TT
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_BFO_TT
         REPLACE ORD_FLGTRA WITH .F.
         IF !ExecRW(Csql,"U_BFO_TT","W")
            return(.f.)
         ENDIF
         V_NUMORF = V_NUMORF + 1
         SELECT P_BFO_TT
         SKIP +1
      ENDDO
   ENDIF

   IF FILE("P_BFO_DD.DBF")
      =OPENDB("P_BFO_DD")
      SELECT P_BFO_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         x_cond = "daggancio = '" + daggancio + "'"
         Csql   = "delete from u_bfo_dd where " + x_cond 
         IF !ExecCommand(Csql,"U_BFO_DD")
            return(.f.)
         ENDIF
         SELECT P_BFO_DD
         SKIP +1
      ENDDO   
      SELECT P_BFO_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         Csql   = "Select * from u_bfo_dd where 1=0" 
         IF !ExecRW(Csql,"U_BFO_DD","R")
            return(.f.)
         ENDIF
         SELECT U_BFO_DD
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_BFO_DD
         IF !ExecRW(CSql,"U_BFO_DD","W")
            return(.f.)
         ENDIF
         SELECT P_BFO_DD
         SKIP +1
      ENDDO
   ENDIF


   *===> Pre-bolle di reso dei pdv
   
   IF FILE("P_PRB_TT.DBF")
      =OPENDB("P_PRB_TT")
      SELECT P_PRB_TT
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         x_cond = "taggancio = '" + M.TAGGANCIO + "'"
         Csql   = "Select * from u_prb_tt where " + x_cond + " order by taggancio"
         IF !ExecRW(Csql,"U_PRB_TT","R")
            return(.f.)
         ENDIF
         SELECT U_PRB_TT
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_PRB_TT
         REPLACE ORD_FLGTRA WITH .F.
         REPLACE ORD_FLGCON WITH .F.
         REPLACE ORD_CONSED WITH .F.
         IF !ExecRW(Csql,"U_PRB_TT","W")
            return(.f.)
         ENDIF
         V_NUMPRB = V_NUMPRB + 1
         SELECT P_PRB_TT
         SKIP +1
      ENDDO
   ENDIF

   IF FILE("P_PRB_DD.DBF")
      =OPENDB("P_PRB_DD")
      SELECT P_PRB_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         x_cond = "daggancio = '" + daggancio + "'"
         Csql   = "delete from u_prb_dd where " + x_cond 
         IF !ExecCommand(Csql,"U_PRB_DD")
            return(.f.)
         ENDIF
         SELECT P_PRB_DD
         SKIP +1
      ENDDO   
      SELECT P_PRB_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         Csql   = "Select * from u_prb_dd where 1=0" 
         IF !ExecRW(Csql,"U_PRB_DD","R")
            return(.f.)
         ENDIF
         SELECT U_PRB_DD
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_PRB_DD
         IF !ExecRW(CSql,"U_PRB_DD","W")
            return(.f.)
         ENDIF
         SELECT P_PRB_DD
         SKIP +1
      ENDDO
   ENDIF

   *===> Messaggi automatici 

   IF FILE("P_MSG_AU.DBF")
      =OPENDB("P_MSG_AU")
      SELECT P_MSG_AU
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         x_cmit = "msg_codmit = '" + M.MSG_CODMIT + "'"
         x_cdes = "msg_coddes = '" + M.MSG_CODDES + "'"
         x_ddes = "msg_desdes = '" + M.MSG_DESDES + "'"
         x_cope = "msg_codope = '" + M.MSG_CODOPE + "'"
         x_dinv = "msg_datinv = '" + M.MSG_DATINV + "'"
         x_oinv = "msg_orainv = '" + M.MSG_ORAINV + "'"
         x_cond = x_cmit + " and " + x_cdes + " and " + x_ddes + " and " + x_cope + " and " + x_dinv + " and " + x_oinv
         Csql   = "Select * from u_msg_au where " + x_cond
         IF !ExecRW(Csql,"U_MSG_AU","R")
            return(.f.)
         ENDIF
         SELECT U_MSG_AU
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         M.MSG_DATRIC = RIBALTA2(DTOC(DATE()))
         M.MSG_ORARIC = TIME()
         M.MSG_FLGRIC = .T.
         M.MSG_FLGTRA = .T.
         DO U_MSG_AU
         IF !ExecRW(Csql,"U_MSG_AU","W")
            return(.f.)
         ENDIF
         V_NUMMSG = V_NUMMSG + 1
         SELECT P_MSG_AU
         SKIP +1
      ENDDO
   ENDIF

   *===> Aggiornamento tabella delle trasmissioni 

   IF FILE("P_CON_TR.DBF")
      =OPENDB("P_CON_TR")
      SELECT P_CON_TR
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         M.ID_UNIQUE  = ""
         x_data = "con_data = '" + M.CON_DATA + "'"
         x_prog = "con_progre = " + ALLTRIM(STR(M.CON_PROGRE,6,0))
         x_cond = x_data + " and " + x_prog
         Csql   = "Select * from u_con_tr where " + x_cond
         IF !ExecRW(Csql,"U_CON_TR","R")
            return(.f.)
         ENDIF
         SELECT U_CON_TR
         GO TOP
         IF EOF()
            APPEND BLANK
         ENDIF
         DO U_CON_TR
         REPLACE CON_ORARIC WITH TIME()
         REPLACE CON_DATRIC WITH RIBALTA2(DTOC(DATE()))
         REPLACE CON_CLIRIC WITH V_NUMCLI
         REPLACE CON_FORRIC WITH V_NUMFOR
         REPLACE CON_ARTRIC WITH V_NUMART
         REPLACE CON_INCRIC WITH V_NUMINC
         REPLACE CON_CANRIC WITH V_NUMCAN
         REPLACE CON_OPCRIC WITH V_NUMOPC
         REPLACE CON_MOVRIC WITH V_NUMMOV
         REPLACE CON_FATRIC WITH V_NUMFAT
         REPLACE CON_BOLRIC WITH V_NUMBOL
         REPLACE CON_ORDRIC WITH V_NUMORD
         REPLACE CON_ORFRIC WITH V_NUMORF
         REPLACE CON_BFORIC WITH V_NUMBFO
         REPLACE CON_AUTRIC WITH V_NUMAUT
         REPLACE CON_PNCRIC WITH V_NUMPNC
         REPLACE CON_PNSRIC WITH V_NUMPNS
         REPLACE CON_FIDRIC WITH V_NUMFID
         REPLACE CON_RICRIC WITH V_NUMRIC
         REPLACE CON_MEGRIC WITH V_NUMMEG
         REPLACE CON_DDTRIC WITH V_NUMDDT
         REPLACE CON_RESRIC WITH V_NUMRES
         REPLACE CON_ASSRIC WITH V_NUMASS
         REPLACE CON_MOCRIC WITH V_NUMMOC
         REPLACE CON_MOPRIC WITH V_NUMMOP
         REPLACE CON_ALTRIC WITH V_NUMALT
         REPLACE CON_FPRRIC WITH V_NUMFPR
         REPLACE CON_GGGRIC WITH V_NUMGGG
         REPLACE CON_GDARIC WITH V_NUMGDA
         REPLACE CON_GANRIC WITH V_NUMGAN
         REPLACE CON_GPRRIC WITH V_NUMGPR
         REPLACE CON_CALRIC WITH V_NUMCAL
         REPLACE CON_CAMRIC WITH V_NUMCAM
         IF !ExecRW(Csql,"U_CON_TR","W")
            return(.f.)
         ENDIF
         SELECT P_CON_TR
         SKIP +1
      ENDDO
   ENDIF

   *===> Cancellazione dei file appena acquisiti
	_max = 41
	DIMENSION tab_tbl[_max]
	tab_tbl[01] = "P_CLI_AN"                                                                           
	tab_tbl[02] = "P_CLI_FI"                                                                           
	tab_tbl[03] = "P_FOR_AN"                                                                           
	tab_tbl[04] = "P_ART_PR"                                                                           
	tab_tbl[05] = "P_MAG_MO"                                                                           
	tab_tbl[06] = "P_PDV_CA"                                                                           
	tab_tbl[07] = "P_PDV_OP"                                                                           
	tab_tbl[08] = "P_PDV_AU"                                                                           
	tab_tbl[09] = "P_PNC_BU"                                                                           
	tab_tbl[10] = "P_PNC_SA"                                                                           
	tab_tbl[11] = "P_FAT_TT"                                                                           
	tab_tbl[12] = "P_FAT_DD"                                                                           
	tab_tbl[13] = "P_BOL_TT"                                                                           
	tab_tbl[14] = "P_BOL_DD"                                                                           
	tab_tbl[15] = "P_ORD_TT"                                                                           
	tab_tbl[16] = "P_ORD_DD"                                                                           
	tab_tbl[17] = "P_ORF_TT"                                                                           
	tab_tbl[18] = "P_ORF_DD"                                                                           
	tab_tbl[19] = "P_BFO_TT"                                                                           
	tab_tbl[20] = "P_BFO_DD"                                                                           
	tab_tbl[21] = "P_CON_TR"                                                                           
	tab_tbl[22] = "P_RIC_VA"                                                                           
	tab_tbl[23] = "P_PDV_CD"                                                                           
	tab_tbl[24] = "P_ORF_DT"                                                                           
	tab_tbl[25] = "P_BOL_RE"                                                                           
	tab_tbl[26] = "P_PRB_TT"                                                                           
	tab_tbl[27] = "P_PRB_DD"                                                                           
	tab_tbl[28] = "P_ORF_CO"
	tab_tbl[29] = "P_CAL_CO"                                                                           
	tab_tbl[30] = "P_CAL_AS"                                                                           
	tab_tbl[31] = "P_MON_CA"                                                                           
	tab_tbl[32] = "P_MON_PE"                                                                           
	tab_tbl[33] = "P_FOR_PR"                                                                           
	tab_tbl[34] = "P_ALT_DA"
	tab_tbl[35] = "P_MAG_GG"                                                                           
	tab_tbl[36] = "P_MAG_DA"                                                                           
	tab_tbl[37] = "P_MAG_AN"                                                                           
	tab_tbl[38] = "P_MAG_PR"                                                                           
	tab_tbl[39] = "P_MAG_CA"                                                                           
	tab_tbl[40] = "P_MSG_AU"                                                                           
	tab_tbl[41] = "P_CAN_RE"                                                                           

    FOR _hh=1 TO _max
        IF FILE(tab_tbl[_hh]+".DBF")
           IF USED(tab_tbl[_hh])
	          SELECT &tab_tbl[_hh]
	          USE
	       ENDIF 
	       _cmd="ERASE "+tab_tbl[_hh]+".DBF"
           &_cmd
           IF FILE(tab_tbl[_hh]+".FPT")
  	          _cmd="ERASE "+tab_tbl[_hh]+".FPT"
              &_cmd
           ENDIF
           IF FILE(tab_tbl[_hh]+".CDX")
	          _cmd="ERASE "+tab_tbl[_hh]+".CDX"
              &_cmd
           ENDIF
        ENDIF
    NEXT 

   SET DEFAULT TO &V_DIR_COPY

   ERASE SEMAFORO.PD2
   SELECT U_FTP_AN
   SKIP +1
	   
ENDDO

SET DEFAULT TO &V_SONOQUI

RETURN


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

**************************************************************************
* Procedura - OPENDB                    Data: 10.11.95   Autore: Project
**************************************************************************
* Procedura da utilizzare per aprire un DB
*
PROCEDURE OPENDB
PARA V1
IF !USED(V1)
   USE &V1 IN 0 AGAIN
ENDIF
SELECT &V1
SET FILTER TO
SET ORDER TO
GO TOP
RETURN
*EOF Procedure: OPENDB



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


************************************************************************
PROCEDURE GESTIONE_RICSEDEPDV  			 && RICEZIONE DATI DA SEDE A PDV
************************************************************************

*=> DEFINIZIONE VARIABILI DI SVILUPPO

RELEASE V_DIR_COPY,V_SONOQUI,V_DISK
PUBLIC  V_DIR_COPY,V_SONOQUI,V_DISK

Csql = "Select * from u_azi_an where azi_codsoc = '01'"
IF !ExecCommand(Csql,"U_AZI_AN")
   return(.f.)
ENDIF
SELECT U_AZI_AN
GO TOP
IF EOF()
   V_DIR      = 'C:\DATI\MINERVA_PDV\RICEZIONE' 
ELSE
   V_DIR      = AZI_FTPRIC                         
   PUB_CODBUN = AZI_CODBUN                        
   PUB_CFDEF  = AZI_CFDEF
   PUB_CODM   = AZI_CODM
ENDIF

V_SONOQUI  = SYS(5)+SYS(2003)
V_DIR_COPY = ALLTRIM(V_DIR)							    && PERCORSO DOVE COPIARE LE TABELLE FOX IN ATTESA DELLA TRASMISSIONE

SET DEFAULT TO &V_DIR_COPY

IF FILE("SEMAFORO.APO")                      && SIGNIFICA CHE STA LAVORANDO APOLLO
   SET DEFAULT TO &V_SONOQUI
   RETURN 
ENDIF

IF FILE("SEMAFORO.PDV")                      && SIGNIFICA CHE STA GIA' LAVORANDO IL DEMONE
   SET DEFAULT TO &V_SONOQUI
   RETURN 
ENDIF

HD=FCREATE("SEMAFORO.PDV")
=FPUTS(HD,"PIPPO")
=FCLOSE(HD)

RELEASE V_NUMPOF,V_NUMCOF,V_NUMORF,V_NUMPRB,V_NUMAUT,V_NUMORC,V_NUMART,V_NUMCLI,V_NUMFOR, ;
        V_NUMLIS,V_NUMLIG,V_NUMMAC,V_NUMLIA,V_NUMMSG,V_NUMFPR
PUBLIC  V_NUMPOF,V_NUMCOF,V_NUMORF,V_NUMPRB,V_NUMAUT,V_NUMORC,V_NUMART,V_NUMCLI,V_NUMFOR, ;
        V_NUMLIS,V_NUMLIG,V_NUMMAC,V_NUMLIA,V_NUMMSG,V_NUMFPR
V_NUMPOF = 0
V_NUMCOF = 0
V_NUMORF = 0
V_NUMPRB = 0
V_NUMAUT = 0
V_NUMORC = 0
V_NUMART = 0
V_NUMCLI = 0
V_NUMFOR = 0
V_NUMLIS = 0
V_NUMLIG = 0
V_NUMMAC = 0
V_NUMLIA = 0
V_NUMMSG = 0
V_NUMFPR = 0

*=> AGGIORNAMENTO TABELLE SQL DA TABELLE FOX DEI PDV

*===> Proposte d'ordine provenienti dalla sede

IF FILE("P_ORF_PO.DBF")
   =OPENDB("P_ORF_PO")
   SELECT P_ORF_PO
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_cpdv = "orf_codpdv = '" + ALLTRIM(M.ORF_CODPDV) + "'"
      x_nume = "orf_numpro = '" + ALLTRIM(M.ORF_NUMPRO) + "'"
      x_uniq = "orf_unique = '" + ALLTRIM(M.ORF_UNIQUE) + "'"
      x_cond = x_cpdv + " and " + x_nume + " and " + x_uniq
      Csql   = "Select * from u_orf_po where " + x_cond 
      IF !ExecRW(Csql,"U_ORF_PO","R")
         return(.f.)
      ENDIF
      SELECT U_ORF_PO
      GO TOP
      IF EOF()
         APPEND BLANK
         XXX_QTAEVA = 0
      ELSE
         XXX_QTAEVA = ORF_QTAEV
      ENDIF
      M.ORF_FLGTRA = .T.
      DO U_ORF_PO
      REPLACE ORF_QTAEV WITH XXX_QTAEVA
      IF ORF_QTADOR > ORF_QTAEV
         REPLACE ORF_CHIUSO WITH .F.
      ELSE
         REPLACE ORF_CHIUSO WITH .T.
      ENDIF
      *IF ORF_TIPAGG = 'A'
      *   DELETE
      *ENDIF
      IF !ExecRW(Csql,"U_ORF_PO","W")
         return(.f.)
      ENDIF
      V_NUMPOF = V_NUMPOF + 1
      SELECT P_ORF_PO
      SKIP +1
   ENDDO
ENDIF

*===> Bolle di trasferimento da sede a pdv CANCELLATE

IF FILE("P_CAN_CO.DBF")
   =OPENDB("P_CAN_CO")

   IF FILE("P_ORF_CO.DBF")
      =OPENDB("P_ORF_CO")
      SELECT P_ORF_CO
      INDEX ON ORF_CODFOR+ORF_CODSYS+ORF_AGGANC+ORF_NUMDDT+ORF_NUMIDE+ORF_ANNSCA TAG I_ORF_CO ADDITIVE
      SET ORDER TO I_ORF_CO
   ENDIF

   SELECT P_CAN_CO
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_uniq = "orf_unique = '" + ALLTRIM(M.ORF_UNIQUE) + "'"
      x_lega = "orf_agganc = '" + ALLTRIM(M.ORF_AGGANC) + "'"
      x_cond = x_uniq + " and " + x_lega
      Csql   = "select * from u_orf_co where " + x_cond
      IF !ExecRW(Csql,"U_ORF_CO","R")
         return(.f.)
      ENDIF
      SELECT U_ORF_CO
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         IF ORF_QTASPE > 0
            SCATTER MEMVAR MEMO
            IF FILE("P_ORF_CO.DBF")
               SELECT P_ORF_CO
               SET ORDER TO I_ORF_CO
               SEEK M.ORF_CODFOR+M.ORF_CODSYS+M.ORF_AGGANC+M.ORF_NUMDDT+M.ORF_NUMIDE+M.ORF_ANNSCA
               DO WHILE .T.
                  IF EOF()
                     EXIT
                  ENDIF
                  REPLACE ORF_QTASPE WITH M.ORF_QTASPE
                  IF ORF_QTADDT > ORF_QTASPE
                     REPLACE ORF_CHIUSO WITH .F.
                  ELSE
                     REPLACE ORF_CHIUSO WITH .T.
                  ENDIF
                  SKIP +1
               ENDDO
            ENDIF
         ENDIF      
         SELECT U_ORF_CO
         DELETE
         SKIP +1
      ENDDO
      IF !ExecRW(Csql,"U_ORF_CO","W")
         return(.f.)
      ENDIF
      x_uniq = "orf_unique = '" + ALLTRIM(M.ORF_UNIQUE) + "'"
      x_lega = "orf_agganc = '" + ALLTRIM(M.ORF_AGGANC) + "'"
      x_cond = x_uniq + " and " + x_lega
      Csql   = "select * from u_can_co where " + x_cond
      IF !ExecRW(Csql,"U_CAN_CO","R")
         return(.f.)
      ENDIF
      SELECT U_CAN_CO
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      M.ORF_FLGTRA = .T.
      DO U_ORF_CO
      IF !ExecRW(Csql,"U_CAN_CO","W")
         return(.f.)
      ENDIF
      V_NUMORC = V_NUMORC + 1
      SELECT P_CAN_CO
      SKIP +1
   ENDDO
ENDIF

*===> Bolle di trasferimento da sede a pdv

IF FILE("P_ORF_CO.DBF")
   =OPENDB("P_ORF_CO")
   SELECT P_ORF_CO
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_uniq = "orf_unique = '" + ALLTRIM(M.ORF_UNIQUE) + "'"
      x_lega = "orf_agganc = '" + ALLTRIM(M.ORF_AGGANC) + "'"
      x_cond = x_uniq + " and " + x_lega
      Csql   = "select * from u_orf_co where " + x_cond
      IF !ExecRW(Csql,"U_ORF_CO","R")
         return(.f.)
      ENDIF
      SELECT U_ORF_CO
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      M.ORF_FLGTRA = .T.
      DO U_ORF_CO
      IF !ExecRW(Csql,"U_ORF_CO","W")
         return(.f.)
      ENDIF
      V_NUMCOF = V_NUMCOF + 1
      SELECT P_ORF_CO
      SKIP +1
   ENDDO
ENDIF

*===> Ordini fornitori / Proposte d'ordine

IF FILE("P_ORF_TT.DBF")
   =OPENDB("P_ORF_TT") 
   SELECT P_ORF_TT
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      M.ID_UNIQUE  = ""
      x_cond = "taggancio = '" + M.TAGGANCIO + "'"
      Csql   = "Select * from u_orf_tt where " + x_cond + " order by taggancio"
      IF !ExecRW(Csql,"U_ORF_TT","R")
         return(.f.)
      ENDIF
      SELECT U_ORF_TT
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      DO U_ORF_TT
      REPLACE ORD_FLGTRA WITH .T.
      IF !ExecRW(Csql,"U_ORF_TT","W")
         return(.f.)
      ENDIF
      V_NUMORF = V_NUMORF + 1
      SELECT P_ORF_TT
      SKIP +1
   ENDDO
ENDIF

IF FILE("P_ORF_DD.DBF")
   =OPENDB("P_ORF_DD")
   SELECT P_ORF_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      x_cond = "daggancio = '" + daggancio + "'"
      Csql   = "delete from u_orf_dd where " + x_cond 
      IF !ExecCommand(Csql,"U_ORF_DD")
         return(.f.)
      ENDIF
      SELECT P_ORF_DD
      SKIP +1
   ENDDO   
   SELECT P_ORF_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      M.ID_UNIQUE  = ""
      Csql   = "Select * from u_orf_dd where 1=0"
      IF !ExecRW(Csql,"U_ORF_DD","R")
         return(.f.)
      ENDIF
      SELECT U_ORF_DD
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      DO U_ORF_DD
      IF !ExecRW(Csql,"U_ORF_DD","W")
         return(.f.)
      ENDIF
      SELECT P_ORF_DD
      SKIP +1
   ENDDO
ENDIF

*===> Prebolla di reso dalla sede ai pdv

IF FILE("P_PRB_TT.DBF")
   =OPENDB("P_PRB_TT") 
   SELECT P_PRB_TT
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      M.ID_UNIQUE  = ""
      x_cond = "taggancio = '" + M.TAGGANCIO + "'"
      Csql   = "Select * from u_prb_tt where " + x_cond + " order by taggancio"
      IF !ExecRW(Csql,"U_PRB_TT","R")
         return(.f.)
      ENDIF
      SELECT U_PRB_TT
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      DO U_PRB_TT
      REPLACE ORD_FLGTRA WITH .T.
      IF !ExecRW(Csql,"U_PRB_TT","W")
         return(.f.)
      ENDIF
      V_NUMPRB = V_NUMPRB + 1
      SELECT P_PRB_TT
      SKIP +1
   ENDDO
ENDIF

IF FILE("P_PRB_DD.DBF")
   =OPENDB("P_PRB_DD")
   SELECT P_PRB_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      x_cond = "daggancio = '" + daggancio + "'"
      Csql   = "delete from u_prb_dd where " + x_cond 
      IF !ExecCommand(Csql,"U_PRB_DD")
         return(.f.)
      ENDIF
      SELECT P_PRB_DD
      SKIP +1
   ENDDO   
   SELECT P_PRB_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      M.ID_UNIQUE  = ""
      Csql   = "Select * from u_prb_dd where 1=0"
      IF !ExecRW(Csql,"U_PRB_DD","R")
         return(.f.)
      ENDIF
      SELECT U_PRB_DD
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      DO U_PRB_DD
      IF !ExecRW(Csql,"U_PRB_DD","W")
         return(.f.)
      ENDIF
      SELECT P_PRB_DD
      SKIP +1
   ENDDO
ENDIF

*===> Autorizzazione alle spese

IF FILE("P_PDV_AU.DBF")
   =OPENDB("P_PDV_AU")
   SELECT P_PDV_AU
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_soci = "pdv_codsoc = '" + ALLTRIM(M.PDV_CODSOC) + "'"
      x_data = "pdv_dataut = '" + ALLTRIM(M.PDV_DATAUT) + "'"
      x_cpdv = "pdv_codbun = '" + ALLTRIM(M.PDV_CODBUN) + "'"
      x_uten = "pdv_codute = '" + ALLTRIM(M.PDV_CODUTE) + "'"
      x_nres = "pdv_nomres = '" + ALLTRIM(M.PDV_NOMRES) + "'"
      x_dres = "pdv_datres = '" + ALLTRIM(M.PDV_DATRES) + "'"
      x_ores = "pdv_orares = '" + ALLTRIM(M.PDV_ORARES) + "'"
      x_npro = "pdv_nompro = '" + ALLTRIM(M.PDV_NOMPRO) + "'"
      x_dpro = "pdv_datpro = '" + ALLTRIM(M.PDV_DATPRO) + "'"
      x_opro = "pdv_orapro = '" + ALLTRIM(M.PDV_ORAPRO) + "'"
      x_cond = x_soci + " and " + x_data + " and " + x_cpdv + " and " + x_uten + " and " + x_nres + " and " + x_dres + " and " + x_ores + " and " + x_npro + " and " + x_dpro + " and " + x_opro
      Csql   = "Select * from u_pdv_au where " + x_cond 
      IF !ExecRW(Csql,"U_PDV_AU","R")
         return(.f.)
      ENDIF
      SELECT U_PDV_AU
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      M.PDV_FLGTRA = .T.
      DO U_PDV_AU
      IF !ExecRW(Csql,"U_PDV_AU","W")
         return(.f.)
      ENDIF
      V_NUMAUT = V_NUMAUT + 1
      SELECT P_PDV_AU
      SKIP +1
   ENDDO
ENDIF

*===> Anagrafica articoli

IF FILE("P_ART_PR.DBF")
   =OPENDB("P_ART_PR")
   SELECT P_ART_PR
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_soci = "art_codsoc = '" + ALLTRIM(M.ART_CODSOC) + "'"
      x_codi = "art_codpri = '" + ALLTRIM(M.ART_CODPRI) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "Select * from u_art_pr where " + x_cond 
      IF !ExecRW(Csql,"U_ART_PR","R")
         return(.f.)
      ENDIF
      SELECT U_ART_PR
      GO TOP
      IF EOF()
         APPEND BLANK
         X_ULNSCA = SPACE(06)
         X_ULDSCA = SPACE(10)
         X_ULQSCA = 0
         X_ULPSCA = 0
         X_TOTSCA = 0
         X_ULNCAR = SPACE(06)
         X_ULDCAR = SPACE(10)
         X_ULQCAR = 0
         X_ULPCAR = 0
         X_TOTCAR = 0
      ELSE
         X_ULNSCA = ART_ULNSCA
         X_ULDSCA = ART_ULDSCA
         X_ULQSCA = ART_ULQSCA
         X_ULPSCA = ART_ULPSCA
         X_TOTSCA = ART_TOTSCA
         X_ULNCAR = ART_ULNCAR
         X_ULDCAR = ART_ULDCAR
         X_ULQCAR = ART_ULQCAR
         X_ULPCAR = ART_ULPCAR
         X_TOTCAR = ART_TOTCAR
      ENDIF
      M.ART_FLGTRA = .T.
      M.ART_ULNSCA = X_ULNSCA
      M.ART_ULDSCA = X_ULDSCA
      M.ART_ULQSCA = X_ULQSCA
      M.ART_ULPSCA = X_ULPSCA
      M.ART_TOTSCA = X_TOTSCA
      M.ART_ULNCAR = X_ULNCAR
      M.ART_ULDCAR = X_ULDCAR
      M.ART_ULQCAR = X_ULQCAR
      M.ART_ULPCAR = X_ULPCAR
      M.ART_TOTCAR = X_TOTCAR
      DO U_ART_PR
      IF !ExecRW(Csql,"U_ART_PR","W")
         return(.f.)
      ENDIF
      V_NUMART = V_NUMART + 1
      SELECT P_ART_PR
      SKIP +1
   ENDDO
ENDIF

*===> Anagrafica clienti

IF FILE("P_CLI_AN.DBF")
   =OPENDB("P_CLI_AN")
   SELECT P_CLI_AN
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_soci = "cli_codsoc = '" + ALLTRIM(M.CLI_CODSOC) + "'"
      x_codi = "cli_codcli = '" + ALLTRIM(M.CLI_CODCLI) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "Select * from u_cli_an where " + x_cond 
      IF !ExecRW(Csql,"U_CLI_AN","R")
         return(.f.)
      ENDIF
      SELECT U_CLI_AN
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      M.CLI_FLGTRA = .T.
      DO U_CLI_AN
      IF !ExecRW(Csql,"U_CLI_AN","W")
         return(.f.)
      ENDIF
      V_NUMCLI = V_NUMCLI + 1
      SELECT P_CLI_AN
      SKIP +1
   ENDDO
ENDIF

*===> Anagrafica fornitori

IF FILE("P_FOR_AN.DBF")
   =OPENDB("P_FOR_AN")
   SELECT P_FOR_AN
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_soci = "for_codsoc = '" + ALLTRIM(M.FOR_CODSOC) + "'"
      x_codi = "for_codcli = '" + ALLTRIM(M.FOR_CODCLI) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "Select * from u_for_an where " + x_cond 
      IF !ExecRW(Csql,"U_FOR_AN","R")
         return(.f.)
      ENDIF
      SELECT U_FOR_AN
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      M.FOR_FLGTRA = .T.
      DO X_FOR_AN
      IF !ExecRW(Csql,"U_FOR_AN","W")
         return(.f.)
      ENDIF
      V_NUMFOR = V_NUMFOR + 1
      SELECT P_FOR_AN
      SKIP +1
   ENDDO
ENDIF

*===> Listini di vendita

IF FILE("P_LIS_TA.DBF")
   =OPENDB("P_LIS_TA")
   SELECT P_LIS_TA
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_soci = "lis_codsoc = '" + ALLTRIM(M.LIS_CODSOC) + "'"
      x_clie = "lis_codcli = '" + ALLTRIM(M.LIS_CODCLI) + "'"
      x_arti = "lis_codart = '" + ALLTRIM(M.LIS_CODART) + "'"
      x_data = "lis_datlis = '" + ALLTRIM(M.LIS_DATLIS) + "'"
      x_cond = x_soci + " and " + x_clie + " and " + x_arti + " and " + x_data
      Csql   = "Delete from u_lis_tt where " + x_cond 
      IF !ExecCommand(Csql,"U_LIS_TT")
         return(.f.)
      ENDIF
      V_NUMLIA = V_NUMLIA + 1
      SELECT P_LIS_TA
      SKIP +1
   ENDDO
ENDIF

IF FILE("P_LIS_TT.DBF")
   =OPENDB("P_LIS_TT")
   SELECT P_LIS_TT
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_soci = "lis_codsoc = '" + ALLTRIM(M.LIS_CODSOC) + "'"
      x_clie = "lis_codcli = '" + ALLTRIM(M.LIS_CODCLI) + "'"
      x_arti = "lis_codart = '" + ALLTRIM(M.LIS_CODART) + "'"
      x_data = "lis_datlis = '" + ALLTRIM(M.LIS_DATLIS) + "'"
      x_cond = x_soci + " and " + x_clie + " and " + x_arti + " and " + x_data
      Csql   = "Select * from u_lis_tt where " + x_cond 
      IF !ExecRW(Csql,"U_LIS_TT","R")
         return(.f.)
      ENDIF
      SELECT U_LIS_TT
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      M.LIS_FLGTRA = .T.
      DO U_LIS_TT
      IF !ExecRW(Csql,"U_LIS_TT","W")
         return(.f.)
      ENDIF
      V_NUMLIS = V_NUMLIS + 1
      SELECT P_LIS_TT
      SKIP +1
   ENDDO
ENDIF

IF FILE("P_LIS_LG.DBF")
   =OPENDB("P_LIS_LG")
   SELECT P_LIS_LG
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_soci = "lis_codsoc = '" + ALLTRIM(M.LIS_CODSOC) + "'"
      x_tipo = "lis_tipo = '" + ALLTRIM(M.LIS_TIPO) + "'"
      x_clie = "lis_codcli = '" + ALLTRIM(M.LIS_CODCLI) + "'"
      x_data = "lis_datlis = '" + ALLTRIM(M.LIS_DATLIS) + "'"
      x_cond = x_soci + " and " + x_tipo + " and " + x_clie + " and " + x_data
      Csql   = "Select * from u_lis_lg where " + x_cond 
      IF !ExecRW(Csql,"U_LIS_LG","R")
         return(.f.)
      ENDIF
      SELECT U_LIS_LG
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      M.LIS_FLGTRA = .T.
      DO U_LIS_LG
      IF !ExecRW(Csql,"U_LIS_LG","W")
         return(.f.)
      ENDIF
      V_NUMLIG = V_NUMLIG + 1
      SELECT P_LIS_LG
      SKIP +1
   ENDDO
ENDIF

*===> Campagne sui prezzi di costo

IF FILE("P_MAG_CP.DBF")
   =OPENDB("P_MAG_CP")
   SELECT P_MAG_CP
   GO TOP
   V_SOC = SPACE(02)
   V_NUM = SPACE(06)
   V_DAT = SPACE(10)
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF V_SOC = MAG_CODSOC .AND. V_NUM = MAG_NUMCAM .AND. V_DAT = MAG_DATCAM
      ELSE
         V_SOC = MAG_CODSOC
         V_NUM = MAG_NUMCAM
         V_DAT = MAG_DATCAM
         x_soci = "mag_codsoc = '" + ALLTRIM(MAG_CODSOC) + "'"
         x_nume = "mag_numcam = '" + ALLTRIM(MAG_NUMCAM) + "'"
         x_data = "mag_datcam = '" + ALLTRIM(MAG_DATCAM) + "'"
         x_cond = x_soci + " and " + x_nume + " and " + x_data
         cSql   = "DELETE FROM U_MAG_CP WHERE " + x_cond
         IF !ExecCommand(CSQL,"U_MAG_CP")
            RETURN (.f.)
         ENDIF 
      ENDIF
      SELECT P_MAG_CP
      SCATTER MEMVAR MEMO
      Csql = "Select * from u_mag_cp where 1=0" 
      IF !ExecRW(Csql,"U_MAG_CP","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_CP
      APPEND BLANK
      M.MAG_FLGTRA = .T.
      DO U_MAG_GG
      IF !ExecRW(Csql,"U_MAG_CP","W")
         return(.f.)
      ENDIF
      V_NUMMAC = V_NUMMAC + 1
      SELECT P_MAG_CP
      SKIP +1
   ENDDO
ENDIF

*===> Fornitori preferenziali

IF FILE("P_FOR_PR.DBF")
   =OPENDB("P_FOR_PR")
   SELECT P_FOR_PR
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      M.FPR_FLGTRA = .T.
      x_soci = "FPR_CODSOC = '" + M.FPR_CODSOC + "'"
      x_arti = "FPR_CODART = '" + M.FPR_CODART + "'"
      x_forn = "FPR_CODFOR = '" + M.FPR_CODFOR + "'"
      x_cond = x_soci + " and " + x_arti + " and " + x_forn
      Csql   = "select * from u_for_pr where " + x_cond
      IF !ExecRW(Csql,"U_FOR_PR","R")
         return(.f.)
      ENDIF
      SELECT U_FOR_PR
      GO TOP
      IF EOF()
         APPEND BLANK
         DO U_FOR_PR
      ENDIF         
      REPLACE FPR_FLGTRA WITH .T.
      REPLACE FPR_CODMAG WITH PUB_CODM
      IF !ExecRW(Csql,"U_FOR_PR","W")
         return(.f.)
      ENDIF
      V_NUMFPR = V_NUMFPR + 1
      SELECT P_FOR_PR
      SKIP +1
   ENDDO
ENDIF

*===> Giacenze dettagliate aggiornate a livello di carico relativo al viaggiante da pdv a sede

IF FILE("P_MAG_GG.DBF")
   =OPENDB("P_MAG_GG")
   SELECT P_MAG_GG
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      IF EMPTY(ALLTRIM(M.MAG_DATAGG))
         x_soci = "mag_codsoc = '" + ALLTRIM(M.MAG_CODSOC) + "'"  
         x_maga = "mag_codmag = '" + ALLTRIM(M.MAG_CODMAG) + "'"
         x_codi = "mag_codart = '" + ALLTRIM(M.MAG_CODART) + "'"
         x_cond = x_soci + " and " + x_maga + " and " + x_codi
         Csql   = "select * from u_mag_an where " + x_cond
         IF !ExecRW(cSql,"U_MAG_AN","R")
            return(.f.)
         ENDIF
         SELECT U_MAG_AN
         IF EOF()
         ELSE
            REPLACE MAG_GIACEN WITH M.MAG_GIACEN
         ENDIF
         IF !ExecRW(cSql,"U_MAG_AN","W")
            return(.f.)
         ENDIF
      ENDIF      
      x_soci = "mag_codsoc = '" + ALLTRIM(M.MAG_CODSOC) + "'"
      x_data = "mag_datagg = '" + ALLTRIM(M.MAG_DATAGG) + "'"
      x_codi = "mag_codart = '" + ALLTRIM(M.MAG_CODART) + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(M.MAG_CODMAG) + "'"
      x_forn = "mag_fornit = '" + ALLTRIM(M.MAG_FORNIT) + "'"
      x_tipo = "mag_codacq = '" + ALLTRIM(M.MAG_CODACQ) + "'"
      x_prz1 = ALLTRIM(STR(M.MAG_PRZCON,17,6))
      x_prz2 = STRTRAN(x_prz1,",",".")
      x_prez = "mag_przcon = " + x_prz2
      x_cide = "mag_numide = '" + ALLTRIM(M.MAG_NUMIDE) + "'"
      x_cpdv = "mag_codbun = '" + ALLTRIM(M.MAG_CODBUN) + "'"
      x_anno = "mag_anno = '" + ALLTRIM(M.MAG_ANNO) + "'"
      x_xpdv = "mag_codpdv = '" + ALLTRIM(M.MAG_CODPDV) + "'"
      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
               x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
               x_cpdv + " and " + x_anno + " and " + x_xpdv
      Csql   = "select * from u_mag_gg where " + x_cond 
      IF !ExecRW(Csql,"U_MAG_GG","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_GG
      GO TOP
      IF EOF()
      ELSE
         REPLACE MAG_GIACEN WITH M.MAG_GIACEN
      ENDIF         
      IF !ExecRW(Csql,"U_MAG_GG","W")
         return(.f.)
      ENDIF
      SELECT P_MAG_GG
      SKIP +1
   ENDDO
ENDIF

*===> Giacenze dettagliate aggiornate a livello di data relativo al viaggiante da pdv a sede

IF FILE("P_MAG_DA.DBF")
   =OPENDB("P_MAG_DA")
   SELECT P_MAG_DA
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_soci = "mag_codsoc = '" + ALLTRIM(M.MAG_CODSOC) + "'"
      x_data = "mag_datagg = '" + ALLTRIM(M.MAG_DATAGG) + "'"
      x_codi = "mag_codart = '" + ALLTRIM(M.MAG_CODART) + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(M.MAG_CODMAG) + "'"
      x_forn = "mag_fornit = '" + ALLTRIM(M.MAG_FORNIT) + "'"
      x_tipo = "mag_codacq = '" + ALLTRIM(M.MAG_CODACQ) + "'"
      x_prz1 = ALLTRIM(STR(M.MAG_PRZCON,17,6))
      x_prz2 = STRTRAN(x_prz1,",",".")
      x_prez = "mag_przcon = " + x_prz2
      x_cide = "mag_numide = '" + ALLTRIM(M.MAG_NUMIDE) + "'"
      x_cpdv = "mag_codbun = '" + ALLTRIM(M.MAG_CODBUN) + "'"
      x_anno = "mag_anno = '" + ALLTRIM(M.MAG_ANNO) + "'"
      x_xpdv = "mag_codpdv = '" + ALLTRIM(M.MAG_CODPDV) + "'"
      x_cond = x_soci + " and " + x_data + " and " + x_codi + " and " + x_maga + " and " + ;
               x_forn + " and " + x_tipo + " and " + x_prez + " and " + x_cide + " and " + ;
               x_cpdv + " and " + x_anno + " and " + x_xpdv
      Csql   = "select * from u_mag_da where " + x_cond 
      IF !ExecRW(Csql,"U_MAG_DA","R")
         return(.f.)
      ENDIF
      SELECT U_MAG_DA
      GO TOP
      IF EOF()
      ELSE
         REPLACE MAG_GIACEN WITH M.MAG_GIACEN
      ENDIF         
      IF !ExecRW(Csql,"U_MAG_DA","W")
         return(.f.)
      ENDIF
      SELECT P_MAG_DA
      SKIP +1
   ENDDO
ENDIF

*===> Messaggi automatici 

IF FILE("P_MSG_AU.DBF")
   =OPENDB("P_MSG_AU")
   SELECT P_MSG_AU
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      x_cmit = "msg_codmit = '" + M.MSG_CODMIT + "'"
      x_cdes = "msg_coddes = '" + M.MSG_CODDES + "'"
      x_ddes = "msg_desdes = '" + M.MSG_DESDES + "'"
      x_cope = "msg_codope = '" + M.MSG_CODOPE + "'"
      x_dinv = "msg_datinv = '" + M.MSG_DATINV + "'"
      x_oinv = "msg_orainv = '" + M.MSG_ORAINV + "'"
      x_cond = x_cmit + " and " + x_cdes + " and " + x_ddes + " and " + x_cope + " and " + x_dinv + " and " + x_oinv
      Csql   = "Select * from u_msg_au where " + x_cond
      IF !ExecRW(Csql,"U_MSG_AU","R")
         return(.f.)
      ENDIF
      SELECT U_MSG_AU
      GO TOP
      IF EOF()
         APPEND BLANK
      ENDIF
      M.MSG_DATRIC = RIBALTA2(DTOC(DATE()))
      M.MSG_ORARIC = TIME()
      M.MSG_FLGRIC = .T.
      M.MSG_FLGTRA = .T.
      DO U_MSG_AU
      IF !ExecRW(Csql,"U_MSG_AU","W")
         return(.f.)
      ENDIF
      V_NUMMSG = V_NUMMSG + 1
      SELECT P_MSG_AU
      SKIP +1
   ENDDO
ENDIF

*===> Cancellazione dei file appena acquisiti
_max = 19
DIMENSION tab_tbl[_max]
tab_tbl[01] = "P_ORF_PO"                                                                           
tab_tbl[02] = "P_ORF_CO"                                                                           
tab_tbl[03] = "P_ORF_TT"                                                                           
tab_tbl[04] = "P_ORF_DD"                                                                           
tab_tbl[05] = "P_PRB_TT"                                                                           
tab_tbl[06] = "P_PRB_DD"                                                                           
tab_tbl[07] = "P_PDV_AU"                                                                           
tab_tbl[08] = "P_CAN_CO"                                                                           
tab_tbl[09] = "P_ART_PR"                                                                           
tab_tbl[10] = "P_CLI_AN"                                                                           
tab_tbl[11] = "P_FOR_AN"                                                                           
tab_tbl[12] = "P_LIS_TT"                                                                           
tab_tbl[13] = "P_LIS_LG"                                                                           
tab_tbl[14] = "P_MAG_CP"                                                                           
tab_tbl[15] = "P_LIS_TA"                                                                           
tab_tbl[16] = "P_MSG_AU"                                                                           
tab_tbl[17] = "P_FOR_PR"                                                                           
tab_tbl[18] = "P_MAG_GG"                                                                           
tab_tbl[19] = "P_MAG_DA"                                                                           

FOR _hh=1 TO _max
   IF FILE(tab_tbl[_hh]+".DBF")
      IF USED(tab_tbl[_hh])
	      SELECT &tab_tbl[_hh]
	      USE
	  ENDIF 
	  _cmd="ERASE "+tab_tbl[_hh]+".DBF"
      &_cmd
      IF FILE(tab_tbl[_hh]+".FPT")
  	     _cmd="ERASE "+tab_tbl[_hh]+".FPT"
         &_cmd
      ENDIF
      IF FILE(tab_tbl[_hh]+".CDX")
	     _cmd="ERASE "+tab_tbl[_hh]+".CDX"
         &_cmd
      ENDIF
   ENDIF
NEXT 

ERASE SEMAFORO.PDV
	   
SET DEFAULT TO &V_SONOQUI

RETURN


