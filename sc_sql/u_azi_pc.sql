
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_AZI_PC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_AZI_PC]
GO
  

/****** Object:  Table [dbo].[U_AZI_PC]    Script Date: 04/04/2019 20:31:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[U_AZI_PC](
	[id_unique] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_U_AZI_PC_id_unique]  DEFAULT (newid()),
	[AZI_CODSOC] [varchar](2) NULL CONSTRAINT [DF_U_AZI_PC_AZI_CODSOC]  DEFAULT (''),
	[AZI_BILGEST] [bit] NULL CONSTRAINT [DF_U_AZI_PC_AZI_BILGEST]  DEFAULT ((0)),
 CONSTRAINT [PK_U_AZI_PC] PRIMARY KEY CLUSTERED 
(
	[id_unique] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO

SET ANSI_PADDING OFF
GO

INSERT INTO U_AZI_PC (AZI_CODSOC, AZI_BILGEST) VALUES ('01',0)
