
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOGTBL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[LOGTBL]
GO
 
CREATE TABLE [dbo].[LOGTBL] (
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
	[FieldsValues] [text] NULL ,
	[Note] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[LOGTBL] WITH NOCHECK ADD 
	CONSTRAINT [PK_LOGTBL] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LOGTBL] WITH NOCHECK ADD 
	CONSTRAINT [DF_LOGTBL_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_LOGTBL_TIMESTAMP] DEFAULT (CONVERT(VARCHAR(30), CURRENT_TIMESTAMP, 21)) FOR [TIMESTAMP],
	CONSTRAINT [DF_LOGTBL_CODOPE] DEFAULT ('') FOR [CODOPE],
	CONSTRAINT [DF_LOGTBL_NOMOPE] DEFAULT ('') FOR [NOMOPE],
	CONSTRAINT [DF_LOGTBL_WORKSTAT] DEFAULT ('') FOR [WORKSTAT],
	CONSTRAINT [DF_LOGTBL_EXECTYPE] DEFAULT ('') FOR [EXECTYPE],
	CONSTRAINT [DF_LOGTBL_CSQL] DEFAULT ('') FOR [CSQL],
	CONSTRAINT [DF_LOGTBL_CallingFormFileName] DEFAULT ('') FOR [CallingFormFileName],
	CONSTRAINT [DF_LOGTBL_MainTableName] DEFAULT ('') FOR [MainTableName],
	CONSTRAINT [DF_LOGTBL_MainTableDescr] DEFAULT ('') FOR [MainTableDescr],
	CONSTRAINT [DF_LOGTBL_FieldsValues] DEFAULT ('') FOR [FieldsValues],
	CONSTRAINT [DF_LOGTBL_Note] DEFAULT ('') FOR [Note]
GO
