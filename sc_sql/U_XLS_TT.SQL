if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_XLS_TT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_XLS_TT]
GO

CREATE TABLE [dbo].[U_XLS_TT] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[XLS_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[TAGGANCIO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[XLS_CODICE] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[XLS_DESCRI] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[XLS_ORDINE] [numeric](9, 0) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_XLS_TT] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_XLS_TT] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_XLS_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_XLS_TT_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_XLS_TT_XLS_CODSOC] DEFAULT ('') FOR [XLS_CODSOC],
	CONSTRAINT [DF_U_XLS_TT_TAGGANCIO] DEFAULT ('') FOR [TAGGANCIO],
	CONSTRAINT [DF_U_XLS_TT_XLS_CODICE] DEFAULT ('') FOR [XLS_CODICE],
	CONSTRAINT [DF_U_XLS_TT_XLS_DESCRI] DEFAULT ('') FOR [XLS_DESCRI],
	CONSTRAINT [DF_U_XLS_TT_XLS_ORDINE] DEFAULT (0) FOR [XLS_ORDINE]
GO

 CREATE  INDEX [IX_U_XLS_TT] ON [dbo].[U_XLS_TT]([XLS_CODSOC], [XLS_CODICE]) ON [PRIMARY]
GO

