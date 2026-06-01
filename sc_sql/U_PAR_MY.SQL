if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_PAR_MY]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_PAR_MY]
GO
 
CREATE TABLE [dbo].[U_PAR_MY] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
        [PAR_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_CODSPE] [numeric] (3,0) NULL ,
	[PAR_PRSCDA] [numeric] (3,0) NULL ,
	[PAR_PRSCAL] [numeric] (3,0) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_PAR_MY] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_PAR_MY] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_PAR_MY] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PAR_MY_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_PAR_MY_PAR_CODSOC] DEFAULT ('') FOR [PAR_CODSOC],
	CONSTRAINT [DF_U_PAR_MY_PAR_CODSPE] DEFAULT (0) FOR [PAR_CODSPE],
	CONSTRAINT [DF_U_PAR_MY_PAR_PRSCDA] DEFAULT (0) FOR [PAR_PRSCDA],
	CONSTRAINT [DF_U_PAR_MY_PAR_PRSCAL] DEFAULT (0) FOR [PAR_PRSCAL]
GO

 
 
 
 
 
