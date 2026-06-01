if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_prg_cl]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_prg_cl]
GO
 
CREATE TABLE [dbo].[u_prg_cl] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[PRG_TIPO] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[PRG_CODSYS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PRG_CODCLI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PRG_RAGSOC] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[PRG_UNIQUE] [varchar] (36) COLLATE Latin1_General_CI_AS NULL ,
	[PRG_BOBPRG] [numeric] (10,0) NULL ,
	[PRG_QTAPRG] [numeric] (18,2) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_prg_cl] WITH NOCHECK ADD 
	CONSTRAINT [PK_u_prg_cl] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[u_prg_cl] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_prg_cl_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_prg_cl_PRG_TIPO] DEFAULT ('') FOR [PRG_TIPO],
	CONSTRAINT [DF_u_prg_cl_PRG_CODSYS] DEFAULT ('') FOR [PRG_CODSYS],
	CONSTRAINT [DF_u_prg_cl_PRG_CODCLI] DEFAULT ('') FOR [PRG_CODCLI],
	CONSTRAINT [DF_u_prg_cl_PRG_RAGSOC] DEFAULT ('') FOR [PRG_RAGSOC],
	CONSTRAINT [DF_u_prg_cl_PRG_UNIQUE] DEFAULT ('') FOR [PRG_UNIQUE],
	CONSTRAINT [DF_u_prg_cl_PRG_BOBPRG] DEFAULT (0) FOR [PRG_BOBPRG],
	CONSTRAINT [DF_u_prg_cl_PRG_QTAPRG] DEFAULT (0) FOR [PRG_QTAPRG]
GO

