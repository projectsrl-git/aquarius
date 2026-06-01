
/****** Object:  Table [dbo].[IMPIANTI_LI]    Script Date: 19/02/2016 17:14:01 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPIANTI_LI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[IMPIANTI_LI]
GO  

/****** Object:  Table [dbo].[IMPIANTI_LI]    Script Date: 19/02/2016 17:14:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IMPIANTI_LI](
	[id_unique]     [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_IMPIANTI_LI_id_unique]  DEFAULT (newid()),
    [LIS_CODLIS]    [varchar](10) NULL CONSTRAINT [DF_IMPIANTI_LIS_CODLIS]  DEFAULT (''),
	[LIS_DATLIS]    [varchar](10) NULL,
	[LIS_ALLIST]    [varchar](10) NULL,
	[LIS_CODRAG]    [varchar](5) NULL CONSTRAINT [DF_IMPIANTI_LI_LIS_CODRAG] DEFAULT (''),
	[LIS_REVISI]    [Numeric](19,3) NULL,       
	[LIS_ABBONSEMP] [Numeric](19,3) NULL,       
	[LIS_ABBONCOMP] [Numeric](19,3) NULL,       
	[LIS_PULIZIA]   [Numeric](19,3) NULL,       
	[LIS_ANALCOMBU] [Numeric](19,3) NULL,       
	[LIS_REVADC]    [Numeric](19,3) NULL,       
	[LIS_BOLLO]     [Numeric](19,3) NULL,      	
	[LIS_NOTELIS]   [text] NULL CONSTRAINT [DF_IMPIANTI_LI_LIS_NOTELIS]  DEFAULT (''),
 CONSTRAINT [PK_IMPIANTI_LI] PRIMARY KEY CLUSTERED 
(
	[id_unique] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
