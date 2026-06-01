if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[log_user]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[log_user]
GO
 
CREATE TABLE [dbo].[log_user] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[OPERATORE] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[DESCRI] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[DATA] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[ORA] [varchar] (8) COLLATE Latin1_General_CI_AS NULL ,
	[OPERAZIONE] [varchar] (100) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[log_user] WITH NOCHECK ADD 
	CONSTRAINT [PK_log_user] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[log_user] WITH NOCHECK ADD 
	CONSTRAINT [DF_log_user_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_log_user_OPERATORE] DEFAULT ('') FOR [OPERATORE],
	CONSTRAINT [DF_log_user_DESCRI] DEFAULT ('') FOR [DESCRI],
	CONSTRAINT [DF_log_user_DATA] DEFAULT ('') FOR [DATA],
	CONSTRAINT [DF_log_user_ORA] DEFAULT ('') FOR [ORA],
	CONSTRAINT [DF_log_user_OPERAZIONE] DEFAULT ('') FOR [OPERAZIONE]
GO

