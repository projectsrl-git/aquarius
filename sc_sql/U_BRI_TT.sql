

/****** Object:  Table [dbo].[U_BRI_TT]    Script Date: 19/04/2016 16:15:38 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_BRI_TT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_BRI_TT]
GO


/****** Object:  Table [dbo].[U_BRI_TT]    Script Date: 11/05/2016 08:56:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[U_BRI_TT](
	[id_unique] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_U_BRI_TT_id_unique]  DEFAULT (newid()),
	[SELEZIONE] [varchar](10) NULL CONSTRAINT [DF_U_BRI_TT_SELEZIONE]  DEFAULT (''),
	[INT_CODSOC] [varchar](2) NULL CONSTRAINT [DF_U_BRI_TT_INT_CODSOC]  DEFAULT (''),
	[INT_CONTO] [varchar](13) NULL CONSTRAINT [DF_U_BRI_TT_INT_CONTO]  DEFAULT (''),
	[INT_DESCRI] [varchar](40) NULL CONSTRAINT [DF_U_BRI_TT_INT_DESCRI]  DEFAULT (''),
	[INT_CODRIG] [varchar](10) NULL CONSTRAINT [DF_U_BRI_TT_INT_CODRIG]  DEFAULT (''),
	[INT_CODRIA] [varchar](10) NULL CONSTRAINT [DF_U_BRI_TT_INT_CODRIA]  DEFAULT (''),
 CONSTRAINT [PK_U_BRI_TT] PRIMARY KEY CLUSTERED 
(
	[id_unique] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


