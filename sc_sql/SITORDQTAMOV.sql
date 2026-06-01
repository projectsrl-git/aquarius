
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SITORDQTAMOV]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[SITORDQTAMOV]
GO
 
CREATE TABLE [dbo].[SITORDQTAMOV] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[DATMOV] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[QTAMOV] [numeric] (19,4) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SITORDQTAMOV] WITH NOCHECK ADD 
	CONSTRAINT [PK_SITORDQTAMOV] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
