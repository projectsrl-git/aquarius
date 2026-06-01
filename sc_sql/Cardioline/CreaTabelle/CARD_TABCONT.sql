USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[TABCONT]    Script Date: 03/12/2013 15:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_TABCONT](
	[TIPOCONTP] [char](3) NULL,
	[GRUPPMERC] [char](9) NULL,
	[SOTRICAV] [char](10) NULL,
	[SOTCOSTO] [char](10) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


