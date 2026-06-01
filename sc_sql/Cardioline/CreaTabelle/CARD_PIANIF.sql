
/****** Object:  Table [dbo].[PIANIF]    Script Date: 16/05/2014 09:28:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CARD_PIANIF](
	[TIPREC] [varchar](3) NULL,
	[TIPORD] [varchar](2) NULL,
	[ANNO] [float] NULL,
	[TIPNUM] [varchar](2) NULL,
	[NUM] [float] NULL,
	[RIGA] [float] NULL,
	[COMM] [varchar](9) NULL,
	[PCOMM] [varchar](6) NULL,
	[TIPO] [varchar](1) NULL,
	[TIPORDF] [varchar](2) NULL,
	[ANNOF] [float] NULL,
	[TIPNUMF] [varchar](2) NULL,
	[NUMF] [float] NULL,
	[RIGAF] [float] NULL,
	[CODART] [varchar](16) NULL,
	[CODMAG] [varchar](3) NULL,
	[UM] [varchar](2) NULL,
	[QCONF] [float] NULL,
	[DATAIP] [datetime] NULL,
	[DATAFC] [datetime] NULL,
	[QFABB] [float] NULL,
	[DATAIPO] [datetime] NULL,
	[DATAFCO] [datetime] NULL,
	[DATAICONF] [datetime] NULL,
	[DATAFCONF] [datetime] NULL,
	[CODCLF] [varchar](6) NULL,
	[LANC] [varchar](1) NULL,
	[QOCC] [float] NULL,
	[OGNI] [float] NULL,
	[QECON] [float] NULL,
	[DATACS] [datetime] NULL,
	[RIPIAN] [varchar](1) NULL,
	[ORDCONF] [varchar](1) NULL,
	[UMDB] [varchar](2) NULL,
	[COEFFDB] [float] NULL,
	[CODCDL] [varchar](6) NULL,
	[TIPOPIAN] [varchar](1) NULL,
	[TIPOFABB] [varchar](2) NULL,
	[NUMFABB] [float] NULL,
	[CODCLIENTE] [varchar](6) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


