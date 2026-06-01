
/****** Object:  Table [dbo].[CARD_PIACON]    Script Date: 06/10/2013 10.54.51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_PIACON](
	[GRUPPO] [char](3) NULL,
	[CONTO] [char](3) NULL,
	[GCONTO] [char](7) NULL,
	[SOTTOCONTO] [char](10) NULL,
	[DESCRIZION] [char](50) NULL,
	[SEQUENZA] [char](6) NULL,
	[TIPOCONTO] [char](1) NULL,
	[TIPO_SP_RC] [char](1) NULL,
	[TIPO] [char](1) NULL,
	[CODCLASSIF] [char](10) NULL,
	[CENTRCO] [char](6) NULL,
	[SEGNO] [char](1) NULL,
	[AUTO_SN] [char](1) NULL,
	[PARTAP_SN] [char](1) NULL,
	[VALUTA_SN] [char](1) NULL,
	[ANALITICA] [char](1) NULL,
	[EXPORTED] [char](1) NULL,
	[MONETA_SN] [char](1) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[BLOCCO_SN] [char](1) NULL,
	[CIVAACQ_SN] [char](1) NULL,
	[CIVAVEN_SN] [char](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


