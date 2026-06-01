
/****** Object:  Table [dbo].[CARD_TATRIB]    Script Date: 30/06/2015 14.29.21 ******/
DROP TABLE [dbo].[CARD_TATRIB]
GO

/****** Object:  Table [dbo].[CARD_TATRIB]    Script Date: 30/06/2015 14.29.21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_TATRIB](
	[CODTRIB] [char](4) NULL,
	[DESCRTRIB] [char](50) NULL,
	[CONTROPART] [char](10) NULL,
	[GIROCONTO] [char](10) NULL,
	[DESMOV] [char](30) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


