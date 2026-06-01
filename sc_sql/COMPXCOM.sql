if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMPXCOM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[COMPXCOM]
GO
 
CREATE TABLE [dbo].[COMPXCOM] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCompXCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCommessaD varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	CodComp varchar(03) COLLATE Latin1_General_CI_AS NULL ,
	DsComp varchar(60) COLLATE Latin1_General_CI_AS NULL ,
	B_chiuso bit NULL,
	Sequen numeric(10,0) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[COMPXCOM] WITH NOCHECK ADD 
	CONSTRAINT [PK_COMPXCOM] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COMPXCOM] WITH NOCHECK ADD 
	CONSTRAINT [DF_COMPXCOM_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_COMPXCOM_IDCompXCom] DEFAULT ('') FOR [IDCompXCom],
	CONSTRAINT [DF_COMPXCOM_IDCommessaD] DEFAULT ('') FOR [IDCommessaD],
	CONSTRAINT [DF_COMPXCOM_CodComp] DEFAULT ('') FOR [CodComp],
	CONSTRAINT [DF_COMPXCOM_DsComp] DEFAULT ('') FOR [DsComp],
	CONSTRAINT [DF_COMPXCOM_B_chiuso] DEFAULT (0) FOR [B_chiuso],
	CONSTRAINT [DF_COMPXCOM_Sequen] DEFAULT (0) FOR [Sequen]
GO

