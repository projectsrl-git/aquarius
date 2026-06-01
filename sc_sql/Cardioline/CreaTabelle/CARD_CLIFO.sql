USE [CARDIOLINE]
GO

DROP TABLE [dbo].[CARD_CLIFO]
GO

/****** Object:  Table [dbo].[CLIFO]    Script Date: 12/12/2013 10:03:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CARD_CLIFO]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CARD_CLIFO]
GO

CREATE TABLE [dbo].[CARD_CLIFO](
	[TIPO] [char](1) NULL,
	[CODICE] [char](10) NULL,
	[FATTURAREA] [char](10) NULL,
	[RAGIONESOC] [char](50) NULL,
	[INDIR1] [char](40) NULL,
	[INDIR2] [char](40) NULL,
	[CAP] [char](5) NULL,
	[LOCALITA] [char](20) NULL,
	[COMUNE] [char](50) NULL,
	[COD_COMUNE] [char](4) NULL,
	[PROVINCIA] [char](5) NULL,
	[NAZIONE] [char](50) NULL,
	[COD_NAZION] [char](3) NULL,
	[STATOINTRA] [char](1) NULL,
	[COFI] [char](16) NULL,
	[PAIV] [char](12) NULL,
	[PTEL] [char](10) NULL,
	[TEL] [char](30) NULL,
	[CODPAG] [char](4) NULL,
	[PER_FATTUR] [char](1) NULL,
	[LINGUA] [char](1) NULL,
	[CODVAL] [char](3) NULL,
	[NOMEBREVE] [char](15) NULL,
	[ALLEGAT_SN] [char](1) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[AGGIORN_SN] [char](1) NULL,
	[RAGGR_SN] [char](1) NULL,
	[FTMAIL_SN] [char](1) NULL,
	[FTFAX_SN] [char](1) NULL,
	[FTE_MAIL] [char](64) NULL,
	[FTFAXNUM] [char](40) NULL,
	[EXPORTED] [char](1) NULL,
	[ADDINT_SN] [char](1) NULL,
	[SOLLSCA_SN] [char](1) NULL,
	[PERCENT_DA] [char](1) NULL,
	[PERC_INT] [float] NULL,
	[BLOCCO_SN] [char](1) NULL,
	[SOGGIVA_SN] [char](1) NULL,
	[PERSFISICA] [char](1) NULL,
	[TP_CENTRAL] [char](1) NULL,
	[RDA_SN] [char](1) NULL,
	[RDASOTTOCO] [char](10) NULL,
	[DARIFAZ_SN] [char](1) NULL,
	[LONGITUDIN] [char](20) NULL,
	[LATITUDINE] [char](20) NULL,
	[BLACKLIST] [char](1) NULL,
	[BLACKLISTF] [char](1) NULL,
	[DATIANA_SN] [char](1) NULL,
	[ALLCOMUNIC] [char](1) NULL,
	[XMLCBI2_SN] [char](1) NULL,
	[CODPAGA] [char](4) NULL,
	[CODPAGB] [char](4) NULL,
	[SOLO30G] [char](1) NULL,
	[SMARINO_SN] [char](1) NULL,
	[CODIDIVA] [char](30) NULL,
	[NUMMANSDD] [char](35) NULL,
	[DTMANSDD] [char](8) NULL,
	[TIPOSEQSDD] [char](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


