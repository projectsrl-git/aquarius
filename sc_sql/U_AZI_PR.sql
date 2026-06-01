
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_AZI_PR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_AZI_PR]
GO
 
CREATE TABLE [dbo].[U_AZI_PR] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[AZI_TIPOPR] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[AZI_DATADA] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[AZI_DATAAL] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[AZI_VALORE] TEXT NOT NULL DEFAULT ''
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_AZI_PR] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_AZI_PR] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
