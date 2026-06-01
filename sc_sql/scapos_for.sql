if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[scapos_for]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[scapos_for]
GO
 
CREATE TABLE [dbo].[scapos_for] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[PAR_CODCLI] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_RAGSOC] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_NPART] [numeric] (14,0) NULL ,
	[PAR_DTPOST] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_DTSCAD] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[NEW_DTSCAD] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_MOTIVO] [varchar] (80) COLLATE Latin1_General_CI_AS NULL ,
	[PAR_NOMOPE] [varchar] (20) COLLATE Latin1_General_CI_AS NULL 

) ON [PRIMARY]
GO

ALTER TABLE [dbo].[scapos_for] WITH NOCHECK ADD 
	CONSTRAINT [PK_scapos_for] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[scapos_for] WITH NOCHECK ADD 
	CONSTRAINT [DF_scapos_for_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_scapos_for_PAR_CODCLI] DEFAULT ('') FOR [PAR_CODCLI],
	CONSTRAINT [DF_scapos_for_PAR_RAGSOC] DEFAULT ('') FOR [PAR_RAGSOC],
	CONSTRAINT [DF_scapos_for_PAR_NPART] DEFAULT (0) FOR [PAR_NPART],
	CONSTRAINT [DF_scapos_for_PAR_DTPOST] DEFAULT ('') FOR [PAR_DTPOST],
	CONSTRAINT [DF_scapos_for_PAR_DTSCAD] DEFAULT ('') FOR [PAR_DTSCAD],
	CONSTRAINT [DF_scapos_for_NEW_DTSCAD] DEFAULT ('') FOR [NEW_DTSCAD],
	CONSTRAINT [DF_scapos_for_PAR_MOTIVO] DEFAULT ('') FOR [PAR_MOTIVO],
	CONSTRAINT [DF_scapos_for_PAR_NOMOPE] DEFAULT ('') FOR [PAR_NOMOPE]

GO

UPDATE scapos_for SET PAR_RAGSOC = ' ' 

