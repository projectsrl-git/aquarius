if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[res_proc]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[res_proc]
GO
 
CREATE TABLE [dbo].[res_proc] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[UTENTE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PROCEDURA] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[INSERIMENT] [bit] NULL ,
	[CANCELLAZI] [bit] NULL ,
	[MODIFICA] [bit] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[res_proc] WITH NOCHECK ADD 
	CONSTRAINT [PK_res_proc] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[res_proc] WITH NOCHECK ADD 
	CONSTRAINT [DF_res_proc_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_res_proc_UTENTE] DEFAULT ('') FOR [UTENTE],
	CONSTRAINT [DF_res_proc_PROCEDURA] DEFAULT ('') FOR [PROCEDURA],
	CONSTRAINT [DF_res_proc_INSERIMENT] DEFAULT (0) FOR [INSERIMENT],
	CONSTRAINT [DF_res_proc_CANCELLAZI] DEFAULT (0) FOR [CANCELLAZI],
	CONSTRAINT [DF_res_proc_MODIFICA] DEFAULT (0) FOR [MODIFICA]
GO

