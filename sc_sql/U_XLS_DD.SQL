if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_XLS_DD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_XLS_DD]
GO

CREATE TABLE [dbo].[U_XLS_DD] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DAGGANCIO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[XLS_CONTO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[XLS_DESCON] [varchar] (40) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_XLS_DD] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_XLS_DD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_XLS_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_XLS_DD_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_XLS_DD_DAGGANCIO] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_U_XLS_DD_XLS_CONTO] DEFAULT ('') FOR [XLS_CONTO],
	CONSTRAINT [DF_U_XLS_DD_XLS_DESCON] DEFAULT ('') FOR [XLS_DESCON]
GO

 CREATE  INDEX [IX_U_XLS_DD] ON [dbo].[U_XLS_DD]([DAGGANCIO]) ON [PRIMARY]
GO

