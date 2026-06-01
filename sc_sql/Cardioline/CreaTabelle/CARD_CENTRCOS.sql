
/****** Object:  Table [dbo].[CARD_CENTRCOS]    Script Date: 05/12/2013 21.43.55 ******/
DROP TABLE [dbo].[CARD_CENTRCOS]
GO

/****** Object:  Table [dbo].[CARD_CENTRCOS]    Script Date: 05/12/2013 21.43.55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_CENTRCOS](
	[CODICE] [char](6) NULL,
	[DESCRIZION] [char](40) NULL,
	[CLASSIFIC1] [char](3) NULL,
	[CLASSIFIC2] [char](3) NULL,
	[CLASSIFIC3] [char](3) NULL,
	[CLASSIFIC4] [char](3) NULL,
	[CLASSIFIC5] [char](3) NULL,
	[CLASSIFIC6] [char](3) NULL,
	[C_F] [char](1) NULL,
	[CLI_FOR] [char](10) NULL,
	[RIPARTIB] [char](1) NULL,
	[LIV_RIP] [char](1) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[EXPORTED] [char](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


