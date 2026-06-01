if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_CAS_DD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_CAS_DD]
GO
 
CREATE TABLE [dbo].[U_CAS_DD] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CAS_MATRIC] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[CAS_COGNOM] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[CAS_NOME] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[CAS_CODLOC] [varchar] (03) COLLATE Latin1_General_CI_AS NULL ,
	[CAS_DESLOC] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_CAS_DD] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_CAS_DD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_CAS_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CAS_DD_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_CAS_DD_CAS_MATRIC] DEFAULT ('') FOR [CAS_MATRIC],
	CONSTRAINT [DF_U_CAS_DD_CAS_COGNOM] DEFAULT ('') FOR [CAS_COGNOM],
	CONSTRAINT [DF_U_CAS_DD_CAS_NOME] DEFAULT ('') FOR [CAS_NOME],
	CONSTRAINT [DF_U_CAS_DD_CAS_CODLOC] DEFAULT ('') FOR [CAS_CODLOC],
	CONSTRAINT [DF_U_CAS_DD_CAS_DESLOC] DEFAULT ('') FOR [CAS_DESLOC]
GO

