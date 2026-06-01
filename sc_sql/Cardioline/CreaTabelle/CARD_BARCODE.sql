USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[BARCODE]    Script Date: 08/01/2014 14:39:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_BARCODE](
	[CODICE] [char](30) NULL,
	[BARCODE] [char](21) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

