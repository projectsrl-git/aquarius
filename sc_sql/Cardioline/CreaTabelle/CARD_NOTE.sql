USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[NOTE]    Script Date: 13/12/2013 09:06:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CARD_NOTE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CARD_NOTE]
GO

CREATE TABLE [dbo].[CARD_NOTE](
	[TIPORECORD] [char](2) NULL,
	[ESERCIZIO] [char](4) NULL,
	[NUMEMOVIME] [char](7) NULL,
	[RIGAMOVIME] [char](5) NULL,
	[PROGRESSIV] [char](5) NULL,
	[CODICE] [char](5) NULL,
	[NOTA] [char](40) NULL,
	[UTENTE] [char](8) NULL,
	[ULT_AGG] [char](8) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


