if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_LOG_RX]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_LOG_RX]
GO
 
CREATE TABLE [dbo].[U_LOG_RX] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[LOG_DTTRAS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LOG_ORTRAS] [varchar] (8) COLLATE Latin1_General_CI_AS NULL ,
	[LOG_ELENCO] [text] COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_LOG_RX] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_LOG_RX] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_LOG_RX] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LOG_RX_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_LOG_RX_LOG_DTTRAS] DEFAULT ('') FOR [LOG_DTTRAS],
	CONSTRAINT [DF_U_LOG_RX_LOG_ORTRAS] DEFAULT ('') FOR [LOG_ORTRAS],
	CONSTRAINT [DF_U_LOG_RX_LOG_ELENCO] DEFAULT ('') FOR [LOG_ELENCO]
GO

