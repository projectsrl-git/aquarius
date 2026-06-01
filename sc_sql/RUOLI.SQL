if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UTENTIXRUOLI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[UTENTIXRUOLI]
GO
 
CREATE TABLE [dbo].[UTENTIXRUOLI] (
	[id_unique] uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[USERID] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[RUOLO] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UTENTIXRUOLI] WITH NOCHECK ADD 
	CONSTRAINT [PK_UTENTIXRUOLI] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[UTENTIXRUOLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_UTENTIXRUOLI_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_UTENTIXRUOLI_USERID] DEFAULT ('') FOR [USERID],
	CONSTRAINT [DF_UTENTIXRUOLI_RUOLO] DEFAULT ('') FOR [RUOLO]
GO

