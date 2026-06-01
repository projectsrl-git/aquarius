
/****** Object:  Table [dbo].[TABIVA]    Script Date: 20/06/2014 22:31:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_TABIVA](
	[CODICE] [varchar](4) NULL,
	[DESCRIZION] [varchar](50) NULL,
	[TIPOCODICE] [varchar](1) NULL,
	[CODIVAVENT] [varchar](4) NULL,
	[PERCENTIVA] [float] NULL,
	[IMPCLIENTI] [varchar](1) NULL,
	[IMPFORNITO] [varchar](1) NULL,
	[CLIENTI101] [varchar](1) NULL,
	[FORNITO101] [varchar](1) NULL,
	[RIGAVENESE] [varchar](1) NULL,
	[RIGAACQESE] [varchar](1) NULL,
	[PLAFOND] [varchar](1) NULL,
	[AGRICOLO] [varchar](1) NULL,
	[AGENVIAGGI] [varchar](1) NULL,
	[CALRIMBANN] [varchar](1) NULL,
	[DETRAIBILE] [varchar](1) NULL,
	[ALLEGAT_SN] [varchar](1) NULL,
	[STATO] [varchar](1) NULL,
	[UTENTE] [varchar](8) NULL,
	[ULT_AGG] [varchar](8) NULL,
	[INTRA_SN] [varchar](1) NULL,
	[PERCDETRAZ] [float] NULL,
	[ALIQDETRAI] [varchar](4) NULL,
	[STESSOSOTT] [varchar](1) NULL,
	[BOLLO_SN] [varchar](1) NULL,
	[TIPOINTRA] [varchar](1) NULL,
	[EXPORTED] [varchar](1) NULL,
	[REV_CHARGE] [char](1) NULL,
	[RIPSOGIVA] [char](1) NULL,
	[RIPCONSFIN] [char](1) NULL,
	[BLACKLIST] [char](1) NULL,
	[BENI_SN] [char](1) NULL,
	[SERVIZI_SN] [char](1) NULL,
	[IVACESS] [char](1) NULL,
	[IVAACQ] [char](1) NULL,
	[VARIAZIONE] [char](1) NULL,
	[NATURA] [char](2) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


