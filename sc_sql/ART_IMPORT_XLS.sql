

/****** Object:  Table [dbo].[ART_IMPORT_XLS]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ART_IMPORT_XLS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ART_IMPORT_XLS]
GO
*/

CREATE TABLE [dbo].[ART_IMPORT_XLS](
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_ART_IMPORT_XLS_id_unique] DEFAULT (newid()),
	[ID_CONFIG]		[varchar](10) NULL CONSTRAINT [DF_ART_IMPORT_XLS_ID_CONFIG]  DEFAULT (''),
	[NOME_CONFIG]	[varchar](100) NULL CONSTRAINT [DF_ART_IMPORT_XLS_NOME_CONFIG] DEFAULT (''),            
	[NOME_COLONNA]	[varchar](20) NULL CONSTRAINT [DF_ART_IMPORT_XLS_NOME_COLONNA] DEFAULT (''),            
	[C_COLONNA]		[varchar](10) NULL CONSTRAINT [DF_ART_IMPORT_XLS_C_COLONNA] DEFAULT (''),
	[D_COLONNA]		[varchar](254) NULL CONSTRAINT [DF_ART_IMPORT_XLS_D_COLONNA] DEFAULT ('')
 	) 
ALTER TABLE [dbo].[ART_IMPORT_XLS] WITH NOCHECK ADD 
	CONSTRAINT [PK_ART_IMPORT_XLS] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO


