
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMBCONV]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[IMBCONV]
GO
 
CREATE TABLE [dbo].[IMBCONV] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[IMBALLO] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[FATT_CONV] [numeric] (4,2) NULL ,
	[IMBALLO_EQ] [varchar] (3) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[IMBCONV] WITH NOCHECK ADD 
	CONSTRAINT [DF_IMBCONV_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_IMBCONV_IMBALLO] DEFAULT ('') FOR [IMBALLO],
	CONSTRAINT [DF_IMBCONV_FATT_CONV] DEFAULT ('') FOR [FATT_CONV],
	CONSTRAINT [DF_IMBCONV_IMBALLO_EQ] DEFAULT ('') FOR [IMBALLO_EQ]
GO

