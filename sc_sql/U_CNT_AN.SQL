if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_CNT_AN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_CNT_AN]
GO
 
CREATE TABLE [dbo].[U_CNT_AN] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CNT_TIPO] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[CNT_DATINI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CNT_ORAINI] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[CNT_DATFIN] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CNT_ORAFIN] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[CNT_NUMREC] [numeric] (20,0) NULL ,
	[CNT_FILE] [varchar] (100) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_CNT_AN] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_CNT_AN] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_CNT_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CNT_AN_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_CNT_AN_CNT_TIPO] DEFAULT ('') FOR [CNT_TIPO],
	CONSTRAINT [DF_U_CNT_AN_CNT_DATINI] DEFAULT ('') FOR [CNT_DATINI],
	CONSTRAINT [DF_U_CNT_AN_CNT_ORAINI] DEFAULT ('') FOR [CNT_ORAINI],
	CONSTRAINT [DF_U_CNT_AN_CNT_DATFIN] DEFAULT ('') FOR [CNT_DATFIN],
	CONSTRAINT [DF_U_CNT_AN_CNT_ORAFIN] DEFAULT ('') FOR [CNT_ORAFIN],
	CONSTRAINT [DF_U_CNT_AN_CNT_NUMREC] DEFAULT (0) FOR [CNT_NUMREC],
	CONSTRAINT [DF_U_CNT_AN_CNT_FILE] DEFAULT ('') FOR [CNT_FILE]
GO

