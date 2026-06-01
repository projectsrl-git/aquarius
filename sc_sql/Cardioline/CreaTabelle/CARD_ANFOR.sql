
/****** Object:  Table [dbo].[ANFOR]    Script Date: 09/05/2014 09:32:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_ANFOR](
	[CODCLF] [varchar](6) NULL,
	[RAGSOC] [varchar](40) NULL,
	[CHIEST] [varchar](20) NULL,
	[NOME] [varchar](20) NULL,
	[INDIR] [varchar](40) NULL,
	[CAP] [varchar](5) NULL,
	[COMUNE] [varchar](40) NULL,
	[PROV] [varchar](2) NULL,
	[NAZ] [varchar](3) NULL,
	[CAT] [varchar](2) NULL,
	[LINGUA] [varchar](2) NULL,
	[LIST] [varchar](2) NULL,
	[CODMAG] [varchar](3) NULL,
	[NOTA] [text] NULL,
	[CODFISCA] [varchar](16) NULL,
	[PARTIVA] [varchar](12) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


