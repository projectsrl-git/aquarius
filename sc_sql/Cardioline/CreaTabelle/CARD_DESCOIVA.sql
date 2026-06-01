
/****** Object:  Table [dbo].[CARD_DESCOIVA]    Script Date: 24/11/2013 00.23.15 ******/
DROP TABLE [dbo].[CARD_DESCOIVA]
GO

/****** Object:  Table [dbo].[CARD_DESCOIVA]    Script Date: 24/11/2013 00.23.15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_DESCOIVA](
	[LINGUA] [varchar](1) NULL,
	[CODICE] [varchar](4) NULL,
	[DESCRIZION] [varchar](50) NULL,
	[STATO] [varchar](1) NULL,
	[UTENTE] [varchar](8) NULL,
	[ULT_AGG] [varchar](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

