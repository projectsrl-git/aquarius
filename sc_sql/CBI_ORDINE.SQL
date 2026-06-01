if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBI_ORDINE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CBI_ORDINE]
GO
 
CREATE TABLE [dbo].[CBI_ORDINE] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[SUP_LOGICO] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[TIPORECORD] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[ORDINE] [numeric] (2,0) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CBI_ORDINE] WITH NOCHECK ADD 
	CONSTRAINT [PK_CBI_ORDINE] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CBI_ORDINE] WITH NOCHECK ADD 
	CONSTRAINT [DF_CBI_ORDINE_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_CBI_ORDINE_SUP_LOGICO] DEFAULT ('') FOR [SUP_LOGICO],
	CONSTRAINT [DF_CBI_ORDINE_TIPORECORD] DEFAULT ('') FOR [TIPORECORD],
	CONSTRAINT [DF_CBI_ORDINE_ORDINE] DEFAULT (0) FOR [ORDINE]
GO

