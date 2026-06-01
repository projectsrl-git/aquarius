
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROD_PIANIF_DD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PROD_PIANIF_DD]
GO
 
CREATE TABLE [dbo].[PROD_PIANIF_DD] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[IDPIANIF] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[MAIN] bit NOT NULL DEFAULT 0,
	[TIPO] [varchar] (1) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DESART] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[SPESSO] numeric(5,0) NOT NULL DEFAULT 0,
	[ALTEZZ] numeric(6,0) NOT NULL DEFAULT 0,
	[LUNGHE] numeric(7,0) NOT NULL DEFAULT 0,
	[NUMBOB] numeric(10,0) NOT NULL DEFAULT 0,
	[UMMAGA] [varchar] (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[P1] numeric(19,4) NOT NULL DEFAULT 0,
	[P2] numeric(19,4) NOT NULL DEFAULT 0,
	[P3] numeric(19,4) NOT NULL DEFAULT 0,
	[P4] numeric(19,4) NOT NULL DEFAULT 0,
	[P5] numeric(19,4) NOT NULL DEFAULT 0,
	[P6] numeric(19,4) NOT NULL DEFAULT 0,
	[A1] numeric(19,4) NOT NULL DEFAULT 0,
	[A2] numeric(19,4) NOT NULL DEFAULT 0,
	[A3] numeric(19,4) NOT NULL DEFAULT 0,
	[A4] numeric(19,4) NOT NULL DEFAULT 0,
	[A5] numeric(19,4) NOT NULL DEFAULT 0,
	[A6] numeric(19,4) NOT NULL DEFAULT 0,
	[QTANEC] numeric(19,4) NOT NULL DEFAULT 0,
	[QTADISP] numeric(19,4) NOT NULL DEFAULT 0,
	[QTAROC] numeric(19,4) NOT NULL DEFAULT 0,
	[QTAINPR] numeric(19,4) NOT NULL DEFAULT 0,
	[QTADAPO] numeric(19,4) NOT NULL DEFAULT 0,
	[QTAORF] numeric(19,4) NOT NULL DEFAULT 0,
	[DT1CON] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[FO1CON] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[LEADTIME] numeric(4,0) NOT NULL DEFAULT 0,
	[SYSUNQ] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[ISGROUP] bit NOT NULL DEFAULT 0,
	[EXPLODED] bit NOT NULL DEFAULT 0,
	[VISIBLE] bit NOT NULL DEFAULT 0,
	[FASELA] varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DESFASELA] varchar (200) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[FORMATO] varchar (200) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[TIPART] varchar (1) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[NUMBOBDAPO] numeric(10,0) NOT NULL DEFAULT 0,
	[SYSORDINI] varchar (254) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[SELEZISAVE] bit NOT NULL DEFAULT 0,
	[PERIODSAVE] numeric(19,4) NOT NULL DEFAULT 0,
	[QTDAPRSAVE] numeric(19,4) NOT NULL DEFAULT 0,
	[DTINPRSAVE] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ''
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PROD_PIANIF_DD] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROD_PIANIF_DD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
