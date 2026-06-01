
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_CLI_AR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_CLI_AR]
GO
    
CREATE TABLE [dbo].[U_CLI_AR] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CODSYS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CODCLI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[RAGSOC] [varchar] (80) COLLATE Latin1_General_CI_AS NULL ,
	[TIPDOC] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[DESART] [varchar] (200) COLLATE Latin1_General_CI_AS NULL ,
	[UM] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[QTA] [numeric] (12,4) NULL ,
	[PREZZO] [numeric] (12,6) NULL ,
	[CODIVA] [varchar] (3) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_CLI_AR] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_CLI_AR] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_CLI_AR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AR_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_CLI_AR_CODSYS] DEFAULT ('') FOR [CODSYS],	
	CONSTRAINT [DF_U_CLI_AR_CODCLI] DEFAULT ('') FOR [CODCLI],
	CONSTRAINT [DF_U_CLI_AR_RAGSOC] DEFAULT ('') FOR [RAGSOC],
	CONSTRAINT [DF_U_CLI_AR_TIPDOC] DEFAULT ('') FOR [TIPDOC],
	CONSTRAINT [DF_U_CLI_AR_CODART] DEFAULT ('') FOR [CODART],
	CONSTRAINT [DF_U_CLI_AR_DESART] DEFAULT ('') FOR [DESART],
	CONSTRAINT [DF_U_CLI_AR_UM] DEFAULT ('') FOR [UM],
	CONSTRAINT [DF_U_CLI_AR_QTA] DEFAULT (0) FOR [QTA],
	CONSTRAINT [DF_U_CLI_AR_PREZZO] DEFAULT (0) FOR [PREZZO],
	CONSTRAINT [DF_U_CLI_AR_CODIVA] DEFAULT ('') FOR [CODIVA]
GO
