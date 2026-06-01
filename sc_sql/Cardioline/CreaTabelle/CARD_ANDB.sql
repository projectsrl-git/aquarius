
/****** Object:  Table [dbo].[CARD_ANDB]    Script Date: 01/11/2013 10.27.30 ******/
DROP TABLE [dbo].[CARD_ANDB]
GO

/****** Object:  Table [dbo].[CARD_ANDB]    Script Date: 01/11/2013 10.27.30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_ANDB](
	[CODPART] [varchar](16) NULL,
	[CODCOMP] [varchar](16) NULL,
	[CODSOST] [varchar](16) NULL,
	[DATADA] [datetime] NULL,
	[DATAA] [datetime] NULL,
	[QOCC] [float] NULL,
	[OGNI] [float] NULL,
	[SCARTO] [float] NULL,
	[UM] [varchar](2) NULL,
	[RICAMBIO] [varchar](1) NULL,
	[SEQ] [float] NULL,
	[CODIS] [varchar](20) NULL,
	[CODALT] [varchar](16) NULL,
	[FQTA] [varchar](1) NULL,
	[NOPIANIF] [varchar](1) NULL,
	[STATODIST] [varchar](1) NULL,
	[REVISIONE] [varchar](40) NULL,
	[PADREREV] [varchar](16) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


