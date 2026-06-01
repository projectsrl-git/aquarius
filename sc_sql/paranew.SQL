if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[paranew]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[paranew]
GO
 
CREATE TABLE [dbo].[paranew] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CODICE] [varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[DESCRI] [varchar] (254) COLLATE Latin1_General_CI_AS NULL ,
	[CONCAU] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CAUSUCC] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
	[CAUSDDT] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
	[CAUSORD] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
	[TOP_COL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[paranew] WITH NOCHECK ADD 
	CONSTRAINT [PK_paranew] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[paranew] WITH NOCHECK ADD 
	CONSTRAINT [DF_paranew_id_unique] DEFAULT (newid()) FOR [id_unique]
GO

INSERT INTO PARANEW (CODICE,DESCRI,CONCAU,CAUSUCC,CAUSDDT,CAUSORD,TOP_COL)
	SELECT
		CODICE,
		DESCRI,
		SUBSTRING(LIBERA,35,3) AS CONCAU,
		SUBSTRING(LIBERA,62,3) AS CAUSUCC,
		SUBSTRING(LIBERA,65,3) AS CAUSDDT,
		SUBSTRING(LIBERA,81,3) AS CAUSORD,
		SUBSTRING(LIBERA,13,3) AS TOP_COL
	FROM PARA WHERE CODICE LIKE 'TOP%'
	AND LTRIM(RTRIM(SUBSTRING(LIBERA,35,3) + SUBSTRING(LIBERA,62,3) + SUBSTRING(LIBERA,65,3) + SUBSTRING(LIBERA,81,3) + SUBSTRING(LIBERA,13,3))) <> ''
