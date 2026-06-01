-- ********************************************************************************
-- Inizializzazione archivi inventario
-- ********************************************************************************
DELETE FROM INVENTARIO
DELETE FROM U_ART_KO
DELETE FROM U_PDA_MO

-- ********************************************************************************
-- Inizializzazione archivi di magazzino
-- ********************************************************************************
DELETE FROM U_MAG_AN
DELETE FROM U_MAG_GG
DELETE FROM U_MAG_DA
DELETE FROM U_MAG_MO
DELETE FROM U_MAG_CA
DELETE FROM U_MAG_CP
DELETE FROM U_MAG_RI
DELETE FROM U_MAG_AR
DELETE FROM U_MAG_MA
DELETE FROM U_MAG_FO
DELETE FROM U_MAG_MF
DELETE FROM U_ALT_DA

-- ********************************************************************************
-- Inizializzazione archivi ordini a fornitori
-- ********************************************************************************
DELETE FROM U_ORF_TT
DELETE FROM U_ORF_DD
DELETE FROM U_ORF_DL

-- ********************************************************************************
-- Inizializzazione archivi carico da documenti fornitori
-- ********************************************************************************
DELETE FROM U_BFO_TT
DELETE FROM U_BFO_DD
DELETE FROM U_BFO_DL

-- ********************************************************************************
-- Inizializzazione archivi ordini clienti
-- ********************************************************************************
DELETE FROM U_ORD_TT
DELETE FROM U_ORD_DD
DELETE FROM U_ORD_DL

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


-- ********************************************************************************
-- Inizializzazione archivi fatture clienti
-- ********************************************************************************
DELETE FROM U_FAT_TT
DELETE FROM U_FAT_DD

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

-- ********************************************************************************
-- Inizializzazione archivi di programmazione produzione
-- ********************************************************************************
DELETE FROM U_PRG_SP
DELETE FROM U_PRG_RA
DELETE FROM U_PRG_DL
DELETE FROM U_PRG_DO
DELETE FROM U_PRG_SM
DELETE FROM U_PRO_IM
DELETE FROM U_PRG_RI
DELETE FROM U_PRG_RR
DELETE FROM U_PRG_TG
DELETE FROM U_PRG_RT
DELETE FROM U_LOT_RI
DELETE FROM U_PRG_CL

-- ********************************************************************************
-- Inizializzazione archivi di avanzamento produzione
-- ********************************************************************************
DELETE FROM U_AVA_SP
DELETE FROM U_AVA_SM
DELETE FROM U_AVA_RI
DELETE FROM U_AVA_TG

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
UPDATE U_CAL_LA SET CAL_GIAIMP = '  '

-- ********************************************************************************
-- Sistemazione autorizzazioni alle voci di menù (licenze)
-- ********************************************************************************
UPDATE TBL_MENU SET AUTORIZZAZIONE = 1


UPDATE PARA SET LIBERA = '6000000000' WHERE CODICE LIKE 'NUM%' AND SUBSTRING(CODICE,7,1) = ' ' 
UPDATE PARA SET LIBERA = '0000000000' WHERE CODICE LIKE 'NUM%' AND SUBSTRING(CODICE,7,1) = '0' AND CODICE <> 'NUMGAC01' AND CODICE <> 'NUMPRR01' AND CODICE <> 'NUMPRS01' AND CODICE <> 'NUMPRT01'


