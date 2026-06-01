if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[para]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[para]
GO
 
CREATE TABLE [dbo].[para] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CODICE] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[DESCRI] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[LIBERA] [varchar] (200) COLLATE Latin1_General_CI_AS NULL ,
	[CLASSE] [numeric] (2,0) NULL ,
	[CONTO1] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[CONTO2] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[CONTO3] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[CONTO4] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[CONIVA] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[DESIVA] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[NOTE] [text] COLLATE Latin1_General_CI_AS NULL ,
	[ITALIANO] [text] COLLATE Latin1_General_CI_AS NULL ,
	[INGLESE] [text] COLLATE Latin1_General_CI_AS NULL ,
	[FRANCESE] [text] COLLATE Latin1_General_CI_AS NULL ,
	[TEDESCO] [text] COLLATE Latin1_General_CI_AS NULL ,
	[GG_LAV] [numeric] (6,2) NULL ,
	[CODPGO] [varchar] (5) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[para] WITH NOCHECK ADD 
	CONSTRAINT [PK_para] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[para] WITH NOCHECK ADD 
	CONSTRAINT [DF_para_id_unique] DEFAULT (newid()) FOR [id_unique]
GO

