
/****** Object:  Table [dbo].[CARD_RIGDIS]    Script Date: 01/11/2013 10.25.11 ******/
DROP TABLE [dbo].[CARD_RIGDIS]
GO

/****** Object:  Table [dbo].[CARD_RIGDIS]    Script Date: 01/11/2013 10.25.11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_RIGDIS](
	[CODICE] [char](30) NULL,
	[IDEVARIAN] [char](4) NULL,
	[CODART] [char](30) NULL,
	[PERCRICARI] [float] NULL,
	[QUANTITA] [float] NULL,
	[FILE1] [char](8) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


