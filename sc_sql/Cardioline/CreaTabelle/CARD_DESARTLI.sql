USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[DESARTLI]    Script Date: 31/10/2013 16:56:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_DESARTLI](
	[LINGUA] [char](1) NULL,
	[ARTICOLO] [char](30) NULL,
	[DESCRIZION] [char](40) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[DESCRART01] [char](40) NULL,
	[DESCRART02] [char](40) NULL,
	[DESARCOMPL] [char](120) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


