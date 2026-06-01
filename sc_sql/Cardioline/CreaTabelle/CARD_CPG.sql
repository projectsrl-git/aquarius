
/****** Object:  Table [dbo].[CPG]    Script Date: 20/06/2014 22:03:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_CPG](
	[CODICE] [varchar](4) NULL,
	[DESCRIZION] [varchar](50) NULL,
	[INIZIOCAL] [varchar](1) NULL,
	[TPRATA] [varchar](1) NULL,
	[MESECOMM] [varchar](1) NULL,
	[SCONTOVALU] [float] NULL,
	[CODLINGUA] [varchar](1) NULL,
	[STATO] [varchar](1) NULL,
	[UTENTE] [varchar](8) NULL,
	[ULT_AGG] [varchar](8) NULL,
	[RATECOSTAN] [varchar](1) NULL,
	[EXPORTED] [varchar](1) NULL,
	[AMOD_INCAS] [char](1) NULL,
	[APAESE_PAG] [char](2) NULL,
	[VMOD_INCAS] [char](1) NULL,
	[VPAESE_PAG] [char](2) NULL,
	[GGCALENDAR] [char](1) NULL,
	[AFINEMESE] [char](1) NULL,
	[CONDPAGPA] [char](2) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


