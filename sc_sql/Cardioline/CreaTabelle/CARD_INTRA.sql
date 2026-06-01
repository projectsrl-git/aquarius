
/****** Object:  Table [dbo].[CARD_INTRA]    Script Date: 22/11/2013 21.05.16 ******/
DROP TABLE [dbo].[CARD_INTRA]
GO

/****** Object:  Table [dbo].[CARD_INTRA]    Script Date: 22/11/2013 21.05.16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_INTRA](
	[CLI_FOR] [char](10) NULL,
	[NATMERCI] [char](2) NULL,
	[CODDOGAN] [char](10) NULL,
	[TRASPORTO] [char](2) NULL,
	[PROVPART] [char](2) NULL,
	[CODVALUTA] [char](3) NULL,
	[STATORIGIN] [char](2) NULL,
	[STATDESTIN] [char](2) NULL,
	[NUMERO] [char](7) NULL,
	[ESERCIZIO] [char](4) NULL,
	[ACQ_VEN] [char](1) NULL,
	[DATAREG] [char](8) NULL,
	[DATAFATT] [char](8) NULL,
	[PERIODORIF] [char](4) NULL,
	[PERIODORET] [char](4) NULL,
	[TIPOPERIOD] [char](1) NULL,
	[TIPOPROTOC] [char](2) NULL,
	[SEGNO] [char](1) NULL,
	[NUMFATTU] [char](15) NULL,
	[DATACAMBIO] [char](8) NULL,
	[VALCAMBIO] [float] NULL,
	[IMPLIRE] [float] NULL,
	[IMPVAL] [float] NULL,
	[MASSA] [float] NULL,
	[UNISUPPL] [float] NULL,
	[VALSTATIST] [float] NULL,
	[STAMPAT_SN] [char](1) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[CONSEGNA] [char](1) NULL,
	[CONSCARD_INTRA] [char](1) NULL,
	[EVALSTATIS] [float] NULL,
	[EIMPLIRE] [float] NULL,
	[ECAMBIO] [float] NULL,
	[COD_SERVIZ] [char](8) NULL,
	[MOD_EROG] [char](1) NULL,
	[MOD_INCAS] [char](1) NULL,
	[PAESE_PAG] [char](2) NULL,
	[SERVIZI_SN] [char](1) NULL,
	[SEZDOGAN] [char](6) NULL,
	[PROTINVIO] [char](6) NULL,
	[PROGSEZIO] [char](5) NULL,
	[RETSERV_SN] [char](1) NULL,
	[CANSERV_SN] [char](1) NULL,
	[DATA_RET] [char](8) NULL,
	[NUMERO_RET] [char](15) NULL,
	[QUAMARCA] [char](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


