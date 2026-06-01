
****************************************************************************
PROCEDURE GESTIONE_TRAPDVSEDE  			 && TRASFERIMENTO DATI DA PDV A SEDE
****************************************************************************

*=> DEFINIZIONE VARIABILI DI SVILUPPO

RELEASE V_DIR_COPY,V_SONOQUI,V_SENDMSG
PUBLIC  V_DIR_COPY,V_SONOQUI,V_SENDMSG

V_SENDMSG = .F.

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

V_SONOQUI	= SYS(5)+SYS(2003)
V_DIR_COPY  = ALLTRIM(V_DIR)							    && PERCORSO DOVE COPIARE LE TABELLE FOX IN ATTESA DELLA TRASMISSIONE

SET DEFAULT TO &V_DIR_COPY

IF FILE("SEMAFORO.PD1")
   SET DEFAULT TO &V_SONOQUI
   RETURN 
ENDIF

SET DEFAULT TO &V_SONOQUI

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

*****************************************************
* OPERAZIONI SU ARCHIVI IN AMBIENTE CASSA FISCALE   *
*****************************************************

*=> CREAZIONE STRUTTURA TABELLE DA PREPARARE PER LA TRASMISSIONE

IF !ExecCommand("select * from u_con_tr where 1=0","CU_CON_TR")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_cli_an where 1=0","CU_CLI_AN")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_cli_fi where 1=0","CU_CLI_FI")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_for_an where 1=0","CU_FOR_AN")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_art_pr where 1=0","CU_ART_PR")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_can_ca where 1=0","CU_CAN_CA")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_pdv_ca where 1=0","CU_PDV_CA")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_pdv_op where 1=0","CU_PDV_OP")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_pdv_au where 1=0","CU_PDV_AU")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_pdv_cd where 1=0","CU_PDV_CD")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_pnc_bu where 1=0","CU_PNC_BU")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_pnc_sa where 1=0","CU_PNC_SA")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_ric_va where 1=0","CU_RIC_VA")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_cal_co where 1=0","CU_CAL_CO")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_cal_as where 1=0","CU_CAL_AS")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_mon_ca where 1=0","CU_MON_CA")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_mon_pe where 1=0","CU_MON_PE")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_msg_au where 1=0","CU_MSG_AU")
   return(.f.)
ENDIF

IF !ExecCommand("select * from u_for_pr where 1=0","CU_FOR_PR")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_alt_da where 1=0","CU_ALT_DA")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_mag_ca where 1=0","CU_MAG_CA")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_mag_mo where 1=0","CU_MAG_MO")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_mag_gg where 1=0","CU_MAG_GG")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_mag_da where 1=0","CU_MAG_DA")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_mag_an where 1=0","CU_MAG_AN")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_mag_pr where 1=0","CU_MAG_PR")
   return(.f.)
ENDIF

IF !ExecCommand("select * from u_orf_dt where 1=0","CU_ORF_DT")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_orf_co where 1=0","CU_ORF_CO")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_bol_re where 1=0","CU_BOL_RE")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_can_re where 1=0","CU_CAN_RE")
   return(.f.)
ENDIF

IF !ExecCommand("select * from u_fat_tt where 1=0","CU_FAT_TT")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_fat_dd where 1=0","CU_FAT_DD")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_bol_tt where 1=0","CU_BOL_TT")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_bol_dd where 1=0","CU_BOL_DD")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_ord_tt where 1=0","CU_ORD_TT")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_ord_dd where 1=0","CU_ORD_DD")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_orf_tt where 1=0","CU_ORF_TT")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_orf_dd where 1=0","CU_ORF_DD")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_bfo_tt where 1=0","CU_BFO_TT")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_bfo_dd where 1=0","CU_BFO_DD")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_prb_tt where 1=0","CU_PRB_TT")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_prb_dd where 1=0","CU_PRB_DD")
   return(.f.)
ENDIF

*=> RIEMPIMENTO DELLE TABELLE DA PREPARARE PER LA TRASMISSIONE
*===> Anagrafica clienti

Csql = "Select * from u_cli_an where cli_flgtra = 0"
IF !ExecRW(Csql,"U_CLI_AN","R")
   return(.f.)
ENDIF
SELECT U_CLI_AN
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_CLI_AN
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMCLI = V_NUMCLI + 1
   V_SENDMSG = .T.
   SELECT U_CLI_AN
   REPLACE CLI_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_CLI_AN","W")
   return(.f.)
ENDIF

*===> Clienti fidelizzati

Csql = "Select * from u_cli_fi where fid_flgtra = 0"
IF !ExecRW(Csql,"U_CLI_FI","R")
   return(.f.)
ENDIF
SELECT U_CLI_FI
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_CLI_FI
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMFID = V_NUMFID + 1
   V_SENDMSG = .T.
   SELECT U_CLI_FI
   REPLACE FID_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_CLI_FI","W")
   return(.f.)
ENDIF

*===> Anagrafica fornitori

Csql = "Select * from u_for_an where for_flgtra = 0"
IF !ExecRW(Csql,"U_FOR_AN","R")
   return(.f.)
ENDIF
SELECT U_FOR_AN
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_FOR_AN
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMFOR = V_NUMFOR + 1
   V_SENDMSG = .T.
   SELECT U_FOR_AN
   REPLACE FOR_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_FOR_AN","W")
   return(.f.)
ENDIF

*===> Anagrafica articoli

Csql = "Select * from u_art_pr where art_flgtra = 0"
IF !ExecRW(Csql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_ART_PR
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMART = V_NUMART + 1
   V_SENDMSG = .T.
   SELECT U_ART_PR
   REPLACE ART_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_ART_PR","W")
   return(.f.)
ENDIF

*===> Incassi cancellati

Csql = "Select * from u_can_ca where cas_flgtra = 0"
IF !ExecRW(Csql,"U_CAN_CA","R")
   return(.f.)
ENDIF
SELECT U_CAN_CA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_CAN_CA
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMCAN = V_NUMCAN + 1
   SELECT U_CAN_CA
   REPLACE CAS_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_CAN_CA","W")
   return(.f.)
ENDIF

*===> Incassi

Csql = "Select * from u_pdv_ca where cas_flgtra = 0 and cas_flgagg = 1"
IF !ExecRW(Csql,"U_PDV_CA","R")
   return(.f.)
ENDIF
SELECT U_PDV_CA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_PDV_CA
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMINC = V_NUMINC + 1
   SELECT U_PDV_CA
   REPLACE CAS_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_PDV_CA","W")
   return(.f.)
ENDIF

*===> Operazioni di cassa

Csql = "Select * from u_pdv_op where cas_flgtra = 0 and cas_flgagg = 1"
IF !ExecRW(Csql,"U_PDV_OP","R")
   return(.f.)
ENDIF
SELECT U_PDV_OP
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_PDV_OP
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMOPC = V_NUMOPC + 1
   SELECT U_PDV_OP
   REPLACE CAS_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_PDV_OP","W")
   return(.f.)
ENDIF

*===> Autorizzazioni alle spese 

Csql = "Select * from u_pdv_au where pdv_flgtra = 0 and pdv_flgpro = 1"
IF !ExecRW(Csql,"U_PDV_AU","R")
   return(.f.)
ENDIF
SELECT U_PDV_AU
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_PDV_AU
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMAUT = V_NUMAUT + 1
   V_SENDMSG = .T.
   SELECT U_PDV_AU
   REPLACE PDV_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_PDV_AU","W")
   return(.f.)
ENDIF

*===> Record della chiusura di cassa definitiva

Csql = "Select * from u_pdv_cd where pdv_flgtra = 0"
IF !ExecRW(Csql,"U_PDV_CD","R")
   return(.f.)
ENDIF
SELECT U_PDV_CD
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_PDV_CD
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMMEG = V_NUMMEG + 1
   V_SENDMSG = .T.
   SELECT U_PDV_CD
   REPLACE PDV_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_PDV_CD","W")
   return(.f.)
ENDIF

*===> Prima nota cassa business unit 

Csql = "Select * from u_pnc_bu where pnc_flgtra = 0"
IF !ExecRW(Csql,"U_PNC_BU","R")
   return(.f.)
ENDIF
SELECT U_PNC_BU
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_PNC_BU
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMPNC = V_NUMPNC + 1
   V_SENDMSG = .T.
   SELECT U_PNC_BU
   REPLACE PNC_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_PNC_BU","W")
   return(.f.)
ENDIF

*===> Saldi per mese prima nota cassa business unit 

Csql = "Select * from u_pnc_sa where pnc_flgtra = 0"
IF !ExecRW(Csql,"U_PNC_SA","R")
   return(.f.)
ENDIF
SELECT U_PNC_SA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_PNC_SA
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMPNS = V_NUMPNS + 1
   SELECT U_PNC_SA
   REPLACE PNC_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_PNC_SA","W")
   return(.f.)
ENDIF

*===> Richieste varie dei clienti

Csql = "Select * from u_ric_va where ric_flgtra = 0"
IF !ExecRW(Csql,"U_RIC_VA","R")
   return(.f.)
ENDIF
SELECT U_RIC_VA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_RIC_VA
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMRIC = V_NUMRIC + 1
   V_SENDMSG = .T.
   SELECT U_RIC_VA
   REPLACE RIC_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_RIC_VA","W")
   return(.f.)
ENDIF

*===> Calendario annuale con orari di apertura/chiusura del pdv

Csql = "Select * from u_cal_co where cop_flgtra = 0"
IF !ExecRW(Csql,"U_CAL_CO","R")
   return(.f.)
ENDIF
SELECT U_CAL_CO
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_CAL_CO
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMCAL = V_NUMCAL + 1
   SELECT U_CAL_CO
   REPLACE COP_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_CAL_CO","W")
   return(.f.)
ENDIF

*===> Assenze dei collaboratori

Csql = "Select * from u_cal_as where cal_flgtra = 0 and cal_flgcon = 1"
IF !ExecRW(Csql,"U_CAL_AS","R")
   return(.f.)
ENDIF
SELECT U_CAL_AS
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_CAL_AS
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMASS = V_NUMASS + 1
   V_SENDMSG = .T.
   SELECT U_CAL_AS
   REPLACE CAL_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_CAL_AS","W")
   return(.f.)
ENDIF

*===> monitoraggio casse

Csql = "Select * from u_mon_ca where mon_flgtra = 0"
IF !ExecRW(Csql,"U_MON_CA","R")
   return(.f.)
ENDIF
SELECT U_MON_CA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_MON_CA
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMMOC = V_NUMMOC + 1
   SELECT U_MON_CA
   REPLACE MON_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_MON_CA","W")
   return(.f.)
ENDIF

*===> monitoraggio numero di visitatori del pdv

Csql = "Select * from u_mon_pe where mon_flgtra = 0"
IF !ExecRW(Csql,"U_MON_PE","R")
   return(.f.)
ENDIF
SELECT U_MON_PE
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_MON_PE
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMMOP = V_NUMMOP + 1
   SELECT U_MON_PE
   REPLACE MON_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_MON_PE","W")
   return(.f.)
ENDIF

*===> Fornitori preferenziali

Csql = "Select * from u_for_pr where fpr_flgtra = 0"
IF !ExecRW(Csql,"U_FOR_PR","R")
   return(.f.)
ENDIF
SELECT U_FOR_PR
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_FOR_PR
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMFPR = V_NUMFPR + 1
   V_SENDMSG = .T.
   SELECT U_FOR_PR
   REPLACE FPR_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_FOR_PR","W")
   return(.f.)
ENDIF

*===> Altri dati che servono nei passaggi alle routine di gestione magazzino

Csql = "Select * from u_alt_da where alt_flgtra = 0"
IF !ExecRW(Csql,"U_ALT_DA","R")
   return(.f.)
ENDIF
SELECT U_ALT_DA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_ALT_DA
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMALT = V_NUMALT + 1
   SELECT U_ALT_DA
   REPLACE ALT_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_ALT_DA","W")
   return(.f.)
ENDIF

*===> Movimenti di magazzino (escluso quelli movimentati dall'incasso)

Csql = "Select * from u_mag_mo where mov_flgtra = 0"
IF !ExecRW(Csql,"U_MAG_MO","R")
   return(.f.)
ENDIF
SELECT U_MAG_MO
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_MAG_MO
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMMOV = V_NUMMOV + 1
   SELECT U_MAG_MO
   REPLACE MOV_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_MAG_MO","W")
   return(.f.)
ENDIF

*===> Movimenti di magazzino cancellati

Csql = "Select * from u_mag_ca where mov_flgtra = 0"
IF !ExecRW(Csql,"U_MAG_CA","R")
   return(.f.)
ENDIF
SELECT U_MAG_CA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_MAG_CA
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMCAM = V_NUMCAM + 1
   SELECT U_MAG_CA
   REPLACE MOV_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_MAG_CA","W")
   return(.f.)
ENDIF

*===> Giacenze per carico (data/mag/art/forn/tipo/prz)

Csql = "Select * from u_mag_gg where mag_flgtra = 0"
IF !ExecRW(Csql,"U_MAG_GG","R")
   return(.f.)
ENDIF
SELECT U_MAG_GG
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_MAG_GG
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMGGG = V_NUMGGG + 1
   SELECT U_MAG_GG
   REPLACE MAG_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_MAG_GG","W")
   return(.f.)
ENDIF

*===> Giacenze per data (data/mag/art/forn/tipo/prz)

Csql = "Select * from u_mag_da where mag_flgtra = 0"
IF !ExecRW(Csql,"U_MAG_DA","R")
   return(.f.)
ENDIF
SELECT U_MAG_DA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_MAG_DA
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMGDA = V_NUMGDA + 1
   SELECT U_MAG_DA
   REPLACE MAG_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_MAG_DA","W")
   return(.f.)
ENDIF

*===> Giacenze al momento (mag/art)

Csql = "Select * from u_mag_an where mag_flgtra = 0"
IF !ExecRW(Csql,"U_MAG_AN","R")
   return(.f.)
ENDIF
SELECT U_MAG_AN
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_MAG_AN
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMGAN = V_NUMGAN + 1
   SELECT U_MAG_AN
   REPLACE MAG_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_MAG_AN","W")
   return(.f.)
ENDIF

*===> Giacenze progressive (anno/mag/art)

Csql = "Select * from u_mag_pr where mag_flgtra = 0"
IF !ExecRW(Csql,"U_MAG_PR","R")
   return(.f.)
ENDIF
SELECT U_MAG_PR
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_MAG_PR
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMGPR = V_NUMGPR + 1
   SELECT U_MAG_PR
   REPLACE MAG_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_MAG_PR","W")
   return(.f.)
ENDIF

*===> Record dei carichi fatti con i documenti del fornitore

Csql = "Select * from u_orf_dt where orf_flgtra = 0 and orf_flgcon = 1"
IF !ExecRW(Csql,"U_ORF_DT","R")
   return(.f.)
ENDIF
SELECT U_ORF_DT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_ORF_DT
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMDDT = V_NUMDDT + 1
   V_SENDMSG = .T.
   SELECT U_ORF_DT
   REPLACE ORF_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_ORF_DT","W")
   return(.f.)
ENDIF

*===> Bolle di trasferimento da pdv a pdv / da pdv a sede / da sede a pdv

x_fla1 = "orf_flgtra = 0"
x_fla2 = "orf_flgcon = 1"
x_cond = x_fla1 + " and " + x_fla2
Csql = "Select * from u_orf_co where " + x_cond
IF !ExecRW(Csql,"U_ORF_CO","R")
   return(.f.)
ENDIF
SELECT U_ORF_CO
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_ORF_CO
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMBOL = V_NUMBOL + 1
   V_SENDMSG = .T.
   SELECT U_ORF_CO
   REPLACE ORF_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_ORF_CO","W")
   return(.f.)
ENDIF

*===> Record delle bolle di reso da pdv a sede

Csql = "Select * from u_bol_re where orf_flgtra = 0 and orf_flgcon = 1"
IF !ExecRW(Csql,"U_BOL_RE","R")
   return(.f.)
ENDIF
SELECT U_BOL_RE
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_BOL_RE
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMRES = V_NUMRES + 1
   V_SENDMSG = .T.
   SELECT U_BOL_RE
   REPLACE ORF_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_BOL_RE","W")
   return(.f.)
ENDIF

*===> Bolle di reso da pdv a sede cancellate

Csql = "Select * from u_can_re where orf_flgtra = 0"
IF !ExecRW(Csql,"U_CAN_RE","R")
   return(.f.)
ENDIF
SELECT U_CAN_RE
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_CAN_RE
   APPEND BLANK
   GATHER MEMVAR MEMO
   SELECT U_CAN_RE
   REPLACE ORF_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_CAN_RE","W")
   return(.f.)
ENDIF

*===> Fatture emesse a clienti

Csql = "Select * from u_fat_tt where ord_flgtra = 0"
IF !ExecRW(Csql,"U_FAT_TT","R")
   return(.f.)
ENDIF
SELECT U_FAT_TT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_FAT_TT
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMFAT = V_NUMFAT + 1
   V_SENDMSG = .T.
   x_cond = "daggancio = '" + ALLTRIM(M.TAGGANCIO) + "'"
   Csql   = "Select * from u_fat_dd where " + x_cond + " order by daggancio,ord_sequen"
   IF !ExecCommand(Csql,"U_FAT_DD")
      return(.f.)
   ENDIF
   SELECT U_FAT_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_FAT_DD
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT U_FAT_DD
      SKIP +1
   ENDDO
   SELECT U_FAT_TT
   REPLACE ORD_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_FAT_TT","W")
   return(.f.)
ENDIF

*===> Ordini clienti

Csql = "Select * from u_ord_tt where ord_flgtra = 0"
IF !ExecRW(Csql,"U_ORD_TT","R")
   return(.f.)
ENDIF
SELECT U_ORD_TT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_ORD_TT
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMORD = V_NUMORD + 1
   V_SENDMSG = .T.
   x_cond = "daggancio = '" + ALLTRIM(M.TAGGANCIO) + "'"
   Csql   = "Select * from u_ord_dd where " + x_cond + " order by daggancio,ord_sequen"
   IF !ExecCommand(Csql,"U_ORD_DD")
      return(.f.)
   ENDIF
   SELECT U_ORD_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_ORD_DD
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT U_ORD_DD
      SKIP +1
   ENDDO
   SELECT U_ORD_TT
   REPLACE ORD_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_ORD_TT","W")
   return(.f.)
ENDIF

*===> Proposte d'ordini

Csql = "Select * from u_orf_tt where ord_flgtra = 0 and ord_flgcon = 1 and ord_makeda = 'PDV '"
IF !ExecRW(Csql,"U_ORF_TT","R")
   return(.f.)
ENDIF
SELECT U_ORF_TT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_ORF_TT
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMORF = V_NUMORF + 1
   V_SENDMSG = .T.
   x_cond = "daggancio = '" + ALLTRIM(M.TAGGANCIO) + "'"
   Csql   = "Select * from u_orf_dd where " + x_cond + " order by daggancio,ord_sequen"
   IF !ExecCommand(Csql,"U_ORF_DD")
      return(.f.)
   ENDIF
   SELECT U_ORF_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_ORF_DD
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT U_ORF_DD
      SKIP +1
   ENDDO
   SELECT U_ORF_TT
   REPLACE ORD_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_ORF_TT","W")
   return(.f.)
ENDIF

*===> Bolle di carico dei fornitori

Csql = "Select * from u_bfo_tt where ord_flgtra = 0 and ord_flgcon = 1"
IF !ExecRW(Csql,"U_BFO_TT","R")
   return(.f.)
ENDIF
SELECT U_BFO_TT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_BFO_TT
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMBFO = V_NUMBFO + 1
   V_SENDMSG = .T.
   x_cond = "daggancio = '" + ALLTRIM(M.TAGGANCIO) + "'"
   Csql   = "Select * from u_bfo_dd where " + x_cond + " order by daggancio,ord_sequen"
   IF !ExecCommand(Csql,"U_BFO_DD")
      return(.f.)
   ENDIF
   SELECT U_BFO_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_BFO_DD
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT U_BFO_DD
      SKIP +1
   ENDDO
   SELECT U_BFO_TT
   REPLACE ORD_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_BFO_TT","W")
   return(.f.)
ENDIF

*===> Pre-bolle di reso emesse direttamente dal pdv

Csql = "Select * from u_prb_tt where ord_flgtra = 0 and ord_flgcon = 1 and ord_makeda = 'PDV '"
IF !ExecRW(Csql,"U_PRB_TT","R")
   return(.f.)
ENDIF
SELECT U_PRB_TT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_PRB_TT
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMPRB = V_NUMPRB + 1
   V_SENDMSG = .T.
   x_cond = "daggancio = '" + ALLTRIM(M.TAGGANCIO) + "'"
   Csql   = "Select * from u_prb_dd where " + x_cond + " order by daggancio,ord_sequen"
   IF !ExecCommand(Csql,"U_PRB_DD")
      return(.f.)
   ENDIF
   SELECT U_PRB_DD
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_PRB_DD
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT U_PRB_DD
      SKIP +1
   ENDDO
   SELECT U_PRB_TT
   REPLACE ORD_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_PRB_TT","W")
   return(.f.)
ENDIF

*===> messaggi automatici

IF V_SENDMSG
   * Ricerca della descrizione del mittente 
   V_DESMIT = ""
   x_cond   = "pdv_codice = '" + ALLTRIM(PUB_CODBUN) + "'"
   Csql     = "select * from u_pdv_an where " + x_cond
   IF !ExecCommand(Csql,"CU_PDV_AN")
      return(.f.)
   ENDIF
   SELECT CU_PDV_AN
   GO TOP
   IF EOF()
   ELSE
      V_DESMIT = PDV_DESCRI
   ENDIF         
   * Ricerca del codice e descrizione del destinatario (sede centrale) 
   V_CODDES = ""
   V_DESDES = ""
   x_cond   = "pdv_codcli = '" + ALLTRIM(PUB_CFDEF) + "'"
   Csql     = "select * from u_pdv_an where " + x_cond
   IF !ExecCommand(Csql,"CU_PDV_AN")
      return(.f.)
   ENDIF
   SELECT CU_PDV_AN
   GO TOP
   IF EOF()
   ELSE
      V_CODDES = PDV_CODICE
      V_DESDES = PDV_DESCRI
   ENDIF         
   * Composizione del testo automatico in base ai dati trasferiti
   V_TESTO  = ""
   V_GEN = "Dati trasferiti : " + CHR(13)
   V_ART = "Anagr. Articoli = " + ALLTRIM(STR(V_NUMART,7,0))
   V_FOR = "Anagr. Fornitori = " + ALLTRIM(STR(V_NUMFOR,7,0))
   V_CLI = "Anagr. Clienti = " + ALLTRIM(STR(V_NUMCLI,7,0))
   V_FID = "Clienti Fidelizzati = " + ALLTRIM(STR(V_NUMFID,7,0))
   V_FPR = "Fornitori preferenziali = " + ALLTRIM(STR(V_NUMFPR,7,0))
   V_AUT = "Autor. alle spese = " + ALLTRIM(STR(V_NUMAUT,7,0))
   V_MEG = "Chiusura di cassa def. = " + ALLTRIM(STR(V_NUMMEG,7,0))
   V_PNC = "Prima nota cassa = " + ALLTRIM(STR(V_NUMPNC,7,0))
   V_RIC = "Richieste varie dei clienti = " + ALLTRIM(STR(V_NUMRIC,7,0))
   V_ASS = "Assenze collaboratori = " + ALLTRIM(STR(V_NUMASS,7,0))
   V_DDT = "Carichi con doc. fornitore = " + ALLTRIM(STR(V_NUMDDT,7,0))
   V_BOL = "Bolle di trasferimento = " + ALLTRIM(STR(V_NUMBOL,7,0))
   V_RES = "Bolle di reso da pdv a sede = " + ALLTRIM(STR(V_NUMRES,7,0))
   V_FAT = "Fatture emesse da clienti = " + ALLTRIM(STR(V_NUMFAT,7,0))
   V_ORD = "Ordini clienti = " + ALLTRIM(STR(V_NUMORD,7,0))
   V_ORF = "Proposte d'ordine = " + ALLTRIM(STR(V_NUMORF,7,0))
   V_BFO = "Bolle di carico dei fornitori = " + ALLTRIM(STR(V_NUMBFO,7,0))
   V_PRB = "Pre-Bolle di reso emesse direttamente dai pdv = " + ALLTRIM(STR(V_NUMPRB,7,0))
   V_TESTO = V_GEN
   IF V_NUMART > 0
      V_TESTO = V_TESTO + V_ART + CHR(13)
   ENDIF
   IF V_NUMFOR > 0
      V_TESTO = V_TESTO + V_FOR + CHR(13)
   ENDIF
   IF V_NUMCLI > 0
      V_TESTO = V_TESTO + V_CLI + CHR(13)
   ENDIF
   IF V_NUMFID > 0
      V_TESTO = V_TESTO + V_FID + CHR(13)
   ENDIF
   IF V_NUMFPR > 0
      V_TESTO = V_TESTO + V_FPR + CHR(13)
   ENDIF
   IF V_NUMAUT > 0
      V_TESTO = V_TESTO + V_AUT + CHR(13)
   ENDIF
   IF V_NUMMEG > 0
      V_TESTO = V_TESTO + V_MEG + CHR(13)
   ENDIF
   IF V_NUMPNC > 0
      V_TESTO = V_TESTO + V_PNC + CHR(13)
   ENDIF
   IF V_NUMRIC > 0
      V_TESTO = V_TESTO + V_RIC + CHR(13)
   ENDIF
   IF V_NUMASS > 0
      V_TESTO = V_TESTO + V_ASS + CHR(13)
   ENDIF
   IF V_NUMDDT > 0
      V_TESTO = V_TESTO + V_DDT + CHR(13)
   ENDIF
   IF V_NUMBOL > 0
      V_TESTO = V_TESTO + V_BOL + CHR(13)
   ENDIF
   IF V_NUMRES > 0
      V_TESTO = V_TESTO + V_RES + CHR(13)
   ENDIF
   IF V_NUMFAT > 0
      V_TESTO = V_TESTO + V_FAT + CHR(13)
   ENDIF
   IF V_NUMORD > 0
      V_TESTO = V_TESTO + V_ORD + CHR(13)
   ENDIF
   IF V_NUMORF > 0
      V_TESTO = V_TESTO + V_ORF + CHR(13)
   ENDIF
   IF V_NUMBFO > 0
      V_TESTO = V_TESTO + V_BFO + CHR(13)
   ENDIF
   IF V_NUMPRB > 0
      V_TESTO = V_TESTO + V_PRB + CHR(13)
   ENDIF
   Csql = "Select * from u_msg_au where 1=0"
   IF !ExecRW(Csql,"U_MSG_AU","R")
      return(.f.)
   ENDIF
   SELECT U_MSG_AU
   APPEND BLANK
   REPLACE MSG_CODSOC WITH PUB_CODSOC
   REPLACE MSG_CODMIT WITH PUB_CODBUN
   REPLACE MSG_DESMIT WITH V_DESMIT
   REPLACE MSG_CODOPE WITH "AUTO"
   REPLACE MSG_DESOPE WITH "AUTOMATICO"
   REPLACE MSG_CODDES WITH V_CODDES
   REPLACE MSG_DESDES WITH V_DESDES
   REPLACE MSG_DATINV WITH RIBALTA2(DTOC(DATE()))
   REPLACE MSG_ORAINV WITH TIME()
   REPLACE MSG_FLGTRA WITH .F.
   REPLACE MSG_FLGCON WITH .T.
   REPLACE MSG_FLGRIC WITH .F.
   REPLACE MSG_FLGLET WITH .F.
   REPLACE MSG_TESTO  WITH V_TESTO
   IF !ExecRW(Csql,"U_MSG_AU","W")
      return(.f.)
   ENDIF
ENDIF   

Csql = "Select * from u_msg_au where msg_flgtra = 0 and msg_flgcon = 1"
IF !ExecRW(Csql,"U_MSG_AU","R")
   return(.f.)
ENDIF
SELECT U_MSG_AU
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_MSG_AU
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMMSG = V_NUMMSG + 1
   SELECT U_MSG_AU
   REPLACE MSG_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_MSG_AU","W")
   return(.f.)
ENDIF

*===> Acquisizione dell'ultimo numero di trasmissione 

x_cond = "codice = 'PRG011'"
Csql   = "Select * from para where " + x_cond
IF !ExecRW(Csql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
GO TOP
IF EOF()
   APPEND BLANK
   REPLACE CODICE WITH 'PRG011'
   REPLACE DESCRI WITH 'PROGRESSIVO TRASMISSIONE DA CASSA A SERVER PDV'
   REPLACE LIBERA WITH '0000000000'
ENDIF
V_PROTRA_N = VAL(SUBSTR(LIBERA,1,10)) + 1
V_PROTRA_X = STR(V_PROTRA_N,10,0)
PUB_LNO    = 10
V_LIBERA   = TRC(PUB_LNO,ALLTRIM(V_PROTRA_X))
REPLACE LIBERA WITH V_LIBERA
IF !ExecRW(Csql,"PARA","W")
   return(.f.)
ENDIF

*===> Aggiornamento tabella delle trasmissioni 
x_data = "con_data = '" + RIBALTA2(DTOC(DATE())) + "'"
x_prog = "con_progre = " + ALLTRIM(V_PROTRA_X)
x_cond = x_data + " and " + x_prog
Csql   = "Select * from u_con_tr where " + x_cond
IF !ExecRW(Csql,"U_CON_TR","R")
   return(.f.)
ENDIF
SELECT U_CON_TR
GO TOP
IF EOF()
   APPEND BLANK
   REPLACE CON_DATA   WITH RIBALTA2(DTOC(DATE()))
   REPLACE CON_PROGRE WITH V_PROTRA_N
ENDIF
REPLACE CON_ORATRA WITH TIME()
REPLACE CON_TIPO   WITH '1'
REPLACE CON_DESCRI WITH 'PDV->SEDE'
REPLACE CON_CLITRA WITH V_NUMCLI
REPLACE CON_FORTRA WITH V_NUMFOR
REPLACE CON_ARTTRA WITH V_NUMART
REPLACE CON_INCTRA WITH V_NUMINC
REPLACE CON_CANTRA WITH V_NUMCAN
REPLACE CON_OPCTRA WITH V_NUMOPC
REPLACE CON_MOVTRA WITH V_NUMMOV
REPLACE CON_FATTRA WITH V_NUMFAT
REPLACE CON_BOLTRA WITH V_NUMBOL
REPLACE CON_ORDTRA WITH V_NUMORD
REPLACE CON_ORFTRA WITH V_NUMORF
REPLACE CON_BFOTRA WITH V_NUMBFO
REPLACE CON_AUTTRA WITH V_NUMAUT
REPLACE CON_PNCTRA WITH V_NUMPNC
REPLACE CON_PNSTRA WITH V_NUMPNS
REPLACE CON_FIDTRA WITH V_NUMFID
REPLACE CON_RICTRA WITH V_NUMRIC
REPLACE CON_MEGTRA WITH V_NUMMEG
REPLACE CON_DDTTRA WITH V_NUMDDT
REPLACE CON_RESTRA WITH V_NUMRES
REPLACE CON_PRBTRA WITH V_NUMPRB
REPLACE CON_ASSTRA WITH V_NUMASS
REPLACE CON_MOCTRA WITH V_NUMMOC
REPLACE CON_MOPTRA WITH V_NUMMOP
REPLACE CON_ALTTRA WITH V_NUMALT
REPLACE CON_FPRTRA WITH V_NUMFPR
REPLACE CON_GGGTRA WITH V_NUMGGG
REPLACE CON_GDATRA WITH V_NUMGDA
REPLACE CON_GANTRA WITH V_NUMGAN
REPLACE CON_GPRTRA WITH V_NUMGPR
REPLACE CON_CALTRA WITH V_NUMCAL
REPLACE CON_CAMTRA WITH V_NUMCAM
SCATTER MEMVAR MEMO
SELECT CU_CON_TR
APPEND BLANK
GATHER MEMVAR MEMO

IF !ExecRW(Csql,"U_CON_TR","W")
   return(.f.)
ENDIF

*===> Copia dei cursori nella directory prevista per la trasmissione delle tabelle fox

_trasmetti = V_DIR_COPY + "\P_CLI_AN"
SELECT CU_CLI_AN
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_CLI_FI"
SELECT CU_CLI_FI
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_FOR_AN"
SELECT CU_FOR_AN
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_ART_PR"
SELECT CU_ART_PR
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_CAN_CA"
SELECT CU_CAN_CA
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_PDV_CA"
SELECT CU_PDV_CA
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_PDV_OP"
SELECT CU_PDV_OP
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_PDV_AU"
SELECT CU_PDV_AU
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_PDV_CD"
SELECT CU_PDV_CD
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_PNC_BU"
SELECT CU_PNC_BU
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_PNC_SA"
SELECT CU_PNC_SA
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_RIC_VA"
SELECT CU_RIC_VA
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_CAL_CO"
SELECT CU_CAL_CO
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_CAL_AS"
SELECT CU_CAL_AS
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_MON_CA"
SELECT CU_MON_CA
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_MON_PE"
SELECT CU_MON_PE
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_FOR_PR"
SELECT CU_FOR_PR
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_ALT_DA"
SELECT CU_ALT_DA
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_MAG_CA"
SELECT CU_MAG_CA
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_MAG_MO"
SELECT CU_MAG_MO
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_MAG_GG"
SELECT CU_MAG_GG
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_MAG_DA"
SELECT CU_MAG_DA
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_MAG_AN"
SELECT CU_MAG_AN
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_MAG_PR"
SELECT CU_MAG_PR
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_ORF_DT"
SELECT CU_ORF_DT
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_ORF_CO"
SELECT CU_ORF_CO
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_BOL_RE"
SELECT CU_BOL_RE
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_CAN_RE"
SELECT CU_CAN_RE
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_FAT_TT"
SELECT CU_FAT_TT
IF EOF()
ELSE
   COPY TO &_trasmetti
   _trasmetti = V_DIR_COPY + "\P_FAT_DD"
   SELECT CU_FAT_DD
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_ORD_TT"
SELECT CU_ORD_TT
IF EOF()
ELSE
   COPY TO &_trasmetti
   _trasmetti = V_DIR_COPY + "\P_ORD_DD"
   SELECT CU_ORD_DD
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_ORF_TT"
SELECT CU_ORF_TT
IF EOF()
ELSE
   COPY TO &_trasmetti
   _trasmetti = V_DIR_COPY + "\P_ORF_DD"
   SELECT CU_ORF_DD
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_BFO_TT"
SELECT CU_BFO_TT
IF EOF()
ELSE
   COPY TO &_trasmetti
   _trasmetti = V_DIR_COPY + "\P_BFO_DD"
   SELECT CU_BFO_DD
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_PRB_TT"
SELECT CU_PRB_TT
IF EOF()
ELSE
   COPY TO &_trasmetti
   _trasmetti = V_DIR_COPY + "\P_PRB_DD"
   SELECT CU_PRB_DD
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_CON_TR"
SELECT CU_CON_TR
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

_trasmetti = V_DIR_COPY + "\P_MSG_AU"
SELECT CU_MSG_AU
IF EOF()
ELSE
   COPY TO &_trasmetti
ENDIF

SET DEFAULT TO &V_DIR_COPY
HD=FCREATE("SEMAFORO.PD1")
=FPUTS(HD,"PIPPO")
=FCLOSE(HD)

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


****************************************************************************
PROCEDURE GESTIONE_TRASEDEPDV  			 && TRASFERIMENTO DATI DA SEDE A PDV
****************************************************************************

Csql = "Select * from u_azi_an where azi_codsoc = '01'"
IF !ExecCommand(Csql,"U_AZI_AN")
   return(.f.)
ENDIF
SELECT U_AZI_AN
GO TOP
IF EOF()
ELSE
   PUB_CODBUN = AZI_CODBUN                        
   PUB_CFDEF  = AZI_CFDEF
ENDIF

*=> DEFINIZIONE VARIABILI DI SVILUPPO

RELEASE V_NUMPOF,V_NUMCOF,V_NUMORF,V_NUMPRB,V_NUMAUT,V_NUMORC,V_NUMART,V_NUMCLI,V_NUMFOR, ;
        V_NUMLIS,V_NUMLIG,V_NUMMAC,V_NUMLIA,V_NUMMSG,V_NUMFPR,V_SENDMSG1
PUBLIC  V_NUMPOF,V_NUMCOF,V_NUMORF,V_NUMPRB,V_NUMAUT,V_NUMORC,V_NUMART,V_NUMCLI,V_NUMFOR, ;
        V_NUMLIS,V_NUMLIG,V_NUMMAC,V_NUMLIA,V_NUMMSG,V_NUMFPR,V_SENDMSG1
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
V_SENDMSG1 = .F.

*=> CREAZIONE STRUTTURA TABELLE DA PREPARARE PER LA TRASMISSIONE A TUTTI I PDV COLLEGATI
IF !ExecCommand("select * from u_art_pr where 1=0","CU_ART_PR")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_cli_an where 1=0","CU_CLI_AN")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_for_an where 1=0","CU_FOR_AN")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_lis_tt where 1=0","CU_LIS_TT")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_lis_lg where 1=0","CU_LIS_LG")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_lis_ta where 1=0","CU_LIS_TA")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_msg_au where 1=0","CU_MSG_AU")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_for_pr where 1=0","CU_FOR_PR")
   return(.f.)
ENDIF

*=> RIEMPIMENTO DELLE TABELLE DA PREPARARE PER LA TRASMISSIONE

*===> Anagrafica articoli
x_flag = "art_flgtra = 0"
x_cond = x_flag
Csql = "Select * from u_art_pr where " + x_cond
IF !ExecRW(Csql,"U_ART_PR","R")
   return(.f.)
ENDIF
SELECT U_ART_PR
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_ART_PR
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMART = V_NUMART + 1
   *V_SENDMSG1 = .T.
   SELECT U_ART_PR
   REPLACE ART_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_ART_PR","W")
   return(.f.)
ENDIF

*===> Anagrafica clienti
x_flag = "cli_flgtra = 0"
x_cond = x_flag
Csql = "Select * from u_cli_an where " + x_cond
IF !ExecRW(Csql,"U_CLI_AN","R")
   return(.f.)
ENDIF
SELECT U_CLI_AN
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_CLI_AN
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMCLI = V_NUMCLI + 1
   *V_SENDMSG1 = .T.
   SELECT U_CLI_AN
   REPLACE CLI_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_CLI_AN","W")
   return(.f.)
ENDIF

*===> Anagrafica fornitori
x_flag = "for_flgtra = 0"
x_cond = x_flag
Csql = "Select * from u_for_an where " + x_cond
IF !ExecRW(Csql,"U_FOR_AN","R")
   return(.f.)
ENDIF
SELECT U_FOR_AN
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_FOR_AN
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMFOR = V_NUMFOR + 1
   *V_SENDMSG1 = .T.
   SELECT U_FOR_AN
   REPLACE FOR_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_FOR_AN","W")
   return(.f.)
ENDIF

*===> Listini di vendita

x_flag = "lis_flgtra = 0"
x_cond = x_flag
Csql   = "Select * from u_lis_ta where " + x_cond
IF !ExecRW(Csql,"U_LIS_TA","R")
   return(.f.)
ENDIF
SELECT U_LIS_TA
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_LIS_TA
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMLIA = V_NUMLIA + 1
   SELECT U_LIS_TA
   REPLACE LIS_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_LIS_TA","W")
   return(.f.)
ENDIF

x_flag = "lis_flgtra = 0"
x_cond = x_flag
Csql   = "Select * from u_lis_tt where " + x_cond
IF !ExecRW(Csql,"U_LIS_TT","R")
   return(.f.)
ENDIF
SELECT U_LIS_TT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_LIS_TT
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMLIS = V_NUMLIS + 1
   *V_SENDMSG1 = .T.
   SELECT U_LIS_TT
   REPLACE LIS_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_LIS_TT","W")
   return(.f.)
ENDIF

x_flag = "lis_flgtra = 0"
x_cond = x_flag
Csql   = "Select * from u_lis_lg where " + x_cond
IF !ExecRW(Csql,"U_LIS_LG","R")
   return(.f.)
ENDIF
SELECT U_LIS_LG
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_LIS_LG
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMLIG = V_NUMLIG + 1
   SELECT U_LIS_LG
   REPLACE LIS_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_LIS_LG","W")
   return(.f.)
ENDIF

*===> Fornitori preferenziali

Csql = "Select * from u_for_pr where fpr_flgtra = 0"
IF !ExecRW(Csql,"U_FOR_PR","R")
   return(.f.)
ENDIF
SELECT U_FOR_PR
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   SCATTER MEMVAR MEMO
   SELECT CU_FOR_PR
   APPEND BLANK
   GATHER MEMVAR MEMO
   V_NUMFPR = V_NUMFPR + 1
   *V_SENDMSG1 = .T.
   SELECT U_FOR_PR
   REPLACE FPR_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_FOR_PR","W")
   return(.f.)
ENDIF

RELEASE V_DIR_COPY,V_SONOQUI,X_CODPDV,V_SENDMSG
PUBLIC  V_DIR_COPY,V_SONOQUI,X_CODPDV,V_SENDMSG
V_SENDMSG = .F.
V_SONOQUI = SYS(5)+SYS(2003)

Csql = "Select * from u_ftp_an where ftp_tipcom = 'S'"
IF !ExecCommand(Csql,"U_FTP_AN")
   return(.f.)
ENDIF
SELECT U_FTP_AN
GO TOP

DO WHILE !EOF()

   IF FTP_TIPO = 'I'
   ELSE
      SKIP +1
      LOOP
   ENDIF

   X_CODPDV    = FTP_CODPDV
   V_DIR_COPY  = ALLTRIM(FTP_PATHDA)    && PERCORSO DOVE PREPARARE I FILE PER I PDV
	   
   SET DEFAULT TO &V_DIR_COPY

   IF FILE("SEMAFORO.APO")
      SET DEFAULT TO &V_SONOQUI
      SKIP +1
      LOOP
   ENDIF

   IF FILE("SEMAFORO.SED")
      SET DEFAULT TO &V_SONOQUI
      SKIP +1
      LOOP
   ENDIF

   IF ADIR(PIPPO,'*.*') <> 0
      SET DEFAULT TO &V_SONOQUI
      SKIP +1
      LOOP
   ENDIF

   HD=FCREATE("SEMAFORO.SED")
   =FPUTS(HD,"PIPPO")
   =FCLOSE(HD)
   
   *=> CREAZIONE STRUTTURA TABELLE DA PREPARARE PER LA TRASMISSIONE

   IF !ExecCommand("select * from u_orf_po where 1=0","CU_ORF_PO")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_orf_co where 1=0","CU_CAN_CO")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_orf_co where 1=0","CU_ORF_CO")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_orf_tt where 1=0","CU_ORF_TT")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_orf_dd where 1=0","CU_ORF_DD")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_prb_tt where 1=0","CU_PRB_TT")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_prb_dd where 1=0","CU_PRB_DD")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_pdv_au where 1=0","CU_PDV_AU")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_mag_cp where 1=0","CU_MAG_CP")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_msg_au where 1=0","CU_MSG_AU")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_mag_gg where 1=0","CU_MAG_GG")
      return(.f.)
   ENDIF
   IF !ExecCommand("select * from u_mag_da where 1=0","CU_MAG_DA")
      return(.f.)
   ENDIF
	   
   *=> RIEMPIMENTO DELLE TABELLE DA PREPARARE PER LA TRASMISSIONE

   *===> Proposte d'ordini da ritornare al pdv

   x_fla1 = "orf_flgtra = 0"
   x_cpdv = "orf_codpdv = '" + ALLTRIM(X_CODPDV) + "'"
   x_fla2 = "orf_flgcon = 1"
   x_cond = x_fla1 + " and " + x_cpdv + " and " + x_fla2
   Csql = "Select * from u_orf_po where " + x_cond
   IF !ExecRW(Csql,"U_ORF_PO","R")
      return(.f.)
   ENDIF
   SELECT U_ORF_PO
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_ORF_PO
      APPEND BLANK
      GATHER MEMVAR MEMO
      V_NUMPOF = V_NUMPOF + 1
      SELECT U_ORF_PO
      REPLACE ORF_FLGTRA WITH .T.
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_ORF_PO","W")
      return(.f.)
   ENDIF

   *===> Bolle di trasferimento da sede a pdv cancellate da ritornare al pdv

   x_flag = "orf_flgtra = 0"
   x_cpdv = "orf_codpdv = '" + ALLTRIM(X_CODPDV) + "'"
   x_cond = x_flag + " and " + x_cpdv
   Csql = "Select * from u_can_co where " + x_cond
   IF !ExecRW(Csql,"U_CAN_CO","R")
      return(.f.)
   ENDIF
   SELECT U_CAN_CO
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_CAN_CO
      APPEND BLANK
      GATHER MEMVAR MEMO
      V_NUMORC = V_NUMORC + 1
      SELECT U_CAN_CO
      REPLACE ORF_FLGTRA WITH .T.
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_CAN_CO","W")
      return(.f.)
   ENDIF

   *===> Bolle di trasferimento da sede a pdv da ritornare al pdv

   x_fla1 = "orf_flgtra = 0"
   x_cpdv = "orf_codpdv = '" + ALLTRIM(X_CODPDV) + "'"
   x_fla2 = "orf_flgcon = 1"
   x_cond = x_fla1 + " and " + x_cpdv + " and " + x_fla2
   Csql = "Select * from u_orf_co where " + x_cond
   IF !ExecRW(Csql,"U_ORF_CO","R")
      return(.f.)
   ENDIF
   SELECT U_ORF_CO
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_ORF_CO
      APPEND BLANK
      GATHER MEMVAR MEMO
      
      x_soci = "mag_codsoc = '" + ALLTRIM(PUB_CODSOC) + "'"
      x_maga = "mag_codmag = '" + ALLTRIM(M.ORF_MAGSCA) + "'"
      x_arti = "mag_codart = '" + ALLTRIM(M.ORF_CODART) + "'"
      x_forn = "mag_fornit = '" + ALLTRIM(M.ORF_CODFOR) + "'"
      x_cacq = "mag_codacq = '" + ALLTRIM(M.ORF_CODACQ) + "'"
      x_nide = "mag_numide = '" + ALLTRIM(M.ORF_NUMIDE) + "'"
      x_cbun = "mag_codbun = '" + ALLTRIM(M.ORF_CODBUN) + "'"
      x_anno = "mag_anno = '" + ALLTRIM(M.ORF_ANNSCA) + "'"
      x_data = "mag_datagg = '" + ALLTRIM(M.ORF_DATSCA) + "'"
      x_przc = "mag_przcon = " + ALLTRIM(STR(M.ORF_PRZACQ,17,6))
      x_przc = STRTRAN(x_przc,',','.')
      x_cond = x_soci + " and " + x_maga + " and " + x_arti + " and " + x_forn + " and " + x_cacq + " and " + x_nide + " and " + ;
               x_cbun + " and " + x_anno + " and " + x_data + " and " + x_przc
      cSql   = "select * from u_mag_cp where " + x_cond
      IF !ExecCommand(cSql,'CUR_MAG_CP')
         return(.f.)
      ENDIF
      SELECT CUR_MAG_CP
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         x_soci = "mag_codsoc = '" + ALLTRIM(PUB_CODSOC) + "'"
         x_maga = "mag_codmag = '" + ALLTRIM(M.ORF_CODMAG) + "'"
         x_arti = "mag_codart = '" + ALLTRIM(M.ORF_CODART) + "'"
         x_forn = "mag_fornit = '" + ALLTRIM(M.ORF_CODFOR) + "'"
         x_cacq = "mag_codacq = '" + ALLTRIM(M.ORF_CODACQ) + "'"
         x_nide = "mag_numide = '" + ALLTRIM(M.ORF_NUMIDE) + "'"
         x_cbun = "mag_codbun = '" + ALLTRIM(M.ORF_CODBUN) + "'"
         x_anno = "mag_anno = '" + ALLTRIM(M.ORF_ANNSCA) + "'"
         x_data = "mag_datagg = '" + ALLTRIM(M.ORF_DATSCA) + "'"
         x_przc = "mag_przcon = " + ALLTRIM(STR(M.ORF_PRZACQ,17,6))
         x_przc = STRTRAN(x_przc,',','.')
         x_cond = x_soci + " and " + x_maga + " and " + x_arti + " and " + x_forn + " and " + x_cacq + " and " + x_nide + " and " + ;
                  x_cbun + " and " + x_anno + " and " + x_data + " and " + x_przc
         cSql   = "select * from u_mag_cp where " + x_cond
         IF !ExecRW(cSql,'U_MAG_CP','R')
            return(.f.)
         ENDIF
         SELECT U_MAG_CP
         GO TOP
         IF EOF()
            APPEND BLANK
         ELSE
            SCATTER MEMVAR MEMO
         ENDIF
         SELECT U_MAG_CP
         M.MAG_CODMAG = M.ORF_CODMAG
         M.MAG_CODPDV = M.ORF_CODMAG
         M.MAG_FLGTRA = .F.
         DO U_MAG_GG
         IF !ExecRW(cSql,'U_MAG_CP','W')
            return(.f.)
         ENDIF
         SELECT CUR_MAG_CP
         SKIP +1
      ENDDO         
                 
      V_NUMCOF = V_NUMCOF + 1
      SELECT U_ORF_CO
      REPLACE ORF_FLGTRA WITH .T.
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_ORF_CO","W")
      return(.f.)
   ENDIF

   *===> Proposte d'ordini della sede

   x_flgt = "ord_flgtra = 0"
   x_flgc = "ord_flgcon = 1"
   x_make = "ord_makeda = 'SEDE'"
   x_cpdv = "ord_codbun = '" + ALLTRIM(X_CODPDV) + "'"
   x_cond = x_flgt + " and " + x_flgc + " and " + x_make + " and " + x_cpdv 
   Csql   = "Select * from u_orf_tt where " + x_cond
   IF !ExecRW(Csql,"U_ORF_TT","R")
      return(.f.)
   ENDIF
   SELECT U_ORF_TT
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_ORF_TT
      APPEND BLANK
      GATHER MEMVAR MEMO
      V_NUMORF = V_NUMORF + 1
      V_SENDMSG = .T.
      x_cond = "daggancio = '" + ALLTRIM(M.TAGGANCIO) + "'"
      Csql   = "Select * from u_orf_dd where " + x_cond + " order by daggancio,ord_sequen"
      IF !ExecCommand(Csql,"U_ORF_DD")
         return(.f.)
      ENDIF
      SELECT U_ORF_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         SELECT CU_ORF_DD
         APPEND BLANK
         GATHER MEMVAR MEMO
         SELECT U_ORF_DD
         SKIP +1
      ENDDO
      SELECT U_ORF_TT
      REPLACE ORD_FLGTRA WITH .T.
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_ORF_TT","W")
      return(.f.)
   ENDIF

   *===> Pre-bolle di reso ai pdv

   x_flgt = "ord_flgtra = 0"
   x_flgc = "ord_flgcon = 1"
   x_cpdv = "ord_codbun = '" + ALLTRIM(X_CODPDV) + "'"
   x_cond = x_flgt + " and " + x_flgc + " and " + x_cpdv 
   Csql   = "Select * from u_prb_tt where " + x_cond
   IF !ExecRW(Csql,"U_PRB_TT","R")
      return(.f.)
   ENDIF
   SELECT U_PRB_TT
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_PRB_TT
      APPEND BLANK
      GATHER MEMVAR MEMO
      REPLACE ORD_CONSED WITH .T.
      V_NUMPRB = V_NUMPRB + 1
      V_SENDMSG = .T.
      x_cond = "daggancio = '" + ALLTRIM(M.TAGGANCIO) + "'"
      Csql   = "Select * from u_prb_dd where " + x_cond + " order by daggancio,ord_sequen"
      IF !ExecCommand(Csql,"U_PRB_DD")
         return(.f.)
      ENDIF
      SELECT U_PRB_DD
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         SCATTER MEMVAR MEMO
         SELECT CU_PRB_DD
         APPEND BLANK
         GATHER MEMVAR MEMO
         SELECT U_PRB_DD
         SKIP +1
      ENDDO
      SELECT U_PRB_TT
      REPLACE ORD_FLGTRA WITH .T.
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_PRB_TT","W")
      return(.f.)
   ENDIF

   *===> Autorizzazione alle spese

   x_flag = "pdv_flgtra = 0"
   x_cpdv = "pdv_codbun = '" + ALLTRIM(X_CODPDV) + "'"
   x_cond = x_flag + " and " + x_cpdv 
   Csql   = "Select * from u_pdv_au where " + x_cond
   IF !ExecRW(Csql,"U_PDV_AU","R")
      return(.f.)
   ENDIF
   SELECT U_PDV_AU
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_PDV_AU
      APPEND BLANK
      GATHER MEMVAR MEMO
      V_NUMAUT = V_NUMAUT + 1
      V_SENDMSG = .T.
      SELECT U_PDV_AU
      REPLACE PDV_FLGTRA WITH .T.
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_PDV_AU","W")
      return(.f.)
   ENDIF

   *===> Campagne sui prezzi di costo

   x_flag = "mag_flgtra = 0"
   x_cpdv = "mag_codmag = '" + ALLTRIM(X_CODPDV) + "'"
   x_cond = x_flag + " and " + x_cpdv 
   Csql   = "Select * from u_mag_cp where " + x_cond
   IF !ExecRW(Csql,"U_MAG_CP","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_CP
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_MAG_CP
      APPEND BLANK
      GATHER MEMVAR MEMO
      V_NUMMAC = V_NUMMAC + 1
      *V_SENDMSG = .T.
      SELECT U_MAG_CP
      REPLACE MAG_FLGTRA WITH .T.
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_MAG_CP","W")
      return(.f.)
   ENDIF

   *===> Giacenze dettagliate a livello di carico aggiornate del viaggiante proveniente dai pdv
   x_flag = "mag_flgvia = 1"
   x_cpdv = "mag_codpdv = '" + ALLTRIM(X_CODPDV) + "'"
   x_cond = x_flag + " and " + x_cpdv
   Csql   = "Select * from u_mag_gg where " + x_cond
   IF !ExecRW(Csql,"U_MAG_GG","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_GG
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_MAG_GG
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT U_MAG_GG
      REPLACE MAG_FLGVIA WITH .F.
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_MAG_GG","W")
      return(.f.)
   ENDIF

   *===> Giacenze dettagliate a livello di data aggiornate del viaggiante proveniente dai pdv
   x_flag = "mag_flgvia = 1"
   x_cpdv = "mag_codpdv = '" + ALLTRIM(X_CODPDV) + "'"
   x_cond = x_flag + " and " + x_cpdv
   Csql   = "Select * from u_mag_da where " + x_cond
   IF !ExecRW(Csql,"U_MAG_DA","R")
      return(.f.)
   ENDIF
   SELECT U_MAG_DA
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      SELECT CU_MAG_DA
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT U_MAG_DA
      REPLACE MAG_FLGVIA WITH .F.
      SKIP +1
   ENDDO
   IF !ExecRW(Csql,"U_MAG_DA","W")
      return(.f.)
   ENDIF

   *===> Messaggi automatici

   IF V_SENDMSG1 .OR. V_SENDMSG
      V_SENDMSG = .F.
      * Ricerca della descrizione del mittente 
      V_DESMIT = ""
      x_cond   = "pdv_codice = '" + ALLTRIM(PUB_CODBUN) + "'"
      Csql     = "select * from u_pdv_an where " + x_cond
      IF !ExecCommand(Csql,"CU_PDV_AN")
         return(.f.)
      ENDIF
      SELECT CU_PDV_AN
      GO TOP
      IF EOF()
      ELSE
         V_DESMIT = PDV_DESCRI
      ENDIF         
      * Ricerca del codice e descrizione del destinatario 
      V_CODDES = ALLTRIM(X_CODPDV)
      V_DESDES = ""
      x_cond   = "pdv_codice = '" + ALLTRIM(X_CODPDV) + "'"
      Csql     = "select * from u_pdv_an where " + x_cond
      IF !ExecCommand(Csql,"CU_PDV_AN")
         return(.f.)
      ENDIF
      SELECT CU_PDV_AN
      GO TOP
      IF EOF()
      ELSE
         V_DESDES = PDV_DESCRI
      ENDIF         
      * Composizione del testo automatico in base ai dati trasferiti
      V_TESTO  = ""
      V_GEN = "Dati trasferiti : " + CHR(13)
      V_ART = "Anagr. Articoli = " + ALLTRIM(STR(V_NUMART,7,0))
      V_CLI = "Anagr. Clienti = " + ALLTRIM(STR(V_NUMCLI,7,0))
      V_FOR = "Anagr. Fornitori = " + ALLTRIM(STR(V_NUMFOR,7,0))
      V_FPR = "Fornitori preferenziali = " + ALLTRIM(STR(V_NUMFPR,7,0))
      V_LIS = "Listini di vendita = " + ALLTRIM(STR(V_NUMLIS,7,0))
      V_ORF = "Proposte d'ordine = " + ALLTRIM(STR(V_NUMORF,7,0))
      V_PRB = "Pre-Bolle di reso da sede a pdv = " + ALLTRIM(STR(V_NUMPRB,7,0))
      V_AUT = "Autor. alle spese = " + ALLTRIM(STR(V_NUMAUT,7,0))
      V_MAC = "Campagne sui prezzi di costo = " + ALLTRIM(STR(V_NUMMAC,7,0))
      V_TESTO = V_GEN
      *IF V_NUMART > 0
      *   V_TESTO = V_TESTO + V_ART + CHR(13)
      *ENDIF
      *IF V_NUMCLI > 0
      *   V_TESTO = V_TESTO + V_CLI + CHR(13)
      *ENDIF
      *IF V_NUMFOR > 0
      *   V_TESTO = V_TESTO + V_FOR + CHR(13)
      *ENDIF
      *IF V_NUMFPR > 0
      *   V_TESTO = V_TESTO + V_FPR + CHR(13)
      *ENDIF
      *IF V_NUMLIS > 0
      *   V_TESTO = V_TESTO + V_LIS + CHR(13)
      *ENDIF
      IF V_NUMORF > 0
         V_TESTO = V_TESTO + V_ORF + CHR(13)
      ENDIF
      IF V_NUMPRB > 0
         V_TESTO = V_TESTO + V_PRB + CHR(13)
      ENDIF
      IF V_NUMAUT > 0
         V_TESTO = V_TESTO + V_AUT + CHR(13)
      ENDIF
      *IF V_NUMMAC > 0
      *   V_TESTO = V_TESTO + V_MAC + CHR(13)
      *ENDIF
      Csql = "Select * from u_msg_au where 1=0"
      IF !ExecRW(Csql,"U_MSG_AU","R")
         return(.f.)
      ENDIF
      SELECT U_MSG_AU
      APPEND BLANK
      REPLACE MSG_CODSOC WITH PUB_CODSOC
      REPLACE MSG_CODMIT WITH PUB_CODBUN
      REPLACE MSG_DESMIT WITH V_DESMIT
      REPLACE MSG_CODOPE WITH "AUTO"
      REPLACE MSG_DESOPE WITH "AUTOMATICO"
      REPLACE MSG_CODDES WITH V_CODDES
      REPLACE MSG_DESDES WITH V_DESDES
      REPLACE MSG_DATINV WITH RIBALTA2(DTOC(DATE()))
      REPLACE MSG_ORAINV WITH TIME()
      REPLACE MSG_FLGTRA WITH .F.
      REPLACE MSG_FLGCON WITH .T.
      REPLACE MSG_FLGRIC WITH .F.
      REPLACE MSG_FLGLET WITH .F.
      REPLACE MSG_TESTO  WITH V_TESTO
      IF !ExecRW(Csql,"U_MSG_AU","W")
         return(.f.)
      ENDIF
   ENDIF   

   x_flag = "msg_flgtra = 0 and msg_flgcon = 1"
   x_cond = x_flag 
   Csql   = "Select * from u_msg_au where " + x_cond
   IF !ExecCommand(Csql,"U_MSG_AU")
      return(.f.)
   ENDIF
   SELECT U_MSG_AU
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      SCATTER MEMVAR MEMO
      V_TRO = .F.
      IF ALLTRIM(MSG_CODDES) = '999'
         V_TRO = .T.
      ELSE 
         IF EMPTY(ALLTRIM(MSG_CODDES)) 
            V_COD = ""
            V_IND = 1
            V_TRO = .F.
            V_MAX = LEN(ALLTRIM(M.MSG_DESDES))
            DO WHILE .T.
               IF V_IND > V_MAX
                  EXIT
               ENDIF
               IF SUBSTR(MSG_DESDES,V_IND,1) = '-'
                  IF V_COD = ALLTRIM(X_CODPDV)
                     V_TRO = .T.
                     EXIT
                  ENDIF
                  V_IND = V_IND + 1
                  V_COD = ""
                  LOOP
               ENDIF
               V_COD = V_COD + SUBSTR(MSG_DESDES,V_IND,1)
               V_IND = V_IND + 1
            ENDDO
         ELSE
            IF ALLTRIM(M.MSG_CODDES) = ALLTRIM(X_CODPDV)
               V_TRO = .T.
            ENDIF
         ENDIF
      ENDIF
      IF V_TRO
      ELSE
         SKIP +1
         LOOP
      ENDIF
      SELECT CU_MSG_AU
      APPEND BLANK
      GATHER MEMVAR MEMO
      V_NUMMSG = V_NUMMSG + 1
      SELECT U_MSG_AU
      SKIP +1
   ENDDO

   *===> Copia dei cursori nella directory prevista per la trasmissione delle tabelle fox

   _trasmetti = V_DIR_COPY + "\P_ART_PR"
   SELECT CU_ART_PR
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_CLI_AN"
   SELECT CU_CLI_AN
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_FOR_AN"
   SELECT CU_FOR_AN
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_LIS_TA"
   SELECT CU_LIS_TA
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_LIS_TT"
   SELECT CU_LIS_TT
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_LIS_LG"
   SELECT CU_LIS_LG
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF
   
   _trasmetti = V_DIR_COPY + "\P_FOR_PR"
   SELECT CU_FOR_PR
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_ORF_PO"
   SELECT CU_ORF_PO
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_CAN_CO"
   SELECT CU_CAN_CO
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_ORF_CO"
   SELECT CU_ORF_CO
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_ORF_TT"
   SELECT CU_ORF_TT
   IF EOF()
   ELSE
      COPY TO &_trasmetti
      _trasmetti = V_DIR_COPY + "\P_ORF_DD"
      SELECT CU_ORF_DD
      IF EOF()
      ELSE
         COPY TO &_trasmetti
      ENDIF
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_PRB_TT"
   SELECT CU_PRB_TT
   IF EOF()
   ELSE
      COPY TO &_trasmetti
      _trasmetti = V_DIR_COPY + "\P_PRB_DD"
      SELECT CU_PRB_DD
      IF EOF()
      ELSE
         COPY TO &_trasmetti
      ENDIF
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_PDV_AU"
   SELECT CU_PDV_AU
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_MAG_CP"
   SELECT CU_MAG_CP
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_MAG_GG"
   SELECT CU_MAG_GG
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_MAG_DA"
   SELECT CU_MAG_DA
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   _trasmetti = V_DIR_COPY + "\P_MSG_AU"
   SELECT CU_MSG_AU
   IF EOF()
   ELSE
      COPY TO &_trasmetti
   ENDIF

   SET DEFAULT TO &V_DIR_COPY

   ERASE SEMAFORO.SED

   SELECT U_FTP_AN
   SKIP +1
   
ENDDO

x_flag = "msg_flgtra = 0 and msg_flgcon = 1"
x_cond = x_flag 
Csql   = "Select * from u_msg_au where " + x_cond
IF !ExecRW(Csql,"U_MSG_AU","R")
   return(.f.)
ENDIF
SELECT U_MSG_AU
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   REPLACE MSG_FLGTRA WITH .T.
   SKIP +1
ENDDO
IF !ExecRW(Csql,"U_MSG_AU","W")
   return(.f.)
ENDIF

SET DEFAULT TO &V_SONOQUI

RETURN


************************************************************************
PROCEDURE U_MAG_GG
***********************************************************************
REPLACE MAG_CODSOC WITH M.MAG_CODSOC
REPLACE MAG_DATAGG WITH M.MAG_DATAGG
REPLACE MAG_CODART WITH M.MAG_CODART 
REPLACE MAG_DESART WITH M.MAG_DESART
REPLACE MAG_CODMAG WITH M.MAG_CODMAG
REPLACE MAG_CODPDV WITH M.MAG_CODPDV 
REPLACE MAG_FORNIT WITH M.MAG_FORNIT 
REPLACE MAG_DESFOR WITH M.MAG_DESFOR 
REPLACE MAG_GIACEN WITH M.MAG_GIACEN
REPLACE MAG_PRZCON WITH M.MAG_PRZCON
REPLACE SELEZIONE  WITH M.SELEZIONE
REPLACE MAG_LEGSYS WITH M.MAG_LEGSYS
REPLACE MAG_LEGAME WITH M.MAG_LEGAME
REPLACE MAG_CODACQ WITH M.MAG_CODACQ
REPLACE MAG_DESACQ WITH M.MAG_DESACQ
REPLACE MAG_PRZUFF WITH M.MAG_PRZUFF
REPLACE MAG_DATINI WITH M.MAG_DATINI
REPLACE MAG_DATFIN WITH M.MAG_DATFIN
REPLACE MAG_SC1    WITH M.MAG_SC1
REPLACE MAG_SC2    WITH M.MAG_SC2
REPLACE MAG_SC3    WITH M.MAG_SC3
REPLACE MAG_SC4    WITH M.MAG_SC4
REPLACE MAG_SC5    WITH M.MAG_SC5
REPLACE MAG_PRZSCO WITH M.MAG_PRZSCO
REPLACE MAG_PAGAME WITH M.MAG_PAGAME
REPLACE MAG_NUMIDE WITH M.MAG_NUMIDE
REPLACE MAG_CODBUN WITH M.MAG_CODBUN
REPLACE MAG_ANNO   WITH M.MAG_ANNO
REPLACE MAG_FLGTRA WITH M.MAG_FLGTRA
REPLACE MAG_UNIQUE WITH M.MAG_UNIQUE
REPLACE MAG_DATCAM WITH M.MAG_DATCAM
REPLACE MAG_NUMCAM WITH M.MAG_NUMCAM
REPLACE MAG_PRZFIS WITH M.MAG_PRZFIS
IF EMPTY(ALLTRIM(M.MAG_DATCAM)) .OR. M.MAG_DATCAM = '  /  /    '
   REPLACE MAG_DATCAM WITH SPACE(10)
ELSE 
   REPLACE MAG_DTCGMA WITH RIBALTA2(M.MAG_DATCAM)
ENDIF
IF EMPTY(ALLTRIM(M.MAG_DATINI)) .OR. M.MAG_DATINI = '  /  /    '
   REPLACE MAG_DTIGMA WITH SPACE(10)
ELSE 
   REPLACE MAG_DTIGMA WITH RIBALTA2(M.MAG_DATINI)
ENDIF
IF EMPTY(ALLTRIM(M.MAG_DATFIN)) .OR. M.MAG_DATFIN = '  /  /    '
   REPLACE MAG_DTFGMA WITH SPACE(10)
ELSE 
   REPLACE MAG_DTFGMA WITH RIBALTA2(M.MAG_DATFIN)
ENDIF
REPLACE MAG_FLGVIA WITH M.MAG_FLGVIA

RETURN
