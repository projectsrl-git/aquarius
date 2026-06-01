if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_LOG_TX]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_LOG_TX]
GO
 
CREATE TABLE [dbo].[U_LOG_TX] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[LOG_DTTRAS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LOG_ORTRAS] [varchar] (8) COLLATE Latin1_General_CI_AS NULL ,
	[LOG_ELENCO] [text] COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_LOG_TX] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_LOG_TX] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_LOG_TX] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LOG_TX_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_LOG_TX_LOG_DTTRAS] DEFAULT ('') FOR [LOG_DTTRAS],
	CONSTRAINT [DF_U_LOG_TX_LOG_ORTRAS] DEFAULT ('') FOR [LOG_ORTRAS],
	CONSTRAINT [DF_U_LOG_TX_LOG_ELENCO] DEFAULT ('') FOR [LOG_ELENCO]
GO

