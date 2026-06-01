
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROD_PIANIF_OF]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PROD_PIANIF_OF]
GO
 
CREATE TABLE [dbo].[PROD_PIANIF_OF] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[IDPIANIF] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[SELEZI] [bit] NOT NULL DEFAULT 0,
	[DESART] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[SPESSO] numeric(5,0) NOT NULL DEFAULT 0,
	[ALTEZZ] numeric(6,0) NOT NULL DEFAULT 0,
	[LUNGHE] numeric(7,0) NOT NULL DEFAULT 0,
	[NUMBOB] numeric(10,0) NOT NULL DEFAULT 0,
	[UNIMIS] [varchar] (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[P1] numeric(19,4) NOT NULL DEFAULT 0,
	[P2] numeric(19,4) NOT NULL DEFAULT 0,
	[P3] numeric(19,4) NOT NULL DEFAULT 0,
	[P4] numeric(19,4) NOT NULL DEFAULT 0,
	[P5] numeric(19,4) NOT NULL DEFAULT 0,
	[P6] numeric(19,4) NOT NULL DEFAULT 0,
	[Q1] numeric(19,4) NOT NULL DEFAULT 0,
	[Q2] numeric(19,4) NOT NULL DEFAULT 0,
	[Q3] numeric(19,4) NOT NULL DEFAULT 0,
	[Q4] numeric(19,4) NOT NULL DEFAULT 0,
	[Q5] numeric(19,4) NOT NULL DEFAULT 0,
	[Q6] numeric(19,4) NOT NULL DEFAULT 0,
	[D1] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[D2] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[D3] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[D4] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[D5] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[D6] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODFOR] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[RAGSOC] [varchar] (80) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[PREZZO] numeric(19,6) NOT NULL DEFAULT 0,
	[VALORE] numeric(19,2) NOT NULL DEFAULT 0,
	[VALUTA] [varchar] (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DTORPR] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[UPDART] [bit] NOT NULL DEFAULT 0,
	[CPA] [varchar] (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[IVA] [varchar] (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[ACURA] [varchar] (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[PORTO] [varchar] (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[SCADENZE] text COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[AGGORF] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[NUMORF] [varchar] (6) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DATORF] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODOPE] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[NOMOPE] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DATMOD] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[ORAMOD] [varchar] (8) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ''
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PROD_PIANIF_OF] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROD_PIANIF_OF] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
