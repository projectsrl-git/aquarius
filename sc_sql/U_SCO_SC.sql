if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_SCO_DD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_SCO_DD]
GO
 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_SCO_SC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_SCO_SC]
GO

CREATE TABLE [dbo].[U_SCO_SC] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_U_SCO_SC_id_unique] DEFAULT newid(),
	[CODSCO] varchar(9) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_SCO_SC_CODSCO] DEFAULT (''),
	[DESSCO] varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_SCO_SC_DESSCO] DEFAULT (''),
	[SCONTO1] numeric(14,10) NOT NULL CONSTRAINT [DF_U_SCO_SC_SCONTO1] DEFAULT (0),
	[SCONTO2] numeric(14,10) NOT NULL CONSTRAINT [DF_U_SCO_SC_SCONTO2] DEFAULT (0),
	[SCONTO3] numeric(14,10) NOT NULL CONSTRAINT [DF_U_SCO_SC_SCONTO3] DEFAULT (0),
	[SCONTO4] numeric(14,10) NOT NULL CONSTRAINT [DF_U_SCO_SC_SCONTO4] DEFAULT (0),
	[SCONTO5] numeric(14,10) NOT NULL CONSTRAINT [DF_U_SCO_SC_SCONTO5] DEFAULT (0),
	[DTVADA] varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_SCO_SC_DTVADA] DEFAULT (''),
	[DTVAAL] varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_SCO_SC_DTVAAL] DEFAULT ('')
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_SCO_SC] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_SCO_SC] PRIMARY KEY CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
