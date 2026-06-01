USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[CAUSMAGA]    Script Date: 14/10/2013 16:51:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_CAUSMAGA](
	[CODCAUMAG] [char](3) NULL,
	[CODRAGCAU] [char](3) NULL,
	[CODCAUCON] [char](3) NULL,
	[DESCAUMAG] [char](30) NULL,
	[CODMAGAZZ] [char](3) NULL,
	[MOVINVENT] [char](1) NULL,
	[MOVCADAAQ] [char](1) NULL,
	[MOVALTRIC] [char](1) NULL,
	[SCAPERVEN] [char](1) NULL,
	[ALTRISCAR] [char](1) NULL,
	[ORDCLIENT] [char](1) NULL,
	[ORDFORNIT] [char](1) NULL,
	[IMPEGNATO] [char](1) NULL,
	[ATTESACOL] [char](1) NULL,
	[ATTESASPE] [char](1) NULL,
	[ATTESAROT] [char](1) NULL,
	[MOVAVALOR] [char](1) NULL,
	[MOVAQUANT] [char](1) NULL,
	[ULTPREACQ] [char](1) NULL,
	[AGGPREVEN] [char](1) NULL,
	[TIPOPREZZ] [char](1) NULL,
	[AGG_TOTALI] [char](1) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[TIPOEFFETT] [char](1) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


