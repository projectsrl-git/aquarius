USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[TABRILIS]    Script Date: 29/10/2013 17:17:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_TABRILIS](
	[CODICE] [char](5) NULL,
	[ARTICOLO] [char](30) NULL,
	[DATAINVALI] [char](8) NULL,
	[PREZZO] [float] NULL,
	[BASERICARI] [float] NULL,
	[PERCRICARI] [float] NULL,
	[ARROTONDAM] [float] NULL,
	[TIPOFFERTA] [char](1) NULL,
	[PREZZORESO] [float] NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[FLAG1] [char](1) NULL,
	[AQUAT1] [float] NULL,
	[PREZZO1] [float] NULL,
	[PROVAG1] [float] NULL,
	[PROVCZ1] [float] NULL,
	[DAQUAT2] [float] NULL,
	[AQUAT2] [float] NULL,
	[PREZZO2] [float] NULL,
	[PROVAG2] [float] NULL,
	[PROVCZ2] [float] NULL,
	[DAQUAT3] [float] NULL,
	[AQUAT3] [float] NULL,
	[PREZZO3] [float] NULL,
	[PROVAG3] [float] NULL,
	[PROVCZ3] [float] NULL,
	[DAQUAT4] [float] NULL,
	[AQUAT4] [float] NULL,
	[PREZZO4] [float] NULL,
	[PROVAG4] [float] NULL,
	[PROVCZ4] [float] NULL,
	[DAQUAT5] [float] NULL,
	[AQUAT5] [float] NULL,
	[PREZZO5] [float] NULL,
	[PROVAG5] [float] NULL,
	[PROVCZ5] [float] NULL,
	[DAQUAT6] [float] NULL,
	[AQUAT6] [float] NULL,
	[PREZZO6] [float] NULL,
	[PROVAG6] [float] NULL,
	[PROVCZ6] [float] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


