if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_PRO_AL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_PRO_AL]
GO
 
CREATE TABLE [dbo].[U_PRO_AL] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[ALT_FINUDO] [numeric] (5,0) NULL ,
	[ALT_FISPDA] [numeric] (5,0) NULL ,
	[ALT_FISPAL] [numeric] (5,0) NULL ,
	[ALT_CILGOM] [numeric] (5,0) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_PRO_AL] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_PRO_AL] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_PRO_AL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRO_AL_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_PRO_AL_ALT_FINUDO] DEFAULT (0) FOR [ALT_FINUDO],
	CONSTRAINT [DF_U_PRO_AL_ALT_FISPDA] DEFAULT (0) FOR [ALT_FISPDA],
	CONSTRAINT [DF_U_PRO_AL_ALT_FISPAL] DEFAULT (0) FOR [ALT_FISPAL],
	CONSTRAINT [DF_U_PRO_AL_ALT_CILGOM] DEFAULT (0) FOR [ALT_CILGOM]
GO

