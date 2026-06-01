

/****** Object:  Table [dbo].[VENDITE_DC]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VENDITE_DC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[VENDITE_DC]
GO  


CREATE TABLE [dbo].[VENDITE_DC](
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_VENDITE_DC_id_unique] DEFAULT (newid()),
	[DAGGANCIO]				[varchar](10) NULL CONSTRAINT [DF_VENDITE_DC_TAGGANCIO]  DEFAULT (''),
	[LINK_DT_DC]			[varchar](10) NULL CONSTRAINT [DF_VENDITE_DC_LINK_DT_DC] DEFAULT (''),            
	[PMKEY]				[varchar](10) NULL CONSTRAINT [DF_VENDITE_DC_PMKEY] DEFAULT (''),            
	[CCODSCHE]			[varchar](20) NULL CONSTRAINT [DF_VENDITE_DC_CCODSCHE] DEFAULT (''),
	[ID_RIGO]				[varchar](5) NULL CONSTRAINT [DF_VENDITE_DC_ID_RIGO] DEFAULT (''), 
	[TIPO_COMPONENTE]		[varchar](03) NULL CONSTRAINT [DF_VENDITE_DC_TIPO_COMPONENTE] DEFAULT (''),            
	[NUMORD]			[varchar](6) NULL CONSTRAINT [DF_VENDITE_DC_NUMORD] DEFAULT (''), 
	[DATORD]			[varchar](10) NULL CONSTRAINT [DF_VENDITE_DC_DATORD] DEFAULT (''), 
	[LINKCOMP]			[varchar](10) NULL CONSTRAINT [DF_VENDITE_DC_LINKCOMP] DEFAULT (''), 
	[LINKCONTR]			[varchar](10) NULL CONSTRAINT [DF_VENDITE_DC_LINKCONTR] DEFAULT ('')          
	) 

ALTER TABLE [dbo].[VENDITE_DC] WITH NOCHECK ADD 
	CONSTRAINT [PK_VENDITE_DC] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO


