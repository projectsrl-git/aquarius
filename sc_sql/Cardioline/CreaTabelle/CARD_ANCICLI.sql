USE [CARDIOLINE]
GO

/****** Object:  Table [dbo].[ANCICLI]    Script Date: 10/10/2013 14:25:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_ANCICLI](
	[CODART] [varchar](16) NULL,
	[DATAV] [datetime] NULL,
	[ORDINE] [float] NULL,
	[CODFASE] [varchar](4) NULL,
	[DESCR] [varchar](40) NULL,
	[CODCDL] [varchar](6) NULL,
	[CODCDL1] [varchar](6) NULL,
	[CODCDL2] [varchar](6) NULL,
	[TIPO] [varchar](1) NULL,
	[CLF] [varchar](1) NULL,
	[CODCLF] [varchar](6) NULL,
	[COSTU] [float] NULL,
	[TCICLO] [float] NULL,
	[TATTR] [float] NULL,
	[TMACCH] [float] NULL,
	[FISSO] [varchar](1) NULL,
	[TUOMO] [float] NULL,
	[PERCM] [float] NULL,
	[PERCU] [float] NULL,
	[TIPADD] [varchar](3) NULL,
	[ESDESCR] [varchar](1) NULL,
	[UMIST] [varchar](2) NULL,
	[LISTAUT] [varchar](3) NULL,
	[LISTATTR] [varchar](16) NULL,
	[OPSOVR] [varchar](1) NULL,
	[QTASOVR] [float] NULL,
	[RIFCICLO] [varchar](1) NULL,
	[LOTTOT] [float] NULL,
	[UMLOTTO] [varchar](2) NULL,
	[COMMENTO] [text] NULL,
	[ECOSTU] [float] NULL,
	[TMACCH2] [float] NULL,
	[TUOMO2] [float] NULL,
	[TIPADD2] [varchar](3) NULL,
	[TMACCH3] [float] NULL,
	[TUOMO3] [float] NULL,
	[TIPADD3] [varchar](3) NULL,
	[LISTATTR2] [varchar](16) NULL,
	[LISTATTR3] [varchar](16) NULL,
	[LISTATTR4] [varchar](16) NULL,
	[LISTATTR5] [varchar](16) NULL,
	[LISTAUT2] [varchar](3) NULL,
	[LISTAUT3] [varchar](3) NULL,
	[LISTAUT4] [varchar](3) NULL,
	[LISTAUT5] [varchar](3) NULL,
	[TIPOCDL] [varchar](1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


