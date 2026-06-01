if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[part_cli_ea]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[part_cli_ea]
GO
 
CREATE TABLE [dbo].[part_cli_ea] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DAGGANCIO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[SYS_PARTI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_ANNO] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_NUMPRO] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_NREG] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_DTREG] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_NPART] [numeric] (10,0) NULL ,
	[PAR_DTFAT] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_NUMFAT] [varchar] (6) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_FATT] [numeric] (17,3) NULL ,
	[PAR_DTSCAD] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_CODCLI] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_RAGSOC] [varchar] (40) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[part_cli_ea] WITH NOCHECK ADD 
	CONSTRAINT [PK_part_cli_ea] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[part_cli_ea] WITH NOCHECK ADD 
	CONSTRAINT [DF_part_cli_ea_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_part_cli_ea_DAGGANCIO] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_part_cli_ea_SYS_PARTI] DEFAULT ('') FOR [SYS_PARTI],
	CONSTRAINT [DF_part_cli_ea_PAR_CODSOC] DEFAULT ('') FOR [PAR_CODSOC],
	CONSTRAINT [DF_part_cli_ea_PAR_ANNO] DEFAULT ('') FOR [PAR_ANNO],
	CONSTRAINT [DF_part_cli_ea_PAR_NUMPRO] DEFAULT ('') FOR [PAR_NUMPRO],
	CONSTRAINT [DF_part_cli_ea_PAR_NREG] DEFAULT ('') FOR [PAR_NREG],
	CONSTRAINT [DF_part_cli_ea_PAR_DTREG] DEFAULT ('') FOR [PAR_DTREG],
	CONSTRAINT [DF_part_cli_ea_PAR_NPART] DEFAULT (0) FOR [PAR_NPART],
	CONSTRAINT [DF_part_cli_ea_PAR_DTFAT] DEFAULT ('') FOR [PAR_DTFAT],
	CONSTRAINT [DF_part_cli_ea_PAR_NUMFAT] DEFAULT ('') FOR [PAR_NUMFAT],
	CONSTRAINT [DF_part_cli_ea_PAR_FATT] DEFAULT (0) FOR [PAR_FATT],
	CONSTRAINT [DF_part_cli_ea_PAR_DTSCAD] DEFAULT ('') FOR [PAR_DTSCAD],
	CONSTRAINT [DF_part_cli_ea_PAR_CODCLI] DEFAULT ('') FOR [PAR_CODCLI],
	CONSTRAINT [DF_part_cli_ea_PAR_RAGSOC] DEFAULT ('') FOR [PAR_RAGSOC]


GO

