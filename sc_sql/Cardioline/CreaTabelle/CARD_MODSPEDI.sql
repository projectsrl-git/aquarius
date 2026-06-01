
/****** Object:  Table [dbo].[CARD_MODSPEDI]    Script Date: 23/11/2013 18.56.41 ******/
DROP TABLE [dbo].[CARD_MODSPEDI]
GO

/****** Object:  Table [dbo].[CARD_MODSPEDI]    Script Date: 23/11/2013 18.56.41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_MODSPEDI](
	[CODICE] [varchar](3) NULL,
	[DESCRIZION] [varchar](60) NULL,
	[TRASPORTO] [varchar](2) NULL,
	[STATO] [varchar](1) NULL,
	[UTENTE] [varchar](8) NULL,
	[ULT_AGG] [varchar](8) NULL,
	[TIPOCAMION] [char](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

