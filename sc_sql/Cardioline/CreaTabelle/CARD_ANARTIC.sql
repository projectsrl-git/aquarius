
/****** Object:  Table [dbo].[CARD_ANARTIC]    Script Date: 01/11/2013 10.06.31 ******/
DROP TABLE [dbo].[CARD_ANARTIC]
GO

/****** Object:  Table [dbo].[CARD_ANARTIC]    Script Date: 01/11/2013 10.06.31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_ANARTIC](
	[CODART] [varchar](16) NULL,
	[CODARF] [varchar](16) NULL,
	[CODFOR] [varchar](6) NULL,
	[DESCR] [varchar](40) NULL,
	[UM] [varchar](2) NULL,
	[UM1] [varchar](2) NULL,
	[COEFF1] [float] NULL,
	[UM2] [varchar](2) NULL,
	[COEFF2] [float] NULL,
	[UM3] [varchar](2) NULL,
	[COEFF3] [float] NULL,
	[LEADPR] [float] NULL,
	[UMPR] [varchar](2) NULL,
	[LEADACQ] [float] NULL,
	[UMACQ] [varchar](2) NULL,
	[TIPDIST] [varchar](2) NULL,
	[TIPCOST] [varchar](2) NULL,
	[TIPART] [varchar](2) NULL,
	[CODIS] [varchar](20) NULL,
	[LOTST] [float] NULL,
	[LOTMUL] [float] NULL,
	[SCSIC] [float] NULL,
	[TIPLAV] [varchar](2) NULL,
	[FILEDIS] [varchar](80) NULL,
	[FILECAT] [varchar](80) NULL,
	[NOPIANIF] [varchar](1) NULL,
	[FITTIZIO] [varchar](1) NULL,
	[CONFIG] [varchar](1) NULL,
	[FLAGDIS] [varchar](1) NULL,
	[SOLOCOST] [varchar](1) NULL,
	[UBICAZIONI] [varchar](1) NULL,
	[LOTTI] [varchar](1) NULL,
	[TIPORD] [varchar](1) NULL,
	[CODMAG] [varchar](3) NULL,
	[CODUBICA] [varchar](10) NULL,
	[ARTSICUR] [varchar](1) NULL,
	[STATO] [varchar](1) NULL,
	[UTENTE] [varchar](8) NULL,
	[DATAULTAGG] [datetime] NULL,
	[ARTCOMM] [varchar](1) NULL,
	[MATRICOLE] [varchar](1) NULL,
	[MODIFICATO] [varchar](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


