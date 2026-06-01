if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_PDV_CN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_PDV_CN]
GO

CREATE TABLE [dbo].[U_PDV_CN] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CAS_NUMAGG] [numeric](3) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_PDV_CN] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_PDV_PN] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_PDV_CN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CN_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_PDV_CN_CAS_NUMAGG] DEFAULT (0) FOR [CAS_NUMAGG]
GO

