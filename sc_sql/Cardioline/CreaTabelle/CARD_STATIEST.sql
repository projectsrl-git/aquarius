
/****** Object:  Table [dbo].[CARD_STATIEST]    Script Date: 23/11/2013 19.19.37 ******/
DROP TABLE [dbo].[CARD_STATIEST]
GO

/****** Object:  Table [dbo].[CARD_STATIEST]    Script Date: 23/11/2013 19.19.37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_STATIEST](
	[CODICE] [varchar](3) NULL,
	[DENOMINAZI] [varchar](50) NULL,
	[VALUTA] [varchar](3) NULL,
	[NAZIONALIT] [varchar](10) NULL,
	[STATOINTRA] [varchar](2) NULL,
	[STATO] [varchar](1) NULL,
	[UTENTE] [varchar](8) NULL,
	[ULT_AGG] [varchar](8) NULL,
	[STATOCEE] [varchar](1) NULL,
	[CODISO] [varchar](3) NULL,
	[CODISON] [char](3) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


