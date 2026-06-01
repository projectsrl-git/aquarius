
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOGSQL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[LOGSQL]
GO
 
CREATE TABLE [dbo].[LOGSQL] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[TIMESTAMP] [varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[CODOPE] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[NOMOPE] [varchar] (25) COLLATE Latin1_General_CI_AS NULL ,
	[WORKSTAT] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[CSQL] [text] COLLATE Latin1_General_CI_AS NULL ,
	[MainTableNames] [varchar] (254) COLLATE Latin1_General_CI_AS NULL ,
	[WhereCondFields] [varchar] (254) COLLATE Latin1_General_CI_AS NULL ,
	[CallStackLevel] [numeric] (10,0) NULL ,
	[CurrentProgramFilename] [varchar] (254) COLLATE Latin1_General_CI_AS NULL ,
	[ModuleOrObjectName] [varchar] (254) COLLATE Latin1_General_CI_AS NULL ,
	[ModuleOrObjectSourceFilename] [varchar] (254) COLLATE Latin1_General_CI_AS NULL ,
	[LineNumberObjectSourceFile] [numeric] (10,0) NULL ,
	[SourceLineContents] [varchar] (254) COLLATE Latin1_General_CI_AS NULL ,
	[TIME] numeric(20,3) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[LOGSQL] WITH NOCHECK ADD 
	CONSTRAINT [PK_LOGSQL] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LOGSQL] WITH NOCHECK ADD 
	CONSTRAINT [DF_LOGSQL_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_LOGSQL_TIMESTAMP] DEFAULT (CONVERT(VARCHAR(30), CURRENT_TIMESTAMP, 21)) FOR [TIMESTAMP],
	CONSTRAINT [DF_LOGSQL_CODOPE] DEFAULT ('') FOR [CODOPE],
	CONSTRAINT [DF_LOGSQL_NOMOPE] DEFAULT ('') FOR [NOMOPE],
	CONSTRAINT [DF_LOGSQL_WORKSTAT] DEFAULT ('') FOR [WORKSTAT],
	CONSTRAINT [DF_LOGSQL_CSQL] DEFAULT ('') FOR [CSQL],
	CONSTRAINT [DF_LOGSQL_MainTableNames] DEFAULT ('') FOR [MainTableNames],
	CONSTRAINT [DF_LOGSQL_WhereCondFields] DEFAULT ('') FOR [WhereCondFields],
	CONSTRAINT [DF_LOGSQL_CallStackLevel] DEFAULT (0) FOR [CallStackLevel],
	CONSTRAINT [DF_LOGSQL_CurrentProgramFilename] DEFAULT ('') FOR [CurrentProgramFilename],
	CONSTRAINT [DF_LOGSQL_ModuleOrObjectName] DEFAULT ('') FOR [ModuleOrObjectName],
	CONSTRAINT [DF_LOGSQL_ModuleOrObjectSourceFilename] DEFAULT ('') FOR [ModuleOrObjectSourceFilename],
	CONSTRAINT [DF_LOGSQL_LineNumberObjectSourceFile] DEFAULT (0) FOR [LineNumberObjectSourceFile],
	CONSTRAINT [DF_LOGSQL_SourceLineContents] DEFAULT ('') FOR [SourceLineContents],
	CONSTRAINT [DF_LOGSQL_TIME] DEFAULT (0) FOR [TIME]
GO
