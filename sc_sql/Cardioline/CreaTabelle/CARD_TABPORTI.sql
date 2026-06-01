
/****** Object:  Table [dbo].[CARD_TABPORTI]    Script Date: 23/11/2013 18.23.21 ******/
DROP TABLE [dbo].[CARD_TABPORTI]
GO

/****** Object:  Table [dbo].[CARD_TABPORTI]    Script Date: 23/11/2013 18.23.21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_TABPORTI](
	[CODICE] [varchar](3) NULL,
	[DESCRIZION] [varchar](60) NULL,
	[STATO] [varchar](1) NULL,
	[UTENTE] [varchar](8) NULL,
	[ULT_AGG] [varchar](8) NULL,
	[CONSEGNA] [varchar](1) NULL,
	[CONSINTRA] [varchar](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
