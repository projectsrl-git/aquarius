if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOG_PCKLST]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[LOG_PCKLST]
GO
 
CREATE TABLE [dbo].[LOG_PCKLST] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	log_numpck varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	log_datpck varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	log_codcli varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	log_ragsoc varchar(80) COLLATE Latin1_General_CI_AS NULL ,
	log_nrgart numeric(10,0) NULL ,
	log_totqta numeric(17,2) NULL ,
	log_tiplog varchar(03) COLLATE Latin1_General_CI_AS NULL ,
	log_datlog varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	log_oralog varchar(08) COLLATE Latin1_General_CI_AS NULL ,
	log_codope varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	log_nomope varchar(50) COLLATE Latin1_General_CI_AS NULL ,
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[LOG_PCKLST] WITH NOCHECK ADD 
	CONSTRAINT [PK_LOG_PCKLST] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LOG_PCKLST] WITH NOCHECK ADD 
	CONSTRAINT [DF_LOG_PCKLST_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_LOG_PCKLST_log_numpck] DEFAULT ('') FOR [log_numpck],
	CONSTRAINT [DF_LOG_PCKLST_log_datpck] DEFAULT ('') FOR [log_datpck],
	CONSTRAINT [DF_LOG_PCKLST_log_codcli] DEFAULT ('') FOR [log_codcli],
	CONSTRAINT [DF_LOG_PCKLST_log_ragsoc] DEFAULT ('') FOR [log_ragsoc],
	CONSTRAINT [DF_LOG_PCKLST_log_nrgart] DEFAULT (0) FOR [log_nrgart],
	CONSTRAINT [DF_LOG_PCKLST_log_totqta] DEFAULT (0) FOR [log_totqta],
	CONSTRAINT [DF_LOG_PCKLST_log_tiplog] DEFAULT ('') FOR [log_tiplog],
	CONSTRAINT [DF_LOG_PCKLST_log_datlog] DEFAULT ('') FOR [log_datlog],
	CONSTRAINT [DF_LOG_PCKLST_log_oralog] DEFAULT ('') FOR [log_oralog],
	CONSTRAINT [DF_LOG_PCKLST_log_codope] DEFAULT ('') FOR [log_codope],
	CONSTRAINT [DF_LOG_PCKLST_log_nomope] DEFAULT ('') FOR [log_nomope]
GO

