
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[NAZIONI_UNICO]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[NAZIONI_UNICO]
GO
 
CREATE TABLE [dbo].[NAZIONI_UNICO] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CODICE] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[DESCRI] [varchar] (40) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[NAZIONI_UNICO] WITH NOCHECK ADD 
	CONSTRAINT [DF_NAZIONI_UNICO_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_NAZIONI_UNICO_CODICE] DEFAULT ('') FOR [CODICE],
	CONSTRAINT [DF_NAZIONI_UNICO_DESCRI] DEFAULT ('') FOR [DESCRI]
GO

