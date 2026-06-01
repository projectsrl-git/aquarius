
/****** Object:  Table [dbo].[TIPODOCU]    Script Date: 20/06/2014 22:36:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_TIPODOCU](
	[CODICE] [char](2) NULL,
	[DESCRIZION] [char](20) NULL,
	[CAUSALEMAG] [char](3) NULL,
	[CAUSTRASPO] [char](3) NULL,
	[CAUCONTABI] [char](3) NULL,
	[NUMERATORE] [char](2) NULL,
	[COLLEGATO] [char](2) NULL,
	[TIPOEFFETT] [char](1) NULL,
	[TIPOFINCAT] [char](2) NULL,
	[FILEFINCAT] [char](8) NULL,
	[DAFATTURAR] [char](1) NULL,
	[REGIVASOSP] [char](2) NULL,
	[DESINSTAMP] [char](1) NULL,
	[CODSTAM_SN] [char](1) NULL,
	[PRSTATI_SN] [char](1) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[CICLOPASSN] [char](1) NULL,
	[TIPOOPCPAS] [char](1) NULL,
	[NUMERO] [char](2) NULL,
	[N_ESPORTA] [char](1) NULL,
	[N_STAMPA] [char](1) NULL,
	[N_FTRIEPI] [char](1) NULL,
	[CARTELLA] [char](10) NULL,
	[STILE] [char](1) NULL,
	[CALCOLACO2] [char](1) NULL,
	[CTRLPAGA] [char](1) NULL,
	[NOTA1TES] [char](60) NULL,
	[NOTA2TES] [char](60) NULL,
	[NOTA1PIEDE] [char](60) NULL,
	[NOTA2PIEDE] [char](60) NULL,
	[TIPDOCPA] [char](1) NULL,
	[TIPRIFPA] [char](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


