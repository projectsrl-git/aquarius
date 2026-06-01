USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[CARD_MOVIVA]    Script Date: 20/02/2015 10:55:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_MOVIVA](
	[NUMERO] [char](7) NULL,
	[RIGA] [char](3) NULL,
	[ANNOIVA] [char](4) NULL,
	[DATAREG] [char](8) NULL,
	[NUMPROTOC] [char](7) NULL,
	[DATADOC] [char](8) NULL,
	[NUMERODOC] [char](10) NULL,
	[SOTTOCONTO] [char](10) NULL,
	[C_F] [char](1) NULL,
	[DATAINIZIO] [char](8) NULL,
	[DATAFINE] [char](8) NULL,
	[TIPODOCIVA] [char](2) NULL,
	[REGISTRO] [char](2) NULL,
	[REGCOLLEG] [char](2) NULL,
	[NUMREGCOLL] [char](7) NULL,
	[ANNOREGCOL] [char](4) NULL,
	[VALUTA] [char](3) NULL,
	[TOTFTVALUT] [float] NULL,
	[TOTFATTURA] [float] NULL,
	[IMPONIBILE] [float] NULL,
	[CODIVA] [char](4) NULL,
	[IMPOSTA] [float] NULL,
	[IMPRATEO] [float] NULL,
	[IMPRISCONT] [float] NULL,
	[RITARDO_SN] [char](1) NULL,
	[STLIQ_SN] [char](1) NULL,
	[STAMPAT_SN] [char](1) NULL,
	[MESEPLAFO] [char](2) NULL,
	[ANNOPLAFO] [char](4) NULL,
	[TEMPORA_SN] [char](1) NULL,
	[PAGATA_SN] [char](1) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[ANNOCOMPET] [char](4) NULL,
	[MESECOMPET] [char](2) NULL,
	[SOSPESO_SN] [char](1) NULL,
	[ETOTFATTUR] [float] NULL,
	[EIMPONIBIL] [float] NULL,
	[EIMPOSTA] [float] NULL,
	[VIMPONIBIL] [float] NULL,
	[VIMPOSTA] [float] NULL,
	[RIFANNPREC] [char](1) NULL,
	[COMUNIC_SN] [char](1) NULL,
	[FORZATO_SN] [char](1) NULL,
	[VALIDAT_SN] [char](1) NULL,
	[CODEVENTO] [char](30) NULL,
	[CODRIFERI] [char](7) NULL,
	[MODPAGAM] [char](1) NULL,
	[TIPONUMERA] [char](1) NULL,
	[DATAMAXLIQ] [char](8) NULL,
	[IVACASFORZ] [char](1) NULL,
	[EIMPONRIC] [float] NULL,
	[EIMPOSRIC] [float] NULL,
	[TOTALE_NC] [float] NULL,
	[EIMPON_NC] [float] NULL,
	[EIMPOS_NC] [float] NULL,
	[IVACALC_SN] [char](1) NULL,
	[IVAFAGG_SN] [char](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


