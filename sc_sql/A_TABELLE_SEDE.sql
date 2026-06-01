if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_ASS_DD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_ASS_DD]
GO
 
CREATE TABLE [dbo].[U_ASS_DD] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_U_ASS_DD_id_unique] DEFAULT (newid()),
	[DAGGANCIO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_DAGGANCIO] DEFAULT (''),
	[ASS_CODFOR] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_CODFOR] DEFAULT (''),
	[ASS_DESFOR] [varchar] (40) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_DESFOR] DEFAULT (''),
	[ASS_NUMASS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_NUMASS] DEFAULT (''),
	[ASS_DESEFF] [varchar] (20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_DESEFF] DEFAULT (''),
	[ASS_DESINT] [varchar] (20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_DESINT] DEFAULT (''),
	[ASS_STATUS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_STATUS] DEFAULT (''),
	[ASS_DTVERS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_DTVERS] DEFAULT (''),
	[ASS_DTRISC] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_DTRISC] DEFAULT (''),
	[ASS_DESBAN] [varchar] (30) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_DESBAN] DEFAULT (''),
	[ASS_CODBA1] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_CODBA1] DEFAULT (''),
	[ASS_CODBA2] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_CODBA2] DEFAULT (''),
	[ASS_CODBA3] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_CODBA3] DEFAULT (''),
	[ASS_NUMCC] [varchar] (15) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_NUMCC] DEFAULT (''),
	[ASS_INTCC] [varchar] (15) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_INTCC] DEFAULT (''),
	[ASS_IMPTOT] [numeric](12, 2) NULL CONSTRAINT [DF_U_ASS_DD_ASS_IMPTOT] DEFAULT (0),
	[ASS_NREGIS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_NREGIS] DEFAULT (''),
	[ASS_DTREGI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_DTREGI] DEFAULT (''),
	[ASS_NUMPRO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ASS_DD_ASS_NUMPRO] DEFAULT (''),
	[ASS_IMPREG] [numeric](12, 2) NULL CONSTRAINT [DF_U_ASS_DD_ASS_IMPREG] DEFAULT (0),	
	CONSTRAINT [PK_U_ASS_DD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ART_PR] ADD 
	 ART_CODPAC varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 ART_DESPAC varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 ART_TIPCOM varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 ART_DESCOM varchar(30) COLLATE Latin1_General_CI_AS NULL,
	 ART_SERNUM varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 ART_NOTCOM varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 ART_FLGMOD varchar(01) COLLATE Latin1_General_CI_AS NULL,
	 ART_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ART_FLGMIM [bit] NULL,
	 ART_CODOPE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ART_DESOPE varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_CODPAC] DEFAULT ('') FOR [ART_CODPAC],
	CONSTRAINT [DF_U_ART_PR_ART_DESPAC] DEFAULT ('') FOR [ART_DESPAC],
	CONSTRAINT [DF_U_ART_PR_ART_TIPCOM] DEFAULT ('') FOR [ART_TIPCOM],
	CONSTRAINT [DF_U_ART_PR_ART_DESCOM] DEFAULT ('') FOR [ART_DESCOM],
	CONSTRAINT [DF_U_ART_PR_ART_SERNUM] DEFAULT ('') FOR [ART_SERNUM],
	CONSTRAINT [DF_U_ART_PR_ART_NOTCOM] DEFAULT ('') FOR [ART_NOTCOM],
	CONSTRAINT [DF_U_ART_PR_ART_FLGMOD] DEFAULT ('') FOR [ART_FLGMOD],
	CONSTRAINT [DF_U_ART_PR_ART_LEGSYS] DEFAULT ('') FOR [ART_LEGSYS],
	CONSTRAINT [DF_U_ART_PR_ART_FLGMIM] DEFAULT (0) FOR [ART_FLGMIM],
	CONSTRAINT [DF_U_ART_PR_ART_CODOPE] DEFAULT ('') FOR [ART_CODOPE],
	CONSTRAINT [DF_U_ART_PR_ART_DESOPE] DEFAULT ('') FOR [ART_DESOPE]
go

UPDATE U_ART_PR SET ART_CODPAC = SPACE(16)
UPDATE U_ART_PR SET ART_DESPAC = SPACE(50)
UPDATE U_ART_PR SET ART_TIPCOM = SPACE(03)
UPDATE U_ART_PR SET ART_DESCOM = SPACE(30)
UPDATE U_ART_PR SET ART_SERNUM = SPACE(50)
UPDATE U_ART_PR SET ART_NOTCOM = SPACE(50)
UPDATE U_ART_PR SET ART_FLGMOD = SPACE(01)
UPDATE U_ART_PR SET ART_LEGSYS = SPACE(10)
UPDATE U_ART_PR SET ART_FLGMIM = 0
UPDATE U_ART_PR SET ART_CODOPE = SPACE(10)
UPDATE U_ART_PR SET ART_DESOPE = SPACE(50)
UPDATE U_ART_PR SET ART_FLGTRA = 1


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_CODOPE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_NOMOPE varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_CODOPE] DEFAULT ('') FOR [MOV_CODOPE],
	CONSTRAINT [DF_U_MAG_MO_MOV_NOMOPE] DEFAULT ('') FOR [MOV_NOMOPE]
go

UPDATE U_MAG_MO SET MOV_CODOPE = SPACE(10)
UPDATE U_MAG_MO SET MOV_NOMOPE = SPACE(50)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_CA] ADD 
	 MOV_CODOPE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_NOMOPE varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CA_MOV_CODOPE] DEFAULT ('') FOR [MOV_CODOPE],
	CONSTRAINT [DF_U_MAG_CA_MOV_NOMOPE] DEFAULT ('') FOR [MOV_NOMOPE]
go

UPDATE U_MAG_CA SET MOV_CODOPE = SPACE(10)
UPDATE U_MAG_CA SET MOV_NOMOPE = SPACE(50)

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[INDICE] ADD 
	 MOV_NPARTO numeric(10,0) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_NPARTO] DEFAULT ('0') FOR [MOV_NPARTO]
go

UPDATE INDICE SET MOV_NPARTO = 0


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[INDICE] ADD 
	 	 MOV_DATSCAD varchar(10) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_CONT] DEFAULT ('0') FOR [MOV_DATSCAD]
go

UPDATE INDICE SET MOV_DATSCAD = '          '

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
CREATE INDEX [U_ART_09] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_CATMER], [ART_GRUEDI], [ART_EDITOR], [ART_COLLAN]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_10] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_GRUEDI], [ART_EDITOR], [ART_COLLAN]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_11] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_EDITOR], [ART_COLLAN]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_12] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_COLLAN]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_13] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_SCORMI]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_14] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_ULDSCA], [ART_ULDCAR]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_15] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_FLGMIM], [ART_CODPAC]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_16] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_FLGMIM], [ART_DESPAC]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_17] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_FLGMIM], [ART_SERNUM]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_18] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_FLGMIM], [ART_TIPCOM]) ON [PRIMARY]
GO
CREATE INDEX [U_ART_19] ON [dbo].[U_ART_PR]([ART_FLGTRA]) ON [PRIMARY]
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

CREATE INDEX [U_MAG_G1] ON [dbo].[U_MAG_GG]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO]) ON [PRIMARY]
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

CREATE INDEX [U_MAG_G1] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_DATAGG], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT], [MAG_CODACQ], [MAG_PRZCON], [MAG_NUMIDE], [MAG_CODBUN], [MAG_ANNO]) ON [PRIMARY]
GO
CREATE INDEX [U_MAG_G2] ON [dbo].[U_MAG_DA]([MAG_CODSOC], [MAG_CODART], [MAG_CODMAG], [MAG_FORNIT],  [MAG_DATAGG]) ON [PRIMARY]
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

UPDATE U_FOR_AN SET FOR_FLGTRA = 1
UPDATE U_CLI_AN SET CLI_FLGTRA = 1


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
