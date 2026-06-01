if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_ELA_ER]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_ELA_ER]
GO
 
CREATE TABLE [dbo].[U_ELA_ER] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DATA_SOLAR] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PROCEDURA]  [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[ANOMALIA]   [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[DATAERRORE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[ORAERRORE]  [varchar] (10) COLLATE Latin1_General_CI_AS NULL 


) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_ELA_ER] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_ELA_ER] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_ELA_ER] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ELA_ER_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_ELA_ER_DATA_SOLAR] DEFAULT ('') FOR [DATA_SOLAR],
	CONSTRAINT [DF_U_ELA_ER_PROCEDURA] DEFAULT ('') FOR [PROCEDURA],
	CONSTRAINT [DF_U_ELA_ER_ANOMALIA] DEFAULT ('') FOR [ANOMALIA],
	CONSTRAINT [DF_U_ELA_ER_DATAERRORE] DEFAULT ('') FOR [DATAERRORE],
	CONSTRAINT [DF_U_ELA_ER_ORAERRORE] DEFAULT ('') FOR [ORAERRORE]

GO

