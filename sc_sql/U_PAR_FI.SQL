if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_PAR_FI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_PAR_FI]
GO
 
CREATE TABLE [dbo].[U_PAR_FI] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
        [PAR_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_CODICE] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_DESCRI] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_MAXORE] [numeric] (6,2) NULL ,
	[PAR_PERSPE] [numeric] (5,2) NULL ,
	[PAR_PERALT] [numeric] (5,2) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_PAR_FI] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_PAR_FI] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_PAR_FI] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PAR_FI_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_PAR_FI_PAR_CODSOC] DEFAULT ('') FOR [PAR_CODSOC],
	CONSTRAINT [DF_U_PAR_FI_PAR_CODICE] DEFAULT ('') FOR [PAR_CODICE],
	CONSTRAINT [DF_U_PAR_FI_PAR_DESCRI] DEFAULT ('') FOR [PAR_DESCRI],
	CONSTRAINT [DF_U_PAR_FI_PAR_MAXORE] DEFAULT (0) FOR [PAR_MAXORE],
	CONSTRAINT [DF_U_PAR_FI_PAR_PERSPE] DEFAULT (0) FOR [PAR_PERSPE],
	CONSTRAINT [DF_U_PAR_FI_PAR_PERALT] DEFAULT (0) FOR [PAR_PERALT]
GO

 
 
 
 
 
