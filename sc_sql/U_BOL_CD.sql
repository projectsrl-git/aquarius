if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_BOL_CD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_BOL_CD]
GO
 
CREATE TABLE [dbo].[U_BOL_CD] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_U_BOL_CD_id_unique] DEFAULT (newid()),
	[DAGGANCIO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_BOL_CD_DAGGANCIO] DEFAULT (''),
	[CLDOG] [varchar] (16) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_BOL_CD_CLDOG] DEFAULT (''),
	[PESO_NETTO] [numeric] (12,2) NULL CONSTRAINT [DF_U_BOL_CD_PESO_NETTO] DEFAULT (''),
	[PESO_LORDO] [numeric] (12,2) NULL CONSTRAINT [DF_U_BOL_CD_PESO_LORDO] DEFAULT ('')
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_BOL_CD] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_BOL_CD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
