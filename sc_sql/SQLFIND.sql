
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SQLFIND]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[SQLFIND]
GO
 
CREATE TABLE [dbo].[SQLFIND] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CHIAVE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PADRE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[NOME] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[DESCRI] [text] COLLATE Latin1_General_CI_AS NULL ,
	[QUERYSQL] [text] COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


ALTER TABLE [dbo].[SQLFIND] WITH NOCHECK ADD 
	CONSTRAINT [DF_SQLFIND_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_SQLFIND_CHIAVE] DEFAULT ('') FOR [CHIAVE],
	CONSTRAINT [DF_SQLFIND_PADRE] DEFAULT ('') FOR [PADRE],
	CONSTRAINT [DF_SQLFIND_NOME] DEFAULT ('') FOR [NOME],
	CONSTRAINT [DF_SQLFIND_DESCRI] DEFAULT ('') FOR [DESCRI],
	CONSTRAINT [DF_SQLFIND_QUERYSQL] DEFAULT ('') FOR [QUERYSQL]
GO

