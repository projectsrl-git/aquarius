if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_PER_PD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_PER_PD]
GO
 
CREATE TABLE [dbo].[U_PER_PD] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[PED_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PED_CODICE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PED_RAGSOC] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[PED_CODPDV] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PED_DESPDV] [varchar] (50) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_PER_PD] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_PER_PD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_PER_PD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PER_PD_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_PER_PD_PED_CODSOC] DEFAULT ('') FOR [PED_CODSOC],
	CONSTRAINT [DF_U_PER_PD_PED_CODICE] DEFAULT ('') FOR [PED_CODICE],
	CONSTRAINT [DF_U_PER_PD_PED_RAGSOC] DEFAULT ('') FOR [PED_RAGSOC],
	CONSTRAINT [DF_U_PER_PD_PED_CODPDV] DEFAULT ('') FOR [PED_CODPDV],
	CONSTRAINT [DF_U_PER_PD_PED_DESPDV] DEFAULT ('') FOR [PED_DESPDV]
GO

