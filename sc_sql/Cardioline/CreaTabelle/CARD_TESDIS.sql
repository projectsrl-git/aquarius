
/****** Object:  Table [dbo].[CARD_TESDIS]    Script Date: 01/11/2013 10.22.48 ******/
DROP TABLE [dbo].[CARD_TESDIS]
GO

/****** Object:  Table [dbo].[CARD_TESDIS]    Script Date: 01/11/2013 10.22.48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_TESDIS](
	[CODICE] [char](30) NULL,
	[STAGIONE] [char](3) NULL,
	[TIPO] [char](1) NULL,
	[NOTE1] [char](50) NULL,
	[NOTE2] [char](50) NULL,
	[PERCRICARI] [float] NULL,
	[FILE1] [char](8) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


