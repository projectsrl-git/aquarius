if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TRATTCOM_DD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TRATTCOM_DD]
GO

CREATE TABLE [dbo].[TRATTCOM_DD] (
	[ID_UNIQUE]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DAGGANCIO]  [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[SOG_TIPSOG] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL ,
	[SOG_CODSOG] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL ,
	[SOG_DESSOG] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL ,
	[SOG_DESGEN] [ntext] COLLATE Latin1_General_CI_AS NULL ,	
	[SOG_ANNESP] [float] NULL ,
	[SOG_POSTI]  [int] NULL ,
	[D_INIZIO] 	 [nvarchar] (8) COLLATE Latin1_General_CI_AS NULL ,
	[D_FINE] 	 [nvarchar] (8) COLLATE Latin1_General_CI_AS NULL ,
	[SOG_GGPREV] [float] NULL ,
	[SOG_COSTO]  [float] NULL ,
	[SOG_RICAVO] [float] NULL ,
	[SOG_UTILE]  [float] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRATTCOM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_TRATTCOM_DD_id_unique] DEFAULT (newid()) FOR [id_unique]
GO