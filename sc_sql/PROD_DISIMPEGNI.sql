if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROD_DISIMPEGNI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PROD_DISIMPEGNI]
GO

CREATE TABLE [dbo].[PROD_DISIMPEGNI] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[IDPRG] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[FASELA] [varchar] (6) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[SEQUEN] [numeric] (10,0) NOT NULL DEFAULT (0),
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[DESART] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[CODINT] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[SPESSO] [numeric] (5,0) NOT NULL DEFAULT (0),
	[ALTEZZ] [numeric] (5,0) NOT NULL DEFAULT (0),
	[LUNGHE] [numeric] (6,0) NOT NULL DEFAULT (0),
	[QTANR] [numeric] (12,0) NOT NULL DEFAULT (0),
	[QTA] [numeric] (17,4) NOT NULL DEFAULT (0),
	[UM] [varchar] (6) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[MAG_NEWUNQ] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[CODMAG] [varchar] (6) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[FILA_X] [varchar] (5) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[PIAN_X] [varchar] (5) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[UBIC_X] [varchar] (5) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[DATIMP] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[ORAIMP] [varchar] (8) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[CODOPE] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[NOMOPE] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[MAG_NEWLEG] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PROD_DISIMPEGNI] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROD_DISIMPEGNI] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
