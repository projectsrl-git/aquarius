if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_REG_FA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_REG_FA]
GO
 
CREATE TABLE [dbo].[U_REG_FA] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	CodArt_R varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	DesArt_R varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	CodArt_A varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	DesArt_A varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	CodArt_P varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	DesArt_P varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	CodArt_S varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	DesArt_S varchar(50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_REG_FA] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_REG_FA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_REG_FA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_REG_FA_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_REG_FA_CodArt_R] DEFAULT ('') FOR [CodArt_R],
	CONSTRAINT [DF_U_REG_FA_DesArt_R] DEFAULT ('') FOR [DesArt_R],
	CONSTRAINT [DF_U_REG_FA_CodArt_A] DEFAULT ('') FOR [CodArt_A],
	CONSTRAINT [DF_U_REG_FA_DesArt_A] DEFAULT ('') FOR [DesArt_A],
	CONSTRAINT [DF_U_REG_FA_CodArt_P] DEFAULT ('') FOR [CodArt_P],
	CONSTRAINT [DF_U_REG_FA_DesArt_P] DEFAULT ('') FOR [DesArt_P],
	CONSTRAINT [DF_U_REG_FA_CodArt_S] DEFAULT ('') FOR [CodArt_S],
	CONSTRAINT [DF_U_REG_FA_DesArt_S] DEFAULT ('') FOR [DesArt_S]
GO

