if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_CMP_TT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_CMP_TT]
GO
 
CREATE TABLE [dbo].[U_CMP_TT] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_U_CMP_TT_id_unique] DEFAULT (newid()),
	[CMP_ID]  [varchar] (13) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_CMP_TT_CMP_ID] DEFAULT (''),
	[CMP_CONTO]  [varchar] (13) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_CMP_TT_CMP_CONTO] DEFAULT (''),
	[CMP_CLIFOR] [varchar] (1) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_CMP_TT_CMP_CLIFOR] DEFAULT (''),
	[CMP_TOP] [varchar] (3) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_CMP_TT_CMP_TOP] DEFAULT (''),
	[CMP_NPART] [numeric] (10,0) NULL ,
	[CMP_DARE] [numeric] (17,3) NULL ,
	[CMP_AVERE] [numeric] (17,3) NULL ,
	[CMP_SALDO] [numeric] (17,3) NULL ,
	[CMP_DESMOV] [varchar] (50) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_CMP_TT_CMP_DESMOV] DEFAULT ('')
	
	CONSTRAINT [PK_U_CMP_TT] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO

