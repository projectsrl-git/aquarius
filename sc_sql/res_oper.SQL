if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[res_oper]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[res_oper]
GO
 
CREATE TABLE [dbo].[res_oper] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CODICE] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[DESCRI] [varchar] (25) COLLATE Latin1_General_CI_AS NULL ,
	[PASSWORD] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[IN_USO] [bit] NULL ,
	[FILE_UNICO] [varchar] (8) COLLATE Latin1_General_CI_AS NULL ,
	[SOCIETA] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PROCEDURA] [varchar] (25) COLLATE Latin1_General_CI_AS NULL ,
	[NO_PREZZI] [bit] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[res_oper] WITH NOCHECK ADD 
	CONSTRAINT [PK_res_oper] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[res_oper] WITH NOCHECK ADD 
	CONSTRAINT [DF_res_oper_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_res_oper_CODICE] DEFAULT ('') FOR [CODICE],
	CONSTRAINT [DF_res_oper_DESCRI] DEFAULT ('') FOR [DESCRI],
	CONSTRAINT [DF_res_oper_PASSWORD] DEFAULT ('') FOR [PASSWORD],
	CONSTRAINT [DF_res_oper_IN_USO] DEFAULT (0) FOR [IN_USO],
	CONSTRAINT [DF_res_oper_FILE_UNICO] DEFAULT ('') FOR [FILE_UNICO],
	CONSTRAINT [DF_res_oper_SOCIETA] DEFAULT ('') FOR [SOCIETA],
	CONSTRAINT [DF_res_oper_PROCEDURA] DEFAULT ('') FOR [PROCEDURA],
	CONSTRAINT [DF_res_oper_NO_PREZZI] DEFAULT (0) FOR [NO_PREZZI]
GO

