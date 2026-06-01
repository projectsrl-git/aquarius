USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[TABMAGAZ]    Script Date: 07/10/2013 10:27:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_TABMAGAZ](
	[CODMAGAZ] [char](3) NULL,
	[DESCRMAGAZ] [char](40) NULL,
	[INDIRMAGAZ] [char](40) NULL,
	[CAPMAGAZ] [char](5) NULL,
	[LOCALMAGAZ] [char](25) NULL,
	[PROVIMAGAZ] [char](2) NULL,
	[GF_MAGAZ] [char](1) NULL,
	[CODRAGGRMA] [char](3) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[PIANIF_SN] [char](1) NULL,
	[UBICAZ_SN] [char](1) NULL,
	[CODUBICA] [char](10) NULL,
	[LOTTI_SN] [char](1) NULL,
	[USRINTEST] [char](1) NULL,
	[LONGITUDIN] [char](20) NULL,
	[LATITUDINE] [char](20) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


