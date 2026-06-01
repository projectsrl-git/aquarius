if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[res_oper_conf]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[res_oper_conf]
GO
 
CREATE TABLE [dbo].[res_oper_conf] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[OPE_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[OPE_CODICE] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[OPE_DESCRI] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[OPE_BLKPRZ] [bit] NULL ,
	[OPE_NOVPRZ] [bit] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[res_oper_conf] WITH NOCHECK ADD 
	CONSTRAINT [PK_res_oper_conf] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[res_oper_conf] WITH NOCHECK ADD 
	CONSTRAINT [DF_res_oper_conf_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_res_oper_conf_OPE_CODSOC] DEFAULT ('') FOR [OPE_CODSOC],
	CONSTRAINT [DF_res_oper_conf_OPE_CODICE] DEFAULT ('') FOR [OPE_CODICE],
	CONSTRAINT [DF_res_oper_conf_OPE_DESCRI] DEFAULT ('') FOR [OPE_DESCRI],
	CONSTRAINT [DF_res_oper_conf_OPE_BLKPRZ] DEFAULT (0) FOR [OPE_BLKPRZ],
	CONSTRAINT [DF_res_oper_conf_OPE_NOVPRZ] DEFAULT (0) FOR [OPE_NOVPRZ]
GO

