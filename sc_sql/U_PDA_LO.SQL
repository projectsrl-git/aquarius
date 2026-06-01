if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_PDA_LO]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_PDA_LO]
GO
 
CREATE TABLE [dbo].[U_PDA_LO] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[PDA_CODMAG] [varchar] (6) COLLATE Latin1_General_CI_AS NULL ,
	[PDA_DESMAG] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[PDA_DATINV] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PDA_ORAINV] [varchar] (8) COLLATE Latin1_General_CI_AS NULL ,
	[PDA_CODOPE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PDA_DESOPE] [varchar] (50) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_PDA_LO] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_PDA_LO] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_PDA_LO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDA_LO_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_PDA_LO_PDA_CODMAG] DEFAULT ('') FOR [PDA_CODMAG],
	CONSTRAINT [DF_U_PDA_LO_PDA_DESMAG] DEFAULT ('') FOR [PDA_DESMAG],
	CONSTRAINT [DF_U_PDA_LO_PDA_DATINV] DEFAULT ('') FOR [PDA_DATINV],
	CONSTRAINT [DF_U_PDA_LO_PDA_ORAINV] DEFAULT ('') FOR [PDA_ORAINV],
	CONSTRAINT [DF_U_PDA_LO_PDA_CODOPE] DEFAULT ('') FOR [PDA_CODOPE],
	CONSTRAINT [DF_U_PDA_LO_PDA_DESOPE] DEFAULT ('') FOR [PDA_DESOPE]
GO

