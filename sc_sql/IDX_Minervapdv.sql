-- ********************************************************************************
-- Indicizzazione tabella CCOSTO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index CCOSTO.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index CCOSTO.CONTO
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[CCOSTO]([CON_SOC], [CON_ANNO], [CON_DESCR]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[CCOSTO]([CON_SOC], [CON_ANNO], [CON_CONTO]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella CONTI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index CONTI.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index CONTI.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'ANNI')
   drop index CONTI.ANNI
GO
 
if exists (select name from dbo.sysindexes where name = 'PIVA')
   drop index CONTI.PIVA
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCON')
   drop index CONTI.DESCON
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[CONTI]([CON_SOC], [CON_ANNO], [CON_DESCR]) ON [PRIMARY]
GO
 
--CREATE UNIQUE INDEX [CONTO] ON [dbo].[CONTI]([CON_SOC], [CON_ANNO], [CON_CONTO]) ON [PRIMARY]
CREATE INDEX [CONTO] ON [dbo].[CONTI]([CON_SOC], [CON_ANNO], [CON_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [ANNI] ON [dbo].[CONTI]([CON_SOC], [CON_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [PIVA] ON [dbo].[CONTI]([CON_SOC], [CON_ANNO], [CON_PARIVA]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCON] ON [dbo].[CONTI]([CON_SOC], [CON_DESCR]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella LINGUE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'NAZIONE')
   drop index LINGUE.NAZIONE
GO
 
CREATE INDEX [NAZIONE] ON [dbo].[LINGUE]([CODSOC], [COD_NAZ], [TIPO_DOC]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella LOG_AGE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'AGENTE')
   drop index LOG_AGE.AGENTE
GO
 
CREATE INDEX [AGENTE] ON [dbo].[LOG_AGE]([CODAGE]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella LOG_CONT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'I_DATOPE')
   drop index LOG_CONT.I_DATOPE
GO
 
if exists (select name from dbo.sysindexes where name = 'I_POSOPE')
   drop index LOG_CONT.I_POSOPE
GO
 
if exists (select name from dbo.sysindexes where name = 'I_NOMOPE')
   drop index LOG_CONT.I_NOMOPE
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CODOPE')
   drop index LOG_CONT.I_CODOPE
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CODCON')
   drop index LOG_CONT.I_CODCON
GO
 
CREATE INDEX [I_DATOPE] ON [dbo].[LOG_CONT]([LOG_DATOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_POSOPE] ON [dbo].[LOG_CONT]([LOG_POSOPE], [LOG_DATOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_NOMOPE] ON [dbo].[LOG_CONT]([LOG_NOMOPE], [LOG_DATOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CODOPE] ON [dbo].[LOG_CONT]([LOG_CODOPE], [LOG_DATOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CODCON] ON [dbo].[LOG_CONT]([LOG_CODCON], [LOG_DATOPE]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella LOG_REI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index LOG_REI.CODICE
GO
 

CREATE INDEX [CODICE] ON [dbo].[LOG_REI]([GIORNO], [PROCEDURA]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella LOG_RETE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'I_DATOPE')
   drop index LOG_RETE.I_DATOPE
GO
 
if exists (select name from dbo.sysindexes where name = 'I_POSOPE')
   drop index LOG_RETE.I_POSOPE
GO
 
if exists (select name from dbo.sysindexes where name = 'I_NOMOPE')
   drop index LOG_RETE.I_NOMOPE
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CODOPE')
   drop index LOG_RETE.I_CODOPE
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CODCON')
   drop index LOG_RETE.I_CODCON
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CODSYS')
   drop index LOG_RETE.I_CODSYS
GO
 
if exists (select name from dbo.sysindexes where name = 'I_RISULT')
   drop index LOG_RETE.I_RISULT
GO
 
CREATE INDEX [I_DATOPE] ON [dbo].[LOG_RETE]([LOG_DATOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_POSOPE] ON [dbo].[LOG_RETE]([LOG_POSOPE], [LOG_DATOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_NOMOPE] ON [dbo].[LOG_RETE]([LOG_NOMOPE], [LOG_DATOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CODOPE] ON [dbo].[LOG_RETE]([LOG_CODOPE], [LOG_DATOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CODCON] ON [dbo].[LOG_RETE]([LOG_CODCON], [LOG_DATOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CODSYS] ON [dbo].[LOG_RETE]([LOG_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [I_RISULT] ON [dbo].[LOG_RETE]([LOG_RISULT]) ON [PRIMARY]
GO
 
-- ********************************************************************************
-- Indicizzazione tabella MENUOLD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'MENU')
   drop index MENUOLD.MENU
GO
 
CREATE INDEX [MENU] ON [dbo].[MENUOLD]([RES_DESCRI]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella MOV_CONT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index MOV_CONT.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index MOV_CONT.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMINTER')
   drop index MOV_CONT.NUMINTER
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_DTREG')
   drop index MOV_CONT.MOV_DTREG
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_NREGIS')
   drop index MOV_CONT.MOV_NREGIS
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_NDOC')
   drop index MOV_CONT.MOV_NDOC
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_NPROT')
   drop index MOV_CONT.MOV_NPROT
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCONTO')
   drop index MOV_CONT.DESCONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_DTDOC')
   drop index MOV_CONT.MOV_DTDOC
GO
 
CREATE INDEX [CONTO] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_CONTO], [MOV_DTREG], [MOV_NREGIS]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_DESMOV]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMINTER] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_NUMPRO]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_DTREG] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_DTREG], [MOV_NUMPRO]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_NREGIS] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_NREGIS]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_NDOC] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_NDOC]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_NPROT] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_NPROT]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCONTO] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_CONTO], [MOV_DESCR]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_DTDOC] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_DTDOC], [MOV_NDOC]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella NOTE_COM.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index NOTE_COM.CODICE
GO
 
CREATE INDEX [CODICE] ON [dbo].[NOTE_COM]([NOT_CODSOC], [NOT_CODICE]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella PARA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index PARA.CODICE
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCRI')
   drop index PARA.DESCRI
GO
 
if exists (select name from dbo.sysindexes where name = 'CODPRO')
   drop index PARA.CODPRO
GO
 
CREATE INDEX [CODICE] ON [dbo].[PARA]([CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCRI] ON [dbo].[PARA]([DESCRI]) ON [PRIMARY]
GO
 
CREATE INDEX [CODPRO] ON [dbo].[PARA]([CODICE], [LIBERA]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella PJMAIL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TAGGANCIO')
   drop index PJMAIL.TAGGANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'ULTIMO')
   drop index PJMAIL.ULTIMO
GO
 
CREATE INDEX [TAGGANCIO] ON [dbo].[PJMAIL]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [ULTIMO] ON [dbo].[PJMAIL]([OPERATORE], [TIPO], [STATO]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella PJTIPREP.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'COMPA')
   drop index PJTIPREP.COMPA
GO
 
if exists (select name from dbo.sysindexes where name = 'PROCE')
   drop index PJTIPREP.PROCE
GO
 
CREATE INDEX [COMPA] ON [dbo].[PJTIPREP]([COMPA], [NOMEPROC]) ON [PRIMARY]
GO
 
CREATE INDEX [PROCE] ON [dbo].[PJTIPREP]([NOMEPROC]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella RES_MENU.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RESVAR')
   drop index RES_MENU.RESVAR
GO
 
if exists (select name from dbo.sysindexes where name = 'RESPROG')
   drop index RES_MENU.RESPROG
GO
 
CREATE INDEX [RESVAR] ON [dbo].[RES_MENU]([RES_VAR]) ON [PRIMARY]
GO
 
CREATE INDEX [RESPROG] ON [dbo].[RES_MENU]([RES_PROG]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella RES_OPER.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index RES_OPER.CODICE
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCRI')
   drop index RES_OPER.DESCRI
GO
 
CREATE INDEX [CODICE] ON [dbo].[RES_OPER]([CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCRI] ON [dbo].[RES_OPER]([DESCRI]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella RES_PROC.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CHIAVE')
   drop index RES_PROC.CHIAVE
GO
 
CREATE INDEX [CHIAVE] ON [dbo].[RES_PROC]([UTENTE], [PROCEDURA]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_AGE_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_AGE_AN')
   drop index U_AGE_AN.U_AGE_AN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AGE_RS')
   drop index U_AGE_AN.U_AGE_RS
GO
 
CREATE INDEX [U_AGE_AN] ON [dbo].[U_AGE_AN]([AGE_CODSOC], [AGE_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AGE_RS] ON [dbo].[U_AGE_AN]([AGE_CODSOC], [AGE_RAGSOC]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ART_PR.DBF
-- ********************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_ART_01')
   drop index U_ART_PR.U_ART_01
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_02')
   drop index U_ART_PR.U_ART_02
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_03')
   drop index U_ART_PR.U_ART_03
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_04')
   drop index U_ART_PR.U_ART_04
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_05')
   drop index U_ART_PR.U_ART_05
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_06')
   drop index U_ART_PR.U_ART_06
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_07')
   drop index U_ART_PR.U_ART_07
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_08')
   drop index U_ART_PR.U_ART_08
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_09')
   drop index U_ART_PR.U_ART_09
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_10')
   drop index U_ART_PR.U_ART_10
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_11')
   drop index U_ART_PR.U_ART_11
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_12')
   drop index U_ART_PR.U_ART_12
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_13')
   drop index U_ART_PR.U_ART_13
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_14')
   drop index U_ART_PR.U_ART_14
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_15')
   drop index U_ART_PR.U_ART_15
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_16')
   drop index U_ART_PR.U_ART_16
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_17')
   drop index U_ART_PR.U_ART_17
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_18')
   drop index U_ART_PR.U_ART_18
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_19')
   drop index U_ART_PR.U_ART_19
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_20')
   drop index U_ART_PR.U_ART_20
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_21')
   drop index U_ART_PR.U_ART_21
GO

CREATE INDEX [U_ART_01] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_CODPRI]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_02] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_DESCR]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_03] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_DESEST]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_04] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_LINEA]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_05] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_COORD], [ART_CODPRI]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_06] ON [dbo].[U_ART_PR]([ART_DATVAR]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_07] ON [dbo].[U_ART_PR]([ART_CODPRI]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_08] ON [dbo].[U_ART_PR]([ART_CDISBN]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_09] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_CATMER], [ART_GRUEDI], [ART_EDITOR], [ART_COLLAN], [ART_AUTORE], [ART_ARGOME]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_10] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_GRUEDI], [ART_EDITOR], [ART_COLLAN], [ART_AUTORE], [ART_ARGOME]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_11] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_EDITOR], [ART_COLLAN], [ART_AUTORE], [ART_ARGOME]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_12] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_COLLAN], [ART_AUTORE], [ART_ARGOME]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_13] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_AUTORE], [ART_ARGOME]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_14] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_ARGOME]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_15] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_SCORMI]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_16] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_ULDSCA], [ART_ULDCAR]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_17] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_FLGMIM], [ART_CODPAC]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_18] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_FLGMIM], [ART_DESPAC]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_19] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_FLGMIM], [ART_SERNUM]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_20] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_FLGMIM], [ART_TIPCOM]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_21] ON [dbo].[U_ART_PR]([ART_FLGTRA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
-- Indicizzazione tabella U_AZI_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_AZI_AN')
   drop index U_AZI_AN.U_AZI_AN
GO
 
CREATE INDEX [U_AZI_AN] ON [dbo].[U_AZI_AN]([AZI_CODSOC]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BAN_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_BAN_CO')
   drop index U_BAN_AN.U_BAN_CO
GO
 
-- CREATE UNIQUE INDEX [U_BAN_CO] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_CODBAN]) ON [PRIMARY]
CREATE INDEX [U_BAN_CO] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_CODBAN]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BFO_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BFOHOOKD')
   drop index U_BFO_DD.BFOHOOKD
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_DA')
   drop index U_BFO_DD.U_BFO_DA
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_AM')
   drop index U_BFO_DD.U_BFO_AM
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_SY')
   drop index U_BFO_DD.U_BFO_SY
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_DO')
   drop index U_BFO_DD.U_BFO_DO
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_MR')
   drop index U_BFO_DD.U_BFO_MR
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_ML')
   drop index U_BFO_DD.U_BFO_ML
GO

CREATE INDEX [BFOHOOKD] ON [dbo].[U_BFO_DD]([DAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_DA] ON [dbo].[U_BFO_DD]([ORD_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_AM] ON [dbo].[U_BFO_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_SY] ON [dbo].[U_BFO_DD]([ORD_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_DO] ON [dbo].[U_BFO_DD]([ORS_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_MR] ON [dbo].[U_BFO_DD]([ORS_NUMORC], [ORS_DATORC], [ORS_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_ML] ON [dbo].[U_BFO_DD]([ORD_MAGA], [ORD_LEGSYS]) ON [PRIMARY]
GO
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BFO_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BFOHOOKT')
   drop index U_BFO_TT.BFOHOOKT
GO
if exists (select name from dbo.sysindexes where name = 'BFONDOCT')
   drop index U_BFO_TT.BFONDOCT
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_TD')
   drop index U_BFO_TT.U_BFO_TD
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_TC')
   drop index U_BFO_TT.U_BFO_TC
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_TA')
   drop index U_BFO_TT.U_BFO_TA
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_RG')
   drop index U_BFO_TT.U_BFO_RG
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_TT')
   drop index U_BFO_TT.U_BFO_TT
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_PV')
   drop index U_BFO_TT.U_BFO_PV
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_CC')
   drop index U_BFO_TT.U_BFO_CC
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_AA')
   drop index U_BFO_TT.U_BFO_AA
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_SY')
   drop index U_BFO_TT.U_BFO_SY
GO
 
CREATE INDEX [BFOHOOKT] ON [dbo].[U_BFO_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [BFONDOCT] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TD] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TC] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TA] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_RG] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TT] ON [dbo].[U_BFO_TT]([ORD_CODCLI], [ORD_NUMORD], [ORD_DATORD], [ORD_TIPDOC], [ORD_CODBUN]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_PV] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_CODBUN]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_CC] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_CODCCO]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_AA] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_TIPO], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_SY] ON [dbo].[U_BFO_TT]([ORD_CODSYS]) ON [PRIMARY]
GO
 
-- ********************************************************************************
-- Indicizzazione tabella U_BOL_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BOLHOOKD')
   drop index U_BOL_DD.BOLHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_DA')
   drop index U_BOL_DD.U_BOL_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_AM')
   drop index U_BOL_DD.U_BOL_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_SY')
   drop index U_BOL_DD.U_BOL_SY
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_DO')
   drop index U_BOL_DD.U_BOL_DO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_MR')
   drop index U_BOL_DD.U_BOL_MR
GO
 
CREATE INDEX [BOLHOOKD] ON [dbo].[U_BOL_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_DA] ON [dbo].[U_BOL_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_AM] ON [dbo].[U_BOL_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_SY] ON [dbo].[U_BOL_DD]([ORD_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_DO] ON [dbo].[U_BOL_DD]([ORS_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_MR] ON [dbo].[U_BOL_DD]([ORS_NUMORC], [ORS_DATORC], [ORS_CODCLI]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BOL_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BOLHOOKT')
   drop index U_BOL_TT.BOLHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'BOLNDOCT')
   drop index U_BOL_TT.BOLNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_TN')
   drop index U_BOL_TT.U_BOL_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_TD')
   drop index U_BOL_TT.U_BOL_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_TC')
   drop index U_BOL_TT.U_BOL_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_TA')
   drop index U_BOL_TT.U_BOL_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_DA')
   drop index U_BOL_TT.U_BOL_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_BOL_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_RG')
   drop index U_BOL_TT.U_BOL_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_BOL_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_SY')
   drop index U_BOL_TT.U_BOL_SY
GO
 
if exists (select name from dbo.sysindexes where name = 'FPS_INDICE')
   drop index U_BOL_TT.FPS_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'FPS_VETTO1')
   drop index U_BOL_TT.FPS_VETTO1
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_CC')
   drop index U_BOL_TT.U_BOL_CC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOL_OR')
   drop index U_BOL_TT.U_BOL_OR
GO
 
CREATE INDEX [BOLHOOKT] ON [dbo].[U_BOL_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [BOLNDOCT] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_TN] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_TD] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_TC] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_TA] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_DA] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_BOL_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_RG] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_BOL_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_SY] ON [dbo].[U_BOL_TT]([ORD_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [FPS_INDICE] ON [dbo].[U_BOL_TT]([ORD_DATORD], [ORD_NUMORD], [ORD_CODEMI], [ORD_TIPORD]) ON [PRIMARY]
GO
 
 
CREATE INDEX [U_BOL_CC] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOL_OR] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CLI_AG.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CLIENTE')
   drop index U_CLI_AG.CLIENTE
GO
 
if exists (select name from dbo.sysindexes where name = 'AGENTE')
   drop index U_CLI_AG.AGENTE
GO
 
if exists (select name from dbo.sysindexes where name = 'AGEASS')
   drop index U_CLI_AG.AGEASS
GO
 
CREATE INDEX [CLIENTE] ON [dbo].[U_CLI_AG]([CLI_CODSOC], [CLI_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [AGENTE] ON [dbo].[U_CLI_AG]([CLI_CODSOC], [CLI_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [AGEASS] ON [dbo].[U_CLI_AG]([CLI_CODSOC], [CLI_AGEASS]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CLI_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CLI_AN')
   drop index U_CLI_AN.U_CLI_AN
GO
if exists (select name from dbo.sysindexes where name = 'U_CLI_RG')
   drop index U_CLI_AN.U_CLI_RG
GO
if exists (select name from dbo.sysindexes where name = 'U_CLI_LO')
   drop index U_CLI_AN.U_CLI_LO
GO
if exists (select name from dbo.sysindexes where name = 'U_CLI_NA')
   drop index U_CLI_AN.U_CLI_NA
GO
if exists (select name from dbo.sysindexes where name = 'U_CLI_AG')
   drop index U_CLI_AN.U_CLI_AG
GO
if exists (select name from dbo.sysindexes where name = 'U_CLI_PI')
   drop index U_CLI_AN.U_CLI_PI
GO
if exists (select name from dbo.sysindexes where name = 'U_CLI_AL')
   drop index U_CLI_AN.U_CLI_AL
GO
if exists (select name from dbo.sysindexes where name = 'U_CLI_01')
   drop index U_CLI_AN.U_CLI_01
GO
 
-- CREATE UNIQUE INDEX [U_CLI_AN] ON [dbo].[U_CLI_AN]([CLI_CODSOC], [CLI_CODCLI]) ON [PRIMARY]
CREATE INDEX [U_CLI_AN] ON [dbo].[U_CLI_AN]([CLI_CODSOC], [CLI_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_RG] ON [dbo].[U_CLI_AN]([CLI_CODSOC], [CLI_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_LO] ON [dbo].[U_CLI_AN]([CLI_CODSOC], [CLI_LOCALI]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_NA] ON [dbo].[U_CLI_AN]([CLI_CODSOC], [CLI_NAZION]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_AG] ON [dbo].[U_CLI_AN]([CLI_CODSOC], [CLI_AGE], [CLI_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_PI] ON [dbo].[U_CLI_AN]([CLI_CODSOC], [CLI_PARIVA]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_AL] ON [dbo].[U_CLI_AN]([CLI_CODSOC], [CLI_RICERC]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_01] ON [dbo].[U_CLI_AN]([CLI_FLGTRA]) ON [PRIMARY]
GO
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CTL_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CTLHOOKD')
   drop index U_CTL_DD.CTLHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_DA')
   drop index U_CTL_DD.U_CTL_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'RIGART')
   drop index U_CTL_DD.RIGART
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_AM')
   drop index U_CTL_DD.U_CTL_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_DD')
   drop index U_CTL_DD.U_CTL_DD
GO
 
CREATE INDEX [CTLHOOKD] ON [dbo].[U_CTL_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_DA] ON [dbo].[U_CTL_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [RIGART] ON [dbo].[U_CTL_DD]([DAGGANCIO], [ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_AM] ON [dbo].[U_CTL_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_DD] ON [dbo].[U_CTL_DD]([DAGGANCIO], [ORD_CODART], [ORD_MAGA], [ORD_DATCON]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CTL_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CTLHOOKT')
   drop index U_CTL_TT.CTLHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'CTLNDOCT')
   drop index U_CTL_TT.CTLNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_TN')
   drop index U_CTL_TT.U_CTL_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_TD')
   drop index U_CTL_TT.U_CTL_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_TC')
   drop index U_CTL_TT.U_CTL_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_TA')
   drop index U_CTL_TT.U_CTL_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_RG')
   drop index U_CTL_TT.U_CTL_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_DA')
   drop index U_CTL_TT.U_CTL_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_CTL_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_TB')
   drop index U_CTL_TT.U_CTL_TB
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CTL_OR')
   drop index U_CTL_TT.U_CTL_OR
GO
 
CREATE INDEX [CTLHOOKT] ON [dbo].[U_CTL_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [CTLNDOCT] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_TN] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_TD] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_TC] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_TA] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_RG] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_DA] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_CTL_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_TB] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_NUMBOL]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_OR] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_DIS_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_DIS_DG')
   drop index U_DIS_DD.U_DIS_DG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_DIS_DA')
   drop index U_DIS_DD.U_DIS_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_DIS_DD')
   drop index U_DIS_DD.U_DIS_DD
GO
 
CREATE INDEX [U_DIS_DG] ON [dbo].[U_DIS_DD]([DIS_GRUPPO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_DA] ON [dbo].[U_DIS_DD]([DIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_DD] ON [dbo].[U_DIS_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_DIS_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_DIS_GR')
   drop index U_DIS_TT.U_DIS_GR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_DIS_TT')
   drop index U_DIS_TT.U_DIS_TT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_DIS_DE')
   drop index U_DIS_TT.U_DIS_DE
GO
 
CREATE INDEX [U_DIS_GR] ON [dbo].[U_DIS_TT]([DIT_GRUPPO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_TT] ON [dbo].[U_DIS_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_DE] ON [dbo].[U_DIS_TT]([DIT_DESCRI]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FAP_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FAPHOOKD')
   drop index U_FAP_DD.FAPHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAP_DA')
   drop index U_FAP_DD.U_FAP_DA
GO
 
CREATE INDEX [FAPHOOKD] ON [dbo].[U_FAP_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_DA] ON [dbo].[U_FAP_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FAP_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FAPHOOKT')
   drop index U_FAP_TT.FAPHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'FAPNDOCT')
   drop index U_FAP_TT.FAPNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAP_TN')
   drop index U_FAP_TT.U_FAP_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAP_TD')
   drop index U_FAP_TT.U_FAP_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAP_DA')
   drop index U_FAP_TT.U_FAP_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAP_TC')
   drop index U_FAP_TT.U_FAP_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAP_AG')
   drop index U_FAP_TT.U_FAP_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAP_TA')
   drop index U_FAP_TT.U_FAP_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAP_RG')
   drop index U_FAP_TT.U_FAP_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_FAP_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NPROT')
   drop index U_FAP_TT.T_NPROT
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_FAP_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAP_SY')
   drop index U_FAP_TT.U_FAP_SY
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAP_OR')
   drop index U_FAP_TT.U_FAP_OR
GO
 
CREATE INDEX [FAPHOOKT] ON [dbo].[U_FAP_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [FAPNDOCT] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_TN] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_TD] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_DA] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_TC] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_AG] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_TA] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_RG] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_FAP_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NPROT] ON [dbo].[U_FAP_TT]([ORD_NPROT]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_FAP_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_SY] ON [dbo].[U_FAP_TT]([ORD_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_OR] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FAT_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FATHOOKD')
   drop index U_FAT_DD.FATHOOKD
GO

if exists (select name from dbo.sysindexes where name = 'U_FAT_DA')
   drop index U_FAT_DD.U_FAT_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'FPS_VETTOD')
   drop index U_FAT_DD.FPS_VETTOD
GO

if exists (select name from dbo.sysindexes where name = 'U_FAT_DF')
   drop index U_FAT_DD.U_FAT_DF
GO
 
CREATE INDEX [FATHOOKD] ON [dbo].[U_FAT_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_DA] ON [dbo].[U_FAT_DD]([ORD_CODART]) ON [PRIMARY]
GO

CREATE INDEX [U_FAT_DF] ON [dbo].[U_FAT_DD]([ORD_CODART], [ORS_NUMORD], [ORS_DATORD], [ORS_CODCLI]) ON [PRIMARY]
GO

 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FAT_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FATHOOKT')
   drop index U_FAT_TT.FATHOOKT
GO
if exists (select name from dbo.sysindexes where name = 'FATNDOCT')
   drop index U_FAT_TT.FATNDOCT
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_TN')
   drop index U_FAT_TT.U_FAT_TN
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_TD')
   drop index U_FAT_TT.U_FAT_TD
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_TC')
   drop index U_FAT_TT.U_FAT_TC
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_AG')
   drop index U_FAT_TT.U_FAT_AG
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_TA')
   drop index U_FAT_TT.U_FAT_TA
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_RG')
   drop index U_FAT_TT.U_FAT_RG
GO
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_FAT_TT.T_NUMERIC
GO
if exists (select name from dbo.sysindexes where name = 'T_NPROT')
   drop index U_FAT_TT.T_NPROT
GO
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_FAT_TT.T_INDICE
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_SY')
   drop index U_FAT_TT.U_FAT_SY
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_OR')
   drop index U_FAT_TT.U_FAT_OR
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_WW')
   drop index U_FAT_TT.U_FAT_WW
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_01')
   drop index U_FAT_TT.U_FAT_01
GO
if exists (select name from dbo.sysindexes where name = 'U_FAT_02')
   drop index U_FAT_TT.U_FAT_02
GO

CREATE INDEX [FATHOOKT] ON [dbo].[U_FAT_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [FATNDOCT] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_TN] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_TD] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_TC] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_AG] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_TA] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_RG] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [T_NUMERIC] ON [dbo].[U_FAT_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [T_NPROT] ON [dbo].[U_FAT_TT]([ORD_NPROT]) ON [PRIMARY]
GO
CREATE INDEX [T_INDICE] ON [dbo].[U_FAT_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_SY] ON [dbo].[U_FAT_TT]([ORD_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_OR] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_WW] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_DATORD], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_01] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_NUMORD], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_02] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_CODCLI]) ON [PRIMARY]
GO
 

 -- ********************************************************************************
-- Indicizzazione tabella U_FOR_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_FOR_AN')
   drop index U_FOR_AN.U_FOR_AN
GO
if exists (select name from dbo.sysindexes where name = 'U_FOR_RG')
   drop index U_FOR_AN.U_FOR_RG
GO
if exists (select name from dbo.sysindexes where name = 'U_FOR_LO')
   drop index U_FOR_AN.U_FOR_LO
GO
if exists (select name from dbo.sysindexes where name = 'U_FOR_NA')
   drop index U_FOR_AN.U_FOR_NA
GO
if exists (select name from dbo.sysindexes where name = 'U_FOR_PI')
   drop index U_FOR_AN.U_FOR_PI
GO
if exists (select name from dbo.sysindexes where name = 'U_FOR_AL')
   drop index U_FOR_AN.U_FOR_AL
GO
if exists (select name from dbo.sysindexes where name = 'U_FOR_CE')
   drop index U_FOR_AN.U_FOR_CE
GO
if exists (select name from dbo.sysindexes where name = 'U_FOR_01')
   drop index U_FOR_AN.U_FOR_01
GO

CREATE INDEX [U_FOR_AN] ON [dbo].[U_FOR_AN]([FOR_CODSOC], [FOR_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_RG] ON [dbo].[U_FOR_AN]([FOR_CODSOC], [FOR_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_LO] ON [dbo].[U_FOR_AN]([FOR_CODSOC], [FOR_LOCALI]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_NA] ON [dbo].[U_FOR_AN]([FOR_CODSOC], [FOR_NAZION]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_PI] ON [dbo].[U_FOR_AN]([FOR_CODSOC], [FOR_PARIVA]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_AL] ON [dbo].[U_FOR_AN]([FOR_CODSOC], [FOR_RICERC]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_CE] ON [dbo].[U_FOR_AN]([FOR_CODSOC], [FOR_CLICEE]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_01] ON [dbo].[U_FOR_AN]([FOR_FLGTRA]) ON [PRIMARY]
GO
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_IMB_TB.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_IMB_CO')
   drop index U_IMB_TB.U_IMB_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_IMB_DE')
   drop index U_IMB_TB.U_IMB_DE
GO
 
CREATE INDEX [U_IMB_CO] ON [dbo].[U_IMB_TB]([IMB_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_IMB_DE] ON [dbo].[U_IMB_TB]([IMB_DESCRI]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_LIF_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_LIS_01')
   drop index U_LIF_TT.U_LIS_01
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LIS_02')
   drop index U_LIF_TT.U_LIS_02
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LIS_03')
   drop index U_LIF_TT.U_LIS_03
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LIS_CA')
   drop index U_LIF_TT.U_LIS_CA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LIS_CO')
   drop index U_LIF_TT.U_LIS_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LIS_DT')
   drop index U_LIF_TT.U_LIS_DT
GO
 
CREATE INDEX [U_LIS_01] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_02] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_03] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_DATLIS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_CA] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_CO] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_DT] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART], [LIS_DATLIS]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_LIS_AG.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'AGENTE')
   drop index U_LIS_AG.AGENTE
GO
 
if exists (select name from dbo.sysindexes where name = 'ARTICOLO')
   drop index U_LIS_AG.ARTICOLO
GO
 
if exists (select name from dbo.sysindexes where name = 'AGEART')
   drop index U_LIS_AG.AGEART
GO
 
CREATE INDEX [AGENTE] ON [dbo].[U_LIS_AG]([LIS_CODSOC], [LIS_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [ARTICOLO] ON [dbo].[U_LIS_AG]([LIS_CODSOC], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [AGEART] ON [dbo].[U_LIS_AG]([LIS_CODSOC], [LIS_AGE], [LIS_CODART]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_LIS_LG.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'AGENTE')
   drop index U_LIS_LG.AGENTE
GO
if exists (select name from dbo.sysindexes where name = 'LISTINO')
   drop index U_LIS_LG.LISTINO
GO
if exists (select name from dbo.sysindexes where name = 'LINEA')
   drop index U_LIS_LG.LINEA
GO
if exists (select name from dbo.sysindexes where name = 'ZONA')
   drop index U_LIS_LG.ZONA
GO
if exists (select name from dbo.sysindexes where name = 'CLIENTE')
   drop index U_LIS_LG.CLIENTE
GO
if exists (select name from dbo.sysindexes where name = 'DATA')
   drop index U_LIS_LG.DATA
GO
if exists (select name from dbo.sysindexes where name = 'DATAAL')
   drop index U_LIS_LG.DATAAL
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_01')
   drop index U_LIS_LG.U_LIS_01
GO
 
CREATE INDEX [AGENTE] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_TIPO], [LIS_AGE]) ON [PRIMARY]
GO
CREATE INDEX [LISTINO] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_TIPO], [LIS_AGE], [LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [LINEA] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_TIPO], [LIS_LINART], [LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [ZONA] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_TIPO], [LIS_ZONA], [LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [CLIENTE] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_TIPO], [LIS_CODCLI], [LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [DATA] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_DATLIS], [LIS_AGE]) ON [PRIMARY]
GO
CREATE INDEX [DATAAL] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_TIPO], [LIS_ALLIST]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_01] ON [dbo].[U_LIS_LG]([LIS_FLGTRA]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_LIS_LI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CLIENTE')
   drop index U_LIS_LI.CLIENTE
GO
 
if exists (select name from dbo.sysindexes where name = 'LINEA')
   drop index U_LIS_LI.LINEA
GO
 
if exists (select name from dbo.sysindexes where name = 'COD_LIN')
   drop index U_LIS_LI.COD_LIN
GO
 
CREATE INDEX [CLIENTE] ON [dbo].[U_LIS_LI]([LIS_CODSOC], [LIS_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [LINEA] ON [dbo].[U_LIS_LI]([LIS_CODSOC], [LIS_LINART]) ON [PRIMARY]
GO
 
CREATE INDEX [COD_LIN] ON [dbo].[U_LIS_LI]([LIS_CODSOC], [LIS_CODCLI], [LIS_LINART]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_LIS_PA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'AGENTE')
   drop index U_LIS_PA.AGENTE
GO
 
if exists (select name from dbo.sysindexes where name = 'LINEA')
   drop index U_LIS_PA.LINEA
GO
 
if exists (select name from dbo.sysindexes where name = 'AGELIN')
   drop index U_LIS_PA.AGELIN
GO
 
CREATE INDEX [AGENTE] ON [dbo].[U_LIS_PA]([LIS_CODSOC], [LIS_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [LINEA] ON [dbo].[U_LIS_PA]([LIS_CODSOC], [LIS_LINEA]) ON [PRIMARY]
GO
 
CREATE INDEX [AGELIN] ON [dbo].[U_LIS_PA]([LIS_CODSOC], [LIS_AGE], [LIS_LINEA]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_LIS_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_LIS_01')
   drop index U_LIS_TT.U_LIS_01
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_02')
   drop index U_LIS_TT.U_LIS_02
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_03')
   drop index U_LIS_TT.U_LIS_03
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_CA')
   drop index U_LIS_TT.U_LIS_CA
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_CO')
   drop index U_LIS_TT.U_LIS_CO
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_VE')
   drop index U_LIS_TT.U_LIS_VE
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_04')
   drop index U_LIS_TT.U_LIS_04
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_05')
   drop index U_LIS_TT.U_LIS_05
GO

CREATE INDEX [U_LIS_01] ON [dbo].[U_LIS_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_02] ON [dbo].[U_LIS_TT]([LIS_CODSOC], [LIS_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_03] ON [dbo].[U_LIS_TT]([LIS_CODSOC], [LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_CA] ON [dbo].[U_LIS_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART], [LIS_DATLIS], [LIS_ALLIST]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_CO] ON [dbo].[U_LIS_TT]([LIS_CODSOC], [LIS_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_VE] ON [dbo].[U_LIS_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART], [LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_04] ON [dbo].[U_LIS_TT]([LIS_FLGTRA]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_05] ON [dbo].[U_LIS_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_DATLIS]) ON [PRIMARY]
GO
 
-- ********************************************************************************
-- Indicizzazione tabella U_LIS_TA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_LIS_01')
   drop index U_LIS_TA.U_LIS_01
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_02')
   drop index U_LIS_TA.U_LIS_02
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_03')
   drop index U_LIS_TA.U_LIS_03
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_CA')
   drop index U_LIS_TA.U_LIS_CA
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_CO')
   drop index U_LIS_TA.U_LIS_CO
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_VE')
   drop index U_LIS_TA.U_LIS_VE
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_04')
   drop index U_LIS_TA.U_LIS_04
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_05')
   drop index U_LIS_TA.U_LIS_05
GO

CREATE INDEX [U_LIS_01] ON [dbo].[U_LIS_TA]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_02] ON [dbo].[U_LIS_TA]([LIS_CODSOC], [LIS_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_03] ON [dbo].[U_LIS_TA]([LIS_CODSOC], [LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_CA] ON [dbo].[U_LIS_TA]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART], [LIS_DATLIS], [LIS_ALLIST]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_CO] ON [dbo].[U_LIS_TA]([LIS_CODSOC], [LIS_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_VE] ON [dbo].[U_LIS_TA]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART], [LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_04] ON [dbo].[U_LIS_TA]([LIS_FLGTRA]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_05] ON [dbo].[U_LIS_TA]([LIS_CODSOC], [LIS_CODCLI], [LIS_DATLIS]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_LIS_VE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_LIS_TI')
   drop index U_LIS_VE.U_LIS_TI
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LIS_VE')
   drop index U_LIS_VE.U_LIS_VE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LIS_AR')
   drop index U_LIS_VE.U_LIS_AR
GO
 
CREATE INDEX [U_LIS_TI] ON [dbo].[U_LIS_VE]([LIS_CODSOC], [LIS_TIPO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_VE] ON [dbo].[U_LIS_VE]([LIS_CODSOC], [LIS_TIPO], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_AR] ON [dbo].[U_LIS_VE]([LIS_CODSOC], [LIS_CODART]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_LOC_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_LOC_CF')
   drop index U_LOC_AN.U_LOC_CF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LOC_CO')
   drop index U_LOC_AN.U_LOC_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LOC_CC')
   drop index U_LOC_AN.U_LOC_CC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LOC_RG')
   drop index U_LOC_AN.U_LOC_RG
GO
 
CREATE UNIQUE INDEX [U_LOC_CF] ON [dbo].[U_LOC_AN]([LOC_CODSOC], [LOC_CF], [LOC_CODCLI], [LOC_CODLOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LOC_CO] ON [dbo].[U_LOC_AN]([LOC_CODSOC], [LOC_CODLOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LOC_CC] ON [dbo].[U_LOC_AN]([LOC_CODSOC], [LOC_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LOC_RG] ON [dbo].[U_LOC_AN]([LOC_CODSOC], [LOC_RAGSOC]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAG_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAG_01')
   drop index U_MAG_AN.U_MAG_01
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GA')
   drop index U_MAG_AN.U_MAG_GA
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GF')
   drop index U_MAG_AN.U_MAG_GF
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_DA')
   drop index U_MAG_AN.U_MAG_DA
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_02')
   drop index U_MAG_AN.U_MAG_02
GO

CREATE INDEX [U_MAG_01] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GA] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GF] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODFOR]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_DA] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_CODMAG], [MAG_DESART]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_02] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_GIACEN], [MAG_CODMAG]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_MAG_GG.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAG_G1')
   drop index U_MAG_GG.U_MAG_G1
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G2')
   drop index U_MAG_GG.U_MAG_G2
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G3')
   drop index U_MAG_GG.U_MAG_G3
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G4')
   drop index U_MAG_GG.U_MAG_G4
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G5')
   drop index U_MAG_GG.U_MAG_G5
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G6')
   drop index U_MAG_GG.U_MAG_G6
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G7')
   drop index U_MAG_GG.U_MAG_G7
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G8')
   drop index U_MAG_GG.U_MAG_G8
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G9')
   drop index U_MAG_GG.U_MAG_G9
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G0')
   drop index U_MAG_GG.U_MAG_G0
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GA')
   drop index U_MAG_GG.U_MAG_GA
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GB')
   drop index U_MAG_GG.U_MAG_GB
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GC')
   drop index U_MAG_GG.U_MAG_GC
GO

CREATE INDEX [U_MAG_G1] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_CODPDV]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G2] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT],  [MAG_DATAGG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G3] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_FORNIT],  [MAG_DATAGG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G4] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_DATAGG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G5] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G6] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_CODMAG], [MAG_FORNIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G7] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_FORNIT]) ON [PRIMARY]
GO 
CREATE INDEX [U_MAG_G8] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_GIACEN], [MAG_CODACQ], [MAG_PRZCON]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G9] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_GIACEN]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G0] ON [dbo].[U_MAG_GG]([MAG_CODMAG], [MAG_LEGSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GA] ON [dbo].[U_MAG_GG]([MAG_CODMAG], [MAG_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GB] ON [dbo].[U_MAG_GG]([MAG_FLGTRA]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GC] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODPDV]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_MAG_DA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAG_G1')
   drop index U_MAG_DA.U_MAG_G1
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G2')
   drop index U_MAG_DA.U_MAG_G2
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G3')
   drop index U_MAG_DA.U_MAG_G3
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G4')
   drop index U_MAG_DA.U_MAG_G4
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G5')
   drop index U_MAG_DA.U_MAG_G5
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G6')
   drop index U_MAG_DA.U_MAG_G6
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G7')
   drop index U_MAG_DA.U_MAG_G7
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G8')
   drop index U_MAG_DA.U_MAG_G8
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G9')
   drop index U_MAG_DA.U_MAG_G9
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G0')
   drop index U_MAG_DA.U_MAG_G0
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GA')
   drop index U_MAG_DA.U_MAG_GA
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GB')
   drop index U_MAG_DA.U_MAG_GB
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GC')
   drop index U_MAG_DA.U_MAG_GC
GO

CREATE INDEX [U_MAG_G1] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_CODPDV]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G2] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT],  [MAG_DATAGG], [MAG_GIACEN]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G3] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_CODART], [MAG_FORNIT],  [MAG_DATAGG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G4] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_CODART], [MAG_DATAGG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G5] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G6] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_CODMAG], [MAG_FORNIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G7] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_FORNIT]) ON [PRIMARY]
GO 
CREATE INDEX [U_MAG_G8] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_GIACEN], [MAG_CODACQ], [MAG_PRZCON]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G9] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_GIACEN]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G0] ON [dbo].[U_MAG_DA]([MAG_CODMAG], [MAG_LEGSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GA] ON [dbo].[U_MAG_DA]([MAG_CODMAG], [MAG_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GB] ON [dbo].[U_MAG_DA]([MAG_FLGTRA]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GC] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODPDV]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_MAG_CP.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAG_G1')
   drop index U_MAG_CP.U_MAG_G1
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G2')
   drop index U_MAG_CP.U_MAG_G2
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G3')
   drop index U_MAG_CP.U_MAG_G3
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G4')
   drop index U_MAG_CP.U_MAG_G4
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G5')
   drop index U_MAG_CP.U_MAG_G5
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G6')
   drop index U_MAG_CP.U_MAG_G6
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G7')
   drop index U_MAG_CP.U_MAG_G7
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G8')
   drop index U_MAG_CP.U_MAG_G8
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G9')
   drop index U_MAG_CP.U_MAG_G9
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_G0')
   drop index U_MAG_CP.U_MAG_G0
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GA')
   drop index U_MAG_CP.U_MAG_GA
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GB')
   drop index U_MAG_CP.U_MAG_GB
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GC')
   drop index U_MAG_CP.U_MAG_GC
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_GD')
   drop index U_MAG_CP.U_MAG_GD
GO

CREATE INDEX [U_MAG_G1] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G2] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_DATAGG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G3] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_CODART], [MAG_FORNIT], [MAG_DATAGG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G4] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_CODART], [MAG_DATAGG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G5] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G6] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_CODMAG], [MAG_FORNIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G7] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_FORNIT]) ON [PRIMARY]
GO 
CREATE INDEX [U_MAG_G8] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_GIACEN], [MAG_CODACQ], [MAG_PRZCON]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G9] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_GIACEN]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G0] ON [dbo].[U_MAG_CP]([MAG_CODMAG], [MAG_LEGSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GA] ON [dbo].[U_MAG_CP]([MAG_CODMAG], [MAG_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GB] ON [dbo].[U_MAG_CP]([MAG_FLGTRA], [MAG_CODMAG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GC] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART], [MAG_FORNIT], [MAG_CODACQ], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_DATAGG], [MAG_PRZCON]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GD] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_NUMCAM], [MAG_DATCAM]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_MAG_MO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAG_MA')
   drop index U_MAG_MO.U_MAG_MA
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_MD')
   drop index U_MAG_MO.U_MAG_MD
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_RD')
   drop index U_MAG_MO.U_MAG_RD
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_MF')
   drop index U_MAG_MO.U_MAG_MF
GO
if exists (select name from dbo.sysindexes where name = 'DTREG')
   drop index U_MAG_MO.DTREG
GO
if exists (select name from dbo.sysindexes where name = 'CODART')
   drop index U_MAG_MO.CODART
GO
if exists (select name from dbo.sysindexes where name = 'NUMDOC')
   drop index U_MAG_MO.NUMDOC
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_AR')
   drop index U_MAG_MO.U_MAG_AR
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_DC')
   drop index U_MAG_MO.U_MAG_DC
GO
if exists (select name from dbo.sysindexes where name = 'I_TROVDEL')
   drop index U_MAG_MO.I_TROVDEL
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_DR')
   drop index U_MAG_MO.U_MAG_DR
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_SE')
   drop index U_MAG_MO.U_MAG_SE
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_MC')
   drop index U_MAG_MO.U_MAG_MC
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_ML')
   drop index U_MAG_MO.U_MAG_ML
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_01')
   drop index U_MAG_MO.U_MAG_01
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_02')
   drop index U_MAG_MO.U_MAG_02
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_03')
   drop index U_MAG_MO.U_MAG_03
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_04')
   drop index U_MAG_MO.U_MAG_04
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_05')
   drop index U_MAG_MO.U_MAG_05
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_06')
   drop index U_MAG_MO.U_MAG_06
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_07')
   drop index U_MAG_MO.U_MAG_07
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_08')
   drop index U_MAG_MO.U_MAG_08
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_09')
   drop index U_MAG_MO.U_MAG_09
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_10')
   drop index U_MAG_MO.U_MAG_10
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_11')
   drop index U_MAG_MO.U_MAG_11
GO

CREATE INDEX [U_MAG_MA] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_CODART], [MOV_DTDOCU], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_MD] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_DTDOCU], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_RD] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_CODART], [MOV_DTREGI], [MOV_FORNIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_MF] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_CODFOR], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [DTREG] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [CODART] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODART], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [NUMDOC] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_NUMDOC], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_AR] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_DC] ON [dbo].[U_MAG_MO]([MOV_CODART], [MOV_CODMAG], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [I_TROVDEL] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_CODART], [MOV_NUMDOC], [MOV_TOP], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_DR] ON [dbo].[U_MAG_MO]([MOV_CODART], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_SE] ON [dbo].[U_MAG_MO]([MOV_CODMAG], [MOV_CODART], [MOV_TOP], [MOV_NUMDOC], [MOV_DTDOCU], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_MC] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_CODART], [MOV_TOP], [MOV_NUMDOC], [MOV_DTDOCU], [MOV_DTREGI], [MOV_ORAMOV]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_ML] ON [dbo].[U_MAG_MO]([MOV_CODMAG], [MOV_LEGSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_01] ON [dbo].[U_MAG_MO]([MOV_CODPDV], [MOV_LEGAME]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_02] ON [dbo].[U_MAG_MO]([MOV_CODPDV], [MOV_LEGSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_03] ON [dbo].[U_MAG_MO]([MOV_CODMAG], [MOV_LEGSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_04] ON [dbo].[U_MAG_MO]([MOV_CODMAG], [MOV_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_05] ON [dbo].[U_MAG_MO]([MOV_FLGTRA]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_06] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODART], [MOV_CODMAG], [MOV_FORNIT], [MOV_CODACQ], [MOV_NUMIDE], [MOV_CODBUN], [MOV_ANNO], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_07] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_FORNIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_08] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_NUMIDE], [MOV_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_09] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_DTDOCU]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_10] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_TOP], [MOV_CODMAG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_11] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_DTREGI]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_MAG_PR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAG_01')
   drop index U_MAG_PR.U_MAG_01
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAG_GA')
   drop index U_MAG_PR.U_MAG_GA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAG_DA')
   drop index U_MAG_PR.U_MAG_DA
GO
 
CREATE INDEX [U_MAG_01] ON [dbo].[U_MAG_PR]([MAG_ANNO], [MAG_CODSOC], [MAG_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAG_GA] ON [dbo].[U_MAG_PR]([MAG_ANNO], [MAG_CODSOC], [MAG_CODMAG], [MAG_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAG_DA] ON [dbo].[U_MAG_PR]([MAG_ANNO], [MAG_CODSOC], [MAG_CODMAG], [MAG_DESART]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_OFF_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKD')
   drop index U_OFF_DD.OFFHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_DA')
   drop index U_OFF_DD.U_OFF_DA
GO
 
CREATE INDEX [OFFHOOKD] ON [dbo].[U_OFF_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_DA] ON [dbo].[U_OFF_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_OFF_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKT')
   drop index U_OFF_TT.OFFHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'OFFNDOCT')
   drop index U_OFF_TT.OFFNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TN')
   drop index U_OFF_TT.U_OFF_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TD')
   drop index U_OFF_TT.U_OFF_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TC')
   drop index U_OFF_TT.U_OFF_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TA')
   drop index U_OFF_TT.U_OFF_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_DA')
   drop index U_OFF_TT.U_OFF_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_RG')
   drop index U_OFF_TT.U_OFF_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_OFF_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_OR')
   drop index U_OFF_TT.U_OFF_OR
GO
 
CREATE INDEX [OFFHOOKT] ON [dbo].[U_OFF_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [OFFNDOCT] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TN] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TD] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TC] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TA] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_DA] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_RG] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_OFF_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_OR] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ORD_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ORDHOOKD')
   drop index U_ORD_DD.ORDHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_DA')
   drop index U_ORD_DD.U_ORD_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_AM')
   drop index U_ORD_DD.U_ORD_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_DO')
   drop index U_ORD_DD.U_ORD_DO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_RI')
   drop index U_ORD_DD.U_ORD_RI
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_DT')
   drop index U_ORD_DD.U_ORD_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_SY')
   drop index U_ORD_DD.U_ORD_SY
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_AN')
   drop index U_ORD_DD.U_ORD_AN
GO
 
CREATE INDEX [ORDHOOKD] ON [dbo].[U_ORD_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_DA] ON [dbo].[U_ORD_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_AM] ON [dbo].[U_ORD_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_DO] ON [dbo].[U_ORD_DD]([ORS_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_RI] ON [dbo].[U_ORD_DD]([ORS_NUMORD], [ORS_DATORD], [ORS_CODEMI], [ORS_TIPORD], [ORS_MAGS], [ORD_CODART], [ORD_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_DT] ON [dbo].[U_ORD_DD]([ORS_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_SY] ON [dbo].[U_ORD_DD]([ORD_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_AN] ON [dbo].[U_ORD_DD]([ORS_DATORD], [ORS_NUMORD]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ORD_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ORDHOOKT')
   drop index U_ORD_TT.ORDHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'ORDNDOCT')
   drop index U_ORD_TT.ORDNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_TN')
   drop index U_ORD_TT.U_ORD_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_TD')
   drop index U_ORD_TT.U_ORD_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_TC')
   drop index U_ORD_TT.U_ORD_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_TA')
   drop index U_ORD_TT.U_ORD_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_DA')
   drop index U_ORD_TT.U_ORD_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_RG')
   drop index U_ORD_TT.U_ORD_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_ORD_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_TV')
   drop index U_ORD_TT.U_ORD_TV
GO
 
if exists (select name from dbo.sysindexes where name = 'FPS_INDICE')
   drop index U_ORD_TT.FPS_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'ORD_CLOSE')
   drop index U_ORD_TT.ORD_CLOSE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_RE')
   drop index U_ORD_TT.U_ORD_RE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORD_OR')
   drop index U_ORD_TT.U_ORD_OR
GO
 
CREATE INDEX [ORDHOOKT] ON [dbo].[U_ORD_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [ORDNDOCT] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_TN] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_TD] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_TC] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_TA] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_DA] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_RG] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_ORD_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_TV] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [FPS_INDICE] ON [dbo].[U_ORD_TT]([ORD_DATORD], [ORD_NUMORD], [ORD_CODEMI], [ORD_TIPORD]) ON [PRIMARY]
GO
 
CREATE INDEX [ORD_CLOSE] ON [dbo].[U_ORD_TT]([ORD_CHIUSO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_RE] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_RAGEMI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_OR] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ORF_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ORFHOOKD')
   drop index U_ORF_DD.ORFHOOKD
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_DA')
   drop index U_ORF_DD.U_ORF_DA
GO
if exists (select name from dbo.sysindexes where name = 'RIGART')
   drop index U_ORF_DD.RIGART
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_AM')
   drop index U_ORF_DD.U_ORF_AM
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_01')
   drop index U_ORF_DD.U_ORF_01
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_02')
   drop index U_ORF_DD.U_ORF_02
GO

CREATE INDEX [ORFHOOKD] ON [dbo].[U_ORF_DD]([DAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_DA] ON [dbo].[U_ORF_DD]([ORD_CODART]) ON [PRIMARY]
GO
CREATE INDEX [RIGART] ON [dbo].[U_ORF_DD]([DAGGANCIO], [ORD_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_AM] ON [dbo].[U_ORF_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_01] ON [dbo].[U_ORF_DD]([DAGGANCIO], [ORD_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_02] ON [dbo].[U_ORF_DD]([DAGGANCIO], [ORD_CODART], [ORD_MAGA], [ORD_DATCON]) ON [PRIMARY]
GO

 
-- ********************************************************************************
-- Indicizzazione tabella U_BFO_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BFOHOOKT')
   drop index U_BFO_TT.BFOHOOKT
GO
if exists (select name from dbo.sysindexes where name = 'BFONDOCT')
   drop index U_BFO_TT.BFONDOCT
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_TD')
   drop index U_BFO_TT.U_BFO_TD
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_TC')
   drop index U_BFO_TT.U_BFO_TC
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_TA')
   drop index U_BFO_TT.U_BFO_TA
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_RG')
   drop index U_BFO_TT.U_BFO_RG
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_TT')
   drop index U_BFO_TT.U_BFO_TT
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_PV')
   drop index U_BFO_TT.U_BFO_PV
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_CC')
   drop index U_BFO_TT.U_BFO_CC
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_AA')
   drop index U_BFO_TT.U_BFO_AA
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_SY')
   drop index U_BFO_TT.U_BFO_SY
GO
 
CREATE INDEX [BFOHOOKT] ON [dbo].[U_BFO_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [BFONDOCT] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TD] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TC] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TA] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_RG] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TT] ON [dbo].[U_BFO_TT]([ORD_CODCLI], [ORD_NUMORD], [ORD_DATORD], [ORD_TIPDOC], [ORD_CODBUN]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_PV] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_CODBUN]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_CC] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_CODCCO]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_AA] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_SY] ON [dbo].[U_BFO_TT]([ORD_CODSYS]) ON [PRIMARY]
GO

 
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PDV_AN')
   drop index U_PDV_AN.U_PDV_AN
GO
if exists (select name from dbo.sysindexes where name = 'U_PDV_DS')
   drop index U_PDV_AN.U_PDV_DS
GO
if exists (select name from dbo.sysindexes where name = 'U_PDV_MA')
   drop index U_PDV_AN.U_PDV_MA
GO
 
CREATE INDEX [U_PDV_AN] ON [dbo].[U_PDV_AN]([PDV_CODICE]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_DS] ON [dbo].[U_PDV_AN]([PDV_DESCRI]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_MA] ON [dbo].[U_PDV_AN]([PDV_CODMAG]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_CA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PDV_CA')
   drop index U_PDV_CA.U_PDV_CA
GO
if exists (select name from dbo.sysindexes where name = 'U_PDV_C1')
   drop index U_PDV_CA.U_PDV_C1
GO
if exists (select name from dbo.sysindexes where name = 'U_PDV_C2')
   drop index U_PDV_CA.U_PDV_C2
GO
if exists (select name from dbo.sysindexes where name = 'U_PDV_C3')
   drop index U_PDV_CA.U_PDV_C3
GO
if exists (select name from dbo.sysindexes where name = 'U_PDV_C4')
   drop index U_PDV_CA.U_PDV_C4
GO
if exists (select name from dbo.sysindexes where name = 'U_PDV_C5')
   drop index U_PDV_CA.U_PDV_C5
GO

CREATE INDEX [U_PDV_CA] ON [dbo].[U_PDV_CA]([CAS_CODMAG], [CAS_PROGRE], [CAS_DATOPE], [CAS_ORAOPE] ) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_C1] ON [dbo].[U_PDV_CA]([CAS_CODMAG], [CAS_CODCLI], [CAS_DATOPE], [CAS_ORAOPE] ) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_C2] ON [dbo].[U_PDV_CA]([CAS_FLGAGG]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_C3] ON [dbo].[U_PDV_CA]([CAS_CODCAS], [CAS_CODMAG], [CAS_PROGRE], [CAS_DATOPE], [CAS_ORAOPE], [CAS_TIPINC], [CAS_CODART], [CAS_SEQUEN]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_C4] ON [dbo].[U_PDV_CA]([CAS_CODCAS], [CAS_DATOPE], [CAS_FLGSOF]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_C5] ON [dbo].[U_PDV_CA]([CAS_DATOPE], [CAS_FLGSOF], [CAS_CODMAG]) ON [PRIMARY]
GO
 

-- ********************************************************************************
-- Indicizzazione tabella U_CAN_CA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CAN_CA')
   drop index U_CAN_CA.U_CAN_CA
GO
if exists (select name from dbo.sysindexes where name = 'U_CAN_C1')
   drop index U_CAN_CA.U_CAN_C1
GO
if exists (select name from dbo.sysindexes where name = 'U_CAN_C2')
   drop index U_CAN_CA.U_CAN_C2
GO

CREATE INDEX [U_CAN_CA] ON [dbo].[U_CAN_CA]([CAS_CODMAG], [CAS_PROGRE], [CAS_DATOPE], [CAS_ORAOPE] ) ON [PRIMARY]
GO
CREATE INDEX [U_CAN_C1] ON [dbo].[U_CAN_CA]([CAS_CODMAG], [CAS_CODCLI], [CAS_DATOPE], [CAS_ORAOPE] ) ON [PRIMARY]
GO
CREATE INDEX [U_CAN_C2] ON [dbo].[U_CAN_CA]([CAS_FLGAGG]) ON [PRIMARY]
GO


 
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_CC.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PDV_CC')
   drop index U_PDV_CC.U_PDV_CC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PDV_DS')
   drop index U_PDV_CC.U_PDV_DS
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PDV_PR')
   drop index U_PDV_CC.U_PDV_PR
GO
 
CREATE INDEX [U_PDV_CC] ON [dbo].[U_PDV_CC]([PDV_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PDV_DS] ON [dbo].[U_PDV_CC]([PDV_DESCRI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PDV_PR] ON [dbo].[U_PDV_CC]([PDV_PROGRE]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_IN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PDV_IN')
   drop index U_PDV_IN.U_PDV_IN
GO
 
CREATE INDEX [U_PDV_IN] ON [dbo].[U_PDV_IN]([CGE_CODPDV], [CGE_CONTO], [CGE_CONTRO], [CGE_DATSCO]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_OP.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PDV_OP')
   drop index U_PDV_OP.U_PDV_OP
GO
if exists (select name from dbo.sysindexes where name = 'U_PDV_O1')
   drop index U_PDV_OP.U_PDV_O1
GO
if exists (select name from dbo.sysindexes where name = 'U_PDV_O2')
   drop index U_PDV_OP.U_PDV_O2
GO
if exists (select name from dbo.sysindexes where name = 'U_PDV_O3')
   drop index U_PDV_OP.U_PDV_O3
GO

CREATE INDEX [U_PDV_OP] ON [dbo].[U_PDV_OP]([CAS_CODMAG], [CAS_CODCAS], [CAS_DATOPE]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_O1] ON [dbo].[U_PDV_OP]([CAS_CODPDV], [CAS_CODCAS], [CAS_DATOPE]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_O2] ON [dbo].[U_PDV_OP]([CAS_CODPDV], [CAS_CODMAG], [CAS_CODCAS], [CAS_DATOPE]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_O3] ON [dbo].[U_PDV_OP]([CAS_FLGAGG]) ON [PRIMARY]
GO

 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_PA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PDV_PA')
   drop index U_PDV_PA.U_PDV_PA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PDV_DS')
   drop index U_PDV_PA.U_PDV_DS
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PDV_PR')
   drop index U_PDV_PA.U_PDV_PR
GO
 
CREATE INDEX [U_PDV_PA] ON [dbo].[U_PDV_PA]([PDV_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PDV_DS] ON [dbo].[U_PDV_PA]([PDV_DESCRI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PDV_PR] ON [dbo].[U_PDV_PA]([PDV_PROGRE]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_SA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PDV_SA')
   drop index U_PDV_SA.U_PDV_SA
GO
 
CREATE INDEX [U_PDV_SA] ON [dbo].[U_PDV_SA]([SAL_TIPO], [SAL_CODPDV], [SAL_PERIOD], [SAL_CODART]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_SC.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PDV_SC')
   drop index U_PDV_SC.U_PDV_SC
GO

if exists (select name from dbo.sysindexes where name = 'U_PDV_S1')
   drop index U_PDV_SC.U_PDV_S1
GO

if exists (select name from dbo.sysindexes where name = 'U_PDV_S2')
   drop index U_PDV_SC.U_PDV_S2
GO
 
CREATE INDEX [U_PDV_SC] ON [dbo].[U_PDV_SC]([CAS_CODMAG], [CAS_CODCAS], [CAS_DATOPE]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_S1] ON [dbo].[U_PDV_SC]([CAS_CODPDV], [CAS_CODCAS], [CAS_DATOPE]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_S2] ON [dbo].[U_PDV_SC]([CAS_CODPDV], [CAS_CODMAG], [CAS_CODCAS], [CAS_DATOPE]) ON [PRIMARY]
GO

 
 
-- ********************************************************************************
-- Indicizzazione tabella U_SPE_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'SPEHOOKD')
   drop index U_SPE_DD.SPEHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPE_DA')
   drop index U_SPE_DD.U_SPE_DA
GO
 
CREATE INDEX [SPEHOOKD] ON [dbo].[U_SPE_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPE_DA] ON [dbo].[U_SPE_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_SPE_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'SPEHOOKT')
   drop index U_SPE_TT.SPEHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'SPENDOCT')
   drop index U_SPE_TT.SPENDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPE_TN')
   drop index U_SPE_TT.U_SPE_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPE_TD')
   drop index U_SPE_TT.U_SPE_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPE_TC')
   drop index U_SPE_TT.U_SPE_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPE_TA')
   drop index U_SPE_TT.U_SPE_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPE_DA')
   drop index U_SPE_TT.U_SPE_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_SPE_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPE_RG')
   drop index U_SPE_TT.U_SPE_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_SPE_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPE_OR')
   drop index U_SPE_TT.U_SPE_OR
GO
 
CREATE INDEX [SPEHOOKT] ON [dbo].[U_SPE_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [SPENDOCT] ON [dbo].[U_SPE_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPE_TN] ON [dbo].[U_SPE_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPE_TD] ON [dbo].[U_SPE_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPE_TC] ON [dbo].[U_SPE_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPE_TA] ON [dbo].[U_SPE_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPE_DA] ON [dbo].[U_SPE_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_SPE_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPE_RG] ON [dbo].[U_SPE_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_SPE_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPE_OR] ON [dbo].[U_SPE_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_VVA_CH.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_VVA_CD')
   drop index U_VVA_CH.U_VVA_CD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_VVA_DC')
   drop index U_VVA_CH.U_VVA_DC
GO
 
CREATE INDEX [U_VVA_CD] ON [dbo].[U_VVA_CH]([VVA_CODSOC], [VVA_CODVAL], [VVA_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_VVA_DC] ON [dbo].[U_VVA_CH]([VVA_CODSOC], [VVA_DATA], [VVA_CODVAL]) ON [PRIMARY]
GO
 
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_IVA_CO CORRISPETTIVI IVA PDV
-- ********************************************************************************
-- ********************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_IVA_CO')
   drop index U_IVA_CO.U_IVA_CO
GO
 
CREATE INDEX [U_IVA_CO] ON [dbo].[U_IVA_CO]([COR_CODSOC], [COR_CODPDV], [COR_DATA]) ON [PRIMARY]
GO


-- ********************************************************************************
-- ********************************************************************************
-- Indicizzazione tabella U_FOR_PR FORNITORI PREFERENZIALI
-- ********************************************************************************
-- ********************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_FOR_PR')
   drop index U_FOR_PR.U_FOR_PR
GO
if exists (select name from dbo.sysindexes where name = 'U_FOR_P1')
   drop index U_FOR_PR.U_FOR_P1
GO
if exists (select name from dbo.sysindexes where name = 'U_FOR_P2')
   drop index U_FOR_PR.U_FOR_P2
GO

CREATE INDEX [U_FOR_PR] ON [dbo].[U_FOR_PR]([FPR_CODSOC], [FPR_CODMAG], [FPR_CODART], [FPR_CODFOR]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_P1] ON [dbo].[U_FOR_PR]([FPR_CODSOC], [FPR_CODMAG], [FPR_CODFOR]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_P2] ON [dbo].[U_FOR_PR]([FPR_CODSOC], [FPR_CODART], [FPR_CODFOR]) ON [PRIMARY]
GO


-- ********************************************************************************
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_CN CONTROLLO AGGIORNAMENTI
-- ********************************************************************************
-- ********************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_PDV_CN')
   drop index U_PDV_CN.U_PDV_CN
GO

CREATE INDEX [U_PDV_CN] ON [dbo].[U_PDV_CN]([ID_UNIQUE], [CAS_TIPO]) ON [PRIMARY]
GO


-- ********************************************************************************
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_AU AUTORIZZAZIONI ALLE SPESE
-- ********************************************************************************
-- ********************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_PDV_AU')
   drop index U_PDV_AU.U_PDV_AU
GO

CREATE INDEX [U_PDV_AU] ON [dbo].[U_PDV_AU]([PDV_CODSOC], [PDV_DATAUT], [PDV_CODUTE]) ON [PRIMARY]
GO


-- ********************************************************************************
-- ********************************************************************************
-- Indicizzazione tabella U_PNC_BU  PRIMA NOTA CASSA INTERNA
-- ********************************************************************************
-- ********************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_PNC_B1')
   drop index U_PNC_BU.U_PNC_B1
GO

if exists (select name from dbo.sysindexes where name = 'U_PNC_B2')
   drop index U_PNC_BU.U_PNC_B2
GO

if exists (select name from dbo.sysindexes where name = 'U_PNC_B3')
   drop index U_PNC_BU.U_PNC_B3
GO
 
CREATE INDEX [U_PNC_B1] ON [dbo].[U_PNC_BU]([PNC_CODSOC], [PNC_CODBUN], [PNC_CODUTE], [PNC_DESOPE], [PNC_DATREG], [PNC_ORAREG]) ON [PRIMARY]
GO

CREATE INDEX [U_PNC_B2] ON [dbo].[U_PNC_BU]([PNC_CODSOC], [PNC_DATOPE]) ON [PRIMARY]
GO

CREATE INDEX [U_PNC_B3] ON [dbo].[U_PNC_BU]([ID_UNIQUE]) ON [PRIMARY]
GO


-- ********************************************************************************
-- ********************************************************************************
-- Indicizzazione tabella U_PNC_SA  SALDI PRIMA NOTA CASSA INTERNA
-- ********************************************************************************
-- ********************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_PNC_SA')
   drop index U_PNC_SA.U_PNC_SA
GO

CREATE INDEX [U_PNC_SA] ON [dbo].[U_PNC_SA]([PNC_CODSOC], [PNC_CODBUN], [PNC_MESE], [PNC_ANNO]) ON [PRIMARY]
GO


-- ********************************************************************************
-- ********************************************************************************
-- Indicizzazione tabella U_CLI_FI  FIDELIZZAZIONE CLIENTI
-- ********************************************************************************
-- ********************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_CLI_F1')
   drop index U_CLI_FI.U_CLI_F1
GO
if exists (select name from dbo.sysindexes where name = 'U_CLI_F2')
   drop index U_CLI_FI.U_CLI_F2
GO
if exists (select name from dbo.sysindexes where name = 'U_CLI_F3')
   drop index U_CLI_FI.U_CLI_F3
GO

CREATE INDEX [U_CLI_F1] ON [dbo].[U_CLI_FI]([FID_CODSOC], [FID_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_F2] ON [dbo].[U_CLI_FI]([FID_CODSOC], [FID_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_F3] ON [dbo].[U_CLI_FI]([FID_FLGTRA]) ON [PRIMARY]
GO


-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_PDV_CD  FILE DI MEGA CONTROLLO CHIUSURA DEFINITIVA DI CASSA
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_PDV_C1')
   drop index U_PDV_CD.U_PDV_C1
GO

if exists (select name from dbo.sysindexes where name = 'U_PDV_C2')
   drop index U_PDV_CD.U_PDV_C2
GO

CREATE INDEX [U_PDV_C1] ON [dbo].[U_PDV_CD]([PDV_CODSOC], [PDV_CODPDV], [PDV_DATCHI]) ON [PRIMARY]
GO

CREATE INDEX [U_PDV_C2] ON [dbo].[U_PDV_CD]([PDV_CODSOC], [PDV_DATCHI], [PDV_CODPDV]) ON [PRIMARY]
GO



-- ********************************************************************************
-- Indicizzazione tabella U_LEG_DO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_LEG_DO')
   drop index U_LEG_DO.U_LEG_DO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LEG_CL')
   drop index U_LEG_DO.U_LEG_CL
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LEG_RG')
   drop index U_LEG_DO.U_LEG_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LEG_TD')
   drop index U_LEG_DO.U_LEG_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LEG_NU')
   drop index U_LEG_DO.U_LEG_NU
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LEG_DT')
   drop index U_LEG_DO.U_LEG_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LEG_CR')
   drop index U_LEG_DO.U_LEG_CR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_LEG_NR')
   drop index U_LEG_DO.U_LEG_NR
GO
 
CREATE INDEX [U_LEG_DO] ON [dbo].[U_LEG_DO]([LEG_TIPDOC], [LEG_ANNO], [LEG_CODCLI], [LEG_RAGSOC], [LEG_NUMDOC], [LEG_DATDOC], [LEG_TIPCRE], [LEG_NUMCRE], [LEG_DATCRE], [LEG_SALCON]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_CL] ON [dbo].[U_LEG_DO]([LEG_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_RG] ON [dbo].[U_LEG_DO]([LEG_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_TD] ON [dbo].[U_LEG_DO]([LEG_TIPDOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_NU] ON [dbo].[U_LEG_DO]([LEG_TIPDOC], [LEG_NUMDOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_DT] ON [dbo].[U_LEG_DO]([LEG_TIPDOC], [LEG_DATDOC], [LEG_NUMDOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_CR] ON [dbo].[U_LEG_DO]([LEG_TIPCRE], [LEG_DATCRE], [LEG_NUMCRE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_NR] ON [dbo].[U_LEG_DO]([LEG_TIPCRE], [LEG_NUMCRE]) ON [PRIMARY]
GO



-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_CNT_AN  FILE DI CONTROLLO SU CONVERSIONE DATI
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_CNT_A1')
   drop index U_CNT_AN.U_CNT_A1
GO

CREATE INDEX [U_CNT_A1] ON [dbo].[U_CNT_AN]([CNT_TIPO]) ON [PRIMARY]
GO



-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_CON_TR  FILE DI CONTROLLO SULLE TRASMISSIONI/RICEZIONI FATTE
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_CON_T1')
   drop index U_CON_TR.U_CON_T1
GO

CREATE INDEX [U_CON_T1] ON [dbo].[U_CON_TR]([CON_DATA], [CON_PROGRE]) ON [PRIMARY]
GO



-- *************************************************************************************
-- *************************************************************************************
-- Indicizzazione tabella U_FTP_AN  FILE DI GESTIONE DELLE TRASMISSIONI/RICEZIONI IN FTP
-- *************************************************************************************
-- *************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_FTP_A1')
   drop index U_FTP_AN.U_FTP_A1
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_A2')
   drop index U_FTP_AN.U_FTP_A2
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_A3')
   drop index U_FTP_AN.U_FTP_A3
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_A4')
   drop index U_FTP_AN.U_FTP_A4
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_A5')
   drop index U_FTP_AN.U_FTP_A5
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_A6')
   drop index U_FTP_AN.U_FTP_A6
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_A7')
   drop index U_FTP_AN.U_FTP_A7
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_A8')
   drop index U_FTP_AN.U_FTP_A8
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_A9')
   drop index U_FTP_AN.U_FTP_A9
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_A0')
   drop index U_FTP_AN.U_FTP_A0
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_AA')
   drop index U_FTP_AN.U_FTP_AA
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_AB')
   drop index U_FTP_AN.U_FTP_AB
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_AC')
   drop index U_FTP_AN.U_FTP_AC
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_AD')
   drop index U_FTP_AN.U_FTP_AD
GO
if exists (select name from dbo.sysindexes where name = 'U_FTP_AE')
   drop index U_FTP_AN.U_FTP_AE
GO

CREATE INDEX [U_FTP_A1] ON [dbo].[U_FTP_AN]([FTP_TIPCOM], [FTP_EXECUTE]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_A2] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_CODPDV], [FTP_STAMPA]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_A3] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_STAMPA]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_A4] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_CODPDV], [FTP_CODCAS], [FTP_TIPO], [FTP_HOST], [FTP_USER], [FTP_PASSWO], [FTP_NOMEFI], [FTP_PATHAL]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_A5] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_DESPDV]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_A6] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_CODCAS]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_A7] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_DESCAS]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_A8] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_NUMSER]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_A9] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_NUMDOC]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_A0] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_DATDOC]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_AA] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_RAGFOR]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_AB] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_TIPO]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_AC] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_HOST]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_AD] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_USER]) ON [PRIMARY]
GO
CREATE INDEX [U_FTP_AE] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_NOMEFI]) ON [PRIMARY]
GO



-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_PER_AN  FILE DELL'ANAGRAFICA DEL PERSONALE
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_PER_A1')
   drop index U_PER_AN.U_PER_A1
GO
if exists (select name from dbo.sysindexes where name = 'U_PER_A2')
   drop index U_PER_AN.U_PER_A2
GO
if exists (select name from dbo.sysindexes where name = 'U_PER_A3')
   drop index U_PER_AN.U_PER_A3
GO
if exists (select name from dbo.sysindexes where name = 'U_PER_A4')
   drop index U_PER_AN.U_PER_A4
GO
if exists (select name from dbo.sysindexes where name = 'U_PER_A5')
   drop index U_PER_AN.U_PER_A5
GO

CREATE INDEX [U_PER_A1] ON [dbo].[U_PER_AN]([PER_CODSOC], [PER_CODICE]) ON [PRIMARY]
GO
CREATE INDEX [U_PER_A2] ON [dbo].[U_PER_AN]([PER_CODSOC], [PER_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [U_PER_A3] ON [dbo].[U_PER_AN]([PER_CODSOC], [PER_TIPCON]) ON [PRIMARY]
GO
CREATE INDEX [U_PER_A4] ON [dbo].[U_PER_AN]([PER_CODSOC], [PER_DESCON]) ON [PRIMARY]
GO
CREATE INDEX [U_PER_A5] ON [dbo].[U_PER_AN]([PER_CODSOC], [PER_DATCON]) ON [PRIMARY]
GO



-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_PER_PD  FILE DI LEGAME PERSONALE CON IL PDV
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_PER_P1')
   drop index U_PER_PD.U_PER_P1
GO

CREATE INDEX [U_PER_P1] ON [dbo].[U_PER_PD]([PED_CODSOC], [PED_CODPDV]) ON [PRIMARY]
GO



-- ************************************************************************************
-- Indicizzazione tabella U_PRO_OR  FILE DELLE PROPOSTE D'ORDINE DEI PDV
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_PRO_O1')
   drop index U_PRO_OR.U_PRO_O1
GO
if exists (select name from dbo.sysindexes where name = 'U_PRO_O2')
   drop index U_PRO_OR.U_PRO_O2
GO
if exists (select name from dbo.sysindexes where name = 'U_PRO_O3')
   drop index U_PRO_OR.U_PRO_O3
GO

CREATE INDEX [U_PRO_O1] ON [dbo].[U_PRO_OR]([PRO_CODSOC], [PRO_MAGAZZ], [PRO_CODART], [PRO_CDFORN]) ON [PRIMARY]
GO
CREATE INDEX [U_PRO_O2] ON [dbo].[U_PRO_OR]([PRO_CODSOC], [PRO_CODART], [PRO_MAGAZZ]) ON [PRIMARY]
GO
CREATE INDEX [U_PRO_O3] ON [dbo].[U_PRO_OR]([PRO_CODSOC], [PRO_CDGRME], [PRO_MAGAZZ]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_PRB_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'PRBHOOKD')
   drop index U_PRB_DD.PRBHOOKD
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_DA')
   drop index U_PRB_DD.U_PRB_DA
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_AM')
   drop index U_PRB_DD.U_PRB_AM
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_SY')
   drop index U_PRB_DD.U_PRB_SY
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_DO')
   drop index U_PRB_DD.U_PRB_DO
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_MR')
   drop index U_PRB_DD.U_PRB_MR
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_01')
   drop index U_PRB_DD.U_PRB_01
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_02')
   drop index U_PRB_DD.U_PRB_02
GO

CREATE INDEX [PRBHOOKD] ON [dbo].[U_PRB_DD]([DAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_DA] ON [dbo].[U_PRB_DD]([ORD_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_AM] ON [dbo].[U_PRB_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_SY] ON [dbo].[U_PRB_DD]([ORD_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_DO] ON [dbo].[U_PRB_DD]([ORS_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_MR] ON [dbo].[U_PRB_DD]([ORS_NUMORC], [ORS_DATORC], [ORS_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_01] ON [dbo].[U_PRB_DD]([ORD_CODART], [ORD_MAGA], [ORS_CODCLI], [ORD_FLGSCP]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_02] ON [dbo].[U_PRB_DD]([ORD_CODART], [ORD_MAGA], [ORD_FORNIT]) ON [PRIMARY]
GO
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRB_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'PRBHOOKT')
   drop index U_PRB_TT.PRBHOOKT
GO
if exists (select name from dbo.sysindexes where name = 'PRBNDOCT')
   drop index U_PRB_TT.PRBNDOCT
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_TN')
   drop index U_PRB_TT.U_PRB_TN
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_TD')
   drop index U_PRB_TT.U_PRB_TD
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_TC')
   drop index U_PRB_TT.U_PRB_TC
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_TA')
   drop index U_PRB_TT.U_PRB_TA
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_DA')
   drop index U_PRB_TT.U_PRB_DA
GO
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_PRB_TT.T_NUMERIC
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_RG')
   drop index U_PRB_TT.U_PRB_RG
GO
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_PRB_TT.T_INDICE
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_SY')
   drop index U_PRB_TT.U_PRB_SY
GO
if exists (select name from dbo.sysindexes where name = 'FPS_INDICE')
   drop index U_PRB_TT.FPS_INDICE
GO
if exists (select name from dbo.sysindexes where name = 'FPS_VETTO1')
   drop index U_PRB_TT.FPS_VETTO1
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_CC')
   drop index U_PRB_TT.U_PRB_CC
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_OR')
   drop index U_PRB_TT.U_PRB_OR
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_01')
   drop index U_PRB_TT.U_PRB_01
GO
if exists (select name from dbo.sysindexes where name = 'U_PRB_02')
   drop index U_PRB_TT.U_PRB_02
GO

CREATE INDEX [PRBHOOKT] ON [dbo].[U_PRB_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [PRBNDOCT] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_TN] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_TD] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_TC] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_TA] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_DA] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [T_NUMERIC] ON [dbo].[U_PRB_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_RG] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [T_INDICE] ON [dbo].[U_PRB_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_SY] ON [dbo].[U_PRB_TT]([ORD_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [FPS_INDICE] ON [dbo].[U_PRB_TT]([ORD_DATORD], [ORD_NUMORD], [ORD_CODEMI], [ORD_TIPORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_CC] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_OR] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_01] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_FLGCON], [ORD_FLBOL], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_02] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_CODBUN], [ORD_FLGCON], [ORD_NUMORD]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_ORF_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ORFHOOKD')
   drop index U_ORF_DD.ORFHOOKD
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_DA')
   drop index U_ORF_DD.U_ORF_DA
GO
if exists (select name from dbo.sysindexes where name = 'RIGART')
   drop index U_ORF_DD.RIGART
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_AM')
   drop index U_ORF_DD.U_ORF_AM
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_01')
   drop index U_ORF_DD.U_ORF_01
GO

CREATE INDEX [ORFHOOKD] ON [dbo].[U_ORF_DD]([DAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_DA] ON [dbo].[U_ORF_DD]([ORD_CODART]) ON [PRIMARY]
GO
CREATE INDEX [RIGART] ON [dbo].[U_ORF_DD]([DAGGANCIO], [ORD_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_AM] ON [dbo].[U_ORF_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_01] ON [dbo].[U_ORF_DD]([DAGGANCIO], [ORD_CODSYS]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_ORF_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ORFHOOKT')
   drop index U_ORF_TT.ORFHOOKT
GO
if exists (select name from dbo.sysindexes where name = 'ORFNDOCT')
   drop index U_ORF_TT.ORFNDOCT
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_TN')
   drop index U_ORF_TT.U_ORF_TN
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_TD')
   drop index U_ORF_TT.U_ORF_TD
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_TC')
   drop index U_ORF_TT.U_ORF_TC
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_TA')
   drop index U_ORF_TT.U_ORF_TA
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_RG')
   drop index U_ORF_TT.U_ORF_RG
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_DA')
   drop index U_ORF_TT.U_ORF_DA
GO
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_ORF_TT.T_INDICE
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_OR')
   drop index U_ORF_TT.U_ORF_OR
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_01')
   drop index U_ORF_TT.U_ORF_01
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_02')
   drop index U_ORF_TT.U_ORF_02
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_03')
   drop index U_ORF_TT.U_ORF_03
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_04')
   drop index U_ORF_TT.U_ORF_04
GO

CREATE INDEX [ORFHOOKT] ON [dbo].[U_ORF_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [ORFNDOCT] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_TN] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_TD] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_TC] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_TA] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_RG] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_DA] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [T_INDICE] ON [dbo].[U_ORF_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_OR] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_01] ON [dbo].[U_ORF_TT]([ORD_FLGTIP], [ORD_CHIUSO], [ORD_CODBUN], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_02] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_FLGTIP], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_03] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_FLGTIP], [ORD_CODBUN], [ORD_ANNO], [ORD_NUMORD], [ORD_CODCLI], [ORD_FLGCON]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_04] ON [dbo].[U_ORF_TT]([ORD_FLGTIP], [ORD_CHIUSO], [ORD_FLGCON], [ORD_CODBUN], [ORD_CODCLI]) ON [PRIMARY]
GO


-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_ORF_PO  FILE DELLE PROPOSTE D'ORDINE DI RITORNO AI PDV
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_ORF_P1')
   drop index U_ORF_PO.U_ORF_P1
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P2')
   drop index U_ORF_PO.U_ORF_P2
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P3')
   drop index U_ORF_PO.U_ORF_P3
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P4')
   drop index U_ORF_PO.U_ORF_P4
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P5')
   drop index U_ORF_PO.U_ORF_P5
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P6')
   drop index U_ORF_PO.U_ORF_P6
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P7')
   drop index U_ORF_PO.U_ORF_P7
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P8')
   drop index U_ORF_PO.U_ORF_P8
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P9')
   drop index U_ORF_PO.U_ORF_P9
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P0')
   drop index U_ORF_PO.U_ORF_P0
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_PA')
   drop index U_ORF_PO.U_ORF_PA
GO

CREATE INDEX [U_ORF_P1] ON [dbo].[U_ORF_PO]([ORF_FLGTRA], [ORF_CODPDV], [ORF_FLGCON]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P2] ON [dbo].[U_ORF_PO]([ORF_CODPDV], [ORF_CODMAG], [ORF_CODART], [ORF_NUMPRO], [ORF_DATPRO], [ORF_CODFOR], [ORF_NUMORD], [ORF_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P3] ON [dbo].[U_ORF_PO]([ORF_ANNO], [ORF_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P4] ON [dbo].[U_ORF_PO]([ORF_CODSYS], [ORF_AGGANC]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P5] ON [dbo].[U_ORF_PO]([ORF_CODPDV], [ORF_NUMPRO], [ORF_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P6] ON [dbo].[U_ORF_PO]([ORF_CHIUSO], [ORF_CODPDV], [ORF_CODFOR], [ORF_ANNO], [ORF_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P7] ON [dbo].[U_ORF_PO]([ORF_QTADOR], [ORF_CODPDV], [ORF_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P8] ON [dbo].[U_ORF_PO]([ORF_QTADOR], [ORF_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P9] ON [dbo].[U_ORF_PO]([ORF_UNIQUE], [ORF_AGGANC]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P0] ON [dbo].[U_ORF_PO]([ORF_CODFOR], [ORF_NUMORD], [ORF_DATORD], [ORF_ANNO], [ORF_TIPAGG]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_PA] ON [dbo].[U_ORF_PO]([ORF_AGGANC], [ORF_SYSSYS]) ON [PRIMARY]
GO

-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_ORF_CO  FILE DELLE SPEDIZIONI FATTE DALLA SEDE CENTRALE AI PDV
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_ORF_C1')
   drop index U_ORF_CO.U_ORF_C1
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_C2')
   drop index U_ORF_CO.U_ORF_C2
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_C3')
   drop index U_ORF_CO.U_ORF_C3
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_C4')
   drop index U_ORF_CO.U_ORF_C4
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_C5')
   drop index U_ORF_CO.U_ORF_C5
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_C6')
   drop index U_ORF_CO.U_ORF_C6
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_C7')
   drop index U_ORF_CO.U_ORF_C7
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_C8')
   drop index U_ORF_CO.U_ORF_C8
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_C9')
   drop index U_ORF_CO.U_ORF_C9
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_C0')
   drop index U_ORF_CO.U_ORF_C0
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_CC')
   drop index U_ORF_CO.U_ORF_CC
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_CA')
   drop index U_ORF_CO.U_ORF_CA
GO

CREATE INDEX [U_ORF_C1] ON [dbo].[U_ORF_CO]([ORF_FLGTRA], [ORF_CODPDV], [ORF_FLGCON]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_C2] ON [dbo].[U_ORF_CO]([ORF_CODPDV], [ORF_CODMAG], [ORF_CODART], [ORF_NUMPRO], [ORF_DATPRO], [ORF_CODFOR], [ORF_NUMORD], [ORF_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_C3] ON [dbo].[U_ORF_CO]([ORF_ANNO], [ORF_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_C4] ON [dbo].[U_ORF_CO]([ORF_CODSYS], [ORF_AGGANC]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_C5] ON [dbo].[U_ORF_CO]([ORF_CODPDV], [ORF_NUMPRO], [ORF_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_C6] ON [dbo].[U_ORF_CO]([ORF_CHIUSO], [ORF_CODPDV], [ORF_CODFOR], [ORF_ANNO], [ORF_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_C7] ON [dbo].[U_ORF_CO]([ORF_QTADOR], [ORF_CODPDV], [ORF_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_C8] ON [dbo].[U_ORF_CO]([ORF_QTADOR], [ORF_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_C9] ON [dbo].[U_ORF_CO]([ORF_UNIQUE], [ORF_AGGANC]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_C0] ON [dbo].[U_ORF_CO]([ORF_CODSYS], [ORF_CODART], [ORF_CODMAG]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_CC] ON [dbo].[U_ORF_CO]([ORF_FLGTRA], [ORF_FLGCON]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_CA] ON [dbo].[U_ORF_CO]([ORF_AGGANC], [ORF_SYSSYS]) ON [PRIMARY]
GO


-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_ORF_DT  FILE DEI CARICHI A FRONTE DI PROPOSTE D'ORDINE E 
-- ORDINI A FORNITORI
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_ORF_P1')
   drop index U_ORF_DT.U_ORF_P1
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P2')
   drop index U_ORF_DT.U_ORF_P2
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P3')
   drop index U_ORF_DT.U_ORF_P3
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P4')
   drop index U_ORF_DT.U_ORF_P4
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P5')
   drop index U_ORF_DT.U_ORF_P5
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P6')
   drop index U_ORF_DT.U_ORF_P6
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P7')
   drop index U_ORF_DT.U_ORF_P7
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_P8')
   drop index U_ORF_DT.U_ORF_P8
GO

CREATE INDEX [U_ORF_P1] ON [dbo].[U_ORF_DT]([ORF_FLGTRA], [ORF_CODPDV]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P2] ON [dbo].[U_ORF_DT]([ORF_CODPDV], [ORF_CODMAG], [ORF_CODART], [ORF_NUMPRO], [ORF_DATPRO], [ORF_CODFOR], [ORF_NUMORD], [ORF_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P3] ON [dbo].[U_ORF_DT]([ORF_ANNO], [ORF_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P4] ON [dbo].[U_ORF_DT]([ORF_CODSYS], [ORF_AGGANC]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P5] ON [dbo].[U_ORF_DT]([ORF_CODPDV], [ORF_NUMPRO], [ORF_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P6] ON [dbo].[U_ORF_DT]([ORF_CHIUSO], [ORF_CODPDV], [ORF_CODFOR], [ORF_ANNO], [ORF_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P7] ON [dbo].[U_ORF_DT]([ORF_NUMORD], [ORF_DATORD], [ORF_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_P8] ON [dbo].[U_ORF_DT]([ORF_AGGANC], [ORF_SYSSYS], [ORF_NUMPRO], [ORF_NUMORD], [ORF_NUMDDT]) ON [PRIMARY]
GO

-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_BOL_RE  FILE DELLE SPEDIZIONI FATTE DALLA SEDE CENTRALE AI PDV
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_BOL_C1')
   drop index U_BOL_RE.U_BOL_C1
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_C2')
   drop index U_BOL_RE.U_BOL_C2
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_C3')
   drop index U_BOL_RE.U_BOL_C3
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_C4')
   drop index U_BOL_RE.U_BOL_C4
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_C5')
   drop index U_BOL_RE.U_BOL_C5
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_C6')
   drop index U_BOL_RE.U_BOL_C6
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_C7')
   drop index U_BOL_RE.U_BOL_C7
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_C8')
   drop index U_BOL_RE.U_BOL_C8
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_C9')
   drop index U_BOL_RE.U_BOL_C9
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_C0')
   drop index U_BOL_RE.U_BOL_C0
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_CA')
   drop index U_BOL_RE.U_BOL_CA
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_CB')
   drop index U_BOL_RE.U_BOL_CB
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_CC')
   drop index U_BOL_RE.U_BOL_CC
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_CD')
   drop index U_BOL_RE.U_BOL_CD
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_CE')
   drop index U_BOL_RE.U_BOL_CE
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_CF')
   drop index U_BOL_RE.U_BOL_CF
GO

CREATE INDEX [U_BOL_C1] ON [dbo].[U_BOL_RE]([ORF_FLGTRA], [ORF_CODPDV], [ORF_FLGCON]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_C2] ON [dbo].[U_BOL_RE]([ORF_CODPDV], [ORF_CODMAG], [ORF_CODART], [ORF_NUMPRO], [ORF_DATPRO], [ORF_CODFOR], [ORF_NUMORD], [ORF_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_C3] ON [dbo].[U_BOL_RE]([ORF_ANNO], [ORF_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_C4] ON [dbo].[U_BOL_RE]([ORF_CODSYS], [ORF_AGGANC]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_C5] ON [dbo].[U_BOL_RE]([ORF_CODPDV], [ORF_NUMPRO], [ORF_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_C6] ON [dbo].[U_BOL_RE]([ORF_CHIUSO], [ORF_CODPDV], [ORF_CODFOR], [ORF_ANNO], [ORF_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_C7] ON [dbo].[U_BOL_RE]([ORF_QTADOR], [ORF_CODPDV], [ORF_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_C8] ON [dbo].[U_BOL_RE]([ORF_QTADOR], [ORF_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_C9] ON [dbo].[U_BOL_RE]([ORF_UNIQUE], [ORF_AGGANC]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_C0] ON [dbo].[U_BOL_RE]([ORF_CODSYS], [ORF_CODART], [ORF_CODMAG]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_CA] ON [dbo].[U_BOL_RE]([ORF_FLGTRA], [ORF_FLGCON]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_CB] ON [dbo].[U_BOL_RE]([ORF_AGGANC], [ORF_SYSSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_CC] ON [dbo].[U_BOL_RE]([ORF_AGGANC], [ORF_UNIQUE], [ORF_NUMPRO], [ORF_NUMDDT]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_CD] ON [dbo].[U_BOL_RE]([ORF_CODART], [ORF_NUMPRO], [ORF_DATPRO]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_CE] ON [dbo].[U_BOL_RE]([ORF_CHIUSO], [ORF_CODMIT], [ORF_CODFOR]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_CF] ON [dbo].[U_BOL_RE]([ORF_CHIUSO], [ORF_CODPDV], [ORF_CODMIT], [ORF_ANNO], [ORF_NUMDDT]) ON [PRIMARY]
GO

-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_PER_CO  FILE DEI COMPENSI MENSILI DEI COLLABORATORI
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_PER_C1')
   drop index U_PER_CO.U_PER_C1
GO
if exists (select name from dbo.sysindexes where name = 'U_PER_C2')
   drop index U_PER_CO.U_PER_C2
GO
if exists (select name from dbo.sysindexes where name = 'U_PER_C3')
   drop index U_PER_CO.U_PER_C3
GO
if exists (select name from dbo.sysindexes where name = 'U_PER_C4')
   drop index U_PER_CO.U_PER_C4
GO
CREATE INDEX [U_PER_C1] ON [dbo].[U_PER_CO]([PER_CODSOC], [PER_CODICE], [PER_CODPDV], [PER_ANNO], [PER_MESE]) ON [PRIMARY]
GO
CREATE INDEX [U_PER_C2] ON [dbo].[U_PER_CO]([PER_CODSOC], [PER_CODPDV], [PER_CODICE], [PER_ANNO], [PER_MESE]) ON [PRIMARY]
GO
CREATE INDEX [U_PER_C3] ON [dbo].[U_PER_CO]([PER_CODSOC], [PER_ANNO], [PER_MESE], [PER_CODPDV], [PER_CODICE]) ON [PRIMARY]
GO
CREATE INDEX [U_PER_C4] ON [dbo].[U_PER_CO]([PER_CODSOC], [PER_ANNO], [PER_MESE], [PER_CODICE]) ON [PRIMARY]
GO

-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_CON_PE  FILE DEI CONTRATTI DEI COLLABORATORI
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_CON_P1')
   drop index U_CON_PE.U_CON_P1
GO
if exists (select name from dbo.sysindexes where name = 'U_CON_P2')
   drop index U_CON_PE.U_CON_P2
GO
if exists (select name from dbo.sysindexes where name = 'U_CON_P3')
   drop index U_CON_PE.U_CON_P3
GO
if exists (select name from dbo.sysindexes where name = 'U_CON_P4')
   drop index U_CON_PE.U_CON_P4
GO

CREATE INDEX [U_CON_P1] ON [dbo].[U_CON_PE]([CON_CODICE]) ON [PRIMARY]
GO
CREATE INDEX [U_CON_P2] ON [dbo].[U_CON_PE]([CON_DESCRI]) ON [PRIMARY]
GO
CREATE INDEX [U_CON_P3] ON [dbo].[U_CON_PE]([CON_SIGLA]) ON [PRIMARY]
GO
CREATE INDEX [U_CON_P4] ON [dbo].[U_CON_PE]([CON_TIPCON]) ON [PRIMARY]
GO

-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_CAL_LA  CALENDARIO LAVORATIVO
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_CAL_L1')
   drop index U_CAL_LA.U_CAL_L1
GO
if exists (select name from dbo.sysindexes where name = 'U_CAL_L2')
   drop index U_CAL_LA.U_CAL_L2
GO
if exists (select name from dbo.sysindexes where name = 'U_CAL_L3')
   drop index U_CAL_LA.U_CAL_L3
GO

CREATE INDEX [U_CAL_L1] ON [dbo].[U_CAL_LA]([CAL_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_L2] ON [dbo].[U_CAL_LA]([CAL_DATAMG]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_L3] ON [dbo].[U_CAL_LA]([CAL_DATA]) ON [PRIMARY]
GO

-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_CAL_AS  ASSENZE COLLABORATORI
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_CAL_A1')
   drop index U_CAL_AS.U_CAL_A1
GO
if exists (select name from dbo.sysindexes where name = 'U_CAL_A2')
   drop index U_CAL_AS.U_CAL_A2
GO
if exists (select name from dbo.sysindexes where name = 'U_CAL_A3')
   drop index U_CAL_AS.U_CAL_A3
GO
if exists (select name from dbo.sysindexes where name = 'U_CAL_A4')
   drop index U_CAL_AS.U_CAL_A4
GO

CREATE INDEX [U_CAL_A1] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_CODPDV], [CAL_CODCOL], [CAL_DATA]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_A2] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_CODCOL]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_A3] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_DESCOL], [CAL_CODCOL], [CAL_DATA]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_A4] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_DATA]) ON [PRIMARY]
GO

-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_MON_CA  MONITORAGGIO CASSE
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_MON_C1')
   drop index U_MON_CA.U_MON_C1
GO
if exists (select name from dbo.sysindexes where name = 'U_MON_C2')
   drop index U_MON_CA.U_MON_C2
GO
CREATE INDEX [U_MON_C1] ON [dbo].[U_MON_CA]([MON_CODSOC], [MON_CODPDV], [MON_CODCAS], [MON_DATINI], [MON_ORAINI]) ON [PRIMARY]
GO
CREATE INDEX [U_MON_C2] ON [dbo].[U_MON_CA]([MON_CODSOC], [MON_CODPDV], [MON_CODCAS], [MON_AMGINI], [MON_ORAINI]) ON [PRIMARY]
GO

-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_MON_PE  MONITORAGGIO VISITATORI DEL PDV
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_MON_P1')
   drop index U_MON_PE.U_MON_P1
GO
if exists (select name from dbo.sysindexes where name = 'U_MON_P2')
   drop index U_MON_PE.U_MON_P2
GO
CREATE INDEX [U_MON_P1] ON [dbo].[U_MON_PE]([MON_CODSOC], [MON_CODPDV], [MON_DATGMA]) ON [PRIMARY]
GO
CREATE INDEX [U_MON_P2] ON [dbo].[U_MON_PE]([MON_CODSOC], [MON_CODPDV], [MON_DATAMG]) ON [PRIMARY]
GO

-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_ALT_DA  ALTRI DATI PER FUNZIONE DI MAGAZZINO
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_ALT_D1')
   drop index U_ALT_DA.U_ALT_D1
GO
CREATE INDEX [U_ALT_D1] ON [dbo].[U_ALT_DA]([ALT_DADOVE], [ALT_CODMAG], [ALT_LEGAME]) ON [PRIMARY]
GO

-- ********************************************************************************


-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_MSG_AU  MESSAGGI AUTOMATICI TRA PDV/SEDE/PDV
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_MSG_01')
   drop index U_MSG_AU.U_MSG_01
GO
if exists (select name from dbo.sysindexes where name = 'U_MSG_02')
   drop index U_MSG_AU.U_MSG_02
GO
if exists (select name from dbo.sysindexes where name = 'U_MSG_03')
   drop index U_MSG_AU.U_MSG_03
GO
if exists (select name from dbo.sysindexes where name = 'U_MSG_04')
   drop index U_MSG_AU.U_MSG_04
GO
if exists (select name from dbo.sysindexes where name = 'U_MSG_05')
   drop index U_MSG_AU.U_MSG_05
GO
if exists (select name from dbo.sysindexes where name = 'U_MSG_06')
   drop index U_MSG_AU.U_MSG_06
GO
if exists (select name from dbo.sysindexes where name = 'U_MSG_07')
   drop index U_MSG_AU.U_MSG_07
GO
if exists (select name from dbo.sysindexes where name = 'U_MSG_08')
   drop index U_MSG_AU.U_MSG_08
GO

CREATE INDEX [U_MSG_01] ON [dbo].[U_MSG_AU]([MSG_CODMIT], [MSG_CODDES], [MSG_DESDES], [MSG_CODOPE], [MSG_DATINV], [MSG_ORAINV]) ON [PRIMARY]
GO
CREATE INDEX [U_MSG_02] ON [dbo].[U_MSG_AU]([MSG_CODSOC], [MSG_CODMIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MSG_03] ON [dbo].[U_MSG_AU]([MSG_CODSOC], [MSG_DESMIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MSG_04] ON [dbo].[U_MSG_AU]([MSG_CODSOC], [MSG_CODOPE]) ON [PRIMARY]
GO
CREATE INDEX [U_MSG_05] ON [dbo].[U_MSG_AU]([MSG_CODSOC], [MSG_DESOPE]) ON [PRIMARY]
GO
CREATE INDEX [U_MSG_06] ON [dbo].[U_MSG_AU]([MSG_CODSOC], [MSG_DESDES]) ON [PRIMARY]
GO
CREATE INDEX [U_MSG_07] ON [dbo].[U_MSG_AU]([MSG_CODSOC], [MSG_DATINV]) ON [PRIMARY]
GO
CREATE INDEX [U_MSG_08] ON [dbo].[U_MSG_AU]([MSG_FLGTRA], [MSG_FLGCON]) ON [PRIMARY]
GO

-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_ORF_DL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_ORF_01')
   drop index U_ORF_DL.U_ORF_01
GO

CREATE INDEX [U_ORF_01] ON [dbo].[U_ORF_DL]([DAGGANCIO]) ON [PRIMARY]
GO

-- ********************************************************************************
