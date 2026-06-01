
/****** Object:  Table [dbo].[CARD_ABICAB]    Script Date: 14/12/2013 22.18.31 ******/
DROP TABLE [dbo].[CARD_ABICAB]
GO

/****** Object:  Table [dbo].[CARD_ABICAB]    Script Date: 14/12/2013 22.18.31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_ABICAB](
	[ABI] [varchar](5) NULL,
	[CAB] [varchar](5) NULL,
	[CODICE] [varchar](11) NULL,
	[DESCRIZION] [varchar](50) NULL,
	[DESCRBANCA] [varchar](24) NULL,
	[DESCRSPORT] [varchar](24) NULL,
	[INDIRIZZO] [varchar](35) NULL,
	[NUMEROCIV] [varchar](10) NULL,
	[LOCALITA] [varchar](20) NULL,
	[PROVINCIA] [varchar](2) NULL,
	[COMUNE] [varchar](4) NULL,
	[DESCOMUNE] [varchar](40) NULL,
	[CAP] [varchar](5) NULL,
	[STATO] [varchar](1) NULL,
	[UTENTE] [varchar](8) NULL,
	[ULT_AGG] [varchar](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


