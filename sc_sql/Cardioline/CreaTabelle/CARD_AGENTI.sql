USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[AGENTI]    Script Date: 31/10/2013 12:24:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_AGENTI](
	[CODICE] [char](5) NULL,
	[CODFORNITO] [char](10) NULL,
	[CODCAPOZON] [char](5) NULL,
	[PERCPROVVI] [float] NULL,
	[CAP_ZON_SN] [char](1) NULL,
	[STATO] [char](1) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL,
	[MATURAT_SN] [char](1) NULL,
	[NOPAGLIQPR] [char](1) NULL,
	[NOPAGPERAC] [float] NULL,
	[SIPAGLIQPR] [char](1) NULL,
	[SIPAGPERAC] [float] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


