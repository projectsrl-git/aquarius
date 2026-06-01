-- ********************************************************************************
-- Indicizzazione tabella ABICAB.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella ANAART.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BOL_RE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_BOL_RE.INDICE_01
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_BOL_RE]([ORF_UNIQUE], [ORF_AGGANC]) ON [PRIMARY]
GO





-- ********************************************************************************
-- Indicizzazione tabella ANACLFO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'I_COD')
   drop index ANACLFO.I_COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CATEGO')
   drop index ANACLFO.I_CATEGO
GO
 
CREATE INDEX [I_COD] ON [dbo].[ANACLFO]([CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CATEGO] ON [dbo].[ANACLFO]([CATEGO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella APEFOR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'AGENTE')
   drop index APEFOR.AGENTE
GO
 
if exists (select name from dbo.sysindexes where name = 'DOCUME')
   drop index APEFOR.DOCUME
GO
 
if exists (select name from dbo.sysindexes where name = 'PARTITA')
   drop index APEFOR.PARTITA
GO
 
if exists (select name from dbo.sysindexes where name = 'PARTACC')
   drop index APEFOR.PARTACC
GO
 
CREATE INDEX [AGENTE] ON [dbo].[APEFOR]([PAR_CODSOC], [PAR_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [DOCUME] ON [dbo].[APEFOR]([PAR_CODSOC], [PAR_AGE], [PAR_CODCLI], [PAR_DTFAT], [PAR_NUMFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [PARTITA] ON [dbo].[APEFOR]([PAR_NPART]) ON [PRIMARY]
GO
 
CREATE INDEX [PARTACC] ON [dbo].[APEFOR]([PAR_CODCLI], [PAR_NPART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella APERTE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'AGENTE')
   drop index APERTE.AGENTE
GO
 
if exists (select name from dbo.sysindexes where name = 'DOCUME')
   drop index APERTE.DOCUME
GO
 
if exists (select name from dbo.sysindexes where name = 'PARTITA')
   drop index APERTE.PARTITA
GO
 
if exists (select name from dbo.sysindexes where name = 'PARTACC')
   drop index APERTE.PARTACC
GO
 
CREATE INDEX [AGENTE] ON [dbo].[APERTE]([PAR_CODSOC], [PAR_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [DOCUME] ON [dbo].[APERTE]([PAR_CODSOC], [PAR_AGE], [PAR_CODCLI], [PAR_DTFAT], [PAR_NUMFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [PARTITA] ON [dbo].[APERTE]([PAR_NPART]) ON [PRIMARY]
GO
 
CREATE INDEX [PARTACC] ON [dbo].[APERTE]([PAR_CODCLI], [PAR_NPART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella APPOGGIO.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella ART_TRA.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella BILNEW.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RIGA')
   drop index BILNEW.RIGA
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index BILNEW.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'BILNEW')
   drop index BILNEW.BILNEW
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index BILNEW.INDICE_01
GO
 
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index BILNEW.INDICE_02
GO

 
CREATE INDEX [RIGA] ON [dbo].[BILNEW]([BIL_CODSOC], [BIL_CODRIG]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[BILNEW]([DESCRIZION]) ON [PRIMARY]
GO
 
CREATE INDEX [BILNEW] ON [dbo].[BILNEW]([BIL_CODSOC], [BIL_CODRIG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[BILNEW]([BIL_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[BILNEW]([BIL_CODRIG]) ON [PRIMARY]
GO




 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CCOSTO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index CCOSTO.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index CCOSTO.CONTO
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index CCOSTO.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index CCOSTO.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index CCOSTO.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index CCOSTO.INDICE_04
GO


 
CREATE INDEX [DESCRIZION] ON [dbo].[CCOSTO]([CON_SOC], [CON_ANNO], [CON_DESCR]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[CCOSTO]([CON_SOC], [CON_ANNO], [CON_CONTO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[CCOSTO]([CON_SOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[CCOSTO]([CON_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[CCOSTO]([CON_CONTO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[CCOSTO]([CON_DESCR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CCOSTX.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CHIUSURA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CHIUSURA')
   drop index CHIUSURA.CHIUSURA
GO
 
CREATE INDEX [CHIUSURA] ON [dbo].[CHIUSURA]([FIN_CODSOC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CLIENTI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODCLI')
   drop index CLIENTI.CODCLI
GO
 
if exists (select name from dbo.sysindexes where name = 'RAGSOC')
   drop index CLIENTI.RAGSOC
GO
 
CREATE INDEX [CODCLI] ON [dbo].[CLIENTI]([CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [RAGSOC] ON [dbo].[CLIENTI]([RAGSOC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella COMMESSE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'COMM1')
   drop index COMMESSE.COMM1
GO
 
if exists (select name from dbo.sysindexes where name = 'COMM2')
   drop index COMMESSE.COMM2
GO
 
if exists (select name from dbo.sysindexes where name = 'COMM3')
   drop index COMMESSE.COMM3
GO
 
if exists (select name from dbo.sysindexes where name = 'COMM4')
   drop index COMMESSE.COMM4
GO
 
CREATE INDEX [COMM3] ON [dbo].[COMMESSE]([DATAC], [CLIENTE]) ON [PRIMARY]
GO
 
CREATE INDEX [COMM4] ON [dbo].[COMMESSE]([NORDCLI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella COMUNI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index COMUNI.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index COMUNI.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index COMUNI.INDICE_03
GO

 
CREATE INDEX [INDICE_01] ON [dbo].[COMUNI]([CAP]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[COMUNI]([COD_FIS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[COMUNI]([COMUNE]) ON [PRIMARY]
GO 

-- ********************************************************************************
 
-- ********************************************************************************
-- Indicizzazione tabella CONTATTI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CONTA')
   drop index CONTATTI.CONTA
GO
 
if exists (select name from dbo.sysindexes where name = 'DITTA')
   drop index CONTATTI.DITTA
GO
 
if exists (select name from dbo.sysindexes where name = 'CITTA')
   drop index CONTATTI.CITTA
GO
 
if exists (select name from dbo.sysindexes where name = 'CAP')
   drop index CONTATTI.CAP
GO
 
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index CONTATTI.CODICE
GO
 
if exists (select name from dbo.sysindexes where name = 'SUBCOD')
   drop index CONTATTI.SUBCOD
GO
 
if exists (select name from dbo.sysindexes where name = 'GROSSI')
   drop index CONTATTI.GROSSI
GO
 
if exists (select name from dbo.sysindexes where name = 'KEY1')
   drop index CONTATTI.KEY1
GO
 
if exists (select name from dbo.sysindexes where name = 'KEY2')
   drop index CONTATTI.KEY2
GO
 
if exists (select name from dbo.sysindexes where name = 'IDITTA')
   drop index CONTATTI.IDITTA
GO
 
if exists (select name from dbo.sysindexes where name = 'SETAT')
   drop index CONTATTI.SETAT
GO
 
if exists (select name from dbo.sysindexes where name = 'TIPROD')
   drop index CONTATTI.TIPROD
GO
 
if exists (select name from dbo.sysindexes where name = 'PROV')
   drop index CONTATTI.PROV
GO
 
if exists (select name from dbo.sysindexes where name = 'CODFIS')
   drop index CONTATTI.CODFIS
GO
 
if exists (select name from dbo.sysindexes where name = 'TELEF')
   drop index CONTATTI.TELEF
GO
 
if exists (select name from dbo.sysindexes where name = 'PIVA')
   drop index CONTATTI.PIVA
GO
 
if exists (select name from dbo.sysindexes where name = 'NAZIONE')
   drop index CONTATTI.NAZIONE
GO
 
if exists (select name from dbo.sysindexes where name = 'REGIONE')
   drop index CONTATTI.REGIONE
GO
 
if exists (select name from dbo.sysindexes where name = 'OCONT')
   drop index CONTATTI.OCONT
GO
 
if exists (select name from dbo.sysindexes where name = 'CODSUB')
   drop index CONTATTI.CODSUB
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index CONTATTI.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index CONTATTI.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index CONTATTI.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index CONTATTI.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index CONTATTI.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index CONTATTI.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index CONTATTI.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index CONTATTI.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index CONTATTI.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index CONTATTI.INDICE_10
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index CONTATTI.INDICE_11
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index CONTATTI.INDICE_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index CONTATTI.INDICE_13
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_14')
   drop index CONTATTI.INDICE_14
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_15')
   drop index CONTATTI.INDICE_15
GO



CREATE INDEX [CONTA] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_CONTA]) ON [PRIMARY]
GO
 
CREATE INDEX [DITTA] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_DITTA]) ON [PRIMARY]
GO
 
CREATE INDEX [CITTA] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_CITTA]) ON [PRIMARY]
GO
 
CREATE INDEX [CAP] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_CAP]) ON [PRIMARY]
GO
 
CREATE INDEX [CODICE] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [SUBCOD] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_SUBCO]) ON [PRIMARY]
GO
 
CREATE INDEX [GROSSI] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_GROSSI]) ON [PRIMARY]
GO
  
CREATE INDEX [IDITTA] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_IDITTA]) ON [PRIMARY]
GO
 
CREATE INDEX [SETAT] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_SETAT]) ON [PRIMARY]
GO
 
CREATE INDEX [TIPROD] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_TIPROD]) ON [PRIMARY]
GO
 
CREATE INDEX [PROV] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_PR]) ON [PRIMARY]
GO
 
CREATE INDEX [CODFIS] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_CODFIS]) ON [PRIMARY]
GO
 
CREATE INDEX [TELEF] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_TELEF]) ON [PRIMARY]
GO
 
CREATE INDEX [PIVA] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_IVA]) ON [PRIMARY]
GO
 
CREATE INDEX [NAZIONE] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_NAZION]) ON [PRIMARY]
GO
 
CREATE INDEX [REGIONE] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_REGIO]) ON [PRIMARY]
GO
 
CREATE INDEX [OCONT] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_OCONT]) ON [PRIMARY]
GO
 
CREATE INDEX [CODSUB] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_CODICE], [MAI_SUBCO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[CONTATTI]([MAI_CONTA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[CONTATTI]([MAI_DITTA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[CONTATTI]([MAI_CITTA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[CONTATTI]([MAI_CAP]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[CONTATTI]([MAI_GROSSI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[CONTATTI]([MAI_CODICE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[CONTATTI]([MAI_SUBCO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_SUBCO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[CONTATTI]([MAI_KEY1]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_KEY1]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_11] ON [dbo].[CONTATTI]([MAI_KEY2]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_12] ON [dbo].[CONTATTI]([MAI_CODSOC], [MAI_KEY2]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_13] ON [dbo].[CONTATTI]([MAI_IDITTA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_14] ON [dbo].[CONTATTI]([MAI_SETAT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_15] ON [dbo].[CONTATTI]([MAI_TIPROD]) ON [PRIMARY]
GO







 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index CONTI.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index CONTI.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index CONTI.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index CONTI.INDICE_04
GO







CREATE INDEX [DESCRIZION] ON [dbo].[CONTI]([CON_SOC], [CON_ANNO], [CON_DESCR]) ON [PRIMARY]
GO
 
--CREATE UNIQUE INDEX [CONTO] ON [dbo].[CONTI]([CON_SOC], [CON_ANNO], [CON_CONTO]) ON [PRIMARY]
CREATE INDEX [CONTO] ON [dbo].[CONTI]([CON_SOC], [CON_ANNO], [CON_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [ANNI] ON [dbo].[CONTI]([CON_SOC], [CON_ANNO], [CON_DESCR]) ON [PRIMARY]
GO
 
CREATE INDEX [PIVA] ON [dbo].[CONTI]([CON_SOC], [CON_ANNO], [CON_PARIVA]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCON] ON [dbo].[CONTI]([CON_SOC], [CON_DESCR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[CONTI]([CON_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[CONTI]([CON_CONTO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[CONTI]([CON_DESCR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[CONTI]([CON_SOC], [CON_CONTO]) ON [PRIMARY]
GO











 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CONTICA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index CONTICA.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index CONTICA.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'ANNI')
   drop index CONTICA.ANNI
GO
 
if exists (select name from dbo.sysindexes where name = 'PIVA')
   drop index CONTICA.PIVA
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCON')
   drop index CONTICA.DESCON
GO
 
if exists (select name from dbo.sysindexes where name = 'CODCONTO')
   drop index CONTICA.CODCONTO
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[CONTICA]([CON_SOC], [CON_ANNO], [CON_DESCR]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[CONTICA]([CON_SOC], [CON_ANNO], [CON_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [ANNI] ON [dbo].[CONTICA]([CON_SOC], [CON_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [PIVA] ON [dbo].[CONTICA]([CON_SOC], [CON_ANNO], [CON_PARIVA]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCON] ON [dbo].[CONTICA]([CON_SOC], [CON_DESCR]) ON [PRIMARY]
GO
 
CREATE INDEX [CODCONTO] ON [dbo].[CONTICA]([CON_SOC], [CON_CONTO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CONTIX.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index CONTIX.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index CONTIX.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'ANNI')
   drop index CONTIX.ANNI
GO
 
if exists (select name from dbo.sysindexes where name = 'PIVA')
   drop index CONTIX.PIVA
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCON')
   drop index CONTIX.DESCON
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[CONTIX]([CON_SOC], [CON_ANNO], [CON_DESCR]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[CONTIX]([CON_SOC], [CON_ANNO], [CON_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [ANNI] ON [dbo].[CONTIX]([CON_SOC], [CON_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [PIVA] ON [dbo].[CONTIX]([CON_SOC], [CON_ANNO], [CON_PARIVA]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCON] ON [dbo].[CONTIX]([CON_SOC], [CON_DESCR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CORPO.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CORPO2.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJ.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJBEBE.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJCAR.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJCLA.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJCRI.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJDAV.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJFAU.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJFLA.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJMAX.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJMOR.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJQ.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella CPJSER.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella D.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella DATI.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella DISEGNI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DISE1')
   drop index DISEGNI.DISE1
GO
 
if exists (select name from dbo.sysindexes where name = 'DISE2')
   drop index DISEGNI.DISE2
GO
 
if exists (select name from dbo.sysindexes where name = 'DISE3')
   drop index DISEGNI.DISE3
GO
 
CREATE INDEX [DISE1] ON [dbo].[DISEGNI]([CODICE], [PDISEGNO], [NUMREV]) ON [PRIMARY]
GO
 
CREATE INDEX [DISE2] ON [dbo].[DISEGNI]([PDISEGNO], [NUMREV], [CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [DISE3] ON [dbo].[DISEGNI]([PDISEGNO], [DTREV]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella DOPPI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index DOPPI.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index DOPPI.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'ANNI')
   drop index DOPPI.ANNI
GO
 
if exists (select name from dbo.sysindexes where name = 'PIVA')
   drop index DOPPI.PIVA
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCON')
   drop index DOPPI.DESCON
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[DOPPI]([CON_SOC], [CON_ANNO], [CON_DESCR]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[DOPPI]([CON_SOC], [CON_ANNO], [CON_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [ANNI] ON [dbo].[DOPPI]([CON_SOC], [CON_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [PIVA] ON [dbo].[DOPPI]([CON_SOC], [CON_ANNO], [CON_PARIVA]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCON] ON [dbo].[DOPPI]([CON_SOC], [CON_DESCR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella ELENTAR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index ELENTAR.CODICE
GO
 
CREATE INDEX [CODICE] ON [dbo].[ELENTAR]([TA_COMPA], [TA_DATA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella EUROLOG.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella FPSMOVC.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RIFERIM')
   drop index FPSMOVC.RIFERIM
GO
 
if exists (select name from dbo.sysindexes where name = 'RICO')
   drop index FPSMOVC.RICO
GO
 
if exists (select name from dbo.sysindexes where name = 'RICO1')
   drop index FPSMOVC.RICO1
GO
 
CREATE INDEX [RIFERIM] ON [dbo].[FPSMOVC]([RIFERIM]) ON [PRIMARY]
GO
 
CREATE INDEX [RICO] ON [dbo].[FPSMOVC]([RIFERIM], [CODICE], [DTREG]) ON [PRIMARY]
GO
 
CREATE INDEX [RICO1] ON [dbo].[FPSMOVC]([CODICE], [RIFERIM], [DTREG]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella INDICE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index INDICE.CONTO
GO
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index INDICE.DESCRIZION
GO
if exists (select name from dbo.sysindexes where name = 'MOV_DTREG')
   drop index INDICE.MOV_DTREG
GO
if exists (select name from dbo.sysindexes where name = 'MOV_NREGIS')
   drop index INDICE.MOV_NREGIS
GO
if exists (select name from dbo.sysindexes where name = 'MOV_NDOC')
   drop index INDICE.MOV_NDOC
GO
if exists (select name from dbo.sysindexes where name = 'MOV_NPROT')
   drop index INDICE.MOV_NPROT
GO
if exists (select name from dbo.sysindexes where name = 'MOV_NUMIN')
   drop index INDICE.MOV_NUMIN
GO
if exists (select name from dbo.sysindexes where name = 'MOV_SELEZI')
   drop index INDICE.MOV_SELEZI
GO
if exists (select name from dbo.sysindexes where name = 'MOV_PRALEG')
   drop index INDICE.MOV_PRALEG
GO
if exists (select name from dbo.sysindexes where name = 'NREGI1996')
   drop index INDICE.NREGI1996
GO
if exists (select name from dbo.sysindexes where name = 'DESCR1996')
   drop index INDICE.DESCR1996
GO
if exists (select name from dbo.sysindexes where name = 'DTREG1996')
   drop index INDICE.DTREG1996
GO
if exists (select name from dbo.sysindexes where name = 'CONTO1996')
   drop index INDICE.CONTO1996
GO
if exists (select name from dbo.sysindexes where name = 'NDOCU1996')
   drop index INDICE.NDOCU1996
GO
if exists (select name from dbo.sysindexes where name = 'NPROT1996')
   drop index INDICE.NPROT1996
GO
if exists (select name from dbo.sysindexes where name = 'NANNO1996')
   drop index INDICE.NANNO1996
GO
if exists (select name from dbo.sysindexes where name = 'NREGI1997')
   drop index INDICE.NREGI1997
GO
if exists (select name from dbo.sysindexes where name = 'DESCR1997')
   drop index INDICE.DESCR1997
GO
if exists (select name from dbo.sysindexes where name = 'DTREG1997')
   drop index INDICE.DTREG1997
GO
if exists (select name from dbo.sysindexes where name = 'CONTO1997')
   drop index INDICE.CONTO1997
GO
if exists (select name from dbo.sysindexes where name = 'NDOCU1997')
   drop index INDICE.NDOCU1997
GO
if exists (select name from dbo.sysindexes where name = 'NPROT1997')
   drop index INDICE.NPROT1997
GO
if exists (select name from dbo.sysindexes where name = 'NANNO1997')
   drop index INDICE.NANNO1997
GO
if exists (select name from dbo.sysindexes where name = 'NREGI1998')
   drop index INDICE.NREGI1998
GO
if exists (select name from dbo.sysindexes where name = 'DESCR1998')
   drop index INDICE.DESCR1998
GO
if exists (select name from dbo.sysindexes where name = 'DTREG1998')
   drop index INDICE.DTREG1998
GO
if exists (select name from dbo.sysindexes where name = 'CONTO1998')
   drop index INDICE.CONTO1998
GO
if exists (select name from dbo.sysindexes where name = 'NDOCU1998')
   drop index INDICE.NDOCU1998
GO
if exists (select name from dbo.sysindexes where name = 'NPROT1998')
   drop index INDICE.NPROT1998
GO
if exists (select name from dbo.sysindexes where name = 'NANNO1998')
   drop index INDICE.NANNO1998
GO
if exists (select name from dbo.sysindexes where name = 'NREGI1999')
   drop index INDICE.NREGI1999
GO
if exists (select name from dbo.sysindexes where name = 'DESCR1999')
   drop index INDICE.DESCR1999
GO
if exists (select name from dbo.sysindexes where name = 'DTREG1999')
   drop index INDICE.DTREG1999
GO
if exists (select name from dbo.sysindexes where name = 'CONTO1999')
   drop index INDICE.CONTO1999
GO
if exists (select name from dbo.sysindexes where name = 'NDOCU1999')
   drop index INDICE.NDOCU1999
GO
if exists (select name from dbo.sysindexes where name = 'NPROT1999')
   drop index INDICE.NPROT1999
GO
if exists (select name from dbo.sysindexes where name = 'NANNO1999')
   drop index INDICE.NANNO1999
GO
if exists (select name from dbo.sysindexes where name = 'NREGI2000')
   drop index INDICE.NREGI2000
GO
if exists (select name from dbo.sysindexes where name = 'DESCR2000')
   drop index INDICE.DESCR2000
GO
if exists (select name from dbo.sysindexes where name = 'DTREG2000')
   drop index INDICE.DTREG2000
GO
if exists (select name from dbo.sysindexes where name = 'CONTO2000')
   drop index INDICE.CONTO2000
GO
if exists (select name from dbo.sysindexes where name = 'NDOCU2000')
   drop index INDICE.NDOCU2000
GO
if exists (select name from dbo.sysindexes where name = 'NPROT2000')
   drop index INDICE.NPROT2000
GO
if exists (select name from dbo.sysindexes where name = 'NANNO2000')
   drop index INDICE.NANNO2000
GO
if exists (select name from dbo.sysindexes where name = 'NREGI2001')
   drop index INDICE.NREGI2001
GO
if exists (select name from dbo.sysindexes where name = 'DESCR2001')
   drop index INDICE.DESCR2001
GO
if exists (select name from dbo.sysindexes where name = 'DTREG2001')
   drop index INDICE.DTREG2001
GO
if exists (select name from dbo.sysindexes where name = 'CONTO2001')
   drop index INDICE.CONTO2001
GO
if exists (select name from dbo.sysindexes where name = 'NDOCU2001')
   drop index INDICE.NDOCU2001
GO
if exists (select name from dbo.sysindexes where name = 'NPROT2001')
   drop index INDICE.NPROT2001
GO
if exists (select name from dbo.sysindexes where name = 'NANNO2001')
   drop index INDICE.NANNO2001
GO
if exists (select name from dbo.sysindexes where name = 'NREGI2002')
   drop index INDICE.NREGI2002
GO
if exists (select name from dbo.sysindexes where name = 'DESCR2002')
   drop index INDICE.DESCR2002
GO
if exists (select name from dbo.sysindexes where name = 'DTREG2002')
   drop index INDICE.DTREG2002
GO
if exists (select name from dbo.sysindexes where name = 'CONTO2002')
   drop index INDICE.CONTO2002
GO
if exists (select name from dbo.sysindexes where name = 'NDOCU2002')
   drop index INDICE.NDOCU2002
GO
if exists (select name from dbo.sysindexes where name = 'NPROT2002')
   drop index INDICE.NPROT2002
GO
if exists (select name from dbo.sysindexes where name = 'NANNO2002')
   drop index INDICE.NANNO2002
GO
if exists (select name from dbo.sysindexes where name = 'NREGI2003')
   drop index INDICE.NREGI2003
GO
if exists (select name from dbo.sysindexes where name = 'DESCR2003')
   drop index INDICE.DESCR2003
GO
if exists (select name from dbo.sysindexes where name = 'DTREG2003')
   drop index INDICE.DTREG2003
GO
if exists (select name from dbo.sysindexes where name = 'CONTO2003')
   drop index INDICE.CONTO2003
GO
if exists (select name from dbo.sysindexes where name = 'NDOCU2003')
   drop index INDICE.NDOCU2003
GO
if exists (select name from dbo.sysindexes where name = 'NPROT2003')
   drop index INDICE.NPROT2003
GO
if exists (select name from dbo.sysindexes where name = 'NANNO2003')
   drop index INDICE.NANNO2003
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index INDICE.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index INDICE.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index INDICE.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index INDICE.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index INDICE.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index INDICE.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index INDICE.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index INDICE.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index INDICE.INDICE_09
GO

CREATE INDEX [CONTO] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_CONTO], [MOV_DTREG]) ON [PRIMARY]
GO
CREATE INDEX [DESCRIZION] ON [dbo].[INDICE]([MOV_SOC], [MOV_DESMOV]) ON [PRIMARY]
GO
CREATE INDEX [MOV_DTREG] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_DTREG], [MOV_NUMPRO]) ON [PRIMARY]
GO
CREATE INDEX [MOV_NREGIS] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_NREGIS]) ON [PRIMARY]
GO
CREATE INDEX [MOV_NDOC] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_NDOC]) ON [PRIMARY]
GO
CREATE INDEX [MOV_NPROT] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_NPROT]) ON [PRIMARY]
GO
CREATE INDEX [MOV_NUMIN] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_NUMPRO]) ON [PRIMARY]
GO
CREATE INDEX [MOV_SELEZI] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [SELEZIONE]) ON [PRIMARY]
GO
CREATE INDEX [MOV_PRALEG] ON [dbo].[INDICE]([MOV_SOC], [MOV_PRALEG], [MOV_DTREG], [MOV_CONTO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_CONTO], [MOV_NDOC], [MOV_DTDOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_CONTO], [MOV_DTDOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_DESMOV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_CONTABILITA_PREVISIONALE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_CATEG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_CATOK]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_DATES]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[INDICE]([MOV_SOC], [MOV_ANNO], [MOV_OKTES]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[INDICE]([MOV_SOC], [MOV_CONTO], [MOV_NDOC], [MOV_DTDOC]) ON [PRIMARY]
GO







 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella INDMACC.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDMAC1')
   drop index INDMACC.INDMAC1
GO
 
if exists (select name from dbo.sysindexes where name = 'INDMAC2')
   drop index INDMACC.INDMAC2
GO
 
if exists (select name from dbo.sysindexes where name = 'INDMAC3')
   drop index INDMACC.INDMAC3
GO
 
if exists (select name from dbo.sysindexes where name = 'INDMAC4')
   drop index INDMACC.INDMAC4
GO
 
CREATE INDEX [INDMAC1] ON [dbo].[INDMACC]([CODICE], [SEQUE]) ON [PRIMARY]
GO
 
CREATE INDEX [INDMAC2] ON [dbo].[INDMACC]([ELEMENTO]) ON [PRIMARY]
GO
 
CREATE INDEX [INDMAC3] ON [dbo].[INDMACC]([SEQUE]) ON [PRIMARY]
GO
 
CREATE INDEX [INDMAC4] ON [dbo].[INDMACC]([ELEMENTO], [CODICE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella INDPROD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDPR1')
   drop index INDPROD.INDPR1
GO
 
if exists (select name from dbo.sysindexes where name = 'INDPR2')
   drop index INDPROD.INDPR2
GO
 
if exists (select name from dbo.sysindexes where name = 'INDPR3')
   drop index INDPROD.INDPR3
GO
 
if exists (select name from dbo.sysindexes where name = 'INDPR4')
   drop index INDPROD.INDPR4
GO
 
CREATE INDEX [INDPR1] ON [dbo].[INDPROD]([CODICE], [SEQUE]) ON [PRIMARY]
GO
 
CREATE INDEX [INDPR2] ON [dbo].[INDPROD]([ELEMENTO]) ON [PRIMARY]
GO
 
CREATE INDEX [INDPR3] ON [dbo].[INDPROD]([SEQUE]) ON [PRIMARY]
GO
 
CREATE INDEX [INDPR4] ON [dbo].[INDPROD]([ELEMENTO], [CODICE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella JOURNAL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DATA')
   drop index JOURNAL.DATA
GO
 
CREATE INDEX [DATA] ON [dbo].[JOURNAL]([LOG_DAT]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella JOURNA_O.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DATA')
   drop index JOURNA_O.DATA
GO
 
CREATE INDEX [DATA] ON [dbo].[JOURNA_O]([LOG_DAT]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella JOURNA_R.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DATA')
   drop index JOURNA_R.DATA
GO
 
if exists (select name from dbo.sysindexes where name = 'NUME')
   drop index JOURNA_R.NUME
GO
 
CREATE INDEX [DATA] ON [dbo].[JOURNA_R]([LOG_DAT]) ON [PRIMARY]
GO
 
CREATE INDEX [NUME] ON [dbo].[JOURNA_R]([LOG_NUM], [LOG_DAT], [LOG_ORA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella LINGUE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'NAZIONE')
   drop index LINGUE.NAZIONE
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index LINGUE.INDICE_01
GO


 
CREATE INDEX [NAZIONE] ON [dbo].[LINGUE]([CODSOC], [COD_NAZ], [TIPO_DOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[LINGUE]([COD_NAZ]) ON [PRIMARY]
GO


 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella LOGERROR.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella LOG_AGE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'AGENTE')
   drop index LOG_AGE.AGENTE
GO
 
CREATE INDEX [AGENTE] ON [dbo].[LOG_AGE]([CODAGE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
CREATE INDEX [I_DATOPE] ON [dbo].[LOG_CONT]([LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_POSOPE] ON [dbo].[LOG_CONT]([LOG_POSOPE], [LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_NOMOPE] ON [dbo].[LOG_CONT]([LOG_NOMOPE], [LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CODOPE] ON [dbo].[LOG_CONT]([LOG_CODOPE], [LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CODCON] ON [dbo].[LOG_CONT]([LOG_CODCON], [LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella LOG_REI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index LOG_REI.CODICE
GO
 

CREATE INDEX [CODICE] ON [dbo].[LOG_REI]([GIORNO], [PROCEDURA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
CREATE INDEX [I_DATOPE] ON [dbo].[LOG_RETE]([LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_POSOPE] ON [dbo].[LOG_RETE]([LOG_POSOPE], [LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_NOMOPE] ON [dbo].[LOG_RETE]([LOG_NOMOPE], [LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CODOPE] ON [dbo].[LOG_RETE]([LOG_CODOPE], [LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CODCON] ON [dbo].[LOG_RETE]([LOG_CODCON], [LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CODSYS] ON [dbo].[LOG_RETE]([LOG_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [I_RISULT] ON [dbo].[LOG_RETE]([LOG_RISULT], [LOG_DATOPE], [LOG_ORAOPE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella LOG_USER.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella L_CMC_IM.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella L_CMC_IS.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella L_CMD_IM.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella L_CMD_IS.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella M1999.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella MACCHINE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'MACCH1')
   drop index MACCHINE.MACCH1
GO
 
if exists (select name from dbo.sysindexes where name = 'MACCH2')
   drop index MACCHINE.MACCH2
GO
 
CREATE INDEX [MACCH1] ON [dbo].[MACCHINE]([CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [MACCH2] ON [dbo].[MACCHINE]([DESC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella MAGAZMP.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'MAGMP1')
   drop index MAGAZMP.MAGMP1
GO
 
if exists (select name from dbo.sysindexes where name = 'MAGMP2')
   drop index MAGAZMP.MAGMP2
GO
 
if exists (select name from dbo.sysindexes where name = 'MAGMP3')
   drop index MAGAZMP.MAGMP3
GO
 
CREATE INDEX [MAGMP1] ON [dbo].[MAGAZMP]([CODICE]) ON [PRIMARY]
GO
  
CREATE INDEX [MAGMP3] ON [dbo].[MAGAZMP]([DATAM]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella MAGAZPF.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'MAGPF1')
   drop index MAGAZPF.MAGPF1
GO
 
if exists (select name from dbo.sysindexes where name = 'MAGPF2')
   drop index MAGAZPF.MAGPF2
GO
 
if exists (select name from dbo.sysindexes where name = 'MAGPF3')
   drop index MAGAZPF.MAGPF3
GO
 
CREATE INDEX [MAGPF1] ON [dbo].[MAGAZPF]([CODICE]) ON [PRIMARY]
GO
  
CREATE INDEX [MAGPF3] ON [dbo].[MAGAZPF]([DATAM]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella MAGGIO99.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella MAG_TRA.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella MAILING.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella MENUOLD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'MENU')
   drop index MENUOLD.MENU
GO
 
CREATE INDEX [MENU] ON [dbo].[MENUOLD]([RES_DESCRI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella MKDUEPJ.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index MKDUEPJ.CODICE
GO
 
CREATE INDEX [CODICE] ON [dbo].[MKDUEPJ]([CODICE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella MOVSTALL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'MOVSTALL')
   drop index MOVSTALL.MOVSTALL
GO
 
if exists (select name from dbo.sysindexes where name = 'MOVSTDES')
   drop index MOVSTALL.MOVSTDES
GO
 
CREATE INDEX [MOVSTALL] ON [dbo].[MOVSTALL]([MOV_CODSOC], [MOV_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [MOVSTDES] ON [dbo].[MOVSTALL]([MOV_CODSOC], [MOV_DESCRI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella MOV_CCO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index MOV_CCO.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index MOV_CCO.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_DTREG')
   drop index MOV_CCO.MOV_DTREG
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMINTER')
   drop index MOV_CCO.NUMINTER
GO
 
CREATE INDEX [CONTO] ON [dbo].[MOV_CCO]([MOV_SOC], [MOV_ANNO], [MOV_CONTO], [MOV_DTREG]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[MOV_CCO]([MOV_SOC], [MOV_DESMOV]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_DTREG] ON [dbo].[MOV_CCO]([MOV_SOC], [MOV_ANNO], [MOV_DTREG], [MOV_NUMPRO]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMINTER] ON [dbo].[MOV_CCO]([MOV_SOC], [MOV_ANNO], [MOV_NUMPRO], [MOV_COPRIM], [MOV_CCO], [MOV_CONTOP]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
CREATE INDEX [NUMINTER] ON [dbo].[MOV_CONT]([MOV_SOC], [MOV_ANNO], [MOV_NUMPRO], [ID_UNIQUE]) ON [PRIMARY]
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella MO_CONCA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index MO_CONCA.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index MO_CONCA.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMINTER')
   drop index MO_CONCA.NUMINTER
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_DTREG')
   drop index MO_CONCA.MOV_DTREG
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_NREGIS')
   drop index MO_CONCA.MOV_NREGIS
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_NDOC')
   drop index MO_CONCA.MOV_NDOC
GO
 
if exists (select name from dbo.sysindexes where name = 'MOV_NPROT')
   drop index MO_CONCA.MOV_NPROT
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCONTO')
   drop index MO_CONCA.DESCONTO
GO
 
CREATE INDEX [CONTO] ON [dbo].[MO_CONCA]([MOV_SOC], [MOV_ANNO], [MOV_CONTO], [MOV_DTREG], [MOV_NREGIS]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[MO_CONCA]([MOV_SOC], [MOV_DESMOV]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMINTER] ON [dbo].[MO_CONCA]([MOV_SOC], [MOV_ANNO], [MOV_NUMPRO]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_DTREG] ON [dbo].[MO_CONCA]([MOV_SOC], [MOV_ANNO], [MOV_DTREG], [MOV_NUMPRO]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_NREGIS] ON [dbo].[MO_CONCA]([MOV_SOC], [MOV_ANNO], [MOV_NREGIS]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_NDOC] ON [dbo].[MO_CONCA]([MOV_SOC], [MOV_ANNO], [MOV_NDOC]) ON [PRIMARY]
GO
 
CREATE INDEX [MOV_NPROT] ON [dbo].[MO_CONCA]([MOV_SOC], [MOV_ANNO], [MOV_NPROT]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCONTO] ON [dbo].[MO_CONCA]([MOV_SOC], [MOV_ANNO], [MOV_CONTO], [MOV_DESCR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella NEW_PARA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index NEW_PARA.CODICE
GO
 
CREATE INDEX [CODICE] ON [dbo].[NEW_PARA]([CODICE]) ON [PRIMARY]
GO
 


-- Indicizzazione tabella para.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index para.INDICE_01
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[para]([TIPOMOV]) ON [PRIMARY]
GO

-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella NOTE_COM.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index NOTE_COM.CODICE
GO
 
CREATE INDEX [CODICE] ON [dbo].[NOTE_COM]([NOT_CODSOC], [NOT_CODICE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
if exists (select name from dbo.sysindexes where name = 'TIPMOV')
   drop index PARA.TIPMOV
GO
 
CREATE INDEX [CODICE] ON [dbo].[PARA]([CODICE]) ON [PRIMARY]
GO
CREATE INDEX [DESCRI] ON [dbo].[PARA]([DESCRI]) ON [PRIMARY]
GO
CREATE INDEX [CODPRO] ON [dbo].[PARA]([CODICE], [LIBERA]) ON [PRIMARY]
GO
CREATE INDEX [TIPMOV] ON [dbo].[PARA]([TIPOMOV]) ON [PRIMARY]
GO

-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PARA1.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index PARA1.CODICE
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCRI')
   drop index PARA1.DESCRI
GO
 
CREATE INDEX [CODICE] ON [dbo].[PARA1]([CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCRI] ON [dbo].[PARA1]([DESCRI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PARACONF.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PARAX.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PARTFOR.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PART_CLI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'PARTITA')
   drop index PART_CLI.PARTITA
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCRI')
   drop index PART_CLI.DESCRI
GO
 
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index PART_CLI.CODICE
GO
 
if exists (select name from dbo.sysindexes where name = 'DOCUMENTO')
   drop index PART_CLI.DOCUMENTO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMINTER')
   drop index PART_CLI.NUMINTER
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index PART_CLI.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'PART_CLI')
   drop index PART_CLI.PART_CLI
GO
 
if exists (select name from dbo.sysindexes where name = 'PAR_SYS')
   drop index PART_CLI.PAR_SYS
GO
 
if exists (select name from dbo.sysindexes where name = 'PARTIAPE')
   drop index PART_CLI.PARTIAPE
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index PART_CLI.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index PART_CLI.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index PART_CLI.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index PART_CLI.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index PART_CLI.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index PART_CLI.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index PART_CLI.INDICE_07
GO



 
CREATE INDEX [PARTITA] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_ANNO], [PAR_NPART], [PAR_NPROG]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCRI] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_ANNO], [PAR_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [CODICE] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_ANNO], [PAR_CODCLI], [PAR_DTREG]) ON [PRIMARY]
GO
 
CREATE INDEX [DOCUMENTO] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_ANNO], [PAR_DTSCAD], [PAR_NUMFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMINTER] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_ANNO], [PAR_NUMPRO]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_CODCLI], [PAR_TIPODO]) ON [PRIMARY]
GO
 
CREATE INDEX [PART_CLI] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_CODCLI], [PAR_NPART], [PAR_NPROG]) ON [PRIMARY]
GO
 
CREATE INDEX [PAR_SYS] ON [dbo].[PART_CLI]([PAR_SYS]) ON [PRIMARY]
GO
 
CREATE INDEX [PARTIAPE] ON [dbo].[PART_CLI]([PAR_CODCLI], [PAR_NPART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_NPROG], [PAR_CODCLI], [PAR_DTREG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_CODCLI], [PAR_TIPODO], [PAR_NPART], [PAR_DTFAT], [PAR_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_DTSCAD], [PAR_NPROG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_CODCLI], [PAR_NREG], [PAR_NPROG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_CODCLI], [PAR_DTSCAD], [PAR_NPROG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_CODCLI], [PAR_DTREG], [PAR_NPROG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[PART_CLI]([PAR_CODSOC], [PAR_NUMPRO]) ON [PRIMARY]
GO




 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PART_FOR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'PARTITA')
   drop index PART_FOR.PARTITA
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCRI')
   drop index PART_FOR.DESCRI
GO
 
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index PART_FOR.CODICE
GO
 
if exists (select name from dbo.sysindexes where name = 'DOCUMENTO')
   drop index PART_FOR.DOCUMENTO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMINTER')
   drop index PART_FOR.NUMINTER
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index PART_FOR.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'PAR_SYS')
   drop index PART_FOR.PAR_SYS
GO
 
if exists (select name from dbo.sysindexes where name = 'PARTIAPE')
   drop index PART_FOR.PARTIAPE
GO
 
if exists (select name from dbo.sysindexes where name = 'PART_FOR')
   drop index PART_FOR.PART_FOR
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index PART_FOR.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index PART_FOR.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index PART_FOR.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index PART_FOR.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index PART_FOR.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index PART_FOR.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index PART_FOR.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index PART_FOR.INDICE_08
GO






 
CREATE INDEX [PARTITA] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_ANNO], [PAR_NPART], [PAR_NPROG]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCRI] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_ANNO], [PAR_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [CODICE] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_ANNO], [PAR_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [DOCUMENTO] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_DTREG], [PAR_NUMFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMINTER] ON [dbo].[PART_FOR]([PAR_NUMPRO]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_CODCLI], [PAR_TIPODO], [PAR_NPART], [PAR_DTFAT], [PAR_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [PAR_SYS] ON [dbo].[PART_FOR]([PAR_SYS]) ON [PRIMARY]
GO
 
CREATE INDEX [PARTIAPE] ON [dbo].[PART_FOR]([PAR_CODCLI], [PAR_NPART]) ON [PRIMARY]
GO
 
CREATE INDEX [PART_FOR] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_CODCLI], [PAR_NPART], [PAR_NPROG], [PAR_DTSCAD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_ANNO], [PAR_NUMPRO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_NPROG], [PAR_CODCLI], [PAR_DTREG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_DTSCAD], [PAR_NPROG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_CODCLI], [PAR_NREG], [PAR_NPROG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_CODCLI], [PAR_DTSCAD], [PAR_NPROG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_CODCLI], [PAR_DTREG], [PAR_NPROG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[PART_FOR]([PAR_NPART], [PAR_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[PART_FOR]([PAR_CODSOC], [PAR_NUMPRO]) ON [PRIMARY]
GO



 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PIPPO.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PJDBPROC.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella PJMESSAG.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PJTIPREP.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'COMPA')
   drop index PJTIPREP.COMPA
GO
 
if exists (select name from dbo.sysindexes where name = 'PROCE')
   drop index PJTIPREP.PROCE
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index PJTIPREP.INDICE_01
GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_02')
--   drop index PJTIPREP.INDICE_02
--GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index PJTIPREP.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index PJTIPREP.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index PJTIPREP.INDICE_05
GO
 
CREATE INDEX [COMPA] ON [dbo].[PJTIPREP]([COMPA], [NOMEPROC]) ON [PRIMARY]
GO
 
CREATE INDEX [PROCE] ON [dbo].[PJTIPREP]([NOMEPROC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[PJTIPREP]([NOMEREP]) ON [PRIMARY]
GO
--CREATE INDEX [INDICE_02] ON [dbo].[PJTIPREP]([NOMEREP1]) ON [PRIMARY]
--GO

CREATE INDEX [INDICE_03] ON [dbo].[PJTIPREP]([NOMEREP2]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[PJTIPREP]([NOMEREP3]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[PJTIPREP]([NOMEREP4]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PJ_SPOOL.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PRODOTTI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'PROD1')
   drop index PRODOTTI.PROD1
GO
 
if exists (select name from dbo.sysindexes where name = 'PROD2')
   drop index PRODOTTI.PROD2
GO
 
if exists (select name from dbo.sysindexes where name = 'PROD3')
   drop index PRODOTTI.PROD3
GO
 
if exists (select name from dbo.sysindexes where name = 'PROD4')
   drop index PRODOTTI.PROD4
GO
 
CREATE INDEX [PROD1] ON [dbo].[PRODOTTI]([CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [PROD2] ON [dbo].[PRODOTTI]([PCLIENTE]) ON [PRIMARY]
GO
 
CREATE INDEX [PROD3] ON [dbo].[PRODOTTI]([PDISEGNO]) ON [PRIMARY]
GO
 
CREATE INDEX [PROD4] ON [dbo].[PRODOTTI]([VARIAZ]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PROVA.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PROVINCE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index PROVINCE.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index PROVINCE.INDICE_02
GO

 
CREATE INDEX [INDICE_01] ON [dbo].[PROVINCE]([SIGLA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[PROVINCE]([PROVINCIA]) ON [PRIMARY]
GO
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PROVVI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'PRO01')
   drop index PROVVI.PRO01
GO
 
if exists (select name from dbo.sysindexes where name = 'PRO02')
   drop index PROVVI.PRO02
GO
 
if exists (select name from dbo.sysindexes where name = 'PRO03')
   drop index PROVVI.PRO03
GO
 
CREATE INDEX [PRO01] ON [dbo].[PROVVI]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [PRO02] ON [dbo].[PROVVI]([ORD_CODSOC], [ORD_RAGSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [PRO03] ON [dbo].[PROVVI]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella PROV_STO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'PROSTO01')
   drop index PROV_STO.PROSTO01
GO
 
if exists (select name from dbo.sysindexes where name = 'PROSTO02')
   drop index PROV_STO.PROSTO02
GO
 
if exists (select name from dbo.sysindexes where name = 'PROSTO03')
   drop index PROV_STO.PROSTO03
GO
 
CREATE INDEX [PROSTO01] ON [dbo].[PROV_STO]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [PROSTO02] ON [dbo].[PROV_STO]([ORD_CODSOC], [ORD_RAGSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [PROSTO03] ON [dbo].[PROV_STO]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella REGIONI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index REGIONI.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index REGIONI.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index REGIONI.INDICE_03
GO


CREATE INDEX [INDICE_01] ON [dbo].[REGIONI]([CODICE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[REGIONI]([REGIONE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[REGIONI]([CODICE], [REGIONE]) ON [PRIMARY]
GO
-- ********************************************************************************
 
 
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella RES_PROC.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CHIAVE')
   drop index RES_PROC.CHIAVE
GO
 
CREATE INDEX [CHIAVE] ON [dbo].[RES_PROC]([UTENTE], [PROCEDURA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella RICE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'T_CODICE')
   drop index RICE.T_CODICE
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERO')
   drop index RICE.T_NUMERO
GO
 
if exists (select name from dbo.sysindexes where name = 'T_RAGSOC')
   drop index RICE.T_RAGSOC
GO
 
CREATE INDEX [T_CODICE] ON [dbo].[RICE]([CLI_COD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERO] ON [dbo].[RICE]([CLI_NFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [T_RAGSOC] ON [dbo].[RICE]([CLI_DESCRI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella RIC_ARC.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella SCADENZE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TIPRENDO')
   drop index SCADENZE.TIPRENDO
GO
 
CREATE INDEX [TIPRENDO] ON [dbo].[SCADENZE]([TIPRENDO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella SCHE_CLI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'AGENTE')
   drop index SCHE_CLI.AGENTE
GO
 
if exists (select name from dbo.sysindexes where name = 'AGECLI')
   drop index SCHE_CLI.AGECLI
GO
 
if exists (select name from dbo.sysindexes where name = 'CLIENTE')
   drop index SCHE_CLI.CLIENTE
GO
 
CREATE INDEX [AGENTE] ON [dbo].[SCHE_CLI]([CODAGE]) ON [PRIMARY]
GO
 
CREATE INDEX [AGECLI] ON [dbo].[SCHE_CLI]([CODAGE], [CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [CLIENTE] ON [dbo].[SCHE_CLI]([CODCLI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella SDF.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella SERG.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella SERGIO.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella SETUP.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella STARTEUR.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella STRINGSQL.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella S_COM_ED.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CLICOMM')
   drop index S_COM_ED.CLICOMM
GO
 
if exists (select name from dbo.sysindexes where name = 'ARTCOMM')
   drop index S_COM_ED.ARTCOMM
GO
 
if exists (select name from dbo.sysindexes where name = 'COMMART')
   drop index S_COM_ED.COMMART
GO
 
if exists (select name from dbo.sysindexes where name = 'COMMPAD')
   drop index S_COM_ED.COMMPAD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_DA')
   drop index S_COM_ED.U_COM_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_AM')
   drop index S_COM_ED.U_COM_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'I_COMCLI')
   drop index S_COM_ED.I_COMCLI
GO
 
if exists (select name from dbo.sysindexes where name = 'I_PRGSCAD')
   drop index S_COM_ED.I_PRGSCAD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_COMART')
   drop index S_COM_ED.I_COMART
GO
 
if exists (select name from dbo.sysindexes where name = 'I_ARTCOM')
   drop index S_COM_ED.I_ARTCOM
GO
 
CREATE INDEX [CLICOMM] ON [dbo].[S_COM_ED]([LCD_CODCLI], [LCD_NUMCOM], [LCD_CODART], [LCD_CODMAG], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [ARTCOMM] ON [dbo].[S_COM_ED]([LCD_CODART], [LCD_CODMAG], [LCD_NUMCOM], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [COMMART] ON [dbo].[S_COM_ED]([LCD_NUMCOM], [LCD_CODART], [LCD_CODMAG], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [COMMPAD] ON [dbo].[S_COM_ED]([LCD_NUMCOM], [LCD_PADRE], [LCD_CODART], [LCD_CODMAG], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_DA] ON [dbo].[S_COM_ED]([LCD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_AM] ON [dbo].[S_COM_ED]([LCD_CODART], [LCD_CODMAG]) ON [PRIMARY]
GO
 
CREATE INDEX [I_COMCLI] ON [dbo].[S_COM_ED]([LCD_NUMCOM], [LCD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [I_PRGSCAD] ON [dbo].[S_COM_ED]([LCD_CODART], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [I_COMART] ON [dbo].[S_COM_ED]([LCD_DATLAN], [LCD_NUMCOM], [LCD_CODART], [LCD_CODMAG], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [I_ARTCOM] ON [dbo].[S_COM_ED]([LCD_CODART], [LCD_DATLAN], [LCD_CODMAG], [LCD_NUMCOM], [LCD_DATSCA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella S_COM_ET.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ARTCOMM')
   drop index S_COM_ET.ARTCOMM
GO
 
if exists (select name from dbo.sysindexes where name = 'ARTCOMN')
   drop index S_COM_ET.ARTCOMN
GO
 
CREATE INDEX [ARTCOMM] ON [dbo].[S_COM_ET]([LCT_CODART], [LCT_CODMAG], [LCT_TIPART]) ON [PRIMARY]
GO
 
CREATE INDEX [ARTCOMN] ON [dbo].[S_COM_ET]([LCT_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella S_ORF_ED.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_ORF_ED')
   drop index S_ORF_ED.U_ORF_ED
GO
 
if exists (select name from dbo.sysindexes where name = 'DESARTI')
   drop index S_ORF_ED.DESARTI
GO
 
if exists (select name from dbo.sysindexes where name = 'DESFORN')
   drop index S_ORF_ED.DESFORN
GO
 
CREATE INDEX [U_ORF_ED] ON [dbo].[S_ORF_ED]([ORD_CODMAG], [ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [DESARTI] ON [dbo].[S_ORF_ED]([ORD_CODMAG], [ORD_DESART]) ON [PRIMARY]
GO
 
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella TABULA.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella TBL_MENU.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella TEMPO.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella TOOLS.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella UCLIAN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CLI_AN')
   drop index UCLIAN.U_CLI_AN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_RG')
   drop index UCLIAN.U_CLI_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_LO')
   drop index UCLIAN.U_CLI_LO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_NA')
   drop index UCLIAN.U_CLI_NA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_AG')
   drop index UCLIAN.U_CLI_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_PI')
   drop index UCLIAN.U_CLI_PI
GO
 
CREATE INDEX [U_CLI_AN] ON [dbo].[UCLIAN]([CLI_CODSOC], [CLI_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_RG] ON [dbo].[UCLIAN]([CLI_CODSOC], [CLI_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_LO] ON [dbo].[UCLIAN]([CLI_CODSOC], [CLI_LOCALI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_NA] ON [dbo].[UCLIAN]([CLI_CODSOC], [CLI_NAZION]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_AG] ON [dbo].[UCLIAN]([CLI_CODSOC], [CLI_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_PI] ON [dbo].[UCLIAN]([CLI_CODSOC], [CLI_PARIVA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_AMM_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'AMMHOOKD')
   drop index U_AMM_DD.AMMHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AMM_DA')
   drop index U_AMM_DD.U_AMM_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AMM_AA')
   drop index U_AMM_DD.U_AMM_AA
GO
 
CREATE INDEX [AMMHOOKD] ON [dbo].[U_AMM_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AMM_DA] ON [dbo].[U_AMM_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AMM_AA] ON [dbo].[U_AMM_DD]([DAGGANCIO], [ORD_ANNO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_AMM_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'AMMHOOKT')
   drop index U_AMM_TT.AMMHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'AMMNDOCT')
   drop index U_AMM_TT.AMMNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AMM_TN')
   drop index U_AMM_TT.U_AMM_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AMM_TD')
   drop index U_AMM_TT.U_AMM_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AMM_DA')
   drop index U_AMM_TT.U_AMM_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AMM_TC')
   drop index U_AMM_TT.U_AMM_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AMM_AG')
   drop index U_AMM_TT.U_AMM_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AMM_TA')
   drop index U_AMM_TT.U_AMM_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AMM_RG')
   drop index U_AMM_TT.U_AMM_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_AMM_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NPROT')
   drop index U_AMM_TT.T_NPROT
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_AMM_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_AMM_XX')
   drop index U_AMM_TT.U_AMM_XX
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AMM_TT.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_AMM_TT.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_AMM_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_AMM_TT.INDICE_04
GO



 
CREATE INDEX [AMMHOOKT] ON [dbo].[U_AMM_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [AMMNDOCT] ON [dbo].[U_AMM_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AMM_TN] ON [dbo].[U_AMM_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AMM_TD] ON [dbo].[U_AMM_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AMM_DA] ON [dbo].[U_AMM_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AMM_TC] ON [dbo].[U_AMM_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AMM_AG] ON [dbo].[U_AMM_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AMM_TA] ON [dbo].[U_AMM_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AMM_RG] ON [dbo].[U_AMM_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_AMM_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NPROT] ON [dbo].[U_AMM_TT]([ORD_NPROT]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_AMM_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_AMM_XX] ON [dbo].[U_AMM_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_NUMORD], [ORD_DATORD], [ORD_CDARTI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_AMM_TT]([ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_AMM_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_AMM_TT]([ORD_CODCLI]) ON [PRIMARY]
GO 
CREATE INDEX [INDICE_04] ON [dbo].[U_AMM_TT]([ORD_NUMPRO]) ON [PRIMARY]
GO 



-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ART_LE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_ART_LE')
   drop index U_ART_LE.U_ART_LE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ART_SE')
   drop index U_ART_LE.U_ART_SE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ART_CE')
   drop index U_ART_LE.U_ART_CE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ART_PE')
   drop index U_ART_LE.U_ART_PE
GO
 
CREATE INDEX [U_ART_LE] ON [dbo].[U_ART_LE]([LEG_CODSOC], [LEG_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ART_SE] ON [dbo].[U_ART_LE]([LEG_CODSOC], [LEG_CODART], [LEG_SEQUEN]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ART_CE] ON [dbo].[U_ART_LE]([LEG_CODSOC], [LEG_CODART], [LEG_CODBUN]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ART_PE] ON [dbo].[U_ART_LE]([LEG_CODSOC], [LEG_CODART], [LEG_CODBUN], [LEG_SEQUEN]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
if exists (select name from dbo.sysindexes where name = 'U_ART_22')
   drop index U_ART_PR.U_ART_22
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_23')
   drop index U_ART_PR.U_ART_23
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_24')
   drop index U_ART_PR.U_ART_24
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_26')
   drop index U_ART_PR.U_ART_26
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_27')
   drop index U_ART_PR.U_ART_27
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_28')
   drop index U_ART_PR.U_ART_28
GO
if exists (select name from dbo.sysindexes where name = 'U_ART_29')
   drop index U_ART_PR.U_ART_29
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ART_PR.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_ART_PR.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_ART_PR.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_ART_PR.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_ART_PR.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_ART_PR.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_ART_PR.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_ART_PR.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_ART_PR.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_ART_PR.INDICE_10
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_ART_PR.INDICE_11
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_ART_PR.INDICE_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_ART_PR.INDICE_13
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_14')
   drop index U_ART_PR.INDICE_14
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_15')
   drop index U_ART_PR.INDICE_15
GO

CREATE INDEX [U_ART_01] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_CODPRI], [ART_CODMAT], [ART_CODIMB], [ART_CODCOL], [ART_SPESSO], [ART_ALTEZZ], [ART_LUNGHE]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_02] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_DESCR]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_03] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_DESEST]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_04] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_LINEA], [ART_CODPRI]) ON [PRIMARY]
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
CREATE INDEX [U_ART_22] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_CODPRI], [ART_CATMER], [ART_GRUEDI], [ART_EDITOR], [ART_COLLAN], [ART_AUTORE], [ART_ARGOME]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_23] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_CODPRI], [ART_CODMAT], [ART_CODIMB], [ART_CODCOL], [ART_SPESSO], [ART_ALTEZZ], [ART_LUNGHE]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_24] ON [dbo].[U_ART_PR]([ART_CATMER], [ART_GRUEDI], [ART_ARGOME], [ART_EDITOR], [ART_COLLAN]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_26] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_BARFOR]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_27] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_CDISBN]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_28] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_CODMAT], [ART_CODIMB], [ART_CODCOL], [ART_SPESSO], [ART_ALTEZZ], [ART_LUNGHE]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_29] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_ART_PR]([ART_CODPRI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_ART_PR]([ART_LINEA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_ART_PR]([ART_COORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_ART_PR]([ART_CODMAT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_ART_PR]([ART_DESMAT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_ART_PR]([ART_CODCOL]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_ART_PR]([ART_DESCOL]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_ART_PR]([ART_CDDIBA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_ART_PR]([ART_DSDIBA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[U_ART_PR]([ART_CGE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_11] ON [dbo].[U_ART_PR]([ART_DATINS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_12] ON [dbo].[U_ART_PR]([ART_DATVAR]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_13] ON [dbo].[U_ART_PR]([ART_SPESSO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_14] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_CODPRI], [ART_CODMAT], [ART_CATBEN], [ART_CATMER], [ART_LINEA], [ART_SERIE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_15] ON [dbo].[U_ART_PR]([ART_CATBEN], [ART_CATMER], [ART_LINEA], [ART_SERIE]) ON [PRIMARY]
GO

-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_AUT_AN.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_AVA_CO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'I_CO1COD')
   drop index U_AVA_CO.I_CO1COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CO2COD')
   drop index U_AVA_CO.I_CO2COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CO3COD')
   drop index U_AVA_CO.I_CO3COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CO4COD')
   drop index U_AVA_CO.I_CO4COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CO5COD')
   drop index U_AVA_CO.I_CO5COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_CO6COD')
   drop index U_AVA_CO.I_CO6COD
GO
 
CREATE INDEX [I_CO1COD] ON [dbo].[U_AVA_CO]([AVA_NUMCOM], [AVA_CODART], [AVA_CODMAG], [AVA_PROGRE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CO2COD] ON [dbo].[U_AVA_CO]([AVA_CODART], [AVA_NUMCOM], [AVA_CODMAG], [AVA_PROGRE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CO3COD] ON [dbo].[U_AVA_CO]([AVA_CODOPE], [AVA_NUMCOM], [AVA_CODART], [AVA_CODMAG], [AVA_PROGRE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CO4COD] ON [dbo].[U_AVA_CO]([AVA_CODREP], [AVA_NUMCOM], [AVA_CODART], [AVA_CODMAG], [AVA_PROGRE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CO5COD] ON [dbo].[U_AVA_CO]([AVA_CODMAC], [AVA_NUMCOM], [AVA_CODART], [AVA_CODMAG], [AVA_PROGRE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_CO6COD] ON [dbo].[U_AVA_CO]([AVA_CODATT], [AVA_NUMCOM], [AVA_CODART], [AVA_CODMAG], [AVA_PROGRE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_AVA_MQ.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'I_MQ1COD')
   drop index U_AVA_MQ.I_MQ1COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_MQ2COD')
   drop index U_AVA_MQ.I_MQ2COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_MQ3COD')
   drop index U_AVA_MQ.I_MQ3COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_MQ4COD')
   drop index U_AVA_MQ.I_MQ4COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_MQ5COD')
   drop index U_AVA_MQ.I_MQ5COD
GO
 
CREATE INDEX [I_MQ1COD] ON [dbo].[U_AVA_MQ]([AVA_NUMCOM], [AVA_CODART], [AVA_CODMAG], [AVA_DATCON], [AVA_PROGRE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_MQ2COD] ON [dbo].[U_AVA_MQ]([AVA_CODART], [AVA_NUMCOM], [AVA_CODMAG], [AVA_DATCON], [AVA_PROGRE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_MQ3COD] ON [dbo].[U_AVA_MQ]([AVA_CODOPE], [AVA_NUMCOM], [AVA_CODART], [AVA_CODMAG], [AVA_DATCON], [AVA_PROGRE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_MQ4COD] ON [dbo].[U_AVA_MQ]([AVA_CODREP], [AVA_NUMCOM], [AVA_CODART], [AVA_CODMAG], [AVA_DATCON], [AVA_PROGRE]) ON [PRIMARY]
GO
 
CREATE INDEX [I_MQ5COD] ON [dbo].[U_AVA_MQ]([AVA_MATRIC], [AVA_CODART], [AVA_NUMCOM], [AVA_CODMAG], [AVA_DATCON], [AVA_PROGRE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_AZI_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_AZI_AN')
   drop index U_AZI_AN.U_AZI_AN
GO
 
CREATE INDEX [U_AZI_AN] ON [dbo].[U_AZI_AN]([AZI_CODSOC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BAN_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_BAN_CO')
   drop index U_BAN_AN.U_BAN_CO
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_BAN_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_BAN_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_BAN_AN.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_BAN_AN.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_BAN_AN.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_BAN_AN.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_BAN_AN.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_BAN_AN.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_BAN_AN.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_BAN_AN.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_BAN_AN.INDICE_11
GO

 
-- CREATE UNIQUE INDEX [U_BAN_CO] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_CODBAN]) ON [PRIMARY]
CREATE INDEX [U_BAN_CO] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_CODBAN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_BAN_AN]([BAN_CODBAN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_BAN_AN]([BAN_DESBAN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_DESBAN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_BAN_AN]([BAN_LOCA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_BAN_AN]([BAN_LOCA], [BAN_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_LOCA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_CODBAN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_PRESE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_DESBAN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_CODABI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_BAN_AN]([BAN_CODSOC], [BAN_CODCAB]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
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
if exists (select name from dbo.sysindexes where name = 'U_BFO_01')
   drop index U_BFO_DD.U_BFO_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_BFO_DD.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_BFO_DD.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_BFO_DD.INDICE_03
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
CREATE INDEX [U_BFO_01] ON [dbo].[U_BFO_DD]([ORS_CODCLI], [ORD_CODART], [ORS_DATORD]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_01] ON [dbo].[U_BFO_DD]([ORS_CODCLI], [ORS_CODACQ], [ORS_DATORD]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_02] ON [dbo].[U_BFO_DD]([CBF_NUMPRO]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_03] ON [dbo].[U_BFO_DD]([ORD_CODART], [ORD_SERBOL], [ORD_SERNUM], [ORD_AAPROD], [ORD_NUMEDA]) ON [PRIMARY]
GO


-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BFO_LE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_BFO_LE')
   drop index U_BFO_LE.U_BFO_LE
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_SE')
   drop index U_BFO_LE.U_BFO_SE
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_CE')
   drop index U_BFO_LE.U_BFO_CE
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_PE')
   drop index U_BFO_LE.U_BFO_PE
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_DA')
   drop index U_BFO_LE.U_BFO_DA
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_DD')
   drop index U_BFO_LE.U_BFO_DD
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_01')
   drop index U_BFO_LE.U_BFO_01
GO

CREATE INDEX [U_BFO_LE] ON [dbo].[U_BFO_LE]([LEG_CODSOC], [LEG_NUMPRO]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_SE] ON [dbo].[U_BFO_LE]([LEG_CODSOC], [LEG_NUMPRO], [LEG_SEQUEN]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_CE] ON [dbo].[U_BFO_LE]([LEG_CODSOC], [LEG_NUMPRO], [LEG_AGGANC]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_PE] ON [dbo].[U_BFO_LE]([LEG_CODSOC], [LEG_NUMPRO], [LEG_AGGANC], [LEG_SEQUEN]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_DA] ON [dbo].[U_BFO_LE]([LEG_CODSOC], [LEG_DATPRN]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_DD] ON [dbo].[U_BFO_LE]([LEG_CODSOC], [LEG_DATDOC]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_01] ON [dbo].[U_BFO_LE]([LEG_AGGANC], [LEG_NUMDOC], [LEG_DATDOC]) ON [PRIMARY]
GO

-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_BFO_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_BFO_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_BFO_TT.INDICE_03
GO


if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_BFO_TT.INDICE_04
GO


if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_BFO_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_BFO_TT.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_BFO_TT.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_BFO_TT.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_BFO_TT.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_BFO_TT.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_BFO_TT.INDICE_11
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_BFO_TT.INDICE_12
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_BFO_TT.INDICE_13
GO

  
CREATE INDEX [BFOHOOKT] ON [dbo].[U_BFO_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [BFONDOCT] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TD] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TC] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TA] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_RG] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_TT] ON [dbo].[U_BFO_TT]([ORD_CODCLI], [ORD_NUMORD], [ORD_DATORD], [ORD_TIPDOC], [ORD_CODBUN]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_PV] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_CODBUN], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_CC] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_CODCCO], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_AA] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_TIPO], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_SY] ON [dbo].[U_BFO_TT]([ORD_CODSYS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_BFO_TT]([ORD_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_BFO_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_BFO_TT]([ORD_TIPO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_BFO_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_BFO_TT]([ORD_DATORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_BFO_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_BFO_TT]([ORD_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_BFO_TT]([ORD_CODBUN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_BFO_TT]([ORD_CODCCO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_BFO_TT]([ORD_NUMIDE]) ON [PRIMARY]
GO
 
CREATE INDEX [INDICE_12] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_NUMIDE], [ORD_ANNO], [ORD_CODBUN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_13] ON [dbo].[U_BFO_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_NUMORD], [ORD_DATOR2], [ORD_DATORD]) ON [PRIMARY]
GO 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BLI_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BLIHOOKD')
   drop index U_BLI_DD.BLIHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLI_DA')
   drop index U_BLI_DD.U_BLI_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'RIGART')
   drop index U_BLI_DD.RIGART
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLI_AM')
   drop index U_BLI_DD.U_BLI_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLI_DO')
   drop index U_BLI_DD.U_BLI_DO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLI_RF')
   drop index U_BLI_DD.U_BLI_RF
GO
 
CREATE INDEX [BLIHOOKD] ON [dbo].[U_BLI_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLI_DA] ON [dbo].[U_BLI_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [RIGART] ON [dbo].[U_BLI_DD]([DAGGANCIO], [ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLI_AM] ON [dbo].[U_BLI_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLI_DO] ON [dbo].[U_BLI_DD]([ORD_CODART], [ORD_MAGA], [ORD_DTORDI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLI_RF] ON [dbo].[U_BLI_DD]([ORD_CODART], [ORD_MAGA], [ORD_NRORDI], [ORD_DTORDI], [ORD_CDORDI], [ORD_NRORFO], [ORD_DTORFO], [ORD_CDORFO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BLI_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BLIHOOKT')
   drop index U_BLI_TT.BLIHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'BLINDOCT')
   drop index U_BLI_TT.BLINDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLI_TN')
   drop index U_BLI_TT.U_BLI_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLI_TD')
   drop index U_BLI_TT.U_BLI_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLI_TC')
   drop index U_BLI_TT.U_BLI_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLI_TA')
   drop index U_BLI_TT.U_BLI_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLI_RG')
   drop index U_BLI_TT.U_BLI_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLI_DA')
   drop index U_BLI_TT.U_BLI_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_BLI_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDRIC')
   drop index U_BLI_TT.T_INDRIC
GO
 
CREATE INDEX [BLIHOOKT] ON [dbo].[U_BLI_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [BLINDOCT] ON [dbo].[U_BLI_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLI_TN] ON [dbo].[U_BLI_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLI_TD] ON [dbo].[U_BLI_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLI_TC] ON [dbo].[U_BLI_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLI_TA] ON [dbo].[U_BLI_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLI_RG] ON [dbo].[U_BLI_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLI_DA] ON [dbo].[U_BLI_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_BLI_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDRIC] ON [dbo].[U_BLI_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BLU_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BLUHOOKD')
   drop index U_BLU_DD.BLUHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_DA')
   drop index U_BLU_DD.U_BLU_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_AM')
   drop index U_BLU_DD.U_BLU_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_SY')
   drop index U_BLU_DD.U_BLU_SY
GO
 
CREATE INDEX [BLUHOOKD] ON [dbo].[U_BLU_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_DA] ON [dbo].[U_BLU_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_AM] ON [dbo].[U_BLU_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_SY] ON [dbo].[U_BLU_DD]([ORD_CODSYS]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BLU_RF.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BLUHOOKD')
   drop index U_BLU_RF.BLUHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_DA')
   drop index U_BLU_RF.U_BLU_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_AM')
   drop index U_BLU_RF.U_BLU_AM
GO
 
CREATE INDEX [BLUHOOKD] ON [dbo].[U_BLU_RF]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_DA] ON [dbo].[U_BLU_RF]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_AM] ON [dbo].[U_BLU_RF]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BLU_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BLUHOOKT')
   drop index U_BLU_TT.BLUHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'BLUNDOCT')
   drop index U_BLU_TT.BLUNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_TN')
   drop index U_BLU_TT.U_BLU_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_TD')
   drop index U_BLU_TT.U_BLU_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_TC')
   drop index U_BLU_TT.U_BLU_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_TA')
   drop index U_BLU_TT.U_BLU_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_DA')
   drop index U_BLU_TT.U_BLU_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_BLU_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BLU_RG')
   drop index U_BLU_TT.U_BLU_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_BLU_TT.T_INDICE
GO
 
CREATE INDEX [BLUHOOKT] ON [dbo].[U_BLU_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [BLUNDOCT] ON [dbo].[U_BLU_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_TN] ON [dbo].[U_BLU_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_TD] ON [dbo].[U_BLU_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_TC] ON [dbo].[U_BLU_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_TA] ON [dbo].[U_BLU_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_DA] ON [dbo].[U_BLU_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_BLU_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BLU_RG] ON [dbo].[U_BLU_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_BLU_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BOF_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BOFHOOKD')
   drop index U_BOF_DD.BOFHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_DA')
   drop index U_BOF_DD.U_BOF_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_AM')
   drop index U_BOF_DD.U_BOF_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_SY')
   drop index U_BOF_DD.U_BOF_SY
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_DO')
   drop index U_BOF_DD.U_BOF_DO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_MR')
   drop index U_BOF_DD.U_BOF_MR
GO
 
CREATE INDEX [BOFHOOKD] ON [dbo].[U_BOF_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_DA] ON [dbo].[U_BOF_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_AM] ON [dbo].[U_BOF_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_SY] ON [dbo].[U_BOF_DD]([ORD_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_DO] ON [dbo].[U_BOF_DD]([ORS_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_MR] ON [dbo].[U_BOF_DD]([ORS_NUMORC], [ORS_DATORC], [ORS_CODCLI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BOF_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'BOFHOOKT')
   drop index U_BOF_TT.BOFHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'BOFNDOCT')
   drop index U_BOF_TT.BOFNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_TN')
   drop index U_BOF_TT.U_BOF_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_TD')
   drop index U_BOF_TT.U_BOF_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_TC')
   drop index U_BOF_TT.U_BOF_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_TA')
   drop index U_BOF_TT.U_BOF_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_DA')
   drop index U_BOF_TT.U_BOF_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_BOF_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_RG')
   drop index U_BOF_TT.U_BOF_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_BOF_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BOF_SY')
   drop index U_BOF_TT.U_BOF_SY
GO
 
if exists (select name from dbo.sysindexes where name = 'FPS_INDICE')
   drop index U_BOF_TT.FPS_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'FPS_VETTO1')
   drop index U_BOF_TT.FPS_VETTO1
GO
 
CREATE INDEX [BOFHOOKT] ON [dbo].[U_BOF_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [BOFNDOCT] ON [dbo].[U_BOF_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_TN] ON [dbo].[U_BOF_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_TD] ON [dbo].[U_BOF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_TC] ON [dbo].[U_BOF_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_TA] ON [dbo].[U_BOF_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_DA] ON [dbo].[U_BOF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_BOF_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_RG] ON [dbo].[U_BOF_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_BOF_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BOF_SY] ON [dbo].[U_BOF_TT]([ORD_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [FPS_INDICE] ON [dbo].[U_BOF_TT]([ORD_DATORD], [ORD_NUMORD], [ORD_CODEMI], [ORD_TIPORD]) ON [PRIMARY]
GO
 
 
-- ********************************************************************************
 
 
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
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_BOL_DD.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_BOL_DD.INDICE_02
GO
 
CREATE INDEX [BOLHOOKD] ON [dbo].[U_BOL_DD]([DAGGANCIO], [ORD_CODICE], [ORD_DESART]) ON [PRIMARY]
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
CREATE INDEX [INDICE_01] ON [dbo].[U_BOL_DD]([DAGGANCIO], [ORD_CODART]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_BOL_DD]([ORS_NUMORD], [ORS_DATORD]) ON [PRIMARY]
GO 
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_BOL_SD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKD')
   drop index U_BOL_SD.OFFHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_DA')
   drop index U_BOL_SD.U_OFF_DA
GO
 
CREATE INDEX [OFFHOOKD] ON [dbo].[U_BOL_SD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_DA] ON [dbo].[U_BOL_SD]([ORD_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BOL_ST.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKT')
   drop index U_BOL_ST.OFFHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'OFFNDOCT')
   drop index U_BOL_ST.OFFNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TN')
   drop index U_BOL_ST.U_OFF_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TD')
   drop index U_BOL_ST.U_OFF_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TC')
   drop index U_BOL_ST.U_OFF_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TA')
   drop index U_BOL_ST.U_OFF_TA
GO
 
CREATE INDEX [OFFHOOKT] ON [dbo].[U_BOL_ST]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [OFFNDOCT] ON [dbo].[U_BOL_ST]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TN] ON [dbo].[U_BOL_ST]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TD] ON [dbo].[U_BOL_ST]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TC] ON [dbo].[U_BOL_ST]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TA] ON [dbo].[U_BOL_ST]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
if exists (select name from dbo.sysindexes where name = 'U_BOL_01')
   drop index U_BOL_TT.U_BOL_01
GO
if exists (select name from dbo.sysindexes where name = 'U_BOL_02')
   drop index U_BOL_TT.U_BOL_02
GO 
if exists (select name from dbo.sysindexes where name = 'U_BOL_03')
   drop index U_BOL_TT.U_BOL_03
GO 
if exists (select name from dbo.sysindexes where name = 'U_BOL_04')
   drop index U_BOL_TT.U_BOL_04
GO 
if exists (select name from dbo.sysindexes where name = 'U_BOL_05')
   drop index U_BOL_TT.U_BOL_05
GO 
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_BOL_TT.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_BOL_TT.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_BOL_TT.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_BOL_TT.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_BOL_TT.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_BOL_TT.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_BOL_TT.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_BOL_TT.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_BOL_TT.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_BOL_TT.INDICE_10
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_BOL_TT.INDICE_11
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_BOL_TT.INDICE_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_BOL_TT.INDICE_13
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_14')
   drop index U_BOL_TT.INDICE_14
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_15')
   drop index U_BOL_TT.INDICE_15
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_16')
   drop index U_BOL_TT.INDICE_16
GO


CREATE INDEX [BOLHOOKT] ON [dbo].[U_BOL_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [BOLNDOCT] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_TN] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_TD] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_TC] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_TA] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_DA] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [T_NUMERIC] ON [dbo].[U_BOL_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_RG] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
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
CREATE INDEX [U_BOL_01] ON [dbo].[U_BOL_TT]([ORD_ANNO], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_02] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_NUMORD], [ORD_CODCLI], [ORD_CAUS]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_03] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_FLBOL], [ORD_AGE], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_04] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_FLBOL], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_BOL_05] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_FLBOL], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_BOL_TT]([ORD_CODSOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_BOL_TT]([ORD_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_BOL_TT]([ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_BOL_TT]([ORD_FORNI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_BOL_TT]([ORD_CAUS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_BOL_TT]([ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_BOL_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_BOL_TT]([ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_BOL_TT]([ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_FLTRAS], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_11] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_FLTRAS], [ORD_AGE], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_12] ON [dbo].[U_BOL_TT]([ORD_ANNO], [ORD_CODSOC], [ORD_DATORD], [ORD_MAGS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_13] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_VETTO1], [ORD_PROVIN], [ORD_INTRAS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_14] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_VETTO1], [ORD_CODNAZ], [ORD_PROVIN], [ORD_INTRAS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_15] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_LOCC], [ORD_CAUS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_16] ON [dbo].[U_BOL_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_LOCC], [ORD_CAUS]) ON [PRIMARY]
GO
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_BUD_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_BUD_CO')
   drop index U_BUD_AN.U_BUD_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BUD_DE')
   drop index U_BUD_AN.U_BUD_DE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_BUD_AN')
   drop index U_BUD_AN.U_BUD_AN
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_BUD_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_BUD_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_BUD_AN.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_BUD_AN.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_BUD_AN.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_BUD_AN.INDICE_06
GO

CREATE INDEX [U_BUD_CO] ON [dbo].[U_BUD_AN]([BUD_CODSOC], [BUD_ANNO], [BUD_CODGRU]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BUD_DE] ON [dbo].[U_BUD_AN]([BUD_CODSOC], [BUD_ANNO], [BUD_DESGRU]) ON [PRIMARY]
GO
 
CREATE INDEX [U_BUD_AN] ON [dbo].[U_BUD_AN]([BUD_CODSOC], [BUD_ANNO], [BUD_MASTRO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_BUD_AN]([BUD_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_BUD_AN]([BUD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_BUD_AN]([BUD_CODGRU]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_BUD_AN]([BUD_CODSOC], [BUD_CODGRU]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_BUD_AN]([BUD_DESGRU]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_BUD_AN]([BUD_CODSOC], [BUD_DESGRU]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CAR_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CAR_AG')
   drop index U_CAR_AN.U_CAR_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CAR_DA')
   drop index U_CAR_AN.U_CAR_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CAR_AC')
   drop index U_CAR_AN.U_CAR_AC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CAR_DC')
   drop index U_CAR_AN.U_CAR_DC
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CAR_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CAR_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CAR_AN.INDICE_03
GO

CREATE INDEX [U_CAR_AG] ON [dbo].[U_CAR_AN]([PRV_CODSOC], [PRV_CODAGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CAR_DA] ON [dbo].[U_CAR_AN]([PRV_CODSOC], [PRV_DESAGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CAR_AC] ON [dbo].[U_CAR_AN]([PRV_CODSOC], [PRV_CODCAR]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CAR_DC] ON [dbo].[U_CAR_AN]([PRV_CODSOC], [PRV_DESCAR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CAR_AN]([PRV_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CAR_AN]([PRV_CODAGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_CAR_AN]([PRV_CODCAR]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CCO_GR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CCO_GR')
   drop index U_CCO_GR.U_CCO_GR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CCO_SE')
   drop index U_CCO_GR.U_CCO_SE
GO
 
CREATE INDEX [U_CCO_GR] ON [dbo].[U_CCO_GR]([GRU_CODSOC], [GRU_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CCO_SE] ON [dbo].[U_CCO_GR]([GRU_CODSOC], [GRU_CODICE], [GRU_SEQUEN]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CCO_LE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CCO_LE')
   drop index U_CCO_LE.U_CCO_LE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CCO_SE')
   drop index U_CCO_LE.U_CCO_SE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CCO_CE')
   drop index U_CCO_LE.U_CCO_CE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CCO_PE')
   drop index U_CCO_LE.U_CCO_PE
GO
 
CREATE INDEX [U_CCO_LE] ON [dbo].[U_CCO_LE]([LEG_CODSOC], [LEG_CODTOP]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CCO_SE] ON [dbo].[U_CCO_LE]([LEG_CODSOC], [LEG_CODTOP], [LEG_SEQUEN]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CCO_CE] ON [dbo].[U_CCO_LE]([LEG_CODSOC], [LEG_CODTOP], [LEG_CODCON]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CCO_PE] ON [dbo].[U_CCO_LE]([LEG_CODSOC], [LEG_CODTOP], [LEG_CODCON], [LEG_SEQUEN]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CEA_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CEIHOOKD')
   drop index U_CEA_DD.CEIHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEA_DA')
   drop index U_CEA_DD.U_CEA_DA
GO
 
CREATE INDEX [CEIHOOKD] ON [dbo].[U_CEA_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEA_DA] ON [dbo].[U_CEA_DD]([ORD_CLDOG]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CEA_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CEIHOOKT')
   drop index U_CEA_TT.CEIHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'CEINDOCT')
   drop index U_CEA_TT.CEINDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEA_TN')
   drop index U_CEA_TT.U_CEA_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEA_TD')
   drop index U_CEA_TT.U_CEA_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEA_DA')
   drop index U_CEA_TT.U_CEA_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEA_TC')
   drop index U_CEA_TT.U_CEA_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEA_RG')
   drop index U_CEA_TT.U_CEA_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_CEA_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_CEA_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEA_OR')
   drop index U_CEA_TT.U_CEA_OR
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CEA_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CEA_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CEA_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_CEA_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_CEA_TT.INDICE_05
GO



 
CREATE INDEX [CEIHOOKT] ON [dbo].[U_CEA_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [CEINDOCT] ON [dbo].[U_CEA_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEA_TN] ON [dbo].[U_CEA_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEA_TD] ON [dbo].[U_CEA_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEA_DA] ON [dbo].[U_CEA_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEA_TC] ON [dbo].[U_CEA_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEA_RG] ON [dbo].[U_CEA_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_CEA_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_CEA_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEA_OR] ON [dbo].[U_CEA_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CEA_TT]([ORD_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CEA_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_CEA_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_CEA_TT]([ORD_DATORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_CEA_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CEI_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CEIHOOKD')
   drop index U_CEI_DD.CEIHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEI_DA')
   drop index U_CEI_DD.U_CEI_DA
GO
 
CREATE INDEX [CEIHOOKD] ON [dbo].[U_CEI_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEI_DA] ON [dbo].[U_CEI_DD]([ORD_CLDOG]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CEI_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CEIHOOKT')
   drop index U_CEI_TT.CEIHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'CEINDOCT')
   drop index U_CEI_TT.CEINDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEI_TN')
   drop index U_CEI_TT.U_CEI_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEI_TD')
   drop index U_CEI_TT.U_CEI_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEI_DA')
   drop index U_CEI_TT.U_CEI_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEI_TC')
   drop index U_CEI_TT.U_CEI_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEI_RG')
   drop index U_CEI_TT.U_CEI_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_CEI_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_CEI_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CEI_OR')
   drop index U_CEI_TT.U_CEI_OR
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CEI_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CEI_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CEI_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_CEI_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_CEI_TT.INDICE_05
GO


 
CREATE INDEX [CEIHOOKT] ON [dbo].[U_CEI_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [CEINDOCT] ON [dbo].[U_CEI_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEI_TN] ON [dbo].[U_CEI_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEI_TD] ON [dbo].[U_CEI_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEI_DA] ON [dbo].[U_CEI_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEI_TC] ON [dbo].[U_CEI_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEI_RG] ON [dbo].[U_CEI_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_CEI_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_CEI_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CEI_OR] ON [dbo].[U_CEI_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CEI_TT]([ORD_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CEI_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_CEI_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_CEI_TT]([ORD_DATORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_CEI_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CER_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CER_CO')
   drop index U_CER_AN.U_CER_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CER_DT')
   drop index U_CER_AN.U_CER_DT
GO
 
CREATE INDEX [U_CER_CO] ON [dbo].[U_CER_AN]([CER_CODSOC], [CER_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CER_DT] ON [dbo].[U_CER_AN]([CER_CODSOC], [CER_DATA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CER_MO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CER_CO')
   drop index U_CER_MO.U_CER_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CER_CF')
   drop index U_CER_MO.U_CER_CF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CER_DT')
   drop index U_CER_MO.U_CER_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CER_DO')
   drop index U_CER_MO.U_CER_DO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CER_DB')
   drop index U_CER_MO.U_CER_DB
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CER_NU')
   drop index U_CER_MO.U_CER_NU
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CER_NO')
   drop index U_CER_MO.U_CER_NO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CER_NB')
   drop index U_CER_MO.U_CER_NB
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CER_CS')
   drop index U_CER_MO.U_CER_CS
GO
 
CREATE INDEX [U_CER_CO] ON [dbo].[U_CER_MO]([CER_CODSOC], [CER_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CER_CF] ON [dbo].[U_CER_MO]([CER_CODSOC], [CER_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CER_DT] ON [dbo].[U_CER_MO]([CER_CODSOC], [CER_DATACS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CER_DO] ON [dbo].[U_CER_MO]([CER_CODSOC], [CER_DATORD], [CER_CARSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CER_DB] ON [dbo].[U_CER_MO]([CER_CODSOC], [CER_DATBOL], [CER_CARSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CER_NU] ON [dbo].[U_CER_MO]([CER_CODSOC], [CER_CERTBV], [CER_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CER_NO] ON [dbo].[U_CER_MO]([CER_CODSOC], [CER_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CER_NB] ON [dbo].[U_CER_MO]([CER_CODSOC], [CER_NUMBOL]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CER_CS] ON [dbo].[U_CER_MO]([CER_CODSOC], [CER_CODICE], [CER_CERTBV], [CER_DATACS]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CIC_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CIC_DG')
   drop index U_CIC_DD.U_CIC_DG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CIC_DA')
   drop index U_CIC_DD.U_CIC_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CIC_DD')
   drop index U_CIC_DD.U_CIC_DD
GO
 
CREATE INDEX [U_CIC_DG] ON [dbo].[U_CIC_DD]([CIC_GRUPPO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CIC_DA] ON [dbo].[U_CIC_DD]([CIC_MACCHI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CIC_DD] ON [dbo].[U_CIC_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CIC_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CIC_GR')
   drop index U_CIC_TT.U_CIC_GR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CIC_TT')
   drop index U_CIC_TT.U_CIC_TT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CIC_DE')
   drop index U_CIC_TT.U_CIC_DE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CIC_01')
   drop index U_CIC_TT.U_CIC_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CIC_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CIC_TT.INDICE_02
GO


CREATE INDEX [U_CIC_GR] ON [dbo].[U_CIC_TT]([CIT_GRUPPO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CIC_TT] ON [dbo].[U_CIC_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CIC_DE] ON [dbo].[U_CIC_TT]([CIT_DESCRI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CIC_01] ON [dbo].[U_CIC_TT]([CIT_CODSOC], [CIT_GRUPPO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CIC_TT]([CIT_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CIC_TT]([CIT_CODSOC], [CIT_DESCRI]) ON [PRIMARY]
GO


-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CLI_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CLI_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CLI_AN.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_CLI_AN.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_CLI_AN.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_CLI_AN.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_CLI_AN.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_CLI_AN.INDICE_08
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

CREATE INDEX [INDICE_01] ON [dbo].[U_CLI_AN]([CLI_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CLI_AN]([CLI_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_CLI_AN]([CLI_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_CLI_AN]([CLI_CODSOC], [CLI_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_CLI_AN]([CLI_PARIVA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_CLI_AN]([CLI_AGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_CLI_AN]([CLI_RICERC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_CLI_AN]([CLI_LOCALI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CLI_AS.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CLI_AN')
   drop index U_CLI_AS.U_CLI_AN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_RG')
   drop index U_CLI_AS.U_CLI_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_LO')
   drop index U_CLI_AS.U_CLI_LO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_NA')
   drop index U_CLI_AS.U_CLI_NA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_AG')
   drop index U_CLI_AS.U_CLI_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_PI')
   drop index U_CLI_AS.U_CLI_PI
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CLI_AL')
   drop index U_CLI_AS.U_CLI_AL
GO
 
CREATE INDEX [U_CLI_AN] ON [dbo].[U_CLI_AS]([CLI_CODSOC], [CLI_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_RG] ON [dbo].[U_CLI_AS]([CLI_CODSOC], [CLI_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_LO] ON [dbo].[U_CLI_AS]([CLI_CODSOC], [CLI_LOCALI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_NA] ON [dbo].[U_CLI_AS]([CLI_CODSOC], [CLI_NAZION]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_AG] ON [dbo].[U_CLI_AS]([CLI_CODSOC], [CLI_AGE], [CLI_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_PI] ON [dbo].[U_CLI_AS]([CLI_CODSOC], [CLI_PARIVA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CLI_AL] ON [dbo].[U_CLI_AS]([CLI_CODSOC], [CLI_RICERC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CLI_OP.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'T_CODICE')
   drop index U_CLI_OP.T_CODICE
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERO')
   drop index U_CLI_OP.T_NUMERO
GO
 
if exists (select name from dbo.sysindexes where name = 'T_CLINFA')
   drop index U_CLI_OP.T_CLINFA
GO
 
if exists (select name from dbo.sysindexes where name = 'T_CLIDFA')
   drop index U_CLI_OP.T_CLIDFA
GO
 
CREATE INDEX [T_CODICE] ON [dbo].[U_CLI_OP]([CLI_COD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERO] ON [dbo].[U_CLI_OP]([CLI_NFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [T_CLINFA] ON [dbo].[U_CLI_OP]([CLI_COD], [CLI_NFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [T_CLIDFA] ON [dbo].[U_CLI_OP]([CLI_COD], [CLI_DTFAT]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CLI_PA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'T_CODICE')
   drop index U_CLI_PA.T_CODICE
GO
 
CREATE INDEX [T_CODICE] ON [dbo].[U_CLI_PA]([CLI_CODCLI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CMC_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CMC_CO')
   drop index U_CMC_AN.U_CMC_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CMC_RG')
   drop index U_CMC_AN.U_CMC_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CMC_DA')
   drop index U_CMC_AN.U_CMC_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CMC_NU')
   drop index U_CMC_AN.U_CMC_NU
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CMC_AG')
   drop index U_CMC_AN.U_CMC_AG
GO
 
CREATE INDEX [U_CMC_CO] ON [dbo].[U_CMC_AN]([CMD_CODSOC], [CMD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CMC_RG] ON [dbo].[U_CMC_AN]([CMD_CODSOC], [CMD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CMC_DA] ON [dbo].[U_CMC_AN]([CMD_CODSOC], [CMD_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CMC_NU] ON [dbo].[U_CMC_AN]([CMD_CODSOC], [CMD_NUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CMC_AG] ON [dbo].[U_CMC_AN]([CMD_CODAGE], [CMD_CODCLI], [CMD_NUMERO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CMD_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CMD_CO')
   drop index U_CMD_AN.U_CMD_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CMD_RG')
   drop index U_CMD_AN.U_CMD_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CMD_DA')
   drop index U_CMD_AN.U_CMD_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CMD_NU')
   drop index U_CMD_AN.U_CMD_NU
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CMD_AG')
   drop index U_CMD_AN.U_CMD_AG
GO
 
CREATE INDEX [U_CMD_CO] ON [dbo].[U_CMD_AN]([CMD_CODSOC], [CMD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CMD_RG] ON [dbo].[U_CMD_AN]([CMD_CODSOC], [CMD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CMD_DA] ON [dbo].[U_CMD_AN]([CMD_CODSOC], [CMD_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CMD_NU] ON [dbo].[U_CMD_AN]([CMD_CODSOC], [CMD_NUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CMD_AG] ON [dbo].[U_CMD_AN]([CMD_CODAGE], [CMD_CODCLI], [CMD_NUMERO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_COM_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_COM_CL')
   drop index U_COM_AN.U_COM_CL
GO
 
CREATE INDEX [U_COM_CL] ON [dbo].[U_COM_AN]([COM_CODSOC], [COM_CLI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_COM_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'COMHOOKD')
   drop index U_COM_DD.COMHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'ORDHOOKD')
   drop index U_COM_DD.ORDHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_DA')
   drop index U_COM_DD.U_COM_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_AM')
   drop index U_COM_DD.U_COM_AM
GO
 
CREATE INDEX [COMHOOKD] ON [dbo].[U_COM_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [ORDHOOKD] ON [dbo].[U_COM_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_DA] ON [dbo].[U_COM_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_AM] ON [dbo].[U_COM_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_COM_ED.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CLICOMM')
   drop index U_COM_ED.CLICOMM
GO
 
if exists (select name from dbo.sysindexes where name = 'ARTCOMM')
   drop index U_COM_ED.ARTCOMM
GO
 
if exists (select name from dbo.sysindexes where name = 'COMMART')
   drop index U_COM_ED.COMMART
GO
 
if exists (select name from dbo.sysindexes where name = 'COMMPAD')
   drop index U_COM_ED.COMMPAD
GO
 
if exists (select name from dbo.sysindexes where name = 'CODISYS')
   drop index U_COM_ED.CODISYS
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_DA')
   drop index U_COM_ED.U_COM_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_AM')
   drop index U_COM_ED.U_COM_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'I_COMCLI')
   drop index U_COM_ED.I_COMCLI
GO
 
if exists (select name from dbo.sysindexes where name = 'I_PRGSCAD')
   drop index U_COM_ED.I_PRGSCAD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_COMART')
   drop index U_COM_ED.I_COMART
GO
 
if exists (select name from dbo.sysindexes where name = 'I_ARTCOM')
   drop index U_COM_ED.I_ARTCOM
GO
 
if exists (select name from dbo.sysindexes where name = 'I_LOTTO')
   drop index U_COM_ED.I_LOTTO
GO
 
CREATE INDEX [CLICOMM] ON [dbo].[U_COM_ED]([LCD_CODCLI], [LCD_NUMCOM], [LCD_CODART], [LCD_CODMAG], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [ARTCOMM] ON [dbo].[U_COM_ED]([LCD_CODART], [LCD_CODMAG], [LCD_NUMCOM], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [COMMART] ON [dbo].[U_COM_ED]([LCD_NUMCOM], [LCD_CODART], [LCD_CODMAG], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [COMMPAD] ON [dbo].[U_COM_ED]([LCD_NUMCOM], [LCD_PADRE], [LCD_CODART], [LCD_CODMAG], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [CODISYS] ON [dbo].[U_COM_ED]([LCD_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_DA] ON [dbo].[U_COM_ED]([LCD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_AM] ON [dbo].[U_COM_ED]([LCD_CODART], [LCD_CODMAG]) ON [PRIMARY]
GO
 
CREATE INDEX [I_COMCLI] ON [dbo].[U_COM_ED]([LCD_NUMCOM], [LCD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [I_PRGSCAD] ON [dbo].[U_COM_ED]([LCD_CODART], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [I_COMART] ON [dbo].[U_COM_ED]([LCD_DATLAN], [LCD_NUMCOM], [LCD_CODART], [LCD_CODMAG], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [I_ARTCOM] ON [dbo].[U_COM_ED]([LCD_CODART], [LCD_DATLAN], [LCD_CODMAG], [LCD_NUMCOM], [LCD_DATSCA]) ON [PRIMARY]
GO
 
CREATE INDEX [I_LOTTO] ON [dbo].[U_COM_ED]([LCD_NUMCOM], [LCD_TIPART], [LCD_LIVELL]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_COM_ET.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ARTCOMM')
   drop index U_COM_ET.ARTCOMM
GO
 
if exists (select name from dbo.sysindexes where name = 'ARTCOMN')
   drop index U_COM_ET.ARTCOMN
GO
 
CREATE INDEX [ARTCOMM] ON [dbo].[U_COM_ET]([LCT_CODART], [LCT_CODMAG], [LCT_TIPART]) ON [PRIMARY]
GO
 
CREATE INDEX [ARTCOMN] ON [dbo].[U_COM_ET]([LCT_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_COM_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'COMHOOKT')
   drop index U_COM_TT.COMHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'ORDHOOKT')
   drop index U_COM_TT.ORDHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'COMNDOCT')
   drop index U_COM_TT.COMNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_TN')
   drop index U_COM_TT.U_COM_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_TD')
   drop index U_COM_TT.U_COM_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_TC')
   drop index U_COM_TT.U_COM_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_TA')
   drop index U_COM_TT.U_COM_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_DA')
   drop index U_COM_TT.U_COM_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_RG')
   drop index U_COM_TT.U_COM_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_COM_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_MA')
   drop index U_COM_TT.U_COM_MA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_TV')
   drop index U_COM_TT.U_COM_TV
GO
 
if exists (select name from dbo.sysindexes where name = 'I_SELEZ')
   drop index U_COM_TT.I_SELEZ
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_OR')
   drop index U_COM_TT.U_COM_OR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_COM_01')
   drop index U_COM_TT.U_COM_01
GO

CREATE INDEX [COMHOOKT] ON [dbo].[U_COM_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [ORDHOOKT] ON [dbo].[U_COM_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [COMNDOCT] ON [dbo].[U_COM_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_TN] ON [dbo].[U_COM_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_TD] ON [dbo].[U_COM_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_TC] ON [dbo].[U_COM_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_TA] ON [dbo].[U_COM_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_DA] ON [dbo].[U_COM_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_RG] ON [dbo].[U_COM_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_COM_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_MA] ON [dbo].[U_COM_TT]([ORD_CODSOC], [ORD_MATRIC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_TV] ON [dbo].[U_COM_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [I_SELEZ] ON [dbo].[U_COM_TT]([SELEZIONE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_OR] ON [dbo].[U_COM_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_COM_01] ON [dbo].[U_COM_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_NUMORD]) ON [PRIMARY]
GO
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_CON_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_CON_CO')
   drop index U_CON_AN.U_CON_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CON_RG')
   drop index U_CON_AN.U_CON_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CON_ID')
   drop index U_CON_AN.U_CON_ID
GO
 
if exists (select name from dbo.sysindexes where name = 'U_CON_AN')
   drop index U_CON_AN.U_CON_AN
GO
 
CREATE INDEX [U_CON_CO] ON [dbo].[U_CON_AN]([SCA_CODSOC], [SCA_CODCLI], [SCA_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CON_RG] ON [dbo].[U_CON_AN]([SCA_CODSOC], [SCA_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CON_ID] ON [dbo].[U_CON_AN]([SCA_CODSOC], [SCA_NUMID]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CON_AN] ON [dbo].[U_CON_AN]([SCA_CODSOC], [SCA_CODCLI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_COR_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RIGAD')
   drop index U_COR_TT.RIGAD
GO
 
if exists (select name from dbo.sysindexes where name = 'RIGAT')
   drop index U_COR_TT.RIGAT
GO
 
CREATE INDEX [RIGAD] ON [dbo].[U_COR_TT]([COR_CODSOC], [COR_RIGA]) ON [PRIMARY]
GO
 
CREATE INDEX [RIGAT] ON [dbo].[U_COR_TT]([COR_CODSOC], [COR_CONFLU]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'U_CTL_01')
   drop index U_CTL_TT.U_CTL_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CTL_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CTL_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CTL_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_CTL_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_CTL_TT.INDICE_05
GO


if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_CTL_TT.INDICE_06
GO

 
CREATE INDEX [CTLHOOKT] ON [dbo].[U_CTL_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [CTLNDOCT] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_TN] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_TD] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_TC] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_TA] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_RG] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_DA] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_CTL_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_TB] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_NUMBOL], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_OR] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_CTL_01] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CTL_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CTL_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_CTL_TT]([ORD_NUMBOL]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_CTL_TT]([ORD_DATBOL]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_CTL_TT]([ORD_CODSOC], [ORD_DATBOL], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_CTL_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO







-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_DIS_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_DIS_CO')
   drop index U_DIS_AN.U_DIS_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_DIS_DE')
   drop index U_DIS_AN.U_DIS_DE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_DIS_CR')
   drop index U_DIS_AN.U_DIS_CR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_DIS_AR')
   drop index U_DIS_AN.U_DIS_AR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_DIS_RE')
   drop index U_DIS_AN.U_DIS_RE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_DIS_DT')
   drop index U_DIS_AN.U_DIS_DT
GO
 
CREATE INDEX [U_DIS_CO] ON [dbo].[U_DIS_AN]([DIS_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_DE] ON [dbo].[U_DIS_AN]([DIS_DESCRI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_CR] ON [dbo].[U_DIS_AN]([DIS_CODICE], [DIS_NUMREV]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_AR] ON [dbo].[U_DIS_AN]([DIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_RE] ON [dbo].[U_DIS_AN]([DIS_NUMREV]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_DT] ON [dbo].[U_DIS_AN]([DIS_DATREV]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_DIS_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_DIS_TT.INDICE_02
GO

 
CREATE INDEX [U_DIS_GR] ON [dbo].[U_DIS_TT]([DIT_GRUPPO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_TT] ON [dbo].[U_DIS_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_DIS_DE] ON [dbo].[U_DIS_TT]([DIT_DESCRI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_DIS_TT]([DIT_CODSOC], [DIT_GRUPPO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_DIS_TT]([DIT_CODSOC], [DIT_DESCRI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_DSB_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_DSB_GR')
   drop index U_DSB_AN.U_DSB_GR
GO
 
CREATE INDEX [U_DSB_GR] ON [dbo].[U_DSB_AN]([DSB_GRUPPO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_EFF_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'EFFHOOKD')
   drop index U_EFF_DD.EFFHOOKD
GO
 
CREATE INDEX [EFFHOOKD] ON [dbo].[U_EFF_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_EFF_PA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'EFFHOOK3')
   drop index U_EFF_PA.EFFHOOK3
GO
 
CREATE INDEX [EFFHOOK3] ON [dbo].[U_EFF_PA]([DAGGANCIO], [WPRORIG]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_EFF_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'EFFHOOKT')
   drop index U_EFF_TT.EFFHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_EFF_TN')
   drop index U_EFF_TT.U_EFF_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_EFF_TD')
   drop index U_EFF_TT.U_EFF_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_EFF_TR')
   drop index U_EFF_TT.U_EFF_TR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_EFF_TA')
   drop index U_EFF_TT.U_EFF_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_EFF_TC')
   drop index U_EFF_TT.U_EFF_TC
GO
 
CREATE INDEX [EFFHOOKT] ON [dbo].[U_EFF_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_EFF_TN] ON [dbo].[U_EFF_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_EFF_TD] ON [dbo].[U_EFF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_EFF_TR] ON [dbo].[U_EFF_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_EFF_TA] ON [dbo].[U_EFF_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_EFF_TC] ON [dbo].[U_EFF_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ERR_RC.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ERR_TR.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FAG_DD.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FAG_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_FAG_TT')
   drop index U_FAG_TT.U_FAG_TT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAG_RS')
   drop index U_FAG_TT.U_FAG_RS
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAG_NU')
   drop index U_FAG_TT.U_FAG_NU
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_FAG_TT.T_NUMERIC
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_FAG_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_FAG_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_FAG_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_FAG_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_FAG_TT.INDICE_05
GO
 
CREATE INDEX [U_FAG_TT] ON [dbo].[U_FAG_TT]([AGE_CODSOC], [AGE_CODICE], [AGE_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAG_RS] ON [dbo].[U_FAG_TT]([AGE_CODSOC], [AGE_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAG_NU] ON [dbo].[U_FAG_TT]([AGE_CODSOC], [AGE_CODICE], [AGE_NUMFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_FAG_TT]([AGE_CODSOC], [AGE_CODICE], [AGE_DATFAT], [AGE_NUMFAT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_FAG_TT]([AGE_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_FAG_TT]([AGE_CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_FAG_TT]([AGE_CODSOC], [AGE_ANNO], [AGE_CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_FAG_TT]([AGE_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_FAG_TT]([AGE_CODSOC], [AGE_ANNO], [AGE_RAGSOC]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FAM_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FAMHOOKD')
   drop index U_FAM_DD.FAMHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAM_DA')
   drop index U_FAM_DD.U_FAM_DA
GO
 
CREATE INDEX [FAMHOOKD] ON [dbo].[U_FAM_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAM_DA] ON [dbo].[U_FAM_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FAM_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FAMHOOKT')
   drop index U_FAM_TT.FAMHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'FAMNDOCT')
   drop index U_FAM_TT.FAMNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAM_TN')
   drop index U_FAM_TT.U_FAM_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAM_TD')
   drop index U_FAM_TT.U_FAM_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAM_DA')
   drop index U_FAM_TT.U_FAM_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAM_TC')
   drop index U_FAM_TT.U_FAM_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAM_AG')
   drop index U_FAM_TT.U_FAM_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAM_TA')
   drop index U_FAM_TT.U_FAM_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAM_RG')
   drop index U_FAM_TT.U_FAM_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_FAM_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NPROT')
   drop index U_FAM_TT.T_NPROT
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_FAM_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAM_XX')
   drop index U_FAM_TT.U_FAM_XX
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_FAM_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_FAM_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_FAM_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_FAM_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_FAM_TT.INDICE_05
GO
 
CREATE INDEX [FAMHOOKT] ON [dbo].[U_FAM_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [FAMNDOCT] ON [dbo].[U_FAM_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAM_TN] ON [dbo].[U_FAM_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAM_TD] ON [dbo].[U_FAM_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAM_DA] ON [dbo].[U_FAM_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAM_TC] ON [dbo].[U_FAM_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAM_AG] ON [dbo].[U_FAM_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAM_TA] ON [dbo].[U_FAM_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAM_RG] ON [dbo].[U_FAM_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_FAM_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NPROT] ON [dbo].[U_FAM_TT]([ORD_NPROT]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_FAM_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAM_XX] ON [dbo].[U_FAM_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_NUMORD], [ORD_DATORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_FAM_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_FAM_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_FAM_TT]([ORD_DATORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_FAM_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_FAM_TT]([ORD_CODCLI]) ON [PRIMARY]
GO


 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_FAP_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_FAP_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_FAP_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_FAP_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_FAP_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_FAP_TT.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_FAP_TT.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_FAP_TT.INDICE_08
GO


 
CREATE INDEX [FAPHOOKT] ON [dbo].[U_FAP_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [FAPNDOCT] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_TN] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_TD] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_DA] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_TC] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_AG] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_TA] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAP_RG] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
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

CREATE INDEX [INDICE_01] ON [dbo].[U_FAP_TT]([ORD_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_FAP_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_FAP_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_FAP_TT]([ORD_DATORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_FAP_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_FAP_TT]([ORD_AGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_FAP_TT]([ORD_CODSOC], [ORD_NPROT], [ORD_DATORD]) ON [PRIMARY]
GO


CREATE INDEX [INDICE_08] ON [dbo].[U_FAP_TT]([ORD_CODCLI]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_FAT_DD.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_FAT_DD.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_FAT_DD.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_FAT_DD.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_FAT_DD.INDICE_05
GO

 
CREATE INDEX [FATHOOKD] ON [dbo].[U_FAT_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_DA] ON [dbo].[U_FAT_DD]([ORD_CODART]) ON [PRIMARY]
GO

CREATE INDEX [U_FAT_DF] ON [dbo].[U_FAT_DD]([ORD_CODART], [ORS_NUMORD], [ORS_DATORD], [ORS_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_FAT_DD]([DAGGANCIO], [ORD_MAGA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_FAT_DD]([ORS_VETTO1], [ORS_DATORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_FAT_DD]([DAGGANCIO], [ORS_NUMORD], [ORS_DATORD], [ORS_CODCLI], [ORD_CODART], [ORD_CODMAT], [ORD_CODCOL], [ORD_SPESSO], [ORD_ALTEZZ], [ORD_LUNGHE]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_04] ON [dbo].[U_FAT_DD]([DAGGANCIO], [ORS_NUMORD], [ORS_DATORD], [ORS_CODCLI], [ORD_CDAPRD], [ORD_CODMAT], [ORD_CODCOL], [ORD_SPESSO], [ORD_ALTEZZ], [ORD_LUNGHE]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_05] ON [dbo].[U_FAT_DD]([ORD_SYSPED], [ORD_CODART]) ON [PRIMARY]
GO 
-- *************************************************************************************************************************************

 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FAT_SD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKD')
   drop index U_FAT_SD.OFFHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_DA')
   drop index U_FAT_SD.U_OFF_DA
GO
 
CREATE INDEX [OFFHOOKD] ON [dbo].[U_FAT_SD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_DA] ON [dbo].[U_FAT_SD]([ORD_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FAT_ST.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKT')
   drop index U_FAT_ST.OFFHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'OFFNDOCT')
   drop index U_FAT_ST.OFFNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TN')
   drop index U_FAT_ST.U_OFF_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TD')
   drop index U_FAT_ST.U_OFF_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TC')
   drop index U_FAT_ST.U_OFF_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TA')
   drop index U_FAT_ST.U_OFF_TA
GO
 
CREATE INDEX [OFFHOOKT] ON [dbo].[U_FAT_ST]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [OFFNDOCT] ON [dbo].[U_FAT_ST]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TN] ON [dbo].[U_FAT_ST]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TD] ON [dbo].[U_FAT_ST]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TC] ON [dbo].[U_FAT_ST]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TA] ON [dbo].[U_FAT_ST]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_FAT_TT.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_FAT_TT.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_FAT_TT.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_FAT_TT.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_FAT_TT.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_FAT_TT.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_FAT_TT.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_FAT_TT.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_FAT_TT.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_FAT_TT.INDICE_10
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_FAT_TT.INDICE_11
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_FAT_TT.INDICE_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_FAT_TT.INDICE_13
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_14')
   drop index U_FAT_TT.INDICE_14
GO



CREATE INDEX [FATHOOKT] ON [dbo].[U_FAT_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [FATNDOCT] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_TN] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_TD] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_TC] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_AG] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_TA] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_FAT_RG] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
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
CREATE INDEX [INDICE_01] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_NUMORD], [ORD_DATORD], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_FAT_TT]([ORD_PERIF], [ORD_SCAR]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_FAT_TT]([ORD_CODSOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_FAT_TT]([ORD_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_FAT_TT]([ORD_BOLLATOIVA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_FAT_TT]([ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_FAT_TT]([ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[U_FAT_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_11] ON [dbo].[U_FAT_TT]([ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_12] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_NPROT], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_13] ON [dbo].[U_FAT_TT]([ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_14] ON [dbo].[U_FAT_TT]([ORD_CODSOC], [ORD_CGE], [ORD_CODCLI]) ON [PRIMARY]
GO




-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FID_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FIDHOOKD')
   drop index U_FID_DD.FIDHOOKD
GO
 
CREATE INDEX [FIDHOOKD] ON [dbo].[U_FID_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FID_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FIDHOOKT')
   drop index U_FID_TT.FIDHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FID_TN')
   drop index U_FID_TT.U_FID_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FID_CO')
   drop index U_FID_TT.U_FID_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FID_RA')
   drop index U_FID_TT.U_FID_RA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FID_AG')
   drop index U_FID_TT.U_FID_AG
GO
 
CREATE INDEX [FIDHOOKT] ON [dbo].[U_FID_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FID_TN] ON [dbo].[U_FID_TT]([FID_CODSOC], [FID_NUMFID]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FID_CO] ON [dbo].[U_FID_TT]([FID_CODSOC], [FID_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FID_RA] ON [dbo].[U_FID_TT]([FID_CODSOC], [FID_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FID_AG] ON [dbo].[U_FID_TT]([FID_CODAGE], [FID_CODCLI], [FID_NUMFID]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FIN_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TIPOSCA')
   drop index U_FIN_AN.TIPOSCA
GO
 
if exists (select name from dbo.sysindexes where name = 'SCADENZA')
   drop index U_FIN_AN.SCADENZA
GO
 
CREATE INDEX [TIPOSCA] ON [dbo].[U_FIN_AN]([CODSOC], [TIPOREC], [SCADENZA]) ON [PRIMARY]
GO
 
CREATE INDEX [SCADENZA] ON [dbo].[U_FIN_AN]([CODSOC], [SCADENZA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_FOR_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_FOR_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_FOR_AN.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_FOR_AN.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_FOR_AN.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_FOR_AN.INDICE_06
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

CREATE INDEX [INDICE_01] ON [dbo].[U_FOR_AN]([FOR_RAGSOC], [FOR_PARIVA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_FOR_AN]([FOR_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_FOR_AN]([FOR_PARIVA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_FOR_AN]([FOR_RICERC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_FOR_AN]([FOR_LOCALI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_FOR_AN]([FOR_RAGSOC], [FOR_LOCALI]) ON [PRIMARY]
GO











-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FOR_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ORDHOOKD')
   drop index U_FOR_DD.ORDHOOKD
GO
 
CREATE INDEX [ORDHOOKD] ON [dbo].[U_FOR_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_FOR_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ORDHOOKT')
   drop index U_FOR_TT.ORDHOOKT
GO
 
CREATE INDEX [ORDHOOKT] ON [dbo].[U_FOR_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_INC_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_INC_AN')
   drop index U_INC_AN.U_INC_AN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_INC_RS')
   drop index U_INC_AN.U_INC_RS
GO
 
if exists (select name from dbo.sysindexes where name = 'U_INC_DT')
   drop index U_INC_AN.U_INC_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_INC_AL')
   drop index U_INC_AN.U_INC_AL
GO
 
if exists (select name from dbo.sysindexes where name = 'U_INC_AC')
   drop index U_INC_AN.U_INC_AC
GO
 
CREATE INDEX [U_INC_AN] ON [dbo].[U_INC_AN]([INC_CODSOC], [INC_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_INC_RS] ON [dbo].[U_INC_AN]([INC_CODSOC], [INC_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_INC_DT] ON [dbo].[U_INC_AN]([INC_CODSOC], [INC_CODCLI], [INC_DATINC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_INC_AL] ON [dbo].[U_INC_AN]([INC_CODSOC], [INC_CODCLI], [INC_CODCAU], [INC_NUMOFF], [INC_DATOFF], [INC_NUMORD], [INC_DATORD], [INC_CODMAG], [INC_DATINC], [INC_NUMFAT], [INC_DATFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_INC_AC] ON [dbo].[U_INC_AN]([INC_CODSOC], [INC_CODCLI], [INC_CODCAU], [INC_NUMOFF], [INC_DATOFF], [INC_NUMORD], [INC_DATORD], [INC_CODMAG], [INC_DATINC], [INC_NUMCOM], [INC_DATCOM]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_INS_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_INS_CO')
   drop index U_INS_AN.U_INS_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_INS_RG')
   drop index U_INS_AN.U_INS_RG
GO
 
CREATE INDEX [U_INS_CO] ON [dbo].[U_INS_AN]([INS_CODSOC], [INS_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_INS_RG] ON [dbo].[U_INS_AN]([INS_CODSOC], [INS_RAGSOC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_INT_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_INT_DT')
   drop index U_INT_AN.U_INT_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_INT_AG')
   drop index U_INT_AN.U_INT_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_INT_DC')
   drop index U_INT_AN.U_INT_DC
GO
 
CREATE INDEX [U_INT_DT] ON [dbo].[U_INT_AN]([INT_CODSOC], [INT_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_INT_AG] ON [dbo].[U_INT_AN]([INT_CODSOC], [INT_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_INT_DC] ON [dbo].[U_INT_AN]([INT_CODSOC], [INT_DATA], [INT_CODICE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_INT_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_INT_01')
   drop index U_INT_TT.U_INT_01
GO
 
if exists (select name from dbo.sysindexes where name = 'U_INT_02')
   drop index U_INT_TT.U_INT_02
GO
 
if exists (select name from dbo.sysindexes where name = 'U_INT_03')
   drop index U_INT_TT.U_INT_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_INT_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_INT_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_INT_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_INT_TT.INDICE_04
GO
 
CREATE INDEX [U_INT_01] ON [dbo].[U_INT_TT]([INT_CODSOC], [INT_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_INT_02] ON [dbo].[U_INT_TT]([INT_CODSOC], [INT_CODRIG]) ON [PRIMARY]
GO
 
CREATE INDEX [U_INT_03] ON [dbo].[U_INT_TT]([INT_CODSOC], [INT_CODRIA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_INT_TT]([INT_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_INT_TT]([INT_CONTO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_INT_TT]([INT_CODRIG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_INT_TT]([INT_CODRIA]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_IVA_CL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ANNOMESE')
   drop index U_IVA_CL.ANNOMESE
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMFATTU')
   drop index U_IVA_CL.NUMFATTU
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMPROT')
   drop index U_IVA_CL.NUMPROT
GO
 
CREATE INDEX [ANNOMESE] ON [dbo].[U_IVA_CL]([IVA_CODSOC], [IVA_ANNO], [IVA_MESE]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMFATTU] ON [dbo].[U_IVA_CL]([IVA_CODSOC], [IVA_ANNO], [IVA_NUMFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMPROT] ON [dbo].[U_IVA_CL]([IVA_CODSOC], [IVA_ANNO], [IVA_MESE], [IVA_CHIAVE], [IVA_CODIVA], [IVA_FATNOT]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_IVA_CR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_IVA_CT')
   drop index U_IVA_CR.U_IVA_CT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_IVA_CR')
   drop index U_IVA_CR.U_IVA_CR
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_IVA_CR.INDICE_01
GO
 
CREATE INDEX [U_IVA_CT] ON [dbo].[U_IVA_CR]([IVA_CODSOC], [IVA_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_IVA_CR] ON [dbo].[U_IVA_CR]([IVA_CODSOC], [IVA_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_IVA_CR]([IVA_ANNO]) ON [PRIMARY]
GO


 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_IVA_TO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODIVA')
   drop index U_IVA_TO.CODIVA
GO
 
CREATE INDEX [CODIVA] ON [dbo].[U_IVA_TO]([ITO_CODSOC], [ITO_ANNO], [ITO_MESE], [ITO_CODIVA], [ITO_CLIFOR], [ITO_FATNOT]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_IVF_CL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ANNOMESE')
   drop index U_IVF_CL.ANNOMESE
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMFATTU')
   drop index U_IVF_CL.NUMFATTU
GO
 
CREATE INDEX [ANNOMESE] ON [dbo].[U_IVF_CL]([IVF_CODSOC], [IVF_ANNO], [IVF_MESE]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMFATTU] ON [dbo].[U_IVF_CL]([IVF_CODSOC], [IVF_ANNO], [IVF_NUMFAT]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
CREATE INDEX [U_LEG_TD] ON [dbo].[U_LEG_DO]([LEG_TIPDOC], [LEG_CODCLI], [LEG_TIPCRE], [LEG_NUMCRE], [LEG_DATCRE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_NU] ON [dbo].[U_LEG_DO]([LEG_TIPDOC], [LEG_NUMDOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_DT] ON [dbo].[U_LEG_DO]([LEG_TIPDOC], [LEG_DATDOC], [LEG_NUMDOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_CR] ON [dbo].[U_LEG_DO]([LEG_TIPCRE], [LEG_DATCRE], [LEG_NUMCRE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LEG_NR] ON [dbo].[U_LEG_DO]([LEG_TIPCRE], [LEG_NUMCRE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_LIF_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_LIF_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_LIF_TT.INDICE_03
GO

 
CREATE INDEX [U_LIS_01] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_02] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_CODART], [LIS_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_03] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_DATLIS], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_CA] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_CO] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_DT] ON [dbo].[U_LIF_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART], [LIS_DATLIS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_LIF_TT]([LIS_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_LIF_TT]([LIS_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_LIF_TT]([LIS_DATLIS]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_LIS_LG.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_LIS_LG.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_LIS_LG.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_LIS_LG.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_LIS_LG.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_LIS_LG.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_LIS_LG.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_LIS_LG.INDICE_08
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

CREATE INDEX [INDICE_01] ON [dbo].[U_LIS_LG]([LIS_AGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_AGE], [LIS_TIPO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_LIS_LG]([LIS_LINART]) ON [PRIMARY]
GO


CREATE INDEX [INDICE_04] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_LINART], [LIS_TIPO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_LIS_LG]([LIS_ZONA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_ZONA], [LIS_TIPO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_LIS_LG]([LIS_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_LIS_LG]([LIS_CODSOC], [LIS_CODCLI], [LIS_TIPO]) ON [PRIMARY]
GO


-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_LIS_PA.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_LIS_PA.INDICE_02
GO

 
CREATE INDEX [AGENTE] ON [dbo].[U_LIS_PA]([LIS_CODSOC], [LIS_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [LINEA] ON [dbo].[U_LIS_PA]([LIS_CODSOC], [LIS_LINEA]) ON [PRIMARY]
GO
 
CREATE INDEX [AGELIN] ON [dbo].[U_LIS_PA]([LIS_CODSOC], [LIS_AGE], [LIS_LINEA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_LIS_PA]([LIS_AGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_LIS_PA]([LIS_LINEA]) ON [PRIMARY]
GO




 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_LIS_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_LIS_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_LIS_TT.INDICE_03
GO


CREATE INDEX [U_LIS_01] ON [dbo].[U_LIS_TT]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_02] ON [dbo].[U_LIS_TT]([LIS_CODSOC], [LIS_CODART], [LIS_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_03] ON [dbo].[U_LIS_TT]([LIS_CODSOC], [LIS_DATLIS], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
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

CREATE INDEX [INDICE_01] ON [dbo].[U_LIS_TT]([LIS_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_LIS_TT]([LIS_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_LIS_TT]([LIS_DATLIS]) ON [PRIMARY]
GO







-- ********************************************************************************

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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_LIS_VE.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_LIS_VE.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_LIS_VE.INDICE_03
GO


 
CREATE INDEX [U_LIS_TI] ON [dbo].[U_LIS_VE]([LIS_CODSOC], [LIS_TIPO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_VE] ON [dbo].[U_LIS_VE]([LIS_CODSOC], [LIS_TIPO], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LIS_AR] ON [dbo].[U_LIS_VE]([LIS_CODSOC], [LIS_CODART], [LIS_TIPO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_LIS_VE]([LIS_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_LIS_VE]([LIS_TIPO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_LIS_VE]([LIS_CODSOC], [LIS_DATLIS], [LIS_TIPO], [LIS_CODART]) ON [PRIMARY]
GO








 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_LOC_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_LOC_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_LOC_AN.INDICE_03
GO




 
CREATE UNIQUE INDEX [U_LOC_CF] ON [dbo].[U_LOC_AN]([LOC_CODSOC], [LOC_CF], [LOC_CODCLI], [LOC_CODLOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LOC_CO] ON [dbo].[U_LOC_AN]([LOC_CODSOC], [LOC_CODLOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LOC_CC] ON [dbo].[U_LOC_AN]([LOC_CODSOC], [LOC_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_LOC_RG] ON [dbo].[U_LOC_AN]([LOC_CODSOC], [LOC_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_LOC_AN]([LOC_CODLOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_LOC_AN]([LOC_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_LOC_AN]([LOC_RAGSOC]) ON [PRIMARY]
GO






 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_LOC_GI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'I_LOC1')
   drop index U_LOC_GI.I_LOC1
GO
 
if exists (select name from dbo.sysindexes where name = 'I_LOC2')
   drop index U_LOC_GI.I_LOC2
GO
 
if exists (select name from dbo.sysindexes where name = 'I_LOC3')
   drop index U_LOC_GI.I_LOC3
GO
 
if exists (select name from dbo.sysindexes where name = 'I_LOC4')
   drop index U_LOC_GI.I_LOC4
GO
 
if exists (select name from dbo.sysindexes where name = 'I_LOC5')
   drop index U_LOC_GI.I_LOC5
GO
 
if exists (select name from dbo.sysindexes where name = 'I_LOC6')
   drop index U_LOC_GI.I_LOC6
GO
 
CREATE INDEX [I_LOC1] ON [dbo].[U_LOC_GI]([LOC_CODMAG], [LOC_CORSIA], [LOC_FILA], [LOC_PIANO], [LOC_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [I_LOC2] ON [dbo].[U_LOC_GI]([LOC_CODMAG], [LOC_CODART], [LOC_CORSIA], [LOC_FILA], [LOC_PIANO]) ON [PRIMARY]
GO
 
CREATE INDEX [I_LOC3] ON [dbo].[U_LOC_GI]([LOC_CODMAG], [LOC_CODART], [LOC_CORSIA]) ON [PRIMARY]
GO
 
CREATE INDEX [I_LOC4] ON [dbo].[U_LOC_GI]([LOC_CODMAG], [LOC_CORSIA], [LOC_FILA], [LOC_PIANO], [LOC_CODART], [LOC_DTCOMP]) ON [PRIMARY]
GO
 
CREATE INDEX [I_LOC5] ON [dbo].[U_LOC_GI]([LOC_CODMAG], [LOC_CORSIA], [LOC_FILA], [LOC_PIANO], [LOC_CODART], [LOC_DATCAR]) ON [PRIMARY]
GO
 
CREATE INDEX [I_LOC6] ON [dbo].[U_LOC_GI]([LOC_CODMAG], [LOC_CODART], [LOC_DATCAR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_LOC_MO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'I_LOCM1')
   drop index U_LOC_MO.I_LOCM1
GO
 
CREATE INDEX [I_LOCM1] ON [dbo].[U_LOC_MO]([AGGANCIO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAC_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAC_CO')
   drop index U_MAC_AN.U_MAC_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAC_DE')
   drop index U_MAC_AN.U_MAC_DE
GO
 
CREATE INDEX [U_MAC_CO] ON [dbo].[U_MAC_AN]([MAC_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAC_DE] ON [dbo].[U_MAC_AN]([MAC_DESCRI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAC_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'GANCIO')
   drop index U_MAC_DD.GANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index U_MAC_DD.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMPAR')
   drop index U_MAC_DD.NUMPAR
GO
 
CREATE INDEX [GANCIO] ON [dbo].[U_MAC_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[U_MAC_DD]([RIC_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMPAR] ON [dbo].[U_MAC_DD]([RIC_NUMPAR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAC_ST.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAC_ST')
   drop index U_MAC_ST.U_MAC_ST
GO
 
CREATE INDEX [U_MAC_ST] ON [dbo].[U_MAC_ST]([LIB_DATMOD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAC_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TGANCIO')
   drop index U_MAC_TT.TGANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMERO')
   drop index U_MAC_TT.NUMERO
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAC_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAC_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MAC_TT.INDICE_03
GO
 
CREATE INDEX [TGANCIO] ON [dbo].[U_MAC_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMERO] ON [dbo].[U_MAC_TT]([RIC_PROGR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_MAC_TT]([RIC_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_MAC_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_MAC_TT]([RIC_CODSOC], [RIC_PROGR], [ORD_ANNO]) ON [PRIMARY]
GO





 
-- ********************************************************************************
 
 
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
if exists (select name from dbo.sysindexes where name = 'U_MAG_03')
   drop index U_MAG_AN.U_MAG_03
GO

CREATE INDEX [U_MAG_01] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GA] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART], [MAG_ANAART]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GF] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODFOR]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_DA] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_CODMAG], [MAG_DESART]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_02] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_GIACEN], [MAG_CODMAG]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_03] ON [dbo].[U_MAG_AN]([MAG_CODSOC], [MAG_CODMAG], [MAG_ANAART]) ON [PRIMARY]
GO 
-- ********************************************************************************


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
if exists (select name from dbo.sysindexes where name = 'U_MAG_10')
   drop index U_MAG_GG.U_MAG_10
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_11')
   drop index U_MAG_GG.U_MAG_11
GO
if exists (select name from dbo.sysindexes where name = 'U_MAG_12')
   drop index U_MAG_GG.U_MAG_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_GG.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAG_GG.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MAG_GG.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MAG_GG.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MAG_GG.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_MAG_GG.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_MAG_GG.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_MAG_GG.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_MAG_GG.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_MAG_GG.INDICE_10
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_MAG_GG.INDICE_11
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_MAG_GG.INDICE_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_MAG_GG.INDICE_13
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_14')
   drop index U_MAG_GG.INDICE_14
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_15')
   drop index U_MAG_GG.INDICE_15
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_16')
   drop index U_MAG_GG.INDICE_16
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_17')
   drop index U_MAG_GG.INDICE_17
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_18')
   drop index U_MAG_GG.INDICE_18
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_19')
   drop index U_MAG_GG.INDICE_19
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_20')
   drop index U_MAG_GG.INDICE_20
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_21')
   drop index U_MAG_GG.INDICE_21
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_22')
   drop index U_MAG_GG.INDICE_22
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_23')
   drop index U_MAG_GG.INDICE_23
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_24')
   drop index U_MAG_GG.INDICE_24
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_25')
   drop index U_MAG_GG.INDICE_25
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_26')
   drop index U_MAG_GG.INDICE_26
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_27')
   drop index U_MAG_GG.INDICE_27
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_28')
   drop index U_MAG_GG.INDICE_28
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_29')
   drop index U_MAG_GG.INDICE_29
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_30')
   drop index U_MAG_GG.INDICE_30
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_31')
   drop index U_MAG_GG.INDICE_31
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_32')
   drop index U_MAG_GG.INDICE_32
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_33')
   drop index U_MAG_GG.INDICE_33
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_34')
   drop index U_MAG_GG.INDICE_34
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_35')
   drop index U_MAG_GG.INDICE_35
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_36')
   drop index U_MAG_GG.INDICE_36
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_37')
   drop index U_MAG_GG.INDICE_37
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_38')
   drop index U_MAG_GG.INDICE_38
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_39')
   drop index U_MAG_GG.INDICE_39
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_40')
   drop index U_MAG_GG.INDICE_40
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_41')
   drop index U_MAG_GG.INDICE_41
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_42')
   drop index U_MAG_GG.INDICE_42
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_43')
   drop index U_MAG_GG.INDICE_43
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_44')
   drop index U_MAG_GG.INDICE_44
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_45')
   drop index U_MAG_GG.INDICE_45
GO


CREATE INDEX [U_MAG_G1] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_CODPDV], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G2] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT],  [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G3] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_FORNIT],  [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G4] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G5] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G6] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_CODMAG], [MAG_FORNIT], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G7] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_GIACEN], [MAG_FORNIT], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO 
CREATE INDEX [U_MAG_G8] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_GIACEN], [MAG_CODACQ], [MAG_PRZCON], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G9] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_GIACEN], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G0] ON [dbo].[U_MAG_GG]([MAG_CODMAG], [MAG_LEGSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GA] ON [dbo].[U_MAG_GG]([MAG_CODMAG], [MAG_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GB] ON [dbo].[U_MAG_GG]([MAG_FLGTRA]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_GC] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODPDV], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_10] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_ANAART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_DATAGG], [MAG_GIACEN], [MAG_FILA_N], [MAG_PIAN_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_11] ON [dbo].[U_MAG_GG]([MAG_DATAGG], [MAG_GIACEN], [MAG_CODMAG], [MAG_QTAIMP], [MAG_ANAART], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_12] ON [dbo].[U_MAG_GG]([ID_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_DATAGG], [MAG_GIACEN], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_ANAART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_CODART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_DATAGG], [MAG_GIACEN], [MAG_FILA_N], [MAG_PIAN_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_PRZCON], [MAG_CODACQ], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART], [MAG_FORNIT], [MAG_CODACQ], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_DATAGG], [MAG_PRZCON], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_ANAART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_CLIENT], [MAG_NUMPED], [MAG_DATAGG], [MAG_GIACEN]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_ANAART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_QTAIMP], [MAG_DATAGG], [MAG_GIACEN], [MAG_FILA_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_11] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_ANAART], [MAG_NRLINT], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_QTAIMP], [MAG_DATAGG], [MAG_GIACEN], [MAG_FILA_N], [MAG_PIAN_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_12] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_CODART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_DATAGG], [MAG_GIACEN], [MAG_QTAIMP], [MAG_FILA_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_13] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_CODART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_14] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_CODART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_QTAIMP], [MAG_DATAGG], [MAG_GIACEN], [MAG_FILA_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_15] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_LUNGHE], [MAG_CODART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_ALTEZZ], [MAG_DATAGG], [MAG_GIACEN], [MAG_QTAIMP], [MAG_FILA_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_16] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_CODPDV], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_17] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_GIACEN], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_18] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_GIACEN], [MAG_PRZCON], [MAG_CODACQ], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_19] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_NRLINT], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_20] ON [dbo].[U_MAG_GG]([MAG_DATAGG], [MAG_GIACEN], [MAG_CODMAG], [MAG_QTAIMP], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_21] ON [dbo].[U_MAG_GG]([MAG_DATAGG], [MAG_GIACEN], [MAG_CODMAG], [MAG_QTAIMP], [MAG_FLGRIB], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_22] ON [dbo].[U_MAG_GG]([MAG_NRLINT], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_23] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_ANAART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_DATAGG], [MAG_GIACEN], [MAG_FILA_N], [MAG_PIAN_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_24] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODMAT], [MAG_DTFICQ], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_25] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODMAT], [MAG_DTINCQ], [MAG_DTFICQ], [MAG_DATAGG], [MAG_TIPART], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_26] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODMAT], [MAG_TIPART], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_27] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAG], [MAG_DTFICQ], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_28] ON [dbo].[U_MAG_GG]([MAG_SYSORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_29] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODACQ], [MAG_CODART], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_30] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_31] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_CODACQ], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_32] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_33] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_FORNIT], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_34] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_DATAGG], [MAG_GIACEN], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_35] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_36] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_37] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_SERBOL], [MAG_SERNUM], [MAG_AAPROD], [MAG_NUMEDA], [MAG_NUMEAL], [MAG_FLGCEL], [MAG_ANAART], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_GIACEN], [MAG_DATAGG], [MAG_FILA_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_38] ON [dbo].[U_MAG_GG]([MAG_ANAART], [MAG_SERBOL], [MAG_SERNUM], [MAG_AAPROD], [MAG_NUMEDA], [MAG_GIACEN], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_39] ON [dbo].[U_MAG_GG]([MAG_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_40] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_CODART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_ANAART], [MAG_DATAGG], [MAG_GIACEN], [MAG_FILA_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_41] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODMAT], [MAG_DTINCQ], [MAG_DTFICQ], [MAG_TIPART], [MAG_DATAGG], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_42] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_NRLINT], [MAG_DATAGG], [MAG_GIACEN], [MAG_FILA_N], [MAG_PIAN_N]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_43] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODMAG], [MAG_FILA_X], [MAG_PIAN_X], [MAG_UBIC_X], [MAG_DATAGG], [MAG_GIACEN]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_44] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_ANAART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_FILA_X], [MAG_PIAN_X], [MAG_UBIC_X]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_45] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_ANAART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_FILA_N], [MAG_PIAN_N], [MAG_UBIC_N]) ON [PRIMARY]
GO
-- ********************************************************************************

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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_DA.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAG_DA.INDICE_02
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

CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_CODPDV], [MAG_DATAGG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO], [MAG_DATAGG]) ON [PRIMARY]
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_CP.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAG_CP.INDICE_02
GO

CREATE INDEX [U_MAG_G1] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G2] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_DATAGG], [MAG_GIACEN]) ON [PRIMARY]
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

CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_DATAGG], [MAG_GIACEN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_MAG_CP]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_NUMCAM], [MAG_DATCAM], [MAG_GIACEN], [MAG_DATAGG]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_MAG_CL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FPS_INDICE')
   drop index U_MAG_CL.FPS_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAG_CL')
   drop index U_MAG_CL.U_MAG_CL
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAG_DA')
   drop index U_MAG_CL.U_MAG_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAG_AR')
   drop index U_MAG_CL.U_MAG_AR
GO
 
CREATE INDEX [FPS_INDICE] ON [dbo].[U_MAG_CL]([MOV_DATORD], [MOV_NUMORD], [MOV_CODORD], [MOV_TIPORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAG_CL] ON [dbo].[U_MAG_CL]([MOV_CODORD], [MOV_CODART], [MOV_CODMAG]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAG_DA] ON [dbo].[U_MAG_CL]([MOV_DATORD], [MOV_CODORD], [MOV_CODART], [MOV_CODMAG]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAG_AR] ON [dbo].[U_MAG_CL]([MOV_CODORD], [MOV_NUMORD], [MOV_DATORD], [MOV_TIPORD], [MOV_CODART], [MOV_CODMAG]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAG_DF.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAG_DF')
   drop index U_MAG_DF.U_MAG_DF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAG_DS')
   drop index U_MAG_DF.U_MAG_DS
GO
 
CREATE INDEX [U_MAG_DF] ON [dbo].[U_MAG_DF]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAG_DS] ON [dbo].[U_MAG_DF]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART], [MAG_SERCAR], [MAG_NUMDA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAG_DM.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAG_IN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAG_01')
   drop index U_MAG_IN.U_MAG_01
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAG_GA')
   drop index U_MAG_IN.U_MAG_GA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAG_GF')
   drop index U_MAG_IN.U_MAG_GF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAG_DA')
   drop index U_MAG_IN.U_MAG_DA
GO
 
CREATE INDEX [U_MAG_01] ON [dbo].[U_MAG_IN]([MAG_CODSOC], [MAG_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAG_GA] ON [dbo].[U_MAG_IN]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAG_GF] ON [dbo].[U_MAG_IN]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODFOR]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAG_DA] ON [dbo].[U_MAG_IN]([MAG_CODSOC], [MAG_CODMAG], [MAG_DESART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
if exists (select name from dbo.sysindexes where name = 'U_MAG_12')
   drop index U_MAG_MO.U_MAG_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_MO.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAG_MO.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MAG_MO.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MAG_MO.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MAG_MO.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_MAG_MO.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_MAG_MO.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_MAG_MO.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_MAG_MO.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_MAG_MO.INDICE_10
GO


CREATE INDEX [U_MAG_MA] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_CODART], [MOV_DTDOCU], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_MD] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_DTDOCU], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_RD] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_CODART], [MOV_DTREGI], [MOV_FORNIT]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_MF] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAG], [MOV_CODFOR], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [DTREG] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_DTREGI], [MOV_CODART], [MOV_TOP], [MOV_CODFOR]) ON [PRIMARY]
GO
CREATE INDEX [CODART] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODART], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [NUMDOC] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_NUMDOC], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_AR] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODART], [MOV_FORNIT], [MOV_CODACQ], [MOV_NUMIDE], [MOV_CODBUN], [MOV_ANNO], [MOV_DATSCA], [MOV_PREACQ], [MOV_CODMAG], [MOV_DTREGI]) ON [PRIMARY]
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
CREATE INDEX [U_MAG_ML] ON [dbo].[U_MAG_MO]([MOV_CODMAG], [MOV_LEGSYS], [MOV_NUMIDE]) ON [PRIMARY]
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
CREATE INDEX [U_MAG_12] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAT], [MOV_CODCOL], [MOV_SPESSO], [MOV_ALTEZZ], [MOV_LUNGHE], [MOV_ANAART], [MOV_NRLINT], [MOV_CODMAG], [MOV_FORNIT], [MOV_NUMIDE], [MOV_ANNO], [MOV_NUMDOC], [MOV_DTDOCU], [MOV_TOP], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODART], [MOV_CODMAG], [MOV_FORNIT], [MOV_CODACQ], [MOV_PREACQ], [MOV_NUMIDE], [MOV_CODBUN], [MOV_ANNO], [MOV_DATSCA], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODART], [MOV_CODMAG], [MOV_FORNIT], [MOV_CODACQ], [MOV_PRZCON], [MOV_NUMIDE], [MOV_CODBUN], [MOV_ANNO], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAT], [MOV_CODCOL], [MOV_SPESSO], [MOV_ALTEZZ], [MOV_LUNGHE], [MOV_ANAART], [MOV_NRLINT], [MOV_CODMAG], [MOV_FORNIT], [MOV_NUMIDE], [MOV_ANNO], [MOV_NUMDOC], [MOV_DTDOCU], [MOV_TOP], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODART], [MOV_CODMAG], [MOV_TOP], [MOV_CODFOR]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODART], [MOV_FORNIT], [MOV_CODACQ], [MOV_NUMIDE], [MOV_CODBUN], [MOV_ANNO], [MOV_DATSCA], [MOV_PREACQ], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODMAT], [MOV_ANAART], [MOV_FORNIT], [MOV_NUMIDE], [MOV_ANNO], [MOV_NUMDOC], [MOV_DTDOCU], [MOV_TOP], [MOV_DTREGI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_DTREGI], [MOV_CODART], [MOV_TOP], [MOV_CODACQ], [MOV_CODFOR]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_NRLINT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_MAG_MO]([MOV_NUMDOC], [MOV_DTDOCU]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[U_MAG_MO]([MOV_CODSOC], [MOV_CODART], [MOV_CODMAG], [MOV_TOP], [MOV_CODFOR], [MOV_LEGSYS]) ON [PRIMARY]
GO

-- ********************************************************************************
 
 
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAN_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'GANCIO')
   drop index U_MAN_DD.GANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index U_MAN_DD.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMPAR')
   drop index U_MAN_DD.NUMPAR
GO
 
CREATE INDEX [GANCIO] ON [dbo].[U_MAN_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[U_MAN_DD]([RIC_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMPAR] ON [dbo].[U_MAN_DD]([RIC_NUMPAR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAN_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TGANCIO')
   drop index U_MAN_TT.TGANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMERO')
   drop index U_MAN_TT.NUMERO
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAN_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAN_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MAN_TT.INDICE_03
GO

 
CREATE INDEX [TGANCIO] ON [dbo].[U_MAN_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMERO] ON [dbo].[U_MAN_TT]([RIC_PROGR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_MAN_TT]([RIC_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_MAN_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_MAN_TT]([RIC_CODSOC], [RIC_PROGR], [ORD_ANNO]) ON [PRIMARY]
GO








 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MAR_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MAR_CL')
   drop index U_MAR_AN.U_MAR_CL
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAR_RA')
   drop index U_MAR_AN.U_MAR_RA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAR_AR')
   drop index U_MAR_AN.U_MAR_AR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MAR_DA')
   drop index U_MAR_AN.U_MAR_DA
GO
 
CREATE INDEX [U_MAR_CL] ON [dbo].[U_MAR_AN]([MAR_CODSOC], [MAR_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAR_RA] ON [dbo].[U_MAR_AN]([MAR_CODSOC], [MAR_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAR_AR] ON [dbo].[U_MAR_AN]([MAR_CODSOC], [MAR_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MAR_DA] ON [dbo].[U_MAR_AN]([MAR_CODSOC], [MAR_DESART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MDC_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MDC_AN')
   drop index U_MDC_AN.U_MDC_AN
GO
 
CREATE INDEX [U_MDC_AN] ON [dbo].[U_MDC_AN]([MDC_CODICE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MDC_ST.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_MDC_ST')
   drop index U_MDC_ST.U_MDC_ST
GO
 
CREATE INDEX [U_MDC_ST] ON [dbo].[U_MDC_ST]([LIB_DATMOD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MRI_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'MRIHOOKD')
   drop index U_MRI_DD.MRIHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_DA')
   drop index U_MRI_DD.U_MRI_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_AM')
   drop index U_MRI_DD.U_MRI_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_DO')
   drop index U_MRI_DD.U_MRI_DO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_RI')
   drop index U_MRI_DD.U_MRI_RI
GO
 
CREATE INDEX [MRIHOOKD] ON [dbo].[U_MRI_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_DA] ON [dbo].[U_MRI_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_AM] ON [dbo].[U_MRI_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_DO] ON [dbo].[U_MRI_DD]([ORS_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_RI] ON [dbo].[U_MRI_DD]([ORS_NUMORD], [ORS_DATORD], [ORS_CODEMI], [ORS_TIPORD], [ORS_MAGS], [ORD_CODART], [ORD_CODSYS]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_MRI_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'MRIHOOKT')
   drop index U_MRI_TT.MRIHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'MRINDOCT')
   drop index U_MRI_TT.MRINDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_TN')
   drop index U_MRI_TT.U_MRI_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_TD')
   drop index U_MRI_TT.U_MRI_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_TC')
   drop index U_MRI_TT.U_MRI_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_TA')
   drop index U_MRI_TT.U_MRI_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_DA')
   drop index U_MRI_TT.U_MRI_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_RG')
   drop index U_MRI_TT.U_MRI_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_MRI_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_TV')
   drop index U_MRI_TT.U_MRI_TV
GO
 
if exists (select name from dbo.sysindexes where name = 'FPS_INDICE')
   drop index U_MRI_TT.FPS_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'MRI_CLOSE')
   drop index U_MRI_TT.MRI_CLOSE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_RE')
   drop index U_MRI_TT.U_MRI_RE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_MRI_OR')
   drop index U_MRI_TT.U_MRI_OR
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MRI_TT.INDICE_01
GO


if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MRI_TT.INDICE_02
GO


if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MRI_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MRI_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MRI_TT.INDICE_05
GO
 
CREATE INDEX [MRIHOOKT] ON [dbo].[U_MRI_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [MRINDOCT] ON [dbo].[U_MRI_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_TN] ON [dbo].[U_MRI_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_TD] ON [dbo].[U_MRI_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_TC] ON [dbo].[U_MRI_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_TA] ON [dbo].[U_MRI_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_DA] ON [dbo].[U_MRI_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_RG] ON [dbo].[U_MRI_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_MRI_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_TV] ON [dbo].[U_MRI_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [FPS_INDICE] ON [dbo].[U_MRI_TT]([ORD_DATORD], [ORD_NUMORD], [ORD_CODEMI], [ORD_TIPORD]) ON [PRIMARY]
GO
 
CREATE INDEX [MRI_CLOSE] ON [dbo].[U_MRI_TT]([ORD_CHIUSO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_RE] ON [dbo].[U_MRI_TT]([ORD_CODSOC], [ORD_RAGEMI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_MRI_OR] ON [dbo].[U_MRI_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_MRI_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_MRI_TT]([ORD_NUMORD]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_03] ON [dbo].[U_MRI_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_MRI_TT]([ORD_AGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_MRI_TT]([ORD_CODCLI]) ON [PRIMARY]
GO



-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_NCR_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'NCRHOOKD')
   drop index U_NCR_DD.NCRHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_NCR_DA')
   drop index U_NCR_DD.U_NCR_DA
GO
 
CREATE INDEX [NCRHOOKD] ON [dbo].[U_NCR_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_NCR_DA] ON [dbo].[U_NCR_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_NCR_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'NCRHOOKT')
   drop index U_NCR_TT.NCRHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'NCRNDOCT')
   drop index U_NCR_TT.NCRNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_NCR_TN')
   drop index U_NCR_TT.U_NCR_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_NCR_TD')
   drop index U_NCR_TT.U_NCR_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_NCR_DA')
   drop index U_NCR_TT.U_NCR_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_NCR_TC')
   drop index U_NCR_TT.U_NCR_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_NCR_AG')
   drop index U_NCR_TT.U_NCR_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_NCR_TA')
   drop index U_NCR_TT.U_NCR_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_NCR_RG')
   drop index U_NCR_TT.U_NCR_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_NCR_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NPROT')
   drop index U_NCR_TT.T_NPROT
GO
 
CREATE INDEX [NCRHOOKT] ON [dbo].[U_NCR_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [NCRNDOCT] ON [dbo].[U_NCR_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_NCR_TN] ON [dbo].[U_NCR_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_NCR_TD] ON [dbo].[U_NCR_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_NCR_DA] ON [dbo].[U_NCR_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_NCR_TC] ON [dbo].[U_NCR_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_NCR_AG] ON [dbo].[U_NCR_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_NCR_TA] ON [dbo].[U_NCR_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_NCR_RG] ON [dbo].[U_NCR_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_NCR_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NPROT] ON [dbo].[U_NCR_TT]([ORD_NPROT]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_OFF_SD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKD')
   drop index U_OFF_SD.OFFHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_DA')
   drop index U_OFF_SD.U_OFF_DA
GO
 
CREATE INDEX [OFFHOOKD] ON [dbo].[U_OFF_SD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_DA] ON [dbo].[U_OFF_SD]([ORD_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_OFF_ST.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKT')
   drop index U_OFF_ST.OFFHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'OFFNDOCT')
   drop index U_OFF_ST.OFFNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TN')
   drop index U_OFF_ST.U_OFF_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TD')
   drop index U_OFF_ST.U_OFF_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TC')
   drop index U_OFF_ST.U_OFF_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TA')
   drop index U_OFF_ST.U_OFF_TA
GO
 
CREATE INDEX [OFFHOOKT] ON [dbo].[U_OFF_ST]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [OFFNDOCT] ON [dbo].[U_OFF_ST]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TN] ON [dbo].[U_OFF_ST]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TD] ON [dbo].[U_OFF_ST]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TC] ON [dbo].[U_OFF_ST]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TA] ON [dbo].[U_OFF_ST]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_OFF_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_OFF_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_OFF_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_OFF_TT.INDICE_04
GO
 
CREATE INDEX [OFFHOOKT] ON [dbo].[U_OFF_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [OFFNDOCT] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TN] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TD] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TC] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TA] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_DA] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_RG] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_OFF_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_OR] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_OFF_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_OFF_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_OFF_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_OFF_TT]([ORD_AGE]) ON [PRIMARY]
GO




 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_OPE_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_OPE_AN')
   drop index U_OPE_AN.U_OPE_AN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OPE_RS')
   drop index U_OPE_AN.U_OPE_RS
GO
 
CREATE INDEX [U_OPE_AN] ON [dbo].[U_OPE_AN]([OPE_CODSOC], [OPE_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OPE_RS] ON [dbo].[U_OPE_AN]([OPE_CODSOC], [OPE_RAGSOC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
if exists (select name from dbo.sysindexes where name = 'U_ORD_01')
   drop index U_ORD_DD.U_ORD_01
GO
if exists (select name from dbo.sysindexes where name = 'U_ORD_02')
   drop index U_ORD_DD.U_ORD_02
GO
if exists (select name from dbo.sysindexes where name = 'U_ORD_03')
   drop index U_ORD_DD.U_ORD_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ORD_DD.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_ORD_DD.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_ORD_DD.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_ORD_DD.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_ORD_DD.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_ORD_DD.INDICE_06
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
CREATE INDEX [U_ORD_01] ON [dbo].[U_ORD_DD]([ID_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_ORD_02] ON [dbo].[U_ORD_DD]([ORS_CODCLI], [ORS_DATORD], [ORD_DATCON], [ORD_NUMPRG], [ORD_DATPRG], [ORD_FLGPRG]) ON [PRIMARY]
GO
CREATE INDEX [U_ORD_03] ON [dbo].[U_ORD_DD]([DAGGANCIO], [ORD_FLGPRG], [ORD_FLGAVA], [ORD_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_ORD_DD]([ORS_CODCLI], [ORD_CODART], [ORD_CODMAT], [ORD_CODCOL], [ORD_SPESSO], [ORD_ALTEZZ], [ORD_LUNGHE], [ORS_DATORD], [ORD_DATCON], [ORD_QTAEV]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_ORD_DD]([DAGGANCIO], [ORD_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_ORD_DD]([ORS_CODCLI], [ORD_NUMPRG], [ORD_DATPRG], [ORS_DATORD], [ORD_DATCON]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_ORD_DD]([ORS_CODCLI], [ORS_NUMORD], [ORS_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_ORD_DD]([ORS_CODCLI], [ORD_SALCON]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_ORD_DD]([ORD_SETTPR]) ON [PRIMARY]
GO

  
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ORD_SD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKD')
   drop index U_ORD_SD.OFFHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_DA')
   drop index U_ORD_SD.U_OFF_DA
GO
 
CREATE INDEX [OFFHOOKD] ON [dbo].[U_ORD_SD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_DA] ON [dbo].[U_ORD_SD]([ORD_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ORD_ST.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKT')
   drop index U_ORD_ST.OFFHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'OFFNDOCT')
   drop index U_ORD_ST.OFFNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TN')
   drop index U_ORD_ST.U_OFF_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TD')
   drop index U_ORD_ST.U_OFF_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TC')
   drop index U_ORD_ST.U_OFF_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TA')
   drop index U_ORD_ST.U_OFF_TA
GO
 
CREATE INDEX [OFFHOOKT] ON [dbo].[U_ORD_ST]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [OFFNDOCT] ON [dbo].[U_ORD_ST]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TN] ON [dbo].[U_ORD_ST]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TD] ON [dbo].[U_ORD_ST]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TC] ON [dbo].[U_ORD_ST]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TA] ON [dbo].[U_ORD_ST]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ORD_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_ORD_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_ORD_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_ORD_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_ORD_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_ORD_TT.INDICE_06
GO


 
CREATE INDEX [ORDHOOKT] ON [dbo].[U_ORD_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [ORDNDOCT] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_TN] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_TD] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_TC] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_TA] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_DA] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORD_RG] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
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

CREATE INDEX [INDICE_01] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_NUMORD], [ORD_CAUS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_ORD_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_ORD_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_ORD_TT]([ORD_AGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_LOCC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_ORD_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_LOCC]) ON [PRIMARY]
GO 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ORE_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_ORE_CD')
   drop index U_ORE_AN.U_ORE_CD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORE_DT')
   drop index U_ORE_AN.U_ORE_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORE_CO')
   drop index U_ORE_AN.U_ORE_CO
GO
 
CREATE INDEX [U_ORE_CD] ON [dbo].[U_ORE_AN]([ORE_CODSOC], [ORE_CODDIP]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORE_DT] ON [dbo].[U_ORE_AN]([ORE_CODSOC], [ORE_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORE_CO] ON [dbo].[U_ORE_AN]([ORE_CODSOC], [ORE_COMM]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
if exists (select name from dbo.sysindexes where name = 'U_ORF_03')
   drop index U_ORF_DD.U_ORF_03
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_04')
   drop index U_ORF_DD.U_ORF_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ORF_DD.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_ORF_DD.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_ORF_DD.INDICE_03
GO

CREATE INDEX [ORFHOOKD] ON [dbo].[U_ORF_DD]([DAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_DA] ON [dbo].[U_ORF_DD]([ORD_CODART], [ORD_SALCON]) ON [PRIMARY]
GO
CREATE INDEX [RIGART] ON [dbo].[U_ORF_DD]([DAGGANCIO], [ORD_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_AM] ON [dbo].[U_ORF_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_01] ON [dbo].[U_ORF_DD]([DAGGANCIO], [ORD_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_02] ON [dbo].[U_ORF_DD]([DAGGANCIO], [ORD_CODART], [ORD_MAGA], [ORD_DATCON]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_03] ON [dbo].[U_ORF_DD]([ORD_LEGSYS]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_04] ON [dbo].[U_ORF_DD]([ORD_CODSYS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_ORF_DD]([ORS_DATORD], [ORD_DATCON], [ORS_CODCLI], [ORD_CODART], [ORD_CODMAT], [ORD_CODCOL], [ORD_SPESSO], [ORD_ALTEZZ], [ORD_LUNGHE], [ORD_QTAEV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_ORF_DD]([ORD_MAGA], [ORD_LEGSYS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_ORF_DD]([ORS_DATORD], [ORS_NUMORD]) ON [PRIMARY]
GO

-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ORF_ED.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_ORF_ED')
   drop index U_ORF_ED.U_ORF_ED
GO
 
if exists (select name from dbo.sysindexes where name = 'DESARTI')
   drop index U_ORF_ED.DESARTI
GO
 
if exists (select name from dbo.sysindexes where name = 'DESFORN')
   drop index U_ORF_ED.DESFORN
GO
 
if exists (select name from dbo.sysindexes where name = 'CODFORN')
   drop index U_ORF_ED.CODFORN
GO
 
CREATE INDEX [U_ORF_ED] ON [dbo].[U_ORF_ED]([ORD_CODMAG], [ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [DESARTI] ON [dbo].[U_ORF_ED]([ORD_CODMAG], [ORD_DESART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ORF_SD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ORFHOOKD')
   drop index U_ORF_SD.ORFHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_DA')
   drop index U_ORF_SD.U_ORF_DA
GO
 
CREATE INDEX [ORFHOOKD] ON [dbo].[U_ORF_SD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_DA] ON [dbo].[U_ORF_SD]([ORD_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_ORF_ST.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'ORFHOOKT')
   drop index U_ORF_ST.ORFHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'ORFNDOCT')
   drop index U_ORF_ST.ORFNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_TN')
   drop index U_ORF_ST.U_ORF_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_TD')
   drop index U_ORF_ST.U_ORF_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_TC')
   drop index U_ORF_ST.U_ORF_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_TA')
   drop index U_ORF_ST.U_ORF_TA
GO
 
CREATE INDEX [ORFHOOKT] ON [dbo].[U_ORF_ST]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [ORFNDOCT] ON [dbo].[U_ORF_ST]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_TN] ON [dbo].[U_ORF_ST]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_TD] ON [dbo].[U_ORF_ST]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_TC] ON [dbo].[U_ORF_ST]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_TA] ON [dbo].[U_ORF_ST]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ORF_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_ORF_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_ORF_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_ORF_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_ORF_TT.INDICE_05
GO


CREATE INDEX [ORFHOOKT] ON [dbo].[U_ORF_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [ORFNDOCT] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_TN] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_TD] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_TC] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_TA] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_RG] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_DA] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [T_INDICE] ON [dbo].[U_ORF_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_OR] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_01] ON [dbo].[U_ORF_TT]([ORD_FLGTIP], [ORD_CHIUSO], [ORD_CODBUN], [ORD_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_02] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_FLGTIP], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_03] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_FLGTIP], [ORD_CODBUN], [ORD_ANNO], [ORD_NUMORD], [ORD_CODCLI], [ORD_FLGCON]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_04] ON [dbo].[U_ORF_TT]([ORD_FLGTIP], [ORD_CHIUSO], [ORD_FLGCON], [ORD_CODBUN], [ORD_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_ORF_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_ORF_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_ORF_TT]([ORD_AGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_ORF_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_NUMORD]) ON [PRIMARY]
GO








-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PAG_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PAG_AN')
   drop index U_PAG_AN.U_PAG_AN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PAG_RS')
   drop index U_PAG_AN.U_PAG_RS
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PAG_DT')
   drop index U_PAG_AN.U_PAG_DT
GO
 
CREATE INDEX [U_PAG_AN] ON [dbo].[U_PAG_AN]([PAG_CODSOC], [PAG_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PAG_RS] ON [dbo].[U_PAG_AN]([PAG_CODSOC], [PAG_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PAG_DT] ON [dbo].[U_PAG_AN]([PAG_CODSOC], [PAG_CODCLI], [PAG_DATINC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PAL_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index U_PAL_AN.CODICE
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCR')
   drop index U_PAL_AN.DESCR
GO
 
CREATE INDEX [CODICE] ON [dbo].[U_PAL_AN]([PAL_CODSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCR] ON [dbo].[U_PAL_AN]([PAL_CODSOC], [PAL_DESCR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PAP_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PAP_CO')
   drop index U_PAP_AN.U_PAP_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PAP_RG')
   drop index U_PAP_AN.U_PAP_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PAP_NF')
   drop index U_PAP_AN.U_PAP_NF
GO
 
CREATE INDEX [U_PAP_CO] ON [dbo].[U_PAP_AN]([PAP_CODSOC], [PAP_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PAP_RG] ON [dbo].[U_PAP_AN]([PAP_CODSOC], [PAP_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PAP_NF] ON [dbo].[U_PAP_AN]([PAP_CODSOC], [PAP_NFAT]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PDV_AN.INDICE_01
GO
 
CREATE INDEX [U_PDV_AN] ON [dbo].[U_PDV_AN]([PDV_CODICE]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_DS] ON [dbo].[U_PDV_AN]([PDV_DESCRI]) ON [PRIMARY]
GO
CREATE INDEX [U_PDV_MA] ON [dbo].[U_PDV_AN]([PDV_CODMAG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PDV_AN]([PDV_CODCLI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_IN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PDV_IN')
   drop index U_PDV_IN.U_PDV_IN
GO
 
CREATE INDEX [U_PDV_IN] ON [dbo].[U_PDV_IN]([CGE_CODPDV], [CGE_CONTO], [CGE_CONTRO], [CGE_DATSCO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PDV_SA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PDV_SA')
   drop index U_PDV_SA.U_PDV_SA
GO
 
CREATE INDEX [U_PDV_SA] ON [dbo].[U_PDV_SA]([SAL_TIPO], [SAL_CODPDV], [SAL_PERIOD], [SAL_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PFO_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'GANCIO')
   drop index U_PFO_DD.GANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index U_PFO_DD.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMPAR')
   drop index U_PFO_DD.NUMPAR
GO
 
CREATE INDEX [GANCIO] ON [dbo].[U_PFO_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[U_PFO_DD]([RIC_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMPAR] ON [dbo].[U_PFO_DD]([RIC_NUMPAR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PFO_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TGANCIO')
   drop index U_PFO_TT.TGANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PFO_CO')
   drop index U_PFO_TT.U_PFO_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PFO_RG')
   drop index U_PFO_TT.U_PFO_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PFO_NF')
   drop index U_PFO_TT.U_PFO_NF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PFO_DF')
   drop index U_PFO_TT.U_PFO_DF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PFO_DS')
   drop index U_PFO_TT.U_PFO_DS
GO
 
CREATE INDEX [TGANCIO] ON [dbo].[U_PFO_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PFO_CO] ON [dbo].[U_PFO_TT]([RIC_CODSOC], [RIC_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PFO_RG] ON [dbo].[U_PFO_TT]([RIC_CODSOC], [RIC_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PFO_NF] ON [dbo].[U_PFO_TT]([RIC_CODSOC], [RIC_NFATT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PFO_DF] ON [dbo].[U_PFO_TT]([RIC_CODSOC], [RIC_DTFATT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PFO_DS] ON [dbo].[U_PFO_TT]([RIC_CODSOC], [RIC_DTSCAD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_POR_EF.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_POR_CO')
   drop index U_POR_EF.U_POR_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_POR_RG')
   drop index U_POR_EF.U_POR_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_POR_NF')
   drop index U_POR_EF.U_POR_NF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_POR_DF')
   drop index U_POR_EF.U_POR_DF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_POR_DS')
   drop index U_POR_EF.U_POR_DS
GO
 
CREATE INDEX [U_POR_CO] ON [dbo].[U_POR_EF]([RIC_CODSOC], [RIC_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_POR_RG] ON [dbo].[U_POR_EF]([RIC_CODSOC], [RIC_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_POR_NF] ON [dbo].[U_POR_EF]([RIC_CODSOC], [RIC_NFATT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_POR_DF] ON [dbo].[U_POR_EF]([RIC_CODSOC], [RIC_DTFATT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_POR_DS] ON [dbo].[U_POR_EF]([RIC_CODSOC], [RIC_DTSCAD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_POS_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_POS_01')
   drop index U_POS_AN.U_POS_01
GO
 
if exists (select name from dbo.sysindexes where name = 'U_POS_02')
   drop index U_POS_AN.U_POS_02
GO
 
if exists (select name from dbo.sysindexes where name = 'U_POS_03')
   drop index U_POS_AN.U_POS_03
GO
 
if exists (select name from dbo.sysindexes where name = 'U_POS_CA')
   drop index U_POS_AN.U_POS_CA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_POS_CO')
   drop index U_POS_AN.U_POS_CO
GO
 
CREATE INDEX [U_POS_01] ON [dbo].[U_POS_AN]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_POS_02] ON [dbo].[U_POS_AN]([LIS_CODSOC], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_POS_03] ON [dbo].[U_POS_AN]([LIS_CODSOC], [LIS_DATLIS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_POS_CA] ON [dbo].[U_POS_AN]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_POS_CO] ON [dbo].[U_POS_AN]([LIS_CODSOC], [LIS_CODCLI]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRE_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRE_AN')
   drop index U_PRE_AN.U_PRE_AN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRE_RS')
   drop index U_PRE_AN.U_PRE_RS
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRE_DT')
   drop index U_PRE_AN.U_PRE_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRE_CL')
   drop index U_PRE_AN.U_PRE_CL
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRE_CR')
   drop index U_PRE_AN.U_PRE_CR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRE_NC')
   drop index U_PRE_AN.U_PRE_NC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRE_MP')
   drop index U_PRE_AN.U_PRE_MP
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRE_DP')
   drop index U_PRE_AN.U_PRE_DP
GO
 
CREATE INDEX [U_PRE_AN] ON [dbo].[U_PRE_AN]([PRE_CODSOC], [PRE_CODICE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRE_RS] ON [dbo].[U_PRE_AN]([PRE_CODSOC], [PRE_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRE_DT] ON [dbo].[U_PRE_AN]([PRE_CODICE], [PRE_NUMCOM], [PRE_DATCOM], [PRE_DATPRE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRE_CL] ON [dbo].[U_PRE_AN]([PRE_CODSOC], [PRE_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRE_CR] ON [dbo].[U_PRE_AN]([PRE_CODSOC], [PRE_DESCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRE_NC] ON [dbo].[U_PRE_AN]([PRE_CODSOC], [PRE_NUMCOM]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRE_MP] ON [dbo].[U_PRE_AN]([PRE_CODSOC], [PRE_DATPRE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRE_DP] ON [dbo].[U_PRE_AN]([PRE_CODSOC], [PRE_DATPRE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRF_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FATHOOKD')
   drop index U_PRF_DD.FATHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAT_DA')
   drop index U_PRF_DD.U_FAT_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'FPS_VETTOD')
   drop index U_PRF_DD.FPS_VETTOD
GO
 
CREATE INDEX [FATHOOKD] ON [dbo].[U_PRF_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_DA] ON [dbo].[U_PRF_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRF_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'FATHOOKT')
   drop index U_PRF_TT.FATHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'FATNDOCT')
   drop index U_PRF_TT.FATNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAT_TN')
   drop index U_PRF_TT.U_FAT_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAT_TD')
   drop index U_PRF_TT.U_FAT_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAT_DA')
   drop index U_PRF_TT.U_FAT_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAT_TC')
   drop index U_PRF_TT.U_FAT_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAT_AG')
   drop index U_PRF_TT.U_FAT_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAT_TA')
   drop index U_PRF_TT.U_FAT_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAT_RG')
   drop index U_PRF_TT.U_FAT_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NUMERIC')
   drop index U_PRF_TT.T_NUMERIC
GO
 
if exists (select name from dbo.sysindexes where name = 'T_NPROT')
   drop index U_PRF_TT.T_NPROT
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_PRF_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_FAT_SY')
   drop index U_PRF_TT.U_FAT_SY
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRF_OR')
   drop index U_PRF_TT.U_PRF_OR
GO
 
CREATE INDEX [FATHOOKT] ON [dbo].[U_PRF_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [FATNDOCT] ON [dbo].[U_PRF_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_TN] ON [dbo].[U_PRF_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_TD] ON [dbo].[U_PRF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_DA] ON [dbo].[U_PRF_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_TC] ON [dbo].[U_PRF_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_AG] ON [dbo].[U_PRF_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_TA] ON [dbo].[U_PRF_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_RG] ON [dbo].[U_PRF_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NUMERIC] ON [dbo].[U_PRF_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_NPROT] ON [dbo].[U_PRF_TT]([ORD_NPROT]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_PRF_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_FAT_SY] ON [dbo].[U_PRF_TT]([ORD_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRF_OR] ON [dbo].[U_PRF_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRO_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRO_AN')
   drop index U_PRO_AN.U_PRO_AN
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRO_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRO_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRO_AN.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PRO_AN.INDICE_04
GO

CREATE INDEX [U_PRO_AN] ON [dbo].[U_PRO_AN]([PRO_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRO_AN]([PRO_CODAGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PRO_AN]([PRO_CODSOC], [PRO_CODAGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PRO_AN]([PRO_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PRO_AN]([PRO_CODSOC], [PRO_RAGSOC]) ON [PRIMARY]
GO

-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRO_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'PROHOOKD')
   drop index U_PRO_DD.PROHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_DA')
   drop index U_PRO_DD.U_PRO_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_AM')
   drop index U_PRO_DD.U_PRO_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_DT')
   drop index U_PRO_DD.U_PRO_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_DO')
   drop index U_PRO_DD.U_PRO_DO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_SY')
   drop index U_PRO_DD.U_PRO_SY
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_YS')
   drop index U_PRO_DD.U_PRO_YS
GO
 
CREATE INDEX [PROHOOKD] ON [dbo].[U_PRO_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_DA] ON [dbo].[U_PRO_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_AM] ON [dbo].[U_PRO_DD]([ORD_CODART], [ORD_MAGA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_DT] ON [dbo].[U_PRO_DD]([ORS_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_DO] ON [dbo].[U_PRO_DD]([ORD_DATORC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_SY] ON [dbo].[U_PRO_DD]([ORD_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_YS] ON [dbo].[U_PRO_DD]([ORS_CODSYS]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRO_PZ.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRO_PZ')
   drop index U_PRO_PZ.U_PRO_PZ
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_SY')
   drop index U_PRO_PZ.U_PRO_SY
GO
 
CREATE INDEX [U_PRO_PZ] ON [dbo].[U_PRO_PZ]([LIB_DATMOD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_SY] ON [dbo].[U_PRO_PZ]([LIB_CODSYS]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRO_ST.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRO_ST')
   drop index U_PRO_ST.U_PRO_ST
GO
 
CREATE INDEX [U_PRO_ST] ON [dbo].[U_PRO_ST]([STO_CODSYS]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRO_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'PROHOOKT')
   drop index U_PRO_TT.PROHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_TO')
   drop index U_PRO_TT.U_PRO_TO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_TN')
   drop index U_PRO_TT.U_PRO_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_TD')
   drop index U_PRO_TT.U_PRO_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_TA')
   drop index U_PRO_TT.U_PRO_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_TI')
   drop index U_PRO_TT.U_PRO_TI
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_TM')
   drop index U_PRO_TT.U_PRO_TM
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_TC')
   drop index U_PRO_TT.U_PRO_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_PRO_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_TL')
   drop index U_PRO_TT.U_PRO_TL
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_RG')
   drop index U_PRO_TT.U_PRO_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRO_OR')
   drop index U_PRO_TT.U_PRO_OR
GO
 
CREATE INDEX [PROHOOKT] ON [dbo].[U_PRO_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_TO] ON [dbo].[U_PRO_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_TN] ON [dbo].[U_PRO_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_TD] ON [dbo].[U_PRO_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_TA] ON [dbo].[U_PRO_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_TI] ON [dbo].[U_PRO_TT]([ORD_CODSOC], [ORD_IDENTI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_TM] ON [dbo].[U_PRO_TT]([ORD_CODSOC], [ORD_MACCHI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_TC] ON [dbo].[U_PRO_TT]([ORD_CODSOC], [ORD_CODMAT]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_PRO_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_TL] ON [dbo].[U_PRO_TT]([ORD_CODSOC], [ORS_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_RG] ON [dbo].[U_PRO_TT]([ORD_CODSOC], [ORS_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRO_OR] ON [dbo].[U_PRO_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRV_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRV_NF')
   drop index U_PRV_AN.U_PRV_NF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRV_AG')
   drop index U_PRV_AN.U_PRV_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRV_DA')
   drop index U_PRV_AN.U_PRV_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRV_CL')
   drop index U_PRV_AN.U_PRV_CL
GO
 
CREATE INDEX [U_PRV_NF] ON [dbo].[U_PRV_AN]([PRV_CODSOC], [PRV_ANNO], [PRV_NUMFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRV_AG] ON [dbo].[U_PRV_AN]([PRV_CODSOC], [PRV_CODAGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRV_DA] ON [dbo].[U_PRV_AN]([PRV_CODSOC], [PRV_DESAGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRV_CL] ON [dbo].[U_PRV_AN]([PRV_CODSOC], [PRV_RAGSOC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRV_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRV_NF')
   drop index U_PRV_DD.U_PRV_NF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRV_AG')
   drop index U_PRV_DD.U_PRV_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRV_DA')
   drop index U_PRV_DD.U_PRV_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRV_CL')
   drop index U_PRV_DD.U_PRV_CL
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRV_AR')
   drop index U_PRV_DD.U_PRV_AR
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRV_DD.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRV_DD.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRV_DD.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PRV_DD.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PRV_DD.INDICE_05
GO



 
CREATE INDEX [U_PRV_NF] ON [dbo].[U_PRV_DD]([PRV_CODSOC], [PRV_ANNO], [PRV_NUMFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRV_AG] ON [dbo].[U_PRV_DD]([PRV_CODSOC], [PRV_CODAGE], [PRV_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRV_DA] ON [dbo].[U_PRV_DD]([PRV_CODSOC], [PRV_DESAGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRV_CL] ON [dbo].[U_PRV_DD]([PRV_CODSOC], [PRV_RAGSOC], [PRV_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRV_AR] ON [dbo].[U_PRV_DD]([PRV_CODSOC], [PRV_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRV_DD]([PRV_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PRV_DD]([PRV_NUMFAT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PRV_DD]([PRV_CODSOC], [PRV_NUMFAT], [PRV_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PRV_DD]([PRV_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_PRV_DD]([PRV_CODAGE]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_PRV_OR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRV_NF')
   drop index U_PRV_OR.U_PRV_NF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRV_AG')
   drop index U_PRV_OR.U_PRV_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRV_DA')
   drop index U_PRV_OR.U_PRV_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_PRV_CL')
   drop index U_PRV_OR.U_PRV_CL
GO
 
CREATE INDEX [U_PRV_NF] ON [dbo].[U_PRV_OR]([PRV_CODSOC], [PRV_ANNO], [PRV_NUMFAT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRV_AG] ON [dbo].[U_PRV_OR]([PRV_CODSOC], [PRV_CODAGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRV_DA] ON [dbo].[U_PRV_OR]([PRV_CODSOC], [PRV_DESAGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_PRV_CL] ON [dbo].[U_PRV_OR]([PRV_CODSOC], [PRV_RAGSOC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RAA_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RAAHOOKD')
   drop index U_RAA_DD.RAAHOOKD
GO
 
CREATE INDEX [RAAHOOKD] ON [dbo].[U_RAA_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RAA_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RAAHOOKT')
   drop index U_RAA_TT.RAAHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'RAANDOCT')
   drop index U_RAA_TT.RAANDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RAA_TN')
   drop index U_RAA_TT.U_RAA_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RAA_TD')
   drop index U_RAA_TT.U_RAA_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RAA_TC')
   drop index U_RAA_TT.U_RAA_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RAA_RG')
   drop index U_RAA_TT.U_RAA_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RAA_DA')
   drop index U_RAA_TT.U_RAA_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_RAA_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'I_INDICE')
   drop index U_RAA_TT.I_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RAA_PA')
   drop index U_RAA_TT.U_RAA_PA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RAA_OR')
   drop index U_RAA_TT.U_RAA_OR
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_RAA_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_RAA_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_RAA_TT.INDICE_03
GO

CREATE INDEX [RAAHOOKT] ON [dbo].[U_RAA_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [RAANDOCT] ON [dbo].[U_RAA_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RAA_TN] ON [dbo].[U_RAA_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RAA_TD] ON [dbo].[U_RAA_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RAA_TC] ON [dbo].[U_RAA_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RAA_RG] ON [dbo].[U_RAA_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RAA_DA] ON [dbo].[U_RAA_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_RAA_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [I_INDICE] ON [dbo].[U_RAA_TT]([ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RAA_PA] ON [dbo].[U_RAA_TT]([ORD_CODSOC], [ORD_DATFPA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RAA_OR] ON [dbo].[U_RAA_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_RAA_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_RAA_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_RAA_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO


-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RET_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'DESCRIZION')
   drop index U_RET_AN.DESCRIZION
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index U_RET_AN.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'ANNI')
   drop index U_RET_AN.ANNI
GO
 
if exists (select name from dbo.sysindexes where name = 'DESCON')
   drop index U_RET_AN.DESCON
GO
 
CREATE INDEX [DESCRIZION] ON [dbo].[U_RET_AN]([CON_SOC], [CON_ANNO], [CON_DESCR]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[U_RET_AN]([CON_SOC], [CON_ANNO], [CON_MESE], [CON_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [ANNI] ON [dbo].[U_RET_AN]([CON_SOC], [CON_ANNO], [CON_MESE]) ON [PRIMARY]
GO
 
CREATE INDEX [DESCON] ON [dbo].[U_RET_AN]([CON_SOC], [CON_DESCR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RET_CE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RIGA')
   drop index U_RET_CE.RIGA
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_RET_CE.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_RET_CE.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_RET_CE.INDICE_03
GO

 
CREATE INDEX [RIGA] ON [dbo].[U_RET_CE]([RET_CODSOC], [RET_RIGA], [RET_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_RET_CE]([RET_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_RET_CE]([RET_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_RET_CE]([RET_RIGA]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RIA_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RIAHOOKD')
   drop index U_RIA_DD.RIAHOOKD
GO
 
CREATE INDEX [RIAHOOKD] ON [dbo].[U_RIA_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RIA_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RIAHOOKT')
   drop index U_RIA_TT.RIAHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'RIANDOCT')
   drop index U_RIA_TT.RIANDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIA_TN')
   drop index U_RIA_TT.U_RIA_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIA_TD')
   drop index U_RIA_TT.U_RIA_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIA_TC')
   drop index U_RIA_TT.U_RIA_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIA_RG')
   drop index U_RIA_TT.U_RIA_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIA_DA')
   drop index U_RIA_TT.U_RIA_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'T_INDICE')
   drop index U_RIA_TT.T_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'I_INDICE')
   drop index U_RIA_TT.I_INDICE
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIA_PA')
   drop index U_RIA_TT.U_RIA_PA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIA_OR')
   drop index U_RIA_TT.U_RIA_OR
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_RIA_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_RIA_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_RIA_TT.INDICE_03
GO
 
CREATE INDEX [RIAHOOKT] ON [dbo].[U_RIA_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [RIANDOCT] ON [dbo].[U_RIA_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIA_TN] ON [dbo].[U_RIA_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIA_TD] ON [dbo].[U_RIA_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIA_TC] ON [dbo].[U_RIA_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIA_RG] ON [dbo].[U_RIA_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIA_DA] ON [dbo].[U_RIA_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [T_INDICE] ON [dbo].[U_RIA_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [I_INDICE] ON [dbo].[U_RIA_TT]([ORD_DATORD], [ORD_NUMORD], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIA_PA] ON [dbo].[U_RIA_TT]([ORD_CODSOC], [ORD_DATFPA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIA_OR] ON [dbo].[U_RIA_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_RIA_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_RIA_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_RIA_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RIC_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_RIC_AG')
   drop index U_RIC_AN.U_RIC_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIC_RA')
   drop index U_RIC_AN.U_RIC_RA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIC_DR')
   drop index U_RIC_AN.U_RIC_DR
GO
 
CREATE INDEX [U_RIC_AG] ON [dbo].[U_RIC_AN]([RIC_CODSOC], [RIC_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIC_RA] ON [dbo].[U_RIC_AN]([RIC_CODSOC], [RIC_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIC_DR] ON [dbo].[U_RIC_AN]([RIC_CODSOC], [RIC_DATA], [RIC_RAGSOC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RIC_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'GANCIO')
   drop index U_RIC_DD.GANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index U_RIC_DD.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMPAR')
   drop index U_RIC_DD.NUMPAR
GO
 
CREATE INDEX [GANCIO] ON [dbo].[U_RIC_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[U_RIC_DD]([RIC_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMPAR] ON [dbo].[U_RIC_DD]([RIC_NUMPAR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RIC_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TGANCIO')
   drop index U_RIC_TT.TGANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIC_CO')
   drop index U_RIC_TT.U_RIC_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIC_RG')
   drop index U_RIC_TT.U_RIC_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIC_NF')
   drop index U_RIC_TT.U_RIC_NF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIC_DF')
   drop index U_RIC_TT.U_RIC_DF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIC_DS')
   drop index U_RIC_TT.U_RIC_DS
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_RIC_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_RIC_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_RIC_TT.INDICE_03
GO
 
CREATE INDEX [TGANCIO] ON [dbo].[U_RIC_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIC_CO] ON [dbo].[U_RIC_TT]([RIC_CODSOC], [RIC_CODCLI], [RIC_DTFATT], [RIC_DTSCAD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIC_RG] ON [dbo].[U_RIC_TT]([RIC_CODSOC], [RIC_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIC_NF] ON [dbo].[U_RIC_TT]([RIC_CODSOC], [RIC_NFATT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIC_DF] ON [dbo].[U_RIC_TT]([RIC_CODSOC], [RIC_DTFATT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIC_DS] ON [dbo].[U_RIC_TT]([RIC_CODSOC], [RIC_DTSCAD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_RIC_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_RIC_TT]([RIC_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_RIC_TT]([RIC_RAGSOC]) ON [PRIMARY]
GO

-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RID_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_RID_PA')
   drop index U_RID_AN.U_RID_PA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RID_IN')
   drop index U_RID_AN.U_RID_IN
GO
 
CREATE INDEX [U_RID_PA] ON [dbo].[U_RID_AN]([RID_CODSOC], [RID_BANCA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RID_IN] ON [dbo].[U_RID_AN]([RID_CODSOC]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RIM_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'GANCIO')
   drop index U_RIM_DD.GANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index U_RIM_DD.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMPAR')
   drop index U_RIM_DD.NUMPAR
GO
 
CREATE INDEX [GANCIO] ON [dbo].[U_RIM_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[U_RIM_DD]([RIC_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMPAR] ON [dbo].[U_RIM_DD]([RIC_NUMPAR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RIM_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TGANCIO')
   drop index U_RIM_TT.TGANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIM_CO')
   drop index U_RIM_TT.U_RIM_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIM_RG')
   drop index U_RIM_TT.U_RIM_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIM_NF')
   drop index U_RIM_TT.U_RIM_NF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIM_DF')
   drop index U_RIM_TT.U_RIM_DF
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIM_DS')
   drop index U_RIM_TT.U_RIM_DS
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_RIM_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_RIM_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_RIM_TT.INDICE_03
GO
--if exists (select name from dbo.sysindexes where name = 'INDICE_04')
--   drop index U_RIM_TT.INDICE_04
--GO

 
CREATE INDEX [TGANCIO] ON [dbo].[U_RIM_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIM_CO] ON [dbo].[U_RIM_TT]([RIC_CODSOC], [RIC_CODCLI], [RIC_DTFATT], [RIC_DTSCAD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIM_RG] ON [dbo].[U_RIM_TT]([RIC_CODSOC], [RIC_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIM_NF] ON [dbo].[U_RIM_TT]([RIC_CODSOC], [RIC_NFATT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIM_DF] ON [dbo].[U_RIM_TT]([RIC_CODSOC], [RIC_DTFATT]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIM_DS] ON [dbo].[U_RIM_TT]([RIC_CODSOC], [RIC_DTSCAD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_RIM_TT]([ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_RIM_TT]([RIC_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_RIM_TT]([RIC_RAGSOC]) ON [PRIMARY]
GO

--CREATE INDEX [INDICE_04] ON [dbo].[U_RIM_TT]([ORD_ANNO]) ON [PRIMARY]
--GO 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RIN_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'EVASO')
   drop index U_RIN_AN.EVASO
GO
 
if exists (select name from dbo.sysindexes where name = 'CLIENTE')
   drop index U_RIN_AN.CLIENTE
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMRIN')
   drop index U_RIN_AN.NUMRIN
GO
 
if exists (select name from dbo.sysindexes where name = 'DATRIN')
   drop index U_RIN_AN.DATRIN
GO
 
CREATE INDEX [EVASO] ON [dbo].[U_RIN_AN]([RIN_EVAS]) ON [PRIMARY]
GO
 
CREATE INDEX [CLIENTE] ON [dbo].[U_RIN_AN]([RIN_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMRIN] ON [dbo].[U_RIN_AN]([RIN_NUMRIN]) ON [PRIMARY]
GO
 
CREATE INDEX [DATRIN] ON [dbo].[U_RIN_AN]([RIN_DATRIN]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RIN_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RINHOOKD')
   drop index U_RIN_DD.RINHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIN_DA')
   drop index U_RIN_DD.U_RIN_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIN_NU')
   drop index U_RIN_DD.U_RIN_NU
GO
 
CREATE INDEX [RINHOOKD] ON [dbo].[U_RIN_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIN_DA] ON [dbo].[U_RIN_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIN_NU] ON [dbo].[U_RIN_DD]([RIN_NUMRIN], [ORD_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_RIN_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'RINHOOKT')
   drop index U_RIN_TT.RINHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'RINNDOCT')
   drop index U_RIN_TT.RINNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIN_TN')
   drop index U_RIN_TT.U_RIN_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIN_TD')
   drop index U_RIN_TT.U_RIN_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIN_TC')
   drop index U_RIN_TT.U_RIN_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIN_TA')
   drop index U_RIN_TT.U_RIN_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIN_DA')
   drop index U_RIN_TT.U_RIN_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIN_RG')
   drop index U_RIN_TT.U_RIN_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_RIN_OR')
   drop index U_RIN_TT.U_RIN_OR
GO
 
CREATE INDEX [RINHOOKT] ON [dbo].[U_RIN_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [RINNDOCT] ON [dbo].[U_RIN_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIN_TN] ON [dbo].[U_RIN_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIN_TD] ON [dbo].[U_RIN_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIN_TC] ON [dbo].[U_RIN_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIN_TA] ON [dbo].[U_RIN_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIN_DA] ON [dbo].[U_RIN_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIN_RG] ON [dbo].[U_RIN_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_RIN_OR] ON [dbo].[U_RIN_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_SCA_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_SCA_CO')
   drop index U_SCA_AN.U_SCA_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SCA_RG')
   drop index U_SCA_AN.U_SCA_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SCA_ID')
   drop index U_SCA_AN.U_SCA_ID
GO
 
CREATE INDEX [U_SCA_CO] ON [dbo].[U_SCA_AN]([SCA_CODSOC], [SCA_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SCA_RG] ON [dbo].[U_SCA_AN]([SCA_CODSOC], [SCA_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SCA_ID] ON [dbo].[U_SCA_AN]([SCA_CODSOC], [SCA_NUMID]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_SIC_PA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TAB_KEY')
   drop index U_SIC_PA.TAB_KEY
GO
 
CREATE INDEX [TAB_KEY] ON [dbo].[U_SIC_PA]([TAB_KEY]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_SIT_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_SIT_AN')
   drop index U_SIT_AN.U_SIT_AN
GO
 
CREATE INDEX [U_SIT_AN] ON [dbo].[U_SIT_AN]([SIT_CODSOC], [SIT_CODART], [SIT_DATCON]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
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
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_SPI_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_SPI_CO')
   drop index U_SPI_AN.U_SPI_CO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPI_RG')
   drop index U_SPI_AN.U_SPI_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPI_DT')
   drop index U_SPI_AN.U_SPI_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_SPI_CD')
   drop index U_SPI_AN.U_SPI_CD
GO
 
CREATE INDEX [U_SPI_CO] ON [dbo].[U_SPI_AN]([SPI_CODSOC], [SPI_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPI_RG] ON [dbo].[U_SPI_AN]([SPI_CODSOC], [SPI_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPI_DT] ON [dbo].[U_SPI_AN]([SPI_CODSOC], [SPI_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_SPI_CD] ON [dbo].[U_SPI_AN]([SPI_CODSOC], [SPI_CODCLI], [SPI_DATA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_STA_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_ORF_DD')
   drop index U_STA_DD.U_ORF_DD
GO
 
if exists (select name from dbo.sysindexes where name = 'ORFHOOKD')
   drop index U_STA_DD.ORFHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_DA')
   drop index U_STA_DD.U_ORF_DA
GO
 
CREATE INDEX [U_ORF_DD] ON [dbo].[U_STA_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [ORFHOOKD] ON [dbo].[U_STA_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_DA] ON [dbo].[U_STA_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_STA_SD.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_STA_ST.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_STA_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_ORF_TT')
   drop index U_STA_TT.U_ORF_TT
GO
 
if exists (select name from dbo.sysindexes where name = 'ORFHOOKT')
   drop index U_STA_TT.ORFHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'ORFNDOCT')
   drop index U_STA_TT.ORFNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_TN')
   drop index U_STA_TT.U_ORF_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_TD')
   drop index U_STA_TT.U_ORF_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_TC')
   drop index U_STA_TT.U_ORF_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_TA')
   drop index U_STA_TT.U_ORF_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_ORF_OR')
   drop index U_STA_TT.U_ORF_OR
GO
 
CREATE INDEX [U_ORF_TT] ON [dbo].[U_STA_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [ORFHOOKT] ON [dbo].[U_STA_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [ORFNDOCT] ON [dbo].[U_STA_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_TN] ON [dbo].[U_STA_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_TD] ON [dbo].[U_STA_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_TC] ON [dbo].[U_STA_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_TA] ON [dbo].[U_STA_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_ORF_OR] ON [dbo].[U_STA_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_STC_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_STC_AN')
   drop index U_STC_AN.U_STC_AN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_SO')
   drop index U_STC_AN.U_STC_SO
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_AG')
   drop index U_STC_AN.U_STC_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_CL')
   drop index U_STC_AN.U_STC_CL
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_AR')
   drop index U_STC_AN.U_STC_AR
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_AM')
   drop index U_STC_AN.U_STC_AM
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_DT')
   drop index U_STC_AN.U_STC_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_LI')
   drop index U_STC_AN.U_STC_LI
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_DC')
   drop index U_STC_AN.U_STC_DC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_CD')
   drop index U_STC_AN.U_STC_CD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_LD')
   drop index U_STC_AN.U_STC_LD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_STC_AD')
   drop index U_STC_AN.U_STC_AD
GO
 
CREATE INDEX [U_STC_AN] ON [dbo].[U_STC_AN]([STC_CODSOC], [STC_CODAGE], [STC_CODCLI], [STC_CODART], [STC_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_SO] ON [dbo].[U_STC_AN]([STC_CODSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_AG] ON [dbo].[U_STC_AN]([STC_CODAGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_CL] ON [dbo].[U_STC_AN]([STC_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_AR] ON [dbo].[U_STC_AN]([STC_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_AM] ON [dbo].[U_STC_AN]([STC_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_DT] ON [dbo].[U_STC_AN]([STC_DTDOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_LI] ON [dbo].[U_STC_AN]([STC_LINEA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_DC] ON [dbo].[U_STC_AN]([STC_CODSOC], [STC_DATA], [STC_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_CD] ON [dbo].[U_STC_AN]([STC_CODSOC], [STC_CODCLI], [STC_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_LD] ON [dbo].[U_STC_AN]([STC_CODSOC], [STC_LINEA], [STC_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_STC_AD] ON [dbo].[U_STC_AN]([STC_CODSOC], [STC_CODART], [STC_DATA]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_SYS_CO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'I_SY1COD')
   drop index U_SYS_CO.I_SY1COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_SY2COD')
   drop index U_SYS_CO.I_SY2COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_SY3COD')
   drop index U_SYS_CO.I_SY3COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_SY4COD')
   drop index U_SYS_CO.I_SY4COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_SY5COD')
   drop index U_SYS_CO.I_SY5COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_SY6COD')
   drop index U_SYS_CO.I_SY6COD
GO
 
if exists (select name from dbo.sysindexes where name = 'I_SY7COD')
   drop index U_SYS_CO.I_SY7COD
GO
 
CREATE INDEX [I_SY1COD] ON [dbo].[U_SYS_CO]([SYS_CODSYS]) ON [PRIMARY]
GO
 
CREATE INDEX [I_SY2COD] ON [dbo].[U_SYS_CO]([SYS_INIASY]) ON [PRIMARY]
GO
 
CREATE INDEX [I_SY3COD] ON [dbo].[U_SYS_CO]([SYS_FINASY]) ON [PRIMARY]
GO
 
CREATE INDEX [I_SY4COD] ON [dbo].[U_SYS_CO]([SYS_INIISY]) ON [PRIMARY]
GO
 
CREATE INDEX [I_SY5COD] ON [dbo].[U_SYS_CO]([SYS_FINISY]) ON [PRIMARY]
GO
 
CREATE INDEX [I_SY6COD] ON [dbo].[U_SYS_CO]([SYS_CHIASY]) ON [PRIMARY]
GO
 
CREATE INDEX [I_SY7COD] ON [dbo].[U_SYS_CO]([SYS_CODSYS], [SYS_PROGRE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_TOP_TT.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_TVE_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TVEHOOKD')
   drop index U_TVE_DD.TVEHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_TVE_DA')
   drop index U_TVE_DD.U_TVE_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_TVE_DD')
   drop index U_TVE_DD.U_TVE_DD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_TVE_PR')
   drop index U_TVE_DD.U_TVE_PR
GO
 
CREATE INDEX [TVEHOOKD] ON [dbo].[U_TVE_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_TVE_DA] ON [dbo].[U_TVE_DD]([ORD_CODART]) ON [PRIMARY]
GO
 
CREATE INDEX [U_TVE_DD] ON [dbo].[U_TVE_DD]([ORD_CODART], [DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_TVE_PR] ON [dbo].[U_TVE_DD]([DAGGANCIO], [ORD_RECNM]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_TVE_SD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKD')
   drop index U_TVE_SD.OFFHOOKD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_DA')
   drop index U_TVE_SD.U_OFF_DA
GO
 
CREATE INDEX [OFFHOOKD] ON [dbo].[U_TVE_SD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_DA] ON [dbo].[U_TVE_SD]([ORD_CODART]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_TVE_ST.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'OFFHOOKT')
   drop index U_TVE_ST.OFFHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'OFFNDOCT')
   drop index U_TVE_ST.OFFNDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TN')
   drop index U_TVE_ST.U_OFF_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TD')
   drop index U_TVE_ST.U_OFF_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TC')
   drop index U_TVE_ST.U_OFF_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_OFF_TA')
   drop index U_TVE_ST.U_OFF_TA
GO
 
CREATE INDEX [OFFHOOKT] ON [dbo].[U_TVE_ST]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [OFFNDOCT] ON [dbo].[U_TVE_ST]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TN] ON [dbo].[U_TVE_ST]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TD] ON [dbo].[U_TVE_ST]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TC] ON [dbo].[U_TVE_ST]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_OFF_TA] ON [dbo].[U_TVE_ST]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_TVE_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TVEHOOKT')
   drop index U_TVE_TT.TVEHOOKT
GO
 
if exists (select name from dbo.sysindexes where name = 'TVENDOCT')
   drop index U_TVE_TT.TVENDOCT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_TVE_TN')
   drop index U_TVE_TT.U_TVE_TN
GO
 
if exists (select name from dbo.sysindexes where name = 'U_TVE_TD')
   drop index U_TVE_TT.U_TVE_TD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_TVE_TC')
   drop index U_TVE_TT.U_TVE_TC
GO
 
if exists (select name from dbo.sysindexes where name = 'U_TVE_TA')
   drop index U_TVE_TT.U_TVE_TA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_TVE_RG')
   drop index U_TVE_TT.U_TVE_RG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_TVE_DA')
   drop index U_TVE_TT.U_TVE_DA
GO
 
if exists (select name from dbo.sysindexes where name = 'U_TVE_OR')
   drop index U_TVE_TT.U_TVE_OR
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_TVE_TT.INDICE_01
GO

 
CREATE INDEX [TVEHOOKT] ON [dbo].[U_TVE_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [TVENDOCT] ON [dbo].[U_TVE_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
 
CREATE INDEX [U_TVE_TN] ON [dbo].[U_TVE_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_TVE_TD] ON [dbo].[U_TVE_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_TVE_TC] ON [dbo].[U_TVE_TT]([ORD_CODSOC], [ORD_CODCLI]) ON [PRIMARY]
GO
 
CREATE INDEX [U_TVE_TA] ON [dbo].[U_TVE_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_TVE_RG] ON [dbo].[U_TVE_TT]([ORD_CODSOC], [ORD_RAGSOC]) ON [PRIMARY]
GO
 
CREATE INDEX [U_TVE_DA] ON [dbo].[U_TVE_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
 
CREATE INDEX [U_TVE_OR] ON [dbo].[U_TVE_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_TVE_TT]([ORD_RSCAR]) ON [PRIMARY]
GO


 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_VER_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'GANCIO')
   drop index U_VER_DD.GANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'CONTO')
   drop index U_VER_DD.CONTO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMPAR')
   drop index U_VER_DD.NUMPAR
GO
 
CREATE INDEX [GANCIO] ON [dbo].[U_VER_DD]([DAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [CONTO] ON [dbo].[U_VER_DD]([RIC_CONTO]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMPAR] ON [dbo].[U_VER_DD]([RIC_NUMPAR]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_VER_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'TGANCIO')
   drop index U_VER_TT.TGANCIO
GO
 
if exists (select name from dbo.sysindexes where name = 'NUMERO')
   drop index U_VER_TT.NUMERO
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_VER_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_VER_TT.INDICE_02
GO


 
CREATE INDEX [TGANCIO] ON [dbo].[U_VER_TT]([TAGGANCIO]) ON [PRIMARY]
GO
 
CREATE INDEX [NUMERO] ON [dbo].[U_VER_TT]([RIC_PROGR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_VER_TT]([RIC_CODSOC], [RIC_PROGR], [ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_VER_TT]([ORD_ANNO]) ON [PRIMARY]
GO


 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_VIS_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_VIS_DT')
   drop index U_VIS_AN.U_VIS_DT
GO
 
if exists (select name from dbo.sysindexes where name = 'U_VIS_AG')
   drop index U_VIS_AN.U_VIS_AG
GO
 
if exists (select name from dbo.sysindexes where name = 'U_VIS_DD')
   drop index U_VIS_AN.U_VIS_DD
GO
 
CREATE INDEX [U_VIS_DT] ON [dbo].[U_VIS_AN]([VIS_CODSOC], [VIS_DTRELA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_VIS_AG] ON [dbo].[U_VIS_AN]([VIS_CODSOC], [VIS_AGE]) ON [PRIMARY]
GO
 
CREATE INDEX [U_VIS_DD] ON [dbo].[U_VIS_AN]([VIS_CODSOC], [VIS_DTRELA], [VIS_DENOM]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_VVA_CH.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_VVA_CD')
   drop index U_VVA_CH.U_VVA_CD
GO
 
if exists (select name from dbo.sysindexes where name = 'U_VVA_DC')
   drop index U_VVA_CH.U_VVA_DC
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_VVA_CH.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_VVA_CH.INDICE_02
GO


 
CREATE INDEX [U_VVA_CD] ON [dbo].[U_VVA_CH]([VVA_CODSOC], [VVA_CODVAL], [VVA_DATA]) ON [PRIMARY]
GO
 
CREATE INDEX [U_VVA_DC] ON [dbo].[U_VVA_CH]([VVA_CODSOC], [VVA_DATA], [VVA_CODVAL]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_VVA_CH]([VVA_CODVAL]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_VVA_CH]([VVA_DATA]) ON [PRIMARY]
GO


 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_WRK_DD.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_WRK_SD.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_WRK_ST.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella U_WRK_TT.DBF
-- ********************************************************************************
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella ZONET_VE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'CODICE')
   drop index ZONET_VE.CODICE
GO
 
CREATE INDEX [CODICE] ON [dbo].[ZONET_VE]([Z_COMPA], [Z_CODICE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
 
 
-- ********************************************************************************
-- Indicizzazione tabella _SUPP_MENU.DBF
-- ********************************************************************************
-- ********************************************************************************

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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_FOR_PR.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_FOR_PR.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_FOR_PR.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_FOR_PR.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_FOR_PR.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_FOR_PR.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_FOR_PR.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_FOR_PR.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_FOR_PR.INDICE_09
GO





CREATE INDEX [U_FOR_PR] ON [dbo].[U_FOR_PR]([FPR_CODSOC], [FPR_CODMAG], [FPR_CODART], [FPR_CODFOR]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_P1] ON [dbo].[U_FOR_PR]([FPR_CODSOC], [FPR_CODMAG], [FPR_CODFOR]) ON [PRIMARY]
GO
CREATE INDEX [U_FOR_P2] ON [dbo].[U_FOR_PR]([FPR_CODSOC], [FPR_CODART], [FPR_CODFOR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_FOR_PR]([FPR_CODSOC], [FPR_CODMAG], [FPR_CODART], [FPR_CODFOR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_FOR_PR]([FPR_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_FOR_PR]([FPR_CODFOR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_FOR_PR]([FPR_RAGFOR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_FOR_PR]([FPR_CODMAG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_FOR_PR]([FPR_DATUCA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_FOR_PR]([FPR_PRZCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_FOR_PR]([FPR_SEQPRI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_FOR_PR]([FPR_DESART]) ON [PRIMARY]
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PDV_AU.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PDV_AU.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PDV_AU.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PDV_AU.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PDV_AU.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_PDV_AU.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_PDV_AU.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_PDV_AU.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_PDV_AU.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_PDV_AU.INDICE_10
GO

CREATE INDEX [U_PDV_AU] ON [dbo].[U_PDV_AU]([PDV_CODSOC], [PDV_DATAUT], [PDV_CODUTE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PDV_AU]([PDV_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PDV_AU]([PDV_DATAUT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PDV_AU]([PDV_CODUTE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PDV_AU]([PDV_CODSOC], [PDV_CODUTE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_PDV_AU]([PDV_DESUTE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_PDV_AU]([PDV_CODSOC], [PDV_DESUTE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_PDV_AU]([PDV_CODBUN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_PDV_AU]([PDV_CODSOC], [PDV_CODBUN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_PDV_AU]([PDV_DESBUN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_PDV_AU]([PDV_CODSOC], [PDV_DESBUN]) ON [PRIMARY]
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PNC_BU.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PNC_BU.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PNC_BU.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PNC_BU.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PNC_BU.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_PNC_BU.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_PNC_BU.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_PNC_BU.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_PNC_BU.INDICE_09
GO

CREATE INDEX [U_PNC_B1] ON [dbo].[U_PNC_BU]([PNC_CODSOC], [PNC_CODBUN], [PNC_CODUTE], [PNC_DESOPE], [PNC_DATREG], [PNC_ORAREG]) ON [PRIMARY]
GO

CREATE INDEX [U_PNC_B2] ON [dbo].[U_PNC_BU]([PNC_CODSOC], [PNC_DATOPE]) ON [PRIMARY]
GO

CREATE INDEX [U_PNC_B3] ON [dbo].[U_PNC_BU]([ID_UNIQUE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PNC_BU]([PNC_CODUTE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PNC_BU]([PNC_CODSOC], [PNC_CODUTE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PNC_BU]([PNC_DESUTE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PNC_BU]([PNC_CODSOC], [PNC_DESUTE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_PNC_BU]([PNC_DATOPE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_PNC_BU]([PNC_DESOPE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_PNC_BU]([PNC_CODSOC], [PNC_DESOPE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_PNC_BU]([PNC_DATREG]) ON [PRIMARY]
GO


CREATE INDEX [INDICE_09] ON [dbo].[U_PNC_BU]([PNC_CODSOC], [PNC_DATREG]) ON [PRIMARY]
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CLI_FI.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CLI_FI.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CLI_FI.INDICE_03
GO


CREATE INDEX [U_CLI_F1] ON [dbo].[U_CLI_FI]([FID_CODSOC], [FID_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_F2] ON [dbo].[U_CLI_FI]([FID_CODSOC], [FID_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [U_CLI_F3] ON [dbo].[U_CLI_FI]([FID_FLGTRA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CLI_FI]([FID_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CLI_FI]([FID_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_CLI_FI]([FID_CODCLI]) ON [PRIMARY]
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
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_FTP_AN.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_FTP_AN.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_FTP_AN.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_FTP_AN.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_FTP_AN.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_FTP_AN.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_FTP_AN.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_FTP_AN.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_FTP_AN.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_FTP_AN.INDICE_10
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_FTP_AN.INDICE_11
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_FTP_AN.INDICE_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_FTP_AN.INDICE_13
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
CREATE INDEX [INDICE_01] ON [dbo].[U_FTP_AN]([FTP_CODPDV]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_FTP_AN]([FTP_DESPDV]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_FTP_AN]([FTP_CODCAS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_FTP_AN]([FTP_DESCAS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_FTP_AN]([FTP_NUMSER]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_FTP_AN]([FTP_NUMDOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_FTP_AN]([FTP_DATDOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_FTP_AN]([FTP_CODSOC], [FTP_DATDOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_FTP_AN]([FTP_RAGFOR]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[U_FTP_AN]([FTP_TIPO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_11] ON [dbo].[U_FTP_AN]([FTP_HOST]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_12] ON [dbo].[U_FTP_AN]([FTP_USER]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_13] ON [dbo].[U_FTP_AN]([FTP_NOMEFI]) ON [PRIMARY]
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PER_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PER_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PER_AN.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PER_AN.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PER_AN.INDICE_05
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

CREATE INDEX [INDICE_01] ON [dbo].[U_PER_AN]([PER_CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PER_AN]([PER_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PER_AN]([PER_TIPCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PER_AN]([PER_DESCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_PER_AN]([PER_DATCON]) ON [PRIMARY]
GO




-- ************************************************************************************
-- ************************************************************************************
-- Indicizzazione tabella U_PER_PD  FILE DI LEGAME PERSONALE CON IL PDV
-- ************************************************************************************
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_PER_P1')
   drop index U_PER_PD.U_PER_P1
GO


if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PER_PD.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PER_PD.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PER_PD.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PER_PD.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PER_PD.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_PER_PD.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_PER_PD.INDICE_07
GO


CREATE INDEX [U_PER_P1] ON [dbo].[U_PER_PD]([PED_CODSOC], [PED_CODPDV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PER_PD]([PED_CODPDV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PER_PD]([PED_CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PER_PD]([PED_CODSOC], [PED_CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PER_PD]([PED_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_PER_PD]([PED_CODSOC], [PED_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_PER_PD]([PED_DESPDV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_PER_PD]([PED_CODSOC], [PED_DESPDV]) ON [PRIMARY]
GO








-- ************************************************************************************
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
CREATE INDEX [U_PRB_AM] ON [dbo].[U_PRB_DD]([ORD_CODART], [ORD_MAGA], [ORD_FORNIT]) ON [PRIMARY]
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRB_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRB_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRB_TT.INDICE_03
GO


CREATE INDEX [PRBHOOKT] ON [dbo].[U_PRB_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [PRBNDOCT] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [TNUMERO]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_TN] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_TD] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_TC] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_TA] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_AGE]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_DA] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [T_NUMERIC] ON [dbo].[U_PRB_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_RG] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [T_INDICE] ON [dbo].[U_PRB_TT]([ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_SY] ON [dbo].[U_PRB_TT]([ORD_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [FPS_INDICE] ON [dbo].[U_PRB_TT]([ORD_DATORD], [ORD_NUMORD], [ORD_CODEMI], [ORD_TIPORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_CC] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_CODCLI], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_OR] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_NUMORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_01] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_FLGCON], [ORD_FLBOL], [ORD_DATORD]) ON [PRIMARY]
GO
CREATE INDEX [U_PRB_02] ON [dbo].[U_PRB_TT]([ORD_CODSOC], [ORD_ANNO], [ORD_CODBUN], [ORD_FLGCON], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRB_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PRB_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PRB_TT]([ORD_CODCLI]) ON [PRIMARY]
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ORF_PO.INDICE_01
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

CREATE INDEX [INDICE_01] ON [dbo].[U_ORF_PO]([ORF_SYSSYS]) ON [PRIMARY]
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
CREATE INDEX [U_CON_P3] ON [dbo].[U_CON_PE]([CON_SIGLA], [CON_CODICE]) ON [PRIMARY]
GO
CREATE INDEX [U_CON_P4] ON [dbo].[U_CON_PE]([CON_TIPCON], [CON_CODICE]) ON [PRIMARY]
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
if exists (select name from dbo.sysindexes where name = 'U_CAL_L4')
   drop index U_CAL_LA.U_CAL_L4
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CAL_LA.INDICE_01
GO

CREATE INDEX [U_CAL_L1] ON [dbo].[U_CAL_LA]([CAL_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_L2] ON [dbo].[U_CAL_LA]([CAL_DATAMG]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_L3] ON [dbo].[U_CAL_LA]([CAL_DATA]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_L4] ON [dbo].[U_CAL_LA]([CAL_SETT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CAL_LA]([CAL_ANNO], [CAL_DATAMG]) ON [PRIMARY]
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CAL_AS.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CAL_AS.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CAL_AS.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_CAL_AS.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_CAL_AS.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_CAL_AS.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_CAL_AS.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_CAL_AS.INDICE_08
GO


CREATE INDEX [U_CAL_A1] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_CODPDV], [CAL_CODCOL], [CAL_DATA]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_A2] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_CODCOL], [CAL_CODPDV], [CAL_DATA]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_A3] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_DESCOL], [CAL_CODCOL], [CAL_DATA]) ON [PRIMARY]
GO
CREATE INDEX [U_CAL_A4] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_DATA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_CAL_AS]([CAL_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CAL_AS]([CAL_CODPDV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_CODPDV], [CAL_CODCOL], [CAL_DATA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_CAL_AS]([CAL_CODCOL]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_CAL_AS]([CAL_DESCOL]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_DESCOL], [CAL_CODPDV], [CAL_DATA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_CAL_AS]([CAL_DATA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_CAL_AS]([CAL_CODSOC], [CAL_DATA], [CAL_CODPDV], [CAL_CODCOL]) ON [PRIMARY]
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

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MSG_AU.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MSG_AU.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MSG_AU.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MSG_AU.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MSG_AU.INDICE_05
GO


if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_MSG_AU.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_MSG_AU.INDICE_07
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

CREATE INDEX [INDICE_01] ON [dbo].[U_MSG_AU]([MSG_DESMIT], [MSG_CODMIT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_MSG_AU]([MSG_CODOPE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_MSG_AU]([MSG_DESOPE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_MSG_AU]([MSG_CODDES]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_MSG_AU]([MSG_DESDES], [MSG_CODDES]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_MSG_AU]([MSG_DATINV], [MSG_DESDES]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_MSG_AU]([MSG_DATRIC], [MSG_DESDES]) ON [PRIMARY]
GO






-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_ORF_DL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_ORF_01')
   drop index U_ORF_DL.U_ORF_01
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_02')
   drop index U_ORF_DL.U_ORF_02
GO
if exists (select name from dbo.sysindexes where name = 'U_ORF_03')
   drop index U_ORF_DL.U_ORF_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ORF_DL.INDICE_01
GO


CREATE INDEX [U_ORF_01] ON [dbo].[U_ORF_DL]([DAGGANCIO], [DLEGAME], [ORD_QTAKGE], [ORD_QTAKG], [ORD_SALCON]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_02] ON [dbo].[U_ORF_DL]([ORD_QTAMQ], [ORD_QTAMQE]) ON [PRIMARY]
GO
CREATE INDEX [U_ORF_03] ON [dbo].[U_ORF_DL]([DLEGAME], [ORD_CODMAT], [ORD_CODCOL], [ORD_SPESSO], [ORD_ALTEZZ], [ORD_LUNGHE], [DAGGANCIO], [ORD_CODSYS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_ORF_DL]([ORD_SALCON]) ON [PRIMARY]
GO

-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_BFO_DL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_BFO_01')
   drop index U_BFO_DL.U_BFO_01
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_02')
   drop index U_BFO_DL.U_BFO_02
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_03')
   drop index U_BFO_DL.U_BFO_03
GO
if exists (select name from dbo.sysindexes where name = 'U_BFO_04')
   drop index U_BFO_DL.U_BFO_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_BFO_DL.INDICE_01
GO

CREATE INDEX [U_BFO_01] ON [dbo].[U_BFO_DL]([DAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_02] ON [dbo].[U_BFO_DL]([ORD_AGGORF], [ORD_SYSORF]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_03] ON [dbo].[U_BFO_DL]([DAGGANCIO], [DLEGAME], [ORD_AGGORF], [ORD_SYSORF], [ORD_CODORF]) ON [PRIMARY]
GO
CREATE INDEX [U_BFO_04] ON [dbo].[U_BFO_DL]([DAGGANCIO], [DLEGAME], [ORD_CODMAT], [ORD_CODCOL], [ORD_SPESSO], [ORD_ALTEZZ], [ORD_LUNGHE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_BFO_DL]([DAGGANCIO], [ORD_AGGORF], [ORD_SYSORF]) ON [PRIMARY]
GO

-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_PRO_IM.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRO_01')
   drop index U_PRO_IM.U_PRO_01
GO
if exists (select name from dbo.sysindexes where name = 'U_PRO_02')
   drop index U_PRO_IM.U_PRO_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRO_IM.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRO_IM.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRO_IM.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PRO_IM.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PRO_IM.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_PRO_IM.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_PRO_IM.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_PRO_IM.INDICE_08
GO


CREATE INDEX [U_PRO_01] ON [dbo].[U_PRO_IM]([ID_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [U_PRO_02] ON [dbo].[U_PRO_IM]([IMP_CODLAV], [IMP_CODMAC], [IMP_DATIMP], [INV_SETIMP], [IMP_NRPRG1], [IMP_NRPRG2]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRO_IM]([IMP_DATIMP]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PRO_IM]([IMP_CODMAC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PRO_IM]([INV_DATIMP]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PRO_IM]([INV_SETIMP]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_PRO_IM]([IMP_NRPRG1]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_PRO_IM]([INV_DTPRG1]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_PRO_IM]([IMP_NRPRG2]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_PRO_IM]([INV_DTPRG2]) ON [PRIMARY]
GO




-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_PRO_CA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRO_01')
   drop index U_PRO_CA.U_PRO_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRO_CA.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRO_CA.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRO_CA.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PRO_CA.INDICE_04
GO


CREATE INDEX [U_PRO_01] ON [dbo].[U_PRO_CA]([CAP_CODLAV], [CAP_CODMAC], [CAP_CODMAT], [CAP_CDDIBA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRO_CA]([CAP_CODLAV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PRO_CA]([CAP_CODMAC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PRO_CA]([CAP_CODMAT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PRO_CA]([CAP_CDDIBA]) ON [PRIMARY]
GO




-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PRO_MY.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRO_01')
   drop index U_PRO_MY.U_PRO_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRO_MY.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRO_MY.INDICE_02
GO



CREATE INDEX [U_PRO_01] ON [dbo].[U_PRO_MY]([MIC_SPESSO], [MIC_CODMAT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRO_MY]([MIC_CODMAT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PRO_MY]([MIC_DESMAT]) ON [PRIMARY]
GO



-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_PRG_SP.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRG_01')
   drop index U_PRG_SP.U_PRG_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRG_SP.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRG_SP.INDICE_02
GO

CREATE INDEX [U_PRG_01] ON [dbo].[U_PRG_SP]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_PRG_SP]([STA_SYSCLI], [STA_DATINI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_PRG_SP]([STA_FLGEND]) ON [PRIMARY]
GO


-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_PRG_RA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRG_01')
   drop index U_PRG_RA.U_PRG_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRG_RA.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRG_RA.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRG_RA.INDICE_03
GO


CREATE INDEX [U_PRG_01] ON [dbo].[U_PRG_RA]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [NUD_CODINT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRG_RA]([STA_CODSYS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PRG_RA]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [STA_FLGEND]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PRG_RA]([NUD_CODINT]) ON [PRIMARY]
GO
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_PRG_DL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRG_01')
   drop index U_PRG_DL.U_PRG_01
GO

CREATE INDEX [U_PRG_01] ON [dbo].[U_PRG_DL]([ORD_NUMPRG], [ORD_DATPRG]) ON [PRIMARY]
GO

-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PRG_DO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRG_01')
   drop index U_PRG_DO.U_PRG_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRG_DO.INDICE_01
GO

CREATE INDEX [U_PRG_01] ON [dbo].[U_PRG_DO]([MAG_NUMPRG], [MAG_AMGPRG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRG_DO]([MAG_NUMPRG], [MAG_CODMAT], [MAG_ANAART], [MAG_AMGPRG]) ON [PRIMARY]
GO


-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PRG_SM.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_PRG_01')
   drop index U_PRG_SM.U_PRG_01
GO

CREATE INDEX [U_PRG_01] ON [dbo].[U_PRG_SM]([SEL_NUMPRG], [SEL_AMGPRG]) ON [PRIMARY]
GO

-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_ORD_DL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_ORD_01')
   drop index U_ORD_DL.U_ORD_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ORD_DL.INDICE_01
GO

CREATE INDEX [U_ORD_01] ON [dbo].[U_ORD_DL]([ORD_NUMPRG], [ORD_DATPRG], [ORS_VALUTA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_ORD_DL]([DAGGANCIO], [ORD_CODSYS], [ORD_QTAKGE], [ORD_SALCON]) ON [PRIMARY]
GO





-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella NOTE_COM.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'NOTE_COM_1')
   drop index NOTE_COM.NOTE_COM_1
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index NOTE_COM.INDICE_01
GO
 
CREATE INDEX [NOTE_COM_1] ON [dbo].[NOTE_COM]([NOT_CODSOC], [NOT_CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_01] ON [dbo].[NOTE_COM]([NOT_CODICE]) ON [PRIMARY]
GO
 
-- ********************************************************************************
-- ********************************************************************************
-- Indicizzazione tabella U_AVA_RI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_AVA_RI1')
   drop index U_AVA_RI.U_AVA_RI1
GO
if exists (select name from dbo.sysindexes where name = 'U_AVA_RI2')
   drop index U_AVA_RI.U_AVA_RI2
GO
if exists (select name from dbo.sysindexes where name = 'U_AVA_RI3')
   drop index U_AVA_RI.U_AVA_RI3
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AVA_RI.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_AVA_RI.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_AVA_RI.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_AVA_RI.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_AVA_RI.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_AVA_RI.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_AVA_RI.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_AVA_RI.INDICE_08
GO

CREATE INDEX [U_AVA_RI1] ON [dbo].[U_AVA_RI]([STA_NUMPRG], [STA_DATPRG], [STA_PROGRE], [AVA_TIPAVA]) ON [PRIMARY]
GO
CREATE INDEX [U_AVA_RI2] ON [dbo].[U_AVA_RI]([AVA_DATAVA], [AVA_ORAAVA]) ON [PRIMARY]
GO
CREATE INDEX [U_AVA_RI3] ON [dbo].[U_AVA_RI]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_AVA_RI]([STA_NUMPRG], [STA_CODART], [NUD_NUMLOT], [STA_CODMAT], [STA_CODCOL], [STA_SPEMAG], [STA_SPEORD], [STA_ALTMAG], [NUD_LUNGHE], [NUD_CODFOR], [STA_CODMAC], [AVA_CODAVA], [STA_AMGPRG], [AVA_AMGAVA], [AVA_ORAAVA] ) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_AVA_RI]([STA_NUMPRG], [STA_CODART], [NUD_NUMLOT], [STA_CODMAT], [STA_CODCOL], [STA_SPEMAG], [STA_SPEORD], [STA_ALTMAG], [NUD_LUNGHE], [NUD_CODFOR], [STA_CODMAC], [AVA_CODAVA], [STA_AMGPRG], [AVA_DATAVA], [AVA_ORAAVA] ) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_AVA_RI]([STA_NUMPRG], [NUD_NUMLOT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_AVA_RI]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [AVA_TIPAVA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_AVA_RI]([STA_NUMPRG], [STA_CODART], [NUD_NUMLOT], [STA_CODMAT], [STA_CODCOL], [STA_SPEMAG], [STA_SPEORD], [STA_ALTMAG], [NUD_LUNGHE], [NUD_CODFOR], [STA_CODMAC], [AVA_CODAVA], [STA_AMGPRG], [AVA_AMGAVA], [AVA_ORAAVA] ) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_AVA_RI]([NUD_NUMLOT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_AVA_RI]([NUD_CODINT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_AVA_RI]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [AVA_AMGAVA]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- ********************************************************************************
-- Indicizzazione tabella U_AVA_SM.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_AVA_SM1')
   drop index U_AVA_SM.U_AVA_SM1
GO
if exists (select name from dbo.sysindexes where name = 'U_AVA_SM2')
   drop index U_AVA_SM.U_AVA_SM2
GO
if exists (select name from dbo.sysindexes where name = 'U_AVA_SM3')
   drop index U_AVA_SM.U_AVA_SM3
GO 
if exists (select name from dbo.sysindexes where name = 'U_AVA_SM4')
   drop index U_AVA_SM.U_AVA_SM4
GO 
CREATE INDEX [U_AVA_SM1] ON [dbo].[U_AVA_SM]([AVA_AMGAVA]) ON [PRIMARY]
GO
CREATE INDEX [U_AVA_SM2] ON [dbo].[U_AVA_SM]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [AVA_TIPO], [AVA_AMGAVA], [AVA_ORAAVA]) ON [PRIMARY]
GO
CREATE INDEX [U_AVA_SM3] ON [dbo].[U_AVA_SM]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [AVA_TIPO], [AVA_STATO], [ADE_CODICE]) ON [PRIMARY]
GO 
CREATE INDEX [U_AVA_SM4] ON [dbo].[U_AVA_SM]([ADE_CODINT]) ON [PRIMARY]
GO 
-- ********************************************************************************

-- ********************************************************************************
-- ********************************************************************************
-- Indicizzazione tabella U_AVA_SP.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_AVA_SP1')
   drop index U_AVA_SP.U_AVA_SP1
GO
if exists (select name from dbo.sysindexes where name = 'U_AVA_SP2')
   drop index U_AVA_SP.U_AVA_SP2
GO
if exists (select name from dbo.sysindexes where name = 'U_AVA_SP3')
   drop index U_AVA_SP.U_AVA_SP3
GO 
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AVA_SP.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_AVA_SP.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_AVA_SP.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_AVA_SP.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_AVA_SP.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_AVA_SP.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_AVA_SP.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_AVA_SP.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_AVA_SP.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_AVA_SP.INDICE_10
GO

CREATE INDEX [U_AVA_SP1] ON [dbo].[U_AVA_SP]([AVA_DATAVA], [AVA_ORAAVA]) ON [PRIMARY]
GO
CREATE INDEX [U_AVA_SP2] ON [dbo].[U_AVA_SP]([STA_NUMPRG], [STA_DATPRG], [STA_PROGRE], [AVA_TIPAVA]) ON [PRIMARY]
GO
CREATE INDEX [U_AVA_SP3] ON [dbo].[U_AVA_SP]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [NUD_CODINT], [NUD_NUMLOT]) ON [PRIMARY]
GO 
CREATE INDEX [INDICE_01] ON [dbo].[U_AVA_SP]([NUD_CODFOR], [STA_CODART], [STA_CODMAT], [STA_NUMPRG], [STA_AMGPRG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_AVA_SP]([STA_NUMPRG], [NUD_NUMLOT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_AVA_SP]([STA_NUMPRG], [STA_CODART], [NUD_NUMLOT], [STA_CODMAT], [STA_CODCOL], [STA_SPEMAG], [STA_SPEORD], [STA_ALTMAG], [NUD_LUNGHE], [NUD_CODFOR], [STA_CODMAC], [AVA_CODAVA], [STA_AMGPRG], [AVA_AMGAVA], [AVA_ORAAVA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_AVA_SP]([STA_NUMPRG], [STA_CODART], [NUD_NUMLOT], [STA_CODMAT], [STA_CODCOL], [STA_SPEMAG], [STA_SPEORD], [STA_ALTMAG], [NUD_LUNGHE], [NUD_CODFOR], [STA_CODMAC], [AVA_CODAVA], [STA_AMGPRG], [AVA_DATAVA], [AVA_ORAAVA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_AVA_SP]([STA_NUMPRG], [STA_DATPRG], [STA_CODART], [NUD_NUMLOT], [STA_CODMAT], [STA_CODCOL], [STA_SPEMAG], [STA_SPEORD], [STA_ALTMAG], [NUD_LUNGHE], [NUD_CODFOR], [STA_CODMAC], [AVA_CODAVA], [AVA_DATAVA], [AVA_ORAAVA], [AVA_LOTFIN]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_AVA_SP]([ID_UNIQUE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_AVA_SP]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [AVA_TIPAVA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_AVA_SP]([NUD_NUMLOT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_AVA_SP]([NUD_CODINT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[U_AVA_SP]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [AVA_AMGAVA]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_AVA_TG.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_AVA_TG1')
   drop index U_AVA_TG.U_AVA_TG1
GO
if exists (select name from dbo.sysindexes where name = 'U_AVA_TG2')
   drop index U_AVA_TG.U_AVA_TG2
GO
if exists (select name from dbo.sysindexes where name = 'U_AVA_TG3')
   drop index U_AVA_TG.U_AVA_TG3
GO 
if exists (select name from dbo.sysindexes where name = 'U_AVA_TG4')
   drop index U_AVA_TG.U_AVA_TG4
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AVA_TG.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_AVA_TG.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_AVA_TG.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_AVA_TG.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_AVA_TG.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_AVA_TG.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_AVA_TG.INDICE_07
GO

CREATE INDEX [U_AVA_TG1] ON [dbo].[U_AVA_TG]([AVA_DATAVA], [AVA_ORAAVA]) ON [PRIMARY]
GO
CREATE INDEX [U_AVA_TG2] ON [dbo].[U_AVA_TG]([STA_NUMPRG], [STA_DATPRG], [STA_PROGRE], [AVA_TIPAVA]) ON [PRIMARY]
GO
CREATE INDEX [U_AVA_TG3] ON [dbo].[U_AVA_TG]([STA_PROGRE], [STA_NUMPRG], [STA_AMGPRG]) ON [PRIMARY]
GO 
CREATE INDEX [U_AVA_TG4] ON [dbo].[U_AVA_TG]([NUD_CODINT], [AVA_CODAVA]) ON [PRIMARY]
GO 
CREATE INDEX [INDICE_01] ON [dbo].[U_AVA_TG]([STA_NUMPRG], [STA_CODART], [NUD_NUMLOT], [STA_CODMAT], [STA_CODCOL], [STA_SPEMAG], [STA_SPEORD], [STA_ALTMAG], [NUD_LUNGHE], [NUD_CODFOR], [STA_CODMAC], [AVA_CODAVA], [STA_AMGPRG], [AVA_AMGAVA], [AVA_ORAAVA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_AVA_TG]([STA_NUMPRG], [STA_CODART], [NUD_NUMLOT], [STA_CODMAT], [STA_CODCOL], [STA_SPEMAG], [STA_SPEORD], [STA_ALTMAG], [NUD_LUNGHE], [NUD_CODFOR], [STA_CODMAC], [AVA_CODAVA], [STA_AMGPRG], [AVA_DATAVA], [AVA_ORAAVA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_AVA_TG]([STA_NUMPRG], [NUD_NUMLOT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_AVA_TG]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [AVA_TIPAVA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_AVA_TG]([NUD_NUMLOT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_AVA_TG]([NUD_CODINT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_AVA_TG]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [AVA_AMGAVA]) ON [PRIMARY]
GO

-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_LOT_RI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_LOT_RI.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_LOT_RI.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_LOT_RI.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_LOT_RI.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_LOT_RI.INDICE_05
GO


if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_LOT_RI.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_LOT_RI.INDICE_07
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_LOT_RI]([LOT_CODSOC], [LOT_NLOINI], [LOT_NLOFIN], [LOT_DATOPE]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_02] ON [dbo].[U_LOT_RI]([LOT_CODSOC], [LOT_NLOINI], [LOT_DATOPE], [LOT_NLOFIN]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_03] ON [dbo].[U_LOT_RI]([LOT_NLOINI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_LOT_RI]([LOT_DATOPE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_LOT_RI]([LOT_CODCAU]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_LOT_RI]([LOT_NLOFIN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_LOT_RI]([LOT_CODSOC], [LOT_NLOFIN], [LOT_NLOINI]) ON [PRIMARY]
GO

-- ************************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_MAG_AR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_AR.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAG_AR.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MAG_AR.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MAG_AR.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MAG_AR.INDICE_05
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_AR]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_CODART], [MAG_CODMAG], [MAG_MATCHC], [MAG_PERI]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_02] ON [dbo].[U_MAG_AR]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_MATCHC], [MAG_PERI], [MAG_CODART], [MAG_CODMAG]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_03] ON [dbo].[U_MAG_AR]([MAG_CODSOC], [MAG_CODART], [MAG_FORNIT], [MAG_MATCHC], [MAG_PERI], [MAG_CODACQ], [MAG_CODMAG]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_04] ON [dbo].[U_MAG_AR]([MAG_CODSOC], [MAG_PERI], [MAG_CODMAG], [MAG_CODACQ], [MAG_CODART], [MAG_FORNIT], [MAG_MATCHC]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_05] ON [dbo].[U_MAG_AR]([MAG_CODSOC], [MAG_PERI], [MAG_FORNIT], [MAG_CODACQ], [MAG_CODART], [MAG_CODMAG], [MAG_MATCHC]) ON [PRIMARY]
GO 

-- ************************************************************************************
-- Indicizzazione tabella U_CCO_DD  ALTRI DATI PER FUNZIONE DI MAGAZZINO
-- ************************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_MAG_MA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_MA.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAG_MA.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MAG_MA.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MAG_MA.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MAG_MA.INDICE_05
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_MA]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_CODART], [MAG_CODMAG], [MAG_MATCHC], [MAG_PERI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_MAG_MA]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_MATCHC], [MAG_PERI], [MAG_CODART], [MAG_CODMAG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_MAG_MA]([MAG_CODSOC], [MAG_CODART], [MAG_FORNIT], [MAG_MATCHC], [MAG_PERI], [MAG_CODACQ], [MAG_CODMAG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_MAG_MA]([MAG_CODSOC], [MAG_PERI], [MAG_CODMAG], [MAG_CODACQ], [MAG_CODART], [MAG_FORNIT], [MAG_MATCHC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_MAG_MA]([MAG_CODSOC], [MAG_PERI], [MAG_FORNIT], [MAG_CODACQ], [MAG_CODART], [MAG_CODMAG], [MAG_MATCHC]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_MAG_FO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_FO.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAG_FO.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MAG_FO.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MAG_FO.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MAG_FO.INDICE_05
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_FO]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_CODART], [MAG_CODMAG], [MAG_MATCHC], [MAG_PERI]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_02] ON [dbo].[U_MAG_FO]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_MATCHC], [MAG_PERI], [MAG_CODART], [MAG_CODMAG]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_03] ON [dbo].[U_MAG_FO]([MAG_CODSOC], [MAG_CODART], [MAG_FORNIT], [MAG_MATCHC], [MAG_PERI], [MAG_CODACQ], [MAG_CODMAG]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_04] ON [dbo].[U_MAG_FO]([MAG_CODSOC], [MAG_PERI], [MAG_CODMAG], [MAG_CODACQ], [MAG_CODART], [MAG_FORNIT], [MAG_MATCHC]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_05] ON [dbo].[U_MAG_FO]([MAG_CODSOC], [MAG_PERI], [MAG_FORNIT], [MAG_CODACQ], [MAG_CODART], [MAG_CODMAG], [MAG_MATCHC]) ON [PRIMARY]
GO 


-- ********************************************************************************
-- Indicizzazione tabella U_MAG_MF.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_MF.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAG_MF.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MAG_MF.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MAG_MF.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MAG_MF.INDICE_05
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_MF]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_CODART], [MAG_CODMAG], [MAG_MATCHC], [MAG_PERI]) ON [PRIMARY]
GO 

CREATE INDEX [INDICE_02] ON [dbo].[U_MAG_MF]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_MATCHC], [MAG_PERI], [MAG_CODART], [MAG_CODMAG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_MAG_MF]([MAG_CODSOC], [MAG_CODART], [MAG_FORNIT], [MAG_MATCHC], [MAG_PERI], [MAG_CODACQ], [MAG_CODMAG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_MAG_MF]([MAG_CODSOC], [MAG_PERI], [MAG_CODMAG], [MAG_CODACQ], [MAG_CODART], [MAG_FORNIT], [MAG_MATCHC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_MAG_MF]([MAG_CODSOC], [MAG_PERI], [MAG_FORNIT], [MAG_CODACQ], [MAG_CODART], [MAG_CODMAG], [MAG_MATCHC]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_MAG_RI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_RI.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAG_RI.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MAG_RI.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MAG_RI.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MAG_RI.INDICE_05
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_RI]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_CODART], [MAG_CODMAG], [MAG_MATCHC], [MAG_PERI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_MAG_RI]([MAG_CODSOC], [MAG_CODACQ], [MAG_FORNIT], [MAG_MATCHC], [MAG_PERI], [MAG_CODART], [MAG_CODMAG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_MAG_RI]([MAG_CODSOC], [MAG_CODART], [MAG_FORNIT], [MAG_MATCHC], [MAG_PERI], [MAG_CODACQ], [MAG_CODMAG]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_MAG_RI]([MAG_CODSOC], [MAG_PERI], [MAG_CODMAG], [MAG_CODACQ], [MAG_CODART], [MAG_FORNIT], [MAG_MATCHC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_MAG_RI]([MAG_CODSOC], [MAG_PERI], [MAG_FORNIT], [MAG_CODACQ], [MAG_CODART], [MAG_CODMAG], [MAG_MATCHC]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_PCK_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PCK_DD.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PCK_DD]([DAGGANCIO]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_PED_PL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PED_PL.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PED_PL.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PED_PL.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PED_PL.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PED_PL.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_PED_PL.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_PED_PL.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_PED_PL.INDICE_08
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PED_PL]([MAG_CODCLI], [MAG_NUMPED], [MAG_DATPED], [MAG_NUMDDT], [MAG_DATDDT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_PED_PL]([MAG_CODMAG], [MAG_CODCLI], [MAG_CLIENT], [MAG_NUMORD], [MAG_DATORD], [MAG_NUMPED], [MAG_NUMDDT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_PED_PL]([MAG_CODCLI], [MAG_NUMPED], [MAG_DATPED], [MAG_NUMDDT], [MAG_SYSDDT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_PED_PL]([MAG_NRLINT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_PED_PL]([MAG_ANAART]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_PED_PL]([MAG_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_PED_PL]([MAG_CODCLI], [MAG_ANAART], [MAG_NUMPRG], [MAG_DATPRG], [MAG_PROPRG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_PED_PL]([MAG_SYSDDT]) ON [PRIMARY]
GO

-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PRG_CL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRG_CL.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRG_CL.INDICE_02
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PRG_CL]([PRG_TIPO], [PRG_CODSYS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PRG_CL]([PRG_TIPO], [PRG_UNIQUE]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_PRG_LT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRG_LT.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRG_LT.INDICE_02
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRG_LT]([LEG_LEGSYS]) ON [PRIMARY]
CREATE INDEX [INDICE_02] ON [dbo].[U_PRG_LT]([LEG_SYSORD]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_PRG_RI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRG_RI.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRG_RI.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRG_RI.INDICE_03
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRG_RI]([STA_SYSCLI], [STA_DATINI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_PRG_RI]([STA_NUMPRG], [STA_AMGPRG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_PRG_RI]([STA_FLGEND]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_PRG_RR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRG_RR.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRG_RR.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRG_RR.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PRG_RR.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PRG_RR.INDICE_05
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PRG_RR]([ID_UNIQUE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PRG_RR]([STA_CODSYS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PRG_RR]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [NUD_CODINT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PRG_RR]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [STA_FLGEND]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_PRG_RR]([NUD_CODINT]) ON [PRIMARY]
GO
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_PRG_RT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRG_RT.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRG_RT.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRG_RT.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PRG_RT.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PRG_RT.INDICE_05
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PRG_RT]([STA_LEGSYS], [STA_FLGEND]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_PRG_RT]([STA_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_PRG_RT]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [NUD_CODINT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_PRG_RT]([STA_NUMPRG], [STA_AMGPRG], [STA_PROGRE], [STA_FLGEND]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_PRG_RT]([NUD_CODINT]) ON [PRIMARY]
GO
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_PRG_TG.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRG_TG.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRG_TG.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRG_TG.INDICE_03
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PRG_TG]([STA_SYSCLI], [STA_DATINI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_PRG_TG]([STA_NUMPRG], [STA_AMGPRG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_PRG_TG]([STA_FLGEND]) ON [PRIMARY]
GO



-- ********************************************************************************
-- Indicizzazione tabella U_PRO_AL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PRO_AL.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PRO_AL.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PRO_AL.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PRO_AL.INDICE_04
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PRO_AL]([ALT_FINUDO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PRO_AL]([ALT_FISPDA]) ON [PRIMARY]
GO
--CREATE INDEX [INDICE_03] ON [dbo].[U_PRO_AL]([ALT_FISPDA1]) ON [PRIMARY]
--GO
CREATE INDEX [INDICE_03] ON [dbo].[U_PRO_AL]([ALT_FISPAL]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_PRO_AL]([ALT_CILGOM]) ON [PRIMARY]
GO
-- ********************************************************************************
-- Indicizzazione tabella U_VEN_CL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_VEN_CL.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_VEN_CL]([VEN_CODSOC], [VEN_ANNO], [VEN_MESE], [VEN_CODCLI], [VEN_CODART], [VEN_TIPO], [VEN_TIPDOC]) ON [PRIMARY]
GO



-- ********************************************************************************
-- Indicizzazione tabella U_AGN_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AGN_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_AGN_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_AGN_AN.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_AGN_AN.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_AGN_AN.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_AGN_AN.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_AGN_AN.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_AGN_AN.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_AGN_AN.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_AGN_AN.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_AGN_AN.INDICE_11
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_AGN_AN.INDICE_12
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_AGN_AN.INDICE_13
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_14')
   drop index U_AGN_AN.INDICE_14
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_15')
   drop index U_AGN_AN.INDICE_15
GO


if exists (select name from dbo.sysindexes where name = 'INDICE_16')
   drop index U_AGN_AN.INDICE_16
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_NOME]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_COGNOME]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_CODPDV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_TELEF]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_CELL]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_CELLAZ]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_EMAIL]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_TIPOL]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_SOCIET]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_TELEF2]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_TELEF3]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_12] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_FAX1]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_13] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_FAX2]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_14] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_INDIR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_15] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_SITO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_16] ON [dbo].[U_AGN_AN]([AGN_CODSOC], [AGN_UTENTE], [AGN_NOTE]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_ASC_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ASC_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_ASC_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_ASC_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_ASC_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_ASC_TT.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_ASC_TT.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_ASC_TT.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_ASC_TT.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_ASC_TT.INDICE_11
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_ASC_TT.INDICE_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_ASC_TT.INDICE_13
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_ASC_TT]([ASS_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_ASC_TT]([ASS_NUMASS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_ASC_TT]([ASS_CODSOC], [ASS_NUMASS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_ASC_TT]([ASS_CODSOC], [ASS_DATASS], [ASS_NUMASS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_ASC_TT]([ASS_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_ASC_TT]([ASS_CODSOC], [ASS_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_ASC_TT]([ASS_CODPDV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_ASC_TT]([ASS_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_ASC_TT]([ASS_CODSOC], [ASS_CODPDV], [ASS_DATASS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_12] ON [dbo].[U_ASC_TT]([ASS_DATASS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_13] ON [dbo].[U_ASC_TT]([ASS_CODSOC], [ASS_CODCLI], [ASS_DATASS]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_ASS_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ASS_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_ASS_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_ASS_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_ASS_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_ASS_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_ASS_TT.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_ASS_TT.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_ASS_TT.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_ASS_TT.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_ASS_TT.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_ASS_TT.INDICE_11
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_ASS_TT.INDICE_12
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_ASS_TT]([ASS_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_ASS_TT]([ASS_NUMASS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_ASS_TT]([ASS_CODSOC], [ASS_NUMASS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_ASS_TT]([ASS_DATASS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_ASS_TT]([ASS_CODSOC], [ASS_DATASS], [ASS_NUMASS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_ASS_TT]([ASS_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_ASS_TT]([ASS_CODSOC], [ASS_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_ASS_TT]([ASS_CODPDV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_ASS_TT]([ASS_CODSOC], [ASS_CODPDV], [ASS_DATASS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_ASS_TT]([ASS_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_ASS_TT]([ASS_CODSOC], [ASS_CODCLI], [ASS_DATASS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_12] ON [dbo].[U_ASS_TT]([TAGGANCIO]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_CAM_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CAM_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CAM_AN.INDICE_02
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CAM_AN]([CAM_CONTR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CAM_AN]([CAM_SOC], [CAM_CATEG]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_CCO_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CCO_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CCO_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_CCO_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_CCO_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_CCO_TT.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_CCO_TT.INDICE_07
GO


if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_CCO_TT.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_CCO_TT.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_CCO_TT.INDICE_11
GO



CREATE INDEX [INDICE_01] ON [dbo].[U_CCO_TT]([ORD_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_CCO_TT]([ORD_CODCCO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_CCO_TT]([ORD_CODSOC], [ORD_CODCCO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_CCO_TT]([ORD_DATAPE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_CCO_TT]([ORD_CODSOC], [ORD_DATAPE], [ORD_NUMCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_CCO_TT]([ORD_1COGNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_CCO_TT]([ORD_2COGNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_CCO_TT]([ORD_3COGNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_CCO_TT]([ORD_ORA]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_CNT_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CNT_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CNT_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CNT_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_CNT_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_CNT_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_CNT_TT.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_CNT_TT.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_CNT_TT.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_CNT_TT.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_CNT_TT.INDICE_10
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_CNT_TT.INDICE_11
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_CNT_TT.INDICE_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_CNT_TT.INDICE_13
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_14')
   drop index U_CNT_TT.INDICE_14
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_15')
   drop index U_CNT_TT.INDICE_15
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_16')
   drop index U_CNT_TT.INDICE_16
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_17')
   drop index U_CNT_TT.INDICE_17
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_CNT_TT]([CNT_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CNT_TT]([CNT_CODAGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_CNT_TT]([CNT_DESAGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_CNT_TT]([CNT_CODNAZ]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_CNT_TT]([CNT_DESNAZ]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_CNT_TT]([CNT_CODZON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_CNT_TT]([CNT_DESZON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_CNT_TT]([CNT_CODSET]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_CNT_TT]([CNT_DESSET]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_CNT_TT]([CNT_CDCONU]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_11] ON [dbo].[U_CNT_TT]([CNT_DSCONU]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_12] ON [dbo].[U_CNT_TT]([CNT_CODSET]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_13] ON [dbo].[U_CNT_TT]([CNT_DESSET]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_14] ON [dbo].[U_CNT_TT]([CNT_CODAGE], [CNT_STATOU], [CNT_PROV], [CNT_LOCALI], [CNT_CODNAZ], [CNT_CODZON], [CNT_DPRAZU] ) ON [PRIMARY]
GO
CREATE INDEX [INDICE_15] ON [dbo].[U_CNT_TT]([TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_16] ON [dbo].[U_CNT_TT]([CNT_RAGSOC], [CNT_CODIVA], [CNT_CODVAL], [CNT_CODNAZ], [CNT_CODZON], [CNT_CODAGE], [CNT_CODSET], [CNT_DATINS] ) ON [PRIMARY]
GO
CREATE INDEX [INDICE_17] ON [dbo].[U_CNT_TT]([CNT_RAGSOC], [CNT_CODAGE], [CNT_STATOU], [CNT_PROV], [CNT_LOCALI], [CNT_CODNAZ], [CNT_CODZON], [CNT_DPRAZU] ) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_CON_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CON_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CON_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CON_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_CON_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_CON_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_CON_TT.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_CON_TT.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_CON_TT.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_CON_TT.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_CON_TT.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_CON_TT.INDICE_11
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_CON_TT.INDICE_12
GO





CREATE INDEX [INDICE_01] ON [dbo].[U_CON_TT]([CON_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CON_TT]([CON_NUMCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_CON_TT]([CON_CODSOC], [CON_NUMCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_CON_TT]([CON_DATCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_CON_TT]([CON_CODSOC], [CON_DATCON], [CON_NUMCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_CON_TT]([CON_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_CON_TT]([CON_CODSOC], [CON_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_CON_TT]([CON_CODPDV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_CON_TT]([CON_CODSOC], [CON_CODPDV], [CON_DATCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_CON_TT]([CON_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_CON_TT]([CON_CODSOC], [CON_CODCLI], [CON_DATCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_12] ON [dbo].[U_CON_TT]([TAGGANCIO]) ON [PRIMARY]
GO





-- ********************************************************************************
-- Indicizzazione tabella U_COM_PE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_COM_PE.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_COM_PE.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_COM_PE.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_COM_PE.INDICE_04
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_COM_PE]([CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_COM_PE]([DESCRI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_COM_PE]([TIPO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_COM_PE]([GRUPPO]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_ELA_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ELA_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_ELA_AN.INDICE_02
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_ELA_AN]([DATA_SOLAR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_ELA_AN]([DATAELA_01]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_FIN_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_FIN_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_FIN_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_FIN_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_FIN_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_FIN_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_FIN_TT.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_FIN_TT.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_FIN_TT.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_FIN_TT.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_FIN_TT.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_FIN_TT.INDICE_11
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_FIN_TT]([FIN_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_FIN_TT]([FIN_NUMCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_FIN_TT]([FIN_CODSOC], [FIN_NUMCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_FIN_TT]([FIN_DATCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_FIN_TT]([FIN_CODSOC], [FIN_DATCON], [FIN_NUMCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_FIN_TT]([FIN_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_FIN_TT]([FIN_CODSOC], [FIN_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_FIN_TT]([FIN_CODPDV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_FIN_TT]([FIN_CODSOC], [FIN_CODPDV], [FIN_DATCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_FIN_TT]([FIN_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_FIN_TT]([FIN_CODSOC], [FIN_CODCLI], [FIN_DATCON]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_GPE_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_GPE_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_GPE_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_GPE_AN.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_GPE_AN.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_GPE_AN.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_GPE_AN.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_GPE_AN.INDICE_07
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_GPE_AN]([GPE_MATRI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_GPE_AN]([GPE_MATRI], [GPE_COGNOM]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_GPE_AN]([GPE_COGNOM]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_GPE_AN]([GPE_LOCAL]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_GPE_AN]([GPE_BANCA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_GPE_AN]([GPE_DTASS]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_GPE_AN]([GPE_DTCES]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_GPP_MO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_GPP_MO.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_GPP_MO.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_GPP_MO.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_GPP_MO.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_GPP_MO.INDICE_05
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_GPP_MO]([GPP_MATRI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_GPP_MO]([GPP_MATRI], [GPP_COGNOM]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_GPP_MO]([GPP_COGNOM]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_GPP_MO]([GPP_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_GPP_MO]([GPP_MESE]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_LEA_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_LEA_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_LEA_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_LEA_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_LEA_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_LEA_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_LEA_TT.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_LEA_TT.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_LEA_TT.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_LEA_TT.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_LEA_TT.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_LEA_TT.INDICE_11
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_LEA_TT]([LEA_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_LEA_TT]([LEA_NUMCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_LEA_TT]([LEA_CODSOC], [LEA_NUMCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_LEA_TT]([LEA_DATCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_LEA_TT]([LEA_CODSOC], [LEA_DATCON], [LEA_NUMCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_LEA_TT]([LEA_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_LEA_TT]([LEA_CODSOC], [LEA_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_LEA_TT]([LEA_CODPDV]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_LEA_TT]([LEA_CODSOC], [LEA_CODPDV], [LEA_DATCON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_LEA_TT]([LEA_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_LEA_TT]([LEA_CODSOC], [LEA_CODCLI], [LEA_DATCON]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_LIS_CA.DBF
-- ********************************************************************************
--if exists (select name from dbo.sysindexes where name = 'INDICE_01')
--   drop index U_LIS_CA.INDICE_01
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_02')
--   drop index U_LIS_CA.INDICE_02
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_03')
--   drop index U_LIS_CA.INDICE_03
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_04')
--   drop index U_LIS_CA.INDICE_04
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_05')
--   drop index U_LIS_CA.INDICE_05
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_06')
--   drop index U_LIS_CA.INDICE_06
--GO


--CREATE INDEX [INDICE_01] ON [dbo].[U_LIS_CA]([LIS_CODCLI]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_02] ON [dbo].[U_LIS_CA]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_03] ON [dbo].[U_LIS_CA]([LIS_CODART]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_04] ON [dbo].[U_LIS_CA]([LIS_CODSOC], [LIS_CODART], [LIS_CODCLI]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_05] ON [dbo].[U_LIS_CA]([LIS_DATLIS]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_06] ON [dbo].[U_LIS_CA]([LIS_CODSOC], [LIS_DATLIS], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
--GO


-- ********************************************************************************
-- Indicizzazione tabella U_PART_PR.DBF
-- ********************************************************************************
--if exists (select name from dbo.sysindexes where name = 'INDICE_01')
--   drop index U_LEA_TT.INDICE_01
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_02')
--   drop index U_PART_PR.INDICE_02
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_03')
--   drop index U_PART_PR.INDICE_03
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_04')
--   drop index U_PART_PR.INDICE_04
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_05')
--   drop index U_PART_PR.INDICE_05
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_06')
--   drop index U_PART_PR.INDICE_06
--GO
--if exists (select name from dbo.sysindexes where name = 'INDICE_07')
--   drop index U_PART_PR.INDICE_07
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_08')
--   drop index U_PART_PR.INDICE_08
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_09')
--   drop index U_PART_PR.INDICE_09
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_10')
--   drop index U_PART_PR.INDICE_10
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_11')
--   drop index U_PART_PR.INDICE_11
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_12')
--   drop index U_PART_PR.INDICE_12
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_13')
--   drop index U_PART_PR.INDICE_13
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_14')
--   drop index U_PART_PR.INDICE_14
--GO

--CREATE INDEX [INDICE_01] ON [dbo].[U_PART_PR]([ART_CODSOC]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_02] ON [dbo].[U_PART_PR]([ART_FLGMIN]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_03] ON [dbo].[U_PART_PR]([ART_CODSOC], [ART_CODPAC]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_04] ON [dbo].[U_PART_PR]([ART_DESPAC]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_05] ON [dbo].[U_PART_PR]([ART_CODSOC], [ART_DESPAC]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_06] ON [dbo].[U_PART_PR]([ART_CODPRI]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_07] ON [dbo].[U_PART_PR]([ART_CODSOC], [ART_CODPRI]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_08] ON [dbo].[U_PART_PR]([ART_DESCR]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_09] ON [dbo].[U_PART_PR]([ART_CODSOC], [ART_DESCR]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_10] ON [dbo].[U_PART_PR]([ART_SERNUM]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_11] ON [dbo].[U_PART_PR]([ART_CODSOC], [ART_SERNUM]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_12] ON [dbo].[U_PART_PR]([ART_TIPCON]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_13] ON [dbo].[U_PART_PR]([ART_CODPAC]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_14] ON [dbo].[U_PART_PR]([ART_CODSOC], [ART_TIPCON], [ART_CODPRI]) ON [PRIMARY]
--GO


-- ********************************************************************************
-- Indicizzazione tabella U_MPA_CQ.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MPA_CQ.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MPA_CQ.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MPA_CQ.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MPA_CQ.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MPA_CQ.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_MPA_CQ.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_MPA_CQ.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_MPA_CQ.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_MPA_CQ.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_MPA_CQ.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_MPA_CQ.INDICE_11
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_MPA_CQ.INDICE_12
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_MPA_CQ.INDICE_13
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_14')
   drop index U_MPA_CQ.INDICE_14
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_15')
   drop index U_MPA_CQ.INDICE_15
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_16')
   drop index U_MPA_CQ.INDICE_16
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_MPA_CQ]([MPA_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_MPA_CQ]([MPA_DESART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_MPA_CQ]([MPA_CODFOR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_MPA_CQ]([MPA_DESFOR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_MPA_CQ]([MPA_NUMORF]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_MPA_CQ]([MPA_DATORF]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_MPA_CQ]([MPA_DTCAMA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_MPA_CQ]([MPA_NUMLOT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_MPA_CQ]([MPA_DTCACQ]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[U_MPA_CQ]([MPA_RESPO1]) ON [PRIMARY]
GO


CREATE INDEX [INDICE_11] ON [dbo].[U_MPA_CQ]([MPA_RESDT1]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_12] ON [dbo].[U_MPA_CQ]([MPA_RESPO2]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_13] ON [dbo].[U_MPA_CQ]([MPA_RESDT2]) ON [PRIMARY]
GO


CREATE INDEX [INDICE_14] ON [dbo].[U_MPA_CQ]([ID_UNIQUE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_15] ON [dbo].[U_MPA_CQ]([MPA_CODSOC], [MPA_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_16] ON [dbo].[U_MPA_CQ]([MPA_CODSOC], [MPA_CODMAG], [MPA_CODART], [MPA_CODFOR], [MPA_NUMORF], [MPA_DATORF], [MPA_NUMLOT], [MPA_ANNLOT], [MPA_DTCAMA]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_MPF_CQ.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MPF_CQ.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MPF_CQ.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MPF_CQ.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MPF_CQ.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MPF_CQ.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_MPF_CQ.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_MPF_CQ.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_MPF_CQ.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_MPF_CQ.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_MPF_CQ.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_MPF_CQ.INDICE_11
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_MPF_CQ.INDICE_12
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_MPF_CQ.INDICE_13
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_14')
   drop index U_MPF_CQ.INDICE_14
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_15')
   drop index U_MPF_CQ.INDICE_15
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_16')
   drop index U_MPF_CQ.INDICE_16
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_MPF_CQ]([MPF_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_MPF_CQ]([MPF_DESART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_MPF_CQ]([MPF_CODFOR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_MPF_CQ]([MPF_DESFOR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_MPF_CQ]([MPF_NUMORF]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_MPF_CQ]([MPF_DATORF]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_MPF_CQ]([MPF_DTCAMA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_MPF_CQ]([MPF_NUMLOT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_MPF_CQ]([MPF_DTCACQ]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_MPF_CQ]([MPF_RESPO1]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_MPF_CQ]([MPF_RESDT1]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_12] ON [dbo].[U_MPF_CQ]([MPF_RESPO2]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_13] ON [dbo].[U_MPF_CQ]([MPF_RESDT2]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_14] ON [dbo].[U_MPF_CQ]([MPF_CODSOC], [MPF_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_15] ON [dbo].[U_MPF_CQ]([MPF_CODSOC], [MPF_CODMAG], [MPF_CODART], [MPF_CODFOR], [MPF_NUMORF], [MPF_DATORF], [MPF_NUMLOT], [MPF_ANNLOT], [MPF_DTCAMA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_16] ON [dbo].[U_MPF_CQ]([ID_UNIQUE]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PAR_CQ.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PAR_CQ.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PAR_CQ.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PAR_CQ.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PAR_CQ.INDICE_04
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PAR_CQ]([PAR_CODSOC], [PAR_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PAR_CQ]([PAR_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PAR_CQ]([PAR_CODART], [PAR_DESART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PAR_CQ]([PAR_DESART]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_PAR_FI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PAR_FI.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PAR_FI.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PAR_FI.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PAR_FI.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PAR_FI.INDICE_05
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PAR_FI]([PAR_CODSOC], [PAR_CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PAR_FI]([PAR_CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PAR_FI]([PAR_CODICE], [PAR_DESCRI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PAR_FI]([PAR_DESCRI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_PAR_FI]([PAR_CODICE], [PAR_CODSOC]) ON [PRIMARY]
GO

-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PAR_MY.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PAR_MY.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PAR_MY.INDICE_02
GO
--if exists (select name from dbo.sysindexes where name = 'INDICE_03')
--   drop index U_PAR_MY.INDICE_03
--GO



CREATE INDEX [INDICE_01] ON [dbo].[U_PAR_MY]([PAR_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PAR_MY]([PAR_CODSPE], [PAR_CODSOC]) ON [PRIMARY]
GO

--CREATE INDEX [INDICE_03] ON [dbo].[U_PAR_MY]([PAR_CODICE]) ON [PRIMARY]
--GO

-- ********************************************************************************
-- Indicizzazione tabella U_PCK_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PCK_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PCK_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PCK_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PCK_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PCK_TT.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_PCK_TT.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_PCK_TT.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_PCK_TT.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_PCK_TT.INDICE_09
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PCK_TT]([ORD_CODSOC], [ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PCK_TT]([ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PCK_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_PCK_TT]([ORD_DATORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_PCK_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_PCK_TT]([ORD_RAGSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_PCK_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_PCK_TT]([ORD_AGE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_PCK_TT]([ORD_CODSOC], [ORD_AGE], [ORD_DATORD]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_XLS_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_XLS_TT.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_XLS_TT.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_XLS_TT.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_XLS_TT.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_XLS_TT.INDICE_05
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_XLS_TT]([XLS_CODSOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_XLS_TT]([XLS_CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_XLS_TT]([XLS_CODSOC], [XLS_CODICE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_XLS_TT]([XLS_DESCRI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_XLS_TT]([XLS_CODSOC], [XLS_DESCRI]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_SLC_CQ.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_SLC_CQ.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_SLC_CQ.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_SLC_CQ.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_SLC_CQ.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_SLC_CQ.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_SLC_CQ.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_SLC_CQ.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_SLC_CQ.INDICE_08
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_SLC_CQ]([SLC_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_SLC_CQ]([SLC_DESART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_SLC_CQ]([SLC_DATANA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_SLC_CQ]([SLC_DESCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_SLC_CQ]([SLC_CAMPIO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_SLC_CQ]([SLC_RESPON]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_SLC_CQ]([SLC_RESDAT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_SLC_CQ]([SLC_CODCLI], [SLC_DATANA], [SLC_CODART]) ON [PRIMARY]
GO





-- ********************************************************************************
-- Indicizzazione tabella U_SLF_CQ.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_SLF_CQ.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_SLF_CQ.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_SLF_CQ.INDICE_03

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_SLF_CQ.INDICE_04
GO
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_SLF_CQ.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_SLF_CQ.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_SLF_CQ.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_SLF_CQ.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_SLF_CQ.INDICE_09
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_SLF_CQ.INDICE_10
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_SLF_CQ.INDICE_11
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_SLF_CQ.INDICE_12
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_SLF_CQ.INDICE_13
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_14')
   drop index U_SLF_CQ.INDICE_14
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_SLF_CQ]([SLF_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_SLF_CQ]([SLF_DESART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_SLF_CQ]([SLF_NUMLOT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_SLF_CQ]([SLF_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_SLF_CQ]([SLF_FNNULO]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[U_SLF_CQ]([SLF_DESCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[U_SLF_CQ]([SLF_DTCACQ]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[U_SLF_CQ]([SLF_RESPO1]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[U_SLF_CQ]([SLF_RESDT1]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_10] ON [dbo].[U_SLF_CQ]([SLF_RESPO2]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_11] ON [dbo].[U_SLF_CQ]([SLF_RESDT2]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_12] ON [dbo].[U_SLF_CQ]([ID_UNIQUE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_13] ON [dbo].[U_SLF_CQ]([SLF_CODSOC], [SLF_CODART]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_14] ON [dbo].[U_SLF_CQ]([SLF_CODSOC], [SLF_CODMAG], [SLF_CODART], [SLF_NUMLOT], [SLF_ANNLOT], [SLF_DATPRO]) ON [PRIMARY]
GO





-- ********************************************************************************
-- Indicizzazione tabella U_SPETT_TT.DBF
-- ********************************************************************************
--if exists (select name from dbo.sysindexes where name = 'INDICE_01')
--   drop index U_SPETT_TT.INDICE_01
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_02')
--   drop index U_SPETT_TT.INDICE_02
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_03')
--   drop index U_SPETT_TT.INDICE_03
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_04')
--   drop index U_SPETT_TT.INDICE_04
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_05')
--   drop index U_SPETT_TT.INDICE_05
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_06')
--   drop index U_SPETT_TT.INDICE_06
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_07')
--   drop index U_SPETT_TT.INDICE_07
--GO

--if exists (select name from dbo.sysindexes where name = 'INDICE_08')
--   drop index U_SPETT_TT.INDICE_08
--GO


--CREATE INDEX [INDICE_01] ON [dbo].[U_SPETT_TT]([ORD_CODSOC]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_02] ON [dbo].[U_SPETT_TT]([ORD_ANNO]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_03] ON [dbo].[U_SPETT_TT]([ORD_NUMORD]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_04] ON [dbo].[U_SPETT_TT]([ORD_CODSOC], [ORD_NUMORD], [ORD_ANNO]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_05] ON [dbo].[U_SPETT_TT]([ORD_DATORD]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_06] ON [dbo].[U_SPETT_TT]([ORD_CODSOC], [ORD_DATORD], [ORD_NUMORD]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_07] ON [dbo].[U_SPETT_TT]([ORD_RAGSOC]) ON [PRIMARY]
--GO

--CREATE INDEX [INDICE_08] ON [dbo].[U_SPETT_TT]([ORD_CODSOC], [ORD_RAGSOC], [ORD_ANNO]) ON [PRIMARY]
--GO

-- ********************************************************************************
-- Indicizzazione tabella U_TES_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_TES_AN.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_TES_AN.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_TES_AN.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_TES_AN.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_TES_AN.INDICE_05
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_TES_AN]([TES_COGN]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_TES_AN]([TES_COGN], [TES_NOME]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_TES_AN]([TES_NOME]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[U_TES_AN]([TES_LOC]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[U_TES_AN]([TES_PROV]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella SALDI_CLI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index SALDI_CLI.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index SALDI_CLI.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index SALDI_CLI.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index SALDI_CLI.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index SALDI_CLI.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index SALDI_CLI.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index SALDI_CLI.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index SALDI_CLI.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index SALDI_CLI.INDICE_09
GO



CREATE INDEX [INDICE_01] ON [dbo].[SALDI_CLI]([PAR_CODCLI], [PAR_FATT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[SALDI_CLI]([PAR_CODCLI], [PAR_FATT], [PAR_ANOMAX]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[SALDI_CLI]([PAR_FATT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[SALDI_CLI]([PAR_FATT], [PAR_ANOMAX]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[SALDI_CLI]([PAR_NPART], [PAR_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[SALDI_CLI]([PAR_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[SALDI_CLI]([PAR_CODCLI], [PAR_ANOMAX]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[SALDI_CLI]([PAR_ANOMAX]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[SALDI_CLI]([PAR_NPART]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella SALDI_FOR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index SALDI_FOR.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index SALDI_FOR.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index SALDI_FOR.INDICE_03
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index SALDI_FOR.INDICE_04
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index SALDI_FOR.INDICE_05
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index SALDI_FOR.INDICE_06
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index SALDI_FOR.INDICE_07
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index SALDI_FOR.INDICE_08
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index SALDI_FOR.INDICE_09
GO



CREATE INDEX [INDICE_01] ON [dbo].[SALDI_FOR]([PAR_CODCLI], [PAR_FATT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[SALDI_FOR]([PAR_CODCLI], [PAR_FATT], [PAR_ANOMAX]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[SALDI_FOR]([PAR_FATT]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_04] ON [dbo].[SALDI_FOR]([PAR_FATT], [PAR_ANOMAX]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_05] ON [dbo].[SALDI_FOR]([PAR_NPART], [PAR_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_06] ON [dbo].[SALDI_FOR]([PAR_CODCLI]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_07] ON [dbo].[SALDI_FOR]([PAR_CODCLI], [PAR_ANOMAX]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_08] ON [dbo].[SALDI_FOR]([PAR_ANOMAX]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_09] ON [dbo].[SALDI_FOR]([PAR_NPART]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_CON_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CON_DD.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CON_DD.INDICE_02
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CON_DD]([CON_CODFOR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_CON_DD]([CON_SYSDOC]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_ASS_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ASS_DD.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_ASS_DD.INDICE_02
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_ASS_DD]([ASS_CODFOR]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_ASS_DD]([ASS_SYSDOC]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_ALT_DA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_ALT_DA.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_ALT_DA]([ALT_DADOVE], [ALT_CODMAG], [ALT_LEGAME]) ON [PRIMARY]
GO

-- ************************************************************************************
-- Indicizzazione tabella U_CCO_DD  ALTRI DATI PER FUNZIONE DI MAGAZZINO
-- ************************************************************************************


if exists (select name from dbo.sysindexes where name = 'U_CCO_D1')
   drop index U_CCO_DD.U_CCO_D1
GO
CREATE INDEX [U_CCO_D1] ON [dbo].[U_CCO_DD]([DAGGANCIO]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_PCK_LE
-- ************************************************************************************

if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PCK_LE.INDICE_01
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PCK_LE.INDICE_02
GO

if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PCK_LE.INDICE_03
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PCK_LE]([LEG_AGGANC], [LEG_SYSPCK], [LEG_UNIQUE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PCK_LE]([LEG_CODART], [LEG_AAPROD], [LEG_SERNUM], [LEG_NUMEDA]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_03] ON [dbo].[U_PCK_LE]([LEG_ANAART]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_BOL_LE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_BOL_LE.INDICE_01
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_BOL_LE]([LEG_AGGANC], [LEG_SYSBOL], [LEG_SYSMAG]) ON [PRIMARY]
GO


-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_INV_MA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_INV_MA.INDICE_01
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_INV_MA]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_DATAGG], [MAG_GIACEN]) ON [PRIMARY]
GO

-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_PDA_MA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PDA_MA.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PDA_MA.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PDA_MA.INDICE_03
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PDA_MA]([MAG_CODSOC], [MAG_CODMAG], [MAG_CODART], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_DATAGG], [MAG_GIACEN]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_PDA_MA]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_PDA_MA]([MAG_CODSOC], [INV_CODMAG]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella COMUNI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_ATT_01')
   drop index U_ATT_OP.U_ATT_01
if exists (select name from dbo.sysindexes where name = 'U_ATT_02')
   drop index U_ATT_OP.U_ATT_02
if exists (select name from dbo.sysindexes where name = 'U_ATT_03')
   drop index U_ATT_OP.U_ATT_03
if exists (select name from dbo.sysindexes where name = 'U_ATT_04')
   drop index U_ATT_OP.U_ATT_04
 
CREATE INDEX [U_ATT_01] ON [dbo].[U_ATT_OP]([ATT_PROCED], [ATT_CODOPE]) ON [PRIMARY]
GO
CREATE INDEX [U_ATT_02] ON [dbo].[U_ATT_OP]([ATT_DESPRO]) ON [PRIMARY]
GO
CREATE INDEX [U_ATT_03] ON [dbo].[U_ATT_OP]([ATT_CODOPE]) ON [PRIMARY]
GO
CREATE INDEX [U_ATT_04] ON [dbo].[U_ATT_OP]([ATT_NOMOPE]) ON [PRIMARY]
GO



-- ********************************************************************************
-- Indicizzazione tabella U_RAP_SP.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_RAP_SP.INDICE_01

 
CREATE INDEX [INDICE_01] ON [dbo].[U_RAP_SP]([RAP_CODSOC], [RAP_NUMPRG], [RAP_AMGPRG], [RAP_PROGRE]) ON [PRIMARY]
GO
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_TOP_MO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_TOP_MO.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_TOP_MO]([TOP_MAGSCA], [TOP_MAGCAR], [TOP_CAUSCA]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_LIS_AL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_LIS_01')
   drop index U_LIS_AL.U_LIS_01
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_02')
   drop index U_LIS_AL.U_LIS_02
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_03')
   drop index U_LIS_AL.U_LIS_03
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_CA')
   drop index U_LIS_AL.U_LIS_CA
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_CO')
   drop index U_LIS_AL.U_LIS_CO
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_VE')
   drop index U_LIS_AL.U_LIS_VE
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_04')
   drop index U_LIS_AL.U_LIS_04
GO
if exists (select name from dbo.sysindexes where name = 'U_LIS_05')
   drop index U_LIS_AL.U_LIS_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_LIS_AL.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_LIS_AL.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_LIS_AL.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_LIS_AL.INDICE_04
GO


CREATE INDEX [U_LIS_01] ON [dbo].[U_LIS_AL]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_02] ON [dbo].[U_LIS_AL]([LIS_CODSOC], [LIS_CODART], [LIS_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_03] ON [dbo].[U_LIS_AL]([LIS_CODSOC], [LIS_DATLIS], [LIS_CODCLI], [LIS_CODART]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_CA] ON [dbo].[U_LIS_AL]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART], [LIS_DATLIS], [LIS_ALLIST]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_CO] ON [dbo].[U_LIS_AL]([LIS_CODSOC], [LIS_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_VE] ON [dbo].[U_LIS_AL]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART], [LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_04] ON [dbo].[U_LIS_AL]([LIS_FLGTRA]) ON [PRIMARY]
GO
CREATE INDEX [U_LIS_05] ON [dbo].[U_LIS_AL]([LIS_CODSOC], [LIS_CODCLI], [LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_01] ON [dbo].[U_LIS_AL]([LIS_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_LIS_AL]([LIS_CODART]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_LIS_AL]([LIS_DATLIS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_LIS_AL]([LIS_CODSOC], [LIS_CODCLI], [LIS_CODART],  [LIS_ALTEDA], [LIS_DATLIS]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PES_VE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PES_VE.INDICE_01
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[U_PES_VE]([PES_CODVET]) ON [PRIMARY]
GO
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_CON_VE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CON_VE.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CON_VE.INDICE_02
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[U_CON_VE]([CON_CODVET], [CON_CODPRV]) ON [PRIMARY]
GO
 
CREATE INDEX [INDICE_02] ON [dbo].[U_CON_VE]([CON_CODVET], [CON_CODNAZ], [CON_CODPRV]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_MAG_MS.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_MS.INDICE_01
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_MS]([MOV_UNIQUE]) ON [PRIMARY]
GO
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_MAG_GS.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_GS.INDICE_01
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_GS]([MAG_UNIQUE]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_MAG_SA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_SA.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAG_SA.INDICE_02
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_SA]([MAG_CODSOC], [MAG_AAAAMM], [MAG_CODMAG], [MAG_CODART]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_MAG_SA]([MAG_CODSOC], [MAG_CODMAT], [MAG_CODCOL], [MAG_SPESSO], [MAG_ALTEZZ], [MAG_LUNGHE], [MAG_ANAART], [MAG_NRLINT], [MAG_CODMAG], [MAG_FORNIT], [MAG_NUMIDE], [MAG_ANNO], [MAG_AAAAMM]) ON [PRIMARY]
GO

-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_MAG_SS.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAG_SS.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_MAG_SS]([MAG_CODSOC], [MAG_AAAAMM], [MAG_CODMAG], [MAG_CODART]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PAR_CT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PAR_CT.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PAR_CT]([PAR_CODNAZ], [PAR_ZONA], [PAR_TIPTRA]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_CNT_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CNT_DD.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CNT_DD.INDICE_02
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CNT_DD]([DAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_CNT_DD]([DAGGANCIO], [CNT_SEQUEN]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_CNT_PR.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CNT_PR.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CNT_PR.INDICE_02
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CNT_PR]([DAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_CNT_PR]([DAGGANCIO_PR]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_CMP_CL.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CMP_CL.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CMP_CL.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CMP_CL.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_CMP_CL.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_CMP_CL.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_CMP_CL.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_CMP_CL.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_CMP_CL.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_CMP_CL.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_CMP_CL.INDICE_10
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_CMP_CL.INDICE_11
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_CMP_CL]([CMP_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_CMP_CL]([CMP_RAGSOC], [CMP_DATARR]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_CMP_CL]([CMP_RAGSOC], [CMP_DESAGE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_CMP_CL]([CMP_RAGSOC], [CMP_TIPRES], [CMP_DTCM02]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_CMP_CL]([CMP_RAGSOC], [CMP_TIPRES], [CMP_DATARR]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_CMP_CL]([CMP_RAGSOC], [CMP_TIPRES], [CMP_DESAGE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_CMP_CL]([CMP_RAGSOC], [CMP_DTCM03], [CMP_DATARR]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_CMP_CL]([CMP_RAGSOC], [CMP_DTCM03], [CMP_DESAGE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_CMP_CL]([CMP_RAGSOC], [CMP_DTCM03], [CMP_TIPRES], [CMP_DTCM02]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[U_CMP_CL]([CMP_RAGSOC], [CMP_CODAGE], [CMP_DATARR]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_11] ON [dbo].[U_CMP_CL]([CMP_RAGSOC], [CMP_CODAGE], [CMP_ARTNUM], [CMP_DATARR], [CMP_DTUMAT]) ON [PRIMARY]
GO
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_MAN_CO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_MAN_CO.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_MAN_CO.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_MAN_CO.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_MAN_CO.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_MAN_CO.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_MAN_CO.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_MAN_CO.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_MAN_CO.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_MAN_CO.INDICE_09
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_MAN_CO]([MAN_ALTEDA], [MAN_ALTEAL], [MAN_LUNGDA], [MAN_LUNGAL], [MAN_SPESDA], [MAN_SPESAL], [MAN_CODPER]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_MAN_CO]([MAN_ALTEDA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_MAN_CO]([MAN_ALTEAL]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_MAN_CO]([MAN_LUNGDA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_MAN_CO]([MAN_LUNGAL]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_MAN_CO]([MAN_SPESDA]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_MAN_CO]([MAN_SPESAL]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_MAN_CO]([MAN_CODPER]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_MAN_CO]([MAN_ALTEDA], [MAN_ALTEAL], [MAN_LUNGDA], [MAN_LUNGAL], [MAN_SPESDA], [MAN_SPESAL], [MAN_CODPER], [MAN_CODMAN], [MAN_DESMAN]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PDA_LO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PDA_LO.INDICE_01
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PDA_LO]([PDA_CODMAG]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PDA_MO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PDA_MO.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PDA_MO.INDICE_02
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PDA_MO]([ID_UNIQUE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PDA_MO]([MAG_CODSOC], [INV_CODMAG]) ON [PRIMARY]
GO
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_PDA_CA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PDA_CA.INDICE_01
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PDA_CA]([MAG_CODSOC], [MAG_CODMAG], [MAG_DATINV]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_SCO_MI.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_SCO_MI.INDICE_01
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[U_SCO_MI]([SCO_CODART], [SCO_ALTEZZ], [SCO_LUNGHE]) ON [PRIMARY]
GO
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_SCA_MA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_SCA_MA.INDICE_01
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[U_SCA_MA]([SCA_MESEDA], [SCA_ANNODA], [SCA_MESEAL], [SCA_ANNOAL]) ON [PRIMARY]
GO
-- ********************************************************************************


-- ********************************************************************************
-- Indicizzazione tabella U_LOC_GE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_LOC_GE.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_LOC_GE.INDICE_02
GO
 

CREATE INDEX [INDICE_01] ON [dbo].[U_LOC_GE]([LOC_CODMAG], [LOC_FILNUM], [LOC_PIANUM], [LOC_UBINUM]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_LOC_GE]([LOC_CODMAG], [LOC_FILALF], [LOC_PIAALF], [LOC_UBIALF]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_PKG_TD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PKG_TD.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PKG_TD.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_PKG_TD.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_PKG_TD.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_PKG_TD.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_PKG_TD.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_PKG_TD.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_PKG_TD.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_PKG_TD.INDICE_09
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_10')
   drop index U_PKG_TD.INDICE_10
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_PKG_TD.INDICE_11
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_PKG_TD.INDICE_12
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[U_PKG_TD]([PKG_CODSYS], [PKG_ANNPKG], [PKG_NUMPKG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_PKG_TD]([PKG_CODSYS], [PKG_ANNPKG], [PKG_DATPKG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_PKG_TD]([PKG_CODSYS], [PKG_ANNPKG], [PKG_NUMPRB]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_PKG_TD]([PKG_CODSYS], [PKG_ANNPKG], [PKG_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_PKG_TD]([PKG_CODSYS], [PKG_ANNPKG], [PKG_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_PKG_TD]([PKG_CODSYS], [PKG_ANNPKG], [PKG_DESTIN]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_PKG_TD]([PKG_CODSYS], [PKG_ANNPKG], [PKG_CODART]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_PKG_TD]([PKG_CODSYS], [PKG_ANNPKG], [PKG_SC_PKG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_PKG_TD]([PKG_NUMPKG], [PKG_DATPKG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_10] ON [dbo].[U_PKG_TD]([PKG_CODSYS]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_11] ON [dbo].[U_PKG_TD]([PKG_DATPKG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_12] ON [dbo].[U_PKG_TD]([PKG_CODCLI], [PKG_CODART], [PKG_DATPKG], [PKG_NUMPKG], [PKG_QTADEV]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_PKG_LE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PKG_LE.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PKG_LE.INDICE_02
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_PKG_LE]([LEG_SYSPKG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_PKG_LE]([LEG_CODSYS]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_AST_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AST_AN.INDICE_01
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[U_AST_AN]([AST_CODSOC], [AST_DATSCA], [AST_NUMSCA], [AST_NUMSCH], [AST_CODCLI], [AST_CODLOC], [AST_CODMAG], [AST_FILA_X], [AST_PIAN_X], [AST_UBIC_X]) ON [PRIMARY]
GO
 

-- ********************************************************************************
-- Indicizzazione tabella U_CAS_TT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CAS_TT.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CAS_TT.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CAS_TT.INDICE_03
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CAS_TT]([CAS_CODSOC], [CAS_DATSCA], [CAS_NUMSCA], [CAS_CODCLI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_CAS_TT]([CAS_CODSOC], [TAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_CAS_TT]([CAS_CODSOC], [CAS_DATSCA], [CAS_NUMSCA], [CAS_NUMSCH], [CAS_CODCLI], [CAS_CODLOC], [CAS_CODMAG], [CAS_FILA_X], [CAS_PIAN_X], [CAS_UBIC_X]) ON [PRIMARY]
GO


-- ********************************************************************************
-- Indicizzazione tabella U_CAS_DD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CAS_DD.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CAS_DD.INDICE_02
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CAS_DD]([DAGGANCIO]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_CAS_DD]([CAD_CODSOC], [CAD_DATSCA], [CAD_NUMSCA], [CAD_CODCLI]) ON [PRIMARY]
GO



-- ********************************************************************************
-- Indicizzazione tabella U_CAS_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CAS_AN.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_CAS_AN]([CAS_MATRIC], [CAS_COGNOM], [CAS_NOME], [CAS_CODLOC]) ON [PRIMARY]
GO

-- ********************************************************************************
-- Indicizzazione tabella U_SOL_GE.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_SOL_GE.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_SOL_GE]([SOL_CODCLI], [SOL_DATSCA], [SOL_NUMDOC], [SOL_DATDOC]) ON [PRIMARY]
GO

-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_CER_CO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_CER_CO.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_CER_CO.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_CER_CO.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_CER_CO.INDICE_04
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_05')
   drop index U_CER_CO.INDICE_05
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_06')
   drop index U_CER_CO.INDICE_06
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_07')
   drop index U_CER_CO.INDICE_07
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_08')
   drop index U_CER_CO.INDICE_08
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_09')
   drop index U_CER_CO.INDICE_09
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_CER_CO]([CER_AGGANC], [CER_TIPPRG], [CER_NUMPRG], [CER_AMGPRG], [CER_PROGRE]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_CER_CO]([CER_AGGANC], [CER_NUMDDT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_CER_CO]([CER_AGGANC], [CER_DATDDT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_CER_CO]([CER_AGGANC], [CER_RAGSOC]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_05] ON [dbo].[U_CER_CO]([CER_AGGANC], [CER_CODART]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_06] ON [dbo].[U_CER_CO]([CER_AGGANC], [CER_NRLINT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_07] ON [dbo].[U_CER_CO]([CER_AGGANC], [CER_TIPPRG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_08] ON [dbo].[U_CER_CO]([CER_AGGANC], [CER_NUMPRG]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_09] ON [dbo].[U_CER_CO]([CER_AGGANC], [CER_AMGPRG]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_AMM_CA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AMM_CA.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_AMM_CA]([AMM_CODAMM]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_AMM_AT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AMM_AT.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_AMM_AT.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_AMM_AT.INDICE_03
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_04')
   drop index U_AMM_AT.INDICE_04
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_AMM_AT]([AMM_CODCES]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_AMM_AT]([AMM_CODCES], [AMM_CODCAT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_AMM_AT]([AMM_CODCES], [AMM_CODCAT], [AMM_CONCES], [AMM_DATUTI]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_04] ON [dbo].[U_AMM_AT]([AMM_CODCES], [AMM_CODCAT], [AMM_CONCES], [AMM_DATREG]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_AMM_AD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AMM_AD.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_AMM_AD.INDICE_02
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_AMM_AD]([AMD_CODCES]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_AMM_AD]([AMD_ANNO], [AMD_NREGIS]) ON [PRIMARY]
GO

-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_QUO_AM.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_QUO_AM.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_QUO_AM]([QUO_CODCES], [QUO_ANNRIF], [QUO_CODCAT]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- ********************************************************************************
-- Indicizzazione tabella U_LEG_CM.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'U_LEG_CM1')
   drop index U_LEG_CM.U_LEG_CM1
GO 
if exists (select name from dbo.sysindexes where name = 'U_LEG_CM2')
   drop index U_LEG_CM.U_LEG_CM2
GO 
if exists (select name from dbo.sysindexes where name = 'U_LEG_CM3')
   drop index U_LEG_CM.U_LEG_CM3
GO 
CREATE INDEX [U_LEG_CM1] ON [dbo].[U_LEG_CM]([LEG_CODCES]) ON [PRIMARY]
GO 
CREATE INDEX [U_LEG_CM2] ON [dbo].[U_LEG_CM]([LEG_ANNO], [LEG_NREGIS], [LEG_NUMPRO]) ON [PRIMARY]
GO 
CREATE INDEX [U_LEG_CM3] ON [dbo].[U_LEG_CM]([LEG_CODCES], [LEG_ANNO], [LEG_NREGIS], [LEG_NUMPRO]) ON [PRIMARY]
GO 
