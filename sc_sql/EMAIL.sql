    
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EMAIL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[EMAIL]
GO
 
CREATE TABLE [dbo].[EMAIL] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[ID_EMAIL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[SYS_EMAIL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[EMAIL] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
	[PER]  BIT NULL ,
	[CC]  BIT NULL ,
	[CCN]  BIT NULL, 
	[SELEZIONE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL

) ON [PRIMARY]   
GO


ALTER TABLE [dbo].[EMAIL] WITH NOCHECK ADD 
	CONSTRAINT [DF_EMAIL_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_EMAIL_ID_EMAIL] DEFAULT ('') FOR [ID_EMAIL],
	CONSTRAINT [DF_EMAIL_SYS_EMAIL] DEFAULT ('') FOR [SYS_EMAIL],
	CONSTRAINT [DF_EMAIL_EMAIL] DEFAULT ('') FOR [EMAIL],
	CONSTRAINT [DF_EMAIL_PER] DEFAULT (0) FOR [PER],
	CONSTRAINT [DF_EMAIL_CC] DEFAULT (0) FOR [CC],
	CONSTRAINT [DF_EMAIL_CCN] DEFAULT (0) FOR [CCN],
	CONSTRAINT [DF_EMAIL_SELEZIONE] DEFAULT ('') FOR [SELEZIONE]
GO

