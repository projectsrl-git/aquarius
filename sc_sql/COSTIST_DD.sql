if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COSTIST_DD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[COSTIST_DD]
GO
 
CREATE TABLE [dbo].[COSTIST_DD] (
	id_unique uniqueidentifier ROWGUIDCOL NOT NULL ,
	DAGGANCIO varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	IDCOSTO varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	Sequen numeric(10,0) NULL ,
	CodAttiv varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	DesAttiv varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	CodCli varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	RagSoc varchar(80) COLLATE Latin1_General_CI_AS NULL ,
	UMCosto varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	Costo numeric(17,2) NULL ,
	Annotazioni text NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[COSTIST_DD] WITH NOCHECK ADD 
	CONSTRAINT [PK_COSTIST_DD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COSTIST_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_COSTIST_DD_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_COSTIST_DD_DAGGANCIO] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_COSTIST_DD_IDCOSTO] DEFAULT ('') FOR [IDCOSTO],
	CONSTRAINT [DF_COSTIST_DD_Sequen] DEFAULT (0) FOR [Sequen],
	CONSTRAINT [DF_COSTIST_DD_CodAttiv] DEFAULT ('') FOR [CodAttiv],
	CONSTRAINT [DF_COSTIST_DD_DesAttiv] DEFAULT ('') FOR [DesAttiv],
	CONSTRAINT [DF_COSTIST_DD_CodCli] DEFAULT ('') FOR [CodCli],
	CONSTRAINT [DF_COSTIST_DD_RagSoc] DEFAULT ('') FOR [RagSoc],
	CONSTRAINT [DF_COSTIST_DD_UMCosto] DEFAULT ('') FOR [UMCosto],
	CONSTRAINT [DF_COSTIST_DD_Costo] DEFAULT (0) FOR [Costo],
	CONSTRAINT [DF_COSTIST_DD_Annotazioni] DEFAULT ('') FOR [Annotazioni]
GO

