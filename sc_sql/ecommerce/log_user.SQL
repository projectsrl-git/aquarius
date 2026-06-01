if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOG_UTENTI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LOG_UTENTI]
GO
  
CREATE TABLE [dbo].[LOG_UTENTI] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[OPERATORE] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[DESCRI] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[DATA] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[ORA] [varchar] (8) COLLATE Latin1_General_CI_AS NULL ,
	[OPERAZIONE] [varchar] (100) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[LOG_UTENTI] WITH NOCHECK ADD 
	CONSTRAINT [PK_LOG_UTENTI] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LOG_UTENTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_LOG_UTENTI_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_LOG_UTENTI_OPERATORE] DEFAULT ('') FOR [OPERATORE],
	CONSTRAINT [DF_LOG_UTENTI_DESCRI] DEFAULT ('') FOR [DESCRI],
	CONSTRAINT [DF_LOG_UTENTI_DATA] DEFAULT ('') FOR [DATA],
	CONSTRAINT [DF_LOG_UTENTI_ORA] DEFAULT ('') FOR [ORA],
	CONSTRAINT [DF_LOG_UTENTI_OPERAZIONE] DEFAULT ('') FOR [OPERAZIONE]
GO

