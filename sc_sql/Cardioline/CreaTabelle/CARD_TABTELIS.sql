USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[TABTELIS]    Script Date: 29/10/2013 17:16:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_TABTELIS](
	[CODICE] [char](5) NULL,
	[TIPO] [char](1) NULL,
	[DESCRIZION] [char](40) NULL,
	[VALUTA] [char](3) NULL,
	[DATAINVALI] [char](8) NULL,
	[DATAFIVALI] [char](8) NULL,
	[LORDOIVA] [char](1) NULL,
	[LISTINSUCC] [char](5) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[LIFASCE_SN] [char](1) NULL,
	[SCONTI_SN] [char](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


