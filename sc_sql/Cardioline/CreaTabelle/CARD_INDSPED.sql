
/****** Object:  Table [dbo].[CARD_INDSPED]    Script Date: 15/01/2015 02:16:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_INDSPED](
	[TIPO] [char](1) NULL,
	[CODCF] [char](10) NULL,
	[CODIND] [char](3) NULL,
	[RAGSOC] [char](50) NULL,
	[INDIR] [char](35) NULL,
	[LOCALITA] [char](35) NULL,
	[CAP] [char](5) NULL,
	[STATOES] [char](3) NULL,
	[COM] [char](4) NULL,
	[DES_COM] [char](50) NULL,
	[PTEL] [char](10) NULL,
	[TEL] [char](30) NULL,
	[PFAX] [char](10) NULL,
	[FAX] [char](30) NULL,
	[IVARID] [char](1) NULL,
	[RAGRECAPIT] [char](1) NULL,
	[PROVINCIA] [char](5) NULL,
	[LONGITUDIN] [char](20) NULL,
	[LATITUDINE] [char](20) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


