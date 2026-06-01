if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Ultima_Colata_DB]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[Ultima_Colata_DB]
GO
 
CREATE TABLE [dbo].[Ultima_Colata_DB] (
	[id_unique] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_Ultima_Colata_DB_id_unique] DEFAULT (newid()),
	[VarName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_Ultima_Colata_DB_VarName] DEFAULT (''),
	[TimeString] [varchar] (20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_Ultima_Colata_DB_TimeString] DEFAULT (''),
	[VarValue] [varchar] (20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_Ultima_Colata_DB_VarValue] DEFAULT (''),
	[Validity] [varchar] (20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_Ultima_Colata_DB_Validity] DEFAULT (''),
	[Time_ms] [varchar] (20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_Ultima_Colata_DB_Time_ms] DEFAULT ('')
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Ultima_Colata_DB] WITH NOCHECK ADD 
	CONSTRAINT [PK_Ultima_Colata_DB] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
