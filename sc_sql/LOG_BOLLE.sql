if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOG_BOLLE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[LOG_BOLLE]
GO
 
CREATE TABLE [dbo].[LOG_BOLLE] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	log_tipdoc varchar(03) COLLATE Latin1_General_CI_AS NULL ,
	log_numbol varchar(06) COLLATE Latin1_General_CI_AS NULL ,
	log_datbol varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	log_codcli varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	log_ragsoc varchar(80) COLLATE Latin1_General_CI_AS NULL ,
	log_nrgart numeric(10,0) NULL ,
	log_totqta numeric(17,2) NULL ,
	log_nrgcom numeric(10,0) NULL ,
	log_tiplog varchar(03) COLLATE Latin1_General_CI_AS NULL ,
	log_datlog varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	log_oralog varchar(08) COLLATE Latin1_General_CI_AS NULL ,
	log_codope varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	log_nomope varchar(50) COLLATE Latin1_General_CI_AS NULL ,
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[LOG_BOLLE] WITH NOCHECK ADD 
	CONSTRAINT [PK_LOG_BOLLE] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LOG_BOLLE] WITH NOCHECK ADD 
	CONSTRAINT [DF_LOG_BOLLE_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_LOG_BOLLE_log_tipdoc] DEFAULT ('') FOR [log_tipdoc],
	CONSTRAINT [DF_LOG_BOLLE_log_numbol] DEFAULT ('') FOR [log_numbol],
	CONSTRAINT [DF_LOG_BOLLE_log_datbol] DEFAULT ('') FOR [log_datbol],
	CONSTRAINT [DF_LOG_BOLLE_log_codcli] DEFAULT ('') FOR [log_codcli],
	CONSTRAINT [DF_LOG_BOLLE_log_ragsoc] DEFAULT ('') FOR [log_ragsoc],
	CONSTRAINT [DF_LOG_BOLLE_log_nrgart] DEFAULT (0) FOR [log_nrgart],
	CONSTRAINT [DF_LOG_BOLLE_log_totqta] DEFAULT (0) FOR [log_totqta],
	CONSTRAINT [DF_LOG_BOLLE_log_nrgcom] DEFAULT (0) FOR [log_nrgcom],
	CONSTRAINT [DF_LOG_BOLLE_log_tiplog] DEFAULT ('') FOR [log_tiplog],
	CONSTRAINT [DF_LOG_BOLLE_log_datlog] DEFAULT ('') FOR [log_datlog],
	CONSTRAINT [DF_LOG_BOLLE_log_oralog] DEFAULT ('') FOR [log_oralog],
	CONSTRAINT [DF_LOG_BOLLE_log_codope] DEFAULT ('') FOR [log_codope],
	CONSTRAINT [DF_LOG_BOLLE_log_nomope] DEFAULT ('') FOR [log_nomope]
GO

