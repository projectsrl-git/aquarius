
/****** Object:  Table [dbo].[CARD_TPAS770]    Script Date: 30/06/2015 14.33.28 ******/
DROP TABLE [dbo].[CARD_TPAS770]
GO

/****** Object:  Table [dbo].[CARD_TPAS770]    Script Date: 30/06/2015 14.33.28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_TPAS770](
	[CODICE] [char](1) NULL,
	[DESCRIZION] [char](20) NULL,
	[IMP_IRPEF] [float] NULL,
	[IMP_ENASAD] [float] NULL,
	[IMP_ENASAS] [float] NULL,
	[IMP_CAP] [float] NULL,
	[IMP_INPSD] [float] NULL,
	[IMP_INPSS] [float] NULL,
	[PERC_IRPEF] [float] NULL,
	[PERC_ENASD] [float] NULL,
	[PERC_ENASS] [float] NULL,
	[PERC_CAP] [float] NULL,
	[PERC_INPSD] [float] NULL,
	[PERC_INPSS] [float] NULL,
	[SOTTIRPEF] [char](10) NULL,
	[SOTTENASD] [char](10) NULL,
	[SOTTENASS] [char](10) NULL,
	[SOTTCAP] [char](10) NULL,
	[SOTTINPSD] [char](10) NULL,
	[SOTTINPSS] [char](10) NULL,
	[ST_770] [char](1) NULL,
	[CODQUADRO] [char](2) NULL,
	[CODTRIB] [char](4) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


