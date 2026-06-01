if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_log_tl]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_log_tl]
GO
 
CREATE TABLE [dbo].[u_log_tl] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[LOG_CODPDV] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[LOG_DATINS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LOG_ORAINS] [varchar] (8) COLLATE Latin1_General_CI_AS NULL ,
	[LOG_AUTH] [varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[LOG_RICH] [varchar] (30) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_log_tl] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_log_tl_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_log_tl_LOG_CODPDV] DEFAULT ('') FOR [LOG_CODPDV],
	CONSTRAINT [DF_u_log_tl_LOG_DATINS] DEFAULT ('') FOR [LOG_DATINS],
	CONSTRAINT [DF_u_log_tl_LOG_ORAINS] DEFAULT ('') FOR [LOG_ORAINS],
	CONSTRAINT [DF_u_log_tl_LOG_AUTH] DEFAULT ('') FOR [LOG_AUTH],
	CONSTRAINT [DF_u_log_tl_LOG_RICH] DEFAULT ('') FOR [LOG_RICH]
GO

