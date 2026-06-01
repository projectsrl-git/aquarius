
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BLACKBOX]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[BLACKBOX]
GO
 
CREATE TABLE [dbo].[BLACKBOX] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[TIMESTAMP] [varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[CODOPE] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[NOMOPE] [varchar] (25) COLLATE Latin1_General_CI_AS NULL ,
	[WORKSTAT] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[EXECTYPE] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[CSQL] [text] COLLATE Latin1_General_CI_AS NULL ,
	[CallingFormFileName] [varchar] (254) COLLATE Latin1_General_CI_AS NULL ,
	[MainTableName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[MainTableDescr] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[WhereCondKey] [text] NULL ,
	[PrevFieldsValues] [text] NULL ,
	[FieldsValues] [text] NULL ,
	[Note] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BLACKBOX] WITH NOCHECK ADD 
	CONSTRAINT [PK_BLACKBOX] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BLACKBOX] WITH NOCHECK ADD 
	CONSTRAINT [DF_BLACKBOX_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_BLACKBOX_TIMESTAMP] DEFAULT (CONVERT(VARCHAR(30), CURRENT_TIMESTAMP, 21)) FOR [TIMESTAMP],
	CONSTRAINT [DF_BLACKBOX_CODOPE] DEFAULT ('') FOR [CODOPE],
	CONSTRAINT [DF_BLACKBOX_NOMOPE] DEFAULT ('') FOR [NOMOPE],
	CONSTRAINT [DF_BLACKBOX_WORKSTAT] DEFAULT ('') FOR [WORKSTAT],
	CONSTRAINT [DF_BLACKBOX_EXECTYPE] DEFAULT ('') FOR [EXECTYPE],
	CONSTRAINT [DF_BLACKBOX_CSQL] DEFAULT ('') FOR [CSQL],
	CONSTRAINT [DF_BLACKBOX_CallingFormFileName] DEFAULT ('') FOR [CallingFormFileName],
	CONSTRAINT [DF_BLACKBOX_MainTableName] DEFAULT ('') FOR [MainTableName],
	CONSTRAINT [DF_BLACKBOX_MainTableDescr] DEFAULT ('') FOR [MainTableDescr],
	CONSTRAINT [DF_BLACKBOX_WhereCondKey] DEFAULT ('') FOR [WhereCondKey],
	CONSTRAINT [DF_BLACKBOX_PrevFieldsValues] DEFAULT ('') FOR [PrevFieldsValues],
	CONSTRAINT [DF_BLACKBOX_FieldsValues] DEFAULT ('') FOR [FieldsValues],
	CONSTRAINT [DF_BLACKBOX_Note] DEFAULT ('') FOR [Note]
GO
