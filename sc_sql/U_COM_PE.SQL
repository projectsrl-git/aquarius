if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_COM_PE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_COM_PE]
GO
 
CREATE TABLE [dbo].[U_COM_PE] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[TIPO] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[GRUPPO] [VARCHAR](10) COLLATE Latin1_General_CI_AS NULL ,
	[CODICE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[DESCRI] [varchar] (80) COLLATE Latin1_General_CI_AS NULL 
	
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_COM_PE] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_COM_PE] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_COM_PE] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_COM_PE_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_COM_PE_TIPO] DEFAULT ('') FOR [TIPO],
	CONSTRAINT [DF_U_COM_PE_GRUPPO] DEFAULT ('') FOR [GRUPPO],
	CONSTRAINT [DF_U_COM_PE_CODICE] DEFAULT ('') FOR [CODICE],
	CONSTRAINT [DF_U_COM_PE_DESCRI] DEFAULT ('') FOR [DESCRI]
GO

UPDATE U_COM_PE SET TIPO=SPACE(3),GRUPPO=SPACE(10),CODICE=SPACE(10),DESCRI=SPACE(80)