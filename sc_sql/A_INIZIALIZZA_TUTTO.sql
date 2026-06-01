-- ********************************************************************************
-- Inizializzazione archivi anagrafiche
-- ********************************************************************************
DELETE FROM U_CLI_AN
DELETE FROM U_FOR_AN
DELETE FROM U_ART_PR
DELETE FROM U_ART_LE
DELETE FROM U_LOC_AN
DELETE FROM U_BAN_AN
DELETE FROM U_AGE_AN
DELETE FROM CONTATTI

-- ********************************************************************************
-- Inizializzazione archivi contabilità generale
-- ********************************************************************************
DELETE FROM CONTI
DELETE FROM CONTICA
DELETE FROM CONTIX
DELETE FROM CCOSTO
DELETE FROM CCOSTX
DELETE FROM INDICE
DELETE FROM MOV_CONT
DELETE FROM MOV_CCO
DELETE FROM PART_CLI
DELETE FROM PART_FOR
DELETE FROM SALDI_CLI
DELETE FROM SALDI_FOR
DELETE FROM CHIUSURA
DELETE FROM APEFOR
DELETE FROM APERTE
DELETE FROM APPOGGIO
DELETE FROM BILNEW
DELETE FROM SCADENZE
DELETE FROM SCAPOS_FOR

-- ********************************************************************************
-- Inizializzazione piani di pagamento
-- ********************************************************************************
DELETE FROM PIANOP_TT
DELETE FROM PIANOP_DD
DELETE FROM PIANOP_MO
DELETE FROM PIANOP_P1
DELETE FROM PIANOP_P2
DELETE FROM PIANOP_SA

-- ********************************************************************************
-- Inizializzazione ammortamenti
-- ********************************************************************************
DELETE FROM U_AMM_TT
DELETE FROM U_AMM_DD
DELETE FROM U_AMM_PE

-- ********************************************************************************
-- Inizializzazione archivi iva
-- ********************************************************************************
DELETE FROM U_IVA_CL
DELETE FROM U_IVA_CO
DELETE FROM U_IVA_CR
DELETE FROM U_IVA_TO
DELETE FROM U_IVF_CL

-- ********************************************************************************
-- Inizializzazione archivi listini
-- ********************************************************************************
DELETE FROM U_LIS_TT
DELETE FROM U_LIC_AN
DELETE FROM U_LIF_TT
DELETE FROM U_LIS_AG
DELETE FROM U_LIS_AL
DELETE FROM U_LIS_LG
DELETE FROM U_LIS_LI
DELETE FROM U_LIS_PA
DELETE FROM U_LIS_TA
DELETE FROM U_LIS_VE

-- ********************************************************************************
-- Inizializzazione archivi provvigioni
-- ********************************************************************************
DELETE FROM U_PRV_AN
DELETE FROM U_PRV_DD
DELETE FROM U_PRV_OR
DELETE FROM PROV_STO

-- ********************************************************************************
-- Inizializzazione archivi documenti cartacei
-- ********************************************************************************
DELETE FROM U_AST_AN

-- ********************************************************************************
-- Inizializzazione archivi cartelle sanitarie
-- ********************************************************************************
DELETE FROM U_CAS_TT
DELETE FROM U_CAS_DD
DELETE FROM U_CAS_AN

-- ********************************************************************************
-- Inizializzazione archivi dei log
-- ********************************************************************************
DELETE FROM LOG_AGE
DELETE FROM LOG_CONT
DELETE FROM LOG_REI
DELETE FROM LOG_RETE
DELETE FROM LOG_USER
DELETE FROM LOGERROR

-- ********************************************************************************
-- Inizializzazione archivi project
-- ********************************************************************************
DELETE FROM PJ_CON_TR
DELETE FROM PJ_SPOOL
DELETE FROM PJDBPROC
DELETE FROM PJMAIL
DELETE FROM PJMESSAG
DELETE FROM PJTIPREP

-- ********************************************************************************
-- Inizializzazione archivi vari
-- ********************************************************************************
DELETE FROM NOTE_COM
DELETE FROM MAILING
DELETE FROM ANAART
DELETE FROM ANACLFO
DELETE FROM ART_TRA
DELETE FROM CBI_LOG
DELETE FROM CBI_ORDINE
DELETE FROM CBI_STRU
DELETE FROM CBIEP
DELETE FROM CBIEP10
DELETE FROM CBIEP20
DELETE FROM CBIEP30
DELETE FROM CBIEP70
DELETE FROM CBIEPEF
DELETE FROM CBIPC
DELETE FROM CBIPC10
DELETE FROM CBIPC20
DELETE FROM CBIPC30
DELETE FROM CBIPC40
DELETE FROM CBIPC50
DELETE FROM CBIPC60
DELETE FROM CBIPC70
DELETE FROM CBIPCEF
DELETE FROM CBIRH
DELETE FROM CBIRH61
DELETE FROM CBIRH62
DELETE FROM CBIRH63
DELETE FROM CBIRH64
DELETE FROM CBIRH65
DELETE FROM CBIRHEF
DELETE FROM CLIENTI
DELETE FROM COMMESSE
DELETE FROM CORPO
DELETE FROM CORPO2
DELETE FROM CPJ
DELETE FROM CPJBEBE
DELETE FROM CPJCAR
DELETE FROM CPJCLA
DELETE FROM CPJCRI
DELETE FROM CPJDAV
DELETE FROM CPJFAU
DELETE FROM CPJFLA
DELETE FROM CPJMAX
DELETE FROM CPJMOR
DELETE FROM CPJQ
DELETE FROM CPJSER
DELETE FROM D
DELETE FROM DATI
DELETE FROM DISEGNI
DELETE FROM DOPPI
DELETE FROM ELENTAR
DELETE FROM EUROLOG
DELETE FROM FPSMOVC
DELETE FROM INDMACC
DELETE FROM INDPROD
DELETE FROM JOURNA_O
DELETE FROM JOURNA_R
DELETE FROM JOURNAL
DELETE FROM L_CMC_IM
DELETE FROM L_CMC_IS
DELETE FROM L_CMD_IM
DELETE FROM L_CMD_IS
DELETE FROM M1999
DELETE FROM MACCHINE
DELETE FROM MAG_TRA
DELETE FROM MAGAZMP
DELETE FROM MAGAZPF
DELETE FROM MENUOLD
DELETE FROM MKDUEPJ
DELETE FROM MO_CONCA
DELETE FROM MOVSTALL
DELETE FROM NEW_PARA
DELETE FROM PARA1
DELETE FROM PARACONF
DELETE FROM PARAX
DELETE FROM PARTFOR
DELETE FROM PIPPO
DELETE FROM PRODOTTI
DELETE FROM PROVA
DELETE FROM PROVVI
DELETE FROM RICE
DELETE FROM S_COM_ET
DELETE FROM S_COM_ED
DELETE FROM S_ORF_ED
DELETE FROM SCHE_CLI
DELETE FROM SDF
DELETE FROM SERG
DELETE FROM SERGIO
DELETE FROM STARTEUR
DELETE FROM SU_PRV_AN
DELETE FROM TAB_CAUCONT
DELETE FROM TAB_CLIENTI
DELETE FROM TAB_CONTI
DELETE FROM TAB_FORNITORI
DELETE FROM TAB_PARTAPERTE
DELETE FROM TAB_PRIMANOTA
DELETE FROM TAB_SPEDRESI
DELETE FROM TAB_TOPCONT
DELETE FROM TAB_VEN_FA
DELETE FROM TAB_VEN_FP
DELETE FROM TAB_VEN_FPA
DELETE FROM TABULA
DELETE FROM TEMPO

-- ********************************************************************************
-- Inizializzazione archivi gestionali vari
-- ********************************************************************************
DELETE FROM U_AGN_AN
DELETE FROM U_ASC_TT
DELETE FROM U_ASC_DD
DELETE FROM U_ATT_OP
DELETE FROM U_AUT_AN
DELETE FROM U_BEN_BE
DELETE FROM U_BLI_TT
DELETE FROM U_BLI_DD
DELETE FROM U_BLU_TT
DELETE FROM U_BLU_DD
DELETE FROM U_BLU_RF
DELETE FROM U_BOF_TT
DELETE FROM U_BOF_DD
DELETE FROM U_BUD_AN
DELETE FROM U_CAM_AN
DELETE FROM U_CAN_CA
DELETE FROM U_CAN_CO
DELETE FROM U_CAN_RE
DELETE FROM U_CAR_AN
DELETE FROM U_CER_AN
DELETE FROM U_CER_MO
DELETE FROM U_CLI_AG
DELETE FROM U_CLI_AS
DELETE FROM U_CLI_FI
DELETE FROM U_CLI_OP
DELETE FROM U_CLI_PA
DELETE FROM U_CMC_AN
DELETE FROM U_CMD_AN
DELETE FROM U_CMP_TT
DELETE FROM U_CNT_AN
DELETE FROM U_CNT_DD
DELETE FROM U_CNT_PR
DELETE FROM U_CNT_TT
DELETE FROM U_COR_TT
DELETE FROM U_CTL_TT
DELETE FROM U_CTL_DD
DELETE FROM U_DSB_AN
DELETE FROM U_ELA_AN
DELETE FROM U_ELA_ER
DELETE FROM U_ERR_RC
DELETE FROM U_ERR_TR
DELETE FROM U_EXC_EL
DELETE FROM U_FAG_TT
DELETE FROM U_FAG_DD
DELETE FROM U_FAM_TT
DELETE FROM U_FAM_DD
DELETE FROM U_FID_TT
DELETE FROM U_FID_DD
DELETE FROM U_FIN_AN
DELETE FROM U_FIN_TT
DELETE FROM U_FIN_DD
DELETE FROM U_FOR_TT
DELETE FROM U_FOR_DD
DELETE FROM U_FOR_PR
DELETE FROM U_FTP_AN
DELETE FROM U_GPE_AN
DELETE FROM U_IMB_TB
DELETE FROM U_INC_AN
DELETE FROM U_INS_AN
DELETE FROM U_INT_AN
DELETE FROM U_INT_TT
DELETE FROM U_LEG_DD
DELETE FROM U_LEG_DO
DELETE FROM U_LOC_GE
DELETE FROM U_LOC_GI
DELETE FROM U_LOC_MO
DELETE FROM U_LOG_TL
DELETE FROM U_LOT_RI
DELETE FROM U_MAC_AN
DELETE FROM U_MAC_TT
DELETE FROM U_MAC_DD
DELETE FROM U_MAC_ST
DELETE FROM U_MAN_CO
DELETE FROM U_MAN_TT
DELETE FROM U_MAN_DD
DELETE FROM U_MAR_AN
DELETE FROM U_MDC_AN
DELETE FROM U_MDC_ST
DELETE FROM U_MEN_TT
DELETE FROM U_MEN_DD
DELETE FROM U_MON_CA
DELETE FROM U_MON_PE
DELETE FROM U_MRI_TT
DELETE FROM U_MRI_DD
DELETE FROM U_MSG_AU
DELETE FROM U_OPE_AN
DELETE FROM U_ORE_AN
DELETE FROM U_ORM_TT
DELETE FROM U_ORM_DD
DELETE FROM U_PAG_AN
DELETE FROM U_PAL_AN
DELETE FROM U_PAP_AN
DELETE FROM U_PAR_CQ
DELETE FROM U_PAR_CT
DELETE FROM U_PAR_FI
DELETE FROM U_PAR_MY
DELETE FROM U_PES_VE
DELETE FROM U_PFO_TT
DELETE FROM U_PFO_DD
DELETE FROM U_PNC_BU
DELETE FROM U_PNC_SA
DELETE FROM U_POR_EF
DELETE FROM U_POS_AN
DELETE FROM U_PRB_TT
DELETE FROM U_PRB_DD
DELETE FROM U_PRE_AN
DELETE FROM U_PRF_TT
DELETE FROM U_PRF_DD
DELETE FROM U_RAP_SP
DELETE FROM U_RET_AN
DELETE FROM U_RET_CE
DELETE FROM U_RIC_AN
DELETE FROM U_RIC_TT
DELETE FROM U_RIC_DD
DELETE FROM U_RIC_VA
DELETE FROM U_RID_AN
DELETE FROM U_RIM_TT
DELETE FROM U_RIM_DD
DELETE FROM U_RIN_TT
DELETE FROM U_RIN_DD
DELETE FROM U_RIN_AN
DELETE FROM U_SCA_AN
DELETE FROM U_SCA_MA
DELETE FROM U_SCO_MI
DELETE FROM U_SIC_PA
DELETE FROM U_SIT_AN
DELETE FROM U_SPE_TT
DELETE FROM U_SPE_DD
DELETE FROM U_SPI_AN
DELETE FROM U_STA_AN
DELETE FROM U_STA_TT
DELETE FROM U_STA_DD
DELETE FROM U_STA_ST
DELETE FROM U_STA_SD
DELETE FROM U_STC_AN
DELETE FROM U_SYS_CO
DELETE FROM U_TES_AN
DELETE FROM U_TOP_TT
DELETE FROM U_TVE_TT
DELETE FROM U_TVE_DD
DELETE FROM U_TVE_SD
DELETE FROM U_TVE_ST
DELETE FROM U_VER_TT
DELETE FROM U_VER_DD
DELETE FROM U_VIS_AN
DELETE FROM U_WRK_TT
DELETE FROM U_WRK_DD
DELETE FROM U_WRK_ST
DELETE FROM U_WRK_SD
DELETE FROM U_XLS_AN
DELETE FROM U_XLS_TT
DELETE FROM U_XLS_DD
DELETE FROM U_XLS_RP
DELETE FROM UCLIAN
DELETE FROM ZONET_VE
DELETE FROM U_NCR_TT
DELETE FROM U_NCR_DD
DELETE FROM U_RIC_TT
DELETE FROM U_RIC_DD
DELETE FROM U_RIC_AN
DELETE FROM U_RIA_TT
DELETE FROM U_RIA_DD
DELETE FROM U_RAA_TT
DELETE FROM U_RAA_DD
DELETE FROM U_TVE_TT
DELETE FROM U_TVE_DD
DELETE FROM U_CEI_TT
DELETE FROM U_CEI_DD
DELETE FROM U_CEA_TT
DELETE FROM U_CEA_DD

-- ********************************************************************************
-- Inizializzazione archivi assegni
-- ********************************************************************************
DELETE FROM U_ASS_TT
DELETE FROM U_ASS_DD

-- ********************************************************************************
-- Inizializzazione archivi contratti
-- ********************************************************************************
DELETE FROM U_CON_AN
DELETE FROM U_CON_DD
DELETE FROM U_CON_PE
DELETE FROM U_CON_TR
DELETE FROM U_CON_TT
DELETE FROM U_CON_VE

-- ********************************************************************************
-- Inizializzazione archivi effetti
-- ********************************************************************************
DELETE FROM U_EFF_TT
DELETE FROM U_EFF_DD
DELETE FROM U_EFF_PA

-- ********************************************************************************
-- Inizializzazione archivi leasing
-- ********************************************************************************
DELETE FROM U_LEA_TT
DELETE FROM U_LEA_DD

-- ********************************************************************************
-- Inizializzazione archivi centri di costo
-- ********************************************************************************
DELETE FROM U_CCO_TT
DELETE FROM U_CCO_DD
DELETE FROM U_CCO_GR
DELETE FROM U_CCO_LE

-- ********************************************************************************
-- Inizializzazione archivi cicli di lavoro
-- ********************************************************************************
DELETE FROM U_CIC_TT
DELETE FROM U_CIC_DD

-- ********************************************************************************
-- Inizializzazione archivi distinte basi
-- ********************************************************************************
DELETE FROM U_DIS_AN
DELETE FROM U_DIS_TT
DELETE FROM U_DIS_DD

-- ********************************************************************************
-- Inizializzazione archivi commesse di produzione
-- ********************************************************************************
DELETE FROM U_COM_AN
DELETE FROM U_COM_DD
DELETE FROM U_COM_ED
DELETE FROM U_COM_ET
DELETE FROM U_COM_PE
DELETE FROM U_COM_TT

-- ********************************************************************************
-- Inizializzazione archivi punti di vendita
-- ********************************************************************************
DELETE FROM U_PDV_AN
DELETE FROM U_PDV_AU
DELETE FROM U_PDV_BA
DELETE FROM U_PDV_CA
DELETE FROM U_PDV_CC
DELETE FROM U_PDV_CD
DELETE FROM U_PDV_CN
DELETE FROM U_PDV_IN
DELETE FROM U_PDV_OP
DELETE FROM U_PDV_PA
DELETE FROM U_PDV_SA
DELETE FROM U_PDV_SC

-- ********************************************************************************
-- Inizializzazione archivi personale
-- ********************************************************************************
DELETE FROM U_PER_AN
DELETE FROM U_PER_CO
DELETE FROM U_PER_CP
DELETE FROM U_PER_PD


-- ********************************************************************************
-- Inizializzazione archivi inventario
-- ********************************************************************************
DELETE FROM INVENTARIO
DELETE FROM U_ART_KO
DELETE FROM U_PDA_MO
DELETE FROM U_PDA_CA
DELETE FROM U_PDA_LO
DELETE FROM U_PDA_MA
DELETE FROM U_INV_MA

-- ********************************************************************************
-- Inizializzazione archivi di magazzino
-- ********************************************************************************
DELETE FROM U_MAG_AN
DELETE FROM U_MAG_AR
DELETE FROM U_MAG_CA
DELETE FROM U_MAG_CL
DELETE FROM U_MAG_CP
DELETE FROM U_MAG_DA
DELETE FROM U_MAG_DF
DELETE FROM U_MAG_DM
DELETE FROM U_MAG_FO
DELETE FROM U_MAG_GG
DELETE FROM U_MAG_GS
DELETE FROM U_MAG_IN
DELETE FROM U_MAG_MA
DELETE FROM U_MAG_MF
DELETE FROM U_MAG_MO
DELETE FROM U_MAG_MS
DELETE FROM U_MAG_PR
DELETE FROM U_MAG_RI
DELETE FROM U_MAG_SA
DELETE FROM U_MAG_SS
DELETE FROM U_ALT_DA

-- ********************************************************************************
-- Inizializzazione archivi ordini a fornitori
-- ********************************************************************************
DELETE FROM U_ORF_TT
DELETE FROM U_ORF_DD
DELETE FROM U_ORF_DL
DELETE FROM U_ORF_CO
DELETE FROM U_ORF_DT
DELETE FROM U_ORF_ED
DELETE FROM U_ORF_PO
DELETE FROM U_ORF_SD
DELETE FROM U_ORF_ST


-- ********************************************************************************
-- Inizializzazione archivi carico da documenti fornitori
-- ********************************************************************************
DELETE FROM U_BFO_TT
DELETE FROM U_BFO_DD
DELETE FROM U_BFO_DL
DELETE FROM U_BFO_LE

-- ********************************************************************************
-- Inizializzazione archivi ordini clienti
-- ********************************************************************************
DELETE FROM U_ORD_TT
DELETE FROM U_ORD_DD
DELETE FROM U_ORD_DL
DELETE FROM U_ORD_ST
DELETE FROM U_ORD_SD

-- ********************************************************************************
-- Inizializzazione archivi packing list
-- ********************************************************************************
DELETE FROM U_PCK_TT
DELETE FROM U_PCK_DD
DELETE FROM U_PCK_LE

DELETE FROM U_PKG_TD
DELETE FROM U_PKG_LE

-- ********************************************************************************
-- Inizializzazione archivi bolle di evasione + pedane
-- ********************************************************************************
DELETE FROM U_BOL_TT
DELETE FROM U_BOL_DD
DELETE FROM U_PED_PL
DELETE FROM U_BOL_LE
DELETE FROM U_BOL_RE
DELETE FROM U_BOL_SD
DELETE FROM U_BOL_ST


-- ********************************************************************************
-- Inizializzazione archivi fatture clienti
-- ********************************************************************************
DELETE FROM U_FAT_TT
DELETE FROM U_FAT_DD
DELETE FROM U_FAT_SD
DELETE FROM U_FAT_ST

-- ********************************************************************************
-- Inizializzazione archivi fatture proforma clienti
-- ********************************************************************************
DELETE FROM U_FAP_TT
DELETE FROM U_FAP_DD

-- ********************************************************************************
-- Inizializzazione archivi offerte
-- ********************************************************************************
DELETE FROM U_OFF_TT
DELETE FROM U_OFF_DD
DELETE FROM U_OFF_SD
DELETE FROM U_OFF_ST

-- ********************************************************************************
-- Inizializzazione archivi di programmazione produzione
-- ********************************************************************************
DELETE FROM U_PRG_CL
DELETE FROM U_PRG_DL
DELETE FROM U_PRG_DO
DELETE FROM U_PRG_LT
DELETE FROM U_PRG_RA
DELETE FROM U_PRG_RI
DELETE FROM U_PRG_RR
DELETE FROM U_PRG_RT
DELETE FROM U_PRG_SM
DELETE FROM U_PRG_SP
DELETE FROM U_PRG_TG
DELETE FROM U_PRO_AL
DELETE FROM U_PRO_AN
DELETE FROM U_PRO_CA
DELETE FROM U_PRO_TT
DELETE FROM U_PRO_DD
DELETE FROM U_PRO_IM
DELETE FROM U_PRO_MY
DELETE FROM U_PRO_OR
DELETE FROM U_PRO_PZ
DELETE FROM U_PRO_ST
DELETE FROM U_LOT_RI

-- ********************************************************************************
-- Inizializzazione archivi di avanzamento produzione
-- ********************************************************************************
DELETE FROM U_AVA_SP
DELETE FROM U_AVA_SM
DELETE FROM U_AVA_RI
DELETE FROM U_AVA_TG
DELETE FROM U_AVA_CO
DELETE FROM U_AVA_MQ

-- ********************************************************************************
-- Inizializzazione archivi controllo qualità
-- ********************************************************************************
DELETE FROM U_MPA_CQ
DELETE FROM U_MPF_CQ
DELETE FROM U_SLF_CQ
DELETE FROM U_SLC_CQ

-- ********************************************************************************
-- Inizializzazione archivio dei riepiloghi venduto per anno/mese/cliente/fornitore
-- ********************************************************************************
DELETE FROM U_VEN_CL

-- ********************************************************************************
-- Aggiornamento campo già impegnato su calendario lavorativo
-- ********************************************************************************
DELETE FROM U_CAL_LA
DELETE FROM U_CAL_AS
DELETE FROM U_CAL_CO

-- ********************************************************************************
-- Sistemazione autorizzazioni alle voci di menù (licenze)
-- ********************************************************************************
UPDATE TBL_MENU SET AUTORIZZAZIONE = 1


UPDATE PARA SET LIBERA = '6000000000' WHERE CODICE LIKE 'NUM%' AND SUBSTRING(CODICE,7,1) = ' ' 
UPDATE PARA SET LIBERA = '0000000000' WHERE CODICE LIKE 'NUM%' AND SUBSTRING(CODICE,7,1) = '0' AND CODICE <> 'NUMGAC01' AND CODICE <> 'NUMPRR01' AND CODICE <> 'NUMPRS01' AND CODICE <> 'NUMPRT01'


