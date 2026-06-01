USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[LINGUE]    Script Date: 31/10/2013 16:54:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_LINGUE](
	[CODICE] [varchar](1) NULL,
	[DESCRIZION] [varchar](20) NULL,
	[STATO] [varchar](1) NULL,
	[UTENTE] [varchar](8) NULL,
	[ULT_AGG] [varchar](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


