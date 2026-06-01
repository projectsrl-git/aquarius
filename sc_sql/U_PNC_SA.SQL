if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_PNC_SA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_PNC_SA]
GO
 
CREATE TABLE [dbo].[U_PNC_SA] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[PNC_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PNC_MESE] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PNC_ANNO] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[PNC_VALORE] [numeric] (15,2) NULL ,
	[PNC_DATREG] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PNC_ORAREG] [varchar] (5) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_PNC_SA] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_PNC_SA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_PNC_SA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PNC_SA_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_PNC_SA_PNC_CODSOC] DEFAULT ('') FOR [PNC_CODSOC],
	CONSTRAINT [DF_U_PNC_SA_PNC_MESE] DEFAULT ('') FOR [PNC_MESE],
	CONSTRAINT [DF_U_PNC_SA_PNC_ANNO] DEFAULT ('') FOR [PNC_ANNO],
	CONSTRAINT [DF_U_PNC_SA_PNC_VALORE] DEFAULT (0) FOR [PNC_VALORE],
	CONSTRAINT [DF_U_PNC_SA_PNC_DATREG] DEFAULT ('') FOR [PNC_DATREG],
	CONSTRAINT [DF_U_PNC_SA_PNC_ORAREG] DEFAULT ('') FOR [PNC_ORAREG]
GO

