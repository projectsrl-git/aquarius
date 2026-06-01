USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[CARD_CODDOGAN]    Script Date: 04/10/2013 17:21:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_CODDOGAN](
	[CHIAVE] [varchar](10) NULL,
	[DESCR] [varchar](60) NULL,
	[STATO] [varchar](1) NULL,
	[UTENTE] [varchar](8) NULL,
	[ULT_AGG] [varchar](8) NULL,
	[UNISUPP_SN] [char](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


