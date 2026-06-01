USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[CARD_GRUPMERC]    Script Date: 04/10/2013 11:23:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_GRUPMERC](
	[CODGRU] [char](3) NULL,
	[CODFAM] [char](3) NULL,
	[CODSFAM] [char](3) NULL,
	[COMPLETO] [char](9) NULL,
	[DESCRIZION] [char](40) NULL,
	[ARROTONDAM] [float] NULL,
	[CONTROACQ] [char](10) NULL,
	[CONTROVEN] [char](10) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[EARROTONDA] [float] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


