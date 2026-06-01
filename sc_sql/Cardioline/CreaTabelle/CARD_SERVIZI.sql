
/****** Object:  Table [dbo].[CARD_SERVIZI]    Script Date: 22/11/2013 21.18.48 ******/
DROP TABLE [dbo].[CARD_SERVIZI]
GO

/****** Object:  Table [dbo].[CARD_SERVIZI]    Script Date: 22/11/2013 21.18.48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_SERVIZI](
	[CODICE] [char](8) NULL,
	[DESCRIZION] [char](60) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


